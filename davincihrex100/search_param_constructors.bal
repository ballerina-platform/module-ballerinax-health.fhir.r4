// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).

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

import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

# Constructs and adds the patient identifier search parameter to the search parameters map.
#
# + patient - The `USCorePatientProfile` resource
# + patientSearchParams - The map of search parameters to update
isolated function constructAndAddPatientIdentifierParam(uscore501:USCorePatientProfile patient,
        map<string[]> patientSearchParams) {
    string[] identifierParamValues = [];

    foreach uscore501:USCorePatientProfileIdentifier patientIdentifier in patient.identifier {
        uscore501:USCorePatientProfileIdentifierUse? use = patientIdentifier.use;
        r4:uri system = patientIdentifier.system;
        string value = patientIdentifier.value;
        if use != () && use == uscore501:CODE_USE_TEMP { // Temporary identifiers are not used for the matching
            continue;
        }
        identifierParamValues.push(string `${system}|${value}`);
    }

    addSearchParam("identifier", identifierParamValues, patientSearchParams);
}

# Constructs and adds patient name search parameters to a search parameters map.
#
# + patient - The `USCorePatientProfile` resource
# + patientSearchParams - The map of search parameters to update
isolated function constructAndAddPatientNameParams(uscore501:USCorePatientProfile patient,
        map<string[]> patientSearchParams) {
    string[] givenParamValues = [];
    string[] familyParamValues = [];

    foreach uscore501:USCorePatientProfileName patientName in patient.name {
        string[]? givenNames = patientName.given;
        if givenNames != () {
            givenParamValues.push(...givenNames);
        }
        string? familyName = patientName.family;
        if familyName != () {
            familyParamValues.push(familyName);
        }
    }

    addSearchParam("given", givenParamValues, patientSearchParams);
    addSearchParam("family", familyParamValues, patientSearchParams);
}

# Constructs and adds patient telecom search parameter to the search parameters map.
#
# + patient - The `USCorePatientProfile` resource
# + patientSearchParams - The map of search parameters to update
isolated function constructAndAddPatientTelecomParam(uscore501:USCorePatientProfile patient,
        map<string[]> patientSearchParams) {
    string[] telecomParamValues = [];

    uscore501:USCorePatientProfileTelecom[]? patientTelecoms = patient.telecom;
    if patientTelecoms != () {
        foreach uscore501:USCorePatientProfileTelecom contactPoint in patientTelecoms {
            telecomParamValues.push(contactPoint.value);
        }
    }

    addSearchParam("telecom", telecomParamValues, patientSearchParams);
}

# Constructs and adds patient address search parameters to the search parameters map.
#
# + patient - The `USCorePatientProfile` resource
# + patientSearchParams - The map of search parameters to update
isolated function constructAndAddPatientAddressParams(uscore501:USCorePatientProfile patient,
        map<string[]> patientSearchParams) {
    uscore501:USCorePatientProfileAddress[]? patientAddresses = patient.address;
    if patientAddresses != () {
        foreach uscore501:USCorePatientProfileAddress patientAddress in patientAddresses {
            // Only the billing address is considered
            if patientAddress.use != () && patientAddress.use == uscore501:CODE_USE_BILLING {
                addSearchParam("address", getAddressLines(patientAddress), patientSearchParams);
                addSearchParam("city", optionalStrToArray(patientAddress.city), patientSearchParams);
                addSearchParam("country", optionalStrToArray(patientAddress.country), patientSearchParams);
                addSearchParam("state", optionalStrToArray(patientAddress.state), patientSearchParams);
                addSearchParam("postalCode", optionalStrToArray(patientAddress.postalCode), patientSearchParams);
            }
        }
    }
}

# Constructs and adds patient language search parameter to the search parameters map.
#
# + patient - The `USCorePatientProfile` resource
# + patientSearchParams - The map of search parameters to update
isolated function constructAndAddPatientLanguageParam(uscore501:USCorePatientProfile patient,
        map<string[]> patientSearchParams) {
    uscore501:USCorePatientProfileCommunication[]? patientCommunications = patient.communication;
    if patientCommunications == () {
        return;
    }

    string[] languageParamValues = [];
    foreach uscore501:USCorePatientProfileCommunication patientCommunication in patientCommunications {
        r4:CodeableConcept languageConcept = patientCommunication.language;
        r4:Coding[]? languageCodings = languageConcept.coding;
        if languageCodings != () {
            foreach r4:Coding languageCoding in languageCodings {
                r4:uri? codingSystem = languageCoding.system;
                r4:code? codingCode = languageCoding.code;
                if codingSystem != () && codingCode != () {
                    languageParamValues.push(string `${codingSystem}|${codingCode}`);
                }
            }
        }
    }

    addSearchParam("language", languageParamValues, patientSearchParams);
}

# Extracts address lines from a `USCorePatientProfileAddress`.
#
# + patientAddress - The `USCorePatientProfileAddress`
# + return - An array of address lines
isolated function getAddressLines(uscore501:USCorePatientProfileAddress patientAddress) returns string[] {
    string[]? lines = patientAddress.line;
    return lines is string[] ? lines : [];
}

# Constructs and adds the coverage identifier search parameter to the search parameters map.
#
# + coverage - The `HRexCoverage` resource
# + coverageSearchParams - The map of search parameters to update
isolated function constructAndAddCoverageIdentifierParam(HRexCoverage coverage, map<string[]> coverageSearchParams) {
    string[] identifierParamValues = [];

    HRexCoverageIdentifier[]? coverageIdentifiers = coverage.identifier;
    if coverageIdentifiers != () {
        foreach HRexCoverageIdentifier coverageIdentifier in coverageIdentifiers {
            r4:uri? system = coverageIdentifier.system;
            string value = coverageIdentifier.value;
            identifierParamValues.push(system != () ? string `${system}|${value}` : value);
        }
    }

    addSearchParam("identifier", identifierParamValues, coverageSearchParams);
}

# Constructs and adds the coverage payor search parameter to the search parameters map.
#
# + coverage - The `HRexCoverage` resource
# + coverageSearchParams - The map of search parameters to update
isolated function constructAndAddCoveragePayorParam(HRexCoverage coverage, map<string[]> coverageSearchParams) {
    string[] payorParamValues = [];

    r4:Reference[] coveragePayorReferences = coverage.payor;
    foreach r4:Reference reference in coveragePayorReferences {
        string? literalReference = reference.reference;
        if literalReference != () {
            payorParamValues.push(literalReference);
        }
    }

    addSearchParam("payor", payorParamValues, coverageSearchParams);
}
