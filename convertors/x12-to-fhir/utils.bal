import ballerina/io;
import ballerina/log;
import ballerina/regex;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.carinbb200;
import ballerinax/health.fhir.r4.davincipas;
// import ballerinax/health.fhir.r4.international401;
// import ballerinax/health.fhir.r4.parser;
import ballerinax/health.fhir.r4.uscore501;

//NM1 - 2010A
public function getUtilizationManagementOrganizationUMOName_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns UtilizationManagementOrganizationUMOName_Type|error {

    string NM101 = "";
    string NM102 = "2";
    string NM103 = "";
    string NM108 = "";
    string NM109 = "";

    //Reference from claim resource pointing to the organization resource
    r4:Reference id = claim.insurer;

    anydata|error profile = getProfileFromBundle(bundle, id, "Organization");
    if profile is anydata {
        uscore501:USCoreOrganizationProfile orgProfile = <uscore501:USCoreOrganizationProfile>profile;

        if orgProfile.resourceType == "Organization" && orgProfile.id == id.reference {

            //NM101
            r4:CodeableConcept[]? profileType = orgProfile.'type;
            if profileType is r4:CodeableConcept[] && profileType.length() > 0 {
                r4:Coding[]? profileCoding = profileType[0].coding;
                if profileCoding is r4:Coding[] && profileCoding.length() > 0 {
                    r4:code? profileCode = profileCoding[0].code;
                    if profileCode is r4:code {
                        NM101 = profileCode;
                    }
                }
            }

            //NM103
            NM103 = orgProfile.name;

            //NM104, NM105, NM107 - These data element are not defined in the PAS Claim profile.

            r4:code? identifierCode = null;
            uscore501:USCoreOrganizationProfileIdentifier[]? profileIdentifier = orgProfile.identifier;
            if (profileIdentifier is uscore501:USCoreOrganizationProfileIdentifier[] && profileIdentifier.length() > 0) {

                //NM108
                r4:CodeableConcept? identifierType = profileIdentifier[0].'type;
                if (identifierType is r4:CodeableConcept) {
                    r4:Coding[]? coding = identifierType.coding;
                    if (coding is r4:Coding[]) {
                        identifierCode = coding[0].code;
                    }
                    if identifierCode != () {
                        if identifierCode == "46" {
                            NM108 = "46";
                        } else if identifierCode == "U" {
                            NM108 = "PI";
                        }
                    } else {
                        log:printWarn("Failed to find matching identifier code for NM1 - 2010A, NM108");
                    }
                }

                //NM109
                string? identifierValue = profileIdentifier[0].value;
                if identifierValue is string {
                    NM109 = identifierValue;
                }
            }
        }

    } else {
        return error("Bundle does not contain an Organization resource, or Claim resource does not have a valid reference to an Organization resource");
    }

    if NM101 == "" || NM102 == "" || NM108 == "" || NM109 == "" {
        return error(string `Following fields are mandatory for 'NM1 - 2010A' segment:
                 	Organization.type[0].coding[0].code
                	Organization.identifier[0].type.coding[0].code
                    Organization.identifier[0].value`);
    }
    return {
        NM101__EntityIdentifierCode: NM101,
        NM102__EntityTypeQualifier: NM102,
        NM103__UtilizationManagementOrganizationUMOLastOrOrganizationName: NM103,
        NM108__IdentificationCodeQualifier: NM108,
        NM109__UtilizationManagementOrganizationUMOIdentifier: NM109
    };
}

//NM1 - 2010B
public function getRequesterName_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns RequesterName_Type|error {

    string NM101 = "";
    string NM102 = "2";
    string NM103 = "";
    string NM108 = "XX";
    string NM109 = "";

    //Reference from claim resource pointing to the organization resource
    r4:Reference id = claim.provider;

    anydata|error profile = getProfileFromBundle(bundle, id, "Organization");
    if profile is anydata {
        uscore501:USCoreOrganizationProfile orgProfile = <uscore501:USCoreOrganizationProfile>profile;

        if orgProfile.resourceType == "Organization" && orgProfile.id == id.reference {

            //NM01
            r4:CodeableConcept[]? profileType = orgProfile.'type;
            if profileType is r4:CodeableConcept[] && profileType.length() > 0 {
                r4:Coding[]? profileCoding = profileType[0].coding;
                if profileCoding is r4:Coding[] && profileCoding.length() > 0 {
                    r4:code? profileCode = profileCoding[0].code;
                    if profileCode is r4:code {
                        NM101 = profileCode;
                    }
                }
            }

            //NM103
            NM103 = orgProfile.name;

            //NM104, NM105, NM107 - These data element are not defined in the PAS Claim profile.

            //NM109
            uscore501:USCoreOrganizationProfileIdentifier[]? profileIdentifier = orgProfile.identifier;
            if profileIdentifier is uscore501:USCoreOrganizationProfileIdentifier[] && profileIdentifier.length() > 0 {
                string? identifierValue = profileIdentifier[0].value;
                if identifierValue is string {
                    NM109 = identifierValue;
                }
            }

        }
    } else {
        return error("Bundle does not contain an Organization resource, or Claim resource does not have a valid reference to an Organization resource");
    }

    if NM101 == "" || NM102 == "" || NM108 == "" || NM109 == "" {
        return error(string `Following fields are mandatory for 'NM1 - 2010B' segment:
                 	Organization.type[0].coding[0].code
                    Organization.identifier[0].value`);
    }
    return {
        NM101__EntityIdentifierCode: NM101,
        NM102__EntityTypeQualifier: NM102,
        NM103__RequesterLastOrOrganizationName: NM103,
        NM108__IdentificationCodeQualifier: NM108,
        NM109__RequesterIdentifier: NM109
    };
}

//N3 - 2010B
public function getRequesterAddress_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns RequesterAddress_Type|error? {

    string N301 = "";
    string N302 = "";

    //Reference from claim resource pointing to the organization resource
    r4:Reference id = claim.provider;

    anydata|error profile = getProfileFromBundle(bundle, id, "Organization");
    if profile is anydata {
        uscore501:USCoreOrganizationProfile orgProfile = <uscore501:USCoreOrganizationProfile>profile;

        if orgProfile.resourceType == "Organization" && orgProfile.id == id.reference {

            uscore501:USCoreOrganizationProfileAddress[]? profileAddress = orgProfile.address;
            if profileAddress is uscore501:USCoreOrganizationProfileAddress[] {
                string[]? addressLines = profileAddress[0].line;
                if addressLines is string[] && addressLines.length() > 0 {
                    N301 = addressLines[0];
                    if addressLines.length() > 1 {
                        N302 = addressLines[1];
                    }
                }
            }
        } else {
            return error("Bundle does not contain an Organization resource, or Claim resource does not have a valid reference to an Organization resource");
        }

    }

    if N301 == "" {
        log:printWarn("Following field(s) are mandatory for 'N3 - 2010B' segment: Organization.address[0].line[0]");
        return ();
    }

    return {
        N301__RequesterAddressLine: N301,
        N302__RequesterAddressLine: N302
    };
}

//N4 - 2010B
public function getRequesterCityStateZIPCode_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns RequesterCityStateZIPCode_Type|error? {

    string N401 = "";
    string N402 = "";
    string N403 = "";
    string N404 = "";

    //Reference from claim resource pointing to the organization resource
    r4:Reference id = claim.provider;

    anydata|error profile = getProfileFromBundle(bundle, id, "Organization");
    if profile is anydata {
        uscore501:USCoreOrganizationProfile orgProfile = <uscore501:USCoreOrganizationProfile>profile;

        if orgProfile.resourceType == "Organization" && orgProfile.id == id.reference {

            uscore501:USCoreOrganizationProfileAddress[]? profileAddress = orgProfile.address;
            if profileAddress is uscore501:USCoreOrganizationProfileAddress[] && profileAddress.length() > 0 {
                string? cityValue = profileAddress[0].city;
                if cityValue is string {
                    N401 = cityValue;
                }
                string? stateValue = profileAddress[0].state;
                if stateValue is string {
                    N402 = stateValue;
                }
                string? postalCodeValue = profileAddress[0].postalCode;
                if postalCodeValue is string {
                    N403 = postalCodeValue;
                }
                string? countryValue = profileAddress[0].country;
                if countryValue is string {
                    N404 = countryValue;
                }

            }
        } else {
            return error("Bundle does not contain an Organization resource, or Claim resource does not have a valid reference to an Organization resource");
        }

    }

    if N401 == "" {
        log:printWarn("Following field(s) are mandatory for 'N4 - 2010B' segment: Organization.address[0].city");
        return ();
    }
    return {
        N401__RequesterCityName: N401,
        N402__RequesterStateOrProvinceCode: N402,
        N403__RequesterPostalZoneOrZIPCode: N403,
        N404__CountryCode: N404
    };
}

// PER - 2010B
public function getRequesterContactInformation_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns RequesterContactInformation_Type|error? {

    string PER01 = "IC";
    string PER02 = "";
    string PER03 = "";
    string PER04 = "";
    string PER05 = "";
    string PER06 = "";
    string PER07 = "";
    string PER08 = "";

    //Reference from claim resource pointing to the organization resource
    r4:Reference id = claim.provider;

    anydata|error profile = getProfileFromBundle(bundle, id, "Organization");
    if profile is anydata {
        uscore501:USCoreOrganizationProfile orgProfile = <uscore501:USCoreOrganizationProfile>profile;

        if orgProfile.resourceType == "Organization" && orgProfile.id == id.reference {

            // io:println(profile);

            uscore501:USCoreOrganizationProfileContact[]? profileContact = orgProfile.contact;
            if profileContact is uscore501:USCoreOrganizationProfileContact[] {
                r4:HumanName? name = profileContact[0].name;
                if name is r4:HumanName {
                    string[]? givenNames = name.given;
                    string fullname = "";
                    if givenNames is string[] {
                        foreach string givenname in givenNames {
                            fullname = fullname + " " + givenname;
                        }
                        PER02 = fullname;
                    }
                }
                //PER03
                r4:ContactPoint[]? telecom = profileContact[0].telecom;
                if telecom is r4:ContactPoint[] && telecom.length() > 0 {
                    r4:ContactPointSystem? system = telecom[0].system;
                    if system is r4:ContactPointSystem {
                        match system {
                            r4:phone => {
                                PER03 = "TE";
                            }
                            r4:fax => {
                                PER03 = "FX";
                            }
                            r4:email => {
                                PER03 = "EM";
                            }
                            r4:pager => {
                                PER03 = "TE";
                            }
                            r4:url => {
                                PER03 = "UR";
                            }
                            r4:sms => {
                                PER03 = "TE";
                            }
                            _ => {
                                PER03 = "cannot be translated"; //Add Error handling
                            }
                        }
                    }
                }
                //PER04
                if telecom is r4:ContactPoint[] && telecom.length() > 0 {
                    r4:ContactPointSystem? system = telecom[0].system;
                    string? systemValue = telecom[0].value;

                    if systemValue is string {
                        PER04 = systemValue;

                        if system is r4:ContactPointSystem && system == r4:phone {
                            string extension = "";
                            // Using regex to split the phone number and extension
                            string[] parts = regex:split(systemValue, "ext\\.");
                            if parts.length() > 1 {
                                extension = parts[1].trim();
                                PER05 = "EX";
                                PER06 = extension;
                            }

                        }
                    }

                }
                //PER05
                if PER03 !== "TE" {
                    if telecom is r4:ContactPoint[] && telecom.length() > 1 {
                        r4:ContactPointSystem? system = telecom[1].system;
                        if system is r4:ContactPointSystem {
                            match system {
                                r4:phone => {
                                    PER05 = "TE";
                                }
                                r4:fax => {
                                    PER05 = "FX";
                                }
                                r4:email => {
                                    PER05 = "EM";
                                }
                                r4:pager => {
                                    PER05 = "TE";
                                }
                                r4:url => {
                                    PER05 = "UR";
                                }
                                r4:sms => {
                                    PER05 = "TE";
                                }
                                _ => {
                                    PER05 = "cannot be translated"; //Add Error handling
                                }
                            }
                        }
                    }
                }
                //PER06
                if PER05 !== "EX" {
                    if telecom is r4:ContactPoint[] && telecom.length() > 1 {
                        r4:ContactPointSystem? system = telecom[1].system;
                        string? systemValue = telecom[1].value;

                        if systemValue is string {
                            PER06 = systemValue;

                            if system is r4:ContactPointSystem && system == r4:phone {
                                string extension = "";
                                // Use regex to split the phone number and extension
                                string[] parts = regex:split(systemValue, "ext\\.");
                                if parts.length() > 1 {
                                    extension = parts[1].trim();

                                    PER07 = "EX";
                                    PER08 = extension;
                                }
                            }
                        }
                    }

                }
                //PER07
                if PER05 !== "TE" {
                    if telecom is r4:ContactPoint[] && telecom.length() > 2 {
                        r4:ContactPointSystem? system = telecom[2].system;
                        if system is r4:ContactPointSystem {
                            if system == r4:phone {
                                PER07 = "TE";
                            } else if system == r4:fax {
                                PER07 = "FX";
                            } else if system == r4:email {
                                PER07 = "EM";
                            } else if system == r4:pager {
                                PER07 = "TE";
                            } else if system == r4:url {
                                PER07 = "UR";
                            } else if system == r4:sms {
                                PER07 = "TE";
                            } else {
                                PER07 = "cannot be translated"; //Add Error handling
                            }
                        }
                    }
                }
                //PER08
                if PER07 !== "EX" {
                    if telecom is r4:ContactPoint[] && telecom.length() > 2 {
                        string? systemValue = telecom[2].value;
                        if systemValue is string {
                            PER08 = systemValue;
                        }
                    }
                }
            }

        } else {
            return error("Bundle does not contain an Organization resource, or Claim resource does not have a valid reference to an Organization resource");
        }

    }

    if PER02 == "" && PER03 == "" && PER04 == "" && PER05 == "" && PER06 == "" && PER07 == "" && PER08 == "" {
        return ();
    }

    return {
        PER01__ContactFunctionCode: PER01,
        PER02__RequesterContactName: PER02,
        PER03__CommunicationNumberQualifier: PER03,
        PER04__RequesterContactCommunicationNumber: PER04,
        PER05__CommunicationNumberQualifier: PER05,
        PER06__RequesterContactCommunicationNumber: PER06,
        PER07__CommunicationNumberQualifier: PER07,
        PER08__RequesterContactCommunicationNumber: PER08
    };

};

