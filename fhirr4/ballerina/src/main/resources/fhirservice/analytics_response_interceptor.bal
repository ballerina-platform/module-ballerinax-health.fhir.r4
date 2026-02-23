// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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
import ballerina/file;

configurable AnalyticsConfig analytics = {
    enabled: false,
    fhirServerContext: DEFAULT_SERVER_CONTEXT,
    jwtAttributes : [
        "client_id",
        "iss"
    ],
    shouldPublishPayloads: false,
    filePath: DEFAULT_FILE_LOCATION, 
    fileName: LOG_FILE_NAME,
    allowedApiContexts: [],
    excludedApiContexts: [],
    enrichPayload: {
        enabled: false,
        url: "",
        username: "",
        password: ""
    }
};

configurable AnalyticsPayloadEnrich analyticsPayloadEnrichConfig = {
    enabled: false,
    url: "",
    username: "",
    password: ""
};

isolated http:Client|http:ClientError? dataEnrichHttpClient = ();

# AnalyticsResponseInterceptor is an HTTP response interceptor that writes analytics data to a configured log file.
isolated service class AnalyticsResponseInterceptor {
    *http:ResponseInterceptor;
    
    # Initializes file rotator.
    #
    # + apiConfig - The API configuration
    isolated function init(r4:ResourceAPIConfig apiConfig) {
        
        if analytics.enabled {
            lock {
                error? fileCreateError = createFileIfNotExist();
                if fileCreateError is error {
                    log:printError("Failed to create log file.", fileCreateError);
                    return;
                }

                if analytics.shouldPublishPayloads == true {
                    if analytics.enrichPayload is AnalyticsPayloadEnrich && analytics.enrichPayload?.enabled == true {
                        if dataEnrichHttpClient is () {
                            dataEnrichHttpClient = initializeEnrichmentHttpClient();
                            if dataEnrichHttpClient is http:ClientError {
                                log:printError(string `Failed to initialize data enrichment HTTP client.`);
                                return;
                            }
                        }
                    }
                }
            }
            // Initialize the file rotator
            initFileRotator();
        }
    }

    remote isolated function interceptResponse(http:RequestContext ctx, http:Request req, http:Response res) 
                                                                                    returns http:NextService|error? {
        
        if analytics.enabled == false {
            return ctx.next();
        }

        //check excluded APIs from config and skip analytics writing
        boolean|error? isApiAllowedResult = isApiAllowed(getApiPath(req.rawPath, analytics.fhirServerContext), 
                                                        analytics.allowedApiContexts, analytics.excludedApiContexts);
        if isApiAllowedResult is boolean {
            if isApiAllowedResult == false {
                return ctx.next();
            }
        } else {
            log:printDebug("Error while validating API for analytics writing.", isApiAllowedResult);
            return ctx.next();
        }

        string|error xJWT = req.getHeader(X_JWT_HEADER);
        if xJWT is error {
            log:printDebug("[AnalyticsResponseInterceptor] Skipped writing analytics data. Missing x-jwt-assertion " +
            "header.", xJWT);
            return ctx.next();
        }

        AnalyticsDataRecord|http:NextService|error? dataToWrite = constructAnalyticsDataRecord(ctx, req, res);
        if dataToWrite is http:NextService || dataToWrite is error {
            if dataToWrite is error {
                log:printDebug("[AnalyticsResponseInterceptor] Skipped writing analytics data. Error constructing " +
                "analytics data record.", dataToWrite);
            }
            return dataToWrite;
        }

        if dataToWrite is AnalyticsDataRecord {
            // Write analytics data asynchronously
            log:printDebug("[AnalyticsResponseInterceptor] Writing analytics data using the analytics writer.");
            future<error?> _ = start writeAnalyticsDataToFile(dataToWrite);
            return ctx.next();
        }
        return;
    }
}

