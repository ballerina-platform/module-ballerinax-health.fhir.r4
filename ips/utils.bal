// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
import ballerina/log;
import ballerina/regex;
import ballerina/time;
import ballerina/uuid;
import ballerinax/health.clients.fhir;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;

# Generate an IPS (International Patient Summary) Bundle using the provided IPS Context.
#
# + patientId - The ID of the patient for whom the IPS Bundle is being generated.
# + context - The IPSContext containing all necessary data to construct the IPS Bundle.
# + return - The constructed FHIR R4 Bundle or an error if generation fails.
public isolated function generateIps(string patientId, IPSContext context) returns r4:Bundle|error {
    r4:Resource[] ipsBundleResources = [];

    // 1. Prepare the Composition resource (sections will be filled below)
    CompositionUvIps composition = {
        status: <CompositionUvIpsStatus>ips_composition_status,
        subject: {
            reference: "Patient/" + patientId
        },
        date: time:utcToString(time:utcNow()),
        author: getIpsAuthorReferences(),
        custodian: getIpsCustodianReference(),
        attester: getIpsAttesters(),
        section: [],
        title: ips_composition_title,
        'type: {
            coding: [
                {
                    system: LOINC_SYSTEM,
                    code: IPS_SECTION_CODE,
                    display: IPS_SECTION_DISPLAY
                }
            ]
        }
    };

    // 2. Fetch the Patient resource
    log:printDebug("Fetching Patient resource for patientId: " + patientId);
    fhir:FHIRConnector patientClient = check context.getFHIRClient(international401:RESOURCE_NAME_PATIENT);
    fhir:FHIRResponse patientResp = check patientClient->getById(international401:RESOURCE_NAME_PATIENT, patientId);
    if patientResp.httpStatusCode != 200 {
        log:printDebug("Failed to fetch Patient resource for patientId: " + patientId + ", status code: " + patientResp.httpStatusCode.toString());
        return error("Failed to fetch Patient resource for given patientId: " + patientId);
    }
    if patientResp.'resource !is json {
        log:printDebug("Invalid response format for Patient resource, expected JSON.");
        return error("Invalid response format for Patient resource, expected JSON.");
    }
    r4:Resource patientResource = check patientResp.'resource.cloneWithType();

    // 3. Add the resource to the entries
    // 3.1 For each IPS section, use context.getSectionConfigs() and fetch resources using section configs
    r4:code[] sectionCodes = [];
    SectionConfig[] sectionConfigs = context.getSectionConfigs();
    foreach SectionConfig sectionConfig in sectionConfigs {
        // Use LOINC code map for section code/display if available
        Coding|error sectionCoding = getSectionCoding(sectionConfig.sectionName);
        if sectionCoding is error {
            log:printWarn("No LOINC code found for section: " + sectionConfig.sectionName + ", using default title as display.");
            continue;
        }

        r4:Reference[] sectionRefs = [];
        string divContent = "";

        // find the section resources from the section config
        foreach SectionResourceConfig resourceConfig in sectionConfig.resources {
            string resourceType = resourceConfig.resourceType;

            // get the search parameters to search the resources
            map<string[]> searchParams = {};
            if resourceConfig.searchParams is map<string> {
                foreach var [k, v] in (<map<string>>resourceConfig.searchParams).entries() {
                    searchParams[k] = [v];
                }
            }
            // add the patient id as a search parameter
            searchParams[resourceConfig.patientParam] = [patientId];

            // get the fhir client and fetch resources
            fhir:FHIRConnector|error clientVal = context.getFHIRClient(resourceType);
            if clientVal is fhir:FHIRConnector {
                // request the resources by searching with the search parameters
                log:printDebug("Fetching resources of type: " + resourceType);
                fhir:FHIRResponse resp = check clientVal->search(resourceType, searchParams);
                if resp.httpStatusCode != 200 {
                    log:printDebug("Failed to fetch resources of type: " + resourceType + ", status code: " + resp.httpStatusCode.toString());
                    continue;
                }

                // check if the response contains resources
                r4:Bundle responseBundle = check resp.'resource.cloneWithType();
                r4:BundleEntry[]? bundleEntryArr = responseBundle.entry;
                if bundleEntryArr is () {
                    log:printDebug("No entries found for resource type: " + resourceType);
                    continue;
                }
                foreach r4:BundleEntry entry in bundleEntryArr {
                    r4:Resource|error bundleEntryResource = entry["resource"].cloneWithType();
                    if bundleEntryResource is r4:Resource {
                        string summary = "";

                        // get the ID and summary from the resource JSON
                        string? id = bundleEntryResource.id;

                        log:printDebug("Processing resource of type: " + resourceType);

                        summary = extractSectionNarrativeSummary(bundleEntryResource);
                        if summary != "" {
                            divContent += summary + ", ";
                        }
                        if id is string {
                            // Add reference to section entry of the composition
                            sectionRefs.push({reference: resourceType + "/" + id});
                        }

                        // add the resource to the bundle entries
                        ipsBundleResources = addIfNotDuplicate(bundleEntryResource, ipsBundleResources);
                    } else {
                        log:printDebug("Bundle entry resource is not JSON for resource type: " + resourceType);
                    }
                }
            } else {
                log:printDebug("Failed to get client for resource type: " + resourceType);
                continue;
            }
        }

        // Add section to Composition if any references found or if section is required by IPS
        if sectionRefs.length() > 0 {
            // Clean up divContent (remove trailing comma/space)
            if divContent.endsWith(", ") {
                divContent = divContent.substring(0, divContent.length() - 2);
            }
            string divHtml = string `<div xmlns=\"http://www.w3.org/1999/xhtml\">${divContent != "" ? divContent : "No information available."}</div>`;

            // ad the section to the Composition
            CompositionUvIpsSection compSection = {
                code: {coding: [{system: LOINC_SYSTEM, code: sectionCoding.code, display: sectionCoding.display}]},
                title: sectionConfig.sectionTitle,
                text: {status: "generated", div: divHtml},
                entry: sectionRefs
            };
            composition.section.push(compSection);
            sectionCodes.push(sectionCoding.code);
        }
    }
    // Check whether all required sections are present in the composition
    foreach r4:code requiredCode in REQUIRED_SECTION_CODES {
        if !(sectionCodes.indexOf(requiredCode) >= 0) {
            log:printDebug("Required section with code: " + requiredCode + " is missing from the composition.");
            return error("Required section with code: " + requiredCode + " is missing from the composition.");
        }
    }

    // 3.2 Add the resources in the composition author and custodian if they are not already present
    foreach r4:Reference authorReference in composition.author {
        if authorReference.reference is string {
            r4:Resource? authorResource = fetchAndAddReferencedResource(<string>authorReference.reference, context);
            if authorResource is r4:Resource {
                // entries.push(authorEntry);
                ipsBundleResources = addIfNotDuplicate(authorResource, ipsBundleResources);
            }
        }
    }
    // Add the custodian reference if not already present
    if composition.custodian is r4:Reference {
        if custodian is string {
            r4:Resource? custodianResource = fetchAndAddReferencedResource(custodian, context);
            if custodianResource is r4:Resource {
                ipsBundleResources = addIfNotDuplicate(custodianResource, ipsBundleResources);
            }
        }
    }

    // 4. Add the Composition as the first entry, Patient as the second
    r4:BundleEntry[] finalEntries = [];
    finalEntries.push(getBundleEntry(composition)); // Composition entry
    finalEntries.push(mapFhirResourceToIpsEntry(patientResource, patientId)); // Patient entry
    foreach r4:BundleEntry entry in mapFhirResourcesToIpsEntryArr(ipsBundleResources, patientId) {
        finalEntries.push(entry);
    }

    // 5. Create the IPS Bundle at the end
    r4:Bundle ipsBundle = {'type: r4:BUNDLE_TYPE_DOCUMENT, entry: finalEntries};
    return ipsBundle;
}

