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

json[] combinationsResources = [
    {
        "id": "pt1",
        "resourceType": "Patient"
    },
    {
        "id": "pt2",
        "resourceType": "Patient"
    },
    {
        "id": "pt3",
        "resourceType": "Patient"
    }
];


@test:Config {}
function testSelect() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
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
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1"
        },
        {
            "id": "pt2"
        },
        {
            "id": "pt3"
        }
    ];
    json[] result = check evaluate(combinationsResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testColumnSelect() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "column_id",
                        'type: "id"
                    }
                ],
                'select: [
                    {
                        column: [
                            {
                                path: "id",
                                name: "select_id",
                                'type: "id"
                            }
                        ]
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "column_id": "pt1",
            "select_id": "pt1"
        },
        {
            "column_id": "pt2",
            "select_id": "pt2"
        },
        {
            "column_id": "pt3",
            "select_id": "pt3"
        }
    ];
    json[] result = check evaluate(combinationsResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testSiblingSelect() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "id_1",
                        'type: "id"
                    }
                ]
            },
            {
                column: [
                    {
                        path: "id",
                        name: "id_2",
                        'type: "id"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id_1": "pt1",
            "id_2": "pt1"
        },
        {
            "id_1": "pt2",
            "id_2": "pt2"
        },
        {
            "id_1": "pt3",
            "id_2": "pt3"
        }
    ];
    json[] result = check evaluate(combinationsResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testSiblingSelectInsideASelect() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                'select: [
                    {
                        column: [
                            {
                                path: "id",
                                name: "id_1",
                                'type: "id"
                            }
                        ]
                    },
                    {
                        column: [
                            {
                                path: "id",
                                name: "id_2",
                                'type: "id"
                            }
                        ]
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id_1": "pt1",
            "id_2": "pt1"
        },
        {
            "id_1": "pt2",
            "id_2": "pt2"
        },
        {
            "id_1": "pt3",
            "id_2": "pt3"
        }
    ];
    json[] result = check evaluate(combinationsResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testColumnSelectWithWhere() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "column_id",
                        'type: "id"
                    }
                ],
                'select: [
                    {
                        column: [
                            {
                                path: "id",
                                name: "select_id",
                                'type: "id"
                            }
                        ]
                    }
                ]
            }
        ],
        'where: [
            {
                path: "id = 'pt1'"
            }
        ]
    };
    json[] expected = [
        {
            "column_id": "pt1",
            "select_id": "pt1"
        }
    ];
    json[] result = check evaluate(combinationsResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testUnionallForeachColumnSelect() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
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
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1"
        },
        {
            "id": "pt2"
        },
        {
            "id": "pt3"
        }
    ];
    json[] result = check evaluate(combinationsResources, view);
    test:assertEquals(result, expected);}
