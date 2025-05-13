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

// import ballerina/log;
// import ballerina/time;
// import ballerina/xmldata;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

xmlns "urn:hl7-org:v3" as v3;
xmlns "urn:hl7-org:sdtc" as sdtc;

# Maps C-CDA Encounter Activity or EncompassingEncounter to FHIR Encounter resource.
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + parentDocument - C-CDA document XML element
# + return - Mapped USCore Encounter Profile or () if mapping fails
public isolated function ccdaToEncounter(xml document, xml parentDocument) returns r4:Resource[] {
    if !isXMLElementNotNull(document) {
        return [];
    }
    r4:Resource[] resources = [];
    [uscore501:USCoreEncounterProfileDiagnosis[], uscore501:USCoreCondition[]] mapEncounterDiagnosisResult = mapEncounterDiagnosis(document, parentDocument);
    [uscore501:USCoreEncounterProfileParticipant[], uscore501:USCorePractitionerProfile[]] mapEncounterParticipantsResult = mapEncounterParticipants(document, parentDocument);
    uscore501:USCoreEncounterProfile encounter = {
        resourceType: "Encounter",
        status: mapEncounterStatus(document),
        'class: mapEncounterClass(document, parentDocument),
        'type: mapEncounterType(document, parentDocument),
        subject: {
            reference: "Patient/unknown"
        },
        period: mapEncounterPeriod(document),
        hospitalization: mapHospitalization(document, parentDocument),
        participant: mapEncounterParticipantsResult[0],
        location: mapEncounterLocationsForEncounterActivity(document),
        reasonCode: mapEncounterReasonCode(document, parentDocument),
        diagnosis: mapEncounterDiagnosisResult[0]
    };

    if (mapEncounterDiagnosisResult[1].length() > 0) {
        uscore501:USCoreCondition[] conditions = mapEncounterDiagnosisResult[1];
        foreach uscore501:USCoreCondition condition in conditions {
            resources.push(condition);
        }
    }

    if (mapEncounterParticipantsResult[1].length() > 0) {
        uscore501:USCorePractitionerProfile[] practitioners = mapEncounterParticipantsResult[1];
        foreach uscore501:USCorePractitionerProfile practitioner in practitioners {
            resources.push(practitioner);
        }
    }

    // Map identifier
    xml? id = document/<v3:id|id>;
    if (id is xml && id.length() > 0) {
        uscore501:USCorePatientProfileIdentifier? identifier = mapCcdaIdToFhirIdentifier(id);
        if (identifier is uscore501:USCorePatientProfileIdentifier) {
            encounter.identifier = [identifier];
        }

        // Check for encompassingEncounter in parentDocument with matching ID
        xml? encompassingEncounter = parentDocument/<v3:componentOf|componentOf>/<v3:encompassingEncounter|encompassingEncounter>;
        if (encompassingEncounter is xml && encompassingEncounter.length() > 0) {
            xml? encompassingId = encompassingEncounter/<v3:id|id>;
            if (encompassingId is xml && encompassingId.length() > 0) {
                string|error docId = id.toString();
                string|error encId = encompassingId.toString();
                if (docId is string && encId is string && docId == encId) {
                    // Merge additional details from encompassingEncounter
                    // Update period if not already set
                    if (encounter.period is ()) {
                        encounter.period = mapEncounterPeriod(encompassingEncounter);
                    }

                    // Merge participants
                    [uscore501:USCoreEncounterProfileParticipant[], uscore501:USCorePractitionerProfile[]] encParticipants = mapEncounterParticipants(encompassingEncounter, parentDocument);
                    if (encounter.participant is uscore501:USCoreEncounterProfileParticipant[]) {
                        uscore501:USCoreEncounterProfileParticipant[] existingParticipants = <uscore501:USCoreEncounterProfileParticipant[]>encounter.participant;
                        encounter.participant = [...existingParticipants, ...encParticipants[0]];
                    } else {
                        encounter.participant = encParticipants[0];
                    }

                    // Merge locations
                    uscore501:USCoreEncounterProfileLocation[] encLocations = mapEncounterLocationsForEncompassingEncounter(encompassingEncounter);
                    if (encLocations.length() > 0) {
                        uscore501:USCoreEncounterProfileLocation[] existingLocations = [];
                        if (encounter.location is uscore501:USCoreEncounterProfileLocation[]) {
                            existingLocations = <uscore501:USCoreEncounterProfileLocation[]>encounter.location;
                        }
                        encounter.location = [...existingLocations, ...encLocations];
                    }

                    // Merge reason codes
                    r4:CodeableConcept[]? encReasons = mapEncounterReasonCode(encompassingEncounter, parentDocument);
                    if (encReasons is r4:CodeableConcept[]) {
                        if (encounter.reasonCode is r4:CodeableConcept[]) {
                            r4:CodeableConcept[] existingReasons = <r4:CodeableConcept[]>encounter.reasonCode;
                            encounter.reasonCode = [...existingReasons, ...encReasons];
                        } else {
                            encounter.reasonCode = encReasons;
                        }
                    }
                }
            }
        }
    }
    resources.push(encounter);

    return resources;
}

