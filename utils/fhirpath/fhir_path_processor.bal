// Copyright (c) 2023 - 2025, WSO2 LLC. (http://www.wso2.com).

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

import ballerina/lang.'int as langint;
import ballerina/lang.regexp;
import ballerina/log;

// Configurable to control whether input FHIR resource validation should be performed
configurable boolean inputFHIRResourceValidation = false;

// Configurable to control whether output FHIR resource validation should be performed. Used only in setFhirPathValues() function.
configurable boolean outputFHIRResourceValidation = false;

// Configurable to control whether missing paths should be created. Used only in setFhirPathValues() function.
configurable boolean createMissingPaths = false;

# Get values of a FHIR resource using a FHIRPath expression
#
# + fhirResource - Input FHIR resource
# + fhirPathExpression - fhirpath expression to get values from
# + validateInputFHIRResource - whether to validate the input FHIR resource (default = false)
# + return - list of results of the fhirpath expression or FHIRPathError
public isolated function getValuesFromFhirPath(json fhirResource, string fhirPathExpression, boolean validateInputFHIRResource = inputFHIRResourceValidation) returns json[]|FHIRPathError {
    // Input FHIR Path validation
    if !validateFhirPath(fhirPathExpression) {
        return createFhirPathError("Invalid FHIR Path expression", fhirPathExpression);
    }

    // Validate input FHIR resource and throw error if invalid
    if validateInputFHIRResource {
        check validateFhirResource(fhirResource);
    }

    if fhirResource !is map<json> {
        return createFhirPathError("FHIR resource must be a JSON object", fhirPathExpression);
    }

    // Parse tokens once
    Token[]|error tokenRecords = getTokens(fhirResource, fhirPathExpression);
    if tokenRecords is error {
        log:printDebug("Token parsing failed", fhirPath = fhirPathExpression);
        return createFhirPathError(tokenRecords.message(), fhirPathExpression);
    }

    // Use recursive evaluation
    json|error evaluationResult = evaluateRecursively(fhirResource, tokenRecords, 0);
    if evaluationResult is error {
        return createFhirPathError(evaluationResult.message(), fhirPathExpression);
    }

    // Format the return value to always return a list of jsons.
    if evaluationResult is json[] {
        return evaluationResult;
    }
    return [evaluationResult];
}

# Updates a FHIR resource at the specified FHIRPath with either a new value or by applying a ModificationFunction
#
# + fhirResource - Input FHIR resource
# + fhirPathExpression - FHIRPath expression to set/modify values
# + value - new value to replace or a function of type ModificationFunction to modify the existing value
# + validateInputFHIRResource - whether to validate the input FHIR resource (default = false)
# + validateOutputFHIRResource - whether to validate the output FHIR resource (default = false)
# + return - Updated FHIR resource or FHIRPathError
public isolated function setValuesToFhirPath(json fhirResource, string fhirPathExpression, json|ModificationFunction value,
        boolean validateInputFHIRResource = inputFHIRResourceValidation, boolean validateOutputFHIRResource = outputFHIRResourceValidation) returns json|FHIRPathError {

    json newValue = value is json ? value : ();
    ModificationFunction? modificationFunction = value is ModificationFunction ? value : ();

    // Input validation
    if !validateFhirPath(fhirPathExpression) {
        return createFhirPathError("Invalid FHIR Path expression", fhirPathExpression);
    }

    // Validate input FHIR resource and throw error if invalid
    if validateInputFHIRResource {
        check validateFhirResource(fhirResource);
    }

    Token[]|error tokenRecords = getTokens(fhirResource, fhirPathExpression);
    if tokenRecords is error {
        return createFhirPathError(tokenRecords.message(), fhirPathExpression);
    }

    // newValue () is to remove the path
    boolean shouldRemove = newValue is () && modificationFunction is ();

    json|error outcome = setValueRecursively(fhirResource, tokenRecords, 0, newValue, createMissingPaths, shouldRemove, modificationFunction);
    if outcome is error {
        return createFhirPathError(outcome.message(), fhirPathExpression);
    }

    // Validate FHIR resource and throw error if invalid
    if validateOutputFHIRResource {
        FHIRPathError? validateFhirResourceResult = validateFhirResource(outcome);
        if validateFhirResourceResult is FHIRPathError {
            return createFhirPathError("Created resource is not FHIR compliant", fhirPathExpression);
        }
    }

    return outcome;
}

