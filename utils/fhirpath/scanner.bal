// Scanner error type for FHIRPath
type ScannerError record {|
    int position;
|};

public type FhirpathScannerError distinct error<ScannerError>;

// Scanner state record
type ScannerState record {|
    string sourceCode;
    FhirPathToken[] tokens;
    int startIndex;
    int current;
    map<TokenType> keywords;
|};

// Initialize scanner state
function createScannerState(string sourceCode) returns ScannerState {
    return {
        sourceCode: sourceCode,
        tokens: [],
        startIndex: 0,
        current: 0,
        keywords: {
            "or": OR,
            "xor": XOR,
            "and": AND,
            "true": TRUE,
            "false": FALSE
        }
    };
}

// Main scanning function
public function scanTokens(string sourceCode) returns FhirpathScannerError|FhirPathToken[] {
    ScannerState state = createScannerState(sourceCode);

    while !isScannerAtEnd(state) {
        state.startIndex = state.current;
        FhirpathScannerError|ScannerState result = scanToken(state);
        if result is FhirpathScannerError {
            return result;
        }
        state = result;
    }

    state.tokens.push(createToken(EOF, "", (), state.current));
    return state.tokens;
}

// Scan a single token
function scanToken(ScannerState state) returns FhirpathScannerError|ScannerState {
    [string, ScannerState] result = advanceScanner(state);
    string c = result[0];
    ScannerState newState = result[1];

    if c == "(" {
        return addToken(newState, LEFT_PAREN);
    } else if c == ")" {
        return addToken(newState, RIGHT_PAREN);
    } else if c == "[" {
        return addToken(newState, LEFT_BRACKET);
    } else if c == "]" {
        return addToken(newState, RIGHT_BRACKET);
    } else if c == "," {
        return addToken(newState, COMMA);
    } else if c == "." {
        return addToken(newState, DOT);
    } else if c == "=" {
        return addToken(newState, EQUAL);
    } else if c == "!" {
        [boolean, ScannerState] matchResult = matchChar(newState, "=");
        if matchResult[0] {
            return addToken(matchResult[1], BANG_EQUAL);
        } else {
            return error FhirpathScannerError("Unexpected character '!'.",
                position = newState.current);
        }
    } else if c == " " || c == "\r" || c == "\t" {
        // Ignore whitespace
        return newState;
    } else if c == "\n" {
        // Ignore newline
        return newState;
    } else if c == "'" {
        return scanString(newState);
    } else if c == "`" {
        return scanDelimitedIdentifier(newState);
    } else if isDigit(c) {
        return scanNumber(newState);
    } else if isAlpha(c) {
        return scanIdentifier(newState);
    } else {
        return error FhirpathScannerError("Unexpected character.",
            position = newState.current);
    }
}

// Scan identifier
function scanIdentifier(ScannerState state) returns ScannerState {
    ScannerState newState = state;
    while isAlphaNumeric(peekScanner(newState)) {
        [string, ScannerState] result = advanceScanner(newState);
        newState = result[1];
    }

    string text = newState.sourceCode.substring(newState.startIndex, newState.current);
    TokenType? tokenType = newState.keywords[text];
    TokenType finalType = tokenType is () ? IDENTIFIER : tokenType;
    return addToken(newState, finalType);
}

// Scan delimited identifier (backtick-delimited)
function scanDelimitedIdentifier(ScannerState state) returns FhirpathScannerError|ScannerState {
    ScannerState newState = state;
    while peekScanner(newState) != "`" && !isScannerAtEnd(newState) {
        // Handle escape sequences
        if peekScanner(newState) == "\\" {
            [string, ScannerState] escResult = advanceScanner(newState);
            newState = escResult[1];
            if !isScannerAtEnd(newState) {
                [string, ScannerState] nextResult = advanceScanner(newState);
                newState = nextResult[1];
            }
        } else {
            [string, ScannerState] result = advanceScanner(newState);
            newState = result[1];
        }
    }

    if isScannerAtEnd(newState) {
        return error FhirpathScannerError("Unterminated delimited identifier.",
            position = newState.current);
    }

    // The closing `
    [string, ScannerState] result = advanceScanner(newState);
    newState = result[1];

    // Trim the surrounding backticks
    string value = newState.sourceCode.substring(newState.startIndex + 1, newState.current - 1);
    return addTokenWithLiteral(newState, DELIMITED_IDENTIFIER, value);
}

