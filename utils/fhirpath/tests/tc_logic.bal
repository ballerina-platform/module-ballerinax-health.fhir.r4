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

function getLogicTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testBooleanLogicAnd1",
            group: "testBooleanLogicAnd",
            expression: "(true and true) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicAnd2",
            group: "testBooleanLogicAnd",
            expression: "(true and false) = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicAnd3",
            group: "testBooleanLogicAnd",
            expression: "(true and {}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicAnd4",
            group: "testBooleanLogicAnd",
            expression: "(false and true) = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicAnd5",
            group: "testBooleanLogicAnd",
            expression: "(false and false) = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicAnd6",
            group: "testBooleanLogicAnd",
            expression: "(false and {}) = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicAnd7",
            group: "testBooleanLogicAnd",
            expression: "({} and true).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicAnd8",
            group: "testBooleanLogicAnd",
            expression: "({} and false) = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicAnd9",
            group: "testBooleanLogicAnd",
            expression: "({} and {}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicOr1",
            group: "testBooleanLogicOr",
            expression: "(true or true) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicOr2",
            group: "testBooleanLogicOr",
            expression: "(true or false) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicOr3",
            group: "testBooleanLogicOr",
            expression: "(true or {}) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicOr4",
            group: "testBooleanLogicOr",
            expression: "(false or true) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicOr5",
            group: "testBooleanLogicOr",
            expression: "(false or false) = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicOr6",
            group: "testBooleanLogicOr",
            expression: "(false or {}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicOr7",
            group: "testBooleanLogicOr",
            expression: "({} or true) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicOr8",
            group: "testBooleanLogicOr",
            expression: "({} or false).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicOr9",
            group: "testBooleanLogicOr",
            expression: "({} or {}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicXOr1",
            group: "testBooleanLogicXOr",
            expression: "(true xor true) = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicXOr2",
            group: "testBooleanLogicXOr",
            expression: "(true xor false) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicXOr3",
            group: "testBooleanLogicXOr",
            expression: "(true xor {}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicXOr4",
            group: "testBooleanLogicXOr",
            expression: "(false xor true) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicXOr5",
            group: "testBooleanLogicXOr",
            expression: "(false xor false) = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicXOr6",
            group: "testBooleanLogicXOr",
            expression: "(false xor {}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicXOr7",
            group: "testBooleanLogicXOr",
            expression: "({} xor true).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicXOr8",
            group: "testBooleanLogicXOr",
            expression: "({} xor false).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLogicXOr9",
            group: "testBooleanLogicXOr",
            expression: "({} xor {}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanImplies1",
            group: "testBooleanImplies",
            expression: "(true implies true) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanImplies2",
            group: "testBooleanImplies",
            expression: "(true implies false) = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanImplies3",
            group: "testBooleanImplies",
            expression: "(true implies {}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanImplies4",
            group: "testBooleanImplies",
            expression: "(false implies true) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanImplies5",
            group: "testBooleanImplies",
            expression: "(false implies false) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanImplies6",
            group: "testBooleanImplies",
            expression: "(false implies {}) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanImplies7",
            group: "testBooleanImplies",
            expression: "({} implies true) = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanImplies8",
            group: "testBooleanImplies",
            expression: "({} implies false).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanImplies9",
            group: "testBooleanImplies",
            expression: "({} implies {}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCollectionBoolean1",
            group: "testCollectionBoolean",
            expression: "iif(1 | 2 | 3, true, false)",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testCollectionBoolean2",
            group: "testCollectionBoolean",
            expression: "iif({}, true, false)",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testCollectionBoolean3",
            group: "testCollectionBoolean",
            expression: "iif(true, true, false)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCollectionBoolean4",
            group: "testCollectionBoolean",
            expression: "iif({} | true, true, false)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCollectionBoolean5",
            group: "testCollectionBoolean",
            expression: "iif(true, true, 1/0)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCollectionBoolean6",
            group: "testCollectionBoolean",
            expression: "iif(false, 1/0, true)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        }
    ];
}
