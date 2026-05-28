## Overview

IHE Patient Demographics Query for Mobile (PDQm) FHIR R4 data model package. It provides Ballerina records aligned with PDQm profiles so applications can build and validate payloads that follow IHE ITI PDQm implementation guidance.

> **Trademark Notice:** FHIR® and the FHIR® logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7®.

### Key Features

- Strongly typed Ballerina records for IHE PDQm profile resources
- Ready-to-use models for patient demographics querying and matching workflows
- Designed to work with the `r4`, parser, and validator packages
- JSON-first profile models for IHE PDQm FHIR integrations

Ballerina package containing FHIR resource data models
compliant with https://profiles.ihe.net/ITI/PDQm/ implementation guide.

# FHIR R4 health.fhir.r4.ihe.pdqm320 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://profiles.ihe.net/ITI/PDQm/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). AuditPdqmQuerySupplier | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). MatchParametersIn | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). PDQmPatient | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). AuditPdqmQueryConsumer | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). AuditPdqmMatchConsumer | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). AuditPdqmMatchSupplier | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). PDQmMatchInput | [[Definition]][s7] [[Ballerina Record]][m7] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pdqm/1.0.0#AuditPdqmQuerySupplier
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pdqm/1.0.0#MatchParametersIn
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pdqm/1.0.0#PDQmPatient
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pdqm/1.0.0#AuditPdqmQueryConsumer
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pdqm/1.0.0#AuditPdqmMatchConsumer
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pdqm/1.0.0#AuditPdqmMatchSupplier
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pdqm/1.0.0#PDQmMatchInput

[s1]: https://profiles.ihe.net/ITI/PDQm/StructureDefinition/IHE.PDQm.Query.Audit.Supplier
[s2]: https://profiles.ihe.net/ITI/PDQm/StructureDefinition/IHE.PDQm.MatchParametersIn
[s3]: https://profiles.ihe.net/ITI/PDQm/StructureDefinition/IHE.PDQm.Patient
[s4]: https://profiles.ihe.net/ITI/PDQm/StructureDefinition/IHE.PDQm.Query.Audit.Consumer
[s5]: https://profiles.ihe.net/ITI/PDQm/StructureDefinition/IHE.PDQm.Match.Audit.Consumer
[s6]: https://profiles.ihe.net/ITI/PDQm/StructureDefinition/IHE.PDQm.Match.Audit.Supplier
[s7]: https://profiles.ihe.net/ITI/PDQm/StructureDefinition/IHE.PDQm.MatchInputPatient

## Sample Usage

This section focuses on samples depicting how to use this package to implement FHIR-related integrations

### Prerequisites

1. Install Ballerina 2201.6.0 or later

### 1. Parse JSON FHIR resource to FHIR resource model
Sample below is using the PDQmPatient resource in `health.fhir.r4.ihe.pdqm320` package.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.r4.ihe.pdqm320;
import ballerinax/health.fhir.r4.parser;

public function main() {
    json patientPayload = {
        "resourceType": "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "https://profiles.ihe.net/ITI/PDQm/StructureDefinition/IHE.PDQm.Patient"
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
        anydata parsedResult = check parser:parse(patientPayload, pdqm320:PDQmPatient);
        pdqm320:PDQmPatient patientModel = check parsedResult.ensureType();
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
import ballerinax/health.fhir.r4.ihe.pdqm320;

public function main() {
    pdqm320:PDQmPatient patient = {
        meta: {
            lastUpdated: time:utcToString(time:utcNow()),
            profile: [pdqm320:PROFILE_BASE_PDQMPATIENT]
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
