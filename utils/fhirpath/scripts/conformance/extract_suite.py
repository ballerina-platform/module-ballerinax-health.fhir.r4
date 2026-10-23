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

"""Extracts the official FHIRPath test suite XML into a JSON case list for the Ballerina conformance runner.

Usage: extract_suite.py <suite-label> <tests.xml> <json-inputs-dir> <input-prefix>
"""
import json
import os
import sys
import xml.etree.ElementTree as ET

NS = "{http://hl7.org/fhirpath/tests}"
NOT_APPLICABLE_MODES = {"tx": "terminology service", "html": "htmlChecks()", "cda": "CDA logical model"}


def main(label, path, inputs_dir, prefix):
    root = ET.parse(path).getroot()
    global NS
    NS = root.tag[:root.tag.index("}") + 1] if root.tag.startswith("{") else ""
    cases = []
    for group in root.iter(NS + "group"):
        group_mode = group.get("mode")
        for test in group.findall(NS + "test"):
            expr_el = test.find(NS + "expression")
            # Keep line breaks: they end // comments
            expression = (expr_el.text or "").strip()
            input_file = test.get("inputfile")
            input_json = None
            if input_file:
                candidate = os.path.join(inputs_dir, prefix + os.path.splitext(input_file)[0] + ".json")
                input_json = candidate if os.path.exists(candidate) else None
            mode = test.get("mode") or group_mode
            skip = None
            if mode in NOT_APPLICABLE_MODES:
                skip = "not applicable: " + NOT_APPLICABLE_MODES[mode]
            elif input_file and input_json is None:
                skip = "input not available: " + input_file
            invalid = expr_el.get("invalid") or test.get("invalid")
            context = test.get("context")
            cases.append({
                "suite": label,
                "group": group.get("name"),
                "name": test.get("name"),
                "expression": expression,
                "evaluated": expression,
                # The expression is evaluated with each node selected by `context` as its focus; `contextType`
                # declares the focus type for static (semantic) checks
                "context": context,
                "contextType": test.get("contextType"),
                "input": input_json,
                "mode": mode,
                "invalid": invalid,
                "strict": mode in ("strict", "semantic") or invalid == "semantic",
                "predicate": test.get("predicate") == "true",
                "ordered": test.get("ordered") != "false",
                "outputs": [{"type": o.get("type"), "value": o.text or ""} for o in test.findall(NS + "output")],
                "skip": skip,
            })
    json.dump(cases, sys.stdout, indent=1)


if __name__ == "__main__":
    main(*sys.argv[1:5])
