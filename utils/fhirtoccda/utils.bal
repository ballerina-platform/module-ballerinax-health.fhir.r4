import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;
import ballerina/log;

# Map FHIR identifier to C-CDA II
#
# + identifier - FHIR Identifier resource
# + return - C-CDA II
public isolated function mapFhirIdentifierToCcdaId(r4:Identifier identifier) returns II? {
    if identifier.system is string && identifier.value is string {
        return {
            root: identifier.system,
            extension: identifier.value
        };
    }
    return ();
}

# Map FHIR address to C-CDA AD
#
# + address - FHIR Address resource
# + return - C-CDA AD
public isolated function mapFhirAddressToCcdaAddress(uscore501:USCorePatientProfileAddress address) returns AD? {
    AD ccdaAddress = {};

    if address.use is r4:AddressUse {
        ccdaAddress.use = mapFhirAddressUseToCcdaAddressUse(<r4:AddressUse>address.use);
    }

    if address.text is string {
        ccdaAddress.xmlText = address.text;
    }

    if address.line is string[] {
        ADXP[] addressLines = [];
        foreach string line in <string[]>address.line {
            addressLines.push({xmlText: line});
        }
        if addressLines.length() > 0 {
            ccdaAddress.streetAddressLine = addressLines;
        }
    }

    if address.city is string {
        ccdaAddress.city = {xmlText: address.city};
    }

    if address.state is string {
        ccdaAddress.state = {xmlText: address.state};
    }

    if address.postalCode is string {
        ccdaAddress.postalCode = {xmlText: address.postalCode};
    }

    if address.country is string {
        ccdaAddress.country = {xmlText: address.country};
    }

    return ccdaAddress;
}

# Map FHIR telecom to C-CDA TEL
#
# + telecom - FHIR Telecom resource
# + return - C-CDA TEL
public isolated function mapFhirTelecomToCcdaTelecom(uscore501:USCorePatientProfileTelecom telecom) returns TEL? {
    TEL ccdaTelecom = {value: telecom.value};

    if telecom.system is r4:ContactPointSystem {
        ccdaTelecom.use = mapFhirContactPointSystemToCcdaTelecomUse(telecom.system);
    }

    return ccdaTelecom;
}

# Map FHIR name to C-CDA PN
#
# + name - FHIR Name resource
# + return - C-CDA PN
public isolated function mapFhirNameToCcdaName(uscore501:USCorePatientProfileName name) returns PN? {
    PN ccdaName = {item: ["L"]};

    if name.use is r4:HumanNameUse {
        ccdaName.item[0] = mapFhirHumanNameUseToCcdaNameUse(<r4:HumanNameUse>name.use);
    }

    if name.text is string {
        ccdaName.xmlText = name.text;
    }

    if name.family is string {
        ccdaName.family[0] = {xmlText: name.family};
    }

    if name.given is string[] {
        ENXP[] givenNames = [];
        foreach string given in <string[]>name.given {
            givenNames.push({xmlText: given});
        }
        if givenNames.length() > 0 {
            ccdaName.given = givenNames;
        }
    }

    if name.prefix is string[] {
        ENXP[] prefixes = [];
        foreach string prefix in <string[]>name.prefix {
            prefixes.push({xmlText: prefix});
        }
        if prefixes.length() > 0 {
            ccdaName.prefix = prefixes;
        }
    }

    if name.suffix is string[] {
        ENXP[] suffixes = [];
        foreach string suffix in <string[]>name.suffix {
            suffixes.push({xmlText: suffix});
        }
        if suffixes.length() > 0 {
            ccdaName.suffix = suffixes;
        }
    }

    return ccdaName;
}

# Map FHIR gender to C-CDA CE
#
# + gender - FHIR Gender resource
# + return - C-CDA CE
public isolated function mapFhirGenderToCcdaGender(uscore501:USCorePatientProfileGender gender) returns CE? {
    string? code = ();
    string? codeSystem = ();
    string? displayName = ();

    match gender {
        "male" => {
            code = "M";
            codeSystem = "2.16.840.1.113883.5.1";
            displayName = "Male";
        }
        "female" => {
            code = "F";
            codeSystem = "2.16.840.1.113883.5.1";
            displayName = "Female";
        }
        "other" => {
            code = "O";
            codeSystem = "2.16.840.1.113883.5.1";
            displayName = "Other";
        }
        "unknown" => {
            code = "UN";
            codeSystem = "2.16.840.1.113883.5.1";
            displayName = "Undifferentiated";
        }
    }

    if code != () {
        return {
            code: code,
            codeSystem: codeSystem,
            displayName: displayName
        };
    }

    return ();
}

# Map FHIR date to C-CDA TS
#
# + date - FHIR Date resource
# + return - C-CDA TS
public isolated function mapFhirDateToCcdaDateTime(r4:date date) returns TS? {
    // Convert FHIR date to HL7 format (YYYYMMDD)
    string hl7Date = date.toString();
    return {value: hl7Date};
}

# Map FHIR dateTime to C-CDA TS
#
# + dateTime - FHIR DateTime resource
# + return - C-CDA TS
public isolated function mapFhirDateTimeToCcdaDateTime(r4:dateTime dateTime) returns TS {
    // Convert FHIR dateTime to HL7 format (YYYYMMDDHHMMSS)
    string hl7DateTime = dateTime.toString();
    return {value: hl7DateTime};
}

