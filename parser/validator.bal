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

import ballerina/constraint;
import ballerina/http;
import ballerina/lang.regexp;
import ballerina/log;
import ballerinax/health.fhir.r4;

# Record used to store user friendly error messages.
#
# + detailedErrors - User friendly error messages
public type FHIRValidationIssueDetail record {
    *r4:FHIRIssueDetail;
    string[]? detailedErrors = ();
};

# Utility function to create FHIRError for validator.
#
# + message - Message to be added to the error
# + errServerity - serverity of the error
# + code - error code
# + diagnostic - (optional) diagnostic message
# + expression - (optional) FHIR Path expression to the error location
# + cause - (optional) original error
# + errorType - (optional) type of the error
# + httpStatusCode - (optional) [default: 500] HTTP status code to return to the client
# + return - Return Value Description
# + parsedErrors - (optional) usefriendly error messages parsed from original error message
public isolated function createValidationError(string message, r4:Severity errServerity, r4:IssueType code,
        string? diagnostic = (), string[]? expression = (), error? cause = (),
        r4:FHIRErrorTypes? errorType = (), string[]? parsedErrors = (), int httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR)
        returns r4:FHIRError {
    string diagnosticMessage = diagnostic != () ? string `${message} due to ${diagnostic}` : message;
    string[] detailedErrors = parsedErrors != () ? parsedErrors : [diagnosticMessage];
    boolean internal = false;
    FHIRValidationIssueDetail issue = {
        severity: errServerity,
        code: code,
        diagnostic: diagnostic,
        expression: expression,
        details: {
            coding: [
                {
                    system: "http://hl7.org/fhir/issue-type",
                    code: httpStatusCode.toString()
                }
            ],
            text: message
        },
        detailedErrors: detailedErrors
    };
    match errorType {
        r4:VALIDATION_ERROR => {
            r4:FHIRValidationError fError = error(message, cause, issues = [issue], httpStatusCode = httpStatusCode,
                                                        internalError = internal);
            return fError;
        }
        r4:PARSE_ERROR => {
            r4:FHIRParseError fError = error(message, cause, issues = [issue], httpStatusCode = httpStatusCode,
                                                        internalError = internal);
            return fError;
        }
        _ => {
            r4:FHIRError fError = error(message, cause, issues = [issue], httpStatusCode = httpStatusCode,
                                                        internalError = internal);
            return fError;
        }
    }
}

# This method will validate FHIR resource.
# Validation consist of Structure, cardinality, Value domain, Profile, json.
#
# + data - FHIR resource
# + return - If the validation fails, return validation error
public isolated function validate(anydata data) returns r4:FHIRValidationError? {

    if data is r4:DomainResource {
        // Get the types of the FHIR resources, it can be international or any specific FHIR profiles like Uscore
        typedesc<anydata> typeDescOfData = typeof data;

        anydata|constraint:Error validationResult = constraint:validate(data, typeDescOfData);

        if validationResult is constraint:Error {
            log:printDebug(string `Constraint validation failed, ${validationResult.message()}`);
            string[] errors = parseConstraintErrors(validationResult.message());
            return <r4:FHIRValidationError>createValidationError("FHIR resource validation failed", r4:ERROR, r4:INVALID, validationResult.message(),
                    errorType = r4:VALIDATION_ERROR, cause = validationResult, parsedErrors = errors, httpStatusCode = http:STATUS_BAD_REQUEST);
        }

        // terminology validation
        if terminologyValidationEnabled {
            string[]? validationErrors = validateTerminologyData(validationResult);
            if validationErrors is string[] {
                return <r4:FHIRValidationError>createValidationError("FHIR resource validation failed, due to terminology validation failed", r4:ERROR, r4:INVALID, "Terminology validation failed",
                        errorType = r4:VALIDATION_ERROR, parsedErrors = validationErrors, httpStatusCode = http:STATUS_BAD_REQUEST);
            } else {
                log:printDebug("Successfully validated FHIR resource with terminology validation");
            }
        }
    } else {
        return <r4:FHIRValidationError>r4:createFHIRError("FHIR resource validation failed", r4:ERROR, r4:INVALID,
                "Invalid FHIR resource type", errorType = r4:VALIDATION_ERROR, httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}

public isolated function parseConstraintErrors(string message) returns string[] {

    string[] errors = [];

    string:RegExp regex = re `\n`;
    string[] data = regex.split(message);

    foreach var i in 0 ... data.length() - 1 {

        //Parsing for dateTime errors.
        regexp:Groups[] invalidDates = re `\$\.([\w\.\[\]]+):pattern`.findAllGroups(data[i]);
        foreach regexp:Groups result in invalidDates {
            if (result.length() > 1) {
                regexp:Span? value = result[1];
                if value !is () {
                    errors.push(string `Invalid pattern (constraint) for field '${value.substring()}'`);
                }
            }
        }

        //Add parsing logic here for other constraint errors
    }
    return errors;
}
