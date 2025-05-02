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

import ballerina/log;
import ballerina/time;
import ballerina/uuid;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

# Map CCDA Allergy to FHIR AllergyIntolerance.
#
# + actElement - xml content of the CCDA Allergy Activity
# + parentDocument - original CCDA document
# + return - FHIR Allergy Intolerance
isolated function ccdaToAllergyIntolerance(xml actElement, xml parentDocument) returns [uscore501:USCoreAllergyIntolerance, uscore501:USCoreProvenance?]? {
    uscore501:USCoreAllergyIntolerance allergyIntolerance = {patient: {}, code: {}};

    if isXMLElementNotNull(actElement) {
        string|error? negationInd = actElement.negationInd;
        xml statusCodeElements = actElement/<v3:statusCode|statusCode>;
        xml idElement = actElement/<v3:id|id>;
        xml valueElement = actElement/<v3:value|value>;
        xml entryRelationshipElement = actElement/<v3:entryRelationship|entryRelationship>;
        xml authorElement = entryRelationshipElement/<v3:observation|observation>/<v3:author|author>;
        xml participantElement = entryRelationshipElement/<v3:observation|observation>/<v3:participant|participant>;
        xml effectiveTimeElement = entryRelationshipElement/<v3:observation|observation>/<v3:effectiveTime|effectiveTime>;

        foreach xml statusCodeElement in statusCodeElements {
            string|error? statusCode = statusCodeElement.code;
            if statusCode is string {
                allergyIntolerance.clinicalStatus.coding = [{code: statusCode}];
            } else {
                log:printDebug("status code is not available", statusCode);
            }
        }

        r4:Identifier[] identifier = [];
        foreach xml idEle in idElement {
            r4:Identifier? mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idEle);
            if mapCcdaIdToFhirIdentifierResult is r4:Identifier {
                identifier.push(mapCcdaIdToFhirIdentifierResult);
            }
        }
        allergyIntolerance.identifier = identifier;

        xml lowEffectiveTimeElement = effectiveTimeElement/<v3:low|low>;
        r4:dateTime? mapCCDALowEffectiveTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(lowEffectiveTimeElement);
        if mapCCDALowEffectiveTimetoFHIRDateTimeResult is r4:dateTime {
            allergyIntolerance.onsetDateTime = mapCCDALowEffectiveTimetoFHIRDateTimeResult;
        }

        uscore501:USCoreAllergyIntoleranceCategory? mapCCDAValueToFHIRCategoryResult = mapCcdaValueToFhirAllergyIntoleranceCategory(valueElement);
        if mapCCDAValueToFHIRCategoryResult is uscore501:USCoreAllergyIntoleranceCategory {
            allergyIntolerance.category = [mapCCDAValueToFHIRCategoryResult];
        }

        uscore501:USCoreAllergyIntoleranceType? mapCCDAValueToFHIRTypeResult = mapCcdaValueToFhirAllergyIntoleranceType(valueElement);
        if mapCCDAValueToFHIRTypeResult is uscore501:USCoreAllergyIntoleranceType {
            allergyIntolerance.'type = mapCCDAValueToFHIRTypeResult;
        }

        xml assignedAuthorTimeElement = authorElement/<v3:time|time>;
        allergyIntolerance.recordedDate = mapCcdaDateTimeToFhirDateTime(assignedAuthorTimeElement);

        xml assignedAuthorElement = authorElement/<v3:assignedAuthor|assignedAuthor>;
        xml assignedAuthorIdElement = assignedAuthorElement/<v3:id|id>;
        // id value is in the extension
        string|error? assignedAuthorIdVal = assignedAuthorIdElement.extension;
        if assignedAuthorIdVal is string && assignedAuthorIdVal.trim() != "" {
            allergyIntolerance.recorder = {reference: string `Practitioner/${assignedAuthorIdVal}`};
        }

        xml participantRoleElement = participantElement/<v3:participantRole|participantRole>;
        xml playingEntityElement = participantRoleElement/<v3:playingEntity|playingEntity>;
        xml playingEntityCodeElement = playingEntityElement/<v3:code|code>;

        string|error? playingEntityCodeNullFlavor = playingEntityCodeElement.nullFlavor;
        r4:CodeableConcept? playingEntityCodeableConcept = mapCcdaCodingToFhirCodeableConcept(playingEntityCodeElement, parentDocument);

        if (negationInd is string && negationInd == "true") && playingEntityCodeNullFlavor is string {
            if playingEntityCodeableConcept is r4:CodeableConcept {
                r4:Coding[]? codings = playingEntityCodeableConcept?.coding;
                if codings is r4:Coding[] {
                    r4:Coding[] newCodings = [];
                    string? code = ();
                    foreach r4:Coding coding in codings {
                        match coding.code {
                            "414285001" => {
                                code = "429625007";
                            }
                            "416098002" => {
                                code = "416098002";
                            }
                            "419199007" => {
                                code = "716186003";
                            }
                        }
                        coding.code = code;
                        newCodings.push(coding);
                    }
                    playingEntityCodeableConcept = {coding: newCodings};
                }
            }
        }

        if playingEntityCodeableConcept is r4:CodeableConcept {
            allergyIntolerance.code = playingEntityCodeableConcept;
        }

        r4:CodeableConcept? clinicalStatus = mapCcdaCodingToFhirCodeableConcept(statusCodeElements, parentDocument);
        if clinicalStatus is r4:CodeableConcept {
            r4:Coding[]? coding = clinicalStatus.coding;
            if coding is r4:Coding[] {
                foreach r4:Coding code in coding {
                    code.system = "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical";
                }
                allergyIntolerance.clinicalStatus = clinicalStatus;
            }
        }

        xml observationElement = entryRelationshipElement/<v3:observation|observation>;
        xml observationValueElement = observationElement/<v3:value|value>;
        xml observationIdElement = observationElement/<v3:id|id>;

        r4:CodeableConcept? manifestation = mapCcdaCodingToFhirCodeableConcept(observationValueElement, parentDocument);
        if manifestation is r4:CodeableConcept {
            uscore501:USCoreAllergyIntoleranceReaction reaction = {
                manifestation: [manifestation]
            };

            string|error? typeCode = entryRelationshipElement.typeCode;
            if typeCode == "MFST" {
                // Find Severity Observation entryRelationship
                xml severityObservationCodeElement = entryRelationshipElement/<v3:observation|observation>/<v3:entryRelationship|entryRelationship>/<v3:observation|observation>/<v3:code|code>;
                if isXMLElementNotNull(severityObservationCodeElement) {
                    string|error? severityCode = severityObservationCodeElement.code;
                    if severityCode is string && severityCode == "SEV" {
                        xml severityValueElement = severityObservationCodeElement/<v3:value|value>;
                        uscore501:USCoreAllergyIntoleranceReactionSeverity? severity = mapCcdaSeverityToFhirSeverity(severityValueElement);
                        if severity is uscore501:USCoreAllergyIntoleranceReactionSeverity {
                            reaction.severity = severity;
                        }
                    }
                }
                string|error? reactionId = observationIdElement.root;
                if reactionId is string {
                    reaction.id = reactionId;
                } else {
                    log:printDebug("reactionId is not available", reactionId);
                }
            } else if typeCode is string && typeCode != "MFST" {
                log:printDebug(string `typeCode ${typeCode} is not MFST`);
            } else if typeCode is error {
                log:printDebug("typeCode is not available", typeCode);
            }
            allergyIntolerance.reaction = [reaction];
        }
        //generate the id for the allergyIntolerance
        allergyIntolerance.id = uuid:createRandomUuid();

        // Provenance mapping
        uscore501:USCoreProvenance? provenance = ();
        if isXMLElementNotNull(assignedAuthorElement) {
            if assignedAuthorIdVal is string && assignedAuthorIdVal.trim() != "" {
                provenance = {
                    target: [{reference: string `AllergyIntolerance/${<string>allergyIntolerance.id}`}],
                    agent: [
                        {
                            who: {reference: string `Practitioner/${assignedAuthorIdVal}`}
                        }
                    ],
                    //add time now
                    recorded: time:utcNow().toString()
                };
            }
        }

        return [allergyIntolerance, provenance];
    } else {
        log:printDebug("AllergyIntolerance not available");
        return ();
    }
}

