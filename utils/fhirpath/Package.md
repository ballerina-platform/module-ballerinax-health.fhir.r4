# FHIR R4 Utils FHIRPath package

A package containing FHIR related processors and utilities to query, manipulate, and extract specific data elements from FHIR resources using FHIRPath expressions.

## Package Overview

This package provides a comprehensive set of functions to facilitate querying, updating, and manipulating FHIR resources using FHIRPath expressions. It features a unified API that supports extracting values, setting new values, removing elements, and applying custom transformation functions for data processing needs such as de-identification and masking.

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
- **Function-based Value Modification**: Apply custom functions to transform values during updates (useful for data masking, hashing, encryption, etc.)
- **Unified API**: Single function handles both direct value setting and function-based transformations
- **Path Creation**: Support for creating missing paths when updating nested structures (configurable)
- **Validate FHIRPath Expressions**: Ensure that FHIRPath expressions are valid before evaluation
- **Validate FHIR Resources**: Ensure that FHIR resources conform to the FHIR R4 specification
- **Error Handling**: Comprehensive error reporting for invalid paths or operations
- **Type Safety**: Strong typing with custom error types for robust error handling

## Main Functions

- `getFhirPathValues(json, string, boolean?)` - Extract values using FHIRPath expressions
- `setFhirPathValues(json, string, json|ModificationFunction, boolean?)` - **Unified function** for setting values, applying transformations, or removing fields
- `validateFhirPath(string)` - Validate FHIRPath expression syntax

Refer [API Documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath) for detailed usage examples.
