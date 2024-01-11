// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).

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

import ballerina/constraint;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.uscore501;
import ballerina/test;
import ballerina/http;

@test:Config{}
function testValidate() {
    json body = {
      "resourceType": "Patient",
      "id": "591841",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-01-22T05:30:13.137+00:00",
        "source": "#KO38Q3spgrJoP5fa"
      },
      "identifier": [ {
        "type": {
          "coding": [ {
            "system": "http://hl7.org/fhir/v2/0203",
            "code": "MR"
          } ]
        },
        "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
      } ],
      "name": [ {
        "family": "Cushing",
        "given": [ "Caleb" ]
      } ],
      "birthDate": "2000-01-01"
    };
    r4:FHIRValidationError? validationResult = validate(body);
    if validationResult is r4:FHIRValidationError {
        test:assertFail(msg = "Validation failed");
    }
}

@test:Config{}
function testValidateConstrainError() {
    json body = {
      "resourceType": "Patient",
      "id": "591841",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-01-22T05:30:13.137+00:00",
        "source": "#KO38Q3spgrJoP5fa"
      },
      "identifier": [ {
        "type": {
          "coding": [ {
            "system": "http://hl7.org/fhir/v2/0203",
            "code": "MR"
          } ]
        },
        "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
      } ],
      "name": [ {
        "family": "Cushing",
        "given": [ "Caleb" ]
      } ],
      "birthDate": "aabbcc"
    };
    r4:FHIRValidationError? validationResult = validate(body);
    if validationResult is r4:FHIRValidationError {
        test:assertTrue(validationResult.cause() is constraint:Error);
        test:assertEquals(validationResult.detail().httpStatusCode, http:STATUS_BAD_REQUEST);
    } else {
        test:assertFail(msg = "Expected error is not thrown");
    }
}

@test:Config{}
function testValidateParseError() {
    json body = {
      "id": "591841",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-01-22T05:30:13.137+00:00",
        "source": "#KO38Q3spgrJoP5fa"
      },
      "identifier": [ {
        "type": {
          "coding": [ {
            "system": "http://hl7.org/fhir/v2/0203",
            "code": "MR"
          } ]
        },
        "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
      } ],
      "name": [ {
        "family": "Cushing",
        "given": [ "Caleb" ]
      } ],
      "birthDate": "2000-01-01"
    };
    r4:FHIRValidationError? validationResult = validate(body);
    if validationResult is r4:FHIRValidationError {
        test:assertTrue(validationResult.cause() is r4:FHIRParseError);
        // test:assertEquals(validationResult.detail().httpStatusCode, http:STATUS_BAD_REQUEST);
    } else {
        test:assertFail(msg = "Expected error is not thrown");
    }
}

@test:Config{}
function testXml(){
    xml x = xml `<test>test</test>`;
    r4:FHIRValidationError? validationResult = validate(x);
    test:assertTrue(validationResult is r4:FHIRValidationError);
    if validationResult is r4:FHIRValidationError {
        test:assertEquals(validationResult.detail().httpStatusCode, http:STATUS_NOT_IMPLEMENTED);
    } else {
        test:assertFail(msg = "Expected error is not thrown");
    }
}

@test:Config{}
function testRecord() {
    international401:Patient p = {
        id: "591841",
        birthDate: "2000-01-01"
    };    
    r4:FHIRValidationError? validationResult = validate(p);
    if validationResult is r4:FHIRValidationError {
        test:assertFail(msg = "Validation failed");
    }
}

@test:Config{}
function testRecordConstraintError() {
    international401:Patient p = {
        id: "591841",
        birthDate: "abcdef"
    };    
    r4:FHIRValidationError? validationResult = validate(p);
    if validationResult is r4:FHIRValidationError {
        test:assertTrue(validationResult.cause() is constraint:Error);
        test:assertEquals(validationResult.detail().httpStatusCode, http:STATUS_BAD_REQUEST);
    } else {
        test:assertFail(msg = "Expected error is not thrown");
    }
}

@test:Config{}
function testInvalidPayload(){
    record {string name; int age;} random = {name: "vijay", age: 30};
    r4:FHIRValidationError? validationResult = validate(random);
    test:assertTrue(validationResult is r4:FHIRValidationError);
    if validationResult is r4:FHIRValidationError {
        test:assertEquals(validationResult.detail().httpStatusCode, http:STATUS_BAD_REQUEST);
    } else {
        test:assertFail(msg = "Expected error is not thrown");
    }
}

@test:Config{}
function testTargetType() {
    json patientPayload = {
        "resourceType": "Patient",
        "id": "example-patient",
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">John Doe</div>"
        },
        "identifier": [
            {
                "system": "http://example.com/patient-ids",
                "value": "12345"
            }
        ],
        "extension": [
            {
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
                "valueCodeableConcept": {
                    "coding": [
                        {
                            "system": "http://hl7.org/fhir/v3/Race",
                            "code": "2106-3",
                            "display": "White"
                        }
                    ]
                }
            }
        ],
        "name": [
            {
                "use": "official",
                "family": "Doe",
                "given": [
                    "John"
                ]
            }
        ],
        "gender": "male",
        "birthDate": "2000-01-01"
    };
    r4:FHIRValidationError? validationResult = validate(patientPayload, uscore501:USCorePatientProfile);
    if validationResult is r4:FHIRValidationError {
        test:assertFail(msg = "Validation failed");
    }
}
