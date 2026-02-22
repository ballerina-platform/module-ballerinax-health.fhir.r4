import ballerina/io;

// Global error flag
boolean hadError = false;

public function main(string... args) returns error? {
    if args.length() > 1 {
        io:println("Usage: bal run [script]");
        error err = error("Invalid arguments");
        return err;
    } else if args.length() == 1 {
        check runFile(args[0]);
    } else {
        check runPrompt();
    }
}

function runFile(string path) returns FhirpathScannerError|FhirpathParserError|FhirpathInterpreterError|io:Error? {
    string sourceCode = check io:fileReadString(path);
    FhirpathScannerError|FhirpathParserError|FhirpathInterpreterError? err = run(sourceCode);
    return err;
}

function runPrompt() returns io:Error? {
    while true {
        io:print("> ");
        string line = io:readln();
        if line.trim() == "" {
            continue;
        }
        FhirpathScannerError|FhirpathParserError|FhirpathInterpreterError? err = run(line);
        if err is FhirpathScannerError|FhirpathParserError|FhirpathInterpreterError {
            io:println("Error: ", err.message());
        }
    }
    // run("Patient.name[0]");
}

function run(string sourceCode) returns FhirpathScannerError|FhirpathParserError|FhirpathInterpreterError? {
    // Scan the source code
    FhirpathScannerError|FhirPathToken[] scanResult = scanTokens(sourceCode);
    if scanResult is FhirpathScannerError {
        return scanResult;
    }
    FhirPathToken[] tokens = scanResult;

    // Parse the tokens
    FhirpathParserError|Expr? parseResult = parse(tokens);
    if parseResult is FhirpathParserError {
        return parseResult;
    }
    Expr? expression = parseResult;

    // Example FHIR Patient resource for testing
    json patientResource = {
        "resourceType": "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/Patient"
            ]
        },
        "active": true,
        "name": [
            {
                "use": "official",
                "family": "Chalmers",
                "given": [
                    "Peter",
                    "James"
                ]
            },
            {
                "use": "usual",
                "given": [
                    "Jim"
                ]
            }
        ],
        "gender": "male",
        "birthDate": "1974-12-25",
        "managingOrganization": {
            "reference": "Organization/1",
            "display": "Burgers University Medical Center"
        },
        "address": [
            {
                "use": "home",
                "line": [
                    "534 Erewhon St",
                    "sqw"
                ],
                "city": "PleasantVille",
                "district": "Rainbow",
                "state": "Vic",
                "postalCode": "3999",
                "country": "Australia"
            },
            {
                "use": "work",
                "line": [
                    "33[0] 6th St"
                ],
                "city": "Melbourne",
                "district": "Rainbow",
                "state": "Vic",
                "postalCode": "3000",
                "country": "Australia"
            }
        ]
    };

    // Interpret the expression with the patient resource
    if expression is Expr {
        io:println("Tokens: ", tokens.'map(t => t.tokenType.toString() + "('" + t.lexeme + "')"));
        io:println("AST: " + printAst(expression));

        FhirpathInterpreterError|json[] result = interpret(expression, patientResource);

        if result is FhirpathInterpreterError {
            return result;
        } else {
            io:println("Result: ", result);
        }
    }
    return ();
}

public function reportError(int line, string message) {
    reportErrorAt(line, "", message);
}

function reportErrorAt(int line, string location, string message) {
    io:println(string `[line ${line}] Error${location}: ${message}`);
}
