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
import ballerina/log;
import ballerinax/health.fhir.r4;

# Response error interceptor to post-process FHIR responses
public isolated service class FHIRResponseInterceptor {
    *http:ResponseInterceptor;

    final r4:ResourceAPIConfig apiConfig;
    private final readonly & map<r4:SearchParamConfig> searchParamConfigMap;

    public function init(r4:ResourceAPIConfig apiConfig) {
        self.apiConfig = apiConfig;

        map<r4:SearchParamConfig> searchParamConfigs = {};
        // process seach parameters
        foreach r4:SearchParamConfig item in self.apiConfig.searchParameters {
            if item.active {
                searchParamConfigs[item.name] = item;
            }
        }
        self.searchParamConfigMap = searchParamConfigs.cloneReadOnly();
    }

    remote isolated function interceptResponse(http:RequestContext ctx, http:Response res) returns http:NextService|r4:FHIRError? {
        log:printDebug("Execute: FHIR Response Interceptor");
        r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
        fhirContext.setDirection(r4:OUT);

        check self.postProcessSearchParameters(fhirContext);

        // set the content type to fhir+json if the response is a json payload
        if res.getJsonPayload() is json {
            error? setType = res.setContentType(r4:FHIR_MIME_TYPE_JSON);
            if setType is error {
                // ignore since the content type is set internally and not by a client
            }
        }

        if (fhirContext.isInErrorState()) {
            // set the proper response code
            res.statusCode = fhirContext.getErrorCode();
        }

        r4:AuditConfig? & readonly auditConfig = self.apiConfig.auditConfig;
        if auditConfig != () && auditConfig.enabled {
            r4:FHIRError? failed = r4:handleAuditEvent(auditConfig, fhirContext);
            // todo handle properly
            if failed != () {
                log:printError("Error while sending audit event", 'error = failed);
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
}

# Response error interceptor to handle errors thrown by fhir preproccessors
public isolated service class FHIRResponseErrorInterceptor {
    *http:ResponseErrorInterceptor;

    isolated remote function interceptResponseError(error err) returns http:NotFound|http:BadRequest|http:UnsupportedMediaType
                                    |http:NotAcceptable|http:Unauthorized|http:NotImplemented|http:InternalServerError {
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
