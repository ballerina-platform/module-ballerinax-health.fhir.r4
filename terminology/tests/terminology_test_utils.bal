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
import ballerina/io;
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

    function init() {
        // Add a CodeSystem object for http://xyz.org
        r4:CodeSystem csXyz = {
            id: "cs-xyz",
            status: "active",
            url: "http://xyz.org",
            version: "2.36",
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
            version: "2.36",
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
            version: "1.0.0",
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
        r4:ValueSet vs1 = {id: "vs1", status: "active", url: "http://example.org/vs1", version: "1.0.0", compose: {include: []}};
        vs1.compose.include = [{valueSet: ["http://example.org/vs2"]}];
        r4:ValueSet vs2 = {id: "vs2", status: "active", url: "http://example.org/vs2", version: "1.0.0", compose: {include: []}};
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
        r4:ValueSet vs4 = {id: "vs4", status: "active", url: "http://example.org/vs4", version: "1.0.0", compose: {include: []}};
        vs4.compose.include = [{valueSet: ["http://example.org/vs3"]}];
        lock {
            self.valueSetMap["http://example.org/vs1"] = vs1.clone();
            self.valueSetMap["http://example.org/vs2"] = vs2.clone();
            self.valueSetMap["http://example.org/vs3"] = vs3.clone();
            self.valueSetMap["http://example.org/vs4"] = vs4.clone();
            self.codeSystemMap["http://loinc.org"] = csLoinc.clone();
            self.codeSystemMap["http://xyz.org"] = csXyz.clone();
            self.codeSystemMap["http://example.org/recursive-codesystem"] = csRecursive.clone();
        }
    }

    public isolated function addCodeSystem(r4:CodeSystem codeSystem) returns r4:FHIRError? {
        return;
    }

    public isolated function addValueSet(r4:ValueSet valueSet) returns r4:FHIRError? {
        return;
    }

    public isolated function findCodeSystem(r4:uri? system, string? id, string? version) returns r4:CodeSystem|r4:FHIRError {
        r4:CodeSystem codeSystem = {content: "example", status: "unknown"};
        return codeSystem;
    }

    public isolated function findConcept(r4:uri system, r4:code code, string? version) returns CodeConceptDetails|r4:FHIRError {
        r4:CodeSystemConcept concept = {code: "example", display: "example"};
        return {concept: concept, url: "http://example.org/vs1"};
    }

    public isolated function findValueSet(r4:uri? system, string? id, string? version) returns r4:ValueSet|r4:FHIRError {
        lock {
            if self.valueSetMap.hasKey(system.toString()) {
                return <r4:ValueSet>self.valueSetMap[system.toString()].clone();
            }
        }
        r4:ValueSet valueSet = {status: "unknown"};
        return valueSet;
    }

    public isolated function isCodeSystemExist(r4:uri system, string version) returns boolean {
        return false;
    }

    public isolated function isValueSetExist(r4:uri system, string version) returns boolean {
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
}

