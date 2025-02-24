import ballerinax/health.fhir.r4.davincipas;

davincipas:PASPractitioner samplePractitionerProfile = {
    "resourceType": "Practitioner",
    "id": "PractitionerRole/SurgicalPractitionerRoleExample",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-practitioner"
        ]
    },
    "text": {
        "status": "generated",
        "div": ""
    },
    "identifier": [
        {
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "SB"
                    }
                ]
            },
            "system": "https://www.upmchealthplan.com/fhir/memberidentifier",
            "value": "88800933501"
        },
        {
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "FI"
                    }
                ]
            },
            "system": "https://www.upmchealthplan.com/fhir/memberidentifier",
            "value": "valueREF02"
        }
    ],
    "name": [
        {
            "family": "practitioner103",
            "given": [
                "practitioner104",
                "practitioner105"
            ],
            "prefix": [
                "practitioner106"
            ],
            "suffix": [
                "practitioner107"
            ]
        }
    ],
    "telecom": [
        {
        "system": "phone", // C? phone | fax | email | pager | url | sms | other
        "value": "077782345 ext. 878" // The actual contact point details
    },
    {
        "system": "email",
        "value": "071222333 ext. 928"
    },
    {
        "system": "url",
        "value": "0332225280 ext. 1028"
    },
    {
        "system": "email",
        "value": "0330025280 ext. 1128"
    }
    ],
    "address": [
        {
            "line": [
                "line11",
                "lineN301",
                "lineN302"
            ],
            "city": "cityN401",
            "state": "stateN402",
            "postalCode": "postalN403",
            "country": "countryN404",
            "district": "districtN407"
        }
    ]
};
