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

import ballerina/http;
import ballerina/uuid;

//public type FHIRErrorType distinct (base:HealthcareError & error<FHIRErrorDetail>);
# FHIR Error type
public type FHIRErrorType distinct (error<FHIRErrorDetail>);

# Base FHIR error type
public type FHIRError distinct FHIRErrorType;

# FHIR validation related error
public type FHIRValidationError FHIRError;

# FHIR validation related error
public type FHIRParseError FHIRError;

# FHIR processing related issue related error
public type FHIRProcessingError FHIRError;

# FHIR serializer error
public type FHIRSerializerError FHIRError;

# FHIR data/resource type related error
public type FHIRTypeError FHIRError;

# Code that describes the type of issue.
public enum IssueType {
    INVALID = "invalid",
    INVALID_STRUCTURE = "structure",
    INVALID_REQUIRED = "required",
    INVALID_VALUE = "value",
    INVALID_INVARIANT = "invariant",
    SECURITY = "security",
    SECURITY_LOGIN = "login",
    SECURITY_UNKNOWN = "unknown",
    SECURITY_EXPIRED = "expired",
    SECURITY_FORBIDDEN = "forbidden",
    SECURITY_SUPPRESSED = "suppressed",
    PROCESSING = "processing",
    PROCESSING_NOT_SUPPORTED = "not-supported",
    PROCESSING_DUPLICATE = "duplicate",
    PROCESSING_MULTIPLE_MATCHES = "multiple-matches",
    PROCESSING_NOT_FOUND = "not-found",
    PROCESSING_NOT_FOUND_DELETED = "deleted",
    PROCESSING_TOO_LONG = "too-long",
    PROCESSING_CODE_INVALID = "code-invalid",
    PROCESSING_EXTENSION = "extension",
    PROCESSING_TOO_COSTLY = "too-costly",
    PROCESSING_BUSINESS_RULE = "business-rule",
    PROCESSING_CONFLICT = "conflict",
    TRANSIENT = "transient",
    TRANSIENT_LOCK_ERROR = "lock-error",
    TRANSIENT_NO_STORE = "no-store",
    TRANSIENT_EXCEPTION = "exception",
    TRANSIENT_TIMEOUT = "timeout",
    TRANSIENT_INCOMPLETE = "incomplete",
    TRANSIENT_THROTTLED = "throttled",
    INFORMATIONAL = "informational"
}

# Level the issue affects the success of the action.
public enum Severity {
    FATAL = "fatal",
    ERROR = "error",
    WARNING = "warning",
    INFORMATION = "information"
}

# FHIR Error types
public enum FHIRErrorTypes {
    VALIDATION_ERROR,
    PROCESSING_ERROR,
    SERIALIZATION_ERROR,
    PARSE_ERROR,
    TYPE_ERROR
}

# FHIR Error Detail structure.
#
# + severity - severity of the issue
# + code - Error or warning code
# + details - Additional details about the error
# + diagnostic - Additional diagnostic information about the issue
# + expression - FHIRPath of element(s) related to issue
public type FHIRIssueDetail record {
    Severity severity;
    IssueType code;
    CodeableConcept? details = ();
    string? diagnostic = ();
    string[]? expression = ();
};

# FHIR error details record.
#
# + issues - FHIR issues
# + internalError - flag to indicate the FHIRError is an internal error
# + httpStatusCode - HTTP status code to return to the client
# + uuid - UUID of the error
public type FHIRErrorDetail record {
    [FHIRIssueDetail, FHIRIssueDetail...] issues;
    boolean internalError = false;
    int httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR;
    string uuid = uuid:createType1AsString();
};

// TODO : Create separate functions to create each error type
# Utility function to create FHIRError.
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
public isolated function createFHIRError(string message, Severity errServerity, IssueType code,
        string? diagnostic = (), string[]? expression = (), error? cause = (),
        FHIRErrorTypes? errorType = (), int httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR)
        returns FHIRError {
    string diagnosticMessage = diagnostic != () ? string `${message} due to ${diagnostic}` : message;
    return createTypedError(diagnosticMessage, errServerity, code, diagnostic, expression, cause, errorType,
            internal = false, httpStatusCode = httpStatusCode);
}

