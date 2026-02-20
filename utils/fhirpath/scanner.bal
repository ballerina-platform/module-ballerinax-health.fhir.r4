// Copyright (c) 2023-2025, WSO2 LLC. (http://www.wso2.com).

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
// ERROR TYPES
// ========================================

# Represents a scanner error with position information.
#
# + position - The position in the source code where the error occurred
type ScannerError record {|
    int position;
|};

# Public error type for FHIRPath scanner errors.
# This error is raised when the scanner encounters invalid syntax.
public type FhirpathScannerError distinct error<ScannerError>;

// ========================================
// STATE MANAGEMENT
// ========================================

# Represents the internal state of the scanner during tokenization.
#
# + sourceCode - The FHIRPath expression being scanned
# + tokens - The list of tokens produced so far
# + startIndex - The start position of the current token being scanned
# + current - The current position in the source code
# + keywords - Map of reserved keywords to their token types
type ScannerState record {|
    string sourceCode;
    FhirPathToken[] tokens;
    int startIndex;
    int current;
    map<TokenType> keywords;
|};

# Initializes a new scanner state with the given source code.
# Sets up the initial scanning position and keyword mappings.
#
# + sourceCode - The FHIRPath expression to be tokenized
# + return - A new ScannerState initialized for scanning
isolated function createScannerState(string sourceCode) returns ScannerState {
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

// ========================================
// API
// ========================================

# Scans a FHIRPath expression and converts it into a sequence of tokens.
# This is the main entry point for lexical analysis.
#
# + sourceCode - The FHIRPath expression to tokenize
# + return - An array of tokens on success, or a FhirpathScannerError if scanning fails
isolated function scanTokens(string sourceCode) returns FhirpathScannerError|FhirPathToken[] {
    ScannerState state = createScannerState(sourceCode);

    while !isScannerAtEnd(state) {
        state.startIndex = state.current;
        state = check scanToken(state);
    }

    state.tokens.push(createToken(EOF, "", (), state.current));
    return state.tokens;
}

// ========================================
// TOKEN SCANNING
// ========================================

# Scans a single token from the current position in the source code.
# Identifies the token type based on the current character and advances the scanner.
#
# + state - The current scanner state
# + return - Updated scanner state on success, or a FhirpathScannerError for unexpected characters
isolated function scanToken(ScannerState state) returns FhirpathScannerError|ScannerState {
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

# Scans an identifier token starting from the current position.
# An identifier consists of alphabetic characters followed by any alphanumeric characters.
# Checks if the identifier matches a keyword and assigns the appropriate token type.
#
# + state - The current scanner state
# + return - Updated scanner state with the identifier token added
isolated function scanIdentifier(ScannerState state) returns ScannerState {
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

# Scans a delimited identifier enclosed in backticks.
# Delimited identifiers can contain special characters and escape sequences.
#
# + state - The current scanner state (positioned after the opening backtick)
# + return - Updated scanner state with the delimited identifier token, or an error if unterminated
isolated function scanDelimitedIdentifier(ScannerState state) returns FhirpathScannerError|ScannerState {
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

# Scans a numeric literal (integer or decimal).
# Handles both integer values and floating-point numbers with decimal parts.
#
# + state - The current scanner state (positioned at the first digit)
# + return - Updated scanner state with the number token added
isolated function scanNumber(ScannerState state) returns ScannerState {
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

# Scans a string literal enclosed in single quotes.
# Handles escape sequences within the string.
#
# + state - The current scanner state (positioned after the opening quote)
# + return - Updated scanner state with the string token, or an error if unterminated
isolated function scanString(ScannerState state) returns FhirpathScannerError|ScannerState {
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

// ========================================
// LOOKAHEAD & MATCHING
// ========================================

# Checks if the current character matches the expected character.
# If it matches, advances the scanner; otherwise, returns false.
#
# + state - The current scanner state
# + expected - The character to match
# + return - A tuple of [match result, updated state] where the state is advanced if matched
isolated function matchChar(ScannerState state, string expected) returns [boolean, ScannerState] {
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

# Peeks at the current character without consuming it.
# Returns a null character if at the end of the source.
#
# + state - The current scanner state
# + return - The current character, or "\0" if at end of source
isolated function peekScanner(ScannerState state) returns string {
    if isScannerAtEnd(state) {
        return "\\0";
    }
    return charAt(state.sourceCode, state.current);
}

# Peeks at the next character (one ahead of current) without consuming it.
# Returns a null character if beyond the end of the source.
#
# + state - The current scanner state
# + return - The next character, or "\0" if at or past end of source
isolated function peekScannerNext(ScannerState state) returns string {
    if state.current + 1 >= state.sourceCode.length() {
        return "\\0";
    }
    return charAt(state.sourceCode, state.current + 1);
}

// ========================================
// CHARACTER CLASSIFICATION
// ========================================

# Checks if a character is alphabetic (a-z, A-Z) or underscore.
#
# + c - The character to check (should be a single character)
# + return - True if the character is alphabetic or underscore, false otherwise
isolated function isAlpha(string c) returns boolean {
    if c.length() != 1 {
        return false;
    }
    string:Char char = <string:Char>c;
    int codePoint = char.toCodePointInt();
    return (codePoint >= 97 && codePoint <= 122) ||  // a-z
            (codePoint >= 65 && codePoint <= 90) ||  // A-Z
            codePoint == 95; // _
}

# Checks if a character is alphanumeric (letter, digit, or underscore).
#
# + c - The character to check
# + return - True if the character is alphanumeric, false otherwise
isolated function isAlphaNumeric(string c) returns boolean {
    return isAlpha(c) || isDigit(c);
}

# Checks if a character is a numeric digit (0-9).
#
# + c - The character to check (should be a single character)
# + return - True if the character is a digit, false otherwise
isolated function isDigit(string c) returns boolean {
    if c.length() != 1 {
        return false;
    }
    string:Char char = <string:Char>c;
    int codePoint = char.toCodePointInt();
    return codePoint >= 48 && codePoint <= 57; // 0-9
}

// ========================================
// SCANNER NAVIGATION
// ========================================

# Checks if the scanner has reached the end of the source code.
#
# + state - The current scanner state
# + return - True if at end of source, false otherwise
isolated function isScannerAtEnd(ScannerState state) returns boolean {
    return state.current >= state.sourceCode.length();
}

# Advances the scanner to the next character.
#
# + state - The current scanner state
# + return - A tuple of [current character, updated state with advanced position]
isolated function advanceScanner(ScannerState state) returns [string, ScannerState] {
    string char = charAt(state.sourceCode, state.current);
    ScannerState newState = state;
    newState.current += 1;
    return [char, newState];
}

# Retrieves a single character at the specified index from a string.
#
# + str - The source string
# + index - The zero-based index of the character to retrieve
# + return - The character at the specified index
isolated function charAt(string str, int index) returns string {
    return str.substring(index, index + 1);
}

// ========================================
// TOKEN CREATION
// ========================================

# Adds a token without a literal value to the token list.
#
# + state - The current scanner state
# + tokenType - The type of token to add
# + return - Updated scanner state with the token added
isolated function addToken(ScannerState state, TokenType tokenType) returns ScannerState {
    return addTokenWithLiteral(state, tokenType, ());
}

# Adds a token with an optional literal value to the token list.
#
# + state - The current scanner state
# + tokenType - The type of token to add
# + literal - The literal value associated with the token (e.g., number value, string content)
# + return - Updated scanner state with the token added
isolated function addTokenWithLiteral(ScannerState state, TokenType tokenType, anydata? literal) returns ScannerState {
    string text = state.sourceCode.substring(state.startIndex, state.current);
    ScannerState newState = state;
    newState.tokens.push(createToken(tokenType, text, literal, newState.startIndex));
    return newState;
}
