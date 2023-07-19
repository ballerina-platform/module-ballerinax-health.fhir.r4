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

# Map CCDA Procedure Activity to FHIR Procedure
#
# + actElement - CCDA Procedure Activity Element
# + return - FHIR Procedure Resource
public isolated function mapCcdaProcedureToFhir(xml actElement) returns r4:Procedure? {
    if isXMLElementNotNull(actElement) {
        r4:Procedure procedure = {subject: {}, status: "unknown"};

        xml idElement = actElement/<v3:id|id>;
        xml codeElement = actElement/<v3:code|code>;
        xml statusCodeElement = actElement/<v3:statusCode|statusCode>;
        xml effectiveTimeLowElement = actElement/<v3:effectiveTime|effectiveTime>/<v3:low|low>;
        xml effectiveTimeHighElement = actElement/<v3:effectiveTime|effectiveTime>/<v3:high|high>;
        xml targetSiteCodeElement = actElement/<v3:targetSiteCode|targetSiteCode>;
        xml performerElement = actElement/<v3:performer|performer>;
        xml participantElement = actElement/<v3:participant|participant>;
        xml entryRelationshipElements = actElement/<v3:entryRelationship|entryRelationship>;

        int index = 0;
        foreach xml idElem in idElement {
            r4:Identifier? mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idElem);
            if mapCcdaIdToFhirIdentifierResult is r4:Identifier {
                procedure.identifier[index] = mapCcdaIdToFhirIdentifierResult;
                index = index + 1;
            }
        }

        procedure.code = mapCcdaCodingtoFhirCodeableConcept(codeElement);
        procedure.status = mapCcdatoFhirProcedureStatus(statusCodeElement);

        r4:dateTime? mapCCDAEffectiveLowTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeLowElement);
        procedure.performedPeriod.'start = mapCCDAEffectiveLowTimetoFHIRDateTimeResult;

        r4:dateTime? mapCCDAEffectiveHighTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeHighElement);
        procedure.performedPeriod.end = mapCCDAEffectiveHighTimetoFHIRDateTimeResult;

        r4:CodeableConcept? mapCcdaCodingtoFhirCodeableConceptResult = mapCcdaCodingtoFhirCodeableConcept(targetSiteCodeElement);
        if mapCcdaCodingtoFhirCodeableConceptResult is r4:CodeableConcept {
            procedure.bodySite = [mapCcdaCodingtoFhirCodeableConceptResult];
        }

        xml assignedEntityElements = performerElement/<v3:assignedEntity|assignedEntity>;

        r4:ProcedurePerformer[] performers = [];
        foreach xml assignedEntityElement in assignedEntityElements {
            xml representedOrganizationElement = assignedEntityElement/<v3:representedOrganization|representedOrganization>;
            xml organizationIdElement = representedOrganizationElement/<v3:id|id>;

            string|error? id = organizationIdElement.root;

            if id is string {
                r4:Reference representedOrganizationReference = {
                    'type: "Organization",
                    reference: string `Organization/${id}`
                };

                r4:ProcedurePerformer performer = {
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

            r4:CodeableConcept? observationCode = mapCcdaCodingtoFhirCodeableConcept(obervationCodeElement);
            if observationCode is r4:CodeableConcept {
                observationCodes.push(observationCode);
            }
        }
        procedure.reasonCode = observationCodes;
        return procedure;
    }
    return ();
}

isolated function mapCcdatoFhirProcedureStatus(xml codingElement) returns r4:ProcedureStatus {
    string|error? codeVal = codingElement.code;
    if codeVal !is string {
        log:printDebug("code is not available in the code element", codeVal);
        return r4:CODE_STATUS_NOT_DONE;
    }
    match codeVal {
        "aborted" => {
            return r4:CODE_STATUS_STOPPED;
        }
        "active" => {
            return r4:CODE_STATUS_IN_PROGRESS;
        }
        "cancelled" => {
            return r4:CODE_STATUS_NOT_DONE;
        }
        "completed" => {
            return r4:CODE_STATUS_COMPLETED;
        }
        _ => {
            return r4:CODE_STATUS_NOT_DONE;
        }
    }
}
