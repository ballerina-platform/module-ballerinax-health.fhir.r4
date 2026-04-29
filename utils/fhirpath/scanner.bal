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
// ERROR TYPES
// ========================================

# Represents a scanner error with position information.
#
# + position - The position in the source code where the error occurred
type ScannerError record {|
    int position;
|};

# Error type for FHIRPath scanner errors.
# This error is raised when the scanner encounters invalid syntax.
type FHIRPathScannerError distinct error<ScannerError>;

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
            "implies": IMPLIES,
            "true": TRUE,
            "false": FALSE,
            "div": DIV,
            "mod": MOD,
            "is": IS,
            "as": AS,
            "in": IN,
            "contains": CONTAINS,
            "asc": ASC,
            "desc": DESC
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
isolated function scanTokens(string sourceCode) returns FHIRPathScannerError|FhirPathToken[] {
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
#
# + state - The current scanner state
# + return - Updated scanner state on success, or a FhirpathScannerError for unexpected characters
isolated function scanToken(ScannerState state) returns FHIRPathScannerError|ScannerState {
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
    } else if c == "{" {
        return addToken(newState, LEFT_BRACE);
    } else if c == "}" {
        return addToken(newState, RIGHT_BRACE);
    } else if c == "," {
        return addToken(newState, COMMA);
    } else if c == "." {
        return addToken(newState, DOT);
    } else if c == "+" {
        return addToken(newState, PLUS);
    } else if c == "-" {
        return addToken(newState, MINUS);
    } else if c == "*" {
        return addToken(newState, STAR);
    } else if c == "/" {
        // Line comment: // ...
        [boolean, ScannerState] slashMatch = matchChar(newState, "/");
        if slashMatch[0] {
            newState = slashMatch[1];
            while peekScanner(newState) != "\n" && !isScannerAtEnd(newState) {
                [string, ScannerState] skipResult = advanceScanner(newState);
                newState = skipResult[1];
            }
            return newState;
        }
        // Block comment: /* ... */
        [boolean, ScannerState] starMatch = matchChar(newState, "*");
        if starMatch[0] {
            newState = starMatch[1];
            while !isScannerAtEnd(newState) {
                [string, ScannerState] blockResult = advanceScanner(newState);
                string blockChar = blockResult[0];
                newState = blockResult[1];
                if blockChar == "*" && peekScanner(newState) == "/" {
                    [string, ScannerState] closeResult = advanceScanner(newState);
                    newState = closeResult[1];
                    break;
                }
            }
            return newState;
        }
        return addToken(newState, SLASH);
    } else if c == "&" {
        return addToken(newState, AMPERSAND);
    } else if c == "|" {
        return addToken(newState, PIPE);
    } else if c == "~" {
        return addToken(newState, TILDE);
    } else if c == "%" {
        return addToken(newState, PERCENT);
    } else if c == "=" {
        return addToken(newState, EQUAL);
    } else if c == "!" {
        [boolean, ScannerState] tildeMatch = matchChar(newState, "~");
        if tildeMatch[0] {
            return addToken(tildeMatch[1], BANG_TILDE);
        }
        [boolean, ScannerState] eqMatch = matchChar(newState, "=");
        if eqMatch[0] {
            return addToken(eqMatch[1], BANG_EQUAL);
        }
        return error FHIRPathScannerError("Unexpected character '!'. Expected '!=' or '!~'.",
            position = newState.current);
    } else if c == "<" {
        [boolean, ScannerState] eqMatch = matchChar(newState, "=");
        if eqMatch[0] {
            return addToken(eqMatch[1], LESS_EQUAL);
        }
        return addToken(newState, LESS_THAN);
    } else if c == ">" {
        [boolean, ScannerState] eqMatch = matchChar(newState, "=");
        if eqMatch[0] {
            return addToken(eqMatch[1], GREATER_EQUAL);
        }
        return addToken(newState, GREATER_THAN);
    } else if c == "$" {
        return scanDollarSpecial(newState);
    } else if c == "@" {
        return scanDateTimeLiteral(newState);
    } else if c == " " || c == "\r" || c == "\t" || c == "\n" {
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
        return error FHIRPathScannerError("Unexpected character.",
            position = newState.current);
    }
}

