# FHIR LKCore Module

## Sample Usage

This section focuses on samples depicting how to use this package to implement FHIR related integrations

### Prerequisites

1. Install Ballerina 2201.8.1 or later

### 1. Parse JSON FHIR resource to FHIR resource model
Sample below is using the Patient resource in `health.fhir.r4.lkcore010` package.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.r4.lkcore010;
import ballerinax/health.fhir.r4.parser;

public function main() {
    json payload = {
        "resourceType": "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/Patient"
            ]
        },
        "identifier": [],
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
        anydata parsedResult = check parser:parse(payload, lkcore010:LKCorePatient);
        lkcore010:LKCorePatient patientModel = check parsedResult.ensureType();
        log:printInfo(string `Patient name : ${patientModel.name.toString()}`);
    } on fail error parseError {
    	log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}
```

### 2. Creating FHIR Resource models and serializing to JSON wire formats

```ballerina
import ballerina/log;
import ballerina/time;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.lkcore010;


public function main() {
    lkcore010:LKCorePatient patient = {
        meta: {
            lastUpdated: time:utcToString(time:utcNow()),
            profile: [lkcore010:PROFILE_BASE_LKCOREPATIENT]
        },
        active: true,
        name: [{
            family: "Doe",
            given: ["Jhon"],
            use: r4:official,
            prefix: ["Mr"]
        }],
        address: [{
            line: ["652 S. Lantern Dr."],
            city: "New York",
            country: "United States",
            postalCode: "10022",
            'type: r4:physical,
            use: r4:home
        }],
        identifier: [], 
        gender: lkcore010:CODE_GENDER_MALE, 
        birthDate: "2000-01-01"};
    r4:FHIRResourceEntity fhirEntity = new(patient);
    // Serialize FHIR resource record to Json payload
    json|r4:FHIRSerializerError jsonResult = fhirEntity.toJson();
    if jsonResult is json {
        log:printInfo(string `Patient resource JSON payload : ${jsonResult.toString()}`);
    } else {
        log:printError(string `Error occurred while serializing to JSON payload : ${jsonResult.message()}`, jsonResult);
    }
}
```
