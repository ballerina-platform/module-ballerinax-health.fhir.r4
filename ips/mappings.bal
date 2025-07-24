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
import ballerina/uuid;
import ballerinax/health.fhir.r4.international401;

isolated function mapPatientToIpsPatient(international401:Patient patient) returns PatientUvIps => let
    string patientId = patient.id ?: uuid:createRandomUuid() in {
        id: patientId,
        identifier: patient.identifier,
        name: patient.name ?: [],
        telecom: patient.telecom,
        gender: mapGenderToIpsGender(patient.gender ?: CODE_GENDER_UNKNOWN),
        birthDate: <string>patient.birthDate,
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

// Medication Mapping
isolated function mapMedicationToIpsMedication(international401:Medication medication, string patientId) returns MedicationIPS => let
    string medicationId = medication.id ?: uuid:createRandomUuid() in {
        id: medicationId,
        implicitRules: medication.implicitRules,
        code: medication.code ?: {},
        status: medication.status,
        form: medication.form,
        ingredient: medication.ingredient
    };

// Medication Statement Mapping
isolated function mapMedicationStatementToIpsMedicationStatement(international401:MedicationStatement medicationStatement, string patientId) returns MedicationStatementIPS => let
    string medicationStatementId = medicationStatement.id ?: uuid:createRandomUuid() in {
        id: medicationStatementId,
        implicitRules: medicationStatement.implicitRules,
        subject: {reference: string `Patient/${patientId}`},
        medicationCodeableConcept: medicationStatement.medicationCodeableConcept,
        medicationReference: medicationStatement.medicationReference,
        status: medicationStatement.status,
        effectiveDateTime: medicationStatement.effectiveDateTime ?: "",
        effectivePeriod: medicationStatement.effectivePeriod ?: {}
    };

// Immunization Mapping
isolated function mapImmunizationToIpsImmunization(
        international401:Immunization immunization,
        string patientId
) returns ImmunizationUvIps => let
    string immunizationId = immunization.id ?: uuid:createRandomUuid() in {
        id: immunizationId,
        implicitRules: immunization.implicitRules,
        patient: {reference: string `Patient/${patientId}`},
        vaccineCode: immunization.vaccineCode,
        status: immunization.status,
        occurrenceDateTime: immunization.occurrenceDateTime,
        occurrenceString: immunization.occurrenceString,
        site: immunization.site,
        route: immunization.route,
        isSubpotent: immunization.isSubpotent
    };

// Procedure Mapping
isolated function mapProcedureToIpsProcedure(
        international401:Procedure procedure,
        string patientId
) returns ProcedureUvIps => let
    string procedureId = procedure.id ?: uuid:createRandomUuid() in {
        id: procedureId,
        subject: {reference: string `Patient/${patientId}`},
        code: procedure.code ?: {},
        performedDateTime: procedure.performedDateTime ?: "",
        status: procedure.status,
        performedString: "",
        performedRange: {},
        performedAge: {},
        performedPeriod: {}
    };

// DiagnosticReport Mapping
isolated function mapDiagnosticReportToIps(
        international401:DiagnosticReport diagnosticReport,
        string patientId
) returns DiagnosticReportUvIps => let
    string reportId = diagnosticReport.id ?: uuid:createRandomUuid() in {
        id: reportId,
        implicitRules: diagnosticReport.implicitRules,
        subject: {reference: string `Patient/${patientId}`},
        code: diagnosticReport.code,
        effectiveDateTime: diagnosticReport.effectiveDateTime ?: "",
        result: diagnosticReport.result,
        effectivePeriod: diagnosticReport.effectivePeriod ?: {},
        performer: diagnosticReport.performer,
        specimen: diagnosticReport.specimen,
        category: diagnosticReport.category ?: [],
        status: diagnosticReport.status
    };

// Observation Radiology Mapping
isolated function mapObservationToIpsRadialogyObservation(
        international401:Observation observation,
        string patientId
) returns ObservationResultsRadiologyUvIps => let
    string observationId = observation.id ?: uuid:createRandomUuid() in {
        id: observationId,
        implicitRules: observation.implicitRules,
        partOf: observation.partOf,
        performer: observation.performer ?: [],
        effectivePeriod: observation.effectivePeriod ?: {},
        effectiveDateTime: observation.effectiveDateTime ?: "",
        category: [{coding: [{system: "http://terminology.hl7.org/CodeSystem/observation-category", code: "imaging", display: "Imaging"}]}],
        status: observation.status,
        code: observation.code,
        valueQuantity: observation.valueQuantity,
        valueCodeableConcept: observation.valueCodeableConcept,
        valueString: observation.valueString,
        valueBoolean: observation.valueBoolean,
        valueInteger: observation.valueInteger,
        valueRange: observation.valueRange,
        valueRatio: observation.valueRatio,
        valueSampledData: observation.valueSampledData,
        valueTime: observation.valueTime,
        valueDateTime: observation.valueDateTime,
        valuePeriod: observation.valuePeriod,
        bodySite: observation.bodySite,
        device: observation.device,
        hasMember: observation.hasMember,
        component: observation.component,
        subject: {reference: string `Patient/${patientId}`}
    };

// Observation pathology Mapping
isolated function mapObservationToIpsPathologyObservation(
        international401:Observation observation,
        string patientId
) returns ObservationResultsPathologyUvIps => let
    string observationId = observation.id ?: uuid:createRandomUuid() in {
        id: observationId,
        implicitRules: observation.implicitRules,
        performer: observation.performer ?: [],
        effectivePeriod: observation.effectivePeriod ?: {},
        effectiveDateTime: observation.effectiveDateTime ?: "",
        category: [{coding: [{system: "http://terminology.hl7.org/CodeSystem/observation-category", code: "laboratory", display: "Laboratory"}]}],
        status: observation.status,
        code: observation.code,
        subject: {reference: string `Patient/${patientId}`},
        valueCodeableConcept: observation.valueCodeableConcept,
        valueString: observation.valueString,
        valueBoolean: observation.valueBoolean,
        valueInteger: observation.valueInteger,
        valueRange: observation.valueRange,
        valueRatio: observation.valueRatio,
        valueSampledData: observation.valueSampledData,
        valueTime: observation.valueTime,
        valueDateTime: observation.valueDateTime,
        valuePeriod: observation.valuePeriod,
        interpretation: observation.interpretation,
        specimen: observation.specimen,
        hasMember: observation.hasMember,
        component: observation.component
    };

// Specimen Mapping
isolated function mapSpecimenToIpsSpecimen(
        international401:Specimen specimen,
        string patientId
) returns SpecimenUvIps => let
    string specimenId = specimen.id ?: uuid:createRandomUuid() in {
        id: specimenId,
        implicitRules: specimen.implicitRules,
        'type: specimen.'type ?: {},
        subject: {reference: string `Patient/${patientId}`},
        status: specimen.status
    };

// Device Mapping
isolated function mapDeviceToIpsDevice(
        international401:Device device,
        string patientId
) returns DeviceUvIps => let
    string deviceId = device.id ?: uuid:createRandomUuid() in {
        id: deviceId,
        implicitRules: device.implicitRules,
        identifier: device.identifier,
        status: device.status,
        manufacturer: device.manufacturer,
        modelNumber: device.modelNumber,
        patient: {reference: string `Patient/${patientId}`}
    };

// DeviceUseStatement Mapping
isolated function mapDeviceUseStatementToIpsDeviceUseStatement(
        international401:DeviceUseStatement deviceUseStatement,
        string patientId
) returns DeviceUseStatementUvIps => let
    string deviceUseStatementId = deviceUseStatement.id ?: uuid:createRandomUuid() in {
        id: deviceUseStatementId,
        implicitRules: deviceUseStatement.implicitRules,
        timingTiming: deviceUseStatement.timingTiming ?: {},
        timingPeriod: deviceUseStatement.timingPeriod ?: {},
        timingDateTime: deviceUseStatement.timingDateTime ?: "",
        subject: {reference: string `Patient/${patientId}`},
        device: deviceUseStatement.device,
        status: deviceUseStatement.status,
        bodySite: deviceUseStatement.bodySite
    };

isolated function mapGenderToIpsGender(international401:PatientGender gender) returns PatientUvIpsGender {
    match gender {
        international401:CODE_GENDER_MALE => {
            return CODE_GENDER_MALE;
        }
        international401:CODE_GENDER_FEMALE => {
            return CODE_GENDER_FEMALE;
        }
        international401:CODE_GENDER_OTHER => {
            return CODE_GENDER_OTHER;
        }
        _ => {
            return CODE_GENDER_UNKNOWN;
        }
    }
}

isolated function mapOrganizationToIpsOrganization(international401:Organization organization) returns OrganizationUvIps => let
    string organizationId = organization.id ?: uuid:createRandomUuid() in {
        id: organizationId,
        name: organization.name ?: "",
        identifier: organization.identifier,
        telecom: organization.telecom,
        address: organization.address,
        partOf: organization.partOf,
        extension: organization.extension,
        modifierExtension: organization.modifierExtension,
        active: organization.active,
        language: organization.language,
        'type: organization.'type,
        endpoint: organization.endpoint,
        contained: organization.contained,
        contact: organization.contact,
        alias: organization.alias,
        text: organization.text,
        implicitRules: organization.implicitRules,
        meta: {
            tag: organization.meta?.tag,
            lastUpdated: organization.meta?.lastUpdated,
            'source: organization.meta?.'source,
            versionId: organization.meta?.versionId,
            extension: organization.meta?.extension,
            security: organization.meta?.security
        }
    };

isolated function mapPractitionerToIpsPractitioner(international401:Practitioner practitioner) returns PractitionerUvIps => let
    string practitionerId = practitioner.id ?: uuid:createRandomUuid() in {
        id: practitionerId,
        identifier: practitioner.identifier,
        name: practitioner.name ?: [],
        extension: practitioner.extension,
        address: practitioner.address,
        modifierExtension: practitioner.modifierExtension,
        active: practitioner.active,
        photo: practitioner.photo,
        language: practitioner.language,
        birthDate: practitioner.birthDate,
        contained: practitioner.contained,
        qualification: practitioner.qualification,
        telecom: practitioner.telecom,
        implicitRules: practitioner.implicitRules,
        text: practitioner.text,
        gender: practitioner.gender,
        communication: practitioner.communication
    };

isolated function mapPractitionerRoleToIpsPractitionerRole(international401:PractitionerRole practitionerRole) returns PractitionerRoleUvIps => let
    string practitionerRoleId = practitionerRole.id ?: uuid:createRandomUuid() in {
        id: practitionerRoleId,
        implicitRules: practitionerRole.implicitRules,
        active: practitionerRole.active,
        period: practitionerRole.period,
        practitioner: {
            id: practitionerRole.practitioner?.id,
            identifier: practitionerRole.practitioner?.identifier,
            extension: practitionerRole.practitioner?.extension,
            'type: practitionerRole.practitioner?.'type,
            display: practitionerRole.practitioner?.display
        },
        organization: practitionerRole.organization,
        code: practitionerRole.code,
        specialty: practitionerRole.specialty,
        location: practitionerRole.location,
        telecom: practitionerRole.telecom,
        availableTime: practitionerRole.availableTime,
        notAvailable: practitionerRole.notAvailable,
        endpoint: practitionerRole.endpoint,
        identifier: practitionerRole.identifier,
        extension: practitionerRole.extension,
        healthcareService: practitionerRole.healthcareService,
        contained: practitionerRole.contained,
        language: practitionerRole.language,
        modifierExtension: practitionerRole.modifierExtension,
        availabilityExceptions: practitionerRole.availabilityExceptions,
        text: practitionerRole.text
    };