//NM1 - 2010C
public function getSubscriberName_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns SubscriberName_Type|error? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        string NM101 = "IL";
        string NM102 = "1";
        string NM103 = "";
        string NM104 = "";
        string NM105 = "";
        string NM106 = "";
        string NM107 = "";
        string NM108 = "MI";
        string NM109 = "";

        uscore501:USCorePatientProfileName[] patientName = patientProfile.name;
        if patientName.length() > 0 {
            //NM03
            string? familyName = patientName[0].family;
            if familyName is string {
                NM103 = familyName;
            }

            string[]? givenNames = patientName[0].given;
            if givenNames is string[] && givenNames.length() > 0 {
                //NM04
                string? givenName1 = givenNames[0];
                if givenName1 is string {
                    NM104 = givenName1;
                }
                //NM05
                string? givenName2 = givenNames[1];
                if givenName2 is string {
                    NM105 = givenName2;
                }
            }

            //NM06
            string[]? prefix = patientName[0].prefix;
            if prefix is string[] && prefix.length() > 0 {
                NM106 = prefix[0];
            }

            //NM07
            string[]? suffix = patientName[0].suffix;
            if suffix is string[] && suffix.length() > 0 {
                NM107 = suffix[0];
            }
        }
        //NM09
        uscore501:USCorePatientProfileIdentifier[] patientIdentifier = patientProfile.identifier;
        if patientIdentifier.length() > 0 {
            NM109 = patientIdentifier[0].value;
        }

        if NM109 == "" {
            return error("Following field is mandatory for 'NM1 - 2010C' segment: Patient.identifier[0].value");
        }

        return {
            NM101__EntityIdentifierCode: NM101,
            NM102__EntityTypeQualifier: NM102,
            NM103__SubscriberLastName: NM103,
            NM104__SubscriberFirstName: NM104,
            NM105__SubscriberMiddleNameOrInitial: NM105,
            NM106__SubscriberNamePrefix: NM106,
            NM107__SubscriberNameSuffix: NM107,
            NM108__IdentificationCodeQualifier: NM108,
            NM109__SubscriberPrimaryIdentifier: NM109
        };
    } else {
        return error("Bundle does not contain a Patient resource, or Claim resource does not have a valid reference to a Patient resource.");
    }
}

//REF -2010 C

public function getSubscriberSupplementalIdentification_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns SubscriberSupplementalIdentification_Type|error? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {
        string REF01 = "";
        string REF02 = "";

        //REF01
        uscore501:USCorePatientProfileIdentifier[] identifier = patientProfile.identifier;
        if identifier.length() > 1 {
            r4:CodeableConcept? identifierType = identifier[1].'type;
            if identifierType is r4:CodeableConcept {
                r4:Coding[]? coding = identifierType.coding;
                if coding is r4:Coding[] && coding.length() > 0 {
                    r4:code? code = coding[0].code;
                    if code is r4:code {
                        match code {
                            "1L" => {
                                REF01 = "1L";
                            }
                            "3L" => {
                                REF01 = "3L";
                            }
                            "6P" => {
                                REF01 = "6P";
                            }
                            "DP" => {
                                REF01 = "DP";
                            }
                            "EJ" => {
                                REF01 = "EJ";
                            }
                            "MC" => {
                                REF01 = "F6";
                            }
                            "HJ" => {
                                REF01 = "HJ";
                            }
                            "IG" => {
                                REF01 = "IG";
                            }
                            "N6" => {
                                REF01 = "N6";
                            }
                            "MA" => {
                                REF01 = "NQ";
                            }
                            "SS" => {
                                REF01 = "SY";
                            }
                            _ => {
                                REF01 = "cannot be translated"; //Add Error handling
                            }
                        }
                    }

                }
            }
            //REF02
            REF02 = identifier[1].value;
        }

        if REF01 == "" && REF02 == "" {
            return ();
        }

        if REF01 == "" || REF02 == "" {
            log:printWarn("Following fields are mandatory for 'REF - 2010C' segment: Patient.identifier[1].type.coding[0].code, Patient.identifier[1].value");
            return ();
        }

        return {
            REF01__ReferenceIdentificationQualifier: REF01,
            REF02__SubscriberSupplementalIdentifier: REF02
        };

    } else {
        return error("Bundle does not contain a Patient resource, or Claim resource does not have a valid reference to a Patient resource.");
    }
}

//N3 - 2010C
public function getSubscriberAddress_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns SubscriberAddress_Type|error? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        string N301 = "";
        string N302 = "";

        uscore501:USCorePatientProfileAddress[]? patientAddress = patientProfile.address;
        if patientAddress is uscore501:USCorePatientProfileAddress[] && patientAddress.length() > 0 {
            string[]? addressLines = patientAddress[0].line;
            if addressLines is string[] && addressLines.length() > 0 {
                //N301
                N301 = addressLines[0];
                if addressLines.length() > 1 {
                    //N302
                    N302 = addressLines[1];
                }
            }
        }

        if N301 == "" {
            return ();
        }

        return {
            N301__SubscriberAddressLine: N301,
            N302__SubscriberAddressLine: N302
        };

    } else {
        return error("Bundle does not contain a Patient resource, or Claim resource does not have a valid reference to a Patient resource.");
    }
}

//N4 - 2010C
public function getSubscriberCityStateZIPCode_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns SubscriberCityStateZIPCode_Type|error? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        string N401 = "";
        string N402 = "";
        string N403 = "";
        string N404 = "";

        uscore501:USCorePatientProfileAddress[]? patientAddress = patientProfile.address;
        if patientAddress is uscore501:USCorePatientProfileAddress[] && patientAddress.length() > 0 {
            //N401
            string? city = patientAddress[0].city;
            if city is string {
                N401 = city;
            }
            //N402
            string? state = patientAddress[0].state;
            if state is string {
                N402 = state;
            }
            //N403
            string? postalCode = patientAddress[0].postalCode;
            if postalCode is string {
                N403 = postalCode;
            }
            //N404
            string? country = patientAddress[0].country;
            if country is string {
                N404 = country;
            }
        }
        if N401 == "" {
            return ();
        }

        return {
            N401__SubscriberCityName: N401,
            N402__SubscriberStateCode: N402,
            N403__SubscriberPostalZoneOrZIPCode: N403,
            N404__CountryCode: N404

        };

    } else {
        return error("Bundle does not contain a Patient resource, or Claim resource does not have a valid reference to a Patient resource.");
    }
}

//DMG - 2010C
public function getSubscriberDemographicInformation_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns SubscriberDemographicInformation_Type|error? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        string DMG01 = "D8";
        string DMG02 = "";
        string DMG03 = "";

        //DMG02
        r4:date? birthDate = patientProfile.birthDate;
        if birthDate is r4:date {
            DMG02 = birthDate.toString();
        }

        //DMG03
        uscore501:USCorePatientProfileGender patientGender = patientProfile.gender;
        match patientGender {
            uscore501:CODE_GENDER_FEMALE => {
                DMG03 = "F";
            }
            uscore501:CODE_GENDER_MALE => {
                DMG03 = "M";
            }
            uscore501:CODE_GENDER_UNKNOWN => {
                DMG03 = "U";
            }
            uscore501:CODE_GENDER_OTHER => {
                DMG03 = "U";
            }
        }

        if DMG02 == "" {
            return ();
        }
        return {
            DMG01__DateTimePeriodFormatQualifier: DMG01,
            DMG02__SubscriberBirthDate: DMG02,
            DMG03__SubscriberGenderCode: DMG03
        };

    } else {
        return error("Bundle does not contain a Patient resource, or Claim resource does not have a valid reference to a Patient resource.");
    }
}

//INS - 2010C
public function getSubscriberRelationship_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns SubscriberRelationship_Type|error? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        string INS01 = "Y";
        string INS02 = "18";
        string INS08 = "";

        r4:Extension[]? patientExtensions = patientProfile.extension;
        if patientExtensions is r4:Extension[] {
            foreach var extension in patientExtensions {
                r4:Extension? patientExtension = extension;
                if patientExtension is r4:Extension {
                    if patientExtension.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-militaryStatus" {

                        r4:CodeableConceptExtension|error patientCodeableConceptExtension = trap <r4:CodeableConceptExtension>patientExtension;
                        if patientCodeableConceptExtension is error {
                            continue;
                        }
                        else {
                            r4:CodeableConcept patientCodeableConcept = patientCodeableConceptExtension.valueCodeableConcept;
                            r4:Coding[]? patientCoding = patientCodeableConcept.coding;
                            if patientCoding is r4:Coding[] && patientCoding.length() > 0 {
                                r4:code? patientCode = patientCoding[0].code;
                                if patientCode is r4:code {
                                    INS08 = patientCode;
                                    break;
                                }
                            }
                        }

                    }
                }
            }
        }
        if INS08 == "" {
            return ();
        }
        return {
            INS01__InsuredIndicator: INS01,
            INS02__IndividualRelationshipCode: INS02,
            INS08__EmploymentStatusCode: INS08
        };

    } else {
        return error("Bundle does not contain a Patient resource, or Claim resource does not have a valid reference to a Patient resource.");
    }

}

public function getDependentName_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns DependentName_Type|error? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        string NM101 = "QC";
        string NM102 = "1";
        string NM103 = "";
        string NM104 = "";
        string NM105 = "";
        string NM107 = "";

        uscore501:USCorePatientProfileName[] patientName = patientProfile.name;
        if patientName.length() > 0 {
            //NM03
            string? familyName = patientName[0].family;
            if familyName is string {
                NM103 = familyName;
            }

            string[]? givenNames = patientName[0].given;
            if givenNames is string[] && givenNames.length() > 0 {
                //NM04
                string? givenName1 = givenNames[0];
                if givenName1 is string {
                    NM104 = givenName1;
                }
                if givenNames.length() > 1 {
                    //NM05
                    string? givenName2 = givenNames[1];
                    if givenName2 is string {
                        NM105 = givenName2;
                    }
                }
            }

            //NM07
            string[]? suffix = patientName[0].suffix;
            if suffix is string[] && suffix.length() > 0 {
                NM107 = suffix[0];
            }

            //No need for validations as mandatory fields are hardcoded
        }
        return {
            NM101__EntityIdentifierCode: NM101,
            NM102__EntityTypeQualifier: NM102,
            NM103__DependentLastName: NM103,
            NM104__DependentFirstName: NM104,
            NM105__DependentMiddleName: NM105,
            NM107__DependentNameSuffix: NM107
        };

    }
    return error("Error in creating mandatory segment NM1 - 2010D");
}

//REF - 2010D
public function getDependentSupplementalIdentification_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns DependentSupplementalIdentification_Type? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {
        string REF01 = "";
        string REF02 = "";

        //REF01
        uscore501:USCorePatientProfileIdentifier[] identifier = patientProfile.identifier;
        if identifier.length() > 0 {
            //REF01
            r4:CodeableConcept? identifierType = identifier[0].'type;
            if identifierType is r4:CodeableConcept {
                r4:Coding[]? coding = identifierType.coding;
                if coding is r4:Coding[] && coding.length() > 0 {
                    r4:code? code = coding[0].code;
                    if code is r4:code {
                        match code {
                            "EJ" => {
                                REF01 = "EJ";
                            }
                            "SB" => {
                                REF01 = "SY";
                            }
                        }
                    }

                }
            }
            //REF02
            REF02 = identifier[0].value;
        }

        if REF01 == "" && REF02 == "" {
            return ();
        }
        if REF01 == "" {
            //TODO - Uncomment these lines, these lines are only commented only for testing purposes
            //log:printWarn("REF01 in 'REF - 2010D' segment cannot be translated.");
            // return ();   
        }
        if REF02 == "" {
            log:printWarn("Following field(s) are mandatory for 'REF - 2010D' segment: Patient.identifier[0].value.");
            return ();
        }

        return {
            REF01__ReferenceIdentificationQualifier: "del", //Replace with REF01 variable (REF01 will be empty here due to the json, so del is added as a placeholder)
            REF02__DependentSupplementalIdentifier: REF02
        };
    }
    return ();
}