# Maps C-CDA statusCode or effectiveTime to FHIR encounter status
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + return - FHIR encounter status
isolated function mapEncounterStatus(xml document) returns uscore501:USCoreEncounterProfileStatus {
    // First check statusCode (body only)
    xml? statusCode = document/<v3:statusCode|statusCode>;
    if (statusCode is xml && statusCode.length() > 0) {
        string|error code = statusCode.code;
        if code is string {
            return mapStatusCodeToStatus(code);
        }
    }

    // Fallback to effectiveTime
    xml? effectiveTime = document/<v3:effectiveTime|effectiveTime>;
    if (effectiveTime is xml && effectiveTime.length() > 0) {
        xml? high = effectiveTime/<v3:high|high>;
        if (high !is xml || high.length() == 0) {
            return uscore501:CODE_STATUS_IN_PROGRESS;
        }
        return uscore501:CODE_STATUS_FINISHED;
    }

    return uscore501:CODE_STATUS_PLANNED;
}

# Maps C-CDA status code to FHIR encounter status
#
# + code - C-CDA status code
# + return - FHIR encounter status
isolated function mapStatusCodeToStatus(string code) returns uscore501:USCoreEncounterProfileStatus {
    if code == "active" {
        return uscore501:CODE_STATUS_IN_PROGRESS;
    } else if code == "completed" {
        return uscore501:CODE_STATUS_FINISHED;
    } else if code == "aborted" {
        return uscore501:CODE_STATUS_CANCELLED;
    } else if code == "suspended" {
        return uscore501:CODE_STATUS_ONLEAVE;
    } else {
        return uscore501:CODE_STATUS_PLANNED;
    }
}

# Maps C-CDA code to FHIR encounter class
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + parentDocument - C-CDA document XML element
# + return - FHIR encounter class
isolated function mapEncounterClass(xml document, xml parentDocument) returns r4:Coding {
    xml? code = document/<v3:code|code>;
    if (code !is xml || code.length() == 0) {
        return {
            //add dataabsentreason
            extension: [
                {
                    url: "http://terminology.hl7.org/CodeSystem/data-absent-reason",
                    valueCode: "unknown"
                }
            ]
        };
    }

    // Check for V3 ActCode in root or translations
    r4:CodeableConcept? codeableConcept = mapCcdaCodingToFhirCodeableConcept(code, parentDocument);
    if (codeableConcept is r4:CodeableConcept && codeableConcept.coding is r4:Coding[]) {
        r4:Coding[] codings = <r4:Coding[]>codeableConcept.coding;
        foreach r4:Coding coding in codings {
            if (coding.system == "http://terminology.hl7.org/CodeSystem/v3-ActCode") {
                return coding;
            }
        }
    }

    return {
        //add dataabsentreason
        extension: [
            {
                url: "http://terminology.hl7.org/CodeSystem/data-absent-reason",
                valueCode: "unknown"
            }
        ]
    };
}

# Maps C-CDA code to FHIR encounter type
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + parentDocument - C-CDA document XML element
# + return - FHIR encounter type
isolated function mapEncounterType(xml document, xml parentDocument) returns r4:CodeableConcept[] {
    xml? code = document/<v3:code|code>;
    if (code !is xml || code.length() == 0) {
        return [];
    }

    r4:CodeableConcept[] types = [];
    r4:CodeableConcept? codeableConcept = mapCcdaCodingToFhirCodeableConcept(code, parentDocument);
    if (codeableConcept is r4:CodeableConcept) {
        if codeableConcept.coding is r4:Coding[] {
            r4:Coding[] codings = <r4:Coding[]>codeableConcept.coding;
            foreach r4:Coding coding in codings {
                if (coding.system != "http://terminology.hl7.org/CodeSystem/v3-ActCode") {
                    types.push({
                        coding: [coding]
                    });
                }
            }
        }
        if codeableConcept.text is string {
            types.push(codeableConcept);
        }
    }
    return types;
}

