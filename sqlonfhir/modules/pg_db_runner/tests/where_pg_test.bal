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

json[] whereResources = [
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
        "id": "p2",
        "name": [
            {
                "use": "nickname",
                "family": "f2"
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "p3",
        "name": [
            {
                "use": "nickname",
                "given": [
                    "g3"
                ],
                "family": "f3"
            }
        ]
    },
    {
        "resourceType": "Observation",
        "id": "o1",
        "valueInteger": 12
    },
    {
        "resourceType": "Observation",
        "id": "o2",
        "valueInteger": 10
    }
];


@test:Config {}
function testSimpleWherePathWithResult() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in whereResources {
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
                        "name": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "name.where(use = 'official').exists()"
            }
        ]
    };
    json[] expected = [
        {
            "id": "p1"
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
function testWherePathWithNoResults() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in whereResources {
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
                        "name": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "name.where(use = 'maiden').exists()"
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

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testWherePathWithGreaterThanInequality() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in whereResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Observation",
        "status": "active",
        "select": [
            {
                "column": [
                    {
                        "path": "id",
                        "name": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "where(value.ofType(integer) > 11).exists()"
            }
        ]
    };
    json[] expected = [
        {
            "id": "o1"
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
function testWherePathWithLessThanInequality() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in whereResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO PatientTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Observation",
        "status": "active",
        "select": [
            {
                "column": [
                    {
                        "path": "id",
                        "name": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "where(value.ofType(integer) < 11).exists()"
            }
        ]
    };
    json[] expected = [
        {
            "id": "o2"
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
function testMultipleWherePaths() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in whereResources {
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
                        "name": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "name.where(use = 'official').exists()"
            },
            {
                "path": "name.where(family = 'f1').exists()"
            }
        ]
    };
    json[] expected = [
        {
            "id": "p1"
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
function testWherePathWithAnAndConnector() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in whereResources {
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
                        "name": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "name.where(use = 'official' and family = 'f1').exists()"
            }
        ]
    };
    json[] expected = [
        {
            "id": "p1"
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
function testWherePathWithAnOrConnector() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in whereResources {
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
                        "name": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "name.where(use = 'official' or family = 'f2').exists()"
            }
        ]
    };
    json[] expected = [
        {
            "id": "p1"
        },
        {
            "id": "p2"
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
function testWherePathThatEvaluatesToTrueWhenEmpty() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in whereResources {
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
                        "name": "id",
                        "type": "id"
                    }
                ]
            }
        ],
        "where": [
            {
                "path": "name.where(family = 'f2').empty()"
            }
        ]
    };
    json[] expected = [
        {
            "id": "p1"
        },
        {
            "id": "p3"
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
