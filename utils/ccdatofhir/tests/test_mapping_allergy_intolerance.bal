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
function testCcdaDocumentToFhirAllergyIntolerance() returns error? {
    r4:Bundle|r4:FHIRError transformed = ccdaToFhir(ccdaDocumentValid);
    test:assertTrue(transformed is r4:Bundle, "Error occurred while transforming CCDA document to FHIR!");

    if (transformed is r4:Bundle) {
        json jsonBundle = transformed.toJson();
        
        json[] entries = <json[]>check jsonBundle.entry;
        json 'resource = check entries[2].'resource;
        test:assertEquals(entries[2].'resource.resourceType, "AllergyIntolerance", "Incorrect resource type from the conversion!");
        json[] clinicalStatusCoding = <json[]>check 'resource.clinicalStatus.coding;
        test:assertEquals(clinicalStatusCoding[0].code, "active", "Incorrect clinical status from the conversion!");
        test:assertEquals(clinicalStatusCoding[0].system, "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical", "Incorrect clinical status system from the conversion!");
        json[] AllergyIntoleranceIdentifier = <json[]>check 'resource.identifier;
        test:assertEquals(AllergyIntoleranceIdentifier.length(), 1, "Incorrect number of identifiers from the conversion!");
        test:assertEquals(check AllergyIntoleranceIdentifier[0].system, "urn:ietf:rfc:3986", "Incorrect identifier system from the conversion!");
        test:assertEquals(check AllergyIntoleranceIdentifier[0].value, "urn:oid:36e3e930-7b14-11db-9fe1-0800200c9a66", "Incorrect identifier value from the conversion!");
        test:assertEquals(entries[2].'resource.onsetDateTime, "2023-05-31T22:05-05:00", "Incorrect onsetDateTime from the conversion!");
        json[] allergyIntoleranceCodeCodings = <json[]>check 'resource.code.coding;
        test:assertEquals(allergyIntoleranceCodeCodings.length(), 1, "Incorrect number of codes from the conversion!");
        test:assertEquals(check allergyIntoleranceCodeCodings[0].system, "http://snomed.info/sct", "Incorrect system from the conversion!");
        test:assertEquals(check allergyIntoleranceCodeCodings[0].code, "429625007", "Incorrect code from the conversion!");
        test:assertEquals(check allergyIntoleranceCodeCodings[0].display, "Substance", "Incorrect display from the conversion!");
        test:assertEquals(entries[2].'resource.recordedDate, "2014-10-03T10:30-05:00", "Incorrect recorded date from the conversion!");
    } else {
        test:assertFail(msg = "Error occurred while transforming CCDA document to FHIR!");
    }
}

@test:Config {}
function testCcdaValueToFhirAllergyIntoleranceCategory() returns error? {
    xml ccdaValue = xml `<value code="235719002"/>`;
    uscore501:USCoreAllergyIntoleranceCategory? category = mapCcdaValueToFhirAllergyIntoleranceCategory(ccdaValue);
    test:assertEquals(category, "food", "Category is not equal to medication");

    ccdaValue = xml `<value code="416098002"/>`;
    category = mapCcdaValueToFhirAllergyIntoleranceCategory(ccdaValue);
    test:assertEquals(category, "medication", "Category is not equal to medication");

    ccdaValue = xml `<value code="414285001"/>`;
    category = mapCcdaValueToFhirAllergyIntoleranceCategory(ccdaValue);
    test:assertEquals(category, "food", "Category is not equal to medication");

    ccdaValue = xml `<value code="418471000"/>`;
    category = mapCcdaValueToFhirAllergyIntoleranceCategory(ccdaValue);
    test:assertEquals(category, "food", "Category is not equal to medication");

    ccdaValue = xml `<value code="419511003"/>`;
    category = mapCcdaValueToFhirAllergyIntoleranceCategory(ccdaValue);
    test:assertEquals(category, "medication", "Category is not equal to medication");

    ccdaValue = xml `<value code="59037007"/>`;
    category = mapCcdaValueToFhirAllergyIntoleranceCategory(ccdaValue);
    test:assertEquals(category, "medication", "Category is not equal to medication");

    ccdaValue = xml `<value code="43534435"/>`;
    category = mapCcdaValueToFhirAllergyIntoleranceCategory(ccdaValue);
    test:assertEquals(category, (), "Category is not equal to medication");
}

@test:Config {}
function testCcdaValueToFhirAllergyIntoleranceType() returns error? {
    xml ccdaValue = xml `<value code="235719002"/>`;
    uscore501:USCoreAllergyIntoleranceType? 'type = mapCcdaValueToFhirAllergyIntoleranceType(ccdaValue);
    test:assertEquals('type, "intolerance", "Type is not equal to intolerance");

    ccdaValue = xml `<value code="416098002"/>`;
    'type = mapCcdaValueToFhirAllergyIntoleranceType(ccdaValue);
    test:assertEquals('type, "allergy", "Type is not equal to allergy");

    ccdaValue = xml `<value code="414285001"/>`;
    'type = mapCcdaValueToFhirAllergyIntoleranceType(ccdaValue);
    test:assertEquals('type, "allergy", "Type is not equal to intolerance");

    ccdaValue = xml `<value code="419199007"/>`;
    'type = mapCcdaValueToFhirAllergyIntoleranceType(ccdaValue);
    test:assertEquals('type, "allergy", "Type is not equal to allergy");

    ccdaValue = xml `<value code="59037007"/>`;
    'type = mapCcdaValueToFhirAllergyIntoleranceType(ccdaValue);
    test:assertEquals('type, "intolerance", "Type is not equal to intolerance");
}
