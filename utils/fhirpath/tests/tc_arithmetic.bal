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

function getArithmeticTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testPlus1",
            group: "testPlus",
            expression: "1 + 1 = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPlus2",
            group: "testPlus",
            expression: "1 + 0 = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPlus3",
            group: "testPlus",
            expression: "1.2 + 1.8 = 3.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPlus4",
            group: "testPlus",
            expression: "'a'+'b' = 'ab'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPlus5",
            group: "testPlus",
            expression: "'a'+{}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testPlusDate1",
            group: "testPlus",
            expression: "@1973-12-25 + 7 days",
            resourceKey: "patient",
            expected: ["@1974-01-01"],
            expectError: false
        },
        {
            name: "test_testPlusDate2",
            group: "testPlus",
            expression: "@1973-12-25 + 7.7 days",
            resourceKey: "patient",
            expected: ["@1974-01-01"],
            expectError: false
        },
        {
            name: "test_testPlusDate3",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 7 days",
            resourceKey: "patient",
            expected: ["@1974-01-01T00:00:00.000+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate4",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 7.7 days",
            resourceKey: "patient",
            expected: ["@1974-01-01T00:00:00.000+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate5",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 1 second",
            resourceKey: "patient",
            expected: ["@1973-12-25T00:00:01.000+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate6",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 10 millisecond",
            resourceKey: "patient",
            expected: ["@1973-12-25T00:00:00.010+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate7",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 1 minute",
            resourceKey: "patient",
            expected: ["@1973-12-25T00:01:00.000+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate8",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 1 hour",
            resourceKey: "patient",
            expected: ["@1973-12-25T01:00:00.000+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate9",
            group: "testPlus",
            expression: "@1973-12-25 + 1 day",
            resourceKey: "patient",
            expected: ["@1973-12-26"],
            expectError: false
        },
        {
            name: "test_testPlusDate10",
            group: "testPlus",
            expression: "@1973-12-25 + 1 month",
            resourceKey: "patient",
            expected: ["@1974-01-25"],
            expectError: false
        },
        {
            name: "test_testPlusDate11",
            group: "testPlus",
            expression: "@1973-12-25 + 1 week",
            resourceKey: "patient",
            expected: ["@1974-01-01"],
            expectError: false
        },
        {
            name: "test_testPlusDate12",
            group: "testPlus",
            expression: "@1973-12-25 + 1 year",
            resourceKey: "patient",
            expected: ["@1974-12-25"],
            expectError: false
        },
        {
            name: "test_testPlusDate13",
            group: "testPlus",
            expression: "@1973-12-25 + 1 'd'",
            resourceKey: "patient",
            expected: ["@1973-12-26"],
            expectError: false
        },
        {
            name: "test_testPlusDate14",
            group: "testPlus",
            expression: "@1973-12-25 + 1 'mo'",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testPlusDate15",
            group: "testPlus",
            expression: "@1973-12-25 + 1 'wk'",
            resourceKey: "patient",
            expected: ["@1974-01-01"],
            expectError: false
        },
        {
            name: "test_testPlusDate16",
            group: "testPlus",
            expression: "@1973-12-25 + 1 'a'",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testPlusDate17",
            group: "testPlus",
            expression: "@1975-12-25 + 1 'a'",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testPlusDate18",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 1 's'",
            resourceKey: "patient",
            expected: ["@1973-12-25T00:00:01.000+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate19",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 0.1 's'",
            resourceKey: "patient",
            expected: ["@1973-12-25T00:00:00.100+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate20",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 10 'ms'",
            resourceKey: "patient",
            expected: ["@1973-12-25T00:00:00.010+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate21",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 1 'min'",
            resourceKey: "patient",
            expected: ["@1973-12-25T00:01:00.000+10:00"],
            expectError: false
        },
        {
            name: "test_testPlusDate22",
            group: "testPlus",
            expression: "@1973-12-25T00:00:00.000+10:00 + 1 'h'",
            resourceKey: "patient",
            expected: ["@1973-12-25T01:00:00.000+10:00"],
            expectError: false
        },
        {
            name: "test_testPlus6",
            group: "testPlus",
            expression: "@1974-12-25 + 7",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testPlusTime1",
            group: "testPlus",
            expression: "@T01:00:00 + 2 hours",
            resourceKey: "patient",
            expected: ["@T03:00:00"],
            expectError: false
        },
        {
            name: "test_testPlusTime2",
            group: "testPlus",
            expression: "@T23:00:00 + 2 hours",
            resourceKey: "patient",
            expected: ["@T01:00:00"],
            expectError: false
        },
        {
            name: "test_testPlusTime3",
            group: "testPlus",
            expression: "@T23:00:00 + 50 hours",
            resourceKey: "patient",
            expected: ["@T01:00:00"],
            expectError: false
        },
        {
            name: "test_testPlusEmpty1",
            group: "testPlus",
            expression: "1 + {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testPlusEmpty2",
            group: "testPlus",
            expression: "{} + 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testPlusEmpty3",
            group: "testPlus",
            expression: "{} + {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testMinus1",
            group: "testMinus",
            expression: "1 - 1 = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMinus2",
            group: "testMinus",
            expression: "1 - 0 = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMinus3",
            group: "testMinus",
            expression: "1.8 - 1.2 = 0.6",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMinus4",
            group: "testMinus",
            expression: "'a'-'b' = 'ab'",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testMinus5",
            group: "testMinus",
            expression: "@1974-12-25 - 1 'month'",
            resourceKey: "patient",
            expected: ["@1974-11-25"],
            expectError: false
        },
        {
            name: "test_testMinus6",
            group: "testMinus",
            expression: "@1974-12-25 - 1 'cm'",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testMinus7",
            group: "testMinus",
            expression: "@T00:30:00 - 1 hour",
            resourceKey: "patient",
            expected: ["@T23:30:00"],
            expectError: false
        },
        {
            name: "test_testMinus8",
            group: "testMinus",
            expression: "@T01:00:00 - 2 hours",
            resourceKey: "patient",
            expected: ["@T23:00:00"],
            expectError: false
        },
        {
            name: "test_testMinusEmpty1",
            group: "testMinus",
            expression: "1 - {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testMinusEmpty2",
            group: "testMinus",
            expression: "{} - 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testMinusEmpty3",
            group: "testMinus",
            expression: "{} - {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testMultiply1",
            group: "testMultiply",
            expression: "1 * 1 = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMultiply2",
            group: "testMultiply",
            expression: "1 * 0 = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMultiply3",
            group: "testMultiply",
            expression: "1.2 * 1.8 = 2.16",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMultiplyEmpty1",
            group: "testMultiply",
            expression: "1 * {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testMultiplyEmpty2",
            group: "testMultiply",
            expression: "{} * 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testMultiplyEmpty3",
            group: "testMultiply",
            expression: "{} * {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDivide1",
            group: "testDivide",
            expression: "1 / 1 = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDivide2",
            group: "testDivide",
            expression: "4 / 2 = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDivide3",
            group: "testDivide",
            expression: "4.0 / 2.0 = 2.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDivide4",
            group: "testDivide",
            expression: "1 / 2 = 0.5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDivide5",
            group: "testDivide",
            expression: "(1.2 / 1.8).round(2) = 0.67",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDivide6",
            group: "testDivide",
            expression: "1 / 0",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDivideEmpty1",
            group: "testDivide",
            expression: "1 / {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDivideEmpty2",
            group: "testDivide",
            expression: "{} / 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDivideEmpty3",
            group: "testDivide",
            expression: "{} / {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDiv1",
            group: "testDiv",
            expression: "1 div 1 = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDiv2",
            group: "testDiv",
            expression: "4 div 2 = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDiv3",
            group: "testDiv",
            expression: "5 div 2 = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDiv4",
            group: "testDiv",
            expression: "2.2 div 1.8 = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDiv5",
            group: "testDiv",
            expression: "5 div 0",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDiv6",
            group: "testDiv",
            expression: "-5.5 div 2 = -2",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testDivEmpty1",
            group: "testDiv",
            expression: "1 div {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDivEmpty2",
            group: "testDiv",
            expression: "{} div 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDivEmpty3",
            group: "testDiv",
            expression: "{} div {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testMod1",
            group: "testMod",
            expression: "1 mod 1 = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMod2",
            group: "testMod",
            expression: "4 mod 2 = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMod3",
            group: "testMod",
            expression: "5 mod 2 = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMod4",
            group: "testMod",
            expression: "2.2 mod 1.8 = 0.4",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMod5",
            group: "testMod",
            expression: "5 mod 0",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testMod6",
            group: "testMod",
            expression: "-5.5 mod 2 = -1.5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testModEmpty1",
            group: "testMod",
            expression: "1 mod {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testModEmpty2",
            group: "testMod",
            expression: "{} mod 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testModEmpty3",
            group: "testMod",
            expression: "{} mod {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testPower1",
            group: "testPower",
            expression: "2.power(3) = 8",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPower2",
            group: "testPower",
            expression: "2.5.power(2) = 6.25",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPower3",
            group: "testPower",
            expression: "(-1).power(0.5)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testPowerEmpty",
            group: "testPower",
            expression: "{}.power(2).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPowerEmpty2",
            group: "testPower",
            expression: "{}.power({}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPowerEmpty3",
            group: "testPower",
            expression: "2.5.power({}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        }
    ];
}
