// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

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

const BRACKET_END = "]";
const BRACKET_START = "[";
const INVALID_CHARACTER_MSG = "The given FhirPath expression is incorrect as it contains invalid " +
"character instead of a number for array access";
const INVALID_FHIRPATH_MSG = "The given FhirPath expression is incorrect for the given FHIR resource";

# Evaluate the fhirpath expression.
#
# + fhirResource - requested fhir resource
# + fhirPathExpression - requested fhirpath expression
# + return - result of the fhirpath expression
public isolated function evaluateFhirPath(json fhirResource, string fhirPathExpression) returns string|json|int|float|boolean|byte|error {

    // Set the root result as the first token
    map<json> result = <map<json>>fhirResource;
    string resourceType = fhirPathExpression.substring(0, <int>fhirPathExpression.indexOf("."));
    Token[]|error tokenRecords = getTokens(fhirPathExpression);

    // Check if the expression and the resource are same.
    if resourceType != result["resourceType"] {
        log:printDebug("ResourceType parameter in the resource is not match with the FhirPath expression: " + fhirPathExpression);
        return createFhirPathError("Resource is not match with the FhirPath expression", fhirPathExpression);
    }
    // Iterate through the tokens and updating the results iteratively.
    if tokenRecords is Token[] {
        foreach int i in 0 ..< tokenRecords.length() {
            if tokenRecords[i] is arrayAccessToken {
                string tokenName = tokenRecords[i].value;
                int valueNum = (<arrayAccessToken>tokenRecords[i]).index;
                if !(result[tokenName] is string|int|float|boolean|byte|()) {
                    json[] tempResult = <json[]>result[tokenName];
                    if tempResult.length() > valueNum {
                        json tempArrayResult = tempResult[valueNum].cloneReadOnly();
                        if tempArrayResult is string|int|float|boolean|byte {
                            return tempArrayResult;
                        } else {
                            result = <map<json>>tempArrayResult;
                        }
                    } else {
                        log:printDebug("The given array index should be less than array length", fhirPath = fhirPathExpression);
                        return createFhirPathError("The given array index is incorrect for the given FHIR" +
                    "resource", fhirPathExpression);
                    }
                } else {
                    return createFhirPathError(INVALID_FHIRPATH_MSG, fhirPathExpression);
                }

            } else {
                if !(result[tokenRecords[i].value] is string|int|float|boolean|json[]) {
                    if result.hasKey(tokenRecords[i].value) {
                        result = <map<json>>result[tokenRecords[i].value];
                    } else {
                        return createFhirPathError(INVALID_FHIRPATH_MSG, fhirPathExpression);
                    }
                } else if result[tokenRecords[i].value] is json[] {
                    if i == tokenRecords.length() - 1 {
                        if result.hasKey(tokenRecords[i].value) {
                            return result[tokenRecords[i].value];
                        } else {
                            return createFhirPathError(INVALID_FHIRPATH_MSG, fhirPathExpression);
                        }
                    } else if !(getSubResultForJsonArray(<json[]>result[tokenRecords[i].value], tokenRecords[i + 1]) is error) {
                        return getSubResultForJsonArray(<json[]>result[tokenRecords[i].value], tokenRecords[i + 1]);
                    } else {
                        return createFhirPathError(INVALID_FHIRPATH_MSG, fhirPathExpression);
                    }
                } else {
                    if result.hasKey(tokenRecords[i].value) {
                        if result[tokenRecords[i].value] is string|int|float|boolean|byte {
                            return result[tokenRecords[i].value];
                        } else {
                            result = <map<json>>result[tokenRecords[i].value];
                        }
                    } else {
                        log:printDebug("The given FhirPath expression is incorrect for the resource given", fhirPath = fhirPathExpression);
                        return createFhirPathError(INVALID_FHIRPATH_MSG, fhirPathExpression);
                    }
                }
            }
        }

    } else {
        log:printDebug("Unable to get tokens from the Fhirpath given", fhirPath = fhirPathExpression);
        return createFhirPathError(INVALID_CHARACTER_MSG, fhirPathExpression);
    }
    return result;
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

    foreach string fhirPath in fhirPaths {
        string[] fhirPathTokens = regexp:split(re `\s*\.\s*`, fhirPath.trim());
        string fhirPathResourceType = fhirPathTokens[0];
        if resourceType == fhirPathResourceType {
            map<anydata> parentElement = elementMap;
            foreach int i in 1 ..< fhirPathTokens.length() {
                string childElementName = fhirPathTokens[i];

                if !parentElement.hasKey(childElementName) {
                    parentElement[childElementName] = {};
                }
                parentElement = <map<anydata>>parentElement[childElementName];
            }
        }
    }

    map<json> tempFhirResource = fhirResource.clone();
    traverseAndRemoveElements(elementMap, tempFhirResource);
    map<json> meta = <map<json>>tempFhirResource["meta"];
    meta["tag"] = [{
        "code": "SUBSETTED",
        "display": "Resource subsetted due to _elements search parameter filter"
    }];
    return  tempFhirResource;
}