# Constructs the analytics data record from the HTTP request and response.
# 
# + ctx - The HTTP request context
# + req - The HTTP request
# + res - The HTTP response
# + return - The constructed analytics data record or an error if construction fails
isolated function constructAnalyticsDataRecord(http:RequestContext ctx, http:Request req, http:Response res) returns AnalyticsDataRecord|http:NextService|error? {

    map<string> & readonly requestHeaders = getRequestHeaders(req, true);
    map<string> & readonly responseHeaders = getResponseHeaders(res);
    int statusCode = res.statusCode;
    string requestPath  = req.rawPath;
    string httpMethod = req.method;

    if analytics.shouldPublishPayloads {
        (json|http:ClientError) & readonly requestPayload = req.getJsonPayload().cloneReadOnly();
        if requestPayload is http:ClientError {
            // This means a payload is not present
            requestPayload = ();
        }
        (json|http:ClientError) & readonly responsePayload = res.getJsonPayload().cloneReadOnly();
        if responsePayload is http:ClientError {
            // This means a payload is not present
            responsePayload = ();
        }

        if requestPayload is () && responsePayload is () {
            return {
                requestHeaders: requestHeaders,
                responseHeaders: responseHeaders,
                statusCode: statusCode,
                requestPath: requestPath,
                httpMethod: httpMethod
            };
        } else if (requestPayload is json) && responsePayload is () {
            return {
                requestHeaders: requestHeaders,
                responseHeaders: responseHeaders,
                statusCode: statusCode,
                requestPath: requestPath,
                httpMethod: httpMethod,
                requestPayload: requestPayload
            };
        } else if (requestPayload is () && responsePayload is json) {
            return {
                requestHeaders: requestHeaders,
                responseHeaders: responseHeaders,
                statusCode: statusCode,
                requestPath: requestPath,
                httpMethod: httpMethod,
                responsePayload: responsePayload
            };
        } else if (requestPayload is json && responsePayload is json) {
            return {
                requestHeaders: requestHeaders,
                responseHeaders: responseHeaders,
                statusCode: statusCode,
                requestPath: requestPath,
                httpMethod: httpMethod,
                requestPayload: requestPayload,
                responsePayload: responsePayload
            };
        }
    }
    return {
        requestHeaders: requestHeaders,
        responseHeaders: responseHeaders,
        statusCode: statusCode,
        requestPath: requestPath,
        httpMethod: httpMethod
    };
}

# Writes the analytics data to a file.
# 
# + analyticsDataRecord - The analytics data record to write
# + return - An error if writing fails
isolated function writeAnalyticsDataToFile(AnalyticsDataRecord analyticsDataRecord) returns error? {

    lock {
        string jwt = analyticsDataRecord.requestHeaders.get(X_JWT_HEADER);
    
        [jwt:Header, jwt:Payload]|error decodedJWT = decodeJWT(jwt);
        if decodedJWT is error {
            log:printError("[AnalyticsResponseInterceptor] Error decoding JWT token.", decodedJWT);
            return;
        }
        [jwt:Header, jwt:Payload] [_, payload] = decodedJWT;

        map<string> analyticsDataFromJwt = extractAnalyticsDataFromJWT(analytics.jwtAttributes, payload);
        json requestHeadersJson = convertMapToJson(analyticsDataRecord.requestHeaders);
        json responseHeadersJson = convertMapToJson(analyticsDataRecord.responseHeaders);
        string? fhirUser = extractFhirUserFromJWT(payload);

        // Enrich payload is only available if the payload publishing is enabled.
        if analytics.shouldPublishPayloads == true {
            // If analytics data enrichment is enabled, fetch and add to analytics data
            if analytics.enrichPayload is AnalyticsPayloadEnrich && analytics.enrichPayload?.enabled == true {
                enrichAnalyticsData(analyticsDataFromJwt, dataEnrichHttpClient);
            }
        }

        // Construct the analytics data record
        Request request = {
            time: time:utcToString(time:utcNow()),
            uri: analyticsDataRecord.requestPath,
            verb: analyticsDataRecord.httpMethod,
            headers: requestHeadersJson
        };

        Response response = {
            time: time:utcToString(time:utcNow()),
            headers: responseHeadersJson,
            status: analyticsDataRecord.statusCode
        };
        request.body = analyticsDataRecord?.requestPayload;
        response.body = analyticsDataRecord?.responsePayload;

        AnalyticsData analyticsData = {
            request: request,
            response: response,
            metadata: analyticsDataFromJwt
        };

        if fhirUser is string {
            analyticsData.user_id = fhirUser;
        }

        // Convert analytics data to JSON string
        json analyticsJson = analyticsData.toJson();
        string logLine = analyticsJson.toJsonString() + "\n";
        string logFilePath = string `${getFilePathBasedOnConfiguration()}${file:pathSeparator}${getFileNameBasedOnConfiguration()}${LOG_FILE_EXTENSION}`;

        // Flow won't come to this point if we don't have a file to write to. Hence no checking required.
        check writeDataToFile(logFilePath, logLine);
        log:printDebug(string `Successfully wrote the analytics data to file: ${getFileNameBasedOnConfiguration().concat(LOG_FILE_EXTENSION)}`);
        return;
    }
}
