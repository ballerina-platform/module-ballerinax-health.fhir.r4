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
import ballerina/log;

const FHIR_IG = "medcom240";

# Initializer for the module
# + return - returns error if error occurred
function init() returns r4:FHIRError? {
    // Anything to initialize should happen here here

    //update terminology processor
    // TODO: https://github.com/wso2-enterprise/open-healthcare/issues/1047
    r4:InMemoryTerminologyLoader terminologyLoader = new(FHIR_CODE_SYSTEMS, FHIR_VALUE_SETS);
    r4:Terminology terminology = check terminologyLoader.load();

    readonly & r4:IGInfoRecord baseIgRecord = {
        title: "medcom240",
        name: "medcom240",
        terminology: terminology,
        profiles: {
            "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-media": {
                url: "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-media",
                resourceType: "Media",
                modelType: MedComCoreMedia
            },
            "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-practitionerrole": {
                url: "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-practitionerrole",
                resourceType: "PractitionerRole",
                modelType: MedComCorePractitionerRole
            },
            "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-careteam": {
                url: "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-careteam",
                resourceType: "CareTeam",
                modelType: MedComCoreCareTeam
            },
            "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-diagnosticreport": {
                url: "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-diagnosticreport",
                resourceType: "DiagnosticReport",
                modelType: MedComCoreDiagnosticReport
            },
            "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-patient": {
                url: "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-patient",
                resourceType: "Patient",
                modelType: MedComCorePatient
            },
            "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-practitioner": {
                url: "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-practitioner",
                resourceType: "Practitioner",
                modelType: MedComCorePractitioner
            },
            "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-encounter": {
                url: "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-encounter",
                resourceType: "Encounter",
                modelType: MedComCoreEncounter
            },
            "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-organization": {
                url: "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-organization",
                resourceType: "Organization",
                modelType: MedComCoreOrganization
            },
            "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-observation": {
                url: "http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-observation",
                resourceType: "Observation",
                modelType: MedComCoreObservation
            }
        },
        searchParameters: [MEDCOMCORE_IG_SEARCH_PARAMS_1]
    };
    r4:FHIRImplementationGuide baseImplementationGuide = new(baseIgRecord);
    check fhirRegistry.addImplementationGuide(baseImplementationGuide);

    log:printDebug("FHIR R4 MedComCore Module initialized.");
}

# This empty function is used to initialize the module by other modules/packages.
public isolated function initialize() {};
