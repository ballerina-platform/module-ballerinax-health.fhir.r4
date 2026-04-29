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

function getCollectionsTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testWhere1",
            group: "testWhere",
            expression: "Patient.name.count() = 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testWhere2",
            group: "testWhere",
            expression: "Patient.name.where(given = 'Jim').count() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testWhere3",
            group: "testWhere",
            expression: "Patient.name.where(given = 'X').count() = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testWhere4",
            group: "testWhere",
            expression: "Patient.name.where($this.given = 'Jim').count() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSelect1",
            group: "testSelect",
            expression: "Patient.name.select(given).count() = 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSelect2",
            group: "testSelect",
            expression: "Patient.name.select(given | family).count() = 7",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSelect3",
            group: "testSelect",
            expression: "name.select(use.contains('i')).count()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_testExists1",
            group: "testExists",
            expression: "Patient.name.exists()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testExists2",
            group: "testExists",
            expression: "Patient.name.exists(use = 'nickname')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testExists3",
            group: "testExists",
            expression: "Patient.name.exists(use = 'official')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testExists4",
            group: "testExists",
            expression: "Patient.maritalStatus.coding.exists(code = 'P' and system = 'http://terminology.hl7.org/CodeSystem/v3-MaritalStatus') or Patient.maritalStatus.coding.exists(code = 'A' and system = 'http://terminology.hl7.org/CodeSystem/v3-MaritalStatus')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testExists5",
            group: "testExists",
            expression: "(1 | 2).exists()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testAllTrue1",
            group: "testAll",
            expression: "Patient.name.select(given.exists()).allTrue()",
            resourceKey: "patient",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testAllTrue2",
            group: "testAll",
            expression: "Patient.name.select(period.exists()).allTrue()",
            resourceKey: "patient",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testAllTrue3",
            group: "testAll",
            expression: "Patient.name.all(given.exists())",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testAllTrue4",
            group: "testAll",
            expression: "Patient.name.all(period.exists())",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testCount1",
            group: "testCount",
            expression: "Patient.name.count()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_testCount2",
            group: "testCount",
            expression: "Patient.name.count() = 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCount3",
            group: "testCount",
            expression: "Patient.name.first().count()",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_testCount4",
            group: "testCount",
            expression: "Patient.name.first().count() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct1",
            group: "testDistinct",
            expression: "(1 | 2 | 3).isDistinct()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct2",
            group: "testDistinct",
            expression: "Questionnaire.descendants().linkId.isDistinct()",
            resourceKey: "questionnaire",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct3",
            group: "testDistinct",
            expression: "Questionnaire.descendants().linkId.select(substring(0,1)).isDistinct().not()",
            resourceKey: "questionnaire",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testDistinct4",
            group: "testDistinct",
            expression: "(1 | 2 | 3).distinct()",
            resourceKey: "patient",
            expected: [1, 2, 3],
            expectError: false
        },
        {
            name: "test_testDistinct5",
            group: "testDistinct",
            expression: "Questionnaire.descendants().linkId.distinct().count()",
            resourceKey: "questionnaire",
            expected: [10],
            expectError: false
        },
        {
            name: "test_testDistinct6",
            group: "testDistinct",
            expression: "Questionnaire.descendants().linkId.select(substring(0,1)).distinct().count()",
            resourceKey: "questionnaire",
            expected: [2],
            expectError: false
        },
        {
            name: "test_testUnion1",
            group: "testUnion",
            expression: "(1 | 2 | 3).count() = 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testUnion2",
            group: "testUnion",
            expression: "(1 | 2 | 2).count() = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testUnion3",
            group: "testUnion",
            expression: "(1|1).count() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testUnion4",
            group: "testUnion",
            expression: "1.union(2).union(3).count() = 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testUnion5",
            group: "testUnion",
            expression: "1.union(2.union(3)).count() = 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testUnion6",
            group: "testUnion",
            expression: "(1 | 2).combine(2).count() = 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testUnion7",
            group: "testUnion",
            expression: "1.combine(1).count() = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testUnion8",
            group: "testUnion",
            expression: "1.combine(1).union(2).count() = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testUnion9",
            group: "testUnion",
            expression: "name.select(use | given).count()",
            resourceKey: "patient",
            expected: [8],
            expectError: false
        },
        {
            name: "test_testUnion10",
            group: "testUnion",
            expression: "name.select(use.union($this.given)).count()",
            resourceKey: "patient",
            expected: [8],
            expectError: false
        },
        {
            name: "test_testUnion11",
            group: "testUnion",
            expression: "name.select(use.union(given)).count()",
            resourceKey: "patient",
            expected: [8],
            expectError: false
        },
        {
            name: "test_testUnion12",
            group: "testUnion",
            expression: "true | Patient.name.given.first()",
            resourceKey: "patient",
            expected: [true, "Peter"],
            expectError: false
        },
        {
            name: "test_testContainsCollection1",
            group: "testContainsCollection",
            expression: "(1 | 2 | 3) contains 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsCollection2",
            group: "testContainsCollection",
            expression: "(2 | 3) contains 1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testContainsCollection3",
            group: "testContainsCollection",
            expression: "('a' | 'c' | 'd') contains 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testContainsCollection4",
            group: "testContainsCollection",
            expression: "('a' | 'c' | 'd') contains 'b'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testContainsCollectionEmpty1",
            group: "testContainsCollection",
            expression: "{} contains 1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testContainsCollectionEmpty2",
            group: "testContainsCollection",
            expression: "{} contains 'value'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testContainsCollectionEmpty3",
            group: "testContainsCollection",
            expression: "{} contains true",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testContainsCollectionEmpty4",
            group: "testContainsCollection",
            expression: "{} contains {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testContainsCollectionEmptyDateTime",
            group: "testContainsCollection",
            expression: "{} contains @2023-01-01",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testIn1",
            group: "testIn",
            expression: "1 in (1 | 2 | 3)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIn2",
            group: "testIn",
            expression: "1 in (2 | 3)",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testIn3",
            group: "testIn",
            expression: "'a' in ('a' | 'c' | 'd')",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIn4",
            group: "testIn",
            expression: "'b' in ('a' | 'c' | 'd')",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testIn5",
            group: "testIn",
            expression: "('a' | 'c' | 'd') in 'b'",
            resourceKey: "patient",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testInEmptyCollection",
            group: "testIn",
            expression: "1 in {}",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testInEmptyValue",
            group: "testIn",
            expression: "{} in (1 | 2 | 3)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testInEmptyBoth",
            group: "testIn",
            expression: "{} in {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testExclude1",
            group: "testExclude",
            expression: "(1 | 2 | 3).exclude(2 | 4) = 1 | 3",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testExclude2",
            group: "testExclude",
            expression: "(1 | 2).exclude(4) = 1 | 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testExclude3",
            group: "testExclude",
            expression: "(1 | 2).exclude({}) = 1 | 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testExclude4",
            group: "testExclude",
            expression: "1.combine(1).exclude(2).count() = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSubSetOf1",
            group: "testSubSetOf",
            expression: "Patient.name.first().subsetOf($this.name)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSubSetOf2",
            group: "testSubSetOf",
            expression: "Patient.name.subsetOf($this.name.first()).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSubSetOf3",
            group: "testSubSetOf",
            expression: "supportingInfo.where(category.coding.code = 'additionalbodysite').sequence.subsetOf($this.item.informationSequence)",
            resourceKey: "eob",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSuperSetOf1",
            group: "testSuperSetOf",
            expression: "Patient.name.first().supersetOf($this.name).not()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSuperSetOf2",
            group: "testSuperSetOf",
            expression: "Patient.name.supersetOf($this.name.first())",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntersect1",
            group: "testIntersect",
            expression: "(1 | 2 | 3).intersect(2 | 4) = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntersect2",
            group: "testIntersect",
            expression: "(1 | 2).intersect(4).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntersect3",
            group: "testIntersect",
            expression: "(1 | 2).intersect({}).empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIntersect4",
            group: "testIntersect",
            expression: "1.combine(1).intersect(1).count() = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCombine1",
            group: "testCombine()",
            expression: "concept.code.combine($this.descendants().concept.code).isDistinct()",
            resourceKey: "codesystem",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testCombine2",
            group: "testCombine()",
            expression: "name.given.combine(name.family).exclude('Jim')",
            resourceKey: "patient",
            expected: ["Peter", "James", "Peter", "James", "Chalmers", "Windsor"],
            expectError: false
        },
        {
            name: "test_testCombine3",
            group: "testCombine()",
            expression: "name.given.combine($this.name.family).exclude('Jim')",
            resourceKey: "patient",
            expected: ["Peter", "James", "Peter", "James", "Chalmers", "Windsor"],
            expectError: false
        },
        {
            name: "test_testFirstLast1",
            group: "testFirstLast",
            expression: "Patient.name.first().given = 'Peter' | 'James'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFirstLast2",
            group: "testFirstLast",
            expression: "Patient.name.last().given = 'Peter' | 'James'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSkip1",
            group: "testSkip",
            expression: "(0 | 1 | 2).skip(1) = 1 | 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSkip2",
            group: "testSkip",
            expression: "(0 | 1 | 2).skip(2) = 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSkip3",
            group: "testSkip",
            expression: "Patient.name.skip(1).given.trace('test') = 'Jim' | 'Peter' | 'James'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSkip4",
            group: "testSkip",
            expression: "Patient.name.skip(3).given.exists() = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTail1",
            group: "testTail",
            expression: "(0 | 1 | 2).tail() = 1 | 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTail2",
            group: "testTail",
            expression: "Patient.name.tail().given = 'Jim' | 'Peter' | 'James'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTake1",
            group: "testTake",
            expression: "(0 | 1 | 2).take(1) = 0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTake2",
            group: "testTake",
            expression: "(0 | 1 | 2).take(2) = 0 | 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTake3",
            group: "testTake",
            expression: "Patient.name.take(1).given = 'Peter' | 'James'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTake4",
            group: "testTake",
            expression: "Patient.name.take(2).given = 'Peter' | 'James' | 'Jim'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTake5",
            group: "testTake",
            expression: "Patient.name.take(3).given.count() = 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTake6",
            group: "testTake",
            expression: "Patient.name.take(4).given.count() = 5",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testTake7",
            group: "testTake",
            expression: "Patient.name.take(0).given.exists() = false",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSingle1",
            group: "testSingle",
            expression: "Patient.name.first().single().exists()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testSingle2",
            group: "testSingle",
            expression: "Patient.name.single().exists()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testIndexer1",
            group: "testIndexer",
            expression: "Patient.name[0].given = 'Peter' | 'James'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testIndexer2",
            group: "testIndexer",
            expression: "Patient.name[1].given = 'Jim'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testAggregate1",
            group: "testAggregate",
            expression: "(1|2|3|4|5|6|7|8|9).aggregate($this+$total, 0) = 45",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testAggregate2",
            group: "testAggregate",
            expression: "(1|2|3|4|5|6|7|8|9).aggregate($this+$total, 2) = 47",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testAggregate3",
            group: "testAggregate",
            expression: "(1|2|3|4|5|6|7|8|9).aggregate(iif($total.empty(), $this, iif($this < $total, $this, $total))) = 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testAggregate4",
            group: "testAggregate",
            expression: "(1|2|3|4|5|6|7|8|9).aggregate(iif($total.empty(), $this, iif($this > $total, $this, $total))) = 9",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testRepeat1",
            group: "testRepeat",
            expression: "ValueSet.expansion.repeat(contains).count() = 10",
            resourceKey: "valueset",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testRepeat2",
            group: "testRepeat",
            expression: "Questionnaire.repeat(item).code.count() = 11",
            resourceKey: "questionnaire",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testRepeat3",
            group: "testRepeat",
            expression: "Questionnaire.descendants().code.count() = 23",
            resourceKey: "questionnaire",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testRepeat4",
            group: "testRepeat",
            expression: "Questionnaire.children().code.count() = 2",
            resourceKey: "questionnaire",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testRepeat5",
            group: "testRepeat",
            expression: "Patient.name.repeat('test')",
            resourceKey: "patient",
            expected: ["test"],
            expectError: false
        }
    ];
}
