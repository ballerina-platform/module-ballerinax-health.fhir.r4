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

function getComparisonsTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testGreaterThan1",
            group: "testGreaterThan",
            expression: "1 > 2",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan2",
            group: "testGreaterThan",
            expression: "1.0 > 1.2",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan3",
            group: "testGreaterThan",
            expression: "'a' > 'b'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan4",
            group: "testGreaterThan",
            expression: "'A' > 'a'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan5",
            group: "testGreaterThan",
            expression: "@2014-12-12 > @2014-12-13",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan6",
            group: "testGreaterThan",
            expression: "@2014-12-13T12:00:00 > @2014-12-13T12:00:01",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan7",
            group: "testGreaterThan",
            expression: "@T12:00:00 > @T14:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan8",
            group: "testGreaterThan",
            expression: "1 > 1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan9",
            group: "testGreaterThan",
            expression: "1.0 > 1.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan10",
            group: "testGreaterThan",
            expression: "'a' > 'a'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan11",
            group: "testGreaterThan",
            expression: "'A' > 'A'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan12",
            group: "testGreaterThan",
            expression: "@2014-12-12 > @2014-12-12",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan13",
            group: "testGreaterThan",
            expression: "@2014-12-13T12:00:00 > @2014-12-13T12:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan14",
            group: "testGreaterThan",
            expression: "@T12:00:00 > @T12:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan15",
            group: "testGreaterThan",
            expression: "2 > 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreaterThan16",
            group: "testGreaterThan",
            expression: "1.1 > 1.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreaterThan17",
            group: "testGreaterThan",
            expression: "'b' > 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreaterThan18",
            group: "testGreaterThan",
            expression: "'B' > 'A'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreaterThan19",
            group: "testGreaterThan",
            expression: "@2014-12-13 > @2014-12-12",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreaterThan20",
            group: "testGreaterThan",
            expression: "@2014-12-13T12:00:01 > @2014-12-13T12:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreaterThan21",
            group: "testGreaterThan",
            expression: "@T12:00:01 > @T12:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreaterThan22",
            group: "testGreaterThan",
            expression: "Observation.value > 100 '[lb_av]'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreaterThan23",
            group: "testGreaterThan",
            expression: "@2018-03 > @2018-03-01",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreaterThan24",
            group: "testGreaterThan",
            expression: "@2018-03-01T10:30 > @2018-03-01T10:30:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreaterThan25",
            group: "testGreaterThan",
            expression: "@T10:30 > @T10:30:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreaterThan26",
            group: "testGreaterThan",
            expression: "@2018-03-01T10:30:00 > @2018-03-01T10:30:00.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThan27",
            group: "testGreaterThan",
            expression: "@T10:30:00 > @T10:30:00.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreaterThanEmpty1",
            group: "testGreaterThan",
            expression: "1 > {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreaterThanEmpty2",
            group: "testGreaterThan",
            expression: "{} > 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreaterThanEmpty3",
            group: "testGreaterThan",
            expression: "{} > {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual1",
            group: "testGreatorOrEqual",
            expression: "1 >= 2",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual2",
            group: "testGreatorOrEqual",
            expression: "1.0 >= 1.2",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual3",
            group: "testGreatorOrEqual",
            expression: "'a' >= 'b'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual4",
            group: "testGreatorOrEqual",
            expression: "'A' >= 'a'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual5",
            group: "testGreatorOrEqual",
            expression: "@2014-12-12 >= @2014-12-13",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual6",
            group: "testGreatorOrEqual",
            expression: "@2014-12-13T12:00:00 >= @2014-12-13T12:00:01",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual7",
            group: "testGreatorOrEqual",
            expression: "@T12:00:00 >= @T14:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual8",
            group: "testGreatorOrEqual",
            expression: "1 >= 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual9",
            group: "testGreatorOrEqual",
            expression: "1.0 >= 1.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual10",
            group: "testGreatorOrEqual",
            expression: "'a' >= 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual11",
            group: "testGreatorOrEqual",
            expression: "'A' >= 'A'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual12",
            group: "testGreatorOrEqual",
            expression: "@2014-12-12 >= @2014-12-12",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual13",
            group: "testGreatorOrEqual",
            expression: "@2014-12-13T12:00:00 >= @2014-12-13T12:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual14",
            group: "testGreatorOrEqual",
            expression: "@T12:00:00 >= @T12:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual15",
            group: "testGreatorOrEqual",
            expression: "2 >= 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual16",
            group: "testGreatorOrEqual",
            expression: "1.1 >= 1.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual17",
            group: "testGreatorOrEqual",
            expression: "'b' >= 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual18",
            group: "testGreatorOrEqual",
            expression: "'B' >= 'A'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual19",
            group: "testGreatorOrEqual",
            expression: "@2014-12-13 >= @2014-12-12",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual20",
            group: "testGreatorOrEqual",
            expression: "@2014-12-13T12:00:01 >= @2014-12-13T12:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual21",
            group: "testGreatorOrEqual",
            expression: "@T12:00:01 >= @T12:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual22",
            group: "testGreatorOrEqual",
            expression: "Observation.value >= 100 '[lb_av]'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual23",
            group: "testGreatorOrEqual",
            expression: "@2018-03 >= @2018-03-01",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual24",
            group: "testGreatorOrEqual",
            expression: "@2018-03-01T10:30 >= @2018-03-01T10:30:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual25",
            group: "testGreatorOrEqual",
            expression: "@T10:30 >= @T10:30:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual26",
            group: "testGreatorOrEqual",
            expression: "@2018-03-01T10:30:00 >= @2018-03-01T10:30:00.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqual27",
            group: "testGreatorOrEqual",
            expression: "@T10:30:00 >= @T10:30:00.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqualEmpty1",
            group: "testGreatorOrEqual",
            expression: "1 >= {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqualEmpty2",
            group: "testGreatorOrEqual",
            expression: "{} >= 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testGreatorOrEqualEmpty3",
            group: "testGreatorOrEqual",
            expression: "{} >= {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessThan1",
            group: "testLessThan",
            expression: "1 < 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessThan2",
            group: "testLessThan",
            expression: "1.0 < 1.2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessThan3",
            group: "testLessThan",
            expression: "'a' < 'b'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessThan4",
            group: "testLessThan",
            expression: "'A' < 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessThan5",
            group: "testLessThan",
            expression: "@2014-12-12 < @2014-12-13",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessThan6",
            group: "testLessThan",
            expression: "@2014-12-13T12:00:00 < @2014-12-13T12:00:01",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessThan7",
            group: "testLessThan",
            expression: "@T12:00:00 < @T14:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessThan8",
            group: "testLessThan",
            expression: "1 < 1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan9",
            group: "testLessThan",
            expression: "1.0 < 1.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan10",
            group: "testLessThan",
            expression: "'a' < 'a'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan11",
            group: "testLessThan",
            expression: "'A' < 'A'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan12",
            group: "testLessThan",
            expression: "@2014-12-12 < @2014-12-12",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan13",
            group: "testLessThan",
            expression: "@2014-12-13T12:00:00 < @2014-12-13T12:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan14",
            group: "testLessThan",
            expression: "@T12:00:00 < @T12:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan15",
            group: "testLessThan",
            expression: "2 < 1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan16",
            group: "testLessThan",
            expression: "1.1 < 1.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan17",
            group: "testLessThan",
            expression: "'b' < 'a'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan18",
            group: "testLessThan",
            expression: "'B' < 'A'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan19",
            group: "testLessThan",
            expression: "@2014-12-13 < @2014-12-12",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan20",
            group: "testLessThan",
            expression: "@2014-12-13T12:00:01 < @2014-12-13T12:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan21",
            group: "testLessThan",
            expression: "@T12:00:01 < @T12:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan22",
            group: "testLessThan",
            expression: "Observation.value < 200 '[lb_av]'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessThan23",
            group: "testLessThan",
            expression: "@2018-03 < @2018-03-01",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessThan24",
            group: "testLessThan",
            expression: "@2018-03-01T10:30 < @2018-03-01T10:30:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessThan25",
            group: "testLessThan",
            expression: "@T10:30 < @T10:30:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessThan26",
            group: "testLessThan",
            expression: "@2018-03-01T10:30:00 < @2018-03-01T10:30:00.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThan27",
            group: "testLessThan",
            expression: "@T10:30:00 < @T10:30:00.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessThanEmpty1",
            group: "testLessThan",
            expression: "1 < {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessThanEmpty2",
            group: "testLessThan",
            expression: "{} < 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessThanEmpty3",
            group: "testLessThan",
            expression: "{} < {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessOrEqual1",
            group: "testLessOrEqual",
            expression: "1 <= 2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual2",
            group: "testLessOrEqual",
            expression: "1.0 <= 1.2",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual3",
            group: "testLessOrEqual",
            expression: "'a' <= 'b'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual4",
            group: "testLessOrEqual",
            expression: "'A' <= 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual5",
            group: "testLessOrEqual",
            expression: "@2014-12-12 <= @2014-12-13",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual6",
            group: "testLessOrEqual",
            expression: "@2014-12-13T12:00:00 <= @2014-12-13T12:00:01",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual7",
            group: "testLessOrEqual",
            expression: "@T12:00:00 <= @T14:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual8",
            group: "testLessOrEqual",
            expression: "1 <= 1",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual9",
            group: "testLessOrEqual",
            expression: "1.0 <= 1.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual10",
            group: "testLessOrEqual",
            expression: "'a' <= 'a'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual11",
            group: "testLessOrEqual",
            expression: "'A' <= 'A'",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual12",
            group: "testLessOrEqual",
            expression: "@2014-12-12 <= @2014-12-12",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual13",
            group: "testLessOrEqual",
            expression: "@2014-12-13T12:00:00 <= @2014-12-13T12:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual14",
            group: "testLessOrEqual",
            expression: "@T12:00:00 <= @T12:00:00",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual15",
            group: "testLessOrEqual",
            expression: "2 <= 1",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessOrEqual16",
            group: "testLessOrEqual",
            expression: "1.1 <= 1.0",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessOrEqual17",
            group: "testLessOrEqual",
            expression: "'b' <= 'a'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessOrEqual18",
            group: "testLessOrEqual",
            expression: "'B' <= 'A'",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessOrEqual19",
            group: "testLessOrEqual",
            expression: "@2014-12-13 <= @2014-12-12",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessOrEqual20",
            group: "testLessOrEqual",
            expression: "@2014-12-13T12:00:01 <= @2014-12-13T12:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessOrEqual21",
            group: "testLessOrEqual",
            expression: "@T12:00:01 <= @T12:00:00",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testLessOrEqual22",
            group: "testLessOrEqual",
            expression: "Observation.value <= 200 '[lb_av]'",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual23",
            group: "testLessOrEqual",
            expression: "@2018-03 <= @2018-03-01",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessOrEqual24",
            group: "testLessOrEqual",
            expression: "@2018-03-01T10:30 <= @2018-03-01T10:30:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessOrEqual25",
            group: "testLessOrEqual",
            expression: "@T10:30 <= @T10:30:00",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessOrEqual26",
            group: "testLessOrEqual",
            expression: "@2018-03-01T10:30:00 <= @2018-03-01T10:30:00.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqual27",
            group: "testLessOrEqual",
            expression: "@T10:30:00 <= @T10:30:00.0",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testLessOrEqualEmpty1",
            group: "testLessOrEqual",
            expression: "1 <= {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessOrEqualEmpty2",
            group: "testLessOrEqual",
            expression: "{} <= 1",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testLessOrEqualEmpty3",
            group: "testLessOrEqual",
            expression: "{} <= {}",
            resourceKey: "patient",
            expected: [],
            expectError: false
        }
    ];
}
