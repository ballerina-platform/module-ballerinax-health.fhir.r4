import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

public function getText_patient() returns r4:Narrative {
    return {
        "status": "generated",
        "div": ""
    };
}

public function getNestedExtension_patient() returns r4:Extension[] {
    return [
        {
            "url": "tribalAffiliation",
            "valueCodeableConcept": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v3-TribalEntityUS",
                        "code": "187",
                        "display": "Paiute-Shoshone Tribe of the Fallon Reservation and Colony, Nevada"
                    }
                ],
                "text": "Shoshone"
            }
        },
        {
            "url": "isEnrolled",
            "valueBoolean": false
        }
    ];
};

public function getExtension_patient() returns r4:Extension[] {
    return [
        {
            extension: [
                {
                    "url": "ombCategory",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2135-2",
                        "display": "Hispanic or Latino"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2184-0",
                        "display": "Dominican"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2148-5",
                        "display": "Mexican"
                    }
                },
                {
                    "url": "text",
                    "valueString": "Hispanic or Latino"
                }
            ],
            url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity"
        },
        {
            extension: getNestedExtension_patient(),
            url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-tribal-affiliation"
        },
        {
            url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex",
            valueCode: "F"
        },
        {
            url: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-militaryStatus",
            valueCodeableConcept: {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v3-NullFlavor",
                        "code": "UNK",
                        "display": "Unknown"
                    }
                ],
                "text": "Unknown"
            }
        },
        {
            url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex",
            valueCode: "248152002"
        }
    ];
};

public function getIdentifier_patient() returns uscore501:USCorePatientProfileIdentifier[] {
    return [
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR",
                        "display": "Medical Record Number"
                    }
                ],
                "text": "Medical Record Number"
            },
            "system": "http://hospital.smarthealthit.org",
            "value": "1032702"
        },
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "SS",
                        "display": "SS Number"
                    }
                ],
                "text": "SS Recording Number"
            },
            "system": "http://hospital.smarthealthit.org",
            "value": "10000"
        }

    ];
};

public function getName_patient() returns uscore501:USCorePatientProfileName[] {
    return [
        {
            "use": "old",
            "family": "Shaw",
            "given": [
                "Amy",
                "V."
            ],
            "prefix": [
                "Ms"
            ],
            "suffix": [
                "Dr"
            ],
            "period": {
                "start": "2016-12-06",
                "end": "2020-07-22"
            }
        },
        {
            "family": "Baxter",
            "given": [
                "Amy",
                "V."
            ],
            "suffix": [
                "PharmD"
            ],
            "period": {
                "start": "2020-07-22"
            }
        }
    ];
};

public function getTelecom_patient() returns uscore501:USCorePatientProfileTelecom[] {
    return [
        {
            "system": "phone",
            "value": "555-555-5555",
            "use": "home"
        },
        {
            "system": "email",
            "value": "amy.shaw@example.com"
        }
    ];
}

public function getAddress_patient() returns uscore501:USCorePatientProfileAddress[] {
    return [
        {
            "use": "old",
            "line": [
                "49 MEADOW ST",
                "APT 2"
            ],
            "city": "MOUNDS",
            "state": "OK",
            "postalCode": "74047",
            "country": "LK",
            "period": {
                "start": "2016-12-06",
                "end": "2020-07-22"
            }
        },
        {
            "line": [
                "183 MOUNTAIN VIEW ST"
            ],
            "city": "JAMAICA",
            "state": "OK",
            "postalCode": "74048",
            "country": "US",
            "period": {
                "start": "2020-07-22"
            }
        }
    ];
}

public function getActive_patient() returns boolean {
    return true;
}

uscore501:USCorePatientProfile samplePatientProfile = {
    resourceType: "Patient",
    id: "Patient/Patient1",
    text: getText_patient(),
    extension: getExtension_patient(),
    identifier: getIdentifier_patient(),
    active: getActive_patient(),
    name: getName_patient(),
    telecom: getTelecom_patient(),
    gender: "female",
    birthDate: "1987-02-20",
    address: getAddress_patient()
};
