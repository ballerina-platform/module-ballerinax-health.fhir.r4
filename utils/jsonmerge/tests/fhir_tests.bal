import ballerina/io;
import ballerina/test;

// Basic functionality tests
@test:Config {}
function testmergeJson_FHIR() returns error? {

    json src = {
        "resourceType": "Patient",
        "id": "591841",
        "meta": {
            "versionId": "1",
            "lastUpdated": "2025-01-22T05:30:13.137+05:30",
            "source": "#KO38Q3spgrJoP5fa"
        },
        "identifier": [
            {
                "type": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
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
        "birthDate": "1985-06-15"
    };

    json base = {
        "resourceType": "Patient",
        "identifier": [
            {
                "type": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                            "code": "MR"
                        }
                    ]
                },
                "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
            },
            {
                "type": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                            "code": "SS"
                        }
                    ]
                },
                "system": "http://hl7.org/fhir/sid/us-ssn",
                "value": "444113456"
            }
        ],
        "telecom": [
            {
                "system": "phone",
                "use": "home",
                "value": "123-456-7890"
            },
            {
                "system": "phone",
                "use": "home",
                "value": "987-654-3210"
            }
        ]
    };

    map<string> keysMap = {
        "identifier": "value",
        "identifier.type.coding": "system,code"
    };
    json mergeResult = check mergeJson(base, src, keysMap);
    io:println("Result: ", mergeResult);

}

@test:Config {}
function testFhirPatientResourceMerge() {
    io:println("=== FHIR Test: Patient Resource Merge ===");

    // Source Patient resource with updated information
    json sourcePatient = {
        "resourceType": "Patient",
        "id": "patient-123",
        "meta": {
            "versionId": "2",
            "lastUpdated": "2024-01-15T10:30:00Z"
        },
        "identifier": [
            {
                "use": "usual",
                "type": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                            "code": "MR"
                        }
                    ]
                },
                "system": "http://hospital.example.org",
                "value": "MRN-12345"
            }
        ],
        "active": true,
        "name": [
            {
                "use": "official",
                "family": "Johnson",
                "given": ["John", "Michael"],
                "prefix": ["Mr."]
            }
        ],
        "telecom": [
            {
                "system": "phone",
                "value": "+1-555-123-4567",
                "use": "mobile"
            },
            {
                "system": "email",
                "value": "john.johnson@email.com",
                "use": "home"
            }
        ],
        "address": [
            {
                "use": "home",
                "line": ["123 Main Street", "Apt 4B"],
                "city": "Springfield",
                "state": "IL",
                "postalCode": "62701",
                "country": "US"
            }
        ]
    };

    // Base Patient resource with existing information
    json basePatient = {
        "resourceType": "Patient",
        "id": "patient-123",
        "meta": {
            "versionId": "1",
            "lastUpdated": "2024-01-10T08:15:00Z",
            "profile": ["http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"]
        },
        "identifier": [
            {
                "use": "usual",
                "type": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                            "code": "MR",
                            "display": "Medical Record Number"
                        }
                    ]
                },
                "system": "http://hospital.example.org",
                "value": "MRN-12345"
            },
            {
                "use": "secondary",
                "type": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                            "code": "SS"
                        }
                    ]
                },
                "system": "http://hl7.org/fhir/sid/us-ssn",
                "value": "123-45-6789"
            }
        ],
        "active": true,
        "name": [
            {
                "use": "official",
                "family": "Johnson",
                "given": ["John"],
                "suffix": ["Jr."]
            }
        ],
        "telecom": [
            {
                "system": "phone",
                "value": "+1-555-987-6543",
                "use": "home"
            }
        ],
        "gender": "male",
        "birthDate": "1985-06-15",
        "address": [
            {
                "use": "home",
                "line": ["456 Oak Avenue"],
                "city": "Springfield",
                "state": "IL",
                "postalCode": "62702",
                "country": "US"
            }
        ]
    };

    // Define keys for merging FHIR Patient arrays
    map<string> fhirKeys = {
        "identifier": "system,value",
        "identifier.type.coding": "system,code",
        "name": "use",
        "telecom": "system,use",
        "address": "use"
    };

    json|error mergeResult = mergeJson(basePatient, sourcePatient, fhirKeys);

    io:println("Source Patient: " + sourcePatient.toJsonString());
    io:println("Base Patient: " + basePatient.toJsonString());

    if mergeResult is json {
        io:println("Merged Patient: " + mergeResult.toJsonString());
        map<json> resultMap = <map<json>>mergeResult;
        test:assertEquals(resultMap["resourceType"], "Patient");
        test:assertEquals(resultMap["id"], "patient-123");
        test:assertTrue(resultMap.hasKey("gender"), "Should preserve gender from base");
        test:assertTrue(resultMap.hasKey("birthDate"), "Should preserve birthDate from base");
    } else {
        io:println("Merge Error: " + mergeResult.message());
        test:assertFail("FHIR Patient merge should not fail");
    }
}

