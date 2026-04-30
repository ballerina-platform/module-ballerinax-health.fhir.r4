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

json[] constantResources = [
    {
        "resourceType": "Patient",
        "id": "pt1",
        "name": [
            {
                "family": "Block",
                "use": "usual"
            },
            {
                "family": "Smith",
                "use": "official"
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "pt2",
        "deceasedBoolean": true,
        "name": [
            {
                "family": "Johnson",
                "use": "usual"
            },
            {
                "family": "Menendez",
                "use": "old"
            }
        ]
    }
];


@test:Config {}
function testConstantInPath() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        constant: [
            {
                name: "name_use",
                valueString: "official"
            }
        ],
        'select: [
            {
                column: [
                    {
                        name: "id",
                        path: "id",
                        'type: "id"
                    },
                    {
                        name: "official_name",
                        path: "name.where(use = %name_use).family",
                        'type: "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "official_name": "Smith"
        },
        {
            "id": "pt2",
            "official_name": ()
        }
    ];
    json[] result = check evaluate(constantResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testConstantInForeach() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        constant: [
            {
                name: "name_use",
                valueString: "official"
            }
        ],
        'select: [
            {
                forEach: "name.where(use = %name_use)",
                column: [
                    {
                        name: "official_name",
                        path: "family",
                        'type: "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "official_name": "Smith"
        }
    ];
    json[] result = check evaluate(constantResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testConstantInWhereElement() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        constant: [
            {
                name: "name_use",
                valueString: "official"
            }
        ],
        'select: [
            {
                column: [
                    {
                        name: "id",
                        path: "id",
                        'type: "id"
                    }
                ]
            }
        ],
        'where: [
            {
                path: "name.where(use = %name_use).exists()"
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1"
        }
    ];
    json[] result = check evaluate(constantResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testConstantInUnionall() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        constant: [
            {
                name: "use1",
                valueString: "official"
            },
            {
                name: "use2",
                valueString: "usual"
            }
        ],
        'select: [
            {
                unionAll: [
                    {
                        forEach: "name.where(use = %use1)",
                        column: [
                            {
                                name: "name",
                                path: "family",
                                'type: "string"
                            }
                        ]
                    },
                    {
                        forEach: "name.where(use = %use2)",
                        column: [
                            {
                                name: "name",
                                path: "family",
                                'type: "string"
                            }
                        ]
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "name": "Smith"
        },
        {
            "name": "Block"
        },
        {
            "name": "Johnson"
        }
    ];
    json[] result = check evaluate(constantResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testIntegerConstant() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        constant: [
            {
                name: "name_index",
                valueInteger: 1
            }
        ],
        'select: [
            {
                column: [
                    {
                        name: "id",
                        path: "id",
                        'type: "id"
                    },
                    {
                        name: "official_name",
                        path: "name[%name_index].family",
                        'type: "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "official_name": "Smith"
        },
        {
            "id": "pt2",
            "official_name": "Menendez"
        }
    ];
    json[] result = check evaluate(constantResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testBooleanConstant() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        constant: [
            {
                name: "is_deceased",
                valueBoolean: true
            }
        ],
        'select: [
            {
                column: [
                    {
                        name: "id",
                        path: "id",
                        'type: "id"
                    }
                ]
            }
        ],
        'where: [
            {
                path: "deceased.ofType(boolean).exists() and deceased.ofType(boolean) = %is_deceased"
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt2"
        }
    ];
    json[] result = check evaluate(constantResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testAccessingAnUndefinedConstant() {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        constant: [
            {
                name: "name_use",
                valueString: "official"
            }
        ],
        'select: [
            {
                forEach: "name.where(use = %wrong_name)",
                column: [
                    {
                        name: "official_name",
                        path: "family",
                        'type: "string"
                    }
                ]
            }
        ]
    };
    json[]|error result = evaluate(constantResources, view);
    test:assertTrue(result is error, msg = "Expected an error for: accessing an undefined constant");
}

@test:Config {}
function testIncorrectConstantDefinition() {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        constant: [
            {
                name: "name_use"
            }
        ],
        'select: [
            {
                column: [
                    {
                        name: "id",
                        path: "id",
                        'type: "id"
                    },
                    {
                        name: "official_name",
                        path: "name.where(use = %name_use).family",
                        'type: "string"
                    }
                ]
            }
        ]
    };
    json[]|error result = evaluate(constantResources, view);
    test:assertTrue(result is error, msg = "Expected an error for: incorrect constant definition");
}
