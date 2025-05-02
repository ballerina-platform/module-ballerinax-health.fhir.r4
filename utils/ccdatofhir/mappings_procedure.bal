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

# Map CCDA Procedure Activity to FHIR Procedure
#
# + procedureElement - CCDA Procedure Activity Element
# + parentDocument - CCDA Document
# + return - FHIR Procedure Resource
isolated function ccdaToProcedure(xml procedureElement, xml parentDocument) returns uscore501:USCoreProcedureProfile? {
    if isXMLElementNotNull(procedureElement) {
        uscore501:USCoreProcedureProfile procedure = {subject: {}, status: "unknown",code: {}, performedDateTime: "", performedPeriod: {}};

        string|error? negationInd = procedureElement.negationInd;
        xml idElement = procedureElement/<v3:id|id>;
        xml codeElement = procedureElement/<v3:code|code>;
        xml statusCodeElement = procedureElement/<v3:statusCode|statusCode>;
        xml effectiveTimeElement = procedureElement/<v3:effectiveTime|effectiveTime>;
        xml effectiveTimeLowElement = procedureElement/<v3:effectiveTime|effectiveTime>/<v3:low|low>;
        xml effectiveTimeHighElement = procedureElement/<v3:effectiveTime|effectiveTime>/<v3:high|high>;
        xml targetSiteCodeElement = procedureElement/<v3:targetSiteCode|targetSiteCode>;
        xml performerElement = procedureElement/<v3:performer|performer>;
        xml participantElement = procedureElement/<v3:participant|participant>;
        xml entryRelationshipElements = procedureElement/<v3:entryRelationship|entryRelationship>;

        int index = 0;
        foreach xml idElem in idElement {
            r4:Identifier? mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idElem);
            if mapCcdaIdToFhirIdentifierResult is r4:Identifier {
                procedure.identifier[index] = mapCcdaIdToFhirIdentifierResult;
                index = index + 1;
            }
        }

        r4:CodeableConcept? mapCcdaCodeCodingtoFhirCodeCodeableConceptResult = mapCcdaCodingToFhirCodeableConcept(codeElement, parentDocument);
        if mapCcdaCodeCodingtoFhirCodeCodeableConceptResult is r4:CodeableConcept {
            procedure.code = mapCcdaCodeCodingtoFhirCodeCodeableConceptResult;
        }

        if negationInd == "true" {
            procedure.status = "not-done";
        } else {
            procedure.status = mapCcdatoFhirProcedureStatus(statusCodeElement);
        }

        r4:dateTime? mapCCDAEffectiveTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeElement);
        procedure.performedDateTime = mapCCDAEffectiveTimetoFHIRDateTimeResult;

        r4:dateTime? mapCCDAEffectiveLowTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeLowElement);
        procedure.performedPeriod.'start = mapCCDAEffectiveLowTimetoFHIRDateTimeResult;

        r4:dateTime? mapCCDAEffectiveHighTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeHighElement);
        procedure.performedPeriod.end = mapCCDAEffectiveHighTimetoFHIRDateTimeResult;

        r4:CodeableConcept? mapCcdaCodingtoFhirCodeableConceptResult = mapCcdaCodingToFhirCodeableConcept(targetSiteCodeElement, parentDocument);
        if mapCcdaCodingtoFhirCodeableConceptResult is r4:CodeableConcept {
            procedure.bodySite = [mapCcdaCodingtoFhirCodeableConceptResult];
        }

        xml assignedEntityElements = performerElement/<v3:assignedEntity|assignedEntity>;

        uscore501:USCoreProcedureProfilePerformer[] performers = [];
        foreach xml assignedEntityElement in assignedEntityElements {
            xml representedOrganizationElement = assignedEntityElement/<v3:representedOrganization|representedOrganization>;
            xml organizationIdElement = representedOrganizationElement/<v3:id|id>;

            string|error? id = organizationIdElement.root;

            if id is string {
                r4:Reference representedOrganizationReference = {
                    'type: "Organization",
                    reference: string `Organization/${id}`
                };

                uscore501:USCoreProcedureProfilePerformer performer = {
                    actor: {},
                    onBehalfOf: representedOrganizationReference
                };
                performers.push(performer);
            }
        }
        procedure.performer = performers;

        string|error? typeCode = participantElement.typeCode;
        if typeCode == "LOC" {
            xml participantRoleElement = participantElement/<v3:participantRole|participantRole>;
            xml roleIdElement = participantRoleElement/<v3:id|id>;

            string|error? id = roleIdElement.root;

            if id is string {
                r4:Reference locationReference = {
                    'type: "Location",
                    reference: string `Location/${id}`
                };
                procedure.location = locationReference;
            }
        }

        r4:CodeableConcept[] observationCodes = [];
        foreach xml entryRelationshipElement in entryRelationshipElements {
            xml obervationElement = entryRelationshipElement/<v3:observation|observation>;
            xml obervationCodeElement = obervationElement/<v3:code|code>;

            r4:CodeableConcept? observationCode = mapCcdaCodingToFhirCodeableConcept(obervationCodeElement, parentDocument);
            if observationCode is r4:CodeableConcept {
                observationCodes.push(observationCode);
            }
        }
        procedure.reasonCode = observationCodes;
        //generate id for procedure
        procedure.id = uuid:createRandomUuid();
        return procedure;
    }
    return ();
}

isolated function mapCcdatoFhirProcedureStatus(xml codingElement) returns uscore501:USCoreProcedureProfileStatus {
    string|error? codeVal = codingElement.code;
    if codeVal !is string {
        log:printDebug("code is not available in the code element", codeVal);
        return uscore501:CODE_STATUS_NOT_DONE;
    }
    match codeVal {
        "aborted" => {
            return uscore501:CODE_STATUS_STOPPED;
        }
        "active" => {
            return uscore501:CODE_STATUS_IN_PROGRESS;
        }
        "cancelled" => {
            return uscore501:CODE_STATUS_NOT_DONE;
        }
        "completed" => {
            return uscore501:CODE_STATUS_COMPLETED;
        }
        _ => {
            return uscore501:CODE_STATUS_NOT_DONE;
        }
    }
}
