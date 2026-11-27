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

"""Extracts worked examples (`expression // result`) from the FHIRPath specification HTML into runner cases.

Usage: extract_spec_examples.py <spec.html> <patient.json>
Only examples whose result can be read unambiguously are kept; the others are listed on stderr.
"""
import html
import json
import re
import sys

CALENDAR = r"(?:years?|months?|weeks?|days?|hours?|minutes?|seconds?|milliseconds?)"
VALUE = (r"(?:true|false|'(?:[^'\\]|\\.)*'|@[0-9T][0-9T:.+\-Z]*|[+-]?\d+(?:\.\d+)?L?"
         r"(?:\s*'[^']*'|\s+" + CALENDAR + r")?)")


def parse_result(text):
    """Returns the list of expected output literals, or None when the result is not machine-readable."""
    t = text.strip()
    t = re.sub(r"^(returns|is|gives|evaluates to|result is|=>|→)\s+", "", t, flags=re.I)
    t = re.split(r"\s+;|\s+\(|;\s", t, maxsplit=1)[0].strip().rstrip(".,")
    if re.fullmatch(r"(\{\s*\}|empty(\s*\(\s*\{\s*\}\s*\))?)", t, re.I) or re.match(r"\{\s*\}\s+empty", t, re.I):
        return []
    # Prose forms: "true as ...", "2 characters", "14:34:28" (a time)
    m = re.match(r"^(true|false)\b", t)
    if m:
        return [m.group(1)]
    m = re.match(r"^(\d+) characters?\b", t)
    if m:
        return [m.group(1)]
    if re.fullmatch(r"\d{2}:\d{2}(:\d{2}(\.\d+)?)?", t):
        return ["@T" + t]
    items = [i.strip() for i in t.split(",")] if "," in t else [t]
    if all(re.fullmatch(VALUE, i) for i in items):
        return items
    return None


def literal_output(item):
    if item.startswith("'"):
        return {"type": "string", "value": item[1:-1].replace("\\'", "'")}
    if item.endswith("L") and re.fullmatch(r"[+-]?\d+L", item):
        return {"type": "long", "value": item[:-1]}
    return {"type": None, "value": item}


def main(spec_path, patient_path):
    page = open(spec_path, encoding="utf-8").read()
    cases, skipped, seen = [], [], set()
    for block in re.findall(r"<pre[^>]*>(.*?)</pre>", page, re.S):
        text = html.unescape(re.sub(r"<[^>]+>", "", block))
        for line in text.split("\n"):
            if "//" not in line or line.strip().startswith("//"):
                continue
            expr, _, comment = line.partition("//")
            expr = expr.strip()
            if not expr or expr in seen or expr.endswith((",", "(", "{")):
                continue
            expected = parse_result(comment)
            if expected is None:
                skipped.append(line.strip())
                continue
            seen.add(expr)
            cases.append({
                "suite": "spec", "group": "specExamples", "name": f"spec{len(cases) + 1}",
                "expression": expr, "evaluated": expr, "input": patient_path, "mode": None,
                "invalid": None, "strict": False, "predicate": False, "ordered": True,
                "outputs": [literal_output(i) for i in expected], "skip": None,
            })
    json.dump(cases, sys.stdout, indent=1)
    print(f"{len(cases)} examples extracted, {len(skipped)} with non-literal results skipped", file=sys.stderr)
    for s in skipped:
        print("  skipped:", s[:140], file=sys.stderr)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
