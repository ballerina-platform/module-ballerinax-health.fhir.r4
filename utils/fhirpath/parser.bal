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
// PARSER FOR FHIRPATH EXPRESSIONS
// ========================================
// This module implements a recursive descent parser for FHIRPath expressions.
// The parser follows the FHIRPath grammar and produces an Abstract Syntax Tree (AST).

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

# Public error type for FHIRPath parser errors.
# This error is raised when the parser encounters invalid syntax.
public type FhirpathParserError distinct error<ParseError>;

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
# Sets up the initial parsing position at the beginning of the token stream.
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
public isolated function parse(FhirPathToken[] tokens) returns FhirpathParserError|Expr? {
    ParserState state = createParserState(tokens);
    ParseResult result = check Expression(state);
    Expr? expr = result[0];
    ParserState endState = result[1];
    if expr is () {
        return ();
    }
    if !isparseAtEnd(endState) {
        FhirPathToken token = peekparse(endState);
        return error FhirpathParserError("Unexpected tokens after expression.", token = token);
    }
    return expr;
}

// ========================================
// EXPRESSION PARSING
// ========================================
// These functions implement the FHIRPath grammar rules in order of precedence.
// The grammar is parsed using recursive descent with each precedence level
// handled by a separate function.

# Parses a top-level expression.
# Grammar: expression -> orExpression
#
# + state - The current parser state
# + return - A parse result with the expression and updated state, or an error
isolated function Expression(ParserState state) returns FhirpathParserError|ParseResult {
    return parseOrExpression(state);
}

