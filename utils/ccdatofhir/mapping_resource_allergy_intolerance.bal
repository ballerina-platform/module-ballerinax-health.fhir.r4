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
import ballerinax/health.fhir.r4;

# Map CCDA Allergy to FHIR AllergyIntolerance.
#
# + actElement - xml content of the CCDA Allergy Activity
# + return - FHIR Allergy Intolerance
public isolated function mapCcdaAllergyToFhir(xml actElement) returns r4:AllergyIntolerance? {
    r4:AllergyIntolerance allergyIntolerance = {patient: {}};

    if isXMLElementNotNull(actElement) {
        xml statusCodeElements = actElement/<v3:statusCode|statusCode>;
        xml idElement = actElement/<v3:id|id>;
        xml effectiveTimeElement = actElement/<v3:effectiveTime|effectiveTime>;
        xml valueElement = actElement/<v3:value|value>;
        xml authorElement = actElement/<v3:author|author>;
        xml participantElement = actElement/<v3:participant|participant>;
        xml entryRelationshipElement = actElement/<v3:entryRelationship|entryRelationship>;

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

        r4:AllergyIntoleranceCategory? mapCCDAValueToFHIRCategoryResult = mapCcdaValueToFhirAllergyIntoleranceCategory(valueElement);
        if mapCCDAValueToFHIRCategoryResult is r4:AllergyIntoleranceCategory {
            allergyIntolerance.category = [mapCCDAValueToFHIRCategoryResult];
        }

        r4:AllergyIntoleranceType? mapCCDAValueToFHIRTypeResult = mapCcdaValueToFhirAllergyIntoleranceType(valueElement);
        if mapCCDAValueToFHIRTypeResult is r4:AllergyIntoleranceType {
            allergyIntolerance.'type = mapCCDAValueToFHIRTypeResult;
        }

        xml assignedAuthorTimeElement = authorElement/<v3:time|time>;
        allergyIntolerance.recordedDate = mapCcdaDateTimeToFhirDateTime(assignedAuthorTimeElement);

        xml assignedAuthorElement = authorElement/<v3:assignedAuthor|assignedAuthor>;
        xml assignedAuthorIdElement = assignedAuthorElement/<v3:id|id>;

        string|error? assignedAuthorIdVal = assignedAuthorIdElement.root;
        if assignedAuthorIdVal is string && assignedAuthorIdVal.trim() != "" {
            allergyIntolerance.recorder = {reference: string `Patient/${assignedAuthorIdVal}`};
        }

        xml participantRoleElement = participantElement/<v3:participantRole|participantRole>;
        xml playingEntityElement = participantRoleElement/<v3:playingEntity|playingEntity>;

        r4:CodeableConcept? playingEntityCodeableConcept = mapCcdaCodingtoFhirCodeableConcept(playingEntityElement);
        if playingEntityCodeableConcept is r4:CodeableConcept {
            allergyIntolerance.code = playingEntityCodeableConcept;
        }

        xml observationElement = entryRelationshipElement/<v3:observation|observation>;
        xml observationValueElement = observationElement/<v3:value|value>;
        xml observationIdElement = observationElement/<v3:id|id>;

        r4:CodeableConcept? clinicalStatus = mapCcdaCodingtoFhirCodeableConcept(observationValueElement);
        if clinicalStatus is r4:CodeableConcept {
            allergyIntolerance.clinicalStatus = clinicalStatus;
        }

        r4:CodeableConcept? manifestation = mapCcdaCodingtoFhirCodeableConcept(observationValueElement);
        if manifestation is r4:CodeableConcept {
            r4:AllergyIntoleranceReaction reaction = {
                manifestation: [manifestation]
            };

            string|error? typeCode = entryRelationshipElement.typeCode;
            if typeCode == "MFST" {
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
        return allergyIntolerance;
    } else {
        log:printDebug("AllergyIntolerance not available");
        return ();
    }
}

isolated function mapCcdaValueToFhirAllergyIntoleranceCategory(xml valueElement) returns r4:AllergyIntoleranceCategory? {
    string|error? codeVal = valueElement.code;
    if codeVal !is string {
        log:printDebug("code value not available", codeVal);
        return ();
    }
    match codeVal {
        "235719002" => {
            return r4:CODE_CATEGORY_FOOD;
        }
        "416098002" => {
            return r4:CODE_CATEGORY_MEDICATION;
        }
        "414285001" => {
            return r4:CODE_CATEGORY_FOOD;
        }
        "418471000" => {
            return r4:CODE_CATEGORY_FOOD;
        }
        "419511003" => {
            return r4:CODE_CATEGORY_MEDICATION;
        }
        "59037007" => {
            return r4:CODE_CATEGORY_MEDICATION;
        }
        _ => {
            log:printDebug("matching code value not available");
            return ();
        }
    }
}

isolated function mapCcdaValueToFhirAllergyIntoleranceType(xml valueElement) returns r4:AllergyIntoleranceType? {
    string|error? codeVal = valueElement.code;
    if codeVal !is string {
        log:printDebug("code value is not available", codeVal);
        return ();
    }
    match codeVal {
        "235719002" => {
            return r4:CODE_TYPE_INTOLERANCE;
        }
        "416098002" => {
            return r4:CODE_TYPE_ALLERGY;
        }
        "414285001" => {
            return r4:CODE_TYPE_ALLERGY;
        }
        "419199007" => {
            return r4:CODE_TYPE_ALLERGY;
        }
        "59037007" => {
            return r4:CODE_TYPE_INTOLERANCE;
        }
        _ => {
            log:printDebug("matching code value not available");
            return ();
        }
    }
}
