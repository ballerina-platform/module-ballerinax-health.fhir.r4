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
public function testEvaluateFhirPath() returns error? {
    // Unit Test for HappyPaths.
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.id"), ["1"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.address[0].line[0]"), ["534 Erewhon St"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.address.line[1]"), ["sqw"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.address[0].city"), ["PleasantVille"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.address[1].line[0]"), ["33[0] 6th St"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.address[1].city"), ["Melbourne"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.name[0].use"), ["official"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.name[0].given[0]"), ["Peter"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.active"), [true], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.managingOrganization.reference"), ["Organization/1"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.managingOrganization.display"), ["Burgers University Medical Center"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.address.use"), ["home", "work"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.name.given"), [["Peter", "James"], ["Jim"]], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.name[0].given"), ["Peter", "James"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.name.given[0]"), ["Peter", "Jim"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(sampleOrganization1, "Organization.address.use"), ["work"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(sampleOrganization1, "Organization.language"), ["eng"], msg = "Failed!");
    test:assertEquals(getFhirPathValues(sampleOrganization1, "Organization.contact[0].address.line"), ["33[0] 6th St"], msg = "Failed!");

    test:assertEquals(getFhirPathValues(samplePatient1, "Patient.address.city"), ["PleasantVille", "Melbourne"], msg = "Failed!");

    // Unit tests for error paths.
    json|error evaluateFhirPathResult = getFhirPathValues(samplePatient1, "Patient.mother[a]");
    if evaluateFhirPathResult is error {
        test:assertEquals(evaluateFhirPathResult.message(), "Invalid FHIR Path expression", msg = "Failed!");
    }
    json|error testOne = getFhirPathValues(samplePatient1, "Pat.name");
    if testOne is error {
        test:assertEquals(testOne.message(), "Resource is not match with the FhirPath expression", msg = "Failed!");
    }
    json|error testTwo = getFhirPathValues(samplePatient1, "Patient.address.name");
    if testTwo is error {
        test:assertEquals(testTwo.message(), "The given FhirPath expression is incorrect for the given FHIR resource", msg = "Failed!");
    }
    json|error testThree = getFhirPathValues(samplePatient1, "Patient.name[0].given[a]");
    if testThree is error {
        test:assertEquals(testThree.message(), "Invalid FHIR Path expression", msg = "Failed!");
    }
    json|error testFour = getFhirPathValues(samplePatient1, "Patient.meta.profile[8]");
    if testFour is error {
        test:assertEquals(testFour.message(), "The given array index is incorrect for the given FHIR resource", msg = "Failed!");
    }
    json|error testFive = getFhirPathValues(samplePatient1, "Patient.address.mor");
    if testFive is error {
        test:assertEquals(testFive.message(), "The given FhirPath expression is incorrect for the given FHIR resource", msg = "Failed!");
    }

    json|error testSix = getFhirPathValues(invalidFhirResource, "Patient.id");
    if testSix is error {
        test:assertEquals(testSix.message(), "Invalid FHIR resource", msg = "Failed!");
    }
}
