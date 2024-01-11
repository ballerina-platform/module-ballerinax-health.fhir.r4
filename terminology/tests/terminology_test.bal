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
    r4:Coding|r4:FHIRError actualCoding = createCoding("http://hl7.org/fhir/account-status", code);
    r4:Coding expectedCoding = {system: "http://hl7.org/fhir/account-status", code: "inactive", display: "Inactive"};
    test:assertEquals(actualCoding, expectedCoding);
}

@test:Config {
    groups: ["coding", "create_coding", "failure_scenario"]
}
function createCoding2() {
    r4:code code = "inactive2";
    string system = "http://hl7.org/fhir/account-status";
    r4:Coding|r4:FHIRError actualCoding = createCoding(system, code);
    test:assertEquals((<r4:FHIRError>actualCoding).message(), string `Code : ${code} not found in system : ${system}`);
}

@test:Config {
    groups: ["coding", "create_coding", "failure_scenario"]
}
function createCoding3() {
    r4:code code = "inactive";
    string incorrectSystem = "http://hl7.org/fhir/account-status1";
    r4:Coding|r4:FHIRError actualCoding = createCoding(incorrectSystem, code);
    test:assertEquals((<r4:FHIRError>actualCoding).message(), string `Unknown ValueSet or CodeSystem : ${incorrectSystem}`);
}

@test:Config {
    groups: ["coding", "create_coding", "failure_scenario"]
}
function createCoding4() {
    r4:code code = "inactive";
    string system = "http://hl7.org/fhir/account-status";
    string incorrectVersion = "5.3.0";
    r4:Coding|r4:FHIRError actualCoding = createCoding(system, code, version = incorrectVersion);
    test:assertEquals((<r4:FHIRError>actualCoding).message(), string `Unknown ValueSet or CodeSystem : ${system}`);
}

@test:Config {
    groups: ["codeableconcept", "create_codeableconcept", "successful_scenario"]
}
function createCodeableconcept1() {
    r4:code code = "inactive";
    string system = "http://hl7.org/fhir/account-status";

    r4:CodeableConcept|r4:FHIRError actualCC = createCodeableConcept(system, code);
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

    r4:CodeableConcept|r4:FHIRError actualCC = createCodeableConcept(system, incorrectCode);
    test:assertEquals((<r4:FHIRError>actualCC).message(), string `Code : ${incorrectCode} not found in system : ${system}`);
}

@test:Config {
    groups: ["codeableconcept", "create_codeableconcept", "failure_scenario"]
}
function createCodeableconcept3() {
    r4:code code = "inactive";
    string incorrectSystem = "http://hl7.org/fhir/account-status2";

    r4:CodeableConcept|r4:FHIRError actualCC = createCodeableConcept(incorrectSystem, code);
    test:assertEquals((<r4:FHIRError>actualCC).message(), string `Unknown ValueSet or CodeSystem : ${incorrectSystem}`);
}

@test:Config {
    groups: ["codeableconcept", "create_codeableconcept", "failure_scenario"]
}
function createCodeableconcept4() {
    r4:code code = "inactive";
    string system = "http://hl7.org/fhir/account-status";
    string incorrectVersion = "5.3.0";

    r4:CodeableConcept|r4:FHIRError actualCC = createCodeableConcept(system, code, version = incorrectVersion);
    test:assertEquals((<r4:FHIRError>actualCC).message(), string `Unknown ValueSet or CodeSystem : ${system}`);
}

@test:Config {
    groups: ["codesystem", "read_by_url_codesystem", "successful_scenario"]
}
function readByUrlCodeSystemTest1() {
    string url = "http://hl7.org/fhir/action-condition-kind";
    string version = "4.0.1";

    r4:CodeSystem expectedCS = returnCodeSystemData("action-condition-kind");

    r4:CodeSystem|r4:FHIRError actualCS = readCodeSystemByUrl(url, version);
    test:assertEquals(actualCS, expectedCS);
}

