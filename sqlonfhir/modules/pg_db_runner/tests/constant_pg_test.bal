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
import ballerina/sql;
import ballerina/test;
import ballerinax/postgresql;

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


// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testConstantInPath() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in constantResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "name_use",
                "valueString": "official"
            }
        ],
        "select": [
            {
                "column": [
                    {
                        "name": "id",
                        "path": "id",
                        "type": "id"
                    },
                    {
                        "name": "official_name",
                        "path": "name.where(use = %name_use).family",
                        "type": "string"
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
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "PatientTable"
    };
    string viewSql = check generateQuery(viewJson, ctx);
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    _ = check dbClient->execute(new DynamicQuery("CREATE VIEW sof_test_view AS " + viewSql));
    stream<record {}, sql:Error?> resultStream = dbClient->query(`SELECT * FROM sof_test_view`);
    json[] result = [];
    check from record {} row in resultStream
        do {
            result.push(row.toJson());
        };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    check dbClient.close();
    assertResultsMatch(result, expected);
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testConstantInForeach() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in constantResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "name_use",
                "valueString": "official"
            }
        ],
        "select": [
            {
                "forEach": "name.where(use = %name_use)",
                "column": [
                    {
                        "name": "official_name",
                        "path": "family",
                        "type": "string"
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
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "PatientTable"
    };
    string viewSql = check generateQuery(viewJson, ctx);
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    _ = check dbClient->execute(new DynamicQuery("CREATE VIEW sof_test_view AS " + viewSql));
    stream<record {}, sql:Error?> resultStream = dbClient->query(`SELECT * FROM sof_test_view`);
    json[] result = [];
    check from record {} row in resultStream
        do {
            result.push(row.toJson());
        };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    check dbClient.close();
    assertResultsMatch(result, expected);
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testConstantInWhereElement() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in constantResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "name_use",
                "valueString": "official"
            }
        ],
        "select": [
            {
                "column": [
                    {
                        "name": "id",
                        "path": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "name.where(use = %name_use).exists()"
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1"
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "PatientTable"
    };
    string viewSql = check generateQuery(viewJson, ctx);
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    _ = check dbClient->execute(new DynamicQuery("CREATE VIEW sof_test_view AS " + viewSql));
    stream<record {}, sql:Error?> resultStream = dbClient->query(`SELECT * FROM sof_test_view`);
    json[] result = [];
    check from record {} row in resultStream
        do {
            result.push(row.toJson());
        };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    check dbClient.close();
    assertResultsMatch(result, expected);
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testConstantInUnionall() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in constantResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "use1",
                "valueString": "official"
            },
            {
                "name": "use2",
                "valueString": "usual"
            }
        ],
        "select": [
            {
                "unionAll": [
                    {
                        "forEach": "name.where(use = %use1)",
                        "column": [
                            {
                                "name": "name",
                                "path": "family",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "forEach": "name.where(use = %use2)",
                        "column": [
                            {
                                "name": "name",
                                "path": "family",
                                "type": "string"
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
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "PatientTable"
    };
    string viewSql = check generateQuery(viewJson, ctx);
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    _ = check dbClient->execute(new DynamicQuery("CREATE VIEW sof_test_view AS " + viewSql));
    stream<record {}, sql:Error?> resultStream = dbClient->query(`SELECT * FROM sof_test_view`);
    json[] result = [];
    check from record {} row in resultStream
        do {
            result.push(row.toJson());
        };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    check dbClient.close();
    assertResultsMatch(result, expected);
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testIntegerConstant() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in constantResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "name_index",
                "valueInteger": 1
            }
        ],
        "select": [
            {
                "column": [
                    {
                        "name": "id",
                        "path": "id",
                        "type": "id"
                    },
                    {
                        "name": "official_name",
                        "path": "name[%name_index].family",
                        "type": "string"
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
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "PatientTable"
    };
    string viewSql = check generateQuery(viewJson, ctx);
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    _ = check dbClient->execute(new DynamicQuery("CREATE VIEW sof_test_view AS " + viewSql));
    stream<record {}, sql:Error?> resultStream = dbClient->query(`SELECT * FROM sof_test_view`);
    json[] result = [];
    check from record {} row in resultStream
        do {
            result.push(row.toJson());
        };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    check dbClient.close();
    assertResultsMatch(result, expected);
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testBooleanConstant() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in constantResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "is_deceased",
                "valueBoolean": true
            }
        ],
        "select": [
            {
                "column": [
                    {
                        "name": "id",
                        "path": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "deceased.ofType(boolean).exists() and deceased.ofType(boolean) = %is_deceased"
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt2"
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "PatientTable"
    };
    string viewSql = check generateQuery(viewJson, ctx);
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    _ = check dbClient->execute(new DynamicQuery("CREATE VIEW sof_test_view AS " + viewSql));
    stream<record {}, sql:Error?> resultStream = dbClient->query(`SELECT * FROM sof_test_view`);
    json[] result = [];
    check from record {} row in resultStream
        do {
            result.push(row.toJson());
        };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    check dbClient.close();
    assertResultsMatch(result, expected);
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testAccessingAnUndefinedConstant() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in constantResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "name_use",
                "valueString": "official"
            }
        ],
        "select": [
            {
                "forEach": "name.where(use = %wrong_name)",
                "column": [
                    {
                        "name": "official_name",
                        "path": "family",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "PatientTable"
    };
    string|error queryResult = generateQuery(viewJson, ctx);
    test:assertTrue(queryResult is error, msg = "Expected an error for: accessing an undefined constant");
    check dbClient.close();
}

@test:Config {}
function testIncorrectConstantDefinition() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in constantResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "name_use"
            }
        ],
        "select": [
            {
                "column": [
                    {
                        "name": "id",
                        "path": "id",
                        "type": "id"
                    },
                    {
                        "name": "official_name",
                        "path": "name.where(use = %name_use).family",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "PatientTable"
    };
    string|error queryResult = generateQuery(viewJson, ctx);
    test:assertTrue(queryResult is error, msg = "Expected an error for: incorrect constant definition");
    check dbClient.close();
}
