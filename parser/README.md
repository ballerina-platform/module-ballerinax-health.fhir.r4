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

**03. Parse and validation with valid FHIR data**

In this approach, the parser will attempt to parse the given FHIR resource payload and apply validation against the specified resource type profile.

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
        uscore501:USCorePatientProfile patientModel = check parser:parseWithValidation(patientPayload, uscore501:USCorePatientProfile).ensureType();
        log:printInfo(string `Patient name : ${patientModel.name[0].toString()}`);
    } on fail error parseError {
        log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}
```

*Note:* `parseWithValidation` function returns `anydata` type when successful, and it needs to be cast to the relevant FHIR Resource type. It will return a validation error if it fails.

**04. Parse and validation with invalid FHIR data**

In this approach, the parser will attempt to parse the given FHIR resource payload and apply validation against the specified resource type profile.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.parser;
public function main() returns error? {
    json patientPayload = {
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
    do {
        international401:Patient patientModel = check parser:parseWithValidation(patientPayload, international401:Patient).ensureType();
        log:printInfo(string `Patient name : ${patientModel.name.toString()}`);
    } on fail error parseError {
        log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}
```

*Note:* `parseWithValidation` function returns `anydata` type when successful, and it needs to be cast to the relevant FHIR Resource type. It will return a validation error if it fails.

---

## Enabling Terminology Validation

To enable terminology validation in the parser module, add the following configuration to your `config.toml` file:

```toml
[ballerinax.health.fhir.r4.parser.terminologyConfig]
isTerminologyValidationEnabled=true
terminologyServiceApi="http://localhost:9089/fhir/r4"
tokenUrl=""
clientId=""
clientSecret=""
```

- `isTerminologyValidationEnabled`: Set to `true` to enable terminology validation.
- `terminologyServiceApi`: The endpoint of your FHIR R4 terminology service.
- `tokenUrl`, `clientId`, `clientSecret`: (Optional) Use these if your terminology service requires OAuth2 authentication.

Once enabled, the parser will validate terminology bindings using the configured terminology service during resource parsing and validation.
