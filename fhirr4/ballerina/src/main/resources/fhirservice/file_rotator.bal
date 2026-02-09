// Copyright (c) 2026, WSO2 LLC. (https://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/file;
import ballerina/task;
import ballerina/time;
import ballerina/log;

// File rotation job implementation
class AnalyticsFileRotationJob {
    *task:Job;
    
    public function execute() {
        rotateAnalyticsDataFile();
    }
}

// Initialize log rotator to run daily at 12 AM
public isolated function initFileRotator() {
    
    AnalyticsFileRotationJob fileRotationJob = new();
    
    // Calculate delay until next 12 AM
    time:Civil delayUntilMidnight = calculateDelayUntilMidnight(time:utcNow());
    
    // Schedule recurring execution every 24 hours starting from next midnight
    task:JobId|task:Error recurringResult = task:scheduleJobRecurByFrequency(fileRotationJob, 86400, maxCount = -1, 
        startTime = delayUntilMidnight);
    if recurringResult is task:Error {
        log:printError("Failed to schedule analytics file rotation task", err = recurringResult.toBalString());
    } else {
        string|error delayUntilMidnightString = time:civilToString(delayUntilMidnight);
        if delayUntilMidnightString is string {
            log:printInfo(string `Analytics file rotation task scheduled successfully. First run at: ${delayUntilMidnightString}`);
        }
    }
}

// Rotate analytics log file by renaming with current date and creating a new file
isolated function rotateAnalyticsDataFile() {

    // Get the date for the previous day
    time:Utc utc = time:utcAddSeconds(time:utcNow(), -86400);
    string date = time:utcToString(utc).substring(0, 10); // YYYY-MM-DD format
    
    string currentLogFile = analytics.analyticsFilePath + "/" + logFileName;
    string rotatedLogFile = analytics.analyticsFilePath + "/cms-analytics-" + date + ".log";
    
    // Check if the current log file exists
    boolean|error fileExists = file:test(currentLogFile, file:EXISTS);
    
    if fileExists is boolean {
        if fileExists {
            // Rename the current log file with the date
            error? renamingError = file:rename(currentLogFile, rotatedLogFile);
            if renamingError is error {
                log:printError(rotationErrorMessage, err = renamingError.toBalString());
                return;
            }
            log:printDebug(string `CMS analytics log file rotated successfully to: ${rotatedLogFile}`);
            
            // Create a new empty analytics.log file
            error? creationError = file:create(currentLogFile);
            if creationError is error {
                log:printError(rotationErrorMessage, err = creationError.toBalString());
                return;
            }
            log:printWarn(string `New CMS analytics.log file created: ${currentLogFile}`);
        } else {
            log:printWarn(string `No CMS analytics.log file found to rotate at: ${currentLogFile}`);
        }
    } else {
        log:printError(rotationErrorMessage, err = fileExists.toBalString());
    }
}
