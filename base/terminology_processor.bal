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

type CodeConceptDetails record {
    uri url;
    CodeSystemConcept|ValueSetComposeIncludeConcept concept;
};

# Function definition for code system finder implementations
public type CodeSystemFinder isolated function (uri system, code code) returns CodeSystem | ValueSet | FHIRError;

# A processor to process terminology data and create relevant data elements
public class TerminologyProcessor {
    
    private map<CodeSystem> codeSystems = {};
    private map<ValueSet> valueSets = {};

    public function init() {
    }

    // To initialize the Terminology map
    // This will delete existing records if you re-initialized
    public function initTerminology(Terminology terminology) {
        self.codeSystems = terminology.codeSystems;
        self.valueSets = terminology.valueSets;
    }

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

    public function addValueSets(ValueSet[] valueSets) returns FHIRError[]? {
        FHIRError[] errors = [];
        foreach ValueSet valueSet in valueSets {
            FHIRError? result = self.addValueSet(valueSet);

            if result is FHIRError{
                errors.push(result);
            }
        }

        return errors;
    }

    public function addCodeSystem(CodeSystem codeSystem) returns FHIRError? {

        if codeSystem.url == () {
            return createFHIRError("Can not find the URL of the CodeSystem",
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "Add a proper URL for the resource: https://www.hl7.org/fhir/codesystem-definitions.html#CodeSystem.url",
            errorType = VALIDATION_ERROR
            );
        }

        string url = <string>codeSystem.url;
        if self.codeSystems.hasKey(url) {
            return createFHIRError("Duplicate entry",
            ERROR,
            PROCESSING_DUPLICATE,
            diagnostic = "Already there is a CodeSystem exists in the registry with the URL: " + url,
            errorType = VALIDATION_ERROR
            );
        }

        self.codeSystems[<string>codeSystem.url] = codeSystem;
    }

    public function addValueSet(ValueSet valueSet) returns FHIRError? {

        if valueSet.url == () {
            return createFHIRError("Can not find the URL of the ValueSet",
            ERROR,
            INVALID_REQUIRED,
            diagnostic = "Add a proper URL for the resource: https://www.hl7.org/fhir/valueset-definitions.html#ValueSet.url",
            errorType = VALIDATION_ERROR
            );
        }

        string url = <string>valueSet.url;
        if self.valueSets.hasKey(url) {
            return createFHIRError("Duplicate entry",
            ERROR,
            PROCESSING_DUPLICATE,
            diagnostic = "Already there is a ValueSet exists in the registry with the URL: " + url,
            errorType = VALIDATION_ERROR
            );
        }

        self.valueSets[url] = valueSet.cloneReadOnly();
    }

    # Find a Code System for a provided Id.
    #
    # + id - Id of the Code System
    # + return - Return Code system data, return FHIR error if no data found for the provided Id
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

    # Find a Value Set for a provided Id.
    #
    # + id - Id of the Value Set
    # + return - Return Value set data, return FHIR error if no data found for the provided Id
    public isolated function getValueSetById(string id) returns ValueSet|FHIRError {
        foreach var item in self.valueSets.keys() {
            if regex:matches(item, string `.*/${id}$`) {
                ValueSet? valueSet = self.valueSets[item];
                string msg = string `Unknown ValueSet : ${id}`;
                return valueSet ?: createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
            }
        }

        string msg = string `Unknown ValueSet : ${id}`;
        return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
    }

    # Search for Code systems for the provided search parameters.
    # Allowed search parameters are name, title, url, version, status.
    #
    # + searchParameters - List of search parameters, should be passed as map of string arrays 
    # + return - Return array of Code System data
    public isolated function searchCodeSystems(map<string[]> searchParameters) returns CodeSystem[]|FHIRError {

        // TThese are the support search parameters for Code systems.
        // These define as a map because to make the search process ease
        map<string> searchParamNames = {
            "name": "name",
            "title": "title",
            "url": "url",
            "version": "version",
            "status": "status"
        };

        // Validate the requested search parameters in the allowed list
        foreach var param in searchParameters.keys() {
            if !searchParamNames.hasKey(param) {
                return createFHIRError("Unsupported search parameter",
                ERROR,
                PROCESSING_NOT_SUPPORTED,
                diagnostic = "Unsupported search parameter: " + param,
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
            }
        }
        return codeSystemArray;
    }

    # Search for Value Sets for the provided search parameters.
    # Allowed search parameters are name, title, url, version, status.
    #
    # + searchParameters - List of search parameters, should be passed as map of string arrays 
    # + return - Return array of Value Set data
    public isolated function searchValueSets(map<string[]> searchParameters) returns ValueSet[] {

        string[] searchParamNames = ["name", "title", "url", "version", "status"];
        ValueSet[] valueSetArray = self.valueSets.toArray();

        foreach var searchParam in searchParamNames {
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
            }
        }
        return valueSetArray;
    }

    public isolated function codeSystemLookUp(uri? system, code? codeValue, Coding? coding) returns (CodeConceptDetails|FHIRError)? {

        if system != () && codeValue != () && self.codeSystems.hasKey(system) {
            return self.findConceptInCodeSystem(self.codeSystems.get(system), codeValue);
        } else if coding != () {
            uri? system1 = coding.system;
            code? code1 = coding.code;

            if system1 != () && code1 != () {
                return self.findConceptInCodeSystem(self.codeSystems.get(system1), code1);
            } else {
                string msg = string `Unknown CodeSystem : ${system}`;
                return createInternalFHIRError(msg, ERROR, PROCESSING_NOT_FOUND);
            }
        } else {
            string msg = string `System URL/code not present or invalide Coding : ${coding.toBalString()}`;
            return createFHIRError(msg, ERROR, INVALID);
        }
    }

    # Create CodeableConcept for given code in a given system.
    # 
    # + system - system uri of the code system or value set
    # + code - code interested
    # + codeSystemFinder - (optional) custom code system function (utility will used this function to find code 
    #                       system in a external source system)
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
    #                       system in a external source system)
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

    # Function to find code system concept within a ValueSet.
    # 
    # + valueSet - Target ValueSet
    # + code - code searching for
    # + return - ValueSet/CodeSystem concept found 
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

    private isolated function conceptToCoding (CodeSystemConcept|ValueSetComposeIncludeConcept concept, uri system) returns Coding {

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
