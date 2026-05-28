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

json[] fnFirstResources = [
    {
        "resourceType": "Patient",
        "name": [
            {
                "use": "official",
                "family": "f1",
                "given": [
                    "g1.1",
                    "g1.2"
                ]
            },
            {
                "use": "usual",
                "given": [
                    "g2.1"
                ]
            },
            {
                "use": "maiden",
                "family": "f3",
                "given": [
                    "g3.1",
                    "g3.2"
                ],
                "period": {
                    "end": "2002"
                }
            }
        ]
    }
];


@test:Config {}
function testTableLevelFirst() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "name.first().use",
                        name: "use",
                        'type: "code"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "use": "official"
        }
    ];
    json[] result = check evaluate(fnFirstResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testTableAndFieldLevelFirst() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "name.first().given.first()",
                        name: "given",
                        'type: "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "given": "g1.1"
        }
    ];
    json[] result = check evaluate(fnFirstResources, view);
    test:assertEquals(result, expected);}
