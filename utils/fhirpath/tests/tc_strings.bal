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

function getStringsTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testContainsString1",
            group: "testContainsString",
            expression: "'12345'.contains('6') = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString2",
            group: "testContainsString",
            expression: "'12345'.contains('5') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString3",
            group: "testContainsString",
            expression: "'12345'.contains('45') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString4",
            group: "testContainsString",
            expression: "'12345'.contains('35') = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString5",
            group: "testContainsString",
            expression: "'12345'.contains('12345') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString6",
            group: "testContainsString",
            expression: "'12345'.contains('012345') = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString7",
            group: "testContainsString",
            expression: "'12345'.contains('') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString8",
            group: "testContainsString",
            expression: "{}.contains('a').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString9",
            group: "testContainsString",
            expression: "{}.contains('').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString10",
            group: "testContainsString",
            expression: "'123456789'.select(contains(length().toString()))",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsString10a",
            group: "testContainsString",
            expression: "'123456789'.contains(length().toString())",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testContainsNonString1",
            group: "testContainsString",
            expression: "Appointment.identifier.contains('rand')",
            resourceKey: "appointment",
            expected: [],
            expectError: true
        },
        {
            name: "test_testStartsWith1",
            group: "testStartsWith",
            expression: "'12345'.startsWith('2') = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith2",
            group: "testStartsWith",
            expression: "'12345'.startsWith('1') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith3",
            group: "testStartsWith",
            expression: "'12345'.startsWith('12') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith4",
            group: "testStartsWith",
            expression: "'12345'.startsWith('13') = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith5",
            group: "testStartsWith",
            expression: "'12345'.startsWith('12345') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith6",
            group: "testStartsWith",
            expression: "'12345'.startsWith('123456') = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith7",
            group: "testStartsWith",
            expression: "'12345'.startsWith('') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith8",
            group: "testStartsWith",
            expression: "{}.startsWith('1').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith9",
            group: "testStartsWith",
            expression: "{}.startsWith('').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith10",
            group: "testStartsWith",
            expression: "''.startsWith('') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith11",
            group: "testStartsWith",
            expression: "{}.startsWith('').exists() = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith12",
            group: "testStartsWith",
            expression: "'987654321'.select(startsWith(length().toString()))",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testStartsWith12a",
            group: "testStartsWith",
            expression: "'987654321'.startsWith(length().toString())",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testStartsWithNonString1",
            group: "testStartsWith",
            expression: "Appointment.identifier.startsWith('rand')",
            resourceKey: "appointment",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testEndsWith1",
            group: "testEndsWith",
            expression: "'12345'.endsWith('2') = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith2",
            group: "testEndsWith",
            expression: "'12345'.endsWith('5') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith3",
            group: "testEndsWith",
            expression: "'12345'.endsWith('45') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith4",
            group: "testEndsWith",
            expression: "'12345'.endsWith('35') = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith5",
            group: "testEndsWith",
            expression: "'12345'.endsWith('12345') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith6",
            group: "testEndsWith",
            expression: "'12345'.endsWith('012345') = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith7",
            group: "testEndsWith",
            expression: "'12345'.endsWith('') = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith8",
            group: "testEndsWith",
            expression: "{}.endsWith('1').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith9",
            group: "testEndsWith",
            expression: "{}.endsWith('').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith10",
            group: "testEndsWith",
            expression: "'123456789'.select(endsWith(length().toString()))",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEndsWith10a",
            group: "testEndsWith",
            expression: "'123456789'.endsWith(length().toString())",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testEndsWithNonString1",
            group: "testEndsWith",
            expression: "Appointment.identifier.endsWith('rand')",
            resourceKey: "appointment",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testLength1",
            group: "testLength",
            expression: "'123456'.length() = 6",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLength2",
            group: "testLength",
            expression: "'12345'.length() = 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLength3",
            group: "testLength",
            expression: "'123'.length() = 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLength4",
            group: "testLength",
            expression: "'1'.length() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLength5",
            group: "testLength",
            expression: "''.length() = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLength6",
            group: "testLength",
            expression: "{}.length().empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSubstring1",
            group: "testSubstring",
            expression: "'12345'.substring(2) = '345'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSubstring2",
            group: "testSubstring",
            expression: "'12345'.substring(2,1) = '3'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSubstring3",
            group: "testSubstring",
            expression: "'12345'.substring(2,5) = '345'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSubstring4",
            group: "testSubstring",
            expression: "'12345'.substring(25).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testSubstring5",
            group: "testSubstring",
            expression: "'12345'.substring(-1).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testSubstring7",
            group: "testSubstring",
            expression: "'LogicalModel-Person'.substring(0, 12)",
            resourceKey: "patient",
            expected: ["LogicalModel"],
            expectError: false
        },
        {
            name: "test_testSubstring8",
            group: "testSubstring",
            expression: "'LogicalModel-Person'.substring(0, 'LogicalModel-Person'.indexOf('-'))",
            resourceKey: "patient",
            expected: ["LogicalModel"],
            expectError: false
        },
        {
            name: "test_testSubstring9",
            group: "testSubstring",
            expression: "{}.substring(25).empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSubstring10",
            group: "testSubstring",
            expression: "Patient.name.family.first().select(substring(2, length()-5))",
            resourceKey: "patient",
            expected: ["alm"],
            expectError: false
        },
        {
            name: "test_testSubstring10a",
            group: "testSubstring",
            expression: "Patient.name.family.first().substring(2, length()-5)",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testSubstring11",
            group: "testSubstring",
            expression: "{}.substring({}).empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSubstring12",
            group: "testSubstring",
            expression: "'string'.substring({}).empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTrim1",
            group: "testTrim",
            expression: "'123456'.trim().length() = 6",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTrim2",
            group: "testTrim",
            expression: "'123 456'.trim().length() = 7",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTrim3",
            group: "testTrim",
            expression: "' 123456 '.trim().length() = 6",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTrim4",
            group: "testTrim",
            expression: "' '.trim().length() = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTrim5",
            group: "testTrim",
            expression: "{}.trim().empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTrim6",
            group: "testTrim",
            expression: "' '.trim() = ''",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMatchesCaseSensitive1",
            group: "testMatches",
            expression: "'FHIR'.matches('FHIR')",
            resourceKey: "empty",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMatchesCaseSensitive2",
            group: "testMatches",
            expression: "'FHIR'.matches('fhir')",
            resourceKey: "empty",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testMatchesEmpty",
            group: "testMatches",
            expression: "'FHIR'.matches({}).empty() = true",
            resourceKey: "empty",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMatchesEmpty2",
            group: "testMatches",
            expression: "{}.matches('FHIR').empty() = true",
            resourceKey: "empty",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMatchesEmpty3",
            group: "testMatches",
            expression: "{}.matches({}).empty() = true",
            resourceKey: "empty",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMatchesSingleLineMode1",
            group: "testMatches",
            expression: "'A B'.matches('A.*B')",
            resourceKey: "empty",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMatchesWithinUrl1",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('library')",
            resourceKey: "empty",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testMatchesWithinUrl2",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('Library')",
            resourceKey: "empty",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testMatchesWithinUrl3",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('^Library$')",
            resourceKey: "empty",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testMatchesWithinUrl1a",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('.*Library.*')",
            resourceKey: "empty",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMatchesWithinUrl4",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('Measure')",
            resourceKey: "empty",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testMatchesFullWithinUrl1",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('library')",
            resourceKey: "empty",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testMatchesFullWithinUrl3",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('Library')",
            resourceKey: "empty",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testMatchesFullWithinUrl4",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('^Library$')",
            resourceKey: "empty",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testMatchesFullWithinUrl1a",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('.*Library.*')",
            resourceKey: "empty",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testMatchesFullWithinUrl2",
            group: "testMatches",
            expression: "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('Measure')",
            resourceKey: "empty",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testReplaceMatches1",
            group: "testReplaceMatches",
            expression: "'123456'.replaceMatches('234', 'X')",
            resourceKey: "patient",
            expected: ["1X56"],
            expectError: false
        },
        {
            name: "test_testReplaceMatches2",
            group: "testReplaceMatches",
            expression: "'abc'.replaceMatches('', 'x')",
            resourceKey: "patient",
            expected: ["abc"],
            expectError: false
        },
        {
            name: "test_testReplaceMatches3",
            group: "testReplaceMatches",
            expression: "'123456'.replaceMatches('234', '')",
            resourceKey: "patient",
            expected: ["156"],
            expectError: false
        },
        {
            name: "test_testReplaceMatches4",
            group: "testReplaceMatches",
            expression: "{}.replaceMatches('234', 'X').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testReplaceMatches5",
            group: "testReplaceMatches",
            expression: "'123'.replaceMatches({}, 'X').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testReplaceMatches6",
            group: "testReplaceMatches",
            expression: "'123'.replaceMatches('2', {}).empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testReplaceMatches7",
            group: "testReplaceMatches",
            expression: "'abc123'.replaceMatches('[0-9]', '-')",
            resourceKey: "patient",
            expected: ["abc---"],
            expectError: false
        },
        {
            name: "test_testReplace1",
            group: "testReplace",
            expression: "'123456'.replace('234', 'X')",
            resourceKey: "patient",
            expected: ["1X56"],
            expectError: false
        },
        {
            name: "test_testReplace2",
            group: "testReplace",
            expression: "'abc'.replace('', 'x')",
            resourceKey: "patient",
            expected: ["xaxbxcx"],
            expectError: false
        },
        {
            name: "test_testReplace3",
            group: "testReplace",
            expression: "'123456'.replace('234', '')",
            resourceKey: "patient",
            expected: ["156"],
            expectError: false
        },
        {
            name: "test_testReplace4",
            group: "testReplace",
            expression: "{}.replace('234', 'X').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testReplace5",
            group: "testReplace",
            expression: "'123'.replace({}, 'X').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testReplace6",
            group: "testReplace",
            expression: "'123'.replace('2', {}).empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToString1",
            group: "testToString",
            expression: "1.toString() = '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToString2",
            group: "testToString",
            expression: "'-1'.toInteger() = -1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToString3",
            group: "testToString",
            expression: "0.toString() = '0'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testToString4",
            group: "testToString",
            expression: "0.0.toString() = '0.0'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testToString5",
            group: "testToString",
            expression: "@2014-12-14.toString() = '2014-12-14'",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testSplit1",
            group: "testSplit",
            expression: "'Peter,James,Jim,Peter,James'.split(',').count() = 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSplit2",
            group: "testSplit",
            expression: "'A,,C'.split(',').join(',') = 'A,,C'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSplit3",
            group: "testSplit",
            expression: "'[stop]ONE[stop][stop]TWO[stop][stop][stop]THREE[stop][stop]'.split('[stop]').trace('n').count() = 9",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSplit4",
            group: "testSplit",
            expression: "'[stop]ONE[stop][stop]TWO[stop][stop][stop]THREE[stop][stop]'.split('[stop]').join('[stop]')",
            resourceKey: "patient",
            expected: ["[stop]ONE[stop][stop]TWO[stop][stop][stop]THREE[stop][stop]"],
            expectError: false
        },
        {
            name: "test_testJoin",
            group: "testJoin",
            expression: "name.given.join(',')",
            resourceKey: "patient",
            expected: ["Peter,James,Jim,Peter,James"],
            expectError: false
        },
        {
            name: "test_testToChars1",
            group: "testToChars",
            expression: "'t2'.toChars() = 't' | '2'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testEncodeBase64A",
            group: "testEncodeDecode",
            expression: "'test'.encode('base64')",
            resourceKey: "patient",
            expected: ["dGVzdA=="],
            expectError: false
        },
        {
            name: "test_testEncodeHex",
            group: "testEncodeDecode",
            expression: "'test'.encode('hex')",
            resourceKey: "patient",
            expected: ["74657374"],
            expectError: false
        },
        {
            name: "test_testEncodeBase64B",
            group: "testEncodeDecode",
            expression: "'subjects?_d'.encode('base64')",
            resourceKey: "patient",
            expected: ["c3ViamVjdHM/X2Q="],
            expectError: false
        },
        {
            name: "test_testEncodeUrlBase64",
            group: "testEncodeDecode",
            expression: "'subjects?_d'.encode('urlbase64')",
            resourceKey: "patient",
            expected: ["c3ViamVjdHM_X2Q="],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testDecodeBase64A",
            group: "testEncodeDecode",
            expression: "'dGVzdA=='.decode('base64')",
            resourceKey: "patient",
            expected: ["test"],
            expectError: false
        },
        {
            name: "test_testDecodeHex",
            group: "testEncodeDecode",
            expression: "'74657374'.decode('hex')",
            resourceKey: "patient",
            expected: ["test"],
            expectError: false
        },
        {
            name: "test_testDecodeBase64B",
            group: "testEncodeDecode",
            expression: "'c3ViamVjdHM/X2Q='.decode('base64')",
            resourceKey: "patient",
            expected: ["subjects?_d"],
            expectError: false
        },
        {
            name: "test_testDecodeUrlBase64",
            group: "testEncodeDecode",
            expression: "'c3ViamVjdHM_X2Q='.decode('urlbase64')",
            resourceKey: "patient",
            expected: ["subjects?_d"],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testEscapeHtml",
            group: "testEscapeUnescape",
            expression: "'\"1<2\"'.escape('html')",
            resourceKey: "patient",
            expected: ["&quot;1&lt;2&quot;"],
            expectError: false
        },
        {
            name: "test_testEscapeJson",
            group: "testEscapeUnescape",
            expression: "'\"1<2\"'.escape('json')",
            resourceKey: "patient",
            expected: ["\\\"1<2\\\""],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testUnescapeHtml",
            group: "testEscapeUnescape",
            expression: "'&quot;1&lt;2&quot;'.unescape('html')",
            resourceKey: "patient",
            expected: ["\"1<2\""],
            expectError: false
        },
        {
            name: "test_testUnescapeJson",
            group: "testEscapeUnescape",
            expression: "'\\\"1<2\\\"'.unescape('json')",
            resourceKey: "patient",
            expected: ["\"1<2\""],
            expectError: false
        },
        {
            name: "test_testIndexOf1",
            group: "testIndexOf",
            expression: "'LogicalModel-Person'.indexOf('-')",
            resourceKey: "patient",
            expected: [12],
            expectError: false
        },
        {
            name: "test_testIndexOf2",
            group: "testIndexOf",
            expression: "'LogicalModel-Person'.indexOf('z')",
            resourceKey: "patient",
            expected: [-1],
            expectError: false
        },
        {
            name: "test_testIndexOf3",
            group: "testIndexOf",
            expression: "'LogicalModel-Person'.indexOf('')",
            resourceKey: "patient",
            expected: [0],
            expectError: false
        },
        {
            name: "test_testIndexOf5",
            group: "testIndexOf",
            expression: "'LogicalModel-Person'.indexOf({}).empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIndexOf4",
            group: "testIndexOf",
            expression: "{}.indexOf('-').empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIndexOf6",
            group: "testIndexOf",
            expression: "{}.indexOf({}).empty() = true",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testConcatenate1",
            group: "testConcatenate",
            expression: "'a' & 'b' = 'ab'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testConcatenate2",
            group: "testConcatenate",
            expression: "'1' & {} = '1'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testConcatenate3",
            group: "testConcatenate",
            expression: "{} & 'b' = 'b'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testConcatenate4",
            group: "testConcatenate",
            expression: "(1 | 2 | 3) & 'b' = '1,2,3b'",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testConcatenate5",
            group: "testConcatenate",
            expression: "{} & {} = ''",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        }
    ];
}
