// Copyright (c) 2023-2026, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// ========================================
// FHIRPATH TO POSTGRESQL TRANSPILER
// ========================================
// Converts FHIRPath expressions to PostgreSQL SQL using JSONB functions.
// Walks the AST produced by parser.bal and generates SQL expressions.

// ========================================
// TYPE DEFINITIONS
// ========================================

# Context passed to the transpiler, controlling how SQL is generated.
#
# + resourceAlias - The SQL table alias for the resource (e.g., "r")
# + resourceColumn - The column name holding the JSONB resource data (e.g., "resource" or "RESOURCE_JSON")
# + tableName - The SQL table name to query (e.g., "fhir_resources" or "PatientTable")
# + constants - External constants (%name references in FHIRPath)
# + iterationContext - Current iteration context expression (e.g., "whereItem.value")
# + currentForEachAlias - forEach alias (e.g., "forEach_0")
# + forEachSource - forEach source (e.g., "r.resource")
# + forEachPathSegments - forEach path segments (e.g., ["name"])
# + testId - Optional test identifier
public type TranspilerContext record {|
    string resourceAlias = "r";
    string resourceColumn;
    string tableName;
    map<string|int|float|boolean?> constants?;
    string? iterationContext = ();
    string? currentForEachAlias = ();
    string? forEachSource = ();
    string[]? forEachPathSegments = ();
    string? testId = ();
|};

# Tag on a ViewDefinition column for type override.
#
# + name - The tag name (e.g., "pg/type", "ansi/type")
# + value - The tag value (e.g., "TEXT", "INTEGER")
type ColumnTag record {|
    string name;
    string value;
|};

# Error type for transpiler failures.
public type FhirPathPostgresTranspilerError distinct error;

// ========================================
// CONSTANTS
// ========================================

final string[] & readonly KNOWN_ARRAY_FIELDS = [
    "name",
    "given",
    "telecom",
    "address",
    "line",
    "identifier",
    "extension",
    "contact",
    "output",
    "item",
    "udiCarrier",
    "coding",
    "component"
];

final string[] & readonly ALWAYS_ARRAY_FIELDS = [
    "given",
    "telecom",
    "address",
    "line",
    "identifier",
    "extension",
    "contact",
    "output",
    "item",
    "udiCarrier",
    "coding",
    "component"
];

final string[] & readonly POLYMORPHIC_FIELDS = ["value", "onset", "effective", "deceased", "identified"];

final map<string> & readonly TYPE_SUFFIX_MAP = {
    "integer": "Integer",
    "string": "String",
    "boolean": "Boolean",
    "decimal": "Decimal",
    "dateTime": "DateTime",
    "date": "Date",
    "time": "Time",
    "instant": "Instant",
    "uri": "Uri",
    "url": "Url",
    "canonical": "Canonical",
    "uuid": "Uuid",
    "oid": "Oid",
    "id": "Id",
    "code": "Code",
    "markdown": "Markdown",
    "base64Binary": "Base64Binary",
    "positiveInt": "PositiveInt",
    "unsignedInt": "UnsignedInt",
    "integer64": "Integer64",
    "Period": "Period",
    "Range": "Range",
    "Quantity": "Quantity",
    "CodeableConcept": "CodeableConcept",
    "Reference": "Reference"
};

final map<string> & readonly FHIR_TO_PG_TYPE_MAP = {
    "id": "VARCHAR(64)",
    "boolean": "BOOLEAN",
    "integer": "INTEGER",
    "positiveint": "INTEGER",
    "unsignedint": "INTEGER",
    "integer64": "BIGINT",
    "uuid": "VARCHAR(100)",
    "oid": "VARCHAR(255)",
    "decimal": "TEXT",
    "date": "VARCHAR(10)",
    "datetime": "VARCHAR(50)",
    "instant": "VARCHAR(50)",
    "time": "VARCHAR(20)",
    "string": "TEXT",
    "markdown": "TEXT",
    "code": "TEXT",
    "uri": "TEXT",
    "url": "TEXT",
    "canonical": "TEXT",
    "base64binary": "BYTEA"
};

// ========================================
// PUBLIC API
// ========================================

# Transpiles a FHIRPath expression string to a PostgreSQL SQL expression.
#
# + expression - The FHIRPath expression text
# + context - The transpiler context
# + return - The generated SQL string on success, or an error
public isolated function transpile(string expression, TranspilerContext context) returns string|error {
    FhirPathToken[] tokens = check scanTokens(expression);
    Expr? ast = check parse(tokens);
    if ast is () {
        return error FhirPathPostgresTranspilerError("Empty expression");
    }
    return walkExpr(ast, context);
}

# Infers the PostgreSQL SQL type for a FHIR primitive type, with optional tag override.
#
# + fhirType - The FHIR type name (e.g., "string", "integer")
# + tags - Optional column tags for type overrides
# + return - The PostgreSQL type string
isolated function inferSqlType(string? fhirType = (), ColumnTag[]? tags = ()) returns string {
    if tags is ColumnTag[] {
        // Check for pg/type tag first (highest precedence)
        string? pgType = getTagValue(tags, "pg/type");
        if pgType is string {
            return pgType;
        }
        // Check for ansi/type tag
        string? ansiType = getTagValue(tags, "ansi/type");
        if ansiType is string {
            return convertAnsiToPostgres(ansiType);
        }
    }
    return getDefaultFhirTypeMapping(fhirType);
}

// ========================================
// CORE AST WALKER
// ========================================

