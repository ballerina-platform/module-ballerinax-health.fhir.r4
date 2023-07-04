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

// --------------------------------------------------------------------------------------------#
// Source C-CDA to FHIR - Resource Mappings
// --------------------------------------------------------------------------------------------#

import ballerina/log;
import ballerinax/health.fhir.r4;

# Map CCDA Patient Role to FHIR Patient
#
# + xmlContent - xml content of the CCDA Patient Role
# + isNamespaceAvailable - Is CCDA namespace available
# + return - FHIR Patient
public isolated function mapCcdaPatientToFhir(xml xmlContent, boolean isNamespaceAvailable = true) returns r4:Patient? {
    if isXMLElementNotNull(xmlContent) {
        r4:Patient patient = {};

        xml idElement = xmlContent/<v3:id|id>;
        xml addrElement = xmlContent/<v3:addr|addr>;
        xml telecomElement = xmlContent/<v3:telecom|telecom>;
        xml patientElement = xmlContent/<v3:patient|patient>;
        xml genderCodeElement = patientElement/<v3:administrativeGenderCode|administrativeGenderCode>;
        xml birthTimeElement = patientElement/<v3:birthTime|birthTime>;
        xml maritalStatusCodeElement = patientElement/<v3:maritalStatusCode|maritalStatusCode>;
        xml languageCommunicationElement = patientElement/<v3:languageCommunication|languageCommunication>;
        xml providerOrganizationElement = xmlContent/<v3:providerOrganization|providerOrganization>;

        r4:Identifier?|error mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idElement);
        if mapCcdaIdToFhirIdentifierResult is r4:Identifier {
            patient.identifier = [mapCcdaIdToFhirIdentifierResult];
        }

        r4:Address?|error mapCcdaAddressToFhirAddressResult = mapCcdaAddressToFhirAddress(addrElement);
        if mapCcdaAddressToFhirAddressResult is r4:Address {
            patient.address = [mapCcdaAddressToFhirAddressResult];
        }

        r4:ContactPoint?|error mapCcdaTelecomToFhirTelecomResult = mapCcdaTelecomToFhirTelecom(telecomElement);
        if mapCcdaTelecomToFhirTelecomResult is r4:ContactPoint {
            patient.telecom = [mapCcdaTelecomToFhirTelecomResult];
        }

        xml nameElement = patientElement/<v3:name|name>;
        r4:HumanName?|error mapCcdaNametoFhirNameResult = mapCcdaNametoFhirName(nameElement);
        if mapCcdaNametoFhirNameResult is r4:HumanName {
            patient.name = [mapCcdaNametoFhirNameResult];
        }

        r4:PatientGender mapCcdaGenderCodetoFhirGenderResult = mapCcdaGenderCodetoFhirGender(genderCodeElement);
        patient.gender = mapCcdaGenderCodetoFhirGenderResult;

        r4:dateTime? mapCCDABirthTimetoFHIRBirthDateResult = mapCcdaDateTimeToFhirDateTime(birthTimeElement);
        if mapCCDABirthTimetoFHIRBirthDateResult is r4:dateTime {
            patient.birthDate = mapCCDABirthTimetoFHIRBirthDateResult;
        }

        r4:CodeableConcept? mapCCDAMaritalStatusCodetoFHIRMaritalStatusResult = mapCcdaCodingtoFhirCodeableConcept(maritalStatusCodeElement);
        if mapCCDAMaritalStatusCodetoFHIRMaritalStatusResult is r4:CodeableConcept {
            patient.maritalStatus = mapCCDAMaritalStatusCodetoFHIRMaritalStatusResult;
        }

        xml preferenceIndElement = languageCommunicationElement/<v3:preferenceInd|preferenceInd>;
        xml languageCodeElement = languageCommunicationElement/<v3:languageCode|languageCode>;

        r4:Coding?|error mapCCDALanguageCodetoFHIRCommunicationLanguageResult = mapCcdaCodingtoFhirCode(languageCodeElement);
        if mapCCDALanguageCodetoFHIRCommunicationLanguageResult is r4:Coding {
            r4:PatientCommunication patientCommunication = {language: {}};
            patientCommunication.language.coding = [mapCCDALanguageCodetoFHIRCommunicationLanguageResult];
            string|error? preferenceIdVal = preferenceIndElement.value;
            if preferenceIdVal is string {
                boolean?|error preference = boolean:fromString(preferenceIdVal);
                if preference is boolean {
                    patientCommunication.preferred = preference;
                } else {
                    log:printDebug("Invalid value for preferred element", preference);
                }
            } else {
                log:printDebug("preferenceValueId is not available", preferenceIdVal);
            }
            patient.communication = [patientCommunication];
        }

        xml organizationIdElement = providerOrganizationElement/<v3:id|id>;
        xml organizationNameElement = providerOrganizationElement/<v3:name|name>;

        r4:Reference organizationReference = {};
        string|error? referenceId = organizationIdElement.extension;
        string|error? referenceRoot = organizationIdElement.root;
        if referenceId is string {
            organizationReference.identifier = {value: referenceId};
        }
        if referenceRoot is string {
            organizationReference.identifier = {system: referenceRoot};
        }

        string organizationName = organizationNameElement.data();
        organizationReference.display = organizationName;

        patient.managingOrganization = organizationReference;
        return patient;
    }
    return ();
}

isolated function mapCcdaGenderCodetoFhirGender(xml codingElement) returns r4:PatientGender {
    string|error? codeVal = codingElement.code;
    if codeVal is string {
        match codeVal {
            "M" => {
                return r4:CODE_GENDER_MALE;
            }
            "F" => {
                return r4:CODE_GENDER_FEMALE;
            }
            "UN" => {
                return r4:CODE_GENDER_OTHER;
            }
            _ => {
                return r4:CODE_GENDER_UNKNOWN;
            }
        }
    }
    log:printDebug("code is not available", codeVal);
    return r4:CODE_GENDER_UNKNOWN;
}
