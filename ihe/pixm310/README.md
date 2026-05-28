## Overview

IHE Patient Identifier Cross-referencing for Mobile (PIXm) FHIR R4 data model package. It provides Ballerina records aligned with PIXm profiles so applications can build and validate payloads that follow IHE ITI PIXm implementation guidance.

> **Trademark Notice:** FHIR® and the FHIR® logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7®.

### Key Features

- Strongly typed Ballerina records for IHE PIXm profile resources
- Ready-to-use models for patient identifier cross-referencing workflows
- Designed to work with the `r4`, parser, and validator packages
- JSON-first profile models for IHE PIXm FHIR integrations

Ballerina package containing FHIR resource data models
compliant with https://profiles.ihe.net/ITI/PIXm/ implementation guide.

# FHIR R4 health.fhir.r4.ihe.pixm310 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://profiles.ihe.net/ITI/PIXm/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). AuditPixmFeedManagerCreate | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). AuditPixmFeedManagerDelete | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). AuditPixmFeedManagerUpdate | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). AuditPixmFeedSourceDelete | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). AuditPixmFeedSourceUpdate | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). AuditPixmQueryConsumer | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). AuditPixmQueryManager | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). PIXmPatient | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). PIXmPatientBirthDateRequired | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). PIXmQueryParametersIn | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). PIXmQueryParametersOut | [[Definition]][s11] [[Ballerina Record]][m11] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedManagerCreate
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedManagerDelete
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedManagerUpdate
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedSourceDelete
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedSourceUpdate
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmQueryConsumer
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmQueryManager
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#PIXmPatient
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#PIXmPatientBirthDateRequired
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#PIXmQueryParametersIn
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#PIXmQueryParametersOut

[s1]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Create.Audit.Manager
[s2]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Delete.Audit.Manager
[s3]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Update.Audit.Manager
[s4]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Delete.Audit.Source
[s5]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Update.Audit.Source
[s6]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Query.Audit.Consumer
[s7]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Query.Audit.Manager
[s8]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Patient
[s9]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Patient.BirthDateRequired
[s10]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Query.Parameters.In
[s11]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Query.Parameters.Out

## Sample Usage

This section focuses on samples depicting how to use this package to implement FHIR-related integrations

### Prerequisites

1. Install Ballerina 2201.6.0 or later

### 1. Parse JSON FHIR resource to FHIR resource model
Sample below is using the PixmPatient resource in `health.fhir.r4.ihe.pixm310` package.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.r4.ihe.pixm310;
import ballerinax/health.fhir.r4.parser;

public function main() {
    json patientPayload = {
        "resourceType": "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Patient"
            ]
        },
        "active": true,
        "name": [
            {
                "use": "official",
                "family": "Chalmers",
                "given": [
                    "Peter",
                    "James"
                ]
            }
        ],
        "gender": "male",
        "birthDate": "1974-12-25",
        "managingOrganization": {
            "reference": "Organization/1"
        }
    };

    do {
        anydata parsedResult = check parser:parse(patientPayload, pixm310:PIXmPatient);
        pixm310:PIXmPatient patientModel = check parsedResult.ensureType();
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
import ballerinax/health.fhir.r4.ihe.pixm310;

public function main() {
    pixm310:PIXmPatient patient = {
        meta: {
            lastUpdated: time:utcToString(time:utcNow()),
            profile: [pixm310:PROFILE_BASE_PIXMPATIENT]
        },
        active: true,
        name: [{
            family: "Doe",
            given: ["John"],
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
        log:printInfo(string `Patient resource JSON payload : ${jsonResult.toJsonString()}`);
    } else {
        log:printError(string `Error occurred while serializing to JSON payload : ${jsonResult.message()}`, jsonResult);
    }
}
```
