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
// SQL-ON-FHIR REPEAT STATEMENT GENERATOR
// ========================================
// Generates PostgreSQL SELECT statements with recursive CTEs for
// sql_on_fhir_lib:ViewDefinition select elements that use `repeat`.
//
// PostgreSQL equivalent of the T-SQL RepeatProcessor (recursive CTE with
// CROSS APPLY OPENJSON). The CTE has columns (resource_id, item_json, depth):
//   - resource_id uses `ctid` (PostgreSQL row identifier) so the CTE can
//     INNER JOIN back to the resource table without assuming an id column.
//   - item_json holds the current element; column expressions inside the
//     repeat use `<cteAlias>.item_json` as their iteration context.
//   - depth increments on each recursion.
//
// The CTE definitions themselves are returned without the `WITH RECURSIVE`
// keyword so they can be consolidated at the top of the query when multiple
// unionAll combinations each contribute their own CTEs.

// ========================================
// INTERNAL TYPES
// ========================================

# Associates a repeat select with its CTE alias, paths, source JSONB expression,
# and derived transpiler context (whose `iterationContext` points to `<cte>.item_json`).
#
# + sel - The repeat select element (reference identity is the lookup key)
# + ctx - The transpiler context for columns directly under this repeat
# + cteAlias - Unique CTE alias (e.g., `"repeat_0"`)
# + paths - FHIRPath expressions to follow recursively (from `sel.repeat`)
# + sourceExpr - JSONB source for the anchor (e.g., `"r.resource"`)
type RepeatEntry record {|
    sql_on_fhir_lib:ViewDefinitionSelect sel;
    TranspilerContext ctx;
    string cteAlias;
    string[] paths;
    string sourceExpr;
|};

// ========================================
// API
// ========================================

