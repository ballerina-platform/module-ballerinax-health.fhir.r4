expression
        : term                                                      #termExpression
        | expression '.' invocation                                 #invocationExpression
	| expression '[' expression ']'                             #indexerExpression
        | expression ('=' | '!=' ) expression           #equalityExpression
        | expression 'and' expression                               #andExpression
        | expression ('or' | 'xor') expression                      #orExpression
        ;

term
        : invocation                                            #invocationTerm
        | literal                                               #literalTerm
        ;

literal
        : ('true' | 'false')                                    #booleanLiteral
        | STRING                                                #stringLiteral
        | NUMBER                                                #numberLiteral
        ;

invocation                          // Terms that can be used after the function/member invocation '.'
        : identifier                                            #memberInvocation
        | function                                              #functionInvocation
        ;

function
        : identifier '(' paramList? ')'
        ;

paramList
        : expression (',' expression)*
        ;

identifier
        : IDENTIFIER
	| DELIMITEDIDENTIFIER
        ;

IDENTIFIER
        : ([A-Za-z] | '_')([A-Za-z0-9] | '_')*            // Added _ to support CQL (FHIR could constrain it out)
        ;

STRING
: '\'' (ESC | .)*? '\''
;

// Also allows leading zeroes now (just like CQL and XSD)
NUMBER
: [0-9]+('.' [0-9]+)?
;

DELIMITEDIDENTIFIER
        : '`' (ESC | .)*? '`'
        ;
