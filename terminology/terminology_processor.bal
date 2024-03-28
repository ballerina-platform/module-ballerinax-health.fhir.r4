// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

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
import ballerina/lang.'int as langint;
import ballerina/log;
import ballerina/time;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401 as i4;
import ballerinax/health.fhir.r4.validator;
import ballerina/lang.regexp;

//It is a custom record to hold system URLs and a related concept.  
type CodeConceptDetails record {
    //System URL of the concept.
    r4:uri url;
    r4:CodeSystemConcept|r4:ValueSetComposeIncludeConcept concept;
};

//It is a custom record to hold system URLs and a array of related concepts.
type ValueSetExpansionDetails record {
    //System URL of the concepts.
    r4:uri url;
    r4:CodeSystemConcept[]|r4:ValueSetComposeIncludeConcept[] concepts;
};

# Defines the interface `Finder` object.
# This should be implemented and provided to the Terminology service operations if external source systems is used.
# For instance DB or external API server.
public type Finder readonly & object {

    # To persist the CodeSystem data in the database.
    #
    # + codeSystems - CodeSystem array to be persisted.
    # + return - Error array if any.
    public isolated function addCodeSystems(r4:CodeSystem[] codeSystems) returns r4:FHIRError[]?;

    # The function definition for Concept finder implementations.
    #
    # + system - CodeSystem URL to be searched.
    # + id - Id of the CodeSystem to be searched.
    # + version - Version of the CodeSystem to be searched.
    # + return - CodeSystem if found or else FHIRError.
    public isolated function findCodeSystem(r4:uri? system = (), string? id = (), string? version = ()) returns r4:CodeSystem|r4:FHIRError;

    # The function definition for Concept finder implementations.
    #
    # + params - Search parameters.  
    # + offset - Offset value for the search.  
    # + count - Count value for the search.
    # + return - CodeSystem array if found or else FHIRError.
    public isolated function searchCodeSystem(map<r4:RequestSearchParameter[]> params, int? offset = (), int? count = ()) returns r4:CodeSystem[]|r4:FHIRError;
    # The function definition for add Concepts implementations.
    #
    # + system - System URL of the CodeSystem to be added.  
    # + concepts - Concept array to be added.
    # + version - version of the CodeSystem to be added.
    # + return - Error array if any.
    public isolated function addConcepts(r4:uri system, r4:CodeSystemConcept[] concepts, string? version = ()) returns r4:FHIRError[]?;

    # The function definition for Concept finder implementations.
    #
    # + system - System URL of the CodeSystem to be searched.
    # + code - Code of the Concept to be searched.
    # + version - version of the CodeSystem to be searched.
    # + return - CodeSystemConcept if found or else FHIRError.
    public isolated function findConcept(r4:uri system, r4:code code, string? version = ()) returns r4:CodeSystemConcept|r4:FHIRError;

    # The function definition for add ValueSets implementations.
    #
    # + valueSets - ValueSet array to be added.
    # + return - Error array if any.
    public isolated function addValueSets(r4:ValueSet[] valueSets) returns r4:FHIRError[]?;

    # The function definition for ValueSet finder implementations.
    #
    # + system - System URL of the ValueSet to be searched.
    # + id - Id of the ValueSet to be searched.  
    # + version - version of the ValueSet to be searched.
    # + return - ValueSet if found or else FHIRError.
    public isolated function findValueSet(r4:uri? system = (), string? id = (), string? version = ()) returns r4:ValueSet|r4:FHIRError;

    # Search ValueSets.
    #
    # + params - Search parameters.  
    # + offset - Offset value for the search. 
    # + count - Count value for the search.
    # + return - ValueSet array if found or else FHIRError.
    public isolated function searchValueSet(map<r4:RequestSearchParameter[]> params, int? offset = (), int? count = ()) returns r4:ValueSet[]|r4:FHIRError;
};