// ========================================
// SPECIAL TOKEN SCANNERS
// ========================================

# Scans $this, $index, or $total special invocation tokens.
# Called after consuming the '$' character.
#
# + state - The scanner state positioned after '$'
# + return - Updated state with DOLLAR_THIS, DOLLAR_INDEX, or DOLLAR_TOTAL token, or an error
isolated function scanDollarSpecial(ScannerState state) returns FHIRPathScannerError|ScannerState {
    ScannerState newState = state;
    // Collect alphanumeric chars to form the name after $
    while isAlphaNumeric(peekScanner(newState)) {
        [string, ScannerState] r = advanceScanner(newState);
        newState = r[1];
    }
    string text = newState.sourceCode.substring(newState.startIndex, newState.current);
    if text == "$this" {
        return addToken(newState, DOLLAR_THIS);
    } else if text == "$index" {
        return addToken(newState, DOLLAR_INDEX);
    } else if text == "$total" {
        return addToken(newState, DOLLAR_TOTAL);
    }
    return error FHIRPathScannerError(string `Unknown special variable '${text}'.`,
        position = newState.startIndex);
}

# Scans a date, datetime, or time literal that starts with '@'.
# Called after consuming the '@' character.
# Format: @YYYY-MM-DD, @YYYY-MM-DDTHH:MM:SS[.fff][Z|+HH:MM], @THH:MM:SS
#
# + state - The scanner state positioned after '@'
# + return - Updated state with DATE, DATETIME, or TIME token, or an error
isolated function scanDateTimeLiteral(ScannerState state) returns FHIRPathScannerError|ScannerState {
    ScannerState newState = state;
    // Collect all characters that can be part of date/time: digits, -, :, T, Z, +
    // For '.', only consume when the next char is a digit (milliseconds separator);
    // otherwise it is a member-access dot and must remain as a separate token.
    // Use keepScanning flag instead of break to avoid nested-if break semantics issues.
    boolean keepScanning = true;
    while !isScannerAtEnd(newState) && keepScanning {
        string ch = peekScanner(newState);
        if isDigit(ch) || ch == "-" || ch == ":" || ch == "T" || ch == "Z" || ch == "+" {
            [string, ScannerState] r = advanceScanner(newState);
            newState = r[1];
        } else if ch == "." && isDigit(peekScannerNext(newState)) {
            // '.' followed by a digit: part of fractional seconds (e.g. .000)
            [string, ScannerState] r = advanceScanner(newState);
            newState = r[1];
        } else {
            // Any other character (including member-access dot): stop here
            keepScanning = false;
        }
    }
    string text = newState.sourceCode.substring(newState.startIndex, newState.current);
    // text includes the leading '@'
    string afterAt = text.substring(1);

    TokenType tokenType;
    if afterAt.startsWith("T") {
        tokenType = TIME;
    } else if afterAt.includes("T") {
        tokenType = DATETIME;
    } else {
        tokenType = DATE;
    }

    if tokenType == TIME {
        // TIME literals cannot carry timezone (Z, +offset, -offset)
        string timeContent = afterAt.substring(1); // strip leading 'T'
        foreach int i in 0 ..< timeContent.length() {
            string ch = timeContent.substring(i, i + 1);
            if ch == "Z" || ch == "+" || ch == "-" {
                return error FHIRPathScannerError(
                    "Invalid time literal: time literals cannot include a timezone designator.",
                    position = newState.startIndex);
            }
        }
    }

    return addTokenWithLiteral(newState, tokenType, text);
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
isolated function scanDelimitedIdentifier(ScannerState state) returns FHIRPathScannerError|ScannerState {
    ScannerState newState = state;
    while peekScanner(newState) != "`" && !isScannerAtEnd(newState) {
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
        return error FHIRPathScannerError("Unterminated delimited identifier.",
            position = newState.current);
    }

    [string, ScannerState] result = advanceScanner(newState);
    newState = result[1];

    string value = newState.sourceCode.substring(newState.startIndex + 1, newState.current - 1);
    return addTokenWithLiteral(newState, DELIMITED_IDENTIFIER, value);
}

# Scans a numeric literal (integer, decimal, or long number).
# Handles integer, floating-point, and L-suffixed long numbers.
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
        [string, ScannerState] result = advanceScanner(newState);
        newState = result[1];
        while isDigit(peekScanner(newState)) {
            [string, ScannerState] advResult = advanceScanner(newState);
            newState = advResult[1];
        }
    }

    // Check for long number suffix 'L'
    if peekScanner(newState) == "L" {
        [string, ScannerState] lResult = advanceScanner(newState);
        newState = lResult[1];
        string longStr = newState.sourceCode.substring(newState.startIndex, newState.current - 1);
        int|error longVal = int:fromString(longStr);
        if longVal is int {
            return addTokenWithLiteral(newState, LONGNUMBER, longVal);
        }
        return addToken(newState, LONGNUMBER);
    }

    string numberStr = newState.sourceCode.substring(newState.startIndex, newState.current);
    // Store as decimal if it has a fractional part, int otherwise
    if numberStr.includes(".") {
        decimal|error decVal = decimal:fromString(numberStr);
        if decVal is decimal {
            return addTokenWithLiteral(newState, NUMBER, decVal);
        }
    } else {
        int|error intVal = int:fromString(numberStr);
        if intVal is int {
            return addTokenWithLiteral(newState, NUMBER, intVal);
        }
    }
    return newState;
}