# Generate a SELECT statement using a recursive CTE for repeat traversal.
#
# Called when a `SelectCombination` contains at least one `repeat` directive.
# Emits the CTE definitions separately so the caller can consolidate them under
# a single `WITH RECURSIVE` clause at the top of the final query.
#
# + combination - The select combination to generate SQL for
# + viewDef - The sql_on_fhir_lib:ViewDefinition
# + ctx - The transpiler context
# + startCounter - Starting counter for CTE alias generation (shared across combinations)
# + return - `[statement, cteDefinitions, nextCounter]` or an error
isolated function generateRepeatStatement(
        SelectCombination combination,
        sql_on_fhir_lib:ViewDefinition viewDef,
        TranspilerContext ctx,
        int startCounter) returns [string, string[], int]|error {

    string fromClause = generateFromClause(ctx.resourceAlias, ctx.tableName);

    [RepeatEntry[], sql_on_fhir_lib:ViewDefinitionSelect[], int] repeatResult =
        buildRepeatContextMap(combination.selects, ctx, combination, startCounter);
    RepeatEntry[] repeatEntries = repeatResult[0];
    int nextCounter = repeatResult[2];

    string[] cteDefs = [];
    foreach RepeatEntry entry in repeatEntries {
        cteDefs.push(buildRepeatCteDefinition(entry, ctx.resourceAlias, ctx.tableName));
    }

    string joinClauses = buildRepeatJoinClauses(repeatEntries, ctx.resourceAlias);

    [ForEachEntry[], sql_on_fhir_lib:ViewDefinitionSelect[]] feResult =
        buildForEachEntriesForRepeat(combination, repeatEntries, ctx);
    ForEachEntry[] forEachEntries = feResult[0];
    sql_on_fhir_lib:ViewDefinitionSelect[] topLevelForEach = feResult[1];

    string lateralClauses = buildLateralJoinClauses(forEachEntries, topLevelForEach, combination);

    string selectClause = check generateRepeatSelectClause(
            combination, ctx, repeatEntries, forEachEntries);
    string? whereClause = check buildWhereClause(ctx.resourceAlias, viewDef.'where, ctx);

    string statement = selectClause + "\n" + fromClause + joinClauses + lateralClauses;
    if whereClause is string {
        statement += "\n" + whereClause;
    }

    return [statement, cteDefs, nextCounter];
}

// ========================================
// REPEAT CONTEXT MAP
// ========================================

# Collect top-level repeat select elements and build a `RepeatEntry` for each.
#
# A repeat select is considered top-level when it:
# - Appears directly as a select in the combination, or
# - Is nested one level inside a non-repeat select's `select` array, or
# - Is the chosen unionAll branch.
#
# + selects - Top-level select elements from the combination
# + baseCtx - The base transpiler context
# + combination - The select combination (used for union branch resolution)
# + startCounter - Starting counter for CTE alias generation
# + return - `[entries, topLevelRepeat, nextCounter]`
isolated function buildRepeatContextMap(
        sql_on_fhir_lib:ViewDefinitionSelect[] selects,
        TranspilerContext baseCtx,
        SelectCombination combination,
        int startCounter) returns [RepeatEntry[], sql_on_fhir_lib:ViewDefinitionSelect[], int] {

    sql_on_fhir_lib:ViewDefinitionSelect[] topLevelRepeat = collectTopLevelRepeat(selects, combination);
    RepeatEntry[] entries = [];
    int counter = startCounter;
    string baseSource = baseCtx.resourceAlias + "." + baseCtx.resourceColumn;

    foreach sql_on_fhir_lib:ViewDefinitionSelect sel in topLevelRepeat {
        string cteAlias = "repeat_" + counter.toString();
        counter += 1;
        string[] paths = sel.repeat ?: [];

        TranspilerContext repeatCtx = {
            resourceAlias: baseCtx.resourceAlias,
            resourceColumn: baseCtx.resourceColumn,
            tableName: baseCtx.tableName,
            constants: baseCtx.constants,
            iterationContext: cteAlias + ".item_json",
            currentForEachAlias: cteAlias,
            forEachSource: baseSource,
            forEachPathSegments: ()
        };

        entries.push({
            sel: sel,
            ctx: repeatCtx,
            cteAlias: cteAlias,
            paths: paths,
            sourceExpr: baseSource
        });
    }

    return [entries, topLevelRepeat, counter];
}

# Scan top-level selects and return the ordered list of repeat selects to process.
#
# + selects - Top-level select elements to scan
# + combination - The select combination for union branch resolution
# + return - Ordered list of top-level repeat select elements
isolated function collectTopLevelRepeat(
        sql_on_fhir_lib:ViewDefinitionSelect[] selects,
        SelectCombination combination) returns sql_on_fhir_lib:ViewDefinitionSelect[] {

    sql_on_fhir_lib:ViewDefinitionSelect[] result = [];

    foreach sql_on_fhir_lib:ViewDefinitionSelect sel in selects {
        if isRepeatSelect(sel) {
            result.push(sel);
            continue;
        }

        sql_on_fhir_lib:ViewDefinitionSelect[]? nested = sel.'select;
        if nested is sql_on_fhir_lib:ViewDefinitionSelect[] {
            foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nested {
                if isRepeatSelect(ns) {
                    result.push(ns);
                }
            }
        }

        int selIdx = indexOfSelect(combination, sel);
        if selIdx < 0 {
            continue;
        }
        int unionChoice = combination.unionChoices[selIdx];
        sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
        if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionChoice >= 0 && unionChoice < unionAll.length() {
            sql_on_fhir_lib:ViewDefinitionSelect branch = unionAll[unionChoice];
            if isRepeatSelect(branch) {
                result.push(branch);
            } else {
                sql_on_fhir_lib:ViewDefinitionSelect[]? branchNested = branch.'select;
                if branchNested is sql_on_fhir_lib:ViewDefinitionSelect[] {
                    foreach sql_on_fhir_lib:ViewDefinitionSelect ns in branchNested {
                        if isRepeatSelect(ns) {
                            result.push(ns);
                        }
                    }
                }
            }
        }
    }

    return result;
}

# Check whether a select element carries a non-empty `repeat` directive.
#
# + sel - The select element to check
# + return - `true` if `sel.repeat` is a non-empty array
isolated function isRepeatSelect(sql_on_fhir_lib:ViewDefinitionSelect sel) returns boolean {
    string[]? rep = sel.repeat;
    return rep is string[] && rep.length() > 0;
}

// ========================================
// CTE DEFINITION BUILDER
// ========================================

# Build a single recursive CTE definition (without the `WITH RECURSIVE` keyword).
#
# The CTE has this shape:
# ```
# repeat_N AS (
#   SELECT r.ctid AS resource_id, anchor.value AS item_json, 0 AS depth
#   FROM <table> AS r
#   CROSS JOIN LATERAL jsonb_array_elements(<source>->'<firstPath>') AS anchor(value)
#   (no resource type filter — caller is responsible for table/query scope)
#   UNION ALL
#   <one recursive SELECT per path, unioned>
# )
# ```
#
# Only the first path is used for the anchor member (matches TS reference
# semantics: subsequent paths like `answer.item` describe traversal patterns
# from within the tree, not entry points from the root).
#
# + entry - The repeat entry
# + resourceAlias - SQL alias for the resource table
# + tableName - The SQL table name
# + return - The CTE definition string (without `WITH RECURSIVE`)
isolated function buildRepeatCteDefinition(
        RepeatEntry entry,
        string resourceAlias,
        string tableName) returns string {

    string firstPath = entry.paths[0];
    string anchor = "SELECT " + resourceAlias + ".ctid AS resource_id, anchor.value AS item_json, 0 AS depth\n"
        + "  FROM " + tableName + " AS " + resourceAlias + "\n"
        + "  CROSS JOIN LATERAL jsonb_array_elements(" + entry.sourceExpr + "->'" + firstPath
        + "') AS anchor(value)";

    // PostgreSQL imposes two constraints on recursive CTEs:
    // 1. The recursive CTE name must not appear in the non-recursive (anchor) term.
    // 2. The recursive CTE name must not appear more than once in the recursive term
    //    (and not inside a subquery within that term).
    //
    // For a single path: the recursive term is one SELECT referencing the CTE once — safe.
    //
    // For multiple paths: naively UNIONing multiple SELECTs each referencing the CTE
    // violates constraint 2. The fix is to reference the CTE exactly ONCE (as `cte`)
    // and combine all paths inside a CROSS JOIN LATERAL subquery that only touches
    // `cte.item_json` — not the CTE name itself.
    string recursivePart;
    if entry.paths.length() == 1 {
        recursivePart = buildRepeatRecursiveMember(entry.paths[0], entry.cteAlias, 0);
    } else {
        recursivePart = buildMultiPathRecursiveMember(entry.paths, entry.cteAlias);
    }

    return entry.cteAlias + " AS (\n  " + anchor + "\n  UNION ALL\n  " + recursivePart + "\n)";
}

# Build one recursive-member SELECT for a single repeat path.
#
# Single-segment path (`"item"`):
# ```
# SELECT cte.resource_id, child_0.value AS item_json, cte.depth + 1
#   FROM repeat_0 AS cte
#   CROSS JOIN LATERAL jsonb_array_elements(cte.item_json->'item') AS child_0(value)
# ```
#
# Multi-segment path (`"answer.item"`) chains a LATERAL join per segment:
# ```
# SELECT cte.resource_id, child_1_1.value AS item_json, cte.depth + 1
#   FROM repeat_0 AS cte
#   CROSS JOIN LATERAL jsonb_array_elements(cte.item_json->'answer') AS child_1_0(value)
#   CROSS JOIN LATERAL jsonb_array_elements(child_1_0.value->'item') AS child_1_1(value)
# ```
#
# + path - The FHIRPath expression (e.g., `"item"` or `"answer.item"`)
# + cteAlias - The CTE alias (e.g., `"repeat_0"`)
# + index - Index of this path (used for alias uniqueness)
# + return - SQL fragment for the recursive member
isolated function buildRepeatRecursiveMember(string path, string cteAlias, int index) returns string {
    string[] segments = re `\.`.split(path);

    if segments.length() == 1 {
        string alias = "child_" + index.toString();
        return "SELECT cte.resource_id, " + alias + ".value AS item_json, cte.depth + 1\n"
            + "  FROM " + cteAlias + " AS cte\n"
            + "  CROSS JOIN LATERAL jsonb_array_elements(cte.item_json->'" + segments[0]
            + "') AS " + alias + "(value)";
    }

    string crossJoins = "";
    string currentSource = "cte.item_json";
    foreach int i in 0 ..< segments.length() {
        string alias = "child_" + index.toString() + "_" + i.toString();
        crossJoins += "\n  CROSS JOIN LATERAL jsonb_array_elements(" + currentSource + "->'"
            + segments[i] + "') AS " + alias + "(value)";
        currentSource = alias + ".value";
    }
    string finalAlias = "child_" + index.toString() + "_" + (segments.length() - 1).toString();
    return "SELECT cte.resource_id, " + finalAlias + ".value AS item_json, cte.depth + 1\n"
        + "  FROM " + cteAlias + " AS cte" + crossJoins;
}

# Build the recursive member for a repeat CTE with 2+ paths using a single
# `CROSS JOIN LATERAL` subquery that references the CTE exactly once.
#
# PostgreSQL requires the recursive CTE name to appear at most once in the
# recursive term and never inside a subquery. To support N paths without
# multiple CTE references, we write:
# ```
# SELECT cte.resource_id, paths.item_json, cte.depth + 1
#   FROM <cteAlias> AS cte
#   CROSS JOIN LATERAL (
#     <path_0_query>
#     UNION ALL
#     <path_1_query>
#     ...
#   ) AS paths
# ```
# Each inner path query references only `cte.item_json`, not `<cteAlias>`.
#
# + paths - All repeat paths (2 or more)
# + cteAlias - The CTE alias
# + return - SQL fragment for the recursive member
isolated function buildMultiPathRecursiveMember(string[] paths, string cteAlias) returns string {
    string[] pathQueries = [];
    foreach int i in 0 ..< paths.length() {
        pathQueries.push(buildLateralPathQuery(paths[i], i));
    }
    string innerUnion = string:'join("\n    UNION ALL\n    ", ...pathQueries);
    return "SELECT cte.resource_id, paths.item_json, cte.depth + 1\n"
        + "  FROM " + cteAlias + " AS cte\n"
        + "  CROSS JOIN LATERAL (\n    " + innerUnion + "\n  ) AS paths";
}

# Build one path query (a single SELECT) for use inside a multi-path LATERAL subquery.
#
# Single-segment (`"item"`):
# ```
# SELECT path_0.value AS item_json
# FROM jsonb_array_elements(cte.item_json->'item') AS path_0
# ```
#
# Multi-segment (`"answer.item"`):
# ```
# SELECT path_1_1.value AS item_json
# FROM jsonb_array_elements(cte.item_json->'answer') AS path_1_0
# CROSS JOIN jsonb_array_elements(path_1_0.value->'item') AS path_1_1
# ```
#
# + path - The FHIRPath expression (e.g., `"item"` or `"answer.item"`)
# + index - Index of this path (for alias uniqueness)
# + return - SQL SELECT fragment (without trailing semicolon)
isolated function buildLateralPathQuery(string path, int index) returns string {
    string[] segments = re `\.`.split(path);

    if segments.length() == 1 {
        string alias = "path_" + index.toString();
        return "SELECT " + alias + ".value AS item_json\n"
            + "    FROM jsonb_array_elements(cte.item_json->'" + segments[0] + "') AS " + alias;
    }

    string froms = "";
    string currentSource = "cte.item_json";
    foreach int i in 0 ..< segments.length() {
        string alias = "path_" + index.toString() + "_" + i.toString();
        string joinClause = i == 0 ? "FROM " : "CROSS JOIN ";
        froms += "\n    " + joinClause + "jsonb_array_elements(" + currentSource + "->'" + segments[i] + "') AS " + alias;
        currentSource = alias + ".value";
    }
    string finalAlias = "path_" + index.toString() + "_" + (segments.length() - 1).toString();
    return "SELECT " + finalAlias + ".value AS item_json" + froms;
}

// ========================================
// JOIN CLAUSE BUILDER
// ========================================

# Build INNER JOIN clauses linking each repeat CTE back to the resource table.
#
# + entries - The repeat entries
# + resourceAlias - SQL alias for the resource table
# + return - Concatenated `\nINNER JOIN … ON …` clauses (one per CTE)
isolated function buildRepeatJoinClauses(RepeatEntry[] entries, string resourceAlias) returns string {
    string clauses = "";
    foreach RepeatEntry entry in entries {
        clauses += "\nINNER JOIN " + entry.cteAlias + " ON " + entry.cteAlias
            + ".resource_id = " + resourceAlias + ".ctid";
    }
    return clauses;
}

// ========================================
// NESTED FOREACH INTEGRATION
// ========================================

# Build forEach entries for a combination that is being processed as a repeat.
#
# Rules (applied per top-level select in the combination):
# - Top-level repeat select: collect its forEach children and build entries whose
# source is `<cteAlias>.item_json` so LATERAL JOINs unnest from within the CTE.
# - Top-level forEach select: build entries starting from `r.resource` (same as
# standalone forEach). These live alongside the repeat in the same combination.
# - Plain top-level select: recurse into its nested selects; forEach children
# use `r.resource`, repeat children are already handled by the CTE.
# - Chosen unionAll branches follow the same classification as above.
#
# + combination - The select combination
# + repeatEntries - Repeat entries already built for this combination
# + baseCtx - The base transpiler context
# + return - `[forEachEntries, topLevelForEach]`
isolated function buildForEachEntriesForRepeat(
        SelectCombination combination,
        RepeatEntry[] repeatEntries,
        TranspilerContext baseCtx) returns [ForEachEntry[], sql_on_fhir_lib:ViewDefinitionSelect[]] {

    ForEachEntry[] entries = [];
    sql_on_fhir_lib:ViewDefinitionSelect[] topLevelForEach = [];
    int counter = 0;
    string baseSource = baseCtx.resourceAlias + "." + baseCtx.resourceColumn;

    foreach int i in 0 ..< combination.selects.length() {
        sql_on_fhir_lib:ViewDefinitionSelect sel = combination.selects[i];
        int unionChoice = combination.unionChoices[i];

        if isRepeatSelect(sel) {
            counter = collectForEachChildrenOfRepeat(
                    sel, repeatEntries, baseCtx, counter, entries, topLevelForEach);
        } else if sel.forEach is string || sel.forEachOrNull is string {
            [ForEachEntry[], int] r = buildForEachEntries(sel, baseSource, baseCtx, counter);
            foreach ForEachEntry e in r[0] {
                entries.push(e);
            }
            topLevelForEach.push(sel);
            counter = r[1];
        } else {
            counter = collectForEachFromPlainSelect(
                    sel, repeatEntries, baseCtx, baseSource, counter, entries, topLevelForEach);
        }

        sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
        if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionChoice >= 0 && unionChoice < unionAll.length() {
            sql_on_fhir_lib:ViewDefinitionSelect branch = unionAll[unionChoice];
            if isRepeatSelect(branch) {
                counter = collectForEachChildrenOfRepeat(
                        branch, repeatEntries, baseCtx, counter, entries, topLevelForEach);
            } else if branch.forEach is string || branch.forEachOrNull is string {
                [ForEachEntry[], int] r = buildForEachEntries(branch, baseSource, baseCtx, counter);
                foreach ForEachEntry e in r[0] {
                    entries.push(e);
                }
                topLevelForEach.push(branch);
                counter = r[1];
            } else {
                counter = collectForEachFromPlainSelect(
                        branch, repeatEntries, baseCtx, baseSource, counter, entries, topLevelForEach);
            }
        }
    }

    return [entries, topLevelForEach];
}

# Append forEach entries for forEach children of a repeat select. Nested forEach
# children source from `<cteAlias>.item_json` so their LATERAL JOIN unnests from
# within the CTE rather than from the raw resource JSONB.
#
# + repeatSel - The repeat select whose forEach children should be collected
# + repeatEntries - The repeat entries already built for this combination (used to resolve the CTE source)
# + baseCtx - The base transpiler context
# + startCounter - The current forEach alias counter
# + entries - Mutable list to which new forEach entries are appended
# + topLevelForEach - Mutable list to which new top-level forEach selects are appended
# + return - The next forEach alias counter value
isolated function collectForEachChildrenOfRepeat(
        sql_on_fhir_lib:ViewDefinitionSelect repeatSel,
        RepeatEntry[] repeatEntries,
        TranspilerContext baseCtx,
        int startCounter,
        ForEachEntry[] entries,
        sql_on_fhir_lib:ViewDefinitionSelect[] topLevelForEach) returns int {

    int counter = startCounter;
    string cteSource = getCteSourceForSelect(repeatSel, repeatEntries);
    if cteSource == "" {
        return counter;
    }

    sql_on_fhir_lib:ViewDefinitionSelect[]? nested = repeatSel.'select;
    if nested is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nested {
            if ns.forEach is string || ns.forEachOrNull is string {
                [ForEachEntry[], int] r = buildForEachEntries(ns, cteSource, baseCtx, counter);
                foreach ForEachEntry e in r[0] {
                    entries.push(e);
                }
                topLevelForEach.push(ns);
                counter = r[1];
            }
        }
    }
    return counter;
}

