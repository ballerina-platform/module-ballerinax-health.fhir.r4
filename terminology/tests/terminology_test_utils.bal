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
import ballerina/io;
import ballerina/lang.regexp;
import ballerina/test;
import ballerinax/health.fhir.r4;

function returnCodeSystemData(string fileName) returns r4:CodeSystem {
    string filePath = string `tests/resources/terminology/code_systems/${fileName}.json`;
    json|error data = io:fileReadJson(filePath);

    if data is json {
        r4:CodeSystem|error temp = data.cloneWithType(r4:CodeSystem);
        if temp is r4:CodeSystem {
            return temp;
        } else {
            test:assertFail("Can not parse the CodeSystem record");
        }
    } else {
        test:assertFail(string `Can not load data from: ${filePath}`);
    }
}

function returnValueSetData(string fileName) returns r4:ValueSet {
    string filePath = string `tests/resources/terminology/value_sets/${fileName}.json`;
    json|error data = io:fileReadJson(filePath);

    if data is json {
        r4:ValueSet|error temp = data.cloneWithType(r4:ValueSet);
        if temp is r4:ValueSet {
            return temp;
        } else {
            test:assertFail("Can not parse the ValueSet record");
        }
    } else {
        test:assertFail(string `Can not load data from: ${filePath}`);
    }
}

function readJsonData(string fileName) returns json {
    string filePath = string `tests/resources/terminology/${fileName}.json`;
    json|error data = io:fileReadJson(filePath);

    if data is json {
        return data;
    } else {
        test:assertFail(string `Can not load data from: ${filePath}`);
    }
}

