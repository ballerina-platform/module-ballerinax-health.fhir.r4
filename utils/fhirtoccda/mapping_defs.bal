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

import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

# ####################################################################################################
# Mapping function definitions for FHIR to C-CDA
# ####################################################################################################

# Mapping function type for FHIR USCore Patient to C-CDA PatientRole.
public type FhirToPatient isolated function (uscore501:USCorePatientProfile patient, r4:Resource[] allResources) returns RecordTarget?;

# Mapping function type for FHIR USCore Practitioner to C-CDA Author.
public type FhirToPractitioner isolated function (uscore501:USCorePractitionerProfile practitioner, r4:Resource[] allResources) returns Author?;

# Mapping function type for FHIR USCore AllergyIntolerance to C-CDA Allergy Activity.
public type FhirToAllergyIntolerance isolated function (uscore501:USCoreAllergyIntolerance allergy, r4:Resource[] allResources) returns Act?;

# Mapping function type for FHIR USCore Condition to C-CDA Problem Concern Activity.
public type FhirToCondition isolated function (uscore501:USCoreCondition condition, r4:Resource[] allResources) returns Act?;

# Mapping function type for FHIR USCore Immunization to C-CDA Immunization Activity.
public type FhirToImmunization isolated function (uscore501:USCoreImmunizationProfile immunization, r4:Resource[] allResources) returns SubstanceAdministration?;

# Mapping function type for FHIR USCore MedicationRequest to C-CDA Medication Activity.
public type FhirToMedication isolated function (uscore501:USCoreMedicationRequestProfile medication, r4:Resource[] allResources) returns SubstanceAdministration?;

# Mapping function type for FHIR USCore Procedure to C-CDA Procedure Activity.
public type FhirToProcedure isolated function (uscore501:USCoreProcedureProfile procedure, r4:Resource[] allResources) returns Procedure?;

# Mapping function type for FHIR USCore DiagnosticReport to C-CDA Diagnostic Imaging Report.
public type FhirToDiagnosticReport isolated function (uscore501:USCoreDiagnosticReportProfileLaboratoryReporting diagnosticReport, r4:Resource[] allResources) returns Organizer?;

# Mapping function type for FHIR USCore Encounter to C-CDA Encounter Activity.
public type FhirToEncounter isolated function (uscore501:USCoreEncounterProfile encounter, r4:Resource[] allResources) returns Encounter?;

# Mapping function type for FHIR USCore DocumentReference to C-CDA Document Reference Activity.
public type FhirToDocumentReference isolated function (uscore501:USCoreDocumentReferenceProfile documentReference, r4:Resource[] allResources) returns Act?;

# FhirToCcda Mapper function implementation holder record.
#
# + fhirToPatient - FHIR USCore Patient to C-CDA PatientRole function.
# + fhirToPractitioner - FHIR USCore Practitioner to C-CDA Author function.
# + fhirToAllergyIntolerance - FHIR USCore AllergyIntolerance to C-CDA Allergy Activity function.
# + fhirToCondition - FHIR USCore Condition to C-CDA Problem Concern Activity function.
# + fhirToImmunization - FHIR USCore Immunization to C-CDA Immunization Activity function.
# + fhirToMedication - FHIR USCore MedicationRequest to C-CDA Medication Activity function.
# + fhirToProcedure - FHIR USCore Procedure to C-CDA Procedure Activity function.
# + fhirToDiagnosticReport - FHIR USCore DiagnosticReport to C-CDA Diagnostic Imaging Report function.
# + fhirToEncounter - FHIR USCore Encounter to C-CDA Encounter Activity function.
# + fhirToDocumentReference - FHIR USCore DocumentReference to C-CDA Document Reference Activity function.
public type FhirToCcdaMapper record {
    FhirToPatient fhirToPatient;
    FhirToPractitioner fhirToPractitioner;
    FhirToAllergyIntolerance fhirToAllergyIntolerance;
    FhirToCondition fhirToCondition;
    FhirToImmunization fhirToImmunization;
    FhirToMedication fhirToMedication;
    FhirToProcedure fhirToProcedure;
    FhirToDiagnosticReport fhirToDiagnosticReport;
    FhirToEncounter fhirToEncounter;
    FhirToDocumentReference fhirToDocumentReference;
};

// Record initialized with the default mapping functions.
final readonly & FhirToCcdaMapper defaultMapper = {
    fhirToPatient,
    fhirToPractitioner,
    fhirToAllergyIntolerance,
    fhirToCondition,
    fhirToImmunization,
    fhirToMedication,
    fhirToProcedure,
    fhirToDiagnosticReport,
    fhirToEncounter,
    fhirToDocumentReference
}; 