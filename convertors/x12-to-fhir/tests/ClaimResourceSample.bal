import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.davincipas;

function getMeta() returns r4:Meta {
    r4:Meta meta = {
        profile: [
            "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claim"
        ]
    };
    return meta;
};

function getNarrative() returns r4:Narrative {
    r4:Narrative narrative = {
        status: "extensions",
        div: ""
    };
    return narrative;
};

function getExtension1() returns r4:Extension {
    return {
        url: "prognosis",
        valueCodeableConcept: {
            coding: [
                {
                    system: "https://codesystem.x12.org/005010/923",
                    code: "1"
                }
            ]
        }
    };
}

function getCoding() returns r4:Coding {
    r4:Coding coding = {
        system: "http://terminology.hl7.org/CodeSystem/claim-type",
        code: "professional"
    };
    return coding;
};

function getExtension() returns r4:Extension[] {

    r4:Extension[] extension = [
        {
            extension: [
                {
                    url: "prognosis",
                    valueCodeableConcept: {
                        coding: [
                            getCoding()
                        ]
                    }
                },
                getExtension1(),
                {
                    url: "date",
                    valueDate: "2005-05-02"
                }
            ],
            url: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-homeHealthCareInformation"
        },
        {
            url: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-levelOfServiceCode",
            valueCodeableConcept: {
                coding: [
                    {
                        system: "http://terminology.hl7.org/CodeSystem/claim-type",
                        code: "UM6-codee"
                    }
                ]
            }
        }

    ];

    return extension;

};

function getProfileIdentifier() returns davincipas:ProfileIdentifier {
    davincipas:ProfileIdentifier profileIdentifier = {
        system: "http://example.org/PATIENT_EVENT_TRACE_NUMBER",
        value: "111099",
        assigner: {
            identifier: {
                system: "http://example.org/USER_ASSIGNED",
                value: "9012345678"
            }
        },
        extension: [
            {
                url: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-identifierSubDepartment",
                valueString: "TRN04-Value"
            }
        ]
    };
    return profileIdentifier;
};

function getType() returns r4:CodeableConcept {
    r4:CodeableConcept typee = {
        coding: [
            {
                system: "http://terminology.hl7.org/CodeSystem/claim-type",
                code: "professional"
            }
        ]
    };
    return typee;
};

function getPatient() returns r4:Reference {
    r4:Reference patient = {
        reference: "Patient/SubscriberExample"
    };
    return patient;
};

function getInsurer() returns r4:Reference {
    r4:Reference insurer = {
        reference: "Organization/InsurerExample"
    };
    return insurer;
};

function getProvider() returns r4:Reference {
    r4:Reference provider = {
        reference: "Organization/UMOExample"
    };
    return provider;
};

function getPriority() returns r4:CodeableConcept {
    r4:CodeableConcept priority = {
        coding: [
            {
                system: "http://terminology.hl7.org/CodeSystem/processpriority",
                code: "normal"
            }
        ]
    };
    return priority;
};

function getInsurance() returns davincipas:PASClaimInsurance[] {
    davincipas:PASClaimInsurance[] insurance = [
        {
            sequence: 1,
            focal: true,
            coverage: {
                reference: "Coverage/InsuranceExample"
            }
        }
    ];
    return insurance;
};

function getItem() returns davincipas:PASClaimItem[] {
    davincipas:PASClaimItem[] item = [
        {
            extension: [
                {
                    url: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-serviceItemRequestType",
                    valueCodeableConcept: {
                        coding: [
                            {
                                system: "https://codesystem.x12.org/005010/1525",
                                code: "um01-codee",
                                display: "Health Services Review"
                            }
                        ]
                    }
                },
                {
                    url: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-certificationType",
                    valueCodeableConcept: {
                        coding: [
                            {
                                system: "https://codesystem.x12.org/005010/1322",
                                code: "um02-codee",
                                display: "Initial"
                            }
                        ]
                    }
                }
            ],
            sequence: 1,
            category: {
                coding: [
                    {
                        system: "https://codesystem.x12.org/005010/1365",
                        code: "um03-codee",
                        display: "Home Health Care"
                    }
                ]
            },
            productOrService: {
                coding: [
                    {
                        system: "http://www.cms.gov/Medicare/Coding/HCPCSReleaseCodeSets",
                        code: "G0154"
                    }
                ]
            },
            locationCodeableConcept: {
                coding: [
                    {
                        system: "https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set",
                        code: "home"
                    }
                ]
            }
        },
        {
            extension: [
                {
                    url: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-serviceItemRequestType",
                    valueCodeableConcept: {
                        coding: [
                            {
                                system: "https://codesystem.x12.org/005010/1525",
                                code: "HS",
                                display: "Health Services Review"
                            }
                        ]
                    }
                },
                {
                    url: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-certificationType",
                    valueCodeableConcept: {
                        coding: [
                            {
                                system: "https://codesystem.x12.org/005010/1322",
                                code: "I",
                                display: "Initial"
                            }
                        ]
                    }
                }
            ],
            sequence: 2,
            category: {
                coding: [
                    {
                        system: "https://codesystem.x12.org/005010/1365",
                        code: "42",
                        display: "Home Health Care"
                    }
                ]
            },
            productOrService: {
                coding: [
                    {
                        system: "http://www.cms.gov/Medicare/Coding/HCPCSReleaseCodeSets",
                        code: "B4184"
                    }
                ]
            }
        }
    ];
    return item;
};

