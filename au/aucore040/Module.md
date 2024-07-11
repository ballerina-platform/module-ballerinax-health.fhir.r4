# FHIR R4 AUCore module - Version 0.4.0

## Sample Usage

This section focuses on samples depicting how to use this package to implement FHIR related integrations

### Prerequisites

1. Install Ballerina 2201.6.0 or later

### 1. Parse JSON FHIR resource to FHIR resource model
Sample below is using the AUBasePatient resource in `health.fhir.r4.aucore040` package.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.r4.aucore040;
import ballerinax/health.fhir.r4.parser;

public function main() {
    json patientPayload = {
   "resourceType":"Patient",
   "gender":"male",
   "identifier":[
      {
         "system":"http://acme.org/patient",
         "value":"123456"
      }
   ],
   "address":[
      {
         "use":"home",
         "type":"physical",
         "line":[
            "652 S. Lantern Dr."
         ],
         "city":"New York",
         "postalCode":"10022",
         "country":"United States"
      }
   ],
   "active":true,
   "birthDate":"1970-01-01",
   "meta":{
      "lastUpdated":"2024-07-11T07:31:24.259090Z",
      "profile":[
         "http://hl7.org.au/fhir/core/StructureDefinition/au-core-patient"
      ]
   },
   "name":[
      {
         "given":[
            "Jhon"
         ],
         "prefix":[
            "Mr"
         ],
         "use":"official",
         "family":"Doe"
      }
   ]
};

    do {
        anydata parsedResult = check parser:parse(patientPayload, aucore040:AUCorePatient);
        aucore040:AUCorePatient patientModel = check parsedResult.ensureType();
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
import ballerinax/health.fhir.r4.aucore040;

public function main() {
    aucore040:AUCorePatient patient = {
        meta: {
            lastUpdated: time:utcToString(time:utcNow()),
            profile: [aucore040:PROFILE_BASE_AUCOREPATIENT]
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
        identifier: [{
            system: "http://acme.org/patient",
            value: "123456"
        }], 
        gender: aucore040:CODE_GENDER_MALE, 
        birthDate: "1970-01-01"
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