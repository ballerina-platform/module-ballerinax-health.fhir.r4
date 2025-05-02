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

import ballerina/io;
import ballerina/test;
import ballerinax/health.fhir.r4.uscore501;
import ballerinax/health.fhir.r4;

xml ccdaDocumentValid = xml ``;
xml? cdaDocumentInvalid = ();

@test:BeforeSuite
function beforeSuiteFunc() returns error? {
    ccdaDocumentValid = check io:fileReadXml("tests/test_valid_ccda_document.xml");
}

@test:Config {}
function testCcdaToIdToFhirIdenitifier() returns error? {
    xml ccdaId = xml `<id root="2.16.840.1.113883.4.500" extension="1234567890V123456"/>`;
    uscore501:USCorePatientProfileIdentifier? identifier = mapCcdaIdToFhirIdentifier(ccdaId);
    test:assertTrue(identifier is uscore501:USCorePatientProfileIdentifier, "Identifier is not of type USCorePatientProfileIdentifier");
    test:assertEquals(identifier?.system, "urn:oid:2.16.840.1.113883.4.500", "Identifier system is not equal to urn:oid:2.16.840.1.113883.4.500");
    test:assertEquals(identifier?.value, "1234567890V123456", "Identifier value is not equal to 1234567890V123456");

    ccdaId = xml `<id root="2.16.840.1.113883.4.500.123456789"/>`;
    identifier = mapCcdaIdToFhirIdentifier(ccdaId);
    test:assertTrue(identifier is uscore501:USCorePatientProfileIdentifier, "Identifier is not of type USCorePatientProfileIdentifier");
    test:assertEquals(identifier?.system, "urn:ietf:rfc:3986", "Identifier system is not equal to urn:ietf:rfc:3986");
    test:assertEquals(identifier?.value, "urn:oid:2.16.840.1.113883.4.500.123456789", "Identifier value is not equal to urn:oid:2.16.840.1.113883.4.500.123456789");

    ccdaId = xml `<id root="2.16.840.1.113883.4.1" extension="1234567890V123456"/>`;
    identifier = mapCcdaIdToFhirIdentifier(ccdaId);
    test:assertTrue(identifier is uscore501:USCorePatientProfileIdentifier, "Identifier is not of type USCorePatientProfileIdentifier");
    test:assertEquals(identifier?.system, "http://hl7.org/fhir/sid/us-ssn", "Identifier system is not equal to http://hl7.org/fhir/sid/us-ssn");
    test:assertEquals(identifier?.value, "1234567890V123456", "Identifier value is not equal to 1234567890V123456");

    ccdaId = xml `<id root="2.16.840.1.113883.4.336" extension="1234567890V123456"/>`;
    identifier = mapCcdaIdToFhirIdentifier(ccdaId);
    test:assertTrue(identifier is uscore501:USCorePatientProfileIdentifier, "Identifier is not of type USCorePatientProfileIdentifier");
    test:assertEquals(identifier?.system, "http://terminology.hl7.org/NamingSystem/CMSCertificationNumber", "Identifier system is not equal to http://terminology.hl7.org/NamingSystem/CMSCertificationNumber");
    test:assertEquals(identifier?.value, "1234567890V123456", "Identifier value is not equal to 1234567890V123456");

    ccdaId = xml `<id root="2.16.840.1.113883.4.6" extension="1234567890V123456"/>`;
    identifier = mapCcdaIdToFhirIdentifier(ccdaId);
    test:assertTrue(identifier is uscore501:USCorePatientProfileIdentifier, "Identifier is not of type USCorePatientProfileIdentifier");
    test:assertEquals(identifier?.system, "http://hl7.org/fhir/sid/us-npi", "Identifier system is not equal to http://hl7.org/fhir/sid/us-npi");
    test:assertEquals(identifier?.value, "1234567890V123456", "Identifier value is not equal to 1234567890V123456");

    ccdaId = xml `<id root="2.16.840.1.113883.4.572" extension="1234567890V123456"/>`;
    identifier = mapCcdaIdToFhirIdentifier(ccdaId);
    test:assertTrue(identifier is uscore501:USCorePatientProfileIdentifier, "Identifier is not of type USCorePatientProfileIdentifier");
    test:assertEquals(identifier?.system, "http://hl7.org/fhir/sid/us-medicare", "Identifier system is not equal to http://hl7.org/fhir/sid/us-medicare");
    test:assertEquals(identifier?.value, "1234567890V123456", "Identifier value is not equal to 1234567890V123456");
}

@test:Config {}
function testCcdaToAddressToFhirAddress() returns error? {
    xml ccdaAddress = xml 
        `<addr use="H">
            <streetAddressLine>1357 Amber Drive</streetAddressLine>        
            <streetAddressLine>Amber Ave</streetAddressLine>
            <city>Beaverton</city>
            <state>OR</state>
            <postalCode>97006</postalCode>
            <useablePeriod>
                <low value="20100101"/>
                <high value="20201231"/>
            </useablePeriod>
        </addr>
        <addr use="HP"><city>Allerton</city></addr>
        <addr use="HV"><city>Allerton</city></addr>
        <addr use="OLD"><city>Allerton</city></addr>
        <addr use="TMP"><city>Allerton</city></addr>
        <addr use="WP"><city>Allerton</city></addr>
        <addr use="DIR"><city>Allerton</city></addr>
        <addr use="PUB"><city>Allerton</city></addr>
        <addr use="BAD"><city>Allerton</city></addr>`;

    r4:Address[]? addresses = mapCcdaAddressToFhirAddress(ccdaAddress);
    test:assertTrue(addresses is r4:Address[], "Identifier is not of type r4:Address[]");
    if addresses is r4:Address[] {
        test:assertEquals(addresses[0]?.city, "Beaverton", "Address city is not equal to Beaverton");
        test:assertEquals(addresses[0]?.state, "OR", "Address state is not equal to OR");
        test:assertEquals(addresses[0]?.postalCode, "97006", "Address postalCode is not equal to 97006");
        test:assertEquals(addresses[0]?.use, "home", "Address use is not equal to home");
        string[]? lines = addresses[0]?.line;
        if lines is string[] {
            test:assertEquals(lines[0], "1357 Amber Drive", "Address line is not equal to 1357 Amber Drive");
            test:assertEquals(lines[1], "Amber Ave", "Address line is not equal to Amber Ave");
        }
        test:assertEquals(addresses[0]?.period?.'start, "2010-01-01", "Address period start is not equal to 2010-01-01");
        test:assertEquals(addresses[0]?.period?.'end, "2020-12-31", "Address period end is not equal to 2020-12-31");

        test:assertEquals(addresses[1]?.use, "home", "Address use is not equal to home");
        test:assertEquals(addresses[1]?.city, "Allerton", "Address city is not equal to Allerton");

        test:assertEquals(addresses[2]?.use, "home", "Address use is not equal to home");
        test:assertEquals(addresses[2]?.city, "Allerton", "Address city is not equal to Allerton");

        test:assertEquals(addresses[3]?.use, "old", "Address use is not equal to old");
        test:assertEquals(addresses[3]?.city, "Allerton", "Address city is not equal to Allerton");

        test:assertEquals(addresses[4]?.use, "temp", "Address use is not equal to temp");
        test:assertEquals(addresses[4]?.city, "Allerton", "Address city is not equal to Allerton");

        test:assertEquals(addresses[5]?.use, "work", "Address use is not equal to work");
        test:assertEquals(addresses[5]?.city, "Allerton", "Address city is not equal to Allerton");

        test:assertEquals(addresses[6]?.use, "work", "Address use is not equal to work");
        test:assertEquals(addresses[6]?.city, "Allerton", "Address city is not equal to Allerton");

        test:assertEquals(addresses[7]?.use, "work", "Address use is not equal to work");
        test:assertEquals(addresses[7]?.city, "Allerton", "Address city is not equal to Allerton");

        test:assertEquals(addresses[8]?.use, "old", "Address use is not equal to old");
        test:assertEquals(addresses[8]?.city, "Allerton", "Address city is not equal to Allerton");
    }
}

@test:Config {}
function testCcdaToTelecomToFhirTelecom() returns error? {
    xml ccdaTelecom = xml 
        `<telecom value="tel:+1(555)-555-2003" use="HP"/>
        <telecom value="mailto:john@dev.com" use="WP"/>
        <telecom value="fax:+1(555)-555-2003" use="MC"/>
        <telecom value="http:dev.com" system="http" use="OP"/>
        <telecom value="x-text-fax:+1(555)-555-2003" use="TP"/>
        <telecom value="+1(555)-555-2003" use="TP"/>`;

    r4:ContactPoint[]? telecom = mapCcdaTelecomToFhirTelecom(ccdaTelecom);
    test:assertTrue(telecom is r4:ContactPoint[], "Telecom is not of type r4:ContactPoint[]");
    if telecom is r4:ContactPoint[] {
        test:assertEquals(telecom[0].system, "phone", "Telecom system is not equal to phone");
        test:assertEquals(telecom[0]?.value, "+1(555)-555-2003", "Telecom value is not equal to +1(555)-555-2003");
        test:assertEquals(telecom[0]?.use, "home", "Telecom use is not equal to home");

        test:assertEquals(telecom[1]?.system, "email", "Telecom system is not equal to email");
        test:assertEquals(telecom[1]?.use, "work", "Telecom use is not equal to work");

        test:assertEquals(telecom[2]?.system, "fax", "Telecom system is not equal to fax");
        test:assertEquals(telecom[2]?.use, "mobile", "Telecom use is not equal to mobile");
        
        test:assertEquals(telecom[3]?.system, "url", "Telecom system is not equal to url");
        test:assertEquals(telecom[3]?.use, "old", "Telecom use is not equal to old");

        test:assertEquals(telecom[4]?.system, "sms", "Telecom system is not equal to sms");
        test:assertEquals(telecom[4]?.use, "temp", "Telecom use is not equal to temp");

        test:assertEquals(telecom[5]?.system, "other", "Telecom use is not equal to other");
    }
}

@test:Config {}
function testCcdaToNameToFhirName() returns error? {
    xml ccdaName = xml 
        `<name use="OR">
            <given>John</given>
            <given>Peter</given>
            <family>Smith</family>
            <prefix>Mr.</prefix>
            <prefix>Eng.</prefix>
            <suffix>Snr</suffix>
        </name>
        <name use="P"><given>John</given></name>
        <name use="L"><given>John</given></name>`;

    r4:HumanName[]? names = mapCcdaNameToFhirName(ccdaName);
    test:assertTrue(names is r4:HumanName[], "Name is not of type r4:HumanName[]");
    if names is r4:HumanName[] {
        test:assertEquals(names[0]?.use, "official", "Name use is not equal to official");
        test:assertEquals(names[0]?.family, "Smith", "Name family is not equal to Smith");

        string[]? prefix = names[0]?.prefix;
        if prefix is string[] {
            test:assertEquals(prefix[0], "Mr.", "Name prefix is not equal to Mr.");
            test:assertEquals(prefix[1], "Eng.", "Name prefix is not equal to Eng.");
        }

        string[]? suffix = names[0]?.suffix;
        if suffix is string[] {
            test:assertEquals(suffix[0], "Snr", "Name suffix is not equal to Snr");
        }

        string[]? given = names[0]?.given;
        if given is string[] {
            test:assertEquals(given[0], "John", "Name given is not equal to John");
            test:assertEquals(given[1], "Peter", "Name given is not equal to Peter");
        }

        test:assertEquals(names[1]?.use, "nickname", "Name use is not equal to nickname");
        test:assertEquals(names[2]?.use, (), "Name use is not null");
    }
}

@test:Config {}
function testCcdaToCodingToFhirCodeableConcept() returns error? {
    xml ccdaCoding = xml 
        `<code code="1234567890" codeSystem="2.16.840.1.113883.6.1" displayName="Test Code">
        <originalText>Test Code System</originalText></code>`;
    xml parentDocument = xml `<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 ../xsd/ccda.xsd">
        <id root="2.16.840.1.113883.4.500" extension="1234567890V123456"/>
        <code code="1234567890" codeSystem="2.16.840.1.113883.6.1" displayName="Test Code"><originalText>Test Code System</originalText></code>
    </ClinicalDocument>`;

    r4:CodeableConcept? codeableConcept = mapCcdaCodingToFhirCodeableConcept(ccdaCoding, parentDocument);
    test:assertTrue(codeableConcept is r4:CodeableConcept, "CodeableConcept is not of type r4:CodeableConcept");
    r4:Coding[]? coding = codeableConcept?.coding;
    test:assertTrue(coding is r4:Coding[], "Coding is not of type r4:Coding[]");
    if coding is r4:Coding[] {
        test:assertEquals(coding[0]?.code, "1234567890", "Coding code is not equal to 1234567890");
        test:assertEquals(coding[0]?.system, "http://loinc.org", "Coding system is not equal to http://loinc.org");
        test:assertEquals(coding[0]?.display, "Test Code", "Coding display is not equal to Test Code");
    }
    test:assertEquals(codeableConcept?.text, "Test Code System", "Coding version is not equal to Test Code System");
}

@test:Config {}
function testCcdaCodingsToFhirCodings() returns error? {
    xml ccdaCoding = xml 
        `<code code="1234567890" codeSystem="2.16.840.1.113883.6.1" displayName="Test Code">Test Code System</code>`;

    r4:Coding? coding = mapCcdaCodingToFhirCoding(ccdaCoding);
    test:assertTrue(coding is r4:Coding, "Coding is not of type r4:Coding");
    test:assertEquals(coding?.code, "1234567890", "Coding code is not equal to 1234567890");
    test:assertEquals(coding?.system, "http://loinc.org", "Coding system is not equal to http://loinc.org");
    test:assertEquals(coding?.display, "Test Code", "Coding display is not equal to Test Code");
}

@test:Config{}
function testCcdaDateTimeToFhirDateTime() returns error? {
    xml ccdaDateTime = xml `<effectiveTime value="202305312205-0500"/>`;
    r4:dateTime? dateTime = mapCcdaDateTimeToFhirDateTime(ccdaDateTime);
    test:assertTrue(dateTime is r4:dateTime, "dateTime is not of type r4:dateTime");
    test:assertEquals(dateTime, "2023-05-31T22:05-05:00", "dateTime is not equal to 2023-05-31T22:05-05:00");

    ccdaDateTime = xml `<effectiveTime value="20230531" precision="year"/>`;
    dateTime = mapCcdaDateTimeToFhirDateTime(ccdaDateTime);
    test:assertEquals(dateTime, "2023-05-31", "dateTime is not equal to 2023-05-31");

    ccdaDateTime = xml `<effectiveTime value="202305" precision="month"/>`;
    dateTime = mapCcdaDateTimeToFhirDateTime(ccdaDateTime);
    test:assertEquals(dateTime, "2023-05", "dateTime is not equal to 2023-05");

    ccdaDateTime = xml `<effectiveTime value="2023" precision="day"/>`;
    dateTime = mapCcdaDateTimeToFhirDateTime(ccdaDateTime);
    test:assertEquals(dateTime, "2023", "dateTime is not equal to 2023");
}

@test:Config{}
function testOidtoUri() {
    string? uri = mapOidToUri("2.16.840.1.113883.6.1");
    test:assertEquals(uri, "http://loinc.org", "uri is not equal to http://loinc.org");

    uri = mapOidToUri("2.16.840.1.113883.6.96");
    test:assertEquals(uri, "http://snomed.info/sct", "uri is not equal to http://snomed.info/sct");

    uri = mapOidToUri("2.16.840.1.113883.6.88");
    test:assertEquals(uri, "http://www.nlm.nih.gov/research/umls/rxnorm", "uri is not equal to http://www.nlm.nih.gov/research/umls/rxnorm");

    uri = mapOidToUri("2.16.840.1.113883.6.12");
    test:assertEquals(uri, "http://www.ama-assn.org/go/cpt", "uri is not equal to http://www.ama-assn.org/go/cpt");

    uri = mapOidToUri("2.16.840.1.113883.2.20.5.1");
    test:assertEquals(uri, "https://fhir.infoway-inforoute.ca/CodeSystem/pCLOCD", "uri is not equal to https://fhir.infoway-inforoute.ca/CodeSystem/pCLOCD");

    uri = mapOidToUri("2.16.840.1.113883.6.345");
    test:assertEquals(uri, "http://va.gov/terminology/medrt", "uri is not equal to http://va.gov/terminology/medrt");

    uri = mapOidToUri("2.16.840.1.113883.4.9");
    test:assertEquals(uri, "http://fdasis.nlm.nih.gov	", "uri is not equal to http://fdasis.nlm.nih.gov	");

    uri = mapOidToUri("2.16.840.1.113883.6.69");
    test:assertEquals(uri, "http://hl7.org/fhir/sid/ndc", "uri is not equal to http://hl7.org/fhir/sid/ndc");

    uri = mapOidToUri("2.16.840.1.113883.12.292");
    test:assertEquals(uri, "http://hl7.org/fhir/sid/cvx", "uri is not equal to http://hl7.org/fhir/sid/cvx");

    uri = mapOidToUri("2.16.840.1.113883.6.24");
    test:assertEquals(uri, "urn:iso:std:iso:11073:10101	", "uri is not equal to urn:iso:std:iso:11073:10101	");
}

@test:Config {}
function testCcdaGenderCodetoFhirGender() returns error? {
    xml codingElement = xml `<code code="M"/>`;
    uscore501:USCorePatientProfileGender gender = mapCcdaGenderCodetoFhirGender(codingElement);
    test:assertEquals(gender, "male", "Status is not equal to male");

    codingElement = xml `<code code="F"/>`;
    gender = mapCcdaGenderCodetoFhirGender(codingElement);
    test:assertEquals(gender, "female", "Status is not equal to female");

    codingElement = xml `<code code="UN"/>`;
    gender = mapCcdaGenderCodetoFhirGender(codingElement);
    test:assertEquals(gender, "other", "Status is not equal to other");

    codingElement = xml `<code code=""/>`;
    gender = mapCcdaGenderCodetoFhirGender(codingElement);
    test:assertEquals(gender, "unknown", "Status is not equal to unknown");
}
