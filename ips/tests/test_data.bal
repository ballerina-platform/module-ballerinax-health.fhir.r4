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
json generatedIpsBundle = {
    "resourceType": "Bundle",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Bundle"
        ]
    },
    "type": "document",
    "entry": [
        {
            "resource": {
                "resourceType": "Composition",
                "date": "2025-07-04T10:57:33.754807600Z",
                "custodian": {
                    "reference": "Organization/50"
                },
                "subject": {
                    "reference": "Patient/102"
                },
                "author": [
                    {
                        "reference": "Practitioner/12345"
                    },
                    {
                        "reference": "Organization/50"
                    }
                ],
                "section": [
                    {
                        "entry": [
                            {
                                "reference": "Condition/condition-id-1"
                            },
                            {
                                "reference": "Condition/condition-id-2"
                            }
                        ],
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "11450-4",
                                    "display": "Problem list"
                                }
                            ]
                        },
                        "text": {
                            "status": "generated",
                            "div": "<div xmlns=\\\"http://www.w3.org/1999/xhtml\\\">No information available.</div>"
                        },
                        "title": "Active Problems"
                    },
                    {
                        "entry": [
                            {
                                "reference": "AllergyIntolerance/allergy-id-1"
                            }
                        ],
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "48765-2",
                                    "display": "Allergies &or adverse reactions"
                                }
                            ]
                        },
                        "text": {
                            "status": "generated",
                            "div": "<div xmlns=\\\"http://www.w3.org/1999/xhtml\\\">No information available.</div>"
                        },
                        "title": "Allergies and Intolerances"
                    },
                    {
                        "entry": [
                            {
                                "reference": "MedicationStatement/medication-statement-id-1"
                            }
                        ],
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "10160-0",
                                    "display": "Medication use"
                                }
                            ]
                        },
                        "text": {
                            "status": "generated",
                            "div": "<div xmlns=\\\"http://www.w3.org/1999/xhtml\\\">No information available.</div>"
                        },
                        "title": "Medication Summary"
                    },
                    {
                        "entry": [
                            {
                                "reference": "Immunization/immunization-id-1"
                            }
                        ],
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "11369-6",
                                    "display": "Immunization"
                                }
                            ]
                        },
                        "text": {
                            "status": "generated",
                            "div": "<div xmlns=\\\"http://www.w3.org/1999/xhtml\\\">No information available.</div>"
                        },
                        "title": "Immunizations"
                    }
                ],
                "title": "International Patient Summary",
                "type": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "60591-5",
                            "display": "Patient summary"
                        }
                    ]
                },
                "status": "final"
            }
        },
        {
            "fullUrl": "urn:uuid:102",
            "resource": {
                "resourceType": "Patient",
                "gender": "unknown",
                "id": "102",
                "birthDate": "1980-01-01",
                "name": [
                    {
                        "use": "official",
                        "family": "Doe",
                        "given": [
                            "John"
                        ]
                    }
                ]
            }
        },
        {
            "fullUrl": "urn:uuid:condition-id-1",
            "resource": {
                "resourceType": "Condition",
                "code": {},
                "subject": {
                    "reference": "Patient/102"
                },
                "clinicalStatus": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
                            "code": "active",
                            "display": "Active"
                        }
                    ]
                },
                "id": "condition-id-1"
            }
        },
        {
            "fullUrl": "urn:uuid:condition-id-2",
            "resource": {
                "resourceType": "Condition",
                "code": {},
                "subject": {
                    "reference": "Patient/102"
                },
                "clinicalStatus": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
                            "code": "resolved",
                            "display": "Resolved"
                        }
                    ]
                },
                "id": "condition-id-2"
            }
        },
        {
            "fullUrl": "urn:uuid:allergy-id-1",
            "resource": {
                "resourceType": "AllergyIntolerance",
                "clinicalStatus": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                            "code": "active",
                            "display": "Active"
                        }
                    ]
                },
                "patient": {
                    "reference": "Patient/102"
                },
                "id": "allergy-id-1"
            }
        },
        {
            "fullUrl": "urn:uuid:medication-statement-id-1",
            "resource": {
                "resourceType": "MedicationStatement",
                "subject": {
                    "reference": "Patient/102"
                },
                "medicationReference": {
                    "reference": "Medication/medication-id-1"
                },
                "id": "medication-statement-id-1",
                "effectivePeriod": {},
                "medicationCodeableConcept": {
                    "coding": [
                        {
                            "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                            "code": "123456",
                            "display": "Example Medication"
                        }
                    ]
                },
                "effectiveDateTime": "",
                "status": "unknown"
            }
        },
        {
            "fullUrl": "urn:uuid:immunization-id-1",
            "resource": {
                "id": "immunization-id-1",
                "resourceType": "Immunization",
                "status": "completed",
                "vaccineCode": {
                    "coding": [
                        {
                            "system": "http://hl7.org/fhir/sid/cvx",
                            "code": "207",
                            "display": "COVID-19, mRNA, LNP-S, PF, 100 mcg/0.5 mL dose"
                        }
                    ]
                },
                "patient": {
                    "reference": "Patient/102"
                },
                "occurrenceDateTime": "2023-09-15",
                "occurrenceString": "2023-09-15T00:00:00Z"
            }
        },
        {
            "fullUrl": "urn:uuid:12345",
            "resource": {
                "resourceType": "Practitioner",
                "name": [
                    {
                        "use": "official",
                        "family": "Smith",
                        "given": [
                            "Jane"
                        ]
                    }
                ],
                "id": "12345"
            }
        },
        {
            "fullUrl": "urn:uuid:50",
            "resource": {
                "resourceType": "Organization",
                "active": true,
                "meta": {
                    "lastUpdated": "2023-10-01T12:00:00Z"
                },
                "name": "Example Organization",
                "id": "50"
            }
        },
        {
            "fullUrl": "urn:uuid:medication-id-1",
            "resource": {
                "resourceType": "Medication",
                "id": "medication-id-1",
                "code": {
                    "coding": [
                        {
                            "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                            "code": "123456",
                            "display": "Example Medication"
                        }
                    ]
                }
            }
        }
    ]
};
