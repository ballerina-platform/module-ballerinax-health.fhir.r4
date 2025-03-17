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

type Patient record {|
    *DomainResource;

    string resourceType;
    code language?;
    dateTime deceasedDateTime?;
    Reference[] generalPractitioner?;
    ContactPoint[] telecom?;
    string id?;
    Identifier[] identifier?;
    Address[] address?;
    boolean active?;
    Attachment[] photo?;
    date birthDate?;
    boolean deceasedBoolean?;
    HumanName[] name?;
    CodeableConcept maritalStatus?;
    Element...;
|};

type RelatedPerson record {|
    *DomainResource;

    string resourceType;
    code language?;
    ContactPoint[] telecom?;
    string id?;
    Identifier[] identifier?;
    Address[] address?;
    boolean active?;
    Attachment[] photo?;
    date birthDate?;
    boolean deceasedBoolean?;
    HumanName[] name?;
    CodeableConcept maritalStatus?;
    Element...;
|};

@test:Config {}
public function subTypingTest() {

    // The following example is a simple serialized Patient resource to parse
    json input = {
        "resourceType": "Patient",
        "name": [
            {
                "family": "Simpson"
            }
        ]
    };

    // Parse it - you can pass the input (as a string or a json) and the
    // type of the resource you want to parse.
    Patient|error patient = input.fromJsonWithType(Patient);
    test:assertTrue(patient is DomainResource, msg = "FHIR resource is not a Domain Resource. " +
            "Every FHIR resource should be a Domain Resource.");
}

@test:Config {}
public function containedResourceInclusionTest() {

    json patientPayload = {
        "resourceType": "Patient",
        "name": [
            {
                "given": ["Homer"],
                "family": "Simpson"
            }
        ],
        "contained": [
            {
                "resourceType": "RelatedPerson",
                "name": [
                    {
                        "given": ["Bart"],
                        "family": "Simpson"
                    }
                ]
            }
        ]
    };

    RelatedPerson relatedPerson = {
        resourceType: "RelatedPerson",
        name: [
            {
                given: ["Adam"],
                family: "Smith"
            }
        ]
    };

    Patient|error parsedPatient = patientPayload.fromJsonWithType(Patient);
    test:assertTrue(parsedPatient is Patient, msg = "Failed to parse the patient resource.");

    if parsedPatient is Patient {
        Resource[]? containedResult = parsedPatient.contained;
        if containedResult is Resource[] {
            test:assertTrue(containedResult.length() == 1, msg = "Failed to parse the contained resource.");
            containedResult.push(relatedPerson);
            test:assertTrue(containedResult.length() == 2, msg = "Failed to add the related person to the contained resource.");
        }
    }
};