# Append forEach entries for forEach children of a plain (non-forEach, non-repeat)
# select. Nested forEach children source from `r.resource`; nested repeat children
# are delegated to `collectForEachChildrenOfRepeat`.
#
# + sel - The plain select whose nested children should be scanned
# + repeatEntries - The repeat entries already built for this combination
# + baseCtx - The base transpiler context
# + baseSource - The base JSONB source expression (e.g., `"r.resource"`)
# + startCounter - The current forEach alias counter
# + entries - Mutable list to which new forEach entries are appended
# + topLevelForEach - Mutable list to which new top-level forEach selects are appended
# + return - The next forEach alias counter value
isolated function collectForEachFromPlainSelect(
        sql_on_fhir_lib:ViewDefinitionSelect sel,
        RepeatEntry[] repeatEntries,
        TranspilerContext baseCtx,
        string baseSource,
        int startCounter,
        ForEachEntry[] entries,
        sql_on_fhir_lib:ViewDefinitionSelect[] topLevelForEach) returns int {

    int counter = startCounter;
    sql_on_fhir_lib:ViewDefinitionSelect[]? nested = sel.'select;
    if nested is sql_on_fhir_lib:ViewDefinitionSelect[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nested {
            if ns.forEach is string || ns.forEachOrNull is string {
                [ForEachEntry[], int] r = buildForEachEntries(ns, baseSource, baseCtx, counter);
                foreach ForEachEntry e in r[0] {
                    entries.push(e);
                }
                topLevelForEach.push(ns);
                counter = r[1];
            } else if isRepeatSelect(ns) {
                counter = collectForEachChildrenOfRepeat(
                        ns, repeatEntries, baseCtx, counter, entries, topLevelForEach);
            }
        }
    }
    return counter;
}

