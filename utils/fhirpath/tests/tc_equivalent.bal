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

function getEquivalentTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testEquivalent1",
            group: "testEquivalent",
            expression: "1 ~ 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent2",
            group: "testEquivalent",
            expression: "{} ~ {}",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent3",
            group: "testEquivalent",
            expression: "1 ~ {}",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquivalent4",
            group: "testEquivalent",
            expression: "1 ~ 2",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquivalent5",
            group: "testEquivalent",
            expression: "'a' ~ 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent6",
            group: "testEquivalent",
            expression: "'a' ~ 'A'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent7",
            group: "testEquivalent",
            expression: "'a' ~ 'b'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquivalent8",
            group: "testEquivalent",
            expression: "1.1 ~ 1.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent9",
            group: "testEquivalent",
            expression: "1.1 ~ 1.2",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testEquivalent10",
            group: "testEquivalent",
            expression: "1.10 ~ 1.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent11",
            group: "testEquivalent",
            expression: "1.2 / 1.8 ~ 0.67",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testEquivalent12",
            group: "testEquivalent",
            expression: "0 ~ 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent13",
            group: "testEquivalent",
            expression: "0.0 ~ 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent14",
            group: "testEquivalent",
            expression: "@2012-04-15 ~ @2012-04-15",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent15",
            group: "testEquivalent",
            expression: "@2012-04-15 ~ @2012-04-16",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquivalent16",
            group: "testEquivalent",
            expression: "@2012-04-15 ~ @2012-04-15T10:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquivalent17",
            group: "testEquivalent",
            expression: "@2012-04-15T15:30:31 ~ @2012-04-15T15:30:31.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent18",
            group: "testEquivalent",
            expression: "@2012-04-15T15:30:31 ~ @2012-04-15T15:30:31.1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquivalent19",
            group: "testEquivalent",
            expression: "name ~ name",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testEquivalent20",
            group: "testEquivalent",
            expression: "name.take(2).given ~ name.take(2).first().given | name.take(2).last().given",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent21",
            group: "testEquivalent",
            expression: "name.take(2).given ~ name.take(2).last().given | name.take(2).first().given",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent22",
            group: "testEquivalent",
            expression: "Observation.value ~ 185 '[lb_av]'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent23",
            group: "testEquivalent",
            expression: "(1 | 2 | 3) ~ (1 | 2 | 3)",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent24",
            group: "testEquivalent",
            expression: "(1 | 2 | 3) ~ (3 | 2 | 1)",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEquivalent1",
            group: "testNotEquivalent",
            expression: "1 !~ 1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent2",
            group: "testNotEquivalent",
            expression: "{} !~ {}",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent3",
            group: "testNotEquivalent",
            expression: "{} !~ 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEquivalent4",
            group: "testNotEquivalent",
            expression: "1 !~ 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEquivalent5",
            group: "testNotEquivalent",
            expression: "'a' !~ 'a'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent6",
            group: "testNotEquivalent",
            expression: "'a' !~ 'A'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent7",
            group: "testNotEquivalent",
            expression: "'a' !~ 'b'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEquivalent8",
            group: "testNotEquivalent",
            expression: "1.1 !~ 1.1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent9",
            group: "testNotEquivalent",
            expression: "1.1 !~ 1.2",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testNotEquivalent10",
            group: "testNotEquivalent",
            expression: "1.10 !~ 1.1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent11",
            group: "testNotEquivalent",
            expression: "0 !~ 0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent12",
            group: "testNotEquivalent",
            expression: "0.0 !~ 0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent13",
            group: "testNotEquivalent",
            expression: "1.2 / 1.8 !~ 0.6",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEquivalent14",
            group: "testNotEquivalent",
            expression: "@2012-04-15 !~ @2012-04-15",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent15",
            group: "testNotEquivalent",
            expression: "@2012-04-15 !~ @2012-04-16",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEquivalent16",
            group: "testNotEquivalent",
            expression: "@2012-04-15 !~ @2012-04-15T10:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEquivalent17",
            group: "testNotEquivalent",
            expression: "@2012-04-15T15:30:31 !~ @2012-04-15T15:30:31.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent18",
            group: "testNotEquivalent",
            expression: "@2012-04-15T15:30:31 !~ @2012-04-15T15:30:31.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEquivalent19",
            group: "testNotEquivalent",
            expression: "name !~ name",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testNotEquivalent20",
            group: "testNotEquivalent",
            expression: "name.take(2).given !~ name.take(2).first().given | name.take(2).last().given",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent21",
            group: "testNotEquivalent",
            expression: "name.take(2).given !~ name.take(2).last().given | name.take(2).first().given",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNotEquivalent22",
            group: "testNotEquivalent",
            expression: "Observation.value !~ 185 'kg'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        }
    ];
}
