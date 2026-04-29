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

function getMathTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testAbs1",
            group: "testAbs",
            expression: "(-5).abs() = 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testAbs2",
            group: "testAbs",
            expression: "(-5.5).abs() = 5.5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testAbs3",
            group: "testAbs",
            expression: "(-5.5 'mg').abs() = 5.5 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testAbsEmpty",
            group: "testAbs",
            expression: "{}.abs().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCeiling1",
            group: "testCeiling",
            expression: "1.ceiling() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCeiling2",
            group: "testCeiling",
            expression: "(-1.1).ceiling() = -1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCeiling3",
            group: "testCeiling",
            expression: "1.1.ceiling() = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCeilingEmpty",
            group: "testCeiling",
            expression: "{}.ceiling().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFloor1",
            group: "testFloor",
            expression: "1.floor() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFloor2",
            group: "testFloor",
            expression: "2.1.floor() = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFloor3",
            group: "testFloor",
            expression: "(-2.1).floor() = -3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFloorEmpty",
            group: "testFloor",
            expression: "{}.floor().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testRound1",
            group: "testRound",
            expression: "1.round() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testRound2",
            group: "testRound",
            expression: "3.14159.round(3) = 3.142",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testRoundEmpty",
            group: "testRound",
            expression: "{}.round().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSqrt1",
            group: "testSqrt",
            expression: "81.sqrt() = 9.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSqrt2",
            group: "testSqrt",
            expression: "(-1).sqrt()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testSqrtEmpty",
            group: "testSqrt",
            expression: "{}.sqrt().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testExp1",
            group: "testExp",
            expression: "0.exp() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testExp2",
            group: "testExp",
            expression: "(-0.0).exp() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testExp3",
            group: "testExp",
            expression: "{}.exp().empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLn1",
            group: "testLn",
            expression: "1.ln() = 0.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLn2",
            group: "testLn",
            expression: "1.0.ln() = 0.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLnEmpty",
            group: "testLn",
            expression: "{}.ln().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLog1",
            group: "testLog",
            expression: "16.log(2) = 4.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLog2",
            group: "testLog",
            expression: "100.0.log(10.0) = 2.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLogEmpty",
            group: "testLog",
            expression: "{}.log(10).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLogEmpty2",
            group: "testLog",
            expression: "{}.log({}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLogEmpty3",
            group: "testLog",
            expression: "16.log({}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTruncate1",
            group: "testTruncate",
            expression: "101.truncate() = 101",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTruncate2",
            group: "testTruncate",
            expression: "1.00000001.truncate() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTruncate3",
            group: "testTruncate",
            expression: "(-1.56).truncate() = -1",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testTruncateEmpty",
            group: "testTruncate",
            expression: "{}.truncate().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        }
    ];
}
