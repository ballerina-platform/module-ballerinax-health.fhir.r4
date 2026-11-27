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

// FHIRPath STU3 quantities and date/time intervals: UCUM and calendar unit conversion in equality,
// equivalence, comparison and arithmetic, comparable(), partial date arithmetic, duration() and difference()
function getStu3QuantitiesTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_ucumEqualConverted",
            group: "testQuantityEquality",
            expression: "1 'cm' = 10.0 'mm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_ucumNotEqualConverted",
            group: "testQuantityEquality",
            expression: "1 'cm' = 1 'm'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_ucumNotCommensurable",
            group: "testQuantityEquality",
            expression: "1 'cm' = 1 's'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_ucumSpecialUnits",
            group: "testQuantityEquality",
            expression: "23 'Cel' = 73.4 '[degF]'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_ucumTime",
            group: "testQuantityEquality",
            expression: "1 'h' = 3600 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_calendarToUcum",
            group: "testQuantityEquality",
            expression: "1 hour = 3600 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_calendarYearUcumYear",
            group: "testQuantityEquality",
            expression: "1 year = 1 'a'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_calendarYearExplicitUcum",
            group: "testQuantityEquality",
            expression: "1 year.toQuantity('a') = 1 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_calendarYearMonths",
            group: "testQuantityEquality",
            expression: "1 year = 12 months",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_calendarYearUcumMonths",
            group: "testQuantityEquality",
            expression: "1 year = 12 'mo'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_calendarWeekUcum",
            group: "testQuantityEquality",
            expression: "1 week = 1 'wk'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_calendarSecondUcum",
            group: "testQuantityEquality",
            expression: "1 second = 1 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_calendarDaysUcumWeek",
            group: "testQuantityEquality",
            expression: "7 days = 1 'wk'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_calendarWeekUcumDays",
            group: "testQuantityEquality",
            expression: "1 week = 7 'd'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_calendarNotTransitive",
            group: "testQuantityEquality",
            expression: "1 year = 360 days",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_fhirQuantityCode",
            group: "testQuantityEquality",
            expression: "Observation.value = 185 '[lb_av]'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_fhirQuantityConverted",
            group: "testQuantityEquality",
            expression: "Observation.value < 90 'kg'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_fhirQuantityDisplayUnit",
            group: "testQuantityEquality",
            expression: "Observation.value = 185 'lbs'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_numberQuantityDefaultUnit",
            group: "testQuantityEquality",
            expression: "2 = 2 '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentLeastGranular",
            group: "testQuantityEquivalence",
            expression: "2.1 'cm' ~ 21 'mm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentRounded",
            group: "testQuantityEquivalence",
            expression: "21 'mm' ~ 2 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentGrams",
            group: "testQuantityEquivalence",
            expression: "4 'g' ~ 4040 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentInches",
            group: "testQuantityEquivalence",
            expression: "1 '[in_i]' ~ 2.5 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentSpecialUnits",
            group: "testQuantityEquivalence",
            expression: "23 'Cel' ~ 73.4 '[degF]'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentCalendarYear",
            group: "testQuantityEquivalence",
            expression: "1 year ~ 1 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentCalendarYearMonths",
            group: "testQuantityEquivalence",
            expression: "1 year ~ 12 'mo'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentElevenMonths",
            group: "testQuantityEquivalence",
            expression: "1 year ~ 11 months",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentSecond",
            group: "testQuantityEquivalence",
            expression: "1 second ~ 1 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_equivalentNotCommensurable",
            group: "testQuantityEquivalence",
            expression: "1 'cm' ~ 1 's'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_notEquivalentValues",
            group: "testQuantityEquivalence",
            expression: "1 'cm' ~ 2 'cm'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_compareYearNotComparable",
            group: "testQuantityComparison",
            expression: "1 year > 1 'a'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_compareSecondsUcum",
            group: "testQuantityComparison",
            expression: "10 seconds > 1 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_compareExplicitConversion",
            group: "testQuantityComparison",
            expression: "2 year.toQuantity('a') > 1 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_compareMonthsYear",
            group: "testQuantityComparison",
            // The R4 test suite (testGreaterThan29) does not order calendar years and months by value; the spec
            // text gives false (0.5 > 1)
            expression: "6 months > 1 year",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_compareConverted",
            group: "testQuantityComparison",
            expression: "1 'km' > 999 'm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_compareNotCommensurable",
            group: "testQuantityComparison",
            expression: "1 'km' > 1 'kg'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_compareFhirQuantity",
            group: "testQuantityComparison",
            expression: "Observation.value > 180 '[lb_av]'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_addMostGranular",
            group: "testQuantityArithmetic",
            expression: "3 'm' + 3 'cm'",
            resourceKey: "patient",
            expected: [{"value": 303, "unit": "cm"}],
            expectError: false
        },
        {
            name: "test_addMostGranularReversed",
            group: "testQuantityArithmetic",
            expression: "3 'cm' + 3 'm' = 303 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_addThenConvert",
            group: "testQuantityArithmetic",
            expression: "(3 'm' + 3 'cm').toQuantity('m') = 3.03 'm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_addNumberToQuantity",
            group: "testQuantityArithmetic",
            expression: "2 + 2 'cm'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_addDefaultUnit",
            group: "testQuantityArithmetic",
            expression: "2 + 2 '1' = 4 '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_addCalendarUnits",
            group: "testQuantityArithmetic",
            expression: "2 minutes + 60 seconds = 180 seconds",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_addMixedSystems",
            group: "testQuantityArithmetic",
            expression: "60 's' + 2 minutes",
            resourceKey: "patient",
            expected: [{"value": 180, "unit": "second"}],
            expectError: false
        },
        {
            name: "test_addWeekDays",
            group: "testQuantityArithmetic",
            expression: "1 'wk' + 2 days = 9 days",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_addYearMonths",
            group: "testQuantityArithmetic",
            expression: "1 year + 12 months",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_addYearUcumMonths",
            group: "testQuantityArithmetic",
            expression: "1 year + 12 'mo'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_addExplicitMonths",
            group: "testQuantityArithmetic",
            expression: "1 year.toQuantity('month') + 12 months = 24 months",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_addWeeksDays",
            group: "testQuantityArithmetic",
            expression: "1 week + 14 days = 21 days",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_addUcumTime",
            group: "testQuantityArithmetic",
            expression: "3 'd' + 1 'wk' = 10 'd'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_subtractMostGranular",
            group: "testQuantityArithmetic",
            expression: "3 'm' - 3 'cm' = 297 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_subtractNegative",
            group: "testQuantityArithmetic",
            expression: "3 'cm' - 3 'm' = -297 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_subtractMixed",
            group: "testQuantityArithmetic",
            expression: "1 minute - 30 's' = 0.5 minute",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_addNotCommensurable",
            group: "testQuantityArithmetic",
            expression: "1 'kg' + 1 'm'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_multiplySameUnit",
            group: "testQuantityArithmetic",
            expression: "12 'cm' * 3 'cm'",
            resourceKey: "patient",
            expected: [{"value": 36, "unit": "cm2"}],
            expectError: false
        },
        {
            name: "test_multiplyExponents",
            group: "testQuantityArithmetic",
            expression: "3 'cm' * 12 'cm2' = 36 'cm3'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_multiplyCancel",
            group: "testQuantityArithmetic",
            expression: "10 'm/s' * 10 's'",
            resourceKey: "patient",
            expected: [{"value": 100, "unit": "m"}],
            expectError: false
        },
        {
            name: "test_multiplyNumber",
            group: "testQuantityArithmetic",
            expression: "3 * 2 'cm'",
            resourceKey: "patient",
            expected: [{"value": 6, "unit": "cm"}],
            expectError: false
        },
        {
            name: "test_multiplyCalendar",
            group: "testQuantityArithmetic",
            expression: "12 day * 45 'm'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_multiplyMixedUnits",
            group: "testQuantityArithmetic",
            expression: "2.0 'cm' * 2.0 'm' = 0.040 'm2'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_divideUnits",
            group: "testQuantityArithmetic",
            expression: "120 'm' / 60 's'",
            resourceKey: "patient",
            expected: [{"value": 2, "unit": "m/s"}],
            expectError: false
        },
        {
            name: "test_divideReduce",
            group: "testQuantityArithmetic",
            expression: "12 'cm2' / 3 'cm' = 4.0 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_divideNumberByQuantity",
            group: "testQuantityArithmetic",
            expression: "60 / 1 's'",
            resourceKey: "patient",
            expected: [{"value": 60, "unit": "/s"}],
            expectError: false
        },
        {
            name: "test_divideQuantityByNumber",
            group: "testQuantityArithmetic",
            expression: "60 's' / 2 = 30 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_divideSameUnit",
            group: "testQuantityArithmetic",
            expression: "1.0 'm' / 1.0 'm'",
            resourceKey: "patient",
            expected: [{"value": 1, "unit": "1"}],
            expectError: false
        },
        {
            name: "test_divideByZero",
            group: "testQuantityArithmetic",
            expression: "1 'm' / 0 's'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_comparableSameUnit",
            group: "testComparableFunction",
            expression: "1 'mg'.comparable(2 'mg')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_comparableMetric",
            group: "testComparableFunction",
            expression: "1 'm'.comparable(20 'cm')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_comparableDefaultUnit",
            group: "testComparableFunction",
            expression: "2 '1'.comparable(3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_comparableNumbers",
            group: "testComparableFunction",
            expression: "1.comparable(2)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_comparableCustomary",
            group: "testComparableFunction",
            expression: "1 '[in_i]'.comparable(1 'cm')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_comparableYearUcum",
            group: "testComparableFunction",
            expression: "1 year.comparable(1 'a')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_comparableSpecial",
            group: "testComparableFunction",
            expression: "1 'Cel'.comparable(1 '[degF]')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_comparableDifferentDimensions",
            group: "testComparableFunction",
            expression: "1 'm'.comparable(1 'kg')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_comparableEmpty",
            group: "testComparableFunction",
            expression: "{}.comparable(1 'm')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_comparableNotQuantity",
            group: "testComparableFunction",
            expression: "'a'.comparable(1 'm')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toQuantityMetric",
            group: "testQuantityConversion",
            expression: "52 'cm'.toQuantity('m') = 0.52 'm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityCustomary",
            group: "testQuantityConversion",
            expression: "1 'kg'.toQuantity('[lb_av]') > 2.2 '[lb_av]'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityTemperature",
            group: "testQuantityConversion",
            expression: "10 'Cel'.toQuantity('[degF]') = 50 '[degF]'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityConcentration",
            group: "testQuantityConversion",
            expression: "1 'mmol/L'.toQuantity('umol/L') = 1000 'umol/L'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityPressure",
            group: "testQuantityConversion",
            expression: "120 'mm[Hg]'.toQuantity('kPa') > 15.99 'kPa'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityAnnotation",
            group: "testQuantityConversion",
            expression: "60 '{beats}/min'.toQuantity('/h') = 3600 '/h'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_convertsToQuantityInches",
            group: "testQuantityConversion",
            expression: "2 '[in_i]'.convertsToQuantity('cm')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_convertsToQuantitySpecial",
            group: "testQuantityConversion",
            expression: "10 'Cel'.convertsToQuantity('[degF]')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_convertsToQuantityIncommensurable",
            group: "testQuantityConversion",
            expression: "5 'm'.convertsToQuantity('kg')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_addMonthsToYear",
            group: "testPartialDateArithmetic",
            expression: "@2014 + 24 months",
            resourceKey: "patient",
            expected: ["@2016"],
            expectError: false
        },
        {
            name: "test_addPartialMonthsToYear",
            group: "testPartialDateArithmetic",
            expression: "@2014 + 23 months",
            resourceKey: "patient",
            expected: ["@2015"],
            expectError: false
        },
        {
            name: "test_addDaysToYear",
            group: "testPartialDateArithmetic",
            expression: "@2016 + 365 days",
            resourceKey: "patient",
            expected: ["@2017"],
            expectError: false
        },
        {
            name: "test_addMonthsBelowYear",
            group: "testPartialDateArithmetic",
            expression: "@2014 + 11 months",
            resourceKey: "patient",
            expected: ["@2014"],
            expectError: false
        },
        {
            name: "test_addWeeksToMonth",
            group: "testPartialDateArithmetic",
            expression: "@2026-02 + 5 weeks",
            resourceKey: "patient",
            expected: ["@2026-03"],
            expectError: false
        },
        {
            name: "test_addWeeksBelowMonth",
            group: "testPartialDateArithmetic",
            expression: "@2026-02 + 4 weeks",
            resourceKey: "patient",
            expected: ["@2026-02"],
            expectError: false
        },
        {
            name: "test_subtractMonthsFromYear",
            group: "testPartialDateArithmetic",
            expression: "@2014 - 24 months",
            resourceKey: "patient",
            expected: ["@2012"],
            expectError: false
        },
        {
            name: "test_subtractMonthsFromDate",
            group: "testPartialDateArithmetic",
            expression: "@2019-03-01 - 24 months",
            resourceKey: "patient",
            expected: ["@2017-03-01"],
            expectError: false
        },
        {
            name: "test_subtractMonthBelowYear",
            group: "testPartialDateArithmetic",
            expression: "@2014 - 1 month",
            resourceKey: "patient",
            expected: ["@2014"],
            expectError: false
        },
        {
            name: "test_subtractDayBelowMonth",
            group: "testPartialDateArithmetic",
            expression: "@2026-02 - 1 day",
            resourceKey: "patient",
            expected: ["@2026-02"],
            expectError: false
        },
        {
            name: "test_addFractionalDays",
            group: "testPartialDateArithmetic",
            expression: "@1973-12-25 + 7.9 days",
            resourceKey: "patient",
            expected: ["@1974-01-01"],
            expectError: false
        },
        {
            name: "test_addMonthEndOfMonth",
            group: "testPartialDateArithmetic",
            expression: "@2026-01-31 + 1 month",
            resourceKey: "patient",
            expected: ["@2026-02-28"],
            expectError: false
        },
        {
            name: "test_addUcumDays",
            group: "testPartialDateArithmetic",
            expression: "@1973-12-25 + 1 'd'",
            resourceKey: "patient",
            expected: ["@1973-12-26"],
            expectError: false
        },
        {
            name: "test_addHoursToDate",
            group: "testPartialDateArithmetic",
            expression: "@2014-01-01 + 25 hours",
            resourceKey: "patient",
            expected: ["@2014-01-02"],
            expectError: false
        },
        {
            name: "test_addHourOverMidnight",
            group: "testPartialDateArithmetic",
            expression: "@T23:30:00 + 1 hour",
            resourceKey: "patient",
            expected: ["@T00:30:00"],
            expectError: false
        },
        {
            name: "test_durationWeek",
            group: "testDurationDifference",
            expression: "@2025-01-02.duration(@2025-01-07, 'week')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_differenceWeek",
            group: "testDurationDifference",
            expression: "@2025-01-02.difference(@2025-01-07, 'week')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_durationYearSameYear",
            group: "testDurationDifference",
            expression: "@2025-01-01.duration(@2025-09-01, 'year')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_differenceYearSameYear",
            group: "testDurationDifference",
            expression: "@2025-01-01.difference(@2025-09-01, 'year')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_durationYearAcross",
            group: "testDurationDifference",
            expression: "@2024-12-01.duration(@2025-09-01, 'year')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_differenceYearAcross",
            group: "testDurationDifference",
            expression: "@2024-12-01.difference(@2025-09-01, 'year')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_durationNegative",
            group: "testDurationDifference",
            expression: "@2025-09-01.duration(@2024-12-01, 'month')",
            resourceKey: "patient",
            expected: [-9],
            expectError: false
        },
        {
            name: "test_durationDays",
            group: "testDurationDifference",
            expression: "@2025-01-01.duration(@2025-01-31, 'day')",
            resourceKey: "patient",
            expected: [30],
            expectError: false
        },
        {
            name: "test_durationIncompleteMonth",
            group: "testDurationDifference",
            expression: "@2024-01-31.duration(@2024-02-29, 'month')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_durationCompleteMonth",
            group: "testDurationDifference",
            expression: "@2024-01-15.duration(@2024-02-15, 'month')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_durationHours",
            group: "testDurationDifference",
            expression: "@2025-01-01T10:00:00Z.duration(@2025-01-01T12:30:00Z, 'hour')",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_durationTimezones",
            group: "testDurationDifference",
            expression: "@2025-01-01T10:00:00+02:00.duration(@2025-01-01T10:00:00Z, 'hour')",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_durationTime",
            group: "testDurationDifference",
            expression: "@T10:00.duration(@T11:59, 'hour')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_durationTimeIncomplete",
            group: "testDurationDifference",
            expression: "@T10:59.duration(@T11:00, 'hour')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_differenceTime",
            group: "testDurationDifference",
            expression: "@T10:59.difference(@T11:00, 'hour')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_durationFhirDate",
            group: "testDurationDifference",
            expression: "Patient.birthDate.duration(@2024-12-25, 'year')",
            resourceKey: "patient",
            expected: [50],
            expectError: false
        },
        {
            name: "test_durationInsufficientPrecision",
            group: "testDurationDifference",
            expression: "@2025-01.duration(@2025-03-01, 'day')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_durationEmpty",
            group: "testDurationDifference",
            expression: "{}.duration(@2025-03-01, 'day')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_durationDatePrecisionInvalid",
            group: "testDurationDifference",
            expression: "@2025-01-01.duration(@2025-01-02, 'hour')",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_durationMixedKinds",
            group: "testDurationDifference",
            expression: "@2025-01-01.duration(@T10:00, 'day')",
            resourceKey: "patient",
            expected: [],
            expectError: true
        }
    ];
}
