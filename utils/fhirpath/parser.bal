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
// PARSER FOR FHIRPATH EXPRESSIONS
// ========================================
// Recursive descent parser implementing the complete FHIRPath N1 normative grammar.
// Precedence levels (lowest → highest binding):
//   implies → or/xor → and → in/contains → =/~/!=/!~ → </>/<=/>= → | → is/as
//   → +/-/& → */div/mod → unary +/- → postfix ./[] → primary

// ========================================
// TYPE DEFINITIONS
// ========================================

# Represents the internal state of the parser during expression parsing.
#
# + tokens - The list of tokens to be parsed
# + current - The current position in the token list
type ParserState record {|
    FhirPathToken[] tokens;
    int current;
|};

# Represents a parser error with token information.
#
# + token - The token where the error occurred
type ParseError record {|
    FhirPathToken token;
|};

# Error type for FHIRPath parser errors.
# This error is raised when the parser encounters invalid syntax.
type FHIRPathParserError distinct error<ParseError>;

# Type alias for parse result: an optional expression and updated parser state.
type ParseResult [Expr?, ParserState];

# Type alias for parameter list parse result: an array of expressions and updated state.
type ParseParamListResult [Expr[], ParserState];

# Type alias for token consumption result: success flag and updated state.
type ConsumeResult [boolean, ParserState];

// ========================================
// STATE MANAGEMENT
// ========================================

# Initializes a new parser state with the given token list.
#
# + tokens - The list of tokens to be parsed
# + return - A new ParserState initialized for parsing
isolated function createParserState(FhirPathToken[] tokens) returns ParserState {
    return {
        tokens: tokens,
        current: 0
    };
}

// ========================================
// API
// ========================================

# Parses a list of tokens into an abstract syntax tree (AST).
# This is the main entry point for parsing FHIRPath expressions.
#
# + tokens - The list of tokens produced by the scanner
# + return - An expression AST on success, or a FhirpathParserError if parsing fails
isolated function parse(FhirPathToken[] tokens) returns FHIRPathParserError|Expr? {
    ParserState state = createParserState(tokens);
    ParseResult result = check Expression(state);
    Expr? expr = result[0];
    ParserState endState = result[1];
    if expr is () {
        return ();
    }
    if !isparseAtEnd(endState) {
        FhirPathToken token = peekparse(endState);
        return error FHIRPathParserError("Unexpected tokens after expression.", token = token);
    }
    return expr;
}

// ========================================
// EXPRESSION PARSING — PRECEDENCE HIERARCHY
// ========================================

# Parses a top-level expression (entry point into precedence chain).
# Grammar: expression -> impliesExpression
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function Expression(ParserState state) returns FHIRPathParserError|ParseResult {
    return parseImpliesExpression(state);
}

// ------ Level 1: implies (lowest precedence) ------

# Parses an implies expression.
# Grammar: impliesExpression -> orExpression ( 'implies' orExpression )*
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseImpliesExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseOrExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, IMPLIES);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parseOrExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];
        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, IMPLIES);
    }

    return [currentExpr, newState];
}

// ------ Level 2: or / xor ------

# Parses an OR/XOR expression.
# Grammar: orExpression -> andExpression ( ( 'or' | 'xor' ) andExpression )*
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseOrExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseAndExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, OR, XOR);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parseAndExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];
        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, OR, XOR);
    }

    return [currentExpr, newState];
}

// ------ Level 3: and ------

# Parses an AND expression.
# Grammar: andExpression -> membershipExpression ( 'and' membershipExpression )*
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseAndExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseMembershipExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, AND);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parseMembershipExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];
        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, AND);
    }

    return [currentExpr, newState];
}

// ------ Level 4: in / contains ------

# Parses a membership expression.
# Grammar: membershipExpression -> equalityExpression ( ( 'in' | 'contains' ) equalityExpression )*
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseMembershipExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseEqualityExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, IN, CONTAINS);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parseEqualityExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];
        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, IN, CONTAINS);
    }

    return [currentExpr, newState];
}

// ------ Level 5: = / ~ / != / !~ ------

# Parses an equality/equivalence expression.
# Grammar: equalityExpression -> inequalityExpression ( ( '=' | '~' | '!=' | '!~' ) inequalityExpression )*
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseEqualityExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseInequalityExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, EQUAL, TILDE, BANG_EQUAL, BANG_TILDE);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parseInequalityExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];
        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, EQUAL, TILDE, BANG_EQUAL, BANG_TILDE);
    }

    return [currentExpr, newState];
}

