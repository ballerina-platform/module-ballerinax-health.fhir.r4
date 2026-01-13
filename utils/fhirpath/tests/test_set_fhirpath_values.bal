// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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

@test:Config {}
function testSetSimpleStringValue() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.gender", "female");

    test:assertTrue(result is json, "Should successfully set gender value");
    if result is json {
        map<json> patientMap = <map<json>>result;
        test:assertEquals(patientMap["gender"], "female", "Gender should be updated to female");
    }
}

@test:Config {}
function testSetSimpleStringValueWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "gender", "female");

    test:assertTrue(result is json, "Should successfully set gender value");
    if result is json {
        map<json> patientMap = <map<json>>result;
        test:assertEquals(patientMap["gender"], "female", "Gender should be updated to female");
    }
}

@test:Config {}
function testSetSimpleNumberValue() {
    json originalPatient = samplePatient3.clone();
    // Note: FHIR IDs are typically strings, but for testing purposes, we can set a number and set validate = false
    json|error result = setValuesToFhirPath(originalPatient, "Patient.id", 999);

    test:assertTrue(result is json, "Should successfully set id value");
    if result is json {
        map<json> patientMap = <map<json>>result;
        test:assertEquals(patientMap["id"], 999, "ID should be updated to 999");
    }
}

@test:Config {}
function testSetSimpleNumberValueWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    // Note: FHIR IDs are typically strings, but for testing purposes, we can set a number and set validate = false
    json|error result = setValuesToFhirPath(originalPatient, "id", 999);

    test:assertTrue(result is json, "Should successfully set id value");
    if result is json {
        map<json> patientMap = <map<json>>result;
        test:assertEquals(patientMap["id"], 999, "ID should be updated to 999");
    }
}

@test:Config {}
function testSetBooleanValue() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.active", false);

    test:assertTrue(result is json, "Should successfully set active value");
    if result is json {
        map<json> patientMap = <map<json>>result;
        test:assertEquals(patientMap["active"], false, "Active should be updated to false");
    }
}

@test:Config {}
function testSetBooleanValueWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "active", false);

    test:assertTrue(result is json, "Should successfully set active value");
    if result is json {
        map<json> patientMap = <map<json>>result;
        test:assertEquals(patientMap["active"], false, "Active should be updated to false");
    }
}

@test:Config {}
function testSetArrayElementValue() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.name[0].family", "NewFamilyName");

    test:assertTrue(result is json, "Should successfully set family name");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] nameArray = <json[]>patientMap["name"];
        map<json> firstNameObj = <map<json>>nameArray[0];
        test:assertEquals(firstNameObj["family"], "NewFamilyName", "Family name should be updated");
    }
}

@test:Config {}
function testSetArrayElementValueWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "name[0].family", "NewFamilyName");

    test:assertTrue(result is json, "Should successfully set family name");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] nameArray = <json[]>patientMap["name"];
        map<json> firstNameObj = <map<json>>nameArray[0];
        test:assertEquals(firstNameObj["family"], "NewFamilyName", "Family name should be updated");
    }
}

@test:Config {}
function testSetNestedArrayElementValue() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.name[0].given[1]", "NewMiddleName");

    test:assertTrue(result is json, "Should successfully set given name");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] nameArray = <json[]>patientMap["name"];
        map<json> firstNameObj = <map<json>>nameArray[0];
        json[] givenArray = <json[]>firstNameObj["given"];
        test:assertEquals(givenArray[1], "NewMiddleName", "Given name should be updated");
    }
}

@test:Config {}
function testSetNestedArrayElementValueWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "name[0].given[1]", "NewMiddleName");

    test:assertTrue(result is json, "Should successfully set given name");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] nameArray = <json[]>patientMap["name"];
        map<json> firstNameObj = <map<json>>nameArray[0];
        json[] givenArray = <json[]>firstNameObj["given"];
        test:assertEquals(givenArray[1], "NewMiddleName", "Given name should be updated");
    }
}

@test:Config {}
function testSetNestedObjectValue() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.managingOrganization.reference", "Organization/999");

    test:assertTrue(result is json, "Should successfully set nested reference");
    if result is json {
        map<json> patientMap = <map<json>>result;
        map<json> orgMap = <map<json>>patientMap["managingOrganization"];
        test:assertEquals(orgMap["reference"], "Organization/999", "Reference should be updated");
    }
}

@test:Config {}
function testSetNestedObjectValueWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "managingOrganization.reference", "Organization/999");

    test:assertTrue(result is json, "Should successfully set nested reference");
    if result is json {
        map<json> patientMap = <map<json>>result;
        map<json> orgMap = <map<json>>patientMap["managingOrganization"];
        test:assertEquals(orgMap["reference"], "Organization/999", "Reference should be updated");
    }
}

@test:Config {}
function testBulkUpdateArrayElements() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.address.city", "NewCity");

    test:assertTrue(result is json, "Should successfully update all address cities");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        map<json> firstAddress = <map<json>>addressArray[0];
        map<json> secondAddress = <map<json>>addressArray[1];

        test:assertEquals(firstAddress["city"], "NewCity", "First address city should be updated");
        test:assertEquals(secondAddress["city"], "NewCity", "Second address city should be updated");
    }
}

@test:Config {}
function testBulkUpdateArrayElementsWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "address.city", "NewCity");

    test:assertTrue(result is json, "Should successfully update all address cities");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        map<json> firstAddress = <map<json>>addressArray[0];
        map<json> secondAddress = <map<json>>addressArray[1];

        test:assertEquals(firstAddress["city"], "NewCity", "First address city should be updated");
        test:assertEquals(secondAddress["city"], "NewCity", "Second address city should be updated");
    }
}

