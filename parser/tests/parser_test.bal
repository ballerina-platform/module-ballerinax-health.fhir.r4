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

import ballerina/log;
import ballerina/test;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;

// Test functions
@test:Config {}
function parseWithoutModelTest() returns r4:FHIRParseError? {
    international401:Patient pat = <international401:Patient>check parse(TEST_FHIR_RESOURCE_JSON_PATIENT_01);
    test:assertEquals(pat.id, "123344", "Mismatching patient ID");
}

@test:Config {}
function parseByGivenModelTest() returns r4:FHIRParseError? {
    international401:Patient pat = <international401:Patient>check parse(TEST_FHIR_RESOURCE_JSON_PATIENT_01, international401:Patient);
    log:printDebug(string `Parsed patient: ${pat.toBalString()}`);
    test:assertEquals(pat.id, "123344", "Mismatching patient ID");
}

@test:Config {}
function parseInvalidResourceTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_JSON_INVALID_PATIENT_01, international401:Patient);
    if pat is r4:FHIRParseError {
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
        test:assertEquals(errorDetail.internalError, false, "Error should not be an internal error");
        test:assertNotEquals(errorDetail.uuid, null, "Error UUID must present");
        error err = pat.cause() ?: error("");
        test:assertEquals(err.message(), "{ballerina/lang.value}ConversionError", "Mismatching error detail");
    } else {
        test:assertFail("Expect to fail since malformed FHIR resource payload");
    }
}
