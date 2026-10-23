# FHIRPath conformance

These scripts measure the package against three independent sources:

| Source | Cases | What it is |
|--------|-------|------------|
| `r5` | 1185 | The official FHIRPath test suite ([fhir-test-cases `r5/fhirpath/tests-fhir-r5.xml`](https://github.com/FHIR/fhir-test-cases/blob/master/r5/fhirpath/tests-fhir-r5.xml)), the source of truth maintained with the specification |
| `r4` | 1027 | The R4 edition of the same suite (`r4/fhirpath/tests-fhir-r4.xml`), evaluated on the R4 inputs |
| `spec` | ~430 | Worked examples (`expression // result`) extracted from the [FHIRPath STU3 specification](https://hl7.org/fhirpath/STU3/en/) text |

## Running

```bash
scripts/conformance/run.sh /tmp/fhirpath-conformance
```

The script downloads the suites, their input resources and the FHIR R4/R5 StructureDefinitions, converts the XML
inputs to JSON (`fhir_xml2json.py`, using the definitions for types and cardinality), extracts the cases
(`extract_suite.py`, `extract_spec_examples.py`), evaluates them with the inert-by-default `runConformanceCases`
test in [tests/conformance_runner.bal](../../tests/conformance_runner.bal), and compares the results with the expected
outputs (`analyze.py`). Values are compared semantically (FHIR and System date/time forms, decimals by value,
quantities by value and unit) and result types are checked against the expected output types.

The suite conventions are honoured: `invalid="syntax|execution"` expects an error, `invalid="semantic"` and
`mode="strict"` evaluate in strict mode, `context` sets the focus, `predicate` compares existence and
`ordered="false"` ignores order. Terminology (`mode="tx"`), `htmlChecks()` (`mode="html"`) and CDA (`mode="cda"`)
cases are reported as not applicable.

## Verdicts

- **pass** — the result matches the expected output (value and type)
- **fail** — the result differs, or an unexpected error occurred
- **semantic-gap** — the case expects a static (semantic) type-check error, which strict mode does not detect
  (strict mode checks navigation against the model, not type narrowing through `is` guards)
- **type-mismatch** — the value matches but the result type differs from the expected output type
- **skipped** — not applicable (see above)

## Known non-passes

Results at the time of writing (2026-10): r5 1148/1175 (97.7%), r4 1004/1027 (97.8%), spec examples 416/429.
No case causes an engine panic. Every remaining non-pass falls into one of these categories:

**Specification text and test suite disagree** — the implementation follows the STU3 text:
- `testEquivalent29`, `testEquivalent30`, `testQuantityNoUnitVsUnitEquivalent`, `testQuantityUnitVsNoUnitEquivalent`:
  the suite expects `false` for `~` on quantities that cannot be compared; the Quantity Equivalence text says the
  result is empty.
- `testDistinct29`, `testDistinct36`: the suite expects empty for `@2020` vs `@2020-01-01`; the `distinct()` /
  `isDistinct()` text says an empty equality result means the items are distinct.
- `testSort10`: the suite expects an empty key first under `desc`; the `sort()` text says empty is lower than all
  values (so it sorts last when descending).
- `HighBoundaryDateMonth`, `LowBoundaryDateMonth` (type only): the suite labels the result of a Date boundary
  `dateTime`; the text says the result has the input's type (Date).
- Spec examples `@2014-01-01T08.lowBoundary(17)` / `.highBoundary(17)`: the examples omit the timezone and give
  `08:59:59.999`; the suite (and this implementation) give `08:00:00.000+14:00` / `08:00:59.999-12:00`.

**Not implemented by design**: static type narrowing in strict mode (`isSemanticChecks`, `testIif6`), `resolve()`
across resources (`testMultipleResolve`), terminology services, `htmlChecks()`, CDA.

**Platform limitation**: `testToString4` (`0.0.toString() = '0.0'`) — Ballerina decimals do not keep the scale of
zero, so `0.0` is held as `0`.

**Outdated R4 copy**: `testPlusDate19` (r4 only) expects `+ 0.1 's'` to leave a DateTime unchanged; the R5 suite
(which passes) expects the 100 ms to be added.

**Spec example artifacts**: examples using placeholders (`A`, `B`, `q`), illustrative values (`today()`,
`timeOfDay()`), Observation examples evaluated on a Patient, the typo `5 'm',convertsToQuantity('kg')`, `'in_i'`
(not a UCUM code; `[in_i]` works), and `1 minute - 30 's'` (documented as `0.5 minute`; the result `30 seconds` is
equal, following the addition rule of converting to the most granular unit).

## Keeping the tests in sync

The verified cases are also part of the regular test suite: `tests/tc_official_r5_additions.bal` (official cases not
covered by the other `tc_*.bal` files) and `tests/tc_spec_examples.bal` (the specification examples), so
`bal test` guards them without network access. After a new suite version is published, run the script and add any
new cases that pass verification in the same way.
