# FHIR R4 Validator Module

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
