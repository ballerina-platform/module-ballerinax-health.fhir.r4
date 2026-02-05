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

function runFile(string path) returns error? {
    string sourceCode = check io:fileReadString(path);
    run(sourceCode);

    // Indicate an error in the exit code
    if hadError {
        error err = error("Compilation error");
        return err;
    }
}

function runPrompt() returns error? {
    while true {
        io:print("> ");
        string line = io:readln();
        if line.trim() == "" {
            continue;
        }
        run(line);
        hadError = false;
    }
}

function run(string sourceCode) {
    // Scan the source code
    FhirPathToken[] tokens = scanTokens(sourceCode);

    // Parse the tokens
    Expr? expression = parse(tokens);

    // Stop if there was a syntax error
    if hadError {
        return;
    }

    // Print the AST (for now, interpreter to be implemented later)
    if expression is Expr {
        io:println(printAst(expression));
    }
}

public function reportError(int line, string message) {
    reportErrorAt(line, "", message);
}

function reportErrorAt(int line, string location, string message) {
    io:println(string `[line ${line}] Error${location}: ${message}`);
    hadError = true;
}
