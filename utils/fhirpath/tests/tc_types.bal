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

function getTypesTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testType1",
            group: "testType",
            expression: "1.type().namespace = 'System'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType1a",
            group: "testType",
            expression: "1.type().name = 'Integer'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType2",
            group: "testType",
            expression: "'1'.type().namespace = 'System'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType2a",
            group: "testType",
            expression: "'1'.type().name = 'String'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType3",
            group: "testType",
            expression: "true.type().namespace = 'System'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType4",
            group: "testType",
            expression: "true.type().name = 'Boolean'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType5",
            group: "testType",
            expression: "true.is(Boolean)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType6",
            group: "testType",
            expression: "true.is(System.Boolean)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType7",
            group: "testType",
            expression: "true is Boolean",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType8",
            group: "testType",
            expression: "true is System.Boolean",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType9",
            group: "testType",
            expression: "Patient.active.type().namespace = 'FHIR'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType10",
            group: "testType",
            expression: "Patient.active.type().name = 'boolean'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType11",
            group: "testType",
            expression: "Patient.active.is(boolean)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType12",
            group: "testType",
            expression: "Patient.active.is(Boolean).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType13",
            group: "testType",
            expression: "Patient.active.is(FHIR.boolean)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType14",
            group: "testType",
            expression: "Patient.active.is(System.Boolean).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType15",
            group: "testType",
            expression: "Patient.type().namespace = 'FHIR'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType16",
            group: "testType",
            expression: "Patient.type().name = 'Patient'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType17",
            group: "testType",
            expression: "Patient.is(Patient)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType18",
            group: "testType",
            expression: "Patient.is(FHIR.Patient)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType19",
            group: "testType",
            expression: "Patient.is(FHIR.`Patient`)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType20",
            group: "testType",
            expression: "Patient.ofType(Patient).type().name",
            resourceKey: "patient",
            expected: ["Patient"],
            expectError: false
        },
        {
            name: "test_testType21",
            group: "testType",
            expression: "Patient.ofType(FHIR.Patient).type().name",
            resourceKey: "patient",
            expected: ["Patient"],
            expectError: false
        },
        {
            name: "test_testType22",
            group: "testType",
            expression: "Patient.is(System.Patient).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testType23",
            group: "testType",
            expression: "Patient.ofType(FHIR.`Patient`).type().name",
            resourceKey: "patient",
            expected: ["Patient"],
            expectError: false
        },
        {
            name: "test_testTypeA1",
            group: "testType",
            expression: "Parameters.parameter[0].value.is(FHIR.string)",
            resourceKey: "parameters",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTypeA2",
            group: "testType",
            expression: "Parameters.parameter[1].value.is(FHIR.integer)",
            resourceKey: "parameters",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTypeA3",
            group: "testType",
            expression: "Parameters.parameter[2].value.is(FHIR.uuid)",
            resourceKey: "parameters",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTypeA4",
            group: "testType",
            expression: "Parameters.parameter[2].value.is(FHIR.uri)",
            resourceKey: "parameters",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTypeA",
            group: "testType",
            expression: "Parameters.parameter[3].value.is(FHIR.decimal)",
            resourceKey: "parameters",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringYearConvertsToDate",
            group: "testTypes",
            expression: "'2015'.convertsToDate()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringMonthConvertsToDate",
            group: "testTypes",
            expression: "'2015-02'.convertsToDate()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringDayConvertsToDate",
            group: "testTypes",
            expression: "'2015-02-04'.convertsToDate()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringYearConvertsToDateTime",
            group: "testTypes",
            expression: "'2015'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringMonthConvertsToDateTime",
            group: "testTypes",
            expression: "'2015-02'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringDayConvertsToDateTime",
            group: "testTypes",
            expression: "'2015-02-04'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringHourConvertsToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringMinuteConvertsToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14:34'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringSecondConvertsToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14:34:28'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringMillisecondConvertsToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14:34:28.123'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringUTCConvertsToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14:34:28Z'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringTZConvertsToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14:34:28+10:00'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringHourConvertsToTime",
            group: "testTypes",
            expression: "'14'.convertsToTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringMinuteConvertsToTime",
            group: "testTypes",
            expression: "'14:34'.convertsToTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringSecondConvertsToTime",
            group: "testTypes",
            expression: "'14:34:28'.convertsToTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringMillisecondConvertsToTime",
            group: "testTypes",
            expression: "'14:34:28.123'.convertsToTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralConvertsToInteger",
            group: "testTypes",
            expression: "1.convertsToInteger()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralIsInteger",
            group: "testTypes",
            expression: "1.is(Integer)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralIsSystemInteger",
            group: "testTypes",
            expression: "1.is(System.Integer)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringLiteralConvertsToInteger",
            group: "testTypes",
            expression: "'1'.convertsToInteger()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringLiteralConvertsToIntegerFalse",
            group: "testTypes",
            expression: "'a'.convertsToInteger().not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringDecimalConvertsToIntegerFalse",
            group: "testTypes",
            expression: "'1.0'.convertsToInteger().not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testStringLiteralIsNotInteger",
            group: "testTypes",
            expression: "'1'.is(Integer).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralConvertsToInteger",
            group: "testTypes",
            expression: "true.convertsToInteger()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralIsNotInteger",
            group: "testTypes",
            expression: "true.is(Integer).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDateIsNotInteger",
            group: "testTypes",
            expression: "@2013-04-05.is(Integer).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralToInteger",
            group: "testTypes",
            expression: "1.toInteger() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringIntegerLiteralToInteger",
            group: "testTypes",
            expression: "'1'.toInteger() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralToInteger",
            group: "testTypes",
            expression: "'1.1'.toInteger() = {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralToIntegerIsEmpty",
            group: "testTypes",
            expression: "'1.1'.toInteger().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralToInteger",
            group: "testTypes",
            expression: "true.toInteger() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralConvertsToDecimal",
            group: "testTypes",
            expression: "1.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralIsNotDecimal",
            group: "testTypes",
            expression: "1.is(Decimal).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralConvertsToDecimal",
            group: "testTypes",
            expression: "1.0.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralIsDecimal",
            group: "testTypes",
            expression: "1.0.is(Decimal)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringIntegerLiteralConvertsToDecimal",
            group: "testTypes",
            expression: "'1'.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringIntegerLiteralIsNotDecimal",
            group: "testTypes",
            expression: "'1'.is(Decimal).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringLiteralConvertsToDecimalFalse",
            group: "testTypes",
            expression: "'1.a'.convertsToDecimal().not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringDecimalLiteralConvertsToDecimal",
            group: "testTypes",
            expression: "'1.0'.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringDecimalLiteralIsNotDecimal",
            group: "testTypes",
            expression: "'1.0'.is(Decimal).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralConvertsToDecimal",
            group: "testTypes",
            expression: "true.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralIsNotDecimal",
            group: "testTypes",
            expression: "true.is(Decimal).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralToDecimal",
            group: "testTypes",
            expression: "1.toDecimal() = 1.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralToDeciamlEquivalent",
            group: "testTypes",
            expression: "1.toDecimal() ~ 1.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralToDecimal",
            group: "testTypes",
            expression: "1.0.toDecimal() = 1.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralToDecimalEqual",
            group: "testTypes",
            expression: "'1.1'.toDecimal() = 1.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralToDecimal",
            group: "testTypes",
            expression: "true.toDecimal() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralConvertsToQuantity",
            group: "testTypes",
            expression: "1.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralIsNotQuantity",
            group: "testTypes",
            expression: "1.is(Quantity).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralConvertsToQuantity",
            group: "testTypes",
            expression: "1.0.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralIsNotQuantity",
            group: "testTypes",
            expression: "1.0.is(System.Quantity).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringIntegerLiteralConvertsToQuantity",
            group: "testTypes",
            expression: "'1'.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringIntegerLiteralIsNotQuantity",
            group: "testTypes",
            expression: "'1'.is(System.Quantity).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringQuantityLiteralConvertsToQuantity",
            group: "testTypes",
            expression: "'1 day'.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringQuantityWeekConvertsToQuantity",
            group: "testTypes",
            expression: "'1 \\'wk\\''.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringQuantityWeekConvertsToQuantityFalse",
            group: "testTypes",
            expression: "'1 wk'.convertsToQuantity().not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringDecimalLiteralConvertsToQuantityFalse",
            group: "testTypes",
            expression: "'1.a'.convertsToQuantity().not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringDecimalLiteralConvertsToQuantity",
            group: "testTypes",
            expression: "'1.0'.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringDecimalLiteralIsNotSystemQuantity",
            group: "testTypes",
            expression: "'1.0'.is(System.Quantity).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralConvertsToQuantity",
            group: "testTypes",
            expression: "true.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralIsNotSystemQuantity",
            group: "testTypes",
            expression: "true.is(System.Quantity).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralToQuantity",
            group: "testTypes",
            expression: "1.toQuantity() = 1 '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralToQuantity",
            group: "testTypes",
            expression: "1.0.toQuantity() = 1.0 '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringIntegerLiteralToQuantity",
            group: "testTypes",
            expression: "'1'.toQuantity()",
            resourceKey: "patient",
            expected: ["1 '1'"],
            expectError: false
        },
        {
            name: "test_testStringQuantityLiteralToQuantity",
            group: "testTypes",
            expression: "'1 day'.toQuantity() = 1 day",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringQuantityDayLiteralToQuantity",
            group: "testTypes",
            expression: "'1 day'.toQuantity() = 1 'd'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringQuantityWeekLiteralToQuantity",
            group: "testTypes",
            expression: "'1 \\'wk\\''.toQuantity() = 1 week",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringQuantityMonthLiteralToQuantity",
            group: "testTypes",
            expression: "'1 \\'mo\\''.toQuantity() = 1 month",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testStringQuantityYearLiteralToQuantity",
            group: "testTypes",
            expression: "'1 \\'a\\''.toQuantity() = 1 year",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testStringDecimalLiteralToQuantity",
            group: "testTypes",
            expression: "'1.0'.toQuantity() ~ 1 '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralConvertsToBoolean",
            group: "testTypes",
            expression: "1.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralConvertsToBooleanFalse",
            group: "testTypes",
            expression: "2.convertsToBoolean()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNegativeIntegerLiteralConvertsToBooleanFalse",
            group: "testTypes",
            expression: "(-1).convertsToBoolean()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralFalseConvertsToBoolean",
            group: "testTypes",
            expression: "0.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralConvertsToBoolean",
            group: "testTypes",
            expression: "1.0.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringTrueLiteralConvertsToBoolean",
            group: "testTypes",
            expression: "'true'.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringFalseLiteralConvertsToBoolean",
            group: "testTypes",
            expression: "'false'.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringFalseLiteralAlsoConvertsToBoolean",
            group: "testTypes",
            expression: "'False'.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTrueLiteralConvertsToBoolean",
            group: "testTypes",
            expression: "true.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFalseLiteralConvertsToBoolean",
            group: "testTypes",
            expression: "false.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralToBoolean",
            group: "testTypes",
            expression: "1.toBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralToBooleanEmpty",
            group: "testTypes",
            expression: "2.toBoolean()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralToBooleanFalse",
            group: "testTypes",
            expression: "0.toBoolean()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testStringTrueToBoolean",
            group: "testTypes",
            expression: "'true'.toBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringFalseToBoolean",
            group: "testTypes",
            expression: "'false'.toBoolean()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralConvertsToString",
            group: "testTypes",
            expression: "1.convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralIsNotString",
            group: "testTypes",
            expression: "1.is(String).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNegativeIntegerLiteralConvertsToString",
            group: "testTypes",
            expression: "(-1).convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralConvertsToString",
            group: "testTypes",
            expression: "1.0.convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringLiteralConvertsToString",
            group: "testTypes",
            expression: "'true'.convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralConvertsToString",
            group: "testTypes",
            expression: "true.convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testQuantityLiteralConvertsToString",
            group: "testTypes",
            expression: "1 'wk'.convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntegerLiteralToString",
            group: "testTypes",
            expression: "1.toString()",
            resourceKey: "patient",
            expected: ["1"],
            expectError: false
        },
        {
            name: "test_testNegativeIntegerLiteralToString",
            group: "testTypes",
            expression: "(-1).toString()",
            resourceKey: "patient",
            expected: ["-1"],
            expectError: false
        },
        {
            name: "test_testDecimalLiteralToString",
            group: "testTypes",
            expression: "1.0.toString()",
            resourceKey: "patient",
            expected: ["1.0"],
            expectError: false
        },
        {
            name: "test_testStringLiteralToString",
            group: "testTypes",
            expression: "'true'.toString()",
            resourceKey: "patient",
            expected: ["true"],
            expectError: false
        },
        {
            name: "test_testBooleanLiteralToString",
            group: "testTypes",
            expression: "true.toString()",
            resourceKey: "patient",
            expected: ["true"],
            expectError: false
        },
        {
            name: "test_testQuantityLiteralWkToString",
            group: "testTypes",
            expression: "1 'wk'.toString()",
            resourceKey: "patient",
            expected: ["1 'wk'"],
            expectError: false
        },
        {
            name: "test_testQuantityLiteralWeekToString",
            group: "testTypes",
            expression: "1 week.toString()",
            resourceKey: "patient",
            expected: ["1 week"],
            expectError: false
        },
        {
            name: "test_testToInteger1",
            group: "testToInteger",
            expression: "'1'.toInteger() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToInteger2",
            group: "testToInteger",
            expression: "'-1'.toInteger() = -1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToInteger3",
            group: "testToInteger",
            expression: "'0'.toInteger() = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToInteger4",
            group: "testToInteger",
            expression: "'0.0'.toInteger().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToInteger5",
            group: "testToInteger",
            expression: "'st'.toInteger().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToDecimal1",
            group: "testToDecimal",
            expression: "'1'.toDecimal() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToDecimal2",
            group: "testToDecimal",
            expression: "'-1'.toInteger() = -1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToDecimal3",
            group: "testToDecimal",
            expression: "'0'.toDecimal() = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToDecimal4",
            group: "testToDecimal",
            expression: "'0.0'.toDecimal() = 0.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToDecimal5",
            group: "testToDecimal",
            expression: "'st'.toDecimal().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCase1",
            group: "testCase",
            expression: "'t'.upper() = 'T'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCase2",
            group: "testCase",
            expression: "'t'.lower() = 't'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCase3",
            group: "testCase",
            expression: "'T'.upper() = 'T'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCase4",
            group: "testCase",
            expression: "'T'.lower() = 't'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        }
    ];
}
