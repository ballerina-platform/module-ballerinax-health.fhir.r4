// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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

function getCcdaResource() returns json {
    return {
    "ClinicalDocument": {
        "realmCode": {
            "_code": "US"
        },
        "typeId": {
            "_extension": "POCD_HD000040",
            "_root": "2.16.840.1.113883.1.3"
        },
        "templateId": [
            {
                "_root": "2.16.840.1.113883.10.20.22.1.2",
                "_extension": "2024-05-01"
            },
            {
                "_root": "2.16.840.1.113883.10.20.22.1.1"
            }
        ],
        "id": {
            "_assigningAuthorityName": "DCI",
            "_root": "2.16.840.1.113883.3.4808"
        },
        "code": {
            "_code": "34133-9",
            "_codeSystem": "2.16.840.1.113883.6.1",
            "_codeSystemName": "LOINC",
            "_displayName": "Summarization of Episode Note DCI"
        },
        "title": "DCI Continuity of Care Document",
        "effectiveTime": {
            "_value": "20160414095027"
        },
        "confidentialityCode": {
            "_code": "R",
            "_codeSystem": "2.16.840.1.113883.5.25",
            "_codeSystemName": "ConfidentialityCode"
        },
        "languageCode": {
            "_code": "en-US"
        },
        "recordTarget": {
            "patientRole": {
                "id": [
                    {
                        "_extension": "337993",
                        "_root": "2.16.840.1.113883.3.4808"
                    },
                    {
                        "_extension": "         ",
                        "_root": "2.16.840.1.113883.4.1"
                    }
                ],
                "addr": {
                    "state": "CA",
                    "city": "OROVILLE",
                    "postalCode": "21014",
                    "streetAddressLine": "302 Cumming Ave RR 2",
                    "country": "US",
                    "_use": "HP"
                },
                "telecom": {
                    "_use": "HP",
                    "_value": "4105550305"
                },
                "patient": {
                    "name": {
                        "given": "BARBARA",
                        "family": "DCI",
                        "_use": "L"
                    },
                    "administrativeGenderCode": {
                        "_code": "F",
                        "_codeSystem": "2.16.840.1.113883.5.1",
                        "_displayName": "Female"
                    },
                    "birthTime": {
                        "_value": "19811208"
                    },
                    "maritalStatusCode": {
                        "_code": "M   ",
                        "_codeSystem": "2.16.840.1.113883.5.2",
                        "_codeSystemName": "MaritalStatusCode",
                        "_displayName": "MARRIED   "
                    },
                    "raceCode": {
                        "_code": "null      ",
                        "_codeSystem": "2.16.840.1.113883.6.238",
                        "_codeSystemName": "Race & Ethnicity - CDC",
                        "_displayName": "null      "
                    },
                    "ethnicGroupCode": {
                        "_code": "2186-5",
                        "_codeSystem": "2.16.840.1.113883.6.238",
                        "_codeSystemName": "Race & Ethnicity - CDC",
                        "_displayName": "Hispanic or Latino "
                    },
                    "languageCommunication": {
                        "languageCode": {
                            "_code": "english"
                        },
                        "preferenceInd": {
                            "_value": "true"
                        }
                    }
                }
            }
        },
        "author": {
            "time": {
                "_value": "20160414"
            },
            "assignedAuthor": {
                "id": {
                    "_extension": "111111",
                    "_root": "2.16.840.1.113883.4.6"
                },
                "addr": {
                    "streetAddressLine": "302 Cumming Ave RR 2",
                    "city": "OROVILLE",
                    "state": "CA",
                    "postalCode": "21014",
                    "country": "US"
                },
                "telecom": {
                    "_use": "WP",
                    "_value": "4105550305"
                },
                "assignedPerson": {
                    "name": {
                        "prefix": "Dr",
                        "given": "Colon",
                        "family": "Wilma"
                    }
                }
            }
        },
        "custodian": {
            "assignedCustodian": {
                "representedCustodianOrganization": {
                    "id": {
                        "_extension": "99999999",
                        "_root": "2.16.840.1.113883.4.6"
                    },
                    "name": "",
                    "telecom": {
                        "_use": "WP",
                        "_value": "tel: +1-(410)555-5544"
                    },
                    "addr": {
                        "streetAddressLine": "8333 Clairemont Blvd",
                        "city": "Bel Air",
                        "state": "MD",
                        "postalCode": "21014",
                        "country": "US",
                        "_use": "WP"
                    }
                }
            }
        },
        "component": {
            "structuredBody": {
                "component": [
                    {
                        "section": {
                            "templateId": [
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.5.1"
                                },
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.5"
                                }
                            ],
                            "code": {
                                "_code": "11450-4",
                                "_codeSystem": "2.16.840.1.113883.6.1",
                                "_codeSystemName": "LOINC",
                                "_displayName": "Problem List"
                            },
                            "title": "Problems",
                            "text": {
                                "table": {
                                    "thead": {
                                        "tr": {
                                            "th": [
                                                "Condition",
                                                "Effective Date",
                                                "Resolved Date",
                                                "Status"
                                            ]
                                        }
                                    },
                                    "tbody": {
                                        "tr": [
                                            {
                                                "td": [
                                                    {
                                                        "_ID": "problem920000584281",
                                                        "__text": "Burn Of Third Degree Of Unspecified Thigh, Subsequent Encounter"
                                                    },
                                                    "06/25/2015",
                                                    "",
                                                    "Active"
                                                ]
                                            },
                                            {
                                                "td": [
                                                    {
                                                        "_ID": "problem920000584280",
                                                        "__text": "Burn Of Second Degree Of Female Genital Region, Initial Encounter"
                                                    },
                                                    "06/25/2015",
                                                    "",
                                                    "Active"
                                                ]
                                            },
                                            {
                                                "td": [
                                                    {
                                                        "_ID": "problem920000584278",
                                                        "__text": "Burns on lower body"
                                                    },
                                                    "06/18/2015",
                                                    "06/25/2015",
                                                    "Resolved"
                                                ]
                                            },
                                            {
                                                "td": [
                                                    {
                                                        "_ID": "problem920000584276",
                                                        "__text": "Cerebral Palsy, Unspecified"
                                                    },
                                                    "08/29/1982",
                                                    "",
                                                    "Active"
                                                ]
                                            }
                                        ]
                                    },
                                    "_width": "100%",
                                    "_border": "1"
                                }
                            },
                            "entry": [
                                {
                                    "act": {
                                        "templateId": {
                                            "_root": "2.16.840.1.113883.10.20.22.4.3"
                                        },
                                        "id": {
                                            "_extension": "920000584281",
                                            "_root": "2c92a6bc-4614-f58f-0146-155c72be4d6c"
                                        },
                                        "code": {
                                            "_nullFlavor": "NI"
                                        },
                                        "statusCode": {
                                            "_code": "completed"
                                        },
                                        "effectiveTime": {
                                            "low": {
                                                "_value": "20160413003547Z"
                                            }
                                        },
                                        "entryRelationship": {
                                            "observation": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.4"
                                                },
                                                "id": {
                                                    "_root": "ff5f915d-5258-4547-91ad-ddf934e24c58"
                                                },
                                                "code": {
                                                    "_code": "55607006",
                                                    "_codeSystem": "2.16.840.1.113883.6.96",
                                                    "_codeSystemName": "SNOMED",
                                                    "_displayName": "Problem"
                                                },
                                                "text": {
                                                    "reference": {
                                                        "_value": "#problem920000584281"
                                                    }
                                                },
                                                "statusCode": {
                                                    "_code": "completed"
                                                },
                                                "effectiveTime": {
                                                    "low": {
                                                        "_value": "20150625"
                                                    }
                                                },
                                                "value": {
                                                    "translation": {
                                                        "_code": "T24.319D",
                                                        "_codeSystem": "2.16.840.1.113883.6.3",
                                                        "_codeSystemName": "ICD-10-CM"
                                                    },
                                                    "_xsi:type": "CD",
                                                    "_nullFlavor": "OTH"
                                                },
                                                "_classCode": "OBS",
                                                "_moodCode": "EVN"
                                            },
                                            "_typeCode": "SUBJ"
                                        },
                                        "_classCode": "ACT",
                                        "_moodCode": "EVN"
                                    }
                                },
                                {
                                    "act": {
                                        "templateId": {
                                            "_root": "2.16.840.1.113883.10.20.22.4.3"
                                        },
                                        "id": {
                                            "_extension": "920000584280",
                                            "_root": "2c92a6bc-4614-f58f-0146-155c72be4d6c"
                                        },
                                        "code": {
                                            "_nullFlavor": "NI"
                                        },
                                        "statusCode": {
                                            "_code": "completed"
                                        },
                                        "effectiveTime": {
                                            "low": {
                                                "_value": "20160413003543Z"
                                            }
                                        },
                                        "entryRelationship": {
                                            "observation": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.4"
                                                },
                                                "id": {
                                                    "_root": "70211e95-0e6a-43f2-91b5-b85eba3616b1"
                                                },
                                                "code": {
                                                    "_code": "55607006",
                                                    "_codeSystem": "2.16.840.1.113883.6.96",
                                                    "_codeSystemName": "SNOMED",
                                                    "_displayName": "Problem"
                                                },
                                                "text": {
                                                    "reference": {
                                                        "_value": "#problem920000584280"
                                                    }
                                                },
                                                "statusCode": {
                                                    "_code": "completed"
                                                },
                                                "effectiveTime": {
                                                    "low": {
                                                        "_value": "20150625"
                                                    }
                                                },
                                                "value": {
                                                    "translation": {
                                                        "_code": "T21.27XA",
                                                        "_codeSystem": "2.16.840.1.113883.6.3",
                                                        "_codeSystemName": "ICD-10-CM"
                                                    },
                                                    "_xsi:type": "CD",
                                                    "_nullFlavor": "OTH"
                                                },
                                                "_classCode": "OBS",
                                                "_moodCode": "EVN"
                                            },
                                            "_typeCode": "SUBJ"
                                        },
                                        "_classCode": "ACT",
                                        "_moodCode": "EVN"
                                    }
                                },
                                {
                                    "act": {
                                        "templateId": {
                                            "_root": "2.16.840.1.113883.10.20.22.4.3"
                                        },
                                        "id": {
                                            "_extension": "920000584278",
                                            "_root": "2c92a6bc-4614-f58f-0146-155c72be4d6c"
                                        },
                                        "code": {
                                            "_nullFlavor": "NI"
                                        },
                                        "statusCode": {
                                            "_code": "completed"
                                        },
                                        "effectiveTime": {
                                            "low": {
                                                "_value": "20160413034835Z"
                                            },
                                            "high": {
                                                "_value": "20150625"
                                            }
                                        },
                                        "entryRelationship": {
                                            "observation": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.4"
                                                },
                                                "id": {
                                                    "_root": "10f0ec87-bac6-4357-ab1b-9c3c31008d62"
                                                },
                                                "code": {
                                                    "_code": "55607006",
                                                    "_codeSystem": "2.16.840.1.113883.6.96",
                                                    "_codeSystemName": "SNOMED",
                                                    "_displayName": "Problem"
                                                },
                                                "text": {
                                                    "reference": {
                                                        "_value": "#problem920000584278"
                                                    }
                                                },
                                                "statusCode": {
                                                    "_code": "completed"
                                                },
                                                "effectiveTime": {
                                                    "low": {
                                                        "_value": "20150618"
                                                    },
                                                    "high": {
                                                        "_value": "20150625"
                                                    }
                                                },
                                                "value": {
                                                    "translation": {
                                                        "_code": "T21.07XA",
                                                        "_codeSystem": "2.16.840.1.113883.6.3",
                                                        "_codeSystemName": "ICD-10-CM"
                                                    },
                                                    "_xsi:type": "CD",
                                                    "_nullFlavor": "OTH"
                                                },
                                                "_classCode": "OBS",
                                                "_moodCode": "EVN"
                                            },
                                            "_typeCode": "SUBJ"
                                        },
                                        "_classCode": "ACT",
                                        "_moodCode": "EVN"
                                    }
                                },
                                {
                                    "act": {
                                        "templateId": {
                                            "_root": "2.16.840.1.113883.10.20.22.4.3"
                                        },
                                        "id": {
                                            "_extension": "920000584276",
                                            "_root": "2c92a6bc-4614-f58f-0146-155c72be4d6c"
                                        },
                                        "code": {
                                            "_nullFlavor": "NI"
                                        },
                                        "statusCode": {
                                            "_code": "completed"
                                        },
                                        "effectiveTime": {
                                            "low": {
                                                "_value": "20160413033854Z"
                                            }
                                        },
                                        "entryRelationship": {
                                            "observation": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.4"
                                                },
                                                "id": {
                                                    "_root": "f2705276-28ee-4f28-9384-21fdf0705ba5"
                                                },
                                                "code": {
                                                    "_code": "55607006",
                                                    "_codeSystem": "2.16.840.1.113883.6.96",
                                                    "_codeSystemName": "SNOMED",
                                                    "_displayName": "Problem"
                                                },
                                                "text": {
                                                    "reference": {
                                                        "_value": "#problem920000584276"
                                                    }
                                                },
                                                "statusCode": {
                                                    "_code": "completed"
                                                },
                                                "effectiveTime": {
                                                    "low": {
                                                        "_value": "19820829"
                                                    }
                                                },
                                                "value": {
                                                    "translation": {
                                                        "_code": "G80.9",
                                                        "_codeSystem": "2.16.840.1.113883.6.3",
                                                        "_codeSystemName": "ICD-10-CM"
                                                    },
                                                    "_xsi:type": "CD",
                                                    "_nullFlavor": "OTH"
                                                },
                                                "_classCode": "OBS",
                                                "_moodCode": "EVN"
                                            },
                                            "_typeCode": "SUBJ"
                                        },
                                        "_classCode": "ACT",
                                        "_moodCode": "EVN"
                                    }
                                }
                            ]
                        }
                    },
                    {
                        "section": {
                            "templateId": [
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.1.1"
                                },
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.1"
                                }
                            ],
                            "code": {
                                "_code": "10160-0",
                                "_codeSystem": "2.16.840.1.113883.6.1",
                                "_codeSystemName": "LOINC",
                                "_displayName": "History of medication use"
                            },
                            "title": "Medications",
                            "text": {
                                "table": {
                                    "thead": {
                                        "tr": {
                                            "th": [
                                                "Medication",
                                                "Instructions",
                                                "Date Range",
                                                "Status",
                                                "comments"
                                            ]
                                        }
                                    },
                                    "tbody": {
                                        "tr": [
                                            {
                                                "td": [
                                                    {
                                                        "_ID": "medication920000875889",
                                                        "__text": "SENOKOT  187 MG | 2 Tablet(s) | PO | QHS  (06/01/2015 - present)"
                                                    },
                                                    "187 MG | 2 Tablet(s) | PO | QHS",
                                                    "06/01/2015-",
                                                    "Completed",
                                                    {
                                                        "_ID": "medcommentsmedication920000875889",
                                                        "__text": "Taken in clinic |"
                                                    }
                                                ]
                                            },
                                            {
                                                "td": [
                                                    {
                                                        "_ID": "medication920000875890",
                                                        "__text": "CLOTRIMAZOLE  1 % | 1 GM | VA | BID  (06/01/2015 - present)"
                                                    },
                                                    "1 % | 1 GM | VA | BID",
                                                    "06/01/2015-",
                                                    "Completed",
                                                    {
                                                        "_ID": "medcommentsmedication920000875890",
                                                        "__text": "Taken in clinic |"
                                                    }
                                                ]
                                            },
                                            {
                                                "td": [
                                                    {
                                                        "_ID": "medication920000875891",
                                                        "__text": "TYLENOL WITH CODEINE #3  300-30 MG | 1 Tablet(s) | PO | QD-PRN  (06/25/2015 - present)"
                                                    },
                                                    "300-30 MG | 1 Tablet(s) | PO | QD-PRN",
                                                    "06/25/2015-",
                                                    "Completed",
                                                    {
                                                        "_ID": "medcommentsmedication920000875891",
                                                        "__text": "Taken in clinic |"
                                                    }
                                                ]
                                            }
                                        ]
                                    },
                                    "_width": "100%",
                                    "_border": "1"
                                }
                            },
                            "entry": [
                                {
                                    "substanceAdministration": {
                                        "templateId": {
                                            "_root": "2.16.840.1.113883.10.20.22.4.16"
                                        },
                                        "id": {
                                            "_root": "a0e312da-2007-4f4b-b8ed-3973e93b948d"
                                        },
                                        "text": {
                                            "reference": {
                                                "_value": "#medication920000875889"
                                            }
                                        },
                                        "statusCode": {
                                            "_code": "completed"
                                        },
                                        "effectiveTime": [
                                            {
                                                "low": {
                                                    "_value": "20150601"
                                                },
                                                "high": {
                                                    "_nullFlavor": "NI"
                                                },
                                                "_xsi:type": "IVL_TS"
                                            },
                                            {
                                                "period": {
                                                    "_unit": "d",
                                                    "_value": "1"
                                                },
                                                "_xsi:type": "PIVL_TS",
                                                "_operator": "A"
                                            },
                                            {
                                                "event": {
                                                    "_code": "HS"
                                                },
                                                "_xsi:type": "EIVL_TS",
                                                "_operator": "A"
                                            }
                                        ],
                                        "routeCode": {
                                            "_displayName": "PO"
                                        },
                                        "doseQuantity": {
                                            "_unit": "MG",
                                            "_value": "374"
                                        },
                                        "consumable": {
                                            "manufacturedProduct": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.23"
                                                },
                                                "manufacturedMaterial": {
                                                    "code": {
                                                        "originalText": {
                                                            "reference": {
                                                                "_value": "#medication920000875889"
                                                            }
                                                        },
                                                        "translation": [
                                                            {
                                                                "_code": "35356057820",
                                                                "_codeSystem": "2.16.840.1.113883.6.69",
                                                                "_codeSystemName": "NDC",
                                                                "_displayName": "SENOKOT"
                                                            },
                                                            {
                                                                "_code": "019286",
                                                                "_codeSystem": "2.16.840.1.113883.6.253",
                                                                "_codeSystemName": "MDDID",
                                                                "_displayName": "SENOKOT"
                                                            }
                                                        ],
                                                        "_nullFlavor": "OTH"
                                                    }
                                                },
                                                "_classCode": "MANU"
                                            }
                                        },
                                        "entryRelationship": {
                                            "observation": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.1.47"
                                                },
                                                "code": {
                                                    "_code": "33999-4",
                                                    "_codeSystem": "2.16.840.1.113883.6.1",
                                                    "_codeSystemName": "LOINC",
                                                    "_displayName": "Status"
                                                },
                                                "value": {
                                                    "_xsi:type": "CE",
                                                    "_code": "55561003",
                                                    "_codeSystem": "2.16.840.1.113883.6.96",
                                                    "_displayName": "Active"
                                                },
                                                "_classCode": "OBS",
                                                "_moodCode": "EVN"
                                            },
                                            "_typeCode": "REFR"
                                        },
                                        "precondition": {
                                            "criterion": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.25"
                                                },
                                                "code": {
                                                    "_code": "ASSERTION",
                                                    "_codeSystem": "2.16.840.1.113883.5.4"
                                                },
                                                "value": {
                                                    "_xsi:type": "CE"
                                                }
                                            },
                                            "_typeCode": "PRCN"
                                        },
                                        "_classCode": "SBADM",
                                        "_moodCode": "INT"
                                    },
                                    "_typeCode": "DRIV"
                                },
                                {
                                    "substanceAdministration": {
                                        "templateId": {
                                            "_root": "2.16.840.1.113883.10.20.22.4.16"
                                        },
                                        "id": {
                                            "_root": "5e328ab0-2c51-4391-823d-ea8a3743e0cf"
                                        },
                                        "text": {
                                            "reference": {
                                                "_value": "#medication920000875890"
                                            }
                                        },
                                        "statusCode": {
                                            "_code": "completed"
                                        },
                                        "effectiveTime": [
                                            {
                                                "low": {
                                                    "_value": "20150601"
                                                },
                                                "high": {
                                                    "_nullFlavor": "NI"
                                                },
                                                "_xsi:type": "IVL_TS"
                                            },
                                            {
                                                "period": {
                                                    "_unit": "d",
                                                    "_value": ".5"
                                                },
                                                "_xsi:type": "PIVL_TS",
                                                "_operator": "A"
                                            }
                                        ],
                                        "routeCode": {
                                            "_displayName": "VA"
                                        },
                                        "doseQuantity": {
                                            "_unit": "GM",
                                            "_value": "1"
                                        },
                                        "consumable": {
                                            "manufacturedProduct": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.23"
                                                },
                                                "manufacturedMaterial": {
                                                    "code": {
                                                        "originalText": {
                                                            "reference": {
                                                                "_value": "#medication920000875890"
                                                            }
                                                        },
                                                        "translation": [
                                                            {
                                                                "_code": "00472022041",
                                                                "_codeSystem": "2.16.840.1.113883.6.69",
                                                                "_codeSystemName": "NDC",
                                                                "_displayName": "CLOTRIMAZOLE"
                                                            },
                                                            {
                                                                "_code": "004781",
                                                                "_codeSystem": "2.16.840.1.113883.6.253",
                                                                "_codeSystemName": "MDDID",
                                                                "_displayName": "CLOTRIMAZOLE"
                                                            }
                                                        ],
                                                        "_nullFlavor": "OTH"
                                                    }
                                                },
                                                "_classCode": "MANU"
                                            }
                                        },
                                        "entryRelationship": {
                                            "observation": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.1.47"
                                                },
                                                "code": {
                                                    "_code": "33999-4",
                                                    "_codeSystem": "2.16.840.1.113883.6.1",
                                                    "_codeSystemName": "LOINC",
                                                    "_displayName": "Status"
                                                },
                                                "value": {
                                                    "_xsi:type": "CE",
                                                    "_code": "55561003",
                                                    "_codeSystem": "2.16.840.1.113883.6.96",
                                                    "_displayName": "Active"
                                                },
                                                "_classCode": "OBS",
                                                "_moodCode": "EVN"
                                            },
                                            "_typeCode": "REFR"
                                        },
                                        "precondition": {
                                            "criterion": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.25"
                                                },
                                                "code": {
                                                    "_code": "ASSERTION",
                                                    "_codeSystem": "2.16.840.1.113883.5.4"
                                                },
                                                "value": {
                                                    "_xsi:type": "CE"
                                                }
                                            },
                                            "_typeCode": "PRCN"
                                        },
                                        "_classCode": "SBADM",
                                        "_moodCode": "INT"
                                    },
                                    "_typeCode": "DRIV"
                                },
                                {
                                    "substanceAdministration": {
                                        "templateId": {
                                            "_root": "2.16.840.1.113883.10.20.22.4.16"
                                        },
                                        "id": {
                                            "_root": "51737098-eecb-42b0-821a-2717d23861b0"
                                        },
                                        "text": {
                                            "reference": {
                                                "_value": "#medication920000875891"
                                            }
                                        },
                                        "statusCode": {
                                            "_code": "completed"
                                        },
                                        "effectiveTime": [
                                            {
                                                "low": {
                                                    "_value": "20150625"
                                                },
                                                "high": {
                                                    "_nullFlavor": "NI"
                                                },
                                                "_xsi:type": "IVL_TS"
                                            },
                                            {
                                                "period": {
                                                    "_unit": "d",
                                                    "_value": "1"
                                                },
                                                "_xsi:type": "PIVL_TS",
                                                "_operator": "A"
                                            }
                                        ],
                                        "routeCode": {
                                            "_displayName": "PO"
                                        },
                                        "doseQuantity": {
                                            "_unit": "Tablet(s)",
                                            "_value": "1"
                                        },
                                        "consumable": {
                                            "manufacturedProduct": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.23"
                                                },
                                                "manufacturedMaterial": {
                                                    "code": {
                                                        "originalText": {
                                                            "reference": {
                                                                "_value": "#medication920000875891"
                                                            }
                                                        },
                                                        "translation": [
                                                            {
                                                                "_code": "50458051380",
                                                                "_codeSystem": "2.16.840.1.113883.6.69",
                                                                "_codeSystemName": "NDC",
                                                                "_displayName": "TYLENOL WITH CODEINE #3"
                                                            },
                                                            {
                                                                "_code": "022591",
                                                                "_codeSystem": "2.16.840.1.113883.6.253",
                                                                "_codeSystemName": "MDDID",
                                                                "_displayName": "TYLENOL WITH CODEINE #3"
                                                            }
                                                        ],
                                                        "_nullFlavor": "OTH"
                                                    }
                                                },
                                                "_classCode": "MANU"
                                            }
                                        },
                                        "entryRelationship": {
                                            "observation": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.1.47"
                                                },
                                                "code": {
                                                    "_code": "33999-4",
                                                    "_codeSystem": "2.16.840.1.113883.6.1",
                                                    "_codeSystemName": "LOINC",
                                                    "_displayName": "Status"
                                                },
                                                "value": {
                                                    "_xsi:type": "CE",
                                                    "_code": "55561003",
                                                    "_codeSystem": "2.16.840.1.113883.6.96",
                                                    "_displayName": "Active"
                                                },
                                                "_classCode": "OBS",
                                                "_moodCode": "EVN"
                                            },
                                            "_typeCode": "REFR"
                                        },
                                        "precondition": {
                                            "criterion": {
                                                "templateId": {
                                                    "_root": "2.16.840.1.113883.10.20.22.4.25"
                                                },
                                                "code": {
                                                    "_code": "ASSERTION",
                                                    "_codeSystem": "2.16.840.1.113883.5.4"
                                                },
                                                "value": {
                                                    "_xsi:type": "CE"
                                                }
                                            },
                                            "_typeCode": "PRCN"
                                        },
                                        "_classCode": "SBADM",
                                        "_moodCode": "INT"
                                    },
                                    "_typeCode": "DRIV"
                                }
                            ]
                        }
                    },
                    {
                        "section": {
                            "templateId": [
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.38.1"
                                },
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.38"
                                }
                            ],
                            "code": {
                                "_code": "10160-0",
                                "_codeSystem": "2.16.840.1.113883.6.1",
                                "_codeSystemName": "LOINC",
                                "_displayName": "History of medication use"
                            },
                            "title": "Medications Administered",
                            "text": {
                                "table": {
                                    "thead": {
                                        "tr": {
                                            "th": [
                                                "Medication",
                                                "Start Date",
                                                "End Date",
                                                "Status"
                                            ]
                                        }
                                    },
                                    "tbody": {
                                        "tr": {
                                            "td": [
                                                {
                                                    "_ID": "medicationadmin1",
                                                    "__text": "No Known Medication Administrations"
                                                },
                                                {
                                                    "_ID": "medicationadmin_desc1"
                                                },
                                                "",
                                                ""
                                            ]
                                        }
                                    },
                                    "_width": "100%",
                                    "_border": "1"
                                }
                            },
                            "entry": {
                                "substanceAdministration": {
                                    "text": {
                                        "reference": {
                                            "_value": "#Medication_1"
                                        }
                                    },
                                    "consumable": {
                                        "manufacturedProduct": {
                                            "manufacturedLabeledDrug": {
                                                "code": {
                                                    "_code": "410942007",
                                                    "_codeSystem": "2.16.840.1.113883.6.96",
                                                    "_codeSystemName": "SNOMED CT",
                                                    "_displayName": "Drug or Medicament"
                                                }
                                            }
                                        }
                                    },
                                    "_classCode": "SBADM",
                                    "_moodCode": "EVN",
                                    "_negationInd": "true"
                                },
                                "_typeCode": "DRIV"
                            }
                        }
                    },
                    {
                        "section": {
                            "templateId": [
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.2.1"
                                },
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.2"
                                }
                            ],
                            "code": {
                                "_code": "11369-6",
                                "_codeSystem": "2.16.840.1.113883.6.1",
                                "_codeSystemName": "LOINC",
                                "_displayName": "History of immunizations"
                            },
                            "title": "IMMUNIZATIONS",
                            "text": {
                                "table": {
                                    "thead": {
                                        "tr": {
                                            "th": [
                                                "Date",
                                                "Vaccination",
                                                "Appointment",
                                                "Status/Event",
                                                "Comments"
                                            ]
                                        }
                                    },
                                    "tbody": {
                                        "tr": {
                                            "td": [
                                                {
                                                    "_ID": "immunization1",
                                                    "__text": "No Known Immunizations"
                                                },
                                                {
                                                    "_ID": "immunizationsig1"
                                                },
                                                "",
                                                "",
                                                {
                                                    "content": {
                                                        "_ID": "vacComment1"
                                                    }
                                                }
                                            ]
                                        }
                                    },
                                    "_width": "100%",
                                    "_border": "1"
                                }
                            },
                            "entry": {
                                "substanceAdministration": {
                                    "templateId": {
                                        "_root": "2.16.840.1.113883.10.20.22.4.52"
                                    },
                                    "id": {
                                        "_nullFlavor": "NA"
                                    },
                                    "statusCode": {
                                        "_code": "completed"
                                    },
                                    "effectiveTime": "",
                                    "consumable": {
                                        "manufacturedProduct": {
                                            "templateId": {
                                                "_root": "2.16.840.1.113883.10.20.22.4.54"
                                            },
                                            "manufacturedMaterial": {
                                                "code": {
                                                    "originalText": {
                                                        "reference": {
                                                            "_value": "#immunization1"
                                                        }
                                                    },
                                                    "_codeSystem": "2.16.840.1.113883.12.292",
                                                    "_codeSystemName": "CVX"
                                                }
                                            },
                                            "_classCode": "MANU"
                                        }
                                    },
                                    "_classCode": "SBADM",
                                    "_moodCode": "EVN",
                                    "_negationInd": "false"
                                },
                                "_typeCode": "DRIV"
                            }
                        }
                    },
                    {
                        "section": {
                            "templateId": [
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.6.1"
                                },
                                {
                                    "_root": "2.16.840.1.113883.10.20.22.2.6"
                                }
                            ],
                            "code": {
                                "_code": "48765-2",
                                "_codeSystem": "2.16.840.1.113883.6.1",
                                "_codeSystemName": "LOINC",
                                "_displayName": "Allergies, adverse reactions, alerts"
                            },
                            "title": "Allergies/Adverse Reactions",
                            "text": {
                                "table": {
                                    "thead": {
                                        "tr": {
                                            "th": [
                                                "Substance",
                                                "Reaction",
                                                "Effective Date",
                                                "Resolved Date",
                                                "Severity",
                                                "Status",
                                                "Notes"
                                            ]
                                        }
                                    },
                                    "tbody": {
                                        "tr": {
                                            "td": [
                                                {
                                                    "_ID": "allergy1",
                                                    "__text": "No Known Allergies"
                                                },
                                                {
                                                    "_ID": "reaction1"
                                                },
                                                "",
                                                "",
                                                "",
                                                "",
                                                {
                                                    "_ID": "allergynote1"
                                                }
                                            ]
                                        }
                                    },
                                    "_width": "100%",
                                    "_border": "1"
                                }
                            },
                            "entry": {
                                "act": {
                                    "entryRelationship": {
                                        "observation": {
                                            "code": {
                                                "_code": "106190000",
                                                "_codeSystem": "2.16.840.1.113883.6.1",
                                                "_displayName": "Allergy"
                                            },
                                            "effectiveTime": {
                                                "low": {
                                                    "_nullFlavor": "NI"
                                                },
                                                "high": {
                                                    "_nullFlavor": "NI"
                                                }
                                            },
                                            "value": {
                                                "_xsi:type": "CD"
                                            },
                                            "participant": {
                                                "participantRole": {
                                                    "playingEntity": {
                                                        "code": {
                                                            "_code": "413477004",
                                                            "_codeSystem": "2.16.840.1.113883.6.96",
                                                            "_codeSystemName": "SNOMED CT",
                                                            "_displayName": "Allergen or Pseudoallergen"
                                                        },
                                                        "_classCode": "MMAT"
                                                    },
                                                    "_classCode": "MANU"
                                                },
                                                "_typeCode": "CSM"
                                            },
                                            "entryRelationship": {
                                                "observation": {
                                                    "templateId": {
                                                        "_root": "2.16.840.1.113883.10.20.22.4.9"
                                                    },
                                                    "id": {
                                                        "_root": "2c92a296-461f-51ac-0146-2047dd110048"
                                                    },
                                                    "code": {
                                                        "_nullFlavor": "NA"
                                                    },
                                                    "text": {
                                                        "reference": {
                                                            "_value": "#reaction1"
                                                        }
                                                    },
                                                    "statusCode": {
                                                        "_code": "completed"
                                                    },
                                                    "effectiveTime": {
                                                        "low": {
                                                            "_nullFlavor": "NI"
                                                        },
                                                        "high": {
                                                            "_nullFlavor": "NI"
                                                        }
                                                    },
                                                    "value": {
                                                        "translation": {
                                                            "_nullFlavor": "NI"
                                                        },
                                                        "_xsi:type": "CD"
                                                    },
                                                    "_classCode": "OBS",
                                                    "_moodCode": "EVN"
                                                },
                                                "_inversionInd": "true",
                                                "_typeCode": "MFST"
                                            },
                                            "_classCode": "OBS",
                                            "_moodCode": "EVN",
                                            "_negationInd": "true"
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        "section": {
                            "templateId": {
                                "_root": "2.16.840.1.113883.10.20.22.2.4.1"
                            },
                            "code": {
                                "_code": "8716-3",
                                "_codeSystem": "2.16.840.1.113883.6.1",
                                "_codeSystemName": "LOINC",
                                "_displayName": "Vital Signs"
                            },
                            "title": "VITAL SIGNS",
                            "text": "No Information",
                            "_nullFlavor": "NI"
                        }
                    },
                    {
                        "section": {
                            "templateId": {
                                "_root": "2.16.840.1.113883.10.20.22.2.17"
                            },
                            "code": {
                                "_code": "29762-2",
                                "_codeSystem": "2.16.840.1.113883.6.1",
                                "_displayName": "Social History"
                            },
                            "title": "Social History",
                            "text": {
                                "table": {
                                    "thead": {
                                        "tr": {
                                            "th": [
                                                "Social History Element",
                                                "Description",
                                                "Effective Date"
                                            ]
                                        }
                                    },
                                    "tbody": {
                                        "tr": {
                                            "td": [
                                                {
                                                    "content": "Smoking"
                                                },
                                                "Never as of 06/18/2015",
                                                "20150618000000"
                                            ]
                                        }
                                    },
                                    "_width": "100%",
                                    "_border": "1"
                                }
                            },
                            "entry": {
                                "observation": {
                                    "templateId": {
                                        "_root": "2.16.840.1.113883.10.20.22.4.78"
                                    },
                                    "id": {
                                        "_root": "9b56c25d-9104-45ee-9fa4-e0f3afaa01c1"
                                    },
                                    "code": {
                                        "originalText": {
                                            "reference": {
                                                "_value": "#soc1"
                                            }
                                        },
                                        "_code": "ASSERTION",
                                        "_codeSystem": "2.16.840.1.113883.5.4",
                                        "_codeSystemName": "ActCode",
                                        "_displayName": "Assertion"
                                    },
                                    "statusCode": {
                                        "_code": "completed"
                                    },
                                    "effectiveTime": {
                                        "low": "",
                                        "high": {
                                            "_value": "20150618000000"
                                        }
                                    },
                                    "value": {
                                        "_xsi:type": "CD",
                                        "_code": "266919005",
                                        "_codeSystem": "2.16.840.1.113883.6.96",
                                        "_displayName": "Never smoker"
                                    },
                                    "_classCode": "OBS",
                                    "_moodCode": "EVN"
                                },
                                "_typeCode": "DRIV"
                            }
                        }
                    },
                    {
                        "section": {
                            "templateId": {
                                "_root": "2.16.840.1.113883.10.20.22.2.13"
                            },
                            "code": {
                                "_code": "46239-0",
                                "_codeSystem": "2.16.840.1.113883.6.1",
                                "_codeSystemName": "LOINC",
                                "_displayName": "REASON FOR VISIT + CHIEF COMPLAINT"
                            },
                            "title": "Reason for Visit/Chief Complaint",
                            "text": "Pain and Blistering on legs"
                        }
                    }
                ]
            }
        },
        "_xmlns": "urn:hl7-org:v3",
        "_xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance"
    }
};
}
