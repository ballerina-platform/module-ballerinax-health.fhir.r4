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

import ballerinax/health.fhir.r4.uscore501;
import ballerinax/health.fhir.r4;
# ####################################################################################################
# Mapping function definitions for C-CDA to FHIR
# ####################################################################################################

# Mapping function type for C-CDA Allergy Intolerance Activity to USCore Allergy Intolerance FHIR resource.
public type CcdaToAllergyIntolerance isolated function (xml document, xml parentDocument) returns [uscore501:USCoreAllergyIntolerance, uscore501:USCoreProvenance?]?;

# Mapping function type for C-CDA Immunization Activity to USCore Immunization FHIR resource.
public type CcdaToImmunization isolated function (xml document, xml parentDocument) returns uscore501:USCoreImmunizationProfile?;

# Mapping function type for C-CDA Medication Activity to USCore Medication FHIR resource.
public type CcdaToMedication isolated function (xml document, xml parentDocument) returns uscore501:USCoreMedicationRequestProfile?;

# Mapping function type for C-CDA US Realm Record Target to USCore Patient FHIR resource.
public type CcdaToPatient isolated function (xml document, xml parentDocument) returns uscore501:USCorePatientProfile?;

# Mapping function type for C-CDA Problem Concern Activity to USCore Condition FHIR resource.
public type CcdaToCondition isolated function (xml sectionDocument, xml document, xml parentDocument) returns uscore501:USCoreCondition?;

# Mapping function type for C-CDA Procedure Acitivity to USCore Procedure FHIR resource.
public type CcdaToProcedure isolated function (xml document, xml parentDocument) returns uscore501:USCoreProcedureProfile?;

# Mapping function type for C-CDA Diagnostic Imaging Report to USCore DiagnosticReport FHIR resource.
public type CcdaToDiagnosticReport isolated function (xml document, xml parentDocument) returns uscore501:USCoreDiagnosticReportProfileLaboratoryReporting?;

# Mapping function type for C-CDA Encounter Activity to USCore Encounter FHIR resource.
public type CcdaToEncounter isolated function (xml document, xml parentDocument) returns r4:Resource[];

# Mapping function type for C-CDA Author Header to USCore Practitioner FHIR resource.
public type CcdaToPractitioner isolated function (xml document, xml parentDocument) returns uscore501:USCorePractitionerProfile?;

# Mapping function type for C-CDA Document Reference Activity to USCore DocumentReference FHIR resource.
public type CcdaToDocumentReference isolated function (xml document, xml parentDocument) returns uscore501:USCoreDocumentReferenceProfile?;

# CcdaToFhir Mapper function implementation holder record.
#
# + ccdaToAllergyIntolerance - C-CDA Allergy Intolerance Activity to USCore Allergy Intolerance function.
# + ccdaToImmunization - C-CDA Immunization Activity to USCore Immunization function.
# + ccdaToMedication - C-CDA Medication Activity to USCore Medication function.
# + ccdaToPatient - C-CDA US Realm Record Target to USCore Patient function.
# + ccdaToCondition - C-CDA Problem Concern Activity to USCore Condition function.
# + ccdaToProcedure - C-CDA Procedure Acitivity to USCore Procedure function.
# + ccdaToDiagnosticReport - C-CDA Diagnostic Imaging Report to USCore DiagnosticReport function.
# + ccdaToPractitioner - C-CDA Author Header to USCore Practitioner function
# + ccdaToEncounter - C-CDA Encounter Activity to USCore Encounter function
# + ccdaToDocumentReference - C-CDA Document Reference Activity to USCore DocumentReference function
public type CcdaToFhirMapper record {
    CcdaToAllergyIntolerance ccdaToAllergyIntolerance;
    CcdaToImmunization ccdaToImmunization;
    CcdaToMedication ccdaToMedication;
    CcdaToPatient ccdaToPatient;
    CcdaToCondition ccdaToCondition;
    CcdaToProcedure ccdaToProcedure;
    CcdaToDiagnosticReport ccdaToDiagnosticReport;
    CcdaToPractitioner ccdaToPractitioner;
    CcdaToEncounter ccdaToEncounter;
    CcdaToDocumentReference ccdaToDocumentReference;
};

// Record initialized with the default mapping functions.
final readonly & CcdaToFhirMapper defaultMapper = {
    ccdaToAllergyIntolerance,
    ccdaToImmunization,
    ccdaToMedication,
    ccdaToPatient,
    ccdaToCondition,
    ccdaToProcedure,
    ccdaToDiagnosticReport,
    ccdaToPractitioner,
    ccdaToEncounter,
    ccdaToDocumentReference
};

