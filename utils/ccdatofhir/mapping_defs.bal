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

import ballerinax/health.fhir.r4;


public type CcdaAllergyToFhir isolated function (xml actElement) returns r4:AllergyIntolerance?;

public type CcdaConditionToFhir isolated function (xml actElement) returns r4:Condition?;

public type CcdaDiagnosticReportToFhir isolated function (xml organizerElement) returns r4:DiagnosticReport?;

public type CcdaImmunizationToFhir isolated function (xml substanceAdministrationElement) returns r4:Immunization?;

public type CcdaMedicationToFhir isolated function (xml substanceAdministrationElement) returns r4:MedicationRequest?;

public type CcdaPatientToFhir isolated function (xml xmlContent, boolean isNamespaceAvailable = true) returns r4:Patient?;

public type CcdaPractitionerToFhir isolated function (xml authorElement) returns r4:Practitioner?;

public type CcdaProcedureToFhir isolated function (xml actElement) returns r4:Procedure?;

public type CCDAtoFhirMapper record {
    CcdaAllergyToFhir ccdaAllergyToFhir?;
    CcdaConditionToFhir ccdaConditionToFhir?;
    CcdaDiagnosticReportToFhir ccdaDiagnosticReportToFhir?;
    CcdaImmunizationToFhir ccdaImmunizationToFhir?;
    CcdaMedicationToFhir ccdaMedicationToFhir?;
    CcdaPatientToFhir ccdaPatientToFhir?;
    CcdaPractitionerToFhir ccdaPractitionerToFhir?;
    CcdaProcedureToFhir ccdaProcedureToFhir?;
};

public final readonly & CCDAtoFhirMapper defaultMapper = {
    ccdaAllergyToFhir : mapCcdaAllergyToFhir,
    ccdaConditionToFhir: mapCcdaConditionToFhir,
    ccdaDiagnosticReportToFhir: mapCcdaDiagnosticReportToFhir,
    ccdaImmunizationToFhir: mapCcdaImmunizationToFhir,
    ccdaMedicationToFhir: mapCcdaMedicationToFhir,
    ccdaPatientToFhir: mapCcdaPatientToFhir,
    ccdaPractitionerToFhir: mapCcdaPractitionerToFhir,
    ccdaProcedureToFhir: mapCcdaProcedureToFhir
};
