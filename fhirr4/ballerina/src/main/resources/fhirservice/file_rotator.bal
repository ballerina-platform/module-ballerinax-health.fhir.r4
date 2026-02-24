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

// Flag to track if the file rotation task is already started
isolated boolean fileRotationTaskStarted = false;

// File rotation job implementation
class AnalyticsFileRotationJob {
    *task:Job;
    
    public function execute() {
        rotateAnalyticsDataFile();
    }
}

# Initialize log rotator to run daily at 12 AM
isolated function initFileRotator() {
    
    // Check if task is already started
    lock {
        if fileRotationTaskStarted {
            log:printDebug("Analytics file rotation task is already started. Skipping initialization.");
            return;
        }
        AnalyticsFileRotationJob fileRotationJob = new();
        
        time:Zone|error zone = time:loadSystemZone();
        if zone is error {
            log:printError("Failed to load system time zone for scheduling file rotation task", err = zone.toBalString());
            return;
        }

        // Calculate delay until next 12 AM
        time:Civil|error delayUntilMidnight = calculateDelayUntilMidnight(time:utcNow(), zone);
        if delayUntilMidnight is error {
            log:printError("Failed to calculate delay until next midnight for scheduling file rotation task", err = delayUntilMidnight.toBalString());
            return;
        }

        // Schedule recurring execution every 24 hours starting from next midnight
        task:JobId|task:Error recurringResult = task:scheduleJobRecurByFrequency(fileRotationJob, 86400, maxCount = -1,
            startTime = delayUntilMidnight);
        if recurringResult is task:Error {
            log:printError("Failed to schedule analytics file rotation task", err = recurringResult.toBalString());
        } else {
            fileRotationTaskStarted = true;
            string|error delayUntilMidnightString = time:civilToString(delayUntilMidnight);
            if delayUntilMidnightString is string {
                log:printInfo(string `Analytics file rotation task scheduled successfully. First run at: ${delayUntilMidnightString}`);
            }
        }
    }
}

# Rotate analytics log file by renaming with current date and creating a new file
isolated function rotateAnalyticsDataFile() {

    // Get the date for the previous day
    time:Civil|error? previousDate = getPreviousCivilDate();
    if previousDate is error {
        log:printError("Failed to get the previous date for the file rotation task", err = previousDate.toBalString());
        return;
    }

    if previousDate is time:Civil {
        string date = string `${previousDate.year}-${previousDate.month}-${previousDate.day}`;
        string currentLogFile = string `${analytics.filePath}${file:pathSeparator}${getFileNameBasedOnConfiguration()}${LOG_FILE_EXTENSION}`;
        string rotatedLogFile = string `${analytics.filePath}${file:pathSeparator}${getFileNameBasedOnConfiguration()}-${date}${LOG_FILE_EXTENSION}`;
        
        // Check if the current log file exists
        boolean|error fileExists = file:test(currentLogFile, file:EXISTS);
        
        if fileExists is error {
            log:printError(rotationErrorMessage, fileExists);
        } else {
            if fileExists {
                // Rename the current log file with the date
                error? renamingError = file:rename(currentLogFile, rotatedLogFile);
                if renamingError is error {
                    log:printError(rotationErrorMessage, err = renamingError.toBalString());
                    return;
                }
                log:printInfo(string `Log file rotated successfully to: ${rotatedLogFile}`);
                
                // Create a new empty analytics.log file
                error? creationError = file:create(currentLogFile);
                if creationError is error {
                    log:printError(rotationErrorMessage, err = creationError.toBalString());
                    return;
                }
                log:printInfo(string `New log file created: ${currentLogFile}`);
            } else {
               log:printWarn(string `No log file found to rotate at: ${currentLogFile}`);
               return;
            }
        }
    }
}
