# FHIR R4 Utils FHIRPath package

A package containing FHIR related processors and utilities to query, manipulate, and extract specific data elements from FHIR resources using FHIRPath expressions.

## Package Overview

This package provides a comprehensive set of functions to facilitate querying, updating, and manipulating FHIR resources using FHIRPath expressions. It supports extracting values, setting new values, removing elements, and selecting specific resource elements based on FHIRPath expressions.

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://hl7.org/fhir/fhirpath.html |
| Package Version      | 3.0.0                |
| Ballerina Version    | 2201.12.2            |

## Key Features

- **Query FHIR Resources**: Extract values from FHIR resources using FHIRPath expressions
- **Update FHIR Resources**: Set or modify values in FHIR resources at specified paths  
- **Remove FHIR Elements**: Remove sub-elements from FHIR resources by setting values to null
- **Path Creation**: Support for creating missing paths when updating nested structures
- **Error Handling**: Comprehensive error reporting for invalid paths or operations
- **Type Safety**: Strong typing with custom error types for robust error handling

## Main Functions

- `getFhirPathValues(json, string)` - Extract values using FHIRPath expressions
- `setFhirPathValues(json, string, json, boolean?)` - Set or remove values at specified paths

Refer [API Documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath) for detailed usage examples.
