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
import ballerina/regex;
import ballerina/time;

//It is a custom record to hold system URLs and a related concept.  
type CodeConceptDetails record {
    //System URL of the concept.
    uri url;
    CodeSystemConcept|ValueSetComposeIncludeConcept concept;
};

//It is a custom record to hold system URLs and a array of related concepts.
type ValueSetExpansionDetails record {
    //System URL of the concepts.
    uri url;
    CodeSystemConcept[]|ValueSetComposeIncludeConcept[] concepts;
};

# The function definition for code system finder implementations.
public type CodeSystemFinder isolated function (uri system, code code) returns CodeSystem|ValueSet|FHIRError;

# A processor to process terminology data and create relevant data elements.
public isolated class TerminologyProcessor {

    # Global records to store Terminologies across different profiles and packages.
    private map<CodeSystem> codeSystems = {};
    private map<ValueSet> valueSets = {};

    public function init() {
    }

    # It will initialize the Terminology map.
    # It will delete the existing records if it is re-initialized.
    # It will be used during the package initialization 
    #
    # + terminology - Terminology record
    public isolated function initTerminology(Terminology terminology) {
        lock {
            self.codeSystems = terminology.clone().codeSystems;
            self.valueSets = terminology.clone().valueSets;
        }
    }

    # Add list of new CodeSystems.
    #
    # + codeSystems - List CodeSystems
    # + return - Return List of FHIRErrors if any
    public isolated function addCodeSystems(CodeSystem[] codeSystems) returns FHIRError[]? {
        FHIRError[] errors = [];
        foreach CodeSystem codeSystem in codeSystems {
            FHIRError? result = self.addCodeSystem(codeSystem);
            _ = result is FHIRError ? errors.push(result) : "";
        }
        return errors;
    }

    # Add list of new CodeSystems as a json or json array.
    #
    # + codeSystemJsonArray - CodeSystem data in the JSON format
    # + return - Return List of FHIRErrors if any
    public isolated function addCodeSystemsAsJson(json[] codeSystemJsonArray) returns FHIRError[]? {
        FHIRError[] errors = [];
        CodeSystem[] codeSystems = [];

        foreach var c in codeSystemJsonArray {
            CodeSystem|error result = c.cloneWithType();
            if result is error {
                FHIRError er = createFHIRError(
                    string `Invalid data. Can not parse the provided json data: ${c.toBalString()}`,
                    ERROR,
                    INVALID,
                    diagnostic = "Please check the provided json structure and re-try with this data again",
                    cause = result,
                    httpStatusCode = http:STATUS_BAD_REQUEST);

                errors.push(er);
            } else {
                codeSystems.push(result);
            }
        }

        _ = codeSystems.length() > 0 ? errors.push(...<FHIRError[]>self.addCodeSystems(codeSystems)) : "";

        if errors.length() > 0 {
            return errors;
        }
        return;
    }

    # Add list of new ValueSets.
    #
    # + valueSets - List ValueSets in the Ballerina record format
    # + return - Return List of FHIRErrors if any
    public isolated function addValueSets(ValueSet[] valueSets) returns FHIRError[]? {
        FHIRError[] errors = [];
        foreach ValueSet valueSet in valueSets {
            FHIRError? result = self.addValueSet(valueSet);
            _ = result is FHIRError ? errors.push(result) : "";
        }
        return errors;
    }

    # Add list of new ValueSet as a json or json array.
    #
    # + valueSetJsonArray - Json ValueSet data in the JSON format
    # + return - Return List of FHIRErrors if any
    public isolated function addValueSetsAsJson(json[] valueSetJsonArray) returns FHIRError[]? {
        FHIRError[] errors = [];
        ValueSet[] valueSets = [];

        foreach var v in valueSetJsonArray {
            ValueSet|error result = v.cloneWithType();
            if result is error {
                FHIRError er = createFHIRError(
                    string `Invalid data. Can not parse the provided json data: ${v.toBalString()}`,
                    ERROR,
                    INVALID,
                    diagnostic = "Please check the provided json structure and re-try with this data again",
                    cause = result,
                    httpStatusCode = http:STATUS_BAD_REQUEST);

                errors.push(er);
            } else {
                valueSets.push(result);
            }
        }

        _ = valueSets.length() > 0 ? errors.push(...<FHIRError[]>self.addValueSets(valueSets)) : "";

        if errors.length() > 0 {
            return errors;
        }
        return;
    }

    # Add a new CodeSystem.
    #
    # + codeSystem - ValueSet to be added, data in the Ballerina record format
    # + return - Return FHIRError
    public isolated function addCodeSystem(CodeSystem codeSystem) returns FHIRError? {
        lock {
            if codeSystem.url == () {
                return createFHIRError(
            string `Can not find the URL of the CodeSystem with name: ${codeSystem.name.toBalString()}`,
            ERROR,
            INVALID_REQUIRED,
            diagnostic = string `Add a proper URL for the resource: 
                                    http://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.url`,
            errorType = VALIDATION_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
            }

            if codeSystem.'version == () {
                return createFHIRError(
            string `Can not find the version of the CodeSystem with name: ${codeSystem.name.toBalString()}`,
            ERROR,
            INVALID_REQUIRED,
            diagnostic = string `Add appropriate version for the resource: 
                                    https://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.version`,
            errorType = VALIDATION_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
            }

            string url = <string>codeSystem.url;
            string 'version = <string>codeSystem.'version;
            string key = string `${url}|${'version}`;

            if self.codeSystems.hasKey(key) {
                return createFHIRError(
            "Duplicate entry",
            ERROR,
            PROCESSING_DUPLICATE,
            diagnostic = string `Already there is a CodeSystem exists in the registry with the URL: ${url}`,
            errorType = PROCESSING_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
            }

            FHIRValidationError? validateResult = validate(codeSystem.clone(), CodeSystem);

            if validateResult is FHIRValidationError {
                return createFHIRError(
            "Validation failed",
            ERROR,
            INVALID,
            diagnostic = string `Check whether the data conforms to the specification: 
                                    http://hl7.org/fhir/R4/codesystem-definitions.html`,
            errorType = VALIDATION_ERROR,
            cause = validateResult,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
            }

            self.codeSystems[key] = codeSystem.clone();
        }
    }

    # Add a new ValueSet.
    #
    # + valueSet - ValueSet to be added, data in the Ballerina record format
    # + return - Return FHIRError
    public isolated function addValueSet(ValueSet valueSet) returns FHIRError? {
        lock {
            if valueSet.url == () {
                return createFHIRError(
            string `Can not find the URL of the ValueSet with name: ${valueSet.name.toBalString()}`,
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "Add a proper URL for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.url",
            errorType = VALIDATION_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
            }

            if valueSet.'version == () {
                return createFHIRError(
            string `Can not find the version of the ValueSet with name: ${valueSet.name.toBalString()}`,
            ERROR,
            INVALID_REQUIRED,
            diagnostic = string `Add appropriate version for the resource: 
                                     http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.version`,
            errorType = VALIDATION_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
            }

            string url = <string>valueSet.url;
            string rVersion = <string>valueSet.'version;
            string rKey = string `${url}|${rVersion}`;

            if self.valueSets.hasKey(rKey) {
                return createFHIRError(
            "Duplicate entry",
            ERROR,
            PROCESSING_DUPLICATE,
            diagnostic = string `Already there is a ValueSet exists in the registry with the URL: ${url}`,
            errorType = VALIDATION_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
            }

            FHIRValidationError? validateResult = validate(valueSet.clone(), ValueSet);

            if validateResult is FHIRValidationError {
                return createFHIRError(
            "Validation failed",
            ERROR,
            INVALID,
            diagnostic = string `Check whether the data conforms to the specification: 
                                    http://hl7.org/fhir/R4/valueset-definitions.html`,
            errorType = VALIDATION_ERROR,
            cause = validateResult,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
            }

            self.valueSets[rKey] = valueSet.clone();
        }
    }

    # Find a Code System based on the provided Id and version.
    #
    # + id - Id of the CodeSystem to be retrieved
    # + version - Version of the CodeSystem to be retrieved and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Return CodeSystem data if the request is successful, return FHIR error if no data found for the provided Id
    public isolated function readCodeSystemById(string id, string? 'version = ()) returns CodeSystem|FHIRError {
        lock {
            CodeSystem[] codeSystems = self.codeSystems.toArray();
            CodeSystem cs = {content: "example", status: "unknown"};

            codeSystems = from CodeSystem entry in codeSystems
                where entry.id == id
                select entry;

            if codeSystems.length() > 0 {
                if 'version is string {
                    codeSystems = from CodeSystem entry in codeSystems
                        where entry.'version == 'version
                        select entry;
                    cs = codeSystems.length() > 0 ? codeSystems[0] : cs;
                }
                if codeSystems.length() < 1 {
                    return createFHIRError(
                        string `Unknown version: '${'version.toString()}'`,
                        ERROR,
                        PROCESSING_NOT_FOUND,
                        diagnostic = string
                        `There is CodeSystem in the registry with Id: '${id}' but can not find version: '${'version.toString()}' of it`,
                        httpStatusCode = http:STATUS_NOT_FOUND
                        );
                } else {
                    string latestVersion = "0.0.0";
                    foreach var item in codeSystems {
                        if item.'version > latestVersion {
                            latestVersion = <string>item.'version;
                            cs = item;
                        }
                    }
                }
            } else {
                return createFHIRError(
                    string `Unknown CodeSystem: '${id}'`,
                                                ERROR,
                                                PROCESSING_NOT_FOUND,
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
    public isolated function readValueSetById(string id, string? 'version = ()) returns ValueSet|FHIRError {
        lock {
            ValueSet[] valueSets = self.valueSets.toArray();
            ValueSet vs = {status: "unknown"};

            valueSets = from ValueSet entry in valueSets
                where entry.id == id
                select entry;

            if valueSets.length() > 0 {
                if 'version is string {
                    valueSets = from ValueSet entry in valueSets
                        where entry.'version == 'version
                        select entry;
                    vs = valueSets.length() > 0 ? valueSets[0] : vs;
                }
                if valueSets.length() < 1 {
                    return createFHIRError(
                        string `Unknown version: '${'version.toString()}'`,
                        ERROR,
                        PROCESSING_NOT_FOUND,
                        diagnostic = string
                        `There is ValueSet in the registry with Id: '${id}' but can not find version: '${'version.toString()}' of it`,
                        httpStatusCode = http:STATUS_NOT_FOUND
                        );
                } else {
                    string latestVersion = "0.0.0";
                    foreach var item in valueSets {
                        if item.'version > latestVersion {
                            latestVersion = <string>item.'version;
                            vs = item;
                        }
                    }
                }
            } else {
                return createFHIRError(
                    string `Unknown ValueSet: '${id}'`,
                                                ERROR,
                                                PROCESSING_NOT_FOUND,
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
    public isolated function searchCodeSystems(map<RequestSearchParameter[]> params) returns CodeSystem[]|FHIRError {
        lock {
            map<RequestSearchParameter[]> searchParameters = params.clone();
            int count = TERMINOLOGY_SEARCH_DEFAULT_COUNT;
            if searchParameters.hasKey("_count") {
                int|error y = langint:fromString(searchParameters.get("_count")[0].value);
                if y is int {
                    count = y;
                }
                _ = searchParameters.remove("_count");
            }

            int offset = 0;
            if searchParameters.hasKey("_offset") {
                int|error y = langint:fromString(searchParameters.get("_offset")[0].value);
                if y is int {
                    offset = y;
                }
                _ = searchParameters.remove("_offset");
            }

            if count > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                return createFHIRError(
                string `Requested size of the response: ${count.toBalString()} is too large`,
                ERROR,
                PROCESSING_NOT_SUPPORTED,
                diagnostic = string `Allowed maximum size of output is: ${TERMINOLOGY_SEARCH_MAXIMUM_COUNT}; therefore, reduce the value of size parameter accordingly`,
                errorType = PROCESSING_ERROR,
                httpStatusCode = http:STATUS_PAYLOAD_TOO_LARGE
                );
            }

            // Validate whether the requested search parameters in the allowed list
            foreach var param in searchParameters.clone().keys() {
                if !CODESYSTEMS_SEARCH_PARAMS.hasKey(param) {
                    return createFHIRError(
                string `This search parameter is not implemented yet: ${param}`,
                ERROR,
                PROCESSING_NOT_SUPPORTED,
                diagnostic = string `Allowed search parameters: ${CODESYSTEMS_SEARCH_PARAMS.keys().toBalString()}`,
                errorType = VALIDATION_ERROR);
                }
            }

            CodeSystem[] codeSystemArray = self.codeSystems.toArray();

            foreach var searchParam in searchParameters.clone().keys() {
                RequestSearchParameter[] searchParamValues = searchParameters.clone()[searchParam] ?: [];

                CodeSystem[] filteredList = [];
                if searchParamValues.length() != 0 {
                    foreach var queriedValue in searchParamValues {
                        CodeSystem[] result = from CodeSystem entry in codeSystemArray
                            where entry[CODESYSTEMS_SEARCH_PARAMS.get(searchParam)] == queriedValue.value
                            select entry;
                        filteredList.push(...result);
                    }
                    codeSystemArray = filteredList;
                }
            }

            int total = codeSystemArray.length();

            if total > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                return createFHIRError(
                        "The response size is too large",
                        ERROR,
                        PROCESSING_TOO_COSTLY,
                        diagnostic = "The response size is too large; therefore search with more specific parameter values",
                        errorType = PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
                        );
            } else if total >= offset + count {
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
    public isolated function searchValueSets(map<RequestSearchParameter[]> params) returns FHIRError|ValueSet[] {
        lock {
            map<RequestSearchParameter[]> searchParameters = params.clone();
            int count = TERMINOLOGY_SEARCH_DEFAULT_COUNT;
            if searchParameters.hasKey("_count") {
                int|error y = langint:fromString(searchParameters.get("_count")[0].value);
                if y is int {
                    count = y;
                }
                _ = searchParameters.remove("_count");
            }

            int offset = 0;
            if searchParameters.hasKey("_offset") {
                int|error y = langint:fromString(searchParameters.get("_offset")[0].value);
                if y is int {
                    offset = y;
                }
                _ = searchParameters.remove("_offset");
            }

            if count > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                return createFHIRError(
                string `Requested size of the response: ${count.toBalString()} is too large`,
                ERROR,
                PROCESSING_NOT_SUPPORTED,
                diagnostic = string `Allowed maximum size of output is: ${TERMINOLOGY_SEARCH_MAXIMUM_COUNT}; therefore, reduce the value of size parameter accordingly`,
                errorType = PROCESSING_ERROR,
                httpStatusCode = http:STATUS_PAYLOAD_TOO_LARGE
                );
            }

            // Validate the requested search parameters in the allowed list
            foreach var param in searchParameters.clone().keys() {
                if !VALUESETS_SEARCH_PARAMS.hasKey(param) {
                    return createFHIRError(
                string `This search parameter is not implemented yet: ${param}`,
                ERROR,
                PROCESSING_NOT_SUPPORTED,
                diagnostic = string `Allowed search parameters: ${VALUESETS_SEARCH_PARAMS.keys().toBalString()}`,
                errorType = VALIDATION_ERROR);
                }
            }

            ValueSet[] valueSetArray = self.valueSets.toArray();

            foreach var searchParam in searchParameters.clone().keys() {
                RequestSearchParameter[] searchParamValues = searchParameters.clone()[searchParam] ?: [];

                ValueSet[] filteredList = [];
                if searchParamValues.length() != 0 {
                    foreach var queriedValue in searchParamValues {
                        ValueSet[] result = from ValueSet entry in valueSetArray
                            where entry[VALUESETS_SEARCH_PARAMS.get(searchParam)] == queriedValue.value
                            select entry;
                        filteredList.push(...result);
                    }
                    valueSetArray = filteredList;
                }
            }

            int total = valueSetArray.length();
            if total > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                return createFHIRError(
                        "The response size is too large",
                        ERROR,
                        PROCESSING_TOO_COSTLY,
                        diagnostic = string `The response size is too large; therefore, search with more specific parameter values`,
                        errorType = PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
                        );
            } else if total >= offset + count {
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
    public isolated function codeSystemLookUp(code|Coding|CodeableConcept codeValue, CodeSystem? cs = (), uri? system = (),
            string? 'version = ()) returns CodeSystemConcept[]|CodeSystemConcept|FHIRError {
        lock {
            // Create and initialize a CodeSystem record with the mandatory fields
            CodeSystem codeSystem = {content: "example", status: "unknown"};
            CodeSystemConcept[] codeConceptDetailsList = [];

            CodeSystem|error ensured = cs.clone().ensureType();
            if ensured !is error {
                codeSystem = ensured;
            } else if system !is () {
                CodeSystem|FHIRError codeSystemById = self.readCodeSystemByUrl(system, 'version);
                if codeSystemById is CodeSystem {
                    codeSystem = codeSystemById;
                } else {
                    return createFHIRError(string `Cannot find a CodeSystem for the provided system URL: ${system}`,
                    ERROR,
                    INVALID,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
                }
            } else {
                return createFHIRError(
                    "Can not find a CodeSystem",
                    ERROR,
                    INVALID_REQUIRED,
                    diagnostic = "Either CodeSystem record or system URL should be provided as input",
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
            }

            if codeValue is code && codeValue.trim() !is "" {
                CodeConceptDetails? result = self.findConceptInCodeSystem(codeSystem, codeValue);

                if result is CodeConceptDetails {
                    return result.concept.clone();
                } else {
                    return createFHIRError(
                    string `Can not find any valid concepts for the code: ${codeValue.toBalString()} in CodeSystem: ${codeSystem.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
                }
            } else if codeValue is Coding {
                CodeConceptDetails? result = self.findConceptInCodeSystemFromCoding(codeSystem, codeValue.clone());

                if result is CodeConceptDetails {
                    return result.concept.clone();
                } else {
                    return createFHIRError(
                    string `Can not find any valid concepts for the coding with code: ${codeValue.code.toBalString()} in CodeSystem: ${codeSystem.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
                }
            } else if codeValue is CodeableConcept {
                Coding[]? codings = codeValue.clone().coding;

                if codings != () {
                    foreach var c in codings {
                        CodeConceptDetails? result = self.findConceptInCodeSystemFromCoding(codeSystem.cloneReadOnly(), c);
                        if result is CodeConceptDetails {
                            codeConceptDetailsList.push(result.concept);
                        }
                    }

                    if codeConceptDetailsList.length() < 0 {
                        return createFHIRError(
                    string `Can not find any valid concepts for the CodeableConcept: ${codeValue.toBalString()} in CodeSystem: ${codeSystem.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
                    }
                    if codeConceptDetailsList.length() == 1 {
                        return codeConceptDetailsList[0].clone();
                    } else {
                        return codeConceptDetailsList.clone();
                    }

                } else {
                    return createFHIRError(
                    "Can not find any valid Codings in the provide CodeableConcept data",
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
                }
            }
            return createFHIRError(
            "Either code or Coding or CodeableConcept should be provided as input",
            ERROR,
            PROCESSING_NOT_FOUND,
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
    public isolated function valueSetLookUp(code|Coding|CodeableConcept codeValue, ValueSet? vs = (), uri? system = (), string? 'version = ())
                                                                                    returns CodeSystemConcept[]|CodeSystemConcept|FHIRError {
        lock {
            // Create and initialize a ValueSet record with the mandatory fields
            ValueSet valueSet = {status: "unknown"};
            CodeSystemConcept[] codeConceptDetailsList = [];

            ValueSet|error ensured = vs.clone().ensureType();
            if ensured !is error {
                valueSet = ensured;
            } else if system !is () {
                if self.readValueSetByUrl(system, 'version) is ValueSet {
                    valueSet = check self.readValueSetByUrl(system, 'version);
                } else {
                    return createFHIRError(string `Cannot find a ValueSet for the provided system URL: ${system}`,
                    ERROR,
                    INVALID,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
                }

            } else {
                return createFHIRError(
            "Can not find a ValueSet",
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "Either ValueSet record or system URL should be provided as input",
            errorType = PROCESSING_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST);
            }

            if codeValue is code && codeValue.trim() !is "" {
                CodeConceptDetails? result = self.findConceptInValueSet(valueSet, codeValue);
                if result is CodeConceptDetails {
                    return result.concept.clone();
                } else {
                    return createFHIRError(
                    string `Can not find any valid concepts for the code: ${codeValue.toBalString()} in ValueSet: ${valueSet.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
                }
            } else if codeValue is Coding {

                CodeConceptDetails? result = self.findConceptInValueSetFromCoding(valueSet, codeValue.clone());

                if result is CodeConceptDetails {
                    return result.concept.clone();
                } else {
                    return createFHIRError(
                    string `Can not find any valid concepts for the coding with code: ${codeValue.code.toBalString()} in ValueSet: ${valueSet.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
                }
            } else if codeValue is CodeableConcept {
                Coding[]? codings = codeValue.coding.clone();

                if codings != () {
                    foreach var c in codings {
                        CodeConceptDetails? result = self.findConceptInValueSetFromCoding(valueSet.cloneReadOnly(), c);

                        if result is CodeConceptDetails {
                            codeConceptDetailsList.push(result.concept);
                        }
                    }

                    if codeConceptDetailsList.length() < 0 {
                        return createFHIRError(
                    string `Can not find any valid concepts for the CodeableConcept: ${codeValue.toBalString()} in CodeSystem: ${valueSet.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
                    }
                    if codeConceptDetailsList.length() == 1 {
                        return codeConceptDetailsList[0].clone();
                    } else {
                        return codeConceptDetailsList.clone();
                    }
                } else {
                    return createFHIRError(
                    "Can not find any valid Codings in the provide CodeableConcept data",
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
                }
            } else {
                return createFHIRError(
            "Either code or Coding or CodeableConcept should be provided as input",
            ERROR,
            PROCESSING_NOT_FOUND,
            errorType = PROCESSING_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
            }
        }
    }

    # Extract all the concepts from a given valueSet based on the given filter parameters.
    # This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#expand.
    #
    # + searchParameters - List of search parameters to filter concepts, should be passed as map of string arrays  
    # + vs - ValueSet record to be processed. If system parameter is not supplied, this value shoud be mandatory, 
    # else this is an optional field  
    # + system - System URL of the ValueSet to be processed, if system ValueSet(vs) is not supplied then  
    # this value shoud be mandatory
    # + return - List of concepts is successful,  return FHIRError if fails
    public isolated function valueSetExpansion(map<RequestSearchParameter[]> searchParameters, ValueSet? vs = (), uri? system = ())
                                                                returns ValueSet|FHIRError {
        lock {
            int count = TERMINOLOGY_SEARCH_DEFAULT_COUNT;
            if searchParameters.hasKey("_count") {
                int|error y = langint:fromString(searchParameters.get("_count")[0].value);
                if y is int {
                    count = y;
                }
                _ = searchParameters.clone().remove("_count");
            }

            int offset = 0;
            if searchParameters.hasKey("_offset") {
                int|error y = langint:fromString(searchParameters.get("_offset")[0].value);
                if y is int {
                    offset = y;
                }
                _ = searchParameters.clone().remove("_offset");
            }

            if count > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                return createFHIRError(
                string `Requested size of the response: ${count.toBalString()} is too large`,
                ERROR,
                PROCESSING_NOT_SUPPORTED,
                diagnostic = "Allowed maximum size of output is: 50; therefore, reduce the value of size parameter accordingly",
                errorType = PROCESSING_ERROR,
                httpStatusCode = http:STATUS_PAYLOAD_TOO_LARGE
                );
            }

            // Create and initialize a ValueSet record with the mandatory fields
            ValueSet valueSet = {status: "unknown"};

            ValueSet|error ensured = vs.clone().ensureType();
            if ensured !is error {
                valueSet = ensured;
            } else if system is string {
                map<RequestSearchParameter[]> clone = searchParameters.clone();
                if clone.hasKey("filter") {
                    _ = clone.remove("filter");
                }

                if !clone.hasKey("url") {
                    RequestSearchParameter r = {name: "url", value: system, typedValue: {modifier: MODIFIER_EXACT}, 'type: URI};
                    clone["url"] = [r];
                }

                ValueSet[] v = check self.searchValueSets(clone);
                if v.length() > 0 {
                    valueSet = v[0];
                } else {
                    return createFHIRError(
                        string `Can not find a ValueSet for system: ${system.toString()}`,
                        ERROR,
                        INVALID_REQUIRED,
                        errorType = PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_BAD_REQUEST);
                }
            }
            else {
                return createFHIRError(
                    "Can not find a ValueSet",
                    ERROR,
                    INVALID_REQUIRED,
                    diagnostic = "Either ValueSet record or system URL should be provided as input",
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
            }

            // Validate the requested search parameters in the allowed list
            foreach var param in searchParameters.clone().keys() {
                if !VALUESETS_EXPANSION_PARAMS.hasKey(param) {
                    return createFHIRError(
                        string `This search parameter is not implemented yet: ${param}`,
                        ERROR,
                        PROCESSING_NOT_SUPPORTED,
                        diagnostic = string `Allowed search parameters: ${VALUESETS_SEARCH_PARAMS.keys().toBalString()}`,
                        errorType = VALIDATION_ERROR);
                }
            }

            ValueSetExpansionDetails? details = self.getAllConceptInValueSet(valueSet);

            if details is ValueSetExpansionDetails {
                CodeSystemConcept[]|ValueSetComposeIncludeConcept[] concepts = details.concepts;

                if concepts is ValueSetComposeIncludeConcept[] {
                    if searchParameters.hasKey("filter") {
                        string filter = searchParameters.get("filter")[0].value;
                        ValueSetComposeIncludeConcept[] result = from ValueSetComposeIncludeConcept entry in concepts
                            where entry["display"] is string && regex:matches((<string>entry["display"]).toUpperAscii(),
                        string `.*${filter.toUpperAscii()}.*`)
                            select entry;
                        concepts = result;
                    }

                    int totalCount = concepts.length();

                    if totalCount > offset + count {
                        concepts = concepts.slice(offset, offset + count);
                    } else if totalCount >= offset {
                        concepts = concepts.slice(offset);
                    } else {
                        CodeSystemConcept[] temp = [];
                        concepts = temp;
                    }

                    ValueSetExpansion expansion = self.createExpandedValueSet(valueSet, concepts);
                    expansion.offset = offset;
                    expansion.total = totalCount;
                    valueSet.expansion = expansion.clone();

                } else {
                    if searchParameters.hasKey("filter") {
                        string filter = searchParameters.get("filter")[0].value;
                        CodeSystemConcept[] result = from CodeSystemConcept entry in concepts
                            where entry["display"] is string
                            && regex:matches((<string>entry["display"]).toUpperAscii(), string `.*${filter.toUpperAscii()}.*`)
                        || entry["definition"] is string
                            && regex:matches((<string>entry["definition"]).toUpperAscii(), string `.*${filter.toUpperAscii()}.*`)
                            select entry;
                        concepts = result;
                    }

                    int totalCount = concepts.length();

                    if totalCount > offset + count {
                        concepts = concepts.slice(offset, offset + count);
                    } else if totalCount >= offset {
                        concepts = concepts.slice(offset);
                    } else {
                        CodeSystemConcept[] temp = [];
                        concepts = temp;
                    }

                    ValueSetExpansion expansion = self.createExpandedValueSet(valueSet, concepts);
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
    public isolated function subsumes(code|Coding conceptA, code|Coding conceptB, CodeSystem? cs = (), uri? system = (),
            string? 'version = ()) returns Parameters|FHIRError {
        lock {
            // Create and initialize a CodeSystem record with the mandatory fields
            CodeSystem codeSystem = {content: "example", status: "unknown"};
            if cs is () && system != () && self.readCodeSystemByUrl(system, 'version) is CodeSystem {
                codeSystem = check self.readCodeSystemByUrl(system, 'version);
            } else if cs != () {
                codeSystem = cs.clone();
            } else {
                return createFHIRError(
            "Can not find a CodeSystem",
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "CodeSystem record or system URL should be provided as input",
            errorType = PROCESSING_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST);
            }

            CodeSystemConcept? conceptDetailsA = self.retrieveCodeSystemConcept(codeSystem, conceptA.clone());
            CodeSystemConcept? conceptDetailsB = self.retrieveCodeSystemConcept(codeSystem, conceptB.clone());

            if conceptDetailsA != () && conceptDetailsB != () {
                if conceptDetailsA.code == conceptDetailsB.code && conceptDetailsA.display == conceptDetailsB.display {
                    return {'parameter: [{name: "outcome", valueCode: "equivalent"}]};
                } else {
                    return {'parameter: [{name: "outcome", valueCode: "not-subsumed"}]};
                }
            } else if conceptDetailsA is () {
                return createFHIRError(
                    string `Code/ Coding: ${conceptA.toBalString()} is not included in the provided CodeSystem`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
            } else {
                return createFHIRError(
                    string `Code/ Coding: ${conceptB.toBalString()} is not included in the provided CodeSystem`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }
    }

    # Find a CodeSystem based on the provided URL and version.
    #
    # + url - URL of the CodeSystem to be retrieved
    # + version - Version of the CodeSystem to be retrieved and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Return CodeSystem data if the request is successful, return FHIR error if no data found for the provided URL
    public isolated function readCodeSystemByUrl(uri url, string? 'version = ()) returns CodeSystem|FHIRError {
        lock {
            boolean isIdExistInRegistry = false;
            if 'version is string {
                foreach var item in self.codeSystems.keys() {
                    if regex:matches(item, string `${url}\|${'version}$`) && self.codeSystems[item] is CodeSystem {
                        return <CodeSystem>self.codeSystems[item].clone();
                    } else if regex:matches(item, string `${url}\|.*`) {
                        isIdExistInRegistry = true;
                    }
                }

                if isIdExistInRegistry {
                    return createFHIRError(
                    string `Unknown version: '${'version}'`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    diagnostic = string `There is CodeSystem in the registry with Id: '${url}' but can not find version: '${'version}' of it`,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
                }
            } else {
                CodeSystem codeSystem = {content: "example", status: "unknown"};
                string latestVersion = "0.0.0";
                foreach var item in self.codeSystems.keys() {
                    if regex:matches(item, string `${url}\|.*`)
                && self.codeSystems[item] is CodeSystem
                && (<CodeSystem>self.codeSystems[item]).'version > latestVersion {
                        codeSystem = <CodeSystem>self.codeSystems[item];
                        latestVersion = codeSystem.'version ?: "0.0.0";
                        isIdExistInRegistry = true;
                    }
                }

                if isIdExistInRegistry {
                    return codeSystem.clone();
                } else {
                    return createFHIRError(
                    string `Unknown CodeSystem: '${url.toBalString()}'`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
                }
            }
            return createFHIRError(
                    string `Unknown CodeSystem: '${url.toBalString()}'`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
        }

    }

    # Find a ValueSet for a provided URL and version.
    #
    # + url - URL of the Value Set to be retrieved
    # + version - Version of the ValueSet to be retrieved and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Return ValueSet data if the request is successful, return FHIR error if no data found for the provided URL
    public isolated function readValueSetByUrl(uri url, string? 'version = ()) returns ValueSet|FHIRError {
        lock {
            boolean isIdExistInRegistry = false;
            if 'version is string {
                foreach var item in self.valueSets.keys() {
                    if regex:matches(item, string `${url}\|${'version}$`) && self.valueSets[item] is ValueSet {
                        return <ValueSet>self.valueSets[item].clone();
                    } else if regex:matches(item, string `${url}\|.*`) {
                        isIdExistInRegistry = true;
                    }
                }

                if isIdExistInRegistry {
                    return createFHIRError(
                    string `Unknown version: '${'version}'`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    diagnostic = string `There is ValueSet in the registry with Id: '${url}' but can not find version: '${'version}' of it`,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
                }
            } else {
                ValueSet valueSet = {status: "unknown"};
                string latestVersion = "0.0.0";
                foreach var item in self.valueSets.keys() {
                    if regex:matches(item, string `${url}\|.*`)
                        && self.valueSets[item] is ValueSet
                        && (<ValueSet>self.valueSets[item]).'version > latestVersion {

                        valueSet = <ValueSet>self.valueSets[item];
                        latestVersion = valueSet.'version ?: "0.0.0";
                        isIdExistInRegistry = true;
                    }
                }

                if !isIdExistInRegistry {
                    return createFHIRError(
                    string `Unknown ValueSet: '${url}'`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
                } else {
                    return valueSet.clone();
                }
            }

            return createFHIRError(
                    string `Unknown ValueSet: '${url.toBalString()}'`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
        }
    }

    # Create CodeableConcept data type for given code in a given system.
    #
    # + system - system uri of the code system or value set  
    # + code - code interested  
    # + codeSystemFinder - (optional) custom code system function (utility will used this function to find code  
    # system in a external source system)  
    # + version - Version of the CodeSystem and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Created CodeableConcept record or FHIRError if not found
    public isolated function createCodeableConcept(uri system, code code, string? 'version = (),
            CodeSystemFinder? codeSystemFinder = ()) returns CodeableConcept|FHIRError {
        lock {
            CodeConceptDetails? conceptResult = check self.findConcept(system, code, codeSystemFinder, 'version = 'version);
            if conceptResult != () {
                return self.conceptToCodeableConcept(conceptResult.concept.clone(), conceptResult.url.clone());
            }
            return createInternalFHIRError(
            string `Code : ${code} not found in system : ${system}`,
            ERROR,
            PROCESSING_NOT_FOUND
            );
        }
    }

    # Create Coding data type for given code in a given system.
    #
    # + system - System uri of the CodeSystem or valueSet  
    # + code - code interested  
    # + codeSystemFinder - (optional) custom code system function (utility will used this function to find code  
    # system in a external source system)  
    # + version - Version of the CodeSystem and it should be provided with system parameter,
    # if this version parameter is not supplied then the latest version of CodeSystem will picked up.
    # + return - Created CodeableConcept record or FHIRError if not found
    public isolated function createCoding(uri system, code code, string? 'version = (),
            CodeSystemFinder? codeSystemFinder = ()) returns Coding|FHIRError {
        lock {
            CodeConceptDetails? conceptResult = check self.findConcept(system, code, codeSystemFinder, 'version = 'version);
            if conceptResult != () {
                return self.conceptToCoding(conceptResult.concept.clone(), conceptResult.url.clone());
            }

            return createInternalFHIRError(
            string `Code : ${code} not found in system : ${system}`,
            ERROR,
            PROCESSING_NOT_FOUND);
        }
    }

    // Function to find concept in CodeSystems or ValueSets by passing code data type parameter.
    private isolated function findConcept(uri system, code code, CodeSystemFinder? codeSystemFinder = (), string? 'version = ())
                                                                                returns (CodeConceptDetails|FHIRError)? {
        lock {
            if codeSystemFinder != () {
                (CodeSystem|ValueSet) & readonly result = check codeSystemFinder(system, code).cloneReadOnly();
                if result is CodeSystem {
                    return self.findConceptInCodeSystem(result, code);
                } else {
                    return self.findConceptInValueSet(result, code);
                }
            } else if self.readValueSetByUrl(system, 'version) is ValueSet {
                return self.findConceptInValueSet(check self.readValueSetByUrl(system, 'version), code);
            } else if self.readCodeSystemByUrl(system, 'version) is CodeSystem {
                return self.findConceptInCodeSystem(check self.readCodeSystemByUrl(system, 'version), code);
            } else {
                return createInternalFHIRError(
                string `Unknown ValueSet or CodeSystem : ${system}`,
                ERROR,
                PROCESSING_NOT_FOUND
                );
            }
        }
    }

    // Function to find concept in a CodeSystem by passing code data type parameter. 
    private isolated function findConceptInCodeSystem(CodeSystem codeSystem, code code) returns CodeConceptDetails? {
        lock {
            CodeSystemConcept[]? concepts = codeSystem.concept;
            uri? url = codeSystem.url;
            if concepts != () && url != () {
                foreach CodeSystemConcept concept in concepts {
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
    private isolated function findConceptInCodeSystemFromCoding(CodeSystem codeSystem, Coding coding) returns CodeConceptDetails? {
        lock {
            code? code = coding.code;

            if code != () {
                return self.findConceptInCodeSystem(codeSystem.clone(), code.clone()).clone();
            } else {
                string msg = "No valid code found in the Coding";
                log:printDebug(createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND).toBalString());
            }
            return;
        }
    }

    // Function to get all concepts in a CodeSystem.
    private isolated function getAllConceptInCodeSystem(CodeSystem codeSystem) returns ValueSetExpansionDetails? {
        lock {
            CodeSystemConcept[]? concepts = codeSystem.concept;
            uri? url = codeSystem.url;
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

    // Function to find concept in a ValueSet by passing code data type parameter. 
    private isolated function findConceptInValueSet(ValueSet valueSet, code code) returns (CodeConceptDetails)? {
        lock {
            ValueSetCompose? composeBBE = valueSet.clone().compose;
            if composeBBE != () {
                foreach ValueSetComposeInclude includeBBE in composeBBE.include {
                    uri? systemValue = includeBBE.system;

                    if systemValue != () {
                        ValueSetComposeIncludeConcept[]? includeConcepts = includeBBE.concept;
                        if includeConcepts != () {
                            foreach ValueSetComposeIncludeConcept includeConcept in includeConcepts {
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
                            CodeSystem|FHIRError codeSystemByUrl = self.readCodeSystemByUrl(systemValue);
                            if codeSystemByUrl is CodeSystem {
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
                        canonical[]? valueSetResult = includeBBE.valueSet;
                        if valueSetResult != () {
                            //+ Rule: A value set include/exclude SHALL have a value set or a system
                            foreach canonical valueSetEntry in valueSetResult {
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

    // Function to find concepts in a ValueSet by passing Coding data type parameter.
    private isolated function findConceptInValueSetFromCoding(ValueSet valueSet, Coding coding) returns CodeConceptDetails? {
        lock {
            code? code = coding.code;

            if code != () {
                return self.findConceptInValueSet(valueSet.clone(), code.clone()).clone();
            } else {
                string msg = "No valid code found in the Coding";
                log:printDebug(createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND).toBalString());
            }
            return;
        }
    }

    // Function to get all concept in a ValueSet. 
    private isolated function getAllConceptInValueSet(ValueSet valueSet) returns (ValueSetExpansionDetails)? {
        lock {
            ValueSetCompose? composeBBE = valueSet.clone().compose;
            if composeBBE != () {
                foreach ValueSetComposeInclude includeBBE in composeBBE.include {
                    uri? systemValue = includeBBE.system;

                    if systemValue != () {
                        ValueSetComposeIncludeConcept[]? includeConcepts = includeBBE.concept;
                        if includeConcepts != () {
                            ValueSetExpansionDetails concepts = {
                                url: systemValue,
                                concepts: includeConcepts
                            };
                            return concepts.clone();
                        } else {
                            // Find CodeSystem
                            CodeSystem|FHIRError codeSystemByUrl = self.readCodeSystemByUrl(systemValue);
                            if codeSystemByUrl is CodeSystem {
                                ValueSetExpansionDetails? result = self.getAllConceptInCodeSystem(codeSystemByUrl);
                                if result != () {
                                    return result.clone();
                                }
                            } else {
                                log:printDebug(codeSystemByUrl.toBalString());
                            }
                        }
                    } else {
                        // check the contents included in this value set
                        canonical[]? valueSetResult = includeBBE.valueSet;
                        if valueSetResult != () {
                            //+ Rule: A value set include/exclude SHALL have a value set or a system
                            foreach canonical valueSetEntry in valueSetResult {
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
            CodeSystemConcept|ValueSetComposeIncludeConcept concept, uri system) returns CodeableConcept {
        lock {
            Coding codingValue = {
                code: concept.code,
                system: system
            };
            string? displayValue = concept.display;
            if displayValue != () {
                codingValue.display = displayValue;
            }

            CodeableConcept cConcept = {
                coding: [
                    codingValue
                ]
            };

            if concept is CodeSystemConcept {
                string? defValue = concept.definition;
                if defValue != () {
                    cConcept.text = defValue;
                }
            }
            return cConcept;
        }
    }

    private isolated function conceptToCoding(CodeSystemConcept|ValueSetComposeIncludeConcept concept, uri system) returns Coding {
        lock {
            Coding codingValue = {
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

    private isolated function retrieveCodeSystemConcept(CodeSystem codeSystem, code|Coding concept) returns CodeSystemConcept? {
        lock {
            if concept is code {
                CodeConceptDetails? conceptDetails = self.findConceptInCodeSystem(
                codeSystem.clone(), concept.clone());
                if conceptDetails is CodeConceptDetails {
                    CodeSystemConcept|ValueSetComposeIncludeConcept codeConcept = conceptDetails.concept;
                    if codeConcept is CodeSystemConcept {
                        return codeConcept.clone();
                    }
                }
            } else {
                CodeConceptDetails? conceptDetails = self.findConceptInCodeSystemFromCoding(
                codeSystem.clone(), concept.clone());

                if conceptDetails is CodeConceptDetails {
                    CodeSystemConcept|ValueSetComposeIncludeConcept temp = conceptDetails.concept;
                    if temp is CodeSystemConcept {
                        return temp.clone();
                    }
                }
            }
            return;
        }
    }

    private isolated function createExpandedValueSet(ValueSet vs, CodeSystemConcept[]|ValueSetComposeIncludeConcept[] concepts)
                                                                                                    returns ValueSetExpansion {
        lock {
            ValueSetExpansionContains[] contains = [];
            if concepts is ValueSetComposeIncludeConcept[] {
                foreach ValueSetComposeIncludeConcept concept in concepts {
                    ValueSetExpansionContains c = {code: concept.code, display: concept.display, id: concept.id};
                    contains.push(c);
                }
            } else {
                foreach CodeSystemConcept concept in concepts {
                    ValueSetExpansionContains c = {code: concept.code, display: concept.display, id: concept.id};
                    contains.push(c);
                }
            }

            ValueSetExpansion expansion = {timestamp: time:utcToString(time:utcNow()), contains: contains};
            return expansion;
        }
    }
}