# Walks an AST expression node and generates PostgreSQL SQL.
#
# + expr - The AST expression node to walk
# + ctx - The transpiler context
# + return - The generated SQL string or an error
isolated function walkExpr(Expr expr, TranspilerContext ctx) returns string|error {
    if expr is LiteralExpr {
        return walkLiteral(expr);
    } else if expr is IdentifierExpr {
        return walkIdentifier(expr, ctx);
    } else if expr is MemberAccessExpr {
        return walkMemberAccess(expr, ctx);
    } else if expr is BinaryExpr {
        return walkBinary(expr, ctx);
    } else if expr is FunctionExpr {
        return walkFunction(expr, ctx);
    } else {
        return walkIndexer(<IndexerExpr>expr, ctx);
    }
}

// ========================================
// EXPRESSION HANDLERS
// ========================================

# Walks a literal expression and returns its SQL representation.
#
# + expr - The literal expression node
# + return - The SQL representation of the literal
isolated function walkLiteral(LiteralExpr expr) returns string {
    anydata? val = expr.value;
    if val is () {
        return "NULL";
    } else if val is boolean {
        return val ? "'true'" : "'false'";
    } else if val is int {
        return val.toString();
    } else if val is float {
        return val.toString();
    } else if val is decimal {
        return val.toString();
    } else if val is string {
        string escaped = escapeQuotes(val);
        return string `'${escaped}'`;
    }
    return "NULL";
}

# Walks an identifier expression.
#
# + expr - The identifier expression node
# + ctx - The transpiler context
# + return - The SQL expression for the identifier
isolated function walkIdentifier(IdentifierExpr expr, TranspilerContext ctx) returns string {
    string name = expr.name;
    string? iterCtx = ctx.iterationContext;

    if iterCtx is string {
        if isKnownArrayField(name) {
            return string `jsonb_extract_path(${iterCtx}::jsonb, '${name}')`;
        }
        return string `jsonb_extract_path_text(${iterCtx}::jsonb, '${name}')`;
    }

    string src = string `${ctx.resourceAlias}.${ctx.resourceColumn}`;
    if name == "id" {
        return string `jsonb_extract_path_text(${src}, 'id')`;
    }
    if isKnownArrayField(name) {
        return string `jsonb_extract_path(${src}, '${name}')`;
    }
    return string `jsonb_extract_path_text(${src}, '${name}')`;
}

# Walks a binary expression (=, !=, and, or, xor).
#
# + expr - The binary expression node
# + ctx - The transpiler context
# + return - The SQL expression or an error
isolated function walkBinary(BinaryExpr expr, TranspilerContext ctx) returns string|error {
    string left = check walkExpr(expr.left, ctx);
    string right = check walkExpr(expr.right, ctx);

    TokenType op = expr.operator.tokenType;
    if op == EQUAL {
        return string `(${left} = ${right})`;
    } else if op == BANG_EQUAL {
        return string `(${left} != ${right})`;
    } else if op == AND {
        return string `(${left} AND ${right})`;
    } else if op == OR {
        return string `(${left} OR ${right})`;
    } else if op == XOR {
        return string `((${left} AND NOT ${right}) OR (NOT ${left} AND ${right}))`;
    }
    return error FhirPathPostgresTranspilerError(string `Unsupported binary operator: ${expr.operator.lexeme}`);
}

# Walks a member access expression (e.g., Patient.name, name.family).
#
# + expr - The member access expression node
# + ctx - The transpiler context
# + return - The SQL expression or an error
isolated function walkMemberAccess(MemberAccessExpr expr, TranspilerContext ctx) returns string|error {
    string base = check walkExpr(expr.target, ctx);
    string member = expr.member;

    // Handle subquery results from where()/extension()
    if base.startsWith("(SELECT ") {
        return handleSubqueryMemberAccess(base, member);
    }

    boolean memberIsArray = isKnownArrayField(member);

    // Try to extend existing jsonb_extract_path[_text] call
    string? extended = tryExtendPathCall(base, member, memberIsArray, ctx);
    if extended is string {
        return extended;
    }

    // Fallback: wrap base in new path call
    if memberIsArray {
        return string `jsonb_extract_path((${base})::jsonb, '${member}')`;
    }
    return string `jsonb_extract_path_text((${base})::jsonb, '${member}')`;
}

# Walks an indexer expression (e.g., name[0]).
#
# + expr - The indexer expression node
# + ctx - The transpiler context
# + return - The SQL expression or an error
isolated function walkIndexer(IndexerExpr expr, TranspilerContext ctx) returns string|error {
    string base = check walkExpr(expr.target, ctx);
    string index = check walkExpr(expr.index, ctx);

    // Try to extend existing path call with index as a segment
    string? extended = tryExtendPathCallWithIndex(base, index);
    if extended is string {
        return extended;
    }

    // Fallback: wrap
    return string `jsonb_extract_path_text((${base})::jsonb, '${index}')`;
}

// ========================================
// FUNCTION DISPATCH
// ========================================

