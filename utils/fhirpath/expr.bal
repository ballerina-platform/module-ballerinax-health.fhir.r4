// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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
// EXPRESSION TYPES FOR FHIRPATH AST
// ========================================
// This module defines the Abstract Syntax Tree (AST) node types for FHIRPath expressions.
// Each expression type represents a different kind of syntactic construct in FHIRPath.

// ========================================
// BASE EXPRESSION TYPE
// ========================================

# Base expression type representing any FHIRPath expression node in the AST.
# This is a union of all possible expression types.
type Expr BinaryExpr|LiteralExpr|IdentifierExpr|FunctionExpr|MemberAccessExpr|IndexerExpr
        |UnaryExpr|ExternalConstantExpr|QuantityLiteralExpr;

// ========================================
// EXPRESSION NODE TYPES
// ========================================

# Represents a binary expression with left and right operands (e.g., a = b, x and y, p or q).
# Used for binary operators: or, xor, and, =, !=
#
# + kind - The expression kind discriminator (always "Binary")
# + left - The left operand expression
# + operator - The operator token (contains the operator type and position)
# + right - The right operand expression
type BinaryExpr record {|
    "Binary" kind;
    Expr left;
    FhirPathToken operator;
    Expr right;
|};

# Represents a literal value expression (e.g., 42, 'hello', true, false).
#
# + kind - The expression kind discriminator (always "Literal")
# + value - The literal value (number, string, boolean, or nil)
type LiteralExpr record {|
    "Literal" kind;
    anydata? value;
|};

# Represents an identifier expression (e.g., name, resourceType, given).
# Used for variable/property names and field access.
#
# + kind - The expression kind discriminator (always "Identifier")
# + name - The identifier name (can be simple or delimited)
type IdentifierExpr record {|
    "Identifier" kind;
    string name;
|};

# Represents a function call expression (e.g., where(condition), first(), count()).
#
# + kind - The expression kind discriminator (always "Function")
# + name - The function name
# + target - The expression the function is called on (e.g., Patient in Patient.where()), or nil for standalone calls
# + params - Array of argument expressions passed to the function
type FunctionExpr record {|
    "Function" kind;
    string name;
    Expr? target; // The expression the function is called on (e.g., Patient in Patient.where())
    Expr[] params;
|};

# Represents a member access expression using dot notation (e.g., Patient.name, name.given).
# Used to access properties/fields of objects.
#
# + kind - The expression kind discriminator (always "MemberAccess")
# + target - The expression being accessed (left side of the dot)
# + member - The member/property name being accessed (right side of the dot)
type MemberAccessExpr record {|
    "MemberAccess" kind;
    Expr target;
    string member;
|};

# Represents an indexer/subscript expression (e.g., name[0], telecom[1]).
# Used to access elements from arrays/collections by index.
#
# + kind - The expression kind discriminator (always "Indexer")
# + target - The expression being indexed (the collection)
# + index - The index expression (typically a literal number)
type IndexerExpr record {|
    "Indexer" kind;
    Expr target;
    Expr index;
|};

# Represents a unary prefix expression (e.g., -42, +3.5).
# Used for polarity operators that negate or affirm numeric values.
#
# + kind - The expression kind discriminator (always "Unary")
# + operator - The operator token (PLUS or MINUS)
# + operand - The expression being negated or affirmed
type UnaryExpr record {|
    "Unary" kind;
    FhirPathToken operator;
    Expr operand;
|};

# Represents an external constant expression (e.g., %myParam, %"external.var").
# External constants are environment-supplied values accessed via the % prefix.
#
# + kind - The expression kind discriminator (always "ExternalConstant")
# + name - The constant name (identifier or string after the %)
type ExternalConstantExpr record {|
    "ExternalConstant" kind;
    string name;
|};

# Represents a quantity literal expression (e.g., 5 'kg', 3 years, 10.5 months).
# Quantities combine a numeric value with a unit of measure.
#
# + kind - The expression kind discriminator (always "QuantityLiteral")
# + value - The numeric quantity value
# + unit - The unit string (UCUM unit or FHIRPath datetime precision keyword)
type QuantityLiteralExpr record {|
    "QuantityLiteral" kind;
    decimal value;
    string unit;
|};

// ========================================
// EXPRESSION CONSTRUCTORS
// ========================================
// These functions create AST nodes for different expression types.
// They are used by the parser to build the abstract syntax tree.

# Creates a binary expression node.
#
# + left - The left operand expression
# + operator - The operator token (contains type and position info)
# + right - The right operand expression
# + return - A new BinaryExpr node
isolated function createBinaryExpr(Expr left, FhirPathToken operator, Expr right) returns BinaryExpr {
    return {
        kind: "Binary",
        left: left,
        operator: operator,
        right: right
    };
}

# Creates a literal expression node.
#
# + value - The literal value (number, string, boolean, or nil)
# + return - A new LiteralExpr node
isolated function createLiteralExpr(anydata? value) returns LiteralExpr {
    return {
        kind: "Literal",
        value: value
    };
}

# Creates an identifier expression node.
#
# + name - The identifier name (can be simple or delimited)
# + return - A new IdentifierExpr node
isolated function createIdentifierExpr(string name) returns IdentifierExpr {
    return {
        kind: "Identifier",
        name: name
    };
}

# Creates a function call expression node.
#
# + name - The function name
# + target - The target expression (for method-style calls), or nil for standalone functions
# + params - Array of parameter expressions
# + return - A new FunctionExpr node
isolated function createFunctionExpr(string name, Expr? target, Expr[] params) returns FunctionExpr {
    return {
        kind: "Function",
        name: name,
        target: target,
        params: params
    };
}

# Creates a member access expression node.
#
# + target - The expression being accessed
# + member - The member/property name to access
# + return - A new MemberAccessExpr node
isolated function createMemberAccessExpr(Expr target, string member) returns MemberAccessExpr {
    return {
        kind: "MemberAccess",
        target: target,
        member: member
    };
}

# Creates an indexer expression node.
#
# + target - The expression being indexed (the collection)
# + index - The index expression
# + return - A new IndexerExpr node
isolated function createIndexerExpr(Expr target, Expr index) returns IndexerExpr {
    return {
        kind: "Indexer",
        target: target,
        index: index
    };
}

# Creates a unary prefix expression node.
#
# + operator - The operator token (PLUS or MINUS)
# + operand - The operand expression
# + return - A new UnaryExpr node
isolated function createUnaryExpr(FhirPathToken operator, Expr operand) returns UnaryExpr {
    return {
        kind: "Unary",
        operator: operator,
        operand: operand
    };
}

# Creates an external constant expression node.
#
# + name - The constant name after the % prefix
# + return - A new ExternalConstantExpr node
isolated function createExternalConstantExpr(string name) returns ExternalConstantExpr {
    return {
        kind: "ExternalConstant",
        name: name
    };
}

# Creates a quantity literal expression node.
#
# + value - The numeric quantity value
# + unit - The unit of measure
# + return - A new QuantityLiteralExpr node
isolated function createQuantityLiteralExpr(decimal value, string unit) returns QuantityLiteralExpr {
    return {
        kind: "QuantityLiteral",
        value: value,
        unit: unit
    };
}
