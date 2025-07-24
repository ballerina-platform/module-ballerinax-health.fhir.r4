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

import ballerina/lang.'int as langint;
import ballerina/lang.regexp;
import ballerina/log;

# Retrieve FhirPath values.
#
# + fhirResource - requested fhir resource
# + fhirPathExpression - requested fhirpath expression
# + return - result of the fhirpath expression
public isolated function retrieveFhirPathValues(json fhirResource, string fhirPathExpression) returns json|error {
    // Input validation
    if fhirPathExpression.trim().length() == 0 {
        return createFhirPathError("FhirPath expression cannot be empty", fhirPathExpression);
    }

    if !(fhirResource is map<json>) {
        return createFhirPathError("FHIR resource must be a JSON object", fhirPathExpression);
    }

    map<json> resourceMap = <map<json>>fhirResource;

    // Extract resource type efficiently
    int? dotIndex = fhirPathExpression.indexOf(DOT_SEPARATOR);
    if dotIndex is () {
        return createFhirPathError("Invalid FhirPath expression format", fhirPathExpression);
    }

    string resourceType = fhirPathExpression.substring(0, dotIndex);

    // Validate resource type match
    json resourceTypeValue = resourceMap["resourceType"];
    if !(resourceTypeValue is string) || resourceType != resourceTypeValue {
        log:printDebug("ResourceType mismatch", expected = resourceType, actual = resourceTypeValue);
        return createFhirPathError(RESOURCE_TYPE_MISMATCH_MSG, fhirPathExpression);
    }

    // Parse tokens once
    Token[]|error tokenRecords = getTokens(fhirPathExpression);
    if tokenRecords is error {
        log:printDebug("Token parsing failed", fhirPath = fhirPathExpression);
        return tokenRecords;
    }

    // Use recursive evaluation
    json|error evaluationResult = evaluateRecursively(fhirResource, tokenRecords, 0);
    if evaluationResult is error {
        return evaluationResult;
    }

    return formatReturnValue(evaluationResult);
}

# Optimize the return value based on type and content
#
# + result - The evaluation result
# + return - Optimized result
isolated function formatReturnValue(json result) returns json {
    if result is json[] {
        return result;
    }
    return [result];
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

    return token is ArrayAccessToken ?
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
isolated function evaluateArrayAccessToken(json current, ArrayAccessToken token, Token[] tokens, int tokenIndex, boolean isLastToken) returns json|error {
    if !(current is map<json>) {
        return createFhirPathError(INVALID_FHIRPATH_MSG, "");
    }

    map<json> currentMap = <map<json>>current;
    string key = token.value;
    int idx = token.index;

    if !currentMap.hasKey(key) {
        return createFhirPathError(INVALID_FHIRPATH_MSG, "");
    }

    json fieldValue = currentMap[key];
    if !(fieldValue is json[]) {
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
    if !(current is map<json>) {
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
public isolated function selectResourceElements(string[] fhirPaths, map<json> fhirResource) returns map<anydata>|error {
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

    return <ArrayAccessToken>{index: valueNum, value: arrayTokenName};
}