// ------ Level 6: < / > / <= / >= ------

# Parses an inequality/comparison expression.
# Grammar: inequalityExpression -> unionExpression ( ( '<' | '>' | '<=' | '>=' ) unionExpression )*
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseInequalityExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseUnionExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, LESS_THAN, GREATER_THAN, LESS_EQUAL, GREATER_EQUAL);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parseUnionExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];
        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, LESS_THAN, GREATER_THAN, LESS_EQUAL, GREATER_EQUAL);
    }

    return [currentExpr, newState];
}

// ------ Level 7: | (union) ------

# Parses a union expression.
# Grammar: unionExpression -> typeExpression ( '|' typeExpression )*
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseUnionExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseTypeExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, PIPE);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parseTypeExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];
        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, PIPE);
    }

    return [currentExpr, newState];
}

// ------ Level 8: is / as (type specifier) ------

# Parses a type check/cast expression.
# Grammar: typeExpression -> additiveExpression ( ( 'is' | 'as' ) qualifiedIdentifier )?
# The right-hand side is always a type name (qualified identifier), not a value expression.
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseTypeExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseAdditiveExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, IS, AS);
    if matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        // Parse the type specifier as a qualified identifier string
        ParseResult typeResult = check parseQualifiedIdentifierExpr(newState);
        Expr? typeExpr = typeResult[0];
        newState = typeResult[1];
        if typeExpr is () {
            FhirPathToken tok = peekparse(newState);
            return error FHIRPathParserError("Expected type name after 'is'/'as'.", token = tok);
        }
        currentExpr = createBinaryExpr(currentExpr, operator, typeExpr);
    }

    return [currentExpr, newState];
}

# Parses a qualified identifier (e.g., FHIR.Patient, integer) as an IdentifierExpr.
# Used as the right-hand side of 'is' and 'as' type expressions.
#
# + state - The current parser state
# + return - A parse result with an IdentifierExpr holding the full qualified name, or an error
isolated function parseQualifiedIdentifierExpr(ParserState state) returns FHIRPathParserError|ParseResult {
    // Accept any identifier-like token as start of a qualified identifier
    [boolean, ParserState] match1 = matchIdentifierOrKeyword(state);
    if !match1[0] {
        return [(), state];
    }
    ParserState newState = match1[1];
    FhirPathToken first = previousparse(newState);
    string name = first.lexeme;

    // Continue with dot-separated parts (e.g., FHIR.Patient)
    [boolean, ParserState] dotMatch = matchToken(newState, DOT);
    while dotMatch[0] {
        newState = dotMatch[1];
        [boolean, ParserState] partMatch = matchIdentifierOrKeyword(newState);
        if !partMatch[0] {
            // Undo the dot — back up one
            newState = {tokens: newState.tokens, current: newState.current - 1};
            break;
        }
        newState = partMatch[1];
        FhirPathToken part = previousparse(newState);
        name = name + "." + part.lexeme;
        dotMatch = matchToken(newState, DOT);
    }

    return [createIdentifierExpr(name), newState];
}

// ------ Level 9: + / - / & ------

# Parses an additive expression.
# Grammar: additiveExpression -> multiplicativeExpression ( ( '+' | '-' | '&' ) multiplicativeExpression )*
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseAdditiveExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseMultiplicativeExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, PLUS, MINUS, AMPERSAND);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parseMultiplicativeExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];
        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, PLUS, MINUS, AMPERSAND);
    }

    return [currentExpr, newState];
}

// ------ Level 10: * / / / div / mod ------

# Parses a multiplicative expression.
# Grammar: multiplicativeExpression -> unaryExpression ( ( '*' | '/' | 'div' | 'mod' ) unaryExpression )*
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseMultiplicativeExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parseUnaryExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, STAR, SLASH, DIV, MOD);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parseUnaryExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];
        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, STAR, SLASH, DIV, MOD);
    }

    return [currentExpr, newState];
}

// ------ Level 11: prefix + / - ------

