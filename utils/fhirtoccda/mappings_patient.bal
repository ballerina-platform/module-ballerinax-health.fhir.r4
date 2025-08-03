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

// --------------------------------------------------------------------------------------------#
// Source FHIR to C-CDA - Patient Mappings
// --------------------------------------------------------------------------------------------#

import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

# Map FHIR USCore Patient to C-CDA PatientRole
#
# + patient - FHIR USCore Patient resource
# + allResources - All FHIR resources for context
# + return - C-CDA RecordTarget
isolated function fhirToPatient(uscore501:USCorePatientProfile patient, r4:Resource[] allResources) returns RecordTarget? {
    PatientRole patientRole = {id: [{root: generateUUID()}]};

    // Map identifiers
    if patient.identifier is uscore501:USCorePatientProfileIdentifier[] {
        II[] ids = [];
        foreach uscore501:USCorePatientProfileIdentifier identifier in patient.identifier {
            II? id = mapFhirIdentifierToCcdaId(identifier);
            if id != () {
                ids.push(id);
            }
        }
        if ids.length() > 0 {
            patientRole.id = ids;
        }
    }

    // Map addresses
    if patient.address is uscore501:USCorePatientProfileAddress[] {
        AD[] addresses = [];
        foreach uscore501:USCorePatientProfileAddress address in <uscore501:USCorePatientProfileAddress[]>patient.address {
            AD? ccdaAddress = mapFhirAddressToCcdaAddress(address);
            if ccdaAddress != () {
                addresses.push(ccdaAddress);
            }
        }
        if addresses.length() > 0 {
            patientRole.addr = addresses;
        }
    }

    // Map telecom
    if patient.telecom is uscore501:USCorePatientProfileTelecom[] {
        TEL[] telecoms = [];
        foreach uscore501:USCorePatientProfileTelecom telecom in <uscore501:USCorePatientProfileTelecom[]>patient.telecom {
            TEL? ccdaTelecom = mapFhirTelecomToCcdaTelecom(telecom);
            if ccdaTelecom != () {
                telecoms.push(ccdaTelecom);
            }
        }
        if telecoms.length() > 0 {
            patientRole.telecom = telecoms;
        }
    }

    // Map patient details
    Patient ccdaPatient = {};

    // Map names
    if patient.name is uscore501:USCorePatientProfileName[] {
        PN[] names = [];
        foreach uscore501:USCorePatientProfileName name in <uscore501:USCorePatientProfileName[]>patient.name {
            PN? ccdaName = mapFhirNameToCcdaName(name);
            if ccdaName != () {
                names.push(ccdaName);
            }
        }
        if names.length() > 0 {
            ccdaPatient.name = names;
        }
    }

    // Map gender
    if patient.gender is uscore501:USCorePatientProfileGender {
        CE? genderCode = mapFhirGenderToCcdaGender(patient.gender);
        if genderCode != () {
            ccdaPatient.administrativeGenderCode = genderCode;
        }
    }

    // Map birth date
    if patient.birthDate is r4:date {
        TS? birthTime = mapFhirDateToCcdaDateTime(<r4:date>patient.birthDate);
        if birthTime != () {
            ccdaPatient.birthTime = birthTime;
        }
    }

    // Map deceased information
    if patient.deceasedBoolean is boolean {
        if <boolean>patient.deceasedBoolean {
            ccdaPatient.deceasedInd = {value: true};
            if patient.deceasedDateTime is r4:dateTime {
                TS? deceasedTime = mapFhirDateTimeToCcdaDateTime(<r4:dateTime>patient.deceasedDateTime);
                if deceasedTime != () {
                    ccdaPatient.deceasedTime = deceasedTime;
                }
            } else {
                // Set nullFlavor="UNK" when deceasedBoolean is true but no deceasedDateTime
                ccdaPatient.deceasedTime = {nullFlavor: "UNK"};
            }
        }
    } else if patient.deceasedDateTime is r4:dateTime {
        ccdaPatient.deceasedInd = {value: true};
        TS? deceasedTime = mapFhirDateTimeToCcdaDateTime(<r4:dateTime>patient.deceasedDateTime);
        if deceasedTime != () {
            ccdaPatient.deceasedTime = deceasedTime;
        }
    }

    // Map marital status
    if patient.maritalStatus is r4:CodeableConcept {
        CE? maritalStatusCode = mapFhirCodeableConceptToCcdaCoding(<r4:CodeableConcept>patient.maritalStatus);
        if maritalStatusCode != () {
            ccdaPatient.maritalStatusCode = maritalStatusCode;
        }
    }

    // Map communication/language
    if patient.communication is uscore501:USCorePatientProfileCommunication[] {
        LanguageCommunication[] languageCommunications = [];
        foreach uscore501:USCorePatientProfileCommunication communication in <uscore501:USCorePatientProfileCommunication[]>patient.communication {
            LanguageCommunication? langComm = mapFhirCommunicationToCcdaLanguageCommunication(communication);
            if langComm != () {
                languageCommunications.push(langComm);
            }
        }
        if languageCommunications.length() > 0 {
            ccdaPatient.languageCommunication = languageCommunications;
        }
    }

    // Map race extension
    if patient.extension is r4:Extension[] {
        CE[] raceCodes = [];
        foreach r4:Extension ext in <r4:Extension[]>patient.extension {
            if ext.url == "http://hl7.org/fhir/us/core/STU4/StructureDefinition/us-core-race" {
                CE[]? mappedRaceCodes = mapFhirRaceExtensionToCcdaRaceCodes(ext);
                if mappedRaceCodes != () {
                    raceCodes = [...raceCodes, ...mappedRaceCodes];
                }
            }
        }
        if raceCodes.length() > 0 {
            ccdaPatient.raceCode = raceCodes;
        }
    }

    // Map ethnicity extension
    if patient.extension is r4:Extension[] {
        CE[] ethnicGroupCodes = [];
        foreach r4:Extension ext in <r4:Extension[]>patient.extension {
            if ext.url == "http://hl7.org/fhir/us/core/STU4/StructureDefinition/us-core-ethnicity" {
                CE[]? mappedEthnicityCodes = mapFhirEthnicityExtensionToCcdaEthnicityCodes(ext);
                if mappedEthnicityCodes != () {
                    ethnicGroupCodes = [...ethnicGroupCodes, ...mappedEthnicityCodes];
                }
            }
        }
        if ethnicGroupCodes.length() > 0 {
            ccdaPatient.ethnicGroupCode = ethnicGroupCodes;
        }
    }

    // Map managing organization
    if patient.managingOrganization is r4:Reference {
        Organization? providerOrg = mapFhirReferenceToCcdaOrganization(<r4:Reference>patient.managingOrganization, allResources);
        if providerOrg != () {
            patientRole.providerOrganization = providerOrg;
        }
    }

    patientRole.patient = ccdaPatient;

    return {
        patientRole: patientRole
    };
}
