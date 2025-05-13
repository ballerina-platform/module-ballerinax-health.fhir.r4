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

import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;
import ballerina/uuid;

# Map CCDA Diagnostic Report to FHIR Diagnostic Report.
#
# + organizerElement - organizer element of the CCDA Diagnostic Report
# + parentDocument - original CCDA document
# + return - FHIR Diagnostic Report
isolated function ccdaToDiagnosticReport(xml organizerElement, xml parentDocument) returns uscore501:USCoreDiagnosticReportProfileLaboratoryReporting? {
    if isXMLElementNotNull(organizerElement) {
        uscore501:USCoreDiagnosticReportProfileLaboratoryReporting diagnosticReport = {code: {}, subject: {}, category: [], status: "partial"};

        xml idElement = organizerElement/<v3:id|id>;
        xml statusCodeElement = organizerElement/<v3:statusCode|statusCode>;
        xml codeElement = organizerElement/<v3:code|code>;
        xml translationElement = codeElement/<v3:translation|translation>;
        xml effectiveTimeLowElement = organizerElement/<v3:effectiveTime|effectiveTime>/<v3:low|low>;
        xml effectiveTimeHighElement = organizerElement/<v3:effectiveTime|effectiveTime>/<v3:high|high>;
        xml effectiveTimeValueElement = organizerElement/<v3:effectiveTime|effectiveTime>/<v3:value|value>;

        r4:Identifier[] identifier = [];
        foreach xml idElem in idElement {
            r4:Identifier? mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idElem);
            if (mapCcdaIdToFhirIdentifierResult is r4:Identifier) {
                identifier.push(mapCcdaIdToFhirIdentifierResult);
            }
        }
        diagnosticReport.identifier = identifier;

        diagnosticReport.status = mapCcdatoFhirDiagnosticReportStatus(statusCodeElement);

        r4:CodeableConcept? mapCcdaCodingtoFhirCodeableConceptResult = mapCcdaCodingToFhirCodeableConcept(translationElement, parentDocument);
        if mapCcdaCodingtoFhirCodeableConceptResult is r4:CodeableConcept {
            diagnosticReport.code = mapCcdaCodingtoFhirCodeableConceptResult;
        } else {
            mapCcdaCodingtoFhirCodeableConceptResult = mapCcdaCodingToFhirCodeableConcept(codeElement, parentDocument);
            if mapCcdaCodingtoFhirCodeableConceptResult is r4:CodeableConcept {
                diagnosticReport.code = mapCcdaCodingtoFhirCodeableConceptResult;
            }
        }

        r4:dateTime? mapCCDAEffectiveLowTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeLowElement);
        if mapCCDAEffectiveLowTimetoFHIRDateTimeResult is r4:dateTime {
            diagnosticReport.effectivePeriod.'start = mapCCDAEffectiveLowTimetoFHIRDateTimeResult;
        }

        r4:dateTime? mapCCDAEffectiveHighTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeHighElement);
        if mapCCDAEffectiveHighTimetoFHIRDateTimeResult is r4:dateTime {
            diagnosticReport.effectivePeriod.end = mapCCDAEffectiveHighTimetoFHIRDateTimeResult;
        }

        r4:dateTime? mapCCDAEffectiveValueTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeValueElement);
        if mapCCDAEffectiveValueTimetoFHIRDateTimeResult is r4:dateTime {
            diagnosticReport.effectiveDateTime = mapCCDAEffectiveValueTimetoFHIRDateTimeResult;
        }
        //generate the id for the diagnostic report
        diagnosticReport.id = uuid:createRandomUuid();
        return diagnosticReport;
    }
    return ();
}

isolated function mapCcdatoFhirDiagnosticReportStatus(xml codingElement) returns uscore501:USCoreDiagnosticReportProfileLaboratoryReportingStatus {
    string codeVal = codingElement.data();
    return codeVal == "completed" ? uscore501:CODE_STATUS_FINAL : uscore501:CODE_STATUS_PARTIAL;
}
