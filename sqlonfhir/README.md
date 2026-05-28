## Overview

SQL-on-FHIR v2 library for evaluating [ViewDefinitions](https://build.fhir.org/ig/FHIR/sql-on-fhir-v2/) against FHIR R4 resources in Ballerina. It flattens nested FHIR JSON into tabular row results, and can also transpile ViewDefinitions to PostgreSQL SQL for database-backed execution.

> **Trademark Notice:** FHIR® and the FHIR® logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7®.

### Key Features

- Evaluate ViewDefinitions against in-memory FHIR R4 resources
- Transpile ViewDefinitions to PostgreSQL SQL for database-backed execution
- Supports `column`, `select`, `forEach`, `forEachOrNull`, `repeat`, and `unionAll` operations
- Custom FHIRPath extension functions (`getResourceKey`, `getReferenceKey`)
- Pre-flight column validation (duplicate names, inconsistent `unionAll` branches)

# SQL-on-FHIR v2 Library

This library implements the [SQL-on-FHIR v2 specification](https://build.fhir.org/ig/FHIR/sql-on-fhir-v2/) for Ballerina. It evaluates `ViewDefinition` resources against FHIR R4 JSON, producing flat arrays of row objects suitable for tabular display or SQL insertion.

## Package Overview

|                      |                                                        |
|----------------------|--------------------------------------------------------|
| FHIR version         | R4                                                     |
| Specification        | https://build.fhir.org/ig/FHIR/sql-on-fhir-v2/        |

## Features

- **In-memory Evaluation**: Apply a `ViewDefinition` to an array of FHIR resources and receive flat `json[]` row results — no database required
- **PostgreSQL Transpilation**: Translate a `ViewDefinition` into a SQL query that runs against a PostgreSQL table storing FHIR resources as JSON
- **`forEach` / `forEachOrNull` Expansion**: Expand repeated child elements into multiple rows; `forEachOrNull` preserves a null row when the path matches nothing
- **`repeat` Traversal**: Recursively walk the FHIR graph using a path expression, then apply a `select` to each collected node
- **`unionAll` Branching**: Concatenate results from multiple independent selection branches; branch column sets are validated for consistency
- **`where` Filtering**: Apply FHIRPath boolean expressions to filter rows before columns are projected
- **FHIRPath Extensions**: Override `getResourceKey()` and `getReferenceKey()` with custom implementations via `FhirPathExtensions`
- **Column Validation**: Pre-flight check detects duplicate column names and mismatched `unionAll` branch schemas before evaluation begins
- **Error Handling**: Detailed errors for invalid ViewDefinition structures, FHIRPath evaluation failures, and column inconsistencies


## Usage Examples

### Column Extraction (in-memory)

```ballerina
import ballerina/io;
import mahima_de_silva/sql_on_fhir_lib;
import mahima_de_silva/sql_on_fhir_lib.in_memory_runner as sof;

json patient = {
    "resourceType": "Patient",
    "id": "p1",
    "address": [
        {"use": "home", "city": "Springfield", "state": "IL"},
        {"use": "work", "city": "Shelbyville",  "state": "IL"}
    ]
};

// One row per address entry
sql_on_fhir_lib:ViewDefinition viewDef = {
    'resource: "Patient",
    'select: [
        {column: [{name: "id", path: "id"}]},
        {
            forEach: "address",
            column: [
                {name: "addressUse",  path: "use"},
                {name: "city",        path: "city"},
                {name: "state",       path: "state"}
            ]
        }
    ]
};

public function main() returns error? {
    json[] rows = check sof:evaluate([patient], viewDef);
    io:println(rows);
    // [{"id":"p1","addressUse":"home","city":"Springfield","state":"IL"},
    //  {"id":"p1","addressUse":"work","city":"Shelbyville","state":"IL"}]
}
```

### Using `where` to Filter Rows

```ballerina
import ballerina/io;
import mahima_de_silva/sql_on_fhir_lib;
import mahima_de_silva/sql_on_fhir_lib.in_memory_runner as sof;

// Only include active patients
sql_on_fhir_lib:ViewDefinition viewDef = {
    'resource: "Patient",
    'where: [{path: "active = true"}],
    'select: [
        {
            column: [
                {name: "id",     path: "id"},
                {name: "family", path: "name.first().family"}
            ]
        }
    ]
};

public function main() returns error? {
    json[] rows = check sof:evaluate(resources, viewDef);
    io:println(rows);
}
```

### Custom FHIRPath Extensions

Override `getResourceKey` or `getReferenceKey` to change how resource and reference keys are resolved (useful for UUID-based IDs, custom reference formats, etc.).

```ballerina
import mahima_de_silva/sql_on_fhir_lib.in_memory_runner as sof;

isolated function uuidResourceKey(json[] nodes) returns json[]|error {
    json[] keys = [];
    foreach json node in nodes {
        if node is map<json> {
            json idVal = node["id"] ?: ();
            if idVal is string {
                // Strip a known prefix before using as the key
                keys.push(idVal.startsWith("urn:uuid:") ? idVal.substring(9) : idVal);
            }
        }
    }
    return keys;
}

public function main() returns error? {
    sof:FhirPathExtensions ext = {getResourceKey: uuidResourceKey};
    json[] rows = check sof:evaluate(resources, viewDef, extensions = ext);
}
```

### PostgreSQL SQL Transpilation

When FHIR resources are stored as JSON in a PostgreSQL table, use the `pg_db_runner` module to transpile a `ViewDefinition` to SQL and execute it directly.

```ballerina
import ballerinax/java.jdbc;
import mahima_de_silva/sql_on_fhir_lib.pg_db_runner as sof_pg;

public function main() returns error? {
    jdbc:Client jdbcClient = check new ("jdbc:postgresql://localhost:5432/fhirdb", "user", "pass");

    json viewJson = {
        "resource": "Patient",
        "select": [{"column": [{"name": "id", "path": "id"}]}]
    };

    sof_pg:TranspilerContext ctx = {
        resourceColumn: "\"RESOURCE_JSON\"",
        tableName: "\"PatientTable\""
    };

    string sqlQuery = check sof_pg:generateQuery(viewJson, ctx);

    stream<record {}, error?> rowStream = jdbcClient->query(new jdbc:ParameterizedQuery([sqlQuery]));
    record {}[] allRows = check from record {} row in rowStream select row;
}
```


## Supported ViewDefinition Operations

| Operation       | Description |
|-----------------|-------------|
| `column`        | Evaluates a FHIRPath expression and produces a named column value |
| `select`        | Groups columns; applies `where` filters and cartesian-products child branches |
| `forEach`       | Expands a repeated path into multiple rows, one per matched element |
| `forEachOrNull` | Same as `forEach` but emits one null row when the path matches nothing |
| `unionAll`      | Concatenates results from multiple branches; all branches must produce identical column sets |
| `repeat`        | Recursively traverses the FHIR graph using a path, then applies `select` to each collected node |


## FHIRPath Extensions

Two FHIRPath functions have default implementations that can be overridden by passing a `FhirPathExtensions` record to `evaluate()`:

| Function | Default behaviour | Override via |
|---|---|---|
| `getResourceKey()` | Extracts the `id` field from matched nodes | `FhirPathExtensions.getResourceKey` |
| `getReferenceKey(?resourceType)` | Parses `reference` strings (e.g. `"Patient/123"`) to extract the ID, optionally filtering by resource type | `FhirPathExtensions.getReferenceKey` |

```ballerina
public type FhirPathExtensions record {|
    GetResourceKeyFunction  getResourceKey?;
    GetReferenceKeyFunction getReferenceKey?;
|};
```

Pass your overrides when calling `evaluate`:

```ballerina
json[] rows = check sof:evaluate(resources, viewDef, extensions = {
    getResourceKey: myKeyFn,
    getReferenceKey: myRefKeyFn
});
```
