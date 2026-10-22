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

// FHIRPath STU3 functions: boolean aggregates, coalesce, repeatAll, lastIndexOf, toLong,
// min/max/avg/sum, date/time component extraction and pathname (examples taken from the specification)
function getStu3FunctionsTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_allTrueAll",
            group: "testBooleanAggregates",
            expression: "true.combine(true).allTrue()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_allTrueSome",
            group: "testBooleanAggregates",
            expression: "true.combine(false).allTrue()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_allTrueEmpty",
            group: "testBooleanAggregates",
            expression: "{}.allTrue()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_anyTrueSome",
            group: "testBooleanAggregates",
            expression: "true.combine(false).anyTrue()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_anyTrueNone",
            group: "testBooleanAggregates",
            expression: "false.combine(false).anyTrue()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_anyTrueEmpty",
            group: "testBooleanAggregates",
            expression: "{}.anyTrue()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_allFalseAll",
            group: "testBooleanAggregates",
            expression: "false.combine(false).allFalse()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_allFalseSome",
            group: "testBooleanAggregates",
            expression: "true.combine(false).allFalse()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_allFalseEmpty",
            group: "testBooleanAggregates",
            expression: "{}.allFalse()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_anyFalseSome",
            group: "testBooleanAggregates",
            expression: "true.combine(false).anyFalse()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_anyFalseNone",
            group: "testBooleanAggregates",
            expression: "true.combine(true).anyFalse()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_anyFalseEmpty",
            group: "testBooleanAggregates",
            expression: "{}.anyFalse()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_anyTrueNonBoolean",
            group: "testBooleanAggregates",
            expression: "(1 | 2).anyTrue()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_coalesceFirstNonEmpty",
            group: "testCoalesce",
            expression: "coalesce({}, 'a', 'b')",
            resourceKey: "patient",
            expected: ["a"],
            expectError: false
        },
        {
            name: "test_coalesceAllEmpty",
            group: "testCoalesce",
            expression: "coalesce({}, {})",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_coalesceInputContext",
            group: "testCoalesce",
            expression: "Patient.coalesce(name.where(use = 'nickname'), name.where(use = 'usual')).given",
            resourceKey: "patient",
            expected: ["Jim"],
            expectError: false
        },
        {
            name: "test_coalesceShortCircuit",
            group: "testCoalesce",
            expression: "coalesce('a', (1 | 2).single())",
            resourceKey: "patient",
            expected: ["a"],
            expectError: false
        },
        {
            name: "test_coalescePerItem",
            group: "testCoalesce",
            expression: "Patient.name.select(coalesce(family, 'unknown'))",
            resourceKey: "patient",
            expected: ["Chalmers", "unknown", "Windsor"],
            expectError: false
        },
        {
            name: "test_coalesceMultipleInputs",
            group: "testCoalesce",
            expression: "Patient.name.coalesce(given)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_repeatAllKeepsDuplicates",
            group: "testRepeatAll",
            expression: "Patient.name.repeatAll(given).count()",
            resourceKey: "patient",
            expected: [5],
            expectError: false
        },
        {
            name: "test_repeatDropsDuplicates",
            group: "testRepeatAll",
            expression: "Patient.name.repeat(given).count()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_repeatAllNested",
            group: "testRepeatAll",
            expression: "Questionnaire.repeatAll(item).linkId.count() = Questionnaire.repeat(item).linkId.count()",
            resourceKey: "questionnaire",
            expected: [true],
            expectError: false
        },
        {
            name: "test_repeatAllNonTerminating",
            group: "testRepeatAll",
            expression: "1.repeatAll($this)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_lastIndexOf1",
            group: "testLastIndexOf",
            expression: "'abcdefg'.lastIndexOf('bc')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_lastIndexOf2",
            group: "testLastIndexOf",
            expression: "'abcdefg'.lastIndexOf('x')",
            resourceKey: "patient",
            expected: [-1],
            expectError: false
        },
        {
            name: "test_lastIndexOf3",
            group: "testLastIndexOf",
            expression: "'abcdefg'.lastIndexOf('abcdefg')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_lastIndexOf4",
            group: "testLastIndexOf",
            expression: "'abc abc'.lastIndexOf('a')",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_lastIndexOf5",
            group: "testLastIndexOf",
            expression: "'0123'.lastIndexOf('')",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_lastIndexOf6",
            group: "testLastIndexOf",
            expression: "'0'.lastIndexOf('')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_lastIndexOf7",
            group: "testLastIndexOf",
            expression: "''.lastIndexOf('')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_lastIndexOfEmpty",
            group: "testLastIndexOf",
            expression: "{}.lastIndexOf('a')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_lastIndexOfMultiple",
            group: "testLastIndexOf",
            expression: "('a' | 'b').lastIndexOf('a')",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_toLongInteger",
            group: "testToLong",
            expression: "42.toLong()",
            resourceKey: "patient",
            expected: [42],
            expectError: false
        },
        {
            name: "test_toLongType",
            group: "testToLong",
            expression: "42.toLong().type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_toLongString",
            group: "testToLong",
            expression: "'123'.toLong()",
            resourceKey: "patient",
            expected: [123],
            expectError: false
        },
        {
            name: "test_toLongSignedString",
            group: "testToLong",
            expression: "'-5'.toLong()",
            resourceKey: "patient",
            expected: [-5],
            expectError: false
        },
        {
            name: "test_toLongInvalidString",
            group: "testToLong",
            expression: "'abc'.toLong()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toLongDecimalString",
            group: "testToLong",
            expression: "'1.0'.toLong()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toLongDecimal",
            group: "testToLong",
            expression: "1.5.toLong()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toLongBoolean",
            group: "testToLong",
            expression: "true.toLong()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_toLongMultiple",
            group: "testToLong",
            expression: "(1 | 2).toLong()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_convertsToLongString",
            group: "testToLong",
            expression: "'123'.convertsToLong()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_convertsToLongInvalid",
            group: "testToLong",
            expression: "'abc'.convertsToLong()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_convertsToLongLong",
            group: "testToLong",
            expression: "1L.convertsToLong()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_convertsToLongEmpty",
            group: "testToLong",
            expression: "{}.convertsToLong()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_minInteger",
            group: "testAggregates",
            expression: "(2 | 4 | 8 | 6).min()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_maxInteger",
            group: "testAggregates",
            expression: "(2 | 4 | 8 | 6).max()",
            resourceKey: "patient",
            expected: [8],
            expectError: false
        },
        {
            name: "test_minLong",
            group: "testAggregates",
            expression: "(2L | 4L | 8L | 6L).min()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_minLongType",
            group: "testAggregates",
            expression: "(2L | 4L | 8L | 6L).min().type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_minDate",
            group: "testAggregates",
            expression: "(@2012-12-31 | @2013-01-01 | @2012-01-01).min()",
            resourceKey: "patient",
            expected: ["@2012-01-01"],
            expectError: false
        },
        {
            name: "test_maxDate",
            group: "testAggregates",
            expression: "(@2012-12-31 | @2013-01-01 | @2012-01-01).max()",
            resourceKey: "patient",
            expected: ["@2013-01-01"],
            expectError: false
        },
        {
            name: "test_minString",
            group: "testAggregates",
            expression: "('b' | 'a' | 'c').min()",
            resourceKey: "patient",
            expected: ["a"],
            expectError: false
        },
        {
            name: "test_minFhirString",
            group: "testAggregates",
            expression: "Patient.name.given.min()",
            resourceKey: "patient",
            expected: ["James"],
            expectError: false
        },
        {
            name: "test_maxQuantity",
            group: "testAggregates",
            expression: "(1.0 'mg' | 3.0 'mg' | 2.0 'mg').max() = 3.0 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_minEmpty",
            group: "testAggregates",
            expression: "{}.min()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_minMixedTypes",
            group: "testAggregates",
            expression: "(1 | 'a').min()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_avgDecimal",
            group: "testAggregates",
            expression: "(5.5 | 4.7 | 4.8).avg() = 5.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_avgInteger",
            group: "testAggregates",
            expression: "(1 | 2).avg() = 1.5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_avgQuantity",
            group: "testAggregates",
            expression: "(5.5 'cm' | 4.7 'cm' | 4.8 'cm').avg() = 5.0 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_avgEmpty",
            group: "testAggregates",
            expression: "{}.avg()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_sumInteger",
            group: "testAggregates",
            expression: "(1 | 2 | 3).sum()",
            resourceKey: "patient",
            expected: [6],
            expectError: false
        },
        {
            name: "test_sumDecimal",
            group: "testAggregates",
            expression: "(1.0 | 2.0 | 3.0 | 4.0 | 5.0).sum() = 15.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_sumLongType",
            group: "testAggregates",
            expression: "(1L | 2L).sum().type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_sumQuantity",
            group: "testAggregates",
            expression: "(1.0 'mg' | 2.0 'mg' | 3.0 'mg' | 4.0 'mg' | 5.0 'mg').sum() = 15.0 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_sumEmpty",
            group: "testAggregates",
            expression: "{}.sum()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_sumMixedUnits",
            group: "testAggregates",
            expression: "(1 'mg' | 1 'g').sum()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_timeOfDayType",
            group: "testDateTimeComponents",
            expression: "timeOfDay().type().name",
            resourceKey: "patient",
            expected: ["Time"],
            expectError: false
        },
        {
            name: "test_timeOfDayFormat",
            group: "testDateTimeComponents",
            expression: "timeOfDay().toString().length() = 12",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_yearOf",
            group: "testDateTimeComponents",
            expression: "@2014-01-05T10:30:00.000.yearOf()",
            resourceKey: "patient",
            expected: [2014],
            expectError: false
        },
        {
            name: "test_monthOf",
            group: "testDateTimeComponents",
            expression: "@2014-01-05T10:30:00.000.monthOf()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_monthOfMissing",
            group: "testDateTimeComponents",
            expression: "@2012.monthOf()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_dayOf",
            group: "testDateTimeComponents",
            expression: "@2014-01-05T10:30:00.000.dayOf()",
            resourceKey: "patient",
            expected: [5],
            expectError: false
        },
        {
            name: "test_hourOf",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T03:30:40.002-07:00.hourOf()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_hourOfAfternoon",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T16:30:40.002-07:00.hourOf()",
            resourceKey: "patient",
            expected: [16],
            expectError: false
        },
        {
            name: "test_hourOfTime",
            group: "testDateTimeComponents",
            expression: "@T10:30.hourOf()",
            resourceKey: "patient",
            expected: [10],
            expectError: false
        },
        {
            name: "test_hourOfDate",
            group: "testDateTimeComponents",
            expression: "@2014-01-01.hourOf()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_minuteOf",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T12:30:40.002-07:00.minuteOf()",
            resourceKey: "patient",
            expected: [30],
            expectError: false
        },
        {
            name: "test_secondOf",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T12:30:40.002-07:00.secondOf()",
            resourceKey: "patient",
            expected: [40],
            expectError: false
        },
        {
            name: "test_millisecondOf",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T12:30:00.002-07:00.millisecondOf()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_timezoneOffsetOf",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T12:30:00.000-07:00.timezoneOffsetOf() = -7.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_timezoneOffsetOfFraction",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T12:30:00.000+08:45.timezoneOffsetOf() = 8.75",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_timezoneOffsetOfMissing",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T12:30:00.000.timezoneOffsetOf()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_dateOf",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T12:30:00.000-07:00.dateOf()",
            resourceKey: "patient",
            expected: ["@2012-01-01"],
            expectError: false
        },
        {
            name: "test_dateOfType",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T12:30:00.000-07:00.dateOf().type().name",
            resourceKey: "patient",
            expected: ["Date"],
            expectError: false
        },
        {
            name: "test_timeOf",
            group: "testDateTimeComponents",
            expression: "@2012-01-01T12:30:00.000-07:00.timeOf()",
            resourceKey: "patient",
            expected: ["@T12:30:00.000"],
            expectError: false
        },
        {
            name: "test_yearOfFhirDate",
            group: "testDateTimeComponents",
            expression: "Patient.birthDate.yearOf()",
            resourceKey: "patient",
            expected: [1974],
            expectError: false
        },
        {
            name: "test_yearOfString",
            group: "testDateTimeComponents",
            expression: "'2014'.yearOf()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_yearOfMultiple",
            group: "testDateTimeComponents",
            expression: "(@2014 | @2015).yearOf()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_pathnamePrimitive",
            group: "testPathname",
            expression: "Patient.birthDate.pathname()",
            resourceKey: "patient",
            expected: ["Patient.birthDate[0]"],
            expectError: false
        },
        {
            name: "test_pathnameShort",
            group: "testPathname",
            expression: "Patient.birthDate.pathname(true)",
            resourceKey: "patient",
            expected: ["Patient.birthDate"],
            expectError: false
        },
        {
            name: "test_pathnameArray",
            group: "testPathname",
            expression: "Patient.name.where(use = 'usual').given.pathname()",
            resourceKey: "patient",
            expected: ["Patient.name[1].given[0]"],
            expectError: false
        },
        {
            name: "test_pathnameArrayShort",
            group: "testPathname",
            expression: "Patient.name.given.pathname(true).first()",
            resourceKey: "patient",
            expected: ["Patient.name[0].given[0]"],
            expectError: false
        },
        {
            name: "test_pathnameChoice",
            group: "testPathname",
            expression: "Observation.value.pathname()",
            resourceKey: "observation",
            expected: ["Observation.value[0]"],
            expectError: false
        },
        {
            name: "test_pathnameComputed",
            group: "testPathname",
            expression: "Patient.name.given.first().substring(0, 2).pathname()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_pathnameLiteral",
            group: "testPathname",
            expression: "'abc'.pathname()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        }
    ];
}