//N3 - 2010D
public function getDependentAddress_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns DependentAddress_Type? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        string N301 = "";
        string N302 = "";

        uscore501:USCorePatientProfileAddress[]? patientAddress = patientProfile.address;
        if patientAddress is uscore501:USCorePatientProfileAddress[] && patientAddress.length() > 0 {
            string[]? addressLines = patientAddress[0].line;
            if addressLines is string[] && addressLines.length() > 0 {
                //N301
                N301 = addressLines[0];
                if addressLines.length() > 1 {
                    //N302
                    N302 = addressLines[1];
                }
            }
        }
        if N301 == "" {
            log:printWarn("Following field(s) are mandatory for 'N3 - 2010D' segment: Patient.address[0].line[0]");
            return ();
        }

        return {
            N301__DependentAddressLine: N301,
            N302__DependentAddressLine: N302
        };
    }
    return ();
}

// N4 - 2010D
public function getDependentCityStateZIPCode_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns DependentCityStateZIPCode_Type? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        string N401 = "";
        string N402 = "";
        string N403 = "";
        string N404 = "";

        uscore501:USCorePatientProfileAddress[]? patientAddress = patientProfile.address;
        if patientAddress is uscore501:USCorePatientProfileAddress[] && patientAddress.length() > 0 {
            //N401
            string? city = patientAddress[0].city;
            if city is string {
                N401 = city;
            }
            //N402
            string? state = patientAddress[0].state;
            if state is string {
                N402 = state;
            }
            //N403
            string? postalCode = patientAddress[0].postalCode;
            if postalCode is string {
                N403 = postalCode;
            }
            //N404
            string? country = patientAddress[0].country;
            if country is string {
                N404 = country;
            }

            if N401 == "" {
                log:printWarn("Following field(s) are mandatory for 'N4 - 2010D' segment: Patient.address[0].city");
                return ();
            }
        }
        return {
            N401__DependentCityName: N401,
            N402__DependentStateCode: N402,
            N403__DependentPostalZoneOrZIPCode: N403,
            N404__CountryCode: N404
        };
    }
    return ();
}

// DMG - 2010D
public function getDependentDemographicInformation_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns DependentDemographicInformation_Type? {

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        string DMG01 = "D8";
        string DMG02 = "";
        string DMG03 = "";

        //DMG02
        r4:date? birthDate = patientProfile.birthDate;
        if birthDate is r4:date {
            DMG02 = birthDate.toString();
        }

        //DMG03
        uscore501:USCorePatientProfileGender patientGender = patientProfile.gender;
        match patientGender {
            uscore501:CODE_GENDER_FEMALE => {
                DMG03 = "F";
            }
            uscore501:CODE_GENDER_MALE => {
                DMG03 = "M";
            }
            uscore501:CODE_GENDER_UNKNOWN => {
                DMG03 = "U";
            }
            uscore501:CODE_GENDER_OTHER => {
                DMG03 = "U";
            }
        }
        if DMG02 == "" {
            log:printWarn("Following field(s) are mandatory for 'DMG - 2010D' segment: Patient.birthDate");
            return ();
        }
        return {
            DMG01__DateTimePeriodFormatQualifier: DMG01,
            DMG02__DependentBirthDate: DMG02,
            DMG03__DependentGenderCode: DMG03
        };
    }
    return ();

}

//INS - 2010D
public function getDependentRelationship_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns DependentRelationship_Type? {

    string INS01 = "N";
    string INS02 = "";
    string INS17 = "";

    r4:Reference id = claim.insurance[0].coverage;

    anydata|error profile = getProfileFromBundle(bundle, id, "Coverage");
    if profile is anydata {
        carinbb200:C4BBCoverage coverageProfile = <carinbb200:C4BBCoverage>profile;
        if coverageProfile.resourceType == "Coverage" && coverageProfile.id == id.reference {
            r4:CodeableConcept relationship = coverageProfile.relationship;
            r4:Coding[]? coding = relationship.coding;
            if coding is r4:Coding[] && coding.length() > 0 {
                r4:code? code = coding[0].code;
                if code is r4:code {
                    match code {
                        "child" => {
                            INS02 = "19";
                        }
                        "parent" => {
                            INS02 = "G8";
                        }
                        "spouse" => {
                            INS02 = "01";
                        }
                        "common" => {
                            INS02 = "G8";
                        }
                        "other" => {
                            INS02 = "G8";
                        }
                        "injured" => {
                            INS02 = "G8";
                        }
                    }
                }
            }
        }

    }

    uscore501:USCorePatientProfile|error patientProfile = getPatientFromCoverage(bundle, claim);
    if patientProfile is uscore501:USCorePatientProfile {

        //INS17
        r4:integer? multipleBirth = patientProfile.multipleBirthInteger;
        if multipleBirth is r4:integer {
            INS17 = multipleBirth.toString();
        }
    }

    //Add error handling if segment is mandatory
    if INS02 == "" {
        log:printWarn("Following field is mandatory for 'INS - 2010D' segment: Coverage.relationship");
        return ();
    }
    return {
        INS01__InsuredIndicator: INS01,
        INS02__IndividualRelationshipCode: INS02,
        INS17__BirthSequenceNumber: INS17
    };

}

// TRN - 2000E
public function getPatientEventLevel_Type(davincipas:PASClaim claim) returns PatientEventTrackingNumber_Type? {

    string TRN01 = "1";
    string TRN02 = "";
    string TRN03 = "";
    string TRN04 = "";

    davincipas:ProfileIdentifier claimIdentifier = claim.identifier;
    //TRN02
    string? value = claimIdentifier.value;
    if value is string {
        TRN02 = value;
    }

    //TRN03
    r4:Reference? assigner = claimIdentifier.assigner;
    if assigner is r4:Reference {
        r4:Identifier? assignerIdentifier = assigner.identifier;
        if assignerIdentifier is r4:Identifier {
            string? assignerValue = assignerIdentifier.value;
            if assignerValue is string {
                TRN03 = assignerValue;
            }
        }
    }

    //TRN04
    r4:Extension[]? extensions = claimIdentifier.extension;
    if extensions is r4:Extension[] {
        foreach var extension in extensions {
            r4:Extension? claimExtension = extension;
            if claimExtension is r4:Extension {
                if claimExtension.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-identifierSubDepartment" {
                    r4:StringExtension|error valueStringExtension = trap <r4:StringExtension>claimExtension;
                    if valueStringExtension is error {
                        continue;
                    }
                    else {
                        TRN04 = valueStringExtension.valueString;
                    }
                }
            }
        }
    }

    // If all fields are empty, segment is not required so return empty object
    // If even one field is not empty segment is required, mandatory fields should be populated so output a warning
    if TRN02 == "" && TRN03 == "" && TRN04 == "" {
        return ();
    } else if TRN02 == "" || TRN03 == "" {
        log:printWarn("Following fields are mandatory for TRN - 2000E segment: Claim.identifier[0].value, Claim.identifier[0].assigner.identifier.value");
        return ();
    }
    return {
        TRN01__TraceTypeCode: TRN01,
        TRN02__PatientEventTraceNumber: TRN02,
        TRN03__TraceAssigningEntityIdentifier: TRN03,
        TRN04__TraceAssigningEntityAdditionalIdentifier: TRN04
    };

}

// UM - 2000E
public function getHealthCareServicesReviewInformation_Type(davincipas:PASClaim claim) returns HealthCareServicesReviewInformation_Type|error? {
    string UM01 = "";
    string UM02 = "";
    string UM03 = "";
    string UM04_01 = "";
    string UM04_02 = "";
    string UM05_01 = "";
    string UM05_04 = "";
    string UM05_05 = "";
    string UM06 = "";

    davincipas:PASClaimItem[] claimItems = claim.item;
    if claimItems.length() > 0 {
        r4:Extension[]? itemExtensions = claimItems[0].extension;
        if itemExtensions is r4:Extension[] && itemExtensions.length() > 0 {
            foreach var extension in itemExtensions {
                //UM01
                if extension.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-serviceItemRequestType" {
                    r4:CodeableConceptExtension|error valueCodeableConceptExtension = trap <r4:CodeableConceptExtension>extension;
                    if valueCodeableConceptExtension is error {
                        continue;
                    }
                    else {
                        r4:CodeableConcept codeableConcept = valueCodeableConceptExtension.valueCodeableConcept;
                        r4:Coding[]? coding = codeableConcept.coding;
                        if coding is r4:Coding[] && coding.length() > 0 {
                            r4:code? code = coding[0].code;
                            if code is r4:code {
                                UM01 = code;
                            }
                        }
                    }
                }
                //UM02
                if extension.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-certificationType" {
                    r4:CodeableConceptExtension|error valueCodeableConceptExtension = trap <r4:CodeableConceptExtension>extension;
                    if valueCodeableConceptExtension is error {
                        continue;
                    }
                    else {
                        r4:CodeableConcept codeableConcept = valueCodeableConceptExtension.valueCodeableConcept;
                        r4:Coding[]? coding = codeableConcept.coding;
                        if coding is r4:Coding[] && coding.length() > 0 {
                            r4:code? code = coding[0].code;
                            if code is r4:code {
                                UM02 = code;
                            }
                        }
                    }
                }
            }
        }

        //UM03
        r4:CodeableConcept category = claimItems[0].category;
        r4:Coding[]? categoryCoding = category.coding;
        if categoryCoding is r4:Coding[] && categoryCoding.length() > 0 {
            r4:code? code = categoryCoding[0].code;
            if code is r4:code {
                UM03 = code;
            }
        }

        r4:CodeableConcept? location = claimItems[0].locationCodeableConcept;
        if location is r4:CodeableConcept {
            r4:Coding[]? locationCoding = location.coding;
            if locationCoding is r4:Coding[] && locationCoding.length() > 0 {
                //UM04_01
                r4:code? code = locationCoding[0].code;
                if code is r4:code {
                    UM04_01 = code;
                }
                //UM04_02
                r4:uri? system = locationCoding[0].system;
                if system is r4:uri {
                    if system == "https://www.nubc.org/CodeSystem/TypeOfBill" {
                        UM04_02 = "A";
                    } else if system == "https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set" {
                        UM04_02 = "B";
                    }
                }
            }

        }
    }
    davincipas:PASClaimAccident? accident = claim.accident;
    if accident is davincipas:PASClaimAccident {
        //UM05_01
        r4:CodeableConcept? accidentType = accident.'type;
        if accidentType is r4:CodeableConcept {
            r4:Coding[]? accidentTypeCoding = accidentType.coding;
            if accidentTypeCoding is r4:Coding[] && accidentTypeCoding.length() > 0 {
                r4:code? code = accidentTypeCoding[0].code;
                if code is r4:code {
                    UM05_01 = code;
                }
            }
        }

        r4:Address? locationAddress = accident.locationAddress;
        if locationAddress is r4:Address {
            //UM05_04
            string? state = locationAddress.state;
            if state is string {
                UM05_04 = state;
            }
            //UM05_05
            string? country = locationAddress.country;
            if country is string {
                UM05_05 = country;
            }
        }
    }

    //UM06
    r4:Extension[]? extensions = claim.extension;
    if extensions is r4:Extension[] {
        foreach var extension in extensions {
            if extension.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-levelOfServiceCode" {
                r4:CodeableConceptExtension|error valueCodeableConceptExtension = trap <r4:CodeableConceptExtension>extension;
                if valueCodeableConceptExtension is error {
                    continue;
                }
                else {
                    r4:CodeableConcept codeableConcept = valueCodeableConceptExtension.valueCodeableConcept;
                    r4:Coding[]? coding = codeableConcept.coding;
                    if coding is r4:Coding[] && coding.length() > 0 {
                        r4:code? code = coding[0].code;
                        if code is r4:code {
                            UM06 = code;
                        }
                    }
                }
            }
        }
    }

    UM04_HealthCareServiceLocationInformation_2000E_GType UM04 = {
        UM04_01_FacilityTypeCode: UM04_01,
        UM04_02_FacilityCodeQualifier: UM04_02
    };
    UM05_RelatedCausesInformation_2000E_GType UM05 = {
        UM05_01_RelatedCausesCode: UM05_01,
        UM05_02_RelatedCausesCode: "",
        UM05_03_RelatedCausesCode: "",
        UM05_04_StateOrProvinceCode: UM05_04,
        UM05_05_CountryCode: UM05_05
    };

    if UM01 == "" || UM02 == "" || UM04_01 == "" || UM04_02 == "" || UM05_01 == "" {
        io:println("UM01: ", UM01 + " UM02: ", UM02 + " UM03: ", UM03 + " UM04_01: ", UM04_01 + " UM04_02: ", UM04_02 + " UM05_01: ", UM05_01 + " UM05_04: ", UM05_04 + " UM05_05: ", UM05_05 + " UM06: ", UM06);
        return error(string `Following field(s) are mandatory for 'UM - 2000E' segment:
                 	Claim.item[0].extension(serviceItemRequestType).valueCodeableConcept.coding[0].code
                	Claim.item[0].extension(certificationType).valueCodeableConcept.coding[0].code
                    Claim.item[0].locationCodeableConcept.coding[0].code
                    Claim.item[0].locationCodeableConcept.coding[0].system
                    Claim.accident.type.coding[0].code
                    `);
    }

    return {
        UM01__RequestCategoryCode: UM01,
        UM02__CertificationTypeCode: UM02,
        UM03__ServiceTypeCode: UM03,
        UM04_HealthCareServiceLocationInformation_2000E: UM04,
        UM05_RelatedCausesInformation_2000E: UM05,
        UM06__LevelOfServiceCode: UM06
    };

};

