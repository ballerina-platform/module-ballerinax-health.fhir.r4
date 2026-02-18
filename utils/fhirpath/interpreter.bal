// Interpreter for FHIRPath expressions

// Runtime error type for FHIRPath
type InterpreterError record {|
    FhirPathToken token;
|};

public type FhirpathInterpreterError distinct error<InterpreterError>;

// Interpret a FHIRPath expression with a JSON context object
public function interpret(Expr expression, json context) returns FhirpathInterpreterError|json[] {
    FhirpathInterpreterError|json[] value = evaluate(expression, context);
    return value;
}

// Evaluate a FHIRPath expression
function evaluate(Expr expr, json context) returns FhirpathInterpreterError|json[] {
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
function visitIdentifierExpr(IdentifierExpr expr, json context) returns FhirpathInterpreterError|json[] {
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
function visitMemberAccessExpr(MemberAccessExpr expr, json context) returns FhirpathInterpreterError|json[] {
    // 1. Evaluate the target expression to get a collection of results
    FhirpathInterpreterError|json[] targetResults = evaluate(expr.target, context);

    if targetResults is FhirpathInterpreterError {
        return targetResults;
    }

    // 2. For each result in the collection, access the member property
    json[] results = [];
    foreach json item in targetResults {
        FhirpathInterpreterError|json[] memberResults = accessMember(item, expr.member);

        if memberResults is FhirpathInterpreterError {
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
function accessMember(json item, string memberName) returns FhirpathInterpreterError|json[] {
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
            FhirpathInterpreterError|json[] elementResults = accessMember(element, memberName);

            if elementResults is FhirpathInterpreterError {
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
function visitIndexerExpr(IndexerExpr expr, json context) returns FhirpathInterpreterError|json[] {
    // 1. Evaluate the target expression to get a collection
    FhirpathInterpreterError|json[] targetResults = evaluate(expr.target, context);

    if targetResults is FhirpathInterpreterError {
        return targetResults;
    }
    // 2. Evaluate the index expression to get the index value
    FhirpathInterpreterError|json[] indexResults = evaluate(expr.index, context);

    if indexResults is FhirpathInterpreterError {
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
function applyIndex(json item, int index) returns FhirpathInterpreterError|json[] {
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
function visitFunctionExpr(FunctionExpr expr, json context) returns FhirpathInterpreterError|json[] {
    // 1. Evaluate the target expression if it exists (e.g., Patient in Patient.where())
    json[] targetResults;
    Expr? targetExpr = expr.target;
    if targetExpr is Expr {
        FhirpathInterpreterError|json[] evalResult = evaluate(targetExpr, context);
        if evalResult is FhirpathInterpreterError {
            return evalResult;
        }
        targetResults = evalResult;
    } else {
        // No target means standalone function call - use context as-is
        targetResults = wrapInCollection(context);
    }

    // 2. Apply the function based on its name
    match expr.name {
        "where" => {
            return applyWhereFunction(targetResults, expr.params, context);
        }
        _ => {
            // Unknown function
            return [];
        }
    }
}

// Visit a binary expression (e.g., name = 'John' or age > 18)
function visitBinaryExpr(BinaryExpr expr, json context) returns FhirpathInterpreterError|json[] {
    // 1. Evaluate left and right expressions
    FhirpathInterpreterError|json[] leftResults = evaluate(expr.left, context);
    if leftResults is FhirpathInterpreterError {
        return leftResults;
    }

    FhirpathInterpreterError|json[] rightResults = evaluate(expr.right, context);
    if rightResults is FhirpathInterpreterError {
        return rightResults;
    }

    // 2. Apply the operator based on its type
    TokenType operatorType = expr.operator.tokenType;

    match operatorType {
        EQUAL => {
            return applyEqualityOperator(leftResults, rightResults, true);
        }
        BANG_EQUAL => {
            return applyEqualityOperator(leftResults, rightResults, false);
        }
        AND => {
            return applyAndOperator(leftResults, rightResults);
        }
        OR => {
            return applyOrOperator(leftResults, rightResults);
        }
        XOR => {
            return applyXorOperator(leftResults, rightResults);
        }
        _ => {
            // Unknown operator
            return error FhirpathInterpreterError(string `Unknown binary operator: ${expr.operator.lexeme}`,
                token = expr.operator);
        }
    }
}

// Apply equality operator (= or !=)
function applyEqualityOperator(json[] left, json[] right, boolean checkEqual) returns json[] {
    // Empty collections
    if left.length() == 0 && right.length() == 0 {
        return [checkEqual]; // Empty = Empty is true, Empty != Empty is false
    }

    if left.length() == 0 || right.length() == 0 {
        return [!checkEqual]; // One empty is not equal (or equal if !=)
    }

    // Compare collections
    // In FHIRPath, equality works on collections:
    // If both have single elements, compare values
    if left.length() == 1 && right.length() == 1 {
        anydata leftValue = left[0];
        anydata rightValue = right[0];
        boolean areEqual = isEqual(leftValue, rightValue);
        return checkEqual ? [areEqual] : [!areEqual];
    }

    // For collections with multiple elements, check if they're equal as collections
    if left.length() == right.length() {
        boolean allEqual = true;
        foreach int i in 0 ..< left.length() {
            if !isEqual(left[i], right[i]) {
                allEqual = false;
                break;
            }
        }
        return checkEqual ? [allEqual] : [!allEqual];
    }

    // Different lengths means not equal
    return [!checkEqual];
}

// Apply AND operator
function applyAndOperator(json[] left, json[] right) returns json[] {
    boolean leftTruthy = isTruthy(left);
    boolean rightTruthy = isTruthy(right);
    return [leftTruthy && rightTruthy];
}

// Apply OR operator
function applyOrOperator(json[] left, json[] right) returns json[] {
    boolean leftTruthy = isTruthy(left);
    boolean rightTruthy = isTruthy(right);
    return [leftTruthy || rightTruthy];
}

// Apply XOR operator
function applyXorOperator(json[] left, json[] right) returns json[] {
    boolean leftTruthy = isTruthy(left);
    boolean rightTruthy = isTruthy(right);
    // XOR is true if exactly one operand is true
    return [(leftTruthy && !rightTruthy) || (!leftTruthy && rightTruthy)];
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

// FHIRPath function implementations

// where(condition) - filters the collection to items where condition is true
function applyWhereFunction(json[] collection, Expr[] params, json originalContext) returns FhirpathInterpreterError|json[] {
    // where() requires exactly one parameter (the condition expression)
    if params.length() != 1 {
        return [];
    }

    Expr conditionExpr = params[0];
    json[] results = [];

    // Evaluate the condition for each item in the collection
    foreach json item in collection {
        // Evaluate condition with item as the context
        FhirpathInterpreterError|json[] conditionResult = evaluate(conditionExpr, item);

        if conditionResult is FhirpathInterpreterError {
            return conditionResult;
        }

        // Include item if condition is truthy
        if isTruthy(conditionResult) {
            results.push(item);
        }
    }

    return results;
}
