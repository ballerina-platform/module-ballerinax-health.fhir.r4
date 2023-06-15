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

import ballerina/regex;
import ballerina/log;
import ballerina/http;
import ballerina/lang.'int as langint;

//It is a custom record to hold system URLs and a related concept.  
type CodeConceptDetails record {
    //System URL of a CodeSystem or ValueSet.
    uri url;
    CodeSystemConcept|ValueSetComposeIncludeConcept concept;
};

# The function definition for code system finder implementations.
public type CodeSystemFinder isolated function (uri system, code code) returns CodeSystem|ValueSet|FHIRError;

# A processor to process terminology data and create relevant data elements.
public class TerminologyProcessor {

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
    public function initTerminology(Terminology terminology) {
        self.codeSystems = terminology.codeSystems;
        self.valueSets = terminology.valueSets;
    }

    # Add list of new CodeSystems to the existing data
    #
    # + codeSystems - List CodeSystems
    # + return - Return List of FHIRErrors
    public function addCodeSystems(CodeSystem[] codeSystems) returns FHIRError[]? {
        FHIRError[] errors = [];
        foreach CodeSystem codeSystem in codeSystems {
            FHIRError? result = self.addCodeSystem(codeSystem);

            if result is FHIRError {
                errors.push(result);
            }
        }

        return errors;
    }

    # Add list of new ValueSets to the existing data
    #
    # + valueSets - List ValueSets
    # + return - Return List of FHIRErrors
    public function addValueSets(ValueSet[] valueSets) returns FHIRError[]? {
        FHIRError[] errors = [];
        foreach ValueSet valueSet in valueSets {
            FHIRError? result = self.addValueSet(valueSet);

            if result is FHIRError {
                errors.push(result);
            }
        }

        return errors;
    }