# Walks a function expression and dispatches to the appropriate handler.
#
# + expr - The function expression node
# + ctx - The transpiler context
# + return - The SQL expression or an error
isolated function walkFunction(FunctionExpr expr, TranspilerContext ctx) returns string|error {
    // Walk target if present
    string? base = ();
    if expr.target is Expr {
        base = check walkExpr(<Expr>expr.target, ctx);
    }

    string name = expr.name;

    // Functions that need raw (untranspiled) parameter expressions
    if name == "where" {
        return handleWhere(base, expr.params, ctx);
    } else if name == "exists" {
        return handleExists(base, expr.params, ctx);
    } else if name == "ofType" {
        return handleOfType(base, expr.params, ctx);
    } else if name == "getReferenceKey" {
        return handleGetReferenceKey(base, expr.params, ctx);
    } else if name == "extension" {
        return handleExtension(base, expr.params, ctx);
    }

    // Functions that use transpiled parameters
    string[] args = [];
    foreach Expr param in expr.params {
        args.push(check walkExpr(param, ctx));
    }

    if name == "first" {
        return handleFirst(base, args, ctx);
    } else if name == "last" {
        return handleLast(base, args, ctx);
    } else if name == "count" {
        return handleCount(base, args, ctx);
    } else if name == "empty" {
        return handleEmpty(base, args, ctx);
    } else if name == "not" {
        return handleNot(base, args, ctx);
    } else if name == "join" {
        return handleJoin(base, args, ctx);
    } else if name == "select" {
        return handleSelect(base, args, ctx);
    } else if name == "getResourceKey" {
        return handleGetResourceKey(ctx);
    } else if name == "lowBoundary" || name == "highBoundary" {
        return handleBoundary(base, ctx);
    }

    return error FhirPathPostgresTranspilerError(string `Unsupported FHIRPath function: ${name}`);
}

// ========================================
// FUNCTION HANDLERS
// ========================================

# Handles the where(condition) function.
# Generates: (SELECT value FROM jsonb_array_elements(base) AS whereItem WHERE <cond> LIMIT 1)
#
# + base - The base SQL expression the function is called on
# + params - The raw parameter expressions (not yet transpiled)
# + ctx - The transpiler context
# + return - The SQL subquery or an error
isolated function handleWhere(string? base, Expr[] params, TranspilerContext ctx) returns string|error {
    if params.length() != 1 {
        return error FhirPathPostgresTranspilerError("where() function requires exactly one argument");
    }

    Expr filterExpr = params[0];

    // If base is at resource root level, transpile filter as a direct WHERE predicate
    if base is () || isResourceRootLevel(base, ctx) {
        return walkExpr(filterExpr, ctx);
    }

    // Extract source and build subquery
    string tableAlias = "whereItem";
    TranspilerContext itemCtx = {
        resourceAlias: tableAlias,
        resourceColumn: ctx.resourceColumn,
        tableName: ctx.tableName,
        constants: ctx.constants,
        iterationContext: string `${tableAlias}.value`
    };

    string condition = check walkExpr(filterExpr, itemCtx);
    string arraySource = buildArrayElementsSource(base);

    return string `(SELECT value FROM ${arraySource} AS ${tableAlias} WHERE ${condition} LIMIT 1)`;
}

# Handles the exists() function with optional filter argument.
#
# + base - The base SQL expression the function is called on
# + params - The raw parameter expressions
# + ctx - The transpiler context
# + return - The SQL EXISTS expression or an error
isolated function handleExists(string? base, Expr[] params, TranspilerContext ctx) returns string|error {
    // exists() with a filter argument
    if params.length() > 0 {
        Expr filterExpr = params[0];
        if base is string {
            string tableAlias = "existsItem";
            TranspilerContext itemCtx = {
                resourceAlias: tableAlias,
                resourceColumn: ctx.resourceColumn,
                tableName: ctx.tableName,
                constants: ctx.constants,
                iterationContext: string `${tableAlias}.value`
            };
            string condition = check walkExpr(filterExpr, itemCtx);
            string arraySource = buildArrayElementsSource(base);
            return string `EXISTS (SELECT 1 FROM ${arraySource} AS ${tableAlias} WHERE ${condition})`;
        }
        // No base, transpile argument directly
        string arg = check walkExpr(filterExpr, ctx);
        return string `(${arg} IS NOT NULL)`;
    }

    // exists() without arguments
    if base is string {
        string trimmed = base.trim();
        if trimmed.startsWith("(SELECT") {
            return string `EXISTS ${base}`;
        }
        if isBooleanExpression(base) {
            return base;
        }
        if base.includes("jsonb_extract_path(") && !base.includes("jsonb_extract_path_text(") {
            return string `(${base} IS NOT NULL AND jsonb_array_length(${base}) > 0)`;
        }
        return string `(${base} IS NOT NULL)`;
    }

    string? iterCtx = ctx.iterationContext;
    if iterCtx is string {
        string trimmed = iterCtx.trim();
        if trimmed.startsWith("EXISTS") {
            return iterCtx;
        }
        if trimmed.startsWith("(SELECT") {
            return string `EXISTS ${iterCtx}`;
        }
        if isBooleanExpression(trimmed) {
            return iterCtx;
        }
        if iterCtx.includes("jsonb_extract_path(") && !iterCtx.includes("jsonb_extract_path_text(") {
            return string `(${iterCtx} IS NOT NULL AND jsonb_array_length(${iterCtx}) > 0)`;
        }
        return string `(${iterCtx} IS NOT NULL)`;
    }

    return string `(${ctx.resourceAlias}.${ctx.resourceColumn} IS NOT NULL)`;
}

# Handles the first() function.
#
# + base - The base SQL expression the function is called on
# + args - The transpiled argument strings
# + ctx - The transpiler context
# + return - The SQL expression for the first element or an error
isolated function handleFirst(string? base, string[] args, TranspilerContext ctx) returns string|error {
    if base is string {
        // Base is already a text scalar (e.g. name.family after `name` auto-index);
        // first() on a singleton is the identity, don't append another '0' segment.
        if base.startsWith(PATH_TEXT_PREFIX) {
            return base;
        }
        // If base is a jsonb_extract_path (array), append '0' segment
        string? extended = tryExtendPathCallWithIndex(base, "0");
        if extended is string {
            // Switch to _text since we're getting a single element
            return switchToPathText(extended);
        }

        // If base is a subquery, add LIMIT 1
        if base.startsWith("(SELECT ") {
            if !base.includes("LIMIT") {
                // Insert LIMIT 1 before the closing paren
                string trimmed = base.substring(0, base.length() - 1);
                return string `${trimmed} LIMIT 1)`;
            }
            return base;
        }

        return string `jsonb_extract_path_text((${base})::jsonb, '0')`;
    }

    string? iterCtx = ctx.iterationContext;
    if iterCtx is string {
        if iterCtx.includes("jsonb_extract_path(") {
            string? ext = tryExtendPathCallWithIndex(iterCtx, "0");
            if ext is string {
                return switchToPathText(ext);
            }
        }
        return string `jsonb_extract_path_text((${iterCtx})::jsonb, '0')`;
    }

    string src = string `${ctx.resourceAlias}.${ctx.resourceColumn}`;
    return string `jsonb_extract_path_text(${src}, '0')`;
}