// DTP - 2000E
public function getAccidentDate_Type(davincipas:PASClaim claim) returns AccidentDate_Type? {
    string DTP01 = "439";
    string DTP02 = "D8";
    string DTP03 = "";

    //DTP03
    davincipas:PASClaimAccident? accident = claim.accident;
    if accident is davincipas:PASClaimAccident {
        r4:date date = accident.date;
        DTP03 = date.toString();
    }

    if DTP03 == "" {
        return ();
    }
    return {
        DTP01__DateTimeQualifier: DTP01,
        DTP02__DateTimePeriodFormatQualifier: DTP03,
        DTP03__AccidentDate: DTP02
    };
};

// DTP - 2000E	
public function getEventDate_Type(davincipas:PASClaim claim) returns EventDate_Type? {

    boolean segmentShouldExist = false;
    string DTP01 = "AAH";
    string DTP02 = "";
    string DTP03 = "";

    //Checking whether segment is to be created
    davincipas:PASClaimSupportingInfo[]? supportingInfoArr = claim.supportingInfo;
    if supportingInfoArr is davincipas:PASClaimSupportingInfo[] {
        foreach var supportingInfo in supportingInfoArr {
            r4:CodeableConcept category = supportingInfo.category;
            r4:Coding[]? coding = category.coding;
            if coding is r4:Coding[] && coding.length() > 0 {
                r4:uri? system = coding[0].system;
                r4:code? code = coding[0].code;
                if system is r4:uri && code is r4:code {
                    if system == "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType" && code == "patientEvent" {
                        segmentShouldExist = true;

                        //DTP03 and DTP02
                        r4:date? timingDate = supportingInfo.timingDate;
                        if timingDate is r4:date {
                            DTP02 = "D8";
                            DTP03 = timingDate.toString();
                        } else {
                            DTP02 = "RD8";
                            DTP03 = "-";
                        }
                        break;
                    }
                }

            }
        }
    }
    if (segmentShouldExist == false) || (DTP03 == "" || DTP02 == "") {
        return ();
    }
    return {
        DTP01__DateTimeQualifier: DTP01,
        DTP02__DateTimePeriodFormatQualifier: DTP02,
        DTP03__ProposedOrActualEventDate: DTP03
    };

};

// DTP - 2000E
public function getAdmissionDate_Type(davincipas:PASClaim claim) returns AdmissionDate_Type? {

    boolean segmentShouldExist = false;
    string DTP01 = "435";
    string DTP02 = "";
    string DTP03 = "";

    //Checking whether segment is to be created
    davincipas:PASClaimSupportingInfo[]? supportingInfoArr = claim.supportingInfo;
    if supportingInfoArr is davincipas:PASClaimSupportingInfo[] {
        foreach var supportingInfo in supportingInfoArr {
            r4:CodeableConcept category = supportingInfo.category;
            r4:Coding[]? coding = category.coding;
            if coding is r4:Coding[] && coding.length() > 0 {
                r4:uri? system = coding[0].system;
                r4:code? code = coding[0].code;
                if system is r4:uri && code is r4:code {
                    if system == "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType" && code == "admissionDates" {
                        segmentShouldExist = true;

                        //DTP02
                        r4:date? timingDate = supportingInfo.timingDate;
                        if timingDate is r4:date {
                            DTP02 = "D8";
                        } else {
                            DTP02 = "RD8";
                        }

                        //DTP03
                        r4:Period? timingPeriod = supportingInfo.timingPeriod;
                        if timingPeriod is r4:Period {
                            r4:dateTime? timingPeriodStart = timingPeriod.'start;
                            if timingPeriodStart is r4:date {
                                DTP03 = timingPeriodStart.toString();
                            }
                        }
                        break;
                    }
                }
            }
        }
    }
    if (segmentShouldExist == false) || (DTP03 == "" || DTP02 == "") {
        return ();
    }
    return {
        DTP01__DateTimeQualifier: DTP01,
        DTP02__DateTimePeriodFormatQualifier: DTP02,
        DTP03__ProposedOrActualAdmissionDate: DTP03
    };
};

// DTP - 2000E
public function getDischargeDate_Type(davincipas:PASClaim claim) returns DischargeDate_Type? {

    boolean segmentShouldExist = false;
    string DTP01 = "096";
    string DTP02 = "D8";
    string DTP03 = "";

    //Checking whether segment is to be created
    davincipas:PASClaimSupportingInfo[]? supportingInfoArr = claim.supportingInfo;
    if supportingInfoArr is davincipas:PASClaimSupportingInfo[] {
        foreach var supportingInfo in supportingInfoArr {
            r4:CodeableConcept category = supportingInfo.category;
            r4:Coding[]? coding = category.coding;
            if coding is r4:Coding[] && coding.length() > 0 {
                r4:uri? system = coding[0].system;
                r4:code? code = coding[0].code;
                if system is r4:uri && code is r4:code {
                    if system == "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType" && code == "dischargeDates" {
                        segmentShouldExist = true;

                        //DTP03
                        r4:date? timingDate = supportingInfo.timingDate;
                        if timingDate is r4:date {
                            DTP03 = timingDate.toString();
                        }
                        break;
                    }
                }
            }
        }
    }
    if (segmentShouldExist == false) || (DTP03 == "") {
        return ();
    }
    return {
        DTP01__DateTimeQualifier: DTP01,
        DTP02__DateTimePeriodFormatQualifier: DTP02,
        DTP03__ProposedOrActualDischargeDate: DTP03
    };
};

// HI - 2000E
public function getPatientDiagnosis_Type(davincipas:PASClaim claim) returns PatientDiagnosis_Type? {

    string HI01_01 = "";
    string HI01_02 = "";
    string HI02_01 = "";
    string HI02_02 = "";
    string HI03_01 = "";
    string HI03_02 = "";
    string HI04_01 = "";
    string HI04_02 = "";
    string HI05_01 = "";
    string HI05_02 = "";
    string HI06_01 = "";
    string HI06_02 = "";
    string HI07_01 = "";
    string HI07_02 = "";
    string HI08_01 = "";
    string HI08_02 = "";
    string HI09_01 = "";
    string HI09_02 = "";
    string HI10_01 = "";
    string HI10_02 = "";
    string HI11_01 = "";
    string HI11_02 = "";
    string HI12_01 = "";
    string HI12_02 = "";

    var getHIDiagnosisTypeCode = function(davincipas:PASClaimDiagnosis diagnosis) returns r4:code? {
        r4:CodeableConcept? typeCodeableConcept = diagnosis.'type;
        if typeCodeableConcept is r4:CodeableConcept {
            r4:Coding[]? typeCoding = typeCodeableConcept.coding;
            if typeCoding is r4:Coding[] && typeCoding.length() > 0 {
                r4:code? typeCode = typeCoding[0].code;
                if typeCode is r4:code {
                    return typeCode;
                }
            }
        }
        return ();
    };

    //HIXX_01
    foreach var i in 0 ... 11 {
        davincipas:PASClaimDiagnosis[]? diagnosis = claim.diagnosis;
        if diagnosis is davincipas:PASClaimDiagnosis[] && diagnosis.length() > i {
            r4:CodeableConcept diagnosisCodeableConcept = diagnosis[i].diagnosisCodeableConcept;
            r4:Coding[]? diagnosticCoding = diagnosisCodeableConcept.coding;
            if diagnosticCoding is r4:Coding[] && diagnosticCoding.length() > 0 {
                r4:uri? system = diagnosticCoding[0].system;
                if system is r4:uri {

                    match i {
                        0 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[0]);
                            if typeCode is r4:code {
                                HI01_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI01_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        1 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[1]);
                            if typeCode is r4:code {
                                HI02_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI02_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        2 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[2]);
                            if typeCode is r4:code {
                                HI03_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI03_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        3 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[3]);
                            if typeCode is r4:code {
                                HI04_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI04_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        4 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[4]);
                            if typeCode is r4:code {
                                HI05_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI05_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        5 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[5]);
                            if typeCode is r4:code {
                                HI06_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI06_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        6 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[6]);
                            if typeCode is r4:code {
                                HI07_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI07_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        7 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[7]);
                            if typeCode is r4:code {
                                HI08_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI08_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        8 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[8]);
                            if typeCode is r4:code {
                                HI09_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI09_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        9 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[9]);
                            if typeCode is r4:code {
                                HI10_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI10_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        10 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[10]);
                            if typeCode is r4:code {
                                HI11_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI11_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                        11 => {
                            r4:code? typeCode = getHIDiagnosisTypeCode(diagnosis[11]);
                            if typeCode is r4:code {
                                HI12_01 = getHIDiagnosisTypeCodeMappingTableValue(system, typeCode);
                            } else {
                                HI12_01 = getHIDiagnosisTypeCodeMappingTableValue(system, "NOT_DEFINED");
                            }
                        }
                    }

                }
            }

        }
    }

    //HIXX_02
    foreach var j in 0 ... 11 {
        davincipas:PASClaimDiagnosis[]? diagnosis = claim.diagnosis;
        if diagnosis is davincipas:PASClaimDiagnosis[] && diagnosis.length() > j {
            r4:CodeableConcept diagnosisCode = diagnosis[j].diagnosisCodeableConcept;
            r4:Coding[]? coding = diagnosisCode.coding;
            if coding is r4:Coding[] && coding.length() > 0 {
                r4:code? code = coding[0].code;
                if code is r4:code {
                    match j {
                        0 => {
                            HI01_02 = code;
                        }
                        1 => {
                            HI02_02 = code;
                        }
                        2 => {
                            HI03_02 = code;
                        }
                        3 => {
                            HI04_02 = code;
                        }
                        4 => {
                            HI05_02 = code;
                        }
                        5 => {
                            HI06_02 = code;
                        }
                        6 => {
                            HI07_02 = code;
                        }
                        7 => {
                            HI08_02 = code;
                        }
                        8 => {
                            HI09_02 = code;
                        }
                        9 => {
                            HI10_02 = code;
                        }
                        10 => {
                            HI11_02 = code;
                        }
                        11 => {
                            HI12_02 = code;
                        }
                    }
                }
            }

        }
    }

    //Validation for mandatory fields
    if HI01_01 == "" || HI01_02 == "" || HI02_01 == "" || HI02_02 == "" || HI03_01 == "" || HI03_02 == "" ||
        HI04_01 == "" || HI04_02 == "" || HI05_01 == "" || HI05_02 == "" || HI06_01 == "" || HI06_02 == "" ||
        HI07_01 == "" || HI07_02 == "" || HI08_01 == "" || HI08_02 == "" || HI09_01 == "" || HI09_02 == "" ||
        HI10_01 == "" || HI10_02 == "" || HI11_01 == "" || HI11_02 == "" || HI12_01 == "" || HI12_02 == "" {
        log:printWarn("Following fields are mandatory for HI - 2000E segment: 'Claim.diagnosis[0...11].diagnosisCodeableConcept.coding[0].system', 	'Claim.diagnosis[0...11].diagnosisCodeableConcept.coding[0].code.' \n 'Claim.diagnosis[0...11].type.coding[0].code' should be one of following strings 'admitting','principal','patientreasonforvisit'");
        return ();
    }
    //Validation for mandatory fields
    if HI01_01 == "" && HI01_02 == "" && HI02_01 == "" && HI02_02 == "" && HI03_01 == "" && HI03_02 == "" &&
        HI04_01 == "" && HI04_02 == "" && HI05_01 == "" && HI05_02 == "" && HI06_01 == "" && HI06_02 == "" &&
        HI07_01 == "" && HI07_02 == "" && HI08_01 == "" && HI08_02 == "" && HI09_01 == "" && HI09_02 == "" &&
        HI10_01 == "" && HI10_02 == "" && HI11_01 == "" && HI11_02 == "" && HI12_01 == "" && HI12_02 == "" {
        return ();
    }

    return {
        HI01_HealthCareCodeInformation_2000E: {
            HI01_01_DiagnosisTypeCode: HI01_01,
            HI01_02_DiagnosisCode: HI01_02
        },
        HI02_HealthCareCodeInformation_2000E: {
            HI02_01_DiagnosisTypeCode: HI02_01,
            HI02_02_DiagnosisCode: HI02_02
        },
        HI03_HealthCareCodeInformation_2000E: {
            HI03_01_DiagnosisTypeCode: HI03_01,
            HI03_02_DiagnosisCode: HI03_02
        },
        HI04_HealthCareCodeInformation_2000E: {
            HI04_01_DiagnosisTypeCode: HI04_01,
            HI04_02_DiagnosisCode: HI04_02
        },
        HI05_HealthCareCodeInformation_2000E: {
            HI05_01_DiagnosisTypeCode: HI05_01,
            HI05_02_DiagnosisCode: HI05_02
        },
        HI06_HealthCareCodeInformation_2000E: {
            HI06_01_DiagnosisTypeCode: HI06_01,
            HI06_02_DiagnosisCode: HI06_02
        },
        HI07_HealthCareCodeInformation_2000E: {
            HI07_01_DiagnosisTypeCode: HI07_01,
            HI07_02_DiagnosisCode: HI07_02
        },
        HI08_HealthCareCodeInformation_2000E: {
            HI08_01_DiagnosisTypeCode: HI08_01,
            HI08_02_DiagnosisCode: HI08_02
        },
        HI09_HealthCareCodeInformation_2000E: {
            HI09_01_DiagnosisTypeCode: HI09_01,
            HI09_02_DiagnosisCode: HI09_02
        },
        HI10_HealthCareCodeInformation_2000E: {
            HI10_01_DiagnosisTypeCode: HI10_01,
            HI10_02_DiagnosisCode: HI10_02
        },
        HI11_HealthCareCodeInformation_2000E: {
            HI11_01_DiagnosisTypeCode: HI11_01,
            HI11_02_DiagnosisCode: HI11_02
        },
        HI12_HealthCareCodeInformation_2000E: {
            HI12_01_DiagnosisTypeCode: HI12_01,
            HI12_02_DiagnosisCode: HI12_02
        }
    };

};

