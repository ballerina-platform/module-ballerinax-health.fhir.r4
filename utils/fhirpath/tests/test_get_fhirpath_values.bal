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
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.id"), ["1"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address[0].line[0]"), ["534 Erewhon St"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.line[1]"), ["sqw"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address[0].city"), ["PleasantVille"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address[1].line[0]"), ["33[0] 6th St"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address[1].city"), ["Melbourne"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name[0].use"), ["official"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name[0].given[0]"), ["Peter"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.active"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.managingOrganization.reference"), ["Organization/1"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.managingOrganization.display"), ["Burgers University Medical Center"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.use"), ["home", "work"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.given"), ["Peter", "James", "Jim"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name[0].given"), ["Peter", "James"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.given[0]"), ["Peter"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.meta.profile[8]"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.mor"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(sampleOrganization1, "Organization.address.use"), ["work"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(sampleOrganization1, "Organization.language"), ["eng"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(sampleOrganization1, "Organization.contact[0].address.line"), ["33[0] 6th St"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.address.city"), ["PleasantVille", "Melbourne"], msg = "Failed!");
    // Evaluating resources when the current result is no longer a map but when there are 
    // still tokens to process. (Patient.active is a boolean) 
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.active.invalidPath"), [], msg = "Failed!");
    // Evaluating resources from a regular token processing array elements.
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name.invalidPath"), [], msg = "Failed!");

    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.mother[a]"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "Patient.name[0].given[a]"), [], msg = "Failed!");

    json|error testThree = getValuesFromFhirPath(invalidFhirResource, "Patient.id");
    if testThree is error {
        test:assertEquals(testThree.message(), "Invalid FHIR resource", msg = "Failed!");
    }
}

@test:Config {}
public function testEvaluateFhirPathWithoutResourceType() returns error? {
    // Unit Test for HappyPaths without resource type prefix.
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "id"), ["1"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address[0].line[0]"), ["534 Erewhon St"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.line[1]"), ["sqw"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address[0].city"), ["PleasantVille"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address[1].line[0]"), ["33[0] 6th St"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address[1].city"), ["Melbourne"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name[0].use"), ["official"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name[0].given[0]"), ["Peter"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "active"), [true], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "managingOrganization.reference"), ["Organization/1"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "managingOrganization.display"), ["Burgers University Medical Center"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.use"), ["home", "work"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.given"), ["Peter", "James", "Jim"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name[0].given"), ["Peter", "James"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name.given[0]"), ["Peter"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "meta.profile[8]"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.mor"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(sampleOrganization1, "address.use"), ["work"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(sampleOrganization1, "language"), ["eng"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(sampleOrganization1, "contact[0].address.line"), ["33[0] 6th St"], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "address.city"), ["PleasantVille", "Melbourne"], msg = "Failed!");

    test:assertEquals(getValuesFromFhirPath(samplePatient1, "mother[a]"), [], msg = "Failed!");
    test:assertEquals(getValuesFromFhirPath(samplePatient1, "name[0].given[a]"), [], msg = "Failed!");

    json|error test3 = getValuesFromFhirPath(invalidFhirResource, "id");
    if test3 is error {
        test:assertEquals(test3.message(), "Invalid FHIR resource", msg = "Failed!");
    }
}
