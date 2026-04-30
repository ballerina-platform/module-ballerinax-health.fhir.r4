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

json[] constantTypesResources = [
    {
        "resourceType": "Organization",
        "name": "o1",
        "id": "o1"
    },
    {
        "resourceType": "Device",
        "id": "d1",
        "udiCarrier": [
            {
                "carrierAIDC": "aGVsbG8K"
            }
        ]
    },
    {
        "resourceType": "Device",
        "id": "d2",
        "udiCarrier": [
            {
                "carrierAIDC": "YnllCg=="
            }
        ]
    },
    {
        "resourceType": "Device",
        "id": "d3"
    },
    {
        "resourceType": "Patient",
        "id": "pt1",
        "gender": "female",
        "birthDate": "1978-03-12"
    },
    {
        "resourceType": "Patient",
        "id": "pt2",
        "gender": "male",
        "birthDate": "1941-09-09"
    },
    {
        "resourceType": "Patient",
        "id": "pt3"
    },
    {
        "resourceType": "ClaimResponse",
        "id": "cr1",
        "use": "claim",
        "patient": {
            "reference": "Patient/p1"
        },
        "created": "2021-09-02",
        "insurer": {
            "reference": "Organization/o1"
        },
        "type": {
            "text": "type"
        },
        "outcome": "complete",
        "status": "active",
        "item": [
            {
                "itemSequence": 1,
                "adjudication": [
                    {
                        "category": {
                            "text": "category"
                        }
                    }
                ]
            }
        ]
    },
    {
        "resourceType": "ClaimResponse",
        "id": "cr2",
        "use": "claim",
        "patient": {
            "reference": "Patient/p1"
        },
        "created": "2021-09-02",
        "insurer": {
            "reference": "Organization/o1"
        },
        "type": {
            "text": "type"
        },
        "outcome": "complete",
        "status": "active",
        "item": [
            {
                "itemSequence": 2,
                "adjudication": [
                    {
                        "category": {
                            "text": "category"
                        }
                    }
                ]
            }
        ]
    },
    {
        "resourceType": "ClaimResponse",
        "id": "cr3",
        "use": "claim",
        "patient": {
            "reference": "Patient/p1"
        },
        "created": "2021-09-02",
        "insurer": {
            "reference": "Organization/o1"
        },
        "type": {
            "text": "type"
        },
        "outcome": "complete",
        "status": "active"
    },
    {
        "resourceType": "DetectedIssue",
        "id": "di1",
        "status": "final",
        "identifiedDateTime": "2023-02-08"
    },
    {
        "resourceType": "DetectedIssue",
        "id": "di2",
        "status": "final",
        "identifiedDateTime": "2016-11-12"
    },
    {
        "resourceType": "DetectedIssue",
        "id": "di3",
        "status": "final"
    },
    {
        "resourceType": "Observation",
        "id": "o1",
        "status": "final",
        "code": {
            "text": "code"
        },
        "valueQuantity": {
            "value": 1.0
        },
        "effectiveInstant": "2015-02-07T13:28:17.239+02:00"
    },
    {
        "resourceType": "Observation",
        "id": "o2",
        "status": "final",
        "code": {
            "text": "code"
        },
        "valueQuantity": {
            "value": 1.8
        },
        "effectiveInstant": "2022-02-07T13:28:17.239+02:00"
    },
    {
        "resourceType": "Observation",
        "id": "o3",
        "status": "final",
        "code": {
            "text": "code"
        }
    },
    {
        "resourceType": "Observation",
        "id": "o4",
        "status": "final",
        "code": {
            "text": "code"
        },
        "valueTime": "18:12:00"
    },
    {
        "resourceType": "Observation",
        "id": "o5",
        "status": "final",
        "code": {
            "text": "code"
        },
        "valueTime": "18:32:00"
    },
    {
        "resourceType": "ImagingStudy",
        "id": "is1",
        "status": "available",
        "subject": {
            "reference": "Patient/p1"
        },
        "numberOfSeries": 9
    },
    {
        "resourceType": "ImagingStudy",
        "id": "is2",
        "status": "available",
        "subject": {
            "reference": "Patient/p1"
        },
        "numberOfSeries": 12
    },
    {
        "resourceType": "ImagingStudy",
        "id": "is3",
        "status": "available",
        "subject": {
            "reference": "Patient/p1"
        }
    },
    {
        "resourceType": "Measure",
        "id": "m1",
        "url": "urn:uuid:53fefa32-fcbb-4ff8-8a92-55ee120877b7",
        "status": "active"
    },
    {
        "resourceType": "Measure",
        "id": "m2",
        "url": "urn:uuid:c4669fc3-0d14-4e54-a77f-525f6d4e8385",
        "status": "active"
    },
    {
        "resourceType": "Measure",
        "id": "m3",
        "status": "active"
    },
    {
        "resourceType": "Task",
        "id": "t1",
        "intent": "order",
        "status": "requested",
        "output": [
            {
                "type": {
                    "text": "type"
                },
                "valueUrl": "http://example.org"
            }
        ]
    },
    {
        "resourceType": "Task",
        "id": "t2",
        "intent": "order",
        "status": "requested",
        "output": [
            {
                "type": {
                    "text": "type"
                },
                "valueUrl": "http://another.example.org"
            }
        ]
    },
    {
        "resourceType": "Task",
        "id": "t3",
        "intent": "order",
        "status": "requested"
    },
    {
        "resourceType": "Task",
        "id": "t4",
        "intent": "order",
        "status": "requested",
        "output": [
            {
                "type": {
                    "text": "type"
                },
                "valueOid": "urn:oid:1.0"
            }
        ]
    },
    {
        "resourceType": "Task",
        "id": "t5",
        "intent": "order",
        "status": "requested",
        "output": [
            {
                "type": {
                    "text": "type"
                },
                "valueOid": "urn:oid:1.2.3"
            }
        ]
    },
    {
        "resourceType": "Task",
        "id": "t6",
        "intent": "order",
        "status": "requested",
        "output": [
            {
                "type": {
                    "text": "type"
                },
                "valueUuid": "urn:uuid:53fefa32-fcbb-4ff8-8a92-55ee120877b7"
            }
        ]
    },
    {
        "resourceType": "Task",
        "id": "t7",
        "intent": "order",
        "status": "requested",
        "output": [
            {
                "type": {
                    "text": "type"
                },
                "valueUuid": "urn:uuid:c4669fc3-0d14-4e54-a77f-525f6d4e8385"
            }
        ]
    },
    {
        "resourceType": "Task",
        "id": "t8",
        "intent": "order",
        "status": "requested",
        "output": [
            {
                "type": {
                    "text": "type"
                },
                "valueId": "id1"
            }
        ]
    },
    {
        "resourceType": "Task",
        "id": "t9",
        "intent": "order",
        "status": "requested",
        "output": [
            {
                "type": {
                    "text": "type"
                },
                "valueId": "id2"
            }
        ]
    }
];


