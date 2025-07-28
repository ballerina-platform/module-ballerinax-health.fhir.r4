// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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
import ballerinax/health.fhir.r4;

http:Client fhirClientIps = check new ("http://localhost:9050");

@test:BeforeGroups {value: ["IPSGeneration"]}
function startIpsSGenService() returns error? {
    // remove the patient service from the registry if it exists
    _ = r4:fhirRegistry.removeFHIRService("Patient");

    // Create a new FHIR listener for the Patient resource type
    Listener ipsGenFhirListener = check new (9050, ipsGenerationPatientApiConfig);
    check ipsGenFhirListener.attach(ipsPatientService);
    check ipsGenFhirListener.'start();

    // Create a new FHIR listener for the Organization resource type
    Listener ipsOrganizationListener = check new (9051, ipsGenerationOrganizationApiConfig);
    check ipsOrganizationListener.attach(ipsOrganizationService);
    check ipsOrganizationListener.'start();

    // Create a new FHIR listener for the Condition resource type
    Listener ipsConditionListener = check new (9052, ipsGenerationConditionApiConfig);
    check ipsConditionListener.attach(ipsConditionService);
    check ipsConditionListener.'start();

    // Create a new FHIR listener for the Medication resource type
    Listener ipsMedicationListener = check new (9053, ipsGenerationMedicationApiConfig);
    check ipsMedicationListener.attach(ipsMedicationService);
    check ipsMedicationListener.'start();

    // Create a new FHIR listener for the MedicationStatement resource type
    Listener ipsMedicationStatementListener = check new (9054, ipsGenerationMedicationStatementApiConfig);
    check ipsMedicationStatementListener.attach(ipsMedicationStatementService);
    check ipsMedicationStatementListener.'start();

    // Create a new FHIR listener for the AllergyIntolerance resource type
    Listener ipsAllergyIntoleranceListener = check new (9055, ipsGenerationAllergicApiConfig);
    check ipsAllergyIntoleranceListener.attach(ipsAllergyIntoleranceService);
    check ipsAllergyIntoleranceListener.'start();
}

@test:Config {groups: ["IPSGeneration"]}
function testIpsGeneration() returns error? {
    http:Response|error response = check fhirClientIps->post("/Patient/102/$summary", ());
    test:assertTrue(response is http:Response);
    if response is http:Response {
        json responseJson = check response.getJsonPayload();
        
        r4:Bundle ipsBundle = check responseJson.cloneWithType();
        r4:Bundle expectedIpsBundle = check expectedIpsJson.cloneWithType();

        r4:BundleEntry[] bundleEntries = ipsBundle.entry is r4:BundleEntry[] ? <r4:BundleEntry[]>ipsBundle.entry : [];
        r4:BundleEntry[] expectedEntries = expectedIpsBundle.entry is r4:BundleEntry[] ? <r4:BundleEntry[]>expectedIpsBundle.entry : [];

        test:assertEquals(bundleEntries.length(), expectedEntries.length(), msg = "Bundle should have the same number of entries");
    } else {
        log:printError("IPS Generation test failed: response is not an http:Response");
    }
}

@test:AfterGroups {value: ["IPSGeneration"]}
function stopIpsGenService() returns error? {
    // check ipsGenFhirListener.gracefulStop();
    log:printInfo("FHIR test service has stopped");
}

