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

import ballerina/jwt;
import ballerina/log;
import ballerinax/mysql.driver as _;
import ballerina/time;
import ballerinax/health.fhir.r4;
import health.fhirr4.store;
import ballerina/task;
import ballerina/http;

type MoesifActionsPayload record {|
    string action_name;
    string user_id?;
    string company_id?;
    string transaction_id?;
    Request request;
    json metadata?;
|};

type Request record {|
    string uri;
|};

configurable AnalyticsConfig analyticsConfig = {};

# MoesifAnalyticsPublisher implements the AnalyticsPublisher interface for Moesif.
isolated service class MoesifAnalyticsPublisher {
    *r4:FhirAnalyticsPublisher;

    final string resourceType;
    private store:Client? dbClient;

    # Initializes the Moesif analytics publisher
    isolated function init(r4:ResourceAPIConfig apiConfig) {
        
        if moesifPublisherJob.appId == "" || moesifPublisherJob.url == "" {
            log:printWarn("[MoesifPublisherJob] Moesif configuration missing. Data will not be published.");
            return;
        }
        
        self.resourceType = apiConfig.resourceType;

        lock {
            if moesifPublisherJob.enabled {
                task:JobId|error jobId = task:scheduleJobRecurByFrequency(new MoesifAnalyticsPublisherJob(), moesifPublisherJob.frequency);
                if jobId is error {
                    log:printError("[MoesifAnalyticsPublisher] Failed to start Moesif publisher job.", jobId);
                    return;
                }
                log:printInfo(string `[MoesifAnalyticsPublisher] Scheduled job started successfully.`);
            } else {
                if !moesifPublisherJob.enabled {
                    log:printWarn("[MoesifAnalyticsPublisher] Scheduled job is disabled.");
                    return;
                }
            }
        }
    }

    # Publishes analytics data to Moesif
    #
    # + requestHeaders - The HTTP request headers
    # + requestPayload - The HTTP request payload
    # + responseHeaders - The HTTP response headers
    # + responsePayload - The HTTP response payload
    # + statusCode - The HTTP status code of the response
    # + requestPath - The request path of the API call
    # + return - An error if the publishing fails
    public isolated function publish(map<string[]> requestHeaders, json|http:ClientError requestPayload, 
                                map<string[]> responseHeaders, json|http:ClientError responsePayload, int statusCode, 
                                string requestPath) returns error? {

        string jwt = requestHeaders.get(X_JWT_HEADER)[0];
        [jwt:Header, jwt:Payload]|error decodedJWT = jwt:decode(jwt);
        if decodedJWT is error {
            log:printError("[MoesifAnalyticsPublisher] Error decoding JWT token.", decodedJWT);
            return;
        }
        
        [jwt:Header, jwt:Payload] [_, payload] = decodedJWT;

        // Construct the payload for storage
        map<string> analyticsData = map from string attrKey in analytics.attributes
                where payload[attrKey] !== ()
                select [attrKey, payload[attrKey].toString()];

            analyticsData["resourceType"] = self.resourceType;
            analyticsData["timestamp"] = time:utcToString(time:utcNow());
            analyticsData["statusCode"] = statusCode.toString();
            analyticsData["rawPath"] = requestPath;

        // Insert the data into the database
        error? publishDataToStoreResult = publishDataToStore(analyticsData.toString());
        log:printDebug("[MoesifAnalyticsPublisher] Data published to store: " + (publishDataToStoreResult is error ? publishDataToStoreResult.message() : "Success"));
        
        if publishDataToStoreResult is error {
            log:printError("[MoesifAnalyticsPublisher] Failed to publish data to store. Analytics Data will not be published to Moesif.", publishDataToStoreResult);
            return publishDataToStoreResult;
        }
    }
}

# Publishes the analytics data to the database for later processing
#
# + dataToStore - The analytics data to store
# + return - An error if the operation fails
isolated function publishDataToStore(string dataToStore) returns error? {
    
    store:Client dbClient = check new ();

    store:MoesifDataInsert[] data = [{
        data: dataToStore.toBytes(),
        published: false
    }];
    int[] ids = check dbClient->/moesifdata.post(data);
    log:printDebug("[publishDataToStore] Inserted record IDs: " + ids.toString());
}