@test:Config {
    groups: ["codesystem", "read_by_url_codesystem", "failure_scenario"]
}
function readByUrlCodeSystemTest2() {
    string url = "http://hl7.org/fhir/action-condition-kind22";
    string version = "4.0.1";

    r4:CodeSystem|r4:FHIRError actualCS = readCodeSystemByUrl(url, version);
    test:assertEquals((<r4:FHIRError>actualCS).message(), string `Unknown CodeSystem: '"${url}"'`);
}

@test:Config {
    groups: ["codesystem", "read_by_url_codesystem", "failure_scenario"]
}
function readByUrlCodeSystemTest3() {
    string url = "http://hl7.org/fhir/action-condition-kind";
    string version = "5.0.0";

    r4:CodeSystem|r4:FHIRError actualCS = readCodeSystemByUrl(url, version);
    test:assertEquals((<r4:FHIRError>actualCS).message(), string `Unknown version: '5.0.0' due to There is CodeSystem in the registry with Id: 'http://hl7.org/fhir/action-condition-kind' but can not find version: '5.0.0' of it`);
}

@test:Config {
    groups: ["valueset", "read_by_url_valueset", "successful_scenario"]
}
function readByUrlValueSetTest1() {
    string url = "http://hl7.org/fhir/ValueSet/relationship";
    string version = "4.0.1";

    r4:ValueSet expectedVS = returnValueSetData("relationship");
    r4:ValueSet|r4:FHIRError actaulVS = readValueSetByUrl(url, version);
    test:assertEquals(actaulVS, expectedVS);
}

@test:Config {
    groups: ["valueset", "read_by_url_valueset", "successful_scenario"]
}
function readByUrlValueSetTest2() {
    string url = "http://hl7.org/fhir/ValueSet/relationship";
    string version = "5.0.0";

    r4:ValueSet|r4:FHIRError actaulVS = readValueSetByUrl(url, version);
    if actaulVS is r4:FHIRError {
        test:assertEquals(actaulVS.message(), "Unknown version: '5.0.0' due to There is ValueSet in the registry with Id: 'http://hl7.org/fhir/ValueSet/relationship' but can not find version: '5.0.0' of it");
    }
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "successful_scenario"]
}
function getByIdCodeSystemTest1() {
    string id = "action-condition-kind";
    string version = "4.0.1";

    r4:CodeSystem expectedCS = returnCodeSystemData("action-condition-kind");

    r4:CodeSystem|r4:FHIRError actualCS = readCodeSystemById(id, version);
    test:assertEquals(actualCS, expectedCS);
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "successful_scenario"]
}
function getByIdCodeSystemTest2() {
    string id = "action-condition-kind";

    r4:CodeSystem expectedCS = returnCodeSystemData("action-condition-kind");
    r4:CodeSystem|r4:FHIRError actualCS = readCodeSystemById(id);
    test:assertEquals(actualCS, expectedCS);
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "failure_scenario"]
}
function getByIdCodeSystemTest3() {
    string id = "action-condition-kind";
    string incorrectVersion = "5.3.0";

    r4:CodeSystem|r4:FHIRError actualCS = readCodeSystemById(id, incorrectVersion);
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

    r4:CodeSystem|r4:FHIRError codeSystem4 = readCodeSystemById(incorrectId, version);
    test:assertEquals((<r4:FHIRError>codeSystem4).message(), string `Unknown CodeSystem: '${incorrectId}'`);
}

@test:Config {
    groups: ["valueset", "get_by_id_valueset", "successful_scenario"]
}
function getByIdValueSetTest1() {
    string id = "relationship";
    string version = "4.0.1";

    r4:ValueSet expectedVS = returnValueSetData(id);
    r4:ValueSet|r4:FHIRError actaulVS = readValueSetById(id, version);
    test:assertEquals(actaulVS, expectedVS);
}

