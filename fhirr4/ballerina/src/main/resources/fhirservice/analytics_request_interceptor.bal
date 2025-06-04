// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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
import ballerina/jwt;
import ballerina/log;
import ballerina/time;
import ballerinax/health.fhir.r4;

configurable boolean analytics_enabled = false;

// OpenSearch configuration
configurable string opensearch_url = "http://localhost:9200";
configurable string opensearch_index = "healthcare-logs";
configurable string opensearch_username = "";
configurable string opensearch_password = "";

// Configs to read from x-jwt-assertion header
configurable string[] x_jwt_attributes = ["fhirUser", "client_id", "iss"];

// Configs to get more information about the patient
configurable boolean get_more_info = false;
configurable string more_info_url = "";
configurable string more_info_username = "";
configurable string more_info_password = "";

const X_JWT_HEADER = "x-jwt-assertion";

isolated service class AnalyticsRequestInterceptor {
    *http:RequestInterceptor;
    final string resourceType;

    public function init(r4:ResourceAPIConfig apiConfig) {
        self.resourceType = apiConfig.resourceType;
    }

    isolated function sendToOpenSearch(json logData) returns error? {

        string url = opensearch_url + "/" + opensearch_index + "/_doc";
        log:printDebug("[AnalyticsRequestInterceptor] Sending log to: " + url + " with index: " + opensearch_index);

        http:Client openSearchClient;
        if opensearch_username != "" && opensearch_password != "" {
            openSearchClient = check new (url, auth = {
                username: opensearch_username,
                password: opensearch_password
            });
        } else {
            openSearchClient = check new (url);
        }

        http:Response result = check openSearchClient->post("", logData);
        if result.statusCode < 200 || result.statusCode >= 300 {
            log:printError("[AnalyticsRequestInterceptor] Failed publishing log to " + url + " with Index: " + opensearch_index + " \nError: " + result.reasonPhrase);
        }
        else {
            log:printInfo("[AnalyticsRequestInterceptor] Log published successfully to " + url + " with Index: " + opensearch_index);
        }
    }

    isolated function getMoreInfo(string patientId) returns json|error {
        http:Client moreInfoClient;
        if more_info_username != "" && more_info_password != "" {
            moreInfoClient = check new (more_info_url, auth = {
                username: more_info_username,
                password: more_info_password
            });
        } else {
            moreInfoClient = check new (more_info_url);
        }
        json moreInfoResponse = check moreInfoClient->get("?patientId=" + patientId);
        return moreInfoResponse;
    }

    isolated function publishAnalyticsData(string jwt) returns error? {

        [jwt:Header, jwt:Payload]|error decodedJWT = jwt:decode(jwt);
        if decodedJWT is [jwt:Header, jwt:Payload] {
            [jwt:Header, jwt:Payload] [_, payload] = decodedJWT;

            // Filter logData to include only keys in x_jwt_attributes
            map<string> filteredLogData = {};
            foreach string attr in x_jwt_attributes {
                if payload[attr] !== () {
                    filteredLogData[attr] = payload[attr].toString();
                }
            }

            filteredLogData["timestamp"] = time:utcToString(time:utcNow());

            filteredLogData["resourceType"] = self.resourceType;

            // Get more information of fhirUser
            if get_more_info {
                string? fhirUser = filteredLogData["fhirUser"];
                if fhirUser is string {
                    json|error moreInfo = self.getMoreInfo(fhirUser);
                    if moreInfo is json {
                        log:printDebug("[AnalyticsRequestInterceptor] More info fetched for fhirUser: " + fhirUser);
                        foreach var [key, value] in (<map<json>>moreInfo).entries() {
                            filteredLogData[key] = value.toString();
                        }
                    } else {
                        log:printError("[AnalyticsRequestInterceptor] Failed to fetch more info for fhirUser: " + fhirUser + ". Error: " + moreInfo.toString());
                    }
                }
                else {
                    log:printDebug("[AnalyticsRequestInterceptor] No fhirUser found in JWT, skipping more info fetch.");
                }
            }

            log:printDebug("[AnalyticsRequestInterceptor] Publishing log" + filteredLogData.toString());
            check self.sendToOpenSearch(filteredLogData.toJson());
        } else {
            log:printError("[AnalyticsRequestInterceptor] Error decoding x-jwt-assertion header.");
        }

    }

    isolated resource function 'default [string... path](http:RequestContext ctx, http:Request req) returns http:NextService|error? {

        if !analytics_enabled {
            log:printDebug("[AnalyticsRequestInterceptor] Analytics is disabled. Skipping analytics data publishing.");
            return ctx.next();
        }

        string|error xJWT = req.getHeader(X_JWT_HEADER);
        if (xJWT is error) {
            log:printError("[AnalyticsRequestInterceptor] Failed publishing logs. Error: Missing x-jwt-assertion header.");
            return ctx.next();
        }

        log:printDebug("[AnalyticsRequestInterceptor] Publishing analytics data.");
        future<error?> _ = start self.publishAnalyticsData(xJWT);

        // Returns the next interceptor in the pipeline.
        return ctx.next();
    }

}

