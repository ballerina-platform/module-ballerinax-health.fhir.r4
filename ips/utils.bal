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
import ballerina/time;
import ballerina/uuid;
import ballerinax/health.clients.fhir;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;

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

# Validate the IPS section configurations.
#
# + sectionConfig - The array of SectionConfig objects to be validated.
# + ipsMetaData - (Optional) IPS metadata containing authors and custodian references.
# + return - Returns true if the IPS section configurations are valid,
public isolated function validateSectionConfig(IpsSectionConfig[] sectionConfig, IpsMetaData? ipsMetaData = ()) returns string[]? {
    string[] errorMsgs = [];

    // check sectionConfig contains all required sections
    IpsSectionName[] sectionNamesInSectionConfig = sectionConfig.map(
        isolated function(IpsSectionConfig section) returns IpsSectionName {
        return section.sectionName;
    }
    );
    foreach IpsSectionName requiredSection in REQUIRED_SECTIONS {
        if sectionNamesInSectionConfig.indexOf(requiredSection) is () {
            errorMsgs.push("Required section '" + requiredSection.toString() + "' is missing in the section configuration.");
        }
    }

    // check if the resources in the section config are valid
    if sectionConfig != DEFAULT_SECTION_CONFIG {
        foreach IpsSectionConfig section in sectionConfig {
            string[]|error validResourceTypes = IPS_COMPOSITION_SECTION_RESOURCE_TYPES[section.sectionName].cloneWithType();
            if validResourceTypes is error {
                errorMsgs.push("Failed to get valid resource types for section: " + section.sectionName + ". Error: " + validResourceTypes.message());
                continue;
            }
            foreach SectionResourceConfig resourceConfig in section.resources {
                if validResourceTypes.indexOf(resourceConfig.resourceType) == () {
                    errorMsgs.push("Invalid resource type '" + resourceConfig.resourceType + "' in section '" + section.sectionName + "'.");
                }
            }
        }
    }

    IpsMetaData ipsMetaDataConfig;
    if ipsMetaData is IpsMetaData {
        // ips configuration is provided while validating the section config
        ipsMetaDataConfig = ipsMetaData;
    } else if ips_meta_data_config is IpsMetaData {
        // use the default ips configuration from the config file
        IpsMetaData|error ipsMetaDataConfigClone = ips_meta_data_config.cloneWithType();
        if ipsMetaDataConfigClone is error {
            errorMsgs.push("Failed to clone IPS metadata configuration: " + ipsMetaDataConfigClone.message());
            return errorMsgs;
        }
        ipsMetaDataConfig = ipsMetaDataConfigClone;
    } else {
        errorMsgs.push("Not enough IPS metadata is provided to validate the section configuration.");
        return errorMsgs;
    }

    if !isValidAuthorReferences(ipsMetaDataConfig.authors) {
        errorMsgs.push("Invalid author reference is configured.");
    }
    if ipsMetaDataConfig.authors.length() == 0 {
        errorMsgs.push("At least one author reference is required in the IPS section configuration.");
    }

    if ipsMetaDataConfig.custodian != "" {
        if !isValidCustodianReference(ipsMetaDataConfig.custodian) {
            errorMsgs.push("Invalid custodian reference is configured.");
        }
    }

    if errorMsgs.length() > 0 {
        return errorMsgs;
    }

    return ();
}

## Registers a custom implementation for the IPS Bundle generation function.
#
# This function allows you to override the default IPS Bundle generation logic by providing your own implementation of the `GenerateIps` function type.
# The custom function must have the same signature as `GenerateIps`, with the first parameter as `patientId` and the second as `IPSContext`.
#
# + customGenerateIps - The custom implementation function for generating an IPS Bundle. Must match the `GenerateIps` function type signature.
public function registerCustomGenerateIps(GenerateIps customGenerateIps) {
    generateIps = customGenerateIps;
}