// CL1 - 2000E
public function getInstitutionalClaimCode_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns InstitutionalClaimCode_Type? {

    string CL101 = "";
    string CL102 = "";
    string CL103 = "";
    string CL104 = "";

    r4:Reference? encounterReference = ();

    //Get the enconter resource
    davincipas:PASClaimSupportingInfo[]? supportingInfoArr = claim.supportingInfo;
    if supportingInfoArr is davincipas:PASClaimSupportingInfo[] {
        foreach var supportingInfo in supportingInfoArr {
            r4:CodeableConcept category = supportingInfo.category;
            r4:Coding[]? coding = category.coding;
            if coding is r4:Coding[] && coding.length() > 0 {
                r4:uri? system = coding[0].system;
                r4:code? code = coding[0].code;
                if system is r4:uri && code is r4:code {
                    if system == "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType" && code == "institutionalEncounter" {
                        encounterReference = supportingInfo.valueReference;
                        break;
                    }
                }
            }
        }
    }
    if encounterReference is r4:Reference {
        anydata|error encounterProfile = getProfileFromBundle(bundle, encounterReference, "Encounter");
        if encounterProfile is anydata {
            davincipas:PASEncounter|error encounterResource = trap <davincipas:PASEncounter>encounterProfile;
            if encounterResource is davincipas:PASEncounter {

                //CL101
                r4:CodeableConcept[] encounterTypes = encounterResource.'type;
                if encounterTypes.length() > 0 {
                    r4:CodeableConcept encounterType = encounterTypes[0];
                    r4:Coding[]? coding = encounterType.coding;
                    if coding is r4:Coding[] && coding.length() > 0 {
                        r4:code? code = coding[0].code;
                        if code is r4:code {
                            CL101 = code;
                        }
                    }
                }

                //CL102
                davincipas:PASEncounterHospitalization? hospitalization = encounterResource.hospitalization;
                if hospitalization is davincipas:PASEncounterHospitalization {
                    r4:CodeableConcept? admitSource = hospitalization.admitSource;
                    if admitSource is r4:CodeableConcept {
                        r4:Coding[]? coding = admitSource.coding;
                        if coding is r4:Coding[] && coding.length() > 0 {
                            r4:code? code = coding[0].code;
                            if code is r4:code {
                                CL102 = code;
                            }
                        }
                    }
                }

                r4:Extension[]? extensionArr = encounterResource.extension;
                if extensionArr is r4:Extension[] {
                    foreach var extension in extensionArr {
                        r4:Extension|error extensionData = trap <r4:CodeableConceptExtension>extension;
                        if extensionData is r4:CodeableConceptExtension {
                            //CL103
                            if extensionData.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-patientStatus" {
                                r4:CodeableConcept valueCodeableConcept = extensionData.valueCodeableConcept;
                                r4:Coding[]? coding = valueCodeableConcept.coding;
                                if coding is r4:Coding[] && coding.length() > 0 {
                                    r4:code? code = coding[0].code;
                                    if code is r4:code {
                                        CL103 = code;
                                    }
                                }
                            }
                            //CL104
                            if extensionData.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-nursingHomeResidentialStatus" {
                                r4:CodeableConcept valueCodeableConcept = extensionData.valueCodeableConcept;
                                r4:Coding[]? coding = valueCodeableConcept.coding;
                                if coding is r4:Coding[] && coding.length() > 0 {
                                    r4:code? code = coding[0].code;
                                    if code is r4:code {
                                        CL104 = code;
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
    } else {
        return ();
    }
    if CL101 == "" && CL102 == "" && CL103 == "" && CL104 == "" {
        return ();
    }
    return {
        CL101__AdmissionTypeCode: CL101,
        CL102__AdmissionSourceCode: CL102,
        CL103__PatientStatusCode: CL103,
        CL104__NursingHomeResidentialStatusCode: CL104
    };
}

// MSG - 2000E
public function getMessageText_Type(davincipas:PASClaim claim) returns MessageText_Type? {

    string MSG01 = "";
    davincipas:PASClaimSupportingInfo[]? supportingInfoArr = claim.supportingInfo;
    if supportingInfoArr is davincipas:PASClaimSupportingInfo[] {
        foreach var supportingInfo in supportingInfoArr {
            r4:CodeableConcept category = supportingInfo.category;
            r4:Coding[]? coding = category.coding;
            if coding is r4:Coding[] && coding.length() > 0 {
                r4:uri? system = coding[0].system;
                r4:code? code = coding[0].code;
                if system is r4:uri && code is r4:code {
                    if system == "http://hl7.org/fhir/us/davinci-pas/CodeSystem-PASSupportingInfoType" && code == "freeFormMessage" {
                        string? value = supportingInfo.valueString;
                        if value is string {
                            MSG01 = value;
                        }
                        break;
                    }
                }
            }
        }
    }
    if MSG01 == "" {
        return ();
    }
    return {
        MSG01__FreeFormMessageText: MSG01
    };
}

// NM1 - 2010EA
public function getPatientEventProviderName_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns PatientEventProviderName_Type? {

    string NM101 = "";
    string NM102 = "";
    string NM103 = "";
    string NM104 = "";
    string NM105 = "";
    string NM106 = "";
    string NM107 = "";
    string NM108 = "";
    string NM109 = "";

    r4:DomainResource? pointedResource = ();

    //Util function getClaimCareTeamProviderResourceType() is not used here as Claim.careTeam[n].role.coding[0].code needs to be accessed.
    davincipas:PASClaimCareTeam[]? careTeamArr = claim.careTeam;
    if careTeamArr is davincipas:PASClaimCareTeam[] {
        foreach var careTeam in careTeamArr {
            r4:Reference resourceRef = careTeam.provider;
            anydata|error resourceProfile1 = getProfileFromBundle(bundle, resourceRef, "Organization");
            if resourceProfile1 is anydata {
                uscore501:USCoreOrganizationProfile|error organizationResource = trap <uscore501:USCoreOrganizationProfile>resourceProfile1;
                if organizationResource is uscore501:USCoreOrganizationProfile {
                    pointedResource = organizationResource;
                    //NM101
                    r4:CodeableConcept? role = careTeam.role;
                    if role is r4:CodeableConcept {
                        r4:Coding[]? coding = role.coding;
                        if coding is r4:Coding[] && coding.length() > 0 {
                            r4:code? code = coding[0].code;
                            if code is r4:code {
                                NM101 = code;
                            }
                        }
                    }
                    break;
                }
            } else {
                anydata|error resourceProfile2 = getProfileFromBundle(bundle, resourceRef, "Practitioner");
                if resourceProfile2 is anydata {
                    davincipas:PASPractitioner|error practitionerResource = trap <davincipas:PASPractitioner>resourceProfile2;
                    if practitionerResource is davincipas:PASPractitioner {
                        pointedResource = practitionerResource;
                        //NM101
                        r4:CodeableConcept? role = careTeam.role;
                        if role is r4:CodeableConcept {
                            r4:Coding[]? coding = role.coding;
                            if coding is r4:Coding[] && coding.length() > 0 {
                                r4:code? code = coding[0].code;
                                if code is r4:code {
                                    NM101 = code;
                                }
                            }
                        }
                        break;
                    }
                }
            }
        }
    }

    if pointedResource is davincipas:PASPractitioner {
        //NM102
        NM102 = "1";

        //NM103
        r4:HumanName[] name = pointedResource.name;
        if name.length() > 0 {
            //NM103
            string? family = name[0].family;
            if family is string {
                NM103 = family;
            }

            //NM104
            string[]? given = name[0].given;
            if given is string[] && given.length() > 0 {
                NM104 = given[0];
            }
            //NM105
            if given is string[] && given.length() > 1 {
                NM105 = given[1];
            }
            //NM106
            string[]? prefix = name[0].prefix;
            if prefix is string[] && prefix.length() > 0 {
                NM106 = prefix[0];
            }
            //NM107
            string[]? suffix = name[0].suffix;
            if suffix is string[] && suffix.length() > 0 {
                NM107 = suffix[0];
            }

            //NM108
            davincipas:ProfileIdentifier[] identifier = pointedResource.identifier;
            if identifier.length() > 0 {
                r4:CodeableConcept? identifierType = identifier[0].'type;
                if identifierType is r4:CodeableConcept {
                    r4:Coding[]? coding = identifierType.coding;
                    if coding is r4:Coding[] && coding.length() > 0 {
                        r4:code? code = coding[0].code;
                        if code is r4:code {
                            match code {
                                "EN" => {
                                    NM108 = "24";
                                }
                                "SB" => {
                                    NM108 = "34";
                                }
                                "46" => {
                                    NM108 = "46";
                                }
                                "NPI" => {
                                    NM108 = "XX";
                                }
                            }
                        }
                    }
                }
            }

            //NM109
            string? value = identifier[0].value;
            if value is string {
                NM109 = value;
            }
        }
    }
    if pointedResource is uscore501:USCoreOrganizationProfile {
        //NM102
        NM102 = "2";

        //NM103
        NM103 = pointedResource.name;

        //NM108
        uscore501:USCoreOrganizationProfileIdentifier[]? identifier = pointedResource.identifier;
        if identifier is uscore501:USCoreOrganizationProfileIdentifier[] && identifier.length() > 0 {
            r4:CodeableConcept? identifierType = identifier[0].'type;
            if identifierType is r4:CodeableConcept {
                r4:Coding[]? coding = identifierType.coding;
                if coding is r4:Coding[] && coding.length() > 0 {
                    r4:code? code = coding[0].code;
                    if code is r4:code {
                        match code {
                            "EN" => {
                                NM108 = "24";
                            }
                            "SB" => {
                                NM108 = "34";
                            }
                            "46" => {
                                NM108 = "46";
                            }
                            "NPI" => {
                                NM108 = "XX";
                            }
                        }
                    }
                }
            }
            //NM109
            string? value = identifier[0].value;
            if value is string {
                NM109 = value;
            }
        }
    }

    if NM101 == "" && NM102 == "" {
        return ();
    }
    if NM101 == "" || NM102 == "" {
        log:printWarn("Followin fields are mandatory for NM1 - 2010EA segment; \n 'Claim.careTeam[n].role.coding[0].code','Claim.careTeam[n].provider' ");
        return ();
    }

    return {
        NM101__EntityIdentifierCode: NM101,
        NM102__EntityTypeQualifier: NM102,
        NM103__PatientEventProviderLastOrOrganizationName: NM103,
        NM104__PatientEventProviderFirstName: NM104,
        NM105__PatientEventProviderMiddleName: NM105,
        NM106__PatientEventProviderNamePrefix: NM106,
        NM107__PatientEventProviderNameSuffix: NM107,
        NM108__IdentificationCodeQualifier: NM108,
        NM109__PatientEventProviderIdentifier: NM109
    };
}

// REF - 2010EA
public function getPatientEventProviderSupplementalInformation_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns PatientEventProviderSupplementalInformation_Type? {
    string REF01 = "";
    string REF02 = "";
    string REF03 = "";

    r4:DomainResource? pointedResource = ();

    pointedResource = getClaimCareTeamProviderResourceType(bundle, claim);

    if pointedResource is davincipas:PASPractitioner {

        davincipas:ProfileIdentifier[] identifier = pointedResource.identifier;
        if identifier.length() > 1 {
            //REF01
            r4:CodeableConcept? identifierType = identifier[1].'type;
            if identifierType is r4:CodeableConcept {
                r4:Coding[]? coding = identifierType.coding;
                if coding is r4:Coding[] && coding.length() > 0 {
                    r4:code? code = coding[0].code;
                    if code is r4:code {
                        match code {
                            "SL" => {
                                REF01 = "0B";
                            }
                            "FI" => {
                                REF01 = "1J";
                            }
                            "EN" => {
                                REF01 = "EI";
                            }
                            "N5" => {
                                REF01 = "N5";
                            }
                            "N7" => {
                                REF01 = "N7";
                            }
                            "SB" => {
                                REF01 = "SY";
                            }
                            "ZH" => {
                                REF01 = "ZH";
                            }

                        }
                    }
                }

            }
            //REF02
            string? value = identifier[1].value;
            if value is string {
                REF02 = value;
            }

        }
    }

    //TODO - REF03

    if pointedResource is uscore501:USCoreOrganizationProfile {

        uscore501:USCoreOrganizationProfileIdentifier[]? identifier = pointedResource.identifier;
        if identifier is uscore501:USCoreOrganizationProfileIdentifier[] && identifier.length() > 1 {
            //REF01
            r4:CodeableConcept? identifierType = identifier[1].'type;
            if identifierType is r4:CodeableConcept {
                r4:Coding[]? coding = identifierType.coding;
                if coding is r4:Coding[] && coding.length() > 0 {
                    r4:code? code = coding[0].code;
                    if code is r4:code {
                        match code {
                            "SL" => {
                                return ();
                            }
                            "FI" => {
                                REF01 = "1J";
                            }
                            "EN" => {
                                REF01 = "EI";
                            }
                            "N5" => {
                                REF01 = "N5";
                            }
                            "N7" => {
                                REF01 = "N7";
                            }
                            "SB" => {
                                REF01 = "SY";
                            }
                            "ZH" => {
                                REF01 = "ZH";
                            }

                        }
                    }
                }

            }
            //REF02
            string? value = identifier[1].value;
            if value is string {
                REF02 = value;
            }

        }

    }
    if REF01 == "" && REF02 == "" {
        return ();
    }
    if REF01 == "" || REF02 == "" {
        log:printWarn("Followin fields are mandatory for REF - 2010EA segment; \n 'Practitioner.identifier[1].type.coding[0].code | Organization.identifier[1].type.coding[0].code','Practitioner.identifier[1].value | Organization.identifier[1].value' ");
        return ();
    }
    return {
        REF01__ReferenceIdentificationQualifier: REF01,
        REF02__PatientEventProviderSupplementalIdentifier: REF02,
        REF03__LicenseNumberStateCode: REF03
    };

}

// N3 - 2010EA
public function getPatientEventProviderAddress_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns PatientEventProviderAddress_Type? {
    string N301 = "";
    string N302 = "";

    r4:DomainResource? pointedResource = ();
    pointedResource = getClaimCareTeamProviderResourceType(bundle, claim);

    r4:Address[]? address;

    if pointedResource is davincipas:PASPractitioner {
        address = pointedResource.address;
    } else if pointedResource is uscore501:USCoreOrganizationProfile {
        address = pointedResource.address;
    } else {
        address = [];
    }

    if address is r4:Address[] && address.length() > 0 {
        r4:Address address1 = address[0];
        string[]? line = address1.line;
        if line is string[] && line.length() > 1 {
            //N301
            N301 = line[1];
            if line.length() > 2 {
                //N302
                N302 = line[2];
            }
        }
    }

    if N301 == "" {
        return ();
    }
    return {
        N301__PatientEventProviderAddressLine: N301,
        N302__PatientEventProviderAddressLine: N302
    };
}

// N4 - 2010EA
public function getPatientEventProviderCityStateZIPCode_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns PatientEventProviderCityStateZIPCode_Type? {
    string N401 = "";
    string N402 = "";
    string N403 = "";
    string N404 = "";
    string N407 = "";

    r4:DomainResource? pointedResource = ();
    pointedResource = getClaimCareTeamProviderResourceType(bundle, claim);

    r4:Address[]? address;
    if pointedResource is davincipas:PASPractitioner {
        address = pointedResource.address;
    } else if pointedResource is uscore501:USCoreOrganizationProfile {
        address = pointedResource.address;
    } else {
        address = [];
    }

    if address is r4:Address[] && address.length() > 0 {
        //N401
        string? city = address[0].city;
        if city is string {
            N401 = city;
        }
        //N402
        string? state = address[0].state;
        if state is string {
            N402 = state;
        }
        //N403
        string? postalCode = address[0].postalCode;
        if postalCode is string {
            N403 = postalCode;
        }
        //N404
        string? country = address[0].country;
        if country is string {
            N404 = country;
        }
        //N407
        string? district = address[0].district;
        if district is string {
            N407 = district;
        }
    }
    if N401 == "" {
        return ();
    }
    return {
        N401__PatientEventProviderCityName: N401,
        N402__PatientEventProviderStateCode: N402,
        N403__PatientEventProviderPostalZoneOrZIPCode: N403,
        N404__CountryCode: N404,
        N407__CountrySubdivisionCode: N407
    };
}

// PER - 2010EA
public function getPatientEventProviderContactInformation_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns PatientEventProviderContactInformation_Type? {
    string PER01 = "IC";
    string PER02 = "";
    string PER04 = "";
    string PER05 = "";
    string PER06 = "";
    string PER07 = "";
    string PER08 = "";

    r4:DomainResource? pointedResource = ();
    pointedResource = getClaimCareTeamProviderResourceType(bundle, claim);

    //PER02
    if pointedResource is uscore501:USCoreOrganizationProfile {
        uscore501:USCoreOrganizationProfileContact[]? contact = pointedResource.contact;
        if contact is uscore501:USCoreOrganizationProfileContact[] {
            r4:HumanName? name = contact[0].name;
            if name is r4:HumanName {
                string? text = name.text;
                if text is string {
                    PER02 = text;
                }
            }
        }
    }

    //Telecom for both Practitioner and Organisation is placed in the same variable so the methods are reused for booth instances.
    r4:ContactPoint[]? telecom = [];
    if pointedResource is davincipas:PASPractitioner {
        telecom = pointedResource.telecom;
    } else if pointedResource is uscore501:USCoreOrganizationProfile {
        uscore501:USCoreOrganizationProfileContact[]? profileContact = pointedResource.contact;
        if profileContact is uscore501:USCoreOrganizationProfileContact[] {
            r4:ContactPoint[]? orgTelecom = profileContact[0].telecom;
            if orgTelecom is r4:ContactPoint[] && orgTelecom.length() > 0 {
                telecom = orgTelecom;
            }
        }
    }
    //PER04
    if telecom is r4:ContactPoint[] && telecom.length() > 0 {
        r4:ContactPointSystem? system = telecom[0].system;
        string? systemValue = telecom[0].value;

        if systemValue is string {
            PER04 = systemValue;

            if system is r4:ContactPointSystem && system == r4:phone {
                string extension = "";
                // Using regex to split the phone number and extension
                string[] parts = regex:split(systemValue, "ext\\.");
                if parts.length() > 1 {
                    extension = parts[1].trim();
                    PER05 = "EX";
                    PER06 = extension;
                }

            }
        }

    }
    //PER05
    if PER05 !== "EX" {
        if telecom is r4:ContactPoint[] && telecom.length() > 1 {
            r4:ContactPointSystem? system = telecom[1].system;
            if system is r4:ContactPointSystem {
                match system {
                    r4:phone => {
                        PER05 = "TE";
                    }
                    r4:fax => {
                        PER05 = "FX";
                    }
                    r4:email => {
                        PER05 = "EM";
                    }
                    r4:pager => {
                        PER05 = "TE";
                    }
                    r4:url => {
                        PER05 = "UR";
                    }
                    r4:sms => {
                        PER05 = "TE";
                    }
                    _ => {
                        PER05 = "cannot be translated"; //Add Error handling
                    }
                }
            }
        }
    }
    //PER06
    if PER05 !== "EX" {
        if telecom is r4:ContactPoint[] && telecom.length() > 1 {
            r4:ContactPointSystem? system = telecom[1].system;
            string? systemValue = telecom[1].value;

            if systemValue is string {
                PER06 = systemValue;

                if system is r4:ContactPointSystem && system == r4:phone {
                    string extension = "";
                    // Use regex to split the phone number and extension
                    string[] parts = regex:split(systemValue, "ext\\.");
                    if parts.length() > 1 {
                        extension = parts[1].trim();

                        PER07 = "EX";
                        PER08 = extension;
                    }
                }
            }
        }

    }
    //PER07
    if PER05 !== "TE" {
        if telecom is r4:ContactPoint[] && telecom.length() > 2 {
            r4:ContactPointSystem? system = telecom[2].system;
            if system is r4:ContactPointSystem {
                if system == r4:phone {
                    PER07 = "TE";
                } else if system == r4:fax {
                    PER07 = "FX";
                } else if system == r4:email {
                    PER07 = "EM";
                } else if system == r4:pager {
                    PER07 = "TE";
                } else if system == r4:url {
                    PER07 = "UR";
                } else if system == r4:sms {
                    PER07 = "TE";
                } else {
                    PER07 = "cannot be translated"; //Add Error handling
                }
            }
        }
    }
    //PER08
    if PER07 !== "EX" {
        if telecom is r4:ContactPoint[] && telecom.length() > 2 {
            string? systemValue = telecom[2].value;
            if systemValue is string {
                PER08 = systemValue;
            }
        }
    }
    if PER02 == "" && PER04 == "" && PER05 == "" && PER06 == "" && PER07 == "" && PER08 == "" {
        return ();
    }
    return {
        PER01__ContactFunctionCode: PER01,
        PER02__PatientEventProviderContactName: PER02,
        PER04__PatientEventProviderContactCommunicationsNumber: PER04,
        PER05__CommunicationNumberQualifier: PER05,
        PER06__PatientEventProviderContactCommunicationsNumber: PER06,
        PER07__CommunicationNumberQualifier: PER07,
        PER08__PatientEventProviderContactCommunicationsNumber: PER08
    };
}

// PRV - 2010EA
public function getPatientEventProviderInformation_Type(r4:Bundle bundle, davincipas:PASClaim claim) returns PatientEventProviderInformation_Type? {

    string PRV01 = "";
    string PRV02 = "";
    string PRV03 = "";

    davincipas:PASClaimCareTeam[]? careTeamArr = claim.careTeam;
    if careTeamArr is davincipas:PASClaimCareTeam[] {
        foreach var careTeam in careTeamArr {
            r4:Reference resourceRef = careTeam.provider;
            anydata|error resourceProfile2 = getProfileFromBundle(bundle, resourceRef, "Practitioner");
            if resourceProfile2 is anydata {
                davincipas:PASPractitioner|error practitionerResource = trap <davincipas:PASPractitioner>resourceProfile2;
                if practitionerResource is davincipas:PASPractitioner {
                    //PRV01
                    r4:CodeableConcept? role = careTeam.role;
                    if role is r4:CodeableConcept {
                        r4:Coding[]? coding = role.coding;
                        if coding is r4:Coding[] && coding.length() > 0 {
                            r4:code? code = coding[0].code;
                            if code is r4:code {
                                PRV01 = code;
                            }
                        }
                    }
                    //PRV02
                    PRV02 = "PXC";
                    //PRV03
                    r4:CodeableConcept? qualification = careTeam.qualification;
                    if qualification is r4:CodeableConcept {
                        r4:Coding[]? coding = qualification.coding;
                        if coding is r4:Coding[] && coding.length() > 0 {
                            r4:code? code = coding[0].code;
                            if code is r4:code {
                                PRV03 = code;
                            }
                        }
                    }
                }
            }
        }
    }
    if PRV01 == "" && PRV03 == "" {
        return ();
    }
    if PRV01 == "" || PRV03 == "" {
        log:printWarn("Followin fields are mandatory for PRV - 2010EA segment; \n 'Claim.careTeam[n].role.coding[0].code','Claim.careTeam[n].qualification.coding[0].code' ");
        return ();
    }
    return {
        PRV01__ProviderCode: PRV01,
        PRV02__ReferenceIdentificationQualifier: PRV02,
        PRV03__ProviderTaxonomyCode: PRV03
    };
}

//----------------------------------utili functions--------------------------------------------
public function getProfileFromBundle(r4:Bundle bundle, r4:Reference id, string resource_type) returns anydata|error {

    //Gets the reference from the claim
    string ref = "";
    if id.reference is string {
        string? nillableRef = id.reference;
        if nillableRef is string {
            ref = nillableRef;
        }
    }

    anydata profileFromBundle = {};

    if bundle.entry is r4:BundleEntry[] {
        r4:BundleEntry[]? entries = bundle.entry;
        if entries is r4:BundleEntry[] {
            foreach var entry in entries {
                r4:BundleEntry? bundleEntry = entry;
                if bundleEntry is r4:BundleEntry {
                    if bundleEntry?.'resource is anydata {
                        r4:DomainResource resourceData = <r4:DomainResource>bundleEntry?.'resource;
                        if resourceData.resourceType == resource_type && resourceData.id == ref {
                            profileFromBundle = resourceData;
                            return profileFromBundle;
                        }
                    }
                }
            }
        }
    }

    return error("Resource not found");

};

public function getPatientFromCoverage(r4:Bundle bundle, davincipas:PASClaim claim) returns uscore501:USCorePatientProfile|error {

    //Reference from claim resource pointing to the coverage resource
    r4:Reference id = claim.insurance[0].coverage;

    //Search for the coverage profile
    anydata|error profile = getProfileFromBundle(bundle, id, "Coverage");
    if profile is anydata {
        carinbb200:C4BBCoverage coverageProfile = <carinbb200:C4BBCoverage>profile;

        if coverageProfile.resourceType == "Coverage" && coverageProfile.id == id.reference {
            //Reference from coverage profile pointing to the patient profile
            r4:Reference? subscriberReference = coverageProfile.subscriber;
            if subscriberReference is r4:Reference {
                //Search for the Patient profile
                anydata|error patient = getProfileFromBundle(bundle, subscriberReference, "Patient");
                if patient is anydata {
                    uscore501:USCorePatientProfile patientProfile = <uscore501:USCorePatientProfile>patient;

                    if patientProfile.resourceType == "Patient" && patientProfile.id == subscriberReference.reference {
                        return patientProfile;
                    }
                }
            }

        }

    }
    return error("Patient Resource not found");
};

//HL - 2000D
public function loop_2000Dstatus(r4:Bundle bundle, davincipas:PASClaim claim) returns boolean {

    //Reference from claim resource pointing to the coverage resource
    r4:Reference id = claim.insurance[0].coverage;

    //Search for the coverage profile
    anydata|error profile = getProfileFromBundle(bundle, id, "Coverage");
    if profile is anydata {
        carinbb200:C4BBCoverage coverageProfile = <carinbb200:C4BBCoverage>profile;

        if coverageProfile.resourceType == "Coverage" && coverageProfile.id == id.reference {
            r4:CodeableConcept relationship = coverageProfile.relationship;
            r4:Coding[]? coding = relationship.coding;
            if coding is r4:Coding[] && coding.length() > 0 {
                r4:code? code = coding[0].code;
                if code is r4:code {
                    if code != "self" {
                        return true;
                    }
                }
            }
        }

    }
    return false;
};

public function getHIDiagnosisTypeCodeMappingTableValue(string system, string code) returns string {
    match [system, code] {
        ["http://hl7.org/fhir/sid/icd-10-cm", "admitting"] => {
            return "ABJ";
        }
        ["http://hl7.org/fhir/sid/icd-10-cm", "principal"] => {
            return "ABK";
        }
        ["http://hl7.org/fhir/sid/icd-10-cm", "patientreasonforvisit"] => {
            return "APR";
        }
        ["http://hl7.org/fhir/sid/icd-10-cm", "NOT_DEFINED"] => {
            return "ABF";
        }
        ["http://terminology.hl7.org/CodeSystem/icd9cm", "admitting"] => {
            return "BJ";
        }
        ["http://terminology.hl7.org/CodeSystem/icd9cm", "principal"] => {
            return "BK";
        }
        ["http://terminology.hl7.org/CodeSystem/icd9cm", "patientreasonforvisit"] => {
            return "PR";
        }
        ["http://terminology.hl7.org/CodeSystem/icd9cm", "NOT_DEFINED"] => {
            return "BF";
        }
        ["https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/AcuteInpatientPPS/MS-DRG-Classifications-and-Software", "admitting"] => {
            return "DRG";
        }
        ["https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/AcuteInpatientPPS/MS-DRG-Classifications-and-Software", "principal"] => {
            return "DRG";
        }
        ["https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/AcuteInpatientPPS/MS-DRG-Classifications-and-Software", "patientreasonforvisit"] => {
            return "DRG";
        }
        ["https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/AcuteInpatientPPS/MS-DRG-Classifications-and-Software", "NOT_DEFINED"] => {
            return "DRG";
        }
        ["http://uri.hddaccess.com/cs/apdrg", "admitting"] => {
            return "DRG";
        }
        ["http://uri.hddaccess.com/cs/apdrg", "principal"] => {
            return "DRG";
        }
        ["http://uri.hddaccess.com/cs/apdrg", "patientreasonforvisit"] => {
            return "DRG";
        }
        ["http://uri.hddaccess.com/cs/apdrg", "NOT_DEFINED"] => {
            return "DRG";
        }
        ["http://uri.hddaccess.com/cs/aprdrg", "admitting"] => {
            return "DRG";
        }
        ["http://uri.hddaccess.com/cs/aprdrg", "principal"] => {
            return "DRG";
        }
        ["http://uri.hddaccess.com/cs/aprdrg", "patientreasonforvisit"] => {
            return "DRG";
        }
        ["http://uri.hddaccess.com/cs/aprdrg", "NOT_DEFINED"] => {
            return "DRG";
        }
        _ => {
            return "";
        }

    }
}

public function getClaimCareTeamProviderResourceType(r4:Bundle bundle, davincipas:PASClaim claim) returns r4:DomainResource? {

    r4:DomainResource? pointedResource = ();

    davincipas:PASClaimCareTeam[]? careTeamArr = claim.careTeam;
    if careTeamArr is davincipas:PASClaimCareTeam[] {
        foreach var careTeam in careTeamArr {
            r4:Reference resourceRef = careTeam.provider;
            anydata|error resourceProfile1 = getProfileFromBundle(bundle, resourceRef, "Organization");
            if resourceProfile1 is anydata {
                uscore501:USCoreOrganizationProfile|error organizationResource = trap <uscore501:USCoreOrganizationProfile>resourceProfile1;
                if organizationResource is uscore501:USCoreOrganizationProfile {
                    pointedResource = organizationResource;
                    return pointedResource;
                }
            } else {
                anydata|error resourceProfile2 = getProfileFromBundle(bundle, resourceRef, "Practitioner");
                if resourceProfile2 is anydata {
                    davincipas:PASPractitioner|error practitionerResource = trap <davincipas:PASPractitioner>resourceProfile2;
                    if practitionerResource is davincipas:PASPractitioner {
                        pointedResource = practitionerResource;
                        return pointedResource;
                    }
                }
            }
        }
    }
    return ();

}

// Process r4:instance type data
public function getTimestamp(r4:instant? timestamp) returns string {

    if timestamp is r4:instant {
        return timestamp.toBalString();
    } else {
        return "";
    }
}

// Process r4:Identifier type data
public function getIdentifierValue(r4:Identifier? identifier) returns string {

    if identifier is r4:Identifier {
        return identifier.value ?: "";
    } else {
        return "";
    }
}

// HL - 2000F
public function getServiceLevel_Type() returns ServiceLevel_Type {
    return {
        HL01__HierarchicalIDNumber: "",
        HL02__HierarchicalParentIDNumber: "",
        HL03__HierarchicalLevelCode: "SS",
        HL04__HierarchicalChildCode: ""
    };
}

// TRN - 2000F
public function getServiceTraceNumber_Type(davincipas:PASClaim claim) returns ServiceTraceNumber_Type {
    return {
        TRN01__TraceTypeCode: "1",
        TRN02__ServiceTraceNumber: "getIdentifierExtensionValue(claim)",
        TRN03__TraceAssigningEntityIdentifier: "getIdentifierExtensionAssignerValue(claim)",
        TRN04__TraceAssigningEntityAdditionalIdentifier: "getExtensionExtension(claim)"
    };
}

public function getIdentifierExtensionValue(davincipas:PASClaim claim) returns string {
    r4:IdentifierExtension|() extension = getIdentifierExtension(claim);
    if extension is r4:IdentifierExtension {
        return extension.valueIdentifier.value is string ? <string>extension.valueIdentifier.value : "";
    }
    return "";
}

public function getIdentifierExtensionAssignerValue(davincipas:PASClaim claim) returns string {
    r4:IdentifierExtension|() extension = getIdentifierExtension(claim);
    if extension is r4:IdentifierExtension {
        return extension.valueIdentifier.assigner?.reference is string ? <string>extension.valueIdentifier.value : "";
    }
    return "";
}

public function getIdentifierExtension(davincipas:PASClaim claim) returns r4:IdentifierExtension|() {
    davincipas:PASClaimItem[] itemList = claim.item;

    foreach var item in itemList {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var extension in extensions {
                if extension is r4:IdentifierExtension && extension.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-itemTraceNumber" {
                    return (<r4:IdentifierExtension>extension);
                }
            }
        }
    }
    return;
}

public function getExtensionExtension(davincipas:PASClaim claim) returns string {
    davincipas:PASClaimItem[] itemList = claim.item;

    foreach var item in itemList {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var extension in extensions {
                if extension is r4:ExtensionExtension && extension.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-itemTraceNumber" {
                    r4:ExtensionExtension extensionExtension = <r4:ExtensionExtension>extension;
                    r4:Extension[]? extensionResult = extensionExtension.extension;
                    if extensionResult is r4:Extension[] {
                        foreach var ex in extensionResult {
                            if ex is r4:StringExtension {
                                r4:StringExtension sx = ex;
                                if sx.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-identifierSubDepartment" {
                                    return ex.valueString;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return "";
}

// REF - 2000F - authorization
public function getPreviousReviewAuthorizationNumber_Type(davincipas:PASClaim claim) returns PreviousReviewAuthorizationNumber_Type {
    return {
        REF01__ReferenceIdentificationQualifier: "BB",
        REF02__PreviousReviewAuthorizationNumber: getAuthorizationNumberExtension(claim)
    };
}

public function getAuthorizationNumberExtension(davincipas:PASClaim claim) returns string {
    davincipas:PASClaimItem[] itemList = claim.item;

    foreach var item in itemList {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var extension in extensions {
                if extension is r4:StringExtension && extension.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-authorizationNumber" {
                    return extension.valueString;
                }
            }
        }
    }
    return "";
}

// REF - 2000F - administration
public function getPreviousReviewAdministrativeReferenceNumber_Type(davincipas:PASClaim claim) returns PreviousReviewAdministrativeReferenceNumber_Type {
    return {
        REF01__ReferenceIdentificationQualifier: "NT",
        REF02__PreviousAdministrativeReferenceNumber: getAdministrationNumberExtension(claim)
    };
}

public function getAdministrationNumberExtension(davincipas:PASClaim claim) returns string {
    davincipas:PASClaimItem[] itemList = claim.item;

    foreach var item in itemList {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var extension in extensions {
                if extension is r4:StringExtension && extension.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-administrationReferenceNumber" {
                    return extension.valueString;
                }
            }
        }
    }
    return "";
}

// DTP - 2000F
public function getServiceDate_Type(davincipas:PASClaim claim) returns ServiceDate_Type {

    string periodFormatQualifier = "RD8";
    string serviceDate = "-";
    foreach var item in claim.item {
        if item.servicedDate is r4:date {
            periodFormatQualifier = "D8";
            serviceDate = <string>item.servicedDate;
        }
    }

    return {
        DTP01__DateTimeQualifier: "472",
        DTP02__DateTimePeriodFormatQualifier: periodFormatQualifier,
        DTP03__ProposedOrActualServiceDate: serviceDate
    };
}

// SV1 - 2000F
public function getProfessionalService_Type(davincipas:PASClaim claim) returns ProfessionalService_Type|() {

    boolean isCodeProfessionalCode = false;
    r4:CodeableConcept typeCodeableConcept = claim.'type;
    r4:Coding[]? codings = typeCodeableConcept.coding;
    if codings is r4:Coding[] {
        foreach var coding in codings {
            if coding.code == "professional" {
                isCodeProfessionalCode = true;
            }
        }
    }

    if isCodeProfessionalCode {
        return {
            SV101_CompositeMedicalProcedureIdentifier_2000F: getSV101_CompositeMedicalProcedureIdentifier_2000F_GType(claim),
            SV102__ServiceLineAmount: getSV102__ServiceLineAmount(claim),
            SV103__UnitOrBasisForMeasurementCode: getSV103__UnitOrBasisForMeasurementCode(claim),
            SV104__ServiceUnitCount: getSV104__ServiceUnitCount(claim),
            SV107_CompositeDiagnosisCodePointer_2000F: getSV107_CompositeDiagnosisCodePointer_2000F(claim),
            SV111__EPSDTIndicator: getSV111__EPSDTIndicator(claim),
            SV120__NursingHomeLevelOfCare: getSV120__NursingHomeLevelOfCare(claim)
        };
    } else {
        return;
    }

}

public function getSV120__NursingHomeLevelOfCare(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var ext in extensions {
                if ext.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-nursingHomeLevelOfCare" {
                    if ext is r4:CodeableConceptExtension {
                        r4:Coding[]? coding = (<r4:CodeableConceptExtension>ext).valueCodeableConcept.coding;
                        if coding is r4:Coding[] {
                            return coding[0].code is r4:code ? <r4:code>coding[0].code : "";
                        }
                    }

                }
            }
        }

    }
    return "";
}

public function getSV111__EPSDTIndicator(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var ext in extensions {
                if ext.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-epsdtIndicator" {
                    if ext is r4:BooleanExtension {
                        return ext.valueBoolean ? "Y" : "N";
                    }

                }
            }
        }

    }
    return "N";
}

