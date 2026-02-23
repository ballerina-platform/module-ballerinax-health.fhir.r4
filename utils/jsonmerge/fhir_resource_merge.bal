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

import ballerina/log;
import ballerinax/health.fhir.r4 as r4;
import ballerinax/health.fhir.r4.validator as validator;
# Description.
# 
# Merges two FHIR R4 resources with validation and merge strategies.
# This function provides a higher-level interface for merging FHIR resources while ensuring
# that both input and output resources conform to FHIR R4 standards.
#
# + originalResource - The original FHIR resource (JSON format) that serves as the foundation
# + updatesResource - The updates FHIR resource (JSON format) containing updates to merge
# + keys - Optional map specifying merge keys for FHIR resource arrays
# + return - Merged FHIR resource as JSON or error if validation fails or merge encounters issues
function mergeFHIRResources(json originalResource, json updatesResource, map<string[]>? keys = ()) returns json|error {
    // Input validation: Validate original and updates FHIR resources
    // Ensure original resource is a valid JSON object
    if originalResource !is map<json> {
        return error("Original resource must be a valid JSON object");
    }
    //Ensure updates resource is a valid JSON object
    if updatesResource !is map<json> {
        return error("Updates resource must be a valid JSON object");
    }

    // Ensures the original resource conforms to FHIR R4 standards before attempting merge
    // This prevents merging with invalid base data that could corrupt the result
    r4:FHIRValidationError? validateOriginalFHIRResourceJson = validator:validate(originalResource);
    if validateOriginalFHIRResourceJson is error {
        log:printError(validateOriginalFHIRResourceJson.detail().toString());
        return error("Original FHIR resource is invalid: " + validateOriginalFHIRResourceJson.message());
    }

    // Ensures the updates resource conforms to FHIR R4 standards before attempting merge
    // This prevents introducing invalid data during the merge process
    r4:FHIRValidationError? validateUpdatesFHIRResourceJson = validator:validate(updatesResource);
    if validateUpdatesFHIRResourceJson is error {
        log:printError(validateUpdatesFHIRResourceJson.detail().toString());
        return error("Updates FHIR resource is invalid: " + validateUpdatesFHIRResourceJson.message());
    }

    // Perform the merge using the mergeJson function
    json|error mergedResult = mergeJson(originalResource, updatesResource, keys);
    if mergedResult is error {
        return error("Failed to merge FHIR resources: " + mergedResult.message());
    }

    // Validate the merged result to ensure it conforms to FHIR R4 standards
    // Ensure the merge operation didn't produce an invalid FHIR resource
    r4:FHIRValidationError? validateMergedFHIRResourceJson = validator:validate(mergedResult);
    if validateMergedFHIRResourceJson is error {
        log:printError(validateMergedFHIRResourceJson.detail().toString());
        return error("Merged FHIR resource is invalid: " + validateMergedFHIRResourceJson.message());
    } else {
        return mergedResult;
    }

}
