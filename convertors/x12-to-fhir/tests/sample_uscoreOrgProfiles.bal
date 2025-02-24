import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

uscore501:USCoreOrganizationProfile sampleOrganizationProfile = {
    "resourceType": "Organization",
    "id": "Organization/InsurerExample",
    "text": {
        "status": "generated",
        "div": ""
    },
    "identifier": [
        {
            "system": "http://hl7.org/fhir/sid/us-npi",
            "value": "1144221847",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/identifier-type",
                        "code": "U",
                        "display": "National Provider Identifier (NPI)"
                    }
                ]
            }
        },
        {
            "system": "urn:oid:2.16.840.1.113883.4.7",
            "value": "12D4567890"
        }
    ],
    "active": true,
    "type": [
        {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/organization-type",
                    "code": "provv",
                    "display": "Healthcare Provider"
                }
            ]
        }
    ],
    "name": "Acme Labs",
    "telecom": [
        {
            "system": "phone",
            "value": "(+1) 734-677-7777"
        },
        {
            "system": "email",
            "value": "hq@acme.org"
        }
    ],
    "address": [
        {
            "line": [
                "3300 Washtenaw Avenuee, Suite 227",
                "33ss00 lalalala Avenue, Suite 227"
            ],
            "city": "Amherst",
            "state": "MA",
            "postalCode": "01002",
            "country": "USA",
            "district": "district1"
        }
    ]
};

uscore501:USCoreOrganizationProfile sampleOrganizationProfile2 = {
    "resourceType": "Organization",
    "id": "Organization/UMOExample",
    "text": {
        "status": "generated",
        "div": ""
    },
    "identifier": [
        {
            "system": "http://hl7.org/fhir/sid/us-npi",
            "value": "1144221847",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/identifier-type",
                        "code": "U",
                        "display": "National Provider Identifier (NPI)"
                    }
                ]
            }
        },
        {
            "system": "urn:oid:2.16.840.1.113883.4.7",
            "value": "12D4567890"
        }
    ],
    "active": true,
    "type": [
        {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/organization-type",
                    "code": "codeeee",
                    "display": "Healthcare Provider"
                }
            ]
        }
    ],
    "name": "Lalala Labs",
    "telecom": [
        {
            "system": "phone",
            "value": "(+1) 734-677-7777"
        },
        {
            "system": "email",
            "value": "hq@acme.org"
        }
    ],
    "address": [
        {
            "line": [
                "3300 Washtenaw Avenue, Suite227",
                "rollloooooooo"
            ],
            "city": "Amherst",
            "state": "MA",
            "postalCode": "01002",
            "country": "USA"
        }
    ],
    "contact": contact //Added a USCoreOrganizationProfileContact[] for testing PER
};

r4:HumanName name = {
    prefix: ["Mr"],
    given: ["John", "constantine"],
    text: "NameTextPER02"
};

r4:ContactPoint[] telecom = [
    {
        system: r4:email, // C? phone | fax | email | pager | url | sms | other
        value: "077782345 ext. 878" // The actual contact point details
    },
    {
        system: r4:phone,
        value: "071222333 ext. 928"
    },
    {
        system: r4:phone,
        value: "0332225280 ext. 1028"
    },
    {
        system: r4:email,
        value: "0330025280 ext. 1128"
    }
];

uscore501:USCoreOrganizationProfileContact[] contact = [
    {
        name: name,
        telecom: telecom
    }
];
