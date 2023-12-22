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
import ballerinax/health.fhir.r4.uscore501;

function testCcdaDocumentToFhirProcedure() returns error? {
    r4:Bundle|r4:FHIRError transformed = ccdaToFhir(ccdaDocumentValid);
    test:assertTrue(transformed is r4:Bundle, "Error occurred while transforming CCDA document to FHIR!");

    if (transformed is r4:Bundle) {
        json jsonBundle = transformed.toJson();
        json[] entries = <json[]>check jsonBundle.entry;
        json 'resource = check entries[5].'resource;
        test:assertEquals('resource.resourceType, "Procedure", "Incorrect resource type from the conversion!");
        test:assertEquals('resource.status, "not-done", "Incorrect status from the conversion!");
        test:assertEquals('resource.resourceType, "Procedure", "Incorrect resource type from the conversion!");
        test:assertEquals('resource.status, "in-progress", "Incorrect status from the conversion!");
        test:assertEquals('resource.performedDateTime, "2021-05-31", "Incorrect performed date from the conversion!");
    }
}

@test:Config {}
function testMapCcdatoFhirProcedureStatus() returns error? {
    xml codingElement = xml `<code code="aborted"/>`;
    uscore501:USCoreProcedureProfileStatus status = mapCcdatoFhirProcedureStatus(codingElement);
    test:assertEquals(status, "stopped", "Status is not equal to stopped");

    codingElement = xml `<code code="active"/>`;
    status = mapCcdatoFhirProcedureStatus(codingElement);
    test:assertEquals(status, "in-progress", "Status is not equal to in-progress");

    codingElement = xml `<code code="cancelled"/>`;
    status = mapCcdatoFhirProcedureStatus(codingElement);
    test:assertEquals(status, "not-done", "Status is not equal to not-done");

    codingElement = xml `<code code="completed"/>`;
    status = mapCcdatoFhirProcedureStatus(codingElement);
    test:assertEquals(status, "completed", "Status is not equal to completed");

    codingElement = xml `<code code="unknown"/>`;
    status = mapCcdatoFhirProcedureStatus(codingElement);
    test:assertEquals(status, "not-done", "Status is not equal to not-done");
}