# Handles the last() function.
#
# + base - The base SQL expression the function is called on
# + args - The transpiled argument strings
# + ctx - The transpiler context
# + return - The SQL expression for the last element or an error
isolated function handleLast(string? base, string[] args, TranspilerContext ctx) returns string|error {
    string target = resolveTarget(base, ctx);
    return string `(${target} -> (jsonb_array_length(${target}) - 1))`;
}

# Handles the count() function.
#
# + base - The base SQL expression the function is called on
# + args - The transpiled argument strings
# + ctx - The transpiler context
# + return - The SQL expression for the array length or an error
isolated function handleCount(string? base, string[] args, TranspilerContext ctx) returns string|error {
    string target = resolveTarget(base, ctx);
    return string `jsonb_array_length(${target})`;
}

# Handles the empty() function.
#
# + base - The base SQL expression the function is called on
# + args - The transpiled argument strings
# + ctx - The transpiler context
# + return - The SQL boolean expression or an error
isolated function handleEmpty(string? base, string[] args, TranspilerContext ctx) returns string|error {
    if base is string {
        if base.includes("EXISTS") {
            return string `(NOT ${base})`;
        }
        // Array check
        if base.includes("jsonb_extract_path(") && !base.includes("jsonb_extract_path_text(") {
            return string `(${base} IS NULL OR jsonb_array_length(${base}) = 0)`;
        }
        return string `(${base} IS NULL)`;
    }

    string? iterCtx = ctx.iterationContext;
    if iterCtx is string {
        if iterCtx.includes("EXISTS") {
            return string `(NOT ${iterCtx})`;
        }
        if iterCtx.includes("jsonb_extract_path(") && !iterCtx.includes("jsonb_extract_path_text(") {
            return string `(${iterCtx} IS NULL OR jsonb_array_length(${iterCtx}) = 0)`;
        }
        return string `(${iterCtx} IS NULL)`;
    }

    string src = string `${ctx.resourceAlias}.${ctx.resourceColumn}`;
    return string `(${src} IS NULL)`;
}

# Handles the not() function.
#
# + base - The base SQL expression the function is called on
# + args - The transpiled argument strings
# + ctx - The transpiler context
# + return - The negated SQL expression or an error
isolated function handleNot(string? base, string[] args, TranspilerContext ctx) returns string|error {
    if base is string {
        return string `NOT (${base})`;
    }
    if args.length() > 0 {
        return string `NOT (${args[0]})`;
    }
    string? iterCtx = ctx.iterationContext;
    if iterCtx is string {
        return string `NOT (${iterCtx})`;
    }
    return "NOT (TRUE)";
}

# Handles the join(separator) function.
#
# + base - The base SQL expression the function is called on
# + args - The transpiled argument strings (first arg is the separator)
# + ctx - The transpiler context
# + return - The SQL string_agg expression or an error
isolated function handleJoin(string? base, string[] args, TranspilerContext ctx) returns string|error {
    string separator = args.length() > 0 ? args[0] : "''";
    string target = resolveTarget(base, ctx);

    // Check for nested array pattern: jsonb_extract_path(source, 'parent', '0', 'child')
    // This means we need to iterate ALL parent elements, not just [0]
    string[]? nested = detectNestedArrayPattern(target);
    if nested is string[] && nested.length() == 3 {
        string src = nested[0];
        string parentField = nested[1];
        string childField = nested[2];
        return string `COALESCE((SELECT string_agg(COALESCE(child.value #>> '{}', ''), ${separator} ORDER BY parent.ordinality, child.ordinality)
            FROM jsonb_array_elements(jsonb_extract_path(${src}, '${parentField}')) WITH ORDINALITY AS parent(value, ordinality),
            LATERAL jsonb_array_elements(parent.value -> '${childField}') WITH ORDINALITY AS child(value, ordinality)
            WHERE jsonb_typeof(child.value) IN ('string', 'number')), '')`;
    }

    // Standard join for simple arrays
    return string `COALESCE((SELECT string_agg(COALESCE(elem.value #>> '{}', ''), ${separator} ORDER BY elem.ordinality)
        FROM jsonb_array_elements(${target}) WITH ORDINALITY AS elem(value, ordinality)
        WHERE jsonb_typeof(elem.value) IN ('string', 'number')), '')`;
}

# Handles the select(expr) function.
#
# + base - The base SQL expression the function is called on
# + args - The transpiled argument strings
# + ctx - The transpiler context
# + return - The selected expression or an error
isolated function handleSelect(string? base, string[] args, TranspilerContext ctx) returns string|error {
    if args.length() != 1 {
        return error FhirPathPostgresTranspilerError("select() function requires exactly one argument");
    }
    return args[0];
}

# Handles the getResourceKey() function.
#
# + ctx - The transpiler context
# + return - The SQL expression for resource_type/id
isolated function handleGetResourceKey(TranspilerContext ctx) returns string {
    string src = string `${ctx.resourceAlias}.${ctx.resourceColumn}`;
    return string `jsonb_extract_path_text(${src}, 'resourceType') || '/' || jsonb_extract_path_text(${src}, 'id')`;
}

