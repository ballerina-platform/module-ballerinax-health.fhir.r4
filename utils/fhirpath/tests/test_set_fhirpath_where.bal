// Copyright (c) 2023-2026, WSO2 LLC. (http://www.wso2.com).

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
function testSetValueWithWhereFilterByUse() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.name.where(use = 'official').family", "NewOfficialFamily");

    test:assertTrue(result is json, "Should successfully set family name where use is official");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] nameArray = <json[]>patientMap["name"];

        // Official name should be updated
        map<json> officialName = <map<json>>nameArray[0];
        test:assertEquals(officialName["family"], "NewOfficialFamily", "Official family name should be updated");

        // Usual name should remain unchanged (no family field originally)
        map<json> usualName = <map<json>>nameArray[1];
        test:assertFalse(usualName.hasKey("family"), "Usual name should not have family field added");
    }
}

@test:Config {}
function testSetValueWithWhereFilterByUseWithoutResourceType() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "name.where(use = 'official').family", "NewOfficialFamily");

    test:assertTrue(result is json, "Should successfully set family name where use is official");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] nameArray = <json[]>patientMap["name"];

        // Official name should be updated
        map<json> officialName = <map<json>>nameArray[0];
        test:assertEquals(officialName["family"], "NewOfficialFamily", "Official family name should be updated");
    }
}

@test:Config {}
function testSetAddressCityWithWhereFilter() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.address.where(use = 'home').city", "NewHomeCity");

    test:assertTrue(result is json, "Should successfully set city where use is home");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        // Home address city should be updated
        map<json> homeAddress = <map<json>>addressArray[0];
        test:assertEquals(homeAddress["city"], "NewHomeCity", "Home address city should be updated");

        // Work address city should remain unchanged
        map<json> workAddress = <map<json>>addressArray[1];
        test:assertEquals(workAddress["city"], "Melbourne", "Work address city should remain unchanged");
    }
}

@test:Config {}
function testSetAddressCityWithWhereFilterWithoutResourceType() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "address.where(use = 'home').city", "NewHomeCity");

    test:assertTrue(result is json, "Should successfully set city where use is home");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        // Home address city should be updated
        map<json> homeAddress = <map<json>>addressArray[0];
        test:assertEquals(homeAddress["city"], "NewHomeCity", "Home address city should be updated");

        // Work address city should remain unchanged
        map<json> workAddress = <map<json>>addressArray[1];
        test:assertEquals(workAddress["city"], "Melbourne", "Work address city should remain unchanged");
    }
}

@test:Config {}
function testSetValueWithWhereFilterByCity() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.address.where(city = 'Melbourne').postalCode", "9999");

    test:assertTrue(result is json, "Should successfully set postal code where city is Melbourne");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        // PleasantVille address should remain unchanged
        map<json> homeAddress = <map<json>>addressArray[0];
        test:assertEquals(homeAddress["postalCode"], "3999", "Home address postal code should remain unchanged");

        // Melbourne address postal code should be updated
        map<json> workAddress = <map<json>>addressArray[1];
        test:assertEquals(workAddress["postalCode"], "9999", "Work address postal code should be updated");
    }
}

@test:Config {}
function testSetValueWithWhereAndOperator() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.address.where(use = 'home' and city = 'PleasantVille').state", "NSW");

    test:assertTrue(result is json, "Should successfully set state where use is home and city is PleasantVille");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        // Home address in PleasantVille should be updated
        map<json> homeAddress = <map<json>>addressArray[0];
        test:assertEquals(homeAddress["state"], "NSW", "Home address state should be updated");

        // Work address should remain unchanged
        map<json> workAddress = <map<json>>addressArray[1];
        test:assertEquals(workAddress["state"], "Vic", "Work address state should remain unchanged");
    }
}

