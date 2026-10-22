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

// FHIRPath STU3 function parameters and environment variables: sort() directions, combine(preserveOrder),
// regex flags, date format templates, toQuantity(unit), %context/%resource/%rootResource
function getStu3ParametersTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_sortDefault",
            group: "testSortDirections",
            expression: "(3 | 1 | 2).sort()",
            resourceKey: "patient",
            expected: [1, 2, 3],
            expectError: false
        },
        {
            name: "test_sortThis",
            group: "testSortDirections",
            expression: "(3 | 1 | 2).sort($this)",
            resourceKey: "patient",
            expected: [1, 2, 3],
            expectError: false
        },
        {
            name: "test_sortAsc",
            group: "testSortDirections",
            expression: "(3 | 1 | 2).sort($this asc)",
            resourceKey: "patient",
            expected: [1, 2, 3],
            expectError: false
        },
        {
            name: "test_sortDesc",
            group: "testSortDirections",
            expression: "(3 | 1 | 2).sort($this desc)",
            resourceKey: "patient",
            expected: [3, 2, 1],
            expectError: false
        },
        {
            name: "test_sortStrings",
            group: "testSortDirections",
            expression: "('c' | 'a' | 'b').sort()",
            resourceKey: "patient",
            expected: ["a", "b", "c"],
            expectError: false
        },
        {
            name: "test_sortStringsDesc",
            group: "testSortDirections",
            expression: "('c' | 'a' | 'b').sort($this desc)",
            resourceKey: "patient",
            expected: ["c", "b", "a"],
            expectError: false
        },
        {
            name: "test_sortStringsNotNumeric",
            group: "testSortDirections",
            expression: "('3' | '1' | '10').sort()",
            resourceKey: "patient",
            expected: ["1", "10", "3"],
            expectError: false
        },
        {
            name: "test_sortEmptyKeyFirst",
            group: "testSortDirections",
            expression: "Patient.name.sort(family).use",
            resourceKey: "patient",
            expected: ["usual", "official", "maiden"],
            expectError: false
        },
        {
            name: "test_sortEmptyKeyLastDesc",
            group: "testSortDirections",
            expression: "Patient.name.sort(family desc, given.first()).use",
            resourceKey: "patient",
            expected: ["maiden", "official", "usual"],
            expectError: false
        },
        {
            name: "test_sortMultipleKeys",
            group: "testSortDirections",
            expression: "Patient.name.sort(given.first(), family desc).use",
            resourceKey: "patient",
            expected: ["usual", "maiden", "official"],
            expectError: false
        },
        {
            name: "test_sortEmptyInput",
            group: "testSortDirections",
            expression: "{}.sort()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_sortMultiValuedKey",
            group: "testSortDirections",
            expression: "Patient.name.sort(given)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_sortIncompatibleTypes",
            group: "testSortDirections",
            expression: "(1 | 'a').sort()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_combinePreserveOrder",
            group: "testCombinePreserveOrder",
            expression: "(1 | 2).combine(2 | 3, true)",
            resourceKey: "patient",
            expected: [1, 2, 2, 3],
            expectError: false
        },
        {
            name: "test_combineEmptyOther",
            group: "testCombinePreserveOrder",
            expression: "(1 | 2).combine({}, true)",
            resourceKey: "patient",
            expected: [1, 2],
            expectError: false
        },
        {
            name: "test_combineInvalidPreserveOrder",
            group: "testCombinePreserveOrder",
            expression: "(1 | 2).combine(3, 'yes')",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_matchesPartial",
            group: "testRegexFlags",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('Library')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_matchesAnchored",
            group: "testRegexFlags",
            expression: "'N8000123123'.matches('^N[0-9]{8}$')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_matchesSequence",
            group: "testRegexFlags",
            expression: "'N8000123123'.matches('N[0-9]{8}')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_matchesMultiline",
            group: "testRegexFlags",
            expression: "'first line\\nsecond line'.matches('^second', 'm')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_matchesNoFlags",
            group: "testRegexFlags",
            expression: "'first line\\nsecond line'.matches('^second', '')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_matchesCombinedFlags",
            group: "testRegexFlags",
            expression: "'first line\\nsecond line'.matches('^SECOND', 'im')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_matchesSingleLineDot",
            group: "testRegexFlags",
            expression: "'a\\nb'.matches('a.b')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_matchesInvalidFlag",
            group: "testRegexFlags",
            expression: "'abc'.matches('a', 'x')",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_matchesMultipleInputs",
            group: "testRegexFlags",
            expression: "('a' | 'b').matches('a')",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_matchesFullPartial",
            group: "testRegexFlags",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('Library')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_matchesFullShort",
            group: "testRegexFlags",
            expression: "'N8000123123'.matchesFull('N[0-9]{8}')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_matchesFullExact",
            group: "testRegexFlags",
            expression: "'N8000123123'.matchesFull('N[0-9]{10}')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_matchesFullCaseInsensitive",
            group: "testRegexFlags",
            expression: "'ABC'.matchesFull('abc', 'i')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_replaceMatchesAll",
            group: "testRegexFlags",
            expression: "'aaabaa'.replaceMatches('aa', '<aa>')",
            resourceKey: "patient",
            expected: ["<aa>ab<aa>"],
            expectError: false
        },
        {
            name: "test_replaceMatchesNamedGroups",
            group: "testRegexFlags",
            expression: "'11/30/1972'.replaceMatches('\\\\b(?<month>\\\\d{1,2})/(?<day>\\\\d{1,2})/(?<year>\\\\d{2,4})\\\\b', '${day}-${month}-${year}')",
            resourceKey: "patient",
            expected: ["30-11-1972"],
            expectError: false
        },
        {
            name: "test_replaceMatchesFlags",
            group: "testRegexFlags",
            expression: "'ABC'.replaceMatches('b', 'x', 'i')",
            resourceKey: "patient",
            expected: ["AxC"],
            expectError: false
        },
        {
            name: "test_toDateFromDateTime",
            group: "testDateFormats",
            expression: "@2024-01-15T23:30:00-05:00.toDate()",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_toDateDefault",
            group: "testDateFormats",
            expression: "'2024-01-15'.toDate()",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_toDateTwoDigitYear",
            group: "testDateFormats",
            expression: "'150124'.toDate('ddMMyy')",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_toDateLiterals",
            group: "testDateFormats",
            expression: "'15-01-2024'.toDate('dd-MM-yyyy')",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_toDatePartial",
            group: "testDateFormats",
            expression: "'12-27'.toDate('MM-yy')",
            resourceKey: "patient",
            expected: ["@2027-12"],
            expectError: false
        },
        {
            name: "test_toDateMonthName",
            group: "testDateFormats",
            expression: "'Jan 15, 2024'.toDate('MMM d, yyyy')",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_toDateFullMonthName",
            group: "testDateFormats",
            expression: "'15 January 2024'.toDate('d MMMM yyyy')",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_toDateType",
            group: "testDateFormats",
            expression: "'2024-01-15'.toDate().type().name",
            resourceKey: "patient",
            expected: ["Date"],
            expectError: false
        },
        {
            name: "test_toDateInvalid",
            group: "testDateFormats",
            expression: "'abc'.toDate()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toDateInvalidMonth",
            group: "testDateFormats",
            expression: "'2024-13-01'.toDate()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toDateInvalidDay",
            group: "testDateFormats",
            expression: "'2024-02-30'.toDate()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toDateFormatMismatch",
            group: "testDateFormats",
            expression: "'2024/01/15'.toDate('dd-MM-yyyy')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toDateMultipleInputs",
            group: "testDateFormats",
            expression: "('2024' | '2025').toDate()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_convertsToDateDefault",
            group: "testDateFormats",
            expression: "'2015-02-04'.convertsToDate()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_convertsToDateInvalid",
            group: "testDateFormats",
            expression: "'not-a-date'.convertsToDate()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_convertsToDateFormat",
            group: "testDateFormats",
            expression: "'15/01/2024'.convertsToDate('dd/MM/yyyy')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_convertsToDateWrongDefault",
            group: "testDateFormats",
            expression: "'15/01/2024'.convertsToDate()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_toDateTimeDefault",
            group: "testDateFormats",
            expression: "'2015-02-04T14:34:28Z'.toDateTime()",
            resourceKey: "patient",
            expected: ["@2015-02-04T14:34:28Z"],
            expectError: false
        },
        {
            name: "test_toDateTimePartial",
            group: "testDateFormats",
            expression: "'2012-01-01T10:00'.toDateTime()",
            resourceKey: "patient",
            expected: ["@2012-01-01T10:00"],
            expectError: false
        },
        {
            name: "test_toDateTimeFromDate",
            group: "testDateFormats",
            expression: "@2015-02-04.toDateTime()",
            resourceKey: "patient",
            expected: ["@2015-02-04T"],
            expectError: false
        },
        {
            name: "test_toDateTimeFromDateType",
            group: "testDateFormats",
            expression: "@2015-02-04.toDateTime().type().name",
            resourceKey: "patient",
            expected: ["DateTime"],
            expectError: false
        },
        {
            name: "test_toDateTimeTwelveHour",
            group: "testDateFormats",
            expression: "'01/15/2024 03:45 PM'.toDateTime('MM/dd/yyyy hh:mm a')",
            resourceKey: "patient",
            expected: ["@2024-01-15T15:45"],
            expectError: false
        },
        {
            name: "test_toDateTimeOffset",
            group: "testDateFormats",
            expression: "'20240115 1430+0530'.toDateTime('yyyyMMdd HHmmZ')",
            resourceKey: "patient",
            expected: ["@2024-01-15T14:30+05:30"],
            expectError: false
        },
        {
            name: "test_toDateTimeFraction",
            group: "testDateFormats",
            expression: "'2024-01-15 14:30:15.123'.toDateTime('yyyy-MM-dd HH:mm:ss.SSS')",
            resourceKey: "patient",
            expected: ["@2024-01-15T14:30:15.123"],
            expectError: false
        },
        {
            name: "test_toDateTimeUtc",
            group: "testDateFormats",
            expression: "'2024-01-15 14:30Z'.toDateTime('yyyy-MM-dd HH:mmZ')",
            resourceKey: "patient",
            expected: ["@2024-01-15T14:30Z"],
            expectError: false
        },
        {
            name: "test_toDateTimeInvalidHour",
            group: "testDateFormats",
            expression: "'2024-01-15T25:00'.toDateTime()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_convertsToDateTimeFormat",
            group: "testDateFormats",
            expression: "'15.01.2024 08:00'.convertsToDateTime('dd.MM.yyyy HH:mm')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toTimeString",
            group: "testDateFormats",
            expression: "'14:34'.toTime()",
            resourceKey: "patient",
            expected: ["@T14:34"],
            expectError: false
        },
        {
            name: "test_toTimeInvalid",
            group: "testDateFormats",
            expression: "'14h'.toTime()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toQuantityWeeksToDays",
            group: "testQuantityUnits",
            expression: "1 'wk'.toQuantity('d') = 7 'd'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityYearsUcum",
            group: "testQuantityUnits",
            expression: "1 'a'.toQuantity('d') = 365.25 'd'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityCalendarYear",
            group: "testQuantityUnits",
            expression: "1 year.toQuantity('d') = 365 'd'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityCalendarPlural",
            group: "testQuantityUnits",
            expression: "2 weeks.toQuantity('days') = 14 days",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityHoursToMinutes",
            group: "testQuantityUnits",
            expression: "1.5 'h'.toQuantity('min') = 90 'min'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantitySameUnit",
            group: "testQuantityUnits",
            expression: "4 'mg'.toQuantity('mg') = 4 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityDefaultUnitNoConversion",
            group: "testQuantityUnits",
            expression: "45.toQuantity('m')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toQuantityIncommensurable",
            group: "testQuantityUnits",
            expression: "24 'm'.toQuantity('kg')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toQuantityInteger",
            group: "testQuantityUnits",
            expression: "42.toQuantity() = 42 '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityType",
            group: "testQuantityUnits",
            expression: "'4 days'.toQuantity().type().name",
            resourceKey: "patient",
            expected: ["Quantity"],
            expectError: false
        },
        {
            name: "test_toQuantityString",
            group: "testQuantityUnits",
            expression: "'4 days'.toQuantity() = 4 days",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityNoSpace",
            group: "testQuantityUnits",
            expression: "'4days'.toQuantity() = 4 days",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_toQuantityMultipleInputs",
            group: "testQuantityUnits",
            expression: "(1 | 2).toQuantity()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_convertsToQuantityUnit",
            group: "testQuantityUnits",
            expression: "1 'wk'.convertsToQuantity('d')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_convertsToQuantityIncommensurable",
            group: "testQuantityUnits",
            expression: "5 'm'.convertsToQuantity('kg')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_contextVariable",
            group: "testEnvironmentVariables",
            expression: "%context.resourceType",
            resourceKey: "patient",
            expected: ["Patient"],
            expectError: false
        },
        {
            name: "test_resourceVariable",
            group: "testEnvironmentVariables",
            expression: "%resource.name.count()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_rootResourceVariable",
            group: "testEnvironmentVariables",
            expression: "%rootResource.birthDate",
            resourceKey: "patient",
            expected: ["1974-12-25"],
            expectError: false
        },
        {
            name: "test_resourceInsideScope",
            group: "testEnvironmentVariables",
            expression: "Patient.name.where(%resource.birthDate = @1974-12-25).count()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_contextInsideSelect",
            group: "testEnvironmentVariables",
            expression: "name.select(%context.id).distinct()",
            resourceKey: "patient",
            expected: ["example"],
            expectError: false
        },
        {
            name: "test_ucumVariable",
            group: "testEnvironmentVariables",
            expression: "%ucum",
            resourceKey: "patient",
            expected: ["http://unitsofmeasure.org"],
            expectError: false
        },
        {
            name: "test_bareIdentifierIsNotVariable",
            group: "testEnvironmentVariables",
            expression: "resource.exists()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_undefinedVariable",
            group: "testEnvironmentVariables",
            expression: "%undefinedVariable",
            resourceKey: "patient",
            expected: [],
            expectError: true
        }
    ];
}