# Handles the ofType(type) function for polymorphic field mapping.
#
# + base - The base SQL expression the function is called on
# + params - The raw parameter expressions (type name)
# + ctx - The transpiler context
# + return - The SQL expression with the typed field name or an error
isolated function handleOfType(string? base, Expr[] params, TranspilerContext ctx) returns string|error {
    if params.length() != 1 {
        return error FhirPathPostgresTranspilerError("ofType() function requires exactly one argument");
    }
    if base is () {
        return error FhirPathPostgresTranspilerError("ofType() requires a target expression");
    }

    // Get the raw type name from the parameter (should be an identifier)
    Expr typeExpr = params[0];
    string typeName;
    if typeExpr is IdentifierExpr {
        typeName = typeExpr.name;
    } else {
        typeName = check walkExpr(typeExpr, ctx);
    }

    return applyPolymorphicFieldMapping(base, typeName);
}

# Handles the extension(url) function.
#
# + base - The base SQL expression the function is called on
# + params - The raw parameter expressions (extension URL)
# + ctx - The transpiler context
# + return - The SQL subquery filtering extensions by URL or an error
isolated function handleExtension(string? base, Expr[] params, TranspilerContext ctx) returns string|error {
    if params.length() != 1 {
        return error FhirPathPostgresTranspilerError("extension() function requires exactly one argument");
    }

    string extensionUrl = check walkExpr(params[0], ctx);
    string target;
    if base is string {
        target = base;
    } else if ctx.iterationContext is string {
        target = <string>ctx.iterationContext;
    } else {
        target = string `${ctx.resourceAlias}.${ctx.resourceColumn}`;
    }

    // Build: jsonb_extract_path(target, 'extension') for the array source
    string extArray;
    // Try to extend existing path call
    string? extended = tryExtendPathCall(target, "extension", true, ctx);
    if extended is string {
        extArray = extended;
    } else {
        extArray = string `jsonb_extract_path((${target})::jsonb, 'extension')`;
    }

    return string `(SELECT value FROM jsonb_array_elements(${extArray}) AS extItem WHERE extItem.value ->> 'url' = ${extensionUrl} LIMIT 1)`;
}

# Handles the getReferenceKey(type?) function.
#
# + base - The base SQL expression the function is called on
# + params - The raw parameter expressions (optional resource type filter)
# + ctx - The transpiler context
# + return - The SQL expression extracting the reference key or an error
isolated function handleGetReferenceKey(string? base, Expr[] params, TranspilerContext ctx) returns string|error {
    string? resourceType = ();
    if params.length() > 0 {
        Expr typeExpr = params[0];
        if typeExpr is IdentifierExpr {
            resourceType = typeExpr.name;
        } else {
            resourceType = check walkExpr(typeExpr, ctx);
        }
    }

    // Determine the reference source
    string refSource;
    if base is string {
        refSource = base;
    } else if ctx.iterationContext is string {
        refSource = <string>ctx.iterationContext;
    } else {
        return error FhirPathPostgresTranspilerError("getReferenceKey() requires a Reference object context");
    }

    // Extract .reference field
    string referenceExpr;
    string? extended = tryExtendPathCall(refSource, "reference", false, ctx);
    if extended is string {
        referenceExpr = extended;
    } else {
        referenceExpr = string `jsonb_extract_path_text((${refSource})::jsonb, 'reference')`;
    }

    // Optional type filter
    if resourceType is string {
        int prefixLen = resourceType.length() + 1;
        return string `CASE WHEN left(${referenceExpr}, ${prefixLen}) = '${resourceType}/' THEN ${referenceExpr} ELSE NULL END`;
    }

    return referenceExpr;
}

# Handles lowBoundary() and highBoundary() functions (pass-through).
#
# + base - The base SQL expression the function is called on
# + ctx - The transpiler context
# + return - The base expression passed through unchanged
isolated function handleBoundary(string? base, TranspilerContext ctx) returns string {
    if base is string {
        return base;
    }
    if ctx.iterationContext is string {
        return <string>ctx.iterationContext;
    }
    return string `${ctx.resourceAlias}.${ctx.resourceColumn}`;
}

// ========================================
// PATH MANIPULATION HELPERS
// ========================================

final string PATH_TEXT_PREFIX = "jsonb_extract_path_text(";
final string PATH_PREFIX = "jsonb_extract_path(";

# Extracts the inner arguments from a jsonb_extract_path[_text](...) call.
# Returns [inner_args, is_text_variant] or () if the base doesn't match.
#
# + base - The SQL expression to analyze
# + return - A tuple of [inner_args, is_text_variant] or () if not a path call
isolated function extractPathCallInner(string base) returns [string, boolean]? {
    if base.startsWith(PATH_TEXT_PREFIX) && base.endsWith(")") {
        string inner = base.substring(PATH_TEXT_PREFIX.length(), base.length() - 1);
        return [inner, true];
    }
    if base.startsWith(PATH_PREFIX) && !base.startsWith(PATH_TEXT_PREFIX) && base.endsWith(")") {
        string inner = base.substring(PATH_PREFIX.length(), base.length() - 1);
        return [inner, false];
    }
    return ();
}