# Look up the CTE-backed source expression for a repeat select by reference identity.
#
# + sel - The select element
# + entries - The repeat entries
# + return - `<cteAlias>.item_json`, or `""` if no matching entry
isolated function getCteSourceForSelect(sql_on_fhir_lib:ViewDefinitionSelect sel, RepeatEntry[] entries) returns string {
    foreach RepeatEntry entry in entries {
        if entry.sel === sel {
            return entry.cteAlias + ".item_json";
        }
    }
    return "";
}

// ========================================
// SELECT CLAUSE BUILDER
// ========================================

# Build the SELECT clause for a repeat statement.
#
# For each select in the combination, uses the appropriate context:
# - forEach context (`forEach_N.value`) for columns directly under a forEach select.
# - repeat context (`<cte>.item_json`) for columns under the repeat and its
# non-forEach descendants.
# - base context for columns under top-level non-repeat, non-forEach selects.
#
# + combination - The select combination
# + baseCtx - The base transpiler context
# + repeatEntries - Repeat entries for this combination
# + forEachEntries - ForEach entries for this combination
# + return - The SELECT clause string, or an error
isolated function generateRepeatSelectClause(
        SelectCombination combination,
        TranspilerContext baseCtx,
        RepeatEntry[] repeatEntries,
        ForEachEntry[] forEachEntries) returns string|error {

    string[] columnParts = [];

    foreach int i in 0 ..< combination.selects.length() {
        sql_on_fhir_lib:ViewDefinitionSelect sel = combination.selects[i];
        int unionChoice = combination.unionChoices[i];

        TranspilerContext selCtx = selectContextFor(sel, baseCtx, repeatEntries, forEachEntries);
        check appendColumns(sel.column, selCtx, columnParts);

        sql_on_fhir_lib:ViewDefinitionSelect[]? nested = sel.'select;
        if nested is sql_on_fhir_lib:ViewDefinitionSelect[] {
            foreach sql_on_fhir_lib:ViewDefinitionSelect ns in nested {
                TranspilerContext nsCtx = selectContextFor(ns, selCtx, repeatEntries, forEachEntries);
                check appendColumns(ns.column, nsCtx, columnParts);
            }
        }

        sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
        if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionChoice >= 0 && unionChoice < unionAll.length() {
            sql_on_fhir_lib:ViewDefinitionSelect branch = unionAll[unionChoice];
            TranspilerContext branchCtx = selectContextFor(branch, selCtx, repeatEntries, forEachEntries);
            check appendColumns(branch.column, branchCtx, columnParts);

            sql_on_fhir_lib:ViewDefinitionSelect[]? branchNested = branch.'select;
            if branchNested is sql_on_fhir_lib:ViewDefinitionSelect[] {
                foreach sql_on_fhir_lib:ViewDefinitionSelect ns in branchNested {
                    TranspilerContext nsCtx = selectContextFor(ns, branchCtx, repeatEntries, forEachEntries);
                    check appendColumns(ns.column, nsCtx, columnParts);
                }
            }
        }
    }

    if columnParts.length() == 0 {
        return "SELECT *";
    }
    return "SELECT\n  " + string:'join(",\n  ", ...columnParts);
}