@test:Config {}
function testFhirObservationResourceMerge() {
    io:println("=== FHIR Test: Observation Resource Merge ===");

    // Source Observation with updated values
    json sourceObservation = {
        "resourceType": "Observation",
        "id": "obs-vitals-001",
        "status": "final",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "vital-signs",
                        "display": "Vital Signs"
                    }
                ]
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "85354-9",
                    "display": "Blood pressure panel"
                }
            ]
        },
        "subject": {
            "reference": "Patient/patient-123"
        },
        "effectiveDateTime": "2024-01-15T14:30:00Z",
        "component": [
            {
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "8480-6",
                            "display": "Systolic blood pressure"
                        }
                    ]
                },
                "valueQuantity": {
                    "value": 125,
                    "unit": "mmHg",
                    "system": "http://unitsofmeasure.org",
                    "code": "mm[Hg]"
                }
            },
            {
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "8462-4",
                            "display": "Diastolic blood pressure"
                        }
                    ]
                },
                "valueQuantity": {
                    "value": 82,
                    "unit": "mmHg",
                    "system": "http://unitsofmeasure.org",
                    "code": "mm[Hg]"
                }
            }
        ]
    };

    // Base Observation with existing data
    json baseObservation = {
        "resourceType": "Observation",
        "id": "obs-vitals-001",
        "meta": {
            "versionId": "1",
            "lastUpdated": "2024-01-10T12:00:00Z"
        },
        "status": "preliminary",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "vital-signs"
                    }
                ]
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "85354-9"
                }
            ]
        },
        "subject": {
            "reference": "Patient/patient-123",
            "display": "John Johnson"
        },
        "effectiveDateTime": "2024-01-10T12:00:00Z",
        "performer": [
            {
                "reference": "Practitioner/dr-smith",
                "display": "Dr. Smith"
            }
        ],
        "component": [
            {
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "8480-6"
                        }
                    ]
                },
                "valueQuantity": {
                    "value": 120,
                    "unit": "mmHg",
                    "system": "http://unitsofmeasure.org",
                    "code": "mm[Hg]"
                }
            },
            {
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "8462-4"
                        }
                    ]
                },
                "valueQuantity": {
                    "value": 80,
                    "unit": "mmHg",
                    "system": "http://unitsofmeasure.org",
                    "code": "mm[Hg]"
                }
            }
        ]
    };

    // Define keys for merging FHIR Observation arrays
    map<string> fhirKeys = {
        "category.coding": "system,code",
        "code.coding": "system,code",
        "component.code.coding": "system,code"
    };

    json|error mergeResult = mergeJson(baseObservation, sourceObservation, fhirKeys);

    io:println("Source Observation: " + sourceObservation.toJsonString());
    io:println("Base Observation: " + baseObservation.toJsonString());

    if mergeResult is json {
        io:println("Merged Observation: " + mergeResult.toJsonString());
        map<json> resultMap = <map<json>>mergeResult;
        test:assertEquals(resultMap["resourceType"], "Observation");
        test:assertEquals(resultMap["status"], "final"); // Should be updated from source
        test:assertTrue(resultMap.hasKey("performer"), "Should preserve performer from base");
    } else {
        io:println("Merge Error: " + mergeResult.message());
        test:assertFail("FHIR Observation merge should not fail");
    }
}

