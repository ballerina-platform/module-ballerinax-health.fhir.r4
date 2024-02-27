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
import ballerinax/health.fhir.r4.uscore501;

# Map CCDA Patient Role to FHIR Patient
#
# + xmlContent - xml content of the CCDA Patient Role
# + return - FHIR Patient
isolated function ccdaToPatient(xml xmlContent) returns uscore501:USCorePatientProfile? {
    if isXMLElementNotNull(xmlContent) {
        uscore501:USCorePatientProfile patient = {identifier: [], gender: "unknown", name: []};

        xml idElement = xmlContent/<v3:id|id>;
        xml addrElement = xmlContent/<v3:addr|addr>;
        xml telecomElement = xmlContent/<v3:telecom|telecom>;
        xml patientElement = xmlContent/<v3:patient|patient>;
        xml genderCodeElement = patientElement/<v3:administrativeGenderCode|administrativeGenderCode>;
        xml birthTimeElement = patientElement/<v3:birthTime|birthTime>;
        xml maritalStatusCodeElement = patientElement/<v3:maritalStatusCode|maritalStatusCode>;
        xml languageCommunicationElement = patientElement/<v3:languageCommunication|languageCommunication>;
        xml providerOrganizationElement = xmlContent/<v3:providerOrganization|providerOrganization>;

        uscore501:USCorePatientProfileIdentifier?|error mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idElement);
        if mapCcdaIdToFhirIdentifierResult is r4:Identifier {
            patient.identifier = [mapCcdaIdToFhirIdentifierResult];
        }

        r4:Address[]?|error mapCcdaAddressToFhirAddressResult = mapCcdaAddressToFhirAddress(addrElement);
        if mapCcdaAddressToFhirAddressResult is r4:Address[] {
            patient.address = mapCcdaAddressToFhirAddressResult;
        }

        uscore501:USCorePatientProfileTelecom[] telecoms = [];
        foreach xml telecomInstance in telecomElement {
            uscore501:USCorePatientProfileTelecom?|error mapCcdaTelecomToFhirTelecomResult = mapCcdaTelecomToFhirPatientTelecom(telecomInstance);
            if mapCcdaTelecomToFhirTelecomResult is uscore501:USCorePatientProfileTelecom {
                telecoms.push(mapCcdaTelecomToFhirTelecomResult);
            }
        }
        
        if telecoms.length() > 0 {
            patient.telecom = telecoms;
        }

        patient.telecom = telecoms;

        xml nameElement = patientElement/<v3:name|name>;
        r4:HumanName[]?|error mapCcdaNametoFhirNameResult = mapCcdaNameToFhirName(nameElement);
        if mapCcdaNametoFhirNameResult is r4:HumanName[] {
            patient.name = mapCcdaNametoFhirNameResult;
        }

        uscore501:USCorePatientProfileGender mapCcdaGenderCodetoFhirGenderResult = mapCcdaGenderCodetoFhirGender(genderCodeElement);
        patient.gender = mapCcdaGenderCodetoFhirGenderResult;

        r4:dateTime? mapCCDABirthTimetoFHIRBirthDateResult = mapCcdaDateTimeToFhirDateTime(birthTimeElement);
        if mapCCDABirthTimetoFHIRBirthDateResult is r4:dateTime {
            patient.birthDate = mapCCDABirthTimetoFHIRBirthDateResult;
        }

        r4:CodeableConcept? mapCCDAMaritalStatusCodetoFHIRMaritalStatusResult = mapCcdaCodingToFhirCodeableConcept(maritalStatusCodeElement);
        if mapCCDAMaritalStatusCodetoFHIRMaritalStatusResult is r4:CodeableConcept {
            patient.maritalStatus = mapCCDAMaritalStatusCodetoFHIRMaritalStatusResult;
        }

        xml preferenceIndElement = languageCommunicationElement/<v3:preferenceInd|preferenceInd>;
        xml languageCodeElement = languageCommunicationElement/<v3:languageCode|languageCode>;

        r4:Coding?|error mapCCDALanguageCodetoFHIRCommunicationLanguageResult = mapCcdaCodingToFhirCoding(languageCodeElement);
        if mapCCDALanguageCodetoFHIRCommunicationLanguageResult is r4:Coding {
            uscore501:USCorePatientProfileCommunication patientCommunication = {language: {}};
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
            organizationReference.reference = "Organization/" + referenceId;
        }
        if referenceRoot is string {
            organizationReference.identifier = {system: referenceRoot};
        }

        string organizationName = organizationNameElement.data();
        organizationReference.display = organizationName;

        patient.managingOrganization = organizationReference;

        r4:Extension[] extensions = [];
        xml patientRaceElement = patientElement/<v3:raceCode|raceCode>;
        r4:Coding? mapCCDARaceCodetoFHIRRaceResult = mapCcdaCodingToFhirCoding(patientRaceElement);
        if mapCCDARaceCodetoFHIRRaceResult is r4:Coding {
            r4:CodingExtension raceExtension = {valueCoding: {}, url: "ombCategory"};
            raceExtension.valueCoding = mapCCDARaceCodetoFHIRRaceResult;
            r4:Extension uscoreRace = {
                url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
                extension: [raceExtension]
            };
            extensions.push(uscoreRace);
        }

        xml patientEthnicityElement = patientElement/<v3:ethnicGroupCode|ethnicGroupCode>;
        r4:Coding? mapCCDAEthnicityCodetoFHIREthnicityResult = mapCcdaCodingToFhirCoding(patientEthnicityElement);
        if mapCCDAEthnicityCodetoFHIREthnicityResult is r4:Coding {
            r4:CodingExtension ethnicityExtension = {valueCoding: {}, url: "ombCategory"};
            ethnicityExtension.valueCoding = mapCCDAEthnicityCodetoFHIREthnicityResult;
            r4:Extension uscoreEthnicity = {
                url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity",
                extension: [ethnicityExtension]
            };
            extensions.push(uscoreEthnicity);
        }

        if extensions.length() > 0 {
            patient.extension = extensions;
        }

        return patient;
    }
    return ();
}

