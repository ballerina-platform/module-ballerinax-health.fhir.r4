// Copyright (c) 2023 - 2025, WSO2 LLC. (http://www.wso2.com).
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
import ballerina/log;
import ballerina/test;
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
    test:assertEquals((<r4:FHIRError>actualCoding).message(), string `Code: ${code.toString()} was not found in the CodeSystem: ${system.toString()}`);
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
    test:assertEquals((<r4:FHIRError>actualCoding).message(), string `Unknown ValueSet or CodeSystem : ${system}|${incorrectVersion}`);
}

@test:Config {
    groups: ["coding", "create_coding", "successful_scenario"]
}
function createCoding5() {
    r4:code code = "1";
    r4:Coding|r4:FHIRError actualCoding = createCoding("http://hl7.org/fhir/ValueSet/relationship", code);
    r4:Coding expectedCoding = {system: "http://hl7.org/fhir/relationship", code: "1", display: "Self"};
    test:assertEquals(actualCoding, expectedCoding);
}

@test:Config {
    groups: ["coding", "create_coding", "successful_scenario"]
}
function createCoding6() {
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
                    "display": "XYZ"
                }

            ]
        }
    ];
    r4:ValueSet vs3 = {id: "vs3", status: "active", url: "http://example.org/vs3", 'version: "1.0.0", compose: {include: []}};
    vs3.compose.include = [{system: "http://hl7.org/fhir/relationship"}];
    r4:ValueSet vs4 = {id: "vs4", status: "active", url: "http://example.org/vs4", 'version: "1.0.0", compose: {include: []}};
    vs4.compose.include = [{valueSet: ["http://example.org/vs3"]}];
    _ = checkpanic addValueSet(vs1);
    _ = checkpanic addValueSet(vs2);
    _ = checkpanic addValueSet(vs3);
    _ = checkpanic addValueSet(vs4);

    r4:code code = "1";
    r4:Coding|r4:FHIRError actualCoding = createCoding(<r4:uri>vs1.url, code);
    r4:Coding expectedCoding = {system: "http://loinc.org", code: "1", display: "Cholesterol [Moles/Volume]"};
    test:assertEquals(actualCoding, expectedCoding);

    actualCoding = createCoding(<r4:uri>vs3.url, code);
    expectedCoding = {system: "http://hl7.org/fhir/relationship", code: "1", display: "Self"};
    test:assertEquals(actualCoding, expectedCoding);

    actualCoding = createCoding(<r4:uri>vs4.url, code);
    expectedCoding = {system: "http://hl7.org/fhir/relationship", code: "1", display: "Self"};
    test:assertEquals(actualCoding, expectedCoding);
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
    test:assertTrue(actualCC is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualCC).message(), string `Code: ${incorrectCode} was not found in the CodeSystem: ${system}`);
}

@test:Config {
    groups: ["codeableconcept", "create_codeableconcept", "failure_scenario"]
}
function createCodeableconcept3() {
    r4:code code = "inactive";
    string incorrectSystem = "http://hl7.org/fhir/account-status2";

    r4:CodeableConcept|r4:FHIRError actualCC = createCodeableConcept(incorrectSystem, code);
    test:assertTrue(actualCC is r4:FHIRError, "Expected an error");
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
    test:assertTrue(actualCC is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualCC).message(), string `Unknown ValueSet or CodeSystem : ${system}|${incorrectVersion}`);
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
    test:assertTrue(actualCS is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualCS).message(), string `Unknown CodeSystem: '"${url}"'`);
}

@test:Config {
    groups: ["codesystem", "read_by_url_codesystem", "failure_scenario"]
}
function readByUrlCodeSystemTest3() {
    string url = "http://hl7.org/fhir/action-condition-kind";
    string version = "5.0.0";

    r4:CodeSystem|r4:FHIRError actualCS = readCodeSystemByUrl(url, version);
    test:assertTrue(actualCS is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualCS).message(), string `Unknown version: '5.0.0', due to : there is a CodeSystem in the registry with Id: 'http://hl7.org/fhir/action-condition-kind' but cannot find version: '5.0.0' of it.`);
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
    test:assertTrue(actaulVS is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actaulVS).message(), "Unknown version: '5.0.0', due to : there is a ValueSet in the registry with Id: 'http://hl7.org/fhir/ValueSet/relationship' but cannot find version: '5.0.0' of it.");
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
    if (actualCS is r4:CodeSystem) {
        log:printInfo(actualCS.toBalString());
    }
    test:assertTrue(actualCS is r4:FHIRError, "Expected an error");
    r4:FHIRError err = <r4:FHIRError>actualCS;
    test:assertEquals(err.message(), string `Unknown version: '5.3.0', due to : there is a CodeSystem in the registry with Id: '${id}' but cannot find version: '${incorrectVersion}' of it.`, "Mismatching error message");
    test:assertEquals(err.detail().issues[0].diagnostic, string `: there is a CodeSystem in the registry with Id: '${id}' but cannot find version: '${incorrectVersion}' of it.`, "Mismatching error diagonistic");
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "failure_scenario"]
}
function getByIdCodeSystemTest4() {
    string incorrectId = "account-status2";
    string version = "5.3.0";

    r4:CodeSystem|r4:FHIRError codeSystem4 = readCodeSystemById(incorrectId, version);
    test:assertTrue(codeSystem4 is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>codeSystem4).message(), string `Unknown CodeSystem Id: '${incorrectId}'`);
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem_with_custom_impl", "failure_scenario"]
}
function getByIdCodeSystemWithCustomImplTest1() {
    string id = "action-condition-kind";
    string version = "4.0.1";
    
    TestTerminology customTerminology = new ();
    r4:CodeSystem|r4:FHIRError actualCS = readCodeSystemById(id, version, customTerminology);
    test:assertTrue(actualCS is r4:FHIRError, "Expected a FHIRError");
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem_with_custom_impl", "successful_scenario"]
}
function getByIdCodeSystemWithCustomImplTest2() {
    string id = "loinc";
    string version = "2.36";
    
    TestTerminology customTerminology = new ();
    r4:CodeSystem|r4:FHIRError actualCS = readCodeSystemById(id, version, customTerminology);
    test:assertTrue(actualCS is r4:CodeSystem, "Expected a CodeSystem");
    if actualCS is r4:CodeSystem {
        test:assertEquals(actualCS.url, "http://loinc.org");
    }
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
    test:assertTrue(actaulVS is r4:FHIRError, "Expected an error");
    r4:FHIRError err = <r4:FHIRError>actaulVS;
    test:assertEquals(err.message(), string `Unknown version: '${incorrectVersion}', due to : there is a ValueSet in the registry with Id: '${id}' but cannot find version: '${incorrectVersion}' of it.`, "Mismatching error message");
    test:assertEquals(err.detail().issues[0].diagnostic, string `: there is a ValueSet in the registry with Id: '${id}' but cannot find version: '${incorrectVersion}' of it.`, "Mismatching error diagonistic");
}