@test:Config {}
function testFhirMedicationRequestMerge() {
    io:println("=== FHIR Test: MedicationRequest Resource Merge ===");

    // Source MedicationRequest with updates
    json sourceMedicationRequest = {
        "resourceType": "MedicationRequest",
        "id": "med-req-001",
        "status": "active",
        "intent": "order",
        "medicationCodeableConcept": {
            "coding": [
                {
                    "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                    "code": "197361",
                    "display": "Lisinopril 10 MG Oral Tablet"
                }
            ]
        },
        "subject": {
            "reference": "Patient/patient-123"
        },
        "authoredOn": "2024-01-15T09:00:00Z",
        "requester": {
            "reference": "Practitioner/dr-jones",
            "display": "Dr. Jones"
        },
        "dosageInstruction": [
            {
                "sequence": 1,
                "text": "Take one tablet by mouth daily",
                "timing": {
                    "repeat": {
                        "frequency": 1,
                        "period": 1,
                        "periodUnit": "d"
                    }
                },
                "route": {
                    "coding": [
                        {
                            "system": "http://snomed.info/sct",
                            "code": "26643006",
                            "display": "Oral route"
                        }
                    ]
                },
                "doseAndRate": [
                    {
                        "type": {
                            "coding": [
                                {
                                    "system": "http://terminology.hl7.org/CodeSystem/dose-rate-type",
                                    "code": "ordered",
                                    "display": "Ordered"
                                }
                            ]
                        },
                        "doseQuantity": {
                            "value": 1,
                            "unit": "tablet",
                            "system": "http://terminology.hl7.org/CodeSystem/v3-orderableDrugForm",
                            "code": "TAB"
                        }
                    }
                ]
            }
        ]
    };

    // Base MedicationRequest with existing data
    json baseMedicationRequest = {
        "resourceType": "MedicationRequest",
        "id": "med-req-001",
        "meta": {
            "versionId": "1",
            "lastUpdated": "2024-01-10T15:30:00Z"
        },
        "status": "draft",
        "intent": "order",
        "priority": "routine",
        "medicationCodeableConcept": {
            "coding": [
                {
                    "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                    "code": "197361"
                }
            ],
            "text": "Lisinopril"
        },
        "subject": {
            "reference": "Patient/patient-123",
            "display": "John Johnson"
        },
        "encounter": {
            "reference": "Encounter/enc-001"
        },
        "authoredOn": "2024-01-10T15:30:00Z",
        "requester": {
            "reference": "Practitioner/dr-smith"
        },
        "reasonCode": [
            {
                "coding": [
                    {
                        "system": "http://snomed.info/sct",
                        "code": "38341003",
                        "display": "Hypertension"
                    }
                ]
            }
        ],
        "dosageInstruction": [
            {
                "sequence": 1,
                "text": "Take as directed",
                "timing": {
                    "repeat": {
                        "frequency": 1,
                        "period": 1,
                        "periodUnit": "d"
                    }
                }
            }
        ]
    };

    // Define keys for merging FHIR MedicationRequest arrays
    map<string> fhirKeys = {
        "dosageInstruction": "sequence",
        "reasonCode": "coding"
    };

    json|error mergeResult = mergeJson(baseMedicationRequest, sourceMedicationRequest, fhirKeys);

    io:println("Source MedicationRequest: " + sourceMedicationRequest.toJsonString());
    io:println("Base MedicationRequest: " + baseMedicationRequest.toJsonString());

    if mergeResult is json {
        io:println("Merged MedicationRequest: " + mergeResult.toJsonString());
        map<json> resultMap = <map<json>>mergeResult;
        test:assertEquals(resultMap["resourceType"], "MedicationRequest");
        test:assertEquals(resultMap["status"], "active"); // Should be updated from source
        test:assertTrue(resultMap.hasKey("priority"), "Should preserve priority from base");
        test:assertTrue(resultMap.hasKey("encounter"), "Should preserve encounter from base");
        test:assertTrue(resultMap.hasKey("reasonCode"), "Should preserve reasonCode from base");
    } else {
        io:println("Merge Error: " + mergeResult.message());
        test:assertFail("FHIR MedicationRequest merge should not fail");
    }
}