# Construct the IPS Bundle from the given IPS Bundle data.
#
# + bundleData - IPS Bundle data as in standard FHIR Bundle or IPS Bundle data holder.
# + return - Constructed IPS Bundle.
public isolated function getIpsBundle(r4:Bundle|IpsBundleData bundleData) returns r4:Bundle|error {
    if bundleData is r4:Bundle {
        return constructIpsBundleFromR4Bundle(<r4:Bundle>bundleData);
    } else if bundleData is IpsBundleData {
        r4:Bundle bundle = {'type: "document"};
        r4:BundleEntry[] entries = [];
        entries.push(getBundleEntry(bundleData.composition));
        entries.push(getBundleEntry(bundleData.patient));
        if (bundleData.allergyIntolerance is AllergyIntoleranceUvIps[]) {
            foreach var allergyIntolerance in <AllergyIntoleranceUvIps[]>bundleData.allergyIntolerance {
                entries.push(getBundleEntry(allergyIntolerance));
            }
        }
        if (bundleData.condition is ConditionUvIps[]) {
            foreach var condition in <ConditionUvIps[]>bundleData.condition {
                entries.push(getBundleEntry(condition));
            }
        }
        if (bundleData.device is DeviceUvIps[]) {
            foreach var device in <DeviceUvIps[]>bundleData.device {
                entries.push(getBundleEntry(device));
            }
        }
        if (bundleData.deviceUseStatement is DeviceUseStatementUvIps[]) {
            foreach var deviceUseStatement in <DeviceUseStatementUvIps[]>bundleData.deviceUseStatement {
                entries.push(getBundleEntry(deviceUseStatement));
            }
        }
        if (bundleData.diagnosticReport is DiagnosticReportUvIps[]) {
            foreach var diagnosticReport in <DiagnosticReportUvIps[]>bundleData.diagnosticReport {
                entries.push(getBundleEntry(diagnosticReport));
            }
        }
        if (bundleData.imagingStudy is ImagingStudyUvIps[]) {
            foreach var imagingStudy in <ImagingStudyUvIps[]>bundleData.imagingStudy {
                entries.push(getBundleEntry(imagingStudy));
            }
        }
        if (bundleData.immunization is ImmunizationUvIps[]) {
            foreach var immunization in <ImmunizationUvIps[]>bundleData.immunization {
                entries.push(getBundleEntry(immunization));
            }
        }
        if (bundleData.mediaObservation is MediaObservationUvIps[]) {
            foreach var mediaObservation in <MediaObservationUvIps[]>bundleData.mediaObservation {
                entries.push(getBundleEntry(mediaObservation));
            }
        }
        if (bundleData.medication is MedicationIPS[]) {
            foreach var medication in <MedicationIPS[]>bundleData.medication {
                entries.push(getBundleEntry(medication));
            }
        }
        if (bundleData.medicationRequest is MedicationRequestIPS[]) {
            foreach var medicationRequest in <MedicationRequestIPS[]>bundleData.medicationRequest {
                entries.push(getBundleEntry(medicationRequest));
            }
        }
        if (bundleData.medicationStatement is MedicationStatementIPS[]) {
            foreach var medicationStatement in <MedicationStatementIPS[]>bundleData.medicationStatement {
                entries.push(getBundleEntry(medicationStatement));
            }
        }
        if (bundleData.practitioner is PractitionerUvIps[]) {
            foreach var practitioner in <PractitionerUvIps[]>bundleData.practitioner {
                entries.push(getBundleEntry(practitioner));
            }
        }
        if (bundleData.practitionerRole is PractitionerRoleUvIps[]) {
            foreach var practitionerRole in <PractitionerRoleUvIps[]>bundleData.practitionerRole {
                entries.push(getBundleEntry(practitionerRole));
            }
        }
        if (bundleData.procedure is ProcedureUvIps[]) {
            foreach var procedure in <ProcedureUvIps[]>bundleData.procedure {
                entries.push(getBundleEntry(procedure));
            }
        }
        if (bundleData.organization is OrganizationUvIps[]) {
            foreach var organization in <OrganizationUvIps[]>bundleData.organization {
                entries.push(getBundleEntry(organization));
            }
        }
        if (bundleData.observationPregnancyEdd is ObservationPregnancyEddUvIps[]) {
            foreach var observationPregnancyEdd in <ObservationPregnancyEddUvIps[]>bundleData.observationPregnancyEdd {
                entries.push(getBundleEntry(observationPregnancyEdd));
            }
        }
        if (bundleData.observationPregnancyOutcome is ObservationPregnancyOutcomeUvIps[]) {
            foreach var observationPregnancyOutcome in <ObservationPregnancyOutcomeUvIps[]>bundleData.observationPregnancyOutcome {
                entries.push(getBundleEntry(observationPregnancyOutcome));
            }
        }
        if (bundleData.observationPregnancyStatus is ObservationPregnancyStatusUvIps[]) {
            foreach var observationPregnancyStatus in <ObservationPregnancyStatusUvIps[]>bundleData.observationPregnancyStatus {
                entries.push(getBundleEntry(observationPregnancyStatus));
            }
        }
        if (bundleData.observationAlcoholUse is ObservationAlcoholUseUvIps[]) {
            foreach var observationAlcoholUse in <ObservationAlcoholUseUvIps[]>bundleData.observationAlcoholUse {
                entries.push(getBundleEntry(observationAlcoholUse));
            }
        }
        if (bundleData.observationTobaccoUse is ObservationTobaccoUseUvIps[]) {
            foreach var observationTobaccoUse in <ObservationTobaccoUseUvIps[]>bundleData.observationTobaccoUse {
                entries.push(getBundleEntry(observationTobaccoUse));
            }
        }
        if (bundleData.observationResults is ObservationResultsUvIps[]) {
            foreach var observationResults in <ObservationResultsUvIps[]>bundleData.observationResults {
                entries.push(getBundleEntry(observationResults));
            }
        }
        if (bundleData.specimen is SpecimenUvIps[]) {
            foreach var specimen in <SpecimenUvIps[]>bundleData.specimen {
                entries.push(getBundleEntry(specimen));
            }
        }
        bundle.entry = entries;
        return bundle;
    }
    return error("Invalid IPS Bundle data");
}

isolated function constructIpsBundleFromR4Bundle(r4:Bundle fhirBundle) returns r4:Bundle|error {
    r4:Bundle ipsBundle = {
        'type: "document",
        timestamp: fhirBundle.timestamp ?: time:utcToString(time:utcNow()),
        identifier: fhirBundle.identifier ?: {system: ips_bundle_identifier_system, value: uuid:createRandomUuid()}
    };
    r4:BundleEntry[] entries = fhirBundle.entry ?: [];
    string patientId = "";
    if entries.length() == 0 {
        return error("No resources found in the bundle");
    }

    //problems section
    CompositionUvIpsSection problemsSection = {
        code: {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "11450-4",
                    display: "Problem list - Reported"
                }
            ]
        },
        text: {status: "generated", div: ""},
        title: ips_composition_problem_section_title
    };
    //medication section
    CompositionUvIpsSection medicationSection = {
        code: {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "10160-0",
                    display: "History of Medication use Narrative"
                }
            ]
        },
        text: {status: "generated", div: ""},
        title: ips_composition_medication_section_title
    };
    //allergy section
    CompositionUvIpsSection allergySection = {
        code: {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "48765-2",
                    display: "Allergies and adverse reactions Document"
                }
            ]
        },
        text: {status: "generated", div: ""},
        title: ips_composition_allergy_section_title
    };
    //immunization section
    CompositionUvIpsSection immunizationSection = {
        code: {coding: [{system: "http://loinc.org", code: "11369-6", display: "Immunizations"}]},
        title: ips_composition_immunization_section_title,
        text: {status: "generated", div: ""}
    };
    //procedure section
    CompositionUvIpsSection procedureSection = {
        code: {coding: [{system: "http://loinc.org", code: "47519-4", display: "Procedures"}]},
        title: ips_composition_procedure_section_title,
        text: {status: "generated", div: ""}
    };
    //diagnostic report section
    CompositionUvIpsSection diagnosticReportSection = {
        code: {coding: [{system: "http://loinc.org", code: "30954-2", display: "Diagnostic Reports"}]},
        title: ips_composition_diagnostic_report_section_title,
        text: {status: "generated", div: ""}
    };

    //composition resource
    CompositionUvIps composition = {
        status: <CompositionUvIpsStatus>ips_composition_status,
        subject: {reference: ""},
        date: ipsBundle.timestamp ?: time:utcToString(time:utcNow()),
        author: [],
        section: [allergySection, problemsSection, medicationSection],
        title: ips_composition_title,
        'type: {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "60591-5",
                    display: "Patient summary Document"
                }
            ]
        }
    };
    r4:BundleEntry[] ipsEntries = [];
    ipsEntries.push(getBundleEntry(composition));
    foreach var entry in entries {
        json|error resourceType = entry?.'resource.toJson().resourceType;
        if resourceType is error {
            return error("Error occurred while extracting resource type from the entry");
        }
        match resourceType {
            "Patient" => {
                international401:Patient patient = check entry?.'resource.cloneWithType();
                PatientUvIps ipsPatient = mapPatientToIpsPatient(patient);
                patientId = <string>ipsPatient.id;
                ipsEntries.push(getBundleEntry(ipsPatient));
            }
            "AllergyIntolerance" => {
                international401:AllergyIntolerance allergyIntolerance = check entry?.'resource.cloneWithType();
                AllergyIntoleranceUvIps ipsAllergyIntolerance = mapAllergyIntoleranceToIpsAllergyIntolerance(allergyIntolerance, patientId);
                string id = ipsAllergyIntolerance.id ?: uuid:createRandomUuid();
                ipsAllergyIntolerance.id = id;
                ipsEntries.push(getBundleEntry(ipsAllergyIntolerance));
                r4:Reference[] sectionReferences = allergySection.entry ?: [];
                sectionReferences.push({reference: string `AllergyIntolerance/${id}`});
                allergySection.entry = sectionReferences;
            }
            "Condition" => {
                international401:Condition condition = check entry?.'resource.cloneWithType();
                ConditionUvIps ipsCondition = mapConditionToIpsCondition(condition, patientId);
                string id = ipsCondition.id ?: uuid:createRandomUuid();
                ipsCondition.id = id;
                ipsEntries.push(getBundleEntry(ipsCondition));
                r4:Reference[] sectionReferences = problemsSection.entry ?: [];
                sectionReferences.push({reference: string `Condition/${id}`});
                problemsSection.entry = sectionReferences;
            }
            "MedicationRequest" => {
                international401:MedicationRequest medicationRequest = check entry?.'resource.cloneWithType();
                MedicationRequestIPS ipsMedicationRequest = check mapMedicationRequestToIpsMedicationRequest(medicationRequest, patientId);
                string id = ipsMedicationRequest.id ?: uuid:createRandomUuid();
                ipsMedicationRequest.id = id;
                ipsEntries.push(getBundleEntry(ipsMedicationRequest));
                r4:Reference[] sectionReferences = medicationSection.entry ?: [];
                sectionReferences.push({reference: string `MedicationRequest/${id}`});
                medicationSection.entry = sectionReferences;
            }
            "Medication" => {
                international401:Medication medication = check entry?.'resource.cloneWithType();
                MedicationIPS ipsMedication = mapMedicationToIpsMedication(medication, patientId);
                string id = ipsMedication.id ?: uuid:createRandomUuid();
                ipsMedication.id = id;
                ipsEntries.push(getBundleEntry(ipsMedication));
                r4:Reference[] sectionReferences = medicationSection.entry ?: [];
                sectionReferences.push({reference: string `Medication/${id}`});
                medicationSection.entry = sectionReferences;
            }
            "MedicationStatement" => {
                international401:MedicationStatement medicationStatement = check entry?.'resource.cloneWithType();
                MedicationStatementIPS ipsMedicationStatement = mapMedicationStatementToIpsMedicationStatement(medicationStatement, patientId);
                string id = ipsMedicationStatement.id ?: uuid:createRandomUuid();
                ipsMedicationStatement.id = id;
                ipsEntries.push(getBundleEntry(ipsMedicationStatement));
                r4:Reference[] sectionReferences = medicationSection.entry ?: [];
                sectionReferences.push({reference: string `MedicationStatement/${id}`});
                medicationSection.entry = sectionReferences;
            }
            "Immunization" => {
                international401:Immunization immunization = check entry?.'resource.cloneWithType();
                ImmunizationUvIps ipsImmunization = mapImmunizationToIpsImmunization(immunization, patientId);
                string id = ipsImmunization.id ?: uuid:createRandomUuid();
                ipsImmunization.id = id;
                ipsEntries.push(getBundleEntry(ipsImmunization));
                r4:Reference[] sectionReferences = immunizationSection.entry ?: [];
                sectionReferences.push({reference: string `Immunization/${id}`});
                immunizationSection.entry = sectionReferences;
            }
            "Procedure" => {
                international401:Procedure procedure = check entry?.'resource.cloneWithType();
                ProcedureUvIps ipsProcedure = mapProcedureToIpsProcedure(procedure, patientId);
                string id = ipsProcedure.id ?: uuid:createRandomUuid();
                ipsProcedure.id = id;
                ipsEntries.push(getBundleEntry(ipsProcedure));
                r4:Reference[] sectionReferences = procedureSection.entry ?: [];
                sectionReferences.push({reference: string `Procedure/${id}`});
                procedureSection.entry = sectionReferences;
            }
            "DiagnosticReport" => {
                international401:DiagnosticReport diagnosticReport = check entry?.'resource.cloneWithType();
                DiagnosticReportUvIps ipsReport = mapDiagnosticReportToIps(diagnosticReport, patientId);
                string id = ipsReport.id ?: uuid:createRandomUuid();
                ipsReport.id = id;
                ipsEntries.push(getBundleEntry(ipsReport));
                r4:Reference[] sectionReferences = diagnosticReportSection.entry ?: [];
                sectionReferences.push({reference: string `DiagnosticReport/${id}`});
                diagnosticReportSection.entry = sectionReferences;
            }
            "Observation" => {
                international401:Observation observation = check entry?.'resource.cloneWithType();
                string? observationCode = ();
                r4:CodeableConcept[]? category = observation.category;
                if category is r4:CodeableConcept[] {
                    r4:Coding[]? coding = category[0].coding;
                    if coding is r4:Coding[] {
                        observationCode = coding[0].code;
                    }
                }
                if observationCode != () && observationCode == "imaging" {
                    ObservationResultsRadiologyUvIps ipsObservation = mapObservationToIpsRadialogyObservation(observation, patientId);
                    string id = ipsObservation.id ?: uuid:createRandomUuid();
                    ipsObservation.id = id;
                    ipsEntries.push(getBundleEntry(ipsObservation));
                } else if observationCode != () && observationCode == "laboratory" {
                    ObservationResultsLaboratoryUvIps ipsObservation = mapObservationToIpsPathologyObservation(observation, patientId);
                    string id = ipsObservation.id ?: uuid:createRandomUuid();
                    ipsObservation.id = id;
                    ipsEntries.push(getBundleEntry(ipsObservation));
                }
            }
            "Specimen" => {
                international401:Specimen specimen = check entry?.'resource.cloneWithType();
                SpecimenUvIps ipsSpecimen = mapSpecimenToIpsSpecimen(specimen, patientId);
                string id = ipsSpecimen.id ?: uuid:createRandomUuid();
                ipsSpecimen.id = id;
                ipsEntries.push(getBundleEntry(ipsSpecimen));
            }
            "Device" => {
                international401:Device device = check entry?.'resource.cloneWithType();
                DeviceUvIps ipsDevice = mapDeviceToIpsDevice(device, patientId);
                string id = ipsDevice.id ?: uuid:createRandomUuid();
                ipsDevice.id = id;
                ipsEntries.push(getBundleEntry(ipsDevice));
            }
            "DeviceUseStatement" => {
                international401:DeviceUseStatement deviceUseStatement = check entry?.'resource.cloneWithType();
                DeviceUseStatementUvIps ipsDeviceUseStatement = mapDeviceUseStatementToIpsDeviceUseStatement(deviceUseStatement, patientId);
                string id = ipsDeviceUseStatement.id ?: uuid:createRandomUuid();
                ipsDeviceUseStatement.id = id;
                ipsEntries.push(getBundleEntry(ipsDeviceUseStatement));
            }
        }
    }
    if diagnosticReportSection.entry is r4:Reference[] {
        composition.section.push(diagnosticReportSection);
    }
    if immunizationSection.entry is r4:Reference[] {
        composition.section.push(immunizationSection);
    }
    if procedureSection.entry is r4:Reference[] {
        composition.section.push(procedureSection);
    }

    composition.subject = {reference: string `Patient/${patientId}`};
    composition.custodian = getIpsCustodianReference();
    composition.author = getIpsAuthorReferences();

    ipsBundle.entry = ipsEntries;
    return ipsBundle;
}

