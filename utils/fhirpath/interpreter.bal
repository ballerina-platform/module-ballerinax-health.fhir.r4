// Copyright (c) 2023 - 2026, WSO2 LLC. (http://www.wso2.com).

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
// INTERPRETER FOR FHIRPATH EXPRESSIONS
// ========================================
// This module implements the interpreter/evaluator for FHIRPath expressions.
// It traverses the AST produced by the parser and evaluates expressions
// against JSON context objects (FHIR resources).

# Represents an interpreter runtime error with token information.
#
# + token - The token where the runtime error occurred
type InterpreterError record {|
    FhirPathToken token;
|};

# Public error type for FHIRPath interpreter runtime errors.
# This error is raised when the interpreter encounters runtime issues.
public type FhirpathInterpreterError distinct error<InterpreterError>;

# Interprets a FHIRPath expression against a JSON context object.
# This is the main entry point for expression evaluation.
#
# + expression - The parsed FHIRPath expression (AST)
# + context - The JSON context object (typically a FHIR resource)
# + return - A collection of JSON results, or a FhirpathInterpreterError if evaluation fails
isolated function interpret(Expr expression, json context) returns FhirpathInterpreterError|json[] {
    FhirpathInterpreterError|json[] value = evaluate(expression, context);
    return value;
}

# Evaluates a FHIRPath expression node against a context.
# Dispatches to the appropriate visitor function based on expression type.
#
# + expr - The expression node to evaluate
# + context - The current evaluation context (JSON value)
# + return - A collection of JSON results, or a FhirpathInterpreterError if evaluation fails
isolated function evaluate(Expr expr, json context) returns FhirpathInterpreterError|json[] {
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

# Evaluates a literal expression (e.g., true, false, 42, 'hello').
#
# + expr - The literal expression node
# + context - The current evaluation context (unused for literals)
# + return - A single-element collection containing the literal value, or empty if nil
isolated function visitLiteralExpr(LiteralExpr expr, json context) returns json[] {
    // Return the literal value as a single-element collection
    json value = <json>expr.value;
    if value is () {
        return [];
    }
    return [value];
}

# Evaluates an identifier expression (e.g., name, resourceType).
# Accesses a property from the context object, or checks for resource type match.
#
# + expr - The identifier expression node
# + context - The current evaluation context
# + return - A collection of values from the identified field, or empty if not found
isolated function visitIdentifierExpr(IdentifierExpr expr, json context) returns FhirpathInterpreterError|json[] {
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

# Evaluates a member access expression (e.g., Patient.name, name.given).
# First evaluates the target to get a collection, then accesses the member from each item.
#
# + expr - The member access expression node
# + context - The current evaluation context
# + return - A flattened collection of all member values, or an error
isolated function visitMemberAccessExpr(MemberAccessExpr expr, json context) returns FhirpathInterpreterError|json[] {
    // 1. Evaluate the target expression to get a collection of results
    json[] targetResults = check evaluate(expr.target, context);

    // 2. For each result in the collection, access the member property
    json[] results = [];
    foreach json item in targetResults {
        json[] memberResults = check accessMember(item, expr.member);

        // Flatten the results into the output collection
        foreach json memberValue in memberResults {
            results.push(memberValue);
        }
    }

    return results;
}

# Accesses a member property from a JSON value.
# Handles objects, arrays, and primitives differently.
#
# + item - The JSON value to access a member from
# + memberName - The name of the member/property to access
# + return - A collection of results (could be empty, single, or multiple values), or an error
isolated function accessMember(json item, string memberName) returns FhirpathInterpreterError|json[] {
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
            json[] elementResults = check accessMember(element, memberName);

            foreach json value in elementResults {
                results.push(value);
            }
        }
        return results;
    }

    // Primitive types don't have members
    return [];
}

