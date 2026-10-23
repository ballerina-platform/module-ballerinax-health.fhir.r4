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

// Strict mode: compile-time checks of navigation against the FHIR R4 model (opt-in)
function getStrictModeTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_strictValidPath",
            group: "testStrictMode",
            expression: "Patient.name.given.first()",
            resourceKey: "patient",
            expected: ["Peter"],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidFilter",
            group: "testStrictMode",
            expression: "Patient.name.where(use = 'official').family",
            resourceKey: "patient",
            expected: ["Chalmers"],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidBackbone",
            group: "testStrictMode",
            expression: "Patient.contact.name.family.exists()",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidChoiceBase",
            group: "testStrictMode",
            expression: "Observation.value.unit",
            resourceKey: "observation",
            expected: ["lbs"],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidOfType",
            group: "testStrictMode",
            expression: "Observation.value.ofType(Quantity).unit",
            resourceKey: "observation",
            expected: ["lbs"],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidAs",
            group: "testStrictMode",
            expression: "(Observation.value as Quantity).unit",
            resourceKey: "observation",
            expected: ["lbs"],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidPrimitiveExtension",
            group: "testStrictMode",
            expression: "Patient.birthDate.extension.exists()",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidContentReference",
            group: "testStrictMode",
            expression: "Questionnaire.item.item.linkId.exists()",
            resourceKey: "questionnaire",
            expected: [true],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidSelect",
            group: "testStrictMode",
            expression: "Patient.name.select(given).count()",
            resourceKey: "patient",
            expected: [5],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidUnion",
            group: "testStrictMode",
            expression: "(Patient.name | Patient.contact.name).family.exists()",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidExtensionValue",
            group: "testStrictMode",
            expression: "Patient.extension('http://example.org/none').value.exists()",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidResourceType",
            group: "testStrictMode",
            expression: "Patient.resourceType",
            resourceKey: "patient",
            expected: ["Patient"],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictValidEnvironment",
            group: "testStrictMode",
            expression: "%resource.name.count()",
            resourceKey: "patient",
            expected: [3],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictUnknownAfterChildren",
            group: "testStrictMode",
            expression: "Patient.children().notAnElement.exists()",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictUnknownContained",
            group: "testStrictMode",
            expression: "Patient.contained.notAnElement.exists()",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            strict: true
        },
        {
            name: "test_strictUnknownElement",
            group: "testStrictMode",
            expression: "Patient.name.given1",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            strict: true
        },
        {
            name: "test_strictWrongContext",
            group: "testStrictMode",
            expression: "Encounter.name",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            strict: true
        },
        {
            name: "test_strictExpandedChoice",
            group: "testStrictMode",
            expression: "Observation.valueQuantity.unit",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true
        },
        {
            name: "test_strictAsType",
            group: "testStrictMode",
            expression: "(Observation.value as Period).unit",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true
        },
        {
            name: "test_strictUnknownInWhere",
            group: "testStrictMode",
            expression: "Patient.name.where(nickname = 'x')",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            strict: true
        },
        {
            name: "test_strictUnknownInSelect",
            group: "testStrictMode",
            expression: "Patient.name.select(given.bar)",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            strict: true
        },
        {
            name: "test_strictPrimitiveNavigation",
            group: "testStrictMode",
            expression: "Patient.birthDate.year",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            strict: true
        },
        {
            name: "test_strictSystemNavigation",
            group: "testStrictMode",
            expression: "'abc'.length",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            strict: true
        },
        {
            name: "test_lenientUnknownElement",
            group: "testStrictMode",
            expression: "Patient.name.given1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        }
    ];
}
