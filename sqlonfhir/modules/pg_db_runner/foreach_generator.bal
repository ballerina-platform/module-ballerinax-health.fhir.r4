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
// SQL-ON-FHIR FOREACH STATEMENT GENERATOR
// ========================================
// Generates PostgreSQL SELECT statements with LATERAL JOIN unnesting
// for sql_on_fhir_lib:ViewDefinition select elements that use forEach / forEachOrNull.
//
// PostgreSQL equivalent of the T-SQL ForEachProcessor (CROSS APPLY OPENJSON):
//   forEach      -> CROSS JOIN LATERAL jsonb_array_elements(source->'path') AS alias(value)
//   forEachOrNull -> LEFT JOIN LATERAL jsonb_array_elements(source->'path') AS alias(value) ON TRUE

// ========================================
// INTERNAL TYPES
// ========================================

# Associates a forEach select element with its transpiler context.
# Used as an identity-keyed map; entries are located by `===` reference equality
# because Ballerina maps require string keys but we need object identity.
#
# + sel - The forEach select element (reference identity is the key)
# + ctx - The transpiler context containing iterationContext, currentForEachAlias, etc.
type ForEachEntry record {|
    sql_on_fhir_lib:ViewDefinitionSelect sel;
    TranspilerContext ctx;
|};

// ========================================
//  API
// ========================================

