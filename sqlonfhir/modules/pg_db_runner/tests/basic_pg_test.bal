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
import ballerina/sql;
import ballerinax/postgresql;

json[] basicResources = [
    {
        "resourceType": "Patient",
        "id": "pt1",
        "name": [
            {
                "family": "F1"
            }
        ],
        "active": true
    },
    {
        "resourceType": "Patient",
        "id": "pt2",
        "name": [
            {
                "family": "F2"
            }
        ],
        "active": false
    },
    {
        "resourceType": "Patient",
        "id": "pt3"
    }
];


@test:Config {}
function testBasicAttribute() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
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
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "PatientTable"
    };
    string viewSql = check generateQuery(viewJson, ctx);
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    _ = check dbClient->execute(new DynamicQuery("CREATE VIEW sof_test_view AS " + viewSql));
    stream<record {}, sql:Error?> resultStream = dbClient->query(`SELECT * FROM sof_test_view`);
    json[] result = [];
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testBooleanAttributeWithFalse() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "select": [
            {
                "column": [
                    {
                        "name": "id",
                        "path": "id",
                        "type": "id"
                    },
                    {
                        "name": "active",
                        "path": "active",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "active": true
        },
        {
            "id": "pt2",
            "active": false
        },
        {
            "id": "pt3",
            "active": ()
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testTwoColumns() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "select": [
            {
                "column": [
                    {
                        "name": "id",
                        "path": "id",
                        "type": "id"
                    },
                    {
                        "name": "last_name",
                        "path": "name.family.first()",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "last_name": "F1"
        },
        {
            "id": "pt2",
            "last_name": "F2"
        },
        {
            "id": "pt3",
            "last_name": ()
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testTwoSelectsWithColumns() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "select": [
            {
                "column": [
                    {
                        "name": "id",
                        "path": "id",
                        "type": "id"
                    }
                ]
            },
            {
                "column": [
                    {
                        "name": "last_name",
                        "path": "name.family.first()",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "last_name": "F1"
        },
        {
            "id": "pt2",
            "last_name": "F2"
        },
        {
            "id": "pt3",
            "last_name": ()
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testWhere1() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
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
                "path": "active.exists() and active = true"
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testWhere2() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
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
                "path": "active.exists() and active = false"
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testWhereReturnsNonBooleanForSomeCases() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
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
                "path": "active"
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testWhereAsExpr1() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
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
                "path": "name.family.exists() and name.family = 'F2'"
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testWhereAsExpr2() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
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
                "path": "name.family.exists() and name.family = 'F1'"
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testSelectColumn() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "select": [
            {
                "column": [
                    {
                        "path": "id",
                        "name": "c_id",
                        "type": "id"
                    }
                ],
                "select": [
                    {
                        "column": [
                            {
                                "path": "id",
                                "name": "s_id",
                                "type": "id"
                            }
                        ]
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "c_id": "pt1",
            "s_id": "pt1"
        },
        {
            "c_id": "pt2",
            "s_id": "pt2"
        },
        {
            "c_id": "pt3",
            "s_id": "pt3"
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testColumnOrdering() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in basicResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "select": [
            {
                "column": [
                    {
                        "path": "'A'",
                        "name": "a",
                        "type": "string"
                    },
                    {
                        "path": "'B'",
                        "name": "b",
                        "type": "string"
                    }
                ],
                "select": [
                    {
                        "forEach": "name",
                        "column": [
                            {
                                "path": "'C'",
                                "name": "c",
                                "type": "string"
                            },
                            {
                                "path": "'D'",
                                "name": "d",
                                "type": "string"
                            }
                        ]
                    }
                ],
                "unionAll": [
                    {
                        "column": [
                            {
                                "path": "'E1'",
                                "name": "e",
                                "type": "string"
                            },
                            {
                                "path": "'F1'",
                                "name": "f",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "column": [
                            {
                                "path": "'E2'",
                                "name": "e",
                                "type": "string"
                            },
                            {
                                "path": "'F2'",
                                "name": "f",
                                "type": "string"
                            }
                        ]
                    }
                ]
            },
            {
                "column": [
                    {
                        "path": "'G'",
                        "name": "g",
                        "type": "string"
                    },
                    {
                        "path": "'H'",
                        "name": "h",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "a": "A",
            "b": "B",
            "c": "C",
            "d": "D",
            "e": "E1",
            "f": "F1",
            "g": "G",
            "h": "H"
        },
        {
            "a": "A",
            "b": "B",
            "c": "C",
            "d": "D",
            "e": "E2",
            "f": "F2",
            "g": "G",
            "h": "H"
        },
        {
            "a": "A",
            "b": "B",
            "c": "C",
            "d": "D",
            "e": "E1",
            "f": "F1",
            "g": "G",
            "h": "H"
        },
        {
            "a": "A",
            "b": "B",
            "c": "C",
            "d": "D",
            "e": "E2",
            "f": "F2",
            "g": "G",
            "h": "H"
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
    check from record {} row in resultStream do {
        result.push(row.toJson());
    };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    assertResultsMatch(result, expected);
    check dbClient.close();
}
