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

json[] fnJoinResources = [
    {
        "resourceType": "Patient",
        "id": "p1",
        "name": [
            {
                "use": "official",
                "given": [
                    "p1.g1",
                    "p1.g2"
                ]
            }
        ]
    }
];


@test:Config {}
function testJoinWithComma() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "id",
                        'type: "id"
                    },
                    {
                        path: "name.given.join(',')",
                        name: "given",
                        'type: "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "p1",
            "given": "p1.g1,p1.g2"
        }
    ];
    json[] result = check evaluate(fnJoinResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testJoinWithEmptyValue() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "id",
                        'type: "id"
                    },
                    {
                        path: "name.given.join('')",
                        name: "given",
                        'type: "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "p1",
            "given": "p1.g1p1.g2"
        }
    ];
    json[] result = check evaluate(fnJoinResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testJoinWithNoValueDefaultToNoSeparator() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "id",
                        'type: "id"
                    },
                    {
                        path: "name.given.join()",
                        name: "given",
                        'type: "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "p1",
            "given": "p1.g1p1.g2"
        }
    ];
    json[] result = check evaluate(fnJoinResources, view);
    test:assertEquals(result, expected);}
