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
import ballerinax/health.fhir.r4.uscore501;
import ballerina/uuid;

# Map CCDA Immunization Activity to FHIR Immunization.
#
# + substanceAdministrationElement - CCDA Immunization Activity Element
# + parentDocument - CCDA Document
# + return - FHIR Immunization Resource
isolated function ccdaToImmunization(xml substanceAdministrationElement, xml parentDocument) returns uscore501:USCoreImmunizationProfile? {
    if isXMLElementNotNull(substanceAdministrationElement) {
        uscore501:USCoreImmunizationProfile immunization = {primarySource: false, patient: {}, occurrenceDateTime: "", occurrenceString: "", vaccineCode: {}, status: "not-done"};

        xml idElement = substanceAdministrationElement/<v3:id|id>;
        xml statusCodeElement = substanceAdministrationElement/<v3:statusCode|statusCode>;
        xml effectiveTimeElement = substanceAdministrationElement/<v3:effectiveTime|effectiveTime>;
        xml repeatNumberElement = substanceAdministrationElement/<v3:repeatNumber|repeatNumber>;
        xml routeCodeElement = substanceAdministrationElement/<v3:routeCode|routeCode>;
        xml approachSiteCodeElement = substanceAdministrationElement/<v3:approachSiteCode|approachSiteCode>;
        xml doseQuantityElement = substanceAdministrationElement/<v3:doseQuantity|doseQuantity>;
        xml vaccineCodeElement = substanceAdministrationElement/<v3:consumable|consumable>/<v3:manufacturedProduct|manufacturedProduct>/<v3:manufacturedMaterial|manufacturedMaterial>/<v3:code|code>;
        xml lotNumberTextElement = substanceAdministrationElement/<v3:consumable|consumable>/<v3:manufacturedProduct|manufacturedProduct>/<v3:manufacturedMaterial|manufacturedMaterial>/<v3:lotNumberText|lotNumberText>;
        xml performerElement = substanceAdministrationElement/<v3:performer|performer>;
        xml entryRelationship = substanceAdministrationElement/<v3:entryRelationship|entryRelationship>;

        r4:Identifier[] identifier = [];
        foreach xml idElem in idElement {
            r4:Identifier? mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idElem);
            if mapCcdaIdToFhirIdentifierResult is r4:Identifier {
                identifier.push(mapCcdaIdToFhirIdentifierResult);
            }
        }
        immunization.identifier = identifier;

        immunization.status = mapCcdaStatusCodeToFhirImmunizationStatus(statusCodeElement);

        r4:dateTime? mapCCDAEffectiveTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeElement);
        if mapCCDAEffectiveTimetoFHIRDateTimeResult is r4:dateTime {
            immunization.occurrenceDateTime = mapCCDAEffectiveTimetoFHIRDateTimeResult;
        }

        string|error? repeatNumber = repeatNumberElement.value;
        if repeatNumber is string && repeatNumber != "" {
            int|error repeatNumberValue = int:fromString(repeatNumber);
            if repeatNumberValue is int {
                immunization.protocolApplied = [{doseNumberString: repeatNumber, doseNumberPositiveInt: repeatNumberValue}];
            } else {
                log:printDebug("Repeat Number is not available", repeatNumberValue);
            }
        } else {
            log:printDebug("Repeat Number is not available");
        }

        immunization.route = mapCcdaCodingToFhirCodeableConcept(routeCodeElement, parentDocument);
        immunization.site = mapCcdaCodingToFhirCodeableConcept(approachSiteCodeElement, parentDocument);

        string|error? doseQuantityUnit = doseQuantityElement.unit;
        r4:Quantity immunizationDoseQuantity = {};
        if doseQuantityUnit is string {
            immunizationDoseQuantity.unit = doseQuantityUnit;
        } else {
            log:printDebug("Dose Quantity Unit is not available", doseQuantityUnit);
        }

        string|error? doseQuantityValue = doseQuantityElement.value;
        if doseQuantityValue is string {
            decimal|error doseQuantityDecimalValue = decimal:fromString(doseQuantityValue);
            if doseQuantityDecimalValue is decimal {
                immunizationDoseQuantity.value = doseQuantityDecimalValue;
                immunization.doseQuantity = immunizationDoseQuantity;
            } else {
                log:printDebug("Dose Quantity Value is not available", doseQuantityDecimalValue);
            }
        } else {
            log:printDebug("Dose Quantity Value is not available", doseQuantityValue);
        }

        r4:CodeableConcept? mapCcdaCodingtoFhirCodeableConceptResult = mapCcdaCodingToFhirCodeableConcept(vaccineCodeElement, parentDocument);
        if mapCcdaCodingtoFhirCodeableConceptResult is r4:CodeableConcept {
            immunization.vaccineCode = mapCcdaCodingtoFhirCodeableConceptResult;
        }

        string lotNumber = lotNumberTextElement.data();
        if lotNumber != "" {
            immunization.lotNumber = lotNumber;
        }

        xml assignedEntityElement = performerElement/<v3:assignedEntity|assignedEntity>;
        xml assignedEntityIdElement = assignedEntityElement/<v3:id|id>;

        string|error? assignedEntityId = assignedEntityIdElement.root;
        if assignedEntityId is string {
            uscore501:USCoreImmunizationProfilePerformer performer = {
                actor: {
                    identifier: {
                        id: assignedEntityId
                    }
                },
                'function: {
                    coding: [
                        {
                            code: "AP"
                        }
                    ]
                }
            };
            immunization.performer = [performer];
        } else {
            log:printDebug("assignedEntityId is not available", assignedEntityId);
        }

        string|error? typeCode = entryRelationship.typeCode;
        if typeCode is string && typeCode == "RSON" {
            xml entryRelationshipObservationCodeElement = entryRelationship/<v3:observation|observation>/<v3:code|code>;
            r4:CodeableConcept? statusReason = mapCcdaRefusalReasonToFhirStatusReason(entryRelationshipObservationCodeElement);
            if statusReason is r4:CodeableConcept {
                immunization.statusReason = statusReason;
            }
        } else if typeCode is string && typeCode == "MFST" {
            xml entryRelationshipObservationElement = entryRelationship/<v3:observation|observation>;
            xml reference = entryRelationshipObservationElement/<v3:text|text>/<v3:reference|reference>;
            string|error? referenceValue = reference.value;
            if referenceValue is string {
                uscore501:USCoreImmunizationProfileReaction immunizationReaction = {
                    detail: {
                        reference: referenceValue
                    }
                };
                immunization.reaction = [immunizationReaction];
            }
        }

        xml codeElement = entryRelationship/<v3:act|act>/<v3:code|code>;
        string|error? code = codeElement.code;
        if code is string {
            if code == "48767-8" {
                xml textElement = entryRelationship/<v3:act|act>/<v3:text|text>;
                string text = textElement.data();
                immunization.note = [{text: text}];
            }
        }
        //generate the id for the immunization
        immunization.id = uuid:createRandomUuid();
        return immunization;
    }
    return ();
}

