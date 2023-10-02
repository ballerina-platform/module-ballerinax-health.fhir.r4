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

xmlns "urn:hl7-org:v3" as v3;

# Map C-CDA id to FHIR Identifier.
#
# + idElement - C-CDA id element
# + return - Return FHIR Identifier
public isolated function mapCcdaIdToFhirIdentifier(xml idElement) returns r4:Identifier? {
    string|error? idVal = idElement.extension;
    string|error? rootVal = idElement.root;
    if rootVal !is string {
        log:printDebug("Mandatory field root not available", rootVal);
        return ();
    }
    if rootVal.equalsIgnoreCaseAscii("2.16.840.1.113883.4.1") && idVal is string {
        return {
            system: "http://hl7.org/fhir/sid/us-ssn",
            value: idVal
        };
    } else if idVal is string {
        return {
            system: rootVal,
            value: string `urn:oid:${idVal}`
        };
    }
    return {
        system: "urn:ietf:rfc:3986",
        value: rootVal
    };
}

# Map C-CDA address to FHIR Address.
#
# + addressElement - C-CDA address element
# + return - Return FHIR Address
public isolated function mapCcdaAddressToFhirAddress(xml addressElement) returns r4:Address? {
    xml streetAddressLineElement = addressElement/<v3:streetAddressLine|streetAddressLine>;
    xml cityElement = addressElement/<v3:city|city>;
    xml stateElement = addressElement/<v3:state|state>;
    xml postalCodeElement = addressElement/<v3:postalCode|postalCode>;

    string streetAddressLine = streetAddressLineElement.data().trim();
    string city = cityElement.data().trim();
    string state = stateElement.data().trim();
    string postalCode = postalCodeElement.data().trim();

    if streetAddressLine != "" || city != "" || state != "" || postalCode != "" {
        return {
            line: [streetAddressLine],
            city,
            state,
            postalCode
        };
    }
    log:printDebug("Address fields not available");
    return ();
}

# Map C-CDA telecom to FHIR ContactPoint.
#
# + telecomElement - C-CDA telecom element
# + return - Return FHIR ContactPoint
public isolated function mapCcdaTelecomToFhirTelecom(xml telecomElement) returns r4:ContactPoint? {
    string|error? telecomUse = telecomElement.use;
    string|error? telecomValue = telecomElement.value;

    string? valueVal = ();
    if telecomValue is string {
        valueVal = telecomValue;
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

    if valueVal is string || useVal is string {
        return {
            value: valueVal,
            use: useVal
        };
    }
    log:printDebug("telecom fields not available");
    return ();
}

# Map C-CDA name to FHIR HumanName.
#
# + nameElement - C-CDA name element
# + return - Return FHIR HumanName
public isolated function mapCcdaNametoFhirName(xml nameElement) returns r4:HumanName? {
    xml familyElement = nameElement/<v3:family|family>;
    xml givenElement = nameElement/<v3:given|given>;

    string given = givenElement.data().trim();
    string family = familyElement.data().trim();

    if given != "" || family != "" {
        return {given: [given], family};
    }
    log:printDebug("name fields not available");
    return ();
}

# Map C-CDA code to FHIR CodeableConcept.
#
# + codingElement - C-CDA code element
# + return - Return FHIR CodeableConcept
public isolated function mapCcdaCodingtoFhirCodeableConcept(xml codingElement) returns r4:CodeableConcept? {
    r4:Coding? mapCcdaCodingtoFhirCodeResult = mapCcdaCodingtoFhirCoding(codingElement);
    if mapCcdaCodingtoFhirCodeResult is r4:Coding {
        return {
            coding: [mapCcdaCodingtoFhirCodeResult]
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
        system = systemVal;
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
        return {
            code: code,
            system: system,
            display: display
        };
    }
    log:printDebug("coding fields not available");
    return ();
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
