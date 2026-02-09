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

# AnalyticsResponseInterceptor is an HTTP response interceptor that writes analytics data to "cms-analytics.log" file.
isolated service class AnalyticsResponseInterceptor {
    *http:ResponseInterceptor;

    # Initializes file rotator.
    #
    # + apiConfig - The API configuration
    function init(r4:ResourceAPIConfig apiConfig) {
        
        if analytics.enabled {
            string logFilePath = analytics.analyticsFilePath + "/" + logFileName;
            // Check if logs directory exists, create if not
            boolean|error? fileExists = isFileExist(logFilePath);
            if fileExists is boolean && !fileExists {
                error? creationError = file:create(logFilePath);
                if creationError is error {
                    log:printError(string `Configured directory ${analytics.analyticsFilePath} doesn't exist. Error creating analytics log file: ${logFileName}. Analytics data will not be written.`);
                    return;
                }
            }
            // Initialize the file rotator
            initFileRotator();
        }
        return;
    }

    remote isolated function interceptResponse(http:RequestContext ctx, http:Request req, http:Response res) returns http:NextService|error? {
        
        //check excluded APIs from config and skip analytics writing
        if isExcludedApi(req.rawPath) {
            return ctx.next();
        }

        map<string> requestHeaders = getRequestHeaders(req);
        map<string> responseHeaders = getResponseHeaders(res);
        json|http:ClientError requestPayload = req.getJsonPayload();
        json|http:ClientError responsePayload = res.getJsonPayload();
        int statusCode = res.statusCode;
        string requestPath  = req.rawPath;

        string|error xJWT = req.getHeader(X_JWT_HEADER);
        if xJWT is error {
            log:printWarn(`[AnalyticsResponseInterceptor] Skipped writing analytics data. Error: Missing x-jwt-assertion header.`);
            return ctx.next();
        }

        // Write analytics data asynchronously
        log:printDebug(`[AnalyticsResponseInterceptor] Writing analytics data using the analytics writer.`);
        future<error?> _ = start writeAnalyticsData(requestHeaders.cloneReadOnly(), requestPayload.clone(), responseHeaders.cloneReadOnly(), responsePayload.clone(), statusCode, requestPath.cloneReadOnly(), req.method);
        return ctx.next();
    }
}

public isolated function writeAnalyticsData(map<string> requestHeaders, json|http:ClientError requestPayload, 
                                map<string> responseHeaders, json|http:ClientError responsePayload, int statusCode, 
                                string requestPath, string httpMethod) returns error? {

    string jwt = requestHeaders.get(X_JWT_HEADER);
    
    [jwt:Header, jwt:Payload]|error decodedJWT = decodeJWT(jwt);
    if decodedJWT is error {
        log:printError("[MoesifAnalyticsPublisher] Error decoding JWT token.", decodedJWT);
        return;
    }
    [jwt:Header, jwt:Payload] [_, payload] = decodedJWT;

    map<string> analyticsData = extractAnalyaticsDataFromJWT(analytics.jwtAttributes, payload);
    json requestHeadersJson = convertMapToJson(requestHeaders);
    json responseHeadersJson = convertMapToJson(responseHeaders);

    // If analytics data enrichment is enabled, fetch and add to analytics data
    if analytics.enrichAnalyticsPayload is AnalyticsPayloadEnrich && analytics.enrichAnalyticsPayload?.enabled == true {
        enrichAnalyticsData(analyticsData);
    }

    // Construct the analytics data record
    Request request = {
        time: time:utcToString(time:utcNow()),
        uri: requestPath,
        verb: httpMethod,
        headers: requestHeadersJson
    };

    Response response = {
        time: time:utcToString(time:utcNow()),
        headers: responseHeadersJson,
        status: statusCode
    };

    // Decide payload analytics based on config
    if analytics.shouldPublishPayloads && requestPayload !is http:ClientError && responsePayload !is http:ClientError {
        json requestPayloadJson = requestPayload;
        json responsePayloadJson = responsePayload;
        request.body = requestPayloadJson;
        response.body = responsePayloadJson;
    } else {
        log:printDebug("Payload publishing is disabled");
    }

    AnalyticsData analyticsDataRecord = {
        request: request,
        response: response,
        metadata: analyticsData
    };

    // Convert analytics data to JSON string
    json analyticsJson = analyticsDataRecord.toJson();
    string logLine = analyticsJson.toJsonString() + "\n";
    string logFilePath = analytics.analyticsFilePath + "/" + logFileName;
    
    // Flow won't come to this point if we don't have a file to write to. Hence no checking required.
    check writeDataToFile(logFilePath, logLine);
    log:printDebug(string `Successfully wrote the analytics data to file: ${logFileName}`);
    return;
}
