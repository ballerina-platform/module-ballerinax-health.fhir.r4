#!/usr/bin/env python3
# Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
#
# WSO2 LLC. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

"""Compares conformance runner results with the expected outputs of the official FHIRPath test suite.

Usage: analyze.py <cases.json> <results.json> [--json out.json]
"""
import collections
import json
import re
import sys
from decimal import Decimal, InvalidOperation

TYPE_MATCHES = {
    "boolean": {"System.Boolean", "FHIR.boolean"},
    "integer": {"System.Integer", "FHIR.integer", "FHIR.positiveInt", "FHIR.unsignedInt"},
    "decimal": {"System.Decimal", "FHIR.decimal"},
    "long": {"System.Long", "FHIR.integer64"},
    "string": {"System.String", "FHIR.string", "FHIR.markdown", "FHIR.uri", "FHIR.url", "FHIR.canonical"},
    "code": {"FHIR.code"},
    "id": {"FHIR.id", "FHIR.string"},
    "date": {"System.Date", "FHIR.date"},
    "dateTime": {"System.DateTime", "FHIR.dateTime", "FHIR.instant"},
    "time": {"System.Time", "FHIR.time"},
    "Quantity": {"System.Quantity", "FHIR.Quantity", "FHIR.Age", "FHIR.Duration", "FHIR.SimpleQuantity"},
}
CALENDAR = {"year", "month", "week", "day", "hour", "minute", "second", "millisecond"}


def as_decimal(value):
    try:
        return Decimal(str(value))
    except (InvalidOperation, ValueError):
        return None


def norm_temporal(value):
    s = str(value)
    s = s[1:] if s.startswith("@") else s
    s = s[1:] if s.startswith("T") else s
    return s[:-1] if s.endswith("T") else s


def norm_unit(unit):
    unit = unit.strip("'")
    return unit[:-1] if unit.endswith("s") and unit[:-1] in CALENDAR else unit


def parse_quantity(text):
    m = re.match(r"^\s*([+-]?\d+(?:\.\d+)?)\s*(.*)$", text)
    return (Decimal(m.group(1)), norm_unit(m.group(2) or "'1'")) if m else None


def infer_type(text):
    """Type of an untyped expected output, inferred from its literal form."""
    if text in ("true", "false"):
        return "boolean"
    if re.fullmatch(r"[+-]?\d+(\.\d+)?", text):
        return "decimal"
    if text.startswith("@T"):
        return "time"
    if text.startswith("@"):
        return "dateTime"
    if re.fullmatch(r"[+-]?\d+(\.\d+)?\s*('[^']*'|[a-z]+)", text):
        return "Quantity"
    return "string"


def value_matches(expected, actual):
    t, text = expected["type"] or infer_type(expected["value"]), expected["value"]
    if t == "boolean":
        return isinstance(actual, bool) and str(actual).lower() == text.strip()
    if t in ("integer", "decimal", "long"):
        return not isinstance(actual, bool) and as_decimal(actual) is not None and as_decimal(actual) == as_decimal(text)
    if t in ("date", "dateTime", "time"):
        return isinstance(actual, str) and norm_temporal(actual) == norm_temporal(text)
    if t == "Quantity":
        exp = parse_quantity(text)
        if not isinstance(actual, dict) or exp is None:
            return False
        unit = actual.get("code") or actual.get("unit") or "1"
        return as_decimal(actual.get("value")) == exp[0] and norm_unit(unit) == exp[1]
    return isinstance(actual, str) and actual == text


def compare(case, result):
    """Returns (verdict, detail) where verdict is pass | fail | semantic-gap | type-mismatch."""
    expected = case["outputs"]
    invalid = case["invalid"]
    if invalid:
        if result["status"] == "error":
            return "pass", ""
        if invalid == "semantic":
            return "semantic-gap", f"expected a {invalid} error, got {json.dumps(result.get('result'))}"
        return "fail", f"expected a {invalid} error, got {json.dumps(result.get('result'))}"
    if result["status"] != "ok":
        return "fail", f"unexpected {result['status']}: {result.get('message')}"
    actual = result["result"]
    if case["predicate"]:
        actual = [len(actual) > 0]
    if len(actual) != len(expected):
        return "fail", f"expected {[e['value'] for e in expected]}, got {json.dumps(actual)}"
    if case["ordered"]:
        ok = all(value_matches(e, a) for e, a in zip(expected, actual))
    else:
        remaining = list(actual)
        ok = True
        for e in expected:
            match = next((a for a in remaining if value_matches(e, a)), None)
            if match is None:
                ok = False
                break
            remaining.remove(match)
    if not ok:
        return "fail", f"expected {[(e['type'], e['value']) for e in expected]}, got {json.dumps(actual)}"
    types = result.get("types")
    if not case["predicate"] and types is not None and len(types) == len(expected):
        for e, t in zip(expected, types):
            allowed = TYPE_MATCHES.get(e["type"])
            if allowed is not None and t not in allowed:
                return "type-mismatch", f"expected type {e['type']}, got {t}"
    return "pass", ""


def main(cases_path, results_path, out=None):
    cases = {c["name"]: c for c in json.load(open(cases_path))}
    verdicts = collections.Counter()
    details = []
    for result in json.load(open(results_path)):
        case = cases[result["name"]]
        if result["status"] == "skipped":
            verdicts["skipped"] += 1
            continue
        verdict, detail = compare(case, result)
        verdicts[verdict] += 1
        if verdict != "pass":
            details.append({"verdict": verdict, "group": case["group"], "name": case["name"],
                            "expression": case["expression"], "detail": detail, "mode": case["mode"]})
    total = sum(verdicts.values()) - verdicts["skipped"]
    print(f"{cases_path}: {total} evaluated, {dict(verdicts)}; pass rate {verdicts['pass'] / total:.1%}")
    for d in sorted(details, key=lambda d: (d["verdict"], d["group"], d["name"])):
        print(f"  [{d['verdict']}] {d['group']}/{d['name']}: {d['expression'][:90]}\n      {d['detail'][:220]}")
    if out:
        json.dump({"verdicts": verdicts, "details": details}, open(out, "w"), indent=1)


if __name__ == "__main__":
    args = sys.argv[1:]
    out = args[args.index("--json") + 1] if "--json" in args else None
    main(args[0], args[1], out)
