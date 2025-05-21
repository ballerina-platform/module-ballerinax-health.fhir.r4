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
import ballerina/uuid;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

# Map CCDA Patient Role to FHIR Patient
#
# + xmlContent - xml content of the CCDA Patient Role
# + parentDocument - parent document of the CCDA
# + return - FHIR Patient
isolated function ccdaToPatient(xml xmlContent, xml parentDocument) returns uscore501:USCorePatientProfile? {
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
        
        uscore501:USCorePatientProfileIdentifier[] identifiers = [];
        foreach xml idInstance in idElement {
            uscore501:USCorePatientProfileIdentifier?|error mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idInstance);
            if mapCcdaIdToFhirIdentifierResult is r4:Identifier {
                identifiers.push(mapCcdaIdToFhirIdentifierResult);
            }
        }

        if identifiers.length() > 0 {
            patient.identifier = identifiers;
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

        r4:CodeableConcept? mapCCDAMaritalStatusCodetoFHIRMaritalStatusResult = mapCcdaCodingToFhirCodeableConcept(maritalStatusCodeElement, parentDocument);
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
            // Add proficiency extensions
            xml proficiencyElement = languageCommunicationElement/<v3:proficiencyLevelCode|proficiencyLevelCode>;
            r4:Coding? proficiencyCoding = mapCcdaCodingToFhirCoding(proficiencyElement);
            if proficiencyCoding is r4:Coding {
                r4:Extension proficiencyExtension = {
                    url: "http://hl7.org/fhir/StructureDefinition/patient-proficiency",
                    extension: [
                        {
                            url: "level",
                            valueCoding: proficiencyCoding
                        },
                        {
                            url: "type",
                            valueCoding: {
                                system: "http://terminology.hl7.org/CodeSystem/v3-LanguageAbilityMode",
                                code: "SPOKEN"
                            }
                        }
                    ]
                };
                patientCommunication.extension = [proficiencyExtension];
            }
            patient.communication = [patientCommunication];
        }

        r4:Extension[] extensions = [];
        xml patientRaceElement = patientElement/<v3:raceCode|raceCode>;
        xml patientSdtcRaceElement = patientElement/<raceCode|raceCode>;
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

        // Handle sdtc:raceCode
        r4:Coding? mapCCDASdtcRaceCodetoFHIRRaceResult = mapCcdaCodingToFhirCoding(patientSdtcRaceElement);
        if mapCCDASdtcRaceCodetoFHIRRaceResult is r4:Coding {
            r4:CodingExtension raceExtension = {valueCoding: {}, url: "ombCategory"};
            raceExtension.valueCoding = mapCCDASdtcRaceCodetoFHIRRaceResult;
            r4:Extension uscoreRace = {
                url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
                extension: [raceExtension]
            };
            extensions.push(uscoreRace);
        }

        xml patientEthnicityElement = patientElement/<v3:ethnicGroupCode|ethnicGroupCode>;
        xml patientSdtcEthnicityElement = patientElement/<ethnicGroupCode|ethnicGroupCode>;
        r4:Coding? mapCCDAEthnicityCodetoFHIREthnicityResult = mapCcdaCodingToFhirCoding(patientEthnicityElement);
        if mapCCDAEthnicityCodetoFHIREthnicityResult is r4:Coding {
            r4:CodingExtension ethnicityExtension = {valueCoding: {}, url: "ombCategory"};
            ethnicityExtension.valueCoding = mapCCDAEthnicityCodetoFHIREthnicityResult;
            r4:StringExtension? ethnicityText = ();
            if mapCCDAEthnicityCodetoFHIREthnicityResult.display is string {
                // Add text extension
                ethnicityText = {
                    url: "text",
                    valueString: <string>mapCCDAEthnicityCodetoFHIREthnicityResult.display
                };
            }

            // Add detailed extension if available
            r4:CodingExtension ethnicityDetailed = {
                url: "detailed",
                valueCoding: mapCCDAEthnicityCodetoFHIREthnicityResult
            };
            r4:Extension uscoreEthnicity = {
                url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity",
                extension: [ethnicityExtension, ethnicityDetailed]
            };
            if ethnicityText is r4:StringExtension {
                (<r4:Extension[]>uscoreEthnicity.extension).push(ethnicityText);
            }
            extensions.push(uscoreEthnicity);
        }

        // Handle sdtc:ethnicGroupCode
        r4:Coding? mapCCDASdtcEthnicityCodetoFHIREthnicityResult = mapCcdaCodingToFhirCoding(patientSdtcEthnicityElement);
        if mapCCDASdtcEthnicityCodetoFHIREthnicityResult is r4:Coding {
            r4:CodingExtension ethnicityExtension = {valueCoding: {}, url: "ombCategory"};
            ethnicityExtension.valueCoding = mapCCDASdtcEthnicityCodetoFHIREthnicityResult;
            r4:StringExtension? ethnicityText = ();
            if mapCCDASdtcEthnicityCodetoFHIREthnicityResult.display is string {
                // Add text extension
                ethnicityText = {
                    url: "text",
                    valueString: <string>mapCCDASdtcEthnicityCodetoFHIREthnicityResult.display
                };
            }

            // Add detailed extension if available
            r4:CodingExtension ethnicityDetailed = {
                url: "detailed",
                valueCoding: mapCCDASdtcEthnicityCodetoFHIREthnicityResult
            };
            r4:Extension uscoreEthnicity = {
                url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity",
                extension: [ethnicityExtension, ethnicityDetailed]
            };
            if ethnicityText is r4:StringExtension {
                (<r4:Extension[]>uscoreEthnicity.extension).push(ethnicityText);
            }
            extensions.push(uscoreEthnicity);
        }

        // Add after the existing extensions code
        xml religiousAffiliationElement = patientElement/<v3:religiousAffiliationCode|religiousAffiliationCode>;
        r4:Coding? mapCCDAReligiousAffiliationCodetoFHIRReligionResult = mapCcdaCodingToFhirCoding(religiousAffiliationElement);
        if mapCCDAReligiousAffiliationCodetoFHIRReligionResult is r4:Coding {
            r4:Extension religiousAffiliationExtension = {
                url: "http://hl7.org/fhir/StructureDefinition/patient-religion",
                valueCodeableConcept: {
                    coding: [mapCCDAReligiousAffiliationCodetoFHIRReligionResult]
                }
            };
            extensions.push(religiousAffiliationExtension);
        }

        // Add birthplace mapping
        xml birthplaceElement = patientElement/<v3:birthplace|birthplace>/<v3:place|place>/<v3:addr|addr>;
        r4:Address[]?|error birthplaceAddress = mapCcdaAddressToFhirAddress(birthplaceElement);
        if birthplaceAddress is r4:Address[] {
            r4:Extension birthplaceExtension = {
                url: "http://hl7.org/fhir/StructureDefinition/patient-birthPlace",
                valueAddress: birthplaceAddress[0]
            };
            extensions.push(birthplaceExtension);
        }

        // Add guardian mapping
        xml guardianElement = patientElement/<v3:guardian|guardian>;
        if isXMLElementNotNull(guardianElement) {
            xml guardianNameElement = guardianElement/<v3:guardianPerson|guardianPerson>/<v3:name|name>;
            xml guardianCodeElement = guardianElement/<v3:code|code>;
            xml guardianAddrElement = guardianElement/<v3:addr|addr>;

            r4:HumanName[]?|error guardianName = mapCcdaNameToFhirName(guardianNameElement);
            r4:CodeableConcept? guardianRelationship = mapCcdaCodingToFhirCodeableConcept(guardianCodeElement, parentDocument);
            r4:Address[]?|error guardianAddress = mapCcdaAddressToFhirAddress(guardianAddrElement);

            if guardianName is r4:HumanName[] && guardianRelationship is r4:CodeableConcept {
                r4:ContactPoint[] guardianContactPoints = [];
                xml guardianTelecomElement = guardianElement/<v3:telecom|telecom>;
                foreach xml telecom in guardianTelecomElement {
                    r4:ContactPoint? contactPoint = mapCcdaTelecomToFhirContactPoint(telecom);
                    if contactPoint is r4:ContactPoint {
                        guardianContactPoints.push(contactPoint);
                    }
                }

                uscore501:USCorePatientProfileContact guardianContact = {
                    relationship: [guardianRelationship],
                    name: guardianName[0],
                    telecom: guardianContactPoints
                };

                if guardianAddress is r4:Address[] {
                    guardianContact.address = guardianAddress[0];
                }

                patient.contact = [guardianContact];
            }
        }

        xml organizationIdElement = providerOrganizationElement/<v3:id|id>;
        xml organizationNameElement = providerOrganizationElement/<v3:name|name>;
        xml organizationTelecomElement = providerOrganizationElement/<v3:telecom|telecom>;

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

        // Handle multiple organization names
        string[] organizationNames = [];
        foreach xml name in organizationNameElement {
            string nameValue = name.data().trim();
            if nameValue != "" {
                organizationNames.push(nameValue);
            }
        }
        if organizationNames.length() > 0 {
            organizationReference.display = string:'join(" ", ...organizationNames);
        }

        // Add organization telecom
        uscore501:USCorePatientProfileTelecom[] organizationTelecoms = [];
        foreach xml telecom in organizationTelecomElement {
            r4:ContactPoint? contactPoint = mapCcdaTelecomToFhirContactPoint(telecom);
            if contactPoint is r4:ContactPoint {
                uscore501:USCorePatientProfileTelecom?|error organizationTelecom = contactPoint.toJson().cloneWithType();
                if organizationTelecom is uscore501:USCorePatientProfileTelecom {
                    organizationTelecoms.push(organizationTelecom);
                }
            }
        }
        if organizationTelecoms.length() > 0 {
            patient.telecom = organizationTelecoms;
        }

        patient.managingOrganization = organizationReference;

        if extensions.length() > 0 {
            patient.extension = extensions;
        }

        if (patient.identifier.length() == 0 && patient.name.length() == 0) {
            log:printDebug("Patient has no identifier or name");
            return ();
        }
        //generate the id
        patient.id = uuid:createRandomUuid();

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
            system: <uscore501:USCorePatientProfileTelecomSystem>systemVal,
            value: valueVal,
            use: useVal
        };
    }
    log:printDebug("telecom fields not available");
    return ();
}
