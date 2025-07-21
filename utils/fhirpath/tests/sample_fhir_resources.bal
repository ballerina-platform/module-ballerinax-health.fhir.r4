json samplePatient1 = {
    "resourceType": "Patient",
    "id": "1",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        },
        {
            "use": "usual",
            "given": [
                "Jim"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    },
    "address": [
        {
            "use": "home",
            "line": [
                "534 Erewhon St",
                "sqw"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "country": "Australia"
        },
        {
            "use": "work",
            "line": [
                "33[0] 6th St"
            ],
            "city": "Melbourne",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3000",
            "country": "Australia"
        }
    ]
};

json samplePatient2 = {
    "resourceType": "Patient",
    "id": "2",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "John",
                "Doe"
            ]
        },
        {
            "use": "usual",
            "given": [
                "John"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1970-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    }
};

json samplePatient3 = {
    "resourceType": "Patient",
    "id": "3",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        },
        {
            "use": "usual",
            "given": [
                "Jim"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    },
    "address": [
        {
            "use": "home",
            "line": [
                "11 Main St",
                "ABC Road"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "country": "Australia"
        },
        {
            "use": "work",
            "line": [
                "75346 6th St"
            ],
            "city": "Melbourne",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3000",
            "country": "Australia"
        }
    ]
};

json sampleOrganization1 = {
    "resourceType": "Organization",
    address: [
        {
            "use": "work",
            "line": [
                "33[0] 6th St"
            ],
            "city": "Melbourne",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3000",
            "country": "Australia"
        }
    ],
    active: false,
    language: "eng",
    contact: [
        {
            "address": {
                "use": "work",
                "line": [
                    "33[0] 6th St"
                ],
                "city": "Melbourne",
                "district": "Rainbow",
                "state": "Vic",
                "postalCode": "3000",
                "country": "Australia"
            }
        }
    ],
    id: "test_ID",
    name: "test_name"
};

json invalidFhirResource = {
    "resourceType": "Patient",
    "id": "591841",
    "meta": {
        "versionId": "1",
        "lastUpdated": "2020-01-22T05:30:13.137+00:00",
        "source": "#KO38Q3spgrJoP5fa"
    },
    "identifier": [
        {
            "type": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/v2/0203",
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
    "birthDate": "jdlksjldjl"
};
