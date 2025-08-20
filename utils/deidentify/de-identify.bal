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
configurable boolean fhirResourceValidation = true;

configurable FHIRPathRule[] fhirPathRules = [
    {
        fhirPath: "Patient.name",
        operation: "mask"
    }
];

# FHIRPathRule is a record type that defines a rule for modifying FHIR resources using FHIRPath expressions.
#
# + fhirPath - The FHIRPath expression to select the field(s) to be modified.
# + operation - The operation to be performed on the selected field(s).
public type FHIRPathRule record {|
    string fhirPath;
    string operation;
|};

# Initializing the default operations for FHIRPath modification functions.
isolated map<fhirpath:ModificationFunction> initOperations = {
    mask: <fhirpath:ModificationFunction>starMaskOperation,
    encrypt: <fhirpath:ModificationFunction>encryptOperation,
    hash: <fhirpath:ModificationFunction>hashOperation
};

# Function to register custom modification functions for FHIRPath operations. Provided map of functions will be appended to the existing operations.
# Functions with same key in the map will override the existing ones.
#
# + functions - Map of FHIRPath modification functions to register.
public isolated function registerModificationFunctions(map<fhirpath:ModificationFunction> functions) {
    foreach var [key, value] in functions.entries() {
        lock {
            initOperations[key] = value;
        }
    }
}

# Function to de-identify FHIR data. It can handle both single FHIR resources and FHIR Bundles.
#
# + fhirResource - The FHIR resource to be de-identified.
# + validateFHIRResource - Flag indicating whether to validate the FHIR resource.
# + skipError - Flag indicating whether to skip errors during de-identification.
# + return - The de-identified FHIR resource or an error.
public isolated function deIdentifyFhirData(json fhirResource, boolean validateFHIRResource = fhirResourceValidation, boolean skipError = skipOnError) returns json|DeIdentificationError {
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
            return deIdentifyBundle(fhirResource, validateFHIRResource, skipError);
        }
    }

    // Process single resource (existing logic)
    return deIdentifySingleResource(fhirResource, validateFHIRResource, skipError);
}

isolated function deIdentifyBundle(json bundleResource, boolean validateFHIRResource, boolean skipError) returns json|DeIdentificationError {
    if !(bundleResource is map<json>) {
        return createDeIdentificationError("Invalid bundle format: expected map<json>");
    }

    map<json> bundleMap = <map<json>>bundleResource;

    // Check if the bundle has an entry field
    if !bundleMap.hasKey("entry") {
        log:printDebug("Bundle has no entry field, returning bundle as-is");
        return bundleResource;
    }

    json entryField = bundleMap.get("entry");

    if !(entryField is json[]) {
        return createDeIdentificationError("Invalid bundle entry format: expected json array");
    }

    json[] entries = <json[]>entryField;
    json[] deIdentifiedEntries = [];

    log:printInfo("Processing FHIR Bundle with " + entries.length().toString() + " entries");

    foreach int i in 0 ..< entries.length() {
        json entry = entries[i];

        if !(entry is map<json>) {
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
        json|DeIdentificationError deIdentifiedResource = deIdentifySingleResource(resourceField, validateFHIRResource, skipError);

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

    log:printInfo(`Completed processing FHIR Bundle with ${deIdentifiedEntries.length().toString()} entries`);

    return deIdentifiedBundle;
}

isolated function deIdentifySingleResource(json fhirResource, boolean validateFHIRResource, boolean skipError) returns json|DeIdentificationError {
    // Check if the single resource is empty before processing
    if isEmptyResource(fhirResource) {
        log:printDebug("Empty single resource detected, returning as-is");
        return fhirResource;
    }

    map<fhirpath:ModificationFunction> & readonly operations;
    lock {
        operations = initOperations.cloneReadOnly();
    }

    log:printDebug(`Available Operations: ${[...operations.keys(), "redact"].toString()}`);
    log:printDebug("Provided Rules: ");
    foreach FHIRPathRule rule in fhirPathRules {
        log:printDebug(`[RULE] FHIR Path: ${rule.fhirPath}, Operation: ${rule.operation}`);
    }
    log:printDebug(`Original Resource: ${fhirResource.toJsonString()}`);

    json modifiedResource = fhirResource;

    foreach FHIRPathRule rule in fhirPathRules {
        log:printDebug(`[PROCESSING RULE] FHIR Path: ${rule.fhirPath} | Operation: ${rule.operation}`);

        json|fhirpath:FHIRPathError modifiedResourceTemp = modifiedResource;

        // Handling redact operation seperately since it removes the fhir path entirely.
        if rule.operation == "redact" {
            modifiedResourceTemp = fhirpath:setFhirPathValues(modifiedResource, rule.fhirPath, (), validateFHIRResource = validateFHIRResource);
        }

        foreach string operation in operations.keys() {
            if rule.operation == operation {
                modifiedResourceTemp = fhirpath:setFhirPathValues(modifiedResource, rule.fhirPath, <fhirpath:ModificationFunction>operations[operation], validateFHIRResource = validateFHIRResource);
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
