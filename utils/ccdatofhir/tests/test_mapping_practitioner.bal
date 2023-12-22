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
function testCcdaToPractitioner() returns error? {
    r4:Bundle|r4:FHIRError transformed = ccdaToFhir(ccdaDocumentValid);
    test:assertTrue(transformed is r4:Bundle, "Error occurred while transforming CCDA document to FHIR!");

    if (transformed is r4:Bundle) {
        json jsonBundle = transformed.toJson();
        json[] entries = <json[]>check jsonBundle.entry;
        json 'resource = check entries[1].'resource;
        test:assertEquals('resource.resourceType, "Practitioner", "Incorrect resource type from the conversion!");
        
        json[] qualifications = <json[]>check 'resource.qualification;
        json[] codings = <json[]>check qualifications[0].code.coding;
        test:assertEquals(codings.length(), 1, "Incorrect number of codings from the conversion!");
        test:assertEquals(check codings[0].code, "200000000X", "Incorrect code from the conversion!");
        test:assertEquals(check codings[0].display, "Allopathic & Osteopathic Physicians", "Incorrect display from the conversion!");
        test:assertEquals(check codings[0].system, "urn:oid:2.16.840.1.113883.6.101", "Incorrect system from the conversion!");

        json[] names = <json[]>check 'resource.name;
        json[] nameOneGiven = <json[]>check names[0].given;
        test:assertEquals(nameOneGiven[0], "Orthopedic", "Incorrect given name from the conversion!");
        test:assertEquals(names[0].family, "Surgery", "Incorrect family name from the conversion!");
    }
}