@test:Config {}
function testBulkUpdateNestedArrayElements() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.address.line", "***");

    test:assertTrue(result is json, "Should successfully update all line numbers");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        // Check first address
        map<json> firstAddress = <map<json>>addressArray[0];
        string firstLine = <string>firstAddress["line"];
        test:assertEquals(firstLine, "***", "First address first line should be updated");

        // Check second address
        map<json> secondAddress = <map<json>>addressArray[1];
        string secondLine = <string>secondAddress["line"];
        test:assertEquals(secondLine, "***", "Second address line should be updated");
    }
}

@test:Config {}
function testBulkUpdateNestedArrayElementsWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "address.line", "***");

    test:assertTrue(result is json, "Should successfully update all line numbers");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        // Check first address
        map<json> firstAddress = <map<json>>addressArray[0];
        string firstLine = <string>firstAddress["line"];
        test:assertEquals(firstLine, "***", "First address first line should be updated");

        // Check second address
        map<json> secondAddress = <map<json>>addressArray[1];
        string secondLine = <string>secondAddress["line"];
        test:assertEquals(secondLine, "***", "Second address line should be updated");
    }
}

function addToConfigFile(string value) returns error? {

    // Write the Config.toml file in the tests directory
    io:Error? writeResult = io:fileWriteString("tests/Config.toml", value, option = io:OVERWRITE);
    if writeResult is io:Error {
        return writeResult;
    }
}

@test:Config {}
function testSkipNonExistentPathWithPathCreationDisabled() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.nonExistentField", "value");

    test:assertTrue(result is json, "Should return original resource unchanged");
    if result is json {
        map<json> patientMap = <map<json>>result;
        test:assertFalse(patientMap.hasKey("nonExistentField"), "Non-existent field should not be created");
        // Verify original data is unchanged
        test:assertEquals(patientMap["id"], "3", "Original data should remain unchanged");
    }
}

@test:Config {}
function testSkipNonExistentPathWithPathCreationDisabledWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "nonExistentField", "value");

    test:assertTrue(result is json, "Should return original resource unchanged");
    if result is json {
        map<json> patientMap = <map<json>>result;
        test:assertFalse(patientMap.hasKey("nonExistentField"), "Non-existent field should not be created");
        // Verify original data is unchanged
        test:assertEquals(patientMap["id"], "3", "Original data should remain unchanged");
    }
}

@test:Config {}
function testSkipNonExistentNestedPath() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.address[0].nonExistent.field", "value");

    test:assertTrue(result is json, "Should return original resource unchanged");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];
        map<json> firstAddress = <map<json>>addressArray[0];
        test:assertFalse(firstAddress.hasKey("nonExistent"), "Non-existent nested field should not be created");
    }
}

@test:Config {}
function testSkipNonExistentNestedPathWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "address[0].nonExistent.field", "value");

    test:assertTrue(result is json, "Should return original resource unchanged");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];
        map<json> firstAddress = <map<json>>addressArray[0];
        test:assertFalse(firstAddress.hasKey("nonExistent"), "Non-existent nested field should not be created");
    }
}

@test:Config {}
function testSkipNonExistentArrayIndexWithPathCreationDisabled() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.address[5].city", "value");

    test:assertTrue(result is json, "Should return original resource unchanged");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];
        test:assertEquals(addressArray.length(), 2, "Array length should remain unchanged");
    }
}

@test:Config {}
function testSkipNonExistentArrayIndexWithPathCreationDisabledWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "address[5].city", "value");

    test:assertTrue(result is json, "Should return original resource unchanged");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];
        test:assertEquals(addressArray.length(), 2, "Array length should remain unchanged");
    }
}

@test:Config {}
function testInvalidEmptyFhirPathExpression() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "", "value");

    test:assertTrue(result is error, "Should return error for empty expression");
    if result is error {
        test:assertTrue(result.message().includes("Invalid FHIR Path"), "Should have appropriate error message");
    }
}

@test:Config {}
function testInvalidEmptyFhirPathExpressionWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "", "value");

    test:assertTrue(result is error, "Should return error for empty expression");
    if result is error {
        test:assertTrue(result.message().includes("Invalid FHIR Path"), "Should have appropriate error message");
    }
}

@test:Config {}
function testInvalidArrayIndex() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.name[abc].family", "value");

    test:assertTrue(result is error, "Should return error for invalid array index");
    if result is error {
        test:assertTrue(result.message().includes("Invalid FHIR Path"), "Should have appropriate error message");
    }
}

@test:Config {}
function testInvalidArrayIndexWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "name[abc].family", "value");

    test:assertTrue(result is error, "Should return error for invalid array index");
    if result is error {
        test:assertTrue(result.message().includes("Invalid FHIR Path"), "Should have appropriate error message");
    }
}

@test:Config {}
function testMalformedArrayAccess() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.name[0.family", "value");
    if result is error {
        test:assertTrue(result.message().includes("Invalid FHIR Path"), "Should have appropriate error message");
    }
}

@test:Config {}
function testMalformedArrayAccessWithoutResourceType() {
    json originalPatient = samplePatient3.clone();
    json|error result = setValuesToFhirPath(originalPatient, "name[0.family", "value");
    if result is error {
        test:assertTrue(result.message().includes("Invalid FHIR Path"), "Should have appropriate error message");
    }
}