// TODO: reenable after completing fhirpath transpiler
@test:Config {enable: false}
function testBase64binary() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Device",
        "status": "active",
        "constant": [
            {
                "name": "aidc",
                "valueBase64Binary": "aGVsbG8K"
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
                        "name": "aidc",
                        "path": "udiCarrier.first().carrierAIDC = %aidc",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "d1",
            "aidc": true
        },
        {
            "id": "d2",
            "aidc": false
        },
        {
            "id": "d3",
            "aidc": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testCode() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "gender",
                "valueCode": "female"
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
                        "name": "bool",
                        "path": "gender = %gender",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "bool": true
        },
        {
            "id": "pt2",
            "bool": false
        },
        {
            "id": "pt3",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testDate() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Patient",
        "status": "active",
        "constant": [
            {
                "name": "bd",
                "valueDate": "1978-03-12"
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
                        "name": "bool",
                        "path": "birthDate = %bd",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "bool": true
        },
        {
            "id": "pt2",
            "bool": false
        },
        {
            "id": "pt3",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testDatetime() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "DetectedIssue",
        "status": "active",
        "constant": [
            {
                "name": "id_time",
                "valueDateTime": "2016-11-12"
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
                        "name": "bool",
                        "path": "identified.ofType(dateTime) = %id_time",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "di1",
            "bool": false
        },
        {
            "id": "di2",
            "bool": true
        },
        {
            "id": "di3",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testDecimal() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Observation",
        "status": "active",
        "constant": [
            {
                "name": "v",
                "valueDecimal": 1.2
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
                        "name": "bool",
                        "path": "value.ofType(Quantity).value < %v",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "o1",
            "bool": true
        },
        {
            "id": "o2",
            "bool": false
        },
        {
            "id": "o3",
            "bool": ()
        },
        {
            "id": "o4",
            "bool": ()
        },
        {
            "id": "o5",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testId() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Task",
        "status": "active",
        "constant": [
            {
                "name": "id",
                "valueId": "id1"
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
                        "name": "bool",
                        "path": "output.first().value.ofType(id) = %id",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "t1",
            "bool": ()
        },
        {
            "id": "t2",
            "bool": ()
        },
        {
            "id": "t3",
            "bool": ()
        },
        {
            "id": "t4",
            "bool": ()
        },
        {
            "id": "t5",
            "bool": ()
        },
        {
            "id": "t6",
            "bool": ()
        },
        {
            "id": "t7",
            "bool": ()
        },
        {
            "id": "t8",
            "bool": true
        },
        {
            "id": "t9",
            "bool": false
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testInstant() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Observation",
        "status": "active",
        "constant": [
            {
                "name": "eff",
                "valueInstant": "2015-02-07T13:28:17.239+02:00"
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
                        "name": "bool",
                        "path": "effective.ofType(instant) = %eff",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "o1",
            "bool": true
        },
        {
            "id": "o2",
            "bool": false
        },
        {
            "id": "o3",
            "bool": ()
        },
        {
            "id": "o4",
            "bool": ()
        },
        {
            "id": "o5",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testOid() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Task",
        "status": "active",
        "constant": [
            {
                "name": "oid",
                "valueOid": "urn:oid:1.0"
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
                        "name": "bool",
                        "path": "output.first().value.ofType(oid) = %oid",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "t1",
            "bool": ()
        },
        {
            "id": "t2",
            "bool": ()
        },
        {
            "id": "t3",
            "bool": ()
        },
        {
            "id": "t4",
            "bool": true
        },
        {
            "id": "t5",
            "bool": false
        },
        {
            "id": "t6",
            "bool": ()
        },
        {
            "id": "t7",
            "bool": ()
        },
        {
            "id": "t8",
            "bool": ()
        },
        {
            "id": "t9",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testPositiveint() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "ClaimResponse",
        "status": "active",
        "constant": [
            {
                "name": "seq",
                "valuePositiveInt": 1
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
                        "name": "bool",
                        "path": "item.first().itemSequence = %seq",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "cr1",
            "bool": true
        },
        {
            "id": "cr2",
            "bool": false
        },
        {
            "id": "cr3",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testTime() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Observation",
        "status": "active",
        "constant": [
            {
                "name": "t",
                "valueTime": "18:12:00"
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
                        "name": "bool",
                        "path": "value.ofType(time) = %t",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "o1",
            "bool": ()
        },
        {
            "id": "o2",
            "bool": ()
        },
        {
            "id": "o3",
            "bool": ()
        },
        {
            "id": "o4",
            "bool": true
        },
        {
            "id": "o5",
            "bool": false
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testUnsignedint() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "ImagingStudy",
        "status": "active",
        "constant": [
            {
                "name": "series",
                "valueUnsignedInt": 9
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
                        "name": "bool",
                        "path": "numberOfSeries = %series",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "is1",
            "bool": true
        },
        {
            "id": "is2",
            "bool": false
        },
        {
            "id": "is3",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testUri() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Measure",
        "status": "active",
        "constant": [
            {
                "name": "uri",
                "valueUri": "urn:uuid:53fefa32-fcbb-4ff8-8a92-55ee120877b7"
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
                        "name": "bool",
                        "path": "url = %uri",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "m1",
            "bool": true
        },
        {
            "id": "m2",
            "bool": false
        },
        {
            "id": "m3",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testUrl() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Task",
        "status": "active",
        "constant": [
            {
                "name": "url",
                "valueUrl": "http://example.org"
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
                        "name": "bool",
                        "path": "output.first().value.ofType(url) = %url",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "t1",
            "bool": true
        },
        {
            "id": "t2",
            "bool": false
        },
        {
            "id": "t3",
            "bool": ()
        },
        {
            "id": "t4",
            "bool": ()
        },
        {
            "id": "t5",
            "bool": ()
        },
        {
            "id": "t6",
            "bool": ()
        },
        {
            "id": "t7",
            "bool": ()
        },
        {
            "id": "t8",
            "bool": ()
        },
        {
            "id": "t9",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
function testUuid() returns error? {
    postgresql:Client dbClient = check new (host, username, password, database, port);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS OrganizationTable (resource_json JSONB)`);
    _ = check dbClient->execute(`DELETE FROM OrganizationTable`);
    foreach json r in constantTypesResources {
        string rStr = r.toJsonString();
        _ = check dbClient->execute(`INSERT INTO OrganizationTable (resource_json) VALUES (${rStr}::jsonb)`);
    }
    json viewJson = {
        "resource": "Task",
        "status": "active",
        "constant": [
            {
                "name": "uuid",
                "valueUuid": "urn:uuid:53fefa32-fcbb-4ff8-8a92-55ee120877b7"
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
                        "name": "bool",
                        "path": "output.first().value.ofType(uuid) = %uuid",
                        "type": "boolean"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "t1",
            "bool": ()
        },
        {
            "id": "t2",
            "bool": ()
        },
        {
            "id": "t3",
            "bool": ()
        },
        {
            "id": "t4",
            "bool": ()
        },
        {
            "id": "t5",
            "bool": ()
        },
        {
            "id": "t6",
            "bool": true
        },
        {
            "id": "t7",
            "bool": false
        },
        {
            "id": "t8",
            "bool": ()
        },
        {
            "id": "t9",
            "bool": ()
        }
    ];
    TranspilerContext ctx = {
        resourceColumn: "resource_json",
        tableName: "OrganizationTable"
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
