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

isolated function getHttpService(Holder h, r4:ResourceAPIConfig apiConfig) returns http:Service {
    http:Service httpService = @http:ServiceConfig {
        interceptors: [
            new r4:FHIRReadRequestInterceptor(apiConfig),
            new r4:FHIRCreateRequestInterceptor(apiConfig),
            new r4:FHIRSearchRequestInterceptor(apiConfig),
            new r4:FHIRRequestErrorInterceptor(),
            new r4:FHIRResponseInterceptor(apiConfig)
        ]
    } isolated service object {

        private final Holder holder = h;

        isolated resource function 'default [string... args](http:Request req, http:RequestContext ctx) returns any|error {
            Service fhirService = self.holder.getFhirServiceFromHolder();
            r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
            string path = req.rawPath;
            if path.indexOf("?") is int {
                path = path.substring(0, <int>path.indexOf("?"));
            }
            string[] split = regex:split(path, "/").slice(1);
            string accessor = req.method;
            if accessor == "GET" {
                handle? resourceMethod = getResourceMethod(fhirService, split, "get");
                if resourceMethod is handle {
                    boolean hasPathParam = isHavingPathParam(resourceMethod);
                    anydata|error executeResourceResult;
                    if hasPathParam {
                        string id = args[args.length() - 1];
                        executeResourceResult = executeReadByID(id, fhirContext, fhirService, resourceMethod);
                    } else {
                        executeResourceResult = executeSearch(fhirContext, fhirService, resourceMethod);
                    }
                    if (executeResourceResult is error) {
                        fhirContext.setInErrorState(true);
                        fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                        return r4:handleErrorResponse(executeResourceResult);
                    }
                    return executeResourceResult;
                }
            } else if accessor == "POST" {
                handle? resourceMethod = getResourceMethod(fhirService, split, "post");
                json|xml payload = ();
                string ctype = req.getContentType();
                if (ctype == "application/fhir+json") {
                    payload = check req.getJsonPayload();
                } else if (ctype == "application/fhir+xml") {
                    payload = check req.getXmlPayload();
                }
                anydata parse = check r4:parse(payload);
                if resourceMethod is handle {
                    any|error executeResourceResult = executeCreate(parse, fhirContext, fhirService, resourceMethod);
                    if (executeResourceResult is error) {
                        fhirContext.setInErrorState(true);
                        fhirContext.setErrorCode(r4:getErrorCode(executeResourceResult));
                        return r4:handleErrorResponse(executeResourceResult);
                    }
                    return executeResourceResult;
                }
            }
        }
    };
    return httpService;
}
