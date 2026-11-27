#!/usr/bin/env bash
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

# Runs the official HL7 FHIRPath test suites (R4 and R5 editions) and the worked examples of the FHIRPath STU3
# specification against this package, then reports the conformance of each.
#
# Usage: scripts/conformance/run.sh <work-dir>
# The work directory receives the downloaded suites, inputs and definitions, the converted JSON inputs, the
# extracted cases, the raw results and a summary per source (summary_<source>.txt).

set -euo pipefail

WORK="$(mkdir -p "${1:?usage: run.sh <work-dir>}" && cd "$1" && pwd)"
HERE="$(cd "$(dirname "$0")" && pwd)"
PACKAGE="$(cd "$HERE/../.." && pwd)"
TEST_CASES="https://raw.githubusercontent.com/FHIR/fhir-test-cases/master"

mkdir -p "$WORK/suites" "$WORK/inputs" "$WORK/json" "$WORK/defs/r4" "$WORK/defs/r5"

echo "Downloading test suites and inputs..."
for edition in r4 r5; do
    curl -sSfL -o "$WORK/suites/tests-fhir-$edition.xml" "$TEST_CASES/$edition/fhirpath/tests-fhir-$edition.xml"
done
for file in $(grep -oh 'inputfile="[^"]*"' "$WORK"/suites/*.xml | sed 's/inputfile="//; s/"$//' | sort -u); do
    for edition in r4 r5; do
        curl -sSfL -o "$WORK/inputs/${edition}_$file" "$TEST_CASES/$edition/$file" 2>/dev/null || rm -f "$WORK/inputs/${edition}_$file"
    done
done
curl -sSfL -o "$WORK/spec.html" "https://hl7.org/fhirpath/STU3/en/"

echo "Downloading FHIR definitions..."
for edition in R4 R5; do
    dir="$WORK/defs/$(echo $edition | tr 'R' 'r')"
    [ -f "$dir/profiles-resources.json" ] && continue
    curl -sSfL -o "$dir/definitions.json.zip" "https://hl7.org/fhir/$edition/definitions.json.zip"
    unzip -o -q "$dir/definitions.json.zip" profiles-resources.json profiles-types.json -d "$dir"
done

echo "Converting inputs to JSON..."
for path in "$WORK"/inputs/*; do
    base="$(basename "$path")"; edition="${base%%_*}"; name="${base#*_}"
    case "$name" in
        *.json) cp "$path" "$WORK/json/${edition}_${name}" ;;
        ccda.xml) ;;  # CDA documents are not FHIR resources
        *.xml) python3 -I "$HERE/fhir_xml2json.py" "$WORK/defs/$edition" "$path" > "$WORK/json/${edition}_${name%.xml}.json" ;;
    esac
done

echo "Extracting cases..."
for edition in r4 r5; do
    python3 -I "$HERE/extract_suite.py" "$edition" "$WORK/suites/tests-fhir-$edition.xml" "$WORK/json" "${edition}_" > "$WORK/cases_$edition.json"
done
python3 -I "$HERE/extract_spec_examples.py" "$WORK/spec.html" "$WORK/json/r4_patient-example.json" > "$WORK/cases_spec.json" 2> "$WORK/spec_examples_skipped.txt"

# bal test may rewrite Dependencies.toml for the local distribution, which breaks the next run: restore it each time
cp "$PACKAGE/Dependencies.toml" "$WORK/Dependencies.toml.orig"
for source in r4 r5 spec; do
    echo "Running $source cases..."
    status=0
    (cd "$PACKAGE" && bal test --tests runConformanceCases -CconformanceCases="$WORK/cases_$source.json" \
        -CconformanceResults="$WORK/results_$source.json" > "$WORK/run_$source.log" 2>&1) || status=$?
    cp "$WORK/Dependencies.toml.orig" "$PACKAGE/Dependencies.toml"
    if [ "$status" -ne 0 ]; then
        echo "The $source run failed; see $WORK/run_$source.log" >&2
        exit "$status"
    fi
    python3 -I "$HERE/analyze.py" "$WORK/cases_$source.json" "$WORK/results_$source.json" \
        --json "$WORK/verdicts_$source.json" > "$WORK/summary_$source.txt"
    head -1 "$WORK/summary_$source.txt"
done
echo "Details: $WORK/summary_<source>.txt"
