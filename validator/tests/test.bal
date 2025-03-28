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
    r4:FHIRValidationError? validationResult = validate(patientPayload, international401:Patient);
    if validationResult is r4:FHIRValidationError {
        test:assertFail(msg = "Validation failed");
    }
}

@test:Config{}
function testDatetimeErrorMessageParsing() {
    string errorMessage = string `Validation failed for '$.identifier[0].period.start:pattern' constraint(s).`;
    string[] parsedError = parseConstraintErrors(errorMessage);

    test:assertTrue(parsedError == ["Invalid pattern (constraint) for field 'identifier[0].period.start'"]);
}

@test:Config{}
function testResourceTypeParsing() {
    string errorMessage = string `Failed to find FHIR profile for the resource type : Psatient`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Resource type is invalid"]);
}

@test:Config{}
function testMissingFieldParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to Invalid JSON content detected, missing required element: "resourceType"`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Missing required Element: 'resourceType'"]);
}

@test:Config{}
function testMissingElementParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient':
                missing required field 'text.status' of type 'ballerinax/health.fhir.r4:4:StatusCode' in record 'health.fhir.r4:Narrative'`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Missing required field 'text.status'"]);
}

@test:Config{}
function testInvalidFieldParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient':
                value of field 'isd' adding to the record 'health.fhir.r4.international401:Patient' should be of type 'health.fhir.r4:Element', found '"example"'`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Invalid field 'isd'. Type of field should be 'health.fhir.r4:Element'"]);
}

@test:Config{}
function testInvalidFieldValueParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient':
                field 'telecom[1].system' in record 'health.fhir.r4:ContactPoint' should be of type 'ballerinax/health.fhir.r4:4:ContactPointSystem', found '1'`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Invalid value of field 'telecom[1].system'. Type of value should be 'ballerinax/health.fhir.r4:4:ContactPointSystem'"]);
}

@test:Config{}
function testInvalidArrayElements() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient':
                array element 'name[0].given[0]' should be of type 'string', found '1'`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Invalid array element 'name[0].given[0]'. Type of element should be 'string'"]);
}

@test:Config{}
function testMultityypeScenarioFieldParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient':
                {
                  missing required field 'contact[0].name._family.extension[0].valueCodeableConcept' of type 'health.fhir.r4:CodeableConcept' in record 'health.fhir.r4:CodeableConceptExtension'     
                  value of field 'valuaeString' adding to the record 'health.fhir.r4:CodeableConceptExtension' should be of type 'health.fhir.r4:Element', found '"VV"'
                or
                  missing required field 'contact[0].name._family.extension[0].valueString' of type 'string' in record 'health.fhir.r4:StringExtension'
                  value of field 'valuaeString' adding to the record 'health.fhir.r4:StringExtension' should be of type 'health.fhir.r4:Element', found '"VV"'
                or
                  missing required field 'contact[0].name._family.extension[0].valueCoding' of type 'health.fhir.r4:Coding' in record 'health.fhir.r4:CodingExtension'
                  value of field 'valuaeString' adding to the record 'health.fhir.r4:CodingExtension' should be of type 'health.fhir.r4:Element', found '"VV"'
                or
                  missing required field 'contact[0].name._family.extension[0].valueCode' of type 'health.fhir.r4:code' in record 'health.fhir.r4:CodeExtension'
                  value of field 'valuaeString' adding to the record 'health.fhir.r4:CodeExtension' should be of type 'health.fhir.r4:Element', found '"VV"'
                or
                  missing required field 'contact[0].name._family.extension[0].valueInteger' of type 'health.fhir.r4:integer' in record 'health.fhir.r4:IntegerExtension'
                  value of field 'valuaeString' adding to the record 'health.fhir.r4:IntegerExtension' should be of type 'health.fhir.r4:Element', found '"VV"'
                or
                  missing required field 'contact[0].name._family.extension[0].valueBase64Binary' of type 'health.fhir.r4:base64Binary' in record 'health.fhir.r4:Base64BinaryExtension'
                  value of field 'valuaeString' adding to the record 'health.fhir.r4:Base64BinaryExtension' should be of type 'health.fhir.r4:Element', found '"VV"'
                or
                  missing required field 'contact[0].name._family.extension[0].valueBoolean' of type 'boolean' in record 'health.fhir.r4:BooleanExtension'
                ...`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["The field 'valuaeString' should be of type value[x] or url[x] where x is a valid fhir data type"]);
}

@test:Config{}
function testMultityypeScenarioValueParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient': 
                {
                  missing required field 'contact[0].name._family.extension[0].valueCodeableConcept' of type 'health.fhir.r4:CodeableConcept' in record 'health.fhir.r4:CodeableConceptExtension'     
                  value of field 'valueString' adding to the record 'health.fhir.r4:CodeableConceptExtension' should be of type 'health.fhir.r4:Element', found '1'
                or
                  field 'contact[0].name._family.extension[0].valueString' in record 'health.fhir.r4:StringExtension' should be of type 'string', found '1'
                or
                  missing required field 'contact[0].name._family.extension[0].valueCoding' of type 'health.fhir.r4:Coding' in record 'health.fhir.r4:CodingExtension'
                  value of field 'valueString' adding to the record 'health.fhir.r4:CodingExtension' should be of type 'health.fhir.r4:Element', found '1'
                or
                  missing required field 'contact[0].name._family.extension[0].valueCode' of type 'health.fhir.r4:code' in record 'health.fhir.r4:CodeExtension'
                  value of field 'valueString' adding to the record 'health.fhir.r4:CodeExtension' 
                  should be of type 'health.fhir.r4:Element', found '1'
                or
                  missing required field 'contact[0].name._family.extension[0].valueInteger' of type 'health.fhir.r4:integer' in record 'health.fhir.r4:IntegerExtension'
                  value of field 'valueString' adding to the record 'health.fhir.r4:IntegerExtension' should be of type 'health.fhir.r4:Element', found '1'
                or
                  missing required field 'contact[0].name._family.extension[0].valueBase64Binary' of type 'health.fhir.r4:base64Binary' in record 'health.fhir.r4:Base64BinaryExtension'
                  value of field 'valueString' adding to the record 'health.fhir.r4:Base64BinaryExtension' should be of type 'health.fhir.r4:Element', found '1'
                or
                  missing required field 'contact[0].name._family.extension[0].valueBoolean' of type 'boolean' in record 'health.fhir.r4:BooleanExtension'
                  value of field 'valueString' adding to the record 'health.fhir.r4:BooleanExtension' should be of type 'health.fhir.r4:Element', found '1'
                ...`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["The field 'contact[0].name._family.extension[0].valueString' should be of type value[x] or url[x] where x is a valid fhir data type"]);
}