isolated function getBundleEntry(r4:Resource 'resource) returns r4:BundleEntry {
    r4:BundleEntry entry = {};
    string? id = 'resource.id;
    if id is string {
        entry.fullUrl = string `urn:uuid:${id}`;
    }
    entry.'resource = 'resource;
    return entry;
}

isolated function getIpsAuthorReferences() returns r4:Reference[] {
    // should be a reference to Practitioner, Organization, PractitionerRole, Device, Patient, RelatedPerson
    r4:Reference[] compositionAuthors = [];
    foreach string author in authors {
        compositionAuthors.push({reference: author});
    }
    return compositionAuthors;
}

isolated function getIpsCustodianReference() returns r4:Reference? {
    // should be a Organization reference
    if custodian != "" {
        return {reference: custodian};
    } else {
        return ();
    }
}

isolated function getIpsAttesters() returns CompositionUvIpsAttester[]? {
    // should be a reference to Practitioner, Organization, PractitionerRole, Device, Patient, RelatedPerson
    if attesters == [] {
        return ();
    }
    CompositionUvIpsAttester[] compositionAttesters = [];
    foreach string attester in attesters {
        compositionAttesters.push({mode: <CompositionUvIpsAttesterMode>attester});
    }
    return compositionAttesters;
}

isolated function addIfNotDuplicate(r4:Resource newResource, r4:Resource[] resourcesArr) returns r4:Resource[] {
    do {
        if newResource.id is string {
            foreach var resourceArrItem in resourcesArr {
                if resourceArrItem.id is string {
                    if resourceArrItem.id == newResource.id && resourceArrItem.resourceType == newResource.resourceType {
                        // Duplicate found, return original array
                        log:printDebug("Duplicate entry found for resource type: " + newResource.resourceType + " with ID: " + <string>resourceArrItem.id);
                        return resourcesArr;
                    }
                }
            }
            // No duplicate found, add new entry
            resourcesArr.push(newResource);
        }
        return resourcesArr;
    } on fail {
        log:printDebug("Error occurred while checking for duplicates in the bundle entries.");
        return resourcesArr;
    }
}

