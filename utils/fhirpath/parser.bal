// Parser for parse expressions

// Parser state
type ParserState record {|
    FhirPathToken[] tokens;
    int current;
|};

// Parser error type
type ParseError record {|
    FhirPathToken token;
|};

public type FhirpathParserError distinct error<ParseError>;

// Type aliases for return types
type ParseResult [Expr?, ParserState];

type ParseParamListResult [Expr[], ParserState];

type ConsumeResult [boolean, ParserState];

// Create parser state
function createParserState(FhirPathToken[] tokens) returns ParserState {
    return {
        tokens: tokens,
        current: 0
    };
}

// Main parse function
public function parse(FhirPathToken[] tokens) returns FhirpathParserError|Expr? {
    ParserState state = createParserState(tokens);
    FhirpathParserError|ParseResult result = Expression(state);
    if result is FhirpathParserError {
        return result;
    }
    return result[0];
}

// expression -> orExpression
function Expression(ParserState state) returns FhirpathParserError|ParseResult {
    return parseOrExpression(state);
}

// orExpression -> andExpression ( ( "or" | "xor" ) andExpression )*
function parseOrExpression(ParserState state) returns FhirpathParserError|[Expr?, ParserState] {
    FhirpathParserError|ParseResult result = parseAndExpression(state);
    if result is FhirpathParserError {
        return result;
    }
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
        FhirpathParserError|ParseResult rightResult = parseAndExpression(newState);
        if rightResult is FhirpathParserError {
            return rightResult;
        }
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

// andExpression -> equalityExpression ( "and" equalityExpression )*
function parseAndExpression(ParserState state) returns FhirpathParserError|ParseResult {
    FhirpathParserError|ParseResult result = parseEqualityExpression(state);
    if result is FhirpathParserError {
        return result;
    }
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
        FhirpathParserError|ParseResult rightResult = parseEqualityExpression(newState);
        if rightResult is FhirpathParserError {
            return rightResult;
        }
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

// equalityExpression -> postfixExpression ( ( "=" | "!=" ) postfixExpression )*
function parseEqualityExpression(ParserState state) returns FhirpathParserError|ParseResult {
    FhirpathParserError|ParseResult result = parsePostfixExpression(state);
    if result is FhirpathParserError {
        return result;
    }
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
        FhirpathParserError|ParseResult rightResult = parsePostfixExpression(newState);
        if rightResult is FhirpathParserError {
            return rightResult;
        }
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

// postfixExpression -> primary ( postfixOp )*
// postfixOp -> "." invocation | "[" expression "]"
function parsePostfixExpression(ParserState state) returns FhirpathParserError|ParseResult {
    FhirpathParserError|ParseResult result = parsePrimary(state);
    if result is FhirpathParserError {
        return result;
    }
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
            FhirpathParserError|ParseResult invocationResult = parseInvocation(newState);
            if invocationResult is FhirpathParserError {
                return invocationResult;
            }
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
            FhirpathParserError|ParseResult indexResult = Expression(newState);
            if indexResult is FhirpathParserError {
                return indexResult;
            }
            Expr? indexExpr = indexResult[0];
            newState = indexResult[1];

            if indexExpr is () {
                return [(), newState];
            }

            FhirpathParserError|ConsumeResult consumeResult = consumeparse(newState, RIGHT_BRACKET, "Expect ']' after index expression.");
            if consumeResult is FhirpathParserError {
                return consumeResult;
            }
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

// invocation -> identifier | function
function parseInvocation(ParserState state) returns FhirpathParserError|ParseResult {
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
            FhirpathParserError|ParseParamListResult paramsResult = parseParamList(newState);
            if paramsResult is FhirpathParserError {
                return paramsResult;
            }
            Expr[] params = paramsResult[0];
            newState = paramsResult[1];

            FhirpathParserError|ConsumeResult consumeResult = consumeparse(newState, RIGHT_PAREN, "Expect ')' after parameters.");
            if consumeResult is FhirpathParserError {
                return consumeResult;
            }
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

// paramList -> expression ( "," expression )*
function parseParamList(ParserState state) returns FhirpathParserError|ParseParamListResult {
    Expr[] params = [];
    ParserState newState = state;

    // Check if empty param list
    if checkToken(newState, RIGHT_PAREN) {
        return [params, newState];
    }

    FhirpathParserError|ParseResult exprResult = Expression(newState);
    if exprResult is FhirpathParserError {
        return exprResult;
    }
    Expr? expr = exprResult[0];
    newState = exprResult[1];

    if expr is () {
        return [params, newState];
    }

    params.push(expr);

    [boolean, ParserState] matchResult = matchToken(newState, COMMA);
    while matchResult[0] {
        newState = matchResult[1];
        FhirpathParserError|ParseResult nextResult = Expression(newState);
        if nextResult is FhirpathParserError {
            return nextResult;
        }
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

// primary -> literal | function | identifier
function parsePrimary(ParserState state) returns FhirpathParserError|ParseResult {
    // Literals
    [boolean, ParserState] matchResult = matchToken(state, FALSE);
    if matchResult[0] {
        return [createLiteralExpr(false), matchResult[1]];
    }
    matchResult = matchToken(state, TRUE);
    if matchResult[0] {
        return [createLiteralExpr(true), matchResult[1]];
    }
    matchResult = matchToken(state, NIL);
    if matchResult[0] {
        return [createLiteralExpr(()), matchResult[1]];
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
            FhirpathParserError|ParseParamListResult paramsResult = parseParamList(newState);
            if paramsResult is FhirpathParserError {
                return paramsResult;
            }
            Expr[] params = paramsResult[0];
            newState = paramsResult[1];

            FhirpathParserError|ConsumeResult consumeResult = consumeparse(newState, RIGHT_PAREN, "Expect ')' after parameters.");
            if consumeResult is FhirpathParserError {
                return consumeResult;
            }
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

// Helper functions

function matchToken(ParserState state, TokenType... types) returns [boolean, ParserState] {
    foreach TokenType tokenType in types {
        if checkToken(state, tokenType) {
            return [true, advanceparse(state)];
        }
    }
    return [false, state];
}

function consumeparse(ParserState state, TokenType tokenType, string message) returns FhirpathParserError|ConsumeResult {
    if checkToken(state, tokenType) {
        return [true, advanceparse(state)];
    }

    FhirPathToken token = peekparse(state);
    return error FhirpathParserError(message,
        token = token);
}

function checkToken(ParserState state, TokenType tokenType) returns boolean {
    if isparseAtEnd(state) {
        return false;
    }
    return peekparse(state).tokenType == tokenType;
}

function advanceparse(ParserState state) returns ParserState {
    ParserState newState = state;
    if !isparseAtEnd(newState) {
        newState.current += 1;
    }
    return newState;
}

function isparseAtEnd(ParserState state) returns boolean {
    return peekparse(state).tokenType == EOF;
}

function peekparse(ParserState state) returns FhirPathToken {
    return state.tokens[state.current];
}

function previousparse(ParserState state) returns FhirPathToken {
    return state.tokens[state.current - 1];
}