@test:Config {}
function testFhirBundleResourceMerge() {
    io:println("=== FHIR Test: Bundle Resource Merge ===");

    // Source Bundle with additional entries
    json sourceBundle = {
        "resourceType": "Bundle",
        "id": "bundle-001",
        "type": "collection",
        "timestamp": "2024-01-15T16:00:00Z",
        "entry": [
            {
                "fullUrl": "Patient/patient-123",
                "resource": {
                    "resourceType": "Patient",
                    "id": "patient-123",
                    "active": true,
                    "name": [
                        {
                            "use": "official",
                            "family": "Johnson",
                            "given": ["John"]
                        }
                    ]
                }
            },
            {
                "fullUrl": "Observation/obs-002",
                "resource": {
                    "resourceType": "Observation",
                    "id": "obs-002",
                    "status": "final",
                    "code": {
                        "coding": [
                            {
                                "system": "http://loinc.org",
                                "code": "33747-0",
                                "display": "General appearance"
                            }
                        ]
                    },
                    "subject": {
                        "reference": "Patient/patient-123"
                    }
                }
            }
        ]
    };

    // Base Bundle with existing entries
    json baseBundle = {
        "resourceType": "Bundle",
        "id": "bundle-001",
        "meta": {
            "versionId": "1",
            "lastUpdated": "2024-01-10T14:00:00Z"
        },
        "type": "collection",
        "timestamp": "2024-01-10T14:00:00Z",
        "total": 2,
        "entry": [
            {
                "fullUrl": "Patient/patient-123",
                "resource": {
                    "resourceType": "Patient",
                    "id": "patient-123",
                    "active": true,
                    "name": [
                        {
                            "use": "official",
                            "family": "Johnson",
                            "given": ["John", "Michael"]
                        }
                    ],
                    "gender": "male"
                }
            },
            {
                "fullUrl": "Practitioner/dr-smith",
                "resource": {
                    "resourceType": "Practitioner",
                    "id": "dr-smith",
                    "active": true,
                    "name": [
                        {
                            "use": "official",
                            "family": "Smith",
                            "given": ["Jane"],
                            "prefix": ["Dr."]
                        }
                    ]
                }
            }
        ]
    };

    // Define keys for merging FHIR Bundle entries
    map<string> fhirKeys = {
        "entry": "fullUrl"
    };

    json|error mergeResult = mergeJson(baseBundle, sourceBundle, fhirKeys);

    io:println("Source Bundle: " + sourceBundle.toJsonString());
    io:println("Base Bundle: " + baseBundle.toJsonString());

    if mergeResult is json {
        io:println("Merged Bundle: " + mergeResult.toJsonString());
        map<json> resultMap = <map<json>>mergeResult;
        test:assertEquals(resultMap["resourceType"], "Bundle");
        test:assertEquals(resultMap["type"], "collection");
        test:assertTrue(resultMap.hasKey("total"), "Should preserve total from base");

        // Check that entries are properly merged
        json entryJson = resultMap["entry"];
        if entryJson is json[] {
            test:assertTrue(entryJson.length() >= 2, "Should have at least 2 entries after merge");
        }
    } else {
        io:println("Merge Error: " + mergeResult.message());
        test:assertFail("FHIR Bundle merge should not fail");
    }
}

