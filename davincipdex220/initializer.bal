// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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
import ballerina/log;

const FHIR_IG = "davincipdex220";

# Initializer for the module
# + return - returns error if error occurred
function init() returns r4:FHIRError? {
    r4:InMemoryTerminologyLoader terminologyLoader = new (FHIR_CODE_SYSTEMS, FHIR_VALUE_SETS);
    r4:Terminology terminology = check terminologyLoader.load();

    readonly & r4:IGInfoRecord baseIgRecord = {
        title: "davincipdex220",
        name: "davincipdex220",
        terminology: terminology,
        profiles: {
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-in": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-in",
                resourceType: "Parameters",
                modelType: PDexMultiMemberMatchRequestParameters
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-out": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-out",
                resourceType: "Parameters",
                modelType: PDexMultiMemberMatchResponseParameters
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provenance": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provenance",
                resourceType: "Provenance",
                modelType: Provenance
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/provider-parameters-multi-member-match-bundle-out": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/provider-parameters-multi-member-match-bundle-out",
                resourceType: "Parameters",
                modelType: ProviderMultiMemberMatchResponseParameters
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/mtls-organization": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/mtls-organization",
                resourceType: "Organization",
                modelType: MtlsOrganization
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/provider-treatment-relationship-consent": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/provider-treatment-relationship-consent",
                resourceType: "Consent",
                modelType: ProviderTreatmentAttestation
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provider-group": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provider-group",
                resourceType: "Group",
                modelType: PDexProviderGroup
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/mtls-endpoint": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/mtls-endpoint",
                resourceType: "Endpoint",
                modelType: MtlsEndpoint
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-member-no-match-group": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-member-no-match-group",
                resourceType: "Group",
                modelType: PDexMemberNoMatchGroup
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provider-member-match": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provider-member-match",
                resourceType: "Group",
                modelType: ProviderMemberMatchGroup
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provider-member-no-match": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provider-member-no-match",
                resourceType: "Group",
                modelType: ProviderMemberNoMatchGroup
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provider-consent": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provider-consent",
                resourceType: "Consent",
                modelType: PDexProviderSharingConsent
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-treatment-relationship": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-treatment-relationship",
                resourceType: "Group",
                modelType: MemberProviderTreatmentRelationship
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-priorauthorization": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-priorauthorization",
                resourceType: "ExplanationOfBenefit",
                modelType: PdexPriorAuthorization
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-member-opt-out": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-member-opt-out",
                resourceType: "Group",
                modelType: MemberOptOut
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/provider-parameters-multi-member-match-bundle-in": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/provider-parameters-multi-member-match-bundle-in",
                resourceType: "Parameters",
                modelType: ProviderMultiMemberMatchRequestParameters
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-device": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-device",
                resourceType: "Device",
                modelType: PdexDevice
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-member-match-group": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-member-match-group",
                resourceType: "Group",
                modelType: PDexMemberMatchGroup
            },
            "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-medicationdispense": {
                url: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-medicationdispense",
                resourceType: "MedicationDispense",
                modelType: PdexMedicationDispense
            }
        },
        searchParameters: [DAVINCIPDEX_IG_SEARCH_PARAMS_1],
        operations: DAVINCIPDEX_IG_OPERATIONS.cloneReadOnly()
    };
    r4:FHIRImplementationGuide baseImplementationGuide = new (baseIgRecord);
    check fhirRegistry.addImplementationGuide(baseImplementationGuide);

    log:printDebug("FHIR R4 DaVinci PDex Module initialized.");
}

# This empty function is used to initialize the module by other modules/packages.
public isolated function initialize() {};
