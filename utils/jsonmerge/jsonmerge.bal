// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/log;

// Configuration flag to control behavior when source and base have different types for the same key
// When true: ignores type mismatches and preserves base value
// When false: returns an error on type mismatch
configurable boolean ignoreMismatchedTypes = false;

# Description.
#
# + srcJson - Source JSON object to merge from
# + baseJson - Base JSON object to merge into (serves as base)  
# + keys - Optional map specifying merge keys for arrays at different paths
# Format: {"keyValue": ["keyField"]} or {"parent.keyValue": ["keyField"]}
# Supports composite keys: {"keyValue": ["field1", "field2"]}
# Note: Currently only supports keys with primitive values (string, int, boolean, float, decimal)
# + return - return merged JSON object or error if types mismatch
public isolated function mergeJson(json baseJson, json srcJson, map<string[]>? keys = ()) returns json|error {

    // Input validation: Ensure both parameters are JSON objects (maps)
    if !(srcJson is map<json>) {
        return error("Source JSON must be a valid JSON object");
    }
    if !(baseJson is map<json>) {
        return error("Base JSON must be a valid JSON object");
    }

    log:printDebug("base json: " + baseJson.toString());
    log:printDebug("src json: " + srcJson.toString());

    // Type cast to map<json> for easier manipulation
    map<json> srcMap = <map<json>>srcJson;
    map<json> baseMap = <map<json>>baseJson;

    // Clone base as the result to preserve original base structure
    map<json> resultMap = baseMap.clone();

    // Iterate through each key-value pair in the source JSON
    foreach var [key, srcValue] in srcMap.entries() {
        // Case 1: Key doesn't exist in base - simply add it
        if !resultMap.hasKey(key) {
            resultMap[key] = srcValue;
        } else {
            // Case 2: Key exists in both source and base - need to merge values
            json resultValue = resultMap[key];

            // Process merge keys for current context
            // This handles nested key paths and composite keys for array merging
            map<string[]> filteredKeys = {}; // Keys for nested objects
            string[] matchedKeys = []; // Keys for current level array merging

            if keys is map<string[]> {

                // Direct key match: key exists in keys map
                if (keys.hasKey(key)) {
                    string[] keyField = keys.get(key);
                    matchedKeys.push(...keyField);
                }
                // Process each key to handle nested paths
                foreach var [keyPath, keyField] in keys.entries() {
                    // Nested path match: keyPath starts with current key + "."
                    // Example: key="patient", keyPath="patient.identifier" -> pass "identifier" to nested merge
                    if keyPath.startsWith(key + ".") {
                        string keyPrefix = key + ".";
                        string newKey = keyPath.substring(keyPrefix.length());
                        filteredKeys[newKey] = keyField;
                    }
                }
            }
            log:printDebug("filteredKeys map: " + filteredKeys.toString());
            log:printDebug("matchedKeys array: " + matchedKeys.toString());

            // Merge strategy based on value types

            // Strategy 1: Both values are JSON objects - recursive merge
            if srcValue is map<json> && resultValue is map<json> {
                json|error mergeResult = mergeJson(resultValue, srcValue, filteredKeys);
                if mergeResult is error {
                    return mergeResult;
                }
                resultMap[key] = mergeResult;
            }

            // Strategy 2: Both values are JSON arrays - merge based on keys or append
            else if srcValue is json[] && resultValue is json[] {
                if keys is () {
                    // No merge keys specified - simple append
                    json[] appendResult = deepMergeArrayByAppend(resultValue, srcValue);
                    resultMap[key] = appendResult;
                } else {
                    // Merge keys specified - merge by matching key values
                    json[]|error mergeByKeyResult = deepMergeArrayByKey(resultValue, srcValue, matchedKeys, filteredKeys);
                    if mergeByKeyResult is error {
                        return mergeByKeyResult;
                    }
                    resultMap[key] = mergeByKeyResult;
                }
            }

            // Strategy 3: Type mismatch handling
            // Covers cases where source and base have different types for the same key
            // Examples: source has object, base has array
            else if (srcValue is map<json> && !(resultValue is map<json>)) ||
                    (!(srcValue is map<json>) && resultValue is map<json>) ||
                    (srcValue is json[] && !(resultValue is json[])) ||
                    (!(srcValue is json[]) && resultValue is json[]) {

                if !ignoreMismatchedTypes {
                    // Strict mode: return error on type mismatch
                    return error("Type mismatch for resultValue: " + resultValue.toString() +
                        " and srcValue: " + srcValue.toString());
                }
                // Lenient mode: preserve base value, ignore source
                // This maintains data integrity by keeping the base structure intact
            }

            // Strategy 4: Both values are primitives - overwrite with source value
            // Overwrites the base value with the source value irrespective of type
            // Example: base={"version": "1.0"}, source={"version": "2.0"} -> result={"version": "2.0"}
            else {
                resultMap[key] = srcValue;
            }
        }
        log:printDebug(key + ": result json: " + resultMap.toJson().toString());

    }
    return resultMap;
}