@test:Config {}
function testFhirDiagnosticReportMerge() {
    io:println("=== FHIR Test: DiagnosticReport Resource Merge ===");

    // Source DiagnosticReport with updated results
    json sourceDiagnosticReport = {
        "resourceType": "DiagnosticReport",
        "id": "report-001",
        "status": "final",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0074",
                        "code": "LAB",
                        "display": "Laboratory"
                    }
                ]
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "24323-8",
                    "display": "Comprehensive metabolic panel"
                }
            ]
        },
        "subject": {
            "reference": "Patient/patient-123"
        },
        "effectiveDateTime": "2024-01-15T08:00:00Z",
        "issued": "2024-01-15T10:00:00Z",
        "result": [
            {
                "reference": "Observation/glucose-001",
                "display": "Glucose measurement",
                "status": "final",
                "valueQuantity": {
                    "value": 95,
                    "unit": "mg/dL",
                    "system": "http://unitsofmeasure.org",
                    "code": "mg/dL"
                },
                "interpretation": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
                                "code": "N",
                                "display": "Normal"
                            }
                        ]
                    }
                ]
            },
            {
                "reference": "Observation/sodium-001",
                "display": "Sodium measurement",
                "status": "final",
                "valueQuantity": {
                    "value": 142,
                    "unit": "mmol/L",
                    "system": "http://unitsofmeasure.org",
                    "code": "mmol/L"
                }
            },
            {
                "reference": "Observation/creatinine-001",
                "display": "Creatinine measurement",
                "status": "final",
                "valueQuantity": {
                    "value": 1.1,
                    "unit": "mg/dL",
                    "system": "http://unitsofmeasure.org",
                    "code": "mg/dL"
                }
            }
        ],
        "performer": [
            {
                "reference": "Organization/lab-central",
                "display": "Central Laboratory"
            }
        ],
        "conclusion": "All values within normal limits",
        "meta": {
            "versionId": "2",
            "lastUpdated": "2024-01-15T10:00:00Z",
            "source": "lab-system-v2"
        }
    };

    // Base DiagnosticReport with existing data and some overlapping results
    json baseDiagnosticReport = {
        "resourceType": "DiagnosticReport",
        "id": "report-001",
        "status": "preliminary",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0074",
                        "code": "LAB",
                        "display": "Laboratory Tests"
                    }
                ]
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "24323-8",
                    "display": "Comprehensive metabolic panel - Blood"
                }
            ]
        },
        "subject": {
            "reference": "Patient/patient-123",
            "display": "John Doe"
        },
        "encounter": {
            "reference": "Encounter/encounter-456"
        },
        "effectiveDateTime": "2024-01-15T08:00:00Z",
        "issued": "2024-01-15T09:30:00Z",
        "result": [
            {
                "reference": "Observation/glucose-001",
                "display": "Blood glucose",
                "status": "preliminary",
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "33747-0",
                            "display": "Glucose [Mass/volume] in Blood"
                        }
                    ]
                },
                "effectiveDateTime": "2024-01-15T08:00:00Z"
            },
            {
                "reference": "Observation/potassium-001",
                "display": "Potassium measurement",
                "status": "final",
                "valueQuantity": {
                    "value": 4.2,
                    "unit": "mmol/L",
                    "system": "http://unitsofmeasure.org",
                    "code": "mmol/L"
                },
                "referenceRange": [
                    {
                        "low": {
                            "value": 3.5,
                            "unit": "mmol/L"
                        },
                        "high": {
                            "value": 5.0,
                            "unit": "mmol/L"
                        }
                    }
                ]
            },
            {
                "reference": "Observation/bun-001",
                "display": "Blood Urea Nitrogen",
                "status": "final",
                "valueQuantity": {
                    "value": 18,
                    "unit": "mg/dL",
                    "system": "http://unitsofmeasure.org",
                    "code": "mg/dL"
                }
            }
        ],
        "performer": [
            {
                "reference": "Organization/lab-central",
                "display": "Central Lab"
            },
            {
                "reference": "Practitioner/dr-smith",
                "display": "Dr. Smith"
            }
        ],
        "resultsInterpreter": [
            {
                "reference": "Practitioner/pathologist-jones",
                "display": "Dr. Jones, Pathologist"
            }
        ],
        "specimen": [
            {
                "reference": "Specimen/blood-sample-001",
                "display": "Blood sample"
            }
        ],
        "meta": {
            "versionId": "1",
            "lastUpdated": "2024-01-15T09:30:00Z",
            "source": "lab-system-v1",
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/DiagnosticReport"
            ]
        }
    };

    // Define keys for merging FHIR resources
    map<string> fhirKeys = {
        "result": "reference",
        "performer": "reference",
        "resultsInterpreter": "reference",
        "specimen": "reference",
        "category.coding": "system,code",
        "code.coding": "system,code",
        "result.code.coding": "system,code",
        "result.referenceRange.low": "value,unit",
        "result.referenceRange.high": "value,unit"
    };

    io:println("Source DiagnosticReport:");
    io:println(sourceDiagnosticReport.toJsonString());
    io:println("");

    io:println("Base DiagnosticReport:");
    io:println(baseDiagnosticReport.toJsonString());
    io:println("");

    io:println("FHIR Keys Map:");
    io:println(fhirKeys.toString());
    io:println("");

    // Perform the merge
    json|error mergeResult = mergeJson(baseDiagnosticReport, sourceDiagnosticReport, fhirKeys);

    if mergeResult is json {
        io:println("Merged DiagnosticReport:");
        io:println(mergeResult.toJsonString());
        io:println("");

        map<json> resultMap = <map<json>>mergeResult;
        // Verify basic properties
        test:assertEquals(resultMap["resourceType"], "DiagnosticReport", "Resource type should be preserved");
        test:assertEquals(resultMap["id"], "report-001", "ID should be preserved");
        test:assertEquals(resultMap["status"], "final", "Status should be updated from source");

        // Verify subject merge
        json subjectJson = resultMap["subject"];
        if subjectJson is map<json> {
            test:assertEquals(subjectJson["reference"], "Patient/patient-123", "Subject reference should be preserved");
            test:assertTrue(subjectJson.hasKey("display"), "Subject display should be preserved from base");
        }

        // Verify encounter is preserved from base
        test:assertTrue(resultMap.hasKey("encounter"), "Encounter should be preserved from base");

        // Verify result array merge
        json resultsJson = resultMap["result"];
        if resultsJson is json[] {
            io:println("Number of results after merge: " + resultsJson.length().toString());

            // Should have merged results - glucose should be merged, others appended
            test:assertTrue(resultsJson.length() >= 5, "Should have at least 5 results after merge");

            // Find glucose observation (should be merged)
            json? glucoseResult = ();
            foreach json result in resultsJson {
                if result is map<json> {
                    json referenceJson = result["reference"];
                    if referenceJson == "Observation/glucose-001" {
                        glucoseResult = result;
                        break;
                    }
                }
            }

            if glucoseResult is map<json> {
                test:assertTrue(glucoseResult.hasKey("valueQuantity"), "Glucose should have valueQuantity from source");
                test:assertTrue(glucoseResult.hasKey("code"), "Glucose should have code from base");
                test:assertEquals(glucoseResult["status"], "final", "Glucose status should be updated from source");
            }
        }

        // Verify performer array merge
        json performerJson = resultMap["performer"];
        if performerJson is json[] {
            test:assertTrue(performerJson.length() >= 2, "Should have at least 2 performers after merge");
        }

        // Verify meta merge
        json metaJson = resultMap["meta"];
        if metaJson is map<json> {
            test:assertEquals(metaJson["versionId"], "2", "Version should be updated from source");
            test:assertEquals(metaJson["source"], "lab-system-v2", "Source should be updated");
            test:assertTrue(metaJson.hasKey("profile"), "Profile should be preserved from base");
        }

        io:println("FHIR DiagnosticReport merge test completed successfully");

    } else {
        io:println("Merge failed with error:");
        io:println(mergeResult.message());
        test:assertFail("FHIR DiagnosticReport merge should not fail");
    }
}

