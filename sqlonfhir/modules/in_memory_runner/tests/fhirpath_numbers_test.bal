// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
// 
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// Source: SQL-on-FHIR v2 test suite (https://github.com/FHIR/sql-on-fhir-v2)
import ballerina/test;
import mahima_de_silva/sql_on_fhir_lib;

json[] fhirpathNumbersResources = [
    {
        "resourceType": "Observation",
        "id": "o1",
        "code": {
            "text": "code"
        },
        "status": "final",
        "valueRange": {
            "low": {
                "value": 2
            },
            "high": {
                "value": 3
            }
        }
    }
];


@test:Config {}
function testAddObservation() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Observation",
        status: "active",
        'select: [
            {
                column: [
                    {
                        name: "id",
                        path: "id",
                        'type: "id"
                    },
                    {
                        name: "add",
                        path: "value.ofType(Range).low.value + value.ofType(Range).high.value",
                        'type: "decimal"
                    },
                    {
                        name: "sub",
                        path: "value.ofType(Range).high.value - value.ofType(Range).low.value",
                        'type: "decimal"
                    },
                    {
                        name: "mul",
                        path: "value.ofType(Range).low.value * value.ofType(Range).high.value",
                        'type: "decimal"
                    },
                    {
                        name: "div",
                        path: "value.ofType(Range).high.value / value.ofType(Range).low.value",
                        'type: "decimal"
                    },
                    {
                        name: "eq",
                        path: "value.ofType(Range).high.value = value.ofType(Range).low.value",
                        'type: "boolean"
                    },
                    {
                        name: "gt",
                        path: "value.ofType(Range).high.value > value.ofType(Range).low.value",
                        'type: "boolean"
                    },
                    {
                        name: "ge",
                        path: "value.ofType(Range).high.value >= value.ofType(Range).low.value",
                        'type: "boolean"
                    },
                    {
                        name: "lt",
                        path: "value.ofType(Range).high.value < value.ofType(Range).low.value",
                        'type: "boolean"
                    },
                    {
                        name: "le",
                        path: "value.ofType(Range).high.value <= value.ofType(Range).low.value",
                        'type: "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "o1",
            "add": 5,
            "sub": 1,
            "mul": 6,
            "div": 1.5d,
            "eq": false,
            "gt": true,
            "ge": true,
            "lt": false,
            "le": false
        }
    ];
    json[] result = check evaluate(fhirpathNumbersResources, view);
    test:assertEquals(result, expected);}
