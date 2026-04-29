## Overview

FHIRPath utility package for querying and modifying FHIR R4 resources using FHIRPath expressions in Ballerina. It supports extraction, updates, additions, removals, and expression validation.

> **Trademark Notice:** FHIR® and the FHIR® logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7®.

### Key Features

- Evaluate FHIRPath expressions to extract values from resources
- Update, add, and remove elements using path-based operations
- Function-based value transformation support during updates
- Validation support for FHIRPath expressions and resource structures

# FHIR R4 Utils - FHIRPath Package

This package provides utilities for working with FHIR resources using FHIRPath expressions. It allows you to query, update, and manipulate FHIR resources in a type-safe manner using Ballerina.

## Package Overview

This package implements FHIRPath, a powerful expression language for querying and manipulating FHIR resources. It supports the FHIR R4 version and provides a set of functions to extract [FHIRPath expression](https://hl7.org/fhir/fhirpath.html) values, update resource values, and handle errors effectively.

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://hl7.org/fhir/fhirpath.html |

Refer to the [API Documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath) for detailed usage.

## Features

- **Query FHIR Resources**: Extract one or more values for a matching FHIRPath expression from FHIR resources
- **Update FHIR Resources**: Set values in FHIR resources at specified paths
- **Remove FHIR Resource Elements**: Remove elements from FHIR resources
- **Function-based Value Modification**: Apply custom functions to transform values during updates (useful for data masking, hashing, etc.)
- **Unified API**: Single function handles both direct value setting and function-based transformations
- **Validate FHIR Resources**: Ensure that FHIR resources provided and returned conform to the expected structure and types. (For more info visit https://central.ballerina.io/ballerinax/health.fhir.r4.validator/latest)
- **Error Handling**: Comprehensive error reporting for invalid paths or operations
- **Type Safety**: Strong typing support for Ballerina applications


## Architecture & How It Works

This library implements a classic interpreter pipeline to evaluate FHIRPath expressions against FHIR JSON resources. The processing flows through three stages:

```
FHIRPath string → Scanner → Tokens → Parser → AST → Interpreter → Result
```

### Pipeline Stages

1. **Scanning / Lexical Analysis** ([scanner.bal](scanner.bal), [token.bal](token.bal), [token_type.bal](token_type.bal))
   The scanner (lexer) takes a raw FHIRPath expression string and breaks it into a sequence of tokens. Each token has a type and the corresponding lexeme text. Beyond basic identifiers, numbers, and strings, the scanner recognises: date/datetime/time literals (`@YYYY-MM-DD`, `@YYYY-MM-DDTHH:MM:SS`, `@THH:MM:SS`), delimited identifiers (backtick-quoted), the `%` prefix for external constants, the special invocations `$this`/`$index`/`$total`, all comparison and arithmetic operators, and skips line (`//`) and block (`/* */`) comments.

2. **Parsing** ([parser.bal](parser.bal), [expr.bal](expr.bal))
   A hand-written **recursive-descent (top-down) parser** consumes the token stream and builds an Abstract Syntax Tree (AST). The AST node types are defined in [expr.bal](expr.bal) and include `BinaryExpr`, `LiteralExpr`, `IdentifierExpr`, `FunctionExpr`, `MemberAccessExpr`, `IndexerExpr`, `UnaryExpr`, `ExternalConstantExpr`, and `QuantityLiteralExpr`. The parser functions in [parser.bal](parser.bal) directly correspond to the grammar rules and are organized by operator precedence (lowest → highest binding): `implies → or/xor → and → in/contains → =/~/!=/!~ → </>/<=/>= → | → is/as → +/-/& → */div/mod → unary +/- → postfix ./[] → primary`.

3. **Interpretation** ([interpreter.bal](interpreter.bal))
   A tree-walking interpreter traverses the AST and evaluates it against the provided FHIR JSON resource. It supports both **getting** values (collecting matching nodes) and **setting/removing** values (producing a modified copy of the resource). The interpreter handles:
   - **Member access** (`.`), **array indexing** (`[n]`), **unary polarity** (`+`/`-`)
   - **All binary operators**: `=`, `~`, `!=`, `!~`, `<`, `>`, `<=`, `>=`, `+`, `-`, `&` (string concat), `*`, `/`, `div`, `mod`, `and`, `or`, `xor`, `implies`, `in`, `contains`, `|` (union), `is`, `as`
   - **External constants** (`%name`) resolved from the `variables` map passed at call time
   - **Built-in functions**: `where`, `select`, `repeat`, `all`, `aggregate`, `exists`, `empty`, `not`, `hasValue`, `first`, `last`, `tail`, `skip`, `take`, `count`, `distinct`, `children`, `descendants`, `combine`, `union`, `intersect`, `exclude`, `subsetOf`, `supersetOf`, `ofType`, `iif`, `extension`, `resolve`, `memberOf`, `startsWith`, `endsWith`, `indexOf`, `substring`, `matches`, `encode`, `decode`, `upper`, `lower`, `trim`, `toInteger`, `toDecimal`, `toString`, `toDate`, `toDateTime`, `toTime`, `toQuantity`, `convertsToInteger`, `convertsToDecimal`

4. **Public API** ([fhir_path_processor.bal](fhir_path_processor.bal))
   The top-level functions `getValuesFromFhirPath` and `setValuesToFhirPath` orchestrate the full pipeline — scan, parse, interpret — and optionally validate the FHIR resource before and/or after the operation.

### Grammar Reference

The file [grammar.g4](grammar.g4) contains the **ANTLR grammar extracted from the official FHIRPath specification** ([HL7 FHIRPath Grammar](https://build.fhir.org/ig/HL7/FHIRPath/grammar.html/)). It serves as the authoritative reference for the subset of FHIRPath syntax that this library supports. The ANTLR grammar (which is a bottom-up / left-recursive notation) has been manually converted into the **top-down recursive-descent parser** implemented in [parser.bal](parser.bal).

### Updating & Extending the Library

If additional FHIRPath features need to be supported in the future, follow these steps:

1. **Update the grammar** — Add or modify the relevant production rules in [grammar.g4](grammar.g4) to reflect the new syntax from the official FHIRPath specification.
2. **Add token types** — If new operators or keywords are needed, add entries to the `TokenType` enum in [token_type.bal](token_type.bal) and update the scanner in [scanner.bal](scanner.bal) to recognize them.
3. **Add AST node types** — If the new syntax requires a new kind of expression, define a new record type in [expr.bal](expr.bal) and add it to the `Expr` union type.
4. **Extend the parser** — Add new parse functions or update existing ones in [parser.bal](parser.bal) to match the updated grammar rules. Ensure operator precedence is handled correctly in the recursive-descent structure.
5. **Update the interpreter** — Implement evaluation logic for the new AST nodes in [interpreter.bal](interpreter.bal), for both get and set operations.
6. **Add tests** — Write test cases in the [tests/](tests/) directory covering the new functionality.

## Usage Examples

### Basic FHIRPath Value Extraction

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

json patient = {
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
    }
};

public function main() {
    // Get single value using FHIRPath
    json[]|fhirpath:FHIRPathError result = fhirpath:getValuesFromFhirPath(patient, "Patient.name[0].given[0]");
    if result is json[] {
        io:println("First given name: ", result);
    }
    // Use where() to filter and extract values
    json[]|fhirpath:FHIRPathError officialFamily = fhirpath:getValuesFromFhirPath(patient, "Patient.name.where(use = 'official').family");
    if officialFamily is json[] {
        io:println("Official family name: ", officialFamily);
    }
    // Handle non-existent paths (returns empty array)
    json[]|fhirpath:FHIRPathError emptyResult = fhirpath:getValuesFromFhirPath(patient, "Patient.nonExistentPath");
    if emptyResult is json[] {
        io:println("Result for non-existent path: ", emptyResult);
    }
    // Handle errors (e.g., malformed expression)
    json[]|fhirpath:FHIRPathError errorResult = fhirpath:getValuesFromFhirPath(patient, "Patient.name[");
    if errorResult is fhirpath:FHIRPathError {
        io:println("Error: ", errorResult.message());
    }

    // Complex expression: extract all given names from names that have a family name starting with 'C'
    json patient2 = {
        "resourceType": "Patient",
        "id": "2",
        "name": [
            {"use": "official", "family": "Chalmers", "given": ["Peter", "James"]},
            {"use": "nickname", "family": "Smith", "given": ["Pete"]},
            {"use": "maiden", "family": "Clarke", "given": ["Mary"]}
        ],
        "telecom": [
            {"system": "phone", "value": "+1-555-867-5309", "use": "home"},
            {"system": "email", "value": "peter@example.com"},
            {"system": "phone", "value": "+1-555-000-0001", "use": "work"}
        ]
    };

    // Extract all home phone numbers using chained where() filters
    json[]|fhirpath:FHIRPathError homePhones = fhirpath:getValuesFromFhirPath(patient2,
        "Patient.telecom.where(system = 'phone').where(use = 'home').value");
    if homePhones is json[] {
        io:println("Home phone numbers: ", homePhones);
    }

    // Extract given names from all official or maiden name entries
    json[]|fhirpath:FHIRPathError givenNames = fhirpath:getValuesFromFhirPath(patient2,
        "Patient.name.where(use = 'official' or use = 'maiden').given");
    if givenNames is json[] {
        io:println("Given names (official or maiden): ", givenNames);
    }
}
```

### Using Variables in FHIRPath Expressions

Variables let you pass dynamic values into a FHIRPath expression at runtime using the `%variableName` syntax. This avoids string interpolation and keeps expressions reusable.

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "name": [
            {"use": "official", "family": "Chalmers", "given": ["Peter", "James"]},
            {"use": "usual",    "family": "Fenders",  "given": ["Jim"]}
        ],
        "telecom": [
            {"system": "phone", "value": "+1-555-867-5309", "use": "home"},
            {"system": "email", "value": "peter@example.com"},
            {"system": "phone", "value": "+1-555-000-0001", "use": "work"}
        ]
    };

    // Use a variable to parameterise the name use filter
    json[]|fhirpath:FHIRPathError officialFamily = fhirpath:getValuesFromFhirPath(
        patient,
        "name.where(use = %name_use).family",
        variables = {"name_use": "official"}
    );
    if officialFamily is json[] {
        io:println("Official family name: ", officialFamily); // ["Chalmers"]
    }

    // Reuse the same expression with a different variable value
    json[]|fhirpath:FHIRPathError usualFamily = fhirpath:getValuesFromFhirPath(
        patient,
        "name.where(use = %name_use).family",
        variables = {"name_use": "usual"}
    );
    if usualFamily is json[] {
        io:println("Usual family name: ", usualFamily); // ["Fenders"]
    }

    // Variables work with any scalar-comparable field
    json[]|fhirpath:FHIRPathError contactValue = fhirpath:getValuesFromFhirPath(
        patient,
        "telecom.where(system = %contact_system).value",
        variables = {"contact_system": "email"}
    );
    if contactValue is json[] {
        io:println("Email address: ", contactValue); // ["peter@example.com"]
    }
}
```

### Updating FHIR Resources

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "active": true,
        "address": [
            {
                "use": "home",
                "line": ["123 Main St"],
                "city": "Anytown",
                "state": "CA",
                "postalCode": "12345"
            },
            {
                "use": "work",
                "line": ["456 Work St"],
                "city": "Worktown",
                "state": "CA",
                "postalCode": "67890"
            }
        ]
    };

    // Update a value in the FHIR resource
    json|fhirpath:FHIRPathError updateResult = fhirpath:setValuesToFhirPath(patient, "Patient.active", false);
    if updateResult is json {
        io:println("Updated patient after active status change: ", updateResult);
    }

    // Update multiple values in the FHIR resource
    json|fhirpath:FHIRPathError updatedAddresses = fhirpath:setValuesToFhirPath(patient, "Patient.address.line", "***", validateInputFHIRResource = false);
    if updatedAddresses is json {
        io:println("Updated patient after address line masking: ", updatedAddresses);
    }

    // Update a nested value in the FHIR resource
    json|fhirpath:FHIRPathError updatedCity = fhirpath:setValuesToFhirPath(patient, "Patient.address[0].city", "NewTown", validateInputFHIRResource = false);
    if updatedCity is json {
        io:println("Updated patient after city change: ", updatedCity);
    }
}

```

### Removing FHIR Resource Fields

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "active": true,
        "gender": "male",
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
                "family": "Fenders",
                "given": [
                    "Jim"
                ]
            }
        ]
    };

    // Remove a simple field
    json|fhirpath:FHIRPathError result = fhirpath:setValuesToFhirPath(patient, "Patient.gender", ());
    if result is json {
        io:println("Patient after removing gender: ", result);
    }

    // Remove multiple elements
    json|fhirpath:FHIRPathError multipleResult = fhirpath:setValuesToFhirPath(patient, "Patient.name.given", ());
    if multipleResult is json {
        io:println("Patient after removing all given names: ", multipleResult);
    }
}
```

### Function-based Value Modifications

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

// Define a custom modification function for data masking
isolated function maskOperation(json input) returns json|error {
    return "***MASKED***";
}

// Define a function to hash sensitive data
isolated function hashOperation(json input) returns json|error {
    if input is string {
        return "HASH_" + input.length().toString(); // Simple hash for example
    }
    return error("Expected string input for hashing", value = input.toString());
}

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "name": [
            {
                "use": "official",
                "family": "Doe",
                "given": ["John", "Michael"]
            }
        ],
        "telecom": [
            {
                "system": "phone",
                "value": "+1-555-123-4567"
            },
            {
                "system": "email",
                "value": "john.doe@example.com"
            }
        ]
    };

    // Mask all phone numbers
    json|fhirpath:FHIRPathError maskedPhone = fhirpath:setValuesToFhirPath(patient, "Patient.telecom[0].value", maskOperation);
    if maskedPhone is json {
        io:println("Patient with masked phone: ", maskedPhone);
    }

    // Hash id
    json|fhirpath:FHIRPathError hashedId = fhirpath:setValuesToFhirPath(patient, "Patient.id", hashOperation);
    if hashedId is json {
        io:println("Patient with hashed id: ", hashedId);
    }
}
```

## Supported Functions

### Existence & Boolean

| | | | | |
|---|---|---|---|---|
| `empty` | `exists` | `not` | `hasValue` | `all` |
| `isDistinct` | `subsetOf` | `supersetOf` | | |

### Filtering & Projection

| | | | | |
|---|---|---|---|---|
| `where` | `select` | `repeat` | `ofType` | |

### Collection

| | | | | |
|---|---|---|---|---|
| `first` | `last` | `tail` | `skip` | `take` |
| `single` | `count` | `distinct` | `combine` | `union` |
| `intersect` | `exclude` | `children` | `descendants` | `aggregate` |
| `sort` | `sum` | | | |

### String

| | | | | |
|---|---|---|---|---|
| `length` | `trim` | `toChars` | `split` | `join` |
| `upper` | `lower` | `startsWith` | `endsWith` | `contains` |
| `indexOf` | `substring` | `replace` | `matches` | `matchesFull` |
| `replaceMatches` | `encode` | `decode` | `escape` | `unescape` |

### Math

| | | | | |
|---|---|---|---|---|
| `abs` | `ceiling` | `floor` | `truncate` | `round` |
| `sqrt` | `power` | `exp` | `ln` | `log` |

### Type & Conversion

| | | | | |
|---|---|---|---|---|
| `type` | `is` | `as` | `toInteger` |
| `toDecimal` | `toString` | `toBoolean` | `toDate` | `toDateTime` |
| `toTime` | `toQuantity` | `convertsToInteger` | `convertsToDecimal` | `convertsToString` |
| `convertsToBoolean` | `convertsToDate` | `convertsToDateTime` | `convertsToTime` | `convertsToQuantity` |

### Date & Time

| | | | | |
|---|---|---|---|---|
| `today` | `now` | `precision` |

