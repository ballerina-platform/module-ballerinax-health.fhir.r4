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
function parseFHIRJsonTest() returns r4:FHIRParseError? {
    international401:Patient pat = <international401:Patient>check parse(TEST_FHIR_RESOURCE_JSON_PATIENT_01);
    test:assertEquals(pat.id, "123344", "Mismatching patient ID");
    test:assertEquals(pat.gender, "male", "Mismatching patient gender");
    test:assertEquals(pat.birthDate, "1974-12-25", "Mismatching patient birth date");
}

@test:Config {}
function parseFHIRJsonWithoutProfileURLTest() returns r4:FHIRParseError? {
    international401:Patient pat = <international401:Patient>check parse(TEST_FHIR_RESOURCE_JSON_PATIENT_WITHOUT_PROFILE);
    test:assertEquals(pat.id, "123344", "Mismatching patient ID");
    test:assertEquals(pat.gender, "male", "Mismatching patient gender");
    test:assertEquals(pat.birthDate, "1974-12-25", "Mismatching patient birth date");
}

@test:Config {}
function parseFHIRJsonWithTargetProfileTest() returns r4:FHIRParseError? {
    international401:Patient pat = <international401:Patient>check parse(TEST_FHIR_RESOURCE_JSON_PATIENT_01, targetProfile = "http://hl7.org/fhir/StructureDefinition/Patient");
    test:assertEquals(pat.id, "123344", "Mismatching patient ID");
    test:assertEquals(pat.gender, "male", "Mismatching patient gender");
    test:assertEquals(pat.birthDate, "1974-12-25", "Mismatching patient birth date");
}

@test:Config {}
function parseFHIRJsonWithInvalidTargetProfileTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_JSON_PATIENT_01, targetProfile = "http://hl7.org/fhir/StructureDefinition/ABCPatient");
    if pat is r4:FHIRParseError {
        test:assertEquals(pat.message(), "Failed to find FHIR profile for the resource type : Patient", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since targetProfile is unsupported");
    }
}

@test:Config {}
function parseFHIRJsonWithInvalidResourceTypeTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_JSON_INVALID_TYPE, targetFHIRModelType = international401:Patient);
    if pat is r4:FHIRParseError {
        test:assertEquals(pat.message(), "Failed to find FHIR profile for the resource type : ABCDPatient", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since the FHIR resource has an invalid resource type");
    }
}

@test:Config {}
function parseFHIRJsonWithInvalidTargetModelTypeTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_JSON_PATIENT_01, targetFHIRModelType = anydata);
    if pat is r4:FHIRParseError {
        test:assertEquals(pat.message(), "Provided type does not represent a FHIR resource", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since the FHIR resource has an invalid resource type");
    }
}

@test:Config {}
function parseFHIRJsonWithInvalidResourceTypeAndWithoutAProfileTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_JSON_INVALID_TYPE_WITHOUT_PROFILE, targetFHIRModelType = international401:Patient);
    if pat is r4:FHIRParseError {
        test:assertEquals(pat.message(), "Failed to find FHIR profile for the resource type : ABCDPatient", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since the FHIR resource has an invalid resource type and does not contain a profile");
    }
}

@test:Config {}
function parseFHIRJsonStringTest() returns r4:FHIRParseError? {
    international401:Patient pat = <international401:Patient>check parse(TEST_FHIR_RESOURCE_JSON_PATIENT_01_STRING);
    test:assertEquals(pat.id, "123344", "Mismatching patient ID");
    test:assertEquals(pat.gender, "male", "Mismatching patient gender");
    test:assertEquals(pat.birthDate, "1974-12-25", "Mismatching patient birth date");
}

@test:Config {}
function parseFHIRXmlTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_XML_PATIENT_01);
    if pat is r4:FHIRParseError {
        test:assertEquals(pat.message(), "XML format of FHIR resources not supported yet", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 501, "Error status code must be 501");
    } else {
        test:assertFail("Expect to fail since FHIR XML is not supported yet");
    }
}