@test:Config {}
function testFhirObservationMerge() {
    io:println("=== FHIR Test: Observation Resource Merge ===");

    // Source Observation with updated values
    json sourceObservation = {
        "resourceType": "Observation",
        "id": "glucose-001",
        "status": "final",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "laboratory",
                        "display": "Laboratory"
                    }
                ]
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "33747-0",
                    "display": "Glucose [Mass/volume] in Blood"
                }
            ]
        },
        "subject": {
            "reference": "Patient/patient-123"
        },
        "valueQuantity": {
            "value": 95,
            "unit": "mg/dL",
            "system": "http://unitsofmeasure.org",
            "code": "mg/dL"
        },
        "interpretation": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
                        "code": "N",
                        "display": "Normal"
                    }
                ]
            }
        ],
        "component": [
            {
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "33747-0",
                            "display": "Glucose"
                        }
                    ]
                },
                "valueQuantity": {
                    "value": 95,
                    "unit": "mg/dL"
                }
            }
        ]
    };

    json baseObservation = {
        "resourceType": "Observation",
        "id": "glucose-001",
        "status": "preliminary",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "laboratory",
                        "display": "Lab Test"
                    }
                ]
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "33747-0",
                    "display": "Blood Glucose"
                }
            ]
        },
        "subject": {
            "reference": "Patient/patient-123",
            "display": "John Doe"
        },
        "effectiveDateTime": "2024-01-15T08:00:00Z",
        "performer": [
            {
                "reference": "Organization/lab-central"
            }
        ],
        "referenceRange": [
            {
                "low": {
                    "value": 70,
                    "unit": "mg/dL"
                },
                "high": {
                    "value": 100,
                    "unit": "mg/dL"
                }
            }
        ]
    };

    map<string> observationKeys = {
        "category": "coding.system,coding.code",
        "category.coding": "system,code",
        "code.coding": "system,code",
        "interpretation": "coding.system,coding.code",
        "interpretation.coding": "system,code",
        "component": "code.coding.system,code.coding.code",
        "component.code.coding": "system,code",
        "performer": "reference",
        "referenceRange": "low.value,high.value"
    };

    json|error mergeResult = mergeJson(baseObservation, sourceObservation, observationKeys);

    if mergeResult is json {
        io:println("Merged Observation:");
        io:println(mergeResult.toJsonString());

        map<json> resultMap = <map<json>>mergeResult;
        test:assertEquals(resultMap["status"], "final", "Status should be updated from source");
        test:assertTrue(resultMap.hasKey("valueQuantity"), "ValueQuantity should be added from source");
        test:assertTrue(resultMap.hasKey("effectiveDateTime"), "EffectiveDateTime should be preserved from base");

        io:println("FHIR Observation merge test completed successfully");
    } else {
        io:println("Observation merge failed: " + mergeResult.message());
        test:assertFail("FHIR Observation merge should not fail");
    }
}

