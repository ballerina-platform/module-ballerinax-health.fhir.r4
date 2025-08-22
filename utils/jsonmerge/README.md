# JSON Merge Utility

This module provides a robust utility for merging two JSON objects using Ballerina, supporting advanced strategies such as key-based array merging, composite keys, and deep recursive merging. It is designed for use cases like FHIR resource merging, configuration overlays, and general-purpose JSON manipulation.

## Features

- **Deep Merge**: Recursively merges nested JSON objects.
- **Array Merge Strategies**:
  - **Append**: By default, arrays are concatenated.
  - **Key-Based Merge**: Arrays of objects can be merged by matching one or more key fields (including composite keys).
    - **Note:** Currently only supports keys with primitive values (string, int, boolean, float, decimal)

- **Composite Key Support**: Specify multiple fields as a composite key for array element matching.
- **Type Safety**: Returns errors on type mismatches unless configured to ignore them.
- **Preserves Base Structure**: The base JSON is never mutated; a new merged object is returned.

## Usage

### Import

```ballerina
import ballerinax/health.fhir.r4utils.jsonmerge;
```

### Basic Merge

```ballerina
json base = { "a": 1, "b": 2 };
json src = { "b": 3, "c": 4 };
json result = check jsonmerge:mergeJson(base, src);
```

Result:
```json
{ "a": 1, "b": 3, "c": 4 }
```

### Array Merge by Key

```ballerina
json base = { "items": [ { "id": 1, "value": "A" } ] };
json src = { "items": [ { "id": 1, "value": "B" }, { "id": 2, "value": "C" } ] };
map<string> keys = { "items": "id" };
json result = check jsonmerge:mergeJson(base, src, keys);
```

Result:
```json
{ "items": [ { "id": 1, "value": "B" }, { "id": 2, "value": "C" } ] }
```

### Composite Key Example

```ballerina
map<string> keys = { "products": "id,code" };
```
This will match array elements where both `id` and `code` fields are equal.

## API Reference

### mergeJson(json baseJson, json srcJson, map<string>? keys = ()) returns json|error

- `baseJson`: The base JSON object.
- `srcJson`: The source JSON object to merge.
- `keys`: (Optional) Map specifying merge keys for arrays at different paths. Supports composite keys.

Returns the merged JSON object or an error if types mismatch.

For more details, see the implementation in [jsonmerge.bal](jsonmerge.bal).

## Strategy

### Main Merge Logic
- **New Key Addition:** If a key exists only in source, it's directly added to the result  

- **Existing Key Handling:** When a key exists in both objects, applies type-specific merge strategies

### Type-Based Merge Strategies

**Strategy 1: Object-to-Object Merge**

- Both source and base values are JSON objects
- Performs recursive deep merge using the same mergeJson function 
- Nested objects are merged recursively with filtered keys for nested paths

**Strategy 2: Array-to-Array Merge**

- Both source and base values are JSON arrays (json[]) 
- Two Sub-strategies:

  1. **Simple Append:** When no merge keys specified, concatenates arrays

      - Concatenates source array to base array 
      - Base elements come first, followed by source elements 
      - Allows duplicate elements

  2.  **Key-Based Merge:** When merge keys provided, matches array elements by specified key fields 

      - First checks for exact JSON matches to avoid duplicates
      - Extracts specified key field values from source elements 
      - Compares key values between source and base array elements    
        **Note:** Supports composite keys  (comma-separated) and primitive value matching only
      - When keys match, recursively merges the matching objects
      - Elements without matching keys are appended as new items

**Strategy 3: Type Mismatch Handling**

- Source and base have different types (object vs array, object vs primitive, etc.) 
- **Configurable Behavior:**

  -  Strict Mode (ignoreMismatchedTypes = false): Returns error on type mismatch
  - Lenient Mode (ignoreMismatchedTypes = true): Preserves base value, ignores source

**Strategy 4: Primitive Value Merge**

- Both values are primitive types (string, number, boolean, null) 
- Source value overwrites base value completely
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
