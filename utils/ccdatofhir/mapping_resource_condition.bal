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
import ballerinax/health.fhir.r4.international401;

# Map CCDA Problem Observation to FHIR Condition.
#
# + actElement - actElement for CCDA Problem Observation
# + return - FHIR Condition
public isolated function mapCcdaConditionToFhir(xml actElement) returns international401:Condition? {
    if isXMLElementNotNull(actElement) {
        international401:Condition condition = {subject: {}};

        xml idElement = actElement/<v3:id|id>;
        xml effectiveTimeLowElement = actElement/<v3:effectiveTime|effectiveTime>/<v3:low|low>;
        xml effectiveTimeHighElement = actElement/<v3:effectiveTime|effectiveTime>/<v3:high|high>;
        xml valueElement = actElement/<v3:value|value>;
        xml authorElement = actElement/<v3:author|author>;
        xml observationValueElement = actElement/<v3:entryRelationship|entryRelationship>/<v3:observation|observation>/<v3:value|value>;

        int index = 0;
        foreach xml idElem in idElement {
            r4:Identifier? mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idElem);
            if mapCcdaIdToFhirIdentifierResult is r4:Identifier {
                condition.identifier[index] = mapCcdaIdToFhirIdentifierResult;
                index = index + 1;
            }
        }

        r4:dateTime? mapCCDALowEffectiveTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeLowElement);
        if mapCCDALowEffectiveTimetoFHIRDateTimeResult is r4:dateTime {
            condition.onsetDateTime = mapCCDALowEffectiveTimetoFHIRDateTimeResult;
        }

        r4:dateTime? mapCCDAHighEffectiveTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeHighElement);
        if mapCCDAHighEffectiveTimetoFHIRDateTimeResult is r4:dateTime {
            condition.abatementDateTime = mapCCDAHighEffectiveTimetoFHIRDateTimeResult;
        }

        r4:CodeableConcept? codeableConcept = mapCcdaCodingtoFhirCodeableConcept(valueElement);
        if codeableConcept is r4:CodeableConcept {
            condition.code = codeableConcept;
        }

        xml assignedAuthorElement = authorElement/<v3:assignedAuthor|assignedAuthor>;
        xml assignedAuthorIdElement = assignedAuthorElement/<v3:id|id>;

        string|error? assignedAuthorIdVal = assignedAuthorIdElement.root;
        if assignedAuthorIdVal is string && assignedAuthorIdVal.trim() != "" {
            condition.recorder = {reference: string `Provenance/${assignedAuthorIdVal}`};
        }

        r4:code? mapCcdatoFhirProblemStatusResult = mapCcdatoFhirProblemStatus(observationValueElement);
        if mapCcdatoFhirProblemStatusResult is r4:code {
            r4:CodeableConcept observationCodeableConcept = {coding: [{code: mapCcdatoFhirProblemStatusResult}]};
            condition.clinicalStatus = observationCodeableConcept;
        }
        return condition;
    } else {
        return ();
    }
}

isolated function mapCcdatoFhirProblemStatus(xml codingElement) returns string {
    string|error? codeVal = codingElement.code;
    if codeVal !is string {
        return "active";
    }
    match codeVal {
        "246455001" => {
            return "recurrence";
        }
        "263855007" => {
            return "relapse";
        }
        "277022003" => {
            return "remission";
        }
        "413322009" => {
            return "resolved";
        }
        "55561003" => {
            return "active";
        }
        "73425007" => {
            return "inactive";
        }
        _ => {
            return "active";
        }
    }
}
