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

// FHIRPath STU3 evaluation semantics: singleton evaluation errors, iif() scoping, equality and equivalence,
// truncating arithmetic, substring ranges, encoding/escaping and conversion rules
function getStu3SemanticsTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_stringFunctionMultipleItems",
            group: "testSingletonErrors",
            expression: "('a' | 'b').length()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_stringFunctionNonString",
            group: "testSingletonErrors",
            expression: "5.length()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_stringFunctionComplex",
            group: "testSingletonErrors",
            expression: "Patient.name.first().upper()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_stringFunctionFhirCode",
            group: "testSingletonErrors",
            expression: "Patient.gender.length()",
            resourceKey: "patient",
            expected: [4],
            expectError: false
        },
        {
            name: "test_stringFunctionFhirDate",
            group: "testSingletonErrors",
            expression: "Patient.birthDate.substring(0, 4)",
            resourceKey: "patient",
            expected: ["1974"],
            expectError: false
        },
        {
            name: "test_stringFunctionEmpty",
            group: "testSingletonErrors",
            expression: "{}.upper()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_mathFunctionMultipleItems",
            group: "testSingletonErrors",
            expression: "(1 | 2).abs()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_mathFunctionNonNumeric",
            group: "testSingletonErrors",
            expression: "'a'.abs()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_additionMultipleItems",
            group: "testSingletonErrors",
            expression: "(1 | 2) + 1",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_additionStringNumber",
            group: "testSingletonErrors",
            expression: "1 + 'a'",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_multiplicationStrings",
            group: "testSingletonErrors",
            expression: "'a' * 'b'",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_comparisonMultipleItems",
            group: "testSingletonErrors",
            expression: "(1 | 2) < 3",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_concatenateMultipleItems",
            group: "testSingletonErrors",
            expression: "('a' | 'b') & 'c'",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_concatenateEmpty",
            group: "testSingletonErrors",
            expression: "{} & 'c'",
            resourceKey: "patient",
            expected: ["c"],
            expectError: false
        },
        {
            name: "test_containsMultipleRight",
            group: "testSingletonErrors",
            expression: "('a' | 'b') contains ('a' | 'b')",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_notSingleNonBoolean",
            group: "testSingletonErrors",
            expression: "'x'.not()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_iifThisCriterion",
            group: "testIifScoping",
            expression: "('context').iif($this = 'context', 'yes', 'no')",
            resourceKey: "patient",
            expected: ["yes"],
            expectError: false
        },
        {
            name: "test_iifThisResult",
            group: "testIifScoping",
            expression: "Patient.name.first().iif(family.exists(), family, 'none')",
            resourceKey: "patient",
            expected: ["Chalmers"],
            expectError: false
        },
        {
            name: "test_iifInsideSelect",
            group: "testIifScoping",
            expression: "Patient.name.select(iif(family.exists(), family, 'none'))",
            resourceKey: "patient",
            expected: ["Chalmers", "none", "Windsor"],
            expectError: false
        },
        {
            name: "test_iifEmptyCriterion",
            group: "testIifScoping",
            expression: "iif({}, 'yes', 'no')",
            resourceKey: "patient",
            expected: ["no"],
            expectError: false
        },
        {
            name: "test_iifNoOtherwise",
            group: "testIifScoping",
            expression: "iif(false, 'yes')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_iifNonBooleanCriterion",
            group: "testIifScoping",
            expression: "iif('x', 'yes', 'no')",
            resourceKey: "patient",
            expected: ["yes"],
            expectError: false
        },
        {
            name: "test_iifZeroCriterion",
            group: "testIifScoping",
            expression: "iif(0, 'yes', 'no')",
            resourceKey: "patient",
            expected: ["yes"],
            expectError: false
        },
        {
            name: "test_iifMultipleCriterion",
            group: "testIifScoping",
            expression: "iif(1 | 2, 'yes', 'no')",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_complexEqual",
            group: "testEqualitySemantics",
            expression: "Patient.name[0] = Patient.name[0]",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_complexNotEqual",
            group: "testEqualitySemantics",
            expression: "Patient.name[0] = Patient.name[2]",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_collectionEqualOrdered",
            group: "testEqualitySemantics",
            expression: "(1 | 2 | 3) = (1 | 2 | 3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_collectionEqualUnordered",
            group: "testEqualitySemantics",
            expression: "(1 | 2 | 3) = (3 | 2 | 1)",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_decimalEquivalentTrailingZero",
            group: "testEqualitySemantics",
            expression: "1.10 ~ 1.1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_decimalEquivalentZero",
            group: "testEqualitySemantics",
            expression: "0.0 ~ 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_decimalEquivalentRounded",
            group: "testEqualitySemantics",
            expression: "1.2 / 1.8 ~ 0.67",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_decimalNotEquivalent",
            group: "testEqualitySemantics",
            expression: "1.1 ~ 1.2",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_collectionEquivalentUnordered",
            group: "testEqualitySemantics",
            expression: "(1 | 2 | 3) ~ (3 | 2 | 1)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_stringEquivalentCase",
            group: "testEqualitySemantics",
            expression: "'a' ~ 'A'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_stringEquivalentWhitespace",
            group: "testEqualitySemantics",
            expression: "'a b\\tc' ~ 'A B C'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_stringEquivalentWhitespaceNotCollapsed",
            group: "testEqualitySemantics",
            expression: "'a     b' ~ 'a b'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_complexEquivalent",
            group: "testEqualitySemantics",
            expression: "Patient.name ~ Patient.name",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_emptyEquivalent",
            group: "testEqualitySemantics",
            expression: "{} ~ {}",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_divNegative",
            group: "testTruncatingArithmetic",
            expression: "-5.5 div 2",
            resourceKey: "patient",
            expected: [-2],
            expectError: false
        },
        {
            name: "test_divIntegers",
            group: "testTruncatingArithmetic",
            expression: "-7 div 2",
            resourceKey: "patient",
            expected: [-3],
            expectError: false
        },
        {
            name: "test_divDecimal",
            group: "testTruncatingArithmetic",
            expression: "7.9 div 2",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_truncateNegative",
            group: "testTruncatingArithmetic",
            expression: "(-5.9).truncate()",
            resourceKey: "patient",
            expected: [-5],
            expectError: false
        },
        {
            name: "test_truncatePositive",
            group: "testTruncatingArithmetic",
            expression: "5.9.truncate()",
            resourceKey: "patient",
            expected: [5],
            expectError: false
        },
        {
            name: "test_quantityNegation",
            group: "testTruncatingArithmetic",
            expression: "(-(5.5 'mg')) = -5.5 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_quantityAbs",
            group: "testTruncatingArithmetic",
            expression: "(-5.5 'mg').abs() = 5.5 'mg'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_substringStart",
            group: "testStringRanges",
            expression: "'abcdefg'.substring(3)",
            resourceKey: "patient",
            expected: ["defg"],
            expectError: false
        },
        {
            name: "test_substringLength",
            group: "testStringRanges",
            expression: "'abcdefg'.substring(1, 2)",
            resourceKey: "patient",
            expected: ["bc"],
            expectError: false
        },
        {
            name: "test_substringPastEnd",
            group: "testStringRanges",
            expression: "'abcdefg'.substring(6, 2)",
            resourceKey: "patient",
            expected: ["g"],
            expectError: false
        },
        {
            name: "test_substringStartOutside",
            group: "testStringRanges",
            expression: "'abcdefg'.substring(7, 1)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_substringNegativeStart",
            group: "testStringRanges",
            expression: "'abcdefg'.substring(-1, 1)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_substringZeroLength",
            group: "testStringRanges",
            expression: "'abcdefg'.substring(3, 0)",
            resourceKey: "patient",
            expected: [""],
            expectError: false
        },
        {
            name: "test_substringNegativeLength",
            group: "testStringRanges",
            expression: "'abcdefg'.substring(3, -1)",
            resourceKey: "patient",
            expected: [""],
            expectError: false
        },
        {
            name: "test_substringEmptyLength",
            group: "testStringRanges",
            expression: "'abcdefg'.substring(3, {})",
            resourceKey: "patient",
            expected: ["defg"],
            expectError: false
        },
        {
            name: "test_substringEmptyString",
            group: "testStringRanges",
            expression: "''.substring(0)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_encodeBase64",
            group: "testEncodingEscaping",
            expression: "'test'.encode('base64')",
            resourceKey: "patient",
            expected: ["dGVzdA=="],
            expectError: false
        },
        {
            name: "test_encodeUrlBase64Padded",
            group: "testEncodingEscaping",
            expression: "'test'.encode('urlbase64')",
            resourceKey: "patient",
            expected: ["dGVzdA=="],
            expectError: false
        },
        {
            name: "test_decodeUrlBase64Unpadded",
            group: "testEncodingEscaping",
            expression: "'dGVzdA'.decode('urlbase64')",
            resourceKey: "patient",
            expected: ["test"],
            expectError: false
        },
        {
            name: "test_encodeAscii",
            group: "testEncodingEscaping",
            expression: "'caf\\u00e9'.encode('ascii')",
            resourceKey: "patient",
            expected: ["caf?"],
            expectError: false
        },
        {
            name: "test_encodeUnknownFormat",
            group: "testEncodingEscaping",
            expression: "'test'.encode('rot13')",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_escapeHtml",
            group: "testEncodingEscaping",
            expression: "'A&B <c>'.escape('html')",
            resourceKey: "patient",
            expected: ["A&amp;B &lt;c&gt;"],
            expectError: false
        },
        {
            name: "test_unescapeHtml",
            group: "testEncodingEscaping",
            expression: "'A&amp;B &lt;c&gt;'.unescape('html')",
            resourceKey: "patient",
            expected: ["A&B <c>"],
            expectError: false
        },
        {
            name: "test_escapeJsonBackslash",
            group: "testEncodingEscaping",
            expression: "'a\\\\b'.escape('json')",
            resourceKey: "patient",
            expected: ["a\\\\b"],
            expectError: false
        },
        {
            name: "test_unescapeJson",
            group: "testEncodingEscaping",
            expression: "'\\\\\"1<2\\\\\"'.unescape('json')",
            resourceKey: "patient",
            expected: ["\"1<2\""],
            expectError: false
        },
        {
            name: "test_convertsToIntegerDecimal",
            group: "testConversionRules",
            expression: "1.5.convertsToInteger()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_toIntegerDecimal",
            group: "testConversionRules",
            expression: "1.5.toInteger()",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_toIntegerSignedString",
            group: "testConversionRules",
            expression: "'+42'.toInteger()",
            resourceKey: "patient",
            expected: [42],
            expectError: false
        },
        {
            name: "test_unterminatedComment",
            group: "testConversionRules",
            expression: "2 + 2 /* not finished",
            resourceKey: "patient",
            expected: [],
            expectError: true
        }
    ];
}
