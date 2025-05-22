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

public isolated function findConceptsInValueSetFromCodeValue(r4:code|r4:Coding|r4:CodeableConcept codeValue, r4:ValueSet valueSet, Terminology? terminology = inMemoryTerminology) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
    r4:code code;
    r4:uri url;
    r4:CodeSystemConcept[] codeConceptDetailsList = [];

    if codeValue is r4:code {
        code = codeValue;
        return findConceptFromCode(valueSet, code, (), terminology = terminology);
    } else if codeValue is r4:Coding {
        code = <r4:code>codeValue.code;
        url = <r4:uri>codeValue.system;
        return findConceptFromCode(valueSet, code, url, terminology = terminology);
    } else {
        r4:Coding[]? codings = (<r4:CodeableConcept>codeValue).coding.clone();
        if codings != () && codings.length() > 0 {
            r4:FHIRError[] errors = [];
            foreach r4:Coding c in codings {
                code = <r4:code>c.code;
                url = <r4:uri>c.system;
                r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError result = findConceptFromCode(valueSet, code, url, terminology = terminology);
                if result is r4:CodeSystemConcept[] {
                    codeConceptDetailsList.push(...result);
                } else if result is r4:CodeSystemConcept {
                    codeConceptDetailsList.push(result);
                } else {
                    errors.push(result);
                }
            }
            if codeConceptDetailsList.length() < 1 {
                return r4:createFHIRError(
                                string `Cannot find any valid concepts for the CodeableConcept: ${codeValue.toString()} in the ValueSet: ${valueSet.url.toString()}`,
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
    return r4:createFHIRError(
                            string `Code: ${code.toString()} was not found in the CodeSystem: ${codeSystem.url.toString()}`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
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
                    codeSystemMetadata.push({url: systemValue, version: includeBBE.version}.clone());
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
                            string `Code: ${code.toString()} was not found in the ValueSet: ${valueSet.url.toString()}`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
}

# Function to find concept in a ValueSet by passing code data type parameter.
# This method disregards `.expansion` and focus only on `.compose`.
# `.compose`: A definition of which codes are intended to be in the value set ("intension")
# |- `.include`: Include one or more codes from a code system or other value set(s).
# |- if the codes are not defined inline, we will return the system urls of the code system(s) or value set(s).
# + valueSet - ValueSet resource
# + code - code to find in the ValueSet
# + return - CodeConceptDetails or FHIRError or canonical[] or uri
isolated function findConceptInValueSet(r4:ValueSet valueSet, r4:code code) returns CodeConceptDetails[]|r4:FHIRError {
    r4:ValueSetCompose? composeBBE = valueSet.clone().compose;
    if composeBBE != () {
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
                            codeConcepts.push(
                                {
                                url: systemValue,
                                concept: includeConcept
                            }.clone()
                            );
                        }
                    }
                }
            }
        }
        if codeConcepts.length() > 0 {
            return codeConcepts;
        }
    }
    return r4:createFHIRError(
                            string `Code: ${code.toString()} was not found in the ValueSet: ${valueSet.toString()}`,
                            r4:ERROR,
                            r4:PROCESSING_NOT_FOUND,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_NOT_FOUND
                        );
}

isolated function findConceptFromCode(r4:ValueSet valueSet, r4:code codeValue, r4:uri? codeUrl, Terminology? terminology) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
    r4:CodeSystemConcept[] codeConceptList = [];
    CodeConceptDetails[]|r4:canonical[]|CodeSystemMetadata[]|r4:FHIRError result = findConceptInValueSetOrReturnValueSetURIs(valueSet, codeValue);

    if result is CodeConceptDetails[] {
        foreach CodeConceptDetails codeConcept in result {
            if codeUrl == () || codeConcept.url == codeUrl {
                codeConceptList.push(codeConcept.concept.clone());
            }
        }
    } else if result is CodeSystemMetadata[] {
        foreach CodeSystemMetadata metadata in result {
            CodeConceptDetails|r4:FHIRError findConcept = (<Terminology>terminology).findConcept(<r4:uri>metadata.url, codeValue, version = metadata.version);
            if findConcept is CodeConceptDetails {
                if codeUrl == () || metadata.url == codeUrl {
                    codeConceptList.push(findConcept.concept.clone());
                }
            }
        }
    }
    else if result is r4:canonical[] {
        foreach r4:uri valusetUrl in result {
            r4:ValueSet|r4:FHIRError subValueSet = (<Terminology>terminology).findValueSet(system = valusetUrl);
            if subValueSet is r4:ValueSet {
                CodeConceptDetails[]|r4:FHIRError subResult = findConceptInValueSet(subValueSet, codeValue);
                if subResult is CodeConceptDetails[] {
                    foreach CodeConceptDetails codeConcept in subResult {
                        if codeUrl == () || codeConcept.url == codeUrl {
                            codeConceptList.push(codeConcept.concept.clone());
                        }
                    }
                }
            }
            // ignore all other cases as this is the second level
        }
    }
    else {
        return <r4:FHIRError>result;
    }
    if codeConceptList.length() < 1 {
        return r4:createFHIRError(
                        string `Cannot find any valid concepts for the code: ${codeValue.toString()} in the ValueSet: ${valueSet.url.toString()}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_NOT_FOUND);
    }
    if codeConceptList.length() == 1 {
        return codeConceptList[0].clone();
    } else {
        return codeConceptList.clone();
    }
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

//Only for in-memory opertaions
isolated function retrieveCodeSystemConcept(r4:CodeSystem codeSystem, r4:code|r4:Coding concept) returns r4:CodeSystemConcept|r4:FHIRError {
    if concept is r4:code {
        CodeConceptDetails|r4:FHIRError conceptDetails = findConceptInCodeSystem(codeSystem.clone(), concept.clone());
        if conceptDetails is CodeConceptDetails {
            r4:CodeSystemConcept codeConcept = conceptDetails.concept;
            if codeConcept is r4:CodeSystemConcept {
                return codeConcept.clone();
            }
        }
        return conceptDetails;
    } else {
        CodeConceptDetails|r4:FHIRError conceptDetails = findConceptInCodeSystemFromCoding(
                codeSystem.clone(), concept.clone());

        if conceptDetails is CodeConceptDetails {
            r4:CodeSystemConcept|r4:ValueSetComposeIncludeConcept temp = conceptDetails.concept;
            if temp is r4:CodeSystemConcept {
                return temp.clone();
            }
        }
        return conceptDetails;
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
    public isolated function isCodeSystemExist(r4:uri system, string version) returns boolean;

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
    public isolated function isValueSetExist(r4:uri system, string version) returns boolean;

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
};