@test:Config {}
function testFhirPatientMerge() {
    io:println("=== FHIR Test: Patient Resource Merge ===");

    json sourcePatient = {
        "resourceType": "Patient",
        "id": "patient-123",
        "active": true,
        "name": [
            {
                "use": "official",
                "family": "Doe",
                "given": ["John", "Michael"],
                "prefix": ["Mr."]
            }
        ],
        "telecom": [
            {
                "system": "phone",
                "value": "+1-555-123-4567",
                "use": "mobile"
            },
            {
                "system": "email",
                "value": "john.doe@email.com",
                "use": "home"
            }
        ],
        "address": [
            {
                "use": "home",
                "line": ["123 Main Street", "Apt 4B"],
                "city": "Springfield",
                "state": "IL",
                "postalCode": "62701",
                "country": "US"
            }
        ]
    };

    json basePatient = {
        "resourceType": "Patient",
        "id": "patient-123",
        "active": false,
        "name": [
            {
                "use": "official",
                "family": "Doe",
                "given": ["John"],
                "suffix": ["Jr."]
            },
            {
                "use": "nickname",
                "given": ["Johnny"]
            }
        ],
        "gender": "male",
        "birthDate": "1985-06-15",
        "telecom": [
            {
                "system": "phone",
                "value": "+1-555-987-6543",
                "use": "work"
            }
        ],
        "address": [
            {
                "use": "work",
                "line": ["456 Business Ave"],
                "city": "Springfield",
                "state": "IL",
                "postalCode": "62702"
            }
        ],
        "maritalStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
                    "code": "M",
                    "display": "Married"
                }
            ]
        }
    };

    map<string> patientKeys = {
        "name": "use",
        "telecom": "system,use",
        "address": "use",
        "maritalStatus.coding": "system,code"
    };

    json|error mergeResult = mergeJson(basePatient, sourcePatient, patientKeys);

    if mergeResult is json {
        io:println("Merged Patient:");
        io:println(mergeResult.toJsonString());

        map<json> resultMap = <map<json>>mergeResult;
        test:assertEquals(resultMap["active"], true, "Active should be updated from source");
        test:assertTrue(resultMap.hasKey("gender"), "Gender should be preserved from base");
        test:assertTrue(resultMap.hasKey("birthDate"), "BirthDate should be preserved from base");

        json nameJson = resultMap["name"];
        if nameJson is json[] {
            test:assertTrue(nameJson.length() >= 2, "Should have multiple name entries after merge");
        }
    } else {
        io:println("Patient merge failed: " + mergeResult.message());
        test:assertFail("FHIR Patient merge should not fail");
    }
}
