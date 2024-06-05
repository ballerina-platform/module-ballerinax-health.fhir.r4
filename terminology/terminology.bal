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
import ballerina/lang.regexp;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401 as i4;
import ballerinax/health.fhir.r4.validator;

final InMemoryTerminology inMemoryTerminology = new ();

# Find a Code System based on the provided Id and version.
#
# + id - Id of the CodeSystem to be retrieved
# + version - Version of the CodeSystem to be retrieved and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return CodeSystem data if the request is successful, return FHIR error if no data found for the provided Id
public isolated function readCodeSystemById(string id, string? version = (), Terminology? terminology = inMemoryTerminology) returns r4:CodeSystem|r4:FHIRError {
    return (<Terminology>terminology).findCodeSystem(id = id, version = version);
}

# Find a ValueSet for a provided Id and version.
#
# + id - Id of the Value Set to be retrieved
# + version - Version of the ValueSet to be retrieved and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return ValueSet data if the request is successful, return FHIR error if no data found for the provided Id
public isolated function readValueSetById(string id, string? version = (), Terminology? terminology = inMemoryTerminology) returns r4:ValueSet|r4:FHIRError {
    return (<Terminology>terminology).findValueSet(id = id, version = version);
}

# Find a CodeSystem based on the provided URL and version.
#
# + url - URL of the CodeSystem to be retrieved
# + version - Version of the CodeSystem to be retrieved and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return CodeSystem data if the request is successful, return FHIR error if no data found for the provided URL
public isolated function readCodeSystemByUrl(r4:uri url, string? version = (), Terminology? terminology = inMemoryTerminology) returns r4:CodeSystem|r4:FHIRError {
    return (<Terminology>terminology).findCodeSystem(system = url, version = version);
}

# Find a ValueSet for a provided URL and version.
#
# + url - URL of the Value Set to be retrieved
# + version - Version of the ValueSet to be retrieved and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return ValueSet data if the request is successful, return FHIR error if no data found for the provided URL
public isolated function readValueSetByUrl(r4:uri url, string? version = (), Terminology? terminology = inMemoryTerminology) returns r4:ValueSet|r4:FHIRError {
    return (<Terminology>terminology).findValueSet(system = url, version = version);
}

