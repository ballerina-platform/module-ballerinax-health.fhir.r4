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
import ballerinax/health.fhir.r4utils.fhirpath;

configurable string cryptoHashKey = "wso2-healthcare-hash";
configurable string encryptKey = "wso2-healthcare-encrypt";
configurable boolean skipOnError = true;
configurable boolean inputFHIRResourceValidation = false;
configurable boolean outputFHIRResourceValidation = false;

configurable DeIdentifyRule[] rules = [
    {
        fhirPaths: ["Patient.name"],
        operation: "mask"
    }
];

# DeIdentifyRule is a record type that defines a rule for de-identifying FHIR resources using a list of FHIRPath expressions.
#
# + fhirPaths - The FHIRPath expressions to select the field(s) to be modified.
# + operation - The operation to be performed on the selected field(s).
public type DeIdentifyRule record {|
    string[] fhirPaths;
    string operation;
|};

# Initializing the default operations for FHIRPath modification functions.
isolated map<DeIdentificationFunction> initOperations = {
    mask: <DeIdentificationFunction>starMaskOperation,
    encrypt: <DeIdentificationFunction>encryptOperation,
    hash: <DeIdentificationFunction>hashOperation
};

# Rule with a single fhir path
#
# + fhirPath - The FHIRPath expression to select the field(s) to be modified.
# + operation - The operation to be performed on the selected field(s).
type Rule record {|
    string fhirPath;
    string operation;
|};

# Simplifies the de-identification rules by flattening the FHIRPath expressions.
#
# + rules - The array of DeIdentifyRule to simplify.
# + return - The simplified array of Rule.
isolated function simplifyRules(DeIdentifyRule[] rules) returns Rule[] {
    Rule[] simplifiedRules = [];
    foreach var rule in rules {
        foreach var path in rule.fhirPaths {
            simplifiedRules.push({
                fhirPath: path,
                operation: rule.operation
            });
        }
    }
    return simplifiedRules;
}

# Function to de-identify FHIR data. It can handle both single FHIR resources and FHIR Bundles.
#
# + fhirResource - The FHIR resource to be de-identified.
# + operations - Map of custom de-identification operations to use. Provided operations will be appended to the existing ones. Existing operations will be overridden if they have the same key.
# + deIdentifyRules - Array of DeIdentifyRule defining the de-identification rules to apply. Defaults to the configured rules in Config.toml
# + validateInputFHIRResource - Flag indicating whether to validate the input FHIR resource. Defaults to false or the value in Config.toml if configured.
# + validateOutputFHIRResource - Flag indicating whether to validate the output FHIR resource. Defaults to false or the value in Config.toml if configured.
# + skipError - Flag indicating whether to skip errors during de-identification. Defaults to false or the value in Config.toml if configured.
# + return - The de-identified FHIR resource or an error.
public isolated function deIdentify(json fhirResource, map<DeIdentificationFunction> operations = {}, DeIdentifyRule[] deIdentifyRules = rules, boolean validateInputFHIRResource = inputFHIRResourceValidation, boolean validateOutputFHIRResource = outputFHIRResourceValidation,
        boolean skipError = skipOnError) returns json|DeIdentificationError {

    // Register any custom functions provided. Provided map of functions will be appended to the existing operations.
    // Functions with same key in the map will override the existing ones.
    foreach var [key, value] in operations.entries() {
        lock {
            initOperations[key] = value;
        }
    }

    log:printDebug("Starting de-identification process for FHIR resource: " + fhirResource.toJsonString());

    // Check if the resource is empty
    if isEmptyResource(fhirResource) {
        log:printDebug("Empty resource detected, returning as-is");
        return fhirResource;
    }

    // Check if the resource is a Bundle
    if fhirResource is map<json> {
        json|error resourceType = fhirResource.get("resourceType");
        if resourceType is string && resourceType == "Bundle" {
            log:printDebug("Detected FHIR Bundle resource, processing multiple resources");
            return deIdentifyBundle(fhirResource, simplifyRules(deIdentifyRules), validateInputFHIRResource, validateOutputFHIRResource, skipError);
        }
    }

    // Process single resource (existing logic)
    return deIdentifySingleResource(fhirResource, simplifyRules(deIdentifyRules), validateInputFHIRResource, validateOutputFHIRResource, skipError);
}

