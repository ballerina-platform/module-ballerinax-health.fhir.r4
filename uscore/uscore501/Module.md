# FHIR R4 US Core Implementation Guide - 5.0.1 - STU5 Release US

## Sample Usage

This section focuses on samples depicting how to use this package to implement FHIR related integrations

### Prerequisites

1. Install Ballerina 2201.6.0 or later

### 1. Parse JSON FHIR resource to FHIR resource model
Sample below is using the Patient resource in `health.fhir.r4.uscore501` package.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.r4.uscore501;
import ballerinax/health.fhir.r4.parser;

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
        anydata parsedResult = check parser:parse(patientPayload, uscore501:USCorePatientProfile);
        uscore501:USCorePatientProfile patientModel = check parsedResult.ensureType();
        log:printInfo(string `Patient name : ${patientModel.name[0].toString()}`);
    } on fail error parseError {
    	log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}
```

### 2. Creating FHIR Resource models and serializing to JSON wire formats

```ballerina
import ballerina/log;
import ballerina/time;
import ballerinax/health.fhir.r4.uscore501;
import ballerinax/health.fhir.r4;

public function main() {
    uscore501:USCorePatientProfile patient = {
        meta: {
            lastUpdated: time:utcToString(time:utcNow()),
            profile: [uscore501:PROFILE_BASE_USCOREPATIENTPROFILE]
        },
        active: true,
        name: [
            {
                family: "Doe",
                given: ["Jhon"],
                use: uscore501:CODE_USE_OFFICIAL,
                prefix: ["Mr"]
            }
        ],
        address: [
            {
                line: ["652 S. Lantern Dr."],
                city: "New York",
                country: "United States",
                postalCode: "10022",
                'type: uscore501:CODE_TYPE_PHYSICAL,
                use: uscore501:CODE_USE_HOME
            }
        ],
        identifier: [],
        gender: uscore501:CODE_GENDER_MALE
    };
    r4:FHIRResourceEntity fhirEntity = new(patient);
    // Serialize FHIR resource record to Json payload
    json|r4:FHIRSerializerError jsonResult = fhirEntity.toJson();
    if jsonResult is json {
        log:printInfo(string `Patient resource JSON payload : ${jsonResult.toJsonString()}`);
    } else {
        log:printError(string `Error occurred while serializing to JSON payload : ${jsonResult.message()}`, jsonResult);
    }
}
```