# Tries to extend an existing jsonb_extract_path[_text] call by appending a segment.
# Returns () if the base doesn't match the expected pattern.
#
# + base - The SQL expression to extend
# + segment - The new path segment to append
# + asArray - Whether the result should use jsonb_extract_path (true) or jsonb_extract_path_text (false)
# + ctx - The transpiler context for array field logic
# + return - The extended path call or () if not extendable
isolated function tryExtendPathCall(string base, string segment, boolean asArray, TranspilerContext ctx) returns string? {
    [string, boolean]? extracted = extractPathCallInner(base);
    if extracted is () {
        return ();
    }
    string inner = extracted[0];
    string newSegment = string `'${segment}'`;

    // Check if the last segment is a known array field that needs [0] insertion
    string withImplicitIndex = maybeInsertArrayIndex(inner, ctx);

    if asArray {
        return string `jsonb_extract_path(${withImplicitIndex}, ${newSegment})`;
    }
    return string `jsonb_extract_path_text(${withImplicitIndex}, ${newSegment})`;
}

# Tries to extend an existing path call with an array index.
#
# + base - The SQL expression to extend
# + index - The array index to append as a path segment
# + return - The extended path call or () if not extendable
isolated function tryExtendPathCallWithIndex(string base, string index) returns string? {
    [string, boolean]? extracted = extractPathCallInner(base);
    if extracted is () {
        return ();
    }
    string inner = extracted[0];
    boolean isText = extracted[1];

    if isText {
        return string `jsonb_extract_path_text(${inner}, '${index}')`;
    }
    return string `jsonb_extract_path(${inner}, '${index}')`;
}

# Extracts the last quoted segment from path call inner args.
# e.g., "r.resource, 'name', 'given'" -> "given"
#
# + innerArgs - The inner arguments string of a path call
# + return - The last quoted segment or () if none found
isolated function extractLastQuotedSegment(string innerArgs) returns string? {
    // Find the last occurrence of ' ... ' at the end
    int lastQuote = lastIndexOf(innerArgs, "'");
    if lastQuote < 0 {
        return ();
    }
    // Find the opening quote before the last quote
    string beforeLastQuote = innerArgs.substring(0, lastQuote);
    int openQuote = lastIndexOf(beforeLastQuote, "'");
    if openQuote < 0 {
        return ();
    }
    return innerArgs.substring(openQuote + 1, lastQuote);
}

# Checks if the last path segment is a known array field and inserts '0' index if needed.
#
# + innerArgs - The inner arguments string of a path call
# + ctx - The transpiler context for forEach and iteration state
# + return - The inner arguments with '0' inserted if applicable
isolated function maybeInsertArrayIndex(string innerArgs, TranspilerContext ctx) returns string {
    string? lastField = extractLastQuotedSegment(innerArgs);
    if lastField is () {
        return innerArgs;
    }

    // Check if it's always an array field and we should add [0]
    if isAlwaysArrayField(lastField) {
        // Don't add [0] if this is the forEach array itself
        string[]? forEachSegs = ctx.forEachPathSegments;
        if forEachSegs is string[] && forEachSegs.length() > 0 {
            string lastForEachSeg = forEachSegs[forEachSegs.length() - 1];
            if lastForEachSeg == lastField {
                return innerArgs;
            }
        }
        // Don't add [0] if we're in an iteration context
        if ctx.iterationContext is string {
            return innerArgs;
        }
        return string `${innerArgs}, '0'`;
    }

    // "name" is special: array at Patient level but object in Contact
    if lastField == "name" && ctx.iterationContext is () {
        return string `${innerArgs}, '0'`;
    }

    return innerArgs;
}

# Handles member access on a subquery result.
# Rewrites SELECT clause to include member extraction.
#
# + base - The subquery SQL expression
# + member - The member name to access
# + return - The rewritten subquery with member extraction
isolated function handleSubqueryMemberAccess(string base, string member) returns string {
    // Check if it already has jsonb_extract_path_text in the SELECT
    if base.includes("SELECT jsonb_extract_path_text(value") {
        // Find ") FROM" to locate where the existing path call ends
        int? funcEnd = base.indexOf(") FROM ");
        int? fromIdx = base.indexOf(" FROM ");
        if funcEnd is int && fromIdx is int {
            // Insert new segment before the closing paren of jsonb_extract_path_text
            string beforeClose = base.substring(0, funcEnd);
            string afterClose = base.substring(funcEnd);
            return string `${beforeClose}, '${member}'${afterClose}`;
        }
    }

    if base.includes("SELECT value FROM") {
        int? fromIdx = base.indexOf(" FROM ");
        if fromIdx is int {
            string fromPart = base.substring(fromIdx);
            return string `(SELECT jsonb_extract_path_text(value::jsonb, '${member}')${fromPart}`;
        }
    }

    // Fallback: wrap the subquery
    return string `jsonb_extract_path_text((${base})::jsonb, '${member}')`;
}

# Detects nested array pattern in a path call for join optimization.
# Pattern: jsonb_extract_path(source, 'parent', '0', 'child')
# Returns [source, parentField, childField] or () if not matched.
#
# + target - The SQL expression to analyze
# + return - An array of [source, parentField, childField] or () if not a nested array pattern
isolated function detectNestedArrayPattern(string target) returns string[]? {
    [string, boolean]? extracted = extractPathCallInner(target);
    if extracted is () {
        return ();
    }
    string inner = extracted[0];

    // Parse the segments from inner args: source, 'parent', '0', 'child'
    string[] segments = extractQuotedSegments(inner);
    if segments.length() >= 3 {
        // Check if second-to-last segment is '0' (implicit first element)
        if segments[segments.length() - 2] == "0" {
            string childField = segments[segments.length() - 1];
            string parentField = segments[segments.length() - 3];
            // Reconstruct the source (everything before the quoted segments)
            string srcExpr = extractSourceFromInner(inner);
            return [srcExpr, parentField, childField];
        }
    }
    return ();
}

