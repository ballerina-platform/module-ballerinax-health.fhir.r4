// Copyright (c) 2023-2025, WSO2 LLC. (http://www.wso2.com).

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
public function testWhereFunction() returns error? {
    // Test where() - filter names by use='official'
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'official').family"), ["Chalmers"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'official').use"), ["official"], msg = "Failed!");

    // Test where() - filter names by use='usual'
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'usual').given"), ["Jim"], msg = "Failed!");

    // Test where() - filter addresses by use='home'
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(use = 'home').city"), ["PleasantVille"], msg = "Failed!");

    // Test where() - filter addresses by use='work'
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(use = 'work').city"), ["Melbourne"], msg = "Failed!");

    // Test where() - filter by city
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'Melbourne').use"), ["work"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'PleasantVille').use"), ["home"], msg = "Failed!");

    // Test where() - no matches returns empty
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'nickname')"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'Sydney')"), [], msg = "Failed!");

    // Test where() - without resource type prefix
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.where(use = 'official').family"), ["Chalmers"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.where(city = 'PleasantVille').use"), ["home"], msg = "Failed!");
}

@test:Config {}
public function testWhereFunctionWithBooleanOperators() returns error? {
    // Test where() with 'and' operator - both conditions match
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(use = 'home' and city = 'PleasantVille').state"), ["Vic"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'Melbourne' and use = 'work').postalCode"), ["3000"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(state = 'Vic' and country = 'Australia').city"), ["PleasantVille", "Melbourne"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(state = 'Vic' and postalCode = '3999').city"), ["PleasantVille"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(district = 'Rainbow' and postalCode = '3000').use"), ["work"], msg = "Failed!");

    // Test where() with 'and' operator - one condition doesn't match (should return empty)
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(use = 'home' and city = 'Melbourne')"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'PleasantVille' and use = 'work')"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(state = 'NSW' and country = 'Australia')"), [], msg = "Failed!");

    // Test where() with 'or' operator - at least one condition matches
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(use = 'home' or use = 'work').city"), ["PleasantVille", "Melbourne"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'PleasantVille' or city = 'Melbourne').use"), ["home", "work"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(postalCode = '3999' or postalCode = '3000').city"), ["PleasantVille", "Melbourne"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(use = 'home' or city = 'Sydney').postalCode"), ["3999"], msg = "Failed!");

    // Test where() with 'or' operator - neither condition matches (should return empty)
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(use = 'temp' or use = 'old')"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.where(city = 'Sydney' or city = 'Brisbane')"), [], msg = "Failed!");

    // Test where() with name fields and boolean operators
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'official' and family = 'Chalmers').given"), ["Peter", "James"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.where(use = 'official' or use = 'usual').use"), ["official", "usual"], msg = "Failed!");

    // Test where() - without resource type prefix
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.where(use = 'home' and city = 'PleasantVille').state"), ["Vic"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.where(city = 'PleasantVille' or city = 'Melbourne').use"), ["home", "work"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.where(use = 'official' and family = 'Chalmers').given"), ["Peter", "James"], msg = "Failed!");
}
