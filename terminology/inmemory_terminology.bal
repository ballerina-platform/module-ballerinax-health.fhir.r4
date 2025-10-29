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
    private map<r4:ConceptMap> conceptMapsMap = {};

    isolated function init() {

        // https://hl7.org/fhir/R4/terminologies-systems.html
        json internalFhirCodeSystems = [];

        // https://hl7.org/fhir/R4/terminologies-valuesets.html - Internal
        json internalFhirValueSets = [];

        // https://terminology.hl7.org/5.4.0/codesystems-fhir.html
        json externalFhirCodeSystems = [];

        // https://terminology.hl7.org/5.4.0/valuesets-fhir.html
        json externalFhirValueSets = [];

        // https://hl7.org/fhir/R4/terminologies-conceptmaps.html
        json internalFhirConceptMaps = [];

        do {
            // We should create terminology as json string constants
            // We can't pack those static files with r4 modules to Ballerina central.
            // https://github.com/ballerina-platform/ballerina-spec/issues/1100
            internalFhirCodeSystems = check DEFAULT_FHIR_CODE_SYSTEMS.fromJsonString();
            internalFhirValueSets = check DEFAULT_FHIR_VALUE_SETS.fromJsonString();
            externalFhirCodeSystems = check EXTERNAL_FHIR_CODE_SYSTEMS.fromJsonString();
            externalFhirValueSets = check EXTERNAL_FHIR_VALUE_SETS.fromJsonString();
            internalFhirConceptMaps = check DEFAULT_FHIR_CONCEPT_MAPS.fromJsonString();
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
            self.conceptMapsMap = self.populateConceptMapsMap(internalFhirConceptMaps, self.conceptMapsMap).clone();
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

    isolated function populateConceptMapsMap(json conceptMapsJson, map<r4:ConceptMap> conceptMapsMap) returns map<r4:ConceptMap> {
        // Implementation logic goes here
        map<r4:ConceptMap> resultedConceptMapsMap = conceptMapsMap;
        // Populate the resultedConceptMapsMap with the concept maps from internalFhirConceptMaps
        foreach json conceptMap in [conceptMapsJson] {
            foreach json jConceptMap in <json[]>conceptMap {
                r4:ConceptMap|error c = jConceptMap.cloneWithType();
                if c is error {
                    r4:FHIRError fHIRError = r4:createFHIRError(
                                            "Error occurred while type casting json concept map to ConceptMap type", r4:ERROR,
                                            r4:PROCESSING,
                                            diagnostic = c.message(),
                                            cause = c
                                        );
                    log:printError(fHIRError.toBalString());
                } else {
                    string key = getKey(<string>c.url, <string?>c.version ?: "");
                    resultedConceptMapsMap[key] = c;
                }
            }
        }

        // Return the updated conceptMapsMap
        return resultedConceptMapsMap;
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

    public isolated function isConceptMapExist(r4:uri system, string 'version) returns boolean {

        string key = getKey(system, version);
        lock {
            return self.conceptMapsMap.hasKey(key);
        }
    }

    public isolated function addConceptMap(r4:ConceptMap conceptMap) returns r4:FHIRError? {
        lock {
            string key = getKey(<string>conceptMap.url, <string>conceptMap.version);
            if !self.conceptMapsMap.hasKey(key) {
                self.conceptMapsMap['key] = conceptMap.clone();
            } else {
                return r4:createFHIRError(
                        "Duplicate entry",
                        r4:ERROR,
                        r4:PROCESSING_DUPLICATE,
                        diagnostic = string `Already there is a ConceptMap exists in the registry with the URL: ${'key}`,
                        errorType = r4:VALIDATION_ERROR,
                        httpStatusCode = http:STATUS_BAD_REQUEST);
            }

        }
    }

    public isolated function getConceptMap(r4:uri? conceptMapUrl, string? version) returns r4:ConceptMap|r4:FHIRError {

        map<r4:ConceptMap> conceptMaps = {};
        lock {
            conceptMaps = self.conceptMapsMap.clone();
        }
        
        boolean isIdExistInRegistry = false;
        if 'version is string && conceptMapUrl != "" {
            foreach var item in conceptMaps.keys() {
                if regexp:isFullMatch(re `${conceptMapUrl}\|${'version}$`, item) && conceptMaps[item] is r4:ConceptMap {
                    return <r4:ConceptMap>conceptMaps[item].clone();
                } else if regexp:isFullMatch(re `${conceptMapUrl}\|.*`, item) {
                    isIdExistInRegistry = true;
                }
            }

            if isIdExistInRegistry {
                return r4:createFHIRError(
                            string `Unknown version: '${'version}',`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `: there is a concept map in the registry with Url: '${conceptMapUrl.toString()}' but cannot find version: '${'version}' of it.`,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
            }
        } else if conceptMapUrl != "" {
            r4:ConceptMap conceptMap = {status: "unknown"};
            foreach var item in conceptMaps.keys() {
                if conceptMapUrl == item
                && conceptMaps[item] is r4:ConceptMap {
                    conceptMap = <r4:ConceptMap>conceptMaps[item];
                    isIdExistInRegistry = true;
                }
            }

            if isIdExistInRegistry {
                return conceptMap.clone();
            } else {
                return r4:createFHIRError(
                            string `Unknown concept map: ${conceptMapUrl.toBalString()}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        httpStatusCode = http:STATUS_NOT_FOUND
                        );
            }
        }
        return r4:createFHIRError(
                string `Unknown concept map: ${conceptMapUrl.toBalString()}`,
                r4:ERROR,
                r4:PROCESSING_NOT_FOUND,
                httpStatusCode = http:STATUS_NOT_FOUND
            );
    }

    public isolated function findConceptMaps(r4:uri sourceValueSetUri, r4:uri? targetValueSetUri) returns r4:ConceptMap[]|r4:FHIRError {

        r4:ConceptMap[] conceptMapsArray = [];
        r4:ConceptMap[] matchingConceptMaps = [];
        lock {
            conceptMapsArray = self.conceptMapsMap.clone().toArray();
        }

        if targetValueSetUri == () {
            foreach var conceptMap in conceptMapsArray {
                if conceptMap.sourceCanonical == sourceValueSetUri || conceptMap.sourceUri == sourceValueSetUri {
                    matchingConceptMaps.push(conceptMap.clone());
                }
            }
        } else {
            foreach var conceptMap in conceptMapsArray {
                if (conceptMap.sourceCanonical == sourceValueSetUri && conceptMap.targetCanonical == targetValueSetUri)
                        || (conceptMap.sourceUri == sourceValueSetUri && conceptMap.targetUri == targetValueSetUri) {
                    matchingConceptMaps.push(conceptMap.clone());
                }
            }
        }

        if matchingConceptMaps.length() == 0 {
            return r4:createFHIRError(
                    "Concept map not found for provided source and target value sets",
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
            );
        }
        return matchingConceptMaps;
    }

    public isolated function searchConceptMap(map<r4:RequestSearchParameter[]> params, int? offset, int? count) returns r4:ConceptMap[]|r4:FHIRError {

        r4:ConceptMap[] conceptMapsArray = [];
        lock {
            conceptMapsArray = self.conceptMapsMap.clone().toArray();
        }
        foreach var searchParam in params.cloneReadOnly().keys() {
            r4:RequestSearchParameter[] searchParamValues = params.cloneReadOnly()[searchParam] ?: [];
            r4:ConceptMap[] filteredList = [];
            if searchParamValues.length() != 0 {
                foreach var queriedValue in searchParamValues {
                    r4:ConceptMap[] result = from r4:ConceptMap entry in conceptMapsArray
                        where entry[CONCEPT_MAPS_SEARCH_PARAMS.get(searchParam)] == queriedValue.value
                        select entry;
                    filteredList.push(...result);
                }
                conceptMapsArray = filteredList.cloneReadOnly();
            }
        }

        int total = conceptMapsArray.length();
        int validatedCount = count ?: TERMINOLOGY_SEARCH_DEFAULT_COUNT;

        if total >= offset + validatedCount {
            return conceptMapsArray.slice(offset ?: 0, (offset ?: 0) + validatedCount).clone();
        } else if total >= offset {
            return conceptMapsArray.slice(offset ?: 0).clone();
        } else {
            return [];
        }
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
            if 'version != () {
                codeSystems = map from r4:CodeSystem entry in codeSystems
                    where entry.version == 'version
                    select [getKey(<string>entry.url, <string>entry.version), entry];

                if codeSystems.length() < 1 {
                    return r4:createFHIRError(
                            string `Unknown version: '${'version.toString()}',`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `: there is a CodeSystem in the registry with Id: '${id.toString()}' but cannot find version: '${'version.toString()}' of it.`,
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
        if 'version is string && system != () {
            foreach var item in codeSystems.keys() {
                if regexp:isFullMatch(re `${system}\|${'version}$`, item) && codeSystems[item] is r4:CodeSystem {
                    return <r4:CodeSystem>codeSystems[item].clone();
                } else if regexp:isFullMatch(re `${system}\|.*`, item) {
                    isIdExistInRegistry = true;
                }
            }

            if isIdExistInRegistry {
                return r4:createFHIRError(
                            string `Unknown version: '${'version}',`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `: there is a CodeSystem in the registry with Id: '${system.toString()}' but cannot find version: '${'version}' of it.`,
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

    public isolated function findConcept(r4:uri system, r4:code code, string? 'version = ()) returns CodeConceptDetails|r4:FHIRError {
        CodeConceptDetails|r4:FHIRError? valuesetConceptDetails = self.findConceptInValueSet(system, code, version);
        if valuesetConceptDetails is CodeConceptDetails {
            return valuesetConceptDetails;
        }

        CodeConceptDetails|r4:FHIRError? conceptDetails = ();
        r4:CodeSystem|r4:FHIRError findCodeSystemResult = self.findCodeSystem(system, (), version);
        if findCodeSystemResult is r4:CodeSystem {
            conceptDetails = findConceptInCodeSystem(findCodeSystemResult, code);
            if conceptDetails is CodeConceptDetails {
                return conceptDetails;
            }
        }

        if conceptDetails is () && valuesetConceptDetails is () {
            return r4:createFHIRError(
                string `Unknown ValueSet or CodeSystem : ${system}${'version == () ? "" : "|" + version}`,
                r4:ERROR,
                r4:INVALID_REQUIRED,
                errorType = r4:PROCESSING_ERROR,
                httpStatusCode = http:STATUS_BAD_REQUEST
            );
        } else if conceptDetails is r4:FHIRError {
            return conceptDetails.clone();
        } else if valuesetConceptDetails is r4:FHIRError {
            return valuesetConceptDetails.clone();
        }

        return r4:createFHIRError(
            "Concept not found",
            r4:ERROR,
            r4:PROCESSING_NOT_FOUND,
            errorType = r4:PROCESSING_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
        );
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
            if 'version != () {
                valueSets = map from r4:ValueSet entry in valueSets
                    where entry.version == 'version
                    select [getKey(<string>entry.url, <string>entry.version), entry];
                if valueSets.length() < 1 {
                    return r4:createFHIRError(
                            string `Unknown version: '${'version.toString()}',`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `: there is a ValueSet in the registry with Id: '${id.toString()}' but cannot find version: '${'version.toString()}' of it.`,
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
        if 'version is string {
            foreach var item in valueSets.keys() {
                if regexp:isFullMatch(re `${system}\|${'version}$`, item) && valueSets[item] is r4:ValueSet {
                    return <r4:ValueSet>valueSets[item].clone();
                } else if regexp:isFullMatch(re `${system}\|.*`, item) {
                    isIdExistInRegistry = true;
                }
            }
            if isIdExistInRegistry {
                return r4:createFHIRError(
                            string `Unknown version: '${'version}',`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `: there is a ValueSet in the registry with Id: '${system.toString()}' but cannot find version: '${'version}' of it.`,
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

    public isolated function isCodeSystemExist(r4:uri system, string 'version) returns boolean {
        string key = getKey(system, version);
        lock {
            return self.codeSystemMap.hasKey(key);
        }
    }

    public isolated function isValueSetExist(r4:uri system, string 'version) returns boolean {
        string key = getKey(system, version);
        lock {
            return self.valueSetMap.hasKey(key);
        }
    }

    private isolated function findConceptInValueSet(r4:uri system, r4:code code, string? version) returns CodeConceptDetails|r4:FHIRError? {
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
            } else if conceptResults is CodeConceptDetails[] {
                // Note: Although duplicate codes can appear under the same system in ValueSet.compose.include,
                // the FHIR specification allows this redundancy. However, during expansion, the terminology
                // service automatically de-duplicates concepts, so only unique codes are returned.
                // Reference: https://hl7.org/fhir/valueset-definitions.html#ValueSet.compose.include.concept
                return conceptResults[0];
            } else {
                result = <r4:FHIRError>conceptResults;
            }
        }

        return result;
    }

    public isolated function expandValueSet(map<r4:RequestSearchParameter[]> searchParameters, r4:ValueSet valueSet, int offset, int count) returns r4:ValueSet|r4:FHIRError {
        ValueSetExpansionDetails? details = getAllConceptInValueSet(valueSet);

        if details is ValueSetExpansionDetails {
            r4:CodeSystemConcept[]|r4:ValueSetComposeIncludeConcept[] concepts = details.concepts;

            if concepts is r4:ValueSetComposeIncludeConcept[] {
                if searchParameters.hasKey(FILTER) {
                    string filter = searchParameters.get(FILTER)[0].value;
                    r4:ValueSetComposeIncludeConcept[] result = from r4:ValueSetComposeIncludeConcept entry in concepts
                        where entry[DISPLAY] is string && regexp:isFullMatch(re `.*${filter.toUpperAscii()}.*`,
                                (<string>entry[DISPLAY]).toUpperAscii())
                        select entry;
                    concepts = result;
                }

                int totalCount = concepts.length();

                if totalCount > offset + count {
                    concepts = concepts.slice(offset, offset + count);
                } else if totalCount >= offset {
                    concepts = concepts.slice(offset);
                } else {
                    r4:CodeSystemConcept[] temp = [];
                    concepts = temp;
                }

                r4:ValueSetExpansion expansion = createExpandedValueSet(valueSet, concepts);
                expansion.offset = offset;
                expansion.total = totalCount;
                valueSet.expansion = expansion.clone();

            } else {
                if searchParameters.hasKey(FILTER) {
                    string filter = searchParameters.get(FILTER)[0].value;
                    r4:CodeSystemConcept[] result = from r4:CodeSystemConcept entry in concepts
                        where entry[DISPLAY] is string
                                && regexp:isFullMatch(re `.*${filter.toUpperAscii()}.*`, (<string>entry[DISPLAY]).toUpperAscii())
                            || entry[DEFINITION] is string
                                && regexp:isFullMatch(re `.*${filter.toUpperAscii()}.*`, (<string>entry[DEFINITION]).toUpperAscii())
                        select entry;
                    concepts = result;
                }

                int totalCount = concepts.length();
                if totalCount > offset + count {
                    concepts = concepts.slice(offset, offset + count);
                } else if totalCount >= offset {
                    concepts = concepts.slice(offset);
                } else {
                    r4:CodeSystemConcept[] temp = [];
                    concepts = temp;
                }
                r4:ValueSetExpansion expansion = createExpandedValueSet(valueSet, concepts);
                expansion.offset = offset;
                expansion.total = totalCount;
                valueSet.expansion = expansion.clone();
            }
        }
        return valueSet.clone();
    }
}

isolated function getKey(string url, string 'version) returns string {
    return string `${url}|${'version}`;
}
