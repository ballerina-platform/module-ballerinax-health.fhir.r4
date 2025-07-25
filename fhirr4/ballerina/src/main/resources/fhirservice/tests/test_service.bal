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
import ballerina/http;
import ballerinax/health.fhir.r4;

type ServiceTestError distinct error;

// This service is used to test the FHIR service.
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
            r4:RequestSearchParameter[]? id = fhirCtx.getRequestSearchParameter("_id");
            // check whether the _id search parameter is present
            r4:DomainResource[] patients = [];
            if id !is () {
                string idValue = id[0].value;

                if idValue == "New" {
                    // return not found error if the id is not "New"
                    return r4:createFHIRError(
                        "Resource not found",
                        r4:ERROR,
                        r4:INVALID,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
                } else {
                    patients = [
                        {
                            resourceType: "Patient",
                            id: idValue
                        }
                    ];
                }
            } else {
                patients = [
                    {
                        resourceType: "Patient",
                        id: "1"
                    },
                    {
                        resourceType: "Patient",
                        id: "2"
                    }
                ];
            }
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

// This service is used to test the FHIR service with default pagination.
Service fhirServiceWithDefaultPagination = service object {
    resource function get test1/Patient(r4:FHIRContext fhirContext) returns [map<r4:RequestSearchParameter[]>, r4:PaginationContext] {
        return [fhirContext.getRequestSearchParameters(), <r4:PaginationContext>fhirContext.getPaginationContext()];
    }

    resource function get test2/Patient(r4:FHIRContext fhirContext) returns r4:Bundle {
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
    }

    resource function get test3/Patient(r4:FHIRContext fhirContext) returns r4:Bundle {
        r4:DomainResource[] patients = [
            {
                resourceType: "Patient",
                id: "1"
            },
            {
                resourceType: "Patient",
                id: "2"
            },
            {
                resourceType: "Patient",
                id: "3"
            },
            {
                resourceType: "Patient",
                id: "4"
            },
            {
                resourceType: "Patient",
                id: "5"
            },
            {
                resourceType: "Patient",
                id: "6"
            },
            {
                resourceType: "Patient",
                id: "7"
            },
            {
                resourceType: "Patient",
                id: "8"
            },
            {
                resourceType: "Patient",
                id: "9"
            },
            {
                resourceType: "Patient",
                id: "10"
            }
        ];
        return r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, patients);
    }
};

// This service is used to test disabled pagination.
Service fhirServiceNoPagination = service object {
    resource function get test1/Patient(r4:FHIRContext fhirContext) returns r4:Bundle {
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
    }
};

// This service is used to test FHIR extended operations
Service fhirOperationsService = service object {
    resource function get fhir/r4/ConceptMap/\$translate(r4:FHIRContext fhirCtx)
            returns international401:Parameters|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is r4:FHIROperationInteraction {
            return {};
        } else {
            return error("Incorrect interaction engaged!");
        }
    }

    resource function post fhir/r4/ConceptMap/\$translate(r4:FHIRContext fhirCtx,
            international401:Parameters parameters) returns international401:Parameters|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is r4:FHIROperationInteraction {
            return {};
        } else {
            return error("Incorrect interaction engaged!");
        }
    }

    resource function get fhir/r4/ConceptMap/[string id]/\$translate(r4:FHIRContext fhirCtx,
            international401:Parameters parameters) returns international401:Parameters|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is r4:FHIROperationInteraction {
            return {};
        } else {
            return error("Incorrect interaction engaged!");
        }
    }

    // Base operation resource function
    resource function get fhir/r4/ConceptMap/\$meta(r4:FHIRContext fhirCtx)
            returns r4:Meta|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is r4:FHIROperationInteraction {
            return {};
        } else {
            return error("Incorrect interaction engaged!");
        }
    }

    resource function get fhir/r4/\$closure(r4:FHIRContext fhirCtx)
            returns international401:ConceptMap|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is r4:FHIROperationInteraction {
            return {status: "active"};
        } else {
            return error("Incorrect interaction engaged!");
        }
    }

    // Invalid operation resource function for testing.
    // 'ConceptMap' resource does not have a '$find-matches' operation.
    resource function get fhir/r4/ConceptMap/\$find\-matches(r4:FHIRContext fhirCtx)
            returns international401:Parameters|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is r4:FHIROperationInteraction {
            return {};
        } else {
            return error("Incorrect interaction engaged!");
        }
    }

    // Invalid operation resource function for testing. 
    // '$translate' operation does not support system scope.
    resource function get fhir/r4/\$translate(r4:FHIRContext fhirCtx)
            returns international401:Parameters|ServiceTestError {
        r4:FHIRInteraction interaction = fhirCtx.getInteraction();
        if interaction is r4:FHIROperationInteraction {
            return {};
        } else {
            return error("Incorrect interaction engaged!");
        }
    }
};


