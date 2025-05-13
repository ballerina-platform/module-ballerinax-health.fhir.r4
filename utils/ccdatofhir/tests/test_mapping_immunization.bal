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
function testCcdaDocumentToFhirImmunization() returns error? {
    r4:Bundle|r4:FHIRError transformed = ccdaToFhir(ccdaDocumentValid);
    test:assertTrue(transformed is r4:Bundle, "Error occurred while transforming CCDA document to FHIR!");

    if (transformed is r4:Bundle) {
        json jsonBundle = transformed.toJson();
        json[] entries = <json[]>check jsonBundle.entry;
        json 'resource = check entries[5].'resource;
        test:assertEquals('resource.resourceType, "Immunization", "Incorrect resource type from the conversion!");
        test:assertEquals('resource.status, "completed", "Incorrect status from the conversion!");
        json[] immunizationIdentifier = <json[]>check 'resource.identifier;
        test:assertEquals(immunizationIdentifier.length(), 1, "Incorrect number of identifiers from the conversion!");
        test:assertEquals(check immunizationIdentifier[0].system, "urn:ietf:rfc:3986", "Incorrect identifier system from the conversion!");
        test:assertEquals(check immunizationIdentifier[0].value, "urn:oid:1.2.3.4.5.6", "Incorrect identifier value from the conversion!");
        json[] immunizationVaccineCodeCodings = <json[]>check 'resource.vaccineCode.coding;
        test:assertEquals(immunizationVaccineCodeCodings.length(), 1, "Incorrect number of vaccine code codings from the conversion!");
        test:assertEquals(check immunizationVaccineCodeCodings[0].system, "urn:oid:2.16.840.1.113883.6.59", "Incorrect system from the conversion!");
        test:assertEquals(check immunizationVaccineCodeCodings[0].code, "90710", "Incorrect code from the conversion!");
        test:assertEquals(check immunizationVaccineCodeCodings[0].display, "Hib vaccine", "Incorrect display from the conversion!");
        test:assertEquals('resource.occurrenceDateTime, "2010-08-15", "Incorrect occurrence date time from the conversion!");
        json[] immunizationStatusReasonCodings = <json[]>check 'resource.statusReason.coding;
        test:assertEquals(immunizationStatusReasonCodings.length(), 1, "Incorrect number of status reason codings from the conversion!");
        test:assertEquals(check immunizationStatusReasonCodings[0].code, "MEDPREC", "Incorrect code from the conversion!");
        json[] immunizationNote = <json[]>check 'resource.note;
        test:assertEquals(immunizationNote.length(), 1, "Incorrect number of notes from the conversion!");
        test:assertEquals(check immunizationNote[0].text, "Immunization was administered in the left deltoid.", "Incorrect note text from the conversion!");
    }
}

@test:Config {}
function testCcdaStatusCodeToFhirImmunizationStatus() returns error? {
    xml ccdaStatusCode = xml `<statusCode code="completed" />`;
    uscore501:USCoreImmunizationProfileStatus status = mapCcdaStatusCodeToFhirImmunizationStatus(ccdaStatusCode);
    test:assertEquals(status, "completed", "Status is not equal to completed");

    ccdaStatusCode = xml `<statusCode code="aborted"/>`;
    status = mapCcdaStatusCodeToFhirImmunizationStatus(ccdaStatusCode);
    test:assertEquals(status, "not-done", "Status is not equal to aborted");

    ccdaStatusCode = xml `<statusCode code="cancelled"/>`;
    status = mapCcdaStatusCodeToFhirImmunizationStatus(ccdaStatusCode);
    test:assertEquals(status, "not-done", "Status is not equal to active");

    ccdaStatusCode = xml `<statusCode code="held"/>`;
    status = mapCcdaStatusCodeToFhirImmunizationStatus(ccdaStatusCode);
    test:assertEquals(status, "not-done", "Status is not equal to nullified");

    ccdaStatusCode = xml `<statusCode code="new"/>`;
    status = mapCcdaStatusCodeToFhirImmunizationStatus(ccdaStatusCode);
    test:assertEquals(status, "not-done", "Status is not equal to suspended");

    ccdaStatusCode = xml `<statusCode code="nullified"/>`;
    status = mapCcdaStatusCodeToFhirImmunizationStatus(ccdaStatusCode);
    test:assertEquals(status, "entered-in-error", "Status is not equal to entered-in-error");

    ccdaStatusCode = xml `<statusCode code="obsolete"/>`;
    status = mapCcdaStatusCodeToFhirImmunizationStatus(ccdaStatusCode);
    test:assertEquals(status, "not-done", "Status is not equal to entered-in-error");

    ccdaStatusCode = xml `<statusCode code="suspended"/>`;
    status = mapCcdaStatusCodeToFhirImmunizationStatus(ccdaStatusCode);
    test:assertEquals(status, "not-done", "Status is not equal to entered-in-error");

    ccdaStatusCode = xml `<statusCode code="unknown"/>`;
    status = mapCcdaStatusCodeToFhirImmunizationStatus(ccdaStatusCode);
    test:assertEquals(status, "not-done", "Status is not equal to entered-in-error");
}

@test:Config {}
function testCcdaToFhirImmunizationSite() returns error? {
    xml ccdaValue = xml `<code>368208006</code>`;
    string? site = mapCcdaToFhirImmunizationSite(ccdaValue);
    test:assertEquals(site, "LA", "Site is not equal to LA");

    ccdaValue = xml `<code>368209003</code>`;
    site = mapCcdaToFhirImmunizationSite(ccdaValue);
    test:assertEquals(site, "RA", "Site is not equal to RA");

    ccdaValue = xml `<code>368210008</code>`;
    site = mapCcdaToFhirImmunizationSite(ccdaValue);
    test:assertEquals(site, (), "Site is not equal to null");
}
