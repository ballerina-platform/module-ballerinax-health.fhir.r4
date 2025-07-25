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
import ballerina/http;
import ballerina/test;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.uscore700;

@test:Config {}
function testValidate1() {
    json body = {
        "resourceType": "Patient",
        "id": "591841",
        "meta": {
            "versionId": "1",
            "lastUpdated": "2020-01-22T05:30:13.137+00:00",
            "source": "#KO38Q3spgrJoP5fa"
        },
        "identifier": [
            {
                "type": {
                    "coding": [
                        {
                            "system": "http://hl7.org/fhir/v2/0203",
                            "code": "MR"
                        }
                    ]
                },
                "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
            }
        ],
        "name": [
            {
                "family": "Cushing",
                "given": ["Caleb"]
            }
        ],
        "birthDate": "2000-01-01"
    };
    r4:FHIRValidationError? validationResult = validate(body);
    if validationResult is r4:FHIRValidationError {
        test:assertFail(msg = "Validation failed");
    }
}

@test:Config {}
function testValidate2() {
    json body = {
        "resourceType": "AllergyIntolerance",
        "id": "example",
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: AllergyIntolerance</b><a name=\"example\"> </a><a name=\"hcexample\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource AllergyIntolerance &quot;example&quot; </p><p style=\"margin-bottom: 0px\">Profile: <a href=\"StructureDefinition-us-core-allergyintolerance.html\">US Core AllergyIntolerance Profile (version 7.0.0)</a></p></div><p><b>clinicalStatus</b>: Active <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.5.0/CodeSystem-allergyintolerance-clinical.html\">AllergyIntolerance Clinical Status Codes</a>#active)</span></p><p><b>verificationStatus</b>: Confirmed <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.5.0/CodeSystem-allergyintolerance-verification.html\">AllergyIntolerance Verification Status</a>#confirmed)</span></p><p><b>category</b>: medication</p><p><b>criticality</b>: high</p><p><b>code</b>: sulfonamide antibacterial <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT[US]</a>#763875007 &quot;Product containing sulfonamide (product)&quot;)</span></p><p><b>patient</b>: <a href=\"Patient-example.html\">Patient/example: Amy V. Shaw</a> &quot; SHAW&quot;</p><h3>Reactions</h3><table class=\"grid\"><tr><td style=\"display: none\">-</td><td><b>Manifestation</b></td><td><b>Severity</b></td></tr><tr><td style=\"display: none\">*</td><td>skin rash <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT[US]</a>#271807003)</span></td><td>mild</td></tr></table></div>"
        },
        "clinicalStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                    "code": "active"
                }
            ]
        },
        "verificationStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
                    "code": "confirmed"
                }
            ]
        },
        "category": ["medication"],
        "criticality": "high",
        "code": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "version": "http://snomed.info/sct/731000124108",
                    "code": "763875007",
                    "display": "Product containing sulfonamide (product)"
                }
            ],
            "text": "sulfonamide antibacterial"
        },
        "patient": {
            "reference": "Patient/example",
            "display": "Amy V. Shaw"
        },
        "reaction": [
            {
                "manifestation": [
                    {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "version": "http://snomed.info/sct/731000124108",
                                "code": "271807003",
                                "display": "skin rash"
                            }
                        ],
                        "text": "skin rash"
                    }
                ],
                "severity": "mild"
            }
        ]
    };
    r4:FHIRValidationError? validationResult = validate(body);
    if validationResult is r4:FHIRValidationError {
        test:assertFail(msg = "Validation failed");
    }
}