    # Add a new CodeSystem to the existing data
    #
    # + codeSystem - ValueSet to be added
    # + return - Return FHIRError
    public function addCodeSystem(CodeSystem codeSystem) returns FHIRError? {

        if codeSystem.url == () {
            return createFHIRError(string `Can not find the URL of the CodeSystem with name: ${codeSystem.name.toBalString()}`,
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "Add a proper URL for the resource: http://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.url",
            errorType = VALIDATION_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
        }

        string url = <string>codeSystem.url;
        if self.codeSystems.hasKey(url) {
            return createFHIRError("Duplicate entry",
            ERROR,
            PROCESSING_DUPLICATE,
            diagnostic = "Already there is a CodeSystem exists in the registry with the URL: " + url,
            errorType = PROCESSING_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
        }

        FHIRValidationError? validateResult = validate(codeSystem, CodeSystem);

        if validateResult is FHIRValidationError {
            return createFHIRError("Validation failed",
            ERROR,
            INVALID,
            diagnostic = "Check whether the data conforms to the specification: http://hl7.org/fhir/R4/codesystem-definitions.html",
            errorType = VALIDATION_ERROR,
            cause = validateResult,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
        }

        self.codeSystems[<string>codeSystem.url] = codeSystem;
    }

    # Add a new ValueSet to the existing data
    #
    # + valueSet - ValueSet to be added
    # + return - Return FHIRError
    public function addValueSet(ValueSet valueSet) returns FHIRError? {

        if valueSet.url == () {
            return createFHIRError(string `Can not find the URL of the ValueSet with name: ${valueSet.name.toBalString()}`,
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "Add a proper URL for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.url",
            errorType = VALIDATION_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
        }

        string url = <string>valueSet.url;
        if self.valueSets.hasKey(url) {
            return createFHIRError("Duplicate entry",
            ERROR,
            PROCESSING_DUPLICATE,
            diagnostic = "Already there is a ValueSet exists in the registry with the URL: " + url,
            errorType = VALIDATION_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
        }

        FHIRValidationError? validateResult = validate(valueSet, ValueSet);

        if validateResult is FHIRValidationError {
            return createFHIRError("Validation failed",
            ERROR,
            INVALID,
            diagnostic = "Check whether the data conforms to the specification: http://hl7.org/fhir/R4/valueset-definitions.html",
            errorType = VALIDATION_ERROR,
            cause = validateResult,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
        }

        self.valueSets[url] = valueSet.cloneReadOnly();
    }

    # Find a Code System based on the provided Id.
    #
    # + id - Id of the CodeSystem
    # + return - Return CodeSystem data is the request is successful, return FHIR error if no data found for the provided Id
    public isolated function getCodeSystemById(string id) returns CodeSystem|FHIRError {
        foreach var item in self.codeSystems.keys() {
            if regex:matches(item, string `.*/${id}$`) {
                CodeSystem? codeSystem = self.codeSystems[item];
                string msg = string `Unknown CodeSystem : ${id}`;
                return codeSystem ?: createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
            }
        }

        string msg = string `Unknown CodeSystem : ${id}`;
        return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
    }

    # Find a ValueSet for a provided Id.
    #
    # + id - Id of the Value Set
    # + return - Return ValueSet data is the request is successful, return FHIR error if no data found for the provided Id
    public isolated function getValueSetById(string id) returns ValueSet|FHIRError {
        foreach var item in self.valueSets.keys() {
            if regex:matches(item, string `.*/${id}$`) {
                ValueSet? valueSet = self.valueSets[item];
                string msg = string `Unknown ValueSet : ${id}`;
                return valueSet ?: createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND, httpStatusCode = http:STATUS_NOT_FOUND);
            }
        }

        string msg = string `Unknown ValueSet : ${id}`;
        return createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    # Search for Code systems based on the provided search parameters.
    # Allowed search parameters are name, title, url, version, status and so on.
    #
    # + searchParameters - List of search parameters, should be passed as map of string arrays
    # + return - Return array of CodeSystem data is success, return FHIR error if the request contains unsupported search parameters
    public isolated function searchCodeSystems(map<string[]> searchParameters) returns CodeSystem[]|FHIRError {

        int count = TERMINOLOGY_SEARCH_DEFAULT_COUNT;
        if searchParameters.hasKey("_count") {
            int|error y = langint:fromString(searchParameters.get("_count")[0]);
            if y is int {
                count = y;
            }
            _ = searchParameters.remove("_count");
        }

        int offset = 0;
        if searchParameters.hasKey("_offset") {
            int|error y = langint:fromString(searchParameters.get("_offset")[0]);
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
                diagnostic = "Allowed maximum size of output is: 50, so reduce the value of size parameter accordingly",
                errorType = PROCESSING_ERROR,
                httpStatusCode = http:STATUS_PAYLOAD_TOO_LARGE
                );
        }

        // Validate whether the requested search parameters in the allowed list
        foreach var param in searchParameters.keys() {
            if !CODESYSTEMS_SEARCH_PARAMS.hasKey(param) {
                return createFHIRError(string `This search parameter is not implemented yet: ${param}`,
                ERROR,
                PROCESSING_NOT_SUPPORTED,
                diagnostic = string `Allowed search parameters: ${CODESYSTEMS_SEARCH_PARAMS.keys().toBalString()}`,
                errorType = VALIDATION_ERROR);
            }
        }

        CodeSystem[] codeSystemArray = self.codeSystems.toArray();

        foreach var searchParam in searchParameters.keys() {
            string[] searchParamValues = searchParameters[searchParam] ?: [];

            CodeSystem[] filteredList = [];
            if searchParamValues.length() != 0 {
                foreach var queriedValue in searchParamValues {
                    CodeSystem[] result = from CodeSystem entry in codeSystemArray
                        where entry[searchParam] == queriedValue
                        select entry;
                    filteredList.push(...result);
                }
                codeSystemArray = filteredList;

                if codeSystemArray.length() > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                    return createFHIRError(
                        "The response size is too large",
                        ERROR,
                        PROCESSING_TOO_COSTLY,
                        diagnostic = "The response size is too large, so search with more specific parameter values",
                        errorType = PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
                        );
                } else if codeSystemArray.length() > offset + count - 1 {
                    return codeSystemArray.slice(0, <int>(count - 1));
                }
            }
        }

        return codeSystemArray.slice(<int>offset);
    }

    # Search for Value Sets for the provided search parameters.
    # Allowed search parameters: are name, title, url, version, status and son on
    #
    # + searchParameters - List of search parameters, should be passed as map of string arrays  
    # + return - Return array of ValueSet data is success, return FHIR error if the request contains unsupported search parameters
    public isolated function searchValueSets(map<string[]> searchParameters) returns FHIRError|ValueSet[] {

        int count = TERMINOLOGY_SEARCH_DEFAULT_COUNT;
        if searchParameters.hasKey("_count") {
            int|error y = langint:fromString(searchParameters.get("_count")[0]);
            if y is int {
                count = y;
            }
            _ = searchParameters.remove("_count");
        }

        int offset = 0;
        if searchParameters.hasKey("_offset") {
            int|error y = langint:fromString(searchParameters.get("_offset")[0]);
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
                diagnostic = "Allowed maximum size of output is: 50, so reduce the value of size parameter accordingly",
                errorType = PROCESSING_ERROR,
                httpStatusCode = http:STATUS_PAYLOAD_TOO_LARGE
                );
        }

        // Validate the requested search parameters in the allowed list
        foreach var param in searchParameters.keys() {
            if !VALUESETS_SEARCH_PARAMS.hasKey(param) {
                return createFHIRError(string `This search parameter is not implemented yet: ${param}`,
                ERROR,
                PROCESSING_NOT_SUPPORTED,
                diagnostic = string `Allowed search parameters: ${VALUESETS_SEARCH_PARAMS.keys().toBalString()}`,
                errorType = VALIDATION_ERROR);
            }
        }

        ValueSet[] valueSetArray = self.valueSets.toArray();

        foreach var searchParam in searchParameters.keys() {
            string[] searchParamValues = searchParameters[searchParam] ?: [];

            ValueSet[] filteredList = [];
            if searchParamValues.length() != 0 {
                foreach var queriedValue in searchParamValues {
                    ValueSet[] result = from ValueSet entry in valueSetArray
                        where entry[searchParam] == queriedValue
                        select entry;
                    filteredList.push(...result);
                }
                valueSetArray = filteredList;

                if valueSetArray.length() > TERMINOLOGY_SEARCH_MAXIMUM_COUNT {
                    return createFHIRError(
                        "The response size is too large",
                        ERROR,
                        PROCESSING_TOO_COSTLY,
                        diagnostic = "The response size is too large, so search with more specific parameter values",
                        errorType = PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
                        );
                } else if valueSetArray.length() > offset + count - 1 {
                    return valueSetArray.slice(0, <int>(count - 1));
                }
            }
        }
        return valueSetArray.slice(<int>offset);
    }

    # Extract the respective concepts from a given CodeSystem based on the give code or Coding or CodeableConcept data
    # This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#lookup.
    #
    # + codeValue - Code or Coding or CodeableConcept data type value to process with the CodeSystem
    # + cs - CodeSystem record to be processed, this is an optional field, 
    # if system parameter is not supplied then this value shoud be mandatory 
    # + system - System URL of the CodeSystem to be processed, if system CodeSystem(cs) is not supplied then 
    # this value shoud be mandatory 
    # + return - Return list of Concepts if processing is successful, FHIRError if fails
    public isolated function codeSystemLookUp(code|Coding|CodeableConcept codeValue, CodeSystem? cs = (), uri? system = ())
                                                                    returns CodeSystemConcept[]|CodeSystemConcept|FHIRError {

        // Create and initialize a CodeSystem record with the mandatory fields
        CodeSystem codeSystem = {content: "example", status: "unknown"};
        CodeSystemConcept[] codeConceptDetailsList = [];

        CodeSystem|error ensured = cs.ensureType();
        if !(ensured is error) {
            codeSystem = ensured;
        } else if !(system is ()) {
            codeSystem = self.codeSystems.get(system);
        } else {
            string msg = "Can not find a CodeSystem";
            return createFHIRError(msg,
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "CodeSystem record or system URL should be provided as input",
            errorType = PROCESSING_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }

        if system != () && codeValue is code {
            CodeConceptDetails? result = self.findConceptInCodeSystem(codeSystem, codeValue);

            if result is CodeConceptDetails {
                return result.concept;
            } else {
                return createFHIRError(
                    string `Can not find any valid concepts for the code: ${codeValue.toBalString()} 
                    in CodeSystem: ${codeSystem.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
            }
        } else if codeValue is Coding {
            CodeConceptDetails? result = self.findConceptInCodeSystemFromCoding(codeSystem, codeValue);

            if result is CodeConceptDetails {
                return result.concept;
            } else {
                return createFHIRError(
                    string `Can not find any valid concepts for the coding with code: ${codeValue.code.toBalString()} 
                    in CodeSystem: ${codeSystem.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
            }
        } else if codeValue is CodeableConcept {
            Coding[]? codings = codeValue.coding;

            if codings != () {
                foreach var c in codings {
                    CodeConceptDetails? result = self.findConceptInCodeSystemFromCoding(codeSystem.cloneReadOnly(), c);
                    if result is CodeConceptDetails {
                        codeConceptDetailsList.push(result.concept);
                    }
                }

                if codeConceptDetailsList.length() < 0 {
                    return createFHIRError(
                    string `Can not find any valid concepts for the CodeableConcept: ${codeValue.toBalString()} 
                    in CodeSystem: ${codeSystem.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
                }
                return codeConceptDetailsList;

            } else {
                return createFHIRError(
                    "Can not find any valid Codings in the provide CodeableConcept data",
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }
        string msg = "Either code or Coding or CodeableConcept should be provided as input";
        return createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND, httpStatusCode = http:STATUS_BAD_REQUEST);

    }

    # Extract the respective concepts from a given ValueSet based on the give code or Coding or CodeableConcept data
    # This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#validation.
    #
    # + codeValue - Code or Coding or CodeableConcept data type value to process with the ValueSet 
    # + vs - ValueSet record to be processed, this is an optional field,
    # if system parameter is not supplied then this value shoud be mandatory
    # + system - System URL of the ValueSet to be processed, if system ValueSet(vs) is not supplied then  
    # this value shoud be mandatory
    # + return - Return list of Concepts if processing is successful, FHIRError if fails
    public isolated function valueSetLookUp(code|Coding|CodeableConcept codeValue, ValueSet? vs = (), uri? system = ())
                                                                returns CodeSystemConcept[]|CodeSystemConcept|FHIRError {

        // Create and initialize a ValueSet record with the mandatory fields
        ValueSet valueSet = {status: "unknown"};
        CodeSystemConcept[] codeConceptDetailsList = [];

        ValueSet|error ensured = vs.ensureType();
        if !(ensured is error) {
            valueSet = ensured;
        } else if !(system is ()) {
            valueSet = self.valueSets.get(system);
        } else {
            string msg = "Can not find a ValueSet";
            return createFHIRError(msg,
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "Either ValueSet record or system URL should be provided as input",
            errorType = PROCESSING_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }

        if system != () && codeValue is code {
            CodeConceptDetails? result = self.findConceptInValueSet(valueSet, codeValue);
            if result is CodeConceptDetails {
                return result.concept;
            } else {
                return createFHIRError(
                    string `Can not find any valid concepts for the code: ${codeValue.toBalString()} 
                    in ValueSet: ${valueSet.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
            }
        } else if codeValue is Coding {

            CodeConceptDetails? result = self.findConceptInValueSetFromCoding(valueSet, codeValue);

            if result is CodeConceptDetails {
                return result.concept;
            } else {
                return createFHIRError(
                    string `Can not find any valid concepts for the coding with code: ${codeValue.code.toBalString()} 
                    in ValueSet: ${valueSet.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
            }
        } else if codeValue is CodeableConcept {
            Coding[]? codings = codeValue.coding;

            if codings != () {
                foreach var c in codings {
                    CodeConceptDetails? result = self.findConceptInValueSetFromCoding(valueSet.cloneReadOnly(), c);

                    if result is CodeConceptDetails {
                        codeConceptDetailsList.push(result.concept);
                    }
                }

                if codeConceptDetailsList.length() < 0 {
                    return createFHIRError(
                    string `Can not find any valid concepts for the CodeableConcept: ${codeValue.toBalString()} 
                    in CodeSystem: ${valueSet.id.toBalString()}`,
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_NOT_FOUND);
                }
                return codeConceptDetailsList;
            } else {
                return createFHIRError(
                    "Can not find any valid Codings in the provide CodeableConcept data",
                    ERROR,
                    PROCESSING_NOT_FOUND,
                    errorType = PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        } else {
            string msg = "Either code or Coding or CodeableConcept should be provided as input";
            return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
        }
    }

    # This method with compare concepts
    # This method was implemented based on: http://hl7.org/fhir/R4/terminology-service.html#subsumes
    #
    # + cs - CodeSystem value  
    # + system - System uri of the codeSystem  
    # + conceptA - Concept 1  
    # + conceptB - Concept 2
    # + return - Return Values either equivalent or not-subsumed if processing is successful, FHIRError processing fails
    public isolated function subsumes(code|Coding conceptA, code|Coding conceptB, CodeSystem? cs = (), uri? system = ())
                                                                                                returns string|FHIRError {

        // Create and initialize a CodeSystem record with the mandatory fields
        CodeSystem codeSystem = {content: "example", status: "unknown"};
        if cs is () && system != () {
            codeSystem = self.codeSystems.get(<string>system);
        } else if cs != () {
            codeSystem = cs;
        } else {
            string msg = "Can not find a CodeSystem";
            return createFHIRError(msg,
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "CodeSystem record or system URL should be provided as input",
            errorType = PROCESSING_ERROR,
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }

        CodeSystemConcept? conceptDetailsA = self.retrieveCodeSystemConcept(codeSystem, conceptA);
        CodeSystemConcept? conceptDetailsB = self.retrieveCodeSystemConcept(codeSystem, conceptB);

        if conceptDetailsA != () && conceptDetailsB != () {
            if conceptDetailsA.code == conceptDetailsB.code && conceptDetailsA.display == conceptDetailsB.display {
                return "equivalent";
            } else {
                return "not-subsumed";
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

    # Create CodeableConcept data type for given code in a given system.
    #
    # + system - system uri of the code system or value set
    # + code - code interested
    # + codeSystemFinder - (optional) custom code system function (utility will used this function to find code 
    # system in a external source system)
    # + return - Created CodeableConcept record or FHIRError if not found
    public isolated function createCodeableConcept(uri system, code code, CodeSystemFinder? codeSystemFinder = ())
                                                                                    returns CodeableConcept|FHIRError {
        CodeConceptDetails? conceptResult = check self.findConcept(system, code, codeSystemFinder);
        if conceptResult != () {
            return self.conceptToCodeableConcept(conceptResult.concept, conceptResult.url);
        }
        string msg = string `Code : ${code} not found in system : ${system}`;
        return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
    }

    # Create Coding data type for given code in a given system.
    #
    # + system - System uri of the CodeSystem or valueSet
    # + code - code interested
    # + codeSystemFinder - (optional) custom code system function (utility will used this function to find code 
    # system in a external source system)
    # + return - Created CodeableConcept record or FHIRError if not found
    public isolated function createCoding(uri system, code code, CodeSystemFinder? codeSystemFinder = ())
                                                                                                returns Coding|FHIRError {
        CodeConceptDetails? conceptResult = check self.findConcept(system, code, codeSystemFinder);
        if conceptResult != () {
            return self.conceptToCoding(conceptResult.concept, conceptResult.url);
        }
        string msg = string `Code : ${code} not found in system : ${system}`;
        return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
    }

    // Function to find concept within a CodeSystem or ValueSet by passing code data type parameter.
    private isolated function findConcept(uri system, code code, CodeSystemFinder? codeSystemFinder = ())
                                                                                returns (CodeConceptDetails|FHIRError)? {
        if codeSystemFinder != () {
            (CodeSystem|ValueSet) & readonly result = check codeSystemFinder(system, code).cloneReadOnly();
            if result is CodeSystem {
                return self.findConceptInCodeSystem(result, code);
            } else {
                return self.findConceptInValueSet(result, code);
            }
        } else if self.valueSets.hasKey(system) {
            return self.findConceptInValueSet(self.valueSets.get(system), code);
        } else if self.codeSystems.hasKey(system) {
            return self.findConceptInCodeSystem(self.codeSystems.get(system), code);
        } else {
            string msg = string `Unknown ValueSet or CodeSystem : ${system}`;
            return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
        }
    }

    // Function to find concept within a CodeSystem by passing code data type parameter. 
    private isolated function findConceptInCodeSystem(CodeSystem codeSystem, code code) returns CodeConceptDetails? {
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

    // Function to find concept within a CodeSystem by passing Coding data type parameter.
    private isolated function findConceptInCodeSystemFromCoding(CodeSystem codeSystem, Coding coding) returns CodeConceptDetails? {
        code? code = coding.code;

        if code != () {
            return self.findConceptInCodeSystem(codeSystem, code);
        } else {
            string msg = "No valid code found in the Coding";
            log:printDebug(createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND).toBalString());
        }
        return;
    }

    // Function to find concept within a ValueSet by passing code data type parameter. 
    private isolated function findConceptInValueSet(ValueSet valueSet, code code) returns (CodeConceptDetails)? {
        ValueSetCompose? composeBBE = valueSet.compose;
        if composeBBE != () {
            foreach ValueSetComposeInclude includeBBE in composeBBE.include {
                uri? systemValue = includeBBE.system;

                if systemValue != () {
                    ValueSetComposeIncludeConcept[]? includeConcepts = includeBBE.concept;
                    if includeConcepts != () {
                        foreach ValueSetComposeIncludeConcept includeConcept in includeConcepts {
                            if includeConcept.code == code {
                                // found the code
                                CodeConceptDetails codeConcept = {
                                    url: systemValue,
                                    concept: includeConcept
                                };
                                return codeConcept;
                            }
                        }
                    } else {
                        // Find CodeSystem
                        if self.codeSystems.hasKey(systemValue) {
                            CodeConceptDetails? result = self.findConceptInCodeSystem(self.codeSystems.get(systemValue), code);
                            if result != () {
                                return result;
                            }
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
                                    return concept;
                                }
                            }
                        }

                    }
                }
            }
        }
        return;
    }

    // Function to find concept within a ValueSet by passing Coding data type parameter.
    private isolated function findConceptInValueSetFromCoding(ValueSet valueSet, Coding coding) returns CodeConceptDetails? {
        code? code = coding.code;

        if code != () {
            return self.findConceptInValueSet(valueSet, code);
        } else {
            string msg = "No valid code found in the Coding";
            log:printDebug(createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND).toBalString());
        }
        return;
    }

    private isolated function conceptToCodeableConcept(
            CodeSystemConcept|ValueSetComposeIncludeConcept concept, uri system) returns CodeableConcept {
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

    private isolated function conceptToCoding(CodeSystemConcept|ValueSetComposeIncludeConcept concept, uri system) returns Coding {

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

    private isolated function retrieveCodeSystemConcept(CodeSystem codeSystem, code|Coding concept) returns CodeSystemConcept? {
        if concept is code {
            CodeConceptDetails? conceptDetails = self.findConceptInCodeSystem(
                codeSystem, concept);
            if conceptDetails is CodeConceptDetails {
                CodeSystemConcept|ValueSetComposeIncludeConcept temp = conceptDetails.concept;
                if temp is CodeSystemConcept {
                    return temp;
                }
            }

        } else {
            CodeConceptDetails? conceptDetails = self.findConceptInCodeSystemFromCoding(
                codeSystem, concept);

            if conceptDetails is CodeConceptDetails {
                CodeSystemConcept|ValueSetComposeIncludeConcept temp = conceptDetails.concept;
                if temp is CodeSystemConcept {
                    return temp;
                }
            }
        }
        return;
    }
}
