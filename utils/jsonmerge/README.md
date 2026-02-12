# JSON Merge Utility

This module provides a robust utility for merging two JSON objects using Ballerina, supporting advanced strategies such as key-based array merging, composite keys, and deep recursive merging. It is designed for use cases like FHIR resource merging, configuration overlays, and general-purpose JSON manipulation.

## Table of Contents

- [Features](#features)
- [Usage](#usage)
  - [Import](#import)
  - [Basic Merge](#basic-merge)
  - [Array Merge by Key](#array-merge-by-key)
  - [Composite Key Example](#composite-key-example)
  - [FHIR Resource Merge](#fhir-resource-merge)
- [API Reference](#api-reference)
  - [mergeJson](#mergejson)
  - [mergeFHIRResources](#mergefhirresources)
- [Strategy](#strategy)
  - [Main Merge Logic](#main-merge-logic)
  - [Type-Based Merge Strategies](#type-based-merge-strategies)
- [Error Handling](#error-handling)
- [Testing](#testing)

## Features

- **Deep Merge**: Recursively merges nested JSON objects.
- **Array Merge Strategies**:
  - **Append**: By default, arrays are concatenated.
  - **Key-Based Merge**: Arrays of objects can be merged by matching one or more key fields (including composite keys).
    - **Note:** Currently only supports keys with primitive values (string, int, boolean, float, decimal)
- **Composite Key Support**: Specify multiple fields as a composite key for array element matching.
- **Type Safety**: Returns errors on type mismatches unless configured to ignore them.
- **Preserves Original Structure**: The original JSON is never mutated; a new merged object is returned.
- **FHIR Resource Support**: Specialized functions for merging FHIR R4 resources and bundles with:
  - Built-in FHIR validation before and after merge operations

## Usage

### Import

```ballerina
import ballerinax/health.fhir.r4utils.jsonmerge;
```

### Basic Merge

```ballerina
json original = { "a": 1, "b": 2 };
json updates = { "b": 3, "c": 4 };
json result = check jsonmerge:mergeJson(original, updates);
```

Result:
```json
{ "a": 1, "b": 3, "c": 4 }
```

### Array Merge by Key

```ballerina
json original = { "items": [ { "id": 1, "value": "A" } ] };
json updates = { "items": [ { "id": 1, "value": "B" }, { "id": 2, "value": "C" } ] };
map<string[]> keys = { "items": ["id"] };
json result = check jsonmerge:mergeJson(original, updates, keys);
```

Result:
```json
{ "items": [ { "id": 1, "value": "B" }, { "id": 2, "value": "C" } ] }
```

**Note:** The merge keys can be defined inside the Config.toml file as well. `Nested key paths should be given inside double quotes` as follows. 

```
[mergeKeys]
#Patient resources
identifier = ["use","system","value"]
"identifier.type.coding" = ["system", "code"]
telecom = ["system","use","value"]
address = ["use","postalCode"]
name = ["use"]
```

### Composite Key Example

```ballerina
map<string[]> keys = { "products": ["id", "code"] };
```
This will match array elements where both `id` and `code` fields are equal.

### FHIR Resource Merge

```ballerina
json originalPatient = {
    "resourceType": "Patient",
    "id": "example",
    "identifier": [
        {
            "system": "http://example.org/mrn",
            "value": "12345"
        }
    ],
    "name": [
        {
            "use": "official",
            "family": "Doe",
            "given": ["John"]
        }
    ]
};

json updatesPatient = {
    "resourceType": "Patient",
    "id": "example",
    "identifier": [
        {
            "system": "http://example.org/mrn", 
            "value": "12345"
        },
        {
            "system": "http://example.org/ssn",
            "value": "111-22-3333"
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "+1-555-123-4567",
            "use": "home"
        }
    ]
};

json result = check jsonmerge:mergeFHIRResources(originalPatient, updatesPatient);

```

## API Reference

### mergeJson(json original, json updates, map<string[]>? keys = ()) returns json|error

- `original`: The original JSON object.
- `updates`: The updates JSON object to merge.
- `keys`: (Optional) Map specifying merge keys for arrays at different paths. Supports composite keys.

Returns the merged JSON object or an error if types mismatch.

For more details, see the implementation in [json_merge.bal](json_merge.bal).

### mergeFHIRResources(json originalResource, json updatesResource, map<string[]>? keys = ()) returns json|error

- `originalResource`: The base FHIR resource (serves as foundation).
- `updatesResource`: The source FHIR resource containing updates to merge.
-  `keys` : Optional map specifying merge keys for FHIR resource arrays

Returns the merged FHIR resource or an error if validation fails.

This function:
- Validates both input resources against FHIR R4 standards
- Uses FHIR-specific merge keys for arrays (e.g., identifiers merged by system+value)
- Validates the merged result to ensure FHIR compliance
- Returns descriptive errors for any validation failures

For more details, see the implementation in [fhir_resource_merge.bal](fhir_resource_merge.bal).

## Strategy

### Main Merge Logic
- **New Key Addition:** If a key exists only in updates JSON, it's directly added to the result  

- **Existing Key Handling:** When a key exists in both objects, applies type-specific merge strategies

### Type-Based Merge Strategies

**Strategy 1: Object-to-Object Merge**

- Both updates and original values are JSON objects
- Performs recursive deep merge using the same mergeJson function 
- Nested objects are merged recursively with filtered keys for nested paths

**Strategy 2: Array-to-Array Merge**

- Both updates and original values are JSON arrays (json[]) 
- Two Sub-strategies:

  1. **Simple Append:** When no merge keys specified, concatenates arrays

      - Concatenates updates array to original array 
      - Original elements come first, followed by updates elements 
      - Allows duplicate elements

  2.  **Key-Based Merge:** When merge keys provided, matches array elements by specified key fields 

      - First checks for exact JSON matches to avoid duplicates
      - Extracts specified key field values from updates elements 
      - Compares key values between updates and original array elements    
        **Note:** Supports composite keys and primitive value matching only
      - When keys match, recursively merges the matching objects
      - Elements without matching keys are appended as new items

**Strategy 3: Type Mismatch Handling**

- Updates and original values have different types (object vs array, object vs primitive, etc.) 
- **Configurable Behavior:**

  - Strict Mode (ignoreMismatchedTypes = false): Returns error on type mismatch
  - Lenient Mode (ignoreMismatchedTypes = true): Preserves original value, ignores updates

**Strategy 4: Primitive Value Merge**

- Both values are primitive types (string, number, boolean, null) 
- Updates value overwrites original value completely
- Simple replacement strategy for non-structural data

## Error Handling

- Returns descriptive errors for type mismatches or invalid inputs.
- Configurable behavior for type mismatches via the `ignoreMismatchedTypes` flag.

## Testing

Extensive tests are provided in the [`tests/`](tests/) directory, covering:
- Primitive and nested object merging
- Array merging (append and key-based)
- Composite key scenarios
- FHIR resource and bundle merging
- Edge cases and error handling

To run tests:
```sh
bal test
```
