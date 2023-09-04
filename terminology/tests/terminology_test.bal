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

import ballerina/test;
import ballerinax/health.fhir.r4.international401 as i4;
import ballerinax/health.fhir.r4;

@test:Config {
    groups: ["coding", "create_coding", "successful_scenario"]
}
function createCoding1() {
    r4:code code = "inactive";
    r4:Coding|r4:FHIRError actualCoding = terminologyProcessor.createCoding("http://hl7.org/fhir/account-status", code);
    r4:Coding expectedCoding = {system: "http://hl7.org/fhir/account-status", code: "inactive", display: "Inactive"};
    test:assertEquals(actualCoding, expectedCoding);
}

@test:Config {
    groups: ["coding", "create_coding", "failure_scenario"]
}
function createCoding2() {
    r4:code code = "inactive2";
    string system = "http://hl7.org/fhir/account-status";
    r4:Coding|r4:FHIRError actualCoding = terminologyProcessor.createCoding(system, code);
    test:assertEquals((<r4:FHIRError>actualCoding).message(), string `Code : ${code} not found in system : ${system}`);
}

@test:Config {
    groups: ["coding", "create_coding", "failure_scenario"]
}
function createCoding3() {
    r4:code code = "inactive";
    string incorrectSystem = "http://hl7.org/fhir/account-status1";
    r4:Coding|r4:FHIRError actualCoding = terminologyProcessor.createCoding(incorrectSystem, code);
    test:assertEquals((<r4:FHIRError>actualCoding).message(), string `Unknown ValueSet or CodeSystem : ${incorrectSystem}`);
}

@test:Config {
    groups: ["coding", "create_coding", "failure_scenario"]
}
function createCoding4() {
    r4:code code = "inactive";
    string system = "http://hl7.org/fhir/account-status";
    string incorrectVersion = "5.3.0";
    r4:Coding|r4:FHIRError actualCoding = terminologyProcessor.createCoding(system, code, version = incorrectVersion);
    test:assertEquals((<r4:FHIRError>actualCoding).message(), string `Unknown ValueSet or CodeSystem : ${system}`);
}

@test:Config {
    groups: ["codeableconcept", "create_codeableconcept", "successful_scenario"]
}
function createCodeableconcept1() {
    r4:code code = "inactive";
    string system = "http://hl7.org/fhir/account-status";

    r4:CodeableConcept|r4:FHIRError actualCC = terminologyProcessor.createCodeableConcept(system, code);
    r4:CodeableConcept expectedCC = {
        coding: [
            {system: "http://hl7.org/fhir/account-status", code: "inactive", display: "Inactive"}
        ],
        text: "This account is inactive and should not be used to track financial information."
    };
    test:assertEquals(actualCC, expectedCC);
}

@test:Config {
    groups: ["codeableconcept", "create_codeableconcept", "failure_scenario"]
}
function createCodeableconcept2() {
    r4:code incorrectCode = "inactive2";
    string system = "http://hl7.org/fhir/account-status";

    r4:CodeableConcept|r4:FHIRError actualCC = terminologyProcessor.createCodeableConcept(system, incorrectCode);
    test:assertEquals((<r4:FHIRError>actualCC).message(), string `Code : ${incorrectCode} not found in system : ${system}`);
}

@test:Config {
    groups: ["codeableconcept", "create_codeableconcept", "failure_scenario"]
}
function createCodeableconcept3() {
    r4:code code = "inactive";
    string incorrectSystem = "http://hl7.org/fhir/account-status2";

    r4:CodeableConcept|r4:FHIRError actualCC = terminologyProcessor.createCodeableConcept(incorrectSystem, code);
    test:assertEquals((<r4:FHIRError>actualCC).message(), string `Unknown ValueSet or CodeSystem : ${incorrectSystem}`);
}

