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
import ballerinax/health.fhir.r4.international401;

# Map CCDA Practitioner to FHIR Practitioner.
#
# + authorElement - CCDA Author Element
# + return - Return FHIR Practitioner resource
public isolated function mapCcdaPractitionerToFhir(xml authorElement) returns international401:Practitioner? {
    if isXMLElementNotNull(authorElement) {
        international401:Practitioner practitioner = {};

        xml assignedAuthorElement = authorElement/<v3:assignedAuthor|assignedAuthor>;

        xml assignedAuthorCodeElement = assignedAuthorElement/<v3:code|code>;
        xml assignedPersonElement = assignedAuthorElement/<v3:assignedPerson|assignedPerson>;

        r4:CodeableConcept? qualificationCode = mapCcdaCodingtoFhirCodeableConcept(assignedAuthorCodeElement);
        if qualificationCode is r4:CodeableConcept {
            international401:PractitionerQualification qualification = {
                code: qualificationCode
            };
            practitioner.qualification = [qualification];
        }

        xml assignedPersonNameElement = assignedPersonElement/<v3:name|name>;
        r4:HumanName? name = mapCcdaNametoFhirName(assignedPersonNameElement);
        if name is r4:HumanName {
            practitioner.name = [name];
        }
        return practitioner;
    }
    return ();
}
