import ballerina/http;
import ballerina/test;

@test:Config {groups: ["conext_validation", "positive"]}
function call_cds_service_context_with_proper_payload() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hapi.fhir.org/baseR4",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "593380",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };

    CdsRequest|error cdsRequest = payload.cloneWithType(CdsRequest);
    if cdsRequest is CdsRequest {
        CdsService cdsService = cds_services.filter(s => s.id == "static-patient-greeter").pop();
        _ = check validateContext(cdsRequest, cdsService);
    }

}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_with_wrong_context_object() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "order-select",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "593380",
            "encounterId": "89284"
        }
    };

    CdsRequest|error cdsRequest = payload.cloneWithType(CdsRequest);
    if cdsRequest is CdsRequest {
        CdsService cdsService = cds_services.filter(s => s.id == "static-order-select").pop();
        CdsError? validateContextResult = validateContext(cdsRequest, cdsService);
        if (validateContextResult is CdsError) {
            test:assertEquals(validateContextResult.message(), "Context validation failed: order-select");
            test:assertEquals(validateContextResult.detail().code, 400);
            test:assertEquals(validateContextResult.detail().description, "Context should only contains set of data allowed by the specification: https://cds-hooks.hl7.org/hooks/order-select/STU1/order-select/#context");
        } else {
            test:assertFail("It should return a context validation error");
        }
    }
}

@test:Config {groups: ["service_endpoint", "positive"]}
function call_cds_service_payload_with_prefetch_data_attached() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "patient-view",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };
    CdsRequest|error cdsRequest = payload.cloneWithType(CdsRequest);
    if cdsRequest is CdsRequest {
        CdsService cdsService = cds_services.filter(s => s.id == "static-patient-greeter").pop();
        CdsRequest|CdsError result = validateAndProcessPrefetch(cdsRequest, cdsService);

        if (result is CdsError) {
            test:assertFail("It should return the CDS request given for the prefetch validation");
        }
    }
}

@test:Config {groups: ["service_endpoint", "positive"]}
function call_cds_service_with_proper_payload() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hapi.fhir.org/baseR4",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "593380",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };

    CdsRequest|error cdsRequest = payload.cloneWithType(CdsRequest);
    if cdsRequest is CdsRequest {
        CdsService cdsService = cds_services.filter(s => s.id == "static-patient-greeter2").pop();
        CdsRequest|CdsError result = validateAndProcessPrefetch(cdsRequest, cdsService);

        if (result is CdsError) {
            test:assertFail("It should return the CDS request given for the prefetch validation");
        }
    }
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_service_payload_with_no_prefetch_data_and_fhirServer() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "patient-view",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        }
    };

    CdsRequest|error cdsRequest = payload.cloneWithType(CdsRequest);
    if cdsRequest is CdsRequest {
        CdsService cdsService = cds_services.filter(s => s.id == "static-patient-greeter").pop();
        CdsRequest|CdsError result = validateAndProcessPrefetch(cdsRequest, cdsService);

        if (result is CdsError) {
            test:assertEquals(result.message(), "Can not find fhirServer url in the request");
            test:assertEquals(result.detail().code, 400);
        } else {
            test:assertFail("It should return the CDS error");
        }
    }
}

@test:Config {groups: ["service_endpoint", "positive"]}
function call_a_cds_service_which_has_empty_prefetch_list() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "order-dispatch",
        "context": {
            "patientId": "1288992",
            "dispatchedOrders": [
                "ServiceRequest/proc002"
            ],
            "performer": "Organization/some-performer",
            "fulfillmentTasks": [
                {
                    "resourceType": "Task",
                    "status": "draft",
                    "intent": "order",
                    "code": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/CodeSystem/task-code",
                                "code": "fulfill"
                            }
                        ]
                    },
                    "focus": {
                        "reference": "ServiceRequest/proc002"
                    },
                    "for": {
                        "reference": "Patient/1288992"
                    },
                    "authoredOn": "2016-03-10T22:39:32-04:00",
                    "lastModified": "2016-03-10T22:39:32-04:00",
                    "requester": {
                        "reference": "Practitioner/456"
                    },
                    "owner": {
                        "reference": "Organziation/some-performer"
                    }
                }
            ]
        }
    };
    CdsRequest|error cdsRequest = payload.cloneWithType(CdsRequest);
    if cdsRequest is CdsRequest {
        CdsService cdsService = cds_services.filter(s => s.id == "static-order-dispatch2").pop();
        CdsRequest|CdsError result = validateAndProcessPrefetch(cdsRequest, cdsService);

        if (result is CdsError) {
            test:assertFail("It should return the CDS request given for the prefetch validation");
        }
    }
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_service_payload_with_no_prefetch_data_and_fhirAuthorization() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hooks.smarthealthit.org:9080",
        "hook": "patient-view",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        }
    };

    CdsRequest|error cdsRequest = payload.cloneWithType(CdsRequest);
    if cdsRequest is CdsRequest {
        CdsService cdsService = cds_services.filter(s => s.id == "static-patient-greeter").pop();
        CdsRequest|CdsError result = validateAndProcessPrefetch(cdsRequest, cdsService);

        if (result is CdsError) {
            test:assertEquals(result.message(), "Can not find fhirAuthorization in the request");
            test:assertEquals(result.detail().code, 400);
        } else {
            test:assertFail("It should return the CDS error");
        }
    }
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_service_wrong_prefetch_template_data() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hapi.fhir.org/baseR4",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "wrong-id", //Wrong Patient id
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };

    CdsRequest|error cdsRequest = payload.cloneWithType(CdsRequest);
    if cdsRequest is CdsRequest {
        CdsService cdsService = cds_services.filter(s => s.id == "static-patient-greeter2").pop();
        CdsRequest|CdsError result = validateAndProcessPrefetch(cdsRequest, cdsService);

        if (result is CdsError) {
            test:assertEquals(result.message(), "FHIR data retrieved for : http://hapi.fhir.org/baseR4/Patient/wrong-id is not valid");
            test:assertEquals(result.detail().code, 412);
        } else {
            test:assertFail("It should return the CDS error");
        }
    }
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_serive_wrong_fhir_server_url() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hapi.fhir.org/baseR4sd",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "wrong-id",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };

    CdsRequest|error cdsRequest = payload.cloneWithType(CdsRequest);
    if cdsRequest is CdsRequest {
        CdsService cdsService = cds_services.filter(s => s.id == "static-patient-greeter2").pop();
        CdsRequest|CdsError result = validateAndProcessPrefetch(cdsRequest, cdsService);

        if (result is CdsError) {
            test:assertEquals(result.message(), "FHIR data retrieved for : http://hapi.fhir.org/baseR4sd/Patient/wrong-id is not JSON");
            test:assertEquals(result.detail().code, 412);
        } else {
            test:assertFail("It should return the CDS error");
        }
    }
}

@test:Config {groups: ["service_endpoint", "negative"]}
function cdsError_to_http_response() {
    CdsError cdsError = createCdsError("Test error message", 400, "Test error description");
    http:Response response = cdsErrorToHttpResponse(cdsError);

    json expected = {
        "message": "Test error message",
        "description": "Test error description"
    };

    test:assertEquals(response.getJsonPayload(), expected);
    test:assertEquals(response.statusCode, 400);
}