# Extracts all quoted segments from inner args.
# e.g., "r.resource, 'name', '0', 'given'" -> ["name", "0", "given"]
#
# + inner - The inner arguments string of a path call
# + return - An array of quoted segment values
isolated function extractQuotedSegments(string inner) returns string[] {
    string[] segments = [];
    int i = 0;
    while i < inner.length() {
        if inner.substring(i, i + 1) == "'" {
            // Find closing quote
            int? closeQuote = inner.indexOf("'", i + 1);
            if closeQuote is int {
                segments.push(inner.substring(i + 1, closeQuote));
                i = closeQuote + 1;
            } else {
                break;
            }
        } else {
            i = i + 1;
        }
    }
    return segments;
}

# Extracts the source expression (before the first quoted segment) from inner args.
# e.g., "r.resource, 'name', '0'" -> "r.resource"
#
# + inner - The inner arguments string of a path call
# + return - The source expression before any quoted segments
isolated function extractSourceFromInner(string inner) returns string {
    int? firstQuote = inner.indexOf("'", 0);
    if firstQuote is int && firstQuote > 0 {
        string beforeQuote = inner.substring(0, firstQuote).trim();
        // Remove trailing comma
        if beforeQuote.endsWith(",") {
            return beforeQuote.substring(0, beforeQuote.length() - 1).trim();
        }
        return beforeQuote;
    }
    return inner;
}

# Builds a jsonb_array_elements() source from a base expression.
#
# + base - The SQL expression representing a JSONB array
# + return - The jsonb_array_elements() wrapping of the base
isolated function buildArrayElementsSource(string base) returns string {
    // If base is already a jsonb_extract_path (returns jsonb), use directly
    if base.startsWith(PATH_PREFIX) && !base.startsWith(PATH_TEXT_PREFIX) {
        return string `jsonb_array_elements(${base})`;
    }
    // Otherwise cast to jsonb
    return string `jsonb_array_elements((${base})::jsonb)`;
}

# Switches a jsonb_extract_path call to jsonb_extract_path_text.
#
# + expr - The SQL expression to convert
# + return - The expression with jsonb_extract_path replaced by jsonb_extract_path_text
isolated function switchToPathText(string expr) returns string {
    if expr.startsWith(PATH_PREFIX) && !expr.startsWith(PATH_TEXT_PREFIX) {
        return PATH_TEXT_PREFIX + expr.substring(PATH_PREFIX.length());
    }
    return expr;
}

# Resolves the target expression from base, iteration context, or resource.
#
# + base - The optional base SQL expression
# + ctx - The transpiler context
# + return - The resolved target expression
isolated function resolveTarget(string? base, TranspilerContext ctx) returns string {
    if base is string {
        return base;
    }
    if ctx.iterationContext is string {
        return <string>ctx.iterationContext;
    }
    return string `${ctx.resourceAlias}.${ctx.resourceColumn}`;
}

// ========================================
// POLYMORPHIC FIELD HANDLING
// ========================================

# Applies polymorphic field mapping (e.g., value.ofType(integer) -> valueInteger).
#
# + base - The SQL expression containing a polymorphic field
# + typeName - The FHIR type name to map to
# + return - The SQL expression with the polymorphic field replaced by its typed variant
isolated function applyPolymorphicFieldMapping(string base, string typeName) returns string {
    string suffix = getTypeSuffix(typeName);

    // Find the last quoted segment in the base and check if it's polymorphic
    string? lastSeg = findLastQuotedSegmentBeforeCloseParen(base);
    if lastSeg is string && isPolymorphicField(lastSeg) {
        string newSeg = string `${lastSeg}${suffix}`;
        return replaceLastSegment(base, lastSeg, newSeg);
    }

    return base;
}

# Finds the last quoted segment before a closing paren in a string.
# e.g., "jsonb_extract_path_text(r.resource, 'name', 'value')" -> "value"
#
# + base - The SQL expression to search
# + return - The last quoted segment or () if not found
isolated function findLastQuotedSegmentBeforeCloseParen(string base) returns string? {
    // Look for the pattern 'segment') at the end
    int lastCloseParen = lastIndexOf(base, "')");
    if lastCloseParen < 0 {
        return ();
    }
    // Find the opening quote
    string beforeClose = base.substring(0, lastCloseParen);
    int openQuote = lastIndexOf(beforeClose, "'");
    if openQuote < 0 {
        return ();
    }
    return base.substring(openQuote + 1, lastCloseParen);
}

# Replaces the last occurrence of a segment name in a path function call.
#
# + base - The SQL expression to modify
# + oldSeg - The old segment name to replace
# + newSeg - The new segment name to insert
# + return - The modified SQL expression
isolated function replaceLastSegment(string base, string oldSeg, string newSeg) returns string {
    string target = string `'${oldSeg}')`;
    string replacement = string `'${newSeg}')`;
    int lastIdx = lastIndexOf(base, target);
    if lastIdx >= 0 {
        return base.substring(0, lastIdx) + replacement + base.substring(lastIdx + target.length());
    }
    return base;
}

// ========================================
// CLASSIFICATION HELPERS
// ========================================

# Checks if a field name is a known FHIR array field.
#
# + name - The field name to check
# + return - True if the field is a known array field
isolated function isKnownArrayField(string name) returns boolean {
    return KNOWN_ARRAY_FIELDS.indexOf(name) != ();
}

# Checks if a field name is always an array field (not context-dependent).
#
# + name - The field name to check
# + return - True if the field is always an array
isolated function isAlwaysArrayField(string name) returns boolean {
    return ALWAYS_ARRAY_FIELDS.indexOf(name) != ();
}