function getCreated() returns r4:dateTime {
    r4:dateTime created = "2019-07-20T11:01:00+05:00";
    return created;
}

function getUse() returns davincipas:PASClaimUse {
    davincipas:PASClaimUse use = "preauthorization";
    return use;
};

function getAccident() returns davincipas:PASClaimAccident {
    return {
        date: "2019-07-20T11:01:00+05:00",
        'type: {
            coding: [
                {
                    system: "http://terminology.hl7.org/CodeSystem/v3-ActCode",
                    code: "UM05-01_codee"
                }
            ]
        },
        locationAddress: {
            city: "USA",
            state: "UM05-04_statee",
            country: "UM05-05_countryy"
        }
    };
}

function getDiagnosis() returns davincipas:PASClaimDiagnosis[] {
    return [
        {
            sequence: 1,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "admitting"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/sid/icd-10-cm",
                        code: "I10"
                    }
                ]
            }
        },
        {
            sequence: 2,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "principal"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/sid/icd-10-cm",
                        code: "200"
                    }
                ]
            }
        },
        {
            sequence: 3,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "patientreasonforvisit"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/sid/icd-10-cm",
                        code: "300"
                    }
                ]
            }
        },
        {
            sequence: 4,
            // 'type: {
            //     coding: [
            //         {
            //             system: "",
            //             code: "admitting"
            //         }
            //     ]
            // },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/sid/icd-10-cm",
                        code: "400"
                    }
                ]
            }
        },
        {
            sequence: 5,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "admitting"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://terminology.hl7.org/CodeSystem/icd9cm",
                        code: "500"
                    }
                ]
            }
        },
        {
            sequence: 6,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "principal"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://terminology.hl7.org/CodeSystem/icd9cm",
                        code: "600"
                    }
                ]
            }
        },
        {
            sequence: 7,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "patientreasonforvisit"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://terminology.hl7.org/CodeSystem/icd9cm",
                        code: "700"
                    }
                ]
            }
        },
        {
            sequence: 8,
            // 'type: {
            //     coding: [
            //         {
            //             system: "",
            //             code: "admitting"
            //         }
            //     ]
            // },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://terminology.hl7.org/CodeSystem/icd9cm",
                        code: "800"
                    }
                ]
            }
        },
        {
            sequence: 9,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "admitting"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://uri.hddaccess.com/cs/apdrg",
                        code: "I10"
                    }
                ]
            }
        },
        {
            sequence: 10,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "admitting"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://uri.hddaccess.com/cs/aprdrg",
                        code: "I10"
                    }
                ]
            }
        },
        {
            sequence: 11,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "admitting"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://uri.hddaccess.com/cs/aprdrg",
                        code: "I10"
                    }
                ]
            }
        },
        {
            sequence: 12,
            'type: {
                coding: [
                    {
                        system: "",
                        code: "admitting"
                    }
                ]
            },
            diagnosisCodeableConcept: {
                coding: [
                    {
                        system: "http://uri.hddaccess.com/cs/aprdrg",
                        code: "I10"
                    }
                ]
            }
        }
    ];
}

function getSupportingInfo() returns davincipas:PASClaimSupportingInfo[] {
    return [
        {
            sequence: 1,
            category: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType",
                        code: "admissionDates"
                    }
                ]
            },
            timingPeriod: {
                "start": "2020-07-02",
                "end": "2020-07-09"
            }
        },
        {
            sequence: 2,
            category: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType",
                        code: "patientEvent"
                    }
                ]
            },
            timingDate: "2024-07-09"
        },
        {
            sequence: 3,
            category: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType",
                        code: "dischargeDates"
                    }
                ]
            },
            timingDate: "2030-07-10"
        },
        {
            sequence: 4,
            category: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType",
                        code: "institutionalEncounter"
                    }
                ]
            },
            valueReference: {
                reference: "Encounter/SurgicalEncounterExample"
            }
        },
        {
            sequence: 5,
            category: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType",
                        code: "freeFormMessage"
                    }
                ]
            },
            valueString: "MSG01"
        }
    ];
};

public function getCareTeam() returns davincipas:PASClaimCareTeam[] {
    return [
        {
            extension: [
                {
                    url: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-careTeamClaimScope",
                    valueBoolean: true
                }
            ],
            sequence: 1,
            provider: {
                reference: "PractitionerRole/SurgicalPractitionerRoleExample"
            },
            role: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType",
                        code: "practioner101"
                    }
                ]
            },
            qualification: {
                coding: [
                    {
                        system: "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType",
                        code: "practioner_PRV03"
                    }
                ]
            }
        }
    ];
}

davincipas:PASClaim claim = {
    resourceType: "Claim",
    id: "HomecareAuthorizationExample",
    meta: getMeta(),
    text: getNarrative(),
    extension: getExtension(),
    identifier: getProfileIdentifier(),
    status: "active",
    'type: getType(),
    use: getUse(),
    patient: getPatient(),
    created: getCreated(),
    insurer: getInsurer(),
    provider: getProvider(),
    priority: getPriority(),
    insurance: getInsurance(),
    item: getItem(),
    accident: getAccident(),
    supportingInfo: getSupportingInfo(),
    diagnosis: getDiagnosis(),
    careTeam: getCareTeam()
};
