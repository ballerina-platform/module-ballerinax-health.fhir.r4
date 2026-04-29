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
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import mahima_de_silva/sql_on_fhir_lib;

// ========================================
// SQL-ON-FHIR QUERY GENERATOR
// ========================================
// Generates PostgreSQL SELECT statements from sql_on_fhir_lib:ViewDefinition structures.
// Builds on top of expandCombinations() and the FHIRPath transpiler.

# The result of expanding a single union combination from a sql_on_fhir_lib:ViewDefinition.
# `selects` holds the select elements contributing to this combination.
# `unionChoices` holds the union branch index chosen for each select element
# (-1 means the select had no unionAll; >= 0 is the index into its unionAll array).
type SelectCombination record {|
    # Select elements that contribute to this combination
    sql_on_fhir_lib:ViewDefinitionSelect[] selects;
    # Parallel array of union branch indices (-1 = no union chosen)
    int[] unionChoices;
|};

// ========================================
// PUBLIC API
// ========================================

# Generate a PostgreSQL query for a sql_on_fhir_lib:ViewDefinition.
#
# Expands all `unionAll` combinations and joins them with `UNION ALL`.
# When any combination contains a `repeat` directive, the collected recursive
# CTE definitions are hoisted to a single `WITH RECURSIVE` clause at the top.
# The supplied `TranspilerContext` controls the table name, JSONB column, and
# whether a `resource_type` filter is emitted in the WHERE clause.
#
# + viewDef - The sql_on_fhir_lib:ViewDefinition as a JSON value (converted via `cloneWithType` internally)
# + ctx - The transpiler context (must include `tableName` and `resourceColumn`)
# + return - The generated SQL string, or an error
public isolated function generateQuery(json viewDef, TranspilerContext ctx) returns string|error {
    sql_on_fhir_lib:ViewDefinition typedViewDef = check viewDef.cloneWithType(sql_on_fhir_lib:ViewDefinition);
    [string[], string[]] result = check generateAllSelectStatements(typedViewDef, ctx);
    string[] statements = result[0];
    string[] cteDefs = result[1];

    string body = string:'join("\nUNION ALL\n", ...statements);
    if cteDefs.length() > 0 {
        return "WITH RECURSIVE " + string:'join(",\n", ...cteDefs) + "\n" + body;
    }
    return body;
}