isolated function fetchAndAddReferencedResource(string reference, IPSContext context) returns r4:Resource? {
    string[] referenceSplit = regex:split(reference, "/");
    if referenceSplit.length() < 2 {
        log:printDebug("Invalid reference format: " + reference);
        return ();
    }
    fhir:FHIRConnector|error clientVal = context.getFHIRClient(referenceSplit[0]);
    if clientVal is fhir:FHIRConnector {
        fhir:FHIRResponse resp = checkpanic clientVal->getById(referenceSplit[0], referenceSplit[1]);
        if resp.httpStatusCode != 200 {
            log:printDebug("Failed to fetch referenced resource: " + reference + ", status code: " + resp.httpStatusCode.toString());
            return ();
        }
        r4:Resource referenceResource = checkpanic resp.'resource.cloneWithType();
        return referenceResource;
    } else {
        log:printError("Failed to get client for referenced resource type: " + referenceSplit[0]);
        return ();
    }
}

isolated function extractSectionNarrativeSummary(r4:Resource resourceObj) returns string {
    // TODO: Implement a more robust HTML to text extraction if needed
    // For now, extract the narrative summary from the resource JSON.
    string summary = "";
    do {
        json resourceJson = resourceObj.toJson();
        
        // First try to extract from existing narrative text if available
        json|error textField = resourceJson.text;
        if textField is json {
            json|error divField = textField.div;
            if divField is string {
                // Extract plain text from HTML div (basic extraction)
                string htmlContent = divField;
                // Simple HTML tag removal for basic text extraction
                string plainText = regex:replaceAll(htmlContent, "<[^>]*>", "");
                plainText = regex:replaceAll(plainText, "\\s+", " ");
                plainText = plainText.trim();
                if plainText.length() > 0 && plainText.length() < 200 {
                    return plainText;
                }
            }
        }
        // If no narrative text, extract from code field
        json|error codeField = resourceJson.code;
        if codeField is json {
            json|error textValue = codeField.text;
            if textValue is string && textValue.trim().length() > 0 {
                summary = textValue.trim();
            } else {
                // Extract from coding display
                json|error codingField = codeField.coding;
                if codingField is json[] && codingField.length() > 0 {
                    json|error displayField = codingField[0].display;
                    if displayField is string && displayField.trim().length() > 0 {
                        summary = displayField.trim();
                    }
                }
            }
        }
    } on fail var e {
        log:printWarn("Error extracting narrative summary: " + e.message());
    }
    return summary;
}

