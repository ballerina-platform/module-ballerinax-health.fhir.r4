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

// Configuration flag to control behavior when updates and original JSONs have different types for the same key
// When true: ignores type mismatches and preserves original value
// When false: returns an error on type mismatch
configurable boolean ignoreMismatchedTypes = false;

// Configurable merge keys - read from Config.toml file for application-wide array merging strategy
// This allows external configuration of how arrays should be merged by specifying which fields
// to use as keys for matching array elements. When merge keys are defined, arrays of objects
// will be merged by matching elements with the same key field values instead of simple appending.
// Examples in Config.toml:
//   [mergeKeys]
//   #Patient resources
//   identifier = ["use", "system", "value"]
//   "identifier.type.coding" = ["system", "code"]
//   telecom = ["system", "use", "value"]
//   address = ["use", "postalCode"]
//   name = ["use"]
//   configurable map<string[]> mergeKeys = {};
configurable map<string[]> mergeKeys = {};

# Description.
#
# + updates - Updates JSON object to merge from
# + original - Original JSON object to merge into (serves as base)  
# + keys - Optional map specifying merge keys for arrays at different paths
# Format: {"keyValue": ["keyField"]} or {"parent.keyValue": ["keyField"]}
# Supports composite keys: {"keyValue": ["field1", "field2"]}
# Note: Currently only supports keys with primitive values (string, int, boolean, float, decimal)
# + return - return merged JSON object or error if types mismatch
public isolated function mergeJson(json original, json updates, map<string[]>? keys = ()) returns json|error {
    // This is the public entry point - use configured keys only if no keys provided
    map<string[]>? effectiveKeys = keys;

    // Only use configured merge keys if the caller did not provide any keys
    if keys is () && mergeKeys.length() > 0 {
        // Clean TOML parsed artifacts (extra quotes) from configured merge keys before using them
        effectiveKeys = cleanMergeKeys(mergeKeys);
        log:printDebug("Using configured merge keys for top-level merge:", mergeKeys = effectiveKeys);
    }

    return mergeJsonInternal(original, updates, effectiveKeys);
}