// Need improvement - SV1 - 2000F - SV107-01
public function getSV107_01_DiagnosisCodePointer(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:positiveInt[]? diagnosisSequence = item.diagnosisSequence;

        r4:positiveInt diagnosisSequenceValue = 0;
        if diagnosisSequence is r4:positiveInt[] {
            diagnosisSequenceValue = diagnosisSequence[0];
        }

        davincipas:PASClaimDiagnosis[]? diagnosis = claim.diagnosis;
        if diagnosis is davincipas:PASClaimDiagnosis[] {
            foreach var diag in diagnosis {
                if diag.sequence == diagnosisSequenceValue {
                    // Should return the HI Element
                    return "1";
                }
            }
        }

    }

    return "";
}

public function getSV107_CompositeDiagnosisCodePointer_2000F(davincipas:PASClaim claim) returns SV107_CompositeDiagnosisCodePointer_2000F_GType {

    return {
        SV107_01_DiagnosisCodePointer: getSV107_01_DiagnosisCodePointer(claim),
        SV107_02_DiagnosisCodePointer: "",
        SV107_03_DiagnosisCodePointer: "",
        SV107_04_DiagnosisCodePointer: ""
    };

}

public function getSV103__UnitOrBasisForMeasurementCode(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        string? unit = item.quantity is r4:Quantity ? (<r4:Quantity>item.unitPrice).unit : "";
        if unit is string {
            return unit;
        }
    }
    return "";
}

