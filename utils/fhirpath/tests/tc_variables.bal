// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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

function getVariablesTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_defineVariable1",
            group: "defineVariable",
            expression: "defineVariable('v1', 'value1').select(%v1)",
            resourceKey: "patient",
            expected: ["value1"],
            expectError: false
        },
        {
            name: "test_defineVariable2",
            group: "defineVariable",
            expression: "defineVariable('n1', name.first()).select(%n1.given)",
            resourceKey: "patient",
            expected: ["Peter", "James"],
            expectError: false
        },
        {
            name: "test_defineVariable3",
            group: "defineVariable",
            expression: "defineVariable('n1', name.first()).select(%n1.given).first()",
            resourceKey: "patient",
            expected: ["Peter"],
            expectError: false
        },
        {
            name: "test_defineVariable4",
            group: "defineVariable",
            expression: "defineVariable('n1', name.first()).select(%n1.given) | defineVariable('n1', name.skip(1).first()).select(%n1.given)",
            resourceKey: "patient",
            expected: ["Peter", "James", "Jim"],
            expectError: false
        },
        {
            name: "test_defineVariable5",
            group: "defineVariable",
            expression: "defineVariable('n1', name.first()).where(active.not()) | defineVariable('n1', name.skip(1).first()).select(%n1.given)",
            resourceKey: "patient",
            expected: ["Jim"],
            expectError: false
        },
        {
            name: "test_defineVariable6",
            group: "defineVariable",
            expression: "defineVariable('n1', name.first()).select(id & '-' & %n1.given.join('|')) | defineVariable('n2', name.skip(1).first()).select(%n2.given)",
            resourceKey: "patient",
            expected: ["example-Peter|James", "Jim"],
            expectError: false
        },
        {
            name: "test_defineVariable7",
            group: "defineVariable",
            expression: "defineVariable('n1', name.first()).active | defineVariable('n2', name.skip(1).first()).select(%n2.given)",
            resourceKey: "patient",
            expected: [true, "Jim"],
            expectError: false
        },
        {
            name: "test_defineVariable8",
            group: "defineVariable",
            expression: "defineVariable('v1', 'value1').select(%v1).trace('data').defineVariable('v2', 'value2').select($this & ':' & %v1 & '-' & %v2) | defineVariable('v3', 'value3').select(%v3)",
            resourceKey: "patient",
            expected: ["value1:value1-value2", "value3"],
            expectError: false
        },
        {
            name: "test_defineVariable9",
            group: "defineVariable",
            expression: "defineVariable('n1', name.first()).active | defineVariable('n2', name.skip(1).first()).select(%n1.given)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_defineVariable10",
            group: "defineVariable",
            expression: "select(%fam.given)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_dvRedefiningVariableThrowsError",
            group: "defineVariable",
            expression: "defineVariable('v1').defineVariable('v1').select(%v1)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_defineVariable12",
            group: "defineVariable",
            expression: "Patient.name.defineVariable('n1', first()).active | Patient.name.defineVariable('n2', skip(1).first()).select(%n1.given)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_defineVariable13",
            group: "defineVariable",
            expression: "Patient.name.defineVariable('n2', skip(1).first()).defineVariable('res', %n2.given+%n2.given).select(%res)",
            resourceKey: "patient",
            expected: ["JimJim", "JimJim", "JimJim"],
            expectError: false
        },
        {
            name: "test_defineVariable14",
            group: "defineVariable",
            expression: "Patient.name.defineVariable('n1', first()).select(%n1).exists() | Patient.name.defineVariable('n2', skip(1).first()).defineVariable('res', %n2.given+%n2.given).select(%res)",
            resourceKey: "patient",
            expected: [true, "JimJim"],
            expectError: false
        },
        {
            name: "test_defineVariable15",
            group: "defineVariable",
            expression: "defineVariable('root', 'r1-').select(defineVariable('v1', 'v1').defineVariable('v2', 'v2').select(%v1 | %v2)).select(%root & $this)",
            resourceKey: "patient",
            expected: ["r1-v1", "r1-v2"],
            expectError: false
        },
        {
            name: "test_defineVariable16",
            group: "defineVariable",
            expression: "defineVariable('root', 'r1-').select(defineVariable('v1', 'v1').defineVariable('v2', 'v2').select(%v1 | %v2)).select(%root & $this & %v1)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_dvCantOverwriteSystemVar",
            group: "defineVariable",
            expression: "defineVariable('context', 'oops')",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_dvConceptMapExample",
            group: "defineVariable",
            expression: "group.select( defineVariable('grp') .element .select( defineVariable('ele') .target .select(%grp.source & '|' & %ele.code & ' ' & relationship & ' ' & %grp.target & '|' & code) ) ) .trace('all') .isDistinct()",
            resourceKey: "conceptmap",
            expected: [false],
            expectError: false
        },
        {
            name: "test_defineVariable19",
            group: "defineVariable",
            expression: "defineVariable(defineVariable('param','ppp').select(%param), defineVariable('param','value').select(%param)).select(%ppp)",
            resourceKey: "patient",
            expected: ["value"],
            expectError: false
        },
        {
            name: "test_dvParametersDontColide",
            group: "defineVariable",
            expression: "'aaa'.replace(defineVariable('param', 'aaa').select(%param), defineVariable('param','bbb').select(%param))",
            resourceKey: "patient",
            expected: ["bbb"],
            expectError: false
        },
        {
            name: "test_dvUsageOutsideScopeThrows",
            group: "defineVariable",
            expression: "defineVariable('n1', 'v1').active | defineVariable('n2', 'v2').select(%n1)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testVariables1",
            group: "testVariables",
            expression: "%sct = 'http://snomed.info/sct'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testVariables2",
            group: "testVariables",
            expression: "%loinc = 'http://loinc.org'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testVariables3",
            group: "testVariables",
            expression: "%ucum = 'http://unitsofmeasure.org'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testVariables4",
            group: "testVariables",
            expression: "%`vs-administrative-gender` = 'http://hl7.org/fhir/ValueSet/administrative-gender'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        }
    ];
}