# Append `expr AS "name"` strings for a list of columns using the given context.
#
# + columns - The column list (may be `()` — in which case this is a no-op)
# + ctx - The transpiler context to use when generating each column expression
# + columnParts - Mutable list to which `expr AS "name"` strings are appended
# + return - `()` on success, or an error from `generateColumnExpression`
isolated function appendColumns(
        sql_on_fhir_lib:ViewDefinitionSelectColumn[]? columns,
        TranspilerContext ctx,
        string[] columnParts) returns error? {
    if columns is sql_on_fhir_lib:ViewDefinitionSelectColumn[] {
        foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in columns {
            string expr = check generateColumnExpression(col, ctx);
            columnParts.push(expr + " AS \"" + col.name + "\"");
        }
    }
}

# Resolve the transpiler context for a select element.
#
# Lookup order:
# 1. Matching forEach entry → forEach context
# 2. Matching repeat entry → repeat context
# 3. Fall back to `parentCtx` (inherited from the enclosing select)
#
# + sel - The select element whose context is being resolved
# + parentCtx - The context to inherit when no forEach/repeat entry matches
# + repeatEntries - Repeat entries for this combination
# + forEachEntries - ForEach entries for this combination
# + return - The resolved transpiler context
isolated function selectContextFor(
        sql_on_fhir_lib:ViewDefinitionSelect sel,
        TranspilerContext parentCtx,
        RepeatEntry[] repeatEntries,
        ForEachEntry[] forEachEntries) returns TranspilerContext {
    foreach ForEachEntry e in forEachEntries {
        if e.sel === sel {
            return e.ctx;
        }
    }
    foreach RepeatEntry e in repeatEntries {
        if e.sel === sel {
            return e.ctx;
        }
    }
    return parentCtx;
}