## Generates an IPS (International Patient Summary) Bundle for a given patient using the provided IPSContext.
#
# This function follows the IPS Implementation Guide by HL7 FHIR, ensuring that the generated IPS document is compliant with international standards.
# See the IPS Implementation Guide for more information: https://hl7.org/fhir/uv/ips/
#
# It:
# - Prepares the IPS Composition resource and sections according to IPS IG.
# - Fetches all required FHIR resources for the patient using the context's FHIR clients and section configs.
# - Assembles the IPS Bundle with all necessary entries, including patient, authors, custodian, and section resources.
# - Validates that all required IPS sections are present and populated as per the guideline.
#
# + patientId - The ID of the patient for whom the IPS Bundle is being generated.
# + context - The IPSContext containing all necessary data to construct the IPS Bundle.
# + return - The constructed FHIR R4 Bundle or an error if generation fails.
isolated function generateIpsImpl(string patientId, IPSContext context) returns r4:Bundle|error {
    r4:Resource[] ipsBundleResources = [];
    IpsMetaData ipsMetaData = context.getIpsMetaData();

    // 1. Prepare the Composition resource (sections will be filled below)
    CompositionUvIps composition = {
        status: ipsMetaData.compositionStatus,
        subject: {
            reference: "Patient/" + patientId
        },
        date: time:utcToString(time:utcNow()),
        author: context.getIpsAuthorReferences(),
        custodian: context.getIpsCustodianReference(),
        section: [],
        title: ipsMetaData.compositionTitle,
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
        return error("Can't generate the IPS. Failed to fetch Patient resource for given patientId: " + patientId + ". HTTP status: " + patientResp.httpStatusCode.toString());
    }
    if patientResp.'resource !is json {
        return error("Invalid response format for Patient resource, expected JSON. patientId: " + patientId);
    }
    r4:Resource patientResource = check patientResp.'resource.cloneWithType();
    log:printDebug("[generateIps] Successfully fetched Patient resource for patientId: " + patientId);

    // 3. Add the resource to the entries
    // 3.1 For each IPS section, use context.getSectionConfigs() and fetch resources using section configs
    IpsSectionName[] compositionSectionNames = [];
    IpsSectionConfig[] sectionConfigs = context.getSectionConfigs();
    log:printDebug("[generateIps] Section configs count: " + sectionConfigs.length().toString());
    foreach IpsSectionConfig sectionConfig in sectionConfigs {
        log:printDebug("[generateIps] Processing section: " + sectionConfig.sectionName.toString());
        // Use LOINC code map for section code/display if available
        Coding|error sectionCoding = getSectionCoding(sectionConfig.sectionName);
        if sectionCoding is error {
            log:printWarn("[generateIps] No LOINC code found for section: " + sectionConfig.sectionName + ", using default title as display. Error: " + sectionCoding.message());
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
                log:printDebug("[generateIps] Fetching resources of type: " + resourceType + " with searchParams: " + searchParams.toString());
                fhir:FHIRResponse resp = check clientVal->search(resourceType, mode = fhir:GET, searchParameters = searchParams);
                if resp.httpStatusCode != 200 {
                    log:printWarn("[generateIps] Failed to fetch resources of type: " + resourceType + ", status code: " + resp.httpStatusCode.toString());
                    continue;
                }

                // check if the response contains resources
                r4:Bundle responseBundle = check resp.'resource.cloneWithType();
                r4:BundleEntry[]? bundleEntryArr = responseBundle.entry;
                if bundleEntryArr is () {
                    log:printDebug("[generateIps] No entries found for resource type: " + resourceType);
                    continue;
                }
                foreach r4:BundleEntry entry in bundleEntryArr {
                    r4:Resource|error bundleEntryResource = entry["resource"].cloneWithType();
                    if bundleEntryResource is r4:Resource {
                        string summary = "";

                        // get the ID and summary from the resource JSON
                        string? id = bundleEntryResource.id;

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
                        log:printWarn("[generateIps] Bundle entry resource is not JSON for resource type: " + resourceType);
                    }
                }
            } else {
                log:printError("[generateIps] Failed to get client for resource type: " + resourceType + ". Error: " + clientVal.message());
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
                title: sectionConfig.sectionTitle ?: DEFAULT_IPS_SECTION_TITLES[sectionConfig.sectionName],
                text: {status: "generated", div: divHtml},
                entry: sectionRefs
            };
            composition.section.push(compSection);
            compositionSectionNames.push(sectionConfig.sectionName);
            log:printDebug("[generateIps] Added section '" + sectionConfig.sectionName.toString() + "' with " + sectionRefs.length().toString() + " references.");
        }
    }
    // Check whether all required sections are present in the composition
    foreach IpsSectionName requiredSection in REQUIRED_SECTIONS {
        if !(compositionSectionNames.indexOf(requiredSection) >= 0) {
            return error("Required section '" + requiredSection + "' is missing in the IPS composition. Present sections: " + compositionSectionNames.toString());
        }
    }

    // 3.2 Add the resources in the composition author and custodian if they are not already present
    foreach r4:Reference authorReference in composition.author {
        if authorReference.reference is string {
            r4:Resource? authorResource = fetchReferencedResource(<string>authorReference.reference, context);
            if authorResource is r4:Resource {
                ipsBundleResources = addIfNotDuplicate(authorResource, ipsBundleResources);
            }
        }
    }
    // Add the custodian reference if not already present
    if composition.custodian is r4:Reference {
        if composition.custodian?.reference is string {
            r4:Resource? custodianResource = fetchReferencedResource(<string>composition.custodian?.reference, context);
            if custodianResource is r4:Resource {
                ipsBundleResources = addIfNotDuplicate(custodianResource, ipsBundleResources);
            }
        }
    }

    // 3.3 Add nested resources to the bundle
    r4:Resource[] nextedResources = fetchNestedResources(ipsBundleResources, context);
    log:printDebug("[generateIps] Nested resources fetched: " + nextedResources.length().toString());
    ipsBundleResources = addIfNotDuplicate(nextedResources, ipsBundleResources);

    // 4. Add the Composition as the first entry, Patient as the second
    r4:BundleEntry[] finalEntries = [];
    finalEntries.push(getBundleEntry(composition)); // Composition entry
    finalEntries.push(mapFhirResourceToIpsEntry(patientResource, patientId)); // Patient entry
    foreach r4:BundleEntry entry in mapFhirResourcesToIpsEntryArr(ipsBundleResources, patientId) {
        finalEntries.push(entry);
    }
    log:printDebug("[generateIps] Final bundle entries count: " + finalEntries.length().toString());

    // 5. Create the IPS Bundle at the end
    r4:Bundle ipsBundle = {
        'type: r4:BUNDLE_TYPE_DOCUMENT,
        timestamp: time:utcToString(time:utcNow()),
        identifier: {
            system: ipsMetaData.ipsBundleIdentifier,
            value: uuid:createRandomUuid()
        },
        entry: finalEntries
    };
    log:printDebug("[generateIps] IPS Bundle generation completed for patientId: " + patientId);
    return ipsBundle;
}

