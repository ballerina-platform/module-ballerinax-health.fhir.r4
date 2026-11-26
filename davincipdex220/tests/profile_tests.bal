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

import ballerina/io;
import ballerina/test;
import ballerinax/health.fhir.r4;

const RESOURCES_DIR = "tests/resources/";

isolated function loadExample(string fileName) returns json|error {
    return io:fileReadJson(RESOURCES_DIR + fileName);
}

@test:Config {}
function testPriorAuthorization() returns error? {
    PdexPriorAuthorization eob = check (check loadExample("ExplanationOfBenefit-PDexPriorAuth1.json")).cloneWithType();
    test:assertEquals(eob.resourceType, "ExplanationOfBenefit");
}

@test:Config {}
function testProviderMultiMemberMatchRequest() returns error? {
    ProviderMultiMemberMatchRequestParameters p = check (check loadExample("Parameters-provider-member-match-request-001.json")).cloneWithType();
    test:assertTrue(p.'parameter.length() > 0);
}

@test:Config {}
function testProviderMultiMemberMatchResponse() returns error? {
    ProviderMultiMemberMatchResponseParameters p = check (check loadExample("Parameters-provider-member-match-response-001.json")).cloneWithType();
    test:assertTrue(p.'parameter.length() > 0);
}

@test:Config {}
function testPdexDevice() returns error? {
    PdexDevice d = check (check loadExample("Device-543210.json")).cloneWithType();
    test:assertEquals(d.resourceType, "Device");
}

@test:Config {}
function testPdexMedicationDispense() returns error? {
    PdexMedicationDispense m = check (check loadExample("MedicationDispense-1000001.json")).cloneWithType();
    test:assertEquals(m.resourceType, "MedicationDispense");
}

@test:Config {}
function testMtlsEndpoint() returns error? {
    MtlsEndpoint e = check (check loadExample("Endpoint-diamond-mtls-endpoint1.json")).cloneWithType();
    test:assertEquals(e.resourceType, "Endpoint");
}

@test:Config {}
function testMtlsOrganization() returns error? {
    MtlsOrganization o = check (check loadExample("Organization-DiamondOnyxHealth1.json")).cloneWithType();
    test:assertEquals(o.resourceType, "Organization");
}

@test:Config {}
function testPDexMemberMatchGroup() returns error? {
    PDexMemberMatchGroup g = check (check loadExample("Group-07e72a15407547bf9d03f522aa536a72.1.json")).cloneWithType();
    test:assertEquals(g.resourceType, "Group");
}

@test:Config {}
function testPDexMemberNoMatchGroup() returns error? {
    PDexMemberNoMatchGroup g = check (check loadExample("Group-example-pdex-member-no-match-group.json")).cloneWithType();
    test:assertEquals(g.resourceType, "Group");
}

@test:Config {}
function testPDexProviderGroup() returns error? {
    PDexProviderGroup g = check (check loadExample("Group-Example-PDex-Provider-Group.json")).cloneWithType();
    test:assertEquals(g.resourceType, "Group");
}

@test:Config {}
function testMemberProviderTreatmentRelationship() returns error? {
    MemberProviderTreatmentRelationship g = check (check loadExample("Group-example-pdex-treatment-relationship-group.json")).cloneWithType();
    test:assertEquals(g.resourceType, "Group");
}

@test:Config {}
function testProviderMemberMatchGroup() returns error? {
    ProviderMemberMatchGroup g = check (check loadExample("Group-example-provider-matched-group.json")).cloneWithType();
    test:assertEquals(g.resourceType, "Group");
}

@test:Config {}
function testProviderMemberNoMatchGroup() returns error? {
    ProviderMemberNoMatchGroup g = check (check loadExample("Group-example-provider-nomatch-group.json")).cloneWithType();
    test:assertEquals(g.resourceType, "Group");
}

@test:Config {}
function testMemberOptOut() returns error? {
    MemberOptOut g = check (check loadExample("Group-member-opt-out-group-001.json")).cloneWithType();
    test:assertEquals(g.resourceType, "Group");
}

@test:Config {}
function testProviderTreatmentAttestation() returns error? {
    ProviderTreatmentAttestation c = check (check loadExample("Consent-provider-treatment-attestation-1.json")).cloneWithType();
    test:assertEquals(c.resourceType, "Consent");
}

@test:Config {}
function testPDexProviderSharingConsent() returns error? {
    PDexProviderSharingConsent c = check (check loadExample("Consent-consent-permit-1.json")).cloneWithType();
    test:assertEquals(c.resourceType, "Consent");
}

@test:Config {}
function testProvenance() returns error? {
    Provenance p = check (check loadExample("Provenance-1000001.json")).cloneWithType();
    test:assertEquals(p.resourceType, "Provenance");
}

@test:Config {}
function testProfilesRegistered() {
    string base = "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/";
    map<string[]> expected = {
        "Group": ["pdex-member-match-group", "pdex-member-no-match-group", "pdex-provider-group",
            "pdex-treatment-relationship", "pdex-provider-member-match", "pdex-provider-member-no-match",
            "pdex-member-opt-out"],
        "Parameters": ["pdex-parameters-multi-member-match-bundle-in", "pdex-parameters-multi-member-match-bundle-out",
            "provider-parameters-multi-member-match-bundle-in", "provider-parameters-multi-member-match-bundle-out"],
        "Consent": ["pdex-provider-consent", "provider-treatment-relationship-consent"],
        "ExplanationOfBenefit": ["pdex-priorauthorization"],
        "Device": ["pdex-device"],
        "MedicationDispense": ["pdex-medicationdispense"],
        "Endpoint": ["mtls-endpoint"],
        "Organization": ["mtls-organization"],
        "Provenance": ["pdex-provenance"]
    };
    foreach [string, string[]] [resourceType, ids] in expected.entries() {
        map<r4:Profile & readonly> profiles = fhirRegistry.getResourceProfiles(resourceType);
        foreach string id in ids {
            test:assertTrue(profiles.hasKey(base + id), string `${resourceType} profile not registered: ${id}`);
        }
    }
}
