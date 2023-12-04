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
// Source C-CDA to FHIR - Datatype Mappings
// --------------------------------------------------------------------------------------------#

import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

xmlns "urn:hl7-org:v3" as v3;

# Map C-CDA id to FHIR Identifier.
#
# + idElement - C-CDA id element
# + return - Return FHIR Identifier
public isolated function mapCcdaIdToFhirIdentifier(xml idElement) returns uscore501:USCorePatientProfileIdentifier? {
    string|error? extensionVal = idElement.extension;
    string|error? rootVal = idElement.root;
    if rootVal !is string {
        log:printDebug("Mandatory field root not available", rootVal);
        return ();
    }

    string? system = ();
    match (rootVal) {
        "2.16.840.1.113883.4.1" => {
            system = "http://hl7.org/fhir/sid/us-ssn";
        }
        "2.16.840.1.113883.4.336" => {
            system = "http://terminology.hl7.org/NamingSystem/CMSCertificationNumber";
        }
        "2.16.840.1.113883.4.6" => {
            system = "http://hl7.org/fhir/sid/us-npi";
        }
        "2.16.840.1.113883.4.572" => {
            system = "http://hl7.org/fhir/sid/us-medicare";
        }
        _=> {
            system = ();
        }
    }

    if system is string && extensionVal is string {
        return {
            system: system,
            value: extensionVal
        };
    } else if system is () && extensionVal is string {
        return {
            system: string `urn:oid:${rootVal}`,
            value: extensionVal
        };
    } else if system is () && extensionVal is () {
        return {
            system: "urn:ietf:rfc:3986",
            value: "urn:oid:2.16.840.1.123.4.50.123456789"	
        };
    }
    return ();
}

# Map C-CDA address to FHIR Address.
#
# + addressElements - C-CDA address element
# + return - Return FHIR Address
public isolated function mapCcdaAddressToFhirAddress(xml addressElements) returns r4:Address[]? {
    r4:Address[] address = [];
    foreach xml addressElement in addressElements {
        xml streetAddressLineElement = addressElement/<v3:streetAddressLine|streetAddressLine>;
        xml cityElement = addressElement/<v3:city|city>;
        xml stateElement = addressElement/<v3:state|state>;
        xml postalCodeElement = addressElement/<v3:postalCode|postalCode>;
        xml useablePeriodLowElement = addressElement/<v3:useablePeriod|useablePeriod>/<v3:low|low>;
        xml useablePeriodHighElement = addressElement/<v3:useablePeriod|useablePeriod>/<v3:high|high>;

        string[] streetAddressLines = [];
        if streetAddressLineElement.length() > 1 {
            foreach xml streetAddressLine in streetAddressLineElement {
                streetAddressLines.push(streetAddressLine.data().trim());
            }
        } else {
            streetAddressLines.push(streetAddressLineElement.data().trim());
        }

        string city = cityElement.data().trim();
        string state = stateElement.data().trim();
        string postalCode = postalCodeElement.data().trim();

        r4:AddressUse? use = ();
        string|error? useVal = addressElement.use;

        match (useVal) {
            "H" => {
                use = r4:home;
            }
            "HP" => {
                use = r4:home;
            }
            "HV" => {
                use = r4:home;
            }
            "OLD" => {
                use = r4:old;
            }
            "TMP" => {
                use = r4:temp;
            }
            "WP" => {
                use = r4:work;
            }
            "DIR" => {
                use = r4:work;
            }
            "PUB" => {
                use = r4:work;
            }
            "BAD" => {
                use = r4:old;
            }
        }

        r4:dateTime? useablePeriodLow = mapCcdaDateTimeToFhirDateTime(useablePeriodLowElement);
        r4:dateTime? useablePeriodHigh = mapCcdaDateTimeToFhirDateTime(useablePeriodHighElement);

        r4:Period? period = ();
        if useablePeriodLow is string || useablePeriodHigh is string {
            period = {
                'start: useablePeriodLow,
                end: useablePeriodHigh
            };
        }

        r4:Address addressVal = {
            use: use,
            line: streetAddressLines,
            city,
            state,
            postalCode,
            period
        };
        address.push(addressVal);
    }

    if address.length() == 0 {
        log:printDebug("Address fields not available");
        return ();
    }
    return address;
}

