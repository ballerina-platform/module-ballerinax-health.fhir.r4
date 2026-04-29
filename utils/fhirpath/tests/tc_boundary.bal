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

function getBoundaryTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_HighBoundaryDecimalDefault",
            group: "HighBoundary",
            expression: "1.587.highBoundary()",
            resourceKey: "empty",
            expected: [1.58750000],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal1",
            group: "HighBoundary",
            expression: "1.587.highBoundary(2)",
            resourceKey: "empty",
            expected: [1.59],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal2",
            group: "HighBoundary",
            expression: "1.587.highBoundary(6)",
            resourceKey: "empty",
            expected: [1.587500],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal3",
            group: "HighBoundary",
            expression: "1.587.highBoundary(-1)",
            resourceKey: "empty",
            expected: [],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimal4",
            group: "HighBoundary",
            expression: "(-1.587).highBoundary()",
            resourceKey: "empty",
            expected: [-1.58650000],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal5",
            group: "HighBoundary",
            expression: "(-1.587).highBoundary(2)",
            resourceKey: "empty",
            expected: [-1.58],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal6",
            group: "HighBoundary",
            expression: "(-1.587).highBoundary(6)",
            resourceKey: "empty",
            expected: [-1.586500],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal7",
            group: "HighBoundary",
            expression: "1.587.highBoundary(39)",
            resourceKey: "empty",
            expected: [],
            expectError: false
        },
        {
            name: "test_HighBoundaryDecimal8",
            group: "HighBoundary",
            expression: "1.highBoundary()",
            resourceKey: "empty",
            expected: [1.50000000],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal9",
            group: "HighBoundary",
            expression: "1.highBoundary(0)",
            resourceKey: "empty",
            expected: [2],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal10",
            group: "HighBoundary",
            expression: "1.highBoundary(5)",
            resourceKey: "empty",
            expected: [1.50000],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal11",
            group: "HighBoundary",
            expression: "12.587.highBoundary(2)",
            resourceKey: "empty",
            expected: [12.59],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal12",
            group: "HighBoundary",
            expression: "12.500.highBoundary(4)",
            resourceKey: "empty",
            expected: [12.5005],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal13",
            group: "HighBoundary",
            expression: "120.highBoundary(2)",
            resourceKey: "empty",
            expected: [120.50],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal14",
            group: "HighBoundary",
            expression: "-120.highBoundary(2)",
            resourceKey: "empty",
            expected: [-120.50],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal15",
            group: "HighBoundary",
            expression: "0.0034.highBoundary(1)",
            resourceKey: "empty",
            expected: [0.0],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal16",
            group: "HighBoundary",
            expression: "-0.0034.highBoundary(1)",
            resourceKey: "empty",
            expected: [0.0],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDecimal",
            group: "HighBoundary",
            expression: "1.587.highBoundary(8)",
            resourceKey: "empty",
            expected: [1.58750000],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryQuantity",
            group: "HighBoundary",
            expression: "1.587 'm'.highBoundary(8)",
            resourceKey: "empty",
            expected: ["1.58750000 'm'"],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_HighBoundaryDateMonth",
            group: "HighBoundary",
            expression: "@2014.highBoundary(6)",
            resourceKey: "empty",
            expected: ["@2014-12"],
            expectError: false
        },
        {
            name: "test_HighBoundaryDateTimeMillisecond1",
            group: "HighBoundary",
            expression: "@2014-01-01T08.highBoundary(17)",
            resourceKey: "empty",
            expected: ["@2014-01-01T08:00:59.999-12:00"],
            expectError: false
        },
        {
            name: "test_HighBoundaryDateTimeMillisecond2",
            group: "HighBoundary",
            expression: "@2014-01-01T08:05-05:00.highBoundary(17)",
            resourceKey: "empty",
            expected: ["@2014-01-01T08:05:59.999-05:00"],
            expectError: false
        },
        {
            name: "test_HighBoundaryDateTimeMillisecond3",
            group: "HighBoundary",
            expression: "@2014-01-01T08.highBoundary(17)",
            resourceKey: "empty",
            expected: ["@2014-01-01T08:00:59.999-12:00"],
            expectError: false
        },
        {
            name: "test_HighBoundaryTimeMillisecond",
            group: "HighBoundary",
            expression: "@T10:30.highBoundary(9)",
            resourceKey: "empty",
            expected: ["@T10:30:59.999"],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimalDefault",
            group: "LowBoundary",
            expression: "1.587.lowBoundary()",
            resourceKey: "empty",
            expected: [1.58650000],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal1",
            group: "LowBoundary",
            expression: "1.587.lowBoundary(6)",
            resourceKey: "empty",
            expected: [1.586500],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal2",
            group: "LowBoundary",
            expression: "1.587.lowBoundary(2)",
            resourceKey: "empty",
            expected: [1.58],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal3",
            group: "LowBoundary",
            expression: "1.587.lowBoundary(-1)",
            resourceKey: "empty",
            expected: [],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimal4",
            group: "LowBoundary",
            expression: "1.587.lowBoundary(0)",
            resourceKey: "empty",
            expected: [1],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal5",
            group: "LowBoundary",
            expression: "1.587.lowBoundary(32)",
            resourceKey: "empty",
            expected: [],
            expectError: false
        },
        {
            name: "test_LowBoundaryNegDecimalDefault",
            group: "LowBoundary",
            expression: "(-1.587).lowBoundary()",
            resourceKey: "empty",
            expected: [-1.58750000],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryNegDecimal1",
            group: "LowBoundary",
            expression: "(-1.587).lowBoundary(6)",
            resourceKey: "empty",
            expected: [-1.587500],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryNegDecimal2",
            group: "LowBoundary",
            expression: "(-1.587).lowBoundary(2)",
            resourceKey: "empty",
            expected: [-1.59],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryNegDecimal3",
            group: "LowBoundary",
            expression: "(-1.587).lowBoundary(-1)",
            resourceKey: "empty",
            expected: [],
            expectError: false
        },
        {
            name: "test_LowBoundaryNegDecimal4",
            group: "LowBoundary",
            expression: "(-1.587).lowBoundary(0)",
            resourceKey: "empty",
            expected: [-2],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryNegDecimal5",
            group: "LowBoundary",
            expression: "(-1.587).lowBoundary(32)",
            resourceKey: "empty",
            expected: [],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimal6",
            group: "LowBoundary",
            expression: "1.587.lowBoundary(39)",
            resourceKey: "empty",
            expected: [],
            expectError: false
        },
        {
            name: "test_LowBoundaryDecimal7",
            group: "LowBoundary",
            expression: "1.toDecimal().lowBoundary()",
            resourceKey: "empty",
            expected: [0.50000000],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal8",
            group: "LowBoundary",
            expression: "1.lowBoundary(0)",
            resourceKey: "empty",
            expected: [0],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal9",
            group: "LowBoundary",
            expression: "1.lowBoundary(5)",
            resourceKey: "empty",
            expected: [0.50000],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal10",
            group: "LowBoundary",
            expression: "12.587.lowBoundary(2)",
            resourceKey: "empty",
            expected: [12.58],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal11",
            group: "LowBoundary",
            expression: "12.500.lowBoundary(4)",
            resourceKey: "empty",
            expected: [12.4995],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal12",
            group: "LowBoundary",
            expression: "120.lowBoundary(2)",
            resourceKey: "empty",
            expected: [119.50],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal13",
            group: "LowBoundary",
            expression: "(-120).lowBoundary(2)",
            resourceKey: "empty",
            expected: [-120.50],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal14",
            group: "LowBoundary",
            expression: "0.0034.lowBoundary(1)",
            resourceKey: "empty",
            expected: [0.0],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDecimal15",
            group: "LowBoundary",
            expression: "(-0.0034).lowBoundary(1)",
            resourceKey: "empty",
            expected: [-0.0],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryQuantity",
            group: "LowBoundary",
            expression: "1.587 'cm'.lowBoundary(8)",
            resourceKey: "empty",
            expected: ["1.58650000 'cm'"],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_LowBoundaryDateMonth",
            group: "LowBoundary",
            expression: "@2014.lowBoundary(6)",
            resourceKey: "empty",
            expected: ["@2014-01"],
            expectError: false
        },
        {
            name: "test_LowBoundaryDateTimeMillisecond1",
            group: "LowBoundary",
            expression: "@2014-01-01T08.lowBoundary(17)",
            resourceKey: "empty",
            expected: ["@2014-01-01T08:00:00.000+14:00"],
            expectError: false
        },
        {
            name: "test_LowBoundaryDateTimeMillisecond2",
            group: "LowBoundary",
            expression: "@2014-01-01T08:05+08:00.lowBoundary(17)",
            resourceKey: "empty",
            expected: ["@2014-01-01T08:05:00.000+08:00"],
            expectError: false
        },
        {
            name: "test_LowBoundaryDateTimeMillisecond3",
            group: "LowBoundary",
            expression: "@2014-01-01T08.lowBoundary(8)",
            resourceKey: "empty",
            expected: ["@2014-01-01"],
            expectError: false
        },
        {
            name: "test_LowBoundaryTimeMillisecond",
            group: "LowBoundary",
            expression: "@T10:30.lowBoundary(9)",
            resourceKey: "empty",
            expected: ["@T10:30:00.000"],
            expectError: false
        },
        {
            name: "test_PrecisionDecimal",
            group: "Precision",
            expression: "1.58700.precision()",
            resourceKey: "empty",
            expected: [5],
            expectError: false
        },
        {
            name: "test_PrecisionYear",
            group: "Precision",
            expression: "@2014.precision()",
            resourceKey: "empty",
            expected: [4],
            expectError: false
        },
        {
            name: "test_PrecisionDateTimeMilliseconds",
            group: "Precision",
            expression: "@2014-01-05T10:30:00.000.precision()",
            resourceKey: "empty",
            expected: [17],
            expectError: false
        },
        {
            name: "test_PrecisionTimeMinutes",
            group: "Precision",
            expression: "@T10:30.precision()",
            resourceKey: "empty",
            expected: [4],
            expectError: false
        },
        {
            name: "test_PrecisionTimeMilliseconds",
            group: "Precision",
            expression: "@T10:30:00.000.precision()",
            resourceKey: "empty",
            expected: [9],
            expectError: false
        },
        {
            name: "test_PrecisionEmpty",
            group: "Precision",
            expression: "{}.precision().empty()",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        }
    ];
}