@test:Config {
    groups: ["valueset", "get_by_id_valueset", "failure_scenario"]
}
function getByIdValueSetTest4() {
    string incorrectId = "relationship2";
    string version = "4.3.0";

    r4:ValueSet|r4:FHIRError|r4:ValueSet[] actaulVS = readValueSetById(incorrectId, version);
    test:assertTrue(actaulVS is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actaulVS).message(), string `Unknown ValueSet Id: '${incorrectId}'`);
}

@test:Config {
    groups: ["codesystem", "search_codesystem", "successful_scenario"]
}
function searchCodeSystemTest1() {
    string id = "action-condition-kind";
    map<r4:RequestSearchParameter[]> searchParameters = {"url": [{name: "url", value: "http://hl7.org/fhir/action-condition-kind", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:URI}]};

    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters);
    r4:CodeSystem expectedCS = returnCodeSystemData(id);
    test:assertTrue(actualCS is r4:CodeSystem[], "Expected a code system array");
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 1);
        test:assertEquals(actualCS[0], expectedCS);
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
    test:assertTrue(actualCS is r4:CodeSystem[], "Expected a code system array");
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 1);
        test:assertEquals(actualCS[0], expectedCS);
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
    test:assertTrue(actualCS is r4:CodeSystem[], "Expected a code system array");
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 268);
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
    test:assertTrue(actualCS is r4:CodeSystem[], "Expected a code system array");
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 68);
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
    test:assertTrue(actualCS is r4:CodeSystem[], "Expected a code system array");
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 50);
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
    InMemoryTerminology inMemoryTerminology = new ();
    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters, inMemoryTerminology);
    test:assertTrue(actualCS is r4:CodeSystem[], "Expected a code system array");
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 17);
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
    test:assertTrue(actualCS is r4:CodeSystem[], "Expected a code system array");
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 300);
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
    InMemoryTerminology inMemoryTerminology = new ();
    r4:CodeSystem[]|r4:FHIRError actualCS = searchCodeSystems(searchParameters, inMemoryTerminology);
    test:assertTrue(actualCS is r4:CodeSystem[], "Expected a code system array");
    if actualCS is r4:CodeSystem[] {
        test:assertEquals(actualCS.length(), 253);
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
    test:assertTrue(actualCS is r4:FHIRError, "Expected an error");
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
    test:assertTrue(actualCS is r4:FHIRError, "Expected an error");
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
    test:assertTrue(actualVS is r4:ValueSet[], "Expected a value set array");
    if actualVS is r4:ValueSet[] {
        test:assertEquals(actualVS.length(), 1);
        test:assertEquals(actualVS[0], expectedVS);
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
    test:assertTrue(actualVS is r4:ValueSet[], "Expected a value set array");
    if actualVS is r4:ValueSet[] {
        test:assertEquals(actualVS.length(), 1);
        test:assertEquals(actualVS[0], expectedVS);
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
    test:assertTrue(actualVS is r4:ValueSet[], "Expected a value set array");
    if actualVS is r4:ValueSet[] {
        test:assertEquals(actualVS.length(), 268);
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
    test:assertTrue(actualVS is r4:ValueSet[], "Expected a value set array");
    if actualVS is r4:ValueSet[] {
        test:assertEquals(actualVS.length(), 68);
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
    test:assertTrue(actualVS is r4:ValueSet[], "Expected a value set array");
    if actualVS is r4:ValueSet[] {
        test:assertEquals(actualVS.length(), 50);
    }
}

@test:Config {
    groups: ["valueset", "search_valueset", "successful_scenario"]
}
function searchValueSetTest6() {
    map<r4:RequestSearchParameter[]> searchParameters = {
        "status": [{name: "status", value: "active", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:REFERENCE}],
        "_count": [{name: "_count", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "90", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };

    r4:ValueSet[]|r4:FHIRError actualVS = searchValueSets(searchParameters);
    test:assertTrue(actualVS is r4:ValueSet[], "Expected a value set array");
    if actualVS is r4:ValueSet[] {
        test:assertEquals(actualVS.length(), 0);
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
    test:assertTrue(actualVS is r4:FHIRError, "Expected an error");
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
    test:assertTrue(actualVS is r4:FHIRError, "Expected an error");
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
    test:assertTrue(actualConcept is r4:CodeSystemConcept, "Expected a code system concept");
    boolean codeFound = false;
    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedCS.concept {
        if c.code == code {
            test:assertEquals(actualConcept, c);
            codeFound = true;
            break;
        }
    }
    test:assertTrue(codeFound, "Expected to find the code in the code system");
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "successful_scenario"]
}
function codeSystemLookupTest2() returns error? {
    r4:Coding coding = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(coding, system = "http://hl7.org/fhir/account-status");
    r4:CodeSystem expectedCS = returnCodeSystemData("account-status");

    boolean codeFound = false;
    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedCS.concept {
        if c.code == coding.code {
            test:assertEquals(actualConcept, c);
            codeFound = true;
            break;
        }
    }
    test:assertTrue(codeFound, "Expected to find the code in the code system");
    codeFound = false;
    actualConcept = codeSystemLookUp(coding, cs = expectedCS);
    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedCS.concept {
        if c.code == coding.code {
            test:assertEquals(actualConcept, c);
            codeFound = true;
            break;
        }
    }
    test:assertTrue(codeFound, "Expected to find the code in the code system");
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest4() returns error? {
    r4:code code = "inactive";
    string system = "http://hl7.org/fhir/account-status2|4.3.0";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code, system = system);

    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(),
            string `Cannot find a CodeSystem for the provided system URL: ${system}`);
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest5() returns error? {
    r4:code code = "inactive";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code);

    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Cannot find a CodeSystem due to Either CodeSystem record or system URL or a valid Coding should be provided as input");
    test:assertEquals((<r4:FHIRError>actualConcept).detail().issues[0].diagnostic, "Either CodeSystem record or system URL or a valid Coding should be provided as input");
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest6() returns error? {
    r4:code code = "inactive2";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code, system = "http://hl7.org/fhir/account-status");
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(), string `Code: inactive2 was not found in the CodeSystem: http://hl7.org/fhir/account-status`);
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest7() returns error? {
    r4:code code = "inactive";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Cannot find a CodeSystem due to Either CodeSystem record or system URL or a valid Coding should be provided as input");
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest8() returns error? {
    r4:Coding coding = {
        system: "http://hl7.org/fhir/account-status",
        code: "close"
    };
    r4:CodeSystem expectedCS = returnCodeSystemData("account-status");
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(coding, cs = expectedCS);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Code: close was not found in the CodeSystem: http://hl7.org/fhir/account-status");
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest11() returns error? {
    r4:Coding coding = {
        system: "http://hl7.org/fhir/account-status2",
        code: "close"
    };
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(coding);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Cannot find a CodeSystem for the provided system URL: http://hl7.org/fhir/account-status2");
}

@test:Config {
    groups: ["codesystem", "codesystem_lookup", "failure_scenario"]
}
function codeSystemLookupTest12() returns error? {
    r4:code code = "";
    r4:CodeSystem expectedCS = returnCodeSystemData("account-status");
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = codeSystemLookUp(code, cs = expectedCS);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(), "A valid code or Coding should be provided as input");
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest1() {
    r4:code code = "1";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://hl7.org/fhir/ValueSet/relationship");
    r4:CodeSystem expectedVS = returnCodeSystemData("relationship");
    boolean codeFound = false;
    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedVS.concept {
        if c.code == code {
            test:assertEquals(actualConcept, c);
            codeFound = true;
            break;
        }
    }
    test:assertTrue(codeFound, "Expected to find the code in the value set");
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest2() returns error? {
    r4:Coding coding = check createCoding("http://hl7.org/fhir/relationship", "1");
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(coding, system = "http://hl7.org/fhir/ValueSet/relationship");
    test:assertTrue(actualConcept is r4:CodeSystemConcept, "Expected a CodeSystemConcept");
    if actualConcept is r4:CodeSystemConcept {
        r4:CodeSystemConcept actualConcepts = <r4:CodeSystemConcept>actualConcept;
        test:assertEquals(actualConcepts.code, "1");
        test:assertEquals(actualConcepts.display, "Self");
        test:assertEquals(actualConcepts.definition, "The patient is the subscriber (policy holder)");
    }

    // use the ValueSet instead of the system and do the same test
    r4:ValueSet expectedVS = returnValueSetData("relationship");
    actualConcept = valueSetLookUp(coding, vs = expectedVS);
    test:assertTrue(actualConcept is r4:CodeSystemConcept, "Expected a CodeSystemConcept");
    if actualConcept is r4:CodeSystemConcept {
        r4:CodeSystemConcept actualConcepts = <r4:CodeSystemConcept>actualConcept;
        test:assertEquals(actualConcepts.code, "1");
        test:assertEquals(actualConcepts.display, "Self");
        test:assertEquals(actualConcepts.definition, "The patient is the subscriber (policy holder)");
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

    boolean codeFound = false;
    foreach r4:CodeSystemConcept c in <r4:CodeSystemConcept[]>expectedVS.concept {
        if c.code == code {
            test:assertEquals(actualConcept, c);
            codeFound = true;
            break;
        }
    }
    test:assertTrue(codeFound, "Expected to find the code in the value set");
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest4() returns error? {
    r4:code code = "1";
    string system = "http://hl7.org/fhir/ValueSet/relationship2|4.3.0";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = system);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(),
            string `Cannot find a ValueSet for the provided system URL: ${system}`);
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest5() returns error? {
    r4:code code = "1";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Cannot find a ValueSet due to Either ValueSet record or system URL should be provided as input");
    test:assertEquals((<r4:FHIRError>actualConcept).detail().issues[0].diagnostic, "Either ValueSet record or system URL should be provided as input");
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest6() returns error? {
    r4:code code = "test";
    string system = "http://hl7.org/fhir/ValueSet/relationship";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = system);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(), string `Unknown ValueSet or CodeSystem : ${system}`);
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest7() returns error? {
    r4:code code = "test";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    if actualConcept is r4:FHIRError {
        test:assertEquals(actualConcept.message(), "Cannot find a ValueSet due to Either ValueSet record or system URL should be provided as input");
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest8() returns error? {
    r4:code coding = "Account";
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(coding, system = "http://hl7.org/fhir/ValueSet/all-types");
    test:assertTrue(actualConcept is r4:CodeSystemConcept, "Expected a CodeSystemConcept");
    if actualConcept is r4:CodeSystemConcept {
        r4:CodeSystemConcept actualConcepts = <r4:CodeSystemConcept>actualConcept;
        test:assertEquals(actualConcepts.code, "Account");
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest9() {
    r4:code code = "1";
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs1", terminology = customTerminology);
    test:assertEquals(actualConcept.clone(), {code: "1", display: "Cholesterol [Moles/Volume]"});
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest10() {
    r4:code code = "3";
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs1", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an error");
    test:assertEquals((<r4:FHIRError>actualConcept).message(), "Concept not found in the ValueSet");
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest11() {
    r4:code code = "1";
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs4", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:CodeSystemConcept, "Expected a CodeSystemConcept");
    if actualConcept is r4:CodeSystemConcept {
        r4:CodeSystemConcept actualConcepts = <r4:CodeSystemConcept>actualConcept;
        test:assertEquals(actualConcepts.code, "1");
        test:assertEquals(actualConcepts.display, "Cholesterol [Moles/Volume]");
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest12() {
    r4:code code = "1";
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs2", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:CodeSystemConcept, "Expected a CodeSystemConcept");
    if actualConcept is r4:CodeSystemConcept {
        r4:CodeSystemConcept actualConcepts = <r4:CodeSystemConcept>actualConcept;
        test:assertEquals(actualConcepts.code, "1");
        test:assertEquals(actualConcepts.display, "Cholesterol [Moles/Volume]");
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest13() {
    r4:code code = "6";
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs2", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an Error");
    if actualConcept is r4:FHIRError {
        test:assertEquals((<r4:FHIRError>actualConcept).message(), "Concept not found in the ValueSet");
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest14() {
    r4:Coding code = {
        system: "http://loinc.org",
        code: "1"
    };
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs2", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:CodeSystemConcept, "Expected a CodeSystemConcept");
    if actualConcept is r4:CodeSystemConcept {
        r4:CodeSystemConcept actualConcepts = <r4:CodeSystemConcept>actualConcept;
        test:assertEquals(actualConcepts.code, "1");
        test:assertEquals(actualConcepts.display, "Cholesterol [Moles/Volume]");
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest15() {
    r4:Coding code = {
        system: "http://loinc.org",
        code: "6"
    };
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs2", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an Error");
    if actualConcept is r4:FHIRError {
        test:assertEquals((<r4:FHIRError>actualConcept).message(), "Concept not found in the ValueSet");
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest16() {
    r4:CodeableConcept code = {
        coding: [
            {
                system: "http://loinc.org",
                code: "1"
            },
            {
                system: "http://xyz.org",
                code: "1"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs2", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:CodeSystemConcept[], "Expected an array of CodeSystemConcept");
    if actualConcept is r4:CodeSystemConcept {
        r4:CodeSystemConcept actualConcepts = <r4:CodeSystemConcept>actualConcept;
        test:assertEquals(actualConcepts.code, "1");
        test:assertEquals(actualConcepts.display, "Cholesterol [Moles/Volume]");
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest17() {
    r4:CodeableConcept code = {
        coding: [
            {
                system: "http://xyz.org",
                code: "1"
            },
            {
                system: "http://loinc.org",
                code: "6"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs2", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an Error");
    if actualConcept is r4:FHIRError {
        test:assertTrue((<r4:FHIRError>actualConcept).message().startsWith(string `Cannot find any valid concepts for the CodeableConcept: {"coding":[{"system":"http://xyz.org","code":"1"},{"system":"http://loinc.org","code":"6"}]} in the ValueSet: http://example.org/vs2`));
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "successful_scenario"]
}
function valueSetLookupTest18() {
    r4:CodeableConcept code = {
        coding: [
            {
                system: "http://loinc.org",
                code: "1"
            },
            {
                system: "http://loinc.org",
                code: "2"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs4", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:CodeSystemConcept[], "Expected an array of CodeSystemConcept");
    if actualConcept is r4:CodeSystemConcept[] {
        r4:CodeSystemConcept[] actualConcepts = <r4:CodeSystemConcept[]>actualConcept;
        test:assertEquals(actualConcepts.length(), 2);
        foreach r4:CodeSystemConcept c in actualConcepts {
            test:assertTrue(c.code == "1" || c.code == "2", "Expected code to be either '1' or '2'");
        }
    }
}

@test:Config {
    groups: ["valueset", "valueset_lookup", "failure_scenario"]
}
function valueSetLookupTest19() {
    r4:CodeableConcept code = {
        coding: [
        ]
    };
    TestTerminology customTerminology = new ();
    r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError actualConcept = valueSetLookUp(code, system = "http://example.org/vs4", terminology = customTerminology);
    test:assertTrue(actualConcept is r4:FHIRError, "Expected an Error");
    if actualConcept is r4:FHIRError {
        test:assertEquals((<r4:FHIRError>actualConcept).message(), string `Cannot find any valid codes in the provided CodeableConcept data`);
    }
}

@test:Config {
    groups: ["valueset", "valueset_expansion", "successful_scenario"]
}
function valueSetExpansionTest1() returns error? {
    // r4:ValueSet valueSet = check readValueSetById("relationship");
    map<r4:RequestSearchParameter[]> searchParameters1 = {
        "valueSetVersion": [{name: "valueSetVersion", value: "4.0.1", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}],
        "_count": [{name: "_count", value: "50", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}],
        "_offset": [{name: "_offset", value: "0", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]
    };
    r4:ValueSet|r4:FHIRError actualVS =
                                        valueSetExpansion(searchParameters1,
                                        system = "http://hl7.org/fhir/ValueSet/relationship");
    test:assertTrue(actualVS is r4:ValueSet, "Expected a value set");
    if actualVS is r4:ValueSet {
        r4:ValueSet expectedVS = returnValueSetData("expanded-relationship");
        r4:ValueSetExpansion? expansion = actualVS.expansion;
        // update the dates and timestamps
        expectedVS.expansion.timestamp = (<r4:ValueSetExpansion>expansion).timestamp;
        expectedVS.meta.lastUpdated = actualVS.meta.lastUpdated;
        expectedVS.date = actualVS.date;
        expectedVS.text.div = (<r4:Narrative>actualVS.text).div;
        test:assertEquals(actualVS, expectedVS);
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
    test:assertTrue(actualVS is r4:ValueSet, "Expected a value set");
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
    test:assertTrue(actualVS is r4:FHIRError, "Expected an error");
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
    test:assertTrue(actualVS is r4:FHIRError, "Expected an error");
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
    test:assertTrue(actualVS is r4:FHIRError, "Expected an error");
    if actualVS is r4:FHIRError {
        test:assertEquals(actualVS.message(), string `Cannot find a ValueSet due to Either ValueSet record or system URL should be provided as input`);
    }
}

@test:Config {
    groups: ["valueset", "valueset_expansion", "successful_scenario"]
}
function valueSetExpansionTest6() {
    TestTerminology customTerminology = new ();
    r4:ValueSet|r4:FHIRError actualVS = valueSetExpansion({}, system = "http://example.org/vs2", terminology = customTerminology);
    test:assertTrue(actualVS is r4:ValueSet, "Expected a value set");
    if actualVS is r4:ValueSet {
        r4:ValueSetExpansion? expansion = actualVS.expansion;
        r4:ValueSetExpansionContains[]? contains = (<r4:ValueSetExpansion>expansion).contains;
        test:assertTrue(contains is r4:ValueSetExpansionContains[], "Expected an array of ValueSetExpansionContains");
        if contains is r4:ValueSetExpansionContains[] {
            test:assertEquals(contains.length(), 2);
            foreach r4:ValueSetExpansionContains c in contains {
                test:assertTrue(c.code == "1" || c.code == "2", "Expected code to be either '1' or '2'");
            }
        }
    }

}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "successful_scenario"]
}
function codesystemSubsumeTest1() returns error? {
    r4:code codeA = "inactive";
    r4:code codeB = "inactive";
    r4:CodeSystem codeSystem = check readCodeSystemById("account-status");
    r4:Parameters actaulResult = check subsumes(codeA, codeB, codeSystem);
    r4:ParametersParameter actual = (<r4:ParametersParameter[]>actaulResult.'parameter)[0];
    test:assertEquals(actual.name, "outcome");
    test:assertEquals(actual.valueCode, "equivalent");
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "successful_scenario"]
}
function codesystemSubsumeTest2() returns error? {
    r4:Coding codingA = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Coding codingB = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Parameters actaulResult = check subsumes(codingA, codingB, system = "http://hl7.org/fhir/account-status");
    r4:ParametersParameter actual = (<r4:ParametersParameter[]>actaulResult.'parameter)[0];
    test:assertEquals(actual.name, "outcome");
    test:assertEquals(actual.valueCode, "equivalent");
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "failure_scenario"]
}
function codesystemSubsumeTest3() returns error? {
    r4:Coding codingA = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Coding codingB = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Parameters|r4:FHIRError actaulResult = subsumes(codingA, codingB);
    test:assertTrue(actaulResult is r4:FHIRError, "Expected an error");
    if actaulResult is r4:FHIRError {
        test:assertEquals(actaulResult.message(), "Cannot find a CodeSystem due to CodeSystem record or system URL should be provided as input");
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "failure_scenario"]
}
function codesystemSubsumeTest4() returns error? {
    r4:code codeA = "inactive2";
    r4:Coding codingB = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Parameters|r4:FHIRError actaulResult = subsumes(codeA, codingB, system = "http://hl7.org/fhir/account-status");
    test:assertTrue(actaulResult is r4:FHIRError, "Expected an error");
    if actaulResult is r4:FHIRError {
        test:assertEquals(actaulResult.message(), string `Code: ${codeA} was not found in the CodeSystem: http://hl7.org/fhir/account-status`);
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "failure_scenario"]
}
function codesystemSubsumeTest5() returns error? {
    r4:Coding codingA = check createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:code codeB = "inactive2";
    r4:Parameters|r4:FHIRError actaulResult = subsumes(codingA, codeB, system = "http://hl7.org/fhir/account-status");
    test:assertTrue(actaulResult is r4:FHIRError, "Expected an error");
    if actaulResult is r4:FHIRError {
        test:assertEquals(actaulResult.message(), string `Code: ${codeB} was not found in the CodeSystem: http://hl7.org/fhir/account-status`);
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "recursive_codesystem"]
}
function codesystemSubsumeTest6() returns error? {
    // "A" is the parent of "A1"
    r4:code codeA = "A";
    r4:code codeB = "A1";
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:FHIRError actualResult = subsumes(codeA, codeB, system = "http://example.org/recursive-codesystem", terminology = customTerminology);
    test:assertTrue(actualResult is r4:Parameters, "Expected Parameters result");
    if actualResult is r4:Parameters {
        r4:ParametersParameter actual = (<r4:ParametersParameter[]>actualResult.'parameter)[0];
        test:assertEquals(actual.valueCode, "subsumed");
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "recursive_codesystem"]
}
function codesystemSubsumeTest7() returns error? {
    // "A1a" and "A2" are not in a parent-child relationship (different branches)
    r4:code codeA = "A1a";
    r4:code codeB = "A2";
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:FHIRError actualResult = subsumes(codeA, codeB, system = "http://example.org/recursive-codesystem", terminology = customTerminology);
    test:assertTrue(actualResult is r4:Parameters, "Expected Parameters result");
    if actualResult is r4:Parameters {
        r4:ParametersParameter actual = (<r4:ParametersParameter[]>actualResult.'parameter)[0];
        test:assertEquals(actual.valueCode, "not-subsumed");
    }
}

@test:Config {
    groups: ["codesystem", "codesystem_subsume", "recursive_codesystem"]
}
function codesystemSubsumeTest8() returns error? {
    // "A" is the parent of "A1"
    r4:code codeA = "A1";
    r4:code codeB = "A";
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:FHIRError actualResult = subsumes(codeA, codeB, system = "http://example.org/recursive-codesystem", terminology = customTerminology);
    test:assertTrue(actualResult is r4:Parameters, "Expected Parameters result");
    if actualResult is r4:Parameters {
        r4:ParametersParameter actual = (<r4:ParametersParameter[]>actualResult.'parameter)[0];
        test:assertEquals(actual.valueCode, "subsumed-by");
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem1() {
    json data = readJsonData("code_systems/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/account-status";

    json[] dataArray = [data];
    r4:FHIRError[]? actual = addCodeSystemsAsJson(dataArray);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Duplicate entry due to There is an already existing CodeSystem in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem2() returns error? {
    json data = readJsonData("code_systems/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/account-status";

    r4:CodeSystem codeSystem = check data.cloneWithType(r4:CodeSystem);
    r4:FHIRError? actual = addCodeSystem(codeSystem);
    test:assertTrue(actual is r4:FHIRError, "Expected an error");
    if actual is r4:FHIRError {
        test:assertEquals(actual.message(), string `Duplicate entry due to There is an already existing CodeSystem in the registry with the URL: ${duplicateEntryUrl}`);
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
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Duplicate entry due to There is an already existing CodeSystem in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem4() {
    json[] dataArray = [{}];
    r4:FHIRError[]? actual = addCodeSystemsAsJson(dataArray);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Invalid data. Cannot parse the provided json data: {} due to Please check the provided json structure and re-try with this data again`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem5() {
    json data = readJsonData("code_systems/account-status-without-url");
    r4:FHIRError[]? actual = addCodeSystemsAsJson([data]);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Cannot find the URL of the CodeSystem with name: AccountStatus due to Add a proper URL for the resource: http://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.url`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem6() {
    json data = readJsonData("code_systems/account-status-without-version");
    r4:FHIRError[]? actual = addCodeSystemsAsJson([data]);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Cannot find the version of the CodeSystem with name: AccountStatus due to Add appropriate version for the resource: https://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.version`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "failure_scenario"]
}
function addCodeSystem7() {
    json data = readJsonData("code_systems/account-status-invalid");
    r4:FHIRError[]? actual = addCodeSystemsAsJson([data]);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Validation failed due to Check whether the data conforms to the specification: http://hl7.org/fhir/R4/codesystem-definitions.html`);
    }
}

@test:Config {
    groups: ["codesystem", "add_codesystem", "successful_scenario"]
}
function addCodeSystem8() returns error? {
    r4:CodeSystem codeSystem = {
        url: "http://example.org/cs1",
        version: "1.0.0",
        name: "Example CodeSystem 1",
        title: "Example CodeSystem 1",
        status: "active",
        content: "complete",
        concept: [
            {
                code: "1",
                display: "Code 1"
            },
            {
                code: "2",
                display: "Code 2"
            }
        ]
    };
    r4:FHIRError[]? actual = addCodeSystems([codeSystem]);
    test:assertTrue(actual !is r4:FHIRError[], "Expected a successful inclusion of the CodeSystem");
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset1() {
    json data = readJsonData("value_sets/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/ValueSet/account-status";

    json[] dataArray = [data];
    r4:FHIRError[]? actual = addValueSetsAsJson(dataArray);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), "Duplicate entry due to Already there is a ValueSet exists in the registry with the URL: http://hl7.org/fhir/ValueSet/account-status");
        test:assertEquals(actual[0].detail().issues[0].diagnostic, string `Already there is a ValueSet exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset2() returns error? {
    json data = readJsonData("value_sets/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/ValueSet/account-status";

    r4:ValueSet valueSet = check data.cloneWithType(r4:ValueSet);
    r4:FHIRError? actual = addValueSet(valueSet);
    test:assertTrue(actual is r4:FHIRError, "Expected an error");
    if actual is r4:FHIRError {
        test:assertEquals(actual.message(), "Duplicate entry due to Already there is a ValueSet exists in the registry with the URL: http://hl7.org/fhir/ValueSet/account-status");
        test:assertEquals(actual.detail().issues[0].diagnostic, string `Already there is a ValueSet exists in the registry with the URL: ${duplicateEntryUrl}`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset3() returns error? {
    json data = readJsonData("value_sets/account-status");
    string duplicateEntryUrl = "http://hl7.org/fhir/ValueSet/account-status";

    r4:ValueSet valueSet = check data.cloneWithType(r4:ValueSet);
    r4:FHIRError[]? actual = addValueSets([valueSet]);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
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
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), "Invalid data. Cannot parse the provided json data: {} due to Please check the provided json structure and re-try with this data again");
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset5() {
    json data = readJsonData("value_sets/account-status-without-url");
    r4:FHIRError[]? actual = addValueSetsAsJson([data]);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Cannot find the URL of the ValueSet with name: AccountStatus due to Add a proper URL for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.url`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset6() {
    json data = readJsonData("value_sets/account-status-without-version");
    r4:FHIRError[]? actual = addValueSetsAsJson([data]);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Cannot find the version of the ValueSet with name: AccountStatus due to Add appropriate version for the resource: http://hl7.org/fhir/R4/valueset-definitions.html#ValueSet.version`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "failure_scenario"]
}
function addValueset7() {
    json data = readJsonData("value_sets/account-status-incorrect");
    r4:FHIRError[]? actual = addValueSetsAsJson([data]);
    test:assertTrue(actual is r4:FHIRError[], "Expected an array of FHIRError");
    if actual is r4:FHIRError[] && actual.length() > 0 {
        test:assertEquals(actual[0].message(), string `Validation failed due to Check whether the data conforms to the specification: http://hl7.org/fhir/R4/valueset-definitions.html`);
    }
}

@test:Config {
    groups: ["valueset", "add_valueset", "successful_scenario"]
}
function addValueset8() {
    r4:ValueSet vs = {
        url: "http://example.org/vs111",
        version: "1.0.0",
        name: "Example ValueSet 1",
        title: "Example ValueSet 1",
        status: "active",
        compose: {
            include: [
                {
                    system: "http://example.org/cs1",
                    concept: [
                        {
                            code: "1",
                            display: "Code 1"
                        },
                        {
                            code: "2",
                            display: "Code 2"
                        }
                    ]
                }
            ]
        }
    };
    r4:FHIRError? actual = addValueSet(vs);
    test:assertTrue(actual !is r4:FHIRError, "Expected a FHIRError");
}

# This test verifies the response when a typical source and target value set URLs are sent in the translate request.
# The result should contain a parameter resource with the matching code for the provided code and the system.
@test:Config {
    groups: ["translate"]
}
function translateTestHappyPath() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/account-status";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/resource-status";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                system: "http://hl7.org/fhir/account-status",
                code: "active"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/correct_response"));
}

# This test verifies the response when a only the source value set URL is sent in the translate request.
# The result should contain a parameter resource with all the matching codes for the provided code and the system.
@test:Config {
    groups: ["translate"]
}
function translateTestHappyPathWithoutTargetValueSetUri() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/account-status";
    r4:uri? valueSet2Url = ();
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                system: "http://hl7.org/fhir/account-status",
                code: "active"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/correct_response"));
}

# translateTestWithoutCodeSystem
# 
# This test verifies the repsonse when only a code is provided without a code system. In this case, the response should
# contain all the matching target codes available in the concept map that matches the provided source and target URLs.
@test:Config {
    groups: ["translate"]
}
function translateTestWithoutCodeSystem() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/account-status";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/resource-status";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                code: "active"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/correct_response_without_system"));
}

# translateTestWithWrongCodeSystem
# 
# This test verifies the response when a code is sent with an incorrect code system. In this case, the response should
# contain no matches.
@test:Config {
    groups: ["translate"]
}
function translateTestWithWrongCodeSystem() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/account-status";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/resource-status";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                system: "wrongCodeSystem",
                code: "active"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/response_with_no_matches"));
}

# translateTestWithMultipleCodes
# 
# This test verifies the response when multiple codes are there for matching. In this case, the response should contain
# All the matches for all the provided codes since the code systems are not provided with the codes.
@test:Config {
    groups: ["translate"]
}
function translateTestWithMultipleCodes() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/administrative-gender";
    r4:uri valueSet2Url = "http://terminology.hl7.org/ValueSet/v2-0001";

    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                code: "other"
            },
            {
                code: "female"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/response_for_multiple_codes"));
}

# translateTestForMultipleConceptMapsWithMultipleCodes
#
# This test verifies the response when multiple codes are provided across different concept maps. The response should
# contain all the matches for all the provided codes in all the available concept maps that matches the provided source
# and target value set URLs.
@test:Config {
    groups: ["translate"]
}
function translateTestForMultipleConceptMapsWithMultipleCodes() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/account-status";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/resource-status";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                code: "active"
            },
            {
                code: "inactive"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/response_for_multiple_concept_maps_with_multiple_codes"));
}

# translateTestWithoutCode
#
# This test verifies the response when no code is provided in the CodeableConcept. 
# The response should indicate that no code was provided.
@test:Config {
    groups: ["translate"]
}
function translateTestWithoutCode() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/administrative-gender";
    r4:uri valueSet2Url = "http://terminology.hl7.org/ValueSet/v2-0001";

    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                system: "http://hl7.org/fhir/administrative-gender"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/response_with_no_matches"));
}

# translateWithWrongCode
#
# This test verifies the response when an incorrect code is provided in the CodeableConcept.
@test:Config {
    groups: ["translate"]
}
function translateWithWrongCode() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/account-status";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/resource-status";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                system: "http://hl7.org/fhir/account-status",
                code: "wrongCode"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/response_with_no_matches"));
}

# translateTestWithoutSourceValueSet
#
# This test verifies the response when no source value set is provided.
@test:Config {
    groups: ["translate"]
}
function translateTestWithoutSourceValueSet() {

    r4:uri valueSet1Url = "";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/resource-status";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                system: "http://hl7.org/fhir/account-status",
                code: "active"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertTrue(result is r4:OperationOutcome);
    test:assertEquals((<r4:OperationOutcome>result).issue[0].details?.text, "Source value set URI should be provided");
}

# translateTestWithIncorrectSourceValueSet
#
# This test verifies the response when an incorrect source value set is provided.
@test:Config {
    groups: ["translate"]
}
function translateTestWithIncorrectSourceValueSet() {

    r4:uri valueSet1Url = "http://www.google.com";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/resource-status";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                system: "http://hl7.org/fhir/account-status",
                code: "active"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertTrue(result is r4:OperationOutcome);
    test:assertEquals((<r4:OperationOutcome>result).issue[0].details?.text, "Concept map not found for provided source and target value sets");
}

# translateTestForUnmappedFixed
#
# This test verifies the response when the provided code is not matched with any code in the target value set and 
# the unmapped field mode is fixed. The response should contain the code defined in the unmapped field of the concept
# map.
@test:Config {
    groups: ["translate"]
}
function translateTestForUnmappedFixed() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/fixed1";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/fixed2";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                code: "fixed"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/response_for_unmapped_fixed"));
}

# translateTestForUnmappedProvided
#
# This test verifies the response when the provided code is not matched with any code in the target value set and
# the unmapped field mode is provided. The response should contain the source code as the matched code.
@test:Config {
    groups: ["translate"]
}
function translateTestForUnmappedProvided() {

    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/provided1";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/provided2";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                code: "provided"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/response_for_unmapped_provided"));
}

# translateTestForUnmappedOtherMap
#
# This test verifies the response when the provided code is not matched with any code in the target value set and
# the unmapped field mode is otherMap. The response should contain the matching codes from the concept map retrieved
# using the URL provided in the unmapped field of the original concept map.
@test:Config {
    groups: ["translate"]
}
function translateTestForUnmappedOtherMap() {

    r4:uri valueSet1Url = "http://example.org/fhir/example1";
    r4:uri valueSet2Url = "http://example.org/fhir/example2";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                code: "otherMapCode"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/response_for_unmapped_other_map"));
}

@test:Config {
    groups: ["conceptmap"]
}
function testAddConceptMap() returns error? {

    r4:ConceptMap conceptMapToAdd = {url: "http://example.org/fhir/ConceptMap/conceptMapToAdd", 'version: "4.1.0", status: "unknown"};
    TestTerminology customTerminology = new ();
    check addConceptMap(conceptMapToAdd, customTerminology);
    r4:ConceptMap|r4:FHIRError foundMap = readConceptMap("http://example.org/fhir/ConceptMap/conceptMapToAdd", (), customTerminology);
    if foundMap is r4:ConceptMap {
        test:assertEquals(foundMap.url, conceptMapToAdd.url);
        test:assertEquals(foundMap.status, conceptMapToAdd.status);
    }  
}

@test:Config {
    groups: ["conceptmap"]
}
function testSearchConceptMap() returns error? {

    TestTerminology customTerminology = new ();
    string conceptMapUrl = "http://hl7.org/fhir/ConceptMap/cm-address-type-v3";
    map<r4:RequestSearchParameter[]> searchParameters = {"url": [{name: "url", value: conceptMapUrl, typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:URI}], "_count": [{name: "_count", value: "10", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]};
    r4:ConceptMap[] foundConceptMaps = check searchConceptMaps(searchParameters, customTerminology);
    test:assertTrue(foundConceptMaps.length() > 0);
    test:assertEquals(conceptMapUrl, foundConceptMaps[0].url);

    string version = "4.0.1";
    map<r4:RequestSearchParameter[]> searchParameters2 = {"version": [{name: "version", value: version, typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:STRING}], "_count": [{name: "_count", value: "10", typedValue: {modifier: r4:MODIFIER_EXACT}, 'type: r4:NUMBER}]};
    r4:ConceptMap[] foundConceptMaps2 = check searchConceptMaps(searchParameters2, customTerminology);
    test:assertTrue(foundConceptMaps2.length() == 10);
}

# translateTestForUnmappedOtherMapLevel2
# 
# This test verifies the translation of the provided code when there are two levels of "other-map" URLs.
# When the first concept map doesn't contain any matches, the code is looked up in the fallback concept map provided in
# the unmapped field of the first concept map. If the second concept map also doesn't contain any matches, the code is
# looked up in the fallback concept map defined in the 2nd concept map.
@test:Config {
    groups: ["translate"]
}
function translateTestForUnmappedOtherMapLevel2() {

    r4:uri valueSet1Url = "http://example.org/fhir/otherMap2example1";
    r4:uri valueSet2Url = "http://example.org/fhir/otherMap2example2";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                code: "otherMapCode"
            }
        ]
    };
    TestTerminology customTerminology = new ();
    r4:Parameters|r4:OperationOutcome result = translate(valueSet1Url, valueSet2Url, codeableConcept, customTerminology);
    test:assertEquals(result, readJsonData("translate_responses/response_for_other_maps_level_two"));
}
