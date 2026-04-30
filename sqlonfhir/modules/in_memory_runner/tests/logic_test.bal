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

json[] logicResources = [
    {
        "resourceType": "Patient",
        "id": "m0",
        "gender": "male",
        "deceasedBoolean": false
    },
    {
        "resourceType": "Patient",
        "id": "f0",
        "deceasedBoolean": false,
        "gender": "female"
    },
    {
        "resourceType": "Patient",
        "id": "m1",
        "gender": "male",
        "deceasedBoolean": true
    },
    {
        "resourceType": "Patient",
        "id": "f1",
        "gender": "female"
    }
];


@test:Config {}
function testFilteringWithAnd() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'where: [
            {
                path: "gender = 'male' and deceased.ofType(boolean) = false"
            }
        ],
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "id",
                        'type: "id"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "m0"
        }
    ];
    json[] result = check evaluate(logicResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testFilteringWithOr() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'where: [
            {
                path: "gender = 'male' or deceased.ofType(boolean) = false"
            }
        ],
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "id",
                        'type: "id"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "m0"
        },
        {
            "id": "f0"
        },
        {
            "id": "m1"
        }
    ];
    json[] result = check evaluate(logicResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testFilteringWithNot() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'where: [
            {
                path: "(gender = 'male').not()"
            }
        ],
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "id",
                        'type: "id"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "f0"
        },
        {
            "id": "f1"
        }
    ];
    json[] result = check evaluate(logicResources, view);
    test:assertEquals(result, expected);}