# Recursively evaluate FHIRPath expression, handling nested arrays.
#
# + current - Current JSON node being processed
# + tokens - Array of tokens representing the path
# + tokenIndex - Current token index being processed
# + return - Evaluation result or error
isolated function evaluateRecursively(json current, Token[] tokens, int tokenIndex) returns json|error {
    int tokensLength = tokens.length();
    if tokenIndex >= tokensLength {
        return current;
    }

    Token token = tokens[tokenIndex];
    boolean isLastToken = tokenIndex == tokensLength - 1;

    return token is ArrayToken ?
        evaluateArrayAccessToken(current, token, tokens, tokenIndex, isLastToken) :
        evaluateRegularToken(current, token, tokens, tokenIndex, isLastToken);
}

# Handle array access token evaluation.
#
# + current - Current JSON node
# + token - Array access token
# + tokens - All tokens
# + tokenIndex - Current token index
# + isLastToken - Whether this is the last token
# + return - Evaluation result or error
isolated function evaluateArrayAccessToken(json current, ArrayToken token, Token[] tokens, int tokenIndex, boolean isLastToken) returns json|error {
    if current !is map<json> {
        return createFhirPathError(INVALID_FHIRPATH_MSG, "");
    }

    map<json> currentMap = <map<json>>current;
    string key = token.value;
    int idx = token.index;

    if !currentMap.hasKey(key) {
        return createFhirPathError(INVALID_FHIRPATH_MSG, "");
    }

    json fieldValue = currentMap[key];
    if fieldValue !is json[] {
        return createFhirPathError(INVALID_FHIRPATH_MSG, "");
    }

    json[] arr = <json[]>fieldValue;
    int arrayLength = arr.length();
    if arrayLength <= idx {
        return createFhirPathError(ARRAY_INDEX_ERROR_MSG, "");
    }

    json arrayElement = arr[idx];
    return isLastToken ? arrayElement : evaluateRecursively(arrayElement, tokens, tokenIndex + 1);
}

# Handle regular token evaluation.
#
# + current - Current JSON node
# + token - Regular token
# + tokens - All tokens
# + tokenIndex - Current token index
# + isLastToken - Whether this is the last token
# + return - Evaluation result or error
isolated function evaluateRegularToken(json current, Token token, Token[] tokens, int tokenIndex, boolean isLastToken) returns json|error {
    if current !is map<json> {
        return createFhirPathError(INVALID_FHIRPATH_MSG, "");
    }

    map<json> currentMap = <map<json>>current;
    string key = token.value;

    if !currentMap.hasKey(key) {
        return createFhirPathError(INVALID_FHIRPATH_MSG, "");
    }

    json fieldValue = currentMap[key];
    if isLastToken {
        return fieldValue;
    }

    // Handle array processing
    if fieldValue is json[] {
        return processArrayElements(<json[]>fieldValue, tokens, tokenIndex);
    }

    // Continue with single object
    return evaluateRecursively(fieldValue, tokens, tokenIndex + 1);
}

# Process array elements efficiently - Fixed to preserve array structure
#
# + arr - Array to process
# + tokens - All tokens
# + tokenIndex - Current token index
# + return - Processed results or error
isolated function processArrayElements(json[] arr, Token[] tokens, int tokenIndex) returns json[]|error {
    json[] results = [];
    int arrayLength = arr.length();

    foreach int i in 0 ..< arrayLength {
        json|error elementResult = evaluateRecursively(arr[i], tokens, tokenIndex + 1);
        if elementResult is error {
            continue; // Skip failed elements
        }

        // Preserve array structure - don't flatten arrays
        results[results.length()] = elementResult;
    }

    return results.length() > 0 ? results : error(INVALID_FHIRPATH_MSG);
}