# Evaluates an indexer expression (e.g., Patient.name[0], given[1]).
# Accesses a specific element from a collection by index.
#
# + expr - The indexer expression node
# + context - The current evaluation context
# + return - A single-element collection with the indexed value, empty if out of bounds, or an error
isolated function visitIndexerExpr(IndexerExpr expr, json context) returns FhirpathInterpreterError|json[] {
    // 1. Evaluate the target expression to get a collection
    json[] targetResults = check evaluate(expr.target, context);

    // 2. Evaluate the index expression to get the index value
    json[] indexResults = check evaluate(expr.index, context);

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

# Applies array indexing to a JSON value.
# Only works on JSON arrays; returns empty for non-arrays.
#
# + item - The JSON value to index into
# + index - The zero-based index to access
# + return - A single-element collection with the indexed value, empty if out of bounds or non-array, or an error
isolated function applyIndex(json item, int index) returns FhirpathInterpreterError|json[] {
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

# Evaluates a function call expression (e.g., name.first(), where(condition)).
# Dispatches to the appropriate function implementation based on function name.
#
# + expr - The function expression node
# + context - The current evaluation context
# + return - A collection of results from the function, or an error
isolated function visitFunctionExpr(FunctionExpr expr, json context) returns FhirpathInterpreterError|json[] {
    // 1. Evaluate the target expression if it exists (e.g., Patient in Patient.where())
    json[] targetResults;
    Expr? targetExpr = expr.target;
    if targetExpr is Expr {
        targetResults = check evaluate(targetExpr, context);
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

# Evaluates a binary expression (e.g., name = 'John', age > 18, a and b).
# Evaluates both operands and applies the operator.
#
# + expr - The binary expression node
# + context - The current evaluation context
# + return - A collection with the boolean result of the operation, or an error
isolated function visitBinaryExpr(BinaryExpr expr, json context) returns FhirpathInterpreterError|json[] {
    // 1. Evaluate left and right expressions
    json[] leftResults = check evaluate(expr.left, context);
    json[] rightResults = check evaluate(expr.right, context);

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

# Applies the equality or inequality operator to two collections.
# Handles FHIRPath equality semantics for collections.
#
# + left - The left operand collection
# + right - The right operand collection
# + checkEqual - True for '=' operator, false for '!=' operator
# + return - A single-element collection with the boolean result
isolated function applyEqualityOperator(json[] left, json[] right, boolean checkEqual) returns json[] {
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

# Applies the logical AND operator to two collections.
#
# + left - The left operand collection
# + right - The right operand collection
# + return - A single-element collection with the boolean result of AND operation
isolated function applyAndOperator(json[] left, json[] right) returns json[] {
    boolean leftTruthy = isTruthy(left);
    boolean rightTruthy = isTruthy(right);
    return [leftTruthy && rightTruthy];
}

# Applies the logical OR operator to two collections.
#
# + left - The left operand collection
# + right - The right operand collection
# + return - A single-element collection with the boolean result of OR operation
isolated function applyOrOperator(json[] left, json[] right) returns json[] {
    boolean leftTruthy = isTruthy(left);
    boolean rightTruthy = isTruthy(right);
    return [leftTruthy || rightTruthy];
}

# Applies the logical XOR (exclusive OR) operator to two collections.
#
# + left - The left operand collection
# + right - The right operand collection
# + return - A single-element collection with the boolean result of XOR operation
isolated function applyXorOperator(json[] left, json[] right) returns json[] {
    boolean leftTruthy = isTruthy(left);
    boolean rightTruthy = isTruthy(right);
    // XOR is true if exactly one operand is true
    return [(leftTruthy && !rightTruthy) || (!leftTruthy && rightTruthy)];
}

# Checks if a FHIRPath result collection is truthy.
# Empty collections are falsy; single boolean values use their value; non-empty collections are truthy.
#
# + result - The collection to check
# + return - True if the collection is considered truthy, false otherwise
isolated function isTruthy(json[] result) returns boolean {
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

# Checks equality between two values according to FHIRPath semantics.
#
# + a - The first value
# + b - The second value
# + return - True if the values are equal, false otherwise
isolated function isEqual(anydata a, anydata b) returns boolean {
    if a is () && b is () {
        return true;
    }
    if a is () || b is () {
        return false;
    }
    return a == b;
}

# Wraps a JSON value in a collection according to FHIRPath conventions.
# - If value is null/nil, returns empty collection []
# - If value is already an array, returns it as-is
# - Otherwise, wraps the value in a single-element array
#
# + value - The JSON value to wrap
# + return - A JSON array containing the value
isolated function wrapInCollection(json value) returns json[] {
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

# Implements the FHIRPath where() function.
# Filters the collection to items where the condition expression evaluates to true.
#
# + collection - The collection to filter
# + params - Function parameters (expects exactly one condition expression)
# + originalContext - The original evaluation context (unused in where)
# + return - A filtered collection containing only items where the condition is truthy, or an error
isolated function applyWhereFunction(json[] collection, Expr[] params, json originalContext) returns FhirpathInterpreterError|json[] {
    // where() requires exactly one parameter (the condition expression)
    if params.length() != 1 {
        return [];
    }

    Expr conditionExpr = params[0];
    json[] results = [];

    // Evaluate the condition for each item in the collection
    foreach json item in collection {
        // Evaluate condition with item as the context
        json[] conditionResult = check evaluate(conditionExpr, item);

        // Include item if condition is truthy
        if isTruthy(conditionResult) {
            results.push(item);
        }
    }

    return results;
}