isolated function mapFhirResourceToIpsEntry(r4:Resource fhirResource, string patientId) returns r4:BundleEntry {
    r4:BundleEntry[] ipsEntries = mapFhirResourcesToIpsEntryArr([fhirResource], patientId);
    if ipsEntries.length() > 1 {
        // this cannot be happend
        log:printError("Multiple entries found for a single resource, returning the first entry.");
    }
    return ipsEntries[0];
}

isolated function mapFhirResourcesToIpsEntryArr(r4:Resource[] fhirResources, string patientId) returns r4:BundleEntry[] {
    r4:BundleEntry[] ipsEntries = [];
    
    foreach var entry in fhirResources {
        do {
            json resourceType = entry.resourceType;
            match resourceType {
                "Patient" => {
                    international401:Patient patient = check entry.cloneWithType();
                    PatientUvIps ipsPatient = mapPatientToIpsPatient(patient);
                    ipsEntries.push(getBundleEntry(ipsPatient));
                }
                "AllergyIntolerance" => {
                    international401:AllergyIntolerance allergyIntolerance = check entry.cloneWithType();
                    AllergyIntoleranceUvIps ipsAllergyIntolerance = mapAllergyIntoleranceToIpsAllergyIntolerance(allergyIntolerance, patientId);
                    string id = ipsAllergyIntolerance.id ?: uuid:createRandomUuid();
                    ipsAllergyIntolerance.id = id;
                    ipsEntries.push(getBundleEntry(ipsAllergyIntolerance));
                }
                "Condition" => {
                    international401:Condition condition = check entry.cloneWithType();
                    ConditionUvIps ipsCondition = mapConditionToIpsCondition(condition, patientId);
                    string id = ipsCondition.id ?: uuid:createRandomUuid();
                    ipsCondition.id = id;
                    ipsEntries.push(getBundleEntry(ipsCondition));
                }
                "MedicationRequest" => {
                    international401:MedicationRequest medicationRequest = check entry.cloneWithType();
                    MedicationRequestIPS ipsMedicationRequest = check mapMedicationRequestToIpsMedicationRequest(medicationRequest, patientId);
                    string id = ipsMedicationRequest.id ?: uuid:createRandomUuid();
                    ipsMedicationRequest.id = id;
                    ipsEntries.push(getBundleEntry(ipsMedicationRequest));
                }
                "Medication" => {
                    international401:Medication medication = check entry.cloneWithType();
                    MedicationIPS ipsMedication = mapMedicationToIpsMedication(medication, patientId);
                    string id = ipsMedication.id ?: uuid:createRandomUuid();
                    ipsMedication.id = id;
                    ipsEntries.push(getBundleEntry(ipsMedication));
                }
                "MedicationStatement" => {
                    international401:MedicationStatement medicationStatement = check entry.cloneWithType();
                    MedicationStatementIPS ipsMedicationStatement = mapMedicationStatementToIpsMedicationStatement(medicationStatement, patientId);
                    string id = ipsMedicationStatement.id ?: uuid:createRandomUuid();
                    ipsMedicationStatement.id = id;
                    ipsEntries.push(getBundleEntry(ipsMedicationStatement));
                }
                "Immunization" => {
                    international401:Immunization immunization = check entry.cloneWithType();
                    ImmunizationUvIps ipsImmunization = mapImmunizationToIpsImmunization(immunization, patientId);
                    string id = ipsImmunization.id ?: uuid:createRandomUuid();
                    ipsImmunization.id = id;
                    ipsEntries.push(getBundleEntry(ipsImmunization));
                }
                "Procedure" => {
                    international401:Procedure procedure = check entry.cloneWithType();
                    ProcedureUvIps ipsProcedure = mapProcedureToIpsProcedure(procedure, patientId);
                    string id = ipsProcedure.id ?: uuid:createRandomUuid();
                    ipsProcedure.id = id;
                    ipsEntries.push(getBundleEntry(ipsProcedure));
                }
                "DiagnosticReport" => {
                    international401:DiagnosticReport diagnosticReport = check entry.cloneWithType();
                    DiagnosticReportUvIps ipsReport = mapDiagnosticReportToIps(diagnosticReport, patientId);
                    string id = ipsReport.id ?: uuid:createRandomUuid();
                    ipsReport.id = id;
                    ipsEntries.push(getBundleEntry(ipsReport));
                }
                "Observation" => {
                    international401:Observation observation = check entry.cloneWithType();
                    string? observationCode = ();
                    r4:CodeableConcept[]? category = observation.category;
                    if category is r4:CodeableConcept[] {
                        r4:Coding[]? coding = category[0].coding;
                        if coding is r4:Coding[] {
                            observationCode = coding[0].code;
                        }
                    }
                    if observationCode != () && observationCode == "imaging" {
                        ObservationResultsRadiologyUvIps ipsObservation = mapObservationToIpsRadialogyObservation(observation, patientId);
                        string id = ipsObservation.id ?: uuid:createRandomUuid();
                        ipsObservation.id = id;
                        ipsEntries.push(getBundleEntry(ipsObservation));
                    } else if observationCode != () && observationCode == "laboratory" {
                        ObservationResultsLaboratoryUvIps ipsObservation = mapObservationToIpsPathologyObservation(observation, patientId);
                        string id = ipsObservation.id ?: uuid:createRandomUuid();
                        ipsObservation.id = id;
                        ipsEntries.push(getBundleEntry(ipsObservation));
                    }
                }
                "Specimen" => {
                    international401:Specimen specimen = check entry.cloneWithType();
                    SpecimenUvIps ipsSpecimen = mapSpecimenToIpsSpecimen(specimen, patientId);
                    string id = ipsSpecimen.id ?: uuid:createRandomUuid();
                    ipsSpecimen.id = id;
                    ipsEntries.push(getBundleEntry(ipsSpecimen));
                }
                "Device" => {
                    international401:Device device = check entry.cloneWithType();
                    DeviceUvIps ipsDevice = mapDeviceToIpsDevice(device, patientId);
                    string id = ipsDevice.id ?: uuid:createRandomUuid();
                    ipsDevice.id = id;
                    ipsEntries.push(getBundleEntry(ipsDevice));
                }
                "DeviceUseStatement" => {
                    international401:DeviceUseStatement deviceUseStatement = check entry.cloneWithType();
                    DeviceUseStatementUvIps ipsDeviceUseStatement = mapDeviceUseStatementToIpsDeviceUseStatement(deviceUseStatement, patientId);
                    string id = ipsDeviceUseStatement.id ?: uuid:createRandomUuid();
                    ipsDeviceUseStatement.id = id;
                    ipsEntries.push(getBundleEntry(ipsDeviceUseStatement));
                }
                "Organization" => {
                    international401:Organization organization = check entry.cloneWithType();
                    OrganizationUvIps ipsOrganization = mapOrganizationToIpsOrganization(organization);
                    ipsEntries.push(getBundleEntry(ipsOrganization));
                }
                "Practitioner" => {
                    international401:Practitioner practitioner = check entry.cloneWithType();
                    PractitionerUvIps ipsPractitioner = mapPractitionerToIpsPractitioner(practitioner);
                    ipsEntries.push(getBundleEntry(ipsPractitioner));
                }
                "PractitionerRole" => {
                    international401:PractitionerRole practitionerRole = check entry.cloneWithType();
                    PractitionerRoleUvIps ipsPractitionerRole = mapPractitionerRoleToIpsPractitionerRole(practitionerRole);
                    ipsEntries.push(getBundleEntry(ipsPractitionerRole));
                }
                _ => {
                    log:printDebug("Unsupported resource type: " + resourceType.toString());
                    ipsEntries.push(getBundleEntry(entry)); // Add the entry as is if unsupported
                }
            }
        } on fail var e {
            log:printError("Error occurred while processing entry: " + e.message());
            continue;
        }
    }
    
    return ipsEntries;
}

isolated function getSectionCoding(IpsSectionName sectionName) returns Coding|error {
    if IPS_SECTION_LOINC_CODES.hasKey(sectionName) {
        Coding? codingOpt = IPS_SECTION_LOINC_CODES[sectionName];
        if codingOpt is Coding {
            return codingOpt.clone();
        }
    }
    return error("Coding not found for section resourceType: " + sectionName);
}