# Recursively traverse the expected map and remove the elements from the actual map.
# 
# + expectedMap - expected map
# + actualMap - actual map
isolated function traverseAndRemoveElements(map<anydata> expectedMap, map<json> actualMap) {
    foreach [string, json] [elementName, elementValue] in actualMap.entries() {
        if !expectedMap.hasKey(elementName) {
            _ = actualMap.remove(elementName);
        } else {
            if elementValue is json[] {
                json[] elementValueEntries = <json[]>elementValue;
                foreach json elementValueEntryItem in elementValueEntries {
                    map<json> tempActualMap = <map<json>>elementValueEntryItem;
                    map<anydata> tempExpectedMap = <map<anydata>>expectedMap[elementName];
                    if tempActualMap.length() > 0 {
                        traverseAndRemoveElements(tempExpectedMap, tempActualMap);
                    }
                }
            } else {
                if elementValue is string|int|float|boolean|byte {
                    continue;
                }
                map<json> tempActualMap = <map<json>>elementValue;
                map<anydata> tempExpectedMap = <map<anydata>>expectedMap[elementName];
                traverseAndRemoveElements(tempExpectedMap, tempActualMap);
            }
        }
    }
}

# Get the sub result of the particular token from the json array.
#
# + result - sub result of the previous token
# + token - token of the fhirpath expression
# + return - sub result of the particular token
isolated function getSubResultForJsonArray(json[] result, Token token) returns json[]|string|json|error {

    json[] outcome = [];
    boolean validToken = false;
    foreach int j in 0 ..< result.length() {
        json cloneReadOnly = result[j].cloneReadOnly();
        map<json> childFields = <map<json>>cloneReadOnly;
        if token is arrayAccessToken {
            string tokenName = token.value;
            int|error valueNum = token.index;
            if childFields.hasKey(tokenName) {
                json[] tempResult = <json[]>childFields[tokenName];
                if valueNum is int {
                    if tempResult.length() > valueNum {
                        json tempArrayResult = tempResult[valueNum].cloneReadOnly();
                        outcome[outcome.length()] = tempArrayResult;
                    } else {
                        continue;
                    }
                } else {
                    log:printDebug("Only numbers are allowed for array access", tokenName = token);
                    return createFhirPathError(INVALID_CHARACTER_MSG, "");
                }
            }
        } else
            if childFields.hasKey(token.value) {
            validToken = true;
            outcome[outcome.length()] = childFields[token.value];
        } else {
            continue;
        }
    }
    if outcome.length() > 0 {
        if outcome.length() == 1 {
            return <json[]|string|json>outcome[0];
        } else {
            return outcome;
        }
    }
    if !validToken {
        log:printDebug("One of the sub token in the given FhirPath is incorrect", TokenName = token);
        return createFhirPathError(INVALID_CHARACTER_MSG, "");
    }
}

# Basic token type.
#
# + value - value of the token
public type Token record {
    string value;
};

# Sub type of token for array access tokens.
#
# + index - index of the array element
public type arrayAccessToken record {
    *Token;
    int index;
};

# Tokenize the fhirpath expression based on the token types.
#
# + fhirPathExpression - requested fhirpath expression
# + return - Token Array
isolated function getTokens(string fhirPathExpression) returns Token[]|error {

    Token[] tokenRecordArray = [];
    string[] tokens = regexp:split(re `\.`, fhirPathExpression);
    foreach int i in 1 ..< tokens.length() {
        if !(tokens[i].includes(BRACKET_START, 0) || tokens[i].includes(BRACKET_END, 0)) {
            Token st = {value: tokens[i]};
            tokenRecordArray[tokenRecordArray.length()] = st;

        } else {
            string arrayTokenName = tokens[i].substring(0, <int>tokens[i].indexOf(BRACKET_START));
            string value = tokens[i].substring(<int>tokens[i].indexOf(BRACKET_START) + 1, <int>tokens[i].indexOf(BRACKET_END));
            int|error valueNum = langint:fromString(value);
            if valueNum is int {
                arrayAccessToken aat = {index: valueNum, value: arrayTokenName};
                tokenRecordArray[tokenRecordArray.length()] = aat;
            } else {
                log:printDebug("Only numbers are allowed for array access", tokenName = arrayTokenName);
                return createFhirPathError(INVALID_CHARACTER_MSG, fhirPathExpression);
            }
        }
    }
    return tokenRecordArray;
}
