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
import ballerina/test;
import ballerinax/health.fhir.r4;

@test:Config
function testIpsBundleCreation() returns error? {
    IpsBundleData sampleData = {
        composition: {
            id: "comp-001",
            status: "final",
            subject: {reference: "Patient/pat-001"},
            date: "2025-01-01",
            author: [
                {
                    "reference": "Practitioner/1c616b24-3895-48c4-9a02-9a64110351ef"
                }
            ],
            section: [],
            title: "Summary of Patient Health Information",
            'type: {
                coding: [
                    {
                        system: "http://loinc.org",
                        code: "60591-5",
                        display: "Patient summary Document"
                    }
                ]
            }
        },
        patient: {
            id: "pat-001",
            name: [
                {
                    use: "official",
                    text: "John Doe"
                }
            ],
            gender: "male",
            birthDate: "1980-01-01"
        },
        organization: [
            {
                id: "org-001",
                name: "City Hospital"
            }
        ]
    };

    r4:Bundle ipsBundle = check getIpsBundle(sampleData);
    test:assertEquals(ipsBundle.'type, "document");
    r4:BundleEntry[]? entry = ipsBundle.entry;
    if entry is r4:BundleEntry[] {
        test:assertEquals(entry.length(), 3);
    } else {
        test:assertFail("Bundle entry is not available");
    }

}

