# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Build the package
bal build

# Run all tests
bal test

# Run tests with skipDisabledTests=false to include incomplete tests
bal test -- -CskipDisabledTests=false

# Run a specific test group (via the HTTP service endpoint during test run)
# Groups: testBasics, testLiterals, testEquality, testEquivalent, testComparisons,
#         testArithmetic, testMath, testStrings, testCollections, testTypes,
#         testLogic, testNavigation, testDatetime, testBoundary, testExtensions,
#         testVariables, testDollar, testSpecial, testMisc

# Run the package locally
bal run
```

## Architecture

This is a Ballerina package (`ballerinax/health.fhir.r4utils.fhirpath`) implementing FHIRPath expression evaluation for FHIR R4 resources. It is a self-contained interpreter pipeline:

```
FHIRPath string → Scanner → Tokens → Parser → AST → Interpreter → Result
```

### Pipeline files

| File | Role |
|------|------|
| `scanner.bal` | Lexer: breaks expression strings into `FhirPathToken[]` |
| `token.bal`, `token_type.bal` | Token record and `TokenType` enum |
| `parser.bal` | Recursive-descent parser → produces `Expr` AST |
| `expr.bal` | AST node types: `BinaryExpr`, `LiteralExpr`, `IdentifierExpr`, `FunctionExpr`, `MemberAccessExpr`, `IndexerExpr`, `UnaryExpr`, `ExternalConstantExpr`, `QuantityLiteralExpr` |
| `interpreter.bal` | Tree-walking evaluator for both `get` and `set/remove` operations |
| `fhir_path_processor.bal` | Public API: `getValuesFromFhirPath` and `setValuesToFhirPath` |
| `functions_*.bal` | Built-in function implementations split by category (collection, string, math, datetime, type, FHIR-specific) |
| `grammar.g4` | ANTLR grammar from the HL7 FHIRPath spec — the authoritative reference for parser structure. ANTLR uses left-recursive rules; `parser.bal` manually converts these into top-down recursive-descent functions. |

### Public API (`fhir_path_processor.bal`)

- `getValuesFromFhirPath(fhirResource, expression, validateInput?, variables?)` → `json[]|FHIRPathError`
- `setValuesToFhirPath(fhirResource, expression, value|ModificationFunction, validateInput?, validateOutput?)` → `json|FHIRPathError`
  - Pass `()` as value to **remove** the element at the path
  - Pass an `isolated function(json) returns json|error` to transform the value

### Test architecture

Tests use a data-driven pattern driven by an HTTP service in `tests/test_service.bal` (port 9876):

- `tests/types.bal` — shared record types: `FHIRPathTestCase`, `TestResult`, `TestReport`
- `tests/runner.bal` — `runCases()` and `getAllTestCases()` aggregating all test groups
- `tests/tc_*.bal` — test case data files per category (basics, strings, math, datetime, etc.)
- `tests/*_resource.bal` — fixture FHIR JSON resources indexed by string key via `getResource()`
- `tests/service_test.bal` — single Ballerina `@test:Config` that calls the HTTP service and fails if any cases fail
- `tests/Config.toml` — sets `skipDisabledTests = true` (disabled tests are cases not yet fully implemented)

To add a new test: add a `FHIRPathTestCase` entry to the relevant `tests/tc_*.bal` file and register any new fixture resource in `tests/runner.bal:getResource()`.

### Extending the library

To support new FHIRPath features, follow this order:
1. Update `grammar.g4` to reflect the new grammar rule
2. Add token types to `token_type.bal` and scanner recognition to `scanner.bal`
3. Add AST node type(s) to `expr.bal` and the `Expr` union
4. Add parse function(s) to `parser.bal` maintaining correct precedence order
5. Implement evaluation in `interpreter.bal` for both get and set paths
6. Add test cases in the appropriate `tests/tc_*.bal` file

### Parser precedence (lowest → highest binding)

`implies → or/xor → and → in/contains → =/~/!=/!~ → </>/<=/>= → | → is/as → +/-/& → */div/mod → unary +/- → postfix ./[] → primary`
