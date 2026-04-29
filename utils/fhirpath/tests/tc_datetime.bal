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

function getDatetimeTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testNow1",
            group: "testNow",
            expression: "Patient.birthDate < now()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNow2",
            group: "testNow",
            expression: "now().toString().length() > 10",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToday1",
            group: "testToday",
            expression: "Patient.birthDate < today()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToday2",
            group: "testToday",
            expression: "today().toString().length() = 10",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testPeriodInvariantOld",
            group: "period",
            expression: "Patient.identifier.period.all(start.hasValue().not() or end.hasValue().not() or (start <= end))",
            resourceKey: "patient_period",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testPeriodInvariantNew",
            group: "period",
            expression: "Patient.identifier.period.all(start.empty() or end.empty() or (start.lowBoundary() < end.highBoundary()))",
            resourceKey: "patient_period",
            expected: [true],
            expectError: false
        }
    ];
}