// Scan number
function scanNumber(ScannerState state) returns ScannerState {
    ScannerState newState = state;
    while isDigit(peekScanner(newState)) {
        [string, ScannerState] result = advanceScanner(newState);
        newState = result[1];
    }

    // Look for a fractional part
    if peekScanner(newState) == "." && isDigit(peekScannerNext(newState)) {
        // Consume the "."
        [string, ScannerState] result = advanceScanner(newState);
        newState = result[1];

        while isDigit(peekScanner(newState)) {
            [string, ScannerState] advResult = advanceScanner(newState);
            newState = advResult[1];
        }
    }

    string numberStr = newState.sourceCode.substring(newState.startIndex, newState.current);
    float|error num = float:fromString(numberStr);
    if num is float {
        return addTokenWithLiteral(newState, NUMBER, num);
    }
    return newState;
}

// Scan string (single-quote delimited)
function scanString(ScannerState state) returns FhirpathScannerError|ScannerState {
    ScannerState newState = state;
    while peekScanner(newState) != "'" && !isScannerAtEnd(newState) {
        // Handle escape sequences
        if peekScanner(newState) == "\\" {
            [string, ScannerState] escResult = advanceScanner(newState);
            newState = escResult[1];
            if !isScannerAtEnd(newState) {
                [string, ScannerState] nextResult = advanceScanner(newState);
                newState = nextResult[1];
            }
        } else {
            [string, ScannerState] result = advanceScanner(newState);
            newState = result[1];
        }
    }

    if isScannerAtEnd(newState) {
        return error FhirpathScannerError("Unterminated string.",
            position = newState.current);
    }

    // The closing '
    [string, ScannerState] result = advanceScanner(newState);
    newState = result[1];

    // Trim the surrounding quotes
    string value = newState.sourceCode.substring(newState.startIndex + 1, newState.current - 1);
    return addTokenWithLiteral(newState, STRING, value);
}

// Match expected character
function matchChar(ScannerState state, string expected) returns [boolean, ScannerState] {
    if isScannerAtEnd(state) {
        return [false, state];
    }
    if charAt(state.sourceCode, state.current) != expected {
        return [false, state];
    }

    ScannerState newState = state;
    newState.current += 1;
    return [true, newState];
}

// Peek at current character
function peekScanner(ScannerState state) returns string {
    if isScannerAtEnd(state) {
        return "\\0";
    }
    return charAt(state.sourceCode, state.current);
}

// Peek at next character
function peekScannerNext(ScannerState state) returns string {
    if state.current + 1 >= state.sourceCode.length() {
        return "\\0";
    }
    return charAt(state.sourceCode, state.current + 1);
}

// Check if character is alpha
function isAlpha(string c) returns boolean {
    if c.length() != 1 {
        return false;
    }
    string:Char char = <string:Char>c;
    int codePoint = char.toCodePointInt();
    return (codePoint >= 97 && codePoint <= 122) ||  // a-z
            (codePoint >= 65 && codePoint <= 90) ||  // A-Z
            codePoint == 95; // _
}

// Check if character is alphanumeric
function isAlphaNumeric(string c) returns boolean {
    return isAlpha(c) || isDigit(c);
}

// Check if character is digit
function isDigit(string c) returns boolean {
    if c.length() != 1 {
        return false;
    }
    string:Char char = <string:Char>c;
    int codePoint = char.toCodePointInt();
    return codePoint >= 48 && codePoint <= 57; // 0-9
}

// Check if at end of source
function isScannerAtEnd(ScannerState state) returns boolean {
    return state.current >= state.sourceCode.length();
}

// Advance to next character
function advanceScanner(ScannerState state) returns [string, ScannerState] {
    string char = charAt(state.sourceCode, state.current);
    ScannerState newState = state;
    newState.current += 1;
    return [char, newState];
}

// Get character at index
function charAt(string str, int index) returns string {
    return str.substring(index, index + 1);
}

// Add token without literal
function addToken(ScannerState state, TokenType tokenType) returns ScannerState {
    return addTokenWithLiteral(state, tokenType, ());
}

// Add token with literal
function addTokenWithLiteral(ScannerState state, TokenType tokenType, anydata? literal) returns ScannerState {
    string text = state.sourceCode.substring(state.startIndex, state.current);
    ScannerState newState = state;
    newState.tokens.push(createToken(tokenType, text, literal, newState.startIndex));
    return newState;
}