@test:Config {}
function testValidateTerminologyError() {
    json body = {
        "resourceType": "AllergyIntolerance",
        "id": "example",
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: AllergyIntolerance</b><a name=\"example\"> </a><a name=\"hcexample\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource AllergyIntolerance &quot;example&quot; </p><p style=\"margin-bottom: 0px\">Profile: <a href=\"StructureDefinition-us-core-allergyintolerance.html\">US Core AllergyIntolerance Profile (version 7.0.0)</a></p></div><p><b>clinicalStatus</b>: Active <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.5.0/CodeSystem-allergyintolerance-clinical.html\">AllergyIntolerance Clinical Status Codes</a>#active)</span></p><p><b>verificationStatus</b>: Confirmed <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.5.0/CodeSystem-allergyintolerance-verification.html\">AllergyIntolerance Verification Status</a>#confirmed)</span></p><p><b>category</b>: medication</p><p><b>criticality</b>: high</p><p><b>code</b>: sulfonamide antibacterial <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT[US]</a>#763875007 &quot;Product containing sulfonamide (product)&quot;)</span></p><p><b>patient</b>: <a href=\"Patient-example.html\">Patient/example: Amy V. Shaw</a> &quot; SHAW&quot;</p><h3>Reactions</h3><table class=\"grid\"><tr><td style=\"display: none\">-</td><td><b>Manifestation</b></td><td><b>Severity</b></td></tr><tr><td style=\"display: none\">*</td><td>skin rash <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT[US]</a>#271807003)</span></td><td>mild</td></tr></table></div>"
        },
        "clinicalStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                    "code": "active"
                }
            ]
        },
        "verificationStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
                    "code": "invalid_term" // invalid code
                }
            ]
        },
        "category": ["medication"],
        "criticality": "high",
        "code": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "version": "http://snomed.info/sct/731000124108",
                    "code": "763875007",
                    "display": "Product containing sulfonamide (product)"
                }
            ],
            "text": "sulfonamide antibacterial"
        },
        "patient": {
            "reference": "Patient/example",
            "display": "Amy V. Shaw"
        },
        "reaction": [
            {
                "manifestation": [
                    {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "version": "http://snomed.info/sct/731000124108",
                                "code": "271807003",
                                "display": "skin rash"
                            }
                        ],
                        "text": "skin rash"
                    }
                ],
                "severity": "mild"
            }
        ]
    };
    r4:FHIRValidationError? validationResult = validate(body);
    if validationResult is r4:FHIRValidationError {
        test:assertEquals(validationResult.detail().httpStatusCode, http:STATUS_BAD_REQUEST);
    }
}

@test:Config {}
function testValidateConstrainError() {
    json body = {
        "resourceType": "Patient",
        "id": "591841",
        "meta": {
            "versionId": "1",
            "lastUpdated": "2020-01-22T05:30:13.137+00:00",
            "source": "#KO38Q3spgrJoP5fa"
        },
        "identifier": [
            {
                "type": {
                    "coding": [
                        {
                            "system": "http://hl7.org/fhir/v2/0203",
                            "code": "MR"
                        }
                    ]
                },
                "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
            }
        ],
        "name": [
            {
                "family": "Cushing",
                "given": ["Caleb"]
            }
        ],
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

@test:Config {}
function testValidateParseError() {
    json body = {
        "id": "591841",
        "meta": {
            "versionId": "1",
            "lastUpdated": "2020-01-22T05:30:13.137+00:00",
            "source": "#KO38Q3spgrJoP5fa"
        },
        "identifier": [
            {
                "type": {
                    "coding": [
                        {
                            "system": "http://hl7.org/fhir/v2/0203",
                            "code": "MR"
                        }
                    ]
                },
                "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
            }
        ],
        "name": [
            {
                "family": "Cushing",
                "given": ["Caleb"]
            }
        ],
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

@test:Config {}
function testXml() {
    xml x = xml `<test>test</test>`;
    r4:FHIRValidationError? validationResult = validate(x);
    test:assertTrue(validationResult is r4:FHIRValidationError);
    if validationResult is r4:FHIRValidationError {
        test:assertEquals(validationResult.detail().httpStatusCode, http:STATUS_NOT_IMPLEMENTED);
    } else {
        test:assertFail(msg = "Expected error is not thrown");
    }
}

@test:Config {}
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

@test:Config {}
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

@test:Config {}
function testInvalidPayload() {
    record {string name; int age;} random = {name: "vijay", age: 30};
    r4:FHIRValidationError? validationResult = validate(random);
    test:assertTrue(validationResult is r4:FHIRValidationError);
    if validationResult is r4:FHIRValidationError {
        test:assertEquals(validationResult.detail().httpStatusCode, http:STATUS_BAD_REQUEST);
    } else {
        test:assertFail(msg = "Expected error is not thrown");
    }
}

@test:Config {}
function testTargetType1() {
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

@test:Config {}
function testTargetType2() {
    json testPayload = {
        "resourceType": "AllergyIntolerance",
        "id": "example",
        "meta": {
            "profile": ["http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance"]
        },
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: AllergyIntolerance</b><a name=\"example\"> </a><a name=\"hcexample\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource AllergyIntolerance &quot;example&quot; </p><p style=\"margin-bottom: 0px\">Profile: <a href=\"StructureDefinition-us-core-allergyintolerance.html\">US Core AllergyIntolerance Profile (version 7.0.0)</a></p></div><p><b>clinicalStatus</b>: Active <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.5.0/CodeSystem-allergyintolerance-clinical.html\">AllergyIntolerance Clinical Status Codes</a>#active)</span></p><p><b>verificationStatus</b>: Confirmed <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.5.0/CodeSystem-allergyintolerance-verification.html\">AllergyIntolerance Verification Status</a>#confirmed)</span></p><p><b>category</b>: medication</p><p><b>criticality</b>: high</p><p><b>code</b>: sulfonamide antibacterial <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT[US]</a>#763875007 &quot;Product containing sulfonamide (product)&quot;)</span></p><p><b>patient</b>: <a href=\"Patient-example.html\">Patient/example: Amy V. Shaw</a> &quot; SHAW&quot;</p><h3>Reactions</h3><table class=\"grid\"><tr><td style=\"display: none\">-</td><td><b>Manifestation</b></td><td><b>Severity</b></td></tr><tr><td style=\"display: none\">*</td><td>skin rash <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT[US]</a>#271807003)</span></td><td>mild</td></tr></table></div>"
        },
        "clinicalStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                    "code": "active"
                }
            ]
        },
        "verificationStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
                    "code": "confirmed"
                }
            ]
        },
        "category": ["medication"],
        "criticality": "high",
        "code": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "version": "http://snomed.info/sct/731000124108",
                    "code": "763875007",
                    "display": "Product containing sulfonamide (product)"
                }
            ],
            "text": "sulfonamide antibacterial"
        },
        "patient": {
            "reference": "Patient/example",
            "display": "Amy V. Shaw"
        },
        "reaction": [
            {
                "manifestation": [
                    {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "version": "http://snomed.info/sct/731000124108",
                                "code": "271807003",
                                "display": "skin rash"
                            }
                        ],
                        "text": "skin rash"
                    }
                ],
                "severity": "mild"
            }
        ]
    };
    r4:FHIRValidationError? validationResult = validate(testPayload, uscore700:USCoreAllergyIntolerance);
    if validationResult is r4:FHIRValidationError {
        test:assertFail(msg = "Validation failed");
    }
}