isolated function mapCcdaValueToFhirAllergyIntoleranceCategory(xml valueElement) returns uscore501:USCoreAllergyIntoleranceCategory? {
    string|error? codeVal = valueElement.code;
    if codeVal !is string {
        log:printDebug("code value not available", codeVal);
        return ();
    }
    match codeVal {
        "235719002" => {
            return uscore501:CODE_CATEGORY_FOOD;
        }
        "416098002" => {
            return uscore501:CODE_CATEGORY_MEDICATION;
        }
        "414285001" => {
            return uscore501:CODE_CATEGORY_FOOD;
        }
        "418471000" => {
            return uscore501:CODE_CATEGORY_FOOD;
        }
        "419511003" => {
            return uscore501:CODE_CATEGORY_MEDICATION;
        }
        "59037007" => {
            return uscore501:CODE_CATEGORY_MEDICATION;
        }
        _ => {
            log:printDebug("matching code value not available");
            return ();
        }
    }
}

isolated function mapCcdaValueToFhirAllergyIntoleranceType(xml valueElement) returns uscore501:USCoreAllergyIntoleranceType? {
    string|error? codeVal = valueElement.code;
    if codeVal !is string {
        log:printDebug("code value is not available", codeVal);
        return ();
    }
    match codeVal {
        "235719002" => {
            return uscore501:CODE_TYPE_INTOLERANCE;
        }
        "416098002" => {
            return uscore501:CODE_TYPE_ALLERGY;
        }
        "414285001" => {
            return uscore501:CODE_TYPE_ALLERGY;
        }
        "419199007" => {
            return uscore501:CODE_TYPE_ALLERGY;
        }
        "59037007" => {
            return uscore501:CODE_TYPE_INTOLERANCE;
        }
        _ => {
            log:printDebug("matching code value not available");
            return ();
        }
    }
}

