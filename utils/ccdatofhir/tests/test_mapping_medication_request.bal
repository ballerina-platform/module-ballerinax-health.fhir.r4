// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

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

import ballerina/test;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

@test:Config {}
function testCcdaDocumentToFhirMedicationRequest() returns error? {
    r4:Bundle|r4:FHIRError transformed = ccdaToFhir(ccdaDocumentValid);
    test:assertTrue(transformed is r4:Bundle, "Error occurred while transforming CCDA document to FHIR!");

    if (transformed is r4:Bundle) {
        json jsonBundle = transformed.toJson();
        json[] entries = <json[]>check jsonBundle.entry;
        json 'resource = check entries[4].'resource;
        test:assertEquals('resource.resourceType, "MedicationRequest", "Incorrect resource type from the conversion!");
    }
}

@test:Config {}
function testCcdaValueToFhirMedicationRequestStatus() returns error? {
    xml ccdaStatusCode = xml `<statusCode code="completed" />`;
    uscore501:USCoreMedicationRequestProfileStatus status = mapCcdatoFhirMedicationRequestStatus(ccdaStatusCode);
    test:assertEquals(status, "completed", "Status is not equal to completed");

    ccdaStatusCode = xml `<statusCode code="aborted"/>`;
    status = mapCcdatoFhirMedicationRequestStatus(ccdaStatusCode);
    test:assertEquals(status, "stopped", "Status is not equal to aborted");

    ccdaStatusCode = xml `<statusCode code="active"/>`;
    status = mapCcdatoFhirMedicationRequestStatus(ccdaStatusCode);
    test:assertEquals(status, "active", "Status is not equal to active");

    ccdaStatusCode = xml `<statusCode code="nullified"/>`;
    status = mapCcdatoFhirMedicationRequestStatus(ccdaStatusCode);
    test:assertEquals(status, "entered-in-error", "Status is not equal to nullified");

    ccdaStatusCode = xml `<statusCode code="suspended"/>`;
    status = mapCcdatoFhirMedicationRequestStatus(ccdaStatusCode);
    test:assertEquals(status, "on-hold", "Status is not equal to suspended");

    ccdaStatusCode = xml `<statusCode code="unknown"/>`;
    status = mapCcdatoFhirMedicationRequestStatus(ccdaStatusCode);
    test:assertEquals(status, "entered-in-error", "Status is not equal to entered-in-error");
}

@test:Config {}
function testCcdaValueToFhirStatusReason() returns error? {
    xml ccdaValue = xml `<code value="MEDPREC" system="https://medical.gov.uk/12342" displayName="Medicine Prescribed"/>`;
    r4:CodeableConcept? statusReason = mapCcdaRefusalReasonToFhirStatusReason(ccdaValue);
    r4:Coding[]? coding = statusReason?.coding;
    if coding is r4:Coding[] {
        test:assertEquals(coding[0]?.code, "MEDPREC", "Status reason is not equal to MEDPREC");
    }

    ccdaValue = xml `<code value="PATOBJ"/>`;
    statusReason = mapCcdaRefusalReasonToFhirStatusReason(ccdaValue);
    coding = statusReason?.coding;
    if coding is r4:Coding[] {
        test:assertEquals(coding[0]?.code, "PATOBJ", "Status reason is not equal to PATOBJ");
    }

    ccdaValue = xml `<code value="IMMUNE"/>`;
    statusReason = mapCcdaRefusalReasonToFhirStatusReason(ccdaValue);
    coding = statusReason?.coding;
    if coding is r4:Coding[] {
        test:assertEquals(coding[0]?.code, "IMMUNE", "Status reason is not equal to IMMUNE");
    }

    ccdaValue = xml `<code value="OSTOCK"/>`;
    statusReason = mapCcdaRefusalReasonToFhirStatusReason(ccdaValue);
    coding = statusReason?.coding;
    if coding is r4:Coding[] {
        test:assertEquals(coding[0]?.code, "OSTOCK", "Status reason is not equal to OSTOCK");
    }

    ccdaValue = xml `<code value="PHILISOP"/>`;
    statusReason = mapCcdaRefusalReasonToFhirStatusReason(ccdaValue);
    coding = statusReason?.coding;
    if coding is r4:Coding[] {
        test:assertEquals(coding[0]?.code, (), "Status reason is not equal to PHILISOP");
    }
}