# Search for Code systems based on the provided search parameters.
# Allowed search parameters are name, title, url, version, status and so on.
#
# + params - List of search parameters, should be passed as map of string arrays
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return array of CodeSystem data if success, return FHIR error if the request contains unsupported search parameters 
# and for any other processing errors
public isolated function searchCodeSystems(map<r4:RequestSearchParameter[]> params, Terminology? terminology = inMemoryTerminology) returns r4:CodeSystem[]|r4:FHIRError {
    record {map<r4:RequestSearchParameter[]> searchParameters; int count; int offset;} paginationData = check modifySearchParamsWithPagination(params.clone());

    // Validate whether the requested search parameters in the allowed list
    foreach var param in paginationData.searchParameters.keys() {
        if !CODESYSTEMS_SEARCH_PARAMS.hasKey(param) {
            return r4:createFHIRError(
                        string `Invalid search parameter: ${param}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_SUPPORTED,
                        diagnostic = string `Allowed search parameters: ${CODESYSTEMS_SEARCH_PARAMS.keys().toString()}`,
                        errorType = r4:VALIDATION_ERROR
                    );
        }
    }
    return (<Terminology>terminology).searchCodeSystem(paginationData.searchParameters.clone(), offset = paginationData.offset, count = paginationData.count);
}

# Search for Value Sets for the provided search parameters.
# Allowed search parameters: are name, title, url, version, status and son on.
#
# + params - List of search parameters, should be passed as map of string arrays  
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return array of ValueSet data if success, return FHIR error if the request contains unsupported search parameters
# and for any other processing errors
public isolated function searchValueSets(map<r4:RequestSearchParameter[]> params, Terminology? terminology = inMemoryTerminology) returns r4:FHIRError|r4:ValueSet[] {
    record {map<r4:RequestSearchParameter[]> searchParameters; int count; int offset;} paginationData = check modifySearchParamsWithPagination(params.clone());

    // Validate the requested search parameters in the allowed list
    foreach var param in paginationData.searchParameters.keys() {
        if !VALUESETS_SEARCH_PARAMS.hasKey(param) {
            return r4:createFHIRError(
                        string `Invalid search parameter: ${param}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_SUPPORTED,
                        diagnostic = string `Allowed search parameters: ${VALUESETS_SEARCH_PARAMS.keys().toString()}`,
                        errorType = r4:VALIDATION_ERROR
                    );
        }
    }
    return (<Terminology>terminology).searchValueSet(paginationData.searchParameters.clone(), offset = paginationData.offset, count = paginationData.count);
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
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return list of Concepts if processing is successful, return FHIRError if fails
public isolated function codeSystemLookUp(r4:code|r4:Coding codeValue, r4:CodeSystem? cs = (),
        r4:uri? system = (), string? version = (), Terminology? terminology = inMemoryTerminology) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
    // Create and initialize a CodeSystem record with the mandatory fields
    r4:CodeSystem codeSystem = {content: "example", status: "unknown"};
    r4:CodeSystem|error ensured = cs.clone().ensureType();
    if ensured is r4:CodeSystem {
        codeSystem = ensured;
    } else if codeValue is r4:code && system is r4:uri {
        r4:CodeSystem|r4:FHIRError tmpCodeSystem = (<Terminology>terminology).findCodeSystem(system, version);
        if tmpCodeSystem is r4:CodeSystem {
            codeSystem = tmpCodeSystem;
        } else {
            return r4:createFHIRError(string `Cannot find a CodeSystem for the provided system URL: ${system}`,
                            r4:ERROR,
                            r4:INVALID,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_BAD_REQUEST
                        );
        }
    } else if codeValue is r4:Coding {
        r4:CodeSystem|r4:FHIRError tmpCodeSystem = (<Terminology>terminology).findCodeSystem(codeValue.system, version);
        if tmpCodeSystem is r4:CodeSystem {
            codeSystem = tmpCodeSystem;
        } else {
            return r4:createFHIRError(string `Cannot find a CodeSystem for the provided system URL: ${<string>codeValue.system}`,
                            r4:ERROR,
                            r4:INVALID,
                            errorType = r4:PROCESSING_ERROR,
                            httpStatusCode = http:STATUS_BAD_REQUEST
                        );
        }
    } else {
        return r4:createFHIRError(
                        "Cannot find a CodeSystem",
                        r4:ERROR,
                        r4:INVALID_REQUIRED,
                        diagnostic = "Either CodeSystem record or system URL or a valid Coding should be provided as input",
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_BAD_REQUEST
                    );
    }
    r4:code code;
    if codeValue is r4:code {
        code = codeValue;
    } else {
        code = <r4:code>codeValue.code;
    }
    if code is "" {
        return r4:createFHIRError(
                "A valid code or Coding should be provided as input",
                r4:ERROR,
                r4:PROCESSING_NOT_FOUND,
                httpStatusCode = http:STATUS_BAD_REQUEST
            );
    }
    CodeConceptDetails|r4:FHIRError result = findConceptInCodeSystem(codeSystem, code);
    if result is CodeConceptDetails {
        return result.concept.clone();
    } else {
        return result;
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
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return list of Concepts if processing is successful, return FHIRError if fails
public isolated function valueSetLookUp(r4:code|r4:Coding|r4:CodeableConcept codeValue, r4:ValueSet? vs = (),
        r4:uri? system = (), string? version = (), Terminology? terminology = inMemoryTerminology) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
    // Create and initialize a ValueSet record with the mandatory fields
    r4:ValueSet valueSet = {status: "unknown"};

    r4:ValueSet|error ensured = vs.clone().ensureType();
    if ensured is r4:ValueSet {
        valueSet = ensured;
    } else if system is r4:uri {
        r4:ValueSet|r4:FHIRError tmpValueSet = (<Terminology>terminology).findValueSet(system, version);
        if tmpValueSet is r4:ValueSet {
            valueSet = tmpValueSet;
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
                    "Cannot find a ValueSet",
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = "Either ValueSet record or system URL should be provided as input",
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    }
    return findConceptsInValueSetFromCodeValue(codeValue, valueSet, terminology);
}

# Extract all the concepts from a given valueSet based on the given filter parameters.
# This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#expand.
#
# + searchParams - List of search parameters to filter concepts, should be passed as map of string arrays  
# + vs - ValueSet record to be processed. If system parameter is not supplied, this value shoud be mandatory, 
# else this is an optional field  
# + system - System URL of the ValueSet to be processed, if system ValueSet(vs) is not supplied then  
# this value shoud be mandatory
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - List of concepts is successful,  return FHIRError if fails
public isolated function valueSetExpansion(map<r4:RequestSearchParameter[]>? searchParams, r4:ValueSet? vs = (), r4:uri? system = (), Terminology? terminology = inMemoryTerminology)
                                                                                        returns r4:ValueSet|r4:FHIRError {
    map<r4:RequestSearchParameter[]> searchParameters = searchParams.clone() ?: {};
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
                    string `Requested size of the response: ${count.toString()} is too large`,
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
                        diagnostic = string `Allowed search parameters: ${VALUESETS_EXPANSION_PARAMS.keys().toString()}`,
                        errorType = r4:VALIDATION_ERROR
                    );
        }
    }

    // Create and initialize a ValueSet record with the mandatory fields
    r4:ValueSet valueSet = {status: "unknown"};

    r4:ValueSet|error ensured = vs.clone().ensureType();
    if ensured is r4:ValueSet {
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

        r4:ValueSet[] v = check searchValueSets(clone, terminology);
        if v.length() > 0 {
            valueSet = v[0];
        } else {
            return r4:createFHIRError(
                        string `Cannot find a ValueSet for system: ${system.toString()}`,
                        r4:ERROR,
                        r4:INVALID_REQUIRED,
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_BAD_REQUEST
                    );
        }
    } else {
        return r4:createFHIRError(
                    "Cannot find a ValueSet",
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = "Either ValueSet record or system URL should be provided as input",
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    }

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

# This method with compare concepts.
# This method was implemented based on: http://hl7.org/fhir/R4/terminology-service.html#subsumes.
#
# + conceptA - Concept 1  
# + conceptB - Concept 2  
# + cs - CodeSystem value  
# + system - System uri of the codeSystem  
# + version - Version of the CodeSystem and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return Values either equivalent or not-subsumed if processing is successful, FHIRError processing fails
public isolated function subsumes(r4:code|r4:Coding conceptA, r4:code|r4:Coding conceptB, r4:CodeSystem? cs = (),
        r4:uri? system = (), string? version = (), Terminology? terminology = inMemoryTerminology) returns i4:Parameters|r4:FHIRError {
    // Create and initialize a CodeSystem record with the mandatory fields
    r4:CodeSystem codeSystem = {content: "example", status: "unknown"};
    r4:CodeSystem?|error tmp = ();
    if cs is () && system != () {
        tmp = readCodeSystemByUrl(system, version, terminology);
    }
    if tmp is r4:CodeSystem {
        codeSystem = tmp;
    } else if cs != () {
        codeSystem = cs.clone();
    } else {
        return r4:createFHIRError(
                    "Cannot find a CodeSystem",
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = "CodeSystem record or system URL should be provided as input",
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    }

    r4:CodeSystemConcept? conceptDetailsA = check retrieveCodeSystemConcept(codeSystem, conceptA.clone());
    r4:CodeSystemConcept? conceptDetailsB = check retrieveCodeSystemConcept(codeSystem, conceptB.clone());

    if conceptDetailsA != () && conceptDetailsB != () {
        if conceptDetailsA.code == conceptDetailsB.code && conceptDetailsA.display == conceptDetailsB.display {
            return {'parameter: [{name: OUTCOME, valueCode: EQUIVALENT}]};
        } else {
            return {'parameter: [{name: OUTCOME, valueCode: NOT_SUBSUMED}]};
        }
    } else if conceptDetailsA is () {
        return r4:createFHIRError(
                    string `Code/ Coding: ${conceptA.toString()} is not included in the provided CodeSystem`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    } else {
        return r4:createFHIRError(
                    string `Code/ Coding: ${conceptB.toString()} is not included in the provided CodeSystem`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    }
}

# Create CodeableConcept data type for given code in a given system.
#
# + system - system uri of the code system or value set  
# + code - code interested  
# + version - Version of the CodeSystem and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Created CodeableConcept record or FHIRError if not found
public isolated function createCodeableConcept(r4:uri system, r4:code code, string? version = ()
        , Terminology? terminology = inMemoryTerminology) returns r4:CodeableConcept|r4:FHIRError {
    CodeConceptDetails|r4:FHIRError conceptResult = (<Terminology>terminology).findConcept(system, code, version = version);
    if conceptResult is CodeConceptDetails {
        return conceptToCodeableConcept(conceptResult.concept.clone(), system.clone());
    } else {
        return conceptResult;
    }
}

# Create Coding data type for given code in a given system.
#
# + system - System uri of the CodeSystem or valueSet  
# + code - code interested 
# + version - Version of the CodeSystem and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Created CodeableConcept record or FHIRError if not found
public isolated function createCoding(r4:uri system, r4:code code, string? version = ()
        , Terminology? terminology = inMemoryTerminology) returns r4:Coding|r4:FHIRError {
    CodeConceptDetails|r4:FHIRError conceptResult = (<Terminology>terminology).findConcept(system, code, version);
    if conceptResult is CodeConceptDetails {
        return conceptToCoding(conceptResult);
    } else {
        return conceptResult;
    }
}

# Add a list of new CodeSystems.
#
# + codeSystems - List CodeSystems
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return List of FHIRErrors if any
public isolated function addCodeSystems(r4:CodeSystem[] codeSystems, Terminology? terminology = inMemoryTerminology) returns r4:FHIRError[]? {
    r4:FHIRError[] errors = [];
    foreach r4:CodeSystem codeSystem in codeSystems {
        r4:FHIRError? result = addCodeSystem(codeSystem, terminology);
        _ = result is r4:FHIRError ? errors.push(result) : "";
    }
    return errors.length() > 0 ? errors : ();
}

# Add a list of new CodeSystems as a json or json array.
#
# + codeSystemJsonArray - CodeSystem data in the JSON format
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return List of FHIRErrors if any
public isolated function addCodeSystemsAsJson(json[] codeSystemJsonArray, Terminology? terminology = inMemoryTerminology) returns r4:FHIRError[]? {
    r4:FHIRError[] errors = [];
    r4:CodeSystem[] codeSystems = [];

    foreach var c in codeSystemJsonArray {
        r4:CodeSystem|error result = c.cloneWithType();
        if result is error {
            r4:FHIRError er = r4:createFHIRError(
                    string `Invalid data. Cannot parse the provided json data: ${c.toString()}`,
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
    _ = codeSystems.length() > 0 ? errors.push(...<r4:FHIRError[]>addCodeSystems(codeSystems, terminology)) : "";

    if errors.length() > 0 {
        return errors;
    }
    return;
}

# Add a list of new ValueSets.
#
# + valueSets - List ValueSets in the Ballerina record format
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return List of FHIRErrors if any
public isolated function addValueSets(r4:ValueSet[] valueSets, Terminology? terminology = inMemoryTerminology) returns r4:FHIRError[]? {
    r4:FHIRError[] errors = [];
    foreach r4:ValueSet valueSet in valueSets {
        r4:FHIRError? result = addValueSet(valueSet, terminology);
        _ = result is r4:FHIRError ? errors.push(result) : "";
    }
    return errors;
}

# Add a list of new ValueSet as a json or json array.
#
# + valueSetJsonArray - Json ValueSet data in the JSON format
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return List of FHIRErrors if any
public isolated function addValueSetsAsJson(json[] valueSetJsonArray, Terminology? terminology = inMemoryTerminology) returns r4:FHIRError[]? {
    r4:FHIRError[] errors = [];
    r4:ValueSet[] valueSets = [];

    foreach var v in valueSetJsonArray {
        r4:ValueSet|error result = v.cloneWithType(r4:ValueSet);
        if result is error {
            r4:FHIRError er = r4:createFHIRError(
                    string `Invalid data. Cannot parse the provided json data: ${v.toString()}`,
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
    _ = valueSets.length() > 0 ? errors.push(...<r4:FHIRError[]>addValueSets(valueSets, terminology)) : "";

    if errors.length() > 0 {
        return errors;
    }
    return;
}

# Add a new CodeSystem.
#
# + codeSystem - ValueSet to be added, data in the Ballerina record format
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return FHIRError
public isolated function addCodeSystem(r4:CodeSystem codeSystem, Terminology? terminology = inMemoryTerminology) returns r4:FHIRError? {
    if codeSystem.url == () {
        return r4:createFHIRError(
                    string `Cannot find the URL of the CodeSystem with name: ${codeSystem.name.toString()}`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = string `Add a proper URL for the resource: http://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.url`,
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    }

    if codeSystem.version == () {
        return r4:createFHIRError(
                    string `Cannot find the version of the CodeSystem with name: ${codeSystem.name.toString()}`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = string `Add appropriate version for the resource: https://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.version`,
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    }

    string url = <string>codeSystem.url;
    string version = <string>codeSystem.version;

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

    if (<Terminology>terminology).isCodeSystemExist(url, version) {
        return r4:createFHIRError(
                    "Duplicate entry",
                    r4:ERROR,
                    r4:PROCESSING_DUPLICATE,
                    diagnostic = string `There is an already existing CodeSystem in the registry with the URL: ${url}`,
                    errorType = r4:PROCESSING_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    }
    r4:FHIRError? result = (<Terminology>terminology).addCodeSystem(codeSystem.clone());
    if result is r4:FHIRError {
        return result;
    }
}

# Add a new ValueSet.
#
# + valueSet - ValueSet to be added, data in the Ballerina record format
# + terminology - Terminology - optional parameter allowing you to pass a custom implementation of the Terminology and by default we use InMemoryTerminology.
# + return - Return FHIRError
public isolated function addValueSet(r4:ValueSet valueSet, Terminology? terminology = inMemoryTerminology) returns r4:FHIRError? {
    if valueSet.url == () {
        return r4:createFHIRError(
                    string `Cannot find the URL of the ValueSet with name: ${valueSet.name.toString()}`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = "Add a proper URL for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.url",
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    }
    if valueSet.version == () {
        return r4:createFHIRError(
                    string `Cannot find the version of the ValueSet with name: ${valueSet.name.toString()}`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = string `Add appropriate version for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.version`,
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST
                );
    }
    string url = <string>valueSet.url;
    string rVersion = <string>valueSet.version;
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
    if (<Terminology>terminology).isValueSetExist(url, rVersion) {
        return r4:createFHIRError(
                    "Duplicate entry",
                    r4:ERROR,
                    r4:PROCESSING_DUPLICATE,
                    diagnostic = string `Already there is a ValueSet exists in the registry with the URL: ${url}`,
                    errorType = r4:VALIDATION_ERROR,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
    }
    r4:FHIRError? result = (<Terminology>terminology).addValueSet(valueSet.clone());
    if result is r4:FHIRError {
        return result;
    }
}