# Map C-CDA TS to FHIR dateTime
#
# + dateTimeElement - C-CDA TS resource
# + return - FHIR dateTime
public isolated function mapCcdaDateTimeToFhirDateTime(TS dateTimeElement) returns r4:dateTime? {
    string|error? dateTimeVal = dateTimeElement.value;
    if dateTimeVal !is string {
        log:printDebug("DateTime is not available", dateTimeVal);
        return ();
    }

    int length = dateTimeVal.length();
    match (length) {
        4 => {
            return dateTimeVal;
        }
        6 => {
            return string `${dateTimeVal.substring(0, 4)}-${dateTimeVal.substring(4, 6)}`;
        }
        8 => {
            return string `${dateTimeVal.substring(0, 4)}-${dateTimeVal.substring(4, 6)}-${dateTimeVal.substring(6, 8)}`;
        }
        17 => {
            return string `${dateTimeVal.substring(0, 4)}-${dateTimeVal.substring(4, 6)}-${dateTimeVal.substring(6, 8)}T${dateTimeVal.substring(8, 10)}:${dateTimeVal.substring(10, 15)}:${dateTimeVal.substring(15, 17)}`;
        }
        19 => {
            return string `${dateTimeVal.substring(0, 4)}-${dateTimeVal.substring(4, 6)}-${dateTimeVal.substring(6, 8)}T${dateTimeVal.substring(8, 10)}:${dateTimeVal.substring(10, 15)}:${dateTimeVal.substring(15, 17)}`;
        }
        _ => {
            log:printDebug("Invalid dateTime length");
            return ();
        }
    }
}

# Map C-CDA TS to FHIR date
#
# + dateElement - C-CDA TS resource
# + return - FHIR date
public isolated function mapCcdaDateTimeToFhirDate(TS dateElement) returns r4:date? {
    string|error? dateVal = dateElement.value;
    if dateVal !is string {
        log:printDebug("Date is not available", dateVal);
        return ();
    }

    int length = dateVal.length();
    match (length) {
        4 => {
            return dateVal;
        }
        6 => {
            return string `${dateVal.substring(0, 4)}-${dateVal.substring(4, 6)}`;
        }
        8 => {
            return string `${dateVal.substring(0, 4)}-${dateVal.substring(4, 6)}-${dateVal.substring(6, 8)}`;
        }
        _ => {
            log:printDebug("Invalid date length");
            return ();
        }
    }
}

# Map FHIR CodeableConcept to C-CDA CE
#
# + codeableConcept - FHIR CodeableConcept resource
# + return - C-CDA CE
public isolated function mapFhirCodeableConceptToCcdaCoding(r4:CodeableConcept codeableConcept) returns CE? {
    if codeableConcept.coding is r4:Coding[] {
        r4:Coding[] codingArray = <r4:Coding[]>codeableConcept.coding;
        if codingArray.length() > 0 {
            r4:Coding coding = codingArray[0];
            return {
                code: coding.code,
                codeSystem: coding.system,
                displayName: coding.display
            };
        }
    }
    return ();
}

# Map FHIR communication to C-CDA LanguageCommunication
#
# + communication - FHIR Communication resource
# + return - C-CDA LanguageCommunication
public isolated function mapFhirCommunicationToCcdaLanguageCommunication(uscore501:USCorePatientProfileCommunication communication) returns LanguageCommunication? {
    LanguageCommunication langComm = {};

    if communication.language is r4:CodeableConcept {
        CE? languageCode = mapFhirCodeableConceptToCcdaCoding(communication.language);
        if languageCode != () {
            langComm.languageCode.originalText = {xmlText: languageCode.displayName};
        }
    }

    if communication.preferred is boolean {
        langComm.preferenceInd = {value: communication.preferred};
    }

    return langComm;
}

# Map FHIR race extension to C-CDA race codes
#
# + raceExtension - FHIR Extension resource
# + return - C-CDA CE[]
public isolated function mapFhirRaceExtensionToCcdaRaceCodes(r4:Extension raceExtension) returns CE[]? {
    // Implementation would parse the race extension and map to C-CDA race codes
    // This is a simplified implementation
    return [];
}

# Map FHIR ethnicity extension to C-CDA ethnicity codes
#
# + ethnicityExtension - FHIR Extension resource
# + return - C-CDA CE[]
public isolated function mapFhirEthnicityExtensionToCcdaEthnicityCodes(r4:Extension ethnicityExtension) returns CE[]? {
    // Implementation would parse the ethnicity extension and map to C-CDA ethnicity codes
    // This is a simplified implementation
    return [];
}

# Map FHIR reference to C-CDA organization
#
# + reference - FHIR Reference resource
# + allResources - All FHIR resources for context
# + return - C-CDA Organization
public isolated function mapFhirReferenceToCcdaOrganization(r4:Reference reference, r4:Resource[] allResources) returns Organization? {
    // Implementation would find the referenced organization and map it
    // This is a simplified implementation
    return ();
}

# Helper functions for mapping FHIR enums to C-CDA enums
#
# + use - FHIR AddressUse resource
# + return - string
public isolated function mapFhirAddressUseToCcdaAddressUse(r4:AddressUse use) returns string {
    // Implementation would map FHIR address use to C-CDA address use
    return "H";
}

public isolated function mapFhirAddressTypeToCcdaAddressType(r4:AddressType addressType) returns string {
    // Implementation would map FHIR address type to C-CDA address type
    return "PST";
}

public isolated function mapFhirContactPointSystemToCcdaTelecomUse(r4:ContactPointSystem system) returns string {
    // Implementation would map FHIR contact point system to C-CDA telecom use
    return "HP";
}

public isolated function mapFhirHumanNameUseToCcdaNameUse(r4:HumanNameUse use) returns string {
    // Implementation would map FHIR human name use to C-CDA name use
    match use {
        "official" => {
            return "OR";
        }
        "nickname" => {
            return "P";
        }
    }
    return "L";
}
