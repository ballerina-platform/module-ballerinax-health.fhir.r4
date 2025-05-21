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
function testCcdaDocumentToFhirPatient() returns error? {
    r4:Bundle|r4:FHIRError transformed = ccdaToFhir(ccdaDocumentValid);
    test:assertTrue(transformed is r4:Bundle, "Error occurred while transforming CCDA document to FHIR!");

    if (transformed is r4:Bundle) {
        json jsonBundle = transformed.toJson();
        test:assertEquals(jsonBundle.resourceType, "Bundle", "Transformed resource type is not equal to Bundle!");
        
        json[] entries = <json[]>check jsonBundle.entry;
        test:assertEquals(entries.length(), 9, "Incorrect number of bundle entries from the conversion!");
        json 'resource = check entries[0].'resource;
        test:assertEquals(check entries[0].'resource.resourceType, "Patient", "Incorrect resource type from the conversion!");

        json[] addresses = <json[]>check 'resource.address;
        test:assertEquals(addresses.length(), 2, "Incorrect number of addresses from the conversion!");
        test:assertEquals(check addresses[0].use, "home", "Incorrect home from the conversion!");
        test:assertEquals(check addresses[1].use, "work", "Incorrect home from the conversion!");

        json[] addressesLines = <json[]>check addresses[0].line;
        test:assertEquals(addressesLines.length(), 2, "Incorrect number of address lines from the conversion!");
        test:assertEquals(addressesLines[0], "1357 Amber Drive", "Incorrect address line from the conversion!");
        test:assertEquals(addressesLines[1], "Amber Ave", "Incorrect address line from the conversion!");

        json[] names = <json[]>check entries[0].'resource.name;
        test:assertEquals(names.length(), 2, "Incorrect number of names from the conversion!");
        test:assertEquals(check names[0].use, "official", "Incorrect name use from the conversion!");
        test:assertEquals(check names[1].use, "nickname", "Incorrect name use from the conversion!");

        json[] nameOneGiven = <json[]>check names[0].given;
        test:assertEquals(nameOneGiven.length(), 2, "Incorrect number of given names from the conversion!");
        test:assertEquals(nameOneGiven[0], "John", "Incorrect given name from the conversion!");
        test:assertEquals(nameOneGiven[1], "Shane", "Incorrect given name from the conversion!");
        json[] nameOnePrefix = <json[]>check names[0].prefix;
        test:assertEquals(nameOnePrefix.length(), 1, "Incorrect number of prefixes from the conversion!");
        test:assertEquals(nameOnePrefix[0], "Mr", "Incorrect prefix from the conversion!");
        json[] nameOneSuffix = <json[]>check names[0].suffix;
        test:assertEquals(nameOneSuffix.length(), 1, "Incorrect number of suffixes from the conversion!");
        test:assertEquals(nameOneSuffix[0], "PhD", "Incorrect suffix from the conversion!");
        json[] nameTwoGiven = <json[]>check names[1].given;
        test:assertEquals(nameTwoGiven.length(), 1, "Incorrect number of given names from the conversion!");
        test:assertEquals(nameTwoGiven[0], "Leonardo", "Incorrect given name from the conversion!");
        test:assertEquals('resource.birthDate, "1947-05-01", "Incorrect birth date from the conversion!");
        json[] maritalStatusCoding = <json[]>check 'resource.maritalStatus.coding;
        test:assertEquals(maritalStatusCoding.length(), 1, "Incorrect number of marital status codings from the conversion!");
        test:assertEquals(check maritalStatusCoding[0].code, "D", "Incorrect marital status code from the conversion!");
        test:assertEquals(check maritalStatusCoding[0].display, "Divorced", "Incorrect marital status display from the conversion!");
        test:assertEquals(check maritalStatusCoding[0].system, "urn:oid:2.16.840.1.113883.4.642.3.29", "Incorrect marital status system from the conversion!");
        test:assertEquals(check entries[0].'resource.maritalStatus.text, "Divorced 2 years ago", "Incorrect marital status text from the conversion!");
        json[] extensions = <json[]>check 'resource.extension;
        test:assertEquals(extensions.length(), 2, "Incorrect number of extensions from the conversion!");
        test:assertEquals(extensions[0].url, "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race", "Incorrect extension url from the conversion!");
        test:assertEquals(extensions[1].url, "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity", "Incorrect extension url from the conversion!");
        test:assertEquals(entries[0].'resource.managingOrganization.reference, "Organization/3", "Incorrect managing organization reference from the conversion!");
        test:assertEquals(entries[0].'resource.managingOrganization.display, "Primary Care's Partners Test", "Incorrect managing organization display from the conversion!");
    }
}

@test:Config {}
function testMapCcdaTelecomToFhirPatientTelecom() returns error? {
    xml telecomElement = xml `<telecom use="HP" value="tel:1234567890"/>`;
    uscore501:USCorePatientProfileTelecom? telecom = mapCcdaTelecomToFhirPatientTelecom(telecomElement);
    test:assertEquals(telecom?.system, "phone", "Telecom system is not equal to phone");
    test:assertEquals(telecom?.value, "1234567890", "Telecom value is not equal to 1234567890");
    test:assertEquals(telecom?.use, "home", "Telecom use is not equal to home");

    telecomElement = xml `<telecom use="WP" value="mailto:1234567890"/>`;
    telecom = mapCcdaTelecomToFhirPatientTelecom(telecomElement);
    test:assertEquals(telecom?.system, "email", "Telecom? system is not equal to phone");
    test:assertEquals(telecom?.value, "1234567890", "Telecom? value is not equal to 1234567890");
    test:assertEquals(telecom?.use, "work", "Telecom? use is not equal to work");

    telecomElement = xml `<telecom use="MC" value="fax:1234567890"/>`;
    telecom = mapCcdaTelecomToFhirPatientTelecom(telecomElement);
    test:assertEquals(telecom?.system, "fax", "Telecom system is not equal to phone");
    test:assertEquals(telecom?.value, "1234567890", "Telecom value is not equal to 1234567890");
    test:assertEquals(telecom?.use, "mobile", "Telecom use is not equal to mobile");

    telecomElement = xml `<telecom use="OP" value="http:1234567890"/>`;
    telecom = mapCcdaTelecomToFhirPatientTelecom(telecomElement);
    test:assertEquals(telecom?.system, "url", "Telecom system is not equal to phone");
    test:assertEquals(telecom?.value, "1234567890", "Telecom value is not equal to 1234567890");
    test:assertEquals(telecom?.use, "old", "Telecom use is not equal to old");

    telecomElement = xml `<telecom use="TP" value="x-text-fax:1234567890"/>`;
    telecom = mapCcdaTelecomToFhirPatientTelecom(telecomElement);
    test:assertEquals(telecom?.system, "sms", "Telecom system is not equal to phone");
    test:assertEquals(telecom?.value, "1234567890", "Telecom value is not equal to 1234567890");
    test:assertEquals(telecom?.use, "temp", "Telecom use is not equal to temp");

    telecomElement = xml `<telecom use="TP" value="1234567890"/>`;
    telecom = mapCcdaTelecomToFhirPatientTelecom(telecomElement);
    test:assertEquals(telecom?.system, "other", "Telecom system is not equal to phone");
    test:assertEquals(telecom?.value, "1234567890", "Telecom value is not equal to 1234567890");
    test:assertEquals(telecom?.use, "temp", "Telecom use is not equal to temp");

    telecomElement = xml `<telecom use="TP" value="wefw:1234567890"/>`;
    telecom = mapCcdaTelecomToFhirPatientTelecom(telecomElement);
    test:assertEquals(telecom?.system, "other", "Telecom system is not equal to phone");
    test:assertEquals(telecom?.value, "1234567890", "Telecom value is not equal to 1234567890");
    test:assertEquals(telecom?.use, "temp", "Telecom use is not equal to temp");
}