isolated class TestTerminology {
    *Terminology;
    # Global records to store Terminologies across different profiles and packages.
    private map<r4:CodeSystem> codeSystemMap = {};
    private map<r4:ValueSet> valueSetMap = {};
    private map<r4:ConceptMap> conceptMap = {};

    function init() {
        // Add a CodeSystem object for http://xyz.org
        r4:CodeSystem csXyz = {
            id: "cs-xyz",
            status: "active",
            url: "http://xyz.org",
            'version: "2.36",
            content: "complete",
            concept: [
                {code: "1", display: "Cholesterol xyz [Moles/Volume]"},
                {code: "2", display: "Cholesterol xyz [Mass/Volume]"}
            ]
        };
        // Add a CodeSystem object with the given concepts and extra concepts
        r4:CodeSystem csLoinc = {
            id: "loinc",
            status: "active",
            url: "http://loinc.org",
            'version: "2.36",
            content: "complete",
            concept: [
                {code: "1", display: "Cholesterol [Moles/Volume]"},
                {code: "2", display: "Cholesterol [Mass/Volume]"},
                {code: "3", display: "Triglyceride [Moles/Volume]"},
                {code: "4", display: "Triglyceride [Mass/Volume]"},
                {code: "5", display: "HDL Cholesterol [Moles/Volume]"}
            ]
        };
        r4:CodeSystem csRecursive = {
            id: "cs-recursive",
            status: "active",
            url: "http://example.org/recursive-codesystem",
            'version: "1.0.0",
            content: "complete",
            concept: [
                {
                    code: "A",
                    display: "Parent A",
                    concept: [
                        {
                            code: "A1",
                            display: "Child A1",
                            concept: [
                                {
                                    code: "A1a",
                                    display: "Grandchild A1a"
                                }
                            ]
                        },
                        {
                            code: "A2",
                            display: "Child A2"
                        }
                    ]
                },
                {
                    code: "B",
                    display: "Parent B"
                }
            ]
        };
        r4:ValueSet vs1 = {id: "vs1", status: "active", url: "http://example.org/vs1", 'version: "1.0.0", compose: {include: []}};
        vs1.compose.include = [{valueSet: ["http://example.org/vs2"]}];
        r4:ValueSet vs2 = {id: "vs2", status: "active", url: "http://example.org/vs2", 'version: "1.0.0", compose: {include: []}};
        vs2.compose.include = [
            {
                "system": "http://loinc.org",
                "version": "2.36",
                "concept": [
                    {
                        "code": "1",
                        "display": "Cholesterol [Moles/Volume]"
                    },
                    {
                        "code": "2",
                        "display": "Cholesterol [Mass/Volume]"
                    }

                ]
            }
        ];
        r4:ValueSet vs3 = {id: "vs3", status: "active", url: "http://example.org/vs3", version: "1.0.0", compose: {include: []}};
        vs3.compose.include = [
            {
                "system": "http://loinc.org",
                "version": "2.36",
                "concept": [
                    {
                        "code": "1",
                        "display": "Cholesterol [Moles/Volume]"
                    },
                    {
                        "code": "2",
                        "display": "Cholesterol [Mass/Volume]"
                    }

                ]
            },
            {
                "system": "http://xyz.org",
                "version": "2.36",
                "concept": [
                    {
                        "code": "1",
                        "display": "Cholesterol xyz [Moles/Volume]"
                    },
                    {
                        "code": "2",
                        "display": "Cholesterol xyz [Mass/Volume]"
                    }

                ]
            }
        ];
        r4:ValueSet vs4 = {id: "vs4", status: "active", url: "http://example.org/vs4", 'version: "1.0.0", compose: {include: []}};
        vs4.compose.include = [{valueSet: ["http://example.org/vs3"]}];
        lock {
            self.valueSetMap["http://example.org/vs1"] = vs1.clone();
            self.valueSetMap["http://example.org/vs2"] = vs2.clone();
            self.valueSetMap["http://example.org/vs3"] = vs3.clone();
            self.valueSetMap["http://example.org/vs4"] = vs4.clone();
            self.valueSetMap["http://hl7.org/fhir/ValueSet/account-status"] = vs5.clone();
            self.valueSetMap["http://hl7.org/fhir/ValueSet/resource-status"] = vs6.clone();
            self.valueSetMap["http://hl7.org/fhir/ValueSet/administrative-gender"] = vs7.clone();
            self.valueSetMap["http://terminology.hl7.org/ValueSet/v2-0001"] = vs8.clone();
            self.valueSetMap["http://hl7.org/fhir/ValueSet/fixed1"] = vs9.clone();
            self.valueSetMap["http://hl7.org/fhir/ValueSet/fixed2"] = vs10.clone();
            self.valueSetMap["http://hl7.org/fhir/ValueSet/provided1"] = vs11.clone();
            self.valueSetMap["http://hl7.org/fhir/ValueSet/provided2"] = vs12.clone();
            self.valueSetMap["http://example.org/fhir/example1"] = vs13.clone();
            self.valueSetMap["http://example.org/fhir/example2"] = vs14.clone();
            self.valueSetMap["http://example.org/fhir/otherMapexample1"] = vs15.clone();
            self.valueSetMap["http://example.org/fhir/otherMapexample1"] = vs16.clone();
            self.codeSystemMap["http://loinc.org"] = csLoinc.clone();
            self.codeSystemMap["http://xyz.org"] = csXyz.clone();
            self.codeSystemMap["http://example.org/recursive-codesystem"] = csRecursive.clone();
            self.conceptMap["http://hl7.org/fhir/ConceptMap/sc-account-status"] = testConceptMap1.clone();
            self.conceptMap["http://hl7.org/fhir/ConceptMap/cm-administrative-gender-v2"] = testConceptMap2.clone();
            self.conceptMap["http://example.org/cm3"] = unmappedConceptMapFixed.clone();
            self.conceptMap["http://example.org/cm4"] = unmappedConceptMapProvided.clone();
            self.conceptMap["http://hl7.org/fhir/ConceptMap/example2"] = unmappedConceptMapOtherMap.clone();
            self.conceptMap["http://example.org/fhir/ConceptMap/map2"] = otherMap.clone();
            self.conceptMap["http://example.org/fhir/ConceptMap/map2-2"] = otherMap2.clone();
            self.conceptMap["http://example.org/fhir/ConceptMap/map2-3"] = otherMap3.clone();
            self.conceptMap["http://example.org/fhir/ConceptMap/map2-4"] = otherMap4.clone();
            self.conceptMap["http://hl7.org/fhir/ConceptMap/sc-account-status2"] = testConceptMap1WithDifferentCodes.clone();
            self.conceptMap["http://hl7.org/fhir/ConceptMap/cm-address-type-v3"] = sampleSearchConceptMap.clone();
        }
    }

    public isolated function addCodeSystem(r4:CodeSystem codeSystem) returns r4:FHIRError? {
        return inMemoryTerminology.addCodeSystem(codeSystem);
    }

    public isolated function addValueSet(r4:ValueSet valueSet) returns r4:FHIRError? {
        return;
    }

    public isolated function findCodeSystem(r4:uri? system, string? id, string? version) returns r4:CodeSystem|r4:FHIRError {
        lock {
            // Search by system (URL) if provided
            if system is r4:uri {
                string systemKey = system.toString();
                if self.codeSystemMap.hasKey(systemKey) {
                    r4:CodeSystem cs = <r4:CodeSystem>self.codeSystemMap[systemKey];
                    if 'version is () || (cs.version is string && cs.version == version) {
                        return cs.clone();
                    }
                }
            }
            // If not found by system, search by id if provided
            if id is string {
                foreach var [_, csValue] in self.codeSystemMap.entries() {
                    r4:CodeSystem cs = <r4:CodeSystem>csValue;
                    if cs.id is string && cs.id == id {
                        if 'version is () || (cs.version is string && cs.version == version) {
                            return cs.clone();
                        }
                    }
                }
            }
        }
        return r4:createFHIRError(
            string `CodeSystem not found for system: ${system is r4:uri ? system.toString() : ""}${id is string ? ", id: " + id : ""}${'version == () ? "" : "|" + version}`,
            r4:ERROR,
            r4:PROCESSING_NOT_FOUND,
            errorType = r4:PROCESSING_ERROR,
            httpStatusCode = http:STATUS_NOT_FOUND
        );
    }

    // for the findConcept() use the same implementation which used in inmemory terminology source
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
            } else if conceptResults is CodeConceptDetails[] {
                // found the concept in the ValueSet
                return conceptResults[0];
            } else {
                result = <r4:FHIRError>conceptResults;
            }
        } else {
            r4:CodeSystem|r4:FHIRError findCodeSystemResult = self.findCodeSystem(system, (), version);
            if findCodeSystemResult is r4:CodeSystem {
                result = findConceptInCodeSystem(findCodeSystemResult, code);

                if result is r4:FHIRError {
                    result = r4:createFHIRError(
                        "Concept not found in the ValueSet",
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        errorType = r4:PROCESSING_ERROR,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
                }
            } 
        }
        if result is () {
            return r4:createFHIRError(
                string `Unknown ValueSet or CodeSystem : ${system}${'version == () ? "" : "|" + version}`,
                r4:ERROR,
                r4:INVALID_REQUIRED,
                errorType = r4:PROCESSING_ERROR,
                httpStatusCode = http:STATUS_NOT_FOUND
            );
        }
        return result.clone();
    }

    public isolated function findValueSet(r4:uri? system, string? id, string? version) returns r4:ValueSet|r4:FHIRError {
        lock {
            if self.valueSetMap.hasKey(system.toString()) {
                return <r4:ValueSet>self.valueSetMap[system.toString()].clone();
            }
        }
        
        return r4:createFHIRError(
            string `ValueSet not found`,
            r4:ERROR,
            r4:PROCESSING_NOT_FOUND,
            errorType = r4:PROCESSING_ERROR,
            httpStatusCode = http:STATUS_NOT_FOUND
        );
    }

    public isolated function isCodeSystemExist(r4:uri system, string 'version) returns boolean {
        return false;
    }

    public isolated function isValueSetExist(r4:uri system, string 'version) returns boolean {
        return false;
    }

    public isolated function searchCodeSystem(map<r4:RequestSearchParameter[]> params, int? offset, int? count) returns r4:CodeSystem[]|r4:FHIRError {
        return [];
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
        return valueSetArray;
    }

    // use same implementation which used in inmemory terminology source
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

    public isolated function getConceptMap(r4:uri? conceptMapUrl, string? version) returns r4:ConceptMap|r4:FHIRError {

        map<r4:ConceptMap> conceptMaps = {};
        lock {
            conceptMaps = self.conceptMap.clone();
        }
        boolean isIdExistInRegistry = false;
        if conceptMapUrl != () {
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

    public isolated function addConceptMap(r4:ConceptMap conceptMap) returns r4:FHIRError? {
        lock {
            self.conceptMap[getKey(<string>conceptMap.url, <string>conceptMap.version)] = conceptMap.clone();
        }
        return ();
    }

    public isolated function searchConceptMap(map<r4:RequestSearchParameter[]> params, int? offset, int? count) returns r4:ConceptMap[]|r4:FHIRError {

        r4:ConceptMap[] conceptMapsArray = [];
        lock {
            conceptMapsArray = self.conceptMap.clone().toArray();
        }

        foreach var searchParam in params.keys() {
            r4:RequestSearchParameter[] searchParamValues = params[searchParam] ?: [];

            r4:ConceptMap[] filteredList = [];
            if searchParamValues.length() != 0 {
                foreach var queriedValue in searchParamValues {
                    r4:ConceptMap[] result = from r4:ConceptMap entry in conceptMapsArray
                        where entry[CONCEPT_MAPS_SEARCH_PARAMS.get(searchParam)] == queriedValue.value
                        select entry;
                    filteredList.push(...result);
                }
                conceptMapsArray = filteredList;
            }
        }
        return conceptMapsArray;
    }

    public isolated function isConceptMapExist(r4:uri system, string 'version) returns boolean {
        return false;
    }

    public isolated function findConceptMaps(r4:uri sourceValueSetUri, r4:uri? targetValueSetUri) returns r4:ConceptMap[]|r4:FHIRError {

        r4:ConceptMap[] conceptMapsArray = [];
        r4:ConceptMap[] matchingConceptMaps = [];
        lock {
            conceptMapsArray = self.conceptMap.clone().toArray();
        }
        
        if targetValueSetUri == () {
            foreach var conceptMap in conceptMapsArray {
                if conceptMap.sourceCanonical == sourceValueSetUri|| conceptMap.sourceUri == sourceValueSetUri {
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
}

