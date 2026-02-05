// TokenType enum
public enum TokenType {
    // Single-character tokens
    LEFT_PAREN, // (
    RIGHT_PAREN, // )
    LEFT_BRACKET, // [
    RIGHT_BRACKET, // ]
    DOT, // .
    COMMA, // ,

    // One or two character tokens
    EQUAL, // =
    BANG_EQUAL, // !=

    // Literals
    IDENTIFIER,
    DELIMITED_IDENTIFIER, // `identifier`
    STRING,
    NUMBER,

    // Keywords
    OR,
    XOR,
    AND,
    TRUE,
    FALSE,
    NIL,

    EOF
}
