// Copyright (c) 2023-2025, WSO2 LLC. (http://www.wso2.com).

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

# Set the values of matching FHIR paths in the JSON resource.
#
# + fhirResource - The JSON FHIR resource to update
# + fhirPathExpression - The FHIR path (dot notation, e.g., "Patient.name[0].family")
# + newValue - The value to set at the path
# + allowPathCreation - Whether to create missing paths (defaults to configurable value)
# + return - The updated JSON resource or error
public isolated function setFhirPathValues(json fhirResource, string fhirPathExpression, json newValue, boolean allowPathCreation = createMissingPaths) returns json|error {
    // Input validation
    if fhirPathExpression.trim().length() == 0 {
        return createFhirPathError("FhirPath expression cannot be empty", fhirPathExpression);
    }

    Token[]|error tokenRecords = getTokens(fhirPathExpression);
    if tokenRecords is error {
        return tokenRecords;
    }

    return setValueRecursively(fhirResource, tokenRecords, 0, newValue, allowPathCreation);
}

# Recursively set value at the given path, handling nested arrays.
#
# + current - Current JSON node being processed
# + tokens - Array of tokens representing the path
# + tokenIndex - Current token index being processed
# + value - The value to set
# + allowPathCreation - Whether to create missing paths
# + return - Updated JSON or error
isolated function setValueRecursively(json current, Token[] tokens, int tokenIndex, json value, boolean allowPathCreation) returns json|error {
    int tokensLength = tokens.length();
    if tokenIndex >= tokensLength {
        return current;
    }

    Token token = tokens[tokenIndex];
    boolean isLastToken = tokenIndex == tokensLength - 1;

    return token is arrayAccessToken ?
        handleArrayAccessToken(current, token, tokens, tokenIndex, value, isLastToken, allowPathCreation) :
        handleRegularToken(current, token, tokens, tokenIndex, value, isLastToken, allowPathCreation);
}

# Handle array access token processing.
#
# + current - Current JSON node
# + token - Array access token
# + tokens - All tokens
# + tokenIndex - Current token index
# + value - Value to set
# + isLastToken - Whether this is the last token
# + allowPathCreation - Whether to create missing paths
# + return - Updated JSON or error
isolated function handleArrayAccessToken(json current, arrayAccessToken token, Token[] tokens, int tokenIndex, json value, boolean isLastToken, boolean allowPathCreation) returns json|error {
    if !(current is map<json>) {
        return current;
    }

    map<json> currentMap = <map<json>>current;
    string key = token.value;
    int idx = token.index;

    // Handle missing key
    if !currentMap.hasKey(key) {
        if !allowPathCreation {
            return current;
        }
        currentMap[key] = [];
    }

    json fieldValue = currentMap[key];
    if !(fieldValue is json[]) {
        if !allowPathCreation {
            return current;
        }
        fieldValue = [];
        currentMap[key] = fieldValue;
    }

    json[] arr = <json[]>fieldValue;

    // Expand array if needed
    if !expandArrayIfNeeded(arr, idx, allowPathCreation) {
        return current;
    }

    currentMap[key] = arr;

    if isLastToken {
        arr[idx] = value;
    } else {
        json|error updatedElement = setValueRecursively(arr[idx], tokens, tokenIndex + 1, value, allowPathCreation);
        if updatedElement is error {
            return updatedElement;
        }
        arr[idx] = updatedElement;
    }

    return current;
}

# Expand array to required size
#
# + arr - Array to expand
# + requiredIndex - Required index
# + allowPathCreation - Whether creation is allowed
# + return - Whether expansion was successful
isolated function expandArrayIfNeeded(json[] arr, int requiredIndex, boolean allowPathCreation) returns boolean {
    int currentLength = arr.length();
    if currentLength > requiredIndex {
        return true;
    }

    if !allowPathCreation {
        return false;
    }

    // Expand array efficiently
    foreach int i in currentLength ... requiredIndex {
        arr[arr.length()] = {};
    }

    return true;
}

# Handle regular token processing.
#
# + current - Current JSON node
# + token - Regular token
# + tokens - All tokens
# + tokenIndex - Current token index
# + value - Value to set
# + isLastToken - Whether this is the last token
# + allowPathCreation - Whether to create missing paths
# + return - Updated JSON or error
isolated function handleRegularToken(json current, Token token, Token[] tokens, int tokenIndex, json value, boolean isLastToken, boolean allowPathCreation) returns json|error {
    if !(current is map<json>) {
        return current;
    }

    map<json> currentMap = <map<json>>current;
    string key = token.value;

    if currentMap[key] is json[] {
        return handleArrayField(currentMap, key, tokens, tokenIndex, value, isLastToken, allowPathCreation);
    }

    return handleObjectField(currentMap, key, tokens, tokenIndex, value, isLastToken, allowPathCreation);
}

# Handle array field processing
#
# + currentMap - Current map
# + key - Field key
# + tokens - All tokens
# + tokenIndex - Current token index
# + value - Value to set
# + isLastToken - Whether this is the last token
# + allowPathCreation - Whether to create missing paths
# + return - Updated JSON or error
isolated function handleArrayField(map<json> currentMap, string key, Token[] tokens, int tokenIndex, json value, boolean isLastToken, boolean allowPathCreation) returns json|error {
    json[] arr = <json[]>currentMap[key];

    if isLastToken {
        currentMap[key] = value;
        return currentMap;
    }

    // Process each array element
    int arrayLength = arr.length();
    foreach int j in 0 ..< arrayLength {
        json|error updatedElement = processArrayElement(arr[j], tokens, tokenIndex, value, allowPathCreation);
        if updatedElement is error {
            return updatedElement;
        }
        arr[j] = updatedElement;
    }

    return currentMap;
}

# Process individual array element
#
# + element - Array element
# + tokens - All tokens
# + tokenIndex - Current token index
# + value - Value to set
# + allowPathCreation - Whether to create missing paths
# + return - Updated element or error
isolated function processArrayElement(json element, Token[] tokens, int tokenIndex, json value, boolean allowPathCreation) returns json|error {
    if element is map<json> {
        return setValueRecursively(element, tokens, tokenIndex + 1, value, allowPathCreation);
    }

    if !allowPathCreation {
        return element;
    }

    // Create new map structure
    map<json> newElement = {};
    return setValueRecursively(newElement, tokens, tokenIndex + 1, value, allowPathCreation);
}

# Handle object field processing
#
# + currentMap - Current map
# + key - Field key
# + tokens - All tokens
# + tokenIndex - Current token index
# + value - Value to set
# + isLastToken - Whether this is the last token
# + allowPathCreation - Whether to create missing paths
# + return - Updated JSON or error
isolated function handleObjectField(map<json> currentMap, string key, Token[] tokens, int tokenIndex, json value, boolean isLastToken, boolean allowPathCreation) returns json|error {
    if isLastToken {
        if currentMap.hasKey(key) || allowPathCreation {
            currentMap[key] = value;
        }
        return currentMap;
    }

    // Handle missing or invalid field
    if !currentMap.hasKey(key) {
        if !allowPathCreation {
            return currentMap;
        }
        currentMap[key] = {};
    } else if !(currentMap[key] is map<json>) {
        if !allowPathCreation {
            return currentMap;
        }
        currentMap[key] = {};
    }

    json|error updatedChild = setValueRecursively(currentMap[key], tokens, tokenIndex + 1, value, allowPathCreation);
    if updatedChild is error {
        return updatedChild;
    }

    currentMap[key] = updatedChild;
    return currentMap;
}