# Description.
#
# + srcArray - Source array to merge from
# + baseArray - Base array to merge into  
# + matchedKeys - Array of key field names to use for matching elements
# + keys - Optional nested merge keys for recursive object merging (map<string[]>)
# + return - return merged JSON array or error
// Examples:
// Simple key match:
//   source: [{"id": "1", "name": "John"}]
//   base: [{"id": "1", "name": "Jane"}]
//   matchedKeys: ["id"]
//   result: [{"id": "1", "name": "John"}] (source overwrites)
//
// Composite key match:
//   source: [{"system": "http://hl7.org", "code": "123", "display": "New"}]
//   base: [{"system": "http://hl7.org", "code": "123", "display": "Old"}]
//   matchedKeys: ["system", "code"]
//   result: [{"system": "http://hl7.org", "code": "123", "display": "New"}]
isolated function deepMergeArrayByKey(json[] baseArray, json[] srcArray, string[] matchedKeys, map<string[]>? keys) returns json[]|error {

    // Fallback to simple append if no merge keys specified
    if matchedKeys.length() == 0 {
        return deepMergeArrayByAppend(baseArray, srcArray);
    }

    // Start with base array as base (preserves base order and unmatched elements)
    json[] resultArray = baseArray.clone();

    // Process each element in source array
    foreach json srcElement in srcArray {
        // Look for exact match between elements.
        boolean elementExists = false;
        foreach json resultElement in resultArray {
            if srcElement == resultElement {
                elementExists = true;
                break;
            }
        }
        if elementExists {
            continue;
        }

        // Key-based merge logic for objects
        if (srcElement is map<json>) {
            map<json> srcMap = <map<json>>srcElement;

            // Extract key values from source element for matching
            // Example: if matchedKeys=["id", "system"], extract values for both fields
            map<json> srcKeyValues = {};
            boolean hasAllKeys = true;

            foreach string keyField in matchedKeys {
                if srcMap.hasKey(keyField) {
                    json keyValue = srcMap.get(keyField);
                    srcKeyValues[keyField] = keyValue;
                } else {
                    // Source element missing required key field - can't match by key
                    hasAllKeys = false;
                    break;
                }
            }

            // If source element lacks required keys, append it as new element
            // Example: trying to match by "id" but source element has no "id" field
            if !hasAllKeys {
                resultArray.push(srcElement);
                continue;
            }
            log:printDebug("Source has all keys.");

            boolean foundMatch = false;

            // Search for matching element in result array
            foreach int i in 0 ..< resultArray.length() {
                json resultElement = resultArray[i];

                // Skip non-object elements in result array
                if !(resultElement is map<json>) {
                    continue;
                }

                map<json> resultElementMap = <map<json>>resultElement;

                // Check if all key fields match between source and result elements
                boolean keysMatch = true;
                foreach string keyField in matchedKeys {
                    if !resultElementMap.hasKey(keyField) {
                        keysMatch = false;
                        break;
                    }

                    json resultKeyValue = resultElementMap.get(keyField);
                    json srcKeyValue = srcKeyValues.get(keyField);

                    // Compare key values for exact match
                    if resultKeyValue != srcKeyValue {
                        keysMatch = false;
                        break;
                    }
                }

                if keysMatch {
                    log:printDebug("Keys match! baseElement:" + resultElement.toString() + " srcElement: " + srcElement.toString());

                    // Found matching element - perform deep merge of the objects
                    json|error mergeResult = mergeJson(resultElement, srcElement, keys);
                    if mergeResult is error {
                        return mergeResult;
                    }
                    resultArray[i] = mergeResult;
                    foundMatch = true;
                    break;
                }
            }

            // If no matching element found, append source element as new
            if !foundMatch {
                resultArray.push(srcElement);
            }
        } else {
            // Not an object, just append (already checked for duplicates)
            resultArray.push(srcElement);
        }
    }
    log:printDebug("Result array: " + resultArray.toString());
    return resultArray;
}

# Description.
#
# + srcArray - Source array to append
# + baseArray - Base array to append to
# + return - Merged array
// Note: This preserves order with base elements first, then source elements
isolated function deepMergeArrayByAppend(json[] baseArray, json[] srcArray) returns json[] {
    // Just append arrays
    json[] combinedArray = [...baseArray, ...srcArray];
    return combinedArray;
}

