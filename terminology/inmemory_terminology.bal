// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
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
import ballerina/lang.regexp;
import ballerina/log;
import ballerinax/health.fhir.r4;

isolated class InMemoryTerminology {
    *Terminology;
    # Global records to store Terminologies across different profiles and packages.
    private map<r4:CodeSystem> codeSystemMap = {};
    private map<r4:ValueSet> valueSetMap = {};

    isolated function init() {

        // https://hl7.org/fhir/R4/terminologies-systems.html
        json internalFhirCodeSystems = [];

        // https://hl7.org/fhir/R4/terminologies-valuesets.html - Internal
        json internalFhirValueSets = [];

        // https://terminology.hl7.org/5.4.0/codesystems-fhir.html
        json externalFhirCodeSystems = [];

        // https://terminology.hl7.org/5.4.0/valuesets-fhir.html
        json externalFhirValueSets = [];
        do {
            // We should create terminology as json string constants
            // We can't pack those static files with r4 modules to Ballerina central.
            // https://github.com/ballerina-platform/ballerina-spec/issues/1100
            internalFhirCodeSystems = check DEFAULT_FHIR_CODE_SYSTEMS.fromJsonString();
            internalFhirValueSets = check DEFAULT_FHIR_VALUE_SETS.fromJsonString();
            externalFhirCodeSystems = check EXTERNAL_FHIR_CODE_SYSTEMS.fromJsonString();
            externalFhirValueSets = check EXTERNAL_FHIR_VALUE_SETS.fromJsonString();
        } on fail var e {
            r4:FHIRError fhirError = r4:createFHIRError(
                                    "Error occurred while type casting json string Terminologies json objects",
                                    r4:ERROR,
                                    r4:PROCESSING,
                                    diagnostic = e.message(),
                                    cause = e
                                );
            log:printError(fhirError.toBalString());
        }

        lock {
            // Call the populateCodeSystemMap function
            self.codeSystemMap = self.populateCodeSystemMap(internalFhirCodeSystems, externalFhirCodeSystems, self.codeSystemMap).clone();
            self.valueSetMap = self.populateValueSetMap(internalFhirValueSets, externalFhirValueSets, self.valueSetMap).clone();
        }

        // Initialiase terminology processor
        log:printInfo("FHIR R4 InMemory Terminology implementation is initialized.");
    }

    // Define the populateCodeSystemMap function
    isolated function populateCodeSystemMap(json internalFhirCodeSystems, json externalFhirCodeSystems, map<r4:CodeSystem> codeSystemMap) returns map<r4:CodeSystem> {
        // Implementation logic goes here
        map<r4:CodeSystem> resultedCodeSystemMap = codeSystemMap;
        // Populate the resultedCodeSystemMap with the code systems from internalFhirCodeSystems and externalFhirCodeSystems
        foreach json codeSystem in [internalFhirCodeSystems, externalFhirCodeSystems] {
            foreach json jCodeSystem in <json[]>codeSystem {
                r4:CodeSystem|error c = jCodeSystem.cloneWithType();
                if c is error {
                    r4:FHIRError fHIRError = r4:createFHIRError(
                                            "Error occurred while type casting json code system to CodeSystem type", r4:ERROR,
                                            r4:PROCESSING,
                                            diagnostic = c.message(),
                                            cause = c
                                        );
                    log:printError(fHIRError.toBalString());
                } else {
                    string key = getKey(<string>c.url, <string>c.version);
                    resultedCodeSystemMap[key] = c;
                }
            }
        }

        // Return the updated codeSystemMap
        return resultedCodeSystemMap;
    }

    isolated function populateValueSetMap(json internalFhirValueSets, json externalFhirValueSets, map<r4:ValueSet> valueSetMap) returns map<r4:ValueSet> {
        // Implementation logic goes here
        map<r4:ValueSet> resultedValueSetMap = valueSetMap;
        // Populate the codeSystemMap with the code systems from internalFhirCodeSystems and externalFhirCodeSystems
        foreach json valueSet in [internalFhirValueSets, externalFhirValueSets] {
            foreach json jValueSet in <json[]>valueSet {
                r4:ValueSet|error v = jValueSet.cloneWithType();
                if v is error {
                    r4:FHIRError fHIRError = r4:createFHIRError(
                                            "Error occurred while type casting json value set to ValueSet type", r4:ERROR,
                                            r4:PROCESSING,
                                            diagnostic = v.message(),
                                            cause = v
                                        );
                    log:printError(fHIRError.toBalString());
                } else {
                    string key = getKey(<string>v.url, <string>v.version);
                    resultedValueSetMap[key] = v;
                }
            }
        }

        // Return the updated codeSystemMap
        return resultedValueSetMap;
    }

    public isolated function addCodeSystem(r4:CodeSystem codeSystem) returns r4:FHIRError? {
        string key = getKey(<string>codeSystem.url, <string>codeSystem.version);
        lock {
            self.codeSystemMap[key] = codeSystem.clone();
        }
        return ();
    }

    public isolated function addValueSet(r4:ValueSet valueSet) returns r4:FHIRError? {
        lock {
            self.valueSetMap[getKey(<string>valueSet.url, <string>valueSet.version)] = valueSet.clone();
        }
        return ();
    }

    public isolated function findCodeSystem(r4:uri? system, string? id, string? version) returns r4:CodeSystem|r4:FHIRError {
        map<r4:CodeSystem> codeSystems = {};
        lock {
            codeSystems = self.codeSystemMap.clone();
        }
        if id != () {
            codeSystems = map from r4:CodeSystem entry in codeSystems
                where entry.id == id
                select [getKey(<string>entry.url, <string>entry.version), entry];
            if codeSystems.length() < 1 {
                return r4:createFHIRError(
                        string `Unknown CodeSystem Id: '${id}'`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
            }
            if version != () {
                codeSystems = map from r4:CodeSystem entry in codeSystems
                    where entry.version == version
                    select [getKey(<string>entry.url, <string>entry.version), entry];

                if codeSystems.length() < 1 {
                    return r4:createFHIRError(
                            string `Unknown version: '${version.toString()}',`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `: there is a CodeSystem in the registry with Id: '${id.toString()}' but cannot find version: '${version.toString()}' of it.`,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                }

            } else {
                // find an available version. since the id is valid there will be at least one valid code system.
                codeSystems = map from r4:CodeSystem entry in codeSystems
                    where entry.version > DEFAULT_VERSION
                    select [getKey(<string>entry.url, <string>entry.version), entry];
            }
            return codeSystems.toArray()[0].clone();
        }

        boolean isIdExistInRegistry = false;
        if version is string && system != () {
            foreach var item in codeSystems.keys() {
                if regexp:isFullMatch(re `${system}\|${version}$`, item) && codeSystems[item] is r4:CodeSystem {
                    return <r4:CodeSystem>codeSystems[item].clone();
                } else if regexp:isFullMatch(re `${system}\|.*`, item) {
                    isIdExistInRegistry = true;
                }
            }

            if isIdExistInRegistry {
                return r4:createFHIRError(
                            string `Unknown version: '${version}',`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `: there is a CodeSystem in the registry with Id: '${system.toString()}' but cannot find version: '${version}' of it.`,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
            }
        } else if system != () {
            r4:CodeSystem codeSystem = {content: "example", status: "unknown"};
            string latestVersion = DEFAULT_VERSION;
            foreach var item in codeSystems.keys() {
                if regexp:isFullMatch(re `${system}\|.*`, item)
                && codeSystems[item] is r4:CodeSystem
                && (<r4:CodeSystem>codeSystems[item]).version > latestVersion {
                    codeSystem = <r4:CodeSystem>codeSystems[item];
                    latestVersion = codeSystem.version ?: DEFAULT_VERSION;
                    isIdExistInRegistry = true;
                }
            }

            if isIdExistInRegistry {
                return codeSystem.clone();
            } else {
                return r4:createFHIRError(
                            string `Unknown CodeSystem: '${system.toBalString()}'`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
            }
        }
        return r4:createFHIRError(
                string `Unknown CodeSystem: '${system.toBalString()}'`,
                r4:ERROR,
                r4:PROCESSING_NOT_FOUND,
                httpStatusCode = http:STATUS_NOT_FOUND
            );
    }

    public isolated function findConcept(r4:uri system, r4:code code, string? version = ()) returns CodeConceptDetails|r4:FHIRError {
        CodeConceptDetails|r4:FHIRError? result = ();
        r4:ValueSet|r4:FHIRError findValueSetResult = self.findValueSet(system, (), version);
        if findValueSetResult is r4:ValueSet {
            CodeConceptDetails[]|r4:canonical[]|r4:FHIRError|CodeSystemMetadata[] conceptResults = findConceptInValueSetOrReturnValueSetURIs(findValueSetResult, code);
            if conceptResults is r4:canonical[] {
                r4:FHIRError? lastError = ();
                foreach r4:canonical refValueSetUrl in conceptResults {
                    r4:ValueSet|r4:FHIRError refValueSet = self.findValueSet(refValueSetUrl, (), ());
                    if refValueSet is r4:ValueSet {
                        CodeConceptDetails[]|r4:canonical[]|CodeSystemMetadata[]|r4:FHIRError? concept = findConceptInValueSetOrReturnValueSetURIs(refValueSet, code);
                        if concept is CodeConceptDetails[] {
                            foreach CodeConceptDetails codeConceptDetails in concept {
                                result = codeConceptDetails;
                                break;
                            }
                        } else if concept is r4:FHIRError {
                            lastError = concept.clone();
                        } else if concept is CodeSystemMetadata[] {
                            foreach CodeSystemMetadata codeSystemMetadata in concept {
                                CodeConceptDetails|r4:FHIRError findConceptResult = self.findConcept(<r4:uri>codeSystemMetadata.url, version = codeSystemMetadata.version, code = code);
                                if findConceptResult is CodeConceptDetails {
                                    return findConceptResult;
                                }
                            }
                        }
                        // ignore other possibilities
                    }
                }
                if result == () && lastError != () {
                    result = lastError;
                }
            } else if conceptResults is CodeSystemMetadata[] {
                foreach CodeSystemMetadata codeSystemMetadata in conceptResults {
                    CodeConceptDetails|r4:FHIRError findConceptResult = self.findConcept(<r4:uri>codeSystemMetadata.url, version = codeSystemMetadata.version, code = code);
                    if findConceptResult is CodeConceptDetails {
                        return findConceptResult;
                    }
                }
            } else {
                result = <r4:FHIRError>conceptResults;
            }
        } else {
            r4:CodeSystem|r4:FHIRError findCodeSystemResult = self.findCodeSystem(system, (), version);
            if findCodeSystemResult is r4:CodeSystem {
                result = findConceptInCodeSystem(findCodeSystemResult, code);
            }
        }
        if result is () {
            return r4:createFHIRError(
                string `Unknown ValueSet or CodeSystem : ${system}${version == () ? "" : "|" + version}`,
                r4:ERROR,
                r4:INVALID_REQUIRED,
                errorType = r4:PROCESSING_ERROR,
                httpStatusCode = http:STATUS_BAD_REQUEST
            );
        }
        return result.clone();
    }

    public isolated function findValueSet(r4:uri? system, string? id, string? version) returns r4:ValueSet|r4:FHIRError {
        map<r4:ValueSet> valueSets = {};
        lock {
            valueSets = self.valueSetMap.clone();
        }
        if id != () {
            valueSets = map from r4:ValueSet entry in valueSets
                where entry.id == id
                select [getKey(<string>entry.url, <string>entry.version), entry];
            if valueSets.length() < 1 {
                return r4:createFHIRError(
                        string `Unknown ValueSet Id: '${id}'`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
            }
            if version != () {
                valueSets = map from r4:ValueSet entry in valueSets
                    where entry.version == version
                    select [getKey(<string>entry.url, <string>entry.version), entry];
                if valueSets.length() < 1 {
                    return r4:createFHIRError(
                            string `Unknown version: '${version.toString()}',`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `: there is a ValueSet in the registry with Id: '${id.toString()}' but cannot find version: '${version.toString()}' of it.`,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                }
            } else {
                valueSets = map from r4:ValueSet entry in valueSets
                    where entry.version > DEFAULT_VERSION
                    select [getKey(<string>entry.url, <string>entry.version), entry];
            }
            return valueSets.toArray()[0].clone();
        }
        boolean isIdExistInRegistry = false;
        if version is string {
            foreach var item in valueSets.keys() {
                if regexp:isFullMatch(re `${system}\|${version}$`, item) && valueSets[item] is r4:ValueSet {
                    return <r4:ValueSet>valueSets[item].clone();
                } else if regexp:isFullMatch(re `${system}\|.*`, item) {
                    isIdExistInRegistry = true;
                }
            }
            if isIdExistInRegistry {
                return r4:createFHIRError(
                            string `Unknown version: '${version}',`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `: there is a ValueSet in the registry with Id: '${system.toString()}' but cannot find version: '${version}' of it.`,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
            }
        } else {
            r4:ValueSet valueSet = {status: "unknown"};
            string latestVersion = DEFAULT_VERSION;
            foreach var item in valueSets.keys() {
                if regexp:isFullMatch(re `${system}\|.*`, item)
                        && valueSets[item] is r4:ValueSet
                        && (<r4:ValueSet>valueSets[item]).version > latestVersion {

                    valueSet = <r4:ValueSet>valueSets[item];
                    latestVersion = valueSet.version ?: DEFAULT_VERSION;
                    isIdExistInRegistry = true;
                }
            }
            if !isIdExistInRegistry {
                return r4:createFHIRError(
                            string `Unknown ValueSet: '${system.toString()}'`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
            } else {
                return valueSet.clone();
            }
        }
        return r4:createFHIRError(
                    string `Unknown ValueSet: '${system.toString()}'`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                );
    }

    public isolated function searchCodeSystem(map<r4:RequestSearchParameter[]> params, int? offset, int? count) returns r4:CodeSystem[]|r4:FHIRError {
        r4:CodeSystem[] codeSystemArray = [];
        lock {
            codeSystemArray = self.codeSystemMap.clone().toArray();
        }
        foreach var searchParam in params.cloneReadOnly().keys() {
            r4:RequestSearchParameter[] searchParamValues = params.cloneReadOnly()[searchParam] ?: [];
            r4:CodeSystem[] filteredList = [];
            if searchParamValues.length() != 0 {
                foreach var queriedValue in searchParamValues {
                    r4:CodeSystem[] result = from r4:CodeSystem entry in codeSystemArray
                        where entry[CODESYSTEMS_SEARCH_PARAMS.get(searchParam)] == queriedValue.value
                        select entry;
                    filteredList.push(...result);
                }
                codeSystemArray = filteredList.cloneReadOnly();
            }
        }

        int total = codeSystemArray.length();
        int validatedCount = count ?: TERMINOLOGY_SEARCH_DEFAULT_COUNT;

        if total >= offset + validatedCount {
            return codeSystemArray.slice(offset ?: 0, (offset ?: 0) + validatedCount).clone();
        } else if total >= offset {
            return codeSystemArray.slice(offset ?: 0).clone();
        } else {
            return [];
        }
    }

    public isolated function searchValueSet(map<r4:RequestSearchParameter[]> params, int? offset, int? count) returns r4:ValueSet[]|r4:FHIRError {
        r4:ValueSet[] valueSetArray = [];
        lock {
            valueSetArray = self.valueSetMap.clone().toArray();
        }
        foreach var searchParam in params.keys() {
            r4:RequestSearchParameter[] searchParamValues = params[searchParam] ?: [];
            r4:ValueSet[] filteredList = [];
            if searchParamValues.length() != 0 {
                foreach var queriedValue in searchParamValues {
                    r4:ValueSet[] result = from r4:ValueSet entry in valueSetArray
                        where entry[VALUESETS_SEARCH_PARAMS.get(searchParam)] == queriedValue.value
                        select entry;
                    filteredList.push(...result);
                }
                valueSetArray = filteredList;
            }
        }
        int total = valueSetArray.length();
        int validatedCount = count ?: TERMINOLOGY_SEARCH_DEFAULT_COUNT;
        if total >= offset + validatedCount {
            return valueSetArray.slice(offset ?: 0, (offset ?: 0) + validatedCount).clone();
        } else if total >= offset {
            return valueSetArray.slice(offset ?: 0).clone();
        } else {
            return [];
        }
    }

    public isolated function isCodeSystemExist(r4:uri system, string version) returns boolean {
        string key = getKey(system, version);
        lock {
            return self.codeSystemMap.hasKey(key);
        }
    }

    public isolated function isValueSetExist(r4:uri system, string version) returns boolean {
        string key = getKey(system, version);
        lock {
            return self.valueSetMap.hasKey(key);
        }
    }

}

isolated function getKey(string url, string version) returns string {
    return string `${url}|${version}`;
}