# Generate one SQL SELECT string per `SelectCombination`, collecting any CTE
# definitions contributed by repeat selects so they can be consolidated at the
# query level.
#
# + viewDef - The typed sql_on_fhir_lib:ViewDefinition (already converted from JSON)
# + ctx - The transpiler context
# + return - `[statements, cteDefinitions]` across all combinations, or an error
isolated function generateAllSelectStatements(
        sql_on_fhir_lib:ViewDefinition viewDef,
        TranspilerContext ctx) returns [string[], string[]]|error {

    SelectCombination[] combinations = expandCombinations(viewDef.'select);
    string[] statements = [];
    string[] cteDefs = [];
    int counter = 0;
    foreach SelectCombination combination in combinations {
        [string, string[], int] result =
            check generateStatementForCombination(combination, viewDef, ctx, counter);
        statements.push(result[0]);
        foreach string d in result[1] {
            cteDefs.push(d);
        }
        counter = result[2];
    }
    return [statements, cteDefs];
}

# Route a combination to the appropriate statement generator.
#
# Repeat takes precedence over forEach when both are present; forEach nested
# inside a repeat is handled by `generateRepeatStatement`.
#
# + combination - The select combination to generate SQL for
# + viewDef - The sql_on_fhir_lib:ViewDefinition
# + ctx - The transpiler context
# + counter - The shared CTE alias counter (threaded across combinations)
# + return - `[statement, cteDefinitions, nextCounter]`, or an error
isolated function generateStatementForCombination(
        SelectCombination combination,
        sql_on_fhir_lib:ViewDefinition viewDef,
        TranspilerContext ctx,
        int counter) returns [string, string[], int]|error {

    if combinationHasRepeat(combination) {
        return generateRepeatStatement(combination, viewDef, ctx, counter);
    } else if combinationHasForEach(combination) {
        string stmt = check generateForEachStatement(combination, viewDef, ctx);
        return [stmt, [], counter];
    }
    string stmt = check generateSimpleStatement(combination, viewDef, ctx);
    return [stmt, [], counter];
}

# Generate a simple SELECT statement (no forEach, no repeat).
#
# Assembles SELECT, FROM, and WHERE clauses from the combination.
#
# + combination - The select combination (must have no forEach/repeat)
# + viewDef - The sql_on_fhir_lib:ViewDefinition
# + ctx - The transpiler context
# + return - The generated SQL string, or an error
isolated function generateSimpleStatement(
        SelectCombination combination,
        sql_on_fhir_lib:ViewDefinition viewDef,
        TranspilerContext ctx) returns string|error {

    string selectClause = check generateSimpleSelectClause(combination, ctx);
    string fromClause = generateFromClause(ctx.resourceAlias, ctx.tableName);
    string? whereClause = check buildWhereClause(ctx.resourceAlias, viewDef.'where, ctx);

    string statement = selectClause + "\n" + fromClause;
    if whereClause is string {
        statement += "\n" + whereClause;
    }
    return statement;
}

// ========================================
// SELECT CLAUSE BUILDER
// ========================================

# Build the SELECT clause for a simple (non-forEach, non-repeat) combination.
#
# Iterates `combination.selects` and `combination.unionChoices` in parallel:
# - For each select element: collects columns recursively (skipping forEach selects).
# - For the chosen `unionAll` branch (if any): collects that branch's direct columns.
#
# + combination - The select combination
# + ctx - The transpiler context
# + return - The SELECT clause string (e.g. `SELECT\n  expr AS "name", …`), or an error
isolated function generateSimpleSelectClause(SelectCombination combination, TranspilerContext ctx) returns string|error {
    string[] columnParts = [];

    foreach int i in 0 ..< combination.selects.length() {
        sql_on_fhir_lib:ViewDefinitionSelect sel = combination.selects[i];
        int unionChoice = combination.unionChoices[i];

        // Collect columns from the select element itself (skips forEach selects).
        string[] cols = check collectSelectColumns(sel, ctx);
        foreach string c in cols {
            columnParts.push(c);
        }

        // Collect direct columns from the chosen unionAll branch (if any).
        sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
        if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionChoice >= 0 && unionChoice < unionAll.length() {
            sql_on_fhir_lib:ViewDefinitionSelect chosenBranch = unionAll[unionChoice];
            sql_on_fhir_lib:ViewDefinitionSelectColumn[]? branchCols = chosenBranch.column;
            if branchCols is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
                foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in branchCols {
                    string expr = check generateColumnExpression(col, ctx);
                    columnParts.push(expr + " AS \"" + col.name + "\"");
                }
            }
        }
    }

    if columnParts.length() == 0 {
        return "SELECT *";
    }
    return "SELECT\n  " + string:'join(",\n  ", ...columnParts);
}

# Recursively collect `expr AS "name"` strings from a select element.
#
# Skips forEach/forEachOrNull selects (those are handled by `generateForEachStatement`).
# Recurses into nested `select` elements.
#
# + sel - The select element to collect columns from
# + ctx - The transpiler context
# + return - Column expression strings, or an error
isolated function collectSelectColumns(sql_on_fhir_lib:ViewDefinitionSelect sel, TranspilerContext ctx) returns string[]|error {
    if sel.forEach is string || sel.forEachOrNull is string {
        return [];
    }

    string[] parts = [];

    sql_on_fhir_lib:ViewDefinitionSelectColumn[]? columns = sel.column;
    if columns is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in columns {
            string expr = check generateColumnExpression(col, ctx);
            parts.push(expr + " AS \"" + col.name + "\"");
        }
    }

    sql_on_fhir_lib:ViewDefinitionSelect[]? nested = sel.'select;
    if nested is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect nestedSel in nested {
            string[] nestedCols = check collectSelectColumns(nestedSel, ctx);
            foreach string c in nestedCols {
                parts.push(c);
            }
        }
    }

    return parts;
}

# Generate the SQL expression for a single column, with optional type cast.
#
# Calls `transpile()` on `col.path`, then wraps the result in a PostgreSQL
# cast if a FHIR type (or tag-based type override) is specified and the
# inferred PostgreSQL type is not `TEXT`.
#
# + col - The column definition
# + ctx - The transpiler context
# + return - The SQL expression string, or an error
isolated function generateColumnExpression(sql_on_fhir_lib:ViewDefinitionSelectColumn col, TranspilerContext ctx) returns string|error {
    string expression = check transpile(col.path, ctx);

    string? fhirType = col.'type;
    if fhirType is () {
        return expression;
    }

    // Convert sql_on_fhir_lib:ViewDefinitionSelectColumnTag[] to ColumnTag[] for inferSqlType.
    ColumnTag[]? colTags = ();
    sql_on_fhir_lib:ViewDefinitionSelectColumnTag[]? rawTags = col.tag;
    if rawTags is sql_on_fhir_lib:ViewDefinitionSelectColumnTag[] {
        colTags = from sql_on_fhir_lib:ViewDefinitionSelectColumnTag t in rawTags
            select {name: t.name, value: t.value};
    }

    string pgType = inferSqlType(fhirType, colTags);
    return applyTypeCast(expression, pgType);
}

