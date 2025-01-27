// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

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

// AUTO-GENERATED FILE.
// This file is auto-generated by Ballerina.

import ballerinax/health.fhir.r4;

# Terminology processor instance
public final r4:TerminologyProcessor terminologyProcessor = r4:terminologyProcessor;

# FHIR registry instance
public final r4:FHIRRegistry fhirRegistry = r4:fhirRegistry;

//Number of search params in USCORE_IG_SEARCH_PARAMS_1  = 100
final readonly & map<r4:FHIRSearchParameterDefinition[]> USCORE_IG_SEARCH_PARAMS_1 = {
    "USCorePatientGender": [
        {
            name: "USCorePatientGender",
            'type: r4:TOKEN,
            base: ["Patient"],
            expression: "Patient.gender"
        }
    ],
    "USCoreAllergyintolerancePatient": [
        {
            name: "USCoreAllergyintolerancePatient",
            'type: r4:REFERENCE,
            base: ["AllergyIntolerance"],
            expression: "AllergyIntolerance.patient"
        }
    ],
    "USCoreDocumentreferenceCategory": [
        {
            name: "USCoreDocumentreferenceCategory",
            'type: r4:TOKEN,
            base: ["DocumentReference"],
            expression: "DocumentReference.category"
        }
    ],
    "USCoreProcedureDate": [
        {
            name: "USCoreProcedureDate",
            'type: r4:DATE,
            base: ["Procedure"],
            expression: "Procedure.performed"
        }
    ],
    "USCoreMedicationrequestPatient": [
        {
            name: "USCoreMedicationrequestPatient",
            'type: r4:REFERENCE,
            base: ["MedicationRequest"],
            expression: "MedicationRequest.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreCareplanCategory": [
        {
            name: "USCoreCareplanCategory",
            'type: r4:TOKEN,
            base: ["CarePlan"],
            expression: "CarePlan.category"
        }
    ],
    "USCoreCareteamStatus": [
        {
            name: "USCoreCareteamStatus",
            'type: r4:TOKEN,
            base: ["CareTeam"],
            expression: "CareTeam.status"
        }
    ],
    "USCoreObservationCategory": [
        {
            name: "USCoreObservationCategory",
            'type: r4:TOKEN,
            base: ["Observation"],
            expression: "Observation.category"
        }
    ],
    "USCoreDocumentreferencePeriod": [
        {
            name: "USCoreDocumentreferencePeriod",
            'type: r4:DATE,
            base: ["DocumentReference"],
            expression: "DocumentReference.context.period"
        }
    ],
    "USCoreGoalLifecycleStatus": [
        {
            name: "USCoreGoalLifecycleStatus",
            'type: r4:TOKEN,
            base: ["Goal"],
            expression: "Goal.lifecycleStatus"
        }
    ],
    "USCoreGoalPatient": [
        {
            name: "USCoreGoalPatient",
            'type: r4:REFERENCE,
            base: ["Goal"],
            expression: "Goal.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreCareTeamRole": [
        {
            name: "USCoreCareTeamRole",
            'type: r4:TOKEN,
            base: ["CareTeam"],
            expression: "CareTeam.participant.role"
        }
    ],
    "USCoreOrganizationName": [
        {
            name: "USCoreOrganizationName",
            'type: r4:STRING,
            base: ["Organization"],
            expression: "Organization.name|Organization.alias"
        }
    ],
    "USCoreMedicationrequestIntent": [
        {
            name: "USCoreMedicationrequestIntent",
            'type: r4:TOKEN,
            base: ["MedicationRequest"],
            expression: "MedicationRequest.intent"
        }
    ],
    "USCoreImmunizationStatus": [
        {
            name: "USCoreImmunizationStatus",
            'type: r4:TOKEN,
            base: ["Immunization"],
            expression: "Immunization.status"
        }
    ],
    "USCoreProcedureStatus": [
        {
            name: "USCoreProcedureStatus",
            'type: r4:TOKEN,
            base: ["Procedure"],
            expression: "Procedure.status"
        }
    ],
    "USCoreQuestionnaireresponseStatus": [
        {
            name: "USCoreQuestionnaireresponseStatus",
            'type: r4:TOKEN,
            base: ["QuestionnaireResponse"],
            expression: "QuestionnaireResponse.status"
        }
    ],
    "USCoreEthnicity": [
        {
            name: "USCoreEthnicity",
            'type: r4:TOKEN,
            base: ["Patient"],
            expression: "Patient.extension.where(url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity').extension.value.code"
        }
    ],
    "USCoreGoalTargetDate": [
        {
            name: "USCoreGoalTargetDate",
            'type: r4:DATE,
            base: ["Goal"],
            expression: "(Goal.target.due as date)"
        }
    ],
    "USCoreRelatedpersonId": [
        {
            name: "USCoreRelatedpersonId",
            'type: r4:TOKEN,
            base: ["RelatedPerson"],
            expression: "RelatedPerson.id"
        }
    ],
    "USCoreDocumentreferenceId": [
        {
            name: "USCoreDocumentreferenceId",
            'type: r4:TOKEN,
            base: ["DocumentReference"],
            expression: "DocumentReference.id"
        }
    ],
    "USCoreConditionEncounter": [
        {
            name: "USCoreConditionEncounter",
            'type: r4:REFERENCE,
            base: ["Condition"],
            expression: "Condition.encounter"
        }
    ],
    "USCoreCareplanPatient": [
        {
            name: "USCoreCareplanPatient",
            'type: r4:REFERENCE,
            base: ["CarePlan"],
            expression: "CarePlan.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreOrganizationAddress": [
        {
            name: "USCoreOrganizationAddress",
            'type: r4:STRING,
            base: ["Organization"],
            expression: "Organization.address"
        }
    ],
    "USCoreConditionAbatementDate": [
        {
            name: "USCoreConditionAbatementDate",
            'type: r4:DATE,
            base: ["Condition"],
            expression: "Condition.abatement.as(dateTime)|Condition.abatement.as(Period)"
        }
    ],
    "USCoreRelatedpersonPatient": [
        {
            name: "USCoreRelatedpersonPatient",
            'type: r4:REFERENCE,
            base: ["RelatedPerson"],
            expression: "RelatedPerson.patient"
        }
    ],
    "USCoreSpecimenId": [
        {
            name: "USCoreSpecimenId",
            'type: r4:TOKEN,
            base: ["Specimen"],
            expression: "Specimen.id"
        }
    ],
    "USCorePatientGenderIdentity": [
        {
            name: "USCorePatientGenderIdentity",
            'type: r4:TOKEN,
            base: ["Patient"],
            expression: "Patient.extension.where(url='http://hl7.org/fhir/us/core/StructureDefinition/us-core-genderIdentity').value.coding.code"
        }
    ],
    "USCoreEncounterClass": [
        {
            name: "USCoreEncounterClass",
            'type: r4:TOKEN,
            base: ["Encounter"],
            expression: "Encounter.class"
        }
    ],
    "USCoreLocationName": [
        {
            name: "USCoreLocationName",
            'type: r4:STRING,
            base: ["Location"],
            expression: "Location.name|Location.alias"
        }
    ],
    "USCoreGoalDescription": [
        {
            name: "USCoreGoalDescription",
            'type: r4:TOKEN,
            base: ["Goal"],
            expression: "Goal.description"
        }
    ],
    "USCoreEncounterLocation": [
        {
            name: "USCoreEncounterLocation",
            'type: r4:REFERENCE,
            base: ["Encounter"],
            expression: "Encounter.location.location"
        }
    ],
    "USCoreRelatedpersonName": [
        {
            name: "USCoreRelatedpersonName",
            'type: r4:STRING,
            base: ["RelatedPerson"],
            expression: "RelatedPerson.name"
        }
    ],
    "USCoreConditionOnsetDate": [
        {
            name: "USCoreConditionOnsetDate",
            'type: r4:DATE,
            base: ["Condition"],
            expression: "Condition.onset.as(dateTime)|Condition.onset.as(Period)"
        }
    ],
    "USCoreConditionRecordedDate": [
        {
            name: "USCoreConditionRecordedDate",
            'type: r4:DATE,
            base: ["Condition"],
            expression: "Condition.recordedDate"
        }
    ],
    "USCoreObservationDate": [
        {
            name: "USCoreObservationDate",
            'type: r4:DATE,
            base: ["Observation"],
            expression: "Observation.effective"
        }
    ],
    "USCoreServicerequestCode": [
        {
            name: "USCoreServicerequestCode",
            'type: r4:TOKEN,
            base: ["ServiceRequest"],
            expression: "ServiceRequest.code"
        }
    ],
    "USCoreQuestionnaireresponseAuthored": [
        {
            name: "USCoreQuestionnaireresponseAuthored",
            'type: r4:DATE,
            base: ["QuestionnaireResponse"],
            expression: "QuestionnaireResponse.authored"
        }
    ],
    "USCoreRace": [
        {
            name: "USCoreRace",
            'type: r4:TOKEN,
            base: ["Patient"],
            expression: "Patient.extension.where(url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race').extension.value.code"
        }
    ],
    "USCoreDeviceStatus": [
        {
            name: "USCoreDeviceStatus",
            'type: r4:TOKEN,
            base: ["Device"],
            expression: "Device.status"
        }
    ],
    "USCoreDiagnosticreportCategory": [
        {
            name: "USCoreDiagnosticreportCategory",
            'type: r4:TOKEN,
            base: ["DiagnosticReport"],
            expression: "DiagnosticReport.category"
        }
    ],
    "USCoreImmunizationPatient": [
        {
            name: "USCoreImmunizationPatient",
            'type: r4:REFERENCE,
            base: ["Immunization"],
            expression: "Immunization.patient"
        }
    ],
    "USCoreServicerequestAuthored": [
        {
            name: "USCoreServicerequestAuthored",
            'type: r4:DATE,
            base: ["ServiceRequest"],
            expression: "ServiceRequest.authoredOn"
        }
    ],
    "USCoreQuestionnaireresponsePatient": [
        {
            name: "USCoreQuestionnaireresponsePatient",
            'type: r4:REFERENCE,
            base: ["QuestionnaireResponse"],
            expression: "QuestionnaireResponse.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreConditionCode": [
        {
            name: "USCoreConditionCode",
            'type: r4:TOKEN,
            base: ["Condition"],
            expression: "Condition.code"
        }
    ],
    "USCoreConditionClinicalStatus": [
        {
            name: "USCoreConditionClinicalStatus",
            'type: r4:TOKEN,
            base: ["Condition"],
            expression: "Condition.clinicalStatus"
        }
    ],
    "USCoreConditionCategory": [
        {
            name: "USCoreConditionCategory",
            'type: r4:TOKEN,
            base: ["Condition"],
            expression: "Condition.category"
        }
    ],
    "USCoreMedicationrequestStatus": [
        {
            name: "USCoreMedicationrequestStatus",
            'type: r4:TOKEN,
            base: ["MedicationRequest"],
            expression: "MedicationRequest.status"
        }
    ],
    "USCoreEncounterType": [
        {
            name: "USCoreEncounterType",
            'type: r4:TOKEN,
            base: ["Encounter"],
            expression: "Encounter.type"
        }
    ],
    "USCorePractitionerName": [
        {
            name: "USCorePractitionerName",
            'type: r4:STRING,
            base: ["Practitioner"],
            expression: "Practitioner.name"
        }
    ],
    "USCoreLocationAddressPostalcode": [
        {
            name: "USCoreLocationAddressPostalcode",
            'type: r4:STRING,
            base: ["Location"],
            expression: "Location.address.postalCode"
        }
    ],
    "USCoreServicerequestCategory": [
        {
            name: "USCoreServicerequestCategory",
            'type: r4:TOKEN,
            base: ["ServiceRequest"],
            expression: "ServiceRequest.category"
        }
    ],
    "USCoreDiagnosticreportCode": [
        {
            name: "USCoreDiagnosticreportCode",
            'type: r4:TOKEN,
            base: ["DiagnosticReport"],
            expression: "DiagnosticReport.code"
        }
    ],
    "USCoreDocumentreferenceType": [
        {
            name: "USCoreDocumentreferenceType",
            'type: r4:TOKEN,
            base: ["DocumentReference"],
            expression: "DocumentReference.type"
        }
    ],
    "USCoreAllergyintoleranceClinicalStatus": [
        {
            name: "USCoreAllergyintoleranceClinicalStatus",
            'type: r4:TOKEN,
            base: ["AllergyIntolerance"],
            expression: "AllergyIntolerance.clinicalStatus"
        }
    ],
    "USCoreSpecimenPatient": [
        {
            name: "USCoreSpecimenPatient",
            'type: r4:REFERENCE,
            base: ["Specimen"],
            expression: "Specimen.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreObservationPatient": [
        {
            name: "USCoreObservationPatient",
            'type: r4:REFERENCE,
            base: ["Observation"],
            expression: "Observation.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreProcedurePatient": [
        {
            name: "USCoreProcedurePatient",
            'type: r4:REFERENCE,
            base: ["Procedure"],
            expression: "Procedure.subject.where(resolve() is Patient)"
        }
    ],
    "USCorePractitionerrolePractitioner": [
        {
            name: "USCorePractitionerrolePractitioner",
            'type: r4:REFERENCE,
            base: ["PractitionerRole"],
            expression: "PractitionerRole.practitioner"
        }
    ],
    "USCorePatientIdentifier": [
        {
            name: "USCorePatientIdentifier",
            'type: r4:TOKEN,
            base: ["Patient"],
            expression: "Patient.identifier"
        }
    ],
    "USCoreConditionAssertedDate": [
        {
            name: "USCoreConditionAssertedDate",
            'type: r4:DATE,
            base: ["Condition"],
            expression: "Condition.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/condition-assertedDate').valueDateTime"
        }
    ],
    "USCoreLocationAddressState": [
        {
            name: "USCoreLocationAddressState",
            'type: r4:STRING,
            base: ["Location"],
            expression: "Location.address.state"
        }
    ],
    "USCoreMedicationrequestAuthoredon": [
        {
            name: "USCoreMedicationrequestAuthoredon",
            'type: r4:DATE,
            base: ["MedicationRequest"],
            expression: "MedicationRequest.authoredOn"
        }
    ],
    "USCoreObservationCode": [
        {
            name: "USCoreObservationCode",
            'type: r4:TOKEN,
            base: ["Observation"],
            expression: "Observation.code"
        }
    ],
    "USCoreCoveragePatient": [
        {
            name: "USCoreCoveragePatient",
            'type: r4:REFERENCE,
            base: ["Coverage"],
            expression: "Coverage.beneficiary"
        }
    ],
    "USCoreEncounterId": [
        {
            name: "USCoreEncounterId",
            'type: r4:TOKEN,
            base: ["Encounter"],
            expression: "Encounter.id"
        }
    ],
    "USCoreMedicationdispenseStatus": [
        {
            name: "USCoreMedicationdispenseStatus",
            'type: r4:TOKEN,
            base: ["MedicationDispense"],
            expression: "MedicationDispense.status"
        }
    ],
    "USCoreEncounterIdentifier": [
        {
            name: "USCoreEncounterIdentifier",
            'type: r4:TOKEN,
            base: ["Encounter"],
            expression: "Encounter.identifier"
        }
    ],
    "USCorePractitionerIdentifier": [
        {
            name: "USCorePractitionerIdentifier",
            'type: r4:TOKEN,
            base: ["Practitioner"],
            expression: "Practitioner.identifier"
        }
    ],
    "USCorePractitionerId": [
        {
            name: "USCorePractitionerId",
            'type: r4:TOKEN,
            base: ["Practitioner"],
            expression: "Practitioner.id"
        }
    ],
    "USCoreObservationStatus": [
        {
            name: "USCoreObservationStatus",
            'type: r4:TOKEN,
            base: ["Observation"],
            expression: "Observation.status"
        }
    ],
    "USCoreServicerequestStatus": [
        {
            name: "USCoreServicerequestStatus",
            'type: r4:TOKEN,
            base: ["ServiceRequest"],
            expression: "ServiceRequest.status"
        }
    ],
    "USCoreServicerequestId": [
        {
            name: "USCoreServicerequestId",
            'type: r4:TOKEN,
            base: ["ServiceRequest"],
            expression: "ServiceRequest.id"
        }
    ],
    "USCoreDocumentreferenceStatus": [
        {
            name: "USCoreDocumentreferenceStatus",
            'type: r4:TOKEN,
            base: ["DocumentReference"],
            expression: "DocumentReference.status"
        }
    ],
    "USCorePatientFamily": [
        {
            name: "USCorePatientFamily",
            'type: r4:STRING,
            base: ["Patient"],
            expression: "Patient.name.family"
        }
    ],
    "USCoreDiagnosticreportPatient": [
        {
            name: "USCoreDiagnosticreportPatient",
            'type: r4:REFERENCE,
            base: ["DiagnosticReport"],
            expression: "DiagnosticReport.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreQuestionnaireresponseQuestionnaire": [
        {
            name: "USCoreQuestionnaireresponseQuestionnaire",
            'type: r4:REFERENCE,
            base: ["QuestionnaireResponse"],
            expression: "QuestionnaireResponse.questionnaire"
        }
    ],
    "USCoreDiagnosticreportDate": [
        {
            name: "USCoreDiagnosticreportDate",
            'type: r4:DATE,
            base: ["DiagnosticReport"],
            expression: "DiagnosticReport.effective"
        }
    ],
    "USCoreCareteamPatient": [
        {
            name: "USCoreCareteamPatient",
            'type: r4:REFERENCE,
            base: ["CareTeam"],
            expression: "CareTeam.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreEncounterPatient": [
        {
            name: "USCoreEncounterPatient",
            'type: r4:REFERENCE,
            base: ["Encounter"],
            expression: "Encounter.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreEncounterDischargeDisposition": [
        {
            name: "USCoreEncounterDischargeDisposition",
            'type: r4:TOKEN,
            base: ["Encounter"],
            expression: "Encounter.hospitalization.dischargeDisposition"
        }
    ],
    "USCoreQuestionnaireresponseId": [
        {
            name: "USCoreQuestionnaireresponseId",
            'type: r4:TOKEN,
            base: ["QuestionnaireResponse"],
            expression: "QuestionnaireResponse.id"
        }
    ],
    "USCoreDocumentreferencePatient": [
        {
            name: "USCoreDocumentreferencePatient",
            'type: r4:REFERENCE,
            base: ["DocumentReference"],
            expression: "DocumentReference.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreCareplanStatus": [
        {
            name: "USCoreCareplanStatus",
            'type: r4:TOKEN,
            base: ["CarePlan"],
            expression: "CarePlan.status"
        }
    ],
    "USCoreDeviceType": [
        {
            name: "USCoreDeviceType",
            'type: r4:TOKEN,
            base: ["Device"],
            expression: "Device.type"
        }
    ],
    "USCorePatientBirthdate": [
        {
            name: "USCorePatientBirthdate",
            'type: r4:DATE,
            base: ["Patient"],
            expression: "Patient.birthDate"
        }
    ],
    "USCoreProcedureCode": [
        {
            name: "USCoreProcedureCode",
            'type: r4:TOKEN,
            base: ["Procedure"],
            expression: "Procedure.code"
        }
    ],
    "USCoreMedicationdispensePatient": [
        {
            name: "USCoreMedicationdispensePatient",
            'type: r4:REFERENCE,
            base: ["MedicationDispense"],
            expression: "MedicationDispense.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreMedicationdispenseType": [
        {
            name: "USCoreMedicationdispenseType",
            'type: r4:TOKEN,
            base: ["MedicationDispense"],
            expression: "MedicationDispense.type"
        }
    ],
    "USCorePatientName": [
        {
            name: "USCorePatientName",
            'type: r4:STRING,
            base: ["Patient"],
            expression: "Patient.name"
        }
    ],
    "USCorePatientDeathDate": [
        {
            name: "USCorePatientDeathDate",
            'type: r4:DATE,
            base: ["Patient"],
            expression: "(Patient.deceased as dateTime)"
        }
    ],
    "USCoreDevicePatient": [
        {
            name: "USCoreDevicePatient",
            'type: r4:REFERENCE,
            base: ["Device"],
            expression: "Device.patient"
        }
    ],
    "USCoreMedicationrequestEncounter": [
        {
            name: "USCoreMedicationrequestEncounter",
            'type: r4:REFERENCE,
            base: ["MedicationRequest"],
            expression: "MedicationRequest.encounter"
        }
    ],
    "USCoreImmunizationDate": [
        {
            name: "USCoreImmunizationDate",
            'type: r4:DATE,
            base: ["Immunization"],
            expression: "Immunization.occurrence"
        }
    ],
    "USCoreDiagnosticreportStatus": [
        {
            name: "USCoreDiagnosticreportStatus",
            'type: r4:TOKEN,
            base: ["DiagnosticReport"],
            expression: "DiagnosticReport.status"
        }
    ],
    "USCorePatientGiven": [
        {
            name: "USCorePatientGiven",
            'type: r4:STRING,
            base: ["Patient"],
            expression: "Patient.name.given"
        }
    ],
    "USCorePractitionerroleSpecialty": [
        {
            name: "USCorePractitionerroleSpecialty",
            'type: r4:TOKEN,
            base: ["PractitionerRole"],
            expression: "PractitionerRole.specialty"
        }
    ],
    "USCoreConditionPatient": [
        {
            name: "USCoreConditionPatient",
            'type: r4:REFERENCE,
            base: ["Condition"],
            expression: "Condition.subject.where(resolve() is Patient)"
        }
    ],
    "USCoreLocationAddress": [
        {
            name: "USCoreLocationAddress",
            'type: r4:STRING,
            base: ["Location"],
            expression: "Location.address"
        }
    ],
    "USCoreDocumentreferenceDate": [
        {
            name: "USCoreDocumentreferenceDate",
            'type: r4:DATE,
            base: ["DocumentReference"],
            expression: "DocumentReference.date"
        }
    ]    
};
//Number of search params in USCORE_IG_SEARCH_PARAMS_2  = 6
final readonly & map<r4:FHIRSearchParameterDefinition[]> USCORE_IG_SEARCH_PARAMS_2 = {
    "USCoreEncounterDate": [
        {
            name: "USCoreEncounterDate",
            'type: r4:DATE,
            base: ["Encounter"],
            expression: "Encounter.period"
        }
    ],
    "USCoreLocationAddressCity": [
        {
            name: "USCoreLocationAddressCity",
            'type: r4:STRING,
            base: ["Location"],
            expression: "Location.address.city"
        }
    ],
    "USCoreEncounterStatus": [
        {
            name: "USCoreEncounterStatus",
            'type: r4:TOKEN,
            base: ["Encounter"],
            expression: "Encounter.status"
        }
    ],
    "USCoreCareplanDate": [
        {
            name: "USCoreCareplanDate",
            'type: r4:DATE,
            base: ["CarePlan"],
            expression: "CarePlan.period"
        }
    ],
    "USCoreServicerequestPatient": [
        {
            name: "USCoreServicerequestPatient",
            'type: r4:REFERENCE,
            base: ["ServiceRequest"],
            expression: "ServiceRequest.subject.where(resolve() is Patient)"
        }
    ],
    "USCorePatientId": [
        {
            name: "USCorePatientId",
            'type: r4:TOKEN,
            base: ["Patient"],
            expression: "Patient.id"
        }
    ]    
};

public json[] FHIR_VALUE_SETS = [];
public json[] FHIR_CODE_SYSTEMS = [];