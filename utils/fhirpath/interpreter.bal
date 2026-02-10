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
    // Identifier accesses a property from the context
    // This handles the first level access, e.g., "name" in context
    if context is () {
        return [];
    }

    // Handle map/object context
    if context is map<json> {
        string fieldName = expr.name;

        // Check if identifier matches the resource type
        // If so, return the entire context (e.g., "Patient" returns the Patient resource)
        json|error resourceTypeValue = context.resourceType;
        if resourceTypeValue !is error && resourceTypeValue is string {
            if fieldName == resourceTypeValue {
                return [context];
            }
        }

        // Regular field access
        if !context.hasKey(fieldName) {
            return [];
        }
        json fieldValue = context[fieldName];
        return wrapInCollection(fieldValue);
    }

    // Context is not accessible as a map
    return [];
}

// Visit a member access expression (e.g., Patient.name, name.given)
function visitMemberAccessExpr(MemberAccessExpr expr, json context) returns RuntimeError|json[] {
    // 1. Evaluate the target expression to get a collection of results
    RuntimeError|json[] targetResults = evaluate(expr.target, context);

    if targetResults is RuntimeError {
        return targetResults;
    }

    // 2. For each result in the collection, access the member property
    json[] results = [];
    foreach json item in targetResults {
        RuntimeError|json[] memberResults = accessMember(item, expr.member);

        if memberResults is RuntimeError {
            return memberResults;
        }

        // Flatten the results into the output collection
        foreach json memberValue in memberResults {
            results.push(memberValue);
        }
    }

    return results;
}

// Access a member property from a JSON value
// Returns a collection of results (could be empty, single, or multiple values)
function accessMember(json item, string memberName) returns RuntimeError|json[] {
    // Handle null/nil
    if item is () {
        return [];
    }

    // Handle map/object - direct property access
    if item is map<json> {
        if !item.hasKey(memberName) {
            return [];
        }
        json fieldValue = item[memberName];
        return wrapInCollection(fieldValue);
    }

    // Handle arrays - access member from each element
    if item is json[] {
        json[] results = [];
        foreach json element in item {
            RuntimeError|json[] elementResults = accessMember(element, memberName);

            if elementResults is RuntimeError {
                return elementResults;
            }

            foreach json value in elementResults {
                results.push(value);
            }
        }
        return results;
    }

    // Primitive types don't have members
    return [];
}

// Visit an indexer expression (e.g., Patient.name[0], given[1])
function visitIndexerExpr(IndexerExpr expr, json context) returns RuntimeError|json[] {
    // 1. Evaluate the target expression to get a collection
    RuntimeError|json[] targetResults = evaluate(expr.target, context);

    if targetResults is RuntimeError {
        return targetResults;
    }
    // 2. Evaluate the index expression to get the index value
    RuntimeError|json[] indexResults = evaluate(expr.index, context);

    if indexResults is RuntimeError {
        return indexResults;
    }

    // Index should be a single integer value
    if indexResults.length() != 1 {
        return []; // Invalid index - must be a single value
    }

    json indexValue = indexResults[0];

    // Convert index to integer (handle both int and float literals)
    int index;
    if indexValue is int {
        index = indexValue;
    } else if indexValue is float {
        // Check if float has no decimal part (e.g., 5.0 is ok, 5.5 is not)
        float floatIndex = <float>indexValue;
        if floatIndex % 1.0 != 0.0 {
            return []; // Index must be a whole number (no decimals)
        }
        index = <int>floatIndex;
    } else {
        return []; // Index must be numeric
    }

    // 3. Apply indexing to the target collection directly
    // Check bounds
    if index < 0 || index >= targetResults.length() {
        return []; // Out of bounds returns empty collection
    }

    // Return the element at the index
    json element = targetResults[index];
    return wrapInCollection(element);
}

// Apply array indexing to a JSON value
// Returns the element at the specified index if the value is an array
function applyIndex(json item, int index) returns RuntimeError|json[] {
    // Handle null/nil
    if item is () {
        return [];
    }

    // Only arrays can be indexed
    if item !is json[] {
        return []; // Non-array values return empty collection
    }

    json[] arr = <json[]>item;
    int arrayLength = arr.length();

    // Check bounds
    if index < 0 || index >= arrayLength {
        return []; // Out of bounds returns empty collection
    }

    // Return the element at the index
    json element = arr[index];
    return wrapInCollection(element);
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

// Helper function to wrap a JSON value in a collection
// - If value is null/nil, returns empty collection []
// - If value is already an array, returns it as-is
// - Otherwise, wraps the value in a single-element array
function wrapInCollection(json value) returns json[] {
    if value is () {
        return [];
    }
    if value is json[] {
        // Already an array, return as-is
        return value;
    }
    // Wrap single value in array
    return [value];
}

// Report a FHIRPath runtime error
function reportRuntimeError(RuntimeError err) {
    io:println(string `FHIRPath Error: ${err.message}\n[line ${err.token.line}, position ${err.token.position}]`);
}

