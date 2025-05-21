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

import ballerinax/health.fhir.r4;

# Maps C-CDA participant to FHIR Practitioner
# + participantElement - The C-CDA participant element
# + return - The mapped FHIR Practitioner reference
public isolated function mapCcdaParticipantToFhirPractitioner(xml participantElement) returns r4:Reference {
    xml participantRoleElement = participantElement/<v3:participantRole|participantRole>;
    xml playingEntityElement = participantRoleElement/<v3:playingEntity|playingEntity>;
    xml playingEntityIdElement = playingEntityElement/<v3:id|id>;
    
    string|error? id = playingEntityIdElement.root;
    if id is string {
        return {
            'type: "Practitioner",
            reference: string `Practitioner/${id}`
        };
    }
    return {};
}

# Maps C-CDA participant to FHIR Organization
# + participantElement - The C-CDA participant element
# + return - The mapped FHIR Organization reference
public isolated function mapCcdaParticipantToFhirOrganization(xml participantElement) returns r4:Reference {
    xml participantRoleElement = participantElement/<v3:participantRole|participantRole>;
    xml scopingEntityElement = participantRoleElement/<v3:scopingEntity|scopingEntity>;
    xml scopingEntityIdElement = scopingEntityElement/<v3:id|id>;
    
    string|error? id = scopingEntityIdElement.root;
    if id is string {
        return {
            'type: "Organization",
            reference: string `Organization/${id}`
        };
    }
    return {};
}

# Maps C-CDA participant to FHIR PractitionerRole
# + participantElement - The C-CDA participant element
# + return - The mapped FHIR PractitionerRole reference
public isolated function mapCcdaParticipantToFhirPractitionerRole(xml participantElement) returns r4:Reference {
    xml participantRoleElement = participantElement/<v3:participantRole|participantRole>;
    xml playingEntityElement = participantRoleElement/<v3:playingEntity|playingEntity>;
    xml playingEntityIdElement = playingEntityElement/<v3:id|id>;
    
    string|error? id = playingEntityIdElement.root;
    if id is string {
        return {
            'type: "PractitionerRole",
            reference: string `PractitionerRole/${id}`
        };
    }
    return {};
}

# Maps C-CDA participant to FHIR RelatedPerson
# + participantElement - The C-CDA participant element
# + return - The mapped FHIR RelatedPerson reference
public isolated function mapCcdaParticipantToFhirRelatedPerson(xml participantElement) returns r4:Reference {
    xml participantRoleElement = participantElement/<v3:participantRole|participantRole>;
    xml playingEntityElement = participantRoleElement/<v3:playingEntity|playingEntity>;
    xml playingEntityIdElement = playingEntityElement/<v3:id|id>;
    
    string|error? id = playingEntityIdElement.root;
    if id is string {
        return {
            'type: "RelatedPerson",
            reference: string `RelatedPerson/${id}`
        };
    }
    return {};
}

# Maps C-CDA participant to FHIR Device
# + participantElement - The C-CDA participant element
# + return - The mapped FHIR Device reference
public isolated function mapCcdaParticipantToFhirDevice(xml participantElement) returns r4:Reference {
    xml participantRoleElement = participantElement/<v3:participantRole|participantRole>;
    xml playingEntityElement = participantRoleElement/<v3:playingEntity|playingEntity>;
    xml playingEntityIdElement = playingEntityElement/<v3:id|id>;
    
    string|error? id = playingEntityIdElement.root;
    if id is string {
        return {
            'type: "Device",
            reference: string `Device/${id}`
        };
    }
    return {};
}

# Maps C-CDA participant to FHIR Location
# + participantElement - The C-CDA participant element
# + return - The mapped FHIR Location reference
public isolated function mapCcdaParticipantToFhirLocation(xml participantElement) returns r4:Reference {
    xml participantRoleElement = participantElement/<v3:participantRole|participantRole>;
    xml playingEntityElement = participantRoleElement/<v3:playingEntity|playingEntity>;
    xml playingEntityIdElement = playingEntityElement/<v3:id|id>;
    
    string|error? id = playingEntityIdElement.root;
    if id is string {
        return {
            'type: "Location",
            reference: string `Location/${id}`
        };
    }
    return {};
}

# Maps C-CDA participant type code to FHIR participant type
# + typeCode - The C-CDA participant type code
# + return - The mapped FHIR participant type
public isolated function mapCcdaParticipantTypeToFhirType(string typeCode) returns r4:CodeableConcept? {
    r4:CodeableConcept participantType = {};
    
    match typeCode {
        "AUT" => {
            participantType = {
                coding: [{
                    system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
                    code: "AUT",
                    display: "Author"
                }]
            };
        }
        "ENT" => {
            participantType = {
                coding: [{
                    system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
                    code: "ENT",
                    display: "Data Enterer"
                }]
            };
        }
        "INF" => {
            participantType = {
                coding: [{
                    system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
                    code: "INF",
                    display: "Informant"
                }]
            };
        }
        "PRF" => {
            participantType = {
                coding: [{
                    system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
                    code: "PRF",
                    display: "Performer"
                }]
            };
        }
        _ => {
            participantType = {
                coding: [{
                    system: "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
                    code: typeCode
                }]
            };
        }
    }
    
    return participantType;
}