# Maps C-CDA effectiveTime to FHIR encounter period
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + return - FHIR encounter period
isolated function mapEncounterPeriod(xml document) returns r4:Period? {
    xml? effectiveTime = document/<v3:effectiveTime|effectiveTime>;
    if (effectiveTime !is xml || effectiveTime.length() == 0) {
        return ();
    }

    return mapCcdaParticipantTimeToFhirPeriod(effectiveTime);
}

# Maps C-CDA dischargeDispositionCode to FHIR hospitalization
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + parentDocument - C-CDA document XML element
# + return - FHIR hospitalization
isolated function mapHospitalization(xml document, xml parentDocument) returns uscore501:USCoreEncounterProfileHospitalization? {
    uscore501:USCoreEncounterProfileHospitalization hospitalization = {};

    // Check both possible locations of dischargeDispositionCode
    xml? dischargeCode = document/<sdtc:dischargeDispositionCode>;
    if (dischargeCode !is xml || dischargeCode.length() == 0) {
        dischargeCode = document/<v3:dischargeDispositionCode|dischargeDispositionCode>;
    }

    if (dischargeCode is xml && dischargeCode.length() > 0) {
        r4:CodeableConcept? codeableConcept = mapCcdaCodingToFhirCodeableConcept(dischargeCode, parentDocument);
        if (codeableConcept is r4:CodeableConcept) {
            hospitalization.dischargeDisposition = codeableConcept;
        }
    }
    if hospitalization.keys().length() == 0 {
        return ();
    }

    return hospitalization;
}

# Maps C-CDA performer/encounterParticipant to FHIR encounter participants
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + parentDocument - C-CDA document XML element
# + return - FHIR encounter participants
isolated function mapEncounterParticipants(xml document, xml parentDocument) returns [uscore501:USCoreEncounterProfileParticipant[], uscore501:USCorePractitionerProfile[]] {
    uscore501:USCoreEncounterProfileParticipant[] participants = [];
    uscore501:USCorePractitionerProfile[] practitioners = [];

    // Map performers (body)
    xml<xml:Element>[] performers = from xml item in document/<v3:performer|performer>
        select item;
    foreach xml performer in performers {
        string|error typeCode = performer.typeCode;
        if typeCode is string && typeCode == "PRF" {
            xml? assignedEntity = performer/<v3:assignedEntity>;
            if assignedEntity is xml {
                string|error classCode = assignedEntity.classCode;
                if classCode is string && classCode == "ASSIGNED" {
                    uscore501:USCorePractitionerProfile? practitioner = ccdaToPractitioner(performer, parentDocument);
                    if practitioner is uscore501:USCorePractitionerProfile {
                        uscore501:USCoreEncounterProfileParticipant participant = {
                            individual: {
                                'type: "Practitioner",
                                reference: string `Practitioner/${<string>practitioner.id}`
                            }
                        };
                        participants.push(participant);
                        practitioners.push(practitioner);
                    }
                }
            }
        }
    }

    // Map encounterParticipants (header)
    xml<xml:Element>[] encounterParticipants = from xml item in document/<v3:encounterParticipant|encounterParticipant>
        select item;
    foreach xml encounterParticipant in encounterParticipants {
        string|error typeCode = encounterParticipant.typeCode;
        if typeCode is string {
            r4:CodeableConcept? typeConcept = mapCcdaParticipantTypeToFhirType(typeCode);
            if typeConcept is r4:CodeableConcept {
                uscore501:USCoreEncounterProfileParticipant participant = {
                    'type: [typeConcept],
                    individual: mapCcdaParticipantToFhirPractitioner(encounterParticipant)
                };
                participants.push(participant);
            }
        }
    }
    return [participants, practitioners];
}