# Scans a string literal enclosed in single quotes.
# Handles escape sequences within the string.
#
# + state - The current scanner state (positioned after the opening quote)
# + return - Updated scanner state with the string token, or an error if unterminated
isolated function scanString(ScannerState state) returns FHIRPathScannerError|ScannerState {
    ScannerState newState = state;
    while peekScanner(newState) != "'" && !isScannerAtEnd(newState) {
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
        return error FHIRPathScannerError("Unterminated string.",
            position = newState.current);
    }

    [string, ScannerState] result = advanceScanner(newState);
    newState = result[1];

    // Process escape sequences in the string value
    string raw = newState.sourceCode.substring(newState.startIndex + 1, newState.current - 1);
    string value = processStringEscapes(raw);
    return addTokenWithLiteral(newState, STRING, value);
}

# Processes escape sequences in a raw string value.
# Handles \\, \', \", \n, \r, \t, \f, \uXXXX sequences.
#
# + raw - The raw string with potential escape sequences
# + return - The processed string with escape sequences replaced
isolated function processStringEscapes(string raw) returns string {
    string result = "";
    int i = 0;
    while i < raw.length() {
        string ch = raw.substring(i, i + 1);
        if ch == "\\" && i + 1 < raw.length() {
            string next = raw.substring(i + 1, i + 2);
            if next == "n" {
                result += "\n";
                i += 2;
            } else if next == "r" {
                result += "\r";
                i += 2;
            } else if next == "t" {
                result += "\t";
                i += 2;
            } else if next == "f" {
                result += "\u{000C}";
                i += 2;
            } else if next == "\\" {
                result += "\\";
                i += 2;
            } else if next == "'" {
                result += "'";
                i += 2;
            } else if next == "\"" {
                result += "\"";
                i += 2;
            } else if next == "`" {
                result += "`";
                i += 2;
            } else if next == "/" {
                result += "/";
                i += 2;
            } else if next == "u" && i + 6 <= raw.length() {
                string hex = raw.substring(i + 2, i + 6);
                int|error codePoint = int:fromHexString(hex);
                if codePoint is int {
                    string:Char|error ch2 = string:fromCodePointInt(codePoint);
                    if ch2 is string:Char {
                        result += ch2;
                    } else {
                        result += "\\u" + hex;
                    }
                } else {
                    result += "\\u" + hex;
                }
                i += 6;
            } else {
                result += ch;
                i += 1;
            }
        } else {
            result += ch;
            i += 1;
        }
    }
    return result;
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
# + literal - The literal value associated with the token (e.g., numeric value, string content)
# + return - Updated scanner state with the token added
isolated function addTokenWithLiteral(ScannerState state, TokenType tokenType, anydata? literal) returns ScannerState {
    string text = state.sourceCode.substring(state.startIndex, state.current);
    ScannerState newState = state;
    newState.tokens.push(createToken(tokenType, text, literal, newState.startIndex));
    return newState;
}