@test:Config
function testIpsBundleCreationFromR4Bundle() returns error? {
    json bundleJson = {
        "resourceType": "Bundle",
        "id": "IPS-examples-Bundle-01",
        "language": "en-GB",
        "identifier": {
            "system": "urn:oid:2.16.724.4.8.10.200.10",
            "value": "175bd032-8b00-4728-b2dc-748bb1501aed"
        },
        "type": "document",
        "timestamp": "2017-12-11T14:30:00+01:00",
        "entry": [
            {
                "fullUrl": "urn:uuid:2b90dd2b-2dab-4c75-9bb9-a355e07401e8",
                "resource": {
                    "resourceType": "Patient",
                    "id": "2b90dd2b-2dab-4c75-9bb9-a355e07401e8",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>identifier</b>: id: 574687583</p><p><b>active</b>: true</p><p><b>name</b>: Martha DeLarosa </p><p><b>telecom</b>: <a href=\"tel:+31788700800\">+31788700800</a></p><p><b>gender</b>: female</p><p><b>birthDate</b>: 1972-05-01</p><p><b>address</b>: Laan Van Europa 1600 Dordrecht 3317 DB Netherlands </p><h3>Contacts</h3><table class=\"grid\"><tr><td>-</td><td><b>Relationship</b></td><td><b>Name</b></td><td><b>Telecom</b></td><td><b>Address</b></td></tr><tr><td>*</td><td><span title=\"Codes: {http://terminology.hl7.org/CodeSystem/v3-RoleCode MTH}\">mother</span></td><td>Martha Mum </td><td><a href=\"tel:+33-555-20036\">+33-555-20036</a></td><td>Promenade des Anglais 111 Lyon 69001 France </td></tr></table></div>"
                    },
                    "identifier": [
                        {
                            "system": "urn:oid:2.16.840.1.113883.2.4.6.3",
                            "value": "574687583"
                        }
                    ],
                    "active": true,
                    "name": [
                        {
                            "family": "DeLarosa",
                            "given": [
                                "Martha"
                            ]
                        }
                    ],
                    "telecom": [
                        {
                            "system": "phone",
                            "value": "+31788700800",
                            "use": "home"
                        }
                    ],
                    "gender": "female",
                    "birthDate": "1972-05-01",
                    "address": [
                        {
                            "line": [
                                "Laan Van Europa 1600"
                            ],
                            "city": "Dordrecht",
                            "postalCode": "3317 DB",
                            "country": "Netherlands"
                        }
                    ],
                    "contact": [
                        {
                            "relationship": [
                                {
                                    "coding": [
                                        {
                                            "system": "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
                                            "code": "MTH"
                                        }
                                    ]
                                }
                            ],
                            "name": {
                                "family": "Mum",
                                "given": [
                                    "Martha"
                                ]
                            },
                            "telecom": [
                                {
                                    "system": "phone",
                                    "value": "+33-555-20036",
                                    "use": "home"
                                }
                            ],
                            "address": {
                                "line": [
                                    "Promenade des Anglais 111"
                                ],
                                "city": "Lyon",
                                "postalCode": "69001",
                                "country": "France"
                            }
                        }
                    ]
                }
            },
            {
                "fullUrl": "urn:uuid:1c616b24-3895-48c4-9a02-9a64110351ef",
                "resource": {
                    "resourceType": "Practitioner",
                    "id": "1c616b24-3895-48c4-9a02-9a64110351ef",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>identifier</b>: id: 129854633</p><p><b>active</b>: true</p><p><b>name</b>: Beetje van Hulp </p><h3>Qualifications</h3><table class=\"grid\"><tr><td>-</td><td><b>Code</b></td></tr><tr><td>*</td><td><span title=\"Codes: {http://terminology.hl7.org/CodeSystem/v2-0360|2.7 MD}\">Doctor of Medicine</span></td></tr></table></div>"
                    },
                    "identifier": [
                        {
                            "system": "urn:oid:2.16.528.1.1007.3.1",
                            "value": "129854633",
                            "assigner": {
                                "display": "CIBG"
                            }
                        }
                    ],
                    "active": true,
                    "name": [
                        {
                            "family": "van Hulp",
                            "given": [
                                "Beetje"
                            ]
                        }
                    ],
                    "qualification": [
                        {
                            "code": {
                                "coding": [
                                    {
                                        "system": "http://terminology.hl7.org/CodeSystem/v2-0360|2.7",
                                        "code": "MD",
                                        "display": "Doctor of Medicine"
                                    }
                                ]
                            }
                        }
                    ]
                }
            },
            {
                "fullUrl": "urn:uuid:890751f4-2924-4636-bab7-efffc7f3cf15",
                "resource": {
                    "resourceType": "Organization",
                    "id": "890751f4-2924-4636-bab7-efffc7f3cf15",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>identifier</b>: id: 564738757</p><p><b>active</b>: true</p><p><b>name</b>: Anorg Aniza Tion BV / The best custodian ever</p><p><b>telecom</b>: <a href=\"tel:+31-51-34343400\">+31-51-34343400</a></p><p><b>address</b>: Houttuinen 27 Dordrecht 3311 CE Netherlands (WORK)</p></div>"
                    },
                    "identifier": [
                        {
                            "system": "urn:oid:2.16.528.1.1007.3.3",
                            "value": "564738757"
                        }
                    ],
                    "active": true,
                    "name": "Anorg Aniza Tion BV / The best custodian ever",
                    "telecom": [
                        {
                            "system": "phone",
                            "value": "+31-51-34343400",
                            "use": "work"
                        }
                    ],
                    "address": [
                        {
                            "use": "work",
                            "line": [
                                "Houttuinen 27"
                            ],
                            "city": "Dordrecht",
                            "postalCode": "3311 CE",
                            "country": "Netherlands"
                        }
                    ]
                }
            },
            {
                "fullUrl": "urn:uuid:c64139e7-f02d-409c-bf34-75e8bf23bc80",
                "resource": {
                    "resourceType": "Condition",
                    "id": "c64139e7-f02d-409c-bf34-75e8bf23bc80",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>identifier</b>: id: c87bf51c-e53c-4bfe-b8b7-aa62bdd93002</p><p><b>clinicalStatus</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/condition-clinical active}\">Active</span></p><p><b>verificationStatus</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/condition-ver-status confirmed}\">Confirmed</span></p><p><b>category</b>: <span title=\"Codes: {http://loinc.org 75326-9}\">Problem</span></p><p><b>severity</b>: <span title=\"Codes: {http://loinc.org LA6751-7}\">Moderate</span></p><p><b>code</b>: <span title=\"Codes: {http://snomed.info/sct 198436008}, {http://hl7.org/fhir/sid/icd-10 N95.1}\">Menopausal flushing (finding)</span></p><p><b>subject</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>onset</b>: 2015</p><p><b>recordedDate</b>: 2016-10</p></div>"
                    },
                    "identifier": [
                        {
                            "system": "urn:oid:1.2.3.999",
                            "value": "c87bf51c-e53c-4bfe-b8b7-aa62bdd93002"
                        }
                    ],
                    "clinicalStatus": {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
                                "code": "active"
                            }
                        ]
                    },
                    "verificationStatus": {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status",
                                "code": "confirmed"
                            }
                        ]
                    },
                    "category": [
                        {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "75326-9",
                                    "display": "Problem"
                                }
                            ]
                        }
                    ],
                    "severity": {
                        "coding": [
                            {
                                "system": "http://loinc.org",
                                "code": "LA6751-7",
                                "display": "Moderate"
                            }
                        ]
                    },
                    "code": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "198436008",
                                "display": "Menopausal flushing (finding)",
                                "_display": {
                                    "extension": [
                                        {
                                            "url": "http://hl7.org/fhir/StructureDefinition/translation",
                                            "extension": [
                                                {
                                                    "url": "lang",
                                                    "valueCode": "nl-NL"
                                                },
                                                {
                                                    "url": "content",
                                                    "valueString": "opvliegers"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            },
                            {
                                "system": "http://hl7.org/fhir/sid/icd-10",
                                "code": "N95.1",
                                "display": "Menopausal and female climacteric states"
                            }
                        ]
                    },
                    "subject": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "onsetDateTime": "2015",
                    "recordedDate": "2016-10"
                }
            },
            {
                "fullUrl": "urn:uuid:976d0804-cae0-45ae-afe3-a19f3ceba6bc",
                "resource": {
                    "resourceType": "Medication",
                    "id": "976d0804-cae0-45ae-afe3-a19f3ceba6bc",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>code</b>: <span title=\"Codes: {http://snomed.info/sct 108774000}, {urn:oid:2.16.840.1.113883.2.4.4.1 99872}, {urn:oid:2.16.840.1.113883.2.4.4.7 2076667}, {http://www.whocc.no/atc L02BG03}\">Product containing anastrozole (medicinal product)</span></p></div>"
                    },
                    "code": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "108774000",
                                "display": "Product containing anastrozole (medicinal product)"
                            },
                            {
                                "system": "urn:oid:2.16.840.1.113883.2.4.4.1",
                                "code": "99872",
                                "display": "ANASTROZOL 1MG TABLET"
                            },
                            {
                                "system": "urn:oid:2.16.840.1.113883.2.4.4.7",
                                "code": "2076667",
                                "display": "ANASTROZOL CF TABLET FILMOMHULD 1MG"
                            },
                            {
                                "system": "http://www.whocc.no/atc",
                                "code": "L02BG03",
                                "display": "anastrozole"
                            }
                        ]
                    }
                }
            },
            {
                "fullUrl": "urn:uuid:8adc0999-9468-4ac9-9557-680fa133d626",
                "resource": {
                    "resourceType": "Medication",
                    "id": "8adc0999-9468-4ac9-9557-680fa133d626",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>code</b>: <span title=\"Codes: {http://snomed.info/sct 412588001}, {http://www.whocc.no/atc G02CX04}\">Black Cohosh Extract herbal supplement</span></p></div>"
                    },
                    "code": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "412588001",
                                "display": "Cimicifuga racemosa extract (substance)",
                                "_display": {
                                    "extension": [
                                        {
                                            "url": "http://hl7.org/fhir/StructureDefinition/translation",
                                            "extension": [
                                                {
                                                    "url": "lang",
                                                    "valueCode": "nl-NL"
                                                },
                                                {
                                                    "url": "content",
                                                    "valueString": "Zwarte Cohosh Extract"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            },
                            {
                                "system": "http://www.whocc.no/atc",
                                "code": "G02CX04",
                                "display": "Cimicifugae rhizoma"
                            }
                        ],
                        "text": "Black Cohosh Extract herbal supplement"
                    }
                }
            },
            {
                "fullUrl": "urn:uuid:72884cad-ebe6-4f43-a51a-2f978275f132",
                "resource": {
                    "resourceType": "AllergyIntolerance",
                    "id": "72884cad-ebe6-4f43-a51a-2f978275f132",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>identifier</b>: id: 3a462598-009c-484a-965c-d6b24a821424</p><p><b>clinicalStatus</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical active}\">Active</span></p><p><b>verificationStatus</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/allergyintolerance-verification confirmed}\">Confirmed</span></p><p><b>type</b>: allergy</p><p><b>category</b>: medication</p><p><b>criticality</b>: high</p><p><b>code</b>: <span title=\"Codes: {http://snomed.info/sct 373270004}\">Substance with penicillin structure and antibacterial mechanism of action (substance)</span></p><p><b>patient</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>onset</b>: 2010</p></div>"
                    },
                    "identifier": [
                        {
                            "system": "urn:oid:1.2.3.999",
                            "value": "3a462598-009c-484a-965c-d6b24a821424"
                        }
                    ],
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
                    "type": "allergy",
                    "category": [
                        "medication"
                    ],
                    "criticality": "high",
                    "code": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "373270004",
                                "display": "Substance with penicillin structure and antibacterial mechanism of action (substance)"
                            }
                        ]
                    },
                    "patient": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "onsetDateTime": "2010"
                }
            },
            {
                "fullUrl": "urn:uuid:c4597aa2-688a-401b-a658-70acc6de28c6",
                "resource": {
                    "resourceType": "Condition",
                    "id": "c4597aa2-688a-401b-a658-70acc6de28c6",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>identifier</b>: id: 66d4a8c7-9081-43e0-a63f-489c2ae6edd6</p><p><b>clinicalStatus</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/condition-clinical remission}\">Remission</span></p><p><b>verificationStatus</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/condition-ver-status confirmed}\">Confirmed</span></p><p><b>category</b>: <span title=\"Codes: {http://loinc.org 75326-9}\">Problem</span></p><p><b>severity</b>: <span title=\"Codes: {http://loinc.org LA6750-9}\">Severe</span></p><p><b>code</b>: <span title=\"Codes: {http://snomed.info/sct 254837009}, {urn:oid:2.16.840.1.113883.6.43.1 8500/3}\">Malignant tumor of breast</span></p><p><b>subject</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>onset</b>: 2015-01</p><p><b>abatement</b>: 2015-03</p></div>"
                    },
                    "identifier": [
                        {
                            "system": "urn:oid:1.2.3.999",
                            "value": "66d4a8c7-9081-43e0-a63f-489c2ae6edd6"
                        }
                    ],
                    "clinicalStatus": {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
                                "code": "remission"
                            }
                        ]
                    },
                    "verificationStatus": {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status",
                                "code": "confirmed"
                            }
                        ]
                    },
                    "category": [
                        {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "75326-9",
                                    "display": "Problem"
                                }
                            ]
                        }
                    ],
                    "severity": {
                        "coding": [
                            {
                                "system": "http://loinc.org",
                                "code": "LA6750-9",
                                "display": "Severe"
                            }
                        ]
                    },
                    "code": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "254837009",
                                "display": "Malignant tumor of breast",
                                "_display": {
                                    "extension": [
                                        {
                                            "url": "http://hl7.org/fhir/StructureDefinition/translation",
                                            "extension": [
                                                {
                                                    "url": "lang",
                                                    "valueCode": "nl-NL"
                                                },
                                                {
                                                    "url": "content",
                                                    "valueString": "Borstkanker stadium II zonder aanwijzingen van recidieven na behandeling"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            },
                            {
                                "system": "urn:oid:2.16.840.1.113883.6.43.1",
                                "code": "8500/3",
                                "display": "Infiltrating duct carcinoma, NOS"
                            }
                        ]
                    },
                    "subject": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "onsetDateTime": "2015-01",
                    "abatementDateTime": "2015-03"
                }
            },
            {
                "fullUrl": "urn:uuid:45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7",
                "resource": {
                    "resourceType": "Organization",
                    "id": "45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>active</b>: true</p><p><b>type</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/organization-type other}\">Other</span></p><p><b>name</b>: Laboratoire de charme</p></div>"
                    },
                    "active": true,
                    "type": [
                        {
                            "coding": [
                                {
                                    "system": "http://terminology.hl7.org/CodeSystem/organization-type",
                                    "code": "other"
                                }
                            ]
                        }
                    ],
                    "name": "Laboratoire de charme"
                }
            },
            {
                "fullUrl": "urn:uuid:aa11a2be-3e36-4be7-b58a-6fc3dace2741",
                "resource": {
                    "resourceType": "Observation",
                    "id": "aa11a2be-3e36-4be7-b58a-6fc3dace2741",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p></p><p><b>category</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/observation-category laboratory}\">Laboratory</span></p><p><b>code</b>: <span title=\"Codes: {http://loinc.org 882-1}\">ABO and Rh group [Type] in Blood</span></p><p><b>subject</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>effective</b>: Oct 10, 2015, 8:15:00 AM</p><p><b>performer</b>: <a href=\"#Organization_45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7\">See above (Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7)</a></p><p><b>value</b>: <span title=\"Codes: {http://snomed.info/sct 278149003}\">Blood group A Rh(D) positive</span></p></div>"
                    },
                    "status": "final",
                    "category": [
                        {
                            "coding": [
                                {
                                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                    "code": "laboratory"
                                }
                            ]
                        }
                    ],
                    "code": {
                        "coding": [
                            {
                                "system": "http://loinc.org",
                                "code": "882-1",
                                "display": "ABO and Rh group [Type] in Blood"
                            }
                        ]
                    },
                    "subject": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "effectiveDateTime": "2015-10-10T09:15:00+01:00",
                    "performer": [
                        {
                            "reference": "Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7"
                        }
                    ],
                    "valueCodeableConcept": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "278149003",
                                "display": "Blood group A Rh(D) positive"
                            }
                        ]
                    }
                }
            },
            {
                "fullUrl": "urn:uuid:6e39ccf3-f997-4a2b-8f28-b4b71c778c70",
                "resource": {
                    "resourceType": "Observation",
                    "id": "6e39ccf3-f997-4a2b-8f28-b4b71c778c70",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p></p><p><b>category</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/observation-category laboratory}\">Laboratory</span></p><p><b>code</b>: <span title=\"Codes: {http://loinc.org 945-6}\">C Ab [Presence] in Serum or Plasma</span></p><p><b>subject</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>effective</b>: Oct 10, 2015, 8:35:00 AM</p><p><b>performer</b>: <a href=\"#Organization_45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7\">See above (Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7)</a></p><p><b>value</b>: <span title=\"Codes: {http://snomed.info/sct 10828004}\">Positive</span></p></div>"
                    },
                    "status": "final",
                    "category": [
                        {
                            "coding": [
                                {
                                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                    "code": "laboratory"
                                }
                            ]
                        }
                    ],
                    "code": {
                        "coding": [
                            {
                                "system": "http://loinc.org",
                                "code": "945-6",
                                "display": "C Ab [Presence] in Serum or Plasma"
                            }
                        ]
                    },
                    "subject": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "effectiveDateTime": "2015-10-10T09:35:00+01:00",
                    "performer": [
                        {
                            "reference": "Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7"
                        }
                    ],
                    "valueCodeableConcept": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "10828004",
                                "display": "Positive"
                            }
                        ]
                    }
                }
            },
            {
                "fullUrl": "urn:uuid:b4916505-a06b-460c-9be8-011609282457",
                "resource": {
                    "resourceType": "Observation",
                    "id": "b4916505-a06b-460c-9be8-011609282457",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p></p><p><b>category</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/observation-category laboratory}\">Laboratory</span></p><p><b>code</b>: <span title=\"Codes: {http://loinc.org 1018-1}\">E Ab [Presence] in Serum or Plasma</span></p><p><b>subject</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>effective</b>: Oct 10, 2015, 8:35:00 AM</p><p><b>performer</b>: <a href=\"#Organization_45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7\">See above (Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7)</a></p><p><b>value</b>: <span title=\"Codes: {http://snomed.info/sct 10828004}\">Positive</span></p></div>"
                    },
                    "status": "final",
                    "category": [
                        {
                            "coding": [
                                {
                                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                    "code": "laboratory"
                                }
                            ]
                        }
                    ],
                    "code": {
                        "coding": [
                            {
                                "system": "http://loinc.org",
                                "code": "1018-1",
                                "display": "E Ab [Presence] in Serum or Plasma"
                            }
                        ]
                    },
                    "subject": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "effectiveDateTime": "2015-10-10T09:35:00+01:00",
                    "performer": [
                        {
                            "reference": "Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7"
                        }
                    ],
                    "valueCodeableConcept": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "10828004",
                                "display": "Positive"
                            }
                        ]
                    }
                }
            },
            {
                "fullUrl": "urn:uuid:a6a5a1d5-c896-4c7e-b922-888fcc7e6ae4",
                "resource": {
                    "resourceType": "Observation",
                    "id": "a6a5a1d5-c896-4c7e-b922-888fcc7e6ae4",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p></p><p><b>category</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/observation-category laboratory}\">Laboratory</span></p><p><b>code</b>: <span title=\"Codes: {http://loinc.org 1156-9}\">little c Ab [Presence] in Serum or Plasma</span></p><p><b>subject</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>effective</b>: Oct 10, 2015, 8:35:00 AM</p><p><b>performer</b>: <a href=\"#Organization_45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7\">See above (Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7)</a></p><p><b>value</b>: <span title=\"Codes: {http://snomed.info/sct 260385009}\">Negative</span></p></div>"
                    },
                    "status": "final",
                    "category": [
                        {
                            "coding": [
                                {
                                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                    "code": "laboratory"
                                }
                            ]
                        }
                    ],
                    "code": {
                        "coding": [
                            {
                                "system": "http://loinc.org",
                                "code": "1156-9",
                                "display": "little c Ab [Presence] in Serum or Plasma"
                            }
                        ]
                    },
                    "subject": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "effectiveDateTime": "2015-10-10T09:35:00+01:00",
                    "performer": [
                        {
                            "reference": "Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7"
                        }
                    ],
                    "valueCodeableConcept": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "260385009",
                                "display": "Negative"
                            }
                        ]
                    }
                }
            },
            {
                "fullUrl": "urn:uuid:2639657a-c19a-48e2-82cc-471e13b8ad94",
                "resource": {
                    "resourceType": "Observation",
                    "id": "2639657a-c19a-48e2-82cc-471e13b8ad94",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p></p><p><b>category</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/observation-category laboratory}\">Laboratory</span></p><p><b>code</b>: <span title=\"Codes: \">Blood typing</span></p><p><b>subject</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>effective</b>: 2015-10-10</p><p><b>performer</b>: <a href=\"#Organization_45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7\">See above (Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7)</a></p><p><b>hasMember</b>: </p><ul><li><a href=\"#Observation_aa11a2be-3e36-4be7-b58a-6fc3dace2741\">See above (Observation/aa11a2be-3e36-4be7-b58a-6fc3dace2741)</a></li><li><a href=\"#Observation_6e39ccf3-f997-4a2b-8f28-b4b71c778c70\">See above (Observation/6e39ccf3-f997-4a2b-8f28-b4b71c778c70)</a></li><li><a href=\"#Observation_b4916505-a06b-460c-9be8-011609282457\">See above (Observation/b4916505-a06b-460c-9be8-011609282457)</a></li><li><a href=\"#Observation_a6a5a1d5-c896-4c7e-b922-888fcc7e6ae4\">See above (Observation/a6a5a1d5-c896-4c7e-b922-888fcc7e6ae4)</a></li></ul></div>"
                    },
                    "status": "final",
                    "category": [
                        {
                            "coding": [
                                {
                                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                    "code": "laboratory"
                                }
                            ]
                        }
                    ],
                    "code": {
                        "text": "Blood typing"
                    },
                    "subject": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "effectiveDateTime": "2015-10-10",
                    "performer": [
                        {
                            "reference": "Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7"
                        }
                    ],
                    "hasMember": [
                        {
                            "reference": "Observation/aa11a2be-3e36-4be7-b58a-6fc3dace2741"
                        },
                        {
                            "reference": "Observation/6e39ccf3-f997-4a2b-8f28-b4b71c778c70"
                        },
                        {
                            "reference": "Observation/b4916505-a06b-460c-9be8-011609282457"
                        },
                        {
                            "reference": "Observation/a6a5a1d5-c896-4c7e-b922-888fcc7e6ae4"
                        }
                    ]
                }
            },
            {
                "fullUrl": "urn:uuid:cc354e00-a419-47ea-8b6c-1768b2a01646",
                "resource": {
                    "resourceType": "Observation",
                    "id": "cc354e00-a419-47ea-8b6c-1768b2a01646",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p></p><p><b>category</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/observation-category laboratory}\">Laboratory</span></p><p><b>code</b>: <span title=\"Codes: {http://loinc.org 17856-6}\">Hemoglobin A1c/Hemoglobin.total in Blood by HPLC</span></p><p><b>subject</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>effective</b>: Nov 10, 2017, 7:20:00 AM</p><p><b>performer</b>: <a href=\"#Organization_45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7\">See above (Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7)</a></p><p><b>value</b>: 7.5 %</p><p><b>note</b>: Above stated goal of 7.0 %</p></div>"
                    },
                    "status": "final",
                    "category": [
                        {
                            "coding": [
                                {
                                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                    "code": "laboratory"
                                }
                            ]
                        }
                    ],
                    "code": {
                        "coding": [
                            {
                                "system": "http://loinc.org",
                                "code": "17856-6",
                                "display": "Hemoglobin A1c/Hemoglobin.total in Blood by HPLC"
                            }
                        ]
                    },
                    "subject": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "effectiveDateTime": "2017-11-10T08:20:00+01:00",
                    "performer": [
                        {
                            "reference": "Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7"
                        }
                    ],
                    "valueQuantity": {
                        "value": 7.5,
                        "unit": "%",
                        "system": "http://unitsofmeasure.org",
                        "code": "%"
                    },
                    "note": [
                        {
                            "text": "Above stated goal of 7.0 %"
                        }
                    ]
                }
            },
            {
                "fullUrl": "urn:uuid:26bee0a9-5997-4557-ab9d-c6adbb05b572",
                "resource": {
                    "resourceType": "Observation",
                    "id": "26bee0a9-5997-4557-ab9d-c6adbb05b572",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p></p><p><b>category</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/observation-category laboratory}\">Laboratory</span></p><p><b>code</b>: <span title=\"Codes: {http://loinc.org 42803-7}\">Bacteria identified in Isolate</span></p><p><b>subject</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p><p><b>effective</b>: Dec 10, 2017, 7:20:00 AM</p><p><b>performer</b>: <a href=\"#Organization_45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7\">See above (Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7)</a></p><p><b>value</b>: <span title=\"Codes: {http://snomed.info/sct 115329001}\">Methicillin resistant Staphylococcus aureus</span></p><p><b>note</b>: Healthy carrier of MRSA</p></div>"
                    },
                    "status": "final",
                    "category": [
                        {
                            "coding": [
                                {
                                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                    "code": "laboratory"
                                }
                            ]
                        }
                    ],
                    "code": {
                        "coding": [
                            {
                                "system": "http://loinc.org",
                                "code": "42803-7",
                                "display": "Bacteria identified in Isolate"
                            }
                        ]
                    },
                    "subject": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    },
                    "effectiveDateTime": "2017-12-10T08:20:00+01:00",
                    "performer": [
                        {
                            "reference": "Organization/45a5c5b1-4ec1-4d60-b4b2-ff5a84a41fd7"
                        }
                    ],
                    "valueCodeableConcept": {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "115329001",
                                "display": "Methicillin resistant Staphylococcus aureus"
                            }
                        ]
                    },
                    "note": [
                        {
                            "text": "Healthy carrier of MRSA"
                        }
                    ]
                }
            },
            {
                "fullUrl": "urn:uuid:c7781f44-6df8-4a8b-9e06-0b34263a47c5",
                "resource": {
                    "resourceType": "AllergyIntolerance",
                    "id": "c7781f44-6df8-4a8b-9e06-0b34263a47c5",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>clinicalStatus</b>: <span title=\"Codes: {http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical active}\">Active</span></p><p><b>code</b>: <span title=\"Codes: {http://hl7.org/fhir/uv/ips/CodeSystem/absent-unknown-uv-ips no-known-food-allergies}\">No known food allergies</span></p><p><b>patient</b>: <a href=\"#Patient_2b90dd2b-2dab-4c75-9bb9-a355e07401e8\">See above (Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8)</a></p></div>"
                    },
                    "clinicalStatus": {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                                "code": "active"
                            }
                        ]
                    },
                    "code": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/uv/ips/CodeSystem/absent-unknown-uv-ips",
                                "code": "no-known-food-allergies"
                            }
                        ]
                    },
                    "patient": {
                        "reference": "Patient/2b90dd2b-2dab-4c75-9bb9-a355e07401e8"
                    }
                }
            }
        ]
    };

    r4:Bundle|error ipsBundle = getIpsBundle(check bundleJson.cloneWithType(r4:Bundle));
    if ipsBundle is r4:Bundle {
        test:assertTrue(ipsBundle.entry is r4:BundleEntry[], "Number of entries in the bundle");
        test:assertEquals((<r4:BundleEntry[]>ipsBundle.entry).length(), 15, "Number of entries in the bundle");
    } else {
        test:assertFail("Error in parsing the bundle");
    }
}

