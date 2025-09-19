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

import ballerina/test;

// Helper modification functions for testing
isolated function toUpperCaseFunction(json input) returns json|error {
    if input is string {
        return input.toUpperAscii();
    }
    return error("Non-string input provided for toUpperCaseFunction.", value = input.toString());
}

isolated function toLowerCaseFunction(json input) returns json|error {
    if input is string {
        return input.toLowerAscii();
    }
    return error("Non-string input provided for toLowerCaseFunction.", value = input.toString());
}

isolated function addPrefixFunction(json input) returns json|error {
    if input is string|int {
        return "PREFIX_" + input.toString();
    }
    return error("Non-string/int input provided for addPrefixFunction.", value = input.toString());
}

isolated function hashFunction(json input) returns json|error {
    if input is string {
        // Simple hash simulation for testing
        return "HASH_" + input.length().toString();
    }
    return error("Non-string input provided for hashFunction.", value = input.toString());
}

isolated function errorFunction(json input) returns json|error {
    return error("Intentional error for testing", value = input.toString());
}

isolated function emptyStringFunction(json input) returns json|error {
    return "";
}

isolated function reverseStringFunction(json input) returns json|error {
    if input is string {
        string reversed = "";
        int length = input.length();
        foreach int i in 0 ..< length {
            string char = input.substring(length - 1 - i, length - i);
            reversed = reversed + char;
        }
        return reversed;
    }
    return error("Input is not a string", value = input.toString());
}

// TESTS

@test:Config {}
function testModificationFunctionOnSimpleStringField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "gender": "male"
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.gender", toUpperCaseFunction);
    test:assertTrue(result is json, "Should successfully apply modification function to gender field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertEquals(resultMap["gender"], "MALE", "Gender should be converted to uppercase");
        test:assertTrue(resultMap.hasKey("id"), "Other fields should remain unchanged");
    }
}

@test:Config {}
function testModificationFunctionOnNestedStringField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "managingOrganization": {
            "reference": "Organization/1",
            "display": "Test Organization"
        }
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.managingOrganization.display", toLowerCaseFunction);
    test:assertTrue(result is json, "Should successfully apply modification function to nested field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json managingOrgValue = resultMap["managingOrganization"];
        map<json> managingOrg = <map<json>>managingOrgValue;
        test:assertEquals(managingOrg["display"], "test organization", "Display should be converted to lowercase");
        test:assertEquals(managingOrg["reference"], "Organization/1", "Other nested fields should remain unchanged");
    }
}

@test:Config {}
function testModificationFunctionOnArrayElementField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": [
            {
                "use": "official",
                "family": "Doe",
                "given": ["John"]
            }
        ]
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.name[0].family", addPrefixFunction);
    test:assertTrue(result is json, "Should successfully apply modification function to array element field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        json nameElementValue = nameArray[0];
        map<json> nameElement = <map<json>>nameElementValue;
        test:assertEquals(nameElement["family"], "PREFIX_Doe", "Family name should have prefix added");
        test:assertEquals(nameElement["use"], "official", "Other fields should remain unchanged");
    }
}

@test:Config {}
function testModificationFunctionOnMultipleArrayElements() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "address": [
            {
                "use": "home",
                "city": "Boston"
            },
            {
                "use": "work",
                "city": "NewYork"
            }
        ]
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.address.city", toUpperCaseFunction);
    test:assertTrue(result is json, "Should successfully apply modification function to multiple array elements");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json addressValue = resultMap["address"];
        json[] addressArray = <json[]>addressValue;

        json firstAddressValue = addressArray[0];
        map<json> firstAddress = <map<json>>firstAddressValue;
        test:assertEquals(firstAddress["city"], "BOSTON", "First city should be uppercase");

        json secondAddressValue = addressArray[1];
        map<json> secondAddress = <map<json>>secondAddressValue;
        test:assertEquals(secondAddress["city"], "NEWYORK", "Second city should be uppercase");
    }
}

@test:Config {}
function testModificationFunctionWithHashFunction() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "gender": "female"
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.gender", hashFunction);
    test:assertTrue(result is json, "Should successfully apply hash function");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertEquals(resultMap["gender"], "HASH_6", "Gender should be hashed (female = 6 chars)");
    }
}

@test:Config {}
function testModificationFunctionWithEmptyStringResult() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "gender": "male"
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.gender", emptyStringFunction);
    test:assertTrue(result is json, "Should successfully apply function that returns empty string");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertEquals(resultMap["gender"], "", "Gender should be empty string");
    }
}

@test:Config {}
function testModificationFunctionWithReverseString() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": [
            {
                "family": "Smith"
            }
        ]
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.name[0].family", reverseStringFunction);
    test:assertTrue(result is json, "Should successfully apply reverse string function");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        json nameElementValue = nameArray[0];
        map<json> nameElement = <map<json>>nameElementValue;
        test:assertEquals(nameElement["family"], "htimS", "Family name should be reversed");
    }
}

