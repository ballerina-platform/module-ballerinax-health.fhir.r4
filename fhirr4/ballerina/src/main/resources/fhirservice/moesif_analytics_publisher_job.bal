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
import ballerina/log;
import ballerina/task;
import health.fhirr4.store;
import ballerina/lang.runtime;
import ballerina/uuid;

# MoesifPublisherJobConfig Record.
#
# + enabled - Whether the scheduled job is enabled
# + frequency - The frequency in seconds at which the job should run
# + batchSize - The number of records to process in each job execution
# + maxRetries - Maximum number of retry attempts for publishing
# + retryInterval - Initial retry interval in seconds (uses exponential backoff)
public type MoesifPublisherJobConfig readonly & record {|
    boolean enabled = false;
    string appId = "";
    string url = "https://api.moesif.net/v1/actions";
    decimal frequency = 30;
    int batchSize = 100;
    int maxRetries = 3;
    decimal retryInterval = 5;
|};

configurable MoesifPublisherJobConfig moesifPublisherJob = {};

# MoesifAnalyticsPublisherJob executes scheduled publishing of analytics data from database to Moesif.
class MoesifAnalyticsPublisherJob {
    *task:Job;

    private final http:Client? moesifClient;
    private final int batchSize;
    private final int maxRetries;
    private final decimal retryInterval;

    # Initializes the MoesifAnalyticsPublisherJob
    isolated function init() {
        
        self.batchSize = moesifPublisherJob.batchSize;
        self.maxRetries = moesifPublisherJob.maxRetries;
        self.retryInterval = moesifPublisherJob.retryInterval;

        http:Client|http:ClientError httpClient = new (moesifPublisherJob.url);

        if httpClient is http:ClientError {
            log:printError("[MoesifPublisherJob] Failed to initialize Moesif HTTP client.", httpClient);
            self.moesifClient = ();
            return;
        } else {
            self.moesifClient = httpClient;
            log:printDebug("[MoesifPublisherJob] Moesif publisher job initialized successfully.");
        }
    }

    # Executes the job to publish unpublished analytics data
    public function execute() {

        log:printDebug("[MoesifPublisherJob] Starting scheduled job execution.");
        http:Client? moesifHttpClient = self.moesifClient;
        if moesifHttpClient is () {
            log:printDebug("[MoesifPublisherJob] Moesif client not initialized. Skipping job execution.");
            return;
        }

        error? publishResult = self.publishUnpublishedData(moesifHttpClient);
        if publishResult is error {
            log:printError("[MoesifPublisherJob] Error during job execution.", publishResult);
        } else {
            log:printDebug("[MoesifPublisherJob] Job execution completed successfully.");
        }
    }

    # Publishes unpublished data from the database to Moesif
    #
    # + moesifHttpClient - The Moesif HTTP client
    # + return - An error if the operation fails
    isolated function publishUnpublishedData(http:Client moesifHttpClient) returns error? {
        
            
        store:Client|error dbClient = new ();

        if dbClient is error {
            log:printError("[MoesifPublisherJob] Failed to initialize database client.", dbClient);
            return dbClient;
        }

        stream<store:MoesifData, error?> unpublishedStream = dbClient->/moesifdata.get(
            whereClause = ` published = false `,
            limitClause = ` ${self.batchSize}`
        );

        int processedCount = 0;
        int successCount = 0;
        int failureCount = 0;

        check from store:MoesifData moesifRecord in unpublishedStream
        
        do {
            processedCount += 1;
            error? publishResult = self.publishRecordToMoesif(moesifHttpClient, dbClient, moesifRecord);
            if publishResult is error {
                failureCount += 1;
                log:printError(string `[MoesifPublisherJob] Failed to publish record ID: ${moesifRecord.id}`, publishResult);
            } else {
                successCount += 1;
            }
        };

        if processedCount > 0 {
            log:printInfo(string `[MoesifPublisherJob] Processed ${processedCount} records. Success: ${successCount}, Failed: ${failureCount}`);
        } else {
            log:printDebug("[MoesifPublisherJob] No unpublished records found.");
        } 
    }

    # Publishes a single record to Moesif with retry logic
    #
    # + moesifHttpClient - The Moesif HTTP client
    # + dbClient - The database client
    # + moesifRecord - The record to publish
    # + return - An error if all retry attempts fail
    isolated function publishRecordToMoesif(http:Client moesifHttpClient, store:Client dbClient, store:MoesifData moesifRecord) returns error? {
        
        string dataString = check string:fromBytes(moesifRecord.data);
        
        json|error analyticsData = dataString.fromJsonString();
        
        if analyticsData is error {
            log:printError(string `[MoesifPublisherJob] Invalid JSON data in record ID: ${moesifRecord.id}`, analyticsData);
            return analyticsData;
        }

        MoesifActionsPayload moesifPayload = formatMoesifPayload(analyticsData);

        int attemptCount = 0;
        error? publishError = ();

        while attemptCount < self.maxRetries {
            attemptCount += 1;
            http:Response|http:ClientError response = moesifHttpClient->post("", moesifPayload, {
                "X-Moesif-Application-Id": moesifPublisherJob.appId
            });

            if response is http:ClientError {
                publishError = response;
                log:printWarn(string `[MoesifPublisherJob] Attempt ${attemptCount}/${self.maxRetries} failed for record ID: ${moesifRecord.id}`, response);

                if attemptCount < self.maxRetries {
                    decimal backoffTime = self.retryInterval * <decimal>(2 ^ (attemptCount - 1));
                    log:printDebug(string `[MoesifPublisherJob] Retrying after ${backoffTime} seconds...`);
                    runtime:sleep(backoffTime);
                }
                continue;
            }

            if response.statusCode < 200 || response.statusCode >= 300 {
                publishError = error(string `Moesif API error: ${response.reasonPhrase}`);
                log:printWarn(string `[MoesifPublisherJob] Attempt ${attemptCount}/${self.maxRetries} returned error status ${response.statusCode} for record ID: ${moesifRecord.id}`);

                if attemptCount < self.maxRetries {
                    decimal backoffTime = self.retryInterval * <decimal>(2 ^ (attemptCount - 1));
                    log:printDebug(string `[MoesifPublisherJob] Retrying after ${backoffTime} seconds...`);
                    runtime:sleep(backoffTime);
                }
                continue;
            }

            // Success - mark as published
            store:MoesifData|error updateResult = dbClient->/moesifdata/[moesifRecord.id].put({
                published: true
            });

            if updateResult is error {
                log:printError(string `[MoesifPublisherJob] Failed to mark record ID: ${moesifRecord.id} as published`, updateResult);
                return updateResult;
            }

            log:printDebug(string `[MoesifPublisherJob] Successfully published record ID: ${moesifRecord.id}`);
            return;
        }

        // All retry attempts failed
        if publishError is error {
            return publishError;
        }
        return error("Failed to publish record after all retry attempts");
    }
}

# Constructs the moesif actions payload using the data to be published.
# 
# + data - Data to be published to Moesif
# + return - The formatted Moesif Actions Payload
isolated function formatMoesifPayload(json data) returns MoesifActionsPayload {

    // rawPath won't be an error
    json|error rawPath = data.rawPath;
    Request request = {
        uri: rawPath is error ? "" : rawPath.toString()
    };

    json|error userId = data.fhirUser;

    MoesifActionsPayload payload = {
        action_name: "FHIR Analytics Data Action",
        user_id: userId is error ? () : userId.toString(),
        transaction_id: uuid:createType1AsString(),
        request: request,
        metadata: data
    };
    return payload;
}