# Description.
# Internal implementation of JSON merging with detailed merge strategies.
# Note: This is an internal function allowing for precise control over merge behavior in recursive calls. 
# Use mergeJson() for public API.
#
# + updates - Updates JSON object to merge from
# + original - Original JSON object to merge into (serves as base)  
# + keys - Optional map specifying merge keys for arrays at different paths
# + return - return merged JSON object or error if types mismatch
isolated function mergeJsonInternal(json original, json updates, map<string[]>? keys = ()) returns json|error {

    // Input validation: Ensure both parameters are JSON objects (maps)
    if updates !is map<json> {
        return error("Updates JSON must be a valid JSON object");
    }
    if original !is map<json> {
        return error("Original JSON must be a valid JSON object");
    }

    log:printDebug("Original json:", original = original);
    log:printDebug("Updates json:", updates = updates);
    log:printDebug("Keys json:", keys = keys);

    // Type cast to map<json> for easier manipulation
    map<json> updatesMap = <map<json>>updates;
    map<json> originalMap = <map<json>>original;

    // Clone original as the result to preserve original base structure
    map<json> resultMap = originalMap.clone();

    // Iterate through each key-value pair in the updates JSON
    foreach var [key, updatesValue] in updatesMap.entries() {
        // Case 1: Key doesn't exist in original - simply add it
        if !resultMap.hasKey(key) {
            resultMap[key] = updatesValue;
        } else {
            // Case 2: Key exists in both updates and original - need to merge values
            json resultValue = resultMap[key];

            // Process merge keys for current context
            // This handles nested key paths and composite keys for array merging
            map<string[]> filteredKeys = {}; // Keys for nested objects
            string[] matchedKeys = []; // Keys for current level array merging

            if keys is map<string[]> {

                // Direct key match: key exists in keys map
                if keys.hasKey(key) {
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
            log:printDebug("Filtered keys map for key: " + key, filteredKeys = filteredKeys);
            log:printDebug("Matched keys array for key: " + key, matchedKeys = matchedKeys);

            // Merge strategy based on value types

            // Strategy 1: Both values are JSON objects - recursive merge
            if updatesValue is map<json> && resultValue is map<json> {
                json|error mergeResult = mergeJson(resultValue, updatesValue, filteredKeys);
                if mergeResult is error {
                    return mergeResult;
                }
                resultMap[key] = mergeResult;
            }

            // Strategy 2: Both values are JSON arrays - merge based on keys or append
            else if updatesValue is json[] && resultValue is json[] {
                if keys is () {
                    // No merge keys specified - simple append
                    json[] appendResult = deepMergeArrayByAppend(resultValue, updatesValue);
                    resultMap[key] = appendResult;
                } else {
                    // Merge keys specified - merge by matching key values
                    json[]|error mergeByKeyResult = deepMergeArrayByKey(resultValue, updatesValue, matchedKeys, filteredKeys);
                    if mergeByKeyResult is error {
                        return mergeByKeyResult;
                    }
                    resultMap[key] = mergeByKeyResult;
                }
            }

            // Strategy 3: Type mismatch handling
            // Covers cases where updates and original have different types for the same key
            // Examples: updates has object, original has array
            else if (updatesValue is map<json> && resultValue !is map<json>) ||
                    (updatesValue !is map<json> && resultValue is map<json>) ||
                    (updatesValue is json[] && resultValue !is json[]) ||
                    (updatesValue !is json[] && resultValue is json[]) {

                if !ignoreMismatchedTypes {
                    // Strict mode: return error on type mismatch
                    return error("Type mismatch for original value:" + resultValue.toString() +
                        " and updates value:" + updatesValue.toString());
                }
                // Lenient mode: preserve original value, ignore updates
                // This maintains data integrity by keeping the original structure intact
            }

            // Strategy 4: Both values are primitives - overwrite with updates value
            // Overwrites the original value with the updates value irrespective of type
            // Example: original={"version": "1.0"}, updates={"version": "2.0"} -> result={"version": "2.0"}
            else {
                resultMap[key] = updatesValue;
            }
        }
        log:printDebug("Key: " + key + ", Result json:", resultMap = resultMap);

    }
    return resultMap;
}

# Description.
#
# + updatesArray - Updates array to merge from
# + originalArray - Original array to merge into  
# + matchedKeys - Array of key field names to use for matching elements
# + keys - Optional nested merge keys for recursive object merging (map<string[]>)
# + return - return merged JSON array or error
// Examples:
// Simple key match:
//   updates: [{"id": "1", "name": "John"}]
//   original: [{"id": "1", "name": "Jane"}]
//   matchedKeys: ["id"]
//   result: [{"id": "1", "name": "John"}] (updates overwrites)
//
// Composite key match:
//   updates: [{"system": "http://hl7.org", "code": "123", "display": "New"}]
//   original: [{"system": "http://hl7.org", "code": "123", "display": "Old"}]
//   matchedKeys: ["system", "code"]
//   result: [{"system": "http://hl7.org", "code": "123", "display": "New"}]
isolated function deepMergeArrayByKey(json[] originalArray, json[] updatesArray, string[] matchedKeys, map<string[]>? keys) returns json[]|error {

    // Fallback to simple append if no merge keys specified
    if matchedKeys.length() == 0 {
        return deepMergeArrayByAppend(originalArray, updatesArray);
    }

    // Start with original array as base (preserves original order and unmatched elements)
    json[] resultArray = originalArray.clone();

    // Process each element in updates array
    foreach json updatesElement in updatesArray {
        // Look for exact match between elements.
        boolean elementExists = false;
        foreach json resultElement in resultArray {
            if updatesElement == resultElement {
                elementExists = true;
                break;
            }
        }
        if elementExists {
            continue;
        }

        // Key-based merge logic for objects
        if updatesElement is map<json> {
            map<json> updatesMap = <map<json>>updatesElement;

            // Extract key values from updates element for matching
            // Example: if matchedKeys=["id", "system"], extract values for both fields
            map<json> updatesKeyValues = {};
            boolean hasAllKeys = true;

            foreach string keyField in matchedKeys {
                if updatesMap.hasKey(keyField) {
                    json keyValue = updatesMap.get(keyField);
                    updatesKeyValues[keyField] = keyValue;
                } else {
                    // updates element missing required key field - can't match by key
                    hasAllKeys = false;
                    break;
                }
            }

            // If updates element lacks required keys, append it as new element
            // Example: trying to match by "id" but updates element has no "id" field
            if !hasAllKeys {
                resultArray.push(updatesElement);
                continue;
            }
            log:printDebug("Updates element has all keys.");

            boolean foundMatch = false;

            // Search for matching element in result array
            foreach int i in 0 ..< resultArray.length() {
                json resultElement = resultArray[i];

                // Skip non-object elements in result array
                if resultElement !is map<json> {
                    continue;
                }

                map<json> resultElementMap = <map<json>>resultElement;

                // Check if all key fields match between updates and result elements
                boolean keysMatch = true;
                foreach string keyField in matchedKeys {
                    if !resultElementMap.hasKey(keyField) {
                        keysMatch = false;
                        break;
                    }

                    json resultKeyValue = resultElementMap.get(keyField);
                    json updatesKeyValue = updatesKeyValues.get(keyField);

                    // Compare key values for exact match
                    if resultKeyValue != updatesKeyValue {
                        keysMatch = false;
                        break;
                    }
                }

                if keysMatch {
                    log:printDebug("Keys match!", resultElement = resultElement, updatesElement = updatesElement);

                    // Found matching element - perform deep merge of the objects
                    json|error mergeResult = mergeJson(resultElement, updatesElement, keys);
                    if mergeResult is error {
                        return mergeResult;
                    }
                    resultArray[i] = mergeResult;
                    foundMatch = true;
                    break;
                }
            }

            // If no matching element found, append updates element as new
            if !foundMatch {
                resultArray.push(updatesElement);
            }
        } else {
            // Not an object, just append (already checked for duplicates)
            resultArray.push(updatesElement);
        }
    }
    log:printDebug("Result array:", resultArray = resultArray);
    return resultArray;
}

# Description.
#
# + updatesArray - Updates array to append
# + originalArray - Original array to append to
# + return - Merged array
// Note: This preserves order with original elements first, then updates elements
isolated function deepMergeArrayByAppend(json[] originalArray, json[] updatesArray) returns json[] {
    // Just append arrays
    json[] combinedArray = [...originalArray, ...updatesArray];
    return combinedArray;
}

# Description.
# Helper function to clean merge keys by removing extra quotes from TOML parsing
#
# + rawKeys - The raw merge keys map from configuration
# + return - Cleaned merge keys map without extra quotes
isolated function cleanMergeKeys(map<string[]> rawKeys) returns map<string[]> {
    map<string[]> cleanedKeys = {};

    foreach var [keyPath, keyFields] in rawKeys.entries() {
        string cleanedKeyPath = keyPath;

        // Remove extra quotes if they exist at the beginning and end
        if cleanedKeyPath.startsWith("\"") && cleanedKeyPath.endsWith("\"") && cleanedKeyPath.length() > 1 {
            cleanedKeyPath = cleanedKeyPath.substring(1, cleanedKeyPath.length() - 1);
        }
        cleanedKeys[cleanedKeyPath] = keyFields;
    }
    return cleanedKeys;
}