# Map C-CDA telecom to FHIR ContactPoint.
#
# + telecomElement - C-CDA telecom element
# + return - Return FHIR ContactPoint
public isolated function mapCcdaTelecomToFhirTelecom(xml telecomElement) returns r4:ContactPoint? {
    string|error? telecomUse = telecomElement.use;
    string|error? telecomValue = telecomElement.value;

    string? systemVal = ();
    string? valueVal = ();
    if telecomValue is string {
        systemVal = re `:`.split(telecomValue)[0];
        valueVal = re `:`.split(telecomValue)[1];

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

# Map C-CDA name to FHIR HumanName.
#
# + nameElements - C-CDA name element
# + return - Return FHIR HumanName
public isolated function mapCcdaNametoFhirName(xml nameElements) returns r4:HumanName[]? {
    r4:HumanName[] humanNames = [];

    foreach xml nameElement in nameElements {    
        xml familyElement = nameElement/<v3:family|family>;
        xml givenElements = nameElement/<v3:given|given>;
        xml prefixlements = nameElement/<v3:prefix|prefix>;
        xml suffixElements = nameElement/<v3:suffix|suffix>;


        string family = familyElement.data().trim();

        string[] given = [];
        foreach xml givenElement in givenElements {
            given.push(givenElement.data().trim());
        }

        string[] prefix = [];
        foreach xml prefixlement in prefixlements {
            prefix.push(prefixlement.data().trim());
        }
        
        string[] suffix = [];
        foreach xml suffixElement in suffixElements {
            suffix.push(suffixElement.data().trim());
        }


        if family != "" || given.length() > 0 || prefix.length() > 0 || suffix.length() > 0 {
            r4:HumanName name = {given: given, family, prefix, suffix};
            humanNames.push(name);
        }
    }

    if humanNames.length() == 0 {
        log:printDebug("name fields not available");
        return ();
    }
    return humanNames;
}

# Map C-CDA code to FHIR CodeableConcept.
#
# + codingElement - C-CDA code element
# + return - Return FHIR CodeableConcept
public isolated function mapCcdaCodingtoFhirCodeableConcept(xml codingElement) returns r4:CodeableConcept? {
    r4:Coding[]? mapCcdaCodingtoFhirCodeResult = mapCcdaCodingstoFhirCodings(codingElement);
    string textVal = codingElement.data().trim();
    if mapCcdaCodingtoFhirCodeResult is r4:Coding[] {
        return {
            coding: mapCcdaCodingtoFhirCodeResult,
            text: textVal
        };
    }
    log:printDebug("codeableConcept not available");
    return ();
}

# Map C-CDA code to FHIR Coding.
#
# + codingElement - C-CDA code element
# + return - Return FHIR Coding
public isolated function mapCcdaCodingtoFhirCoding(xml codingElement) returns r4:Coding? {
    string|error? codeVal = codingElement.code;
    string|error? systemVal = codingElement.codeSystem;
    string|error? displayNameVal = codingElement.displayName;

    string? code = ();
    if codeVal is string {
        code = codeVal;
    } else {
        log:printDebug("codeVal is not available", codeVal);
    }

    string? system = ();
    if systemVal is string {
        system = mapOidtoUri(systemVal);
    } else {
        log:printDebug("systemVal is not available", systemVal);
    }

    string? display = ();
    if displayNameVal is string {
        display = displayNameVal;
    } else {
        log:printDebug("displayNameVal is not available", displayNameVal);
    }

    if code is string || system is string || display is string {
        return  {
            code: code,
            system: system,
            display: display
        };
    }
    log:printDebug("coding fields not available");
    return ();
}

# Map C-CDA codes to FHIR Coding.
#
# + codingElements - C-CDA code element
# + return - Return FHIR Coding
public isolated function mapCcdaCodingstoFhirCodings(xml codingElements) returns r4:Coding[]? {
    r4:Coding[] codings = [];
    foreach xml codingElement in codingElements {
        string|error? codeVal = codingElement.code;
        string|error? systemVal = codingElement.codeSystem;
        string|error? displayNameVal = codingElement.displayName;

        string? code = ();
        if codeVal is string {
            code = codeVal;
        } else {
            log:printDebug("codeVal is not available", codeVal);
        }

        string? system = ();
        if systemVal is string {
            system = mapOidtoUri(systemVal);
        } else {
            log:printDebug("systemVal is not available", systemVal);
        }

        string? display = ();
        if displayNameVal is string {
            display = displayNameVal;
        } else {
            log:printDebug("displayNameVal is not available", displayNameVal);
        }

        if code is string || system is string || display is string {
            r4:Coding coding = {
                code: code,
                system: system,
                display: display
            };
            codings.push(coding);
        }
    }

    if codings.length() == 0 {
        log:printDebug("coding fields not available");
        return ();
    }   
    return codings;
}

# Map C-CDA dateTime to FHIR dateTime.
#
# + dateTimeElement - C-CDA dateTime element
# + return - Return FHIR dateTime
public isolated function mapCcdaDateTimeToFhirDateTime(xml dateTimeElement) returns r4:dateTime? {
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
            return string `${dateTimeVal.substring(0, 4)}-${dateTimeVal.substring(4, 6)}-${dateTimeVal.substring(6, 8)}T${dateTimeVal.substring(9, 11)}:${dateTimeVal.substring(11, 15)}:${dateTimeVal.substring(15, 17)}`;
        }
        _ => {
            log:printDebug("Invalid dateTime length");
            return ();
        }
    }
}

# Map C-CDA OID to FHIR codesystems.
# 
# + oid - C-CDA OID
# + return - Return FHIR codesystems
public isolated function mapOidtoUri(string oid) returns string {
    match (oid) {
        "2.16.840.1.113883.6.1" => {
            return "http://loinc.org";
        }
        "2.16.840.1.113883.6.96" => {
            return "http://snomed.info/sct";
        }
        "2.16.840.1.113883.6.88" => {
            return "http://www.nlm.nih.gov/research/umls/rxnorm";
        }
        "2.16.840.1.113883.6.12" => {
            return "http://www.ama-assn.org/go/cpt";
        }
        "2.16.840.1.113883.2.20.5.1" => {
            return "https://fhir.infoway-inforoute.ca/CodeSystem/pCLOCD";
        }
        "2.16.840.1.113883.6.8" => {
            return "http://unitsofmeasure.org";
        }
        "2.16.840.1.113883.6.345" => {
            return "http://va.gov/terminology/medrt";
        }
        "2.16.840.1.113883.4.9" => {
            return "http://fdasis.nlm.nih.gov	";
        }
        "2.16.840.1.113883.6.69" => {
            return "http://hl7.org/fhir/sid/ndc";
        }
        "2.16.840.1.113883.12.292" => {
            return "http://hl7.org/fhir/sid/cvx";
        }
        "2.16.840.1.113883.6.24" => {
            return "urn:iso:std:iso:11073:10101	";
        }
        _ => {
            return string `urn:oid:${oid}`;
        }
    }
}
