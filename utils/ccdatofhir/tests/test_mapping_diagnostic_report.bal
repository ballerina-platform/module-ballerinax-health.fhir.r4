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

import ballerina/test;
import ballerinax/health.fhir.r4;

@test:Config {}
function testCcdaToDiagnosticReport() returns error? {
    r4:Bundle|r4:FHIRError transformed = ccdaToFhir(ccdaDocumentValid);
    test:assertTrue(transformed is r4:Bundle, "Error occurred while transforming CCDA document to FHIR!");

    if (transformed is r4:Bundle) {
        json jsonBundle = transformed.toJson();
        json[] entries = <json[]>check jsonBundle.entry;
        json 'resource = check entries[8].'resource;
        test:assertEquals('resource.resourceType, "DiagnosticReport", "Incorrect resource type from the conversion!");
        test:assertEquals('resource.status, "partial", "Incorrect status from the conversion!");
        json[] codings = <json[]> check 'resource.code.coding;
        test:assertEquals(codings[0].code, "166312007", "Incorrect code from the conversion!");
        test:assertEquals(codings[0].display, "Blood chemistry test", "Incorrect display from the conversion!");
        test:assertEquals(codings[0].system, "http://snomed.info/sct", "Incorrect system from the conversion!");
        json[] identifiers = <json[]> check 'resource.identifier;
        test:assertEquals(identifiers[0].system, "urn:ietf:rfc:3986", "Incorrect system from the conversion!");
        test:assertEquals(identifiers[0].value, "urn:oid:122ed3ae-6d9e-43d0-bfa2-434ea34b1426", "Incorrect value from the conversion!");
        test:assertEquals('resource.effectivePeriod.'start, "2008-03-20T09:30-08:00", "Incorrect issued date from the conversion!");
        test:assertEquals('resource.effectivePeriod.end, "2008-03-20T09:30-08:00", "Incorrect issued date from the conversion!");
    }
}