@test:Config {}
function parseFHIRXmlStringTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_XML_PATIENT_01_STRING);
    if pat is r4:FHIRParseError {
        test:assertEquals(pat.message(), "XML format of FHIR resources not supported yet", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 501, "Error status code must be 501");
    } else {
        test:assertFail("Expect to fail since FHIR XML is not supported yet");
    }
}

@test:Config {}
function parseUnsupportedStringTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_UNSUPPORTED_STRING);
    if pat is r4:FHIRParseError {
        test:assertEquals(pat.message(), "Failed to parse string payload to json or xml", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since FHIR cannot be represented in text");
    }
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

@test:Config {}
function parseAResourceWithInvalidProfileTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_JSON_INVALID_PROFILE);
    if pat is r4:FHIRParseError {
        test:assertEquals(pat.message(), "Failed to find FHIR profile for the profile URL : http://hl7.org/fhir/StructureDefinition/ABCDPatient", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since an invalid FHIR profile url is present in the resource and nor target profile was given");
    }
}

@test:Config {}
function parseAResourceWithNoProfileAndUnknownResourceTest() {
    anydata|r4:FHIRParseError pat = parse(TEST_FHIR_RESOURCE_JSON_WITH_NO_PROFILE_UNKNOWN_RESOURCE_TYPE);
    if pat is r4:FHIRParseError {
        test:assertEquals(pat.message(), "Failed to find FHIR profile for the resource type : ABCDPatient", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since FHIR cannot be represented in text");
    }
}

@test:Config {}
function parseAndValidateTest() returns r4:FHIRParseError|r4:FHIRValidationError? {
    r4:ResourceAPIConfig apiConfig = {
        resourceType: "Patient",
        operations: [],
        authzConfig: (),
        profiles: ["http://hl7.org/fhir/StructureDefinition/Patient"],
        defaultProfile: (),
        searchParameters: [],
        serverConfig: ()
    };
    international401:Patient pat = <international401:Patient>check validateAndParse(TEST_FHIR_RESOURCE_JSON_PATIENT_01, apiConfig);
    test:assertEquals(pat.id, "123344", "Mismatching patient ID");
}

@test:Config {}
function parseAndValidateWithInvalidProfileTest() returns r4:FHIRParseError|r4:FHIRValidationError? {
    r4:ResourceAPIConfig apiConfig = {
        resourceType: "Patient",
        operations: [],
        authzConfig: (),
        profiles: ["http://hl7.org/fhir/StructureDefinition/ABCPatient"],
        defaultProfile: (),
        searchParameters: [],
        serverConfig: ()
    };
    anydata|r4:FHIRValidationError|r4:FHIRParseError? pat = validateAndParse(TEST_FHIR_RESOURCE_JSON_PATIENT_01, apiConfig);
    if pat is r4:FHIRValidationError {
        test:assertEquals(pat.message(), "Unsupported FHIR profile due to FHIR server does not support this FHIR profile : http://hl7.org/fhir/StructureDefinition/Patient", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since the FHIR server is not capable of understanding the given FHIR resource.");
    }
}

@test:Config {}
function parseAndValidateWithInvalidResourceTypeTest() returns r4:FHIRParseError|r4:FHIRValidationError? {
    r4:ResourceAPIConfig apiConfig = {
        resourceType: "Patient",
        operations: [],
        authzConfig: (),
        profiles: ["http://hl7.org/fhir/StructureDefinition/ABCPatient"],
        defaultProfile: (),
        searchParameters: [],
        serverConfig: ()
    };
    anydata|r4:FHIRValidationError|r4:FHIRParseError? pat = validateAndParse(TEST_FHIR_RESOURCE_JSON_WITH_NO_PROFILE_UNKNOWN_RESOURCE_TYPE, apiConfig);
    if pat is r4:FHIRValidationError {
        test:assertEquals(pat.message(), "Unknown FHIR resource type due to Payload contains unknown resource type : ABCDPatient", "Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since the FHIR server is not capable of understanding the given FHIR resource.");
    }
}

@test:Config {}
function parseAndValidateWithUnmatchingResourceTypeTest() returns r4:FHIRParseError|r4:FHIRValidationError? {
    r4:ResourceAPIConfig apiConfig = {
        resourceType: "ABCPatient",
        operations: [],
        authzConfig: (),
        profiles: ["http://hl7.org/fhir/StructureDefinition/Patient"],
        defaultProfile: (),
        searchParameters: [],
        serverConfig: ()
    };
    anydata|r4:FHIRValidationError|r4:FHIRParseError? pat = validateAndParse(TEST_FHIR_RESOURCE_JSON_PATIENT_01, apiConfig);
    if pat is r4:FHIRValidationError {
        test:assertEquals(pat.message(), "Mismatching resource type of the FHIR resource with the resource API due to Payload resource type : Patient but expected resource type : ABCPatient", " Mismatching error message");
        r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else {
        test:assertFail("Expect to fail since the FHIR server is not capable of understanding the given FHIR resource.");
    }
}

@test:Config {}
function parseWithValidationFailureTest() returns r4:FHIRParseError|r4:FHIRValidationError? {
    anydata|r4:FHIRValidationError|r4:FHIRParseError? patient = parseWithValidation(TEST_FHIR_RESOURCE_JSON_INVALID_PATIENT_02);
    if patient is r4:FHIRValidationError {
        test:assertEquals(patient.message(), "FHIR resource validation failed");
        r4:FHIRErrorDetail & readonly errorDetail = patient.detail();

        string? diagnostic = errorDetail.issues[0].diagnostic;
        if diagnostic is string {
            test:assertEquals(diagnostic, "It should be a date, or partial date (e.g. just year or year + month) as used in human communication. The format is YYYY, YYYY-MM, " +
                    "or YYYY-MM-DD, e.g. 2018, 1973-06, or 1905-08-23. There SHALL be no time zone. Refer: https://hl7.org/fhir/R4/datatypes.html.");
        }
    } else {
        test:assertFail("Expect to fail since the FHIR server is not capable of understanding the given FHIR resource.");
    }
}

@test:Config {}
function parseWithValidationSuccessTest() returns r4:FHIRParseError|r4:FHIRValidationError? {
    anydata|r4:FHIRValidationError|r4:FHIRParseError patient = parseWithValidation(TEST_FHIR_RESOURCE_JSON_VALID_PATIENT_01);
    if patient is r4:FHIRValidationError {
        test:assertEquals(patient.message(), "FHIR resource validation failed");
        // r4:FHIRErrorDetail & readonly errorDetail = pat.detail();

        // test:assertEquals(errorDetail.httpStatusCode, 400, "Error status code must be 400");
    } else if patient is anydata {
        test:assertTrue(patient is international401:Patient);
    } else {

    }
}

@test:Config {
    enable: terminologyConfig?.isTerminologyValidationEnabled ?: false
}
function validateTerminologyTest() {
    string[]? validationErrors = validateTerminologyData(TEST_FHIR_RESOURCE_JSON_PATIENT_02);
    if validationErrors is string[] {
        test:assertEquals(validationErrors.length(), 0, "Terminology validation failed with errors");
    }
}

@test:Config {
    enable: terminologyConfig?.isTerminologyValidationEnabled ?: false
}
function validateTerminologyNegativeTest() {
    string[]? validationErrors = validateTerminologyData(TEST_FHIR_RESOURCE_JSON_PATIENT_02_INVALID_TERMINOLOGY);
    if validationErrors is string[] {
        test:assertTrue(validationErrors.length() > 0, "Expected terminology validation errors but none found");
        test:assertTrue(validationErrors[0].startsWith("Terminology code "), "Unexpected error message: " + validationErrors[0]);
    } else {
        test:assertFail("Unexpected error during terminology validation, Cannot validate terminology codes");
    }
}