# Maps C-CDA participant function code to FHIR function code
# + functionCodeElement - The C-CDA function code element
# + parentDocument - The parent document of the C-CDA
# + return - The mapped FHIR function code
public isolated function mapCcdaFunctionCodeToFhirFunctionCode(xml functionCodeElement, xml parentDocument) returns r4:CodeableConcept? {
    r4:CodeableConcept? result = mapCcdaCodingToFhirCodeableConcept(functionCodeElement, parentDocument);
    if result is r4:CodeableConcept {
        return result;
    }
    return ();
}

# Maps C-CDA participant time to FHIR period
# + timeElement - The C-CDA time element
# + return - The mapped FHIR period
public isolated function mapCcdaParticipantTimeToFhirPeriod(xml timeElement) returns r4:Period? {
    r4:Period period = {};
    
    xml lowElement = timeElement/<v3:low|low>;
    xml highElement = timeElement/<v3:high|high>;
    
    r4:dateTime? lowDateTime = mapCcdaDateTimeToFhirDateTime(lowElement);
    if lowDateTime is r4:dateTime {
        period.'start = lowDateTime;
    }
    
    r4:dateTime? highDateTime = mapCcdaDateTimeToFhirDateTime(highElement);
    if highDateTime is r4:dateTime {
        period.end = highDateTime;
    }
    if period.'start is r4:dateTime || period.end is r4:dateTime {
        return period;
    }
    return ();
}

# Maps C-CDA mode code to FHIR mode code
# + modeCodeElement - The C-CDA mode code element
# + parentDocument - The parent document of the C-CDA
# + return - The mapped FHIR mode code
public isolated function mapCcdaModeCodeToFhirModeCode(xml modeCodeElement, xml parentDocument) returns r4:CodeableConcept? {
    r4:CodeableConcept? result = mapCcdaCodingToFhirCodeableConcept(modeCodeElement, parentDocument);
    if result is r4:CodeableConcept {
        return result;
    }
    return ();
}

# Maps C-CDA awareness code to FHIR awareness code
# + awarenessCodeElement - The C-CDA awareness code element
# + parentDocument - The parent document of the C-CDA
# + return - The mapped FHIR awareness code
public isolated function mapCcdaAwarenessCodeToFhirAwarenessCode(xml awarenessCodeElement, xml parentDocument) returns r4:CodeableConcept? {
    r4:CodeableConcept? result = mapCcdaCodingToFhirCodeableConcept(awarenessCodeElement, parentDocument);
    if result is r4:CodeableConcept {
        return result;
    }
    return ();
}

# Maps C-CDA patient relationship to FHIR relationship
# + relationshipElement - The C-CDA patient relationship element
# + parentDocument - The parent document of the C-CDA
# + return - The mapped FHIR relationship
public isolated function mapCcdaPatientRelationshipToFhirRelationship(xml relationshipElement, xml parentDocument) returns r4:CodeableConcept? {
    r4:CodeableConcept? result = mapCcdaCodingToFhirCodeableConcept(relationshipElement, parentDocument);
    if result is r4:CodeableConcept {
        return result;
    }
    return ();
}

# Maps C-CDA organization part-of to FHIR organization part-of
# + partOfElement - The C-CDA organization part-of element
# + return - The mapped FHIR organization part-of reference
public isolated function mapCcdaOrganizationPartOfToFhirPartOf(xml partOfElement) returns r4:Reference? {
    xml idElement = partOfElement/<v3:id|id>;
    string|error? id = idElement.root;
    if id is string {
        return {
            'type: "Organization",
            reference: string `Organization/${id}`
        };
    }
    return ();
}

# Maps C-CDA standard industry class code to FHIR organization type
# + standardIndustryClassCodeElement - The C-CDA standard industry class code element
# + parentDocument - The parent document of the C-CDA
# + return - The mapped FHIR organization type
public isolated function mapCcdaStandardIndustryClassCodeToFhirType(xml standardIndustryClassCodeElement, xml parentDocument) returns r4:CodeableConcept? {
    r4:CodeableConcept? result = mapCcdaCodingToFhirCodeableConcept(standardIndustryClassCodeElement, parentDocument);
    if result is r4:CodeableConcept {
        return result;
    }
    return ();
} 
