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

import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4;
import ballerina/http;

type ServiceTestError distinct error;

Service fhirService = service object {
    // read
    resource function get fhir/r4/Patient/[string id](r4:FHIRContext fhirCtx) returns international401:Patient|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRReadInteraction {
            return {
                resourceType: "Patient",
                id: "1"
            };
        } else {
            return error ServiceTestError("Incorrect interation engaged!");
        }
    }

    // vread
    resource function get fhir/r4/Patient/[string id]/_history/[string vid](r4:FHIRContext fhirCtx) returns international401:Patient|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRVReadInteraction {
            return {
                resourceType: "Patient",
                id: "1"
            };
        } else {
            return error ServiceTestError("Incorrect interation engaged!");
        }
    }

    // search
    resource function get fhir/r4/Patient(r4:FHIRContext fhirCtx) returns r4:Bundle|error {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRSearchInteraction {
            r4:DomainResource[] patients = [
                {
                    resourceType: "Patient",
                    id: "1"
                },
                {
                    resourceType: "Patient",
                    id: "2"
                }
            ];
            return r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, patients);
        } else {
            return error ServiceTestError("Incorrect interation engaged!");
        }
    }

    // update
    resource function put fhir/r4/Patient/[string id](r4:FHIRContext fhirCtx, international401:Patient p) returns http:Response|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRUpdateInteraction {
            http:Response response = new;
            response.statusCode = http:STATUS_ACCEPTED;
            return response;
        } else {
            return error ServiceTestError("Incorrect interation engaged!");
        }
    }

    // create
    resource function post fhir/r4/Patient(r4:FHIRContext fhirCtx, international401:Patient p) returns http:Response|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRCreateInteraction {
            http:Response response = new;
            response.statusCode = http:STATUS_CREATED;
            return response;
        } else {
            return error ServiceTestError("Incorrect interation engaged!");
        }
    }

    // patch
    resource function patch fhir/r4/Patient/[string id](r4:FHIRContext fhirCtx, json p) returns http:Response|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRPatchInteraction {
            http:Response response = new;
            response.statusCode = http:STATUS_ACCEPTED;
            return response;
        } else {
            return error ServiceTestError("Incorrect interation engaged!");
        }
    }

    // delete
    resource function delete fhir/r4/Patient/[string id](r4:FHIRContext fhirCtx) returns http:Response|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRDeleteInteraction {
            http:Response response = new;
            response.statusCode = http:STATUS_ACCEPTED;
            return response;
        } else {
            return error ServiceTestError("Incorrect interation engaged!");
        }
    }

    // instance history
    resource function get fhir/r4/Patient/[string id]/_history(r4:FHIRContext fhirCtx) returns r4:Bundle|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRInstanceHistoryInteraction {
            r4:DomainResource[] patients = [
                {
                    resourceType: "Patient",
                    id: "1"
                },
                {
                    resourceType: "Patient",
                    id: "2"
                }
            ];
            return r4:createFhirBundle(r4:BUNDLE_TYPE_HISTORY, patients);
        } else {
            return error("Incorrect interation engaged!");
        }
    }

    // type history
    resource function get fhir/r4/Patient/_history(r4:FHIRContext fhirCtx) returns r4:Bundle|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRHistoryInteraction {
            r4:DomainResource[] patients = [
                {
                    resourceType: "Patient",
                    id: "1"
                },
                {
                    resourceType: "Patient",
                    id: "2"
                }
            ];
            return r4:createFhirBundle(r4:BUNDLE_TYPE_HISTORY, patients);
        } else {
            return error("Incorrect interation engaged!");
        }
    }

    // metadata
    resource function get fhir/r4/metadata(r4:FHIRContext fhirCtx) returns international401:CapabilityStatement|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is FHIRCapabilitiesInteraction {
            international401:CapabilityStatement capstmnt = {
                date: "2023-01-01",
                fhirVersion: "4.0.1",
                format: [
                    international401:CODE_FORMAT_JSON
                ],
                kind: "instance",
                status: "active"
            };
            return capstmnt;
        } else {
            return error("Incorrect interation engaged!");
        }
    }
};