# Parses a unary prefix expression.
# Grammar: unaryExpression -> ( '+' | '-' ) unaryExpression | postfixExpression
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function parseUnaryExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    [boolean, ParserState] matchResult = matchToken(state, PLUS, MINUS);
    if matchResult[0] {
        ParserState newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult operandResult = check parseUnaryExpression(newState);
        Expr? operand = operandResult[0];
        newState = operandResult[1];
        if operand is () {
            return [(), newState];
        }
        return [createUnaryExpr(operator, operand), newState];
    }
    return parsePostfixExpression(state);
}

// ------ Level 12: postfix . and [] ------

# Parses a postfix expression (member access and indexer operations).
# Grammar: postfixExpression -> primary ( '.' invocation | '[' expression ']' )*
#
# + state - The current parser state
# + return - A parse result with the postfix expression and updated state, or an error
isolated function parsePostfixExpression(ParserState state) returns FHIRPathParserError|ParseResult {
    ParseResult result = check parsePrimary(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    boolean continuing = true;

    while continuing {
        [boolean, ParserState] dotMatch = matchToken(newState, DOT);
        if dotMatch[0] {
            newState = dotMatch[1];
            ParseResult invocationResult = check parseInvocation(newState);
            Expr? invocationExpr = invocationResult[0];
            newState = invocationResult[1];

            if invocationExpr is () {
                return [(), newState];
            }

            if invocationExpr is IdentifierExpr {
                currentExpr = createMemberAccessExpr(currentExpr, invocationExpr.name);
            } else if invocationExpr is FunctionExpr {
                currentExpr = createFunctionExpr(invocationExpr.name, currentExpr, invocationExpr.params);
            } else {
                return [(), newState];
            }
            continue;
        }

        [boolean, ParserState] bracketMatch = matchToken(newState, LEFT_BRACKET);
        if bracketMatch[0] {
            newState = bracketMatch[1];
            ParseResult indexResult = check Expression(newState);
            Expr? indexExpr = indexResult[0];
            newState = indexResult[1];

            if indexExpr is () {
                return [(), newState];
            }

            ConsumeResult consumeResult = check consumeparse(newState, RIGHT_BRACKET, "Expect ']' after index expression.");
            if !consumeResult[0] {
                return [(), consumeResult[1]];
            }
            newState = consumeResult[1];

            currentExpr = createIndexerExpr(currentExpr, indexExpr);
            continue;
        }

        continuing = false;
    }

    return [currentExpr, newState];
}

// ------ Level 13: primary (atoms) ------

# Parses a primary expression (literals, identifiers, function calls, parens, etc.).
#
# + state - The current parser state
# + return - A parse result with the primary expression and updated state, or an error
isolated function parsePrimary(ParserState state) returns FHIRPathParserError|ParseResult {
    // ---- Null literal: {} ----
    [boolean, ParserState] braceMatch = matchToken(state, LEFT_BRACE);
    if braceMatch[0] {
        ParserState newState = braceMatch[1];
        ConsumeResult closeResult = check consumeparse(newState, RIGHT_BRACE, "Expect '}' after '{'.");
        if !closeResult[0] {
            return [(), closeResult[1]];
        }
        return [createLiteralExpr(()), closeResult[1]];
    }

    // ---- Parenthesized expression: ( expr ) ----
    [boolean, ParserState] parenMatch = matchToken(state, LEFT_PAREN);
    if parenMatch[0] {
        ParserState newState = parenMatch[1];
        ParseResult innerResult = check Expression(newState);
        Expr? innerExpr = innerResult[0];
        newState = innerResult[1];
        if innerExpr is () {
            FhirPathToken tok = peekparse(newState);
            return error FHIRPathParserError("Expected expression inside parentheses.", token = tok);
        }
        ConsumeResult closeResult = check consumeparse(newState, RIGHT_PAREN, "Expect ')' after expression.");
        if !closeResult[0] {
            return [(), closeResult[1]];
        }
        return [innerExpr, closeResult[1]];
    }

    // ---- External constant: % identifier | % STRING ----
    [boolean, ParserState] percentMatch = matchToken(state, PERCENT);
    if percentMatch[0] {
        ParserState newState = percentMatch[1];
        [boolean, ParserState] strMatch = matchToken(newState, STRING);
        if strMatch[0] {
            FhirPathToken strTok = previousparse(strMatch[1]);
            string constName = strTok.literal is string ? <string>strTok.literal : strTok.lexeme;
            return [createExternalConstantExpr(constName), strMatch[1]];
        }
        [boolean, ParserState] idMatch = matchIdentifierOrKeyword(newState);
        if idMatch[0] {
            FhirPathToken idTok = previousparse(idMatch[1]);
            string constName = idTok.tokenType == DELIMITED_IDENTIFIER && idTok.literal is string
                ? <string>idTok.literal : idTok.lexeme;
            return [createExternalConstantExpr(constName), idMatch[1]];
        }
        FhirPathToken tok = peekparse(newState);
        return error FHIRPathParserError("Expected identifier or string after '%'.", token = tok);
    }

    // ---- Boolean literals ----
    [boolean, ParserState] falseMatch = matchToken(state, FALSE);
    if falseMatch[0] {
        return [createLiteralExpr(false), falseMatch[1]];
    }
    [boolean, ParserState] trueMatch = matchToken(state, TRUE);
    if trueMatch[0] {
        return [createLiteralExpr(true), trueMatch[1]];
    }

    // ---- Numeric literals (number, then check for quantity unit) ----
    [boolean, ParserState] numMatch = matchToken(state, NUMBER);
    if numMatch[0] {
        ParserState newState = numMatch[1];
        FhirPathToken numTok = previousparse(newState);
        decimal numVal = convertToDecimal(numTok.literal);

        // Quantity: number followed by unit keyword or string
        string? unitStr = tryParseUnit(newState);
        if unitStr is string {
            // Consume the unit token(s)
            ParseResult unitConsumeResult = check consumeUnit(newState);
            newState = unitConsumeResult[1];
            return [createQuantityLiteralExpr(numVal, unitStr), newState];
        }

        return [createLiteralExpr(numTok.literal), newState];
    }

    // ---- Long number ----
    [boolean, ParserState] longMatch = matchToken(state, LONGNUMBER);
    if longMatch[0] {
        FhirPathToken longTok = previousparse(longMatch[1]);
        return [createLiteralExpr(longTok.literal), longMatch[1]];
    }

    // ---- String literal ----
    [boolean, ParserState] strMatch = matchToken(state, STRING);
    if strMatch[0] {
        FhirPathToken strTok = previousparse(strMatch[1]);
        return [createLiteralExpr(strTok.literal), strMatch[1]];
    }

    // ---- Date/DateTime/Time literals ----
    [boolean, ParserState] dateMatch = matchToken(state, DATE, DATETIME, TIME);
    if dateMatch[0] {
        FhirPathToken dateTok = previousparse(dateMatch[1]);
        return [createLiteralExpr(dateTok.lexeme), dateMatch[1]];
    }

    // ---- $this / $index / $total ----
    [boolean, ParserState] thisMatch = matchToken(state, DOLLAR_THIS);
    if thisMatch[0] {
        return [createIdentifierExpr("$this"), thisMatch[1]];
    }
    [boolean, ParserState] indexMatch = matchToken(state, DOLLAR_INDEX);
    if indexMatch[0] {
        return [createIdentifierExpr("$index"), indexMatch[1]];
    }
    [boolean, ParserState] totalMatch = matchToken(state, DOLLAR_TOTAL);
    if totalMatch[0] {
        return [createIdentifierExpr("$total"), totalMatch[1]];
    }

    // ---- Identifier or function call ----
    [boolean, ParserState] idOrKwMatch = matchIdentifierOrKeyword(state);
    if idOrKwMatch[0] {
        ParserState newState = idOrKwMatch[1];
        FhirPathToken identToken = previousparse(newState);
        string name = identToken.lexeme;

        if identToken.tokenType == DELIMITED_IDENTIFIER && identToken.literal is string {
            name = <string>identToken.literal;
        }

        // Check if followed by "(" for function call
        [boolean, ParserState] funcParenMatch = matchToken(newState, LEFT_PAREN);
        if funcParenMatch[0] {
            newState = funcParenMatch[1];
            ParseParamListResult paramsResult = check parseParamList(newState);
            Expr[] params = paramsResult[0];
            newState = paramsResult[1];

            ConsumeResult consumeResult = check consumeparse(newState, RIGHT_PAREN, "Expect ')' after parameters.");
            if !consumeResult[0] {
                return [(), consumeResult[1]];
            }
            newState = consumeResult[1];

            return [createFunctionExpr(name, (), params), newState];
        }

        return [createIdentifierExpr(name), newState];
    }

    FhirPathToken token = peekparse(state);
    return error FHIRPathParserError("Expect expression.",
        token = token);
}

// ========================================
// INVOCATION PARSING
// ========================================

# Parses an invocation (identifier or function call), used after a dot operator.
# Accepts keyword tokens as valid identifiers (is, as, in, contains, div, mod, asc, desc, sort).
#
# + state - The current parser state
# + return - A parse result with the identifier or function expression, or an error
isolated function parseInvocation(ParserState state) returns FHIRPathParserError|ParseResult {
    // $this / $index / $total are valid invocations after a dot
    [boolean, ParserState] thisMatch = matchToken(state, DOLLAR_THIS);
    if thisMatch[0] {
        return [createIdentifierExpr("$this"), thisMatch[1]];
    }
    [boolean, ParserState] indexMatch = matchToken(state, DOLLAR_INDEX);
    if indexMatch[0] {
        return [createIdentifierExpr("$index"), indexMatch[1]];
    }
    [boolean, ParserState] totalMatch = matchToken(state, DOLLAR_TOTAL);
    if totalMatch[0] {
        return [createIdentifierExpr("$total"), totalMatch[1]];
    }

    [boolean, ParserState] idMatch = matchIdentifierOrKeyword(state);
    if idMatch[0] {
        ParserState newState = idMatch[1];
        FhirPathToken identToken = previousparse(newState);
        string name = identToken.lexeme;

        if identToken.tokenType == DELIMITED_IDENTIFIER && identToken.literal is string {
            name = <string>identToken.literal;
        }

        [boolean, ParserState] parenMatch = matchToken(newState, LEFT_PAREN);
        if parenMatch[0] {
            newState = parenMatch[1];
            ParseParamListResult paramsResult = check parseParamList(newState);
            Expr[] params = paramsResult[0];
            newState = paramsResult[1];

            ConsumeResult consumeResult = check consumeparse(newState, RIGHT_PAREN, "Expect ')' after parameters.");
            if !consumeResult[0] {
                return [(), consumeResult[1]];
            }
            newState = consumeResult[1];

            return [createFunctionExpr(name, (), params), newState];
        }

        return [createIdentifierExpr(name), newState];
    }

    FhirPathToken token = peekparse(state);
    return error FHIRPathParserError("Expect identifier or function.",
        token = token);
}

# Attempts to match any identifier-like token: IDENTIFIER, DELIMITED_IDENTIFIER,
# or keyword tokens that can also serve as identifiers per the FHIRPath grammar.
#
# + state - The current parser state
# + return - [matched, newState] — true if an identifier-like token was consumed
isolated function matchIdentifierOrKeyword(ParserState state) returns [boolean, ParserState] {
    return matchToken(state,
        IDENTIFIER, DELIMITED_IDENTIFIER,
        IS, AS, IN, CONTAINS,
        DIV, MOD, ASC, DESC,
        IMPLIES, AND, OR, XOR
    );
}

// ========================================
// PARAMETER LIST PARSING
// ========================================

# Parses a comma-separated list of function parameters.
# Grammar: paramList -> expression ( ',' expression )*
#
# + state - The current parser state
# + return - A parse result with the parameter list and updated state, or an error
isolated function parseParamList(ParserState state) returns FHIRPathParserError|ParseParamListResult {
    Expr[] params = [];
    ParserState newState = state;

    if checkToken(newState, RIGHT_PAREN) {
        return [params, newState];
    }

    ParseResult exprResult = check Expression(newState);
    Expr? expr = exprResult[0];
    newState = exprResult[1];

    if expr is () {
        return [params, newState];
    }

    params.push(expr);

    [boolean, ParserState] matchResult = matchToken(newState, COMMA);
    while matchResult[0] {
        newState = matchResult[1];
        ParseResult nextResult = check Expression(newState);
        Expr? nextExpr = nextResult[0];
        newState = nextResult[1];

        if nextExpr is () {
            return [params, newState];
        }

        params.push(nextExpr);
        matchResult = matchToken(newState, COMMA);
    }

    return [params, newState];
}

// ========================================
// QUANTITY UNIT HELPERS
// ========================================

// Date/time precision keywords for quantity units
final readonly & string[] DATETIME_UNIT_KEYWORDS = [
    "year", "month", "week", "day", "hour", "minute", "second", "millisecond",
    "years", "months", "weeks", "days", "hours", "minutes", "seconds", "milliseconds"
];

# Checks if the next token(s) form a quantity unit, and if so returns the unit string.
# Returns () if no unit follows.
#
# + state - The current parser state
# + return - The unit string if a unit token follows, or () if not
isolated function tryParseUnit(ParserState state) returns string? {
    if isparseAtEnd(state) {
        return ();
    }
    FhirPathToken nextTok = peekparse(state);

    // STRING unit: e.g., 'kg', 'mg', 'mmol'
    if nextTok.tokenType == STRING {
        if nextTok.literal is string {
            return <string>nextTok.literal;
        }
        return nextTok.lexeme;
    }

    // Identifier that is a datetime precision keyword
    if nextTok.tokenType == IDENTIFIER {
        foreach string kw in DATETIME_UNIT_KEYWORDS {
            if nextTok.lexeme == kw {
                return kw;
            }
        }
    }

    return ();
}

# Consumes the unit token(s) after a quantity number.
# Returns a dummy ParseResult just to allow check-style error propagation.
#
# + state - The current parser state
# + return - A parse result with () expression and the advanced state
isolated function consumeUnit(ParserState state) returns FHIRPathParserError|ParseResult {
    if isparseAtEnd(state) {
        return [(), state];
    }
    FhirPathToken nextTok = peekparse(state);
    if nextTok.tokenType == STRING || nextTok.tokenType == IDENTIFIER {
        return [(), advanceparse(state)];
    }
    return [(), state];
}

// ========================================
// TOKEN MATCHING & CONSUMPTION
// ========================================

# Attempts to match the current token against one or more expected token types.
# If matched, advances the parser; otherwise returns false without advancing.
#
# + state - The current parser state
# + types - Variable number of token types to match against
# + return - A tuple of [match success, updated state] where state is advanced if matched
isolated function matchToken(ParserState state, TokenType... types) returns [boolean, ParserState] {
    foreach TokenType tokenType in types {
        if checkToken(state, tokenType) {
            return [true, advanceparse(state)];
        }
    }
    return [false, state];
}

# Consumes a token of the expected type or returns an error.
#
# + state - The current parser state
# + tokenType - The expected token type
# + message - Error message to display if the token doesn't match
# + return - A consume result with success flag and updated state, or a parser error
isolated function consumeparse(ParserState state, TokenType tokenType, string message) returns FHIRPathParserError|ConsumeResult {
    if checkToken(state, tokenType) {
        return [true, advanceparse(state)];
    }

    FhirPathToken token = peekparse(state);
    return error FHIRPathParserError(message,
        token = token);
}

# Checks if the current token matches the expected type without consuming it.
#
# + state - The current parser state
# + tokenType - The token type to check against
# + return - True if the current token matches the expected type, false otherwise
isolated function checkToken(ParserState state, TokenType tokenType) returns boolean {
    if isparseAtEnd(state) {
        return false;
    }
    return peekparse(state).tokenType == tokenType;
}

// ========================================
// PARSER NAVIGATION
// ========================================

# Advances the parser to the next token.
#
# + state - The current parser state
# + return - Updated parser state with advanced position
isolated function advanceparse(ParserState state) returns ParserState {
    ParserState newState = state;
    if !isparseAtEnd(newState) {
        newState.current += 1;
    }
    return newState;
}

# Checks if the parser has reached the end of the token stream.
#
# + state - The current parser state
# + return - True if at end of tokens (EOF token), false otherwise
isolated function isparseAtEnd(ParserState state) returns boolean {
    return peekparse(state).tokenType == EOF;
}

# Peeks at the current token without consuming it.
#
# + state - The current parser state
# + return - The current token
isolated function peekparse(ParserState state) returns FhirPathToken {
    return state.tokens[state.current];
}

# Returns the most recently consumed token.
#
# + state - The current parser state
# + return - The previous token (at current position - 1)
isolated function previousparse(ParserState state) returns FhirPathToken {
    return state.tokens[state.current - 1];
}

// ========================================
// NUMERIC HELPERS
// ========================================

# Converts a token literal value to decimal for use in quantity expressions.
#
# + literal - The literal value (int, decimal, float, or ())
# + return - The decimal representation
isolated function convertToDecimal(anydata? literal) returns decimal {
    if literal is int {
        return <decimal>literal;
    } else if literal is decimal {
        return literal;
    } else if literal is float {
        decimal|error d = decimal:fromString(literal.toString());
        return d is decimal ? d : 0d;
    }
    return 0d;
}
