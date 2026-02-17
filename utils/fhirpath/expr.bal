// Expression types for FHIRPath

// Base expression type
public type Expr BinaryExpr|LiteralExpr|IdentifierExpr|FunctionExpr|MemberAccessExpr|IndexerExpr;

// Binary expression: left operator right (for or, xor, and, =, !=)
public type BinaryExpr record {|
    "Binary" kind;
    Expr left;
    FhirPathToken operator;
    Expr right;
|};

// Literal expression: numbers, strings, true, false
public type LiteralExpr record {|
    "Literal" kind;
    anydata? value;
|};

// Identifier expression: simple or delimited identifier
public type IdentifierExpr record {|
    "Identifier" kind;
    string name;
|};

// Function call expression: identifier(params)
public type FunctionExpr record {|
    "Function" kind;
    string name;
    Expr? target; // The expression the function is called on (e.g., Patient in Patient.where())
    Expr[] params;
|};

// Member access expression: expression.identifier
public type MemberAccessExpr record {|
    "MemberAccess" kind;
    Expr target;
    string member;
|};

// Indexer expression: expression[index]
public type IndexerExpr record {|
    "Indexer" kind;
    Expr target;
    Expr index;
|};

// Constructor functions
public function createBinaryExpr(Expr left, FhirPathToken operator, Expr right) returns BinaryExpr {
    return {
        kind: "Binary",
        left: left,
        operator: operator,
        right: right
    };
}

public function createLiteralExpr(anydata? value) returns LiteralExpr {
    return {
        kind: "Literal",
        value: value
    };
}

public function createIdentifierExpr(string name) returns IdentifierExpr {
    return {
        kind: "Identifier",
        name: name
    };
}

public function createFunctionExpr(string name, Expr? target, Expr[] params) returns FunctionExpr {
    return {
        kind: "Function",
        name: name,
        target: target,
        params: params
    };
}

public function createMemberAccessExpr(Expr target, string member) returns MemberAccessExpr {
    return {
        kind: "MemberAccess",
        target: target,
        member: member
    };
}

public function createIndexerExpr(Expr target, Expr index) returns IndexerExpr {
    return {
        kind: "Indexer",
        target: target,
        index: index
    };
}
