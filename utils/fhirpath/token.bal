// Copyright (c) 2023 - 2025, WSO2 LLC. (http://www.wso2.com).

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
// TOKEN TYPES FOR FHIRPATH LEXER
// ========================================
// This module defines the token structure and utilities for FHIRPath lexical analysis.
// Tokens represent the smallest meaningful units produced by the scanner.

// ========================================
// TOKEN STRUCTURE
// ========================================

#
# + tokenType - The type/category of the token (e.g., IDENTIFIER, NUMBER, STRING)
# + lexeme - The actual text from the source code that forms this token
# + literal - The interpreted value for literals (e.g., numeric value, string content), null for non-literals
# + position - The position in the source code where this token starts (zero-based index)
public type FhirPathToken record {|
    TokenType tokenType;
    string lexeme;
    anydata? literal;
    int position;
|};

// ========================================
// TOKEN UTILITIES
// ========================================

# Creates a new FHIRPath token.
#
# + tokenType - The type/category of the token
# + lexeme - The source text for this token
# + literal - The interpreted literal value (for NUMBER, STRING tokens), or null
# + position - The zero-based position in source code where the token starts
# + return - A new FhirPathToken instance
isolated function createToken(TokenType tokenType, string lexeme, anydata? literal, int position) returns FhirPathToken {
    return {
        tokenType: tokenType,
        lexeme: lexeme,
        literal: literal,
        position: position
    };
}

# Converts a token to a human-readable string representation.
#
# + token - The token to convert
# + return - A string representation showing token type, lexeme, and literal value
isolated function tokenToString(FhirPathToken token) returns string {
    return string `${token.tokenType} ${token.lexeme} ${token.literal.toString()}`;
}