isolated function mapCcdaGenderCodetoFhirGender(xml codingElement) returns uscore501:USCorePatientProfileGender {
    string|error? codeVal = codingElement.code;
    if codeVal is string {
        match codeVal {
            "M" => {
                return uscore501:CODE_GENDER_MALE;
            }
            "F" => {
                return uscore501:CODE_GENDER_FEMALE;
            }
            "UN" => {
                return uscore501:CODE_GENDER_OTHER;
            }
            _ => {
                return uscore501:CODE_GENDER_UNKNOWN;
            }
        }
    }
    log:printDebug("code is not available", codeVal);
    return uscore501:CODE_GENDER_UNKNOWN;
}

# Map C-CDA telecom to FHIR Patient ContactPoint.
#
# + telecomElement - C-CDA telecom element
# + return - Return FHIR ContactPoint
public isolated function mapCcdaTelecomToFhirPatientTelecom(xml telecomElement) returns uscore501:USCorePatientProfileTelecom? {
    string|error? telecomUse = telecomElement.use;
    string|error? telecomValue = telecomElement.value;

    string? systemVal = ();
    string? valueVal = ();
    if telecomValue is string {
        string[] valTokens = re `:`.split(telecomValue);
            if valTokens.length() == 1 {
                systemVal = r4:other;
                valueVal = telecomValue;
            } else {
                systemVal = valTokens[0];
                valueVal = valTokens[1];
                
                match (systemVal) {
                    "tel" => {
                        systemVal = r4:phone;
                    }
                    "mailto" => {
                        systemVal = r4:email;
                    }
                    "fax" => {
                        systemVal = r4:fax;
                    }
                    "http" => {
                        systemVal = r4:url;
                    }
                    "x-text-fax" => {
                        systemVal = r4:sms;
                    }
                    _ => {
                        systemVal = r4:other;
                    }
                }
            }
    } else {
        log:printDebug("Telecom value not available", telecomValue);
    }

    r4:ContactPointUse? useVal = ();
    if telecomUse is string {
        match telecomUse {
            "HP" => {
                useVal = "home";
            }
            "WP" => {
                useVal = "work";
            }
            "MC" => {
                useVal = "mobile";
            }
            "OP" => {
                useVal = "old";
            }
            "TP" => {
                useVal = "temp";
            }
        }
    } else {
        log:printDebug("Telecom use not available", telecomUse);
    }

    if systemVal is string && valueVal is string {
        return {
            system: <uscore501:USCorePatientProfileTelecomSystem> systemVal,
            value: valueVal,
            use: useVal
        };
    }
    log:printDebug("telecom fields not available");
    return ();
}