isolated function deIdentifyBundle(json bundleResource, Rule[] deIdentifyRules, boolean validateInputFHIRResource, boolean validateOutputFHIRResource, boolean skipError) returns json|DeIdentificationError {

    if bundleResource !is map<json> {
        return createDeIdentificationError("Invalid bundle format: expected map<json>");
    }

    map<json> bundleMap = <map<json>>bundleResource;

    // Check if the bundle has an entry field
    if !bundleMap.hasKey("entry") {
        log:printDebug("Bundle has no entry field, returning bundle as-is");
        return bundleResource;
    }

    json entryField = bundleMap.get("entry");

    if entryField !is json[] {
        return createDeIdentificationError("Invalid bundle entry format: expected json array");
    }

    json[] entries = <json[]>entryField;
    json[] deIdentifiedEntries = [];

    log:printDebug("Processing FHIR Bundle with " + entries.length().toString() + " entries");

    foreach int i in 0 ..< entries.length() {
        json entry = entries[i];

        if entry !is map<json> {
            if skipError {
                log:printWarn(`Skipping invalid entry at index ${i.toString()}: not a map`);
                deIdentifiedEntries.push(entry);
                continue;
            } else {
                return createDeIdentificationError(string `Invalid entry format at index ${i.toString()}: expected map<json>`);
            }
        }

        map<json> entryMap = <map<json>>entry;

        // Check if the entry has a resource field
        if !entryMap.hasKey("resource") {
            log:printDebug(`Entry at index ${i.toString()} has no resource field, keeping entry as-is`);
            deIdentifiedEntries.push(entry);
            continue;
        }

        json resourceField = entryMap.get("resource");

        log:printDebug(`Processing entry ${i + 1}/${entries.length()}`);

        // De-identify the individual resource
        json|DeIdentificationError deIdentifiedResource = deIdentifySingleResource(resourceField, deIdentifyRules, validateInputFHIRResource, validateOutputFHIRResource, skipError);

        if deIdentifiedResource is DeIdentificationError {
            if skipError {
                log:printWarn(`Skipping entry at index ${i.toString()} due to de-identification error: ${deIdentifiedResource.message()}`);
                deIdentifiedEntries.push(entry);
                continue;
            } else {
                return deIdentifiedResource;
            }
        }

        // Create new entry with de-identified resource
        map<json> newEntry = entryMap.clone();
        newEntry["resource"] = deIdentifiedResource;
        deIdentifiedEntries.push(newEntry);

        log:printDebug(`Completed processing entry ${i + 1}/${entries.length()}`);
    }

    // Create new bundle with de-identified entries
    map<json> deIdentifiedBundle = bundleMap.clone();
    deIdentifiedBundle["entry"] = deIdentifiedEntries;

    log:printDebug(`Completed processing FHIR Bundle with ${deIdentifiedEntries.length().toString()} entries`);

    return deIdentifiedBundle;
}

isolated function deIdentifySingleResource(json fhirResource, Rule[] deIdentifyRules, boolean validateInputFHIRResource, boolean validateOutputFHIRResource, boolean skipError) returns json|DeIdentificationError {

    // Check if the single resource is empty before processing
    if isEmptyResource(fhirResource) {
        log:printDebug("Empty single resource detected, returning as-is");
        return fhirResource;
    }

    map<DeIdentificationFunction> & readonly operations;
    lock {
        operations = initOperations.cloneReadOnly();
    }

    log:printDebug(`Available Operations: ${[...operations.keys(), "redact"].toString()}`);
    log:printDebug("Provided Rules: ", rules = deIdentifyRules.toJson());
    log:printDebug(`Original Resource: ${fhirResource.toJsonString()}`);

    json modifiedResource = fhirResource;

    foreach Rule rule in deIdentifyRules {
        log:printDebug(`[PROCESSING RULE] FHIR Path: ${rule.fhirPath} | Operation: ${rule.operation}`);

        json|fhirpath:FHIRPathError modifiedResourceTemp = modifiedResource;

        // Handling redact operation seperately since it removes the fhir path entirely.
        if rule.operation == "redact" {
            modifiedResourceTemp = fhirpath:setValuesToFhirPath(modifiedResource, rule.fhirPath, (), validateInputFHIRResource = validateInputFHIRResource,
                    validateOutputFHIRResource = validateOutputFHIRResource);
        }

        foreach string operation in operations.keys() {
            if rule.operation == operation {
                modifiedResourceTemp = fhirpath:setValuesToFhirPath(modifiedResource, rule.fhirPath, <fhirpath:ModificationFunction>operations[operation],
                        validateInputFHIRResource = validateInputFHIRResource, validateOutputFHIRResource = validateOutputFHIRResource);
                break;
            }
        }

        // Handle errors from the modification
        if modifiedResourceTemp is fhirpath:FHIRPathError {
            if skipError {
                log:printWarn(`Skipping operation: ${rule.operation} | FHIR path: ${rule.fhirPath} | Error: ${modifiedResourceTemp.message()}`);
                continue;
            } else {
                return createDeIdentificationError(modifiedResourceTemp.message(), fhirPath = rule.fhirPath);
            }
        } else {
            modifiedResource = modifiedResourceTemp;
            log:printDebug(`Modified resource after applying rule: ${modifiedResource.toJsonString()}`);
        }
    }

    log:printDebug(`Final modified resource: ${modifiedResource.toJsonString()}`);
    return modifiedResource;
}
