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
`mode="strict"` evaluate in strict mode, `context` sets the focus (and `contextType` its declared type for the static
checks), `predicate` compares existence and
`ordered="false"` ignores order. Terminology (`mode="tx"`), `htmlChecks()` (`mode="html"`) and CDA (`mode="cda"`)
cases are reported as not applicable.

## Verdicts

- **pass** — the result matches the expected output (value and type)
- **fail** — the result differs, or an unexpected error occurred
- **semantic-gap** — the case expects a static (semantic) type-check error that strict mode does not detect
- **type-mismatch** — the value matches but the result type differs from the expected output type
- **skipped** — not applicable (see above)

## Known non-passes

The package targets FHIR R4: **the R4 suite passes in full** (1027/1027). Where the R4 suite and the STU3 text
differ, the R4 suite's expectation is implemented. Results at the time of writing (2026-10): r4 1027/1027,
r5 1169/1175, spec examples 416/429. No case causes an engine panic.

**R5 suite (all specific to the R5 edition):**
- `testPlusDate19`: the R5 edition adds 100 ms for `+ 0.1 's'`; the R4 edition (implemented) applies UCUM time
  quantities in whole units and leaves the value unchanged.
- `testDistinct29`, `testDistinct36`: the R5 edition expects empty for `@2020` vs `@2020-01-01`; the `distinct()` /
  `isDistinct()` text says an empty equality result means the items are distinct (these cases are not in the R4
  edition).
- `HighBoundaryDateMonth`, `LowBoundaryDateMonth` (type only): the suite labels the result of a Date boundary
  `dateTime`; the text says the result has the input's type (Date).
- `testMultipleResolve` (`mode="element"`): `resolve()` across resources is not implemented.
- Not applicable: terminology services (`mode="tx"`), `htmlChecks()` (`mode="html"`) and CDA (`mode="cda"`).

**Spec examples:** placeholders (`A`, `B`, `q`), illustrative values (`today()`, `timeOfDay()`), an Observation
example evaluated on a Patient, the typo `5 'm',convertsToQuantity('kg')`, `'in_i'` (not a UCUM code; `[in_i]`
works), `1 minute - 30 's'` (documented as `0.5 minute`; the result `30 seconds` is equal), and the boundary examples
`@2014-01-01T08.lowBoundary(17)` / `.highBoundary(17)` (written without the timezone and with `08:59:59.999`; the test
suites, and this implementation, give `08:00:00.000+14:00` / `08:00:59.999-12:00`).

## Keeping the tests in sync

The verified cases are also part of the regular test suite: `tests/tc_official_r5_additions.bal` (official cases not
covered by the other `tc_*.bal` files), `tests/tc_semantic_checks.bal` (the static type checks) and
`tests/tc_spec_examples.bal` (the specification examples), so
`bal test` guards them without network access. After a new suite version is published, run the script and add any
new cases that pass verification in the same way.
