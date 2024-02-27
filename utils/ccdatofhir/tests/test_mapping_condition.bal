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

function testCcdaDocumentToFhirCondition() returns error? {
    r4:Bundle|r4:FHIRError transformed = ccdaToFhir(ccdaDocumentValid);
    test:assertTrue(transformed is r4:Bundle, "Error occurred while transforming CCDA document to FHIR!");

    if (transformed is r4:Bundle) {
        json jsonBundle = transformed.toJson();
        json[] entries = <json[]>check jsonBundle.entry;
        json 'resource = check entries[6].'resource;
        test:assertEquals('resource.resourceType, "Condition", "Incorrect resource type from the conversion!");
        json[] conditionVerificationStatusCoding = <json[]>check entries[6].'resource.verificationStatus.coding;
        test:assertEquals(conditionVerificationStatusCoding.length(), 1, "Incorrect number of verification status codings from the conversion!");
        test:assertEquals(conditionVerificationStatusCoding[0].code, "refuted", "Incorrect clinical status from the conversion!");
        json[] conditionCategory = <json[]>check 'resource.category;
        test:assertEquals(conditionCategory.length(), 1, "Incorrect number of categories from the conversion!");
        json[] conditionCategoryCoding = <json[]>check conditionCategory[0].coding;
        test:assertEquals(conditionCategoryCoding.length(), 1, "Incorrect number of category codings from the conversion!");
        test:assertEquals(check conditionCategoryCoding[0].code, "problem-list-item", "Incorrect category code from the conversion!");
        json[] conditionIdentifier = <json[]>check 'resource.identifier;
        test:assertEquals(conditionIdentifier.length(), 1, "Incorrect number of identifiers from the conversion!");
        test:assertEquals('resource.onsetDateTime, "2022-01-01", "Incorrect onset datetime from the conversion!");
        test:assertEquals('resource.abatementDateTime, "2023-12-31", "Incorrect onset datetime from the conversion!");
    }
}

@test:Config {}
function testMapCcdatoFhirProblemStatus() returns error? {
    xml codingElement = xml `<code code="246455001" codeSystem="2.16.840.1.113883.6.96" displayName="Recurrence"/>`;
    string status = mapCcdatoFhirProblemStatus(codingElement);
    test:assertEquals(status, "recurrence", "Status is not equal to recurrence");

    codingElement = xml `<code code="263855007" codeSystem="2.16.840.1.113883.6.96" displayName="Relapse"/>`;
    status = mapCcdatoFhirProblemStatus(codingElement);
    test:assertEquals(status, "relapse", "Status is not equal to relapse");

    codingElement = xml `<code code="277022003" codeSystem="2.16.840.1.113883.6.96" displayName="Remission"/>`;
    status = mapCcdatoFhirProblemStatus(codingElement);
    test:assertEquals(status, "remission", "Status is not equal to remission");

    codingElement = xml `<code code="413322009" codeSystem="2.16.840.1.113883.6.96" displayName="Resolved"/>`;
    status = mapCcdatoFhirProblemStatus(codingElement);
    test:assertEquals(status, "resolved", "Status is not equal to resolved");

    codingElement = xml `<code code="55561003" codeSystem="2.16.840.1.113883.6.96" displayName="Active"/>`;
    status = mapCcdatoFhirProblemStatus(codingElement);
    test:assertEquals(status, "active", "Status is not equal to active");

    codingElement = xml `<code code="73425007" codeSystem="2.16.840.1.113883.6.96" displayName="Inactive"/>`;
    status = mapCcdatoFhirProblemStatus(codingElement);
    test:assertEquals(status, "inactive", "Status is not equal to inactive");

    codingElement = xml `<code code="1234567890" codeSystem="2.16.840.1.113883.6.96" displayName="Test Code"/>`;
    status = mapCcdatoFhirProblemStatus(codingElement);
    test:assertEquals(status, "active", "Status is not  equal to active");
}
