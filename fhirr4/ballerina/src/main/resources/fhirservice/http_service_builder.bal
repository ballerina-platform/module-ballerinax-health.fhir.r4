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
import ballerina/lang.regexp;
import ballerinax/health.fhir.r4;

// Construct an http service for a fhir service.
isolated function getHttpService(Holder h, r4:ResourceAPIConfig apiConfig, string[] & readonly servicePath) returns http:Service {
    http:InterceptableService httpService = isolated service object {

        private final Holder holder = h;
        private final FHIRPreprocessor preprocessor = new (apiConfig);

        public function createInterceptors() returns [FHIRResponseErrorInterceptor, FHIRResponseInterceptor] {
            return [new FHIRResponseErrorInterceptor(), new FHIRResponseInterceptor(apiConfig)];
        }

        isolated resource function get [string... path](http:Request req, http:RequestContext ctx) returns any|error {

            string[] paths = getRequestPaths(req.rawPath);
            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, servicePath, paths, http:HTTP_GET);
            if resourceMethod is handle {
                boolean hasPathParam = isHavingPathParam(resourceMethod);
                any|error executeResourceResult = ();
                r4:FHIRContext fhirContext;
                if isOperationPath(paths) {
                    string fhirResource = apiConfig.resourceType;
                    string operation = paths[path.length() - 1].substring(1);
                    r4:FHIRInteractionLevel operationScope = getRequestOperationScope(operation, fhirResource, paths);
                    if hasPathParam { // Instance level operation
                        string id = paths[paths.length() - 2];
                        r4:FHIRError? processOperation = self.preprocessor.processOperation(fhirResource,
                                operation, operationScope, (), req, ctx);
                        if processOperation is error {
                            return processOperation;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithID(id, fhirContext, fhirService, resourceMethod);
                    } else { // System or Type level operation
                        r4:FHIRError? processOperation =
                                self.preprocessor.processOperation(fhirResource, operation, operationScope, (), req, ctx);
                        if processOperation is error {
                            return processOperation;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithNoParam(fhirContext, fhirService, resourceMethod);
                    }
                } else if hasPathParam {
                    // can be any of read, vread, instance history
                    if (paths.length() >= 1 && paths[paths.length() - 1] == HISTORY) {
                        // instance history
                        string fhirResource = apiConfig.resourceType;
                        string id = paths[paths.length() - 2];
                        r4:FHIRError? processIHistory = self.preprocessor.processInstanceHistory(fhirResource, id, req, ctx);
                        if processIHistory is r4:FHIRError {
                            return processIHistory;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithID(id, fhirContext, fhirService, resourceMethod);
                        if executeResourceResult is r4:Bundle {
                            executeResourceResult = handleBundleInfo(executeResourceResult, fhirContext, req.extraPathInfo);
                        }
                    } else if (paths.length() >= 2 && paths[paths.length() - 2] == HISTORY) {
                        // vread
                        string fhirResource = apiConfig.resourceType;
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
                        string fhirResource = apiConfig.resourceType;
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
                    if (paths.length() >= 1 && paths[paths.length() - 1] == HISTORY) {
                        // system history or type history
                        r4:FHIRError? processHistory = self.preprocessor.processHistory(req, ctx);
                        if processHistory is r4:FHIRError {
                            return processHistory;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithNoParam(fhirContext, fhirService, resourceMethod);
                        if executeResourceResult is r4:Bundle {
                            executeResourceResult = handleBundleInfo(executeResourceResult, fhirContext, req.extraPathInfo);
                        }
                    } else if (paths.length() >= 1 && paths[paths.length() - 1] == METADATA) {
                        // metadata
                        r4:FHIRError? processCapability = self.preprocessor.processCapability(req, ctx);
                        if processCapability is r4:FHIRError {
                            return processCapability;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithNoParam(fhirContext, fhirService, resourceMethod);
                    } else {
                        // search
                        string fhirResource = apiConfig.resourceType;
                        r4:FHIRError? processSearch = self.preprocessor.processSearch(fhirResource, req, ctx);
                        if processSearch is r4:FHIRError {
                            return processSearch;
                        }
                        fhirContext = check r4:getFHIRContext(ctx);
                        executeResourceResult = executeWithNoParam(fhirContext, fhirService, resourceMethod);
                        if executeResourceResult is r4:Bundle {
                            executeResourceResult = handleBundleInfo(executeResourceResult, fhirContext, req.extraPathInfo);
                        }
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

        isolated resource function post [string... path](http:Request req, http:RequestContext ctx) returns any|error {

            string[] paths = getRequestPaths(req.rawPath);
            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, servicePath, paths, http:HTTP_POST);
            json|http:NoContentError|http:ClientError payload = req.getJsonPayload();

            any|error executeResourceResult = ();
            string fhirResource = apiConfig.resourceType;
            r4:FHIRContext fhirContext;

            if resourceMethod is handle {
                if isOperationPath(paths) { // An operation
                    if payload is json || payload is http:NoContentError {
                        // An operation with no parameters but affects the state is invoked using an empty body
                        json? operationPayload = payload is http:NoContentError ? () : payload;
                        string operation = paths[path.length() - 1].substring(1);
                        r4:FHIRInteractionLevel operationScope = getRequestOperationScope(operation,
                                fhirResource, paths);
                        if isHavingPathParam(resourceMethod) { // Instance level operation 
                            string id = paths[paths.length() - 2];
                            r4:FHIRError? processOperation = self.preprocessor.processOperation(fhirResource,
                                operation, operationScope, operationPayload, req, ctx);
                            if processOperation is error {
                                return processOperation;
                            }
                            fhirContext = check r4:getFHIRContext(ctx);
                            executeResourceResult = executeWithIDAndPayload(id, operationPayload, fhirContext,
                                    fhirService, resourceMethod);
                        } else { // System or Type level operation
                            r4:FHIRError? processOperation = self.preprocessor.processOperation(fhirResource,
                                operation, operationScope, operationPayload, req, ctx);
                            if processOperation is error {
                                return processOperation;
                            }
                            fhirContext = check r4:getFHIRContext(ctx);
                            executeResourceResult = executeWithPayload(operationPayload, fhirContext,
                                    fhirService, resourceMethod);
                        }
                    } else {
                        return r4:createFHIRError(string `Invalid operation payload`, r4:CODE_SEVERITY_ERROR,
                                r4:TRANSIENT, httpStatusCode = http:STATUS_BAD_REQUEST);
                    }
                } else if payload is json { // Create interaction
                    r4:FHIRError? processCreate = self.preprocessor.processCreate(fhirResource, payload, req, ctx);
                    if processCreate is r4:FHIRError {
                        return processCreate;
                    }
                    fhirContext = check r4:getFHIRContext(ctx);
                    executeResourceResult = executeWithPayload(payload, fhirContext, fhirService, resourceMethod);
                } else {
                    return r4:createFHIRError(string `Invalid payload`, r4:CODE_SEVERITY_ERROR, r4:TRANSIENT,
                        httpStatusCode = http:STATUS_BAD_REQUEST);
                }
                if executeResourceResult is error {
                    fhirContext.setInErrorState(true);
                    fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                    return r4:handleErrorResponse(executeResourceResult);
                }
                if executeResourceResult is r4:DomainResource {
                    string? createdId = executeResourceResult.id;
                    if createdId is string {
                        string location = string `${fhirResource}/${createdId}`;
                        fhirContext.setProperty(r4:LOCATION_HEADER_PROP_NAME, location);
                    }
                }
                return executeResourceResult;
            } else {
                return r4:createFHIRError(string `Path not found: ${req.extraPathInfo}`, r4:CODE_SEVERITY_ERROR,
                        r4:TRANSIENT, httpStatusCode = http:STATUS_NOT_FOUND);
            }
        }

        isolated resource function put [string... path](http:Request req, http:RequestContext ctx) returns any|error {
            // update
            string[] paths = getRequestPaths(req.rawPath);
            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, servicePath, paths, http:HTTP_PUT);
            json|http:ClientError payload = req.getJsonPayload();
            if payload is json {
                if resourceMethod is handle {
                    string fhirResource = apiConfig.resourceType;
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
        isolated resource function patch [string... path](http:Request req, http:RequestContext ctx) returns any|error {
            // patch
            string[] paths = getRequestPaths(req.rawPath);
            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, servicePath, paths, http:HTTP_PATCH);
            json|http:ClientError payload = req.getJsonPayload();
            if payload is json {
                if resourceMethod is handle {
                    string fhirResource = apiConfig.resourceType;
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
        isolated resource function delete [string... path](http:Request req, http:RequestContext ctx) returns any|error {
            // delete
            string[] paths = getRequestPaths(req.rawPath);
            Service fhirService = self.holder.getFhirServiceFromHolder();
            handle? resourceMethod = getResourceMethod(fhirService, servicePath, paths, http:HTTP_DELETE);

            if resourceMethod is handle {
                string fhirResource = apiConfig.resourceType;
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

# Process an API request raw path to obtain clean path segments.
#
# + path - The raw URL path from an API request, potentially including query parameters
# + return - An array containing the cleaned path segments
isolated function getRequestPaths(string path) returns string[] {
    string[] paths;
    string rawPath = path.includes("?") ? (path.substring(0, path.indexOf("?") ?: 0)) : path;
    paths = regexp:split(re `/`, rawPath);
    _ = paths.remove(0);
    _ = paths[0] == "" ? paths.remove(0) : [];
    return paths;
}

# Checks if paths represents an operation path.
#
# + paths - An paths to check
# + return - A boolean indicating whether the paths represent an operation path
isolated function isOperationPath(string[] paths) returns boolean
    => paths.length() > 0 && paths[paths.length() - 1].startsWith("$");

# Determines the scope of a FHIR operation request.
#
# + operation - The FHIR operation
# + resourceType - The resource type involved in the operation
# + paths - An array of paths involved in the operation
# + return - The scope of the operation request
isolated function getRequestOperationScope(string operation, string resourceType,
        string[] paths) returns r4:FHIRInteractionLevel {
    int? resourceTypeIndex = paths.indexOf(resourceType);

    if resourceTypeIndex is () { // No resource type in the path - System level
        return r4:FHIR_INTERACTION_SYSTEM;
    } else if resourceTypeIndex < paths.length() - 1 &&
            (paths[resourceTypeIndex + 1] == string `$${operation}`) { // Type level
        return r4:FHIR_INTERACTION_TYPE;
    } else { // Instance level
        return r4:FHIR_INTERACTION_INSTANCE;
    }
}