isolated function mapCcdaRefusalReasonToFhirStatusReason(xml codingElement) returns r4:CodeableConcept? {
    if isXMLElementNotNull(codingElement) {
        r4:CodeableConcept mapCcdaCodingtoFhirCodeableConceptResult = {};
        string|error? codeVal = codingElement.value;
        if codeVal is string {
            string? code;
            match codeVal {
                "IMMUNE" => {
                    code = "IMMUNE";
                }
                "MEDPREC" => {
                    code = "MEDPREC";
                }
                "OSTOCK" => {
                    code = "OSTOCK";
                }
                "PATOBJ" => {
                    code = "PATOBJ";
                }
                _ => {
                    code = ();
                }
            }
            mapCcdaCodingtoFhirCodeableConceptResult = {
                coding: [
                    {
                        code: code
                    }
                ]
            };
        }

        string|error? codeSystem = codingElement.codeSystem;
        if codeSystem is string {
            mapCcdaCodingtoFhirCodeableConceptResult.coding[0].system = codeSystem;
        }

        string|error? displayName = codingElement.displayName;
        if displayName is string {
            mapCcdaCodingtoFhirCodeableConceptResult.coding[0].display = displayName;
        }
        return mapCcdaCodingtoFhirCodeableConceptResult;
    }
    return ();
}

isolated function mapCcdaStatusCodeToFhirImmunizationStatus(xml codingElement) returns uscore501:USCoreImmunizationProfileStatus {
    string|error? codeVal = codingElement.code;

    if codeVal !is string {
        return uscore501:CODE_STATUS_NOT_DONE;
    }

    match codeVal {
        "aborted" => {
            return uscore501:CODE_STATUS_NOT_DONE;
        }
        "cancelled" => {
            return uscore501:CODE_STATUS_NOT_DONE;
        }
        "completed" => {
            return uscore501:CODE_STATUS_COMPLETED;
        }
        "held" => {
            return uscore501:CODE_STATUS_NOT_DONE;
        }
        "new" => {
            return uscore501:CODE_STATUS_NOT_DONE;
        }
        "nullified" => {
            return uscore501:CODE_STATUS_ENTERED_IN_ERROR;
        }
        "obsolete" => {
            return uscore501:CODE_STATUS_NOT_DONE;
        }
        "suspended" => {
            return uscore501:CODE_STATUS_NOT_DONE;
        }
        _ => {
            return uscore501:CODE_STATUS_NOT_DONE;
        }
    }
}

isolated function mapCcdaToFhirImmunizationSite(xml codingElement) returns string? {
    string codeVal = codingElement.data();
    match codeVal {
        "368208006" => {
            return "LA";
        }
        "368209003" => {
            return "RA";
        }
        _ => {
            return ();
        }
    }
}