# Generate a SELECT statement that iterates over FHIR arrays using LATERAL JOINs.
#
# Called when a `SelectCombination` contains at least one forEach or forEachOrNull
# directive. Each forEach element becomes a CROSS JOIN LATERAL (or LEFT JOIN
# LATERAL for forEachOrNull) on `jsonb_array_elements`, and column expressions
# within the forEach use `forEach_N.value` as their iteration context.
#
# + combination - The select combination to generate SQL for
# + viewDef - The sql_on_fhir_lib:ViewDefinition
# + ctx - The transpiler context (base resource alias and column)
# + return - The generated SQL string, or an error
isolated function generateForEachStatement(
        SelectCombination combination,
        sql_on_fhir_lib:ViewDefinition viewDef,
        TranspilerContext ctx) returns string|error {

    string fromClause = generateFromClause(ctx.resourceAlias, ctx.tableName);

    [ForEachEntry[], sql_on_fhir_lib:ViewDefinitionSelect[]] mapResult =
        buildForEachContextMap(combination.selects, ctx, combination);
    ForEachEntry[] contextMap = mapResult[0];
    sql_on_fhir_lib:ViewDefinitionSelect[] topLevelForEach = mapResult[1];

    string lateralClauses = buildLateralJoinClauses(contextMap, topLevelForEach, combination);
    string selectClause = check generateForEachSelectClause(combination, ctx, contextMap);
    string? whereClause = check buildWhereClause(ctx.resourceAlias, viewDef.'where, ctx);

    string statement = selectClause + "\n" + fromClause + lateralClauses;
    if whereClause is string {
        statement += "\n" + whereClause;
    }
    return statement;
}

// ========================================
// CONTEXT MAP BUILDER
// ========================================

# Build forEach context map and collect top-level forEach select elements.
#
# Traverses the select elements in the combination to find top-level forEach
# selects (directly on a select or one level nested in a non-forEach select),
# then generates a `TranspilerContext` for each with a unique alias (`forEach_0`,
# `forEach_1`, …).
#
# + selects - Top-level select elements from the combination
# + baseCtx - The base transpiler context for the statement
# + combination - The select combination (used for union branch resolution)
# + return - Tuple of [context map entries, top-level forEach selects]
isolated function buildForEachContextMap(
        sql_on_fhir_lib:ViewDefinitionSelect[] selects,
        TranspilerContext baseCtx,
        SelectCombination combination) returns [ForEachEntry[], sql_on_fhir_lib:ViewDefinitionSelect[]] {

    sql_on_fhir_lib:ViewDefinitionSelect[] topLevelForEach = collectTopLevelForEach(selects, combination);

    ForEachEntry[] contextMap = [];
    int counter = 0;
    string baseSource = baseCtx.resourceAlias + "." + baseCtx.resourceColumn;

    foreach sql_on_fhir_lib:ViewDefinitionSelect sel in topLevelForEach {
        [ForEachEntry[], int] result = buildForEachEntries(sel, baseSource, baseCtx, counter);
        foreach ForEachEntry e in result[0] {
            contextMap.push(e);
        }
        counter = result[1];
    }

    return [contextMap, topLevelForEach];
}

# Collect all top-level forEach select elements from the given selects array.
#
# A forEach select is considered "top-level" when:
# - It directly carries forEach / forEachOrNull, OR
# - It is a non-forEach select that contains forEach in its nested `select` array
# (in which case the nested forEach selects are the top-level ones).
# Also checks the chosen unionAll branch for each select element.
#
# + selects - Top-level select elements to scan
# + combination - The select combination for union branch resolution
# + return - Ordered list of top-level forEach select elements
isolated function collectTopLevelForEach(
        sql_on_fhir_lib:ViewDefinitionSelect[] selects,
        SelectCombination combination) returns sql_on_fhir_lib:ViewDefinitionSelect[] {

    sql_on_fhir_lib:ViewDefinitionSelect[] result = [];

    foreach sql_on_fhir_lib:ViewDefinitionSelect sel in selects {
        if sel.forEach is string || sel.forEachOrNull is string {
            result.push(sel);
        } else {
            // Collect forEach selects from this select's nested select array.
            sql_on_fhir_lib:ViewDefinitionSelect[]? nested = sel.'select;
            if nested is sql_on_fhir_lib:ViewDefinitionSelect[] {
                foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nested {
                    if ns.forEach is string || ns.forEachOrNull is string {
                        result.push(ns);
                    }
                }
            }

            // Check the chosen unionAll branch (if any).
            int selIdx = indexOfSelect(combination, sel);
            if selIdx >= 0 {
                int unionChoice = combination.unionChoices[selIdx];
                sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
                if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionChoice >= 0 && unionChoice < unionAll.length() {
                    sql_on_fhir_lib:ViewDefinitionSelect branch = unionAll[unionChoice];
                    if branch.forEach is string || branch.forEachOrNull is string {
                        result.push(branch);
                    } else {
                        sql_on_fhir_lib:ViewDefinitionSelect[]? branchNested = branch.'select;
                        if branchNested is sql_on_fhir_lib:ViewDefinitionSelect[] {
                            foreach sql_on_fhir_lib:ViewDefinitionSelect ns in branchNested {
                                if ns.forEach is string || ns.forEachOrNull is string {
                                    result.push(ns);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return result;
}

# Recursively build `ForEachEntry` records for a forEach select and its nested forEach selects.
#
# Assigns the alias `forEach_<startCounter>` to this select, then recurses into
# nested forEach selects in `forEachSel.select` and `forEachSel.unionAll`, using
# `alias.value` as the source expression for each nested level.
#
# + forEachSel - The forEach select element to generate an entry for
# + sourceExpr - SQL expression that produces the JSONB array to unnest (e.g. `r.resource`)
# + baseCtx - The parent transpiler context
# + startCounter - The next alias counter value to use
# + return - Tuple of [generated entries, next counter value after this subtree]
isolated function buildForEachEntries(
        sql_on_fhir_lib:ViewDefinitionSelect forEachSel,
        string sourceExpr,
        TranspilerContext baseCtx,
        int startCounter) returns [ForEachEntry[], int] {

    string applyAlias = "forEach_" + startCounter.toString();
    int counter = startCounter + 1;

    string rawPath = resolveForEachPath(forEachSel);
    string[] pathSegments = re `\.`.split(rawPath);

    TranspilerContext forEachCtx = {
        resourceAlias: baseCtx.resourceAlias,
        resourceColumn: baseCtx.resourceColumn,
        tableName: baseCtx.tableName,
        constants: baseCtx.constants,
        iterationContext: applyAlias + ".value",
        currentForEachAlias: applyAlias,
        forEachSource: sourceExpr,
        forEachPathSegments: pathSegments
    };

    ForEachEntry[] entries = [{sel: forEachSel, ctx: forEachCtx}];

    // Recurse into nested forEach selects within this forEach's select array.
    sql_on_fhir_lib:ViewDefinitionSelect[]? nestedSelects = forEachSel.'select;
    if nestedSelects is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nestedSelects {
            if ns.forEach is string || ns.forEachOrNull is string {
                [ForEachEntry[], int] nested = buildForEachEntries(
                        ns, applyAlias + ".value", forEachCtx, counter);
                foreach ForEachEntry e in nested[0] {
                    entries.push(e);
                }
                counter = nested[1];
            }
        }
    }

    // Recurse into nested forEach selects within unionAll options.
    sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = forEachSel.unionAll;
    if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect uo in unionAll {
            if uo.forEach is string || uo.forEachOrNull is string {
                [ForEachEntry[], int] union = buildForEachEntries(
                        uo, applyAlias + ".value", forEachCtx, counter);
                foreach ForEachEntry e in union[0] {
                    entries.push(e);
                }
                counter = union[1];
            }
        }
    }

    return [entries, counter];
}

# Look up the `TranspilerContext` for a forEach select by reference identity.
#
# Uses `===` (reference equality) because `sql_on_fhir_lib:ViewDefinitionSelect` is a record;
# value equality would give false positives for structurally identical selects.
#
# + contextMap - The forEach context map entries
# + sel - The select element to look up
# + return - The associated context, or `()` if not found
isolated function lookupForEachContext(
        ForEachEntry[] contextMap,
        sql_on_fhir_lib:ViewDefinitionSelect sel) returns TranspilerContext? {
    foreach ForEachEntry entry in contextMap {
        if entry.sel === sel {
            return entry.ctx;
        }
    }
    return ();
}

// ========================================
// LATERAL JOIN CLAUSE BUILDER
// ========================================

# Build all LATERAL JOIN clause strings for the forEach selects.
#
# Generates one LATERAL JOIN string per top-level forEach select (in traversal
# order), with nested forEach joins appended immediately after their parent.
#
# + contextMap - The forEach context map
# + topLevelForEach - Top-level forEach select elements (in traversal order)
# + combination - The select combination
# + return - Concatenated LATERAL JOIN strings (each prefixed with `\n`)
isolated function buildLateralJoinClauses(
        ForEachEntry[] contextMap,
        sql_on_fhir_lib:ViewDefinitionSelect[] topLevelForEach,
        SelectCombination combination) returns string {

    string clauses = "";
    foreach sql_on_fhir_lib:ViewDefinitionSelect sel in topLevelForEach {
        TranspilerContext? forEachCtx = lookupForEachContext(contextMap, sel);
        if forEachCtx is TranspilerContext {
            clauses += buildLateralJoinClause(sel, forEachCtx, contextMap, combination);
        }
    }
    return clauses;
}

# Build the LATERAL JOIN clause for a single forEach select element.
#
# Generates the main JOIN for this select, then appends clauses for any nested
# forEach selects in `forEachSel.select`.
#
# + forEachSel - The forEach select element
# + forEachCtx - The transpiler context assigned to this forEach
# + contextMap - The forEach context map
# + combination - The select combination
# + return - The LATERAL JOIN string(s) for this forEach and its nested forEach selects
isolated function buildLateralJoinClause(
        sql_on_fhir_lib:ViewDefinitionSelect forEachSel,
        TranspilerContext forEachCtx,
        ForEachEntry[] contextMap,
        SelectCombination combination) returns string {

    string rawPath = resolveForEachPath(forEachSel);
    boolean isOrNull = forEachSel.forEachOrNull is string;
    string alias = forEachCtx.currentForEachAlias ?: "forEach_0";
    string sourceExpr = forEachCtx.forEachSource ?: "";
    string joinType = isOrNull ? "LEFT JOIN" : "CROSS JOIN";

    string[] segments = re `\.`.split(rawPath);
    string mainClause = buildLateralJoinSegments(segments, sourceExpr, alias, joinType, isOrNull);

    // Append nested forEach join clauses.
    string nestedClauses = "";
    sql_on_fhir_lib:ViewDefinitionSelect[]? nestedSelects = forEachSel.'select;
    if nestedSelects is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nestedSelects {
            if ns.forEach is string || ns.forEachOrNull is string {
                TranspilerContext? nestedCtx = lookupForEachContext(contextMap, ns);
                if nestedCtx is TranspilerContext {
                    nestedClauses += buildLateralJoinClause(ns, nestedCtx, contextMap, combination);
                }
            }
        }
    }

    return mainClause + nestedClauses;
}

# Build the LATERAL JOIN SQL fragment for a path that may have multiple segments.
#
# Single-segment path (`name`):
# ```
# CROSS JOIN LATERAL jsonb_array_elements(r.resource->'name') AS forEach_0(value)
# ```
#
# Multi-segment path (`contact.telecom`):
# ```
# CROSS JOIN LATERAL jsonb_array_elements(r.resource->'contact') AS forEach_0_nest0(value)
# CROSS JOIN LATERAL jsonb_array_elements(forEach_0_nest0.value->'telecom') AS forEach_0(value)
# ```
#
# + segments - The path split by `.` (e.g. `["contact", "telecom"]`)
# + sourceExpr - The initial JSONB source (e.g. `r.resource`)
# + finalAlias - The alias to assign to the last (outermost) join
# + joinType - `"CROSS JOIN"` or `"LEFT JOIN"`
# + isOrNull - When `true`, appends `ON TRUE` to make it an outer lateral join
# + return - The LATERAL JOIN SQL fragment(s), each prefixed with `\n`
isolated function buildLateralJoinSegments(
        string[] segments,
        string sourceExpr,
        string finalAlias,
        string joinType,
        boolean isOrNull) returns string {

    if segments.length() == 1 {
        string onClause = isOrNull ? " ON TRUE" : "";
        return "\n" + joinType + " LATERAL jsonb_array_elements("
            + sourceExpr + "->'" + segments[0] + "') AS " + finalAlias + "(value)" + onClause;
    }

    // Multi-segment: generate one intermediate join per segment except the last.
    string result = "";
    string currentSource = sourceExpr;

    foreach int i in 0 ..< segments.length() {
        boolean isLast = i == segments.length() - 1;
        string segAlias = isLast ? finalAlias : finalAlias + "_nest" + i.toString();
        string segJoinType = isLast ? joinType : "CROSS JOIN";
        string onClause = (isLast && isOrNull) ? " ON TRUE" : "";
        result += "\n" + segJoinType + " LATERAL jsonb_array_elements("
            + currentSource + "->'" + segments[i] + "') AS " + segAlias + "(value)" + onClause;
        currentSource = segAlias + ".value";
    }

    return result;
}

// ========================================
// FOREACH SELECT CLAUSE BUILDER
// ========================================

# Build the SELECT clause for a forEach statement.
#
# For each select element in the combination:
# - If the select has forEach / forEachOrNull: uses the forEach context from the map.
# - Otherwise: uses the base context, but checks nested select elements for forEach.
# Falls back to `SELECT *` when no columns are collected.
#
# + combination - The select combination
# + ctx - The base transpiler context
# + contextMap - The forEach context map
# + return - The SELECT clause string, or an error
isolated function generateForEachSelectClause(
        SelectCombination combination,
        TranspilerContext ctx,
        ForEachEntry[] contextMap) returns string|error {

    string[] columnParts = [];

    foreach int i in 0 ..< combination.selects.length() {
        sql_on_fhir_lib:ViewDefinitionSelect sel = combination.selects[i];
        int unionChoice = combination.unionChoices[i];

        string[] cols;
        if sel.forEach is string || sel.forEachOrNull is string {
            TranspilerContext? forEachCtx = lookupForEachContext(contextMap, sel);
            if forEachCtx is TranspilerContext {
                cols = check collectForEachSelectColumns(sel, unionChoice, forEachCtx, contextMap);
            } else {
                cols = [];
            }
        } else {
            cols = check collectNonForEachSelectColumns(sel, unionChoice, ctx, contextMap);
        }

        foreach string c in cols {
            columnParts.push(c);
        }
    }

    if columnParts.length() == 0 {
        return "SELECT *";
    }
    return "SELECT\n  " + string:'join(",\n  ", ...columnParts);
}

# Collect column expressions for a forEach select element.
#
# Direct columns use the forEach context. Nested select elements that are
# themselves forEach selects use their own nested forEach context. Other
# nested selects use the parent forEach context.
#
# + sel - The forEach select element
# + unionChoice - The chosen unionAll branch index (-1 if no union)
# + forEachCtx - The transpiler context for this forEach
# + contextMap - The forEach context map
# + return - Column expression strings (`expr AS "name"`), or an error
isolated function collectForEachSelectColumns(
        sql_on_fhir_lib:ViewDefinitionSelect sel,
        int unionChoice,
        TranspilerContext forEachCtx,
        ForEachEntry[] contextMap) returns string[]|error {

    string[] parts = [];

    // Direct columns use the forEach context.
    sql_on_fhir_lib:ViewDefinitionSelectColumn[]? columns = sel.column;
    if columns is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in columns {
            string expr = check generateColumnExpression(col, forEachCtx);
            parts.push(expr + " AS \"" + col.name + "\"");
        }
    }

    // Nested select elements.
    sql_on_fhir_lib:ViewDefinitionSelect[]? nested = sel.'select;
    if nested is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nested {
            if ns.forEach is string || ns.forEachOrNull is string {
                // Nested forEach: use its own context.
                TranspilerContext? nestedCtx = lookupForEachContext(contextMap, ns);
                if nestedCtx is TranspilerContext {
                    sql_on_fhir_lib:ViewDefinitionSelectColumn[]? nestedCols = ns.column;
                    if nestedCols is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
                        foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in nestedCols {
                            string expr = check generateColumnExpression(col, nestedCtx);
                            parts.push(expr + " AS \"" + col.name + "\"");
                        }
                    }
                }
            } else {
                // Non-forEach nested: inherit parent forEach context.
                sql_on_fhir_lib:ViewDefinitionSelectColumn[]? nestedCols = ns.column;
                if nestedCols is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
                    foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in nestedCols {
                        string expr = check generateColumnExpression(col, forEachCtx);
                        parts.push(expr + " AS \"" + col.name + "\"");
                    }
                }
            }
        }
    }

    // Chosen unionAll branch columns.
    sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
    if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionChoice >= 0 && unionChoice < unionAll.length() {
        sql_on_fhir_lib:ViewDefinitionSelect branch = unionAll[unionChoice];
        TranspilerContext? branchCtx = lookupForEachContext(contextMap, branch);
        TranspilerContext effectiveCtx = branchCtx is TranspilerContext ? branchCtx : forEachCtx;
        sql_on_fhir_lib:ViewDefinitionSelectColumn[]? branchCols = branch.column;
        if branchCols is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
            foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in branchCols {
                string expr = check generateColumnExpression(col, effectiveCtx);
                parts.push(expr + " AS \"" + col.name + "\"");
            }
        }
    }

    return parts;
}

# Collect column expressions for a non-forEach select element in a forEach statement.
#
# Direct columns use the base context. Nested select elements that are forEach
# selects use their forEach context from the map. Other nested selects use the
# base context.
#
# + sel - The non-forEach select element
# + unionChoice - The chosen unionAll branch index (-1 if no union)
# + ctx - The base transpiler context
# + contextMap - The forEach context map
# + return - Column expression strings (`expr AS "name"`), or an error
isolated function collectNonForEachSelectColumns(
        sql_on_fhir_lib:ViewDefinitionSelect sel,
        int unionChoice,
        TranspilerContext ctx,
        ForEachEntry[] contextMap) returns string[]|error {

    string[] parts = [];

    // Direct columns use the base context.
    sql_on_fhir_lib:ViewDefinitionSelectColumn[]? columns = sel.column;
    if columns is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in columns {
            string expr = check generateColumnExpression(col, ctx);
            parts.push(expr + " AS \"" + col.name + "\"");
        }
    }

    // Nested select elements.
    sql_on_fhir_lib:ViewDefinitionSelect[]? nested = sel.'select;
    if nested is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nested {
            if ns.forEach is string || ns.forEachOrNull is string {
                // Nested forEach: use its forEach context.
                TranspilerContext? forEachCtx = lookupForEachContext(contextMap, ns);
                if forEachCtx is TranspilerContext {
                    sql_on_fhir_lib:ViewDefinitionSelectColumn[]? nestedCols = ns.column;
                    if nestedCols is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
                        foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in nestedCols {
                            string expr = check generateColumnExpression(col, forEachCtx);
                            parts.push(expr + " AS \"" + col.name + "\"");
                        }
                    }
                }
            } else {
                // Non-forEach nested: use base context.
                sql_on_fhir_lib:ViewDefinitionSelectColumn[]? nestedCols = ns.column;
                if nestedCols is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
                    foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in nestedCols {
                        string expr = check generateColumnExpression(col, ctx);
                        parts.push(expr + " AS \"" + col.name + "\"");
                    }
                }
            }
        }
    }

    // Chosen unionAll branch columns.
    sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
    if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionChoice >= 0 && unionChoice < unionAll.length() {
        sql_on_fhir_lib:ViewDefinitionSelect branch = unionAll[unionChoice];
        TranspilerContext? branchCtx = lookupForEachContext(contextMap, branch);
        TranspilerContext effectiveCtx = branchCtx is TranspilerContext ? branchCtx : ctx;
        sql_on_fhir_lib:ViewDefinitionSelectColumn[]? branchCols = branch.column;
        if branchCols is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
            foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in branchCols {
                string expr = check generateColumnExpression(col, effectiveCtx);
                parts.push(expr + " AS \"" + col.name + "\"");
            }
        }
    }

    return parts;
}

// ========================================
// PRIVATE UTILITIES
// ========================================

# Extract the forEach path string from a select element.
#
# Returns `forEach` if set, otherwise `forEachOrNull`. Returns `""` if neither
# is set (which should not occur when this function is called correctly).
#
# + sel - The select element
# + return - The raw forEach path string
isolated function resolveForEachPath(sql_on_fhir_lib:ViewDefinitionSelect sel) returns string {
    string? fe = sel.forEach;
    if fe is string {
        return fe;
    }
    string? feon = sel.forEachOrNull;
    if feon is string {
        return feon;
    }
    return "";
}

# Find the index of a select element in a combination by reference identity.
#
# + combination - The select combination to search
# + sel - The select element to find
# + return - The index, or `-1` if not found
isolated function indexOfSelect(SelectCombination combination, sql_on_fhir_lib:ViewDefinitionSelect sel) returns int {
    foreach int i in 0 ..< combination.selects.length() {
        if combination.selects[i] === sel {
            return i;
        }
    }
    return -1;
}
