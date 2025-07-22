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
import ballerina/http;
import ballerina/log;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.parser;
import ballerinax/health.fhir.r4;

Listener fhirListener = check new (9292, apiConfig);
http:Client fhirClient = check new ("http://localhost:9292/fhir/r4");

@test:BeforeGroups { value:["FhirService"] }
function startService() returns error? {
    check fhirListener.attach(fhirService);
    check fhirListener.'start();
    log:printInfo("FHIR test service has started");
}

@test:Config { groups: ["FhirService"] }
function testRead() returns error? {
    international401:Patient|ServiceTestError response = check fhirClient->get("/Patient/1");
    test:assertTrue(response is international401:Patient);
}

@test:Config { groups: ["FhirService"] }
function testVRead() returns error? {
    international401:Patient|ServiceTestError response = check fhirClient->get("/Patient/1/_history/1");
    test:assertTrue(response is international401:Patient);
}

@test:Config { groups: ["FhirService"] }
function testSearch() returns error? {
    r4:Bundle|ServiceTestError response = check fhirClient->get("/Patient?_id=1");
    test:assertTrue(response is r4:Bundle);
}

@test:Config { groups: ["FhirService"] }
function testSearchUnsupportedSearchParam() returns error? {
    http:Response|ServiceTestError response = check fhirClient->get("/Patient?parent=1");
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        json operationOutcome = check response.getJsonPayload();
        anydata operationOutcomeStruct = check parser:parse(operationOutcome);
        if operationOutcomeStruct is r4:OperationOutcome {
            r4:CodeableConcept? details = operationOutcomeStruct.issue[0].details;
            if details is r4:CodeableConcept {
                // casting directly since this operation outcome is populated internally 
                // and the text is always a string
                test:assertTrue((<string>details.text).startsWith("Unknown search parameter"));
            } else {
                test:assertFail("Error in extracting details from operation outcome");
            }
        } else {
            test:assertFail("Error in parsing the response payload");
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService"] }
function testUpdate() returns error? {
    international401:Patient patient = {
        resourceType: "Patient",
        id: "1",
        name: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ]
    };
    http:Response|ServiceTestError response = check fhirClient->put("/Patient/1", message = patient, mediaType = r4:FHIR_MIME_TYPE_JSON);
    test:assertTrue(response is http:Response);
    if response is http:Response {
        test:assertEquals(response.statusCode, 202);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService"] }
function testUpdateMissingID() returns error? {
    international401:Patient patient = {
        resourceType: "Patient",
        name: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ]
    };
    http:Response|ServiceTestError response = check fhirClient->put("/Patient/1", message = patient, mediaType = r4:FHIR_MIME_TYPE_JSON);
    test:assertTrue(response is http:Response);
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        json operationOutcome = check response.getJsonPayload();
        anydata operationOutcomeStruct = check parser:parse(operationOutcome);
        if operationOutcomeStruct is r4:OperationOutcome {
            r4:CodeableConcept? details = operationOutcomeStruct.issue[0].details;
            if details is r4:CodeableConcept {
                test:assertEquals(details.text, "Payload doesn't have the mandatory ID field");
            } else {
                test:assertFail("Error in extracting details from operation outcome");
            }
        } else {
            test:assertFail("Error in parsing the response payload");
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService"] }
function testUpdateIncorrectID() returns error?{
    international401:Patient patient = {
        resourceType: "Patient",
        id: "2",
        name: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ]
    };
    http:Response|ServiceTestError response = check fhirClient->put("/Patient/1", message = patient, mediaType = r4:FHIR_MIME_TYPE_JSON);
    test:assertTrue(response is http:Response);
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
        json operationOutcome = check response.getJsonPayload();
        anydata operationOutcomeStruct = check parser:parse(operationOutcome);
        if operationOutcomeStruct is r4:OperationOutcome {
            r4:CodeableConcept? details = operationOutcomeStruct.issue[0].details;
            if details is r4:CodeableConcept {
                test:assertEquals(details.text, "Payload ID doesn't match with the resource ID");
            } else {
                test:assertFail("Error in extracting details from operation outcome");
            }
        } else {
            test:assertFail("Error in parsing the response payload");
        }
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService"] }
function testCreate() returns error? {
    international401:Patient patient = {
        resourceType: "Patient",
        id: "1",
        name: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ]
    };
    http:Response|ServiceTestError response = check fhirClient->post("/Patient", message = patient, mediaType = r4:FHIR_MIME_TYPE_JSON);
    test:assertTrue(response is http:Response);
    if response is http:Response {
        test:assertEquals(response.statusCode, 201);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService"] }
function testCreateInvalidPayload() returns error? {
    json patient = { 
        resourceType: "Patient",
        id: "1",
        familyname: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ]
    };
    http:Response|ServiceTestError response = check fhirClient->post("/Patient", message = patient, mediaType = r4:FHIR_MIME_TYPE_JSON);
    test:assertTrue(response is http:Response);
    if response is http:Response {
        test:assertEquals(response.statusCode, 400);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService", "conditional_interactions"] }
function testCreateConditional412() returns error? {
    international401:Patient patient = {
        resourceType: "Patient",
        name: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ],
        id: "150"
    };
    map<string> headers = {
        "If-None-Exist": "http://localhost:9292/fhir/r4/Patient" // not ID for 412
    };
    http:Response|ServiceTestError response = check fhirClient->post("/Patient", message = patient, headers = headers, mediaType = r4:FHIR_MIME_TYPE_JSON);
    test:assertTrue(response is http:Response);
    if response is http:Response {
        // 412 for multiple resources
        test:assertEquals(response.statusCode, 412);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService", "conditional_interactions"] }
function testCreateConditionalExistingResource() returns error? {
    international401:Patient patient = {
        resourceType: "Patient",
        name: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ],
        id: "1"
    };
    map<string> headers = {
        "If-None-Exist": "http://localhost:9292/fhir/r4/Patient?_id=1"
    };
    http:Response|ServiceTestError response = check fhirClient->post("/Patient", message = patient, headers = headers, mediaType = r4:FHIR_MIME_TYPE_JSON);
    test:assertTrue(response is http:Response);
    if response is http:Response {
        // 200 for existing resource
        test:assertEquals(response.statusCode, 200);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService", "conditional_interactions"] }
function testCreateConditionalSuccess() returns error? {
    international401:Patient patient = {
        resourceType: "Patient",
        name: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ],
        id: "1"
    };
    map<string> headers = {
        "If-None-Exist": "http://localhost:9292/fhir/r4/Patient?_id=New"
    };
    http:Response|ServiceTestError response = check fhirClient->post("/Patient", message = patient, headers = headers, mediaType = r4:FHIR_MIME_TYPE_JSON);
    test:assertTrue(response is http:Response);
    if response is http:Response {
        // 201 created for new resource
        test:assertEquals(response.statusCode, 201);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService"] }
function testPatch() returns error? {
    json patient = {
        name: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ]
    };
    http:Response|ServiceTestError response = check fhirClient->patch("/Patient/1", message = patient, mediaType = "application/json-patch+json");
    test:assertTrue(response is http:Response);
    if response is http:Response {
        test:assertEquals(response.statusCode, 202);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService"] }
function testPatchWithIncorrectMime() returns error? {
    json patient = {
        name: [
            {
                "family": "Smith",
                "given": ["John"]
            }
        ]
    };
    http:Response|ServiceTestError response = check fhirClient->patch("/Patient/1", message = patient, mediaType = "application/json");
    test:assertTrue(response is http:Response);
    if response is http:Response {
        test:assertEquals(response.statusCode, 415);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService"] }
function testDetete() returns error? {
    http:Response|ServiceTestError response = check fhirClient->delete("/Patient/1");
    test:assertTrue(response is http:Response);
    if response is http:Response {
        test:assertEquals(response.statusCode, 202);
    } else {
        test:assertFail("Error in service invocation");
    }
}

@test:Config { groups: ["FhirService"] }
function testInstanceHistory() returns error? {
    r4:Bundle|ServiceTestError response = check fhirClient->get("/Patient/1/_history");
    test:assertTrue(response is r4:Bundle);
}

@test:Config { groups: ["FhirService"] }
function testTypeHistory() returns error? {
    r4:Bundle|ServiceTestError response = check fhirClient->get("/Patient/_history");
    test:assertTrue(response is r4:Bundle);
}

@test:Config { groups: ["FhirService"] }
function testMetadata() returns error? {
    international401:CapabilityStatement|ServiceTestError response = check fhirClient->get("/metadata");
    test:assertTrue(response is international401:CapabilityStatement);
}

@test:Config { groups: ["FhirService"] }
function testInvalidApiConfig() returns error? {
    r4:ResourceAPIConfig invalidApiConfig = {operations: [], authzConfig: (), profiles: [], defaultProfile: (), 
        searchParameters: [], serverConfig: (), resourceType: ""};
    Listener|error fhirListener = new (config = invalidApiConfig);
    test:assertTrue(fhirListener is error, "Expected an error when creating a listener with invalid API config");
    if fhirListener is error {
        test:assertEquals(fhirListener.message(), "Resource type cannot be empty in the API config. Please provide a valid FHIR resource type.");
    } 
}

@test:AfterGroups { value:["FhirService"] }
function stopService() returns error? {
    check fhirListener.gracefulStop();
    log:printInfo("FHIR test service has stopped");
}
