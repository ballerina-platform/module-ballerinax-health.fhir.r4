// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;

service http:Service /fhir/r4 on new http:Listener(9090) {
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
    
    isolated resource function get Patient(http:Request request) returns http:Response {
        string? searchParams = request.getQueryParamValue("_id");

        international401:Patient patient = {
            id: searchParams is string ? searchParams : "123",
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
            ]
        };

        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, [patient]);
        
        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}

service http:Service /fhir/r4 on new http:Listener(9091) {
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

    isolated resource function get Organization(http:Request request) returns http:Response {
        string? searchParams = request.getQueryParamValue("_id");

        international401:Organization organization = {
            id: searchParams is string ? searchParams : "123",
            resourceType: "Organization",
            meta: {
                lastUpdated: "2023-10-01T12:00:00Z"
            },
            active: true,
            name: "Example Organization"
        };

        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, [organization]);
        
        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}

service http:Service /fhir/r4 on new http:Listener(9092) {
    isolated resource function get Condition(http:Request request) returns http:Response {
        string? searchParams = request.getQueryParamValue("patient");

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
                    reference: "Patient/" + (searchParams is string ? searchParams : "123")
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
                    reference: "Patient/" + (searchParams is string ? searchParams : "123")
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
}

service http:Service /fhir/r4 on new http:Listener(9093) {
    isolated resource function get AllergyIntolerance(http:Request request) returns http:Response {
        string? searchParams = request.getQueryParamValue("patient");

        international401:AllergyIntolerance[] allergies = [
            {
                id: "allergy-id-1",
                resourceType: "AllergyIntolerance",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                patient: {
                    reference: "Patient/" + (searchParams is string ? searchParams : "123")
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
}

service http:Service /fhir/r4 on new http:Listener(9094) {
    isolated resource function get MedicationStatement(http:Request request) returns http:Response {
        string? searchParams = request.getQueryParamValue("patient");

        international401:MedicationStatement[] medications = [
            {
                id: "medication-statement-id-1",
                resourceType: "MedicationStatement",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                subject: {
                    reference: "Patient/" + (searchParams is string ? searchParams : "123")
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
}

service http:Service /fhir/r4 on new http:Listener(9095) {
    isolated resource function get Practitioner/[string pid]() returns http:Response {
        international401:Practitioner practitioner = {
            id: pid,
            resourceType: "Practitioner",
            meta: {
                lastUpdated: "2023-10-01T12:00:00Z"
            },
            name: [
                {
                    use: "official",
                    family: "Smith",
                    given: ["Jane"]
                }
            ]
        };
        
        http:Response response = new;
        response.setPayload(practitioner);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }

    isolated resource function get Practitioner(http:Request request) returns http:Response {
        string? searchParams = request.getQueryParamValue("_id");

        international401:Practitioner[] practitioner = [
            {
                id: searchParams is string ? searchParams : "123",
                resourceType: "Practitioner",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                name: [
                    {
                        use: "official",
                        family: "Smith",
                        given: ["Jane"]
                    }
                ]
            }
        ];

        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, practitioner);
        
        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}

service http:Service /fhir/r4 on new http:Listener(9096) {
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
}

service http:Service /fhir/r4 on new http:Listener(9097) {
    isolated resource function get Immunization/[string iid]() returns http:Response {
        international401:Immunization immunization = {
            id: iid,
            resourceType: "Immunization",
            meta: {
                lastUpdated: "2023-10-01T12:00:00Z"
            },
            status: "completed",
            vaccineCode: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/sid/cvx",
                        code: "207",
                        display: "COVID-19, mRNA, LNP-S, PF, 100 mcg/0.5 mL dose"
                    }
                ]
            },
            patient: {
                reference: "Patient/102"
            },
            occurrenceDateTime: "2023-09-15",
            occurrenceString: "2023-09-15T00:00:00Z"
        };

        http:Response response = new;
        response.setPayload(immunization);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }

    isolated resource function get Immunization(http:Request request) returns http:Response {
        string? patientParam = request.getQueryParamValue("patient");

        international401:Immunization[] immunizations = [
            {
                id: "immunization-id-1",
                resourceType: "Immunization",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                status: "completed",
                vaccineCode: {
                    coding: [
                        {
                            system: "http://hl7.org/fhir/sid/cvx",
                            code: "207",
                            display: "COVID-19, mRNA, LNP-S, PF, 100 mcg/0.5 mL dose"
                        }
                    ]
                },
                patient: {
                    reference: "Patient/" + (patientParam is string ? patientParam : "102")
                },
                occurrenceDateTime: "2023-09-15",
                occurrenceString: "2023-09-15T00:00:00Z"
            }
        ];

        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, immunizations);

        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}
