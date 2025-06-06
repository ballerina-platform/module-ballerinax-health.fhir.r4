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
import ballerina/io;
import ballerina/log;
import ballerinax/health.fhir.r4;

# Response error interceptor to post-process FHIR responses
public isolated service class FHIRResponseInterceptor {
    *http:ResponseInterceptor;

    final r4:ResourceAPIConfig apiConfig;
    private final readonly & map<r4:SearchParamConfig> searchParamConfigMap;
    // All the operations that are active in the API config
    private final readonly & map<r4:OperationConfig> operationConfigMap;
    final readonly & r4:AuditConfig? auditConfig;
    final http:Client|http:ClientError? auditClient;

    public function init(r4:ResourceAPIConfig apiConfig) {
        self.apiConfig = apiConfig;
        self.auditConfig = apiConfig.auditConfig;
        r4:AuditConfig? auditConfig = self.auditConfig;
        if auditConfig != () {
            self.auditClient = new (auditConfig.auditServiceUrl, retryConfig = {
                interval: 5,
                count: 3,
                backOffFactor: 2.0,
                maxWaitInterval: 30
            });
        } else {
            self.auditClient = ();
        }

        map<r4:SearchParamConfig> searchParamConfigs = {};
        // process seach parameters
        foreach r4:SearchParamConfig item in self.apiConfig.searchParameters {
            if item.active {
                searchParamConfigs[item.name] = item;
            }
        }
        self.searchParamConfigMap = searchParamConfigs.cloneReadOnly();

        // Active operations in the API config
        map<r4:OperationConfig> operationConfigs = {};
        foreach r4:OperationConfig operationConfig in self.apiConfig.operations {
            if operationConfig.active {
                operationConfigs[operationConfig.name] = operationConfig;
            }
        }
        self.operationConfigMap = operationConfigs.cloneReadOnly();
    }

    remote isolated function interceptResponse(http:RequestContext ctx, http:Response res) returns http:NextService|r4:FHIRError? {
        log:printDebug("Execute: FHIR Response Interceptor");
        final r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
        fhirContext.setDirection(r4:OUT);

        check self.postProcessSearchParameters(fhirContext);
        check self.postProcessOperation(fhirContext);

        // set the content type to fhir+json if the response is a json payload
        if res.getJsonPayload() is json {
            error? setType = res.setContentType(r4:FHIR_MIME_TYPE_JSON);
            if setType is error {
                // ignore since the content type is set internally and not by a client
            }
        }

        // set the location header if available
        anydata? location = fhirContext.getProperty(r4:LOCATION_HEADER_PROP_NAME);
        if location is string {
            res.setHeader(LOCATION_HEADER, location);
        }

        // Set custom headers and status code from the FHIR context(If available)
        r4:HTTPResponse? httpResponse = fhirContext.getHTTPResponse();
        if httpResponse != () {
            log:printDebug("Setting response status code and headers from the FHIR context.");
            // set the response status code
            if httpResponse.statusCode is int {
                res.statusCode = <int> httpResponse.statusCode;
            }
            // set the response headers
            foreach string headerName in httpResponse.headers.keys() {
                log:printDebug(string `Setting header: ${headerName}`);

                string? headerValue = httpResponse.headers[headerName];
                if headerValue != () {
                    res.setHeader(headerName, headerValue);
                }
                
            }
        }

        if fhirContext.isInErrorState() {
            // set the proper response code
            res.statusCode = fhirContext.getErrorCode();
        }

        // Worker to send the audit events asynchronously
        worker auditWorker {
            r4:AuditConfig? auditConfig = self.auditConfig;
            if auditConfig != () && auditConfig.enabled {
                http:Client|http:ClientError? auditClient = self.auditClient;

                if auditClient is () || auditClient is http:ClientError {
                    // TODO temporary adding the println as errors are not logged by ballerina log module.
                    io:println(self.auditClient);
                    log:printError("[Audit Event Sender] Failed to establish a connection to audit service.", auditClient);
                } else {
                    // send to the audit service and retries if it fails
                    r4:AuditEventSendingError? failed = r4:handleAuditEvent(auditClient, fhirContext);
                    if failed != () && failed.fhirError != () {
                        // if sending the audit event is still fails, log the error and the audit event
                        log:printError("[Audit Event Sender] Error while sending audit event.", 'error = failed.fhirError, auditEvent = failed.auditEvent);
                    }
                }
            }
        }
        return getNextService(ctx);
    }

    isolated function postProcessSearchParameters(r4:FHIRContext context) returns r4:FHIRError? {
        map<r4:RequestSearchParameter[]> & readonly searchParameters = context.getRequestSearchParameters();

        foreach string paramName in searchParameters.keys() {
            r4:RequestSearchParameter[] searchParams = searchParameters.get(paramName);
            foreach r4:RequestSearchParameter searchParam in searchParams {
                if self.searchParamConfigMap.hasKey(paramName) {
                    r4:SearchParamConfig & readonly paramConfig = self.searchParamConfigMap.get(paramName);
                    r4:SearchParameterPostProcessor? postProcessor = paramConfig.postProcessor;
                    if postProcessor != () {
                        r4:FHIRSearchParameterDefinition? definition = r4:fhirRegistry.getResourceSearchParameterByName(self.apiConfig.resourceType, paramName);
                        if definition != () {
                            check postProcessor(definition, searchParam, context);
                        }
                    }
                } else if r4:COMMON_SEARCH_PARAMETERS.hasKey(paramName) {
                    // post process common search parameter
                    r4:CommonSearchParameterDefinition & readonly definition = r4:COMMON_SEARCH_PARAMETERS.get(paramName);
                    r4:CommonSearchParameterPostProcessor? & readonly postProcessor = definition.postProcessor;
                    if postProcessor != () {
                        check postProcessor(definition, searchParam, context);
                    }
                }
            }
        }
    }

    # Post-processes a FHIR operation.
    #
    # + context - The FHIR context.
    # + return - A `r4:FHIRError` if an error occurs during post-processing, nil otherwise.
    isolated function postProcessOperation(r4:FHIRContext context) returns r4:FHIRError? {
        r4:FHIRInteraction interaction = context.getInteraction();
        if interaction is r4:FHIROperationInteraction {
            string operation = interaction.operation;
            if self.operationConfigMap.hasKey(operation) {
                r4:OperationConfig & readonly operationConfig = self.operationConfigMap.get(operation);
                r4:OperationPostProcessor? postProcessor = operationConfig.postProcessor;
                if postProcessor != () {
                    r4:FHIROperationDefinition? operationDefinition =
                            r4:fhirRegistry.getResourceOperationByName(self.apiConfig.resourceType, operation);
                    // Could be a base operation overridden in the API config
                    if operationDefinition == () && r4:BASE_RESOURCE_OPERATIONS.hasKey(operation) {
                        operationDefinition = r4:BASE_RESOURCE_OPERATIONS.get(operation);
                    }
                    if operationDefinition != () {
                        check postProcessor(operationDefinition, context);
                    }
                }
            }
        }
    }
}

# Response error interceptor to handle errors thrown by fhir preproccessors
public isolated service class FHIRResponseErrorInterceptor {
    *http:ResponseErrorInterceptor;

    isolated remote function interceptResponseError(error err) returns http:NotFound|http:BadRequest|http:UnsupportedMediaType
            |http:NotAcceptable|http:Unauthorized|http:NotImplemented|http:MethodNotAllowed|http:InternalServerError|http:PreconditionFailed|http:Ok {
        log:printDebug("Execute: FHIR Response Error Interceptor");
        if err is r4:FHIRError {
            match err.detail().httpStatusCode {
                http:STATUS_NOT_FOUND => {
                    http:NotFound notFound = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return notFound;
                }
                http:STATUS_BAD_REQUEST => {
                    http:BadRequest badRequest = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return badRequest;
                }
                http:STATUS_UNSUPPORTED_MEDIA_TYPE => {
                    http:UnsupportedMediaType unsupportedMediaType = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return unsupportedMediaType;
                }
                http:STATUS_NOT_ACCEPTABLE => {
                    http:NotAcceptable notAcceptable = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return notAcceptable;
                }
                http:STATUS_UNAUTHORIZED => {
                    http:Unauthorized unauthorized = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return unauthorized;
                }
                http:STATUS_NOT_IMPLEMENTED => {
                    http:NotImplemented notImplemented = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return notImplemented;
                }
                http:STATUS_METHOD_NOT_ALLOWED => {
                    http:MethodNotAllowed methodNotAllowed = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return methodNotAllowed;
                }
                http:STATUS_PRECONDITION_FAILED => {
                    http:PreconditionFailed preconditionFailed = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return preconditionFailed;
                }
                http:STATUS_OK => {
                    // This is a special case where the operation is successful but the response is an error.
                    // This can happen in cases like conditional search where the resource already exists.
                    http:Ok response = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return response;
                }
                _ => {
                    http:InternalServerError internalServerError = {
                        body: r4:handleErrorResponse(err),
                        mediaType: r4:FHIR_MIME_TYPE_JSON
                    };
                    return internalServerError;
                }
            }
        }
        http:InternalServerError internalServerError = {
            body: r4:handleErrorResponse(err),
            mediaType: r4:FHIR_MIME_TYPE_JSON
        };
        return internalServerError;
    }
}