@test:Config {
    groups: ["codeableconcept", "create_codeableconcept", "failure_scenario"]
}
function createCodeableconcept4() {
    r4:code code = "inactive";
    string system = "http://hl7.org/fhir/account-status";
    string incorrectVersion = "5.3.0";

    r4:CodeableConcept|r4:FHIRError actualCC = terminologyProcessor.createCodeableConcept(system, code, version = incorrectVersion);
    test:assertEquals((<r4:FHIRError>actualCC).message(), string `Unknown ValueSet or CodeSystem : ${system}`);
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "successful_scenario"]
}
function getByIdCodeSystemTest1() {
    string id = "action-condition-kind";
    string version = "4.0.1";

    r4:CodeSystem expectedCS = returnCodeSystemData("action-condition-kind");

    r4:CodeSystem|r4:FHIRError actualCS = terminologyProcessor.readCodeSystemById(id, version);
    test:assertEquals(actualCS, expectedCS);
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "successful_scenario"]
}
function getByIdCodeSystemTest2() {
    string id = "action-condition-kind";

    r4:CodeSystem expectedCS = returnCodeSystemData("action-condition-kind");
    r4:CodeSystem|r4:FHIRError actualCS = terminologyProcessor.readCodeSystemById(id);
    test:assertEquals(actualCS, expectedCS);
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "failure_scenario"]
}
function getByIdCodeSystemTest3() {
    string id = "action-condition-kind";
    string incorrectVersion = "5.3.0";

    r4:CodeSystem|r4:FHIRError actualCS = terminologyProcessor.readCodeSystemById(id, incorrectVersion);
    r4:FHIRError err = <r4:FHIRError>actualCS;
    test:assertEquals(err.message(), string `Unknown version: '5.3.0' due to There is CodeSystem in the registry with Id: '${id}' but can not find version: '${incorrectVersion}' of it`, "Mismatching error message");
    test:assertEquals(err.detail().issues[0].diagnostic, string `There is CodeSystem in the registry with Id: '${id}' but can not find version: '${incorrectVersion}' of it`, "Mismatching error diagonistic");
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "failure_scenario"]
}
function getByIdCodeSystemTest4() {
    string incorrectId = "account-status2";
    string version = "5.3.0";

    r4:CodeSystem|r4:FHIRError codeSystem4 = terminologyProcessor.readCodeSystemById(incorrectId, version);
    test:assertEquals((<r4:FHIRError>codeSystem4).message(), string `Unknown CodeSystem: '${incorrectId}'`);
}

@test:Config {
    groups: ["valueset", "get_by_id_valueset", "successful_scenario"]
}
function getByIdValueSetTest1() {
    string id = "relationship";
    string version = "4.0.1";

    r4:ValueSet expectedVS = returnValueSetData(id);
    r4:ValueSet|r4:FHIRError actaulVS = terminologyProcessor.readValueSetById(id, version);
    test:assertEquals(actaulVS, expectedVS);
}

@test:Config {
    groups: ["valueset", "get_by_id_valueset", "successful_scenario"]
}
function getByIdValueSetTest2() {
    string id = "relationship";

    r4:ValueSet expectedVS = returnValueSetData(id);
    r4:ValueSet|r4:FHIRError|r4:ValueSet[] actaulVS = terminologyProcessor.readValueSetById(id);
    test:assertEquals(actaulVS, expectedVS);
}

@test:Config {
    groups: ["valueset", "get_by_id_valueset", "failure_scenario"]
}
function getByIdValueSetTest3() {
    string id = "relationship";
    string incorrectVersion = "5.3.0";

    r4:ValueSet|r4:FHIRError|r4:ValueSet[] actaulVS = terminologyProcessor.readValueSetById(id, incorrectVersion);
    r4:FHIRError err = <r4:FHIRError>actaulVS;
    test:assertEquals(err.message(), string `Unknown version: '${incorrectVersion}' due to There is ValueSet in the registry with Id: '${id}' but can not find version: '${incorrectVersion}' of it`, "Mismatching error message");
    test:assertEquals(err.detail().issues[0].diagnostic, string `There is ValueSet in the registry with Id: '${id}' but can not find version: '${incorrectVersion}' of it`, "Mismatching error diagonistic");
}