# Select the resource elements from the given FHIR resource.
#
# + fhirPaths - FhirPath expressions for the required elements
# + fhirResource - Requested fhir resource
# + return - Returns FHIR resource with the selected elements
isolated function selectResourceElements(string[] fhirPaths, map<json> fhirResource) returns map<anydata>|error {
    string resourceType = check fhirResource["resourceType"].ensureType();

    map<anydata> elementMap = {
        "resourceType": {},
        "meta": {}
    };

    // Process paths efficiently
    foreach string fhirPath in fhirPaths {
        string[] fhirPathTokens = regexp:split(re `\s*\.\s*`, fhirPath.trim());
        if fhirPathTokens.length() == 0 {
            continue;
        }

        string fhirPathResourceType = fhirPathTokens[0];
        if resourceType == fhirPathResourceType {
            buildElementMap(elementMap, fhirPathTokens);
        }
    }

    map<json> tempFhirResource = fhirResource.clone();
    traverseAndRemoveElements(elementMap, tempFhirResource);

    // Add subset tag efficiently
    addSubsetTag(tempFhirResource);
    return tempFhirResource;
}

# Build element map from path tokens
#
# + elementMap - Element map to build
# + pathTokens - Path tokens
isolated function buildElementMap(map<anydata> elementMap, string[] pathTokens) {
    map<anydata> parentElement = elementMap;
    int tokensLength = pathTokens.length();

    foreach int i in 1 ..< tokensLength {
        string childElementName = pathTokens[i];
        if !parentElement.hasKey(childElementName) {
            parentElement[childElementName] = {};
        }
        parentElement = <map<anydata>>parentElement[childElementName];
    }
}

# Add subset tag to resource
#
# + fhirResource - FHIR resource to modify
isolated function addSubsetTag(map<json> fhirResource) {
    map<json> meta = <map<json>>fhirResource["meta"];
    meta["tag"] = [
        {
            "code": "SUBSETTED",
            "display": "Resource subsetted due to _elements search parameter filter"
        }
    ];
}

# Recursively traverse the expected map and remove the elements from the actual map.
#
# + expectedMap - expected map
# + actualMap - actual map
isolated function traverseAndRemoveElements(map<anydata> expectedMap, map<json> actualMap) {
    string[] keysToRemove = [];

    // Collect keys to remove first to avoid concurrent modification
    foreach [string, json] [elementName, elementValue] in actualMap.entries() {
        if !expectedMap.hasKey(elementName) {
            keysToRemove[keysToRemove.length()] = elementName;
        } else {
            processElementValue(expectedMap, actualMap, elementName, elementValue);
        }
    }

    // Remove collected keys
    foreach string key in keysToRemove {
        _ = actualMap.remove(key);
    }
}

# Process individual element value
#
# + expectedMap - Expected map
# + actualMap - Actual map
# + elementName - Element name
# + elementValue - Element value
isolated function processElementValue(map<anydata> expectedMap, map<json> actualMap, string elementName, json elementValue) {
    if elementValue is json[] {
        json[] elementValueEntries = <json[]>elementValue;
        map<anydata> tempExpectedMap = <map<anydata>>expectedMap[elementName];

        foreach json elementValueEntryItem in elementValueEntries {
            if elementValueEntryItem is map<json> {
                map<json> tempActualMap = <map<json>>elementValueEntryItem;
                if tempActualMap.length() > 0 {
                    traverseAndRemoveElements(tempExpectedMap, tempActualMap);
                }
            }
        }
    } else if elementValue is map<json> {
        map<json> tempActualMap = <map<json>>elementValue;
        map<anydata> tempExpectedMap = <map<anydata>>expectedMap[elementName];
        traverseAndRemoveElements(tempExpectedMap, tempActualMap);
    }
    // Skip primitive values
}

# Parse individual token
#
# + tokenStr - Token string to parse
# + return - Parsed token or error
isolated function parseToken(string tokenStr) returns Token|error {
    if !tokenStr.includes(BRACKET_START) {
        return {value: tokenStr};
    }

    int? startIndex = tokenStr.indexOf(BRACKET_START);
    int? endIndex = tokenStr.indexOf(BRACKET_END);

    if startIndex is () || endIndex is () || startIndex >= endIndex {
        return createFhirPathError(INVALID_CHARACTER_MSG, "");
    }

    string arrayTokenName = tokenStr.substring(0, startIndex);
    string indexStr = tokenStr.substring(startIndex + 1, endIndex);

    int|error valueNum = langint:fromString(indexStr);
    if valueNum is error {
        log:printDebug("Invalid array index", tokenName = arrayTokenName, index = indexStr);
        return createFhirPathError(INVALID_CHARACTER_MSG, "");
    }

    return <ArrayToken>{index: valueNum, value: arrayTokenName};
}