# Wrap a SQL expression in a PostgreSQL type cast.
#
# - `TEXT`: returned as-is (no cast needed).
# - `BOOLEAN`: uses `(expr)::BOOLEAN` syntax.
# - Other types: uses `CAST(expr AS type)` syntax.
#
# + expression - The SQL expression to cast
# + pgType - The PostgreSQL type string (from `inferSqlType`)
# + return - The cast expression
isolated function applyTypeCast(string expression, string pgType) returns string {
    if pgType == "TEXT" {
        return expression;
    }
    if pgType == "BOOLEAN" {
        return "(" + expression + ")::BOOLEAN";
    }
    return "CAST(" + expression + " AS " + pgType + ")";
}

// ========================================
// FROM / WHERE CLAUSE BUILDERS
// ========================================

# Generate the FROM clause.
#
# + resourceAlias - SQL alias for the resource table
# + tableName - The SQL table name to query
# + return - The FROM clause string (e.g. `FROM PatientTable AS r`)
isolated function generateFromClause(string resourceAlias, string tableName) returns string {
    return "FROM " + tableName + " AS " + resourceAlias;
}

# Build the WHERE clause from view-level filters.
#
# Appends each `sql_on_fhir_lib:ViewDefinitionWhere` condition by transpiling its FHIRPath expression.
#
# + resourceAlias - SQL alias for the resource table
# + whereConditions - Optional view-level filter conditions
# + ctx - The transpiler context
# + return - The WHERE clause string, or `()` if no conditions, or an error
isolated function buildWhereClause(
        string resourceAlias,
        sql_on_fhir_lib:ViewDefinitionWhere[]? whereConditions,
        TranspilerContext ctx) returns string?|error {

    string[] conditions = [];

    if whereConditions is sql_on_fhir_lib:ViewDefinitionWhere[] {
        foreach sql_on_fhir_lib:ViewDefinitionWhere w in whereConditions {
            string condition = check transpile(w.path, ctx);
            if !isBooleanExpression(condition) {
                condition = "(" + condition + " IS NOT NULL AND " + condition + " != 'false')";
            }
            conditions.push(condition);
        }
    }

    if conditions.length() == 0 {
        return ();
    }
    return "WHERE " + string:'join(" AND ", ...conditions);
}

// ========================================
// COMBINATION DETECTION HELPERS
// ========================================

# Check whether a single select element (or any element reachable from it) uses forEach.
#
# Recursively checks nested `select` arrays and `unionAll` options.
#
# + sel - The select element to check
# + return - `true` if the element or any descendant uses forEach/forEachOrNull
isolated function selectHasForEach(sql_on_fhir_lib:ViewDefinitionSelect sel) returns boolean {
    if sel.forEach is string || sel.forEachOrNull is string {
        return true;
    }
    sql_on_fhir_lib:ViewDefinitionSelect[]? nested = sel.'select;
    if nested is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nested {
            if selectHasForEach(ns) {
                return true;
            }
        }
    }
    sql_on_fhir_lib:ViewDefinitionSelect[]? ua = sel.unionAll;
    if ua is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect u in ua {
            if selectHasForEach(u) {
                return true;
            }
        }
    }
    return false;
}

# Check whether any select in the combination has a `forEach` or `forEachOrNull` directive.
#
# Checks recursively into nested `select` arrays and `unionAll` options, and also
# checks the chosen `unionAll` branch for each top-level select element.
#
# + combination - The select combination
# + return - `true` if any select (or any descendant) uses forEach/forEachOrNull
isolated function combinationHasForEach(SelectCombination combination) returns boolean {
    foreach int i in 0 ..< combination.selects.length() {
        sql_on_fhir_lib:ViewDefinitionSelect sel = combination.selects[i];
        if selectHasForEach(sel) {
            return true;
        }
        int unionChoice = combination.unionChoices[i];
        sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
        if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionChoice >= 0 && unionChoice < unionAll.length() {
            sql_on_fhir_lib:ViewDefinitionSelect branch = unionAll[unionChoice];
            if selectHasForEach(branch) {
                return true;
            }
        }
    }
    return false;
}

# Check whether any select in the combination has a `repeat` directive.
#
# Also checks the chosen `unionAll` branch for each select.
#
# + combination - The select combination
# + return - `true` if any select (or chosen union branch) uses repeat
isolated function combinationHasRepeat(SelectCombination combination) returns boolean {
    foreach int i in 0 ..< combination.selects.length() {
        sql_on_fhir_lib:ViewDefinitionSelect sel = combination.selects[i];
        string[]? rep = sel.repeat;
        if rep is string[] && rep.length() > 0 {
            return true;
        }
        int unionChoice = combination.unionChoices[i];
        sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
        if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionChoice >= 0 && unionChoice < unionAll.length() {
            sql_on_fhir_lib:ViewDefinitionSelect branch = unionAll[unionChoice];
            string[]? branchRep = branch.repeat;
            if branchRep is string[] && branchRep.length() > 0 {
                return true;
            }
        }
    }
    return false;
}
