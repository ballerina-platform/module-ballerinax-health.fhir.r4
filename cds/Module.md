# CDS Base Module

## Sample Usage

This section focuses on samples depicting how to use this package to implement CDS related integrations

### Prerequisites

1. Install [Ballerina](https://ballerina.io/downloads/) 2201.8.2 or later

### 1. Validate the context data of CDS request

Sample below is using the CDS request resource in `health.fhir.r4.cds` package.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.cds;

public function main() returns error? {
    json cdsRequestPayload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hapi.fhir.org/baseR4",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "593380",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };

    json cdsServiceJson = {
        "description": "An example of a CDS Service that returns a static set of cards",
        "hook": "patient-view",
        "id": "static-patient-greeter",
        "title": "Static CDS Service Example",
        "prefetch": {
            "patientToGreet": "Patient/{{context.patientId}}"
        }
    };

    cds:CdsService cdsService = check cdsServiceJson.cloneWithType();
    cds:CdsRequest cdsRequest = check cdsRequestPayload.cloneWithType();
    cds:CdsError? validationResult = cds:validateContext(cdsRequest, cdsService);
    if validationResult is cds:CdsError {
        log:printError(string `Error message: ${validationResult.message()}`);
        log:printError(string `Error description: ${validationResult.detail().description ?: ""}`);
        log:printError(string `Status code: ${validationResult.detail().code}`);
    } else {
        log:printInfo("Context validation is successful!");
    }
}
```

### 2. Prefetch validation

```ballerina
import ballerina/log;
import ballerinax/health.fhir.cds;

public function main() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hapi.fhir.org/baseR4",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "593380",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };

    json cdsServiceJson = {
        "description": "An example of a CDS Service that returns a static set of cards",
        "hook": "patient-view",
        "id": "static-patient-greeter",
        "title": "Static CDS Service Example",
        "prefetch": {
            "patientToGreet": "Patient/{{context.patientId}}"
        }
    };

    cds:CdsService cdsService = check cdsServiceJson.cloneWithType();
    cds:CdsRequest cdsRequest = check payload.cloneWithType();
    cds:CdsRequest|cds:CdsError result = cds:validateAndProcessPrefetch(cdsRequest, cdsService);

    if (result is cds:CdsError) {
        log:printError(string `Error message: ${result.message()}`);
        log:printError(string `Error description: ${result.detail().description ?: ""}`);
        log:printError(string `Status code: ${result.detail().code}`);
    } else {
        log:printInfo(string `Validated CDS request: ${result.toJsonString()}`);
    }
}
```
