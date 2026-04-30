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

json[] fnEmptyResources = [
    {
        "resourceType": "Patient",
        "id": "p1",
        "name": [
            {
                "use": "official",
                "family": "f1"
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "p2"
    }
];


@test:Config {}
function testEmptyNames() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
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
                        name: "name_empty",
                        path: "name.empty()",
                        'type: "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "p1",
            "name_empty": false
        },
        {
            "id": "p2",
            "name_empty": true
        }
    ];
    json[] result = check evaluate(fnEmptyResources, view);
    test:assertEquals(result, expected);}
