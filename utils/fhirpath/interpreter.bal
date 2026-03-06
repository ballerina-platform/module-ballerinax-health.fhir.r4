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
            return error FhirpathInterpreterError(string `Unknown function '${expr.name}'`,
            token = {tokenType: IDENTIFIER, lexeme: expr.name, literal: (), position: 0});
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
    if left.length() == 0 || right.length() == 0 {
        // Per FHIRPath spec: if either operand is empty, result is empty
        return [];
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

// ========================================
// SET INTERPRETER FOR FHIRPATH EXPRESSIONS
// ========================================
// This section implements the interpreter for setting values at FHIRPath locations.
// It traverses the AST and modifies the JSON context object at the specified path.

# Interprets a FHIRPath expression to SET a value at the specified path in a JSON context object.
# This is the main entry point for set expression evaluation.
#
# + expression - The parsed FHIRPath expression (AST)
# + context - The JSON context object (typically a FHIR resource, must be a map<json>)
# + newValue - The new value to set at the path
# + shouldRemove - Whether to remove the value instead of setting it
# + modificationFunction - Optional function to transform the existing value
# + return - The modified JSON context, or a FhirpathInterpreterError if evaluation fails
isolated function interpretSet(Expr expression, json context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FhirpathInterpreterError|json {
    if context !is map<json> {
        return error FhirpathInterpreterError("Context must be a JSON object for set operations",
            token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
    }

    map<json> contextClone = context.clone();
    FhirpathInterpreterError|map<json> result = evaluateSet(expression, contextClone, newValue, shouldRemove, modificationFunction);
    return result;
}

# Evaluates a FHIRPath expression node for setting a value.
# Dispatches to the appropriate visitor function based on expression type.
#
# + expr - The expression node to evaluate
# + context - The current evaluation context (JSON object)
# + newValue - The new value to set
# + shouldRemove - Whether to remove the value instead of setting it
# + modificationFunction - Optional function to transform the existing value
# + return - The modified JSON object, or a FhirpathInterpreterError if evaluation fails
isolated function evaluateSet(Expr expr, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FhirpathInterpreterError|map<json> {
    match expr.kind {
        "Identifier" => {
            return visitIdentifierExprSet(<IdentifierExpr>expr, context, newValue, shouldRemove, modificationFunction);
        }
        "MemberAccess" => {
            return visitMemberAccessExprSet(<MemberAccessExpr>expr, context, newValue, shouldRemove, modificationFunction);
        }
        "Indexer" => {
            return visitIndexerExprSet(<IndexerExpr>expr, context, newValue, shouldRemove, modificationFunction);
        }
        _ => {
            return error FhirpathInterpreterError("Unsupported expression type for set operation",
                token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
        }
    }
}

# Sets a value at an identifier path (e.g., resourceType, name).
# This handles terminal single-level paths.
#
# + expr - The identifier expression node
# + context - The current evaluation context (JSON object)
# + newValue - The new value to set
# + shouldRemove - Whether to remove the value instead of setting it
# + modificationFunction - Optional function to transform the existing value
# + return - The modified JSON object, or an error
isolated function visitIdentifierExprSet(IdentifierExpr expr, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FhirpathInterpreterError|map<json> {
    string fieldName = expr.name;

    // Check if identifier matches the resource type
    json|error resourceTypeValue = context.resourceType;
    if resourceTypeValue !is error && resourceTypeValue is string {
        if fieldName == resourceTypeValue {
            // Identifier is the resource type itself - return context as is
            // We need to set the value at a deeper path, not replace the whole resource
            return context;
        }
    }

    // Handle regular field access
    if shouldRemove {
        if context.hasKey(fieldName) {
            _ = context.remove(fieldName);
        }
        return context;
    }

    // Handle setting field - error if field doesn't exist
    if !context.hasKey(fieldName) {
        return error FhirpathInterpreterError(string `Path '${fieldName}' does not exist in the resource`,
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }

    json|error modifiedValue = getModifiedValueInternal(context[fieldName], modificationFunction, newValue);
    if modifiedValue is error {
        return error FhirpathInterpreterError(modifiedValue.message(),
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }
    context[fieldName] = modifiedValue;

    return context;
}

# Sets a value at a member access path (e.g., Patient.name, name.given).
# Traverses through the path and sets the value at the terminal member.
#
# + expr - The member access expression node
# + context - The current evaluation context (JSON object)
# + newValue - The new value to set
# + shouldRemove - Whether to remove the value instead of setting it
# + modificationFunction - Optional function to transform the existing value
# + return - The modified JSON object, or an error
isolated function visitMemberAccessExprSet(MemberAccessExpr expr, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FhirpathInterpreterError|map<json> {
    // First, navigate to the target
    Expr targetExpr = expr.target;
    string memberName = expr.member;

    // Evaluate the target to get intermediate contexts
    json[] targetResults = check evaluate(targetExpr, context);

    // If we have intermediate results, set value on each of them
    if targetResults.length() > 0 {
        foreach json targetItem in targetResults {
            if targetItem is map<json> {
                if shouldRemove {
                    if targetItem.hasKey(memberName) {
                        _ = targetItem.remove(memberName);
                    }
                } else {
                    // Check if member exists - error if it doesn't
                    if !targetItem.hasKey(memberName) {
                        return error FhirpathInterpreterError(string `Path '${memberName}' does not exist in the resource`,
                            token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
                    }
                    json currentValue = targetItem[memberName];
                    json|error modifiedValue = getModifiedValueInternal(currentValue, modificationFunction, newValue);
                    if modifiedValue is error {
                        return error FhirpathInterpreterError(modifiedValue.message(),
                            token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
                    }
                    targetItem[memberName] = modifiedValue;
                }
            } else if targetItem is json[] {
                // Handle array of objects - set member on each element
                foreach json element in targetItem {
                    if element is map<json> {
                        if shouldRemove {
                            if element.hasKey(memberName) {
                                _ = element.remove(memberName);
                            }
                        } else {
                            // Check if member exists - error if it doesn't
                            if !element.hasKey(memberName) {
                                return error FhirpathInterpreterError(string `Path '${memberName}' does not exist in the resource`,
                                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
                            }
                            json currentValue = element[memberName];
                            json|error modifiedValue = getModifiedValueInternal(currentValue, modificationFunction, newValue);
                            if modifiedValue is error {
                                return error FhirpathInterpreterError(modifiedValue.message(),
                                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
                            }
                            element[memberName] = modifiedValue;
                        }
                    }
                }
            }
        }
        return context;
    }

    // No existing path - return error for set, silently succeed for remove
    if shouldRemove {
        return context;
    }
    return error FhirpathInterpreterError(string `Path '${memberName}' does not exist in the resource`,
        token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
}

# Sets a value at an indexed path (e.g., name[0], telecom[1]).
# Navigates to the indexed element and sets the value.
#
# + expr - The indexer expression node
# + context - The current evaluation context (JSON object)
# + newValue - The new value to set
# + shouldRemove - Whether to remove the value instead of setting it
# + modificationFunction - Optional function to transform the existing value
# + return - The modified JSON object, or an error
isolated function visitIndexerExprSet(IndexerExpr expr, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FhirpathInterpreterError|map<json> {
    // Get the index value
    json[] indexResults = check evaluate(expr.index, context);
    if indexResults.length() != 1 {
        return error FhirpathInterpreterError("Index must be a single value",
            token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
    }

    int index;
    json indexValue = indexResults[0];
    if indexValue is int {
        index = indexValue;
    } else if indexValue is float {
        if indexValue % 1.0 != 0.0 {
            return error FhirpathInterpreterError("Index must be a whole number",
                token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
        }
        index = <int>indexValue;
    } else {
        return error FhirpathInterpreterError("Index must be numeric",
            token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
    }

    // Handle the target expression to get the array
    Expr targetExpr = expr.target;

    // Different handling based on target type
    if targetExpr is IdentifierExpr {
        return setValueAtIndexedIdentifier(targetExpr, index, context, newValue, shouldRemove, modificationFunction);
    } else if targetExpr is MemberAccessExpr {
        return setValueAtIndexedMemberAccess(targetExpr, index, context, newValue, shouldRemove, modificationFunction);
    } else if targetExpr is IndexerExpr {
        // Nested indexer e.g., name[0][1] - evaluate target to get array element then index again
        return setValueAtNestedIndexer(targetExpr, index, context, newValue, shouldRemove, modificationFunction);
    }

    return context;
}

# Sets value at an indexed identifier (e.g., name[0]).
#
# + expr - The identifier expression for the array field
# + index - The index to access
# + context - The current JSON context
# + newValue - The new value to set
# + shouldRemove - Whether to remove instead of set
# + modificationFunction - Optional modification function
# + return - The modified context or error
isolated function setValueAtIndexedIdentifier(IdentifierExpr expr, int index, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FhirpathInterpreterError|map<json> {
    string fieldName = expr.name;

    // Check if field exists
    if !context.hasKey(fieldName) {
        if shouldRemove {
            return context;
        }
        return error FhirpathInterpreterError(string `Path '${fieldName}' does not exist in the resource`,
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }

    json fieldValue = context[fieldName];
    if fieldValue !is json[] {
        if shouldRemove {
            return context;
        }
        return error FhirpathInterpreterError(string `Path '${fieldName}' is not an array`,
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }

    json[] arr = <json[]>fieldValue;

    if shouldRemove {
        // Remove the element at index
        if index >= 0 && index < arr.length() {
            json[] newArr = [];
            foreach int i in 0 ..< arr.length() {
                if i != index {
                    newArr.push(arr[i]);
                }
            }
            context[fieldName] = newArr;
        }
        return context;
    }

    // Check if index exists
    if index >= arr.length() {
        return error FhirpathInterpreterError(string `Index ${index} is out of bounds for array '${fieldName}' with length ${arr.length()}`,
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }

    // Set the value at index
    json|error modifiedValue = getModifiedValueInternal(arr[index], modificationFunction, newValue);
    if modifiedValue is error {
        return error FhirpathInterpreterError(modifiedValue.message(),
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }
    arr[index] = modifiedValue;

    return context;
}

# Sets value at an indexed member access (e.g., Patient.name[0]).
#
# + expr - The member access expression
# + index - The index to access
# + context - The current JSON context
# + newValue - The new value to set
# + shouldRemove - Whether to remove instead of set
# + modificationFunction - Optional modification function
# + return - The modified context or error
isolated function setValueAtIndexedMemberAccess(MemberAccessExpr expr, int index, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FhirpathInterpreterError|map<json> {
    // Evaluate target to get the parent object(s)
    json[] targetResults = check evaluate(expr.target, context);
    string memberName = expr.member;

    if targetResults.length() == 0 {
        if shouldRemove {
            return context;
        }
        return error FhirpathInterpreterError(string `Path to '${memberName}' does not exist in the resource`,
            token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
    }

    // Process each target result
    foreach json targetItem in targetResults {
        if targetItem is map<json> {
            // Check if array field exists
            if !targetItem.hasKey(memberName) {
                if shouldRemove {
                    continue;
                }
                return error FhirpathInterpreterError(string `Path '${memberName}' does not exist`,
                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
            }

            json fieldValue = targetItem[memberName];
            if fieldValue !is json[] {
                if shouldRemove {
                    continue;
                }
                return error FhirpathInterpreterError(string `Path '${memberName}' is not an array`,
                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
            }

            json[] arr = <json[]>fieldValue;

            if shouldRemove {
                if index >= 0 && index < arr.length() {
                    json[] newArr = [];
                    foreach int i in 0 ..< arr.length() {
                        if i != index {
                            newArr.push(arr[i]);
                        }
                    }
                    targetItem[memberName] = newArr;
                }
                continue;
            }

            // Check if index exists
            if index >= arr.length() {
                return error FhirpathInterpreterError(string `Index ${index} is out of bounds for array '${memberName}' with length ${arr.length()}`,
                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
            }

            // Set the value
            json|error modifiedValue = getModifiedValueInternal(arr[index], modificationFunction, newValue);
            if modifiedValue is error {
                return error FhirpathInterpreterError(modifiedValue.message(),
                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
            }
            arr[index] = modifiedValue;
        }
    }

    return context;
}

# Sets value at a nested indexer (e.g., name[0][1]).
#
# + expr - The inner indexer expression
# + outerIndex - The outer index
# + context - The current JSON context
# + newValue - The new value to set
# + shouldRemove - Whether to remove instead of set
# + modificationFunction - Optional modification function
# + return - The modified context or error
isolated function setValueAtNestedIndexer(IndexerExpr expr, int outerIndex, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FhirpathInterpreterError|map<json> {
    // Evaluate the inner indexer to get the array
    json[] innerResults = check evaluate(expr, context);

    if innerResults.length() == 0 {
        if shouldRemove {
            return context;
        }
        return error FhirpathInterpreterError("Path does not exist in the resource",
            token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
    }

    foreach json innerItem in innerResults {
        if innerItem is json[] {
            json[] arr = <json[]>innerItem;

            if shouldRemove {
                if outerIndex >= 0 && outerIndex < arr.length() {
                    json[] newArr = [];
                    foreach int i in 0 ..< arr.length() {
                        if i != outerIndex {
                            newArr.push(arr[i]);
                        }
                    }
                    // Persist removal: clear the original array and copy filtered elements back
                    // This mirrors setValueAtIndexedIdentifier's approach of writing newArr back
                    while arr.length() > 0 {
                        _ = arr.pop();
                    }
                    foreach json item in newArr {
                        arr.push(item);
                    }
                }
                continue;
            }

            if outerIndex < 0 || outerIndex >= arr.length() {
                return error FhirpathInterpreterError(string `Index ${outerIndex} is out of bounds for array with length ${arr.length()}`,
                    token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
            }

            json|error modifiedValue = getModifiedValueInternal(arr[outerIndex], modificationFunction, newValue);
            if modifiedValue is error {
                return error FhirpathInterpreterError(modifiedValue.message(),
                    token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
            }
            arr[outerIndex] = modifiedValue;
        }
    }

    return context;
}

# Function to modify the value at the path
public type ModificationFunction isolated function (json param) returns json|error;

# Get the modified value by applying either a modification function or setting a new value.
# Internal version for use within the interpreter.
#
# + currentValue - The current value at the FHIRPath location
# + modificationFunction - Optional function to transform the current value
# + newValue - Optional new value to set directly
# + return - The modified value or an error if modification function fails
isolated function getModifiedValueInternal(json currentValue, ModificationFunction? modificationFunction, json? newValue) returns json|error {
    if currentValue !is () && modificationFunction !is () {
        return modificationFunction(currentValue);
    }
    if newValue !is () {
        return newValue;
    }
    return currentValue;
}