@test:Config {
    groups: ["valueset", "get_by_id_valueset", "successful_scenario"]
}
function getByIdValueSetTest2() {
    string id = "relationship";

    r4:ValueSet expectedVS = returnValueSetData(id);
    r4:ValueSet|r4:FHIRError|r4:ValueSet[] actaulVS = readValueSetById(id);
    test:assertEquals(actaulVS, expectedVS);
}

@test:Config {
    groups: ["valueset", "get_by_id_valueset", "failure_scenario"]
}
function getByIdValueSetTest3() {
    string id = "relationship";
    string incorrectVersion = "5.3.0";

    r4:ValueSet|r4:FHIRError|r4:ValueSet[] actaulVS = readValueSetById(id, incorrectVersion);
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

    r4:ValueSet|r4:FHIRError|r4:ValueSet[] actaulVS = readValueSetById(incorrectId, version);
    test:assertEquals((<r4:FHIRError>actaulVS).message(), string `Unknown ValueSet: '${incorrectId}'`);
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest1() {
    string id = "action-condition-kind";
    map<r4:RequestSearchParameter[]> searchParameters = {"url": [{name: "url", value: "http://hl7.org/fhir/action-condition-kind", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:URI}]};

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    r4:CodeSystem expectedCS = returnCodeSystemData(id);
    if actualCS is r4:CodeSystem[] {
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

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    r4:CodeSystem expectedCS = returnCodeSystemData(id);
    if actualCS is r4:CodeSystem[] {
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

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 268);
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

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 68);
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

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 50);
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
        "_offset": [{name: "_offset", value: "40", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 17);
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

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 300);
    } else {
        test:assertFail(actualCS.message());
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest8() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "_count": [{name: "_count", value: "300", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "250", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 253);
    } else {
        test:assertFail(actualCS.message());
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "failure_scenario"]
}
function searchCodeSystemTest9() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "incorrect_param": [{name: "incorrect_param", value: "300", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    if actualCS is r4:FHIRError {
        test:assertEquals(actualCS.message(), string `Invalid search parameter: incorrect_param due to Allowed search parameters: ["_id","name","title","url","version","status","system","description","publisher"]`);
    }
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "failure_scenario"]
}
function searchCodeSystemTest10() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "_count": [{name: "_count", value: "400", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    if actualCS is r4:FHIRError {
        test:assertEquals(actualCS.message(), "Requested size of the response: 400 is too large due to Allowed maximum size of output is: 300; therefore, reduce the value of size parameter accordingly");
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "successful_scenario"]
}
function searchValueSetTest1() {
    string id = "relationship";
    map<r4:RequestSearchParameter[]> searchParameters = {"url": [{name: "url", value: "http://hl7.org/fhir/ValueSet/relationship", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:URI}]};

    r4:ValueSet[]|r4:FHIRError actualVS = searchValueSets(searchParameters);
    r4:ValueSet expectedVS = returnValueSetData(id);
    if actualVS is r4:ValueSet[] {
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

    r4:ValueSet[]|r4:FHIRError actualVS = searchValueSets(searchParameters);
    r4:ValueSet expectedVS = returnValueSetData(id);
    if actualVS is r4:ValueSet[] {
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

    r4:ValueSet[]|r4:FHIRError actualVS = searchValueSets(searchParameters);
    if actualVS is r4:ValueSet[] {
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

    r4:ValueSet[]|r4:FHIRError actualVS = searchValueSets(searchParameters);
    if actualVS is r4:ValueSet[] {
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

    r4:ValueSet[]|r4:FHIRError actualVS = searchValueSets(searchParameters);
    if actualVS is r4:ValueSet[] {
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

    r4:ValueSet[]|r4:FHIRError actualVS = searchValueSets(searchParameters);
    if actualVS is r4:ValueSet[] {
        test:assertEquals(actualVS.length(), 0);
    } else {
        test:assertFail(actualVS.message());
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "failure_scenario"]
}
function searchValueSetTest7() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "incorrect_param": [{name: "incorrect_param", value: "300", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    r4:FHIRError|r4:ValueSet[] actualVS = searchValueSets(searchParameters);
    if actualVS is r4:FHIRError {
        test:assertEquals(actualVS.message(), string `Invalid search parameter: incorrect_param due to Allowed search parameters: ["_id","name","title","url","version","status","description","publisher"]`);
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "failure_scenario"]
}
function searchValueSetTest8() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "_count": [{name: "_count", value: "400", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    r4:FHIRError|r4:ValueSet[] actualVS = searchValueSets(searchParameters);
    if actualVS is r4:FHIRError {
        test:assertEquals(actualVS.message(), "Requested size of the response: 400 is too large due to Allowed maximum size of output is: 300; therefore, reduce the value of size parameter accordingly");
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "successful_scenario"]
}
function codeSystemLookupTest1() {
    r4:code code = "inactive";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code, system = "http://hl7.org/fhir/account-status");
    r4:CodeSystem expectedCS = returnCodeSystemData("account-status");

    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedCS.concept {
        if c.code == code {
            test:assertEquals(actualConcept, c);
        }
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "successful_scenario"]
}
function codeSystemLookupTest2() returns error? {
    r4:Coding coding = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(coding, system = "http://hl7.org/fhir/account-status");
    r4:CodeSystem expectedCS = returnCodeSystemData("account-status");

    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedCS.concept {
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
    r4:CodeableConcept codeableConcept = check createCodeableConcept("http://hl7.org/fhir/account-status", code);
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(codeableConcept, system = "http://hl7.org/fhir/account-status");
    r4:CodeSystem expectedCS = returnCodeSystemData("account-status");

    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedCS.concept {
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
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code, system = system);

    test:assertEquals((<r4:FHIRError>actualConcept).message(),
            string `Cannot find a CodeSystem for the provided system URL: ${system}`);
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest5() returns error? {
    r4:code code = "inactive";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code);

    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Can not find a CodeSystem due to Either CodeSystem record or system URL should be provided as input");
    test:assertEquals((<r4:FHIRError>actualConcept).detail().issues[0].diagnostic, "Either CodeSystem record or system URL should be provided as input");
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest6() returns error? {
    r4:code code = "inactive2";
    string id = "account-status";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code, system = "http://hl7.org/fhir/account-status");

    test:assertEquals((<r4:FHIRError>actualConcept).message(), string `Can not find any valid concepts for the code: "${code}" in CodeSystem: "${id}"`);
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest7() returns error? {
    r4:code code = "inactive";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code);

    if actualConcept is r4:FHIRError {
        test:assertEquals(actualConcept.message(), "Can not find a CodeSystem due to Either CodeSystem record or system URL should be provided as input");

    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest1() {
    r4:code code = "1";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://hl7.org/fhir/ValueSet/relationship");
    r4:CodeSystem expectedVS = returnCodeSystemData("relationship");

    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedVS.concept {
        if c.code == code {
            test:assertEquals(actualConcept, c);
        }
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest2() returns error? {
    r4:Coding coding = check createCoding("http://hl7.org/fhir/relationship", "1");
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(coding, system = "http://hl7.org/fhir/ValueSet/relationship");
    r4:CodeSystem expectedVS = returnCodeSystemData("relationship");

    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedVS.concept {
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
    r4:CodeableConcept codeableConcept = check createCodeableConcept("http://hl7.org/fhir/action-condition-kind", code);
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(codeableConcept, system = "http://hl7.org/fhir/ValueSet/action-condition-kind");
    r4:CodeSystem expectedVS = returnCodeSystemData("action-condition-kind");

    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedVS.concept {
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
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = system);

    test:assertEquals((<r4:FHIRError>actualConcept).message(),
            string `Cannot find a ValueSet for the provided system URL: ${system}`);
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest5() returns error? {
    r4:code code = "1";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code);

    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Can not find a ValueSet due to Either ValueSet record or system URL should be provided as input");
    test:assertEquals((<r4:FHIRError>actualConcept).detail().issues[0].diagnostic, "Either ValueSet record or system URL should be provided as input");
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest6() returns error? {
    r4:code code = "test";
    string id = "relationship";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://hl7.org/fhir/ValueSet/relationship");

    test:assertEquals((<r4:FHIRError>actualConcept).message(), string `Can not find any valid concepts for the code: "${code}" in ValueSet: "${id}"`);
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest7() returns error? {
    r4:code code = "test";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code);

    if actualConcept is r4:FHIRError {
        test:assertEquals(actualConcept.message(), "Can not find a ValueSet due to Either ValueSet record or system URL should be provided as input");

    }
}

@test:Config {
    groups: ["valueset", "valueset_expansion", "successful_scenario"]
}
function valueSetExpansionTest1() {
    r4:ValueSet|r4:FHIRError valueSet = readValueSetById("relationship");
    map<r4:RequestSearchParameter[]> searchParameters1 = {
        "valueSetVersion": [{name: "valueSetVersion", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}],
        "_count": [{name: "_count", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "0", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };
    if valueSet is r4:ValueSet {
        r4:ValueSet|r4:FHIRError actualVS =
                                        valueSetExpansion(searchParameters1,
                                        system = "http://hl7.org/fhir/ValueSet/relationship");
        if actualVS is r4:ValueSet {
            r4:ValueSet expectedVS = returnValueSetData("expanded-relationship");
            r4:ValueSetExpansion? expansion = actualVS.expansion;
            expectedVS.expansion.timestamp = (<r4:ValueSetExpansion>expansion).timestamp;
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
    r4:ValueSet|r4:FHIRError actualVS =
                                        valueSetExpansion(searchParameters,
                                        system = "http://hl7.org/fhir/ValueSet/account-status");
    if actualVS is r4:ValueSet {
        r4:ValueSet expectedVS = returnValueSetData("expanded-account-status");
        r4:ValueSetExpansion? expansion = actualVS.expansion;
        expectedVS.expansion.timestamp = (<r4:ValueSetExpansion>expansion).timestamp;
        test:assertEquals(actualVS, expectedVS);
    }
}

@test:Config {
    groups: ["valueset", "valueset_expansion", "failure_scenario"]
}
function valueSetExpansionTest3() {
    map<r4:RequestSearchParameter[]> searchParameters1 = {
        "valueSetVersion": [{name: "valueSetVersion", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}],
        "_count": [{name: "_count", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "incorrect_param": [{name: "_offset", value: "0", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };
    r4:ValueSet|r4:FHIRError actualVS =
                                        valueSetExpansion(searchParameters1,
                                        system = "http://hl7.org/fhir/ValueSet/relationship");
    if actualVS is r4:FHIRError {
        test:assertEquals(actualVS.message(), string `Invalid search parameter: incorrect_param due to Allowed search parameters: ["url","valueSetVersion","filter","_offset","_count"]`);
    }
}

@test:Config {
    groups: ["valueset", "valueset_expansion", "failure_scenario"]
}
function valueSetExpansionTest4() {
    map<r4:RequestSearchParameter[]> searchParameters1 = {
        "valueSetVersion": [{name: "valueSetVersion", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}],
        "_count": [{name: "_count", value: "400", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };
    r4:ValueSet|r4:FHIRError actualVS =
                                        valueSetExpansion(searchParameters1,
                                        system = "http://hl7.org/fhir/ValueSet/relationship");
    if actualVS is r4:FHIRError {
        test:assertEquals(actualVS.message(), string `Requested size of the response: 400 is too large due to Allowed maximum size of output is: 300; therefore, reduce the value of size parameter accordingly`);
    }
}

@test:Config {
    groups: ["valueset", "valueset_expansion", "failure_scenario"]
}
function valueSetExpansionTest5() {
    map<r4:RequestSearchParameter[]> searchParameters1 = {
        "valueSetVersion": [{name: "valueSetVersion", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}]
    };
    r4:ValueSet|r4:FHIRError actualVS = valueSetExpansion(searchParameters1);
    if actualVS is r4:FHIRError {
        test:assertEquals(actualVS.message(), string `Can not find a ValueSet due to Either ValueSet record or system URL should be provided as input`);
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "successful_scenario"]
}
function codesystemSubsumeTest1() returns error? {
    r4:code codeA = "inactive";
    r4:code codeB = "inactive";
    r4:CodeSystem codeSystem = check readCodeSystemById("account-status");
    i4:Parameters actaulResult = check subsumes(codeA, codeB, codeSystem);
    i4:ParametersParameter actual = (<i4:ParametersParameter[]>actaulResult.'parameter)[0];
    test:assertEquals(actual.name, "outcome");
    test:assertEquals(actual.valueCode, "equivalent");
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "successful_scenario"]
}
function codesystemSubsumeTest2() returns error? {
    r4:Coding codingA = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Coding codingB = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    i4:Parameters actaulResult = check subsumes(codingA, codingB, system = "http://hl7.org/fhir/account-status");
    i4:ParametersParameter actual = (<i4:ParametersParameter[]>actaulResult.'parameter)[0];
    test:assertEquals(actual.name, "outcome");
    test:assertEquals(actual.valueCode, "equivalent");
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "successful_scenario"]
}
function codesystemSubsumeTest3() returns error? {
    r4:Coding codingA = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Coding codingB = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    i4:Parameters|r4:FHIRError actaulResult = subsumes(codingA, codingB);

    if actaulResult is r4:FHIRError {
        test:assertEquals(actaulResult.message(), "Can not find a CodeSystem due to CodeSystem record or system URL should be provided as input");
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "successful_scenario"]
}
function codesystemSubsumeTest4() returns error? {
    r4:code codeA = "inactive2";
    r4:Coding codingB = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    i4:Parameters|r4:FHIRError actaulResult = subsumes(codeA, codingB, system = "http://hl7.org/fhir/account-status");

    if actaulResult is r4:FHIRError {
        test:assertEquals(actaulResult.message(), string `Code/ Coding: "inactive2" is not included in the provided CodeSystem`);
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "successful_scenario"]
}
function codesystemSubsumeTest5() returns error? {
    r4:Coding codingA = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:code codeB = "inactive2";
    i4:Parameters|r4:FHIRError actaulResult = subsumes(codingA, codeB, system = "http://hl7.org/fhir/account-status");

    if actaulResult is r4:FHIRError {
        test:assertEquals(actaulResult.message(), string `Code/ Coding: "inactive2" is not included in the provided CodeSystem`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "successful_scenario"]
}
function addCodeSystem1() {
    json data = readJsonData("code_systems/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/account-status";

    json[] dataArray = [data];
    r4:FHIRError[]? actual = addCodeSystemsAsJson(dataArray);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Duplicate entry due to Already there is a CodeSystem exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "successful_scenario"]
}
function addCodeSystem2() returns error? {
    json data = readJsonData("code_systems/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/account-status";

    r4:CodeSystem codeSystem = check data.cloneWithType(r4:CodeSystem);
    r4:FHIRError? actual = addCodeSystem(codeSystem);

    if actual is r4:FHIRError {
        test:assertEquals(actual.message(), string `Duplicate entry due to Already there is a CodeSystem exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem3() returns error? {
    json data = readJsonData("code_systems/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/account-status";

    r4:CodeSystem codeSystem = check data.cloneWithType(r4:CodeSystem);
    r4:FHIRError[]? actual = addCodeSystems([codeSystem]);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Duplicate entry due to Already there is a CodeSystem exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem4() {
    json[] dataArray = [{}];
    r4:FHIRError[]? actual = addCodeSystemsAsJson(dataArray);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Invalid data. Can not parse the provided json data: {} due to Please check the provided json structure and re-try with this data again`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem5() {
    json data = readJsonData("code_systems/account-status-without-url");
    r4:FHIRError[]? actual = addCodeSystemsAsJson([data]);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Can not find the URL of the CodeSystem with name: "AccountStatus" due to Add a proper URL for the resource: http://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.url`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem6() {
    json data = readJsonData("code_systems/account-status-without-version");
    r4:FHIRError[]? actual = addCodeSystemsAsJson([data]);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Can not find the version of the CodeSystem with name: "AccountStatus" due to Add appropriate version for the resource: https://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.version`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem7() {
    json data = readJsonData("code_systems/account-status-invalid");
    r4:FHIRError[]? actual = addCodeSystemsAsJson([data]);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Validation failed due to Check whether the data conforms to the specification: http://hl7.org/fhir/R4/codesystem-definitions.html`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "successful_scenario"]
}
function addValueset1() {
    json data = readJsonData("value_sets/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/ValueSet/account-status";

    json[] dataArray = [data];
    r4:FHIRError[]? actual = addValueSetsAsJson(dataArray);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), "Duplicate entry due to Already there is a ValueSet exists in the registry with the URL: http://hl7.org/fhir/ValueSet/account-status");
        test:assertEquals(actual[0].detail().issues[0].diagnostic, string `Already there is a ValueSet exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "successful_scenario"]
}
function addValueset2() returns error? {
    json data = readJsonData("value_sets/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/ValueSet/account-status";

    r4:ValueSet valueSet = check data.cloneWithType(r4:ValueSet);
    r4:FHIRError? actual = addValueSet(valueSet);

    if actual is r4:FHIRError {
        test:assertEquals(actual.message(), "Duplicate entry due to Already there is a ValueSet exists in the registry with the URL: http://hl7.org/fhir/ValueSet/account-status");
        test:assertEquals(actual.detail().issues[0].diagnostic, string `Already there is a ValueSet exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "successful_scenario"]
}
function addValueset3() returns error? {
    json data = readJsonData("value_sets/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/ValueSet/account-status";

    r4:ValueSet valueSet = check data.cloneWithType(r4:ValueSet);
    r4:FHIRError[]? actual = addValueSets([valueSet]);

    if actual is r4:FHIRError[] && actual.length() > 1 {
        test:assertEquals(actual[0].message(), "Duplicate entry due to Already there is a ValueSet exists in the registry with the URL: http://hl7.org/fhir/ValueSet/account-status");
        test:assertEquals(actual[0].detail().issues[0].diagnostic, string `Already there is a ValueSet exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset4() {
    json[] dataArray = [{}];
    r4:FHIRError[]? actual = addValueSetsAsJson(dataArray);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), "Invalid data. Can not parse the provided json data: {} due to Please check the provided json structure and re-try with this data again");
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset5() {
    json data = readJsonData("value_sets/account-status-without-url");
    r4:FHIRError[]? actual = addValueSetsAsJson([data]);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Can not find the URL of the ValueSet with name: "AccountStatus" due to Add a proper URL for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.url`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset6() {
    json data = readJsonData("value_sets/account-status-without-version");
    r4:FHIRError[]? actual = addValueSetsAsJson([data]);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Can not find the version of the ValueSet with name: "AccountStatus" due to Add appropriate version for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.version`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset7() {
    json data = readJsonData("value_sets/account-status-incorrect");
    r4:FHIRError[]? actual = addValueSetsAsJson([data]);

    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Validation failed due to Check whether the data conforms to the specification: http://hl7.org/fhir/R4/valueset-definitions.html`);
    }
}
