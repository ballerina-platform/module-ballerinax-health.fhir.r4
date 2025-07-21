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
                {
                    "no": "11A",
                    "street": "ABC Road"
                },
                {
                    "no": "xxx",
                    "street": "ABC Road"
                }
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "country": "Australia",
            "new": {
                "a": "A",
                "b": "B"
            }
        },
        {
            "use": "work",
            "line": [
                {
                    "no": "3423",
                    "street": "dvsg Road"
                }
            ],
            "city": "Melbourne",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3000",
            "country": "Australia",
            "new": {
                "a": "A",
                "b": "B"
            }
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

