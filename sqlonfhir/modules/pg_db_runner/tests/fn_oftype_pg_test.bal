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

json[] fnOftypeResources = [
    {
        "resourceType": "Observation",
        "id": "o1",
        "code": {
            "text": "code"
        },
        "status": "final",
        "valueString": "foo"
    },
    {
        "resourceType": "Observation",
        "id": "o2",
        "code": {
            "text": "code"
        },
        "status": "final",
        "valueInteger": 42
    },
    {
        "resourceType": "Observation",
        "id": "o3",
        "code": {
            "text": "code"
        },
        "status": "final"
    }
];


@test:Config {}
function testSelectStringValues() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS ObservationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM ObservationTable`);
    foreach json r in fnOftypeResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO ObservationTable (resource_json) VALUES (${rStr}::jsonb)`);
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
                    },
                    {
                        "path": "value.ofType(string)",
                        "name": "string_value",
                        "type": "string"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "o1",
            "string_value": "foo"
        },
        {
            "id": "o2",
            "string_value": ()
        },
        {
            "id": "o3",
            "string_value": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "ObservationTable"
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
function testSelectIntegerValues() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS ObservationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM ObservationTable`);
    foreach json r in fnOftypeResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO ObservationTable (resource_json) VALUES (${rStr}::jsonb)`);
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
                    },
                    {
                        "path": "value.ofType(integer)",
                        "name": "integer_value",
                        "type": "integer"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "o1",
            "integer_value": ()
        },
        {
            "id": "o2",
            "integer_value": 42
        },
        {
            "id": "o3",
            "integer_value": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "ObservationTable"
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
