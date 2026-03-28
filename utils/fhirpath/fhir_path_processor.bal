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

import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.validator;

// Configurable to control whether input FHIR resource validation should be performed
configurable boolean inputFHIRResourceValidation = false;

// Configurable to control whether output FHIR resource validation should be performed. Used only in setFhirPathValues() function.
configurable boolean outputFHIRResourceValidation = false;

# FhirpathResourceValidationError is the error object that is returned when an error occurs during FHIR resource validation.
public type FhirpathResourceValidationError distinct error;

# Union type for all FHIRPath-related errors
public type FhirpathError FhirpathScannerError|FhirpathParserError|FhirpathInterpreterError|FhirpathResourceValidationError;

# Get values of a FHIR resource using a FHIRPath expression
#
# + fhirResource - Input FHIR resource
# + fhirPathExpression - fhirpath expression to get values from
# + validateInputFHIRResource - whether to validate the input FHIR resource (default = false)
# + return - list of results of the fhirpath expression or FhirpathError (scanner/parser/interpreter/validation errors)
public isolated function getValuesFromFhirPath(json fhirResource, string fhirPathExpression, boolean validateInputFHIRResource = inputFHIRResourceValidation) returns json[]|FhirpathError {
    // Validate input FHIR resource and throw error if invalid
    if validateInputFHIRResource {
        check validateFhirResource(fhirResource);
    }

    if fhirResource !is map<json> {
        return error FhirpathResourceValidationError("FHIR resource must be a JSON object", fhirPath = fhirPathExpression);
    }

    // Scan tokens
    FhirpathScannerError|FhirPathToken[] scanResult = scanTokens(fhirPathExpression);
    if scanResult is FhirpathScannerError {
        return scanResult;
    }
    FhirPathToken[] tokens = scanResult;

    // Parse expression
    FhirpathParserError|Expr? parseResult = parse(tokens);
    if parseResult is FhirpathParserError {
        return parseResult;
    }
    Expr? expr = parseResult;
    if expr is () {
        log:printDebug("Parsing failed", fhirPath = fhirPathExpression);
        return error FhirpathParserError("Failed to parse FHIRPath expression", token = tokens[tokens.length() - 1]);
    }

    // Interpret the expression
    FhirpathInterpreterError|json[] evaluationResult = interpret(expr, fhirResource);
    if evaluationResult is FhirpathInterpreterError {
        return evaluationResult;
    }

    return evaluationResult;
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
        boolean validateInputFHIRResource = inputFHIRResourceValidation, boolean validateOutputFHIRResource = outputFHIRResourceValidation) returns json|FhirpathError {

    json newValue = value is json ? value : ();
    ModificationFunction? modificationFunction = value is ModificationFunction ? value : ();

    // Validate input FHIR resource and throw error if invalid
    if validateInputFHIRResource {
        check validateFhirResource(fhirResource);
    }

    if fhirResource !is map<json> {
        return error FhirpathResourceValidationError("FHIR resource must be a JSON object", fhirPath = fhirPathExpression);
    }

    // Scan tokens
    FhirpathScannerError|FhirPathToken[] scanResult = scanTokens(fhirPathExpression);
    if scanResult is FhirpathScannerError {
        return scanResult;
    }
    FhirPathToken[] tokens = scanResult;

    // Parse expression
    FhirpathParserError|Expr? parseResult = parse(tokens);
    if parseResult is FhirpathParserError {
        return parseResult;
    }
    Expr? expr = parseResult;
    if expr is () {
        log:printDebug("Parsing failed", fhirPath = fhirPathExpression);
        return error FhirpathParserError("Failed to parse FHIRPath expression", token = tokens[tokens.length() - 1]);
    }

    // newValue () is to remove the path
    boolean shouldRemove = newValue is () && modificationFunction is ();

    // Interpret the expression for setting values (path creation is not supported)
    FhirpathInterpreterError|json outcome = interpretSet(expr, fhirResource, newValue, shouldRemove, modificationFunction);
    if outcome is FhirpathInterpreterError {
        return outcome;
    }

    // Validate FHIR resource and throw error if invalid
    if validateOutputFHIRResource {
        FhirpathResourceValidationError? validateFhirResourceResult = validateFhirResource(outcome);
        if validateFhirResourceResult is FhirpathResourceValidationError {
            return error FhirpathResourceValidationError("Created resource is not FHIR compliant", fhirPath = fhirPathExpression);
        }
    }

    return outcome;
}

# Validate a FHIR resource for syntax correctness.
#
# + fhirResource - The FHIR resource to validate
# + return - True if the resource is valid, false otherwise
isolated function validateFhirResource(json fhirResource) returns FhirpathResourceValidationError? {
    r4:FHIRValidationError? validateFHIRResourceJson = validator:validate(fhirResource);

    if validateFHIRResourceJson is r4:FHIRValidationError {
        return error FhirpathResourceValidationError("Invalid FHIR resource", cause = validateFHIRResourceJson);

    }
}