public function getSV104__ServiceUnitCount(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:Quantity? quantity = item.quantity;
        if quantity is r4:Quantity {
            decimal? value = quantity.value;
            if value is decimal {
                return value.toString();
            }
        }
    }
    return "";
}

public function getSV102__ServiceLineAmount(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        return item.unitPrice is r4:Money ? (<r4:Money>item.unitPrice).value.toBalString() : "";
    }
    return "";
}

public function getSV101_CompositeMedicalProcedureIdentifier_2000F_GType(davincipas:PASClaim claim) returns SV101_CompositeMedicalProcedureIdentifier_2000F_GType {

    return {
        SV101_01_ProductOrServiceIDQualifier: getProductOrServiceID(claim),
        SV101_02_ProcedureCode: getSV101_02_ProcedureCode(claim),
        SV101_03_ProcedureModifier: getSV101_ProcedureModifier(claim, 0),
        SV101_04_ProcedureModifier: getSV101_ProcedureModifier(claim, 1),
        SV101_05_ProcedureModifier: getSV101_ProcedureModifier(claim, 2),
        SV101_06_ProcedureModifier: getSV101_ProcedureModifier(claim, 3),
        SV101_07_ProcedureCodeDescription: getSV101_07_ProcedureCodeDescription(claim),
        SV101_08_ProcedureCode: getSV101_08_ProcedureCode(claim)
    };

}

