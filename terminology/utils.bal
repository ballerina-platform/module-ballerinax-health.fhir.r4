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
import ballerina/lang.'int as langint;
import ballerina/log;
import ballerina/time;
import ballerinax/health.fhir.r4;

public isolated function findConceptsInValueSetFromCodeValue(r4:code|r4:Coding|r4:CodeableConcept codeValue, r4:uri system, string? version, Terminology? terminology = inMemoryTerminology) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
    r4:CodeSystemConcept[] codeConceptDetailsList = [];
    CodeConceptDetails|r4:FHIRError result;

    if codeValue is r4:code {
        result = (<Terminology>terminology).findConcept(system, codeValue, version);
        if result is CodeConceptDetails {
            return result.concept;
        } else {
            return result;
        }
    } else if codeValue is r4:Coding {
        result = (<Terminology>terminology).findConcept(<r4:uri>codeValue.system, <r4:code>codeValue.code, codeValue.version);
        if result is CodeConceptDetails {
            return result.concept;
        } else {
            return result;
        }
    } else {
        r4:Coding[]? codings = (<r4:CodeableConcept>codeValue).coding.clone();
        if codings != () && codings.length() > 0 {
            r4:FHIRError[] errors = [];
            foreach r4:Coding c in codings {
                result = (<Terminology>terminology).findConcept(<r4:uri>c.system, <r4:code>c.code, c.'version);
                if result is CodeConceptDetails {
                    codeConceptDetailsList.push(result.concept);
                } else {
                    errors.push(result);
                }
            }
            if codeConceptDetailsList.length() < 1 || errors.length() > 0 {
                return r4:createFHIRError(
                                string `Cannot find any valid concepts for the CodeableConcept: ${codeValue.toString()} in the ValueSet: ${system.toString()}`,
                                r4:ERROR,
                                r4:PROCESSING_NOT_FOUND,
                                errorType = r4:PROCESSING_ERROR,
                                diagnostic = errors.toBalString(),
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
                            "Cannot find any valid codes in the provided CodeableConcept data",
                            r4:ERROR,
                            r4:INVALID_VALUE,
                            errorType = r4:VALIDATION_ERROR,
                            httpStatusCode = http:STATUS_BAD_REQUEST
                        );
        }
    }
}

# Function to find concept in a CodeSystem by passing code data type parameter. 
# + codeSystem - CodeSystem resource
# + code - code to find in the CodeSystem
# + return - CodeConceptDetails or FHIRError
isolated function findConceptInCodeSystem(r4:CodeSystem codeSystem, r4:code code) returns CodeConceptDetails|r4:FHIRError {
    r4:CodeSystemConcept[]? concepts = codeSystem.concept;
    r4:uri? url = codeSystem.url;

    if concepts != () && url != () {
        CodeConceptDetails? result = findConceptRecursively(concepts, code, url);
        if result != () {
            return result;
        }
    }

    return r4:createFHIRError(
        string `Code: ${code.toString()} was not found in the CodeSystem: ${codeSystem.url.toString()}`,
        r4:ERROR,
        r4:PROCESSING_NOT_FOUND,
        errorType = r4:PROCESSING_ERROR,
        httpStatusCode = http:STATUS_NOT_FOUND
    );
}

# Recursive function to search for a concept in nested CodeSystemConcept arrays.
# This function traverses through the provided `concepts` array and its nested arrays
# to find a concept that matches the given `code`. If a match is found, it returns
# the `CodeConceptDetails` containing the concept and its associated `url`.
# + concepts - The array of `CodeSystemConcept` to search within.
# + code - The code to search for in the `CodeSystemConcept` array.
# + url - The URL of the CodeSystem associated with the concepts.
# + return - Returns `CodeConceptDetails` if a matching concept is found, otherwise `()` (nil).
isolated function findConceptRecursively(r4:CodeSystemConcept[] concepts, r4:code code, r4:uri url) returns CodeConceptDetails? {
    foreach r4:CodeSystemConcept concept in concepts {
        if concept.code == code {
            return {
                url: url,
                concept: concept
            };
        }
        if concept.concept != () {
            CodeConceptDetails? nestedResult = findConceptRecursively(concept.concept ?: [], code, url);
            if nestedResult != () {
                return nestedResult;
            }
        }
    }
    return ();
}

# Function to find concept in a ValueSet by passing code data type parameter.
# This method disregards `.expansion` and focus only on `.compose`.
# `.compose`: A definition of which codes are intended to be in the value set ("intension")
# |- `.include`: Include one or more codes from a code system or other value set(s).
# |- if the codes are not defined inline, we will return the system urls of the code system(s) or value set(s).
# + valueSet - ValueSet resource
# + code - code to find in the ValueSet
# + return - CodeConceptDetails or FHIRError or canonical[] or uri
isolated function findConceptInValueSetOrReturnValueSetURIs(r4:ValueSet valueSet, r4:code code) returns CodeConceptDetails[]|r4:FHIRError|r4:canonical[]|CodeSystemMetadata[] {
    r4:ValueSetCompose? composeBBE = valueSet.clone().compose;
    if composeBBE != () {
        CodeSystemMetadata[] codeSystemMetadata = [];
        r4:canonical[] valueSets = [];
        CodeConceptDetails[] codeConcepts = [];
        foreach r4:ValueSetComposeInclude includeBBE in composeBBE.include {
            // Include one or more codes from a code system or other value set(s).
            r4:uri? systemValue = includeBBE.system;
            //+ Rule: A value set include/exclude SHALL have a value set or a system
            if systemValue != () {
                r4:ValueSetComposeIncludeConcept[]? includeConcepts = includeBBE.concept;
                if includeConcepts != () {
                    foreach r4:ValueSetComposeIncludeConcept includeConcept in includeConcepts {
                        if includeConcept.code == code {
                            // found the code
                            codeConcepts.push({
                                url: systemValue,
                                concept: includeConcept
                            }.clone());
                        }
                    }
                } else {
                    // when the concepts are not defined inline, we have to find the codes from the system url
                    codeSystemMetadata.push({url: systemValue, 'version: includeBBE.version}.clone());
                }
            } else {
                // check the contents included in this valueset
                r4:canonical[]? valueSetResult = includeBBE.valueSet;
                if valueSetResult != () {
                    // returns the list of valueset uris
                    foreach r4:canonical valueSetEntry in valueSetResult {
                        valueSets.push(valueSetEntry.clone());
                    }
                }
            }
        }

        if codeConcepts.length() > 0 {
            return codeConcepts;
        } else if codeSystemMetadata.length() > 0 {
            return codeSystemMetadata;
        } else if valueSets.length() > 0 {
            return valueSets;
        }
    }
    return r4:createFHIRError(
                            "Concept not found in the ValueSet",
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
}

isolated function getAllConceptInValueSet(r4:ValueSet valueSet) returns (ValueSetExpansionDetails)? {
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
                    r4:CodeSystem|r4:FHIRError codeSystem = readCodeSystemByUrl(systemValue);
                    if codeSystem is r4:CodeSystem {
                        ValueSetExpansionDetails? result = getAllConceptInCodeSystem(codeSystem);
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
                        r4:ValueSet|r4:FHIRError refValueSet = readValueSetByUrl(valueSetEntry);

                        if refValueSet is r4:ValueSet {
                            ValueSetExpansionDetails? concept =
                                                    getAllConceptInValueSet(refValueSet.clone());
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

isolated function conceptToCodeableConcept(r4:CodeSystemConcept concept, r4:uri system) returns r4:CodeableConcept {
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
    string? defValue = concept.definition;
    if defValue != () {
        cConcept.text = defValue;
    }
    return cConcept;
}

isolated function conceptToCoding(CodeConceptDetails conceptDetails) returns r4:Coding {
    r4:Coding codingValue = {
        code: conceptDetails.concept.code,
        system: conceptDetails.url
    };
    string? displayValue = conceptDetails.concept.display;
    if displayValue != () {
        codingValue.display = displayValue;
    }
    return codingValue;
}

isolated function retrieveCodeSystemConcept(r4:uri url, string? version, r4:code|r4:Coding concept, Terminology? terminology = inMemoryTerminology) returns r4:CodeSystemConcept|r4:FHIRError {
    if concept is r4:code {
        CodeConceptDetails|r4:FHIRError conceptDetails = (<Terminology>terminology).findConcept(url, concept, version);
        if conceptDetails is CodeConceptDetails {
            return conceptDetails.concept;
        }
        return conceptDetails;
    } else {
        if concept.code is r4:code {
            CodeConceptDetails|r4:FHIRError conceptDetails = (<Terminology>terminology).findConcept(url, <r4:code>concept.code, version);        

            if conceptDetails is CodeConceptDetails {
                return conceptDetails.concept;
            }
            return conceptDetails;
        } else {
            string msg = "No valid code found in the Coding";
            log:printDebug(r4:createFHIRError(msg, r4:ERROR, r4:PROCESSING_NOT_FOUND).toBalString());
            return r4:createFHIRError(msg, r4:ERROR, r4:PROCESSING_NOT_FOUND);
        }
    }
}

isolated function createExpandedValueSet(r4:ValueSet vs, r4:CodeSystemConcept[]|r4:ValueSetComposeIncludeConcept[] concepts)
                                                                                                    returns r4:ValueSetExpansion {
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

// Function to get all concepts in a CodeSystem.
isolated function getAllConceptInCodeSystem(r4:CodeSystem codeSystem) returns ValueSetExpansionDetails? {
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

// Function to find concept in a CodeSystem by passing Coding data type parameter.
isolated function findConceptInCodeSystemFromCoding(r4:CodeSystem codeSystem, r4:Coding coding) returns CodeConceptDetails|r4:FHIRError {
    r4:code? code = coding.code;
    if code != () {
        return findConceptInCodeSystem(codeSystem.clone(), code.clone()).clone();
    } else {
        string msg = "No valid code found in the Coding";
        log:printDebug(r4:createFHIRError(msg, r4:ERROR, r4:PROCESSING_NOT_FOUND).toBalString());
        return r4:createFHIRError(msg, r4:ERROR, r4:PROCESSING_NOT_FOUND);
    }
}

isolated function modifySearchParamsWithPagination(map<r4:RequestSearchParameter[]> searchParameters) returns PaginationSearchParamsResponse|r4:FHIRError {
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
                    string `Requested size of the response: ${count.toString()} is too large`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_SUPPORTED,
                    diagnostic = string `Allowed maximum size of output is: ${TERMINOLOGY_SEARCH_MAXIMUM_COUNT}; therefore, reduce the value of size parameter accordingly`,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_PAYLOAD_TOO_LARGE
                );
    }
    return {
        searchParameters: searchParameters,
        count: count,
        offset: offset
    };
}

isolated function isAChildConcept(r4:code targetCode, r4:CodeSystemConcept[] conceptsInCurrentConcept) returns boolean {
    foreach r4:CodeSystemConcept currentConcept in conceptsInCurrentConcept {
        if currentConcept.code == targetCode {
            return true;
        }
        if currentConcept.concept is r4:CodeSystemConcept[] {
            if isAChildConcept(targetCode, <r4:CodeSystemConcept[]>currentConcept.concept) {
                return true;
            }
        }
    }
    return false;
}

type PaginationSearchParamsResponse record {
    map<r4:RequestSearchParameter[]> searchParameters;
    int count;
    int offset;
};

//It is a custom record to hold system URLs and a related concept.  
public type CodeConceptDetails record {
    //System URL of the concept.
    r4:uri url;
    r4:CodeSystemConcept|r4:ValueSetComposeIncludeConcept concept;
};

//It is a custom record to hold metadata of a code system.
type CodeSystemMetadata record {
    //System URL of the CodeSystem.
    r4:uri url;
    //Version of the CodeSystem.
    string? version;
};

//It is a custom record to hold system URLs and a array of related concepts.
type ValueSetExpansionDetails record {
    //System URL of the concepts.
    r4:uri url;
    r4:CodeSystemConcept[]|r4:ValueSetComposeIncludeConcept[] concepts;
};

# Defines the interface for a `Terminology` implementation.
# This should be implemented and provided to the Terminology API. Default implementation is 
# an in-memory terminology implementation.
public type Terminology isolated object {

    # To check whether the CodeSystem exists.
    #
    # + system - CodeSystem URL to be checked.
    # + version - Version of the CodeSystem to be checked.
    # + return - Return true if the CodeSystem exists, else false.
    public isolated function isCodeSystemExist(r4:uri system, string 'version) returns boolean;

    # Add a new code system. Terminology API makes sure that the CodeSystem is valid. 
    #
    # + codeSystem - CodeSystem to be added. 
    # + return - FHIRError if any.
    public isolated function addCodeSystem(r4:CodeSystem codeSystem) returns r4:FHIRError?;

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

    # The function definition for Concept finder implementations.
    #
    # + system - System URL of the CodeSystem to be searched.
    # + code - Code of the Concept to be searched.
    # + version - version of the CodeSystem to be searched.
    # + return - CodeConceptDetails if found or else FHIRError.
    public isolated function findConcept(r4:uri system, r4:code code, string? version = ()) returns CodeConceptDetails|r4:FHIRError;

    # To check whether the ValueSet exists.
    # + system - ValueSet URL to be checked.
    # + version - Version of the ValueSet to be checked.
    # + return - Return true if the ValueSet exists, else false.
    public isolated function isValueSetExist(r4:uri system, string 'version) returns boolean;

    # Add a new value set. Terminology API makes sure that the ValueSet is valid.
    #
    # + valueSet - ValueSet to be added.
    # + return - FHIRError if any.
    public isolated function addValueSet(r4:ValueSet valueSet) returns r4:FHIRError?;

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

    # Expands a ValueSet with the given search parameters, offset, and count.
    #
    # This function applies filtering and pagination to the concepts in the provided ValueSet,
    # returning a ValueSetExpansion or an FHIRError if the operation fails.
    #
    # + searchParams - Map of search parameters to filter concepts (e.g., filter by display or definition).
    # + valueSet - The ValueSet record to be expanded.
    # + offset - The starting index for pagination (optional).
    # + count - The maximum number of concepts to return (optional).
    # + return - Returns a ValueSetExpansion if successful, or an FHIRError if the operation fails.
    public isolated function expandValueSet(map<r4:RequestSearchParameter[]> searchParams, r4:ValueSet valueSet, int offset, int count) returns r4:ValueSet|r4:FHIRError;

    # To check whether the ConceptMap exists.
    #
    # + system - ConceptMap URL to be checked.
    # + version - Version of the ConceptMap to be checked.
    # + return - Return true if the ConceptMap exists, else false.
    public isolated function isConceptMapExist(r4:uri system, string 'version) returns boolean;

    # Add a new concept map. Terminology API makes sure that the ConceptMap is valid. 
    #
    # + conceptMap - ConceptMap to be added. 
    # + return - FHIRError if any.
    public isolated function addConceptMap(r4:ConceptMap conceptMap) returns r4:FHIRError?;

    # Find a ConceptMap by its source and target ValueSets.
    #
    # + sourceValueSetUri - URI of the source ValueSet.
    # + targetValueSetUri - URI of the target ValueSet.
    # + return - ConceptMap if found or else FHIRError.
    public isolated function findConceptMaps(r4:uri sourceValueSetUri, r4:uri? targetValueSetUri = ()) returns r4:ConceptMap[]|r4:FHIRError;

    # The function definition for Concept Map finder implementations.
    #
    # + params - Search parameters.  
    # + offset - Offset value for the search.  
    # + count - Count value for the search.
    # + return - Concept Map array if found or else FHIRError.
    public isolated function searchConceptMap(map<r4:RequestSearchParameter[]> params, int? offset = (), int? count = ()) returns r4:ConceptMap[]|r4:FHIRError;

    # The function definition for Concept Map finder implementations.
    #
    # + conceptMapUrl - URI of the ConceptMap to be found.
    # + version - Version of the ConceptMap to be found (optional).
    # + return - ConceptMap if found or else FHIRError.
    public isolated function getConceptMap(r4:uri conceptMapUrl, string? version = ()) returns r4:ConceptMap|r4:FHIRError;
};

# Performs the translation of codes using the provided concept maps and codes to translate. Multiple concept maps can 
# be provided for matching. The codesToTranslate codeable concept can contain an array of code/system pairs. All the codes
# provided in the codeable concept will be matched with the provided concept map/s.
# 
# If the coding has a system, the concept map group that matches the source code system will be filetered and matched.
# If the coding has no system, all the groups in the concept map will be matched.
# 
# When a particular group doesn't have any matches, the unmapped field of that group will be checked for the mode and
# the matching will be done accordingly.
# 
# - When the unmapped mode is "fixed": the code provided inside the unmapped field is used.
# - When the unmapped mode is "provided": the source code is used as the target code.
# - When the unmapped mode is "other-map": the concept map provided inside the unmapped field is used for matching. The 
# function would recursively match the codes when there are multiple nested "other-map" references.
# 
# + conceptMaps - The array of ConceptMap resources to use for translation.
# + codesToTranslate - The CodeableConcept containing the codes to be translated.
# + terminology - The Terminology service to use for code translation.
# + return - A Parameters resource containing the translation results or an FHIRError if an error occurs.
isolated function doTranslation(r4:ConceptMap[] conceptMaps, r4:CodeableConcept codesToTranslate, Terminology? terminology = inMemoryTerminology) returns r4:Parameters|r4:FHIRError {

    r4:ParametersParameter[] parameters = [];
    r4:Coding[]? codes = codesToTranslate.coding;
    
    if codes is () || codes.length() == 0 {
        string msg = "No code found in the request. At least one code is required to perform the translation";
        log:printError(msg);
        return r4:createFHIRError(msg, r4:ERROR, r4:PROCESSING_NOT_FOUND, httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    foreach var conceptMap in conceptMaps {
        r4:uri? conceptMapUri = conceptMap.url;
        r4:ConceptMapGroup[]? groups = conceptMap.group;
        if (groups == () || groups.length() == 0) {
            // If no groups are found in the current concept map, continue to the next concept map
            log:printWarn(string`No groups found in concept map: ${conceptMap.id.toString()}. Proceeding to the next one`);
            continue;
        }

        foreach var code in codes {
            r4:code? sourceCode = code.code;
            r4:uri? sourceCodeSystem = code.system;

            if sourceCode is () {
                log:printDebug("Current coding has no code present in it, proceeding to the next coding.");
                continue;
            }

            if sourceCodeSystem is () || sourceCodeSystem.toString() == "" {
                log:printDebug(string `Matching the code ${sourceCode} with all groups available in the concept map.`);
                check matchWithAllGroups(groups, sourceCode, parameters, conceptMapUri, terminology);
            } else {
                int initialMatchCount = countMatchParameters(parameters);
                foreach var group in groups {
                    if doesGroupHasMatchingSystem(group, sourceCodeSystem) {
                        r4:ConceptMapGroupElement[] groupElements = group.element;
                        r4:uri? targetSystem = group.target;
                        log:printDebug(string `Matching the code ${sourceCode} with the group having source system ${sourceCodeSystem}.`);
                        matchWithGroupElement(groupElements, sourceCode, parameters, conceptMapUri, targetSystem);
                    }

                    int postMatchCount = countMatchParameters(parameters);

                    if postMatchCount == initialMatchCount { // This means this group didn't have any matches for the code
                        r4:ConceptMapGroupUnmapped? unmappedField = group.unmapped;
                        if unmappedField is () {
                            log:printDebug("No unmapped element found in the current group, proceeding to the next group.");
                            continue;
                        }
                        matchWithUnmappedField(parameters, unmappedField, sourceCode, terminology, sourceCodeSystem);
                    }
                }
            }
        }
    }

    if !haveResultParameter(parameters) {
        if !haveMatchParameters(parameters) {
            parameters.push({name: "result", valueBoolean: false});
            parameters.push({name: "message", valueString: "No translation found for in any concept map."});
        } else {
            parameters.push({name: "result", valueBoolean: true});
        }
    }
    return {'parameter: parameters};
}

# Checks if the source code system matches with the provided concept map group
#
# + group - a group from the concept map
# + sourceSystem - The source code system URI
# + return - true is the group matches with the source system. False otherwise.
isolated function doesGroupHasMatchingSystem(r4:ConceptMapGroup group, r4:uri sourceSystem) returns boolean {

    r4:uri? sourceSystemInGroup = group.'source;
    return sourceSystemInGroup == sourceSystem;
}

# Matches the provided code/s with all available groups in the concept map without the code system.
#
# + groups - the concept map groups to match against
# + codeToTranslate - the code to translate
# + parameters - the parameters to populate with the match results
# + conceptMapUri - the URI of the concept map
# + terminology - the terminology implementation
# + sourceSystem - the URI of the source system
# + return - an optional FHIRError if an error occurs during matching
isolated function matchWithAllGroups(r4:ConceptMapGroup[] groups, r4:code codeToTranslate, r4:ParametersParameter[] parameters, r4:uri? conceptMapUri = (), Terminology? terminology = inMemoryTerminology, r4:uri? sourceSystem = ()) returns r4:FHIRError? {

    foreach var group in groups {
        int initialMatchCount = countMatchParameters(parameters);
        r4:ConceptMapGroupElement[]? elements = group.element;
        r4:uri? targetSystem = group.target;

        if elements is () || elements.length() == 0 {
            log:printDebug("No elements found in the current group, proceeding to the next group.");
            continue;
        }
        matchWithGroupElement(elements, codeToTranslate, parameters, conceptMapUri, targetSystem);

        int postMatchCount = countMatchParameters(parameters);

        if postMatchCount == initialMatchCount {
            log:printDebug(string `Checking the unmapped field for the code: ${codeToTranslate}`);
            r4:ConceptMapGroupUnmapped? unmappedField = group.unmapped;
            if unmappedField is () {
                log:printDebug("No unmapped element found in the current group, proceeding to the next group.");
                continue;
            }
            matchWithUnmappedField(parameters, unmappedField, codeToTranslate, terminology);
        }
    }
}

# Matches the 'unmapped' mode for unmapped fields.
#
# + parameters - the parameters to populate with the match results
# + unmappedField - the unmapped field to process
# + codeToTranslate - the code to translate
# + terminology - the terminology service
# + sourceSystem - the URI of the source system
isolated function matchWithUnmappedField(r4:ParametersParameter[] parameters, r4:ConceptMapGroupUnmapped unmappedField, r4:code? codeToTranslate, Terminology? terminology = inMemoryTerminology, r4:uri? sourceSystem = ()) {

    r4:ConceptMapGroupUnmappedMode mode = unmappedField.mode;

    match mode {
        r4:CODE_MODE_PROVIDED => {
            handleProvidedMode(codeToTranslate, parameters);
        }
        r4:CODE_MODE_FIXED => {
            handleFixedMode(unmappedField, parameters);
        }
        r4:CODE_MODE_OTHER_MAP => {
            handleOtherMapMode(unmappedField, parameters, codeToTranslate, sourceSystem, terminology);
        }
    }
}

# Matches the 'provided' mode for unmapped fields.
#
# + codeToTranslate - the code to translate
# + parameters - the parameters to populate with the match results
isolated function handleProvidedMode(r4:code? codeToTranslate, r4:ParametersParameter[] parameters) {

    r4:Coding conceptCoding = {
        code: codeToTranslate
    };
    parameters.push(
        {
        name: r4:MATCH,
        part: getPartParameter(conceptCoding, r4:CODE_EQUIVALENCE_UNMATCHED)
    }
    );
}

# Matches the 'fixed' mode for unmapped fields.
#
# + unmappedField - the unmapped field to process
# + parameters - the parameters to populate with the match results
isolated function handleFixedMode(r4:ConceptMapGroupUnmapped unmappedField, r4:ParametersParameter[] parameters) {
    r4:Coding conceptCoding = {
        code: unmappedField.code,
        display: unmappedField.display
    };
    parameters.push(
        {
        name: r4:MATCH,
        part: getPartParameter(conceptCoding, r4:CODE_EQUIVALENCE_UNMATCHED)
    }
    );
}

# Matches the 'other-map' mode for unmapped fields.
#
# + unmappedField - the unmapped field to process
# + parameters - the parameters to populate with the match results
# + codeToTranslate - the code to translate
# + sourceSystem - the URI of the source system
# + terminology - the terminology service to use for translation
isolated function handleOtherMapMode(r4:ConceptMapGroupUnmapped unmappedField, r4:ParametersParameter[] parameters, r4:code? codeToTranslate = (), r4:uri? sourceSystem = (), Terminology? terminology = inMemoryTerminology) {

    // Retrieve the fallback concept map from the URL
    r4:uri? otherConceptMapUri = unmappedField.url;
    if otherConceptMapUri is () {
        log:printWarn("No other concept map URI provided for the 'other-map' mode, cannot proceed with the translation.");
        return;
    }
    r4:ConceptMap|r4:FHIRError? fallbackConceptMap = (<Terminology>terminology).getConceptMap(otherConceptMapUri);
    if fallbackConceptMap is r4:FHIRError || fallbackConceptMap is () {
        log:printWarn("No fallback concept map found for the 'other-map' mode");
        return;
    }

    r4:ConceptMap[] fallbackConceptMapArray = [fallbackConceptMap];
    r4:Parameters|r4:FHIRError fallbackResponse = doTranslation(fallbackConceptMapArray, 
                                                {coding: [{code: codeToTranslate, system: sourceSystem}]}, terminology);

    if fallbackResponse is r4:FHIRError {
        return;
    }

    r4:ParametersParameter[]? fallbackParameters = fallbackResponse.'parameter;
    if fallbackParameters !is () && fallbackParameters.length() > 0 {
        foreach r4:ParametersParameter item in fallbackParameters {
            parameters.push(item);
        }
    }
}

# Matches the group elements within a concept map.
#
# + elements - the group elements to match
# + codeToTranslate - the code to translate
# + parameters - the parameters to populate with the match results
# + conceptMapUri - the URI of the concept map
# + targetSystem - the URI of the target system
isolated function matchWithGroupElement(r4:ConceptMapGroupElement[] elements, r4:code codeToTranslate, r4:ParametersParameter[] parameters, r4:uri? conceptMapUri = (), r4:uri? targetSystem = ()) {

    foreach var element in elements {
        r4:code? code = element.code;
        if code == codeToTranslate {
            r4:ConceptMapGroupElementTarget[]? targets = element.target;
            if targets is () {
                log:printDebug("No targets found in the current element, proceeding to the next element.");
                continue;
            }
            matchWithGroupElementTarget(targets, parameters, conceptMapUri, targetSystem);
        }
    }
}

# Matches the target elements within a group element and enriches the parameters array.
#
# + targets - the target elements to match
# + parameters - the parameters to populate with the match results
# + conceptMapUri - the URI of the concept map
# + targetSystem - the URI of the target system
isolated function matchWithGroupElementTarget(r4:ConceptMapGroupElementTarget[] targets, r4:ParametersParameter[] parameters, r4:uri? conceptMapUri = (), r4:uri? targetSystem = ()) {

    foreach var target in targets {
        r4:code? targetCode = target.code;
        if targetCode is () {
            log:printDebug("No code found in the current target, proceeding to the next target.");
            continue;
        }
        r4:Coding conceptCoding = {
            code: target.code,
            display: target.display,
            system: targetSystem
        };
        parameters.push(getMatchParameter(conceptCoding, conceptMapUri, target.equivalence.toString()));
    }
}

# Returns a match parameter for the given concept coding and concept map URI.
#
# + conceptCoding - the coding information for the concept
# + conceptMapUri - the URI of the concept map
# + equivalenceCode - the equivalence code for the concept
# + return - a match parameter for the given concept coding and concept map URI
isolated function getMatchParameter(r4:Coding conceptCoding, r4:uri? conceptMapUri = (), string? equivalenceCode = ()) returns r4:ParametersParameter {

    return {
        name: r4:MATCH,
        part: getPartParameter(conceptCoding, conceptMapUri, equivalenceCode)
    };
}

# Returns a parameter indicating the equivalence of the concept.
#
# + equivalenceCode - the equivalence code for the concept
# + return - a parameter indicating the equivalence of the concept
isolated function getEquivalenceParameter(string? equivalenceCode = ()) returns r4:ParametersParameter {

    return {
        name: r4:CODE_EQUIVALENCE_EQUIVALENT,
        valueCode: equivalenceCode
    };
}

# Returns a parameter indicating the concept being mapped.
#
# + conceptCoding - the coding information for the concept
# + return - a parameter indicating the concept being mapped
isolated function getConceptParameter(r4:Coding conceptCoding) returns r4:ParametersParameter {

    string? targetCode = conceptCoding.code;
    string? display = conceptCoding.display;
    string? targetSystem = conceptCoding.system;

    if targetSystem is () {
        return {
            name: "concept",
            valueCoding: {
                code: targetCode,
                display: display,
                system: targetSystem,
                userSelected: false // This must be false since there is no user intervention when deciding this matching
            }
        };
    }

    return {
        name: "concept",
        valueCoding: {
            system: targetSystem,
            code: targetCode,
            display: display,
            userSelected: false // This must be false since there is no user intervention when deciding this matching
        }
    };
}

# Returns a parameter indicating the source of the concept map.
#
# + conceptMapUri - the URI of the concept map
# + return - a parameter indicating the source of the concept map
isolated function getSourceParameter(string conceptMapUri) returns r4:ParametersParameter {

    return {
        name: "source",
        valueUri: conceptMapUri
    };
}

# Returns a parameter indicating the source of the concept map.
#
# + conceptCoding - the coding information for the concept
# + conceptMapUri - the URI of the concept map
# + equivalenceCode - the equivalence code for the concept
# + return - an array of parameters indicating the parts of the concept mapping
isolated function getPartParameter(r4:Coding conceptCoding, r4:uri? conceptMapUri = (), string? equivalenceCode = ()) returns r4:ParametersParameter[] {

    if conceptMapUri is () {
        return [
            getEquivalenceParameter(equivalenceCode),
            getConceptParameter(conceptCoding)
        ];
    } else {
        return [
            getEquivalenceParameter(equivalenceCode),
            getConceptParameter(conceptCoding),
            getSourceParameter(conceptMapUri)
        ];
    }
}

# Returns a parameter indicating that no translation was found for a specific code.
#
# + code - the code that was not found
# + return - a parameter indicating that no translation was found for the specific code
isolated function getUnmatchedCodeParameter(string code) returns r4:ParametersParameter {

    return {
        name: "message",
        valueString: string `No translation found for the code '${code}' in the provided concept map/s`
    };
}

# Counts the number of match parameters in the provided parameters array.
#
# + parameters - the parameters array
# + return - the count of match parameters
isolated function countMatchParameters(r4:ParametersParameter[] parameters) returns int {

    int matchCount = 0;
    foreach r4:ParametersParameter item in parameters {
        if item.name == r4:MATCH {
            matchCount += 1;
        }
    }
    log:printDebug(string `Match parameter count is ${matchCount}`);
    return matchCount;
}

# Checks if there are any match parameters present in the provided parameters array.
#
# + parameters - the parameters array
# + return - true if at least one match parameter is found, false otherwise
isolated function haveMatchParameters(r4:ParametersParameter[] parameters) returns boolean {

    foreach r4:ParametersParameter item in parameters {
        if item.name == r4:MATCH {
            return true;
        }
    }
    return false;
}

# Counts the number of parameters with the name "result" in it.
#
# + parameters - the parameters array
# + return - true if at least one result parameter is found, false otherwise
isolated function haveResultParameter(r4:ParametersParameter[] parameters) returns boolean {

    foreach r4:ParametersParameter item in parameters {
        if item.name == "result" {
            return true;
        }
    }
    return false;
}

