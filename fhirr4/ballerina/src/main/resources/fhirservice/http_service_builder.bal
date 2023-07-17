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
import ballerina/regex;
import ballerinax/health.fhir.r4;

// Construct an http service for a fhir service.
isolated function getHttpService(Holder h, r4:ResourceAPIConfig apiConfig) returns http:Service {
    http:InterceptableService httpService = isolated service object {

        private final Holder holder = h;
        private final FHIRPreprocessor preprocessor = new (apiConfig);

        public function createInterceptors() returns [FHIRResponseErrorInterceptor, FHIRResponseInterceptor] {
            return [new FHIRResponseErrorInterceptor(), new FHIRResponseInterceptor(apiConfig)];
        }

        isolated resource function get [string... paths](http:Request req, http:RequestContext ctx) returns anydata|error {

            Service fhirService = self.holder.getFhirServiceFromHolder();
            string path = req.extraPathInfo;
            string[] split = getSplitPath(path);
            handle? resourceMethod = getResourceMethod(fhirService, split, "get");
            if resourceMethod is handle {
                boolean hasPathParam = isHavingPathParam(resourceMethod);
                anydata|error executeResourceResult = ();
                if hasPathParam {
                    r4:FHIRError? processRead = self.preprocessor.processRead(split[split.length() - 2], split[split.length() - 1], req, ctx);
                    if processRead is r4:FHIRError {
                        return processRead;
                    }
                    r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
                    string id = paths[paths.length() - 1];
                    executeResourceResult = executeReadByID(id, fhirContext, fhirService, resourceMethod);
                    if (executeResourceResult is error) {
                        fhirContext.setInErrorState(true);
                        fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                        return r4:handleErrorResponse(executeResourceResult);
                    }

                } else {
                    r4:FHIRError? processSearch = self.preprocessor.processSearch(split[split.length() - 1], req, ctx);
                    if processSearch is r4:FHIRError {
                        return processSearch;
                    }
                    r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
                    executeResourceResult = executeSearch(fhirContext, fhirService, resourceMethod);
                    if (executeResourceResult is error) {
                        fhirContext.setInErrorState(true);
                        fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                        return r4:handleErrorResponse(executeResourceResult);
                    }

                }
                return executeResourceResult;
            } else {
                return r4:createFHIRError(string `Path not found: ${path}`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_NOT_FOUND);
            }
        }

        isolated resource function post [string... paths](http:Request req, http:RequestContext ctx) returns anydata|error {

            Service fhirService = self.holder.getFhirServiceFromHolder();
            string path = req.extraPathInfo;
            string[] split = getSplitPath(path);
            handle? resourceMethod = getResourceMethod(fhirService, split, "post");
            json|http:ClientError payload = req.getJsonPayload();
            if payload is json {
                if resourceMethod is handle {
                    r4:FHIRError? processCreate = self.preprocessor.processCreate(split[split.length() - 1], payload, req, ctx);
                    if processCreate is r4:FHIRError {
                        return processCreate;
                    }
                    r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
                    anydata|error executeResourceResult = executeCreate(payload, fhirContext, fhirService, resourceMethod);
                    if (executeResourceResult is error) {
                        fhirContext.setInErrorState(true);
                        fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                        return r4:handleErrorResponse(executeResourceResult);
                    }
                    return executeResourceResult;
                } else {
                    return r4:createFHIRError(string `Path not found: ${path}`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_NOT_FOUND);
                }
            } else {
                return r4:createFHIRError(string `Invalid payload`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }
    };
    return httpService;
}

// Split request path into array. Remove query params from the path if any.
isolated function getSplitPath(string restPath) returns string[] {
    string path = restPath;
    if path.indexOf("?") is int {
        path = path.substring(0, <int>path.indexOf("?"));
    }
    string[] split = regex:split(path, "/").slice(1);
    return split;
}