@test:Config {}
function testValidateTerminologySystemNotDefinedInPackage() {
    json body = {
        "resourceType": "Patient",
        "extension": [
            {
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
                "extension": [
                    {
                        "url": "ombCategory",
                        "valueCoding": {
                            "system": "urn:oid:2.16.840.1.113883.6.238",
                            "code": "2106-3",
                            "display": "White"
                        }
                    },
                    {
                        "url": "ombCategory",
                        "valueCoding": {
                            "system": "urn:oid:2.16.840.1.113883.6.238",
                            "code": "1002-5",
                            "display": "American Indian or Alaska Native"
                        }
                    },
                    {
                        "url": "ombCategory",
                        "valueCoding": {
                            "system": "urn:oid:2.16.840.1.113883.6.238",
                            "code": "2028-9",
                            "display": "Asian"
                        }
                    },
                    {
                        "url": "detailed",
                        "valueCoding": {
                            "system": "urn:oid:2.16.840.1.113883.6.238",
                            "code": "1586-7",
                            "display": "Shoshone"
                        }
                    },
                    {
                        "url": "detailed",
                        "valueCoding": {
                            "system": "urn:oid:2.16.840.1.113883.6.238",
                            "code": "2036-2",
                            "display": "Filipino"
                        }
                    },
                    {
                        "url": "text",
                        "valueString": "Mixed"
                    }
                ]
            },
            {
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity",
                "extension": [
                    {
                        "url": "ombCategory",
                        "valueCoding": {
                            "system": "urn:oid:2.16.840.1.113883.6.238",
                            "code": "2135-2",
                            "display": "Hispanic or Latino"
                        }
                    },
                    {
                        "url": "detailed",
                        "valueCoding": {
                            "system": "urn:oid:2.16.840.1.113883.6.238",
                            "code": "2184-0",
                            "display": "Dominican"
                        }
                    },
                    {
                        "url": "detailed",
                        "valueCoding": {
                            "system": "urn:oid:2.16.840.1.113883.6.238",
                            "code": "2148-5",
                            "display": "Mexican"
                        }
                    },
                    {
                        "url": "text",
                        "valueString": "Hispanic or Latino"
                    }
                ]
            },
            {
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex",
                "valueCode": "F"
            }
        ],
        "gender": "female",
        "telecom": [
            {
                "system": "phone",
                "use": "home",
                "value": "555-555-5555"
            },
            {
                "system": "email",
                "value": "amy.shaw@example.com"
            }
        ],
        "id": "101",
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n\t\t\t<p>\n\t\t\t\t<b>Generated Narrative with Details</b>\n\t\t\t</p>\n\t\t\t<p>\n\t\t\t\t<b>id</b>: example</p>\n\t\t\t<p>\n\t\t\t\t<b>identifier</b>: Medical Record Number = 1032702 (USUAL)</p>\n\t\t\t<p>\n\t\t\t\t<b>active</b>: true</p>\n\t\t\t<p>\n\t\t\t\t<b>name</b>: Amy V. Shaw </p>\n\t\t\t<p>\n\t\t\t\t<b>telecom</b>: ph: 555-555-5555(HOME), amy.shaw@example.com</p>\n\t\t\t<p>\n\t\t\t\t<b>gender</b>: </p>\n\t\t\t<p>\n\t\t\t\t<b>birthsex</b>: Female</p>\n\t\t\t<p>\n\t\t\t\t<b>birthDate</b>: Feb 20, 2007</p>\n\t\t\t<p>\n\t\t\t\t<b>address</b>: 49 Meadow St Mounds OK 74047 US </p>\n\t\t\t<p>\n\t\t\t\t<b>race</b>: White, American Indian or Alaska Native, Asian, Shoshone, Filipino</p>\n\t\t\t<p>\n\t\t\t\t<b>ethnicity</b>: Hispanic or Latino, Dominican, Mexican</p>\n\t\t</div>"
        },
        "identifier": [
            {
                "system": "http://hospital.smarthealthit.org",
                "use": "usual",
                "type": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                            "code": "MR",
                            "display": "Medical Record Number"
                        }
                    ],
                    "text": "Medical Record Number"
                },
                "value": "1032702"
            }
        ],
        "address": [
            {
                "country": "US",
                "city": "Mounds",
                "line": [
                    "49 Meadow St"
                ],
                "postalCode": "74047",
                "state": "OK"
            }
        ],
        "active": true,
        "birthDate": "2007-02-20",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
            ]
        },
        "name": [
            {
                "given": [
                    "Jack",
                    "V."
                ],
                "family": "Shaw"
            }
        ]
    };
    r4:FHIRValidationError? validationResult = validate(body, uscore700:USCorePatientProfile);
    if validationResult is r4:FHIRValidationError {
        test:assertFail(msg = "Validation failed");
    }
}