@test:Config {}
function testSetValueWithWhereAndOperatorWithoutResourceType() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "address.where(use = 'home' and city = 'PleasantVille').state", "NSW");

    test:assertTrue(result is json, "Should successfully set state where use is home and city is PleasantVille");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        // Home address in PleasantVille should be updated
        map<json> homeAddress = <map<json>>addressArray[0];
        test:assertEquals(homeAddress["state"], "NSW", "Home address state should be updated");

        // Work address should remain unchanged
        map<json> workAddress = <map<json>>addressArray[1];
        test:assertEquals(workAddress["state"], "Vic", "Work address state should remain unchanged");
    }
}

@test:Config {}
function testSetValueWithWhereOrOperator() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.address.where(use = 'home' or use = 'work').country", "New Zealand");

    test:assertTrue(result is json, "Should successfully set country for both home and work addresses");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        // Both addresses should be updated
        map<json> homeAddress = <map<json>>addressArray[0];
        test:assertEquals(homeAddress["country"], "New Zealand", "Home address country should be updated");

        map<json> workAddress = <map<json>>addressArray[1];
        test:assertEquals(workAddress["country"], "New Zealand", "Work address country should be updated");
    }
}

@test:Config {}
function testSetValueWithWhereOrOperatorWithoutResourceType() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "address.where(use = 'home' or use = 'work').country", "New Zealand");

    test:assertTrue(result is json, "Should successfully set country for both home and work addresses");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] addressArray = <json[]>patientMap["address"];

        // Both addresses should be updated
        map<json> homeAddress = <map<json>>addressArray[0];
        test:assertEquals(homeAddress["country"], "New Zealand", "Home address country should be updated");

        map<json> workAddress = <map<json>>addressArray[1];
        test:assertEquals(workAddress["country"], "New Zealand", "Work address country should be updated");
    }
}

@test:Config {}
function testSetValueWithWhereNoMatch() {
    json originalPatient = samplePatient1.clone();
    json|FhirpathError result = setValuesToFhirPath(originalPatient, "Patient.name.where(use = 'nickname').family", "NicknameFamilyName");

    // When where clause matches nothing, it should return error as path doesn't exist
    test:assertTrue(result is FhirpathInterpreterError, "Should return error when where clause matches nothing");
}

@test:Config {}
function testSetValueWithWhereNoMatchWithoutResourceType() {
    json originalPatient = samplePatient1.clone();
    json|FhirpathError result = setValuesToFhirPath(originalPatient, "name.where(use = 'nickname').family", "NicknameFamilyName");

    // When where clause matches nothing, it should return error as path doesn't exist
    test:assertTrue(result is FhirpathInterpreterError, "Should return error when where clause matches nothing");
}

@test:Config {}
function testSetGivenNameWithWhereFilter() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "Patient.name.where(use = 'official').given", ["Alice", "Marie"]);

    test:assertTrue(result is json, "Should successfully set given names where use is official");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] nameArray = <json[]>patientMap["name"];

        // Official name given should be updated
        map<json> officialName = <map<json>>nameArray[0];
        json[] givenArray = <json[]>officialName["given"];
        test:assertEquals(givenArray, <json[]>["Alice", "Marie"], "Official given names should be updated");

        // Usual name should remain unchanged
        map<json> usualName = <map<json>>nameArray[1];
        json[] usualGivenArray = <json[]>usualName["given"];
        test:assertEquals(usualGivenArray, <json[]>["Jim"], "Usual given name should remain unchanged");
    }
}

@test:Config {}
function testSetGivenNameWithWhereFilterWithoutResourceType() {
    json originalPatient = samplePatient1.clone();
    json|error result = setValuesToFhirPath(originalPatient, "name.where(use = 'official').given", ["Alice", "Marie"]);

    test:assertTrue(result is json, "Should successfully set given names where use is official");
    if result is json {
        map<json> patientMap = <map<json>>result;
        json[] nameArray = <json[]>patientMap["name"];

        // Official name given should be updated  
        map<json> officialName = <map<json>>nameArray[0];
        json[] givenArray = <json[]>officialName["given"];
        test:assertEquals(givenArray, <json[]>["Alice", "Marie"], "Official given names should be updated");
    }
}