# Checks if a field name is a FHIR polymorphic field (value[x], onset[x], etc.).
#
# + name - The field name to check
# + return - True if the field is polymorphic
isolated function isPolymorphicField(string name) returns boolean {
    return POLYMORPHIC_FIELDS.indexOf(name) != ();
}

# Gets the PascalCase type suffix for polymorphic field mapping.
#
# + typeName - The FHIR type name (e.g., "integer")
# + return - The PascalCase suffix (e.g., "Integer")
isolated function getTypeSuffix(string typeName) returns string {
    string? suffix = TYPE_SUFFIX_MAP[typeName];
    return suffix is string ? suffix : typeName;
}

# Checks if a base expression represents the resource root level.
#
# + base - The SQL expression to check
# + ctx - The transpiler context
# + return - True if the base is at the resource root level
isolated function isResourceRootLevel(string base, TranspilerContext ctx) returns boolean {
    string fullResource = string `${ctx.resourceAlias}.${ctx.resourceColumn}`;
    return base == fullResource ||
            base == ctx.resourceAlias ||
            (!base.includes("jsonb_extract_path") &&
            !base.includes("EXISTS") &&
            !base.includes("SELECT"));
}

# Checks if a SQL expression is a boolean expression (contains comparison operators).
#
# + expr - The SQL expression to check
# + return - True if the expression contains boolean operators
isolated function isBooleanExpression(string expr) returns boolean {
    return expr.includes(" = ") ||
            expr.includes(" != ") ||
            expr.includes(" < ") ||
            expr.includes(" > ") ||
            expr.includes(" <= ") ||
            expr.includes(" >= ") ||
            expr.includes(" AND ") ||
            expr.includes(" OR ") ||
            expr.includes(" IS NULL") ||
            expr.includes(" IS NOT NULL") ||
            expr.startsWith("EXISTS ") ||
            expr.startsWith("(EXISTS ") ||
            expr.startsWith("NOT ") ||
            expr.startsWith("(NOT ");
}

// ========================================
// TYPE INFERENCE HELPERS
// ========================================

# Finds a tag value by name from an array of column tags.
#
# + tags - The array of column tags to search
# + tagName - The tag name to look for
# + return - The tag value if found, or () if not present
isolated function getTagValue(ColumnTag[] tags, string tagName) returns string? {
    foreach ColumnTag tag in tags {
        if tag.name == tagName {
            return tag.value;
        }
    }
    return ();
}

# Converts an ANSI/ISO SQL type to its PostgreSQL equivalent.
#
# + ansiType - The ANSI SQL type string
# + return - The PostgreSQL type string
isolated function convertAnsiToPostgres(string ansiType) returns string {
    string upper = ansiType.trim().toUpperAscii();
    if upper == "BOOLEAN" {
        return "BOOLEAN";
    } else if upper == "INTEGER" {
        return "INTEGER";
    } else if upper == "BIGINT" {
        return "BIGINT";
    } else if upper == "SMALLINT" {
        return "SMALLINT";
    } else if upper == "FLOAT" || upper == "DOUBLE PRECISION" {
        return "DOUBLE PRECISION";
    } else if upper == "REAL" {
        return "REAL";
    } else if upper == "NUMERIC" || upper == "DECIMAL" {
        return "NUMERIC";
    } else if upper == "DATE" {
        return "DATE";
    } else if upper == "TIME" {
        return "TIME";
    } else if upper == "TIMESTAMP" {
        return "TIMESTAMP";
    }
    // Check for CHARACTER/VARCHAR patterns
    if upper.startsWith("CHARACTER VARYING") || upper.startsWith("VARCHAR") {
        return ansiType; // PostgreSQL supports these natively
    }
    if upper.startsWith("CHARACTER(") || upper.startsWith("CHAR(") {
        return ansiType;
    }
    return ansiType; // Pass through as-is
}

# Gets the default PostgreSQL type mapping for a FHIR primitive type.
#
# + fhirType - The FHIR type name, or () for default
# + return - The PostgreSQL type string
isolated function getDefaultFhirTypeMapping(string? fhirType) returns string {
    if fhirType is () {
        return "TEXT";
    }
    string? mapped = FHIR_TO_PG_TYPE_MAP[fhirType.toLowerAscii()];
    return mapped is string ? mapped : "TEXT";
}

// ========================================
// STRING HELPERS
// ========================================

# Escapes single quotes for SQL by doubling them.
#
# + val - The string value to escape
# + return - The escaped string
isolated function escapeQuotes(string val) returns string {
    string result = "";
    foreach string char in val {
        if char == "'" {
            result += "''";
        } else {
            result += char;
        }
    }
    return result;
}

# Formats a constant value as a SQL literal string.
#
# + value - The constant value to format
# + return - The SQL literal representation
isolated function formatConstantValue(string|int|float|boolean? value) returns string {
    if value is string {
        string escaped = escapeQuotes(value);
        return string `'${escaped}'`;
    } else if value is int|float {
        return value.toString();
    } else if value is boolean {
        return value ? "'true'" : "'false'";
    }
    return "NULL";
}

# Finds the last index of a substring in a string.
#
# + str - The string to search in
# + substr - The substring to find
# + return - The last index of the substring, or -1 if not found
isolated function lastIndexOf(string str, string substr) returns int {
    int lastIdx = -1;
    int? idx = str.indexOf(substr, 0);
    while idx is int {
        lastIdx = idx;
        idx = str.indexOf(substr, idx + 1);
    }
    return lastIdx;
}

# Finds the index of a substring in a string.
#
# + str - The string to search in
# + substr - The substring to find
# + return - The index of the substring, or -1 if not found
isolated function indexOf(string str, string substr) returns int {
    int? idx = str.indexOf(substr, 0);
    return idx is int ? idx : -1;
}
