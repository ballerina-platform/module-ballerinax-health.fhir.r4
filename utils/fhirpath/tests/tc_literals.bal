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

function getLiteralsTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testLiteralTrue",
            group: "testLiterals",
            expression: "Patient.name.exists() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralFalse",
            group: "testLiterals",
            expression: "Patient.name.empty() = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralString1",
            group: "testLiterals",
            expression: "Patient.name.given.first() = 'Peter'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralInteger1",
            group: "testLiterals",
            expression: "1.convertsToInteger()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralInteger0",
            group: "testLiterals",
            expression: "0.convertsToInteger()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerNegative1",
            group: "testLiterals",
            expression: "(-1).convertsToInteger()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerNegative1Invalid",
            group: "testLiterals",
            expression: "-1.convertsToInteger()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testLiteralIntegerMax",
            group: "testLiterals",
            expression: "2147483647.convertsToInteger()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralString2",
            group: "testLiterals",
            expression: "'test'.convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralStringEscapes",
            group: "testLiterals",
            expression: "'\\\\\\/\\f\\r\\n\\t\\\"\\`\\'\\u002a'.convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralBooleanTrue",
            group: "testLiterals",
            expression: "true.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralBooleanFalse",
            group: "testLiterals",
            expression: "false.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimal10",
            group: "testLiterals",
            expression: "1.0.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimal01",
            group: "testLiterals",
            expression: "0.1.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimal00",
            group: "testLiterals",
            expression: "0.0.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimalNegative01",
            group: "testLiterals",
            expression: "(-0.1).convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimalNegative01Invalid",
            group: "testLiterals",
            expression: "-0.1.convertsToDecimal()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testLiteralDecimalMax",
            group: "testLiterals",
            expression: "1234567890987654321.0.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimalStep",
            group: "testLiterals",
            expression: "0.00000001.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateYear",
            group: "testLiterals",
            expression: "@2015.is(Date)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateMonth",
            group: "testLiterals",
            expression: "@2015-02.is(Date)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateDay",
            group: "testLiterals",
            expression: "@2015-02-04.is(Date)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeYear",
            group: "testLiterals",
            expression: "@2015T.is(DateTime)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeMonth",
            group: "testLiterals",
            expression: "@2015-02T.is(DateTime)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeDay",
            group: "testLiterals",
            expression: "@2015-02-04T.is(DateTime)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeHour",
            group: "testLiterals",
            expression: "@2015-02-04T14.is(DateTime)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeMinute",
            group: "testLiterals",
            expression: "@2015-02-04T14:34.is(DateTime)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeSecond",
            group: "testLiterals",
            expression: "@2015-02-04T14:34:28.is(DateTime)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeMillisecond",
            group: "testLiterals",
            expression: "@2015-02-04T14:34:28.123.is(DateTime)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeUTC",
            group: "testLiterals",
            expression: "@2015-02-04T14:34:28Z.is(DateTime)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeTimezoneOffset",
            group: "testLiterals",
            expression: "@2015-02-04T14:34:28+10:00.is(DateTime)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralTimeHour",
            group: "testLiterals",
            expression: "@T14.is(Time)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralTimeMinute",
            group: "testLiterals",
            expression: "@T14:34.is(Time)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralTimeSecond",
            group: "testLiterals",
            expression: "@T14:34:28.is(Time)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralTimeMillisecond",
            group: "testLiterals",
            expression: "@T14:34:28.123.is(Time)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralTimeUTC",
            group: "testLiterals",
            expression: "@T14:34:28Z.is(Time)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testLiteralTimeTimezoneOffset",
            group: "testLiterals",
            expression: "@T14:34:28+10:00.is(Time)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testLiteralQuantityDecimal",
            group: "testLiterals",
            expression: "10.1 'mg'.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralQuantityInteger",
            group: "testLiterals",
            expression: "10 'mg'.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralQuantityDay",
            group: "testLiterals",
            expression: "4 days.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerNotEqual",
            group: "testLiterals",
            expression: "-3 != 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerEqual",
            group: "testLiterals",
            expression: "Patient.name.given.count() = 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPolarityPrecedence",
            group: "testLiterals",
            expression: "-Patient.name.given.count() = -5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerGreaterThan",
            group: "testLiterals",
            expression: "Patient.name.given.count() > -3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerCountNotEqual",
            group: "testLiterals",
            expression: "Patient.name.given.count() != 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerLessThanTrue",
            group: "testLiterals",
            expression: "1 < 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerLessThanFalse",
            group: "testLiterals",
            expression: "1 < -2",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerLessThanPolarityTrue",
            group: "testLiterals",
            expression: "+1 < +2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralIntegerLessThanPolarityFalse",
            group: "testLiterals",
            expression: "-1 < 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimalGreaterThanNonZeroTrue",
            group: "testLiterals",
            expression: "Observation.value.value > 180.0",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimalGreaterThanZeroTrue",
            group: "testLiterals",
            expression: "Observation.value.value > 0.0",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimalGreaterThanIntegerTrue",
            group: "testLiterals",
            expression: "Observation.value.value > 0",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimalLessThanInteger",
            group: "testLiterals",
            expression: "Observation.value.value < 190",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDecimalLessThanInvalid",
            group: "testLiterals",
            expression: "Observation.value.value < 'test'",
            resourceKey: "observation",
            expected: [],
            expectError: true
        },
        {
            name: "test_testDateEqual",
            group: "testLiterals",
            expression: "Patient.birthDate = @1974-12-25",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testDateNotEqual",
            group: "testLiterals",
            expression: "Patient.birthDate != @1974-12-25T12:34:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDateNotEqualTimezoneOffsetBefore",
            group: "testLiterals",
            expression: "Patient.birthDate != @1974-12-25T12:34:00-10:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDateNotEqualTimezoneOffsetAfter",
            group: "testLiterals",
            expression: "Patient.birthDate != @1974-12-25T12:34:00+10:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDateNotEqualUTC",
            group: "testLiterals",
            expression: "Patient.birthDate != @1974-12-25T12:34:00Z",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDateNotEqualTimeSecond",
            group: "testLiterals",
            expression: "Patient.birthDate != @T12:14:15",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testDateNotEqualTimeMinute",
            group: "testLiterals",
            expression: "Patient.birthDate != @T12:14",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testDateNotEqualToday",
            group: "testLiterals",
            expression: "Patient.birthDate < today()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDateTimeGreaterThanDate1",
            group: "testLiterals",
            expression: "now() > Patient.birthDate",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDateGreaterThanDate",
            group: "testLiterals",
            expression: "today() > Patient.birthDate",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDateTimeGreaterThanDate2",
            group: "testLiterals",
            expression: "now() > today()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeTZGreater",
            group: "testLiterals",
            expression: "@2017-11-05T01:30:00.0-04:00 > @2017-11-05T01:15:00.0-05:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeTZLess",
            group: "testLiterals",
            expression: "@2017-11-05T01:30:00.0-04:00 < @2017-11-05T01:15:00.0-05:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeTZEqualFalse",
            group: "testLiterals",
            expression: "@2017-11-05T01:30:00.0-04:00 = @2017-11-05T01:15:00.0-05:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLiteralDateTimeTZEqualTrue",
            group: "testLiterals",
            expression: "@2017-11-05T01:30:00.0-04:00 = @2017-11-05T00:30:00.0-05:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralUnicode",
            group: "testLiterals",
            expression: "Patient.name.given.first() = 'P\\u0065ter'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCollectionNotEmpty",
            group: "testLiterals",
            expression: "Patient.name.given.empty().not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCollectionNotEqualEmpty",
            group: "testLiterals",
            expression: "Patient.name.given != {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testExpressions",
            group: "testLiterals",
            expression: "Patient.name.select(given | family).distinct()",
            resourceKey: "patient",
            expected: ["Peter", "James", "Chalmers", "Jim", "Windsor"],
            expectError: false
        },
        {
            name: "test_testExpressionsEqual",
            group: "testLiterals",
            expression: "Patient.name.given.count() = 1 + 4",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEmpty",
            group: "testLiterals",
            expression: "Patient.name.empty().not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEmpty",
            group: "testLiterals",
            expression: "Patient.link.empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralNotOnEmpty",
            group: "testLiterals",
            expression: "{}.not().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralNotTrue",
            group: "testLiterals",
            expression: "true.not() = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralNotFalse",
            group: "testLiterals",
            expression: "false.not() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerBooleanNotTrue",
            group: "testLiterals",
            expression: "(0).not() = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testIntegerBooleanNotFalse",
            group: "testLiterals",
            expression: "(1).not() = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testNotInvalid",
            group: "testLiterals",
            expression: "(1|2).not() = false",
            resourceKey: "patient",
            expected: [],
            expectError: true
        }
    ];
}
