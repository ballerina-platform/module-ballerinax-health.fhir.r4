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

json[] foreachResources = [
    {
        "resourceType": "Patient",
        "id": "pt1",
        "name": [
            {
                "family": "F1.1"
            },
            {
                "family": "F1.2"
            }
        ],
        "contact": [
            {
                "telecom": [
                    {
                        "system": "phone"
                    }
                ],
                "name": {
                    "family": "FC1.1",
                    "given": [
                        "N1",
                        "N1`"
                    ]
                }
            },
            {
                "telecom": [
                    {
                        "system": "email"
                    }
                ],
                "gender": "unknown",
                "name": {
                    "family": "FC1.2",
                    "given": [
                        "N2"
                    ]
                }
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "pt2",
        "name": [
            {
                "family": "F2.1"
            },
            {
                "family": "F2.2"
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "pt3"
    }
];

@test:Config {}
function testForeachNormal() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
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
                "forEach": "name",
                "column": [
                    {
                        "name": "family",
                        "path": "family",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "family": "F1.1"
        },
        {
            "id": "pt1",
            "family": "F1.2"
        },
        {
            "id": "pt2",
            "family": "F2.1"
        },
        {
            "id": "pt2",
            "family": "F2.2"
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testForeachornullBasic() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
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
                "forEachOrNull": "name",
                "column": [
                    {
                        "name": "family",
                        "path": "family",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "family": "F1.1"
        },
        {
            "id": "pt1",
            "family": "F1.2"
        },
        {
            "id": "pt2",
            "family": "F2.1"
        },
        {
            "id": "pt2",
            "family": "F2.2"
        },
        {
            "id": "pt3",
            "family": ()
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testForeachEmpty() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
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
                "forEach": "identifier",
                "column": [
                    {
                        "name": "value",
                        "path": "value",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [];
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testForeachTwoOnTheSameLevel() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "select": [
            {
                "forEach": "contact",
                "column": [
                    {
                        "name": "cont_family",
                        "path": "name.family",
                        "type": "string"
                    }
                ]
            },
            {
                "forEach": "name",
                "column": [
                    {
                        "name": "pat_family",
                        "path": "family",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "pat_family": "F1.1",
            "cont_family": "FC1.1"
        },
        {
            "pat_family": "F1.1",
            "cont_family": "FC1.2"
        },
        {
            "pat_family": "F1.2",
            "cont_family": "FC1.1"
        },
        {
            "pat_family": "F1.2",
            "cont_family": "FC1.2"
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testForeachTwoOnTheSameLevelEmptyResult() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
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
                "forEach": "identifier",
                "column": [
                    {
                        "name": "value",
                        "path": "value",
                        "type": "string"
                    }
                ]
            },
            {
                "forEach": "name",
                "column": [
                    {
                        "name": "family",
                        "path": "family",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [];
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testForeachornullNullCase() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
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
                "forEachOrNull": "identifier",
                "column": [
                    {
                        "name": "value",
                        "path": "value",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "value": ()
        },
        {
            "id": "pt2",
            "value": ()
        },
        {
            "id": "pt3",
            "value": ()
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

@test:Config {}
function testForeachAndForeachornullOnTheSameLevel() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
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
                "forEachOrNull": "identifier",
                "column": [
                    {
                        "name": "value",
                        "path": "value",
                        "type": "string"
                    }
                ]
            },
            {
                "forEach": "name",
                "column": [
                    {
                        "name": "family",
                        "path": "family",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "family": "F1.1",
            "value": ()
        },
        {
            "id": "pt1",
            "family": "F1.2",
            "value": ()
        },
        {
            "id": "pt2",
            "family": "F2.1",
            "value": ()
        },
        {
            "id": "pt2",
            "family": "F2.2",
            "value": ()
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testNestedForeach() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
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
                "forEach": "contact",
                "select": [
                    {
                        "column": [
                            {
                                "name": "contact_type",
                                "path": "telecom.system",
                                "type": "code"
                            }
                        ]
                    },
                    {
                        "forEach": "name.given",
                        "column": [
                            {
                                "name": "name",
                                "path": "$this",
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
            "contact_type": "phone",
            "name": "N1",
            "id": "pt1"
        },
        {
            "contact_type": "phone",
            "name": "N1`",
            "id": "pt1"
        },
        {
            "contact_type": "email",
            "name": "N2",
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testNestedForeachSelectColumn() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
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
                "forEach": "contact",
                "column": [
                    {
                        "name": "contact_type",
                        "path": "telecom.system",
                        "type": "code"
                    }
                ],
                "select": [
                    {
                        "forEach": "name.given",
                        "column": [
                            {
                                "name": "name",
                                "path": "$this",
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
            "contact_type": "phone",
            "name": "N1",
            "id": "pt1"
        },
        {
            "contact_type": "phone",
            "name": "N1`",
            "id": "pt1"
        },
        {
            "contact_type": "email",
            "name": "N2",
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
    test:assertEquals(result.length(), expected.length(), msg = "Row count mismatch");
    json[] remaining = result.clone();
    foreach json expectedRow in expected {
        int? idx = remaining.indexOf(expectedRow);
        if idx is () {
            test:assertFail(string `Expected row not found in result: ${expectedRow.toJsonString()}`);
        }
        _ = remaining.remove(<int>idx);
    }
    check dbClient.close();
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testForeachornullUnionallOnTheSameLevel() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "select": [
            {
                "column": [
                    {
                        "path": "id",
                        "name": "id",
                        "type": "id"
                    }
                ]
            },
            {
                "forEachOrNull": "contact",
                "unionAll": [
                    {
                        "column": [
                            {
                                "path": "name.family",
                                "name": "name",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "forEach": "name.given",
                        "column": [
                            {
                                "path": "$this",
                                "name": "name",
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
            "id": "pt1",
            "name": "FC1.1"
        },
        {
            "id": "pt1",
            "name": "N1"
        },
        {
            "id": "pt1",
            "name": "N1`"
        },
        {
            "id": "pt1",
            "name": "FC1.2"
        },
        {
            "id": "pt1",
            "name": "N2"
        },
        {
            "id": "pt2",
            "name": ()
        },
        {
            "id": "pt3",
            "name": ()
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testForeachUnionallOnTheSameLevel() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "select": [
            {
                "column": [
                    {
                        "path": "id",
                        "name": "id",
                        "type": "id"
                    }
                ]
            },
            {
                "forEach": "contact",
                "unionAll": [
                    {
                        "column": [
                            {
                                "path": "name.family",
                                "name": "name",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "forEach": "name.given",
                        "column": [
                            {
                                "path": "$this",
                                "name": "name",
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
            "id": "pt1",
            "name": "FC1.1"
        },
        {
            "id": "pt1",
            "name": "N1"
        },
        {
            "id": "pt1",
            "name": "N1`"
        },
        {
            "id": "pt1",
            "name": "FC1.2"
        },
        {
            "id": "pt1",
            "name": "N2"
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testForeachUnionallColumnSelectOnTheSameLevel() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "select": [
            {
                "column": [
                    {
                        "path": "id",
                        "name": "id",
                        "type": "id"
                    }
                ]
            },
            {
                "forEach": "contact",
                "column": [
                    {
                        "path": "telecom.system",
                        "name": "tel_system",
                        "type": "code"
                    }
                ],
                "select": [
                    {
                        "column": [
                            {
                                "path": "gender",
                                "name": "gender",
                                "type": "code"
                            }
                        ]
                    }
                ],
                "unionAll": [
                    {
                        "column": [
                            {
                                "path": "name.family",
                                "name": "name",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "forEach": "name.given",
                        "column": [
                            {
                                "path": "$this",
                                "name": "name",
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
            "id": "pt1",
            "name": "FC1.1",
            "tel_system": "phone",
            "gender": ()
        },
        {
            "id": "pt1",
            "name": "N1",
            "tel_system": "phone",
            "gender": ()
        },
        {
            "id": "pt1",
            "name": "N1`",
            "tel_system": "phone",
            "gender": ()
        },
        {
            "id": "pt1",
            "name": "FC1.2",
            "tel_system": "email",
            "gender": "unknown"
        },
        {
            "id": "pt1",
            "name": "N2",
            "tel_system": "email",
            "gender": "unknown"
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testForeachornullUnionallColumnSelectOnTheSameLevel() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in foreachResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "select": [
            {
                "column": [
                    {
                        "path": "id",
                        "name": "id",
                        "type": "id"
                    }
                ]
            },
            {
                "forEachOrNull": "contact",
                "column": [
                    {
                        "path": "telecom.system",
                        "name": "tel_system",
                        "type": "code"
                    }
                ],
                "select": [
                    {
                        "column": [
                            {
                                "path": "gender",
                                "name": "gender",
                                "type": "code"
                            }
                        ]
                    }
                ],
                "unionAll": [
                    {
                        "column": [
                            {
                                "path": "name.family",
                                "name": "name",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "forEach": "name.given",
                        "column": [
                            {
                                "path": "$this",
                                "name": "name",
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
            "id": "pt1",
            "name": "FC1.1",
            "tel_system": "phone",
            "gender": ()
        },
        {
            "id": "pt1",
            "name": "N1",
            "tel_system": "phone",
            "gender": ()
        },
        {
            "id": "pt1",
            "name": "N1`",
            "tel_system": "phone",
            "gender": ()
        },
        {
            "id": "pt1",
            "name": "FC1.2",
            "tel_system": "email",
            "gender": "unknown"
        },
        {
            "id": "pt1",
            "name": "N2",
            "tel_system": "email",
            "gender": "unknown"
        },
        {
            "id": "pt2",
            "name": (),
            "tel_system": (),
            "gender": ()
        },
        {
            "id": "pt3",
            "name": (),
            "tel_system": (),
            "gender": ()
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
    assertResultsMatch(result, expected);
    check dbClient.close();
}
