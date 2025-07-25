# FHIR Validator Package

A FHIR validator is a package designed to check the adherence of FHIR resources to the FHIR specification. Validator ensures that FHIR resources follow the defined rules, constraints, and guidelines specified in the FHIR standard.

## Package Overview

This package provides the following functionalities required for validating FHIR resource payloads against corresponding FHIR resource models.

1. Resource Parsing: The FHIR validator parses the serialized FHIR resources, which are usually in JSON format. 
2. Schema/Strucuture Validation: The validator checks whether the resource adheres to the syntactic rules and structure defined by the FHIR specification. It verifies that the resource is well-formed and properly organized.
3. Profile Validation: FHIR resources can have associated profiles that define specific rules and constraints. The validator ensures that the resource conforms to these profiles.
4. Value Domain Validation: The validator examines the values within the resource to ensure they are within acceptable ranges, formats, and constraints. For example, it might validate that a patient's gender is a valid code value.
5. Constraint Validation: The validator checks whether the resource adhere to its element cardinalities and constraints such as regex patterns, etc.
6. Error Reporting: If any validation errors are found, the validator generates detailed error reports that highlight the issues in the resource. These reports assist developers in identifying and resolving problems.

### Sample Usage

**01. Validate against FHIR base resource model**

In this approach user just need to provide only the FHIR resource payload. Based on the resource type, validator will validate
against to it's base profile model.

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.validator;

public function main() returns error? {

    json body = {
      "resourceType": "Patient",
      "id": "591841",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-01-22T05:30:13.137+00:00",
        "source": "#KO38Q3spgrJoP5fa"
      },
      "identifier": [ {
        "type": {
          "coding": [ {
            "system": "http://hl7.org/fhir/v2/0203",
            "code": "MR"
          } ]
        },
        "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
      } ],
      "name": [ {
        "family": "Cushing",
        "given": [ "Caleb" ]
      } ],
      "birthDate": "jdlksjldjl"
    };


    r4:FHIRValidationError? validateFHIRResourceJson = validator:validate(body);

    if validateFHIRResourceJson is r4:FHIRValidationError {
        io:print(validateFHIRResourceJson);
    }
}
```

*Note:* `validate` function returns `FHIRValidationError` when validation fails.

**02. Validate againts given FHIR profile resource model**

In this approach the validator will attempt to validate the given FHIR resource payload against given resource type

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.validator;

public function main() returns error? {

    json body = {
      "resourceType": "Patient",
      "id": "591841",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-01-22T05:30:13.137+00:00",
        "source": "#KO38Q3spgrJoP5fa"
      },
      "identifier": [ {
        "type": {
          "coding": [ {
            "system": "http://hl7.org/fhir/v2/0203",
            "code": "MR"
          } ]
        },
        "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
      } ],
      "name": [ {
        "family": "Cushing",
        "given": [ "Caleb" ]
      } ],
      "birthDate": "jdlksjldjl"
    };


    r4:FHIRValidationError? validateFHIRResourceJson = validator:validate(body, international401:Patient);

    if validateFHIRResourceJson is r4:FHIRValidationError {
        io:print(validateFHIRResourceJson);
    }
}
```

*Note:* `validate` function returns `FHIRValidationError` when validation fails.

---

## Enabling Terminology Validation

To enable terminology validation in the parser module, add the following configuration to your `Config.toml` file:

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