# Parses an OR/XOR expression (lowest precedence).
# Grammar: orExpression -> andExpression ( ( "or" | "xor" ) andExpression )*
#
# + state - The current parser state
# + return - A parse result with the binary expression and updated state, or an error
isolated function parseOrExpression(ParserState state) returns FhirpathParserError|[Expr?, ParserState] {
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

# Parses an AND expression.
# Grammar: andExpression -> equalityExpression ( "and" equalityExpression )*
#
# + state - The current parser state
# + return - A parse result with the binary expression and updated state, or an error
isolated function parseAndExpression(ParserState state) returns FhirpathParserError|ParseResult {
    ParseResult result = check parseEqualityExpression(state);
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
        ParseResult rightResult = check parseEqualityExpression(newState);
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

# Parses an equality expression (= or !=).
# Grammar: equalityExpression -> postfixExpression ( ( "=" | "!=" ) postfixExpression )*
#
# + state - The current parser state
# + return - A parse result with the binary expression and updated state, or an error
isolated function parseEqualityExpression(ParserState state) returns FhirpathParserError|ParseResult {
    ParseResult result = check parsePostfixExpression(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    [boolean, ParserState] matchResult = matchToken(newState, EQUAL, BANG_EQUAL);
    while matchResult[0] {
        newState = matchResult[1];
        FhirPathToken operator = previousparse(newState);
        ParseResult rightResult = check parsePostfixExpression(newState);
        Expr? right = rightResult[0];
        newState = rightResult[1];

        if right is () {
            return [(), newState];
        }
        currentExpr = createBinaryExpr(currentExpr, operator, right);
        matchResult = matchToken(newState, EQUAL, BANG_EQUAL);
    }

    return [currentExpr, newState];
}

# Parses a postfix expression (member access and indexer operations).
# Grammar: postfixExpression -> primary ( postfixOp )*
# postfixOp -> "." invocation | "[" expression "]"
#
# + state - The current parser state
# + return - A parse result with the postfix expression and updated state, or an error
isolated function parsePostfixExpression(ParserState state) returns FhirpathParserError|ParseResult {
    ParseResult result = check parsePrimary(state);
    Expr? expr = result[0];
    ParserState newState = result[1];

    if expr is () {
        return [(), newState];
    }

    Expr currentExpr = expr;
    boolean continuing = true;

    while continuing {
        // Check for "." (member access)
        [boolean, ParserState] dotMatch = matchToken(newState, DOT);
        if dotMatch[0] {
            newState = dotMatch[1];
            // invocation -> identifier | function
            ParseResult invocationResult = check parseInvocation(newState);
            Expr? invocationExpr = invocationResult[0];
            newState = invocationResult[1];

            if invocationExpr is () {
                return [(), newState];
            }

            // Wrap in member access or function call
            if invocationExpr is IdentifierExpr {
                currentExpr = createMemberAccessExpr(currentExpr, invocationExpr.name);
            } else if invocationExpr is FunctionExpr {
                // For member function call, set the target to the left-hand expression
                currentExpr = createFunctionExpr(invocationExpr.name, currentExpr, invocationExpr.params);
            } else {
                return [(), newState];
            }
            continue;
        }

        // Check for "[" (indexer)
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

# Parses an invocation (identifier or function call).
# Grammar: invocation -> identifier | function
#
# + state - The current parser state
# + return - A parse result with the identifier or function expression, or an error
isolated function parseInvocation(ParserState state) returns FhirpathParserError|ParseResult {
    // Try to parse as identifier or function
    [boolean, ParserState] idMatch = matchToken(state, IDENTIFIER, DELIMITED_IDENTIFIER);
    if idMatch[0] {
        ParserState newState = idMatch[1];
        FhirPathToken identToken = previousparse(newState);
        string name = identToken.lexeme;

        if identToken.tokenType == DELIMITED_IDENTIFIER && identToken.literal is string {
            name = <string>identToken.literal;
        }

        // Check if followed by "(" for function call
        [boolean, ParserState] parenMatch = matchToken(newState, LEFT_PAREN);
        if parenMatch[0] {
            newState = parenMatch[1];
            // Parse parameter list
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

        // Just an identifier
        return [createIdentifierExpr(name), newState];
    }

    FhirPathToken token = peekparse(state);
    return error FhirpathParserError("Expect identifier or function.",
        token = token);
}

# Parses a comma-separated list of function parameters.
# Grammar: paramList -> expression ( "," expression )*
#
# + state - The current parser state
# + return - A parse result with the parameter list and updated state, or an error
isolated function parseParamList(ParserState state) returns FhirpathParserError|ParseParamListResult {
    Expr[] params = [];
    ParserState newState = state;

    // Check if empty param list
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

# Parses a primary expression (literals, identifiers, or function calls).
# Grammar: primary -> literal | function | identifier
#
# + state - The current parser state
# + return - A parse result with the primary expression and updated state, or an error
isolated function parsePrimary(ParserState state) returns FhirpathParserError|ParseResult {
    // Literals
    [boolean, ParserState] matchResult = matchToken(state, FALSE);
    if matchResult[0] {
        return [createLiteralExpr(false), matchResult[1]];
    }
    matchResult = matchToken(state, TRUE);
    if matchResult[0] {
        return [createLiteralExpr(true), matchResult[1]];
    }

    matchResult = matchToken(state, NUMBER);
    if matchResult[0] {
        FhirPathToken token = previousparse(matchResult[1]);
        return [createLiteralExpr(token.literal), matchResult[1]];
    }

    matchResult = matchToken(state, STRING);
    if matchResult[0] {
        FhirPathToken token = previousparse(matchResult[1]);
        return [createLiteralExpr(token.literal), matchResult[1]];
    }

    // Check for identifier or function
    matchResult = matchToken(state, IDENTIFIER, DELIMITED_IDENTIFIER);
    if matchResult[0] {
        ParserState newState = matchResult[1];
        FhirPathToken identToken = previousparse(newState);
        string name = identToken.lexeme;

        if identToken.tokenType == DELIMITED_IDENTIFIER && identToken.literal is string {
            name = <string>identToken.literal;
        }

        // Check if followed by "(" for function call
        [boolean, ParserState] parenMatch = matchToken(newState, LEFT_PAREN);
        if parenMatch[0] {
            newState = parenMatch[1];
            // Parse parameter list
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

        // Just an identifier
        return [createIdentifierExpr(name), newState];
    }

    FhirPathToken token = peekparse(state);
    return error FhirpathParserError("Expect expression.",
        token = token);
}

// ========================================
// TOKEN MATCHING & CONSUMPTION
// ========================================

# Attempts to match the current token against one or more expected token types.
# If matched, advances the parser; otherwise, returns false without advancing.
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
# This is used to enforce required tokens in the grammar.
#
# + state - The current parser state
# + tokenType - The expected token type
# + message - Error message to display if the token doesn't match
# + return - A consume result with success flag and updated state, or a parser error
isolated function consumeparse(ParserState state, TokenType tokenType, string message) returns FhirpathParserError|ConsumeResult {
    if checkToken(state, tokenType) {
        return [true, advanceparse(state)];
    }

    FhirPathToken token = peekparse(state);
    return error FhirpathParserError(message,
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

