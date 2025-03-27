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
import ballerina/time;
import ballerina/uuid;
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
    if custodian != "" {
        composition.custodian = {reference: custodian};
    }
    if author != "" {
        composition.author = [{reference: author}];
    }

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

