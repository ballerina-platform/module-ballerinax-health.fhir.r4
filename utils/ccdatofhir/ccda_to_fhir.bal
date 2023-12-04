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
import ballerinax/health.fhir.r4.international401;

# Transform an C-CDA message to FHIR.
#
# + ccda - C-CDA message as a xml
# + return - FHIR Bundle
public isolated function ccdaToFhir(xml? ccda) returns r4:Bundle|r4:FHIRError => ccda is xml ? transformToFhir(ccda) :
    r4:createFHIRError("Failed to parse C-CDA payload to xml", r4:ERROR, r4:INVALID_STRUCTURE);

isolated function transformToFhir(xml xmlDocument) returns r4:Bundle {
    xmlns "urn:hl7-org:v3" as v3;

    r4:BundleEntry[] entries = [];
    foreach var xmlPayload in xmlDocument {
        xml childElements = xmlPayload/<v3:recordTarget|recordTarget>;
        if childElements.length() > 0 {
            xml xmlContent = childElements.get(0);
            xml patientRoleElement = xmlContent/<v3:patientRole|patientRole>;
            international401:Patient? mapCCDAToFHIRPatientResult = mapCcdaPatientToFhir(patientRoleElement);
            if mapCCDAToFHIRPatientResult is international401:Patient {
                entries.push({'resource: mapCCDAToFHIRPatientResult});
            }
        }

        xml authorElement = xmlPayload/<v3:author|author>;
        international401:Practitioner? mapCCDAToFHIRPractitionerResult = mapCcdaPractitionerToFhir(authorElement);
        if mapCCDAToFHIRPractitionerResult is international401:Practitioner {
            entries.push({'resource: mapCCDAToFHIRPractitionerResult});
        }

        xml componentElements = xmlPayload/<v3:component|component>/<v3:structuredBody|structuredBody>/<v3:component|component>;
        foreach xml componentElement in componentElements {
            xml sectionElement = componentElement/<v3:section|section>;
            xml codeElement = sectionElement/<v3:code|code>;

            string|error? codeVal = codeElement.code;
            if codeVal !is string {
                continue;
            }
            xml entryElements = sectionElement/<v3:entry|entry>;
            foreach xml entryElement in entryElements {
                xml actElement = entryElement/<v3:act|act>;
                xml substanceAdministrationElement = entryElement/<v3:substanceAdministration|substanceAdministration>;
                xml procedureElement = entryElement/<v3:procedure|procedure>;
                xml organizerElement = entryElement/<v3:organizer|organizer>;

                anydata mapCCDAToFHIRResult;
                match codeVal {
                    CCDA_ALLERGY_CODE => {
                        mapCCDAToFHIRResult = mapCcdaAllergyToFhir(actElement);
                        if mapCCDAToFHIRResult is uscore501:USCoreAllergyIntolerance {
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_CONDITION_CODE => {
                        mapCCDAToFHIRResult = mapCcdaConditionToFhir(sectionElement, actElement);
                        if mapCCDAToFHIRResult is uscore501:USCoreCondition {
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_IMMUNIZATION_CODE => {
                        mapCCDAToFHIRResult = mapCcdaImmunizationToFhir(substanceAdministrationElement);
                        if mapCCDAToFHIRResult is uscore501:USCoreImmunizationProfile {
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_MEDICATION_CODE => {
                        mapCCDAToFHIRResult = mapCcdaMedicationToFhir(substanceAdministrationElement);
                        if mapCCDAToFHIRResult is uscore501:USCoreMedicationRequestProfile {
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_PROCEDURE_CODE => {
                        mapCCDAToFHIRResult = mapCcdaProcedureToFhir(procedureElement);
                        if mapCCDAToFHIRResult is uscore501:USCoreProcedureProfile {
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_DIAGNOSTIC_REPORT_CODE => {
                        mapCCDAToFHIRResult = mapCcdaDiagnosticReportToFhir(organizerElement);
                        if mapCCDAToFHIRResult is uscore501:USCoreDiagnosticReportProfileLaboratoryReporting {
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                }
            }
        }
    }
    return {
        'type: "searchset",
        entry: entries
    };
}
