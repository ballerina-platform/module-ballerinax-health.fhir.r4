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
    fhirpath:FhirPathResult result = fhirpath:getFhirPathValue(patient, "Patient.name[0].given[0]");
    if result.result is json {
        io:println("First given name: ", result.result);
    }
    // Get all given names
    fhirpath:FhirPathResult result = fhirpath:getFhirPathValue(patient, "Patient.name.given[0]");
    if result.result is json {
        io:println("First given name: ", result.result);
    }
    
    // Handle errors
    fhirpath:FhirPathResult errorResult = fhirpath:getFhirPathValue(patient, "Patient.invalidPath");
    if errorResult.'error is fhirpath:FhirPathErrorRecord {
        io:println("Error: ", errorResult.'error.message);
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
        "active": true
    };
    
    // Update a value in the FHIR resource
    fhirpath:FhirPathResult updateResult = fhirpath:setFhirPathValue(
        patient, 
        "Patient.gender", 
        "male"
    );
    
    if updateResult.result is json {
        io:println("Updated patient: ", updateResult.result);
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
                "given": [
                    "Jim"
                ]
            }
        ]
    };
    
    // Remove a simple field
    fhirpath:FhirPathResult result = fhirpath:setFhirPathValue(patient, "Patient.gender", ());
    if result.result is json {
        io:println("Patient after removing gender: ", result.result);
    }
    
    // Remove an array element
    fhirpath:FhirPathResult arrayResult = fhirpath:setFhirPathValue(patient, "Patient.name[0]", ());
    if arrayResult.result is json {
        io:println("Patient after removing first name: ", arrayResult.result);
    }

    // Remove multiple elements
    fhirpath:FhirPathResult arrayResult = fhirpath:setFhirPathValue(patient, "Patient.name.given", ());
    if arrayResult.result is json {
        io:println("Patient after removing all given names: ", arrayResult.result);
    }
    
    // Using low-level function for removal
    json|error directResult = fhirpath:updateFhirPathValues(patient, "Patient.active", ());
    if directResult is json {
        io:println("Updated patient resource: ", directResult);
    }
}
```

## API Reference

### Main Functions

- `getFhirPathValue(json fhirResource, string fhirPath) returns FhirPathResult`
  - Returns a result containing either the extracted value list or an error. Output is a `FhirPathResult` record.
  - Can handle both single and multiple values (Eg: `Patient.name.given[0]` returns the first given name, while `Patient.name.given` returns all given names)

- `setFhirPathValue(json fhirResource, string fhirPathExpression, json value, boolean? allowPathCreation) returns FhirPathResult`
  - Updates a FHIR resource at the specified FHIRPath with the provided value and returns or sends an error. Output is a `FhirPathResult` record.
  - Use `()` as the value to remove a field from the resource (Eg: `Patient.gender` to `()` removes the gender field)
  - Can handle both single and multiple values (Eg: `Patient.name.given[0]` sets the first given name, while `Patient.name.given` sets all given names)
  - Optionally creates missing paths in the resource structure

- `retrieveFhirPathValues(json fhirResource, string fhirPathExpression) returns json|error`
  - Low-level function of the getFhirPathValue function
  - Returns the extracted values directly or an error

- `updateFhirPathValues(json fhirResource, string fhirPathExpression, json newValue, boolean allowPathCreation) returns json|error`
  - Low-level function of the setFhirPathValue function
  - Returns the updated FHIR resource or an error

### Types

- `FhirPathResult` - Result record containing either a result or error
- `FhirPathErrorRecord` - Error record with message field
- `FhirPathRequest` - Request parameters for FHIRPath operations
- `Token` - Basic token type for FHIRPath parsing
- `ArrayAccessToken` - Sub type of token for array access tokens

## Error Handling

The package provides comprehensive error handling for various scenarios:
- Invalid FHIRPath expressions
- Mismatched resource types
- Array index out of bounds
- Invalid characters in path expressions
