# FHIR R4 Base module

## Sample Usage

This section focuses on samples depicting how to use this package to implement FHIR related integrations

### Prerequisites

1. Install Ballerina 2201.1.2 (Swan Lake Update 1) or later

### 1. Parse JSON FHIR resource to FHIR resource model
Sample below is using the Patient resource in `health.fhir.r4` package.

```ballerina
import ballerinax/health.fhir.r4;


function parseSamplePatient() returns r4:Patient {
    json patientPayload = {
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
        anydata parsedResult = check parse(patientPayload, r4:Patient);
        r4:Patient patientModel = check parsedResult.ensureType();
        log:printInfo(string `Patient name : ${patientModel.name.toString()}`);
        return patientModel;
    } on fail error parseError {
    	log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}
```

### 2. Creating FHIR Resource models and serializing to JSON wire formats

```ballerina
import ballerinax/health.fhir.r4;


function createSamplePatient() returns json {
    r4:Patient patient = {
        meta: {
            lastUpdated: time:utcToString(time:utcNow()),
            profile: [r4:PROFILE_BASE_PATIENT]
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
        }]
    };
    FHIRResourceEntity fhirEntity = new(patient);
    // Serialize FHIR resource record to Json payload
    json|FHIRSerializerError jsonResult = fhirEntity.toJson();
    if jsonResult is json {
        log:printInfo(string `Patient resource JSON payload : ${jsonResult.toString()}`);
        return jsonResult;
    } else {
        log:printError(string `Error occurred while serializing to JSON payload : ${jsonResult.message()}`, jsonResult);
    }
}
```