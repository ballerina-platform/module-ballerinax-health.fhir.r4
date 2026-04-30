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

json[] collectionResources = [
    {
        "resourceType": "Patient",
        "id": "pt1",
        "name": [
            {
                "use": "official",
                "family": "f1.1",
                "given": [
                    "g1.1"
                ]
            },
            {
                "family": "f1.2",
                "given": [
                    "g1.2",
                    "g1.3"
                ]
            }
        ],
        "gender": "male",
        "birthDate": "1950-01-01",
        "address": [
            {
                "city": "c1"
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "pt2",
        "name": [
            {
                "family": "f2.1",
                "given": [
                    "g2.1"
                ]
            },
            {
                "use": "official",
                "family": "f2.2",
                "given": [
                    "g2.2",
                    "g2.3"
                ]
            }
        ],
        "gender": "female",
        "birthDate": "1950-01-01"
    }
];

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testFailWhenCollectionIsNotTrue() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in collectionResources {
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
                        "path": "name.family",
                        "type": "string",
                        "collection": false
                    },
                    {
                        "name": "first_name",
                        "path": "name.given",
                        "type": "string",
                        "collection": true
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
    test:assertTrue(queryResult is error, msg = "Expected an error for: fail when 'collection' is not true");
    check dbClient.close();
}

// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testCollectionTrue() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in collectionResources {
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
                        "path": "name.family",
                        "type": "string",
                        "collection": true
                    },
                    {
                        "name": "first_name",
                        "path": "name.given",
                        "type": "string",
                        "collection": true
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "last_name": [
                "f1.1",
                "f1.2"
            ],
            "first_name": [
                "g1.1",
                "g1.2",
                "g1.3"
            ]
        },
        {
            "id": "pt2",
            "last_name": [
                "f2.1",
                "f2.2"
            ],
            "first_name": [
                "g2.1",
                "g2.2",
                "g2.3"
            ]
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
function testCollectionFalseRelativeToForeachParent() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in collectionResources {
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
                "select": [
                    {
                        "forEach": "name",
                        "column": [
                            {
                                "name": "last_name",
                                "path": "family",
                                "type": "string",
                                "collection": false
                            },
                            {
                                "name": "first_name",
                                "path": "given",
                                "type": "string",
                                "collection": true
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
            "last_name": "f1.1",
            "first_name": [
                "g1.1"
            ]
        },
        {
            "id": "pt1",
            "last_name": "f1.2",
            "first_name": [
                "g1.2",
                "g1.3"
            ]
        },
        {
            "id": "pt2",
            "last_name": "f2.1",
            "first_name": [
                "g2.1"
            ]
        },
        {
            "id": "pt2",
            "last_name": "f2.2",
            "first_name": [
                "g2.2",
                "g2.3"
            ]
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
function testCollectionFalseRelativeToForeachornullParent() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS PatientTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM PatientTable`);
    foreach json r in collectionResources {
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
                "select": [
                    {
                        "forEachOrNull": "name",
                        "column": [
                            {
                                "name": "last_name",
                                "path": "family",
                                "type": "string",
                                "collection": false
                            },
                            {
                                "name": "first_name",
                                "path": "given",
                                "type": "string",
                                "collection": true
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
            "last_name": "f1.1",
            "first_name": [
                "g1.1"
            ]
        },
        {
            "id": "pt1",
            "last_name": "f1.2",
            "first_name": [
                "g1.2",
                "g1.3"
            ]
        },
        {
            "id": "pt2",
            "last_name": "f2.1",
            "first_name": [
                "g2.1"
            ]
        },
        {
            "id": "pt2",
            "last_name": "f2.2",
            "first_name": [
                "g2.2",
                "g2.3"
            ]
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
