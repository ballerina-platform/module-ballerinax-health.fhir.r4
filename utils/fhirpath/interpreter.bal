// Interpreter for FHIRPath expressions

import ballerina/io;

// Runtime error type for FHIRPath
public type RuntimeError record {|
    FhirPathToken token;
    string message;
|};

// Interpret a FHIRPath expression with a JSON context object
public function interpret(Expr expression, json context) returns RuntimeError|json[] {
    RuntimeError|json[] value = evaluate(expression, context);

    if value is RuntimeError {
        reportRuntimeError(value);
        return value;
    }

    return value;
}

// Evaluate a FHIRPath expression
function evaluate(Expr expr, json context) returns RuntimeError|json[] {
    match expr.kind {
        "Literal" => {
            return visitLiteralExpr(<LiteralExpr>expr, context);
        }
        "Identifier" => {
            return visitIdentifierExpr(<IdentifierExpr>expr, context);
        }
        "MemberAccess" => {
            return visitMemberAccessExpr(<MemberAccessExpr>expr, context);
        }
        "Indexer" => {
            return visitIndexerExpr(<IndexerExpr>expr, context);
        }
        "Function" => {
            return visitFunctionExpr(<FunctionExpr>expr, context);
        }
        "Binary" => {
            return visitBinaryExpr(<BinaryExpr>expr, context);
        }
    }
    return [];
}

// Visit a literal expression
function visitLiteralExpr(LiteralExpr expr, json context) returns json[] {
    // Return the literal value as a single-element collection
    json value = <json>expr.value;
    if value is () {
        return [];
    }
    return [value];
}

// Visit an identifier expression
function visitIdentifierExpr(IdentifierExpr expr, json context) returns RuntimeError|json[] {
    // TODO: Implement identifier resolution from context
    // For now, return empty collection
    return [];
}

// Visit a member access expression (e.g., Patient.name)
function visitMemberAccessExpr(MemberAccessExpr expr, json context) returns RuntimeError|json[] {
    // TODO: Implement member access
    // 1. Evaluate the target expression
    // 2. For each result, access the member property
    // 3. Return the collection of results
    return [];
}

// Visit an indexer expression (e.g., Patient.name[0])
function visitIndexerExpr(IndexerExpr expr, json context) returns RuntimeError|json[] {
    // TODO: Implement indexer access
    // 1. Evaluate the target expression
    // 2. Evaluate the index expression
    // 3. Return the indexed element
    return [];
}

// Visit a function call expression (e.g., name.first())
function visitFunctionExpr(FunctionExpr expr, json context) returns RuntimeError|json[] {
    // TODO: Implement function calls
    // Common FHIRPath functions:
    // - first(), last()
    // - where(condition)
    // - exists(), empty()
    // - count()
    // etc.
    return [];
}

// Visit a binary expression (e.g., name = 'John' or age > 18)
function visitBinaryExpr(BinaryExpr expr, json context) returns RuntimeError|json[] {
    // TODO: Implement binary operations
    // 1. Evaluate left and right expressions
    // 2. Apply the operator (=, !=, or, xor, and)
    // 3. Return boolean result as collection
    return [];
}

// Helper function to check if FHIRPath result is truthy
function isTruthy(json[] result) returns boolean {
    // In FHIRPath, empty collections are falsy
    if result.length() == 0 {
        return false;
    }

    // If single boolean value, use that
    if result.length() == 1 && result[0] is boolean {
        return <boolean>result[0];
    }

    // Non-empty collections are truthy
    return true;
}

// Helper function to check equality in FHIRPath
function isEqual(anydata a, anydata b) returns boolean {
    if a is () && b is () {
        return true;
    }
    if a is () || b is () {
        return false;
    }
    return a == b;
}

// Report a FHIRPath runtime error
function reportRuntimeError(RuntimeError err) {
    io:println(string `FHIRPath Error: ${err.message}\n[line ${err.token.line}, position ${err.token.position}]`);
}

