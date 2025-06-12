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

# AnalyticsConfig Record.
#
# + enabled - if analytics is enabled or not
# + attributes - the list of attributes picked from x-jwt-assertion to publish
# + url - the URL of the analytics server to publish logs
# + username - the username for the analytics server
# + password - the password for the analytics server
# + moreInfo - configuration for fetching more information
public type AnalyticsConfig record {|
    boolean enabled;
    string[] attributes;
    string url;
    string username;
    string password;
    MoreInfoConfig moreInfo;
|};

# MoreInfoConfig Record.
#
# + enabled - if more info fetching is enabled or not
# + url - the URL to fetch more information
# + username - the username for the more info server
# + password - the password for the more info server
public type MoreInfoConfig record {|
    boolean enabled;
    string url;
    string username;
    string password;
|};

configurable AnalyticsConfig analytics = {
    enabled: true,
    attributes: ["fhirUser", "client_id", "iss"],
    url: "http://localhost:9200/fhirr4/_doc",
    username: "",
    password: "",
    moreInfo: {
        enabled: false,
        url: "",
        username: "",
        password: ""
    }
};

const X_JWT_HEADER = "x-jwt-assertion";

# AnalyticsResponseInterceptor is an HTTP response interceptor that publishes analytics data
isolated service class AnalyticsResponseInterceptor {
    *http:ResponseInterceptor;
    final string resourceType;
    final http:Client|http:ClientError? logPublisherHttpClient;
    final http:Client|http:ClientError? moreInfoHttpClient;

    # Initializes the AnalyticsResponseInterceptor
    public function init(r4:ResourceAPIConfig apiConfig) {
        self.resourceType = apiConfig.resourceType;
        // Initialize the log publisher HTTP client
        if analytics.username is "" {
            self.logPublisherHttpClient = new (analytics.url);
        } else {
            self.logPublisherHttpClient = new (analytics.url, auth = {
                username: analytics.username,
                password: analytics.password
            });
        }

        // Initialize the analytics more info HTTP client
        if !analytics.moreInfo.enabled {
            self.moreInfoHttpClient = ();
        } else if analytics.moreInfo.username is "" {
            self.moreInfoHttpClient = new (analytics.moreInfo.url);
        } else {
            self.moreInfoHttpClient = new (analytics.moreInfo.url, auth = {
                username: analytics.moreInfo.username,
                password: analytics.moreInfo.password
            });
        }
    }

    # Publishes the log data to the analytics server
    #
    # + logData - The log data json to be published
    isolated function publish(json logData) {
        http:Client|http:ClientError? logPublisher = self.logPublisherHttpClient;
        log:printDebug(`[AnalyticsResponseInterceptor] Sending log to: ${analytics.url}`);
        if logPublisher is () || logPublisher is http:ClientError {
            log:printError(`[AnalyticsResponseInterceptor] Failed to create Analytics HTTP client`);
        } else {
            http:Response|http:ClientError result = logPublisher->/.post(logData);
            if result is http:ClientError {
                log:printError(`[AnalyticsResponseInterceptor] Failed publishing log to ${analytics.url} [Error]: ${result.toString()}`);
            } else if result.statusCode < 200 || result.statusCode >= 300 {
                log:printError(`[AnalyticsResponseInterceptor] Failed publishing log to ${analytics.url} [Error]: ${result.reasonPhrase}`);
            } else {
                log:printInfo(`[AnalyticsResponseInterceptor] Log published successfully to ${analytics.url}`);
            }
        }
    }

    # Retrieves more information from the configured URL
    #
    # + logData - The log data to send to retrieve more information
    # + return - A JSON object containing additional information
    isolated function getMoreInfo(json logData) returns json {
        http:Client|http:ClientError? moreInfoClient = self.moreInfoHttpClient;
        if moreInfoClient is () || moreInfoClient is http:ClientError {
            log:printError(`[AnalyticsResponseInterceptor] Failed to create More Info HTTP client`);
            return {};
        } else {
            http:Response|http:ClientError result = moreInfoClient->/.post(logData);
            if (result is http:Response) {
                json|error payload = result.getJsonPayload();
                if payload is json {
                    return payload;
                } else {
                    log:printError(`[AnalyticsResponseInterceptor] Failed to extract JSON payload from More Info response.`);
                    return {};
                }
            } else {
                log:printError(`[AnalyticsResponseInterceptor] Failed to fetch more info from ${analytics.moreInfo.url} [Error]: ${result.toString()}`);
                return {};
            }
        }
    }

    # Publishes the analytics data based on the x-jwt-assertion header
    # + jwt - The JWT token from the x-jwt-assertion header
    # + statusCode - The HTTP status code of the response
    # + return - An error if the publishing fails
    isolated function publishAnalyticsData(string jwt, int statusCode) returns error? {
        [jwt:Header, jwt:Payload]|error decodedJWT = jwt:decode(jwt);
        if decodedJWT is [jwt:Header, jwt:Payload] {
            [jwt:Header, jwt:Payload] [_, payload] = decodedJWT;

            // Filter logData to include only keys in x_jwt_attributes
            map<string> filteredLogData = map from string attrKey in analytics.attributes
                where payload[attrKey] !== ()
                select [attrKey, payload[attrKey].toString()];

            filteredLogData["resourceType"] = self.resourceType;

            // Get more information if configured
            if analytics.moreInfo.enabled {
                json moreInfo = self.getMoreInfo(filteredLogData.toJson());
                log:printDebug(`[AnalyticsResponseInterceptor] More info fetched from: ${analytics.moreInfo.url} [More info]: ${moreInfo.toString()}`);
                foreach var [key, value] in (<map<json>>moreInfo).entries() {
                    filteredLogData[key] = value.toString();
                }
            }

            filteredLogData["timestamp"] = time:utcToString(time:utcNow());
            filteredLogData["statusCode"] = statusCode.toString();

            log:printDebug(`[AnalyticsResponseInterceptor] Publishing log: ${filteredLogData.toString()}`);
            self.publish(filteredLogData.toJson());
        } else {
            log:printError(`[AnalyticsResponseInterceptor] Error decoding x-jwt-assertion header.`);
        }

    }

    # Interceptor function that processes the response and publishes analytics data
    # + ctx - The request context
    # + req - The HTTP request
    # + res - The HTTP response
    # + return - The next service in the interceptor chain or an error
    remote isolated function interceptResponse(http:RequestContext ctx, http:Request req, http:Response res) returns http:NextService|error? {
        if !analytics.enabled {
            log:printDebug(`[AnalyticsResponseInterceptor] Analytics is disabled. Skipping analytics data publishing.`);
            return ctx.next();
        }

        string|error xJWT = req.getHeader(X_JWT_HEADER);
        if xJWT is error {
            log:printError(`[AnalyticsResponseInterceptor] Skipped publishing logs. Error: Missing x-jwt-assertion header.`);
            return ctx.next();
        }

        log:printDebug(`[AnalyticsResponseInterceptor] Publishing analytics data.`);
        future<error?> _ = start self.publishAnalyticsData(xJWT, res.statusCode);

        // Returns the next interceptor in the pipeline.
        return ctx.next();
    }
}
