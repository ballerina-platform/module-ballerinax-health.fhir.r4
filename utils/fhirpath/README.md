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

- **Query FHIR Resources**: Extract one or more values for a matching FHIRPath expression from FHIR resources
- **Update FHIR Resources**: Set values in FHIR resources at specified paths
- **Remove FHIR Sub-Resources**: Remove sub-elements from FHIR resources by setting values to null
- **Resource Manipulation**: Support for creating missing paths and updating nested structures
- **Function-based Value Modification**: Apply custom functions to transform values during updates (useful for data masking, hashing, etc.)
- **Unified API**: Single function handles both direct value setting and function-based transformations
- **Validate FHIRPath Expressions**: Ensure that FHIRPath expressions are valid before evaluation
- **Validate FHIR Resources**: Ensure that FHIR resources provided and returned conform to the expected structure and types
- **Error Handling**: Comprehensive error reporting for invalid paths or operations
- **Type Safety**: Strong typing support for Ballerina applications

## API Reference

### Main Functions

- `getFhirPathValues(json fhirResource, string fhirPathExpression, boolean validateFHIRResource = fhirResourceValidation) returns json[]|FHIRPathError`
  - Extracts values from FHIR resources using FHIRPath expressions
  - Returns extracted values as a json array or an error
  - Can handle both single and multiple values (e.g., `Patient.address[0].city` returns the first city from all address records, while `Patient.address.city` returns all the cities from all address records)
  - Optional validation of FHIR resource structure

- `setFhirPathValues(json fhirResource, string fhirPathExpression, json|ModificationFunction valueOrFunction, boolean validateFHIRResource = fhirResourceValidation) returns json|FHIRPathError`
  - Updates a FHIR resource at the specified FHIRPath with either a new value or by applying a custom function
  - **Direct Value Setting**: When `valueOrFunction` is a json value, it sets the new value directly
    - Can handle both single and multiple values (e.g., `Patient.address[0].city` sets the city in the first address, while `Patient.address.city` updates all the cities in all the addresses)
    - Use `()` as the value to remove a field from the resource (e.g., setting `Patient.gender` to `()` removes the gender field)
  - **Function-based Transformation**: When `valueOrFunction` is a ModificationFunction, it applies the function to transform existing values
    - Useful for data masking, hashing, encryption, or other custom transformations
    - The modification function receives the current value and returns the transformed value
    - Can handle both single and multiple values
  - Optional validation of FHIR resource structure

- `validateFhirPath(string fhirPathExpression) returns boolean`
  - Validates a FHIRPath expression to ensure it is syntactically correct
  - Returns `true` if valid, `false` if invalid
  - Uses regex pattern matching to validate FHIRPath syntax

### Types

- `Token` - Basic token type for FHIRPath parsing with value field
- `ArrayToken` - Sub type of token for array access tokens with index field
- `FHIRPathError` - Distinct error type for FHIRPath-related errors
- `ModificationFunction` - Function type for custom value transformations: `isolated function (json) returns json|ModificationFunctionError`
- `ModificationFunctionError` - Distinct error type for modification function errors

### Utility Functions

- `createFhirPathError(string errorMsg, string? fhirPath) returns FHIRPathError` - Creates a FHIRPath error
- `createModificationFunctionError(string errorMsg, string? fhirPath, string? fhirPathValue) returns ModificationFunctionError` - Creates a modification function error

## Error Handling

The package provides comprehensive error handling for various scenarios:
- Invalid FHIRPath expressions
- Mismatched resource types
- Array index out of bounds
- Invalid characters in path expressions
- Resource structure validation errors

All main functions return either the expected result or a `FHIRPathError` which can be handled using standard Ballerina error handling patterns.

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
    json|error updateResult = fhirpath:setFhirPathValues(patient, "Patient.active", false);
    if updateResult is json {
        io:println("Updated patient after active status change: ", updateResult);
    }

    // Update multiple values in the FHIR resource
    json|error updatedAddresses = fhirpath:setFhirPathValues(patient, "Patient.address.line", "***", validateFHIRResource = false);
    if updatedAddresses is json {
        io:println("Updated patient after address line masking: ", updatedAddresses);
    }

    // Add a new value to the FHIR resource
    json|error newlyAdded = fhirpath:setFhirPathValues(patient, "Patient.gender", "male", validateFHIRResource = false);

    if newlyAdded is json {
        io:println("Updated patient after gender addition: ", newlyAdded);
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

### Function-based Value Modifications

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

// Define a custom modification function for data masking
isolated function maskOperation(json input) returns json|fhirpath:ModificationFunctionError {
    return "***MASKED***";
}

// Define a function to hash sensitive data
isolated function hashOperation(json input) returns json|fhirpath:ModificationFunctionError {
    if input is string {
        return "HASH_" + input.length().toString(); // Simple hash for example
    }
    return fhirpath:createModificationFunctionError("Expected string input for hashing", (), input.toString());
}

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "name": [
            {
                "use": "official",
                "family": "Doe",
                "given": ["John", "Michael"]
            }
        ],
        "telecom": [
            {
                "system": "phone",
                "value": "+1-555-123-4567"
            },
            {
                "system": "email",
                "value": "john.doe@example.com"
            }
        ]
    };

    // Mask all phone numbers
    json|error maskedPhone = fhirpath:setFhirPathValues(patient, "Patient.telecom[0].value", maskOperation);
    if maskedPhone is json {
        io:println("Patient with masked phone: ", maskedPhone);
    }

    // Hash email addresses
    json|error hashedId = fhirpath:setFhirPathValues(patient, "Patient.id", hashOperation);
    if hashedId is json {
        io:println("Patient with hashed id: ", hashedId);
    }

    // Apply function to multiple values
    json|error maskedNames = fhirpath:setFhirPathValues(patient, "Patient.name.given", maskOperation, validateFHIRResource = false);
    if maskedNames is json {
        io:println("Patient with masked given names: ", maskedNames);
    }
}
```