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

@test:Config {}
function testRemoveSimpleStringField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "active": true,
        "gender": "male"
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.gender", ());
    test:assertTrue(result is json, "Should successfully remove gender field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertFalse(resultMap.hasKey("gender"), "Gender field should be removed");
        test:assertTrue(resultMap.hasKey("id"), "Other fields should remain");
        test:assertTrue(resultMap.hasKey("active"), "Other fields should remain");
    }
}

@test:Config {}
function testRemoveBooleanField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "active": true,
        "gender": "male"
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.active", ());
    test:assertTrue(result is json, "Should successfully remove active field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertFalse(resultMap.hasKey("active"), "Active field should be removed");
        test:assertTrue(resultMap.hasKey("id"), "Other fields should remain");
        test:assertTrue(resultMap.hasKey("gender"), "Other fields should remain");
    }
}

@test:Config {}
function testRemoveNumericField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "version": 1,
        "active": true
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.version", ());
    test:assertTrue(result is json, "Should successfully remove version field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertFalse(resultMap.hasKey("version"), "Version field should be removed");
        test:assertTrue(resultMap.hasKey("id"), "Other fields should remain");
        test:assertTrue(resultMap.hasKey("active"), "Other fields should remain");
    }
}

@test:Config {}
function testRemoveNestedObjectField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "managingOrganization": {
            "reference": "Organization/1",
            "display": "Test Organization"
        }
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.managingOrganization.display", ());
    test:assertTrue(result is json, "Should successfully remove nested display field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertTrue(resultMap.hasKey("managingOrganization"), "Parent object should remain");
        json managingOrgValue = resultMap["managingOrganization"];
        map<json> managingOrg = <map<json>>managingOrgValue;
        test:assertFalse(managingOrg.hasKey("display"), "Display field should be removed");
        test:assertTrue(managingOrg.hasKey("reference"), "Other nested fields should remain");
    }
}

@test:Config {}
function testRemoveEntireNestedObject() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "managingOrganization": {
            "reference": "Organization/1",
            "display": "Test Organization"
        }
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.managingOrganization", ());
    test:assertTrue(result is json, "Should successfully remove entire managingOrganization");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertFalse(resultMap.hasKey("managingOrganization"), "ManagingOrganization should be removed");
        test:assertTrue(resultMap.hasKey("id"), "Other fields should remain");
    }
}

@test:Config {}
function testRemoveArrayElementByIndex() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": [
            {
                "use": "official",
                "family": "Doe"
            },
            {
                "use": "usual",
                "given": ["John"]
            }
        ]
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.name[0]", ());
    test:assertTrue(result is json, "Should successfully remove first name element");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertTrue(resultMap.hasKey("name"), "Name array should still exist");
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        test:assertEquals(nameArray.length(), 1, "Array should have one element after removal");
        json remainingNameValue = nameArray[0];
        map<json> remainingName = <map<json>>remainingNameValue;
        test:assertEquals(remainingName["use"], "usual", "Remaining element should be the second one");
    }
}

@test:Config {}
function testRemoveMiddleArrayElement() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": [
            {
                "use": "official",
                "family": "Doe"
            },
            {
                "use": "usual",
                "given": ["John"]
            },
            {
                "use": "nickname",
                "given": ["Johnny"]
            }
        ]
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.name[1]", ());
    test:assertTrue(result is json, "Should successfully remove middle name element");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        test:assertEquals(nameArray.length(), 2, "Array should have two elements after removal");
        json firstNameValue = nameArray[0];
        map<json> firstName = <map<json>>firstNameValue;
        test:assertEquals(firstName["use"], "official", "First element should remain");
        json secondNameValue = nameArray[1];
        map<json> secondName = <map<json>>secondNameValue;
        test:assertEquals(secondName["use"], "nickname", "Third element should become second");
    }
}

@test:Config {}
function testRemoveFieldFromArrayElement() {
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

    json|error result = setValuesToFhirPath(testResource, "Patient.name[0].family", ());
    test:assertTrue(result is json, "Should successfully remove family field from array element");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        json nameElementValue = nameArray[0];
        map<json> nameElement = <map<json>>nameElementValue;
        test:assertFalse(nameElement.hasKey("family"), "Family field should be removed");
        test:assertTrue(nameElement.hasKey("use"), "Other fields should remain");
        test:assertTrue(nameElement.hasKey("given"), "Other fields should remain");
    }
}