# Mock service for test IPS generation
# This service is used to test the IPS generation functionality.

Service ipsPatientService = service object {
    isolated resource function get Patient/[string pid]() returns http:Response {
        international401:Patient patient = {
            id: pid,
            resourceType: "Patient",
            meta: {
                lastUpdated: "2023-10-01T12:00:00Z"
            },
            name: [
                {
                    use: "official",
                    family: "Doe",
                    given: ["John"]
                }
            ],
            birthDate: "1980-01-01"
        };
        
        http:Response response = new;
        response.setPayload(patient);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
};

// Organization Service
Service ipsOrganizationService = service object {
    isolated resource function get Organization/[string oid]() returns http:Response {
        international401:Organization organization = {
            id: oid,
            resourceType: "Organization",
            meta: {
                lastUpdated: "2023-10-01T12:00:00Z"
            },
            active: true,
            name: "Example Organization"
        };
        
        http:Response response = new;
        response.setPayload(organization);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
};

// AllergyIntolerance Service
Service ipsAllergyIntoleranceService = service object {
   isolated resource function get AllergyIntolerance(http:Request request) returns http:Response {
        international401:AllergyIntolerance[] allergies = [
            {
                id: "allergy-id-1",
                resourceType: "AllergyIntolerance",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                patient: {
                    reference: "Patient/102"
                },
                clinicalStatus: {
                    coding: [
                        {
                            system: "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                            code: "active",
                            display: "Active"
                        }
                    ]
                }
            }
        ];

        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, allergies);
        
        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
};

// Condition Service
Service ipsConditionService = service object {
    isolated resource function get Condition(http:Request request) returns http:Response {
        international401:Condition[] conditions = [
            {
                id: "condition-id-1",
                resourceType: "Condition",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                clinicalStatus: {
                    coding: [
                        {
                            system: "http://terminology.hl7.org/CodeSystem/condition-clinical",
                            code: "active",
                            display: "Active"
                        }
                    ]
                },
                subject: {
                    reference: "Patient/102"
                }
            },
            {   
                id: "condition-id-2",
                resourceType: "Condition",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                clinicalStatus: {
                    coding: [
                        {
                            system: "http://terminology.hl7.org/CodeSystem/condition-clinical",
                            code: "resolved",
                            display: "Resolved"
                        }
                    ]
                },
                subject: {
                    reference: "Patient/102"
                }
            }
        ];

        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, conditions);
        
        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
};

// MedicationStatement Service
Service ipsMedicationStatementService = service object {
    isolated resource function get MedicationStatement(http:Request request) returns http:Response {
        international401:MedicationStatement[] medications = [
            {
                id: "medication-statement-id-1",
                resourceType: "MedicationStatement",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                subject: {
                    reference: "Patient/102"
                },
                medicationReference: {
                    reference: "Medication/medication-id-1"
                },
                medicationCodeableConcept: {
                    coding: [
                        {
                            system: "http://www.nlm.nih.gov/research/umls/rxnorm",
                            code: "123456",
                            display: "Example Medication"
                        }
                    ]
                },
                status: "unknown"
            }
        ];

        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, medications);
        
        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
};

// medication Service
Service ipsMedicationService = service object {
    isolated resource function get Medication/[string mid]() returns http:Response {
        international401:Medication medication = {
            id: mid,
            resourceType: "Medication",
            meta: {
                lastUpdated: "2023-10-01T12:00:00Z"
            },
            code: {
                coding: [
                    {
                        system: "http://www.nlm.nih.gov/research/umls/rxnorm",
                        code: "123456",
                        display: "Example Medication"
                    }
                ]
            }
        };

        http:Response response = new;
        response.setPayload(medication);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }    
};
