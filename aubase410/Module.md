# FHIR R4 AUBase module

## Sample Usage

This section focuses on samples depicting how to use this package to implement FHIR related integrations

### Prerequisites

1. Install Ballerina 2201.5.0 (Swan Lake Update 5)

### 1. Parse JSON FHIR resource to FHIR resource model
Sample below is using the AUBasePatient resource in `health.fhir.r4.aubase410` package.

```ballerina
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.aubase410;

function parseSamplePatient() returns aubase410:AUBasePatient {
    json patientPayload = {
        "resourceType": "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org.au/fhir/StructureDefinition/au-patient"
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
        anydata parsedResult = check r4:parse(patientPayload, aubase410:AUBasePatient);
        aubase410:AUBasePatient patientModel = check parsedResult.ensureType();
        log:printInfo("string `Patient name : ${patientModel.name.toString()}`);
        return patientModel;
    } on fail error parseError {
    	log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}
```

### 2. Creating FHIR Resource models and serializing to JSON wire formats

```ballerina
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.aubase410;

function createSamplePatient() returns json {
    aubase410:AUBasePatient patient = {
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
    r4:FHIRResourceEntity fhirEntity = new(patient);
    // Serialize FHIR resource record to Json payload
    json|r4:FHIRSerializerError jsonResult = fhirEntity.toJson();
    if jsonResult is json {
        log:printInfo(string `Patient resource JSON payload : ${jsonResult.toString()}`);
        return jsonResult;
    } else {
        log:printError(string `Error occurred while serializing to JSON payload : ${jsonResult.message()}`, jsonResult);
    }
}
```