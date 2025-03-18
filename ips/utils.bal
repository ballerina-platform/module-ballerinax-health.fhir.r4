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
        return getIpsBundleFromFHIR(<r4:Bundle>bundleData);
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

isolated function getIpsBundleFromFHIR(r4:Bundle fhirBundle) returns r4:Bundle|error {
    r4:Bundle ipsBundle = {
        'type: "document",
        timestamp: fhirBundle.timestamp ?: time:utcToString(time:utcNow()),
        identifier: fhirBundle.identifier ?: {system: ips_bundle_identifier_system, value: uuid:createRandomUuid()}
    };

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
    r4:BundleEntry[] entries = fhirBundle.entry ?: [];
    string patientId = "";
    foreach var entry in entries {
        r4:Resource resourceContent = check entry?.'resource.cloneWithType();
        string resourceType = resourceContent.resourceType;
        if resourceType == "Patient" {
            international401:Patient patient = check entry?.'resource.cloneWithType();
            PatientUvIps ipsPatient = mapPatientToIpsPatient(patient);
            patientId = <string>ipsPatient.id;
            ipsEntries.push(getBundleEntry(ipsPatient));
        } else if resourceType == "AllergyIntolerance" {
            international401:AllergyIntolerance allergyIntolerance = check entry?.'resource.cloneWithType();
            AllergyIntoleranceUvIps ipsAllergyIntolerance = mapAllergyIntoleranceToIpsAllergyIntolerance(allergyIntolerance, patientId);
            string id = ipsAllergyIntolerance.id ?: uuid:createRandomUuid();
            ipsAllergyIntolerance.id = id;
            ipsEntries.push(getBundleEntry(ipsAllergyIntolerance));
            r4:Reference[] sectionReferences = allergySection.entry ?: [];
            sectionReferences.push({reference: string `AllergyIntolerance/${id}`});
            allergySection.entry = sectionReferences;
        } else if resourceType == "Condition" {
            international401:Condition condition = check entry?.'resource.cloneWithType();
            ConditionUvIps ipsCondition = mapConditionToIpsCondition(condition, patientId);
            string id = ipsCondition.id ?: uuid:createRandomUuid();
            ipsCondition.id = id;
            ipsEntries.push(getBundleEntry(ipsCondition));
            r4:Reference[] sectionReferences = problemsSection.entry ?: [];
            sectionReferences.push({reference: string `Condition/${id}`});
            problemsSection.entry = sectionReferences;
        } else if resourceType == "MedicationRequest" {
            international401:MedicationRequest medicationRequest = check entry?.'resource.cloneWithType();
            MedicationRequestIPS ipsMedicationRequest = check mapMedicationRequestToIpsMedicationRequest(medicationRequest, patientId);
            string id = ipsMedicationRequest.id ?: uuid:createRandomUuid();
            ipsMedicationRequest.id = id;
            ipsEntries.push(getBundleEntry(ipsMedicationRequest));
            r4:Reference[] sectionReferences = medicationSection.entry ?: [];
            sectionReferences.push({reference: string `MedicationRequest/${id}`});
            medicationSection.entry = sectionReferences;
        }
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
        entry.fullUrl = string`urn:uuid:${id}`;
    }
    entry.'resource = 'resource;
    return entry;
}

isolated function mapPatientToIpsPatient(international401:Patient patient) returns PatientUvIps => let
    string patientId = patient.id ?: uuid:createRandomUuid() in {
        id: patientId,
        identifier: patient.identifier,
        name: patient.name ?: [],
        telecom: patient.telecom,
        gender: <PatientUvIpsGender>patient.gender,
        birthDate: patient.birthDate ?: "",
        deceasedBoolean: patient.deceasedBoolean,
        deceasedDateTime: patient.deceasedDateTime,
        address: patient.address,
        generalPractitioner: patient.generalPractitioner,
        link: patient.link
    };

isolated function mapAllergyIntoleranceToIpsAllergyIntolerance(international401:AllergyIntolerance allergyIntolerance, string patientId) returns AllergyIntoleranceUvIps => let
    string allergyId = allergyIntolerance.id ?: uuid:createRandomUuid() in {
        id: allergyId,
        patient: {reference: string `Patient/${patientId}`},
        clinicalStatus: allergyIntolerance.clinicalStatus,
        verificationStatus: allergyIntolerance.verificationStatus,
        'type: allergyIntolerance.'type,
        code: allergyIntolerance.code,
        onsetDateTime: allergyIntolerance.onsetDateTime,
        reaction: allergyIntolerance.reaction
    };

isolated function mapConditionToIpsCondition(international401:Condition condition, string patientId) returns ConditionUvIps => let
    string conditionId = condition.id ?: uuid:createRandomUuid() in {
        id: conditionId,
        clinicalStatus: condition.clinicalStatus ?: {},
        verificationStatus: condition.verificationStatus,
        category: condition.category,
        severity: condition.severity,
        code: condition.code ?: {},
        bodySite: condition.bodySite,
        onsetDateTime: condition.onsetDateTime,
        subject: {reference: string `Patient/${patientId}`}
    };

isolated function mapMedicationRequestToIpsMedicationRequest(international401:MedicationRequest medicationRequest, string patientId) returns MedicationRequestIPS|error => let
    string medicationRequestId = medicationRequest.id ?: uuid:createRandomUuid() in {
        id: medicationRequestId,
        subject: {reference: string `Patient/${patientId}`},
        medicationCodeableConcept: medicationRequest.medicationCodeableConcept,
        medicationReference: medicationRequest.medicationReference,
        intent: medicationRequest.intent,
        doNotPerform: medicationRequest.doNotPerform,
        status: medicationRequest.status,
        implicitRules: medicationRequest.implicitRules,
        dosageInstruction: check medicationRequest.dosageInstruction.cloneWithType()
    };
