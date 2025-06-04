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

configurable boolean analyticsEnabled = false;

// OpenSearch configuration
configurable string opensearchUrl = "http://localhost:9200";
configurable string opensearchIndex = "healthcare-logs";
configurable string opensearchUsername = "";
configurable string opensearchPassword = "";

// Configs to read from x-jwt-assertion header
configurable string[] requiredAttributes = ["fhirUser", "client_id", "iss"];

// Configs to get more information about the patient
configurable boolean moreInfoRequired = false;
configurable string moreInfoUrl = "";
configurable string moreInfoUsername = "";
configurable string moreInfoPassword = "";

const X_JWT_HEADER = "x-jwt-assertion";

isolated service class AnalyticsRequestInterceptor {
    *http:RequestInterceptor;
    final string resourceType;

    public function init(r4:ResourceAPIConfig apiConfig) {
        self.resourceType = apiConfig.resourceType;
    }

    isolated function sendToOpenSearch(json logData) returns error? {
        string url = opensearchUrl + "/" + opensearchIndex + "/_doc";
        log:printDebug(`[AnalyticsRequestInterceptor] Sending log to: ${url} with index: ${opensearchIndex}`);

        http:Client openSearchClient;
        if opensearchUsername != "" && opensearchPassword != "" {
            openSearchClient = check new (url, auth = {
                username: opensearchUsername,
                password: opensearchPassword
            });
        } else {
            openSearchClient = check new (url);
        }

        http:Response result = check openSearchClient->/.post(logData);
        if result.statusCode < 200 || result.statusCode >= 300 {
            log:printError(`[AnalyticsRequestInterceptor] Failed publishing log to ${url} with Index: ${opensearchIndex}. ${"\n"}Error: ${result.reasonPhrase}`);
        } else {
            log:printInfo(`[AnalyticsRequestInterceptor] Log published successfully to ${url} with Index: ${opensearchIndex}`);
        }
    }

    isolated function getMoreInfo(string patientId) returns json|error {
        http:Client moreInfoClient;
        if moreInfoUsername != "" && moreInfoPassword != "" {
            moreInfoClient = check new (moreInfoUrl, auth = {
                username: moreInfoUsername,
                password: moreInfoPassword
            });
        } else {
            moreInfoClient = check new (moreInfoUrl);
        }
        json moreInfoResponse = check moreInfoClient->/.get(patientId = patientId);
        return moreInfoResponse;
    }

    isolated function publishAnalyticsData(string jwt) returns error? {
        [jwt:Header, jwt:Payload]|error decodedJWT = jwt:decode(jwt);
        if decodedJWT is [jwt:Header, jwt:Payload] {
            [jwt:Header, jwt:Payload] [_, payload] = decodedJWT;

            // Filter logData to include only keys in x_jwt_attributes
            map<string> filteredLogData = map from string attrKey in requiredAttributes
                where payload[attrKey] !== ()
                select [attrKey, payload[attrKey].toString()];

            filteredLogData["timestamp"] = time:utcToString(time:utcNow());
            filteredLogData["resourceType"] = self.resourceType;

            // Get more information of fhirUser
            if moreInfoRequired {
                string? fhirUser = filteredLogData["fhirUser"];
                if fhirUser is string {
                    json|error moreInfo = self.getMoreInfo(fhirUser);
                    if moreInfo is json {
                        log:printDebug(`[AnalyticsRequestInterceptor] More info fetched for fhirUser: ${fhirUser}`);
                        foreach var [key, value] in (<map<json>>moreInfo).entries() {
                            filteredLogData[key] = value.toString();
                        }
                    } else {
                        log:printError(`[AnalyticsRequestInterceptor] Failed to fetch more info for fhirUser: ${fhirUser}. ${"\n"}Error: ${moreInfo.toString()}`);
                    }
                } else {
                    log:printDebug(`[AnalyticsRequestInterceptor] No fhirUser found in JWT, skipping more info fetch.`);
                }
            }

            log:printDebug(`[AnalyticsRequestInterceptor] Publishing log: ${"\n"} ${filteredLogData.toString()}`);
            check self.sendToOpenSearch(filteredLogData.toJson());
        } else {
            log:printError(`[AnalyticsRequestInterceptor] Error decoding x-jwt-assertion header.`);
        }

    }

    isolated resource function 'default [string... path](http:RequestContext ctx, http:Request req) returns http:NextService|error? {
        if !analyticsEnabled {
            log:printDebug(`[AnalyticsRequestInterceptor] Analytics is disabled. Skipping analytics data publishing.`);
            return ctx.next();
        }

        string|error xJWT = req.getHeader(X_JWT_HEADER);
        if (xJWT is error) {
            log:printError(`[AnalyticsRequestInterceptor] Failed publishing logs. Error: Missing x-jwt-assertion header.`);
            return ctx.next();
        }

        log:printDebug(`[AnalyticsRequestInterceptor] Publishing analytics data.`);
        future<error?> _ = start self.publishAnalyticsData(xJWT);

        // Returns the next interceptor in the pipeline.
        return ctx.next();
    }
}
