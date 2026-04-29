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

function getEqualityTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testEquality1",
            group: "testEquality",
            expression: "1 = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality2",
            group: "testEquality",
            expression: "{} = {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testEquality3",
            group: "testEquality",
            expression: "true = {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testEquality4",
            group: "testEquality",
            expression: "(1) = (1)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality5",
            group: "testEquality",
            expression: "(1 | 2) = (1 | 2)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality6",
            group: "testEquality",
            expression: "(1 | 2 | 3) = (1 | 2 | 3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality7",
            group: "testEquality",
            expression: "(1 | 1) = (1 | 2 | {})",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality8",
            group: "testEquality",
            expression: "1 = 2",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality9",
            group: "testEquality",
            expression: "'a' = 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality10",
            group: "testEquality",
            expression: "'a' = 'A'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality11",
            group: "testEquality",
            expression: "'a' = 'b'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality12",
            group: "testEquality",
            expression: "1.1 = 1.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality13",
            group: "testEquality",
            expression: "1.1 = 1.2",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality14",
            group: "testEquality",
            expression: "1.10 = 1.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality15",
            group: "testEquality",
            expression: "0 = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality16",
            group: "testEquality",
            expression: "0.0 = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality17",
            group: "testEquality",
            expression: "@2012-04-15 = @2012-04-15",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality18",
            group: "testEquality",
            expression: "@2012-04-15 = @2012-04-16",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality19",
            group: "testEquality",
            expression: "@2012-04-15 = @2012-04-15T10:00:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testEquality20",
            group: "testEquality",
            expression: "@2012-04-15T15:00:00 = @2012-04-15T10:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality21",
            group: "testEquality",
            expression: "@2012-04-15T15:30:31 = @2012-04-15T15:30:31.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality22",
            group: "testEquality",
            expression: "@2012-04-15T15:30:31 = @2012-04-15T15:30:31.1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality23",
            group: "testEquality",
            expression: "@2012-04-15T15:00:00Z = @2012-04-15T10:00:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testEquality24",
            group: "testEquality",
            expression: "@2012-04-15T15:00:00+02:00 = @2012-04-15T16:00:00+03:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality25",
            group: "testEquality",
            expression: "name = name",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testEquality26",
            group: "testEquality",
            expression: "name.take(2) = name.take(2).first() | name.take(2).last()",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testEquality27",
            group: "testEquality",
            expression: "name.take(2) = name.take(2).last() | name.take(2).first()",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testEquality28",
            group: "testEquality",
            expression: "Observation.value = 185 '[lb_av]'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNEquality1",
            group: "testNEquality",
            expression: "1 != 1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality2",
            group: "testNEquality",
            expression: "{} != {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNEquality3",
            group: "testNEquality",
            expression: "1 != 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNEquality4",
            group: "testNEquality",
            expression: "'a' != 'a'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality5",
            group: "testNEquality",
            expression: "'a' != 'b'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNEquality6",
            group: "testNEquality",
            expression: "1.1 != 1.1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality7",
            group: "testNEquality",
            expression: "1.1 != 1.2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNEquality8",
            group: "testNEquality",
            expression: "1.10 != 1.1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality9",
            group: "testNEquality",
            expression: "0 != 0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality10",
            group: "testNEquality",
            expression: "0.0 != 0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality11",
            group: "testNEquality",
            expression: "@2012-04-15 != @2012-04-15",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality12",
            group: "testNEquality",
            expression: "@2012-04-15 != @2012-04-16",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNEquality13",
            group: "testNEquality",
            expression: "@2012-04-15 != @2012-04-15T10:00:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNEquality14",
            group: "testNEquality",
            expression: "@2012-04-15T15:00:00 != @2012-04-15T10:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNEquality15",
            group: "testNEquality",
            expression: "@2012-04-15T15:30:31 != @2012-04-15T15:30:31.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality16",
            group: "testNEquality",
            expression: "@2012-04-15T15:30:31 != @2012-04-15T15:30:31.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNEquality17",
            group: "testNEquality",
            expression: "@2012-04-15T15:00:00Z != @2012-04-15T10:00:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNEquality18",
            group: "testNEquality",
            expression: "@2012-04-15T15:00:00+02:00 != @2012-04-15T16:00:00+03:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality19",
            group: "testNEquality",
            expression: "name != name",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testNEquality20",
            group: "testNEquality",
            expression: "name.take(2) != name.take(2).first() | name.take(2).last()",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testNEquality21",
            group: "testNEquality",
            expression: "name.take(2) != name.take(2).last() | name.take(2).first()",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testNEquality22",
            group: "testNEquality",
            expression: "(1.2 / 1.8).round(2) != 0.6666667",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNEquality23",
            group: "testNEquality",
            expression: "(1.2 / 1.8).round(2) != 0.67",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNEquality24",
            group: "testNEquality",
            expression: "Observation.value != 185 'kg'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_Comparable1",
            group: "Comparable",
            expression: "1 'cm'.comparable(1 '[in_i]')",
            resourceKey: "empty",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_Comparable2",
            group: "Comparable",
            expression: "1 'cm'.comparable(1 '[s]')",
            resourceKey: "empty",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_Comparable3",
            group: "Comparable",
            expression: "1 'cm'.comparable(1 's')",
            resourceKey: "empty",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        }
    ];
}
