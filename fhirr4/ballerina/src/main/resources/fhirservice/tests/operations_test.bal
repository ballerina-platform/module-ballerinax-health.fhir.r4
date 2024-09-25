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

import ballerina/http;
import ballerina/log;
import ballerina/test;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.parser;

Listener fhirOperationsListener = check new (9295, operationsApiConfig);
http:Client fhirOperationsClient = check new ("http://localhost:9295/fhir/r4");

@test:BeforeGroups {value: ["Operations"]}
function startOperationsService() returns error? {
    check fhirOperationsListener.attach(fhirOperationsService);
    check fhirOperationsListener.'start();
    log:printInfo("FHIR operations test service has started");
}

@test:Config {groups: ["Operations"]}
function testValidGetInvokedOperation() returns error? {
    international401:Parameters|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/$translate?url=http://hl7.org/fhir/");
    test:assertTrue(response is international401:Parameters);
}

@test:Config {groups: ["Operations"]}
function testValidGetInvokedBaseOperation() returns error? {
    // The operation '$meta' is a base operation for all resource types
    r4:Meta|ServiceTestError? response = check fhirOperationsClient->get("/ConceptMap/$meta");
    test:assertTrue(response is r4:Meta);
}

@test:Config {groups: ["Operations"]}
function testInvalidGetInvokedOperation() returns error? {
    // The operations '$find-matches' is not a valid operation for the 'ConceptMap' resource type
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/$find-matches?system=http://hl7.org/fhir/composition-status");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testInvalidGetInvokedOperationWithUnsupportedOperation() returns error? {
    // The operation '$closure' is not supported by the API
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/$closure?name=patient-problems");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Unsupported operation"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testInvalidGetInvokedOperationWithInvalidScope() returns error? {
    // The '$translate' operation is not allowed in the system scope
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/$translate?url=http://hl7.org/fhir/");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Invalid operation scope"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testInvalidGetInvokedOperationWithTooFewParams() returns error? {
    // The mandatory param 'url' defined in API config is missing in this request
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/$translate?dependency.element=http://hl7.org/fhir/");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Too few operation parameters"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testInvalidGetInvokedOperationWithTooManyParams() returns error? {
    // The operation parameter 'system' count exceeds the limit defined in the API config
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/23224/$translate?url=http://hl7.org/fhir/&system=http://hl7.org/fhir/&system=http://hl7.org/fhir/&system=http://hl7.org/fhir/");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Too many operation parameters"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testInvalidGetInvokedOperationWithInvalidParam() returns error? {
    // The param 'codeA' is not a valid param of the '$translate' operation
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/$translate?url=http://hl7.org/fhir/&codeA=365786009");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Unknown operation parameter"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testValidGetInvokedOperationWithUnsupportedParam() returns error? {
    // The param 'version' is unsupported for the '$translate' operation
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/$translate?url=http://hl7.org/fhir/&version=1");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Unsupported operation parameter"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testInvalidGetInvokedOperationWithInvalidParamScope() returns error? {
    // The 'system' parameter is only supported at the instance level as per the API configuration, not at the type level
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/$translate?url=http://hl7.org/fhir/&version=1&system=http://hl7.org/fhir/composition-status");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Invalid operation parameter scope"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testInvalidGetInvokedOperationWithNonPrimitiveParam() returns error? {
    // The 'conceptMap' parameter is a resource type, not a primitive type
    // Therefore, it cannot be used using an HTTP GET method
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/$translate?url=http://hl7.org/fhir/&conceptMap={}");
    if response is http:Response {
        test:assertEquals(response.statusCode, 405);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Invalid operation invocation"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testValidGetInvokedOperationWithMultiPartParam() returns error? {
    international401:Parameters|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/$translate?url=http://hl7.org/fhir/&dependency.element=http://hl7.org/fhir/");
    test:assertTrue(response is international401:Parameters);
}

@test:Config {groups: ["Operations"]}
function testInvalidGetInvokedOperationWithMultiPartParamWithoutParts() returns error? {
    // The 'dependency' parameter is a multi-part parameter and it should be invoked with its parts
    http:Response|ServiceTestError response =
            check fhirOperationsClient->get("/ConceptMap/$translate?dependency={}");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Invalid operation invocation"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config {groups: ["Operations"]}
function testValidPostInvokedOperation() returns error? {
    json payload = {
        "resourceType": "Parameters",
        "parameter": [
            {
                "name": "url",
                "valueUri": "http://hl7.org/fhir/"
            },
            {
                "name": "dependency",
                "part": [
                    {
                        "name": "element",
                        "valueUri": "http://hl7.org/fhir/"
                    }
                ]
            }
        ]
    };
    international401:Parameters|ServiceTestError response = check fhirOperationsClient->post("/ConceptMap/$translate",
            message = payload, mediaType = r4:FHIR_MIME_TYPE_JSON);
    test:assertTrue(response is international401:Parameters);
}

@test:Config {groups: ["Operations"]}
function testInvalidPostInvokedOperationWithInvalidPayload() returns error? {
    json invalidPayload = {
        "resourceType": "Parameters",
        "parameter": [
            {
                "name": "invalidParameter",
                "invalidValue": "someInvalidValue"
            }
        ]
    };
    http:Response|ServiceTestError response = check fhirOperationsClient->post("/ConceptMap/$translate",
            message = invalidPayload, mediaType = r4:FHIR_MIME_TYPE_JSON);
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        string|error diagnostic = extractIssueTextFromOperationOutcomeResponse(response);
        if diagnostic is string {
            test:assertTrue(diagnostic.startsWith("Invalid operation payload"));
        } else {
            test:assertFail(diagnostic.message());
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:AfterGroups {value: ["Operations"]}
function stopOperationsService() returns error? {
    check fhirOperationsListener.gracefulStop();
    log:printInfo("FHIR operations test service has stopped");
}

// Helper function to extract the issue text from an operation outcome response
function extractIssueTextFromOperationOutcomeResponse(http:Response response) returns string|error {
    json operationOutcome = check response.getJsonPayload();
    anydata operationOutcomeStruct = check parser:parse(operationOutcome);
    if operationOutcomeStruct is r4:OperationOutcome {
        r4:CodeableConcept? details = operationOutcomeStruct.issue[0].details;
        if details is r4:CodeableConcept {
            string? text = details.text;
            if text is string {
                return text;
            } else {
                return error("Error in extracting details text from operation outcome");
            }
        } else {
            return error("Error in extracting details from operation outcome");
        }
    } else {
        return error("Error in parsing the response payload");
    }
}