# Recursively set value at the given path, handling nested arrays.
#
# + current - Current JSON node being processed
# + tokens - Array of tokens representing the path
# + tokenIndex - Current token index being processed
# + value - The value to set
# + allowPathCreation - Whether to create missing paths
# + shouldRemove - Whether to remove the path instead of setting value
# + modificationFunction - Function to modify the value at the path
# + return - Updated JSON or error
isolated function setValueRecursively(json current, Token[] tokens, int tokenIndex, json value, boolean allowPathCreation, boolean shouldRemove, ModificationFunction? modificationFunction) returns json|error {
    int tokensLength = tokens.length();
    if tokenIndex >= tokensLength {
        return current;
    }

    Token token = tokens[tokenIndex];
    boolean isLastToken = tokenIndex == tokensLength - 1;

    return token is ArrayToken ?
        check handleArrayAccessToken(current, token, tokens, tokenIndex, value, isLastToken, allowPathCreation, shouldRemove, modificationFunction) :
        handleRegularToken(current, token, tokens, tokenIndex, value, isLastToken, allowPathCreation, shouldRemove, modificationFunction);
}

# Handle array access token processing.
#
# + current - Current JSON node
# + token - Array access token
# + tokens - All tokens
# + tokenIndex - Current token index
# + newValue - Value to set
# + isLastToken - Whether this is the last token
# + allowPathCreation - Whether to create missing paths
# + shouldRemove - Whether to remove the path instead of setting value
# + modificationFunction - Function to modify the value at the path
# + return - Updated JSON or error
isolated function handleArrayAccessToken(json current, ArrayToken token, Token[] tokens, int tokenIndex, json newValue, boolean isLastToken, boolean allowPathCreation, boolean shouldRemove, ModificationFunction? modificationFunction) returns json|error {
    if current !is map<json> {
        return current;
    }

    map<json> currentMap = <map<json>>current;
    string key = token.value;
    int idx = token.index;

    // Handle missing key
    if !currentMap.hasKey(key) {
        if shouldRemove || !allowPathCreation {
            return current;
        }
        currentMap[key] = [];
    }

    json fieldValue = currentMap[key];
    if fieldValue !is json[] {
        if shouldRemove || !allowPathCreation {
            return current;
        }
        fieldValue = [];
        currentMap[key] = fieldValue;
    }

    json[] arr = <json[]>fieldValue;

    // Check if index exists for removal
    if shouldRemove && isLastToken {
        if idx < arr.length() {
            // Remove the array element at the specified index
            json[] newArr = [];
            foreach int i in 0 ..< arr.length() {
                if i != idx {
                    newArr[newArr.length()] = arr[i];
                }
            }
            currentMap[key] = newArr;
        }
        return current;
    }

    // Expand array if needed (only when not removing)
    if !shouldRemove && !expandArrayIfNeeded(arr, idx, allowPathCreation) {
        return current;
    }

    // Ensure array is updated in the map
    currentMap[key] = arr;

    if isLastToken {
        if shouldRemove {
            // Remove array element
            if idx < arr.length() {
                json[] newArr = [];
                foreach int i in 0 ..< arr.length() {
                    if i != idx {
                        newArr[newArr.length()] = arr[i];
                    }
                }
                currentMap[key] = newArr;
            }
        } else {
            //  SET
            json modifiedValue = check getModifiedValue(arr[idx], modificationFunction, newValue);
            arr[idx] = modifiedValue;
        }
    } else {
        json|error updatedElement = setValueRecursively(arr[idx], tokens, tokenIndex + 1, newValue, allowPathCreation, shouldRemove, modificationFunction);
        if updatedElement is error {
            return updatedElement;
        }
        //  SET
        // json modifiedValue = check getModifiedValue(arr[idx], modificationFunction, updatedElement);
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
# + shouldRemove - Whether to remove the path instead of setting value
# + modificationFunction - Function to modify the value at the path
# + return - Updated JSON or error
isolated function handleRegularToken(json current, Token token, Token[] tokens, int tokenIndex, json value, boolean isLastToken, boolean allowPathCreation, boolean shouldRemove,
        ModificationFunction? modificationFunction) returns json|error {
    if current !is map<json> {
        return current;
    }

    map<json> currentMap = <map<json>>current;
    string key = token.value;

    if currentMap[key] is json[] {
        return handleArrayField(currentMap, key, tokens, tokenIndex, value, isLastToken, allowPathCreation, shouldRemove, modificationFunction);
    }

    return handleObjectField(currentMap, key, tokens, tokenIndex, value, isLastToken, allowPathCreation, shouldRemove, modificationFunction);
}

# Handle array field processing
#
# + currentMap - Current map
# + key - Field key
# + tokens - All tokens
# + tokenIndex - Current token index
# + newValue - Value to set
# + isLastToken - Whether this is the last token
# + allowPathCreation - Whether to create missing paths
# + shouldRemove - Whether to remove the path instead of setting value
# + modificationFunction - Function to modify the value at the path
# + return - Updated JSON or error
isolated function handleArrayField(map<json> currentMap, string key, Token[] tokens, int tokenIndex, json newValue, boolean isLastToken, boolean allowPathCreation, boolean shouldRemove, ModificationFunction? modificationFunction) returns json|error {
    json[] arr = <json[]>currentMap[key];

    if isLastToken {
        if shouldRemove {
            // Remove the entire array field
            _ = currentMap.remove(key);
        } else {
            //  SET
            json modifiedValue = check getModifiedValue(currentMap[key], modificationFunction, newValue);
            currentMap[key] = modifiedValue;
        }
        return currentMap;
    }

    // Setting multiple elements in an array (Ex: Patient.address.city)
    int arrayLength = arr.length();
    foreach int j in 0 ..< arrayLength {
        json|error updatedElement = processArrayElement(arr[j], tokens, tokenIndex, newValue, allowPathCreation, shouldRemove, modificationFunction);
        if updatedElement is error {
            return updatedElement;
        }
        //  SET
        // json modifiedValue = check getModifiedValue(arr[j], modificationFunction, updatedElement);
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
# + shouldRemove - Whether to remove the path instead of setting value
# + modificationFunction - Function to modify the value at the path
# + return - Updated element or error
isolated function processArrayElement(json element, Token[] tokens, int tokenIndex, json value, boolean allowPathCreation, boolean shouldRemove, ModificationFunction? modificationFunction) returns json|error {
    if element is map<json> {
        return setValueRecursively(element, tokens, tokenIndex + 1, value, allowPathCreation, shouldRemove, modificationFunction);
    }

    if shouldRemove || !allowPathCreation {
        return element;
    }

    // Create new map structure
    map<json> newElement = {};
    return setValueRecursively(newElement, tokens, tokenIndex + 1, value, allowPathCreation, shouldRemove, modificationFunction);
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
# + shouldRemove - Whether to remove the path instead of setting value
# + modificationFunction - Function to modify the value at the path
# + return - Updated JSON or error
isolated function handleObjectField(map<json> currentMap, string key, Token[] tokens, int tokenIndex, json value, boolean isLastToken, boolean allowPathCreation, boolean shouldRemove, ModificationFunction? modificationFunction) returns json|error {
    if isLastToken {
        if shouldRemove {
            // Remove the field completely
            if currentMap.hasKey(key) {
                _ = currentMap.remove(key);
            }
        } else if currentMap.hasKey(key) || allowPathCreation {
            //  SET
            json modifiedValue = check getModifiedValue(currentMap[key], modificationFunction, value);
            currentMap[key] = modifiedValue;
        }
        return currentMap;
    }

    // Handle missing or invalid field
    if !currentMap.hasKey(key) {
        if shouldRemove || !allowPathCreation {
            return currentMap;
        }
        currentMap[key] = {};
    } else if currentMap[key] !is map<json> {
        if shouldRemove || !allowPathCreation {
            return currentMap;
        }
        currentMap[key] = {};
    }

    json|error updatedChild = setValueRecursively(currentMap[key], tokens, tokenIndex + 1, value, allowPathCreation, shouldRemove, modificationFunction);
    if updatedChild is error {
        return updatedChild;
    }

    currentMap[key] = updatedChild;
    return currentMap;
}
