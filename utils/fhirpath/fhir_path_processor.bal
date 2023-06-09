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
import ballerina/regex;

const string BRACKET_END = "]";
const string BRACKET_START = "[";
# Evaluate the fhirpath expression.
#
# + fhirResource - requested fhir resource
# + fhirPathExpression - requested fhirpath expression
# + return - result of the fhirpath expression
public isolated function evaluateFhirPath(map<json> fhirResource, string fhirPathExpression) returns string|json|int|float|boolean|byte|error {

    // Set the root result as the first token
    map<json> result = <map<json>>fhirResource.toJson();
    string resourceType = fhirPathExpression.substring(0, <int>fhirPathExpression.indexOf("."));
    Token[]|error tokenRecords = getTokens(fhirPathExpression);

    // Check if the expression and the resource are same.
    if resourceType != fhirResource["resourceType"] {
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
                        return createFhirPathError("The given array index is incorrect for the given FHIR" +
                    "resource", fhirPathExpression);
                    }
                } else {
                    return createFhirPathError("The given FhirPath expression is incorrect for the given FHIR " +
                    "resource", fhirPathExpression);
                }

            } else {
                if !(result[tokenRecords[i].value] is string|int|float|boolean|json[]) {
                    if result.hasKey(tokenRecords[i].value) {
                        result = <map<json>>result[tokenRecords[i].value];
                    } else {
                        return createFhirPathError("The given FhirPath expression is incorrect for the given FHIR " +
                    "resource", fhirPathExpression);
                    }
                } else if result[tokenRecords[i].value] is json[] {
                    if i == tokenRecords.length() - 1 {
                        if result.hasKey(tokenRecords[i].value) {
                            return result[tokenRecords[i].value];
                        } else {
                            return createFhirPathError("The given FhirPath expression is incorrect for the given FHIR " +
                    "resource", fhirPathExpression);
                        }
                    } else if !(getSubResultForJsonArray(<json[]>result[tokenRecords[i].value], tokenRecords[i + 1]) is error) {
                        return getSubResultForJsonArray(<json[]>result[tokenRecords[i].value], tokenRecords[i + 1]);
                    } else {
                        return createFhirPathError("The given FhirPath expression is incorrect for the given FHIR " +
                    "resource", fhirPathExpression);
                    }
                } else {
                    if result.hasKey(tokenRecords[i].value) {
                        if result[tokenRecords[i].value] is string|int|float|boolean|byte {
                            return result[tokenRecords[i].value];
                        } else {
                            result = <map<json>>result[tokenRecords[i].value];
                        }
                    } else {
                        return createFhirPathError("The given FhirPath expression is incorrect for the given FHIR " +
                    "resource", fhirPathExpression);
                    }
                }
            }
        }

    } else {
        return createFhirPathError("The given FhirPath expression is incorrect as it contains english " +
                "letter instead of number for array access", fhirPathExpression);
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
                    return createFhirPathError("The given FhirPath expression is incorrect as it contains english " +
                "letter instead of number for array access", "");
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
        return createFhirPathError("The given FhirPath expression is incorrect as it contains english " +
                "letter instead of number for array access", "");
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
    string[] tokens = regex:split(fhirPathExpression, "\\.");
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
                return createFhirPathError("The given FhirPath expression is incorrect as it contains english " +
                "letter instead of number for array access", fhirPathExpression);
            }

        }
    }
    return tokenRecordArray;
}
