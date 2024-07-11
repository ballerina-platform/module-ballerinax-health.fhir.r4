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

//Number of search params in AUCOREIMPLEMENTATIONGUIDE_IG_SEARCH_PARAMS_1  = 2
final readonly & map<r4:FHIRSearchParameterDefinition[]> AUCOREIMPLEMENTATIONGUIDE_IG_SEARCH_PARAMS_1 = {
    "AUCorePractitionerRolePractitioner": [
        {
            name: "AUCorePractitionerRolePractitioner",
            'type: r4:REFERENCE,
            base: ["PractitionerRole"],
            expression: "PractitionerRole.practitioner"
        }
    ],
    "AUCoreClinicalPatient": [
        {
            name: "AUCoreClinicalPatient",
            'type: r4:REFERENCE,
            base: ["AllergyIntolerance","Condition","Encounter","Immunization","MedicationRequest","Observation","Procedure"],
            expression: "AllergyIntolerance.patient | CarePlan.subject.where(resolve() is Patient) | CareTeam.subject.where(resolve() is Patient) | ClinicalImpression.subject.where(resolve() is Patient) | Composition.subject.where(resolve() is Patient) | Condition.subject.where(resolve() is Patient) | Consent.patient | DetectedIssue.patient | DeviceRequest.subject.where(resolve() is Patient) | DeviceUseStatement.subject | DiagnosticReport.subject.where(resolve() is Patient) | DocumentManifest.subject.where(resolve() is Patient) | DocumentReference.subject.where(resolve() is Patient) | Encounter.subject.where(resolve() is Patient) | EpisodeOfCare.patient | FamilyMemberHistory.patient | Flag.subject.where(resolve() is Patient) | Goal.subject.where(resolve() is Patient) | ImagingStudy.subject.where(resolve() is Patient) | Immunization.patient | List.subject.where(resolve() is Patient) | MedicationAdministration.subject.where(resolve() is Patient) | MedicationDispense.subject.where(resolve() is Patient) | MedicationRequest.subject.where(resolve() is Patient) | MedicationStatement.subject.where(resolve() is Patient) | NutritionOrder.patient | Observation.subject.where(resolve() is Patient) | Procedure.subject.where(resolve() is Patient) | RiskAssessment.subject.where(resolve() is Patient) | ServiceRequest.subject.where(resolve() is Patient) | SupplyDelivery.patient | VisionPrescription.patient"
        }
    ]    
};

public json[] FHIR_VALUE_SETS = [];
public json[] FHIR_CODE_SYSTEMS = [];
