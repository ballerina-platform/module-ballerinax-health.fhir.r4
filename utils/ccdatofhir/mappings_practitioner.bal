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

// --------------------------------------------------------------------------------------------#
// This is added as a custom mapping for the Practitioner resource
// --------------------------------------------------------------------------------------------#

import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;
import ballerina/log;

# Map CCDA Practitioner to FHIR Practitioner.
#
# + authorElement - CCDA Author Element
# + return - Return FHIR Practitioner resource
isolated function ccdaToPractitioner(xml authorElement) returns uscore501:USCorePractitionerProfile? {
    if isXMLElementNotNull(authorElement) {
        uscore501:USCorePractitionerProfile practitioner = {identifier: [], name: []};

        xml assignedAuthorElement = authorElement/<v3:assignedAuthor|assignedAuthor>;
        xml assignedAuthorCodeElement = assignedAuthorElement/<v3:code|code>;
        xml assignedPersonElement = assignedAuthorElement/<v3:assignedPerson|assignedPerson>;
        xml assignedAuthorAddressElement = assignedAuthorElement/<v3:addr|addr>;

        r4:CodeableConcept? qualificationCode = mapCcdaCodingtoFhirCodeableConcept(assignedAuthorCodeElement);
        if qualificationCode is r4:CodeableConcept {
            uscore501:USCorePractitionerProfileQualification qualification = {
                code: qualificationCode
            };
            practitioner.qualification = [qualification];
        }

        xml assignedPersonNameElement = assignedPersonElement/<v3:name|name>;
        uscore501:USCorePractitionerProfileName? name = mapCcdaNametoFhirPractitionerName(assignedPersonNameElement);
        if name is r4:HumanName {
            practitioner.name = [name];
        }

        r4:Address[]?|error mapCcdaAddressToFhirAddressResult = mapCcdaAddressToFhirAddress(assignedAuthorAddressElement);
        if mapCcdaAddressToFhirAddressResult is r4:Address[] {
            practitioner.address = mapCcdaAddressToFhirAddressResult;
        }

        return practitioner;
    }
    return ();
}

# Map C-CDA name to FHIR Practitioner HumanName.
#
# + nameElement - C-CDA name element
# + return - Return FHIR HumanName
public isolated function mapCcdaNametoFhirPractitionerName(xml nameElement) returns uscore501:USCorePractitionerProfileName? {
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
