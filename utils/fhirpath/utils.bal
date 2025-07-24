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

// import ballerina/lang.'int as langint;
import ballerina/lang.regexp;

// import ballerina/log;

const BRACKET_END = "]";
const BRACKET_START = "[";
const DOT_SEPARATOR = ".";
const INVALID_CHARACTER_MSG = "The given FhirPath expression is incorrect as it contains invalid " +
"character instead of a number for array access";
const INVALID_FHIRPATH_MSG = "The given FhirPath expression is incorrect for the given FHIR resource";
const RESOURCE_TYPE_MISMATCH_MSG = "Resource is not match with the FhirPath expression";
const ARRAY_INDEX_ERROR_MSG = "The given array index is incorrect for the given FHIR resource";

// Configurable to control whether missing paths should be created
configurable boolean createMissingPaths = false;

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

# Client record to hold the results of fhirpath evaluation.
#
# + result - Result of the fhirpath expression
# + error - Error message if the result is an error
public type FhirPathResult record {
    json result?;
    FhirPathErrorRecord 'error?;
};

# Record to hold FhirPath request parameters.
#
# + fhirResource - the FHIR Resource which the FhirPath expression is evaluated against
# + fhirPath - the FhirPath expression
public type FhirPathRequest record {|
    json fhirResource;
    string[]|string fhirPath;
|};

# Record to hold FhirPath error Message.
#
# + message - error message
public type FhirPathErrorRecord record {
    string message;
};

# Tokenize the fhirpath expression based on the token types.
#
# + fhirPathExpression - requested fhirpath expression
# + return - Token Array
isolated function getTokens(string fhirPathExpression) returns Token[]|error {
    string[] tokens = regexp:split(re `\.`, fhirPathExpression);
    int tokensLength = tokens.length();
    Token[] tokenRecordArray = [];

    // Pre-allocate array size for better performance
    foreach int i in 1 ..< tokensLength {
        string tokenStr = tokens[i];
        Token|error tokenResult = parseToken(tokenStr);

        if tokenResult is error {
            return tokenResult;
        }

        tokenRecordArray[tokenRecordArray.length()] = tokenResult;
    }

    return tokenRecordArray;
}

# FhirPathError is the error object that is returned when an error occurs during the evaluation of a FHIRPath expression.
public type FHIRPathError distinct error;

# Method to create a FHIRPathError
#
# + errorMsg - the reason for the occurence of error
# + fhirPath - the fhirpath expression that is being evaluated
# + return - the error object
public isolated function createFhirPathError(string errorMsg, string? fhirPath) returns error {
    FHIRPathError fhirPathError = error(errorMsg, fhirpath = fhirPath);
    return fhirPathError;
}
