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

// FHIRPath STU3 instance selectors (object creation) and Long arithmetic
function getStu3SelectorsTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_selectorCoding",
            group: "testInstanceSelector",
            expression: "Coding { system: 'http://example.org/demo', code: 'c1' }",
            resourceKey: "patient",
            expected: [{"system": "http://example.org/demo", "code": "c1"}],
            expectError: false
        },
        {
            name: "test_selectorQualified",
            group: "testInstanceSelector",
            expression: "FHIR.Identifier { system: 'http://example.org/demo', value: 'N0001231' }",
            resourceKey: "patient",
            expected: [{"system": "http://example.org/demo", "value": "N0001231"}],
            expectError: false
        },
        {
            name: "test_selectorNested",
            group: "testInstanceSelector",
            expression: "Identifier { type: CodeableConcept { coding: Coding { system: 'http://terminology.hl7.org/CodeSystem/v2-0203', code: 'MR' } }, system: 'urn:oid:1.2.36.146.595.217.0.1', value: '12345', period: Period { start: @2001-05-06 } }",
            resourceKey: "patient",
            expected: [{"type": {"coding": [{"system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "MR"}]}, "system": "urn:oid:1.2.36.146.595.217.0.1", "value": "12345", "period": {"start": "2001-05-06"}}],
            expectError: false
        },
        {
            name: "test_selectorEmptyObject",
            group: "testInstanceSelector",
            expression: "Period {:}",
            resourceKey: "patient",
            expected: [{}],
            expectError: false
        },
        {
            name: "test_selectorEmptyObjectExists",
            group: "testInstanceSelector",
            expression: "Period {:}.exists()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_selectorType",
            group: "testInstanceSelector",
            expression: "Coding { code: 'c1' }.type().name",
            resourceKey: "patient",
            expected: ["Coding"],
            expectError: false
        },
        {
            name: "test_selectorIsType",
            group: "testInstanceSelector",
            expression: "Coding { code: 'c1' } is Coding",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_selectorNavigation",
            group: "testInstanceSelector",
            expression: "Coding { system: 'http://loinc.org', code: '1234-5' }.code",
            resourceKey: "patient",
            expected: ["1234-5"],
            expectError: false
        },
        {
            name: "test_selectorFromContext",
            group: "testInstanceSelector",
            expression: "Patient.select(Coding { system: 'http://hl7.org/fhir/administrative-gender', code: gender })",
            resourceKey: "patient",
            expected: [{"system": "http://hl7.org/fhir/administrative-gender", "code": "male"}],
            expectError: false
        },
        {
            name: "test_selectorPerItem",
            group: "testInstanceSelector",
            expression: "Patient.name.select(HumanName { family: family }).count()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_selectorEmptyElementOmitted",
            group: "testInstanceSelector",
            expression: "Patient.name[1].select(HumanName { family: family, given: given })",
            resourceKey: "patient",
            expected: [{"given": ["Jim"]}],
            expectError: false
        },
        {
            name: "test_selectorRepeatingUnion",
            group: "testInstanceSelector",
            expression: "CodeableConcept { coding: Coding { code: 'MR' } | Coding { code: 'mr' } }.coding.count()",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_selectorRepeatingSingle",
            group: "testInstanceSelector",
            expression: "CodeableConcept { coding: Coding { code: 'MR' } }",
            resourceKey: "patient",
            expected: [{"coding": [{"code": "MR"}]}],
            expectError: false
        },
        {
            name: "test_selectorChoiceElement",
            group: "testInstanceSelector",
            expression: "Extension { url: 'http://example.org/ext', value: 'abc' }",
            resourceKey: "patient",
            expected: [{"url": "http://example.org/ext", "valueString": "abc"}],
            expectError: false
        },
        {
            name: "test_selectorChoiceNavigation",
            group: "testInstanceSelector",
            expression: "Extension { url: 'http://example.org/ext', value: 42 }.value",
            resourceKey: "patient",
            expected: [42],
            expectError: false
        },
        {
            name: "test_selectorQuantity",
            group: "testInstanceSelector",
            expression: "Quantity { value: 1.5, unit: 'mg' } = 1.5 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_selectorResource",
            group: "testInstanceSelector",
            expression: "Patient { gender: 'female' }.resourceType",
            resourceKey: "patient",
            expected: ["Patient"],
            expectError: false
        },
        {
            name: "test_selectorPrimitive",
            group: "testInstanceSelector",
            expression: "code { value: 'final' }.type().name",
            resourceKey: "patient",
            expected: ["code"],
            expectError: false
        },
        {
            name: "test_selectorPrimitiveValue",
            group: "testInstanceSelector",
            expression: "code { value: 'final' }",
            resourceKey: "patient",
            expected: ["final"],
            expectError: false
        },
        {
            name: "test_selectorKeywordElement",
            group: "testInstanceSelector",
            expression: "Narrative { status: 'generated', div: '<div>x</div>' }.status",
            resourceKey: "patient",
            expected: ["generated"],
            expectError: false
        },
        {
            name: "test_selectorUnknownType",
            group: "testInstanceSelector",
            expression: "Foo { a: 1 }",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_selectorUnknownElement",
            group: "testInstanceSelector",
            expression: "Coding { colour: 'red' }",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_selectorNotRepeating",
            group: "testInstanceSelector",
            expression: "Coding { code: 'a' | 'b' }",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_longPlusLong",
            group: "testLongArithmetic",
            expression: "(1L + 2L).type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_longPlusInteger",
            group: "testLongArithmetic",
            expression: "(1 + 5L).type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_longPlusIntegerValue",
            group: "testLongArithmetic",
            expression: "1 + 5L",
            resourceKey: "patient",
            expected: [6],
            expectError: false
        },
        {
            name: "test_longPlusDecimal",
            group: "testLongArithmetic",
            expression: "(5L + 4.5).type().name",
            resourceKey: "patient",
            expected: ["Decimal"],
            expectError: false
        },
        {
            name: "test_longPlusDecimalValue",
            group: "testLongArithmetic",
            expression: "5L + 4.5 = 9.5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_longTimes",
            group: "testLongArithmetic",
            expression: "(3L * 4).type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_longDiv",
            group: "testLongArithmetic",
            expression: "(5L div 2).type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_longDivValue",
            group: "testLongArithmetic",
            expression: "5L div 2",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_longDivOverflow",
            group: "testLongArithmetic",
            expression: "(-9223372036854775807L - 1L) div -1L",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_longDivNegativeTruncates",
            group: "testLongArithmetic",
            expression: "-5L div 2",
            resourceKey: "patient",
            expected: [-2],
            expectError: false
        },
        {
            name: "test_longMod",
            group: "testLongArithmetic",
            expression: "(5L mod 2).type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_longDivide",
            group: "testLongArithmetic",
            expression: "(5L / 2).type().name",
            resourceKey: "patient",
            expected: ["Decimal"],
            expectError: false
        },
        {
            name: "test_longBeyondInteger",
            group: "testLongArithmetic",
            expression: "(2147483647L + 1).type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_longBeyondIntegerValue",
            group: "testLongArithmetic",
            expression: "2147483647L + 1",
            resourceKey: "patient",
            expected: [2147483648],
            expectError: false
        },
        {
            name: "test_integerOverflow",
            group: "testLongArithmetic",
            expression: "2147483647 + 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_integerUnderflow",
            group: "testLongArithmetic",
            expression: "-2147483647 - 2",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_longOverflow",
            group: "testLongArithmetic",
            expression: "9223372036854775807L + 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_longEqualsInteger",
            group: "testLongArithmetic",
            expression: "5L = 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_longCompare",
            group: "testLongArithmetic",
            expression: "5L > 4",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_longNegate",
            group: "testLongArithmetic",
            expression: "(-5L).type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_decimalModulo",
            group: "testLongArithmetic",
            expression: "5.5 mod 0.7 = 0.6",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_decimalDiv",
            group: "testLongArithmetic",
            expression: "5.5 div 0.7",
            resourceKey: "patient",
            expected: [7],
            expectError: false
        }
    ];
}