isolated function constructIpsBundleFromR4Bundle(r4:Bundle fhirBundle) returns r4:Bundle|error {
    r4:Bundle ipsBundle = {
        'type: "document",
        timestamp: fhirBundle.timestamp ?: time:utcToString(time:utcNow()),
        identifier: fhirBundle.identifier ?: {
            system: ips_meta_data_config?.ipsBundleIdentifier ?: DEFAULT_IPS_BUNDLE_IDENTIFIER,
            value: uuid:createRandomUuid()
        }
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
        title: ips_section_titles[PROBLEMS] ?: DEFAULT_IPS_SECTION_TITLES[PROBLEMS]
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
        title: ips_section_titles[MEDICATIONS] ?: DEFAULT_IPS_SECTION_TITLES[MEDICATIONS]
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
        title: ips_section_titles[ALLERGIES] ?: DEFAULT_IPS_SECTION_TITLES[ALLERGIES]
    };
    //immunization section
    CompositionUvIpsSection immunizationSection = {
        code: {coding: [{system: "http://loinc.org", code: "11369-6", display: "Immunizations"}]},
        title: ips_section_titles[IMMUNIZATIONS] ?: DEFAULT_IPS_SECTION_TITLES[IMMUNIZATIONS],
        text: {status: "generated", div: ""}
    };
    //procedure section
    CompositionUvIpsSection procedureSection = {
        code: {coding: [{system: "http://loinc.org", code: "47519-4", display: "Procedures"}]},
        title: ips_section_titles[PROCEDURE_HISTORY] ?: DEFAULT_IPS_SECTION_TITLES[PROCEDURE_HISTORY],
        text: {status: "generated", div: ""}
    };
    //diagnostic report section
    CompositionUvIpsSection diagnosticReportSection = {
        code: {coding: [{system: "http://loinc.org", code: "30954-2", display: "Diagnostic Reports"}]},
        title: ips_section_titles[RESULTS] ?: DEFAULT_IPS_SECTION_TITLES[RESULTS],
        text: {status: "generated", div: ""}
    };

    //composition resource
    CompositionUvIps composition = {
        status: ips_meta_data_config?.compositionStatus ?: CODE_STATUS_FINAL,
        subject: {reference: ""},
        date: ipsBundle.timestamp ?: time:utcToString(time:utcNow()),
        author: [],
        section: [allergySection, problemsSection, medicationSection],
        title: ips_meta_data_config?.compositionTitle ?: DEFAULT_IPS_COMPOSITION_TITLE,
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

    // add custodian reference if available
    composition.subject = {reference: string `Patient/${patientId}`};
    if ips_meta_data_config?.custodian !is () {
        composition.custodian = {reference: ips_meta_data_config?.custodian};
    }

    // add authors to the composition
    r4:Reference[] compositionAuthors = [];
    string[] authors = ips_meta_data_config?.authors ?: [];
    foreach string author in authors {
        compositionAuthors.push({reference: author});
    }
    composition.author = compositionAuthors;

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

isolated function addIfNotDuplicate(r4:Resource|r4:Resource[] newResource, r4:Resource[] resourcesArr) returns r4:Resource[] {
    do {
        r4:Resource[] newResourceClone = (newResource is r4:Resource) ? [newResource] : newResource;
        foreach r4:Resource newResourceArrItem in newResourceClone {
            boolean isDuplicateFound = false;
            if newResourceArrItem.id is string {
                foreach var resourceArrItem in resourcesArr {
                    if resourceArrItem.id is string {
                        if resourceArrItem.id == newResourceArrItem.id && resourceArrItem.resourceType == newResourceArrItem.resourceType {
                            // Duplicate found, continue to next item
                            log:printDebug("Duplicate entry found for resource type: " + newResourceArrItem.resourceType + " with ID: " + <string>newResourceArrItem.id);
                            isDuplicateFound = true;
                            break;
                        }
                    }
                }
                if !isDuplicateFound {
                    // No duplicate found, add new entry
                    resourcesArr.push(newResourceArrItem);
                }
            }
        }
        return resourcesArr;
    } on fail {
        log:printDebug("Error occurred while checking for duplicates in the bundle entries.");
        return resourcesArr;
    }
}

isolated function fetchReferencedResource(string reference, IPSContext context) returns r4:Resource? {
    ResourceReference|error referenceSplit = splitR4Reference(reference);
    if referenceSplit is error {
        log:printDebug("Invalid reference format: " + reference);
        return ();
    }

    fhir:FHIRConnector|error clientVal = context.getFHIRClient(referenceSplit.resourceType);
    if clientVal is fhir:FHIRConnector {
        fhir:FHIRResponse resp = checkpanic clientVal->getById(referenceSplit.resourceType, referenceSplit.id);
        if resp.httpStatusCode != 200 {
            log:printDebug("Failed to fetch referenced resource: " + reference + ", status code: " + resp.httpStatusCode.toString());
            return ();
        }
        r4:Resource referenceResource = checkpanic resp.'resource.cloneWithType();
        return referenceResource;
    } else {
        log:printError("Failed to get client for referenced resource type: " + referenceSplit.resourceType + " due to: " + clientVal.message());
        return ();
    }
}

isolated function fetchNestedResources(r4:Resource[] resourcesArr, IPSContext context) returns r4:Resource[] {
    string[] nestedResourceReferences = [];

    foreach r4:Resource resourceArrItem in resourcesArr {
        match resourceArrItem.resourceType {
            "MedicationStatement" => {
                // Fetch Medication resource for MedicationStatement (medicationReference)
                international401:MedicationStatement|error medicationStatement = resourceArrItem.cloneWithType();
                if medicationStatement is international401:MedicationStatement {
                    r4:Reference medicationStatementRef = <r4:Reference> medicationStatement.medicationReference;
                    string? medicationResourceReference = medicationStatementRef.reference;
                    if medicationResourceReference is string && nestedResourceReferences.indexOf(medicationResourceReference) is () {
                        nestedResourceReferences.push(medicationResourceReference);
                    }
                }
            }
            "MedicationAdministration" => {
                // Fetch Medication resource for MedicationAdministration (medicationReference)
                international401:MedicationAdministration|error medicationAdmin = resourceArrItem.cloneWithType();
                if medicationAdmin is international401:MedicationAdministration {
                    r4:Reference medicationAdminRef = <r4:Reference> medicationAdmin.medicationReference;
                    string? medicationResourceReference = medicationAdminRef.reference;
                    if medicationResourceReference is string && nestedResourceReferences.indexOf(medicationResourceReference) is () {
                        nestedResourceReferences.push(medicationResourceReference);
                    }
                }
            }
            "MedicationRequest" => {
                // Fetch Medication resource for MedicationRequest (medicationReference)
                international401:MedicationRequest|error medicationRequest = resourceArrItem.cloneWithType();
                if medicationRequest is international401:MedicationRequest {
                    r4:Reference medicationRequestRef = <r4:Reference> medicationRequest.medicationReference;
                    string? medicationResourceReference = medicationRequestRef.reference;
                    if medicationResourceReference is string && nestedResourceReferences.indexOf(medicationResourceReference) is () {
                        nestedResourceReferences.push(medicationResourceReference);
                    }
                }
            }
            "Observation" => {
                // Fetch nested Observation resources
                international401:Observation|error observation = resourceArrItem.cloneWithType();
                if observation is international401:Observation {
                    // (hasMember)
                    r4:Reference[]? observationReferences = observation.hasMember;
                    if observationReferences is r4:Reference[] {
                        foreach r4:Reference obsRef in observationReferences {
                            if obsRef.reference is string && nestedResourceReferences.indexOf(<string>obsRef.reference) is () {
                                nestedResourceReferences.push(<string>obsRef.reference);
                            }
                        }
                    }
                }
            }
        }
    }

    r4:Resource[] nestedResources = [];
    foreach string item in nestedResourceReferences {
        r4:Resource? nestedResource = fetchReferencedResource(item, context);
        if nestedResource is r4:Resource {
            nestedResources.push(nestedResource);
        }
    }

    return nestedResources;
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
                string:RegExp regexHtmlTags = re `<[^>]*>`;
                string plainText = regexHtmlTags.replaceAll(htmlContent, "");
                // Replace multiple spaces with a single space and trim the text
                string:RegExp regexWhiteSpaces = re `\s+`;
                plainText = regexWhiteSpaces.replaceAll(plainText, " ");

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

isolated function splitR4Reference(string reference) returns ResourceReference|error {
    string:RegExp slash = re `/`;
    string[] parts = slash.split(reference);
    if parts.length() != 2 {
        return error("Invalid reference format: " + reference);
    }
    return {
        resourceType: parts[0],
        id: parts[1]
    };
}

isolated function isValidAuthorReferences(string[] authorRef) returns boolean {
    string[] resourceTypes = ["Practitioner", "Organization", "PractitionerRole", "Device", "Patient", "RelatedPerson"];
    if authorRef.length() == 0 {
        return false;
    }
    foreach string ref in authorRef {
        ResourceReference|error referenceSplit = splitR4Reference(ref);
        if referenceSplit is error {
            log:printDebug("Invalid author reference format: " + ref);
            return false;
        }
        if resourceTypes.indexOf(referenceSplit.resourceType) is () {
            return false;
        } 
    }
    return true;
}

isolated function isValidCustodianReference(string? custodianRef) returns boolean {
    if custodianRef is string {
        ResourceReference|error referenceSplit = splitR4Reference(custodianRef);
        if referenceSplit is ResourceReference {
            return referenceSplit.resourceType == "Organization";
        } else {
            log:printDebug("Invalid custodian reference format: " + custodianRef);
            return false;
        }
    }
    return true;
}
