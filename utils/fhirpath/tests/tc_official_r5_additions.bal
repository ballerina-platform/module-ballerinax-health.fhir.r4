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

// Cases from the official FHIRPath test suite (fhir-test-cases r5/fhirpath/tests-fhir-r5.xml) that the other
// tc_*.bal files do not include. Expected values were verified against the suite's expected outputs with the
// conformance tooling in scripts/conformance and are written in this library's JSON output form.
function getOfficialR5AdditionsTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testExtractBirthDate",
            group: "testMiscellaneousAccessorTests",
            expression: "birthDate",
            resourceKey: "patient",
            expected: ["1974-12-25"],
            expectError: false
        },
        {
            name: "test_testPatientHasBirthDate",
            group: "testMiscellaneousAccessorTests",
            expression: "birthDate",
            resourceKey: "patient",
            expected: ["1974-12-25"],
            expectError: false
        },
        {
            name: "test_testLiteralYearToDateTime",
            group: "testTypes",
            expression: "'2015'.toDateTime() = @2015",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralMonthToDateTime",
            group: "testTypes",
            expression: "'2015-02'.toDateTime() = @2015-02",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralDayToDateTime",
            group: "testTypes",
            expression: "'2015-02-04'.toDateTime() = @2015-02-04",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralSecondToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14:34:28'.toDateTime() = @2015-02-04T14:34:28",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralMillisecondToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14:34:28.123'.toDateTime() = @2015-02-04T14:34:28.123",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralUTCToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14:34:28Z'.toDateTime() = @2015-02-04T14:34:28Z",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLiteralTZToDateTime",
            group: "testTypes",
            expression: "'2015-02-04T14:34:28+10:00'.toDateTime() = @2015-02-04T14:34:28+10:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringQuantityMonthToQuantityEquivalent",
            group: "testTypes",
            expression: "'1 month'.toQuantity() ~ 1 month",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStringQuantityYearToQuantityEquivalent",
            group: "testTypes",
            expression: "'1 year'.toQuantity() ~ 1 year",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct7",
            group: "testDistinct",
            expression: "Patient.name.given.isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct8",
            group: "testDistinct",
            expression: "Patient.name.given.distinct().isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct9",
            group: "testDistinct",
            expression: "Patient.gender.combine('male').isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct10",
            group: "testDistinct",
            expression: "Patient.gender.combine('female').isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct11",
            group: "testDistinct",
            expression: "CodeSystem.url.combine('http://hl7.org/fhir/CodeSystem/example').isDistinct()",
            resourceKey: "codesystem",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct12",
            group: "testDistinct",
            expression: "'1'.combine(2).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct13",
            group: "testDistinct",
            expression: "1.0.combine(1.00).isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct14",
            group: "testDistinct",
            expression: "1.combine(2).combine(1).isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct15",
            group: "testDistinct",
            expression: "true.combine(false).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct16",
            group: "testDistinct",
            expression: "true.combine(false).combine(true).isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct17",
            group: "testDistinct",
            expression: "@T10:00:00.combine(@T11:00:00).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct18",
            group: "testDistinct",
            expression: "@T10:00:00.combine(@T10:00:00).isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct19",
            group: "testDistinct",
            expression: "1.combine('a').combine(true).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct20",
            group: "testDistinct",
            expression: "1.combine('a').combine(true).combine('a').isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct21",
            group: "testDistinct",
            expression: "1.combine(1.0).isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct22",
            group: "testDistinct",
            expression: "1.5.combine(2.5).combine(10.0).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct23",
            group: "testDistinct",
            expression: "1.5.combine(2.0).combine(1.50).isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct24",
            group: "testDistinct",
            expression: "'1.0'.combine('1.00').combine(5.0).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct25",
            group: "testDistinct",
            expression: "10.combine(1.5).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct26",
            group: "testDistinct",
            expression: "@2020-01-01.combine(@2020-01-02).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct27",
            group: "testDistinct",
            expression: "@2020-01-01.combine(@2020-01-01).isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct28",
            group: "testDistinct",
            expression: "@2020-01-01T10:00:00+10:00.combine(@2020-01-01T00:00:00Z).isDistinct()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testDistinct29",
            group: "testDistinct",
            expression: "@2020.combine(@2020-01-01).isDistinct()",
            resourceKey: "patient",
            expected: [],
            expectError: false,
            // Conflicts with the STU3 distinct()/isDistinct() text: an empty equality result means the items are distinct,
            disabled: true
        },
        {
            name: "test_testDistinct30",
            group: "testDistinct",
            expression: "'a'.combine('b').combine('a').distinct()",
            resourceKey: "patient",
            expected: ["b", "a"],
            expectError: false
        },
        {
            name: "test_testDistinct31",
            group: "testDistinct",
            expression: "Patient.gender.combine('male').distinct()",
            resourceKey: "patient",
            expected: ["male"],
            expectError: false
        },
        {
            name: "test_testDistinct32",
            group: "testDistinct",
            expression: "1.combine(2).combine(1).combine(3).distinct()",
            resourceKey: "patient",
            expected: [2, 1, 3],
            expectError: false
        },
        {
            name: "test_testDistinct33",
            group: "testDistinct",
            expression: "1.combine(2).combine(1.0).distinct()",
            resourceKey: "patient",
            expected: [2, 1.0d],
            expectError: false
        },
        {
            name: "test_testDistinct34",
            group: "testDistinct",
            expression: "true.combine(false).combine(true).distinct()",
            resourceKey: "patient",
            expected: [false, true],
            expectError: false
        },
        {
            name: "test_testDistinct35",
            group: "testDistinct",
            expression: "@2020-01-01.combine(@2020-01-02).combine(@2020-01-01).distinct()",
            resourceKey: "patient",
            expected: ["@2020-01-02", "@2020-01-01"],
            expectError: false
        },
        {
            name: "test_testDistinct36",
            group: "testDistinct",
            expression: "@2020.combine(@2020-01-01).distinct()",
            resourceKey: "patient",
            expected: [],
            expectError: false,
            // Conflicts with the STU3 distinct()/isDistinct() text: an empty equality result means the items are distinct,
            disabled: true
        },
        {
            name: "test_testSplit5",
            group: "testSplit",
            expression: "'fr-BE'.split('-').first() = 'fr'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSplit6",
            group: "testSplit",
            expression: "'fr-BE'.split('-').last() = 'BE'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSplit7",
            group: "testSplit",
            expression: "'a-b-c'.split('-').skip(1).first() = 'b'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSplit8",
            group: "testSplit",
            expression: "'a-b-c'.split('-').take(2).join('-') = 'a-b'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testJoinEmpty",
            group: "testJoin",
            expression: "name.prefix.join(',')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testEquality29",
            group: "testEquality",
            expression: "name.first() = 'Peter'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality30",
            group: "testEquality",
            expression: "'Peter' = name.first()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality31",
            group: "testEquality",
            expression: "100 = 1.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality32",
            group: "testEquality",
            expression: "10 = 1.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality33",
            group: "testEquality",
            expression: "10 = 10.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality34",
            group: "testEquality",
            expression: "1.50 = 1.5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquality35",
            group: "testEquality",
            expression: "100.toDecimal() = 1.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquality36",
            group: "testEquality",
            expression: "1 year = 1 'a'",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNEquality25",
            group: "testNEquality",
            expression: "name.first() != 'Peter'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNEquality26",
            group: "testNEquality",
            expression: "'Peter' != name.first()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testHasValue1",
            group: "testHasValue",
            expression: "name.first().given.first().hasValue()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testHasValue2",
            group: "testHasValue",
            expression: "name.first().hasValue()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testHasValue3",
            group: "testHasValue",
            expression: "name.first().given.first().hasValue() and name.first() != 'Peter'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent25",
            group: "testEquivalent",
            expression: "1 year ~ 1 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent26",
            group: "testEquivalent",
            expression: "2 years ~ 2 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent27",
            group: "testEquivalent",
            expression: "1 month ~ 1 'mo'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEquivalent28",
            group: "testEquivalent",
            expression: "1 year ~ 1 day",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testEquivalent29",
            group: "testEquivalent",
            expression: "1 'x' ~ 1 year",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            // Conflicts with the STU3 Quantity Equivalence text: quantities that cannot be compared give an empty result,
            disabled: true
        },
        {
            name: "test_testEquivalent30",
            group: "testEquivalent",
            expression: "1 year ~ 1 'kg'",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            // Conflicts with the STU3 Quantity Equivalence text: quantities that cannot be compared give an empty result,
            disabled: true
        },
        {
            name: "test_testNotEquivalent23",
            group: "testNotEquivalent",
            expression: "1 year !~ 1 day",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNotEquivalent24",
            group: "testNotEquivalent",
            expression: "1 month !~ 1 'mo'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testQuantityNoUnitEqual",
            group: "testQuantityUnitComparison",
            expression: "Parameters.parameter[0].value = Parameters.parameter[1].value",
            resourceKey: "parameters_quantities",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testQuantityNoUnitEquivalent",
            group: "testQuantityUnitComparison",
            expression: "Parameters.parameter[0].value ~ Parameters.parameter[1].value",
            resourceKey: "parameters_quantities",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testQuantityUnitTextEqual",
            group: "testQuantityUnitComparison",
            expression: "Parameters.parameter[2].value = Parameters.parameter[3].value",
            resourceKey: "parameters_quantities",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testQuantityUnitTextEquivalent",
            group: "testQuantityUnitComparison",
            expression: "Parameters.parameter[2].value ~ Parameters.parameter[3].value",
            resourceKey: "parameters_quantities",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testQuantityUnitVsNoUnitEqual",
            group: "testQuantityUnitComparison",
            expression: "Parameters.parameter[2].value = Parameters.parameter[0].value",
            resourceKey: "parameters_quantities",
            expected: [],
            expectError: false
        },
        {
            name: "test_testQuantityNoUnitVsUnitEqual",
            group: "testQuantityUnitComparison",
            expression: "Parameters.parameter[0].value = Parameters.parameter[2].value",
            resourceKey: "parameters_quantities",
            expected: [],
            expectError: false
        },
        {
            name: "test_testQuantityUnitVsNoUnitEquivalent",
            group: "testQuantityUnitComparison",
            expression: "Parameters.parameter[2].value ~ Parameters.parameter[0].value",
            resourceKey: "parameters_quantities",
            expected: [false],
            expectError: false,
            // Conflicts with the STU3 Quantity Equivalence text: quantities that cannot be compared give an empty result,
            disabled: true
        },
        {
            name: "test_testQuantityNoUnitVsUnitEquivalent",
            group: "testQuantityUnitComparison",
            expression: "Parameters.parameter[0].value ~ Parameters.parameter[2].value",
            resourceKey: "parameters_quantities",
            expected: [false],
            expectError: false,
            // Conflicts with the STU3 Quantity Equivalence text: quantities that cannot be compared give an empty result,
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimalCarry1",
            group: "LowBoundary",
            expression: "(-9.96).lowBoundary(1)",
            resourceKey: "empty",
            expected: [-10],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimalCarry2",
            group: "LowBoundary",
            expression: "(-99.96).lowBoundary(1)",
            resourceKey: "empty",
            expected: [-100],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimalCarry3",
            group: "LowBoundary",
            expression: "(-9).lowBoundary(0)",
            resourceKey: "empty",
            expected: [-10],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimalBorrow1",
            group: "LowBoundary",
            expression: "10.lowBoundary(0)",
            resourceKey: "empty",
            expected: [9],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimalBorrow2",
            group: "LowBoundary",
            expression: "100.lowBoundary(2)",
            resourceKey: "empty",
            expected: [99.5d],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimalExponent1",
            group: "LowBoundary",
            expression: "Parameters.parameter[0].value.lowBoundary(0)",
            resourceKey: "parameters_decimals",
            expected: [945],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimalExponent2",
            group: "LowBoundary",
            expression: "Parameters.parameter[1].value.lowBoundary()",
            resourceKey: "parameters_decimals",
            expected: [0.00145d],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimalExponent3",
            group: "LowBoundary",
            expression: "Parameters.parameter[2].value.lowBoundary(0)",
            resourceKey: "parameters_decimals",
            expected: [-955],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimalExponent4",
            group: "LowBoundary",
            expression: "Parameters.parameter[3].value.lowBoundary(1)",
            resourceKey: "parameters_decimals",
            expected: [145],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimalCarry1",
            group: "HighBoundary",
            expression: "9.95.highBoundary(1)",
            resourceKey: "empty",
            expected: [10],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimalCarry2",
            group: "HighBoundary",
            expression: "0.996.highBoundary(1)",
            resourceKey: "empty",
            expected: [1],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimalCarry3",
            group: "HighBoundary",
            expression: "99.96.highBoundary(1)",
            resourceKey: "empty",
            expected: [100],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimalCarry4",
            group: "HighBoundary",
            expression: "9.highBoundary(0)",
            resourceKey: "empty",
            expected: [10],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimalExponent1",
            group: "HighBoundary",
            expression: "Parameters.parameter[0].value.highBoundary(0)",
            resourceKey: "parameters_decimals",
            expected: [955],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimalExponent2",
            group: "HighBoundary",
            expression: "Parameters.parameter[0].value.highBoundary()",
            resourceKey: "parameters_decimals",
            expected: [955],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimalExponent3",
            group: "HighBoundary",
            expression: "Parameters.parameter[1].value.highBoundary()",
            resourceKey: "parameters_decimals",
            expected: [0.00155d],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimalExponent4",
            group: "HighBoundary",
            expression: "Parameters.parameter[2].value.highBoundary(0)",
            resourceKey: "parameters_decimals",
            expected: [-945],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimalExponent5",
            group: "HighBoundary",
            expression: "Parameters.parameter[3].value.highBoundary(1)",
            resourceKey: "parameters_decimals",
            expected: [155],
            expectError: false
        },
        {
            name: "test_from-zulip-1",
            group: "from-Zulip",
            expression: "(true and 'foo').empty()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_from-zulip-2",
            group: "from-Zulip",
            expression: "(true | 'foo').allTrue()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testPolymorphicsB",
            group: "polymorphics",
            expression: "Observation.valueQuantity.exists()",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true
        },
        {
            name: "test_testNoValueExists",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().exists()",
            resourceKey: "patient_name_ext",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNoValueExistsElement",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().exists()",
            resourceKey: "patient_name_ext",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testNoValueHasValue",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().hasValue()",
            resourceKey: "patient_name_ext",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testNoValueLength",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().length()",
            resourceKey: "patient_name_ext",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNoValueLengthElement",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().length()",
            resourceKey: "patient_name_ext",
            expected: [],
            expectError: false
        },
        {
            name: "test_testValueLength",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.last().length()",
            resourceKey: "patient_name_ext",
            expected: [5],
            expectError: false
        },
        {
            name: "test_testNoValueToChars",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().toChars()",
            resourceKey: "patient_name_ext",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNoValueSubstring",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().substring(0, 1)",
            resourceKey: "patient_name_ext",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNoValueUpper",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().upper()",
            resourceKey: "patient_name_ext",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNoValueComparison",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first() < 'x'",
            resourceKey: "patient_name_ext",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNoValueInvariant",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().exists() and Patient.name.given.first().length() = 1",
            resourceKey: "patient_name_ext",
            expected: [],
            expectError: false
        },
        {
            name: "test_testNoValueInvariantElement",
            group: "primitivesWithoutValue",
            expression: "Patient.name.given.first().exists() and Patient.name.given.first().length() = 1",
            resourceKey: "patient_name_ext",
            expected: [],
            expectError: false
        }
    ];
}