public function getProductOrServiceID(davincipas:PASClaim claim) returns string {

    foreach var item in claim.item {
        r4:Coding[]? codings = item.productOrService.coding;
        if codings is r4:Coding[] {
            foreach var coding in codings {
                match (coding.system) {
                    "http://codesystem.x12.org/005010/1365"|"http://terminology.hl7.org/CodeSystem/icd9cm"|"http://www.cms.gov/Medicare/Coding/ICD10" => {
                        return "";
                    }

                    "http://www.ama-assn.org/go/cpt"|"http: //www.cms.gov/Medicare/Coding/HCPCSReleaseCodeSets" => {
                        return "HC";
                    }

                    "http://hl7.org/fhir/sid/ndc" => {
                        return "N4";
                    }

                }
            }
        }
    }

    return "";
}

public function getSV101_02_ProcedureCode(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        if item is davincipas:PASClaimItem {
            r4:Coding[]? codings = item.productOrService.coding;
            if codings is r4:Coding[] {
                foreach var coding in codings {
                    return coding.code ?: "";
                }
            }

        }
    }

    return "";
}

public function getSV101_ProcedureModifier(davincipas:PASClaim claim, int modifierIndex) returns string {
    foreach var item in claim.item {
        if item is davincipas:PASClaimItem {
            r4:CodeableConcept[]? codeableConcepts = item.modifier;
            if codeableConcepts is r4:CodeableConcept[] {
                r4:Coding[]? codings = codeableConcepts[modifierIndex].coding;
                if codings is r4:Coding[] {
                    return codings[0].code ?: "";
                }
            }

        }
    }
    return "";
}

public function getSV101_07_ProcedureCodeDescription(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        if item is davincipas:PASClaimItem {
            return item.productOrService.text ?: "";
        }
    }
    return "";
}

public function getSV101_08_ProcedureCode(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var ext in extensions {
                if ext.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-productOrServiceCodeEnd" {
                    r4:CodeableConceptExtension valueCodeableConcept = <r4:CodeableConceptExtension>ext;
                    r4:Coding[]? codings = valueCodeableConcept.valueCodeableConcept.coding;
                    if codings is r4:Coding[] {
                        return codings[0].code ?: "";
                    }
                }
            }
        }

    }
    return "";
}

// SV2 - 2000F
public function getInstitutionalServiceLine(davincipas:PASClaim claim) returns InstitutionalServiceLine_Type|() {

    boolean isCodeInstitutionalCode = false;
    r4:CodeableConcept typeCodeableConcept = claim.'type;
    r4:Coding[]? codings = typeCodeableConcept.coding;
    if codings is r4:Coding[] {
        foreach var coding in codings {
            if coding.code == "institutional" {
                isCodeInstitutionalCode = true;
            }
        }
    }

    if isCodeInstitutionalCode {
        return {
            SV201__ServiceLineRevenueCode: getSV201__ServiceLineRevenueCode(claim),
            SV202_CompositeMedicalProcedureIdentifier_2000F: getSV202_CompositeMedicalProcedureIdentifier_2000F(claim),
            SV203__ServiceLineAmount: getSV203__ServiceLineAmount(claim),
            SV204__UnitOrBasisForMeasurementCode: getSV204__UnitOrBasisForMeasurementCode(claim),
            SV205__ServiceUnitCount: getSV205__ServiceUnitCount(claim),
            SV206__ServiceLineRate: getSV206__ServiceLineRate(claim),
            SV209__NursingHomeResidentialStatusCode: getSV209__NursingHomeResidentialStatusCode(claim),
            SV210__NursingHomeLevelOfCare: getSV210__NursingHomeLevelOfCare(claim)
        };
    }

    return;
}

public function getSV210__NursingHomeLevelOfCare(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var ext in extensions {
                if ext.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-nursingHomeLevelOfCare" {
                    if ext is r4:CodeableConceptExtension {
                        r4:Coding[]? codings = ext.valueCodeableConcept?.coding;
                        if codings is r4:Coding[] && codings.length() > 0 {
                            r4:code? code = codings[0].code;
                            return code ?: "";
                        }
                    }
                }
            }
        }
    }
    return "";
}

public function getSV209__NursingHomeResidentialStatusCode(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var ext in extensions {
                if ext.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-revenueUnitRateLimit" {
                    if ext is r4:CodeableConceptExtension {
                        r4:Coding[]? codings = ext.valueCodeableConcept?.coding;
                        if codings is r4:Coding[] && codings.length() > 0 {
                            r4:code? code = codings[0].code;
                            return code ?: "";
                        }
                    }
                }
            }
        }
    }
    return "";
}

public function getSV206__ServiceLineRate(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var ext in extensions {
                if ext.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-revenueUnitRateLimit" {
                    if ext is r4:DecimalExtension {
                        if ext.valueDecimal is decimal {
                            return ext.valueDecimal.toString();
                        }

                    }
                }
            }
        }
    }
    return "";
}

public function getSV205__ServiceUnitCount(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        if item.quantity?.value is decimal {
            return item.quantity?.value.toString();
        }
    }
    return "";
}

public function getSV204__UnitOrBasisForMeasurementCode(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        return item.quantity?.unit ?: "";
    }
    return "";
}

public function getSV203__ServiceLineAmount(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        if item.unitPrice?.value is decimal {
            return item.unitPrice?.value.toString();
        }
    }
    return "";
}

public function getSV202_CompositeMedicalProcedureIdentifier_2000F(davincipas:PASClaim claim) returns SV202_CompositeMedicalProcedureIdentifier_2000F_GType {

    return {
        SV202_01_ProductOrServiceIDQualifier: getSV202_01_ProductOrServiceIDQualifier(claim),
        SV202_02_ProcedureCode: getSV202_02_ProcedureCode(claim),
        SV202_03_ProcedureModifier: getSV202_ProcedureModifier(claim, 0),
        SV202_04_ProcedureModifier: getSV202_ProcedureModifier(claim, 1),
        SV202_05_ProcedureModifier: getSV202_ProcedureModifier(claim, 2),
        SV202_06_ProcedureModifier: getSV202_ProcedureModifier(claim, 3),
        SV202_07_ProcedureCodeDescription: getSV202_07_ProcedureCodeDescription(claim),
        SV202_08_ProcedureCode: getSV101_08_ProcedureCode(claim)
    };
}

public function getSV202_08_ProcedureCode(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:Extension[]? extensions = item.extension;
        if extensions is r4:Extension[] {
            foreach var ext in extensions {
                if ext.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-productOrServiceCodeEnd" {
                    r4:CodeableConceptExtension valueCodeableConcept = <r4:CodeableConceptExtension>ext;
                    r4:Coding[]? codings = valueCodeableConcept.valueCodeableConcept.coding;
                    if codings is r4:Coding[] {
                        return codings[0].code ?: "";
                    }
                }
            }
        }

    }
    return "";
}

public function getSV202_07_ProcedureCodeDescription(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        if item is davincipas:PASClaimItem {
            return item.productOrService.text is string ? <string>item.productOrService.text : "";
        }
    }
    return "";
}

public function getSV202_ProcedureModifier(davincipas:PASClaim claim, int modifierIndex) returns string {
    foreach var item in claim.item {
        if item is davincipas:PASClaimItem {
            r4:CodeableConcept[]? codeableConcepts = item.modifier;
            if codeableConcepts is r4:CodeableConcept[] {
                r4:Coding[]? codings = codeableConcepts[modifierIndex].coding;
                if codings is r4:Coding[] {
                    return codings[0].code ?: "";
                }
            }

        }
    }
    return "";
}

public function getSV202_02_ProcedureCode(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:CodeableConcept? productOrService = item.productOrService;
        if productOrService is r4:CodeableConcept {
            r4:Coding[]? codings = productOrService.coding;
            if codings is r4:Coding[] {
                return codings[0].system ?: "";
            }
        }
    }
    return "";

}

public function getSV202_01_ProductOrServiceIDQualifier(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:CodeableConcept? revenue = item.revenue;
        if revenue is r4:CodeableConcept {
            r4:Coding[]? codings = revenue.coding;
            if codings is r4:Coding[] {
                return codings[0].code ?: "";
            }
        }
    }
    return "";

}

public function getSV201__ServiceLineRevenueCode(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        r4:CodeableConcept? revenue = item.revenue;
        if revenue is r4:CodeableConcept {
            r4:Coding[]? codings = revenue.coding;
            if codings is r4:Coding[] {
                return codings[0].code ?: "";
            }
        }

    }
    return "";
}

public function getHealthCareServicesDelivery(davincipas:PASClaim claim) returns HealthCareServicesDelivery_Type {
    return {
        HSD01__QuantityQualifier: getHSD01__QuantityQualifier(claim),
        HSD02__ServiceUnitCount: getHHSD02__ServiceUnitCount(claim),
        HSD03__UnitOrBasisForMeasurementCode: "",
        HSD04__SampleSelectionModulus: "",
        HSD05__TimePeriodQualifier: "",
        HSD06__PeriodCount: "",
        HSD07__DeliveryFrequencyCode: "",
        HSD08__DeliveryPatternTimeCode: ""
    };
}

public function getRequestedService(davincipas:PASClaim claim, r4:Bundle bundle) returns string {
    foreach var item in claim.item {
        if item.extension is r4:Extension[] {
            foreach var ext in <r4:Extension[]>item.extension {
                if ext.url == "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-requestedService" {
                    if ext is r4:ReferenceExtension {
                        r4:Reference valueReference = ext.valueReference;
                        string reference = valueReference.reference ?: "";

                        match valueReference.'type {
                            "MedicationRequest" => {
                                r4:BundleEntry[]? entries = bundle.entry;
                                if entries is r4:BundleEntry[] {
                                    foreach var entry in entries {
                                        // entry.'resource;
                                        // international401:MedicationRequest medicationRequest = check parser:parse(, international401:MedicationRequest).ensureType();
                                    }
                                }
                            }

                            "ServiceRequest" => {

                            }

                            "DeviceRequest" => {

                            }
                        }
                    }
                }
            }
        }
    }
    return ""; // Return empty string if no value is found
}

public function getHHSD02__ServiceUnitCount(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        if item.quantity?.value is decimal {
            return item.quantity?.unit ?: "";
        }
    }
    return "";
}

public function getHSD01__QuantityQualifier(davincipas:PASClaim claim) returns string {
    foreach var item in claim.item {
        if item.quantity?.unit is string {
            return item.quantity?.unit ?: "";
        }
    }
    return "";
}

