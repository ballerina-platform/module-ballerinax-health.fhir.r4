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

// Analytics Server configuration
configurable boolean analyticsEnabled = false;
configurable string analyticsServerUrl = "http://localhost:9200/fhirr4/_doc";
configurable string analyticsServerUsername = "";
configurable string analyticsServerPassword = "";

// Configs to read from x-jwt-assertion header
configurable string[] analyticsRequiredAttributes = ["fhirUser", "client_id", "iss"];

// Configs to get more information about the patient
configurable boolean analyticsMoreInfoRequired = false;
configurable string analyticsMoreInfoUrl = "";
configurable string analyticsMoreInfoUsername = "";
configurable string analyticsMoreInfoPassword = "";

const X_JWT_HEADER = "x-jwt-assertion";

# AnalyticsRequestInterceptor is an HTTP request interceptor that publishes analytics data
isolated service class AnalyticsRequestInterceptor {
    *http:RequestInterceptor;
    final string resourceType;
    final http:Client|http:ClientError? logPublisherHttpClient;
    final http:Client|http:ClientError? moreInfoHttpClient;

    # Initializes the AnalyticsRequestInterceptor
    public function init(r4:ResourceAPIConfig apiConfig) {
        self.resourceType = apiConfig.resourceType;
        // Initialize the log publisher HTTP client
        if analyticsServerUsername != "" && analyticsServerPassword != "" {
            self.logPublisherHttpClient = new (analyticsServerUrl, auth = {
                username: analyticsServerUsername,
                password: analyticsServerPassword
            });
        } else {
            self.logPublisherHttpClient = new (analyticsServerUrl);
        }
        // Initialize the analytics more info HTTP client
        if analyticsMoreInfoUsername != "" && analyticsMoreInfoPassword != "" {
            self.moreInfoHttpClient = new (analyticsMoreInfoUrl, auth = {
                username: analyticsMoreInfoUsername,
                password: analyticsMoreInfoPassword
            });
        } else {
            self.moreInfoHttpClient = new (analyticsMoreInfoUrl);
        }
    }

    # Publishes the log data to the analytics server
    #
    # + logData - The log data json to be published
    isolated function publish(json logData) {
        http:Client|http:ClientError? logPublisher = self.logPublisherHttpClient;
        log:printDebug(`[AnalyticsRequestInterceptor] Sending log to: ${analyticsServerUrl}`);
        if logPublisher is () || logPublisher is http:ClientError {
            log:printError(`[AnalyticsRequestInterceptor] Failed to create Analytics HTTP client`);
        } else {
            http:Response|http:ClientError result = logPublisher->/.post(logData);
            if result is http:ClientError {
                log:printError(`[AnalyticsRequestInterceptor] Failed publishing log to ${analyticsServerUrl} [Error]: ${result.toString()}`);
            } else if result.statusCode < 200 || result.statusCode >= 300 {
                log:printError(`[AnalyticsRequestInterceptor] Failed publishing log to ${analyticsServerUrl} [Error]: ${result.reasonPhrase}`);
            } else {
                log:printInfo(`[AnalyticsRequestInterceptor] Log published successfully to ${analyticsServerUrl}`);
            }
        }
    }

    # Retrieves more information about the patient from the configured URL
    #
    # + logData - The log data to send to retrieve more information
    # + return - A JSON object containing additional information
    isolated function getMoreInfo(json logData) returns json {
        http:Client|http:ClientError? moreInfoClient = self.moreInfoHttpClient;
        if moreInfoClient is () || moreInfoClient is http:ClientError {
            log:printError(`[AnalyticsRequestInterceptor] Failed to create More Info HTTP client`);
            return {};
        } else {
            http:Response|http:ClientError result = moreInfoClient->/.post(logData);
            if (result is http:Response) {
                json|error payload = result.getJsonPayload();
                if payload is json {
                    return payload;
                } else {
                    log:printError(`[AnalyticsRequestInterceptor] Failed to extract JSON payload from More Info response.`);
                    return {};
                }
            } else {
                log:printError(`[AnalyticsRequestInterceptor] Failed to fetch more info from ${analyticsMoreInfoUrl} [Error]: ${result.toString()}`);
                return {};
            }
        }
    }

    # Publishes the analytics data based on the x-jwt-assertion header
    # + jwt - The JWT token from the x-jwt-assertion header
    # + return - An error if the publishing fails
    isolated function publishAnalyticsData(string jwt) returns error? {
        [jwt:Header, jwt:Payload]|error decodedJWT = jwt:decode(jwt);
        if decodedJWT is [jwt:Header, jwt:Payload] {
            [jwt:Header, jwt:Payload] [_, payload] = decodedJWT;

            // Filter logData to include only keys in x_jwt_attributes
            map<string> filteredLogData = map from string attrKey in analyticsRequiredAttributes
                where payload[attrKey] !== ()
                select [attrKey, payload[attrKey].toString()];

            filteredLogData["resourceType"] = self.resourceType;

            // Get more information if configured
            if analyticsMoreInfoRequired {
                json moreInfo = self.getMoreInfo(filteredLogData.toJson());
                log:printDebug(`[AnalyticsRequestInterceptor] More info fetched from: ${analyticsMoreInfoUrl} [More info]: ${moreInfo.toString()}`);
                foreach var [key, value] in (<map<json>>moreInfo).entries() {
                    filteredLogData[key] = value.toString();
                }
            }

            filteredLogData["timestamp"] = time:utcToString(time:utcNow());

            log:printDebug(`[AnalyticsRequestInterceptor] Publishing log: ${filteredLogData.toString()}`);
            self.publish(filteredLogData.toJson());
        } else {
            log:printError(`[AnalyticsRequestInterceptor] Error decoding x-jwt-assertion header.`);
        }

    }

    # Interceptor function that processes the request and publishes analytics data
    # + path - The request path
    # + ctx - The request context
    # + req - The HTTP request
    # + return - The next service in the interceptor chain or an error
    isolated resource function 'default [string... path](http:RequestContext ctx, http:Request req) returns http:NextService|error? {
        if !analyticsEnabled {
            log:printDebug(`[AnalyticsRequestInterceptor] Analytics is disabled. Skipping analytics data publishing.`);
            return ctx.next();
        }

        string|error xJWT = req.getHeader(X_JWT_HEADER);
        if xJWT is error {
            log:printError(`[AnalyticsRequestInterceptor] Skipped publishing logs. Error: Missing x-jwt-assertion header.`);
            return ctx.next();
        }

        log:printDebug(`[AnalyticsRequestInterceptor] Publishing analytics data.`);
        future<error?> _ = start self.publishAnalyticsData(xJWT);

        // Returns the next interceptor in the pipeline.
        return ctx.next();
    }
}
