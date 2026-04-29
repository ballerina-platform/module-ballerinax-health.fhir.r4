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

function getBasicsTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testSimple",
            group: "testBasics",
            expression: "name.given",
            resourceKey: "patient",
            expected: ["Peter", "James", "Jim", "Peter", "James"],
            expectError: false
        },
        {
            name: "test_testSimpleNone",
            group: "testBasics",
            expression: "name.suffix",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testEscapedIdentifier",
            group: "testBasics",
            expression: "name.`given`",
            resourceKey: "patient",
            expected: ["Peter", "James", "Jim", "Peter", "James"],
            expectError: false
        },
        {
            name: "test_testSimpleBackTick1",
            group: "testBasics",
            expression: "`Patient`.name.`given`",
            resourceKey: "patient",
            expected: ["Peter", "James", "Jim", "Peter", "James"],
            expectError: false
        },
        {
            name: "test_testSimpleFail",
            group: "testBasics",
            expression: "name.given1",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testSimpleWithContext",
            group: "testBasics",
            expression: "Patient.name.given",
            resourceKey: "patient",
            expected: ["Peter", "James", "Jim", "Peter", "James"],
            expectError: false
        },
        {
            name: "test_testSimpleWithWrongContext",
            group: "testBasics",
            expression: "Encounter.name.given",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        }
    ];
}
