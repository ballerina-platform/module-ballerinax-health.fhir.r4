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

import ballerina/http;
import ballerina/log;
import ballerina/test;

http:Client testClient = check new ("http://localhost:9876");

@test:Config {}
function runStandardFhirPathTestSuite() returns error? {
    json response = check testClient->get("/fhirpath/run");
    TestReport report = check response.cloneWithType(TestReport);

    log:printInfo("FHIRPath test run complete",
            total = report.total, passed = report.passed,
            failed = report.failed, skipped = report.skipped);

    foreach string failedName in report.failedNames {
        TestResult[] matching = from TestResult r in report.results
            where r.name == failedName
            select r;
        if matching.length() > 0 {
            TestResult r = matching[0];
            log:printError("FAIL: " + failedName,
                    'group = r.group,
                    reason = r.failureReason ?: "unknown",
                    expected = (r.expectedResult ?: []).toJsonString(),
                    actual = (r.actualResult ?: []).toJsonString());
        }
    }

    if report.failed > 0 {
        test:assertFail(msg = report.failed.toString() + " FHIRPath test(s) failed. "
                + "Failed: " + string:'join(", ", ...report.failedNames));
    }
}
