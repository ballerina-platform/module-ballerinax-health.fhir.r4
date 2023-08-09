# FHIR R4 Parser Module

### Sample Usage

**01. Parse to FHIR base resource model**

In this approach user just need to provide only the FHIR resource payload. Based on the resource type, parser will parse
it to it's base profile model.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.r4.parser;
import ballerinax/health.fhir.r4.international401;

public function main() {
    json payload = {
        "resourceType": "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/Patient"
            ]
        },
        "active":true,
        "name":[
            {
                "use":"official",
                "family":"Chalmers",
                "given":[
                    "Peter",
                    "James"
                ]
            }
        ],
        "gender":"male",
        "birthDate":"1974-12-25",
        "managingOrganization":{
            "reference":"Organization/1"
        }
    };
    do {
        international401:Patient patientModel = <international401:Patient> check parser:parse(payload);
        log:printInfo(string `Patient name : ${patientModel.name.toString()}`);
    } on fail error parseError {
    	log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}
```

*Note:* `parse` function returns `anydata` type when success, and it needs to be cast to the relevant FHIR Resource type.

**02. Parse to given FHIR profile resource model**

In this approach the parser will attempt to parse the given FHIR resource payload to given resource type profile.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.r4.parser;
import ballerinax/health.fhir.r4.uscore501;

public function main() {
    json patientPayload = {
        "resourceType": "Patient",
        "id": "example-patient",
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">John Doe</div>"
        },
        "identifier": [
            {
                "system": "http://example.com/patient-ids",
                "value": "12345"
            }
        ],
        "extension": [
            {
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
                "valueCodeableConcept": {
                    "coding": [
                        {
                            "system": "http://hl7.org/fhir/v3/Race",
                            "code": "2106-3",
                            "display": "White"
                        }
                    ]
                }
            }
        ],
        "name": [
            {
                "use": "official",
                "family": "Doe",
                "given": [
                    "John"
                ]
            }
        ],
        "gender": "male",
        "birthDate": "2000-01-01"
    };

    do {
        uscore501:USCorePatientProfile patientModel = <uscore501:USCorePatientProfile> check parser:parse(patientPayload, uscore501:USCorePatientProfile);
        log:printInfo(string `Patient name : ${patientModel.name[0].toString()}`);
    } on fail error parseError {
    	log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}
```

*Note:* `parse` function returns `anydata` type when success, and it needs to be cast to the relevant FHIR Resource type.
