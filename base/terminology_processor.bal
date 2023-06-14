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

        int sizeofTheResult = 20;
        if searchParameters.get("count").length() > 0 {
            int|error y = langint:fromString(searchParameters.get("count")[0]);
            if y is int {
                sizeofTheResult = y;
            }
        }

        int offset = 0;
        if searchParameters.get("count").length() > 0 {
            int|error y = langint:fromString(searchParameters.get("offset")[0]);
            if y is int {
                offset = y;
            }
        }

        if sizeofTheResult > 50 {
            return createFHIRError(
                string `Requested size of the response: ${sizeofTheResult.toBalString()} is too large`,
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

                if codeSystemArray.length() > 50 {
                    return createFHIRError(
                        "The response size is too large",
                        ERROR,
                        PROCESSING_TOO_COSTLY,
                        diagnostic = "The response size is too large, so search with more specific parameter values",
                        errorType = PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
                        );
                } else if codeSystemArray.length() > offset + sizeofTheResult - 1 {
                    return codeSystemArray.slice(0, <int>(sizeofTheResult - 1));
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

        int sizeofTheResult = 20;
        if searchParameters.get("count").length() > 0 {
            int|error y = langint:fromString(searchParameters.get("count")[0]);
            if y is int {
                sizeofTheResult = y;
            }
        }

        int offset = 0;
        if searchParameters.get("count").length() > 0 {
            int|error y = langint:fromString(searchParameters.get("offset")[0]);
            if y is int {
                offset = y;
            }
        }

        if sizeofTheResult > 50 {
            return createFHIRError(
                string `Requested size of the response: ${sizeofTheResult.toBalString()} is too large`,
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

                if valueSetArray.length() > 50 {
                    return createFHIRError(
                        "The response size is too large",
                        ERROR,
                        PROCESSING_TOO_COSTLY,
                        diagnostic = "The response size is too large, so search with more specific parameter values",
                        errorType = PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
                        );
                } else if valueSetArray.length() > offset + sizeofTheResult - 1 {
                    return valueSetArray.slice(0, <int>(sizeofTheResult - 1));
                }
            }
        }
        return valueSetArray.slice(<int>offset, <int>sizeofTheResult - 1);
    }

    // public isolated function lookUpCodeSystem(uri? system, code? codeValue, Coding? coding) returns (CodeConceptDetails|FHIRError)? {

    //     if system != () && codeValue != () && self.codeSystems.hasKey(system) {
    //         return self.findConceptInCodeSystem(self.codeSystems.get(system), codeValue);
    //     } else if coding != () {
    //         uri? system1 = coding.system;
    //         code? code1 = coding.code;

    //         if system1 != () && code1 != () {
    //             return self.findConceptInCodeSystem(self.codeSystems.get(system1), code1);
    //         } else {
    //             string msg = "No system URL or code value found in the Coding";
    //             return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
    //         }
    //     } else {
    //         string msg = "Either code or Coding should be provided as input";
    //         return createFHIRError(msg, ERROR, INVALID);
    //     }
    // }

    // public isolated function lookUpCodeSystems(CodeSystem codeSystem, code? codeValue, Coding? coding) returns (CodeConceptDetails|FHIRError)? {

    //     if codeValue != () {
    //         return self.findConceptInCodeSystem(codeSystem, codeValue);
    //     } else if coding != () {
    //         code? code1 = coding.code;

    //         if code1 != () {
    //             return self.findConceptInCodeSystem(codeSystem, code1);
    //         } else {
    //             string msg = string `No code value or in-valide code value found in the Coding: ${code1.toBalString()}`;
    //             return createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
    //         }
    //     } else {
    //         string msg = "Either code or Coding should be provided as input";
    //         return createFHIRError(msg, ERROR, INVALID_REQUIRED);
    //     }
    // }

    # Description
    # This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#lookup
    #
    # + cs - CodeSystem record to be processed, this is an optional field, 
    # if system parameter is not supplied then this value shoud be mandatory 
    # + system - System URL of the CodeSystem to be processed, if system CodeSystem(cs) is not supplied then 
    # this value shoud be mandatory 
    # + codeValue - Code data type value to process with the CodeSystem, Optional field
    # + coding - Coding data type value to process with the CodeSystem, Optional field
    # + codeableConcept - CodeableConcept data type value to process with the CodeSystem, Optional field
    # + return - Return list of Concepts is success, FHIRError if fails
    public isolated function codeSystemLookUp(CodeSystem? cs, uri? system, code? codeValue,
            Coding? coding, CodeableConcept? codeableConcept) returns CodeConceptDetails?[]|FHIRError {

        // Create and initialize a CodeSystem record with the mandatory fields
        CodeSystem codeSystem = {content: "example", status: "unknown"};
        CodeConceptDetails?[] codeConceptDetailsList = [];

        CodeSystem|error ensured = cs.ensureType();
        if !(ensured is error) {
            codeSystem = ensured;
        } else if system is string {
            codeSystem = self.codeSystems.get(system);
        }

        if system != () && codeValue != () {
            codeConceptDetailsList.push(self.findConceptInCodeSystem(codeSystem, codeValue));
            return codeConceptDetailsList;
        } else if coding != () {
            codeConceptDetailsList.push(self.findConceptInCodeSystemFromCoding(codeSystem, coding));
            return codeConceptDetailsList;
        } else if codeableConcept != () {
            Coding[]? codings = codeableConcept.coding;

            if codings != () {
                foreach var c in codings {
                    codeConceptDetailsList.push(self.findConceptInCodeSystemFromCoding(
                        codeSystem.cloneReadOnly(), c));
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

    # Description
    # This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#validation
    #
    # + vs - Parameter Description  
    # + system - Parameter Description  
    # + codeValue - Parameter Description  
    # + coding - Parameter Description  
    # + codeableConcept - Parameter Description
    # + return - Return Value Description
    public isolated function valueSetLookUp(ValueSet? vs, uri? system, code? codeValue,
            Coding? coding, CodeableConcept? codeableConcept) returns CodeConceptDetails?[]|FHIRError {

        // Create and initialize a ValueSet record with the mandatory fields
        ValueSet valueSet = {status: "unknown"};
        CodeConceptDetails?[] codeConceptDetailsList = [];

        ValueSet|error ensured = vs.ensureType();
        if !(ensured is error) {
            valueSet = ensured;
        }

        if system != () && codeValue != () {
            if ensured is error {
                valueSet = self.valueSets.get(system);
            }
            codeConceptDetailsList.push(self.findConceptInValueSet(valueSet, codeValue));
            return codeConceptDetailsList;
        } else if coding != () {
            if ensured is error {
                string url = <string>system;
                valueSet = self.valueSets.get(url);
            }
            codeConceptDetailsList.push(check self.findConceptInValueSetFromCoding(valueSet, coding));
            return codeConceptDetailsList;
        } else if codeableConcept != () {
            if ensured is error {
                string url = <string>system;
                valueSet = self.valueSets.get(url);
            }

            Coding[]? codings = codeableConcept.coding;

            if codings != () {
                foreach var c in codings {
                    codeConceptDetailsList.push(check self.findConceptInValueSetFromCoding(
                        valueSet.cloneReadOnly(), c));
                }
                return codeConceptDetailsList;
            } else {
                string msg = "Can not find any valid Codings in the provide CodeableConcept data";
                return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
            }
        } else {
            string msg = "Either code or Coding or CodeableConcept should be provided as input";
            return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
        }
    }

    # Description
    # This method was implemented based on: http://hl7.org/fhir/R4/terminology-service.html#subsumes
    #
    # + cs - Parameter Description  
    # + system - Parameter Description  
    # + conceptA - Parameter Description  
    # + conceptB - Parameter Description
    # + return - Return Value Description
    public isolated function subsumes(CodeSystem? cs, uri? system, code|Coding conceptA,
            code|Coding conceptB) returns string {

        // Create and initialize a CodeSystem record with the mandatory fields
        CodeSystem codeSystem = {content: "example", status: "unknown"};
        if cs is () {
            codeSystem = self.codeSystems.get(<string>system);
        } else {
            codeSystem = cs;
        }

        CodeSystemConcept conceptDetailsA = <CodeSystemConcept>self.retrieveCodeSystemConcept(codeSystem, conceptA);
        CodeSystemConcept conceptDetailsB = <CodeSystemConcept>self.retrieveCodeSystemConcept(codeSystem, conceptB);

        return self.compareConcepts(conceptDetailsA, conceptDetailsB);

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

    private isolated function compareConcepts(CodeSystemConcept conceptA, CodeSystemConcept conceptB) returns string {
        if conceptA.code == conceptB.code && conceptA.display == conceptB.display {
            return "equivalent";
        } else {
            return "not-subsumed";
        }
    }

    # Create CodeableConcept for given code in a given system.
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

    # Create Coding for given code in a given system.
    #
    # + system - system uri of the code system or value set
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

    public isolated function findConcept(uri system, code code, CodeSystemFinder? codeSystemFinder = ())
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

    # Function to find code system concept within a CodeSystem.
    #
    # + codeSystem - Target CodeSystem
    # + code - code searching for
    # + return - Code system concept found in the CodeSystem 
    public isolated function findConceptInCodeSystem(CodeSystem codeSystem, code code) returns CodeConceptDetails? {
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

    public isolated function findConceptInCodeSystemFromCoding(CodeSystem codeSystem, Coding coding) returns CodeConceptDetails? {
        code? code = coding.code;

        if code != () {
            return self.findConceptInCodeSystem(codeSystem, code);
        } else {
            string msg = "No valid code found in the Coding";
            log:printDebug(createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND).toBalString());
        }
    }

    # Function to find code system concept within a ValueSet.
    #
    # + valueSet - Target ValueSet
    # + code - code searching for
    # + return - ValueSet/CodeSystem concept found 
    public isolated function findConceptInValueSet(ValueSet valueSet, code code) returns (CodeConceptDetails)? {
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

    public isolated function findConceptInValueSetFromCoding(ValueSet valueSet, Coding coding) returns CodeConceptDetails?|FHIRError? {
        code? code = coding.code;

        if code != () {
            return self.findConceptInValueSet(valueSet, code);
        } else {
            string msg = "No valid code found in the Coding";
            return createFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
        }
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
}