@test:Config {}
function testRemoveEntireArrayField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": [
            {
                "use": "official",
                "family": "Doe"
            }
        ],
        "active": true
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.name", ());
    test:assertTrue(result is json, "Should successfully remove entire name array");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertFalse(resultMap.hasKey("name"), "Name array should be removed");
        test:assertTrue(resultMap.hasKey("id"), "Other fields should remain");
        test:assertTrue(resultMap.hasKey("active"), "Other fields should remain");
    }
}

@test:Config {}
function testRemoveNonExistentField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient"
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.nonExistentField", ());
    test:assertTrue(result is json, "Should handle removal of non-existent field gracefully");
    if result is json {
        map<json> resultMap = <map<json>>result;
        test:assertEquals(resultMap.length(), 2, "Resource should remain unchanged");
        test:assertTrue(resultMap.hasKey("resourceType"), "Original fields should remain");
        test:assertTrue(resultMap.hasKey("id"), "Original fields should remain");
    }
}

@test:Config {}
function testRemoveFromNonExistentArrayIndex() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": [
            {
                "use": "official",
                "family": "Doe"
            }
        ]
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.name[5]", ());
    test:assertTrue(result is json, "Should handle removal of non-existent array index gracefully");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        test:assertEquals(nameArray.length(), 1, "Array should remain unchanged");
    }
}

@test:Config {}
function testRemoveFromEmptyArray() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": []
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.name[0]", ());
    test:assertTrue(result is json, "Should handle removal from empty array gracefully");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        test:assertEquals(nameArray.length(), 0, "Empty array should remain empty");
    }
}

@test:Config {}
function testRemoveDeeplyNestedField() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "address": [
            {
                "use": "home",
                "line": [
                    "90 Main St"
                ],
                "city": "TestCity"
            }
        ]
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.address.line", ());
    test:assertTrue(result is json, "Should successfully remove deeply nested field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json addressValue = resultMap["address"];
        json[] addressArray = <json[]>addressValue;
        json addressElementValue = addressArray[0];
        map<json> addressElement = <map<json>>addressElementValue;
        test:assertFalse(addressElement.hasKey("line"), "Line field should be removed");
        test:assertTrue(addressElement.hasKey("use"), "Other fields should remain");
        test:assertTrue(addressElement.hasKey("city"), "Other fields should remain");
    }
}

@test:Config {}
function testRemoveComplexNestedStructure() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "contact": [
            {
                "relationship": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/v2-0131",
                                "code": "N",
                                "display": "Next-of-Kin"
                            }
                        ]
                    }
                ],
                "name": {
                    "family": "du Marché",
                    "given": ["Bénédicte"]
                }
            }
        ]
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.contact[0].relationship[0].coding[0].display", ());
    test:assertTrue(result is json, "Should successfully remove complex nested field");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json contactValue = resultMap["contact"];
        json[] contactArray = <json[]>contactValue;
        json contactElementValue = contactArray[0];
        map<json> contact = <map<json>>contactElementValue;
        json relationshipValue = contact["relationship"];
        json[] relationshipArray = <json[]>relationshipValue;
        json relationshipElementValue = relationshipArray[0];
        map<json> relationship = <map<json>>relationshipElementValue;
        json codingValue = relationship["coding"];
        json[] codingArray = <json[]>codingValue;
        json codingElementValue = codingArray[0];
        map<json> coding = <map<json>>codingElementValue;
        test:assertFalse(coding.hasKey("display"), "Display field should be removed");
        test:assertTrue(coding.hasKey("system"), "Other fields should remain");
        test:assertTrue(coding.hasKey("code"), "Other fields should remain");
    }
}

@test:Config {}
function testRemoveLastArrayElement() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": [
            {
                "use": "official",
                "family": "Doe"
            },
            {
                "use": "usual",
                "given": ["John"]
            }
        ]
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.name[1]", ());
    test:assertTrue(result is json, "Should successfully remove last name element");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        test:assertEquals(nameArray.length(), 1, "Array should have one element after removal");
        json remainingNameValue = nameArray[0];
        map<json> remainingName = <map<json>>remainingNameValue;
        test:assertEquals(remainingName["use"], "official", "First element should remain");
    }
}

@test:Config {}
function testRemoveSingleArrayElement() {
    json testResource = {
        "resourceType": "Patient",
        "id": "test-patient",
        "name": [
            {
                "use": "official",
                "family": "Doe"
            }
        ]
    };

    json|error result = setValuesToFhirPath(testResource, "Patient.name[0]", ());
    test:assertTrue(result is json, "Should successfully remove single array element");
    if result is json {
        map<json> resultMap = <map<json>>result;
        json nameValue = resultMap["name"];
        json[] nameArray = <json[]>nameValue;
        test:assertEquals(nameArray.length(), 0, "Array should be empty after removing single element");
    }
}