# Maps C-CDA location to FHIR encounter locations
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + return - FHIR encounter locations
isolated function mapEncounterLocationsForEncounterActivity(xml document) returns uscore501:USCoreEncounterProfileLocation[] {
    uscore501:USCoreEncounterProfileLocation[] locations = [];

    // Map locations from body
    xml<xml:Element>[] bodyLocations = from xml item in document/<v3:participant|participant>
        select item;
    foreach xml location in bodyLocations {
        string|error typeCode = location.typecode;
        if typeCode is string {
            if typeCode == "LOC" {
                locations.push({
                    location: mapCcdaParticipantToFhirLocation(location)
                });
            }
        }
    }

    // Map locations from header
    xml<xml:Element>[] headerLocations = from xml item in document/<v3:location|location>
        select item;
    foreach xml location in headerLocations {
        locations.push({
            location: mapCcdaParticipantToFhirLocation(location)
        });
    }

    return locations;
}

# Maps C-CDA location to FHIR encounter locations for encompassingEncounter
#
# + document - C-CDA EncompassingEncounter XML element
# + return - FHIR encounter locations
isolated function mapEncounterLocationsForEncompassingEncounter(xml document) returns uscore501:USCoreEncounterProfileLocation[] {
    uscore501:USCoreEncounterProfileLocation[] locations = [];

    // Map locations from body
    xml<xml:Element>[] bodyLocations = from xml item in document/<v3:location|location>
        select item;
    foreach xml location in bodyLocations {
        locations.push({
            location: mapCcdaParticipantToFhirLocation(location)
        });
    }

    return locations;
}

# Maps C-CDA indication to FHIR encounter reasonCode
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + parentDocument - C-CDA document XML element
# + return - FHIR encounter reasonCode
isolated function mapEncounterReasonCode(xml document, xml parentDocument) returns r4:CodeableConcept[]? {
    r4:CodeableConcept[] reasons = [];

    xml<xml:Element>[] indications = from xml item in document/<v3:entryRelationship|entryRelationship>/<v3:observation|observation>
        select item;
    foreach xml indication in indications {
        string|error typeCode = indication.typecode;
        if typeCode is string {
            if typeCode == "RSON" {
                xml? value = indication/<v3:value|value>;
                if (value is xml && value.length() > 0) {
                    r4:CodeableConcept? codeableConcept = mapCcdaCodingToFhirCodeableConcept(value, parentDocument);
                    if (codeableConcept is r4:CodeableConcept) {
                        reasons.push(codeableConcept);
                    }
                }
            }
        }
    }
    if (reasons.length() > 0) {
        return reasons;
    }
    return ();
}

# Maps C-CDA encounter diagnosis to FHIR encounter diagnosis
#
# + document - C-CDA Encounter Activity or EncompassingEncounter XML element
# + parentDocument - C-CDA document XML element
# + return - FHIR encounter diagnosis
isolated function mapEncounterDiagnosis(xml document, xml parentDocument) returns [uscore501:USCoreEncounterProfileDiagnosis[], uscore501:USCoreCondition[]] {
    uscore501:USCoreEncounterProfileDiagnosis[] diagnoses = [];
    uscore501:USCoreCondition[] conditions = [];

    xml<xml:Element>[] diagnosisActs = from xml item in document/<v3:entryRelationship|entryRelationship>/<v3:act|act>
        select item;
    foreach xml diagnosisAct in diagnosisActs {
        xml? xmlResult = diagnosisAct/<v3:code|code>;
        if xmlResult is xml && xmlResult.length() > 0 {
            string|error code = xmlResult.code;
            if code is string {
                if code == "29308-4" {
                    xml? observation = diagnosisAct/<v3:entryRelationship|entryRelationship>/<v3:observation|observation>;
                    if (observation is xml && observation.length() > 0) {
                        xml? idElement = observation/<v3:id|id>;
                        if idElement is xml && idElement.length() > 0 {
                            string|error id = idElement.extension;
                            if id is string {
                                diagnoses.push({
                                    condition: {
                                        reference: id
                                    }
                                });
                                xml sectionElement = xml `<section>
                                    <code code="46240-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
                                </section>`;
                                uscore501:USCoreCondition? condition = ccdaToCondition(sectionElement, diagnosisAct, parentDocument);
                                if condition is uscore501:USCoreCondition {
                                    conditions.push(condition);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return [diagnoses, conditions];
}
