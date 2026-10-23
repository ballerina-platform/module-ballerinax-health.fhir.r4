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

// Worked examples from the FHIRPath STU3 specification text (https://hl7.org/fhirpath/STU3/en/), extracted from
// its `expression // result` code samples. Expected values were verified against the documented results with the
// conformance tooling in scripts/conformance and are written in this library's JSON output form.
function getSpecExamplesTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_specExample1",
            group: "specExamples",
            expression: "'\\p'",
            resourceKey: "patient",
            expected: ["p"],
            expectError: false
        },
        {
            name: "test_specExample2",
            group: "specExamples",
            expression: "'\\\\p'",
            resourceKey: "patient",
            expected: ["\\p"],
            expectError: false
        },
        {
            name: "test_specExample3",
            group: "specExamples",
            expression: "'\\3'",
            resourceKey: "patient",
            expected: ["3"],
            expectError: false
        },
        {
            name: "test_specExample4",
            group: "specExamples",
            expression: "'\\u005'",
            resourceKey: "patient",
            expected: ["u005"],
            expectError: false
        },
        {
            name: "test_specExample5",
            group: "specExamples",
            expression: "'\\'",
            resourceKey: "patient",
            expected: [""],
            expectError: false
        },
        {
            name: "test_specExample6",
            group: "specExamples",
            expression: "1 'm' | 100 'cm'",
            resourceKey: "patient",
            expected: [{"value": 1.0d, "unit": "m"}],
            expectError: false
        },
        {
            name: "test_specExample7",
            group: "specExamples",
            expression: "1.combine(2).combine(3).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample8",
            group: "specExamples",
            expression: "1.combine(2).combine(3).combine(2).isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample9",
            group: "specExamples",
            expression: "1 'm'.combine(100 'cm').isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample10",
            group: "specExamples",
            expression: "(3 | 1 | 2).sort()",
            resourceKey: "patient",
            expected: [1, 2, 3],
            expectError: false
        },
        {
            name: "test_specExample11",
            group: "specExamples",
            expression: "(3 | 1 | 2).sort($this)",
            resourceKey: "patient",
            expected: [1, 2, 3],
            expectError: false
        },
        {
            name: "test_specExample12",
            group: "specExamples",
            expression: "(3 | 1 | 2).sort($this desc)",
            resourceKey: "patient",
            expected: [3, 2, 1],
            expectError: false
        },
        {
            name: "test_specExample13",
            group: "specExamples",
            expression: "('c' | 'a' | 'b').sort()",
            resourceKey: "patient",
            expected: ["a", "b", "c"],
            expectError: false
        },
        {
            name: "test_specExample14",
            group: "specExamples",
            expression: "('c' | 'a' | 'b').sort($this desc)",
            resourceKey: "patient",
            expected: ["c", "b", "a"],
            expectError: false
        },
        {
            name: "test_specExample15",
            group: "specExamples",
            expression: "('3' | '1' | '10').sort()",
            resourceKey: "patient",
            expected: ["1", "10", "3"],
            expectError: false
        },
        {
            name: "test_specExample16",
            group: "specExamples",
            expression: "(0 | 1 | 2).tail()",
            resourceKey: "patient",
            expected: [1, 2],
            expectError: false
        },
        {
            name: "test_specExample17",
            group: "specExamples",
            expression: "(0 | 1 | 2).skip(1)",
            resourceKey: "patient",
            expected: [1, 2],
            expectError: false
        },
        {
            name: "test_specExample18",
            group: "specExamples",
            expression: "(0 | 1 | 2).skip(2)",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample19",
            group: "specExamples",
            expression: "(0 | 1 | 2).take(2)",
            resourceKey: "patient",
            expected: [0, 1],
            expectError: false
        },
        {
            name: "test_specExample20",
            group: "specExamples",
            expression: "(0 | 1 | 2).take(5)",
            resourceKey: "patient",
            expected: [0, 1, 2],
            expectError: false
        },
        {
            name: "test_specExample21",
            group: "specExamples",
            expression: "(1 | 2 | 3).intersect(2 | 4)",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample22",
            group: "specExamples",
            expression: "(1 | 2 | 3).exclude(2)",
            resourceKey: "patient",
            expected: [1, 3],
            expectError: false
        },
        {
            name: "test_specExample23",
            group: "specExamples",
            expression: "iif(true, 'It is true', 'It is false')",
            resourceKey: "patient",
            expected: ["It is true"],
            expectError: false
        },
        {
            name: "test_specExample24",
            group: "specExamples",
            expression: "iif(false, 'It is true', 'It is false')",
            resourceKey: "patient",
            expected: ["It is false"],
            expectError: false
        },
        {
            name: "test_specExample25",
            group: "specExamples",
            expression: "iif({}, 'It is true', 'It is false')",
            resourceKey: "patient",
            expected: ["It is false"],
            expectError: false
        },
        {
            name: "test_specExample26",
            group: "specExamples",
            expression: "{}.iif(true, 'It is true', 'It is false')",
            resourceKey: "patient",
            expected: ["It is true"],
            expectError: false
        },
        {
            name: "test_specExample27",
            group: "specExamples",
            expression: "iif(1, 'true', 'false')",
            resourceKey: "patient",
            expected: ["true"],
            expectError: false
        },
        {
            name: "test_specExample28",
            group: "specExamples",
            expression: "iif(0, 'true', 'false')",
            resourceKey: "patient",
            expected: ["true"],
            expectError: false
        },
        {
            name: "test_specExample29",
            group: "specExamples",
            expression: "iif('hi', 'true', 'false')",
            resourceKey: "patient",
            expected: ["true"],
            expectError: false
        },
        {
            name: "test_specExample30",
            group: "specExamples",
            expression: "'true'.toBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample31",
            group: "specExamples",
            expression: "1.toBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample32",
            group: "specExamples",
            expression: "'hello'.toBoolean()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample33",
            group: "specExamples",
            expression: "'true'.convertsToBoolean()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample34",
            group: "specExamples",
            expression: "'abc'.convertsToBoolean()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample35",
            group: "specExamples",
            expression: "'1'.toInteger()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample36",
            group: "specExamples",
            expression: "'st'.toInteger()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample37",
            group: "specExamples",
            expression: "42L.toInteger()",
            resourceKey: "patient",
            expected: [42],
            expectError: false
        },
        {
            name: "test_specExample38",
            group: "specExamples",
            expression: "'1'.convertsToInteger()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample39",
            group: "specExamples",
            expression: "'1.0'.convertsToInteger()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample40",
            group: "specExamples",
            expression: "42.toLong()",
            resourceKey: "patient",
            expected: [42],
            expectError: false
        },
        {
            name: "test_specExample41",
            group: "specExamples",
            expression: "'123'.toLong()",
            resourceKey: "patient",
            expected: [123],
            expectError: false
        },
        {
            name: "test_specExample42",
            group: "specExamples",
            expression: "'abc'.toLong()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample43",
            group: "specExamples",
            expression: "'123'.convertsToLong()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample44",
            group: "specExamples",
            expression: "'abc'.convertsToLong()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample45",
            group: "specExamples",
            expression: "@2024-01-15T23:30:00-05:00.toDate()",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_specExample46",
            group: "specExamples",
            expression: "'2024-01-15'.toDate()",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_specExample47",
            group: "specExamples",
            expression: "'150124'.toDate('ddMMyy')",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_specExample48",
            group: "specExamples",
            expression: "'15-01-2024'.toDate('dd-MM-yyyy')",
            resourceKey: "patient",
            expected: ["@2024-01-15"],
            expectError: false
        },
        {
            name: "test_specExample49",
            group: "specExamples",
            expression: "'12-27'.toDate('MM-yy')",
            resourceKey: "patient",
            expected: ["@2027-12"],
            expectError: false
        },
        {
            name: "test_specExample50",
            group: "specExamples",
            expression: "'2015-02-04'.convertsToDate()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample51",
            group: "specExamples",
            expression: "'not-a-date'.convertsToDate()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample52",
            group: "specExamples",
            expression: "'2015-02-04T14:34:28Z'.toDateTime()",
            resourceKey: "patient",
            expected: ["@2015-02-04T14:34:28Z"],
            expectError: false
        },
        {
            name: "test_specExample53",
            group: "specExamples",
            expression: "'2012-01-01T10:00'.toDateTime()",
            resourceKey: "patient",
            expected: ["@2012-01-01T10:00"],
            expectError: false
        },
        {
            name: "test_specExample54",
            group: "specExamples",
            expression: "'2015-02-04T14:34:28'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample55",
            group: "specExamples",
            expression: "'not a datetime'.convertsToDateTime()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample56",
            group: "specExamples",
            expression: "'1.1'.toDecimal()",
            resourceKey: "patient",
            expected: [1.1d],
            expectError: false
        },
        {
            name: "test_specExample57",
            group: "specExamples",
            expression: "'42'.toDecimal()",
            resourceKey: "patient",
            expected: [42],
            expectError: false
        },
        {
            name: "test_specExample58",
            group: "specExamples",
            expression: "'42L'.toDecimal()",
            resourceKey: "patient",
            expected: [42],
            expectError: false
        },
        {
            name: "test_specExample59",
            group: "specExamples",
            expression: "'st'.toDecimal()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample60",
            group: "specExamples",
            expression: "'1.0'.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample61",
            group: "specExamples",
            expression: "'42'.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample62",
            group: "specExamples",
            expression: "'42L'.convertsToDecimal()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample63",
            group: "specExamples",
            expression: "'1.a'.convertsToDecimal()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample64",
            group: "specExamples",
            expression: "52 'cm'.toQuantity('m')",
            resourceKey: "patient",
            expected: [{"value": 0.520d, "unit": "m"}],
            expectError: false
        },
        {
            name: "test_specExample65",
            group: "specExamples",
            expression: "45.toQuantity('m')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample66",
            group: "specExamples",
            expression: "24 'm'.toQuantity('kg')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample67",
            group: "specExamples",
            expression: "1 'a'.toQuantity('d')",
            resourceKey: "patient",
            expected: [{"value": 365.25d, "unit": "d"}],
            expectError: false
        },
        {
            name: "test_specExample68",
            group: "specExamples",
            expression: "1 'wk'.toQuantity('d')",
            resourceKey: "patient",
            expected: [{"value": 7.0d, "unit": "d"}],
            expectError: false
        },
        {
            name: "test_specExample69",
            group: "specExamples",
            expression: "42.toQuantity()",
            resourceKey: "patient",
            expected: [{"value": 42.0d, "unit": "1"}],
            expectError: false
        },
        {
            name: "test_specExample70",
            group: "specExamples",
            expression: "182.5 'd'.toQuantity('a')",
            resourceKey: "patient",
            expected: [{"value": 0.499657768651608487337440d, "unit": "a"}],
            expectError: false
        },
        {
            name: "test_specExample71",
            group: "specExamples",
            expression: "'1 day'.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample72",
            group: "specExamples",
            expression: "10 'mg'.convertsToQuantity()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample73",
            group: "specExamples",
            expression: "2 '[in_i]'.convertsToQuantity('cm')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample74",
            group: "specExamples",
            expression: "10 'Cel'.convertsToQuantity('[degF]')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample75",
            group: "specExamples",
            expression: "@2025-01-15.convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample76",
            group: "specExamples",
            expression: "1.convertsToString()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample77",
            group: "specExamples",
            expression: "Patient.name.first().convertsToString()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample78",
            group: "specExamples",
            expression: "{}.convertsToString()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample79",
            group: "specExamples",
            expression: "'14:34:28'.toTime()",
            resourceKey: "patient",
            expected: ["@T14:34:28"],
            expectError: false
        },
        {
            name: "test_specExample80",
            group: "specExamples",
            expression: "'10:00'.toTime()",
            resourceKey: "patient",
            expected: ["@T10:00"],
            expectError: false
        },
        {
            name: "test_specExample81",
            group: "specExamples",
            expression: "'14:34:28'.convertsToTime()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample82",
            group: "specExamples",
            expression: "'not a time'.convertsToTime()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample83",
            group: "specExamples",
            expression: "'abcdefg'.indexOf('bc')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample84",
            group: "specExamples",
            expression: "'abcdefg'.indexOf('x')",
            resourceKey: "patient",
            expected: [-1],
            expectError: false
        },
        {
            name: "test_specExample85",
            group: "specExamples",
            expression: "'abcdefg'.indexOf('abcdefg')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_specExample86",
            group: "specExamples",
            expression: "'a🔥b'.indexOf('🔥')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample87",
            group: "specExamples",
            expression: "'a🔥b'.indexOf('b')",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample88",
            group: "specExamples",
            expression: "'a\\uD83D\\uDD25b'.indexOf('b')",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample89",
            group: "specExamples",
            expression: "'abcdefg'.lastIndexOf('bc')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample90",
            group: "specExamples",
            expression: "'abcdefg'.lastIndexOf('x')",
            resourceKey: "patient",
            expected: [-1],
            expectError: false
        },
        {
            name: "test_specExample91",
            group: "specExamples",
            expression: "'abcdefg'.lastIndexOf('abcdefg')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_specExample92",
            group: "specExamples",
            expression: "'abc abc'.lastIndexOf('a')",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_specExample93",
            group: "specExamples",
            expression: "'0123'.lastIndexOf('')",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_specExample94",
            group: "specExamples",
            expression: "'0'.lastIndexOf('')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample95",
            group: "specExamples",
            expression: "''.lastIndexOf('')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_specExample96",
            group: "specExamples",
            expression: "'abcdefg'.substring(3)",
            resourceKey: "patient",
            expected: ["defg"],
            expectError: false
        },
        {
            name: "test_specExample97",
            group: "specExamples",
            expression: "'abcdefg'.substring(1, 2)",
            resourceKey: "patient",
            expected: ["bc"],
            expectError: false
        },
        {
            name: "test_specExample98",
            group: "specExamples",
            expression: "'abcdefg'.substring(6, 2)",
            resourceKey: "patient",
            expected: ["g"],
            expectError: false
        },
        {
            name: "test_specExample99",
            group: "specExamples",
            expression: "'abcdefg'.substring(7, 1)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample100",
            group: "specExamples",
            expression: "'abcdefg'.substring(-1, 1)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample101",
            group: "specExamples",
            expression: "'abcdefg'.substring(3, 0)",
            resourceKey: "patient",
            expected: [""],
            expectError: false
        },
        {
            name: "test_specExample102",
            group: "specExamples",
            expression: "'abcdefg'.substring(3, -1)",
            resourceKey: "patient",
            expected: [""],
            expectError: false
        },
        {
            name: "test_specExample103",
            group: "specExamples",
            expression: "'abcdefg'.substring(-1, -1)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample104",
            group: "specExamples",
            expression: "''.substring(0)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample105",
            group: "specExamples",
            expression: "'abcdefg'.startsWith('abc')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample106",
            group: "specExamples",
            expression: "'abcdefg'.startsWith('xyz')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample107",
            group: "specExamples",
            expression: "'abcdefg'.endsWith('efg')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample108",
            group: "specExamples",
            expression: "'abcdefg'.endsWith('abc')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample109",
            group: "specExamples",
            expression: "'abc'.contains('b')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample110",
            group: "specExamples",
            expression: "'abc'.contains('bc')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample111",
            group: "specExamples",
            expression: "'abc'.contains('d')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample112",
            group: "specExamples",
            expression: "'abcdefg'.upper()",
            resourceKey: "patient",
            expected: ["ABCDEFG"],
            expectError: false
        },
        {
            name: "test_specExample113",
            group: "specExamples",
            expression: "'AbCdefg'.upper()",
            resourceKey: "patient",
            expected: ["ABCDEFG"],
            expectError: false
        },
        {
            name: "test_specExample114",
            group: "specExamples",
            expression: "'ABCDEFG'.lower()",
            resourceKey: "patient",
            expected: ["abcdefg"],
            expectError: false
        },
        {
            name: "test_specExample115",
            group: "specExamples",
            expression: "'aBcDEFG'.lower()",
            resourceKey: "patient",
            expected: ["abcdefg"],
            expectError: false
        },
        {
            name: "test_specExample116",
            group: "specExamples",
            expression: "'abcdefg'.replace('cde', '123')",
            resourceKey: "patient",
            expected: ["ab123fg"],
            expectError: false
        },
        {
            name: "test_specExample117",
            group: "specExamples",
            expression: "'abcdefg'.replace('cde', '')",
            resourceKey: "patient",
            expected: ["abfg"],
            expectError: false
        },
        {
            name: "test_specExample118",
            group: "specExamples",
            expression: "'abc'.replace('', 'x')",
            resourceKey: "patient",
            expected: ["xaxbxcx"],
            expectError: false
        },
        {
            name: "test_specExample119",
            group: "specExamples",
            expression: "'a\\uD83D\\uDD25c'.replace('', 'x')",
            resourceKey: "patient",
            expected: ["xax🔥xcx"],
            expectError: false
        },
        {
            name: "test_specExample120",
            group: "specExamples",
            expression: "'a🔥c'.replace('', 'x')",
            resourceKey: "patient",
            expected: ["xax🔥xcx"],
            expectError: false
        },
        {
            name: "test_specExample121",
            group: "specExamples",
            expression: "'N8000123123'.matches('^N[0-9]{8}$')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample122",
            group: "specExamples",
            expression: "'N8000123123'.matches('N[0-9]{8}')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample123",
            group: "specExamples",
            expression: "'first line\\nsecond line'.matches('^second', 'm')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample124",
            group: "specExamples",
            expression: "'first line\\nsecond line'.matches('^second', '')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample125",
            group: "specExamples",
            expression: "'first line\\nsecond line'.matches('^SECOND', 'im')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample126",
            group: "specExamples",
            expression: "'N8000123123'.matchesFull('N[0-9]{8}')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample127",
            group: "specExamples",
            expression: "'N8000123123'.matchesFull('N[0-9]{10}')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample128",
            group: "specExamples",
            expression: "'abc'.length()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_specExample129",
            group: "specExamples",
            expression: "''.length()",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_specExample130",
            group: "specExamples",
            expression: "'\\u0065\\u0301'.length()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample131",
            group: "specExamples",
            expression: "'\\uD83D\\uDD25'.length()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample132",
            group: "specExamples",
            expression: "'test'.encode('base64')",
            resourceKey: "patient",
            expected: ["dGVzdA=="],
            expectError: false
        },
        {
            name: "test_specExample133",
            group: "specExamples",
            expression: "'test'.encode('hex')",
            resourceKey: "patient",
            expected: ["74657374"],
            expectError: false
        },
        {
            name: "test_specExample134",
            group: "specExamples",
            expression: "'dGVzdA=='.decode('base64')",
            resourceKey: "patient",
            expected: ["test"],
            expectError: false
        },
        {
            name: "test_specExample135",
            group: "specExamples",
            expression: "'74657374'.decode('hex')",
            resourceKey: "patient",
            expected: ["test"],
            expectError: false
        },
        {
            name: "test_specExample136",
            group: "specExamples",
            expression: "'A&B'.escape('html')",
            resourceKey: "patient",
            expected: ["A&amp;B"],
            expectError: false
        },
        {
            name: "test_specExample137",
            group: "specExamples",
            expression: "'\"1<2\"'.escape('json')",
            resourceKey: "patient",
            expected: ["\\\"1<2\\\""],
            expectError: false
        },
        {
            name: "test_specExample138",
            group: "specExamples",
            expression: "'&quot;1&lt;2&quot;'.unescape('html')",
            resourceKey: "patient",
            expected: ["\"1<2\""],
            expectError: false
        },
        {
            name: "test_specExample139",
            group: "specExamples",
            expression: "' 123456 '.trim()",
            resourceKey: "patient",
            expected: ["123456"],
            expectError: false
        },
        {
            name: "test_specExample140",
            group: "specExamples",
            expression: "'  '.trim()",
            resourceKey: "patient",
            expected: [""],
            expectError: false
        },
        {
            name: "test_specExample141",
            group: "specExamples",
            expression: "('A' | 'B' | 'C').join()",
            resourceKey: "patient",
            expected: ["ABC"],
            expectError: false
        },
        {
            name: "test_specExample142",
            group: "specExamples",
            expression: "(-5).abs()",
            resourceKey: "patient",
            expected: [5],
            expectError: false
        },
        {
            name: "test_specExample143",
            group: "specExamples",
            expression: "(-5.5).abs()",
            resourceKey: "patient",
            expected: [5.5d],
            expectError: false
        },
        {
            name: "test_specExample144",
            group: "specExamples",
            expression: "(-5.5 'mg').abs()",
            resourceKey: "patient",
            expected: [{"value": 5.5d, "unit": "mg"}],
            expectError: false
        },
        {
            name: "test_specExample145",
            group: "specExamples",
            expression: "1.ceiling()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample146",
            group: "specExamples",
            expression: "1.1.ceiling()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample147",
            group: "specExamples",
            expression: "(-1.1).ceiling()",
            resourceKey: "patient",
            expected: [-1],
            expectError: false
        },
        {
            name: "test_specExample148",
            group: "specExamples",
            expression: "0.exp()",
            resourceKey: "patient",
            expected: [1.0d],
            expectError: false
        },
        {
            name: "test_specExample149",
            group: "specExamples",
            expression: "(-0.0).exp()",
            resourceKey: "patient",
            expected: [1.0d],
            expectError: false
        },
        {
            name: "test_specExample150",
            group: "specExamples",
            expression: "1.floor()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample151",
            group: "specExamples",
            expression: "2.1.floor()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample152",
            group: "specExamples",
            expression: "(-2.1).floor()",
            resourceKey: "patient",
            expected: [-3],
            expectError: false
        },
        {
            name: "test_specExample153",
            group: "specExamples",
            expression: "1.ln()",
            resourceKey: "patient",
            expected: [0.0d],
            expectError: false
        },
        {
            name: "test_specExample154",
            group: "specExamples",
            expression: "1.0.ln()",
            resourceKey: "patient",
            expected: [0.0d],
            expectError: false
        },
        {
            name: "test_specExample155",
            group: "specExamples",
            expression: "16.log(2)",
            resourceKey: "patient",
            expected: [4.0d],
            expectError: false
        },
        {
            name: "test_specExample156",
            group: "specExamples",
            expression: "100.0.log(10.0)",
            resourceKey: "patient",
            expected: [2.0d],
            expectError: false
        },
        {
            name: "test_specExample157",
            group: "specExamples",
            expression: "2.power(3)",
            resourceKey: "patient",
            expected: [8],
            expectError: false
        },
        {
            name: "test_specExample158",
            group: "specExamples",
            expression: "2.5.power(2)",
            resourceKey: "patient",
            expected: [6.25d],
            expectError: false
        },
        {
            name: "test_specExample159",
            group: "specExamples",
            expression: "2.power(-1)",
            resourceKey: "patient",
            expected: [0.5d],
            expectError: false
        },
        {
            name: "test_specExample160",
            group: "specExamples",
            expression: "(-1).power(0.5)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample161",
            group: "specExamples",
            expression: "1.round()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample162",
            group: "specExamples",
            expression: "3.14159.round(3)",
            resourceKey: "patient",
            expected: [3.142d],
            expectError: false
        },
        {
            name: "test_specExample163",
            group: "specExamples",
            expression: "81.sqrt()",
            resourceKey: "patient",
            expected: [9.0d],
            expectError: false
        },
        {
            name: "test_specExample164",
            group: "specExamples",
            expression: "(-1).sqrt()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample165",
            group: "specExamples",
            expression: "101.truncate()",
            resourceKey: "patient",
            expected: [101],
            expectError: false
        },
        {
            name: "test_specExample166",
            group: "specExamples",
            expression: "1.00000001.truncate()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample167",
            group: "specExamples",
            expression: "(-1.56).truncate()",
            resourceKey: "patient",
            expected: [-1],
            expectError: false
        },
        {
            name: "test_specExample168",
            group: "specExamples",
            expression: "timeOfDay() = timeOfDay()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample169",
            group: "specExamples",
            expression: "1.587.lowBoundary()",
            resourceKey: "patient",
            expected: [1.5865d],
            expectError: false
        },
        {
            name: "test_specExample170",
            group: "specExamples",
            expression: "1.587.lowBoundary(6)",
            resourceKey: "patient",
            expected: [1.5865d],
            expectError: false
        },
        {
            name: "test_specExample171",
            group: "specExamples",
            expression: "1.587.lowBoundary(2)",
            resourceKey: "patient",
            expected: [1.58d],
            expectError: false
        },
        {
            name: "test_specExample172",
            group: "specExamples",
            expression: "1.587.lowBoundary(0)",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample173",
            group: "specExamples",
            expression: "(-1.587).lowBoundary()",
            resourceKey: "patient",
            expected: [-1.5875d],
            expectError: false
        },
        {
            name: "test_specExample174",
            group: "specExamples",
            expression: "(-1.587).lowBoundary(6)",
            resourceKey: "patient",
            expected: [-1.5875d],
            expectError: false
        },
        {
            name: "test_specExample175",
            group: "specExamples",
            expression: "(-1.587).lowBoundary(2)",
            resourceKey: "patient",
            expected: [-1.59d],
            expectError: false
        },
        {
            name: "test_specExample176",
            group: "specExamples",
            expression: "(-1.587).lowBoundary(0)",
            resourceKey: "patient",
            expected: [-2],
            expectError: false
        },
        {
            name: "test_specExample177",
            group: "specExamples",
            expression: "@2014.lowBoundary(6)",
            resourceKey: "patient",
            expected: ["@2014-01"],
            expectError: false
        },
        {
            name: "test_specExample178",
            group: "specExamples",
            expression: "@T10:30.lowBoundary(9)",
            resourceKey: "patient",
            expected: ["@T10:30:00.000"],
            expectError: false
        },
        {
            name: "test_specExample179",
            group: "specExamples",
            expression: "1.587.highBoundary()",
            resourceKey: "patient",
            expected: [1.5875d],
            expectError: false
        },
        {
            name: "test_specExample180",
            group: "specExamples",
            expression: "1.587.highBoundary(6)",
            resourceKey: "patient",
            expected: [1.5875d],
            expectError: false
        },
        {
            name: "test_specExample181",
            group: "specExamples",
            expression: "1.587.highBoundary(2)",
            resourceKey: "patient",
            expected: [1.59d],
            expectError: false
        },
        {
            name: "test_specExample182",
            group: "specExamples",
            expression: "1.587.highBoundary(0)",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample183",
            group: "specExamples",
            expression: "(-1.587).highBoundary()",
            resourceKey: "patient",
            expected: [-1.5865d],
            expectError: false
        },
        {
            name: "test_specExample184",
            group: "specExamples",
            expression: "(-1.587).highBoundary(6)",
            resourceKey: "patient",
            expected: [-1.5865d],
            expectError: false
        },
        {
            name: "test_specExample185",
            group: "specExamples",
            expression: "(-1.587).highBoundary(2)",
            resourceKey: "patient",
            expected: [-1.58d],
            expectError: false
        },
        {
            name: "test_specExample186",
            group: "specExamples",
            expression: "(-1.587).highBoundary(0)",
            resourceKey: "patient",
            expected: [-1],
            expectError: false
        },
        {
            name: "test_specExample187",
            group: "specExamples",
            expression: "@2014.highBoundary(6)",
            resourceKey: "patient",
            expected: ["@2014-12"],
            expectError: false
        },
        {
            name: "test_specExample188",
            group: "specExamples",
            expression: "@T10:30.highBoundary(9)",
            resourceKey: "patient",
            expected: ["@T10:30:59.999"],
            expectError: false
        },
        {
            name: "test_specExample189",
            group: "specExamples",
            expression: "1.58700.precision()",
            resourceKey: "patient",
            expected: [5],
            expectError: false
        },
        {
            name: "test_specExample190",
            group: "specExamples",
            expression: "100.precision()",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_specExample191",
            group: "specExamples",
            expression: "@2014.precision()",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_specExample192",
            group: "specExamples",
            expression: "@2014-01-05T10:30:00.000.precision()",
            resourceKey: "patient",
            expected: [17],
            expectError: false
        },
        {
            name: "test_specExample193",
            group: "specExamples",
            expression: "@T10:30.precision()",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_specExample194",
            group: "specExamples",
            expression: "@T10:30:00.000.precision()",
            resourceKey: "patient",
            expected: [9],
            expectError: false
        },
        {
            name: "test_specExample195",
            group: "specExamples",
            expression: "@2014-01-05T10:30:00.000.yearOf()",
            resourceKey: "patient",
            expected: [2014],
            expectError: false
        },
        {
            name: "test_specExample196",
            group: "specExamples",
            expression: "@2014-01-05T10:30:00.000.monthOf()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample197",
            group: "specExamples",
            expression: "@2014-01-05T10:30:00.000.dayOf()",
            resourceKey: "patient",
            expected: [5],
            expectError: false
        },
        {
            name: "test_specExample198",
            group: "specExamples",
            expression: "@2012-01-01T03:30:40.002-07:00.hourOf()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_specExample199",
            group: "specExamples",
            expression: "@2012-01-01T16:30:40.002-07:00.hourOf()",
            resourceKey: "patient",
            expected: [16],
            expectError: false
        },
        {
            name: "test_specExample200",
            group: "specExamples",
            expression: "@2012-01-01T12:30:40.002-07:00.minuteOf()",
            resourceKey: "patient",
            expected: [30],
            expectError: false
        },
        {
            name: "test_specExample201",
            group: "specExamples",
            expression: "@2012-01-01T12:30:40.002-07:00.secondOf()",
            resourceKey: "patient",
            expected: [40],
            expectError: false
        },
        {
            name: "test_specExample202",
            group: "specExamples",
            expression: "@2012-01-01T12:30:00.002-07:00.millisecondOf()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample203",
            group: "specExamples",
            expression: "@2012-01-01T12:30:00.000-07:00.timezoneOffsetOf()",
            resourceKey: "patient",
            expected: [-7.0d],
            expectError: false
        },
        {
            name: "test_specExample204",
            group: "specExamples",
            expression: "@2012-01-01T12:30:00.000-07:00.dateOf()",
            resourceKey: "patient",
            expected: ["@2012-01-01"],
            expectError: false
        },
        {
            name: "test_specExample205",
            group: "specExamples",
            expression: "@2012-01-01T12:30:00.000-07:00.timeOf()",
            resourceKey: "patient",
            expected: ["@T12:30:00.000"],
            expectError: false
        },
        {
            name: "test_specExample206",
            group: "specExamples",
            expression: "@2025-01-02.duration(@2025-01-07, 'week')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_specExample207",
            group: "specExamples",
            expression: "@2025-01-01.duration(@2025-09-01, 'year')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_specExample208",
            group: "specExamples",
            expression: "@2024-12-01.duration(@2025-09-01, 'year')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_specExample209",
            group: "specExamples",
            expression: "@2025-01-02.difference(@2025-01-07, 'week')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample210",
            group: "specExamples",
            expression: "@2025-01-01.difference(@2025-09-01, 'year')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_specExample211",
            group: "specExamples",
            expression: "@2024-12-01.difference(@2025-09-01, 'year')",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample212",
            group: "specExamples",
            expression: "1.10 = 1.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample213",
            group: "specExamples",
            expression: "1.2 / 1.8 = 0.67",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample214",
            group: "specExamples",
            expression: "0.0 = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample215",
            group: "specExamples",
            expression: "{} = {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample216",
            group: "specExamples",
            expression: "name = name",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample217",
            group: "specExamples",
            expression: "(1 | 2 | 3) = (3 | 2 | 1)",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample218",
            group: "specExamples",
            expression: "(1 | 2 | 3) = (1 | 2 | 3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample219",
            group: "specExamples",
            expression: "'a' = 'A'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample220",
            group: "specExamples",
            expression: "23 = 23 '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample221",
            group: "specExamples",
            expression: "1 'cm' = 10.0 'mm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample222",
            group: "specExamples",
            expression: "1 'cm' = 1 'm'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample223",
            group: "specExamples",
            expression: "1 'cm' = 1 's'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample224",
            group: "specExamples",
            expression: "23 'Cel' = 73.4 '[degF]'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample225",
            group: "specExamples",
            expression: "1 'h' = 3600 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample226",
            group: "specExamples",
            expression: "1 hour = 3600 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample227",
            group: "specExamples",
            expression: "1 year = 1 'a'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample228",
            group: "specExamples",
            expression: "1 year.toQuantity('a') = 1 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample229",
            group: "specExamples",
            expression: "1 year = 12 months",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample230",
            group: "specExamples",
            expression: "1 year = 12 'mo'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample231",
            group: "specExamples",
            expression: "1 week = 1 'wk'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample232",
            group: "specExamples",
            expression: "1 second = 1 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample233",
            group: "specExamples",
            expression: "7 days = 1 'wk'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample234",
            group: "specExamples",
            expression: "1 week = 7 'd'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample235",
            group: "specExamples",
            expression: "@2012 = @2012",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample236",
            group: "specExamples",
            expression: "@2012 = @2013",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample237",
            group: "specExamples",
            expression: "@2012-01 = @2012",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample238",
            group: "specExamples",
            expression: "@2012-01-01T10:30 = @2012-01-01T10:30",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample239",
            group: "specExamples",
            expression: "@2012-01-01T10:30 = @2012-01-01T10:31",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample240",
            group: "specExamples",
            expression: "@2012-01-01T10:30:31 = @2012-01-01T10:30",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample241",
            group: "specExamples",
            expression: "@2012-01-01T10:30:31.0 = @2012-01-01T10:30:31",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample242",
            group: "specExamples",
            expression: "@2012-01-01T10:30:31.1 = @2012-01-01T10:30:31",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample243",
            group: "specExamples",
            expression: "@2017-11-05T01:30:00.0-04:00 > @2017-11-05T01:15:00.0-05:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample244",
            group: "specExamples",
            expression: "@2017-11-05T01:30:00.0-04:00 < @2017-11-05T01:15:00.0-05:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample245",
            group: "specExamples",
            expression: "@2017-11-05T01:30:00.0-04:00 = @2017-11-05T01:15:00.0-05:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample246",
            group: "specExamples",
            expression: "@2017-11-05T01:30:00.0-04:00 = @2017-11-05T00:30:00.0-05:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample247",
            group: "specExamples",
            expression: "1.10 ~ 1.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample248",
            group: "specExamples",
            expression: "1.2 / 1.8 ~ 0.67",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample249",
            group: "specExamples",
            expression: "0.0 ~ 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample250",
            group: "specExamples",
            expression: "{} ~ {}",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample251",
            group: "specExamples",
            expression: "name ~ name",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample252",
            group: "specExamples",
            expression: "(1 | 2 | 3) ~ (3 | 2 | 1)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample253",
            group: "specExamples",
            expression: "'a' ~ 'A'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample254",
            group: "specExamples",
            expression: "23 ~ 23 '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample255",
            group: "specExamples",
            expression: "2.1 'cm' ~ 21 'mm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample256",
            group: "specExamples",
            expression: "21 'mm' ~ 2 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample257",
            group: "specExamples",
            expression: "4 'g' ~ 4000 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample258",
            group: "specExamples",
            expression: "4 'g' ~ 4040 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample259",
            group: "specExamples",
            expression: "1 '[in_i]' ~ 2.5 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample260",
            group: "specExamples",
            expression: "23 'Cel' ~ 73.4 '[degF]'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample261",
            group: "specExamples",
            expression: "1 year ~ 1 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample262",
            group: "specExamples",
            expression: "1 year ~ 12 'mo'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample263",
            group: "specExamples",
            expression: "1 year ~ 11 months",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample264",
            group: "specExamples",
            expression: "1 second ~ 1 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample265",
            group: "specExamples",
            expression: "@2012 ~ @2012",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample266",
            group: "specExamples",
            expression: "@2012 ~ @2013",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample267",
            group: "specExamples",
            expression: "@2012-01 ~ @2012",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample268",
            group: "specExamples",
            expression: "@2012-01-01T10:30 ~ @2012-01-01T10:30",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample269",
            group: "specExamples",
            expression: "@2012-01-01T10:30 ~ @2012-01-01T10:31",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample270",
            group: "specExamples",
            expression: "@2012-01-01T10:30:31 ~ @2012-01-01T10:30",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample271",
            group: "specExamples",
            expression: "@2012-01-01T10:30:31.0 ~ @2012-01-01T10:30:31",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample272",
            group: "specExamples",
            expression: "@2012-01-01T10:30:31.1 ~ @2012-01-01T10:30:31",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample273",
            group: "specExamples",
            expression: "'a b' ~ 'a\\tb'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample274",
            group: "specExamples",
            expression: "'a     b' ~ 'a b'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample275",
            group: "specExamples",
            expression: "'a b' ~ 'A B'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample276",
            group: "specExamples",
            expression: "1 year > 1 'a'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample277",
            group: "specExamples",
            expression: "10 seconds > 1 's'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample278",
            group: "specExamples",
            expression: "2 year.toQuantity('a') > 1 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample279",
            group: "specExamples",
            expression: "6 months > 1 year",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample280",
            group: "specExamples",
            expression: "10 > 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample281",
            group: "specExamples",
            expression: "10 > 5.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample282",
            group: "specExamples",
            expression: "'abc' > 'ABC'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample283",
            group: "specExamples",
            expression: "4 'm' > 4 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample284",
            group: "specExamples",
            expression: "@2018-03-01 > @2018-01-01",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample285",
            group: "specExamples",
            expression: "@2018-03 > @2018-03-01",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample286",
            group: "specExamples",
            expression: "@2018-03-01T10:30:00 > @2018-03-01T10:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample287",
            group: "specExamples",
            expression: "@2018-03-01T10 > @2018-03-01T10:30",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample288",
            group: "specExamples",
            expression: "@2018-03-01T10:30:00 > @2018-03-01T10:30:00.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample289",
            group: "specExamples",
            expression: "@T10:30:00 > @T10:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample290",
            group: "specExamples",
            expression: "@T10 > @T10:30",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample291",
            group: "specExamples",
            expression: "@T10:30:00 > @T10:30:00.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample292",
            group: "specExamples",
            expression: "10 < 5",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample293",
            group: "specExamples",
            expression: "10 < 5.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample294",
            group: "specExamples",
            expression: "'abc' < 'ABC'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample295",
            group: "specExamples",
            expression: "4 'm' < 4 'cm'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample296",
            group: "specExamples",
            expression: "@2018-03-01 < @2018-01-01",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample297",
            group: "specExamples",
            expression: "@2018-01-01 < @2018-01-01",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample298",
            group: "specExamples",
            expression: "@2018-03 < @2018-03-01",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample299",
            group: "specExamples",
            expression: "@2018-03-01T10:30:00 < @2018-03-01T10:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample300",
            group: "specExamples",
            expression: "@2018-03-01T10 < @2018-03-01T10:30",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample301",
            group: "specExamples",
            expression: "@2018-03-01T10:30:00 < @2018-03-01T10:30:00.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample302",
            group: "specExamples",
            expression: "@2018-01-01T16:00:00+11:00 < @2018-01-01T15:00:00.0+10:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample303",
            group: "specExamples",
            expression: "@2018-01-01T16:00:00+12:00 < @2018-01-01T15:00:00.0+10:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample304",
            group: "specExamples",
            expression: "@T10:30:00 < @T10:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample305",
            group: "specExamples",
            expression: "@T10 < @T10:30",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample306",
            group: "specExamples",
            expression: "@T10:30:00 < @T10:30:00.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample307",
            group: "specExamples",
            expression: "10 <= 5",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample308",
            group: "specExamples",
            expression: "10 <= 5.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample309",
            group: "specExamples",
            expression: "'abc' <= 'ABC'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample310",
            group: "specExamples",
            expression: "4 'm' <= 4 'cm'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample311",
            group: "specExamples",
            expression: "@2018-03-01 <= @2018-01-01",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample312",
            group: "specExamples",
            expression: "@2018-01-01 <= @2018-01-01",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample313",
            group: "specExamples",
            expression: "@2018-03 <= @2018-03-01",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample314",
            group: "specExamples",
            expression: "@2018-03-01T10:30:00 <= @2018-03-01T10:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample315",
            group: "specExamples",
            expression: "@2018-03-01T10 <= @2018-03-01T10:30",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample316",
            group: "specExamples",
            expression: "@2018-03-01T10:30:00 <= @2018-03-01T10:30:00.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample317",
            group: "specExamples",
            expression: "@2018-01-01T16:00:00+11:00 <= @2018-01-01T15:00:00.0+10:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample318",
            group: "specExamples",
            expression: "@2018-01-01T16:00:00+12:00 <= @2018-01-01T15:00:00.0+10:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample319",
            group: "specExamples",
            expression: "@T10:30:00 <= @T10:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample320",
            group: "specExamples",
            expression: "@T10 <= @T10:30",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample321",
            group: "specExamples",
            expression: "@T10:30:00 <= @T10:30:00.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample322",
            group: "specExamples",
            expression: "10 >= 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample323",
            group: "specExamples",
            expression: "10 >= 5.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample324",
            group: "specExamples",
            expression: "'abc' >= 'ABC'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample325",
            group: "specExamples",
            expression: "4 'm' >= 4 'cm'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample326",
            group: "specExamples",
            expression: "@2018-03-01 >= @2018-01-01",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample327",
            group: "specExamples",
            expression: "@2018-01-01 >= @2018-01-01",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample328",
            group: "specExamples",
            expression: "@2018-03 >= @2018-03-01",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample329",
            group: "specExamples",
            expression: "@2018-03-01T10:30:00 >= @2018-03-01T10:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample330",
            group: "specExamples",
            expression: "@2018-03-01T10 >= @2018-03-01T10:30",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample331",
            group: "specExamples",
            expression: "@2018-03-01T10:30:00 >= @2018-03-01T10:30:00.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample332",
            group: "specExamples",
            expression: "@T10:30:00 >= @T10:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample333",
            group: "specExamples",
            expression: "@T10 >= @T10:30",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample334",
            group: "specExamples",
            expression: "@T10:30:00 >= @T10:30:00.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample335",
            group: "specExamples",
            expression: "1 'mg'.comparable(2 'mg')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample336",
            group: "specExamples",
            expression: "1 'm'.comparable(20 'cm')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample337",
            group: "specExamples",
            expression: "2 '1'.comparable(3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample338",
            group: "specExamples",
            expression: "1.comparable(2)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample339",
            group: "specExamples",
            expression: "1 year.comparable(1 'a')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_specExample340",
            group: "specExamples",
            expression: "1 'Cel'.comparable(1 '[degF]')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_specExample341",
            group: "specExamples",
            expression: "12 'cm' * 3 'cm'",
            resourceKey: "patient",
            expected: [{"value": 36.00d, "unit": "cm2"}],
            expectError: false
        },
        {
            name: "test_specExample342",
            group: "specExamples",
            expression: "3 'cm' * 12 'cm2'",
            resourceKey: "patient",
            expected: [{"value": 36.00d, "unit": "cm3"}],
            expectError: false
        },
        {
            name: "test_specExample343",
            group: "specExamples",
            expression: "10 'm/s' * 10 's'",
            resourceKey: "patient",
            expected: [{"value": 100.00d, "unit": "m"}],
            expectError: false
        },
        {
            name: "test_specExample344",
            group: "specExamples",
            expression: "3 * 2 'cm'",
            resourceKey: "patient",
            expected: [{"value": 6.00d, "unit": "cm"}],
            expectError: false
        },
        {
            name: "test_specExample345",
            group: "specExamples",
            expression: "42 * 1 'm'",
            resourceKey: "patient",
            expected: [{"value": 42.00d, "unit": "m"}],
            expectError: false
        },
        {
            name: "test_specExample346",
            group: "specExamples",
            expression: "12 day * 45 'm'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample347",
            group: "specExamples",
            expression: "4 / 2",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample348",
            group: "specExamples",
            expression: "2 / 4",
            resourceKey: "patient",
            expected: [0.5d],
            expectError: false
        },
        {
            name: "test_specExample349",
            group: "specExamples",
            expression: "12 / 0",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample350",
            group: "specExamples",
            expression: "0 / 0",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample351",
            group: "specExamples",
            expression: "12 'cm2' / 3 'cm'",
            resourceKey: "patient",
            expected: [{"value": 4, "unit": "cm"}],
            expectError: false
        },
        {
            name: "test_specExample352",
            group: "specExamples",
            expression: "120 'm' / 60 's'",
            resourceKey: "patient",
            expected: [{"value": 2, "unit": "m/s"}],
            expectError: false
        },
        {
            name: "test_specExample353",
            group: "specExamples",
            expression: "60 / 1 's'",
            resourceKey: "patient",
            expected: [{"value": 60, "unit": "/s"}],
            expectError: false
        },
        {
            name: "test_specExample354",
            group: "specExamples",
            expression: "60 's' / 2",
            resourceKey: "patient",
            expected: [{"value": 30, "unit": "s"}],
            expectError: false
        },
        {
            name: "test_specExample355",
            group: "specExamples",
            expression: "1 + 2",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_specExample356",
            group: "specExamples",
            expression: "1 + 5L",
            resourceKey: "patient",
            expected: [6],
            expectError: false
        },
        {
            name: "test_specExample357",
            group: "specExamples",
            expression: "5L + 4.5",
            resourceKey: "patient",
            expected: [9.5d],
            expectError: false
        },
        {
            name: "test_specExample358",
            group: "specExamples",
            expression: "3 'm' + 3 'cm'",
            resourceKey: "patient",
            expected: [{"value": 303.0d, "unit": "cm"}],
            expectError: false
        },
        {
            name: "test_specExample359",
            group: "specExamples",
            expression: "3 'cm' + 3 'm'",
            resourceKey: "patient",
            expected: [{"value": 303.0d, "unit": "cm"}],
            expectError: false
        },
        {
            name: "test_specExample360",
            group: "specExamples",
            expression: "(3 'm' + 3 'cm').toQuantity('m')",
            resourceKey: "patient",
            expected: [{"value": 3.030d, "unit": "m"}],
            expectError: false
        },
        {
            name: "test_specExample361",
            group: "specExamples",
            expression: "2 + 2 'cm'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample362",
            group: "specExamples",
            expression: "2 + 2 '1'",
            resourceKey: "patient",
            expected: [{"value": 4.0d, "unit": "1"}],
            expectError: false
        },
        {
            name: "test_specExample363",
            group: "specExamples",
            expression: "2 minutes + 60 seconds",
            resourceKey: "patient",
            expected: [{"value": 180.0d, "unit": "second"}],
            expectError: false
        },
        {
            name: "test_specExample364",
            group: "specExamples",
            expression: "60 's' + 2 minutes",
            resourceKey: "patient",
            expected: [{"value": 180.0d, "unit": "second"}],
            expectError: false
        },
        {
            name: "test_specExample365",
            group: "specExamples",
            expression: "1 'wk' + 2 days",
            resourceKey: "patient",
            expected: [{"value": 9.0d, "unit": "day"}],
            expectError: false
        },
        {
            name: "test_specExample366",
            group: "specExamples",
            expression: "1 year + 12 months",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample367",
            group: "specExamples",
            expression: "1 year + 12 'mo'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample368",
            group: "specExamples",
            expression: "1 year.toQuantity('month') + 12 months",
            resourceKey: "patient",
            expected: [{"value": 24.0d, "unit": "month"}],
            expectError: false
        },
        {
            name: "test_specExample369",
            group: "specExamples",
            expression: "1 week + 14 days",
            resourceKey: "patient",
            expected: [{"value": 21.0d, "unit": "day"}],
            expectError: false
        },
        {
            name: "test_specExample370",
            group: "specExamples",
            expression: "3 'd' + 1 'wk'",
            resourceKey: "patient",
            expected: [{"value": 10.0d, "unit": "d"}],
            expectError: false
        },
        {
            name: "test_specExample371",
            group: "specExamples",
            expression: "3 'm' - 3 'cm'",
            resourceKey: "patient",
            expected: [{"value": 297.0d, "unit": "cm"}],
            expectError: false
        },
        {
            name: "test_specExample372",
            group: "specExamples",
            expression: "3 'cm' - 3 'm'",
            resourceKey: "patient",
            expected: [{"value": -297.0d, "unit": "cm"}],
            expectError: false
        },
        {
            name: "test_specExample373",
            group: "specExamples",
            expression: "5 div 2",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample374",
            group: "specExamples",
            expression: "5.5 div 0.7",
            resourceKey: "patient",
            expected: [7],
            expectError: false
        },
        {
            name: "test_specExample375",
            group: "specExamples",
            expression: "5 div 0",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample376",
            group: "specExamples",
            expression: "5L div 2",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample377",
            group: "specExamples",
            expression: "5 mod 2",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_specExample378",
            group: "specExamples",
            expression: "5.5 mod 0.7",
            resourceKey: "patient",
            expected: [0.6d],
            expectError: false
        },
        {
            name: "test_specExample379",
            group: "specExamples",
            expression: "5 mod 0",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample380",
            group: "specExamples",
            expression: "'ABC' + 'DEF'",
            resourceKey: "patient",
            expected: ["ABCDEF"],
            expectError: false
        },
        {
            name: "test_specExample381",
            group: "specExamples",
            expression: "'ABC' + { } + 'DEF'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_specExample382",
            group: "specExamples",
            expression: "'ABC' & 'DEF'",
            resourceKey: "patient",
            expected: ["ABCDEF"],
            expectError: false
        },
        {
            name: "test_specExample383",
            group: "specExamples",
            expression: "'ABC' & { } & 'DEF'",
            resourceKey: "patient",
            expected: ["ABCDEF"],
            expectError: false
        },
        {
            name: "test_specExample384",
            group: "specExamples",
            expression: "@1973-12-25 + 7 days",
            resourceKey: "patient",
            expected: ["@1974-01-01"],
            expectError: false
        },
        {
            name: "test_specExample385",
            group: "specExamples",
            expression: "@1973-12-25 + 7.9 days",
            resourceKey: "patient",
            expected: ["@1974-01-01"],
            expectError: false
        },
        {
            name: "test_specExample386",
            group: "specExamples",
            expression: "@1973-12-25 + 1 week",
            resourceKey: "patient",
            expected: ["@1974-01-01"],
            expectError: false
        },
        {
            name: "test_specExample387",
            group: "specExamples",
            expression: "@2019-03-01 + 24 months",
            resourceKey: "patient",
            expected: ["@2021-03-01"],
            expectError: false
        },
        {
            name: "test_specExample388",
            group: "specExamples",
            expression: "@2026-01-31 + 1 month",
            resourceKey: "patient",
            expected: ["@2026-02-28"],
            expectError: false
        },
        {
            name: "test_specExample389",
            group: "specExamples",
            expression: "@2026-01-01T13:00:00 + 30 minutes",
            resourceKey: "patient",
            expected: ["@2026-01-01T13:30:00"],
            expectError: false
        },
        {
            name: "test_specExample390",
            group: "specExamples",
            expression: "@1973-12-25T00:00:00.000+10:00 + 42.53 seconds",
            resourceKey: "patient",
            expected: ["@1973-12-25T00:00:42.530+10:00"],
            expectError: false
        },
        {
            name: "test_specExample391",
            group: "specExamples",
            expression: "@1973-12-25 + 1 'd'",
            resourceKey: "patient",
            expected: ["@1973-12-26"],
            expectError: false
        },
        {
            name: "test_specExample392",
            group: "specExamples",
            expression: "@T23:30:00 + 1 hour",
            resourceKey: "patient",
            expected: ["@T00:30:00"],
            expectError: false
        },
        {
            name: "test_specExample393",
            group: "specExamples",
            expression: "@T01:00:00 + 48 hour",
            resourceKey: "patient",
            expected: ["@T01:00:00"],
            expectError: false
        },
        {
            name: "test_specExample394",
            group: "specExamples",
            expression: "@2014 + 24 months",
            resourceKey: "patient",
            expected: ["@2016"],
            expectError: false
        },
        {
            name: "test_specExample395",
            group: "specExamples",
            expression: "@2014 + 23 months",
            resourceKey: "patient",
            expected: ["@2015"],
            expectError: false
        },
        {
            name: "test_specExample396",
            group: "specExamples",
            expression: "@2016 + 365 days",
            resourceKey: "patient",
            expected: ["@2017"],
            expectError: false
        },
        {
            name: "test_specExample397",
            group: "specExamples",
            expression: "@2014 + 11 months",
            resourceKey: "patient",
            expected: ["@2014"],
            expectError: false
        },
        {
            name: "test_specExample398",
            group: "specExamples",
            expression: "@2026-02 + 5 weeks",
            resourceKey: "patient",
            expected: ["@2026-03"],
            expectError: false
        },
        {
            name: "test_specExample399",
            group: "specExamples",
            expression: "@2026-02 + 4 weeks",
            resourceKey: "patient",
            expected: ["@2026-02"],
            expectError: false
        },
        {
            name: "test_specExample400",
            group: "specExamples",
            expression: "@T00:30:00 - 1 hour",
            resourceKey: "patient",
            expected: ["@T23:30:00"],
            expectError: false
        },
        {
            name: "test_specExample401",
            group: "specExamples",
            expression: "@T01:00:00 - 2 hours",
            resourceKey: "patient",
            expected: ["@T23:00:00"],
            expectError: false
        },
        {
            name: "test_specExample402",
            group: "specExamples",
            expression: "@2014 - 24 months",
            resourceKey: "patient",
            expected: ["@2012"],
            expectError: false
        },
        {
            name: "test_specExample403",
            group: "specExamples",
            expression: "@2019-03-01 - 24 months",
            resourceKey: "patient",
            expected: ["@2017-03-01"],
            expectError: false
        },
        {
            name: "test_specExample404",
            group: "specExamples",
            expression: "@2014 - 1 month",
            resourceKey: "patient",
            expected: ["@2014"],
            expectError: false
        },
        {
            name: "test_specExample405",
            group: "specExamples",
            expression: "@2026-02 - 1 day",
            resourceKey: "patient",
            expected: ["@2026-02"],
            expectError: false
        },
        {
            name: "test_specExample406",
            group: "specExamples",
            expression: "(-7).combine(3)",
            resourceKey: "patient",
            expected: [-7, 3],
            expectError: false
        },
        {
            name: "test_specExample407",
            group: "specExamples",
            expression: "( 1.0 | 2.0 | 3.0 | 4.0 | 5.0 ).sum()",
            resourceKey: "patient",
            expected: [15.0d],
            expectError: false
        },
        {
            name: "test_specExample408",
            group: "specExamples",
            expression: "( 1.0 'mg' | 2.0 'mg' | 3.0 'mg' | 4.0 'mg' | 5.0 'mg' ).sum()",
            resourceKey: "patient",
            expected: [{"value": 15.0d, "unit": "mg"}],
            expectError: false
        },
        {
            name: "test_specExample409",
            group: "specExamples",
            expression: "( 2 | 4 | 8 | 6 ).min()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample410",
            group: "specExamples",
            expression: "( 2L | 4L | 8L | 6L ).min()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_specExample411",
            group: "specExamples",
            expression: "( @2012-12-31 | @2013-01-01 | @2012-01-01 ).min()",
            resourceKey: "patient",
            expected: ["@2012-01-01"],
            expectError: false
        },
        {
            name: "test_specExample412",
            group: "specExamples",
            expression: "( 2 | 4 | 8 | 6 ).max()",
            resourceKey: "patient",
            expected: [8],
            expectError: false
        },
        {
            name: "test_specExample413",
            group: "specExamples",
            expression: "( 2L | 4L | 8L | 6L ).max()",
            resourceKey: "patient",
            expected: [8],
            expectError: false
        },
        {
            name: "test_specExample414",
            group: "specExamples",
            expression: "( @2012-12-31 | @2013-01-01 | @2012-01-01 ).max()",
            resourceKey: "patient",
            expected: ["@2013-01-01"],
            expectError: false
        },
        {
            name: "test_specExample415",
            group: "specExamples",
            expression: "( 5.5 | 4.7 | 4.8 ).avg()",
            resourceKey: "patient",
            expected: [5],
            expectError: false
        },
        {
            name: "test_specExample416",
            group: "specExamples",
            expression: "( 5.5 'cm' | 4.7 'cm' | 4.8 'cm' ).avg()",
            resourceKey: "patient",
            expected: [{"value": 5, "unit": "cm"}],
            expectError: false
        }
    ];
}
