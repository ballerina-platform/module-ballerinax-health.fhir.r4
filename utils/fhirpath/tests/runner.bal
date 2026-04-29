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

function getResource(string key) returns json|error {
    match key {
        "empty"            => { return getEmptyResource(); }
        "patient"          => { return getPatientResource(); }
        "observation"      => { return getObservationResource(); }
        "ccda"             => { return getCcdaResource(); }
        "appointment"      => { return getAppointmentResource(); }
        "codesystem"       => { return getCodesystemResource(); }
        "conceptmap"       => { return getConceptmapResource(); }
        "diagnosticreport" => { return getDiagnosticreportResource(); }
        "eob"              => { return getEobResource(); }
        "parameters"       => { return getParametersResource(); }
        "patient_container" => { return getPatientContainerResource(); }
        "patient_name"     => { return getPatientNameResource(); }
        "patient_period"   => { return getPatientPeriodResource(); }
        "patient_name_ext" => { return getPatientNameExtResource(); }
        "questionnaire"    => { return getQuestionnaireResource(); }
        "valueset"         => { return getValuesetResource(); }
        _                  => { return error("Unknown resource key: " + key); }
    }
}

function getAllTestCases() returns FHIRPathTestCase[] {
    FHIRPathTestCase[] all = [];
    foreach FHIRPathTestCase tc in getBasicsTestCases()      { all.push(tc); }
    foreach FHIRPathTestCase tc in getLiteralsTestCases()    { all.push(tc); }
    foreach FHIRPathTestCase tc in getEqualityTestCases()    { all.push(tc); }
    foreach FHIRPathTestCase tc in getEquivalentTestCases()  { all.push(tc); }
    foreach FHIRPathTestCase tc in getComparisonsTestCases() { all.push(tc); }
    foreach FHIRPathTestCase tc in getArithmeticTestCases()  { all.push(tc); }
    foreach FHIRPathTestCase tc in getMathTestCases()        { all.push(tc); }
    foreach FHIRPathTestCase tc in getStringsTestCases()     { all.push(tc); }
    foreach FHIRPathTestCase tc in getCollectionsTestCases() { all.push(tc); }
    foreach FHIRPathTestCase tc in getTypesTestCases()       { all.push(tc); }
    foreach FHIRPathTestCase tc in getLogicTestCases()       { all.push(tc); }
    foreach FHIRPathTestCase tc in getNavigationTestCases()  { all.push(tc); }
    foreach FHIRPathTestCase tc in getDatetimeTestCases()    { all.push(tc); }
    foreach FHIRPathTestCase tc in getBoundaryTestCases()    { all.push(tc); }
    foreach FHIRPathTestCase tc in getExtensionsTestCases()  { all.push(tc); }
    foreach FHIRPathTestCase tc in getVariablesTestCases()   { all.push(tc); }
    foreach FHIRPathTestCase tc in getDollarTestCases()      { all.push(tc); }
    foreach FHIRPathTestCase tc in getSpecialTestCases()     { all.push(tc); }
    foreach FHIRPathTestCase tc in getMiscTestCases()        { all.push(tc); }
    return all;
}

// TODO: Set skipDisabledTests = false in Config.toml once all disabled tests are fully implemented
configurable boolean skipDisabledTests = false;

function runCases(FHIRPathTestCase[] cases) returns TestReport {
    TestResult[] results = [];
    int passed = 0;
    int failed = 0;
    int skipped = 0;

    foreach FHIRPathTestCase tc in cases {
        if tc.disabled && skipDisabledTests {
            skipped += 1;
            continue;
        }
        json|error resourceResult = getResource(tc.resourceKey);
        if resourceResult is error {
            results.push({
                name: tc.name,
                group: tc.group,
                status: "fail",
                failureReason: "Resource lookup failed: " + resourceResult.message(),
                actualResult: (),
                expectedResult: ()
            });
            failed += 1;
            continue;
        }

        json[]|FHIRPathError evalResult = getValuesFromFhirPath(resourceResult, tc.expression, false);

        TestResult tr;
        if tc.expectError {
            if evalResult is FHIRPathError {
                tr = {name: tc.name, group: tc.group, status: "pass",
                      failureReason: (), actualResult: (), expectedResult: ()};
                passed += 1;
            } else {
                tr = {name: tc.name, group: tc.group, status: "fail",
                      failureReason: "Expected FHIRPathError but got result: " + evalResult.toJsonString(),
                      actualResult: evalResult, expectedResult: ()};
                failed += 1;
            }
        } else {
            if evalResult is FHIRPathError {
                tr = {name: tc.name, group: tc.group, status: "fail",
                      failureReason: "Unexpected FHIRPathError: " + evalResult.message(),
                      actualResult: (), expectedResult: tc.expected};
                failed += 1;
            } else if evalResult == tc.expected {
                tr = {name: tc.name, group: tc.group, status: "pass",
                      failureReason: (), actualResult: (), expectedResult: ()};
                passed += 1;
            } else {
                tr = {name: tc.name, group: tc.group, status: "fail",
                      failureReason: "Mismatch: expected " + tc.expected.toJsonString()
                          + " but got " + evalResult.toJsonString(),
                      actualResult: evalResult, expectedResult: tc.expected};
                failed += 1;
            }
        }
        results.push(tr);
    }

    string[] failedNames = from TestResult r in results where r.status == "fail" select r.name;
    return {total: cases.length(), passed, failed, skipped, failedNames, results};
}
