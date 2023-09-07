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
import ballerinax/health.fhir.r4;

// Construct an http service for a fhir service.
isolated function getHttpService(Holder h, r4:ResourceAPIConfig apiConfig) returns http:Service {
    http:InterceptableService httpService = isolated service object {

        private final Holder holder = h;
        private final FHIRPreprocessor preprocessor = new (apiConfig);

        public function createInterceptors() returns [FHIRResponseErrorInterceptor, FHIRResponseInterceptor] {
            return [new FHIRResponseErrorInterceptor(), new FHIRResponseInterceptor(apiConfig)];
        }

        isolated resource function get [string... paths](http:Request req, http:RequestContext ctx) returns any|error {

            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, paths, http:HTTP_GET);
            if resourceMethod is handle {
                boolean hasPathParam = isHavingPathParam(resourceMethod);
                any|error executeResourceResult = ();
                r4:FHIRContext fhirContext;
                if hasPathParam {
                    // can be any of read, vread, instance history
                    if paths[paths.length() - 1] == HISTORY {
                        // instance history
                        string fhirResource = paths[paths.length() - 3];
                        string id = paths[paths.length() - 2];
                        r4:FHIRError? processIHistory = self.preprocessor.processInstanceHistory(fhirResource, id, req, ctx);
                        if processIHistory is r4:FHIRError {
                            return processIHistory;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithID(id, fhirContext, fhirService, resourceMethod);
                    } else if paths[paths.length() - 2] == HISTORY {
                        // vread
                        string fhirResource = paths[paths.length() - 4];
                        string id = paths[paths.length() - 3];
                        string vid = paths[paths.length() - 1];
                        r4:FHIRError? processIHistory = self.preprocessor.processVread(fhirResource, id, vid, req, ctx);
                        if processIHistory is r4:FHIRError {
                            return processIHistory;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithIDAndVID(id, vid, fhirContext, fhirService, resourceMethod);
                    } else {
                        // read
                        string fhirResource = paths[paths.length() - 2];
                        string id = paths[paths.length() - 1];
                        r4:FHIRError? processRead = self.preprocessor.processRead(fhirResource, id, req, ctx);
                        if processRead is r4:FHIRError {
                            return processRead;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithID(id, fhirContext, fhirService, resourceMethod);
                    }
                } else {
                    // can be any of search, type history, system history, metadata
                    if paths[paths.length() - 1] == HISTORY {
                        // system history or type history
                        r4:FHIRError? processHistory = self.preprocessor.processHistory(req, ctx);
                        if processHistory is r4:FHIRError {
                            return processHistory;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithNoParam(fhirContext, fhirService, resourceMethod);
                    } else if paths[paths.length() - 1] == METADATA {
                        // metadata
                        r4:FHIRError? processCapability = self.preprocessor.processCapability(req, ctx);
                        if processCapability is r4:FHIRError {
                            return processCapability;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithNoParam(fhirContext, fhirService, resourceMethod);
                    } else {
                        // search
                        string fhirResource = paths[paths.length() - 1];
                        r4:FHIRError? processSearch = self.preprocessor.processSearch(fhirResource, req, ctx);
                        if processSearch is r4:FHIRError {
                            return processSearch;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithNoParam(fhirContext, fhirService, resourceMethod);
                    }
                }
                if (executeResourceResult is error) {
                    fhirContext.setInErrorState(true);
                    fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                    return r4:handleErrorResponse(executeResourceResult);
                }
                return executeResourceResult;
            } else {
                return r4:createFHIRError(string `Path not found: ${req.extraPathInfo}`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_NOT_FOUND);
            }
        }

        isolated resource function post [string... paths](http:Request req, http:RequestContext ctx) returns any|error {

            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, paths, http:HTTP_POST);
            json|http:ClientError payload = req.getJsonPayload();
            if payload is json {
                if resourceMethod is handle {
                    string fhirResource = paths[paths.length() - 1];
                    r4:FHIRError? processCreate = self.preprocessor.processCreate(fhirResource, payload, req, ctx);
                    if processCreate is r4:FHIRError {
                        return processCreate;
                    }
                    r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
                    any|error executeResourceResult = executeWithPayload(payload, fhirContext, fhirService, resourceMethod);
                    if (executeResourceResult is error) {
                        fhirContext.setInErrorState(true);
                        fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                        return r4:handleErrorResponse(executeResourceResult);
                    }
                    return executeResourceResult;
                } else {
                    return r4:createFHIRError(string `Path not found: ${req.extraPathInfo}`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_NOT_FOUND);
                }
            } else {
                return r4:createFHIRError(string `Invalid payload`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }

        isolated resource function put [string... paths](http:Request req, http:RequestContext ctx) returns any|error {
            // update
            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, paths, http:HTTP_PUT);
            json|http:ClientError payload = req.getJsonPayload();
            if payload is json {
                if resourceMethod is handle {
                    string fhirResource = paths[paths.length() - 2];
                    string id = paths[paths.length() - 1];
                    r4:FHIRError? processUpdate = self.preprocessor.processUpdate(fhirResource, id, payload, req, ctx);
                    if processUpdate is r4:FHIRError {
                        return processUpdate;
                    }
                    r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
                    any|error executeResourceResult = executeWithIDAndPayload(id, payload, fhirContext, fhirService, resourceMethod);
                    if (executeResourceResult is error) {
                        fhirContext.setInErrorState(true);
                        fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                        return r4:handleErrorResponse(executeResourceResult);
                    }
                    return executeResourceResult;
                } else {
                    return r4:createFHIRError(string `Path not found: ${req.extraPathInfo}`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_NOT_FOUND);
                }
            } else {
                return r4:createFHIRError(string `Invalid payload`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }
        isolated resource function patch [string... paths](http:Request req, http:RequestContext ctx) returns any|error {
            // patch
            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, paths, http:HTTP_PATCH);
            json|http:ClientError payload = req.getJsonPayload();
            if payload is json {
                if resourceMethod is handle {
                    string fhirResource = paths[paths.length() - 2];
                    string id = paths[paths.length() - 1];
                    r4:FHIRError? processPatch = self.preprocessor.processPatch(fhirResource, id, payload, req, ctx);
                    if processPatch is r4:FHIRError {
                        return processPatch;
                    }
                    r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
                    any|error executeResourceResult = executeWithIDAndPayload(id, payload, fhirContext, fhirService, resourceMethod);
                    if (executeResourceResult is error) {
                        fhirContext.setInErrorState(true);
                        fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                        return r4:handleErrorResponse(executeResourceResult);
                    }
                    return executeResourceResult;
                } else {
                    return r4:createFHIRError(string `Path not found: ${req.extraPathInfo}`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_NOT_FOUND);
                }
            } else {
                return r4:createFHIRError(string `Invalid payload`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }
        isolated resource function delete [string... paths](http:Request req, http:RequestContext ctx) returns any|error {
            // delete
            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, paths, http:DELETE);

            if resourceMethod is handle {
                string fhirResource = paths[paths.length() - 2];
                string id = paths[paths.length() - 1];
                r4:FHIRError? processDelete = self.preprocessor.processDelete(fhirResource, id, req, ctx);
                if processDelete is r4:FHIRError {
                    return processDelete;
                }
                r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
                any|error executeResourceResult = executeWithID(id, fhirContext, fhirService, resourceMethod);
                if (executeResourceResult is error) {
                    fhirContext.setInErrorState(true);
                    fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                    return r4:handleErrorResponse(executeResourceResult);
                }
                return executeResourceResult;
            } else {
                return r4:createFHIRError(string `Path not found: ${req.extraPathInfo}`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT, httpStatusCode = http:STATUS_NOT_FOUND);
            }
        }
    };
    return httpService;
}
