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

import ballerinax/health.fhir.r4;

r4:ConceptMap testConceptMap1 = {
    "resourceType": "ConceptMap",
    "id": "sc-account-status",
    "text": {
        "status": "generated",
        "div": "<div>!-- Snipped for Brevity --></div>"
    },
    "url": "http://hl7.org/fhir/ConceptMap/sc-account-status",
    "version": "4.0.1",
    "name": "AccountStatusCanonicalMap",
    "title": "Canonical Mapping for \"AccountStatus\"",
    "status": "draft",
    "date": "2019-11-01T09:29:23+11:00",
    "publisher": "HL7 (FHIR Project)",
    "contact": [
        {
            "telecom": [
                {
                    "system": "url",
                    "value": "http://hl7.org/fhir"
                },
                {
                    "system": "email",
                    "value": "fhir@lists.hl7.org"
                }
            ]
        }
    ],
    "description": "Canonical Mapping for \"Indicates whether the account is available to be used.\"",
    "sourceCanonical": "http://hl7.org/fhir/ValueSet/account-status",
    "targetCanonical": "http://hl7.org/fhir/ValueSet/resource-status",
    "group": [
        {
            "source": "http://hl7.org/fhir/account-status",
            "target": "http://hl7.org/fhir/resource-status",
            "element": [
                {
                    "code": "entered-in-error",
                    "target": [
                        {
                            "code": "error",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "active",
                    "target": [
                        {
                            "code": "active",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "on-hold",
                    "target": [
                        {
                            "code": "suspended",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "inactive",
                    "target": [
                        {
                            "code": "inactive",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "unknown",
                    "target": [
                        {
                            "code": "unknown",
                            "equivalence": "equivalent"
                        }
                    ]
                }
            ]
        }
    ]
};

r4:ConceptMap testConceptMap1WithDifferentCodes = {
    "resourceType": "ConceptMap",
    "id": "sc-account-status",
    "text": {
        "status": "generated",
        "div": "<div>!-- Snipped for Brevity --></div>"
    },
    "url": "http://hl7.org/fhir/ConceptMap/sc-account-status2",
    "version": "4.0.1",
    "status": "draft",
    "sourceCanonical": "http://hl7.org/fhir/ValueSet/account-status",
    "targetCanonical": "http://hl7.org/fhir/ValueSet/resource-status",
    "group": [
        {
            "source": "http://hl7.org/fhir/account-status2",
            "target": "http://hl7.org/fhir/resource-status2",
            "element": [
                {
                    "code": "entered-in-error2",
                    "target": [
                        {
                            "code": "error",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "active",
                    "target": [
                        {
                            "code": "active2",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "on-hold2",
                    "target": [
                        {
                            "code": "suspended",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "inactive",
                    "target": [
                        {
                            "code": "inactive2",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "unknown2",
                    "target": [
                        {
                            "code": "unknown",
                            "equivalence": "equivalent"
                        }
                    ]
                }
            ]
        }
    ]
};

r4:ConceptMap testConceptMap2 = {
    "resourceType": "ConceptMap",
    "id": "cm-administrative-gender-v2",
    "text": {
        "status": "generated",
        "div": "<div>!-- Snipped for Brevity --></div>"
    },
    "url": "http://hl7.org/fhir/ConceptMap/cm-administrative-gender-v2",
    "version": "4.0.1",
    "name": "v2.AdministrativeGender",
    "title": "v2 map for AdministrativeGender",
    "status": "draft",
    "date": "2019-11-01T09:29:23+11:00",
    "publisher": "HL7 (FHIR Project)",
    "sourceCanonical": "http://hl7.org/fhir/ValueSet/administrative-gender",
    "targetCanonical": "http://terminology.hl7.org/ValueSet/v2-0001",
    "group": [
        {
            "source": "http://hl7.org/fhir/administrative-gender",
            "target": "http://terminology.hl7.org/CodeSystem/v2-0001",
            "element": [
                {
                    "code": "male",
                    "target": [
                        {
                            "code": "M",
                            "equivalence": "equal"
                        }
                    ]
                },
                {
                    "code": "female",
                    "target": [
                        {
                            "code": "F",
                            "equivalence": "equal"
                        }
                    ]
                },
                {
                    "code": "other",
                    "target": [
                        {
                            "code": "A",
                            "equivalence": "wider"
                        },
                        {
                            "code": "O",
                            "equivalence": "wider"
                        }
                    ]
                },
                {
                    "code": "unknown",
                    "target": [
                        {
                            "code": "U",
                            "equivalence": "equal"
                        }
                    ]
                }
            ]
        }
    ]
};

r4:ConceptMap unmappedConceptMapFixed = {
    "resourceType": "ConceptMap",
    "id": "unmapped-concept-map-fixed",
    "url": "http://example.org/cm3",
    "version": "4.0.1",
    "status": "draft",
    "sourceCanonical": "http://hl7.org/fhir/ValueSet/fixed1",
    "targetCanonical": "http://hl7.org/fhir/ValueSet/fixed2",
    "group": [
        {
            "source": "http://hl7.org/fhir/account-status",
            "target": "http://hl7.org/fhir/resource-status",
            "element": [
                {
                    "code": "entered-in-error",
                    "target": [
                        {
                            "code": "error",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "active",
                    "target": [
                        {
                            "code": "active",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "on-hold",
                    "target": [
                        {
                            "code": "suspended",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "inactive",
                    "target": [
                        {
                            "code": "inactive",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "unknown",
                    "target": [
                        {
                            "code": "unknown",
                            "equivalence": "equivalent"
                        }
                    ]
                }
            ],
            "unmapped": {
                "mode": "fixed",
                "code": "temp",
                "display": "temp"
            }
        }
    ]
};

r4:ConceptMap unmappedConceptMapProvided = {
    "resourceType": "ConceptMap",
    "id": "unmapped-concept-map-provided",
    "url": "http://example.org/cm4",
    "version": "4.0.1",
    "status": "draft",
    "sourceCanonical": "http://hl7.org/fhir/ValueSet/provided1",
    "targetCanonical": "http://hl7.org/fhir/ValueSet/provided2",
    "group": [
        {
            "source": "http://hl7.org/fhir/account-status",
            "target": "http://hl7.org/fhir/resource-status",
            "element": [
                {
                    "code": "entered-in-error",
                    "target": [
                        {
                            "code": "error",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "active",
                    "target": [
                        {
                            "code": "active",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "on-hold",
                    "target": [
                        {
                            "code": "suspended",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "inactive",
                    "target": [
                        {
                            "code": "inactive",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "unknown",
                    "target": [
                        {
                            "code": "unknown",
                            "equivalence": "equivalent"
                        }
                    ]
                }
            ],
            "unmapped": {
                "mode": "provided"
            }
        }
    ]
};

r4:ConceptMap unmappedConceptMapOtherMap = {
    "resourceType": "ConceptMap",
    "id": "example2",
    "url": "http://hl7.org/fhir/ConceptMap/example2",
    "version": "4.0.1",
    "name": "FHIR-exanple-2",
    "title": "FHIR Example 2",
    "status": "draft",
    "experimental": true,
    "date": "2012-06-13",
    "publisher": "HL7, Inc",
    "contact": [
        {
            "name": "FHIR project team (example)",
            "telecom": [
                {
                    "system": "url",
                    "value": "http://hl7.org/fhir"
                }
            ]
        }
    ],
    "description": "An example mapping",
    "purpose": "To illustrate mapping features",
    "sourceUri": "http://example.org/fhir/example1",
    "targetUri": "http://example.org/fhir/example2",
    "group": [
        {
            "source": "http://example.org/fhir/example1",
            "target": "http://example.org/fhir/example2",
            "element": [
                {
                    "code": "code",
                    "display": "Example Code",
                    "target": [
                        {
                            "code": "code2",
                            "display": "Some Example Code",
                            "equivalence": "equivalent",
                            "dependsOn": [
                                {
                                    "property": "http://example.org/fhir/property-value/example",
                                    "system": "http://example.org/fhir/example3",
                                    "value": "some-code",
                                    "display": "Something Coded"
                                }
                            ]
                        }
                    ]
                }
            ],
            "unmapped": {
                "mode": "other-map",
                "url": "http://example.org/fhir/ConceptMap/map2"
            }
        }
    ]
};

r4:ConceptMap otherMap = {
    "resourceType": "ConceptMap",
    "id": "example2",
    "url": "http://example.org/fhir/ConceptMap/map2",
    "version": "4.0.1",
    "name": "Other-map-for-test",
    "status": "draft",
    "sourceUri": "http://example.org/fhir/otherMapexample1",
    "targetUri": "http://example.org/fhir/otherMapexample2",
    "group": [
        {
            "source": "http://example.org/fhir/example3",
            "target": "http://example.org/fhir/example4",
            "element": [
                {
                    "code": "otherMapCode",
                    "display": "Example Code",
                    "target": [
                        {
                            "code": "otherMapTargetCode",
                            "display": "Other Map Example Code",
                            "equivalence": "equivalent"
                        }
                    ]
                }
            ]
        }
    ]
};

r4:ConceptMap otherMap2 = {
    "resourceType": "ConceptMap",
    "id": "example2",
    "url": "http://example.org/fhir/ConceptMap/map2-2",
    "version": "4.0.1",
    "name": "Other-map-for-test",
    "status": "draft",
    "sourceUri": "http://example.org/fhir/otherMap2example1",
    "targetUri": "http://example.org/fhir/otherMap2example2",
    "group": [
        {
            "source": "http://example.org/fhir/example5",
            "target": "http://example.org/fhir/example6",
            "element": [
                {
                    "code": "otherMapCodeNoMatch",
                    "display": "Example Code",
                    "target": [
                        {
                            "code": "otherMapTargetCode",
                            "display": "Other Map Example Code",
                            "equivalence": "equivalent"
                        }
                    ]
                }
            ],
            "unmapped": {
                "mode": "other-map",
                "url": "http://example.org/fhir/ConceptMap/map2-3"
            }
        }
    ]
};

r4:ConceptMap otherMap3 = {
    "resourceType": "ConceptMap",
    "id": "example2",
    "url": "http://example.org/fhir/ConceptMap/map2-3",
    "version": "4.0.1",
    "name": "Other-map-for-test",
    "status": "draft",
    "sourceUri": "http://example.org/fhir/otherMap3example1",
    "targetUri": "http://example.org/fhir/otherMap3example2",
    "group": [
        {
            "source": "http://example.org/fhir/example5",
            "target": "http://example.org/fhir/example6",
            "element": [
                {
                    "code": "otherMapCodeNoMatch",
                    "display": "Example Code",
                    "target": [
                        {
                            "code": "otherMap3TargetCode",
                            "display": "Other Map 3 Example Code",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "otherMap3Code",
                    "display": "Example 3 Code",
                    "target": [
                        {
                            "code": "otherMap3TargetCode",
                            "display": "Other Map 3 Example Code",
                            "equivalence": "equivalent"
                        }
                    ]
                }
            ],
            "unmapped": {
                "mode": "other-map",
                "url": "http://example.org/fhir/ConceptMap/map2-4"
            }
        }
    ]
};

r4:ConceptMap otherMap4 = {
    "resourceType": "ConceptMap",
    "id": "example2",
    "url": "http://example.org/fhir/ConceptMap/map2-4",
    "version": "4.0.1",
    "name": "Other-map-for-test",
    "status": "draft",
    "sourceUri": "http://example.org/fhir/otherMap4example1",
    "targetUri": "http://example.org/fhir/otherMap4example2",
    "group": [
        {
            "source": "http://example.org/fhir/example5",
            "target": "http://example.org/fhir/example6",
            "element": [
                {
                    "code": "otherMapCode",
                    "display": "Example 4 Code",
                    "target": [
                        {
                            "code": "otherMap4TargetCode",
                            "display": "Other Map 4 Example Code",
                            "equivalence": "equivalent"
                        }
                    ]
                }
            ]
        }
    ]
};

r4:ValueSet vs5 = {
    status: "draft",
    id: "account-status",
    url: "http://hl7.org/fhir/ValueSet/account-status",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://hl7.org/fhir/account-status"
            }
        ]
    }
};
r4:ValueSet vs6 = {
    status: "draft",
    id: "resource-status",
    url: "http://hl7.org/fhir/ValueSet/resource-status",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://hl7.org/fhir/resource-status"
            }
        ]
    }
};
r4:ValueSet vs7 = {
    status: "draft",
    id: "administrative-gender",
    url: "http://hl7.org/fhir/ValueSet/administrative-gender",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://hl7.org/fhir/administrative-gender"
            }
        ]
    }
};
r4:ValueSet vs8 = {
    status: "draft",
    id: "v2-0001",
    url: "http://terminology.hl7.org/ValueSet/v2-0001",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://terminology.hl7.org/CodeSystem/v2-0001"
            }
        ]
    }
};
r4:ValueSet vs9 = {
    status: "draft",
    id: "v2-0001",
    url: "http://hl7.org/fhir/ValueSet/fixed1",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://terminology.hl7.org/CodeSystem/v2-0001"
            }
        ]
    }
};
r4:ValueSet vs10 = {
    status: "draft",
    id: "v2-0001",
    url: "http://hl7.org/fhir/ValueSet/fixed2",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://terminology.hl7.org/CodeSystem/v2-0001"
            }
        ]
    }
};
r4:ValueSet vs11 = {
    status: "draft",
    id: "v2-0001",
    url: "http://hl7.org/fhir/ValueSet/provided12",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://terminology.hl7.org/CodeSystem/v2-0001"
            }
        ]
    }
};
r4:ValueSet vs12 = {
    status: "draft",
    id: "v2-0001",
    url: "http://hl7.org/fhir/ValueSet/provided2",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://terminology.hl7.org/CodeSystem/v2-0001"
            }
        ]
    }
};
r4:ValueSet vs13 = {
    status: "draft",
    id: "v2-0001",
    url: "http://example.org/fhir/example1",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://example.org/fhir/example1"
            }
        ]
    }
};
r4:ValueSet vs14 = {
    status: "draft",
    id: "v2-0001",
    url: "http://example.org/fhir/example2",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://example.org/fhir/example2"
            }
        ]
    }
};
r4:ValueSet vs15 = {
    status: "draft",
    url: "http://example.org/fhir/otherMapexample1",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://example.org/fhir/example3"
            }
        ]
    }
};
r4:ValueSet vs16 = {
    status: "draft",
    url: "http://example.org/fhir/otherMapexample2",
    'version: "4.0.1",
    compose: {
        include: [
            {
                system: "http://example.org/fhir/example4"
            }
        ]
    }
};

r4:ConceptMap sampleSearchConceptMap = {status: "unknown", url: "http://hl7.org/fhir/ConceptMap/cm-address-type-v3"};
