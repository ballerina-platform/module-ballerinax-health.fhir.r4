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

json[] unionResources = [
    {
        "resourceType": "Patient",
        "id": "pt1",
        "telecom": [
            {
                "value": "t1.1",
                "system": "phone"
            },
            {
                "value": "t1.2",
                "system": "fax"
            },
            {
                "value": "t1.3",
                "system": "email"
            }
        ],
        "contact": [
            {
                "telecom": [
                    {
                        "value": "t1.c1.1",
                        "system": "pager"
                    }
                ]
            },
            {
                "telecom": [
                    {
                        "value": "t1.c2.1",
                        "system": "url"
                    },
                    {
                        "value": "t1.c2.2",
                        "system": "sms"
                    }
                ]
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "pt2",
        "telecom": [
            {
                "value": "t2.1",
                "system": "phone"
            },
            {
                "value": "t2.2",
                "system": "fax"
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "pt3",
        "contact": [
            {
                "telecom": [
                    {
                        "value": "t3.c1.1",
                        "system": "email"
                    },
                    {
                        "value": "t3.c1.2",
                        "system": "pager"
                    }
                ]
            },
            {
                "telecom": [
                    {
                        "value": "t3.c2.1",
                        "system": "sms"
                    }
                ]
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "pt4"
    }
];


@test:Config {}
function testBasic2() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
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
                "unionAll": [
                    {
                        "forEach": "telecom",
                        "column": [
                            {
                                "name": "tel",
                                "path": "value",
                                "type": "string"
                            },
                            {
                                "name": "sys",
                                "path": "system",
                                "type": "code"
                            }
                        ]
                    },
                    {
                        "forEach": "contact.telecom",
                        "column": [
                            {
                                "name": "tel",
                                "path": "value",
                                "type": "string"
                            },
                            {
                                "name": "sys",
                                "path": "system",
                                "type": "code"
                            }
                        ]
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "tel": "t1.1",
            "sys": "phone",
            "id": "pt1"
        },
        {
            "tel": "t1.2",
            "sys": "fax",
            "id": "pt1"
        },
        {
            "tel": "t1.3",
            "sys": "email",
            "id": "pt1"
        },
        {
            "tel": "t1.c1.1",
            "sys": "pager",
            "id": "pt1"
        },
        {
            "tel": "t1.c2.1",
            "sys": "url",
            "id": "pt1"
        },
        {
            "tel": "t1.c2.2",
            "sys": "sms",
            "id": "pt1"
        },
        {
            "tel": "t2.1",
            "sys": "phone",
            "id": "pt2"
        },
        {
            "tel": "t2.2",
            "sys": "fax",
            "id": "pt2"
        },
        {
            "tel": "t3.c1.1",
            "sys": "email",
            "id": "pt3"
        },
        {
            "tel": "t3.c1.2",
            "sys": "pager",
            "id": "pt3"
        },
        {
            "tel": "t3.c2.1",
            "sys": "sms",
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
    check from record {} row in resultStream
        do {
            result.push(row.toJson());
        };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    check dbClient.close();
    assertResultsMatch(result, expected);
}

@test:Config {}
function testUnionallColumn() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
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
                ],
                "unionAll": [
                    {
                        "forEach": "telecom",
                        "column": [
                            {
                                "name": "tel",
                                "path": "value",
                                "type": "string"
                            },
                            {
                                "name": "sys",
                                "path": "system",
                                "type": "code"
                            }
                        ]
                    },
                    {
                        "forEach": "contact.telecom",
                        "column": [
                            {
                                "name": "tel",
                                "path": "value",
                                "type": "string"
                            },
                            {
                                "name": "sys",
                                "path": "system",
                                "type": "code"
                            }
                        ]
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "tel": "t1.1",
            "sys": "phone",
            "id": "pt1"
        },
        {
            "tel": "t1.2",
            "sys": "fax",
            "id": "pt1"
        },
        {
            "tel": "t1.3",
            "sys": "email",
            "id": "pt1"
        },
        {
            "tel": "t1.c1.1",
            "sys": "pager",
            "id": "pt1"
        },
        {
            "tel": "t1.c2.1",
            "sys": "url",
            "id": "pt1"
        },
        {
            "tel": "t1.c2.2",
            "sys": "sms",
            "id": "pt1"
        },
        {
            "tel": "t2.1",
            "sys": "phone",
            "id": "pt2"
        },
        {
            "tel": "t2.2",
            "sys": "fax",
            "id": "pt2"
        },
        {
            "tel": "t3.c1.1",
            "sys": "email",
            "id": "pt3"
        },
        {
            "tel": "t3.c1.2",
            "sys": "pager",
            "id": "pt3"
        },
        {
            "tel": "t3.c2.1",
            "sys": "sms",
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
    check from record {} row in resultStream
        do {
            result.push(row.toJson());
        };
    _ = check dbClient->execute(`DROP VIEW IF EXISTS sof_test_view`);
    check dbClient.close();
    assertResultsMatch(result, expected);
}

@test:Config {}
function testDuplicates() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
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
                ],
                "unionAll": [
                    {
                        "forEach": "telecom",
                        "column": [
                            {
                                "name": "tel",
                                "path": "value",
                                "type": "string"
                            },
                            {
                                "name": "sys",
                                "path": "system",
                                "type": "code"
                            }
                        ]
                    },
                    {
                        "forEach": "telecom",
                        "column": [
                            {
                                "name": "tel",
                                "path": "value",
                                "type": "string"
                            },
                            {
                                "name": "sys",
                                "path": "system",
                                "type": "code"
                            }
                        ]
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "tel": "t1.1",
            "sys": "phone",
            "id": "pt1"
        },
        {
            "tel": "t1.2",
            "sys": "fax",
            "id": "pt1"
        },
        {
            "tel": "t1.3",
            "sys": "email",
            "id": "pt1"
        },
        {
            "tel": "t1.1",
            "sys": "phone",
            "id": "pt1"
        },
        {
            "tel": "t1.2",
            "sys": "fax",
            "id": "pt1"
        },
        {
            "tel": "t1.3",
            "sys": "email",
            "id": "pt1"
        },
        {
            "tel": "t2.1",
            "sys": "phone",
            "id": "pt2"
        },
        {
            "tel": "t2.2",
            "sys": "fax",
            "id": "pt2"
        },
        {
            "tel": "t2.1",
            "sys": "phone",
            "id": "pt2"
        },
        {
            "tel": "t2.2",
            "sys": "fax",
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

@test:Config {}
function testEmptyResults() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
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
                ],
                "unionAll": [
                    {
                        "forEach": "name",
                        "column": [
                            {
                                "name": "given",
                                "path": "given",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "forEach": "name",
                        "column": [
                            {
                                "name": "given",
                                "path": "given",
                                "type": "string"
                            }
                        ]
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
    check dbClient.close();
    assertResultsMatch(result, expected);
}

@test:Config {}
function testEmptyWithForeachornull() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
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
                ],
                "unionAll": [
                    {
                        "forEachOrNull": "name",
                        "column": [
                            {
                                "name": "given",
                                "path": "given",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "forEachOrNull": "name",
                        "column": [
                            {
                                "name": "given",
                                "path": "given",
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
            "given": (),
            "id": "pt1"
        },
        {
            "given": (),
            "id": "pt1"
        },
        {
            "given": (),
            "id": "pt2"
        },
        {
            "given": (),
            "id": "pt2"
        },
        {
            "given": (),
            "id": "pt3"
        },
        {
            "given": (),
            "id": "pt3"
        },
        {
            "given": (),
            "id": "pt4"
        },
        {
            "given": (),
            "id": "pt4"
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

@test:Config {}
function testForeachornullAndForeach() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
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
                ],
                "unionAll": [
                    {
                        "forEach": "name",
                        "column": [
                            {
                                "name": "given",
                                "path": "given",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "forEachOrNull": "name",
                        "column": [
                            {
                                "name": "given",
                                "path": "given",
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
            "given": (),
            "id": "pt1"
        },
        {
            "given": (),
            "id": "pt2"
        },
        {
            "given": (),
            "id": "pt3"
        },
        {
            "given": (),
            "id": "pt4"
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
function testNested() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
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
                ],
                "unionAll": [
                    {
                        "forEach": "telecom[0]",
                        "column": [
                            {
                                "name": "tel",
                                "path": "value",
                                "type": "string"
                            }
                        ]
                    },
                    {
                        "unionAll": [
                            {
                                "forEach": "telecom[0]",
                                "column": [
                                    {
                                        "name": "tel",
                                        "path": "value",
                                        "type": "string"
                                    }
                                ]
                            },
                            {
                                "forEach": "contact.telecom[0]",
                                "column": [
                                    {
                                        "name": "tel",
                                        "path": "value",
                                        "type": "string"
                                    }
                                ]
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
            "tel": "t1.1"
        },
        {
            "id": "pt1",
            "tel": "t1.1"
        },
        {
            "id": "pt1",
            "tel": "t1.c1.1"
        },
        {
            "id": "pt2",
            "tel": "t2.1"
        },
        {
            "id": "pt2",
            "tel": "t2.1"
        },
        {
            "id": "pt3",
            "tel": "t3.c1.1"
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

@test:Config {}
function testOneEmptyOperand() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
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
                "unionAll": [
                    {
                        "forEach": "telecom.where(false)",
                        "column": [
                            {
                                "name": "tel",
                                "path": "value",
                                "type": "string"
                            },
                            {
                                "name": "sys",
                                "path": "system",
                                "type": "code"
                            }
                        ]
                    },
                    {
                        "forEach": "contact.telecom",
                        "column": [
                            {
                                "name": "tel",
                                "path": "value",
                                "type": "string"
                            },
                            {
                                "name": "sys",
                                "path": "system",
                                "type": "code"
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
            "sys": "pager",
            "tel": "t1.c1.1"
        },
        {
            "id": "pt1",
            "sys": "url",
            "tel": "t1.c2.1"
        },
        {
            "id": "pt1",
            "sys": "sms",
            "tel": "t1.c2.2"
        },
        {
            "id": "pt3",
            "sys": "email",
            "tel": "t3.c1.1"
        },
        {
            "id": "pt3",
            "sys": "pager",
            "tel": "t3.c1.2"
        },
        {
            "id": "pt3",
            "sys": "sms",
            "tel": "t3.c2.1"
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
function testColumnMismatch() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "select": [
            {
                "unionAll": [
                    {
                        "column": [
                            {
                                "name": "a",
                                "path": "id",
                                "type": "id"
                            },
                            {
                                "name": "b",
                                "path": "id",
                                "type": "id"
                            }
                        ]
                    },
                    {
                        "column": [
                            {
                                "name": "a",
                                "path": "id",
                                "type": "id"
                            },
                            {
                                "name": "c",
                                "path": "id",
                                "type": "id"
                            }
                        ]
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
    test:assertTrue(queryResult is error, msg = "Expected an error for: column mismatch");
    check dbClient.close();
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testColumnOrderMismatch() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in unionResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "select": [
            {
                "unionAll": [
                    {
                        "column": [
                            {
                                "name": "a",
                                "path": "id",
                                "type": "id"
                            },
                            {
                                "name": "b",
                                "path": "id",
                                "type": "id"
                            }
                        ]
                    },
                    {
                        "column": [
                            {
                                "name": "b",
                                "path": "id",
                                "type": "id"
                            },
                            {
                                "name": "a",
                                "path": "id",
                                "type": "id"
                            }
                        ]
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
    test:assertTrue(queryResult is error, msg = "Expected an error for: column order mismatch");
    check dbClient.close();
}