@test:Config {}
function testModificationFunctionError() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "gender": "male"
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.gender", errorFunction);
    test:assertTrue(result is FHIRPathError, "Should return error when modification function fails");
    if result is FHIRPathError {
        test:assertTrue(result.message().includes("Intentional error"), "Error message should contain modification function error");
    }
}

@test:Config {}
function testModificationFunctionOnNonStringValue() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "active": true
    };

    // Modification function should not be applied to non-string values
    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.active", toUpperCaseFunction);
    test:assertTrue(result is FHIRPathError, "Should return error for non-string value");
    if result is FHIRPathError {
        test:assertTrue(result.message().includes("Non-string input provided for toUpperCaseFunction."), "Error message should indicate modification function cannot be applied");
    }
}

@test:Config {}
function testModificationFunctionOnMissingField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient"
    };

    // Should not apply modification function if field doesn't exist and path creation is disabled
    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.gender", toUpperCaseFunction);
    test:assertTrue(result is json, "Should handle missing field gracefully");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertFalse(resultMap.hasKey("gender"), "Field should not be created when path creation is disabled");
    }
}

@test:Config {}
function testModificationFunctionOnDeeplyNestedField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "contact": [
            {
                "name": {
                    "family": "Emergency",
                    "given": ["Contact"]
                }
            }
        ]
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.contact[0].name.family", addPrefixFunction);
    test:assertTrue(result is json, "Should successfully apply modification function to deeply nested field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json contactValue = resultMap["contact"];
        json[] contactArray = <json[]>contactValue;
        json contactElementValue = contactArray[0];
        map<json> contact = <map<json>>contactElementValue;
        json nameValue = contact["name"];
        map<json> name = <map<json>>nameValue;
        test:assertEquals(name["family"], "PREFIX_Emergency", "Deeply nested field should be modified");
        test:assertEquals(name["given"], ["Contact"], "Other nested fields should remain unchanged");
    }
}

@test:Config {}
function testModificationFunctionOnComplexArrayStructure() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "identifier": [
            {
                "system": "http://example.com/patient-ids",
                "value": "12345"
            },
            {
                "system": "http://example.com/mrn",
                "value": "67890"
            }
        ]
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.identifier.value", hashFunction);
    test:assertTrue(result is json, "Should successfully apply modification function to all identifier values");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json identifierValue = resultMap["identifier"];
        json[] identifierArray = <json[]>identifierValue;

        json firstIdentifierValue = identifierArray[0];
        map<json> firstIdentifier = <map<json>>firstIdentifierValue;
        test:assertEquals(firstIdentifier["value"], "HASH_5", "First identifier value should be hashed");

        json secondIdentifierValue = identifierArray[1];
        map<json> secondIdentifier = <map<json>>secondIdentifierValue;
        test:assertEquals(secondIdentifier["value"], "HASH_5", "Second identifier value should be hashed");
    }
}

@test:Config {}
function testModificationFunctionOnSpecificArrayIndex() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "telecom": [
            {
                "system": "phone",
                "value": "555-1234"
            },
            {
                "system": "email",
                "value": "patient@example.com"
            }
        ]
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.telecom[1].value", toUpperCaseFunction);
    test:assertTrue(result is json, "Should successfully apply modification function to specific array index");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json telecomValue = resultMap["telecom"];
        json[] telecomArray = <json[]>telecomValue;

        json firstTelecomValue = telecomArray[0];
        map<json> firstTelecom = <map<json>>firstTelecomValue;
        test:assertEquals(firstTelecom["value"], "555-1234", "First telecom value should remain unchanged");

        json secondTelecomValue = telecomArray[1];
        map<json> secondTelecom = <map<json>>secondTelecomValue;
        test:assertEquals(secondTelecom["value"], "PATIENT@EXAMPLE.COM", "Second telecom value should be uppercase");
    }
}

@test:Config {}
function testModificationFunctionChaining() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": [
            {
                "family": "smith"
            }
        ]
    };

    // First apply uppercase
    json|FHIRPathError result1 = setValuesToFhirPath(testResource, "Patient.name[0].family", toUpperCaseFunction);
    test:assertTrue(result1 is json, "First modification should succeed");

    if result1 is json {
        // Then apply prefix to the result
        json|FHIRPathError result2 = setValuesToFhirPath(result1, "Patient.name[0].family", addPrefixFunction);
        test:assertTrue(result2 is json, "Second modification should succeed");

        if result2 is json {
            map<json> resultMap = <map<json>>result2;
            json nameValue = resultMap["name"];
            json[] nameArray = <json[]>nameValue;
            json nameElementValue = nameArray[0];
            map<json> nameElement = <map<json>>nameElementValue;
            test:assertEquals(nameElement["family"], "PREFIX_SMITH", "Should apply both modifications in sequence");
        }
    }
}

@test:Config {}
function testModificationFunctionWithEmptyArray() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": []
    };

    json|FHIRPathError result = setValuesToFhirPath(testResource, "Patient.name.family", toUpperCaseFunction);
    test:assertTrue(result is json, "Should handle empty array gracefully");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        test:assertEquals(nameArray.length(), 0, "Array should remain empty");
    }
}
