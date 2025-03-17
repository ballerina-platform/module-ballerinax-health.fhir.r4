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
import ballerina/lang.value;
import ballerina/log;
import ballerina/url;
import ballerina/uuid;

# Get the FHIR context from the HTTP request context.
#
# + httpCtx - HTTP request context
# + return - FHIR context or error
public isolated function getFHIRContext(http:RequestContext httpCtx) returns FHIRContext|FHIRError {
    if httpCtx.hasKey(FHIR_CONTEXT_PROP_NAME) {
        value:Cloneable|object {} fhirCtx = httpCtx.get(FHIR_CONTEXT_PROP_NAME);
        if fhirCtx is FHIRContext {
            return fhirCtx;
        }
    }
    string diag = "Unable to find FHIR context in HTTP request context.";
    return createInternalFHIRError("FHIR Context not found", FATAL, PROCESSING_NOT_FOUND, diagnostic = diag);
}

# Get request resource entity from the FHIR context.
#
# + ctx - HTTP request context
# + return - FHIR resource entity or error
public isolated function getRequestResourceEntity(http:RequestContext ctx) returns FHIRResourceEntity|FHIRError {

    FHIRContext fhirCtx = check getFHIRContext(ctx);
    FHIRRequest? request = fhirCtx.getFHIRRequest();
    if request is FHIRRequest {
        FHIRResourceEntity? resourceEntity = request.getResourceEntity();
        if resourceEntity is FHIRResourceEntity {
            return resourceEntity;
        }
    }
    return createFHIRError("FHIR Request payload not found", ERROR, PROCESSING_NOT_FOUND);
}

public isolated function getResourceDefinition(typedesc resourceType) returns ResourceDefinitionRecord|FHIRTypeError {
    ResourceDefinitionRecord? def = resourceType.@ResourceDefinition;
    if def != () {
        return def;
    } else {
        string message = "Provided type does not represent a FHIR resource";
        string diagnostic = string `Unable to find resource definition of given resource of type : ${resourceType.toBalString()}`;
        return <FHIRTypeError>createInternalFHIRError(message, FATAL, PROCESSING, diagnostic = diagnostic);
    }
}

# Utility function to create request search parameter record.
#
# + name - name of the search parameter
# + paramType - Search parameter type
# + originalValue - Original incoming search parameter value
# + typedValue - Typed (parsed/decoded) search parameter record
# + return - Created RequestSearchParameter
isolated function createSearchParameterWrapper(string & readonly name, FHIRSearchParameterType & readonly paramType,
        string & readonly originalValue, FHIRTypedSearchParameter & readonly typedValue)
                                                                                        returns RequestSearchParameter {
    RequestSearchParameter searchParam = {
        'type: paramType,
        name: name,
        value: originalValue,
        typedValue: typedValue
    };
    return searchParam;
}

public isolated function handleErrorResponse(error errorResponse) returns OperationOutcome {
    string errorUUID;
    if errorResponse is FHIRError {
        FHIRErrorDetail & readonly detail = errorResponse.detail();
        if (!detail.internalError) {
            return errorToOperationOutcome(errorResponse);
        } else {
            //TODO log the error if it is an internal error
            errorUUID = errorResponse.detail().uuid;
            log:printError(string `${errorUUID} : ${errorResponse.message()}`, errorResponse, errorResponse.stackTrace());
        }
    } else {
        // TODO log the error since it is not an FHIR related error
        errorUUID = uuid:createType1AsString();
        log:printError(string `${errorUUID} : ${errorResponse.message()}`, errorResponse, errorResponse.stackTrace());
    }
    OperationOutcome opOutcome = {
        issue: [
            {
                severity: ERROR,
                code: SECURITY_UNKNOWN,
                diagnostics: errorUUID
            }
        ]
    };
    return opOutcome;
}

public isolated function getErrorCode(error errorResponse) returns int {
    if errorResponse is FHIRError {
        FHIRErrorDetail & readonly detail = errorResponse.detail();
        if (!detail.internalError) {
            return detail.httpStatusCode;
        }
    }
    return 500;
}

