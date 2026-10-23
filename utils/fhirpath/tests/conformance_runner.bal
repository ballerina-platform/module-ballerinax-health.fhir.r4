// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/test;

// Conformance runner for the official HL7 FHIRPath test suites (see scripts/conformance/README.md).
// It only runs when a case file is given:
//   bal test --tests runConformanceCases -CconformanceCases=<cases.json> -CconformanceResults=<results.json>
configurable string conformanceCases = "";
configurable string conformanceResults = "";

@test:Config {}
function runConformanceCases() returns error? {
    if conformanceCases == "" {
        return;
    }
    json[] cases = <json[]>check io:fileReadJson(conformanceCases);
    map<json> inputs = {};
    json[] results = [];
    foreach json entry in cases {
        map<json> tc = <map<json>>entry;
        if tc["skip"] !is () {
            results.push({name: tc["name"], suite: tc["suite"], status: "skipped"});
            continue;
        }
        json inputResource = ();
        json inputPath = tc["input"];
        if inputPath is string {
            if !inputs.hasKey(inputPath) {
                inputs[inputPath] = check io:fileReadJson(inputPath);
            }
            inputResource = inputs.get(inputPath);
        }
        string expression = <string>tc["evaluated"];
        boolean strict = <boolean>tc["strict"];
        json[]|error result = trap getValuesFromFhirPath(inputResource.clone(), expression, false, strictMode = strict);
        if result is FHIRPathError {
            results.push({name: tc["name"], suite: tc["suite"], status: "error", message: result.message()});
            continue;
        }
        if result is error {
            // A panic is an engine defect, never an expected outcome
            results.push({name: tc["name"], suite: tc["suite"], status: "panic", message: result.message()});
            continue;
        }
        // Result types, for checking against the expected output types
        json[]|error types = trap getValuesFromFhirPath(inputResource.clone(),
            string `(${expression}).select($this.type().namespace + '.' + $this.type().name)`, false);
        results.push({name: tc["name"], suite: tc["suite"], status: "ok", result, types: types is json[] ? types : ()});
    }
    check io:fileWriteJson(conformanceResults, results);
}