# Utility function to create internal FHIRError.
#
# + message - Message to be added to the error
# + errServerity - serverity of the error
# + code - error code
# + diagnostic - (optional) diagnostic message
# + expression - (optional) FHIR Path expression to the error location
# + cause - (optional) original error
# + errorType - (optional) type of the error
# + return - Created FHIRError error
public isolated function createInternalFHIRError(string message, Severity errServerity, IssueType code,
        string? diagnostic = (), string[]? expression = (), error? cause = (),
        FHIRErrorTypes? errorType = ()) returns FHIRError {

    return createTypedError(message, errServerity, code, diagnostic, expression, cause, errorType, internal = true);
}

isolated function createTypedError(string message, Severity errServerity, IssueType code,
        string? diagnostic = (), string[]? expression = (), error? cause = (),
        FHIRErrorTypes? errorType = (), int httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR,
        boolean internal = false)
                                returns FHIRError {
    FHIRIssueDetail issue = {
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
        }
    };
    match errorType {
        VALIDATION_ERROR => {
            FHIRValidationError fError = error(message, cause, issues = [issue], httpStatusCode = httpStatusCode,
                                                internalError = internal);
            return fError;
        }
        PARSE_ERROR => {
            FHIRParseError fError = error(message, cause, issues = [issue], httpStatusCode = httpStatusCode,
                                                internalError = internal);
            return fError;
        }
        _ => {
            FHIRError fError = error(message, cause, issues = [issue], httpStatusCode = httpStatusCode,
                                                internalError = internal);
            return fError;
        }
    }
}

# Error util function to create FHIR Parser Error from any given FHIR Error.
#
# + fhirError - Source FHIR Error
# + return - Created FHIR Parser Error
public isolated function createParserErrorFrom(FHIRError fhirError) returns FHIRParseError {
    FHIRErrorDetail & readonly detail = fhirError.detail();
    FHIRParseError fError = error(fhirError.message(), fhirError, issues = detail.issues,
                                    httpStatusCode = detail.httpStatusCode, internalError = detail.internalError);
    return fError;
}

# Utility function to create OperationOutcome from FHIRError.
#
# + fhirError - FHIRError to be converted
# + return - created OperationOutcome record
public isolated function errorToOperationOutcome(FHIRError fhirError) returns OperationOutcome {
    FHIRErrorDetail & readonly detail = fhirError.detail();
    [FHIRIssueDetail, FHIRIssueDetail...] & readonly issues = detail.issues;
    [OperationOutcomeIssue, OperationOutcomeIssue...] issueBBEs = [issueDetailToOperationOutcomeIssue(issues[0], detail.uuid)];

    if issues.length() > 1 {
        foreach int i in 1 ... (issues.length() - 1) {
            issueBBEs.push(issueDetailToOperationOutcomeIssue(issues[i], detail.uuid));
        }
    }
    OperationOutcome opOutcome = {
        issue: issueBBEs
    };
    return opOutcome;
}

isolated function issueDetailToOperationOutcomeIssue(FHIRIssueDetail & readonly detail, string uuid) returns OperationOutcomeIssue {

    OperationOutcomeIssue issueBBE = {
        severity: detail.severity,
        code: detail.code
    };

    (CodeableConcept & readonly)? details = detail.details;
    if details != () {
        issueBBE.details = details;
    }

    string? diagnostic = detail.diagnostic;
    if diagnostic != () {
        issueBBE.diagnostics = string `${uuid} : ${diagnostic}`;
    } else {
        issueBBE.diagnostics = uuid;
    }

    string[]? & readonly expression = detail.expression;
    if expression != () {
        issueBBE.expression = expression;
    }

    return issueBBE;
}

isolated function createHttpErrorResponse(FHIRError fhirError) returns http:BadRequest|http:InternalServerError {
    FHIRErrorDetail & readonly detail = fhirError.detail();
    OperationOutcome operationOutcome = errorToOperationOutcome(fhirError);

    match detail.httpStatusCode {
        http:STATUS_BAD_REQUEST => {
            http:BadRequest badRequest = {
                body: operationOutcome
            };
            return badRequest;
        }
        _ => {
            http:InternalServerError internalServerError = {
                body: operationOutcome
            };
            return internalServerError;
        }
    }
}
