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

function getMiscTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testTrace1",
            group: "testTrace",
            expression: "name.given.trace('test').count() = 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTrace2",
            group: "testTrace",
            expression: "name.trace('test', given).count() = 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testComment1",
            group: "comments",
            expression: "2 + 2 // This is a single-line comment + 4",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_testComment2",
            group: "comments",
            expression: "// This is a multi line comment using // that\r\n  // should not fail during parsing\r\n  2+2",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_testComment3",
            group: "comments",
            expression: "2 + 2 /* This is a multi-line comment Any text enclosed within is ignored +2 */",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_testComment4",
            group: "comments",
            expression: "2 + 2 /* This is a multi-line comment Any text enclosed within is ignored */ +2",
            resourceKey: "patient",
            expected: [6],
            expectError: false
        },
        {
            name: "test_testComment5",
            group: "comments",
            expression: "/* This is a multi-line comment Any text enclosed within is ignored */ 2+2",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_testComment6",
            group: "comments",
            expression: "2 // comment / 2",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_testComment7",
            group: "comments",
            expression: "2 + 2 /",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testComment8",
            group: "comments",
            expression: "2 + 2 /* not finished",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testComment9",
            group: "comments",
            expression: "2 + /* inline $@%^+ * */ 2 = 4",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPrecedence1",
            group: "testPrecedence",
            expression: "-1.convertsToInteger()",
            resourceKey: "empty",
            expected: [],
            expectError: true
        },
        {
            name: "test_testPrecedence2",
            group: "testPrecedence",
            expression: "1+2*3+4 = 11",
            resourceKey: "empty",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPrecedence3",
            group: "testPrecedence",
            expression: "1 > 2 is Boolean",
            resourceKey: "empty",
            expected: [],
            expectError: true
        },
        {
            name: "test_testPrecedence4",
            group: "testPrecedence",
            expression: "(1 | 1 is Integer).count()",
            resourceKey: "empty",
            expected: [2],
            expectError: false
        },
        {
            name: "test_testPrecedence5",
            group: "testPrecedence",
            expression: "true and '0215' in ('0215' | '0216')",
            resourceKey: "empty",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPrecedence6",
            group: "testPrecedence",
            expression: "category.exists(coding.exists(system = 'http://terminology.hl7.org/CodeSystem/observation-category' and code.trace('c') in ('vital-signs' | 'vital-signs2').trace('codes')))",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIif1",
            group: "testIif",
            expression: "iif(Patient.name.exists(), 'named', 'unnamed') = 'named'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIif2",
            group: "testIif",
            expression: "iif(Patient.name.empty(), 'unnamed', 'named') = 'named'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIif3",
            group: "testIif",
            expression: "iif(true, true, (1 | 2).toString())",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIif4",
            group: "testIif",
            expression: "iif(false, (1 | 2).toString(), true)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIif5",
            group: "testIif",
            expression: "iif(false, 'true-result').empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIif6",
            group: "testIif",
            expression: "iif('non boolean criteria', 'true-result', 'false-result')",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testIif7",
            group: "testIif",
            expression: "{}.iif(true, 'true-result', 'false-result')",
            resourceKey: "patient",
            expected: ["true-result"],
            expectError: false
        },
        {
            name: "test_testIif8",
            group: "testIif",
            expression: "('item').iif(true, 'true-result', 'false-result')",
            resourceKey: "patient",
            expected: ["true-result"],
            expectError: false
        },
        {
            name: "test_testIif9",
            group: "testIif",
            expression: "('context').iif(true, select($this), 'false-result')",
            resourceKey: "patient",
            expected: ["context"],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testIif10",
            group: "testIif",
            expression: "('item1' | 'item2').iif(true, 'true-result', 'false-result')",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testIif11",
            group: "testIif",
            expression: "('context').iif($this = 'context','true-result', 'false-result')",
            resourceKey: "patient",
            expected: ["true-result"],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testIif12",
            group: "testIif",
            expression: "Patient.name.first().iif(text.exists(), text, family+given.first())",
            resourceKey: "patient_name",
            expected: ["Pater J Chalmers"],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testSort1",
            group: "testSort",
            expression: "(1 | 2 | 3).sort() = (1 | 2 | 3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSort2",
            group: "testSort",
            expression: "(3 | 2 | 1).sort() = (1 | 2 | 3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSort3",
            group: "testSort",
            expression: "(1 | 2 | 3).sort($this) = (1 | 2 | 3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSort4",
            group: "testSort",
            expression: "(3 | 2 | 1).sort($this) = (1 | 2 | 3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSort5",
            group: "testSort",
            expression: "(1 | 2 | 3).sort(-$this) = (3 | 2 | 1)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSort6",
            group: "testSort",
            expression: "('a' | 'b' | 'c').sort($this) = ('a' | 'b' | 'c')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSort7",
            group: "testSort",
            expression: "('c' | 'b' | 'a').sort($this) = ('a' | 'b' | 'c')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSort8",
            group: "testSort",
            expression: "('a' | 'b' | 'c').sort(-$this) = ('c' | 'b' | 'a')",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testSort9",
            group: "testSort",
            expression: "Patient.name[0].given.sort() = ('James' | 'Peter')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSort10",
            group: "testSort",
            expression: "Patient.name.sort(-family, -given.first()).first().use = 'usual'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity1",
            group: "testQuantity",
            expression: "4.0000 'g' = 4000.0 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity2",
            group: "testQuantity",
            expression: "4 'g' ~ 4000 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity3",
            group: "testQuantity",
            expression: "4 'g' != 4040 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testQuantity4",
            group: "testQuantity",
            expression: "4 'g' ~ 4040 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity5",
            group: "testQuantity",
            expression: "7 days = 1 week",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity6",
            group: "testQuantity",
            expression: "7 days = 1 'wk'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity7",
            group: "testQuantity",
            expression: "6 days < 1 week",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity8",
            group: "testQuantity",
            expression: "8 days > 1 week",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity9",
            group: "testQuantity",
            expression: "2.0 'cm' * 2.0 'm' = 0.040 'm2'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity10",
            group: "testQuantity",
            expression: "4.0 'g' / 2.0 'm' = 2 'g/m'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testQuantity11",
            group: "testQuantity",
            expression: "1.0 'm' / 1.0 'm' = 1 '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        }
    ];
}
