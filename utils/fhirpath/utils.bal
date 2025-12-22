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

import ballerina/lang.regexp;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.validator;

const BRACKET_END = "]";
const BRACKET_START = "[";
const DOT_SEPARATOR = ".";
const INVALID_CHARACTER_MSG = "The given FhirPath expression is incorrect as it contains invalid " +
"character instead of a number for array access";
const INVALID_FHIRPATH_MSG = "The given FhirPath expression is incorrect for the given FHIR resource";
const ARRAY_INDEX_ERROR_MSG = "The given array index is incorrect for the given FHIR resource";

# Basic token type.
#
# + value - value of the token
type Token record {
    string value;
};

# Sub type of token for array access tokens.
#
# + index - index of the array element
type ArrayToken record {
    *Token;
    int index;
};

# Validate a FHIR path expression for syntax correctness using regex.
#
# + fhirPathExpression - The FHIR path expression to validate
# + return - True if the path is valid, false otherwise
isolated function validateFhirPath(string fhirPathExpression) returns boolean {
    // Check if expression is empty or only whitespace
    if fhirPathExpression.trim().length() == 0 {
        return false;
    }

    // Comprehensive regex pattern for FHIR path validation
    // Pattern breakdown:
    // ^[A-Za-z][A-Za-z0-9_]*(\[[0-9]+\])?  - Resource type (starts with letter, followed by alphanumeric/underscore) or field name with optional array access
    // (\.[A-Za-z][A-Za-z0-9_]* - Field names (dot followed by identifier)
    // (\[[0-9]+\])?)*         - Optional array access with numeric index
    // $                       - End of string
    string:RegExp fhirPathPattern = re `^[A-Za-z][A-Za-z0-9_]*(\[[0-9]+\])?(\.[A-Za-z][A-Za-z0-9_]*(\[[0-9]+\])?)*$`;

    return fhirPathPattern.isFullMatch(fhirPathExpression);
}

# Validate a FHIR resource for syntax correctness.
#
# + fhirResource - The FHIR resource to validate
# + return - True if the resource is valid, false otherwise
isolated function validateFhirResource(json fhirResource) returns FHIRPathError? {
    r4:FHIRValidationError? validateFHIRResourceJson = validator:validate(fhirResource);

    if validateFHIRResourceJson is r4:FHIRValidationError {
        return error("Invalid FHIR resource");
    }
}

# Tokenize the fhirpath expression based on the token types.
#
# + fhirResource - Input FHIR resource
# + fhirPathExpression - requested fhirpath expression
# + return - Token Array
isolated function getTokens(json fhirResource, string fhirPathExpression) returns Token[]|error {
    string[] tokens = regexp:split(re `\.`, fhirPathExpression);
    int tokensLength = tokens.length();
    Token[] tokenRecordArray = [];

    // Pre-allocate array size for better performance
    // Start from index 1 to skip the resource type (e.g., "Patient" in "Patient.name.given")
    // Only process field access tokens after the resource type
    int startIndex = 0;
    json|error resourceTypeValue = fhirResource.resourceType;
    if resourceTypeValue !is error {
        if tokens[0] === resourceTypeValue.toString() {
            startIndex = 1;
        }
    }
    foreach int i in startIndex ..< tokensLength {
        string tokenStr = tokens[i];
        Token|error tokenResult = parseToken(tokenStr);

        if tokenResult is error {
            return tokenResult;
        }

        tokenRecordArray[tokenRecordArray.length()] = tokenResult;
    }

    return tokenRecordArray;
}

# FHIRPathError is the error object that is returned when an error occurs during the evaluation of a FHIRPath expression.
public type FHIRPathError distinct error;

# Method to create a FHIRPathError
#
# + errorMsg - the reason for the occurence of error
# + fhirPath - the fhirpath expression that is being evaluated
# + return - the error object
isolated function createFhirPathError(string errorMsg, string? fhirPath) returns FHIRPathError {
    FHIRPathError fhirPathError = error(errorMsg, fhirPath = fhirPath);
    return fhirPathError;
}

# Function to modify the value at the path
public type ModificationFunction isolated function (json param) returns json|error;

# Get the modified value by applying either a modification function or setting a new value.
#
# + currentValue - The current value at the FHIRPath location
# + modificationFunction - Optional function to transform the current value
# + newValue - Optional new value to set directly
# + return - The modified value or an error if modification function fails
isolated function getModifiedValue(json currentValue, ModificationFunction? modificationFunction, json? newValue) returns json|error {
    if currentValue !is () && modificationFunction !is () {
        // Apply modification function if provided and return result
        return modificationFunction(currentValue);
    }
    if newValue !is () {
        return newValue;
    }
    return currentValue;
}