@test:Config {}
function testDatetimeErrorMessageParsing() {
    string errorMessage = string `Validation failed for '$.identifier[0].period.start:pattern' constraint(s).`;
    string[] parsedError = parseConstraintErrors(errorMessage);

    test:assertTrue(parsedError == ["Invalid pattern (constraint) for field 'identifier[0].period.start'"]);
}

@test:Config {}
function testResourceTypeParsing() {
    string errorMessage = string `Failed to find FHIR profile for the resource type : Psatient`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Resource type is invalid"]);
}

@test:Config {}
function testMissingFieldParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to Invalid JSON content detected, missing required element: "resourceType"`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Missing required Element: 'resourceType'"]);
}

@test:Config {}
function testMissingElementParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient':
                missing required field 'text.status' of type 'ballerinax/health.fhir.r4:4:StatusCode' in record 'health.fhir.r4:Narrative'`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Missing required field 'text.status'"]);
}

@test:Config {}
function testInvalidFieldParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient':
                value of field 'isd' adding to the record 'health.fhir.r4.international401:Patient' should be of type 'health.fhir.r4:Element', found '"example"'`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Invalid field 'isd'. Type of field should be 'health.fhir.r4:Element'"]);
}

@test:Config {}
function testInvalidFieldValueParsing() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient':
                field 'telecom[1].system' in record 'health.fhir.r4:ContactPoint' should be of type 'ballerinax/health.fhir.r4:4:ContactPointSystem', found '1'`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Invalid value of field 'telecom[1].system'. Type of value should be 'ballerinax/health.fhir.r4:4:ContactPointSystem'"]);
}

@test:Config {}
function testInvalidArrayElements() {
    string errorMessage = string `Failed to parse request body as JSON resource due to 'map<json>' value cannot be converted to 'health.fhir.r4.international401:Patient':
                array element 'name[0].given[0]' should be of type 'string', found '1'`;
    string[] parsedError = processFHIRParserErrors(errorMessage);

    test:assertTrue(parsedError == ["Invalid array element 'name[0].given[0]'. Type of element should be 'string'"]);
}

@test:Config {}
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

@test:Config {}
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
