// Token record
public type FhirPathToken record {|
    TokenType tokenType;
    string lexeme;
    anydata? literal;
    int position;
    int line;
|};

// Create a new token
public function createToken(TokenType tokenType, string lexeme, anydata? literal, int position, int line = 1) returns FhirPathToken {
    return {
        tokenType: tokenType,
        lexeme: lexeme,
        literal: literal,
        position: position,
        line: line
    };
}

// Convert token to string
public function tokenToString(FhirPathToken token) returns string {
    return string `${token.tokenType} ${token.lexeme} ${token.literal.toString()}`;
}