isolated function mapCcdaSeverityToFhirSeverity(xml valueElement) returns uscore501:USCoreAllergyIntoleranceReactionSeverity? {
    string|error? codeVal = valueElement.code;
    if codeVal !is string {
        log:printDebug("severity code value not available", codeVal);
        return ();
    }
    match codeVal {
        "255604002" => { // Mild
            return uscore501:CODE_SEVERITY_MILD;
        }
        "6736007" => { // Moderate
            return uscore501:CODE_SEVERITY_MODERATE;
        }
        "24484000" => { // Severe
            return uscore501:CODE_SEVERITY_SEVERE;
        }
        _ => {
            log:printDebug("matching severity code value not available");
            return ();
        }
    }
}

# Map C-CDA telecom to FHIR ContactPoint.
#
# + telecomElement - C-CDA telecom element
# + return - Return FHIR ContactPoint
public isolated function mapCcdaTelecomToFhirContactPoint(xml telecomElement) returns r4:ContactPoint? {
    string|error? telecomUse = telecomElement.use;
    string|error? telecomValue = telecomElement.value;

    string? systemVal = ();
    string? valueVal = ();
    if telecomValue is string {
        string[] valTokens = re `:`.split(telecomValue);
        if valTokens.length() == 1 {
            systemVal = r4:other;
            valueVal = telecomValue;
        } else {
            systemVal = valTokens[0];
            valueVal = valTokens[1];
            
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
            "PG" => {
                useVal = "work";
            }
        }
    } else {
        log:printDebug("Telecom use not available", telecomUse);
    }

    if systemVal is string && valueVal is string {
        return {
            system: <r4:ContactPointSystem> systemVal,
            value: valueVal,
            use: useVal
        };
    }
    log:printDebug("telecom fields not available");
    return ();
}
