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

// TokenType enum
enum TokenType {
    // Single-character tokens
    LEFT_PAREN,    // (
    RIGHT_PAREN,   // )
    LEFT_BRACKET,  // [
    RIGHT_BRACKET, // ]
    LEFT_BRACE,    // {
    RIGHT_BRACE,   // }
    DOT,           // .
    COMMA,         // ,

    // Arithmetic / string operators
    PLUS,          // +
    MINUS,         // -
    STAR,          // *
    SLASH,         // /
    AMPERSAND,     // &
    PIPE,          // |
    TILDE,         // ~
    PERCENT,       // %

    // Comparison operators (one or two chars)
    EQUAL,         // =
    BANG_EQUAL,    // !=
    BANG_TILDE,    // !~
    LESS_THAN,     // <
    GREATER_THAN,  // >
    LESS_EQUAL,    // <=
    GREATER_EQUAL, // >=

    // Literals
    IDENTIFIER,
    DELIMITED_IDENTIFIER, // `identifier`
    STRING,
    NUMBER,
    LONGNUMBER,    // [0-9]+'L'
    DATE,          // @YYYY(-MM(-DD)?)?
    DATETIME,      // @YYYY-MM-DDTHH:...
    TIME,          // @THH:...

    // Keywords — boolean logic
    OR,
    XOR,
    AND,
    IMPLIES,

    // Keywords — boolean literals
    TRUE,
    FALSE,

    // Keywords — type / membership
    IS,
    AS,
    IN,
    CONTAINS,

    // Keywords — arithmetic
    DIV,
    MOD,

    // Keywords — sort direction
    ASC,
    DESC,

    // Special invocation tokens
    DOLLAR_THIS,   // $this
    DOLLAR_INDEX,  // $index
    DOLLAR_TOTAL,  // $total

    EOF
}