# A processor to process terminology data and create relevant data elements.
public isolated class TerminologyProcessor {

    # Global records to store Terminologies across different profiles and packages.
    private map<r4:CodeSystem> codeSystems = {};
    private map<r4:ValueSet> valueSets = {};
    private Finder? finder = ();

    # It will initialize the Terminology map.
    # It will delete the existing records if it is re-initialized.
    # It will be used during the package initialization. 
    #
    # + codeSystems - CodeSystem map 
    # + valueSets - ValueSet map
    public isolated function initTerminology(map<r4:CodeSystem> codeSystems, map<r4:ValueSet> valueSets) {
        lock {
            self.codeSystems = codeSystems.clone();
            self.valueSets = valueSets.clone();
        }
    }

    public isolated function setFinder(Finder finder) {
        lock {
            self.finder = finder;
        }
    }

    # Add list of new CodeSystems.
    #
    # + codeSystems - List CodeSystems
    # + return - Return List of FHIRErrors if any
    public isolated function addCodeSystems(r4:CodeSystem[] codeSystems) returns r4:FHIRError[]? {
        r4:FHIRError[] errors = [];
        foreach r4:CodeSystem codeSystem in codeSystems {
            r4:FHIRError? result = self.addCodeSystem(codeSystem);
            _ = result is r4:FHIRError ? errors.push(result) : "";
        }
        return errors;
    }

    # Add list of new CodeSystems as a json or json array.
    #
    # + codeSystemJsonArray - CodeSystem data in the JSON format
    # + return - Return List of FHIRErrors if any
    public isolated function addCodeSystemsAsJson(json[] codeSystemJsonArray) returns r4:FHIRError[]? {
        r4:FHIRError[] errors = [];
        r4:CodeSystem[] codeSystems = [];

        foreach var c in codeSystemJsonArray {
            r4:CodeSystem|error result = c.cloneWithType();
            if result is error {
                r4:FHIRError er = r4:createFHIRError(
                    string `Invalid data. Can not parse the provided json data: ${c.toBalString()}`,
                    r4:ERROR,
                    r4:INVALID,
                    diagnostic = "Please check the provided json structure and re-try with this data again",
                    cause = result,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );

                errors.push(er);
            } else {
                codeSystems.push(result);
            }
        }

        _ = codeSystems.length() > 0 ? errors.push(...<r4:FHIRError[]>self.addCodeSystems(codeSystems)) : "";

        if errors.length() > 0 {
            return errors;
        }
        return;
    }

    # Add list of new ValueSets.
    #
    # + valueSets - List ValueSets in the Ballerina record format
    # + return - Return List of FHIRErrors if any
    public isolated function addValueSets(r4:ValueSet[] valueSets) returns r4:FHIRError[]? {
        r4:FHIRError[] errors = [];
        foreach r4:ValueSet valueSet in valueSets {
            r4:FHIRError? result = self.addValueSet(valueSet);
            _ = result is r4:FHIRError ? errors.push(result) : "";
        }
        return errors;
    }

    # Add list of new ValueSet as a json or json array.
    #
    # + valueSetJsonArray - Json ValueSet data in the JSON format
    # + return - Return List of FHIRErrors if any
    public isolated function addValueSetsAsJson(json[] valueSetJsonArray) returns r4:FHIRError[]? {
        r4:FHIRError[] errors = [];
        r4:ValueSet[] valueSets = [];

        foreach var v in valueSetJsonArray {
            r4:ValueSet|error result = v.cloneWithType(r4:ValueSet);
            if result is error {
                r4:FHIRError er = r4:createFHIRError(
                    string `Invalid data. Can not parse the provided json data: ${v.toBalString()}`,
                    r4:ERROR,
                    r4:INVALID,
                    diagnostic = "Please check the provided json structure and re-try with this data again",
                    cause = result,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );

                errors.push(er);
            } else {
                valueSets.push(result);
            }
        }

        _ = valueSets.length() > 0 ? errors.push(...<r4:FHIRError[]>self.addValueSets(valueSets)) : "";

        if errors.length() > 0 {
            return errors;
        }
        return;
    }

    # Add a new CodeSystem.
    #
    # + codeSystem - ValueSet to be added, data in the Ballerina record format
    # + return - Return FHIRError
    public isolated function addCodeSystem(r4:CodeSystem codeSystem) returns r4:FHIRError? {
        lock {
            if codeSystem.url == () {
                return r4:createFHIRError(
                    string `Can not find the URL of the CodeSystem with name: ${codeSystem.name.toBalString()}`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = string `Add a proper URL for the resource: http://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.url`,
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            if codeSystem.version == () {
                return r4:createFHIRError(
                    string `Can not find the version of the CodeSystem with name: ${codeSystem.name.toBalString()}`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = string `Add appropriate version for the resource: https://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.version`,
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            string url = <string>codeSystem.url;
            string version = <string>codeSystem.version;
            string key = string `${url}|${version}`;

            if self.finder is () && self.codeSystems.hasKey(key) {
                return r4:createFHIRError(
                    "Duplicate entry",
                    r4:ERROR,
                    r4:PROCESSING_DUPLICATE,
                    diagnostic = string `Already there is a CodeSystem exists in the registry with the URL: ${url}`,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            r4:FHIRValidationError? validateResult = validator:validate(codeSystem.clone(), r4:CodeSystem);

            if validateResult is r4:FHIRValidationError {
                return r4:createFHIRError(
                    "Validation failed",
                    r4:ERROR,
                    r4:INVALID,
                    diagnostic = string `Check whether the data conforms to the specification: http://hl7.org/fhir/R4/codesystem-definitions.html`,
                    errorType = r4:VALIDATION_ERROR,
                    cause = validateResult,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            if self.finder is Finder {
                r4:FHIRError[]? result = (<Finder>self.finder).addCodeSystems([codeSystem.clone()]);
                if result is r4:FHIRError[] {
                    return result[0];
                }
            } else {
                self.codeSystems[key] = codeSystem.clone();
            }
        }
    }

    # Add a new ValueSet.
    #
    # + valueSet - ValueSet to be added, data in the Ballerina record format
    # + return - Return FHIRError
    public isolated function addValueSet(r4:ValueSet valueSet) returns r4:FHIRError? {
        lock {
            if valueSet.url == () {
                return r4:createFHIRError(
                    string `Can not find the URL of the ValueSet with name: ${valueSet.name.toBalString()}`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = "Add a proper URL for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.url",
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            if valueSet.version == () {
                return r4:createFHIRError(
                    string `Can not find the version of the ValueSet with name: ${valueSet.name.toBalString()}`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = string `Add appropriate version for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.version`,
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            string url = <string>valueSet.url;
            string rVersion = <string>valueSet.version;
            string rKey = string `${url}|${rVersion}`;

            if self.finder is () && self.valueSets.hasKey(rKey) {
                return r4:createFHIRError(
                    "Duplicate entry",
                    r4:ERROR,
                    r4:PROCESSING_DUPLICATE,
                    diagnostic = string `Already there is a ValueSet exists in the registry with the URL: ${url}`,
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            r4:FHIRValidationError? validateResult = validator:validate(valueSet.clone(), r4:ValueSet);

            if validateResult is r4:FHIRValidationError {
                return r4:createFHIRError(
                    "Validation failed",
                    r4:ERROR,
                    r4:INVALID,
                    diagnostic = string `Check whether the data conforms to the specification: http://hl7.org/fhir/R4/valueset-definitions.html`,
                    errorType = r4:VALIDATION_ERROR,
                    cause = validateResult,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            if self.finder is Finder {
                r4:FHIRError[]? result = (<Finder>self.finder).addValueSets([valueSet.clone()]);
                if result is r4:FHIRError[] {
                    return result[0];
                }
            } else {
                self.valueSets[rKey] = valueSet.clone();
            }
        }
    }

    # Find a Code System based on the provided Id and version.
    #
    # + id - Id of the CodeSystem to be retrieved
    # + version - Version of the CodeSystem to be retrieved and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Return CodeSystem data if the request is successful, return FHIR error if no data found for the provided Id
    public isolated function readCodeSystemById(string id, string? version = ()) returns r4:CodeSystem|r4:FHIRError {
        lock {
            if self.finder is Finder {
                return (<Finder>self.finder).findCodeSystem(id = id, version = version);
            }

            r4:CodeSystem[] codeSystems = self.codeSystems.toArray();
            r4:CodeSystem cs = {content: "example", status: "unknown"};

            codeSystems = from r4:CodeSystem entry in codeSystems
                where entry.id == id
                select entry;

            if codeSystems.length() > 0 {
                if version is string {
                    codeSystems = from r4:CodeSystem entry in codeSystems
                        where entry.version == version
                        select entry;
                    cs = codeSystems.length() > 0 ? codeSystems[0] : cs;
                }
                if codeSystems.length() < 1 {
                    return r4:createFHIRError(
                            string `Unknown version: '${version.toString()}'`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string
                            `There is CodeSystem in the registry with Id: '${id}' but can not find version: '${version.toString()}' of it`,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                } else {
                    string latestVersion = DEFAULT_VERSION;
                    foreach var item in codeSystems {
                        if item.version > latestVersion {
                            latestVersion = <string>item.version;
                            cs = item;
                        }
                    }
                }
            } else {
                return r4:createFHIRError(
                        string `Unknown CodeSystem: '${id}'`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
            }

            return cs.clone();
        }
    }

    # Find a ValueSet for a provided Id and version.
    #
    # + id - Id of the Value Set to be retrieved
    # + version - Version of the ValueSet to be retrieved and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Return ValueSet data if the request is successful, return FHIR error if no data found for the provided Id
    public isolated function readValueSetById(string id, string? version = ()) returns r4:ValueSet|r4:FHIRError {
        lock {
            if self.finder is Finder {
                return (<Finder>self.finder).findValueSet(id = id, version = version);
            }

            r4:ValueSet[] valueSets = self.valueSets.toArray();
            r4:ValueSet vs = {status: "unknown"};

            valueSets = from r4:ValueSet entry in valueSets
                where entry.id == id
                select entry;

            if valueSets.length() > 0 {
                if version is string {
                    valueSets = from r4:ValueSet entry in valueSets
                        where entry.version == version
                        select entry;

                    if valueSets.length() > 0 {
                        vs = valueSets[0];
                    }
                }
                if valueSets.length() < 1 {
                    return r4:createFHIRError(
                            string `Unknown version: '${version.toString()}'`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string
                            `There is ValueSet in the registry with Id: '${id}' but can not find version: '${version.toString()}' of it`,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                } else {
                    string latestVersion = DEFAULT_VERSION;
                    foreach var item in valueSets {
                        if item.version > latestVersion {
                            latestVersion = <string>item.version;
                            vs = item;
                        }
                    }
                }
            } else {
                return r4:createFHIRError(
                        string `Unknown ValueSet: '${id}'`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
            }
            return vs.clone();
        }
    }

    # Search for Code systems based on the provided search parameters.
    # Allowed search parameters are name, title, url, version, status and so on.
    #
    # + params - List of search parameters, should be passed as map of string arrays
    # + return - Return array of CodeSystem data if success, return FHIR error if the request contains unsupported search parameters 
    # and for any other processing errors
    public isolated function searchCodeSystems(map<r4:RequestSearchParameter[]> params) returns r4:CodeSystem[]|r4:FHIRError {
        lock {
            map<r4:RequestSearchParameter[]> searchParameters = params.clone();
            int count = TERMINOLOGY_SEARCH_DEFAULT_COUNT;
            if searchParameters.hasKey(SEARCH_COUNT_ATTRIBUTE) {
                int|error y = langint:fromString(searchParameters.get(SEARCH_COUNT_ATTRIBUTE)[0].value);
                if y is int {
                    count = y;
                }
                _ = searchParameters.remove(SEARCH_COUNT_ATTRIBUTE);
            }

            int offset = 0;
            if searchParameters.hasKey(SEARCH_OFFSET_ATTRIBUTE) {
                int|error y = langint:fromString(searchParameters.get(SEARCH_OFFSET_ATTRIBUTE)[0].value);
                if y is int {
                    offset = y;
                }
                _ = searchParameters.remove(SEARCH_OFFSET_ATTRIBUTE);
            }

            if count > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                return r4:createFHIRError(
                    string `Requested size of the response: ${count.toBalString()} is too large`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_SUPPORTED,
                    diagnostic = string `Allowed maximum size of output is: ${TERMINOLOGY_SEARCH_MAXIMUM_COUNT}; therefore, reduce the value of size parameter accordingly`,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_PAYLOAD_TOO_LARGE
                );
            }

            // Validate whether the requested search parameters in the allowed list
            foreach var param in searchParameters.keys() {
                if !CODESYSTEMS_SEARCH_PARAMS.hasKey(param) {
                    return r4:createFHIRError(
                        string `Invalid search parameter: ${param}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_SUPPORTED,
                        diagnostic = string `Allowed search parameters: ${CODESYSTEMS_SEARCH_PARAMS.keys().toBalString()}`,
                        errorType = r4:VALIDATION_ERROR
                    );
                }
            }

            if self.finder is Finder {
                return check (<Finder>self.finder).searchCodeSystem(searchParameters.clone(), offset = offset, count = count);
            }

            r4:CodeSystem[] codeSystemArray = self.codeSystems.toArray();

            foreach var searchParam in searchParameters.keys() {
                r4:RequestSearchParameter[] searchParamValues = searchParameters[searchParam] ?: [];

                r4:CodeSystem[] filteredList = [];
                if searchParamValues.length() != 0 {
                    foreach var queriedValue in searchParamValues {
                        r4:CodeSystem[] result = from r4:CodeSystem entry in codeSystemArray
                            where entry[CODESYSTEMS_SEARCH_PARAMS.get(searchParam)] == queriedValue.value
                            select entry;
                        filteredList.push(...result);
                    }
                    codeSystemArray = filteredList;
                }
            }

            int total = codeSystemArray.length();

            if total >= offset + count {
                return codeSystemArray.slice(offset, offset + count).clone();
            } else if total >= offset {
                return codeSystemArray.slice(offset).clone();
            } else {
                return [];
            }
        }
    }

    # Search for Value Sets for the provided search parameters.
    # Allowed search parameters: are name, title, url, version, status and son on.
    #
    # + params - List of search parameters, should be passed as map of string arrays  
    # + return - Return array of ValueSet data if success, return FHIR error if the request contains unsupported search parameters
    # and for any other processing errors
    public isolated function searchValueSets(map<r4:RequestSearchParameter[]> params) returns r4:FHIRError|r4:ValueSet[] {
        lock {
            map<r4:RequestSearchParameter[]> searchParameters = params.clone();
            int count = TERMINOLOGY_SEARCH_DEFAULT_COUNT;
            if searchParameters.hasKey(SEARCH_COUNT_ATTRIBUTE) {
                int|error y = langint:fromString(searchParameters.get(SEARCH_COUNT_ATTRIBUTE)[0].value);
                if y is int {
                    count = y;
                }
                _ = searchParameters.remove(SEARCH_COUNT_ATTRIBUTE);
            }

            int offset = 0;
            if searchParameters.hasKey(SEARCH_OFFSET_ATTRIBUTE) {
                int|error y = langint:fromString(searchParameters.get(SEARCH_OFFSET_ATTRIBUTE)[0].value);
                if y is int {
                    offset = y;
                }
                _ = searchParameters.remove(SEARCH_OFFSET_ATTRIBUTE);
            }

            if count > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                return r4:createFHIRError(
                    string `Requested size of the response: ${count.toBalString()} is too large`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_SUPPORTED,
                    diagnostic = string `Allowed maximum size of output is: ${TERMINOLOGY_SEARCH_MAXIMUM_COUNT}; therefore, reduce the value of size parameter accordingly`,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_PAYLOAD_TOO_LARGE
                );
            }

            // Validate the requested search parameters in the allowed list
            foreach var param in searchParameters.keys() {
                if !VALUESETS_SEARCH_PARAMS.hasKey(param) {
                    return r4:createFHIRError(
                        string `Invalid search parameter: ${param}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_SUPPORTED,
                        diagnostic = string `Allowed search parameters: ${VALUESETS_SEARCH_PARAMS.keys().toBalString()}`,
                        errorType = r4:VALIDATION_ERROR
                    );
                }
            }

            if self.finder is Finder {
                return (<Finder>self.finder).searchValueSet(searchParameters.clone(), offset = offset, count = count);
            }

            r4:ValueSet[] valueSetArray = self.valueSets.toArray();

            foreach var searchParam in searchParameters.keys() {
                r4:RequestSearchParameter[] searchParamValues = searchParameters[searchParam] ?: [];

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
            if total >= offset + count {
                return valueSetArray.slice(offset, offset + count).clone();
            } else if total >= offset {
                return valueSetArray.slice(offset).clone();
            } else {
                return [];
            }
        }

    }

    # Extract the respective concepts from a given CodeSystem based on the give code or Coding or CodeableConcept data.
    # This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#lookup.
    #
    # + codeValue - Code or Coding or CodeableConcept data type value to process with the CodeSystem  
    # + cs - CodeSystem record to be processed. If system parameter is not supplied, this value shoud be mandatory,  
    # else this is an optional field  
    # + system - System URL of the CodeSystem to be processed, if system CodeSystem(cs) is not supplied,  
    # this value shoud be mandatory  
    # + version - Version of the CodeSystem and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Return list of Concepts if processing is successful, return FHIRError if fails
    public isolated function codeSystemLookUp(r4:code|r4:Coding|r4:CodeableConcept codeValue, r4:CodeSystem? cs = (), r4:uri? system = (),
            string? version = ()) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
        lock {
            // Create and initialize a CodeSystem record with the mandatory fields
            r4:CodeSystem codeSystem = {content: "example", status: "unknown"};
            r4:CodeSystemConcept[] codeConceptDetailsList = [];

            if self.finder is () {
                r4:CodeSystem|error ensured = cs.clone().ensureType();
                if ensured !is error {
                    codeSystem = ensured;
                } else if system !is () {
                    r4:CodeSystem|r4:FHIRError codeSystemById = self.readCodeSystemByUrl(system, version);
                    if codeSystemById is r4:CodeSystem {
                        codeSystem = codeSystemById;
                    } else {
                        return r4:createFHIRError(string `Cannot find a CodeSystem for the provided system URL: ${system}`,
                            r4:ERROR,
                            r4:INVALID,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                    }
                } else {
                    return r4:createFHIRError(
                        "Can not find a CodeSystem",
                        r4:ERROR,
                        r4:INVALID_REQUIRED,
                        diagnostic = "Either CodeSystem record or system URL should be provided as input",
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
                }
            }

            if codeValue is r4:code && codeValue.trim() !is "" {
                if self.finder is Finder {
                    if system is r4:uri {
                        return (<Finder>self.finder).findConcept(<r4:uri>system, codeValue);
                    } else {
                        return r4:createFHIRError(
                            "Provided CodeSystem or system url is invalid",
                            r4:ERROR,
                            r4:INVALID_REQUIRED,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_BAD_REQUEST
                        );
                    }
                } else {
                    CodeConceptDetails? result = self.findConceptInCodeSystem(codeSystem, codeValue);

                    if result is CodeConceptDetails {
                        return result.concept.clone();
                    } else {
                        return r4:createFHIRError(
                            string `Can not find any valid concepts for the code: ${codeValue.toBalString()} in CodeSystem: ${codeSystem.id.toBalString()}`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                    }
                }
            } else if codeValue is r4:Coding {
                if self.finder is Finder {
                    if system is r4:uri {
                        return (<Finder>self.finder).findConcept(<r4:uri>system, <r4:code>codeValue.code);
                    } else {
                        return r4:createFHIRError(
                            "Provided CodeSystem or system url is invalid",
                            r4:ERROR,
                            r4:INVALID_REQUIRED,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_BAD_REQUEST
                        );
                    }
                } else {
                    CodeConceptDetails? result = self.findConceptInCodeSystemFromCoding(codeSystem, codeValue.clone());

                    if result is CodeConceptDetails {
                        return result.concept.clone();
                    } else {
                        return r4:createFHIRError(
                            string `Can not find any valid concepts for the coding with code: ${codeValue.code.toBalString()} in CodeSystem: ${codeSystem.id.toBalString()}`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                    }
                }
            }
            else if codeValue is r4:CodeableConcept {
                r4:Coding[]? codings = codeValue.clone().coding;

                if codings != () {
                    foreach var c in codings {
                        CodeConceptDetails? result = ();
                        r4:CodeSystemConcept findConceptResult;
                        if self.finder is Finder {
                            if system is r4:uri && c.code is r4:code {
                                findConceptResult = check (<Finder>self.finder).findConcept(<r4:uri>system, <r4:code>c.code);
                            } else {
                                return r4:createFHIRError(
                                    "Provided CodeSystem or system url is invalid",
                                    r4:ERROR,
                                    r4:INVALID_REQUIRED,
                                    errorType = r4:PROCESSING_ERROR,
                                    httpStatusCode = http:STATUS_BAD_REQUEST
                                );
                            }

                            result = {
                                url: <r4:uri>system,
                                concept: findConceptResult
                            };
                        } else {
                            result = self.findConceptInCodeSystemFromCoding(codeSystem.cloneReadOnly(), c);
                        }

                        if result is CodeConceptDetails {
                            codeConceptDetailsList.push(result.concept);
                        }
                    }

                    if codeConceptDetailsList.length() < 0 {
                        return r4:createFHIRError(
                            string `Can not find any valid concepts for the CodeableConcept: ${codeValue.toBalString()} in CodeSystem: ${codeSystem.id.toBalString()}`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                    }

                    if codeConceptDetailsList.length() == 1 {
                        return codeConceptDetailsList[0].clone();
                    } else {
                        return codeConceptDetailsList.clone();
                    }

                }
                else {
                    return r4:createFHIRError(
                        "Can not find any valid Codings in the provide CodeableConcept data",
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_BAD_REQUEST
                    );
                }
            }

            return r4:createFHIRError(
                "Either code or Coding or CodeableConcept should be provided as input",
                r4:ERROR,
                r4:PROCESSING_NOT_FOUND,
                httpStatusCode = http:STATUS_BAD_REQUEST
            );
        }
    }

    # Extract the respective concepts from a given ValueSet based on the give code or Coding or CodeableConcept data.
    # This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#validation.
    #
    # + codeValue - Code or Coding or CodeableConcept data type value to process with the ValueSet  
    # + vs - vs - ValueSet record to be processed. If system parameter is not supplied, this value shoud be mandatory,  
    # else this is an optional field  
    # + system - System URL of the ValueSet to be processed, if system ValueSet(vs) is not supplied then  
    # this value shoud be mandatory  
    # + version - Version of the ValueSet and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up. 
    # + return - Return list of Concepts if processing is successful, return FHIRError if fails
    public isolated function valueSetLookUp(r4:code|r4:Coding|r4:CodeableConcept codeValue, r4:ValueSet? vs = (), r4:uri? system = (), string? version = ())
                                                                                    returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
        lock {
            // Create and initialize a ValueSet record with the mandatory fields
            r4:ValueSet valueSet = {status: "unknown"};
            r4:CodeSystemConcept[] codeConceptDetailsList = [];

            r4:ValueSet|error ensured = vs.clone().ensureType();
            if ensured is r4:ValueSet {
                valueSet = ensured;
            } else if system is r4:uri {
                if self.readValueSetByUrl(system, version) is r4:ValueSet {
                    valueSet = check self.readValueSetByUrl(system, version);
                } else {
                    return r4:createFHIRError(string `Cannot find a ValueSet for the provided system URL: ${system}`,
                        r4:ERROR,
                        r4:INVALID,
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_BAD_REQUEST
                    );
                }
            } else {
                return r4:createFHIRError(
                    "Can not find a ValueSet",
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = "Either ValueSet record or system URL should be provided as input",
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            if codeValue is r4:code && codeValue.trim() !is "" {
                CodeConceptDetails? result = self.findConceptInValueSet(valueSet, codeValue);
                if result is CodeConceptDetails {
                    return result.concept.clone();
                } else {
                    return r4:createFHIRError(
                        string `Can not find any valid concepts for the code: ${codeValue.toBalString()} in ValueSet: ${valueSet.id.toBalString()}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
                }
            } else if codeValue is r4:Coding {

                CodeConceptDetails? result = self.findConceptInValueSetFromCoding(valueSet, codeValue.clone());

                if result is CodeConceptDetails {
                    return result.concept.clone();
                } else {
                    return r4:createFHIRError(
                        string `Can not find any valid concepts for the coding with code: ${codeValue.code.toBalString()} in ValueSet: ${valueSet.id.toBalString()}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
                }
            } else if codeValue is r4:CodeableConcept {
                r4:Coding[]? codings = codeValue.coding.clone();

                if codings != () {
                    foreach var c in codings {
                        CodeConceptDetails? result = self.findConceptInValueSetFromCoding(valueSet.cloneReadOnly(), c);

                        if result is CodeConceptDetails {
                            codeConceptDetailsList.push(result.concept);
                        }
                    }

                    if codeConceptDetailsList.length() < 0 {
                        return r4:createFHIRError(
                            string `Can not find any valid concepts for the CodeableConcept: ${codeValue.toBalString()} in CodeSystem: ${valueSet.id.toBalString()}`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                    }
                    if codeConceptDetailsList.length() == 1 {
                        return codeConceptDetailsList[0].clone();
                    } else {
                        return codeConceptDetailsList.clone();
                    }
                } else {
                    return r4:createFHIRError(
                        "Can not find any valid Codings in the provide CodeableConcept data",
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_BAD_REQUEST
                    );
                }
            } else {
                return r4:createFHIRError(
                    "Either code or Coding or CodeableConcept should be provided as input",
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }
        }
    }

    # Extract all the concepts from a given valueSet based on the given filter parameters.
    # This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#expand.
    #
    # + searchParams - List of search parameters to filter concepts, should be passed as map of string arrays  
    # + vs - ValueSet record to be processed. If system parameter is not supplied, this value shoud be mandatory, 
    # else this is an optional field  
    # + system - System URL of the ValueSet to be processed, if system ValueSet(vs) is not supplied then  
    # this value shoud be mandatory
    # + return - List of concepts is successful,  return FHIRError if fails
    public isolated function valueSetExpansion(map<r4:RequestSearchParameter[]> searchParams, r4:ValueSet? vs = (), r4:uri? system = ())
                                                                returns r4:ValueSet|r4:FHIRError {
        lock {
            map<r4:RequestSearchParameter[]> searchParameters = searchParams.clone();
            int count = TERMINOLOGY_SEARCH_DEFAULT_COUNT;
            if searchParameters.hasKey(SEARCH_COUNT_ATTRIBUTE) {
                int|error y = langint:fromString(searchParameters.get(SEARCH_COUNT_ATTRIBUTE)[0].value);
                if y is int {
                    count = y;
                }
                map<r4:RequestSearchParameter[]> clone = searchParameters.clone();
                _ = clone.remove(SEARCH_COUNT_ATTRIBUTE);
                searchParameters = clone;
            }

            int offset = 0;
            if searchParameters.hasKey(SEARCH_OFFSET_ATTRIBUTE) {
                int|error y = langint:fromString(searchParameters.get(SEARCH_OFFSET_ATTRIBUTE)[0].value);
                if y is int {
                    offset = y;
                }
                map<r4:RequestSearchParameter[]> clone = searchParameters.clone();
                _ = clone.remove(SEARCH_OFFSET_ATTRIBUTE);
                searchParameters = clone;
            }

            if count > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                return r4:createFHIRError(
                    string `Requested size of the response: ${count.toBalString()} is too large`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_SUPPORTED,
                    diagnostic = string `Allowed maximum size of output is: ${TERMINOLOGY_SEARCH_MAXIMUM_COUNT}; therefore, reduce the value of size parameter accordingly`,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_PAYLOAD_TOO_LARGE
                );
            }

            // Validate the requested search parameters in the allowed list
            foreach var param in searchParameters.keys() {
                if !VALUESETS_EXPANSION_PARAMS.hasKey(param) {
                    return r4:createFHIRError(
                        string `Invalid search parameter: ${param}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_SUPPORTED,
                        diagnostic = string `Allowed search parameters: ${VALUESETS_EXPANSION_PARAMS.keys().toBalString()}`,
                        errorType = r4:VALIDATION_ERROR
                    );
                }
            }

            // Create and initialize a ValueSet record with the mandatory fields
            r4:ValueSet valueSet = {status: "unknown"};

            r4:ValueSet|error ensured = vs.clone().ensureType();
            if ensured !is error {
                valueSet = ensured;
            } else if system is string {
                map<r4:RequestSearchParameter[]> clone = searchParameters.clone();
                if clone.hasKey(FILTER) {
                    _ = clone.remove(FILTER);
                }

                if !clone.hasKey(VALUESETS_SEARCH_PARAMS.url) {
                    r4:RequestSearchParameter r = {
                        name: VALUESETS_SEARCH_PARAMS.url,
                        value: system,
                        typedValue: {modifier: r4:MODIFIER_EXACT},
                        'type: r4:URI
                    };
                    clone[VALUESETS_SEARCH_PARAMS.url] = [r];
                }

                if clone.hasKey(VALUESETS_EXPANSION_PARAMS.valueSetVersion) {
                    r4:RequestSearchParameter[] p = [];
                    foreach var item in clone.get(VALUESETS_EXPANSION_PARAMS.valueSetVersion) {
                        r4:RequestSearchParameter r = {
                            name: VALUESETS_SEARCH_PARAMS.version,
                            value: item.value,
                            typedValue: {modifier: r4:MODIFIER_EXACT},
                            'type: r4:STRING
                        };

                        p.push(r);
                    }
                    clone[VALUESETS_SEARCH_PARAMS.version] = p;
                    _ = clone.remove(VALUESETS_EXPANSION_PARAMS.valueSetVersion);
                }

                r4:ValueSet[] v = check self.searchValueSets(clone);
                if v.length() > 0 {
                    valueSet = v[0];
                } else {
                    return r4:createFHIRError(
                        string `Can not find a ValueSet for system: ${system.toString()}`,
                        r4:ERROR,
                        r4:INVALID_REQUIRED,
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_BAD_REQUEST
                    );
                }
            }
            else {
                return r4:createFHIRError(
                    "Can not find a ValueSet",
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = "Either ValueSet record or system URL should be provided as input",
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            ValueSetExpansionDetails? details = self.getAllConceptInValueSet(valueSet);

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

                    r4:ValueSetExpansion expansion = self.createExpandedValueSet(valueSet, concepts);
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

                    r4:ValueSetExpansion expansion = self.createExpandedValueSet(valueSet, concepts);
                    expansion.offset = offset;
                    expansion.total = totalCount;
                    valueSet.expansion = expansion.clone();
                }
            }
            return valueSet.clone();
        }
    }

    # This method with compare concepts.
    # This method was implemented based on: http://hl7.org/fhir/R4/terminology-service.html#subsumes.
    #
    # + conceptA - Concept 1  
    # + conceptB - Concept 2  
    # + cs - CodeSystem value  
    # + system - System uri of the codeSystem  
    # + version - Version of the CodeSystem and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Return Values either equivalent or not-subsumed if processing is successful, FHIRError processing fails
    public isolated function subsumes(r4:code|r4:Coding conceptA, r4:code|r4:Coding conceptB, r4:CodeSystem? cs = (), r4:uri? system = (),
            string? version = ()) returns i4:Parameters|r4:FHIRError {
        lock {
            // Create and initialize a CodeSystem record with the mandatory fields
            r4:CodeSystem codeSystem = {content: "example", status: "unknown"};
            if cs is () && system != () && self.readCodeSystemByUrl(system, version) is r4:CodeSystem {
                codeSystem = check self.readCodeSystemByUrl(system, version);
            } else if cs != () {
                codeSystem = cs.clone();
            } else {
                return r4:createFHIRError(
                    "Can not find a CodeSystem",
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = "CodeSystem record or system URL should be provided as input",
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }

            r4:CodeSystemConcept? conceptDetailsA = self.retrieveCodeSystemConcept(codeSystem, conceptA.clone());
            r4:CodeSystemConcept? conceptDetailsB = self.retrieveCodeSystemConcept(codeSystem, conceptB.clone());

            if conceptDetailsA != () && conceptDetailsB != () {
                if conceptDetailsA.code == conceptDetailsB.code && conceptDetailsA.display == conceptDetailsB.display {
                    return {'parameter: [{name: OUTCOME, valueCode: EQUIVALENT}]};
                } else {
                    return {'parameter: [{name: OUTCOME, valueCode: NOT_SUBSUMED}]};
                }
            } else if conceptDetailsA is () {
                return r4:createFHIRError(
                    string `Code/ Coding: ${conceptA.toBalString()} is not included in the provided CodeSystem`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            } else {
                return r4:createFHIRError(
                    string `Code/ Coding: ${conceptB.toBalString()} is not included in the provided CodeSystem`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
            }
        }
    }

    # Find a CodeSystem based on the provided URL and version.
    #
    # + url - URL of the CodeSystem to be retrieved
    # + version - Version of the CodeSystem to be retrieved and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Return CodeSystem data if the request is successful, return FHIR error if no data found for the provided URL
    public isolated function readCodeSystemByUrl(r4:uri url, string? version = ()) returns r4:CodeSystem|r4:FHIRError {
        lock {
            if self.finder is Finder {
                return (<Finder>self.finder).findCodeSystem(url, version);
            }

            boolean isIdExistInRegistry = false;
            if version is string {
                foreach var item in self.codeSystems.keys() {
                    if regexp:isFullMatch(re `${url}\|${version}$`, item) && self.codeSystems[item] is r4:CodeSystem {
                        return <r4:CodeSystem>self.codeSystems[item].clone();
                    } else if regexp:isFullMatch(re `${url}\|.*`, item) {
                        isIdExistInRegistry = true;
                    }
                }

                if isIdExistInRegistry {
                    return r4:createFHIRError(
                            string `Unknown version: '${version}'`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `There is CodeSystem in the registry with Id: '${url}' but can not find version: '${version}' of it`,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                }
            } else {
                r4:CodeSystem codeSystem = {content: "example", status: "unknown"};
                string latestVersion = DEFAULT_VERSION;
                foreach var item in self.codeSystems.keys() {
                    if regexp:isFullMatch(re `${url}\|.*`, item)
                && self.codeSystems[item] is r4:CodeSystem
                && (<r4:CodeSystem>self.codeSystems[item]).version > latestVersion {
                        codeSystem = <r4:CodeSystem>self.codeSystems[item];
                        latestVersion = codeSystem.version ?: DEFAULT_VERSION;
                        isIdExistInRegistry = true;
                    }
                }

                if isIdExistInRegistry {
                    return codeSystem.clone();
                } else {
                    return r4:createFHIRError(
                            string `Unknown CodeSystem: '${url.toBalString()}'`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                }
            }
            return r4:createFHIRError(
                string `Unknown CodeSystem: '${url.toBalString()}'`,
                r4:ERROR,
                r4:PROCESSING_NOT_FOUND,
                httpStatusCode = http:STATUS_NOT_FOUND
            );

        }
    }

    // # Find a ValueSet for a provided URL and version.
    // #
    // # + url - URL of the Value Set to be retrieved
    // # + version - Version of the ValueSet to be retrieved and it should be provided with system parameter,
    // # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    // # + return - Return ValueSet data if the request is successful, return FHIR error if no data found for the provided URL
    public isolated function readValueSetByUrl(r4:uri url, string? version = ()) returns r4:ValueSet|r4:FHIRError {
        lock {
            if self.finder is Finder {
                return (<Finder>self.finder).findValueSet(url, version);
            }

            boolean isIdExistInRegistry = false;
            if version is string {
                foreach var item in self.valueSets.keys() {
                    if regexp:isFullMatch(re `${url}\|${version}$`, item) && self.valueSets[item] is r4:ValueSet {
                        return <r4:ValueSet>self.valueSets[item].clone();
                    } else if regexp:isFullMatch(re `${url}\|.*`, item) {
                        isIdExistInRegistry = true;
                    }
                }

                if isIdExistInRegistry {
                    return r4:createFHIRError(
                            string `Unknown version: '${version}'`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            diagnostic = string `There is ValueSet in the registry with Id: '${url}' but can not find version: '${version}' of it`,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                }
            } else {
                r4:ValueSet valueSet = {status: "unknown"};
                string latestVersion = DEFAULT_VERSION;
                foreach var item in self.valueSets.keys() {
                    if regexp:isFullMatch(re `${url}\|.*`, item)
                        && self.valueSets[item] is r4:ValueSet
                        && (<r4:ValueSet>self.valueSets[item]).version > latestVersion {

                        valueSet = <r4:ValueSet>self.valueSets[item];
                        latestVersion = valueSet.version ?: DEFAULT_VERSION;
                        isIdExistInRegistry = true;
                    }
                }

                if !isIdExistInRegistry {
                    return r4:createFHIRError(
                            string `Unknown ValueSet: '${url}'`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
                } else {
                    return valueSet.clone();
                }
            }

            return r4:createFHIRError(
                    string `Unknown ValueSet: '${url.toBalString()}'`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                );

        }

    }

    # Create CodeableConcept data type for given code in a given system.
    #
    # + system - system uri of the code system or value set  
    # + code - code interested  
    # + finder - (optional) custom code system function (utility will used this function to find code  
    # system in a external source system)  
    # + version - Version of the CodeSystem and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Created CodeableConcept record or FHIRError if not found
    public isolated function createCodeableConcept(r4:uri system, r4:code code, string? version = (),
            Finder? finder = ()) returns r4:CodeableConcept|r4:FHIRError {
        lock {
            CodeConceptDetails? conceptResult = check self.findConcept(system, code, finder, version = version);
            if conceptResult != () {
                return self.conceptToCodeableConcept(conceptResult.concept.clone(), conceptResult.url.clone());
            }
            return r4:createInternalFHIRError(
                string `Code : ${code} not found in system : ${system}`,
                r4:ERROR,
                r4:PROCESSING_NOT_FOUND
            );
        }
    }

    # Create Coding data type for given code in a given system.
    #
    # + system - System uri of the CodeSystem or valueSet  
    # + code - code interested  
    # + finder - (optional) custom code system function (utility will used this function to find code  
    # system in a external source system)  
    # + version - Version of the CodeSystem and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Created CodeableConcept record or FHIRError if not found
    public isolated function createCoding(r4:uri system, r4:code code, string? version = (),
            Finder? finder = ()) returns r4:Coding|r4:FHIRError {
        lock {
            CodeConceptDetails? conceptResult = check self.findConcept(system, code, finder, version = version);
            if conceptResult != () {
                return self.conceptToCoding(conceptResult.concept.clone(), conceptResult.url.clone());
            }

            return r4:createInternalFHIRError(
                string `Code : ${code} not found in system : ${system}`,
                r4:ERROR,
                r4:PROCESSING_NOT_FOUND
            );
        }
    }

    // Function to find concept in CodeSystems or ValueSets by passing code data type parameter.
    private isolated function findConcept(r4:uri system, r4:code code, Finder? codeSystemFinder = (), string? version = ())
                                                                                returns CodeConceptDetails|r4:FHIRError? {
        lock {
            if self.finder is Finder {
                r4:CodeSystemConcept concept = check (<Finder>self.finder).findConcept(system, code);
                return {
                    url: system,
                    concept: concept.clone()
                };
            } else if self.readValueSetByUrl(system, version) is r4:ValueSet {
                return self.findConceptInValueSet(check self.readValueSetByUrl(system, version), code);
            } else if self.readCodeSystemByUrl(system, version) is r4:CodeSystem {
                return self.findConceptInCodeSystem(check self.readCodeSystemByUrl(system, version), code);
            } else {
                return r4:createInternalFHIRError(
                string `Unknown ValueSet or CodeSystem : ${system}`,
                r4:ERROR,
                r4:PROCESSING_NOT_FOUND
                );
            }
        }
    }

    // Function to find concept in a CodeSystem by passing code data type parameter. 
    private isolated function findConceptInCodeSystem(r4:CodeSystem codeSystem, r4:code code) returns CodeConceptDetails? {
        lock {
            r4:CodeSystemConcept[]? concepts = codeSystem.concept;
            r4:uri? url = codeSystem.url;
            if concepts != () && url != () {
                foreach r4:CodeSystemConcept concept in concepts {
                    if concept.code == code {
                        CodeConceptDetails codeConcept = {
                            url: url,
                            concept: concept
                        };
                        return codeConcept;
                    }
                }
            }
            return;
        }
    }

    // Function to find concept in a CodeSystem by passing Coding data type parameter.
    private isolated function findConceptInCodeSystemFromCoding(r4:CodeSystem codeSystem, r4:Coding coding) returns CodeConceptDetails? {
        lock {
            r4:code? code = coding.code;

            if code != () {
                return self.findConceptInCodeSystem(codeSystem.clone(), code.clone()).clone();
            } else {
                string msg = "No valid code found in the Coding";
                log:printDebug(r4:createFHIRError(msg, r4:ERROR, r4:PROCESSING_NOT_FOUND).toBalString());
            }
            return;
        }
    }

    // Function to get all concepts in a CodeSystem.
    private isolated function getAllConceptInCodeSystem(r4:CodeSystem codeSystem) returns ValueSetExpansionDetails? {
        lock {
            r4:CodeSystemConcept[]? concepts = codeSystem.concept;
            r4:uri? url = codeSystem.url;
            if concepts != () && url != () {
                ValueSetExpansionDetails codeConcept = {
                    url: url,
                    concepts: concepts
                };
                return codeConcept;
            }
            return;
        }
    }

    // // Function to find concept in a ValueSet by passing code data type parameter. 
    private isolated function findConceptInValueSet(r4:ValueSet valueSet, r4:code code) returns (CodeConceptDetails)? {
        lock {
            r4:ValueSetCompose? composeBBE = valueSet.clone().compose;
            if composeBBE != () {
                foreach r4:ValueSetComposeInclude includeBBE in composeBBE.include {
                    r4:uri? systemValue = includeBBE.system;

                    if systemValue != () {
                        r4:ValueSetComposeIncludeConcept[]? includeConcepts = includeBBE.concept;
                        if includeConcepts != () {
                            foreach r4:ValueSetComposeIncludeConcept includeConcept in includeConcepts {
                                if includeConcept.code == code {
                                    // found the code
                                    return {
                                        url: systemValue,
                                        concept: includeConcept
                                    }.clone();
                                }
                            }
                        } else {
                            // Find CodeSystem
                            r4:CodeSystem|r4:FHIRError codeSystemByUrl = self.readCodeSystemByUrl(systemValue);
                            if codeSystemByUrl is r4:CodeSystem {
                                CodeConceptDetails? result = self.findConceptInCodeSystem(codeSystemByUrl, code);
                                if result != () {
                                    return result.clone();
                                }
                            } else {
                                log:printDebug(codeSystemByUrl.toBalString());
                            }
                        }
                    } else {
                        // check the contents included in this value set
                        r4:canonical[]? valueSetResult = includeBBE.valueSet;
                        if valueSetResult != () {
                            //+ Rule: A value set include/exclude SHALL have a value set or a system
                            foreach r4:canonical valueSetEntry in valueSetResult {
                                if self.valueSets.hasKey(valueSetEntry) {
                                    CodeConceptDetails? concept = self.findConceptInValueSet(self.valueSets.get(valueSetEntry), code);
                                    if concept != () {
                                        return concept.clone();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return;
        }
    }

    // // Function to find concepts in a ValueSet by passing Coding data type parameter.
    private isolated function findConceptInValueSetFromCoding(r4:ValueSet valueSet, r4:Coding coding) returns CodeConceptDetails? {
        lock {
            r4:code? code = coding.code;

            if code != () {
                return self.findConceptInValueSet(valueSet.clone(), code.clone()).clone();
            } else {
                string msg = "No valid code found in the Coding";
                log:printDebug(r4:createFHIRError(msg, r4:ERROR, r4:PROCESSING_NOT_FOUND).toBalString());
            }
            return;
        }
    }

    // // Function to get all concept in a ValueSet. 
    private isolated function getAllConceptInValueSet(r4:ValueSet valueSet) returns (ValueSetExpansionDetails)? {
        lock {
            r4:ValueSetCompose? composeBBE = valueSet.clone().compose;
            if composeBBE != () {
                foreach r4:ValueSetComposeInclude includeBBE in composeBBE.include {
                    r4:uri? systemValue = includeBBE.system;

                    if systemValue != () {
                        r4:ValueSetComposeIncludeConcept[]? includeConcepts = includeBBE.concept;
                        if includeConcepts != () {
                            ValueSetExpansionDetails concepts = {
                                url: systemValue,
                                concepts: includeConcepts
                            };
                            return concepts.clone();
                        } else {
                            // Find CodeSystem
                            r4:CodeSystem|r4:FHIRError codeSystem = self.readCodeSystemByUrl(systemValue);
                            if codeSystem is r4:CodeSystem {
                                ValueSetExpansionDetails? result = self.getAllConceptInCodeSystem(codeSystem);
                                if result != () {
                                    return result.clone();
                                }
                            } else {
                                log:printDebug(codeSystem.toBalString());
                            }
                        }
                    } else {
                        // check the contents included in this value set
                        r4:canonical[]? valueSetResult = includeBBE.valueSet;
                        if valueSetResult != () {
                            //+ Rule: A value set include/exclude SHALL have a value set or a system
                            foreach r4:canonical valueSetEntry in valueSetResult {
                                if self.valueSets.hasKey(valueSetEntry) {
                                    ValueSetExpansionDetails? concept =
                                                            self.getAllConceptInValueSet(self.valueSets.get(valueSetEntry));
                                    if concept != () {
                                        return concept.clone();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return;
        }
    }

    private isolated function conceptToCodeableConcept(
            r4:CodeSystemConcept|r4:ValueSetComposeIncludeConcept concept, r4:uri system) returns r4:CodeableConcept {
        lock {
            r4:Coding codingValue = {
                code: concept.code,
                system: system
            };
            string? displayValue = concept.display;
            if displayValue != () {
                codingValue.display = displayValue;
            }

            r4:CodeableConcept cConcept = {
                coding: [
                    codingValue
                ]
            };

            if concept is r4:CodeSystemConcept {
                string? defValue = concept.definition;
                if defValue != () {
                    cConcept.text = defValue;
                }
            }
            return cConcept;
        }
    }

    private isolated function conceptToCoding(r4:CodeSystemConcept|r4:ValueSetComposeIncludeConcept concept, r4:uri system) returns r4:Coding {
        lock {
            r4:Coding codingValue = {
                code: concept.code,
                system: system
            };
            string? displayValue = concept.display;
            if displayValue != () {
                codingValue.display = displayValue;
            }
            return codingValue;
        }
    }

    //Only for in-memory opertaions
    private isolated function retrieveCodeSystemConcept(r4:CodeSystem codeSystem, r4:code|r4:Coding concept) returns r4:CodeSystemConcept? {
        lock {
            if concept is r4:code {
                CodeConceptDetails? conceptDetails = self.findConceptInCodeSystem(
                codeSystem.clone(), concept.clone());
                if conceptDetails is CodeConceptDetails {
                    r4:CodeSystemConcept|r4:ValueSetComposeIncludeConcept codeConcept = conceptDetails.concept;
                    if codeConcept is r4:CodeSystemConcept {
                        return codeConcept.clone();
                    }
                }
            } else {
                CodeConceptDetails? conceptDetails = self.findConceptInCodeSystemFromCoding(
                codeSystem.clone(), concept.clone());

                if conceptDetails is CodeConceptDetails {
                    r4:CodeSystemConcept|r4:ValueSetComposeIncludeConcept temp = conceptDetails.concept;
                    if temp is r4:CodeSystemConcept {
                        return temp.clone();
                    }
                }
            }
            return;
        }
    }

    private isolated function createExpandedValueSet(r4:ValueSet vs, r4:CodeSystemConcept[]|r4:ValueSetComposeIncludeConcept[] concepts)
                                                                                                    returns r4:ValueSetExpansion {
        lock {
            r4:ValueSetExpansionContains[] contains = [];
            if concepts is r4:ValueSetComposeIncludeConcept[] {
                foreach r4:ValueSetComposeIncludeConcept concept in concepts {
                    r4:ValueSetExpansionContains c = {code: concept.code, display: concept.display, id: concept.id};
                    contains.push(c);
                }
            } else {
                foreach r4:CodeSystemConcept concept in concepts {
                    r4:ValueSetExpansionContains c = {code: concept.code, display: concept.display, id: concept.id};
                    contains.push(c);
                }
            }

            r4:ValueSetExpansion expansion = {timestamp: time:utcToString(time:utcNow()), contains: contains};
            return expansion;
        }
    }
}