@test:Config
public function testNegativeSectionConfig() returns error? {
    final IpsSectionConfig[] sectionConfigs = [
        {
            sectionName: PROBLEMS,
            sectionTitle: "Active Problems",
            resources: [
                {resourceType: "Goal"}
            ]
        }
    ];

    string[]? errorMsgs = validateSectionConfig(sectionConfigs);
    if errorMsgs is string[] {
        test:assertEquals(errorMsgs.length(), 4, msg = "Should have one error message");
    } else {
        test:assertFail("Section configuration validation did not return expected error messages");
    }
}

@test:Config
public function testGenerateIpsWithMockServices() returns error? {
    string patientId = "102";

    final IpsSectionConfig[] sectionConfigs = [
        {
            sectionName: PROBLEMS,
            sectionTitle: "Active Problems",
            resources: [
                {resourceType: "Condition"}
            ]
        },
        {
            sectionName: ALLERGIES,
            sectionTitle: "Allergies and Intolerances",
            resources: [
                {resourceType: "AllergyIntolerance"}
            ]
        },
        {
            sectionName: MEDICATIONS,
            sectionTitle: "Medication Summary",
            resources: [
                {resourceType: "MedicationStatement"}
            ]
        },
        {
            sectionName: IMMUNIZATIONS,
            sectionTitle: "Immunizations",
            resources: [
                {resourceType: "Immunization"}
            ]
        }
    ];

    map<string> serviceResourceMap = {
        "Patient": "http://localhost:9090/fhir/r4",
        "Organization": "http://localhost:9091/fhir/r4",
        "Condition": "http://localhost:9092/fhir/r4",
        "AllergyIntolerance": "http://localhost:9093/fhir/r4",
        "MedicationStatement": "http://localhost:9094/fhir/r4",
        "Practitioner": "http://localhost:9095/fhir/r4",
        "Medication": "http://localhost:9096/fhir/r4",
        "Immunization": "http://localhost:9097/fhir/r4"
    };

    IpsMetaData ipsMetaData = {
        authors: ["Practitioner/12345", "Organization/50"],
        custodian: "Organization/50"
    };

    // validate the section configurations
    string[]? errorMsgs = validateSectionConfig(sectionConfigs, ipsMetaData);
    if errorMsgs is string[] {
        test:assertFail("Section configuration validation failed: " + errorMsgs.toString().'join(", "));
    }

    // create the IPS context for the mock fhir services
    IPSContext ipsContext = check new (serviceResourceMap, ipsMetaData, sectionConfigs);

    r4:Bundle bundle = check generateIps(patientId, ipsContext);
    r4:Bundle expectedBundle = check generatedIpsBundle.cloneWithType();

    r4:BundleEntry[] bundleEntries = bundle.entry is r4:BundleEntry[] ? <r4:BundleEntry[]>bundle.entry : [];
    r4:BundleEntry[] expectedEntries = expectedBundle.entry is r4:BundleEntry[] ? <r4:BundleEntry[]>expectedBundle.entry : [];

    test:assertEquals(bundleEntries.length(), expectedEntries.length(), msg = "Bundle should have the same number of entries");

    int index = 0;
    foreach var item in bundleEntries {
        r4:Resource bundleResource = check item["resource"].cloneWithType();
        r4:Resource expectedBundleResource = check expectedEntries[index]["resource"].cloneWithType();
        
        if index == 0 {
            CompositionUvIps composition = check bundleResource.cloneWithType();
            CompositionUvIps expectedComposition = check expectedBundleResource.cloneWithType();

            expectedComposition.date = composition.date;

            test:assertEquals(composition, expectedComposition, msg = "Composition resource should match expected");
        } else {
            test:assertEquals(bundleResource, expectedBundleResource, msg = "Resource at index " + index.toString() + " should match expected");
        }

        index += 1;
    }
}