@test:Config {
    groups: ["valueset", "get_by_id_valueset", "failure_scenario"]
}
function getByIdValueSetTest4() {
    string incorrectId = "relationship2";
    string version = "4.3.0";

    i4:ValueSet|r4:FHIRError|i4:ValueSet[] actaulVS = terminologyProcessor.readValueSetById(incorrectId, version);
    test:assertEquals((<r4:FHIRError>actaulVS).message(), string `Unknown ValueSet: '${incorrectId}'`);
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest1() {
    string id = "action-condition-kind";
    map<r4:RequestSearchParameter[]> searchParameters = {"url": [{name: "url", value: "http://hl7.org/fhir/action-condition-kind", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:URI}]};

    i4:CodeSystem[]|r4:FHIRError actualCS = terminologyProcessor.searchCodeSystems(searchParameters);
    i4:CodeSystem expectedCS = returnCodeSystemData(id);
    if actualCS is i4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 1);
        test:assertEquals(actualCS[0], expectedCS);
    } else {
        test:assertEquals(actualCS, expectedCS);
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest2() {
    string id = "action-condition-kind";
    map<r4:RequestSearchParameter[]> searchParameters = {"_id": [{name: "_id", value: id, typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}]};

    i4:CodeSystem[]|r4:FHIRError actualCS = terminologyProcessor.searchCodeSystems(searchParameters);
    i4:CodeSystem expectedCS = returnCodeSystemData(id);
    if actualCS is i4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 1);
        test:assertEquals(actualCS[0], expectedCS);
    } else {
        test:assertEquals(actualCS, expectedCS);
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest3() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "version": [{name: "version", value: "4.0.1", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}],
        "_count": [{name: "_count", value: "300", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:CodeSystem[]|r4:FHIRError actualCS = terminologyProcessor.searchCodeSystems(searchParameters);
    if actualCS is i4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 256);
    } else {
        test:assertFail(actualCS.message());
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest4() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "version": [{name: "version", value: "4.0.1", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}],
        "_count": [{name: "_count", value: "300", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "200", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:CodeSystem[]|r4:FHIRError actualCS = terminologyProcessor.searchCodeSystems(searchParameters);
    if actualCS is i4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 56);
    } else {
        test:assertFail(actualCS.message());
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest5() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "status": [{name: "status", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:REFERENCE}],
        "_count": [{name: "_count", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "0", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:CodeSystem[]|r4:FHIRError actualCS = terminologyProcessor.searchCodeSystems(searchParameters);
    if actualCS is i4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 43);
    } else {
        test:assertFail(actualCS.message());
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest6() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "status": [{name: "status", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:REFERENCE}],
        "_count": [{name: "_count", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:CodeSystem[]|r4:FHIRError actualCS = terminologyProcessor.searchCodeSystems(searchParameters);
    if actualCS is i4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 0);
    } else {
        test:assertFail(actualCS.message());
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest7() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "status": [
            {name: "status", value: "draft", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:REFERENCE},
            {name: "status", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:REFERENCE}
        ],
        "_count": [{name: "_count", value: "300", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:CodeSystem[]|r4:FHIRError actualCS = terminologyProcessor.searchCodeSystems(searchParameters);
    if actualCS is i4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 258);
    } else {
        test:assertFail(actualCS.message());
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest8() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "_count": [{name: "_count", value: "300", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:CodeSystem[]|r4:FHIRError actualCS = terminologyProcessor.searchCodeSystems(searchParameters);
    if actualCS is i4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 258);
    } else {
        test:assertFail(actualCS.message());
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "successful_scenario"]
}
function searchValueSetTest1() {
    string id = "relationship";
    map<r4:RequestSearchParameter[]> searchParameters = {"url": [{name: "url", value: "http://hl7.org/fhir/ValueSet/relationship", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:URI}]};

    i4:ValueSet[]|r4:FHIRError actualVS = terminologyProcessor.searchValueSets(searchParameters);
    i4:ValueSet expectedVS = returnValueSetData(id);
    if actualVS is i4:ValueSet[] {
        test:assertEquals(actualVS.length(), 1);
        test:assertEquals(actualVS[0], expectedVS);
    } else {
        test:assertEquals(actualVS, expectedVS);
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "successful_scenario"]
}
function searchValueSetTest2() {
    string id = "relationship";
    map<r4:RequestSearchParameter[]> searchParameters = {"url": [{name: "url", value: "http://hl7.org/fhir/ValueSet/relationship", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:URI}]};

    i4:ValueSet[]|r4:FHIRError actualVS = terminologyProcessor.searchValueSets(searchParameters);
    i4:ValueSet expectedVS = returnValueSetData(id);
    if actualVS is i4:ValueSet[] {
        test:assertEquals(actualVS.length(), 1);
        test:assertEquals(actualVS[0], expectedVS);
    } else {
        test:assertEquals(actualVS, expectedVS);
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "successful_scenario"]
}
function searchValueSetTest3() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "version": [{name: "version", value: "4.0.1", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}],
        "_count": [{name: "_count", value: "300", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:ValueSet[]|r4:FHIRError actualVS = terminologyProcessor.searchValueSets(searchParameters);
    if actualVS is i4:ValueSet[] {
        test:assertEquals(actualVS.length(), 268);
    } else {
        test:assertFail(actualVS.message());
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "successful_scenario"]
}
function searchValueSetTest4() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "version": [{name: "version", value: "4.0.1", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}],
        "_count": [{name: "_count", value: "300", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "200", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:ValueSet[]|r4:FHIRError actualVS = terminologyProcessor.searchValueSets(searchParameters);
    if actualVS is i4:ValueSet[] {
        test:assertEquals(actualVS.length(), 68);
    } else {
        test:assertFail(actualVS.message());
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "successful_scenario"]
}
function searchValueSetTest5() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "status": [{name: "status", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:REFERENCE}],
        "_count": [{name: "_count", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "0", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:ValueSet[]|r4:FHIRError actualVS = terminologyProcessor.searchValueSets(searchParameters);
    if actualVS is i4:ValueSet[] {
        test:assertEquals(actualVS.length(), 50);
    } else {
        test:assertFail(actualVS.message());
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "successful_scenario"]
}
function searchValueSetTest6() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "status": [{name: "status", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:REFERENCE}],
        "_count": [{name: "_count", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "70", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    i4:ValueSet[]|r4:FHIRError actualVS = terminologyProcessor.searchValueSets(searchParameters);
    if actualVS is i4:ValueSet[] {
        test:assertEquals(actualVS.length(), 0);
    } else {
        test:assertFail(actualVS.message());
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "successful_scenario"]
}
function codeSystemLookupTest1() {
    r4:code code = "inactive";
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .codeSystemLookUp(code, system = "http://hl7.org/fhir/account-status");
    i4:CodeSystem expectedCS = returnCodeSystemData("account-status");

    foreach i4:CodeSystemConcept c in <i4:CodeSystemConcept[]>expectedCS.concept {
        if c.code == code {
            test:assertEquals(actualConcept, c);
        }
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "successful_scenario"]
}
function codeSystemLookupTest2() returns error? {
    r4:Coding coding = check terminologyProcessor.createCoding("http://hl7.org/fhir/account-status", "inactive");
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .codeSystemLookUp(coding, system = "http://hl7.org/fhir/account-status");
    i4:CodeSystem expectedCS = returnCodeSystemData("account-status");

    foreach i4:CodeSystemConcept c in <i4:CodeSystemConcept[]>expectedCS.concept {
        if c.code == coding.code {
            test:assertEquals(actualConcept, c);
        }
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "successful_scenario"]
}
function codeSystemLookupTest3() returns error? {
    r4:code code = "inactive";
    r4:CodeableConcept codeableConcept = check terminologyProcessor.createCodeableConcept("http://hl7.org/fhir/account-status", code);
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .codeSystemLookUp(codeableConcept, system = "http://hl7.org/fhir/account-status");
    i4:CodeSystem expectedCS = returnCodeSystemData("account-status");

    foreach i4:CodeSystemConcept c in <i4:CodeSystemConcept[]>expectedCS.concept {
        if c.code == code {
            test:assertEquals(actualConcept, c);
        }
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest4() returns error? {
    r4:code code = "inactive";
    string system = "http://hl7.org/fhir/account-status2|4.3.0";
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .codeSystemLookUp(code, system = system);

    test:assertEquals((<r4:FHIRError>actualConcept).message(),
            string `Cannot find a CodeSystem for the provided system URL: ${system}`);
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest5() returns error? {
    r4:code code = "inactive";
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .codeSystemLookUp(code);

    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Can not find a CodeSystem due to Either CodeSystem record or system URL should be provided as input");
    test:assertEquals((<r4:FHIRError>actualConcept).detail().issues[0].diagnostic, "Either CodeSystem record or system URL should be provided as input");
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest6() returns error? {
    r4:code code = "inactive2";
    string id = "account-status";
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .codeSystemLookUp(code, system = "http://hl7.org/fhir/account-status");

    test:assertEquals((<r4:FHIRError>actualConcept).message(), string `Can not find any valid concepts for the code: "${code}" in CodeSystem: "${id}"`);
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest1() {
    r4:code code = "1";
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .valueSetLookUp(code, system = "http://hl7.org/fhir/ValueSet/relationship");
    i4:CodeSystem expectedVS = returnCodeSystemData("relationship");

    foreach i4:CodeSystemConcept c in <i4:CodeSystemConcept[]>expectedVS.concept {
        if c.code == code {
            test:assertEquals(actualConcept, c);
        }
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest2() returns error? {
    r4:Coding coding = check terminologyProcessor.createCoding("http://hl7.org/fhir/relationship", "1");
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .valueSetLookUp(coding, system = "http://hl7.org/fhir/ValueSet/relationship");
    i4:CodeSystem expectedVS = returnCodeSystemData("relationship");

    foreach i4:CodeSystemConcept c in <i4:CodeSystemConcept[]>expectedVS.concept {
        if c.code == coding.code {
            test:assertEquals(actualConcept, c);
        }
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest3() returns error? {
    r4:code code = "start";
    r4:CodeableConcept codeableConcept = check terminologyProcessor.createCodeableConcept("http://hl7.org/fhir/action-condition-kind", code);
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .valueSetLookUp(codeableConcept, system = "http://hl7.org/fhir/ValueSet/action-condition-kind");
    i4:CodeSystem expectedVS = returnCodeSystemData("action-condition-kind");

    foreach i4:CodeSystemConcept c in <i4:CodeSystemConcept[]>expectedVS.concept {
        if c.code == code {
            test:assertEquals(actualConcept, c);
        }
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest4() returns error? {
    r4:code code = "1";
    string system = "http://hl7.org/fhir/ValueSet/relationship2|4.3.0";
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .valueSetLookUp(code, system = system);

    test:assertEquals((<r4:FHIRError>actualConcept).message(),
            string `Cannot find a ValueSet for the provided system URL: ${system}`);
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest5() returns error? {
    r4:code code = "1";
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .valueSetLookUp(code);

    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Can not find a ValueSet due to Either ValueSet record or system URL should be provided as input");
    test:assertEquals((<r4:FHIRError>actualConcept).detail().issues[0].diagnostic, "Either ValueSet record or system URL should be provided as input");
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest6() returns error? {
    r4:code code = "test";
    string id = "relationship";
    i4:CodeSystemConcept[]|i4:CodeSystemConcept|r4:FHIRError actualConcept = terminologyProcessor
                                                .valueSetLookUp(code, system = "http://hl7.org/fhir/ValueSet/relationship");

    test:assertEquals((<r4:FHIRError>actualConcept).message(), string `Can not find any valid concepts for the code: "${code}" in ValueSet: "${id}"`);
}

@test:Config {
    groups: ["valueset", "valueset_expansion", "successful_scenario"]
}
function valueSetExpansionTest1() {
    i4:ValueSet|r4:FHIRError valueSet = terminologyProcessor.readValueSetById("relationship");
    map<r4:RequestSearchParameter[]> searchParameters1 = {
        "valueSetVersion": [{name: "valueSetVersion", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}],
        "_count": [{name: "_count", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };
    if valueSet is i4:ValueSet {
        i4:ValueSet|r4:FHIRError actualVS = terminologyProcessor.
                                        valueSetExpansion(searchParameters1,
                                        system = "http://hl7.org/fhir/ValueSet/relationship");
        if actualVS is i4:ValueSet {
            i4:ValueSet expectedVS = returnValueSetData("expanded-relationship");
            i4:ValueSetExpansion? expansion = actualVS.expansion;
            expectedVS.expansion.timestamp = (<i4:ValueSetExpansion>expansion).timestamp;
            test:assertEquals(actualVS, expectedVS);
        }
    }
}

@test:Config {
    groups: ["valueset", "valueset_expansion", "successful_scenario"]
}
function valueSetExpansionTest2() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "filter": [{name: "filter", value: "account", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}]
    };
    i4:ValueSet|r4:FHIRError actualVS = terminologyProcessor.
                                        valueSetExpansion(searchParameters,
                                        system = "http://hl7.org/fhir/ValueSet/account-status");
    if actualVS is i4:ValueSet {
        i4:ValueSet expectedVS = returnValueSetData("expanded-account-status");
        i4:ValueSetExpansion? expansion = actualVS.expansion;
        expectedVS.expansion.timestamp = (<i4:ValueSetExpansion>expansion).timestamp;
        test:assertEquals(actualVS, expectedVS);
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "successful_scenario"]
}
function codesystemSubsumeTest1() returns error? {
    r4:code codeA = "inactive";
    r4:code codeB = "inactive";
    i4:CodeSystem codeSystem = check terminologyProcessor.readCodeSystemById("account-status");
    i4:Parameters actaulResult = check terminologyProcessor.subsumes(codeA, codeB, codeSystem);
    i4:ParametersParameter actual = (<i4:ParametersParameter[]>actaulResult.'parameter)[0];
    test:assertEquals(actual.name, "outcome");
    test:assertEquals(actual.valueCode, "equivalent");
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "successful_scenario"]
}
function codesystemSubsumeTest2() returns error? {
    r4:Coding codingA = check terminologyProcessor.createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Coding codingB = check terminologyProcessor.createCoding("http://hl7.org/fhir/account-status", "inactive");
    i4:Parameters actaulResult = check terminologyProcessor.subsumes(codingA, codingB, system = "http://hl7.org/fhir/account-status");
    i4:ParametersParameter actual = (<i4:ParametersParameter[]>actaulResult.'parameter)[0];
    test:assertEquals(actual.name, "outcome");
    test:assertEquals(actual.valueCode, "equivalent");
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "successful_scenario"]
}
function addCodeSystem1() {
    json data = readJsonData("code_systems/additional-codesystem-data");
    string duplicateEntryUrl = "http://hl7.org/fhir/action-grouping-behavior";

    r4:FHIRError[]? actual = terminologyProcessor.addCodeSystemsAsJson(<json[]>data);

    if actual is r4:FHIRError[] && actual.length() > 1 {
        test:assertEquals(actual[0].message(), "Duplicate entry");
        test:assertEquals(actual[0].detail().issues[0].diagnostic, string `Already there is a CodeSystem exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "successful_scenario"]
}
function addValueset1() {
    json data = readJsonData("value_sets/additional-valueset-data");
    string duplicateEntryUrl = "http://hl7.org/fhir/ValueSet/diagnostic-report-status";

    r4:FHIRError[]? actual = terminologyProcessor.addValueSetsAsJson(<json[]>data);

    if actual is r4:FHIRError[] {
        test:assertEquals(actual[0].message(), "Duplicate entry due to Already there is a ValueSet exists in the registry with the URL: http://hl7.org/fhir/ValueSet/diagnostic-report-status");
        test:assertEquals(actual[0].detail().issues[0].diagnostic, string `Already there is a ValueSet exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}