# Extract error messages from 4xx errors.
# + requestError - ClientRequestError.
# + return - Error message.
public isolated function getErrorMessage(http:ClientRequestError requestError) returns string {
    string errorMsg;
    error|record {
        string message;
    } body = requestError.detail().body.ensureType();
    if (body is error) {
        // unable to extract the error message from the response body
        // hence use the error message set to the ClientRequestError
        errorMsg = requestError.message();
    } else {
        // set the detailed error message from the response body
        errorMsg = body.message;
    }
    return errorMsg;
}

# Convert a http client error to a FHIR error.
#
# + clientError - http:ClientError.
# + return - Return a FHIR error.
public isolated function clientErrorToFhirError(http:ClientError clientError) returns FHIRError {
    if (clientError is http:ClientRequestError) {
        // handle 4xx errors
        string errorMsg = getErrorMessage(clientError);
        return createFHIRError(errorMsg, CODE_SEVERITY_ERROR, TRANSIENT_EXCEPTION,
                httpStatusCode = clientError.detail().statusCode);
    }
    else {
        // handle other errors
        return createFHIRError(clientError.message(), CODE_SEVERITY_ERROR,
                TRANSIENT_EXCEPTION, httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
    }
}

# Create a FHIR Bundle.
#
# + t - a BundleType.
# + resources - array of FHIR resources.
# + return - Return a FHIR Bundle.
public isolated function createFhirBundle(BundleType t, DomainResource[] resources) returns Bundle {
    Bundle bundle = {
        'type: t
    };
    BundleEntry[] entry = [];
    foreach var res in resources {
        entry.push({
            'resource: res
        });
    }
    bundle.entry = entry;
    return bundle;
}

public isolated function urlEncodeFhirSearchParameters(map<RequestSearchParameter[] & readonly> & readonly params)
        returns string|FHIRError {
    string|error encoded = url:encode(params.toJsonString(), "UTF-8");
    if (encoded is error) {
        string errorMsg = "Error occurred while encoding the search parameters.";
        log:printError(errorMsg, 'error = encoded);
        return createFHIRError(errorMsg, CODE_SEVERITY_FATAL, INVALID, httpStatusCode = http:STATUS_BAD_REQUEST);
    }
    return encoded;
}

public isolated function decodeFhirSearchParameters(string urlEncodedParams)
        returns map<RequestSearchParameter[] & readonly>|FHIRError {
    string|error paramsDecoded = url:decode(urlEncodedParams, "UTF-8");
    if (paramsDecoded is error) {
        string errorMsg = "Error occurred while decoding the search parameters.";
        log:printError(errorMsg, 'error = paramsDecoded);
        return createFHIRError(errorMsg, CODE_SEVERITY_FATAL, INVALID, httpStatusCode = http:STATUS_BAD_REQUEST);
    }
    map<RequestSearchParameter[] & readonly>|error arr = paramsDecoded.fromJsonStringWithType();
    if (arr is error) {
        string errorMsg = "Error occurred while decoding the search parameters to an array.";
        log:printError(errorMsg, 'error = arr);
        return createFHIRError(errorMsg, CODE_SEVERITY_FATAL, INVALID, httpStatusCode = http:STATUS_BAD_REQUEST);
    }
    return arr;
}

# Maps a given FHIR primitive type to a corresponding FHIR search parameter type.
#
# + primitiveType - The FHIR primitive type to be mapped
# + return - The corresponding FHIR search parameter type or a `FHIRError` if the primitive type does not 
# correspond to a search parameter type
public isolated function primitiveTypeToSearchParamType(string primitiveType) returns FHIRSearchParameterType|FHIRError {
    match primitiveType {
        "base64Binary"|"boolean"|"code" => {
            return TOKEN;
        }
        "canonical" => {
            return REFERENCE;
        }
        "date"|"dateTime" => {
            return DATE;
        }
        "id"|"instant" => {
            return TOKEN;
        }
        "decimal"|"integer"|"positiveInt"|"unsignedInteger" => {
            return NUMBER;
        }
        "string" => {
            return STRING;
        }
        "oid"|"uri"|"url"|"uuid" => {
            return URI;
        }
        _ => {
            string msg = "FHIR primitive type \"" + primitiveType + "\" does not correspond to a recognized "
            + "FHIR search parameter type.";
            return createFHIRError(msg, ERROR, PROCESSING);
        }
    }
}
