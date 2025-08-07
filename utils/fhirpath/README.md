# FHIR R4 Utils FHIRPath Package

This package provides utilities for working with FHIR resources using FHIRPath expressions. It allows you to query, update, and manipulate FHIR resources in a type-safe manner using Ballerina.

## Package Overview

This package implements FHIRPath, a powerful expression language for querying and manipulating FHIR resources. It supports the FHIR R4 version and provides a set of functions to evaluate FHIRPath expressions, update resource values, and handle errors effectively.

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://hl7.org/fhir/fhirpath.html |
| Package Version      | 3.0.0                |
| Ballerina Version    | 2201.12.2            |

Refer to the [API Documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath) for detailed usage.

## Features

- **Query FHIR Resources**: Extract one or more values for a matching FHIRPath expression from a FHIR resources
- **Update FHIR Resources**: Set values in FHIR resources at specified paths
- **Remove FHIR Sub-Resources**: Remove sub-elements from FHIR resources by setting values to null
- **Resource Manipulation**: Support for creating missing paths and updating nested structures
- **Validate FHIRPath Expressions**: Ensure that FHIRPath expressions are valid before evaluation
- **Validate FHIR Resource**: Ensure that FHIR resources provided and returned conform to the expected structure and types
- **Error Handling**: Comprehensive error reporting for invalid paths or operations
- **Type Safety**: Strong typing support for Ballerina applications


## Usage Examples

### Basic FHIRPath Value Extraction

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

json patient = {
    "resourceType": "Patient",
    "id": "1",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
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
        },
        {
            "use": "usual",
            "given": [
                "Jim"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    }
};

public function main() {
    // Get single value using FHIRPath
    json|error result = fhirpath:getFhirPathValues(patient, "Patient.name[0].given[0]");
    if result is json {
        io:println("First given name: ", result);
    }
    // Get all given names from all name records
    json|error allGivenResult = fhirpath:getFhirPathValues(patient, "Patient.name.given[0]");
    if allGivenResult is json {
        io:println("All first given names: ", allGivenResult);
    }
    
    // Handle errors
    json|error errorResult = fhirpath:getFhirPathValues(patient, "Patient.invalidPath");
    if errorResult is error {
        io:println("Error: ", errorResult.message());
    }
}
```

### Updating FHIR Resources

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "active": true,
        "address": [
            {
                "use": "home",
                "line": ["123 Main St"],
                "city": "Anytown",
                "state": "CA",
                "postalCode": "12345"
            },
            {
                "use": "work",
                "line": ["456 Work St"],
                "city": "Worktown",
                "state": "CA",
                "postalCode": "67890"
            }
        ]
    };

    // Update a value in the FHIR resource
    json|error updateResult = fhirpath:setFhirPathValues(
            patient,
            "Patient.active",
            false
    );
    if updateResult is json {
        io:println("Updated patient after active status change: ", updateResult);
    }

    // Update multiple values in the FHIR resource
    json|error updatedAddresses = fhirpath:setFhirPathValues(
            patient,
            "Patient.address.line",
            "***"
    );
    if updatedAddresses is json {
        io:println("Updated patient after address line masking: ", updatedAddresses);
    }

    // Add a new value to the FHIR resource
    json|error newlyAdded = fhirpath:setFhirPathValues(
            patient,
            "Patient.gender",
            "male",
            true
    );

    if newlyAdded is json {
        io:println("Updated patient after gender status addition: ", newlyAdded);
    }
}

```

### Removing FHIR Resource Fields

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "active": true,
        "gender": "male",
        "name": [
            {
                "use": "official",
                "family": "Chalmers",
                "given": [
                    "Peter",
                    "James"
                ]
            },
            {
                "use": "usual",
                "family": "Fenders",
                "given": [
                    "Jim"
                ]
            }
        ]
    };

    // Remove a simple field
    json|error result = fhirpath:setFhirPathValues(patient, "Patient.gender", ());
    if result is json {
        io:println("Patient after removing gender: ", result);
    }

    // Remove multiple elements
    json|error multipleResult = fhirpath:setFhirPathValues(patient, "Patient.name.given", ());
    if multipleResult is json {
        io:println("Patient after removing all given names: ", multipleResult);
    }

    // Using low-level function for removal
    json|error directResult = fhirpath:setFhirPathValues(patient, "Patient.active", ());
    if directResult is json {
        io:println("Updated patient resource: ", directResult);
    }
}
```

## API Reference

### Main Functions

- `getFhirPathValues(json fhirResource, string fhirPathExpression, boolean validate = fhirResourceValidation) returns json|FHIRPathError`
  - Extracts values from FHIR resources using FHIRPath expressions
  - Returns extracted values as a json array or an error
  - Can handle both single and multiple values (e.g., `Patient.address[0].city` returns the first city from all address records, while `Patient.address.city` returns all the cities from all address records)

- `setFhirPathValues(json fhirResource, string fhirPathExpression, json newValue, boolean allowPathCreation = createMissingPaths, boolean validate = fhirResourceValidation) returns json|FHIRPathError`
  - Updates a FHIR resource at the specified FHIRPath with the provided value
  - Can handle both single and multiple values (e.g., `Patient.address[0].city` sets the city in the first address, while `Patient.address.city` updates all the cities in all the addresses.)
  - Use `()` as the value to remove a field from the resource (e.g., setting `Patient.gender` to `()` removes the gender field)
  - Optionally can create missing paths in the resource structure based on the `allowPathCreation` parameter

- `validateFhirPath(string fhirPath) returns boolean`
  - Validates a FHIRPath expression to ensure it is syntactically correct
  - Returns `true` if valid, or a `FHIRPathError` if invalid

### Types

- `Token` - Basic token type for FHIRPath parsing with value field
- `ArrayToken` - Sub type of token for array access tokens with index field
- `FHIRPathError` - Distinct error type for FHIRPath-related errors

## Error Handling

The package provides comprehensive error handling for various scenarios:
- Invalid FHIRPath expressions
- Mismatched resource types
- Array index out of bounds
- Invalid characters in path expressions
- Resource structure validation errors

All main functions return either the expected result or a `FHIRPathError` which can be handled using standard Ballerina error handling patterns.
