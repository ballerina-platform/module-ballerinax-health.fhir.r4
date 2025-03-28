Ballerina package containing CDS data models
compliant with https://cds-hooks.hl7.org/2.0/ implementation guide.

# CDS package

## Package Overview

|                      |                        |
|----------------------|------------------------|
| CDS                  | 2.0                    |
| Implementation Guide | http://hl7.org/fhir/   |

## Capabilities and features

### CDS resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). CdsService | [[Definition]][s1] |
| 2). CdsRequest | [[Definition]][s2] |
| 3). FhirAuthorization | [[Definition]][s3] |
| 4). OrderSignContext | [[Definition]][s4] |
| 5). OrderSelectContext | [[Definition]][s5] |
| 6). OrderDispatchContext | [[Definition]][s6] |
| 7). AppointmentBookContext | [[Definition]][s7] |
| 8). PatientViewContext | [[Definition]][s8] |
| 9). EncounterStartContext | [[Definition]][s9] |
| 10). EncounterDischargeContext | [[Definition]][s10] |
| 11). CdsResponse | [[Definition]][s11] |
| 12). Card | [[Definition]][s12] |
| 13). Source | [[Definition]][s13] |
| 14). Suggestion | [[Definition]][s14] |
| 15). Action | [[Definition]][s15] |
| 16). Link | [[Definition]][s16] |
| 17). Feedback | [[Definition]][s17] |
| 18). AcceptedSuggestion | [[Definition]][s18] |
| 19). OverrideReason | [[Definition]][s19] |

[s1]: https://cds-hooks.hl7.org/2.0/#response
[s2]: https://cds-hooks.hl7.org/2.0/#http-request_1
[s3]: https://cds-hooks.hl7.org/2.0/#passing-the-access-token-to-the-cds-service
[s4]: https://cds-hooks.hl7.org/hooks/order-sign/STU1/order-sign/
[s5]: https://cds-hooks.hl7.org/hooks/order-select/STU1/order-select/
[s6]: https://cds-hooks.hl7.org/hooks/order-dispatch/STU1/order-dispatch/
[s7]: https://cds-hooks.hl7.org/hooks/appointment-book/STU1/appointment-book/
[s8]: https://cds-hooks.hl7.org/hooks/patient-view/STU1/patient-view/
[s9]: https://cds-hooks.hl7.org/hooks/encounter-start/STU1/encounter-start/
[s10]: https://cds-hooks.hl7.org/hooks/encounter-discharge/STU1/encounter-discharge/
[s11]: https://cds-hooks.hl7.org/2.0/#http-response
[s12]: https://cds-hooks.hl7.org/2.0/#card-attributes
[s13]: https://cds-hooks.hl7.org/2.0/#sources
[s14]: https://cds-hooks.hl7.org/2.0/#suggestion
[s15]: https://cds-hooks.hl7.org/2.0/#action
[s16]: https://cds-hooks.hl7.org/2.0/#link
[s17]: https://cds-hooks.hl7.org/2.0/#feedback
[s18]: https://cds-hooks.hl7.org/2.0/#suggestion-accepted
[s19]: https://cds-hooks.hl7.org/2.0/#overridereason

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
