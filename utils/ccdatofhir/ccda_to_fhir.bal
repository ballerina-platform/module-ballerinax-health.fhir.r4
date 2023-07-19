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

# Transform an C-CDA message to FHIR.
#
# + ccda - C-CDA message as a xml  
# + customMapper - Custom mapper implementation
# + return - FHIR Bundle
public isolated function ccdaToFhir(xml? ccda, CCDAtoFhirMapper? customMapper = ()) returns r4:Bundle|r4:FHIRError {
    if ccda is xml {
        if customMapper == () {
            return transformToFhir(ccda, defaultMapper);
        }
        CCDAtoFhirMapper mapper = {...defaultMapper};
        foreach string key in customMapper.keys() {
            mapper[key] = customMapper.get(key);
        }
        return transformToFhir(ccda, mapper);
    }
    return r4:createFHIRError("Failed to parse C-CDA payload to xml", r4:ERROR, r4:INVALID_STRUCTURE);
}

isolated function transformToFhir(xml xmlDocument, CCDAtoFhirMapper? customMapper) returns r4:Bundle {
    xmlns "urn:hl7-org:v3" as v3;

    CCDAtoFhirMapper impl;
    lock {
        impl = customMapper != () ? customMapper : defaultMapper;
    }
    r4:BundleEntry[] entries = [];
    foreach var xmlPayload in xmlDocument {
        xml childElements = xmlPayload/<v3:recordTarget|recordTarget>;
        if childElements.length() > 0 {
            xml xmlContent = childElements.get(0);
            xml patientRoleElement = xmlContent/<v3:patientRole|patientRole>;
            CcdaPatientToFhir? ccdaPatientToFhir = impl.ccdaPatientToFhir;
            if ccdaPatientToFhir is CcdaPatientToFhir {
                r4:Patient? mapCCDAToFHIRPatientResult = ccdaPatientToFhir(patientRoleElement);
                if mapCCDAToFHIRPatientResult is r4:Patient {
                    entries.push({'resource: mapCCDAToFHIRPatientResult});
                }
            }
        }

        xml authorElement = xmlPayload/<v3:author|author>;
        CcdaPractitionerToFhir? ccdaPractitionerToFhir = impl.ccdaPractitionerToFhir;
        if ccdaPractitionerToFhir is CcdaPractitionerToFhir {
            r4:Practitioner? mapCCDAToFHIRPractitionerResult = ccdaPractitionerToFhir(authorElement);
            if mapCCDAToFHIRPractitionerResult is r4:Practitioner {
                entries.push({'resource: mapCCDAToFHIRPractitionerResult});
            }
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
                        CcdaAllergyToFhir? ccdaAllergyToFhir = impl.ccdaAllergyToFhir;
                        if ccdaAllergyToFhir is CcdaAllergyToFhir {
                            mapCCDAToFHIRResult = ccdaAllergyToFhir(actElement);
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_CONDITION_CODE => {
                        CcdaConditionToFhir? ccdaConditionToFhir = impl.ccdaConditionToFhir;
                        if ccdaConditionToFhir is CcdaConditionToFhir {
                            mapCCDAToFHIRResult = ccdaConditionToFhir(actElement);
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_IMMUNIZATION_CODE => {
                        CcdaImmunizationToFhir? ccdaImmunizationToFhir = impl.ccdaImmunizationToFhir;
                        if ccdaImmunizationToFhir is CcdaImmunizationToFhir {
                            mapCCDAToFHIRResult = ccdaImmunizationToFhir(substanceAdministrationElement);
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_MEDICATION_CODE => {
                        CcdaMedicationToFhir? ccdaMedicationToFhir = impl.ccdaMedicationToFhir;
                        if ccdaMedicationToFhir is CcdaMedicationToFhir {
                            mapCCDAToFHIRResult = ccdaMedicationToFhir(substanceAdministrationElement);
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_PROCEDURE_CODE => {
                        CcdaProcedureToFhir? ccdaProcedureToFhir = impl.ccdaProcedureToFhir;
                        if ccdaProcedureToFhir is CcdaProcedureToFhir {
                            mapCCDAToFHIRResult = ccdaProcedureToFhir(procedureElement);
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_DIAGNOSTIC_REPORT_CODE => {
                        CcdaDiagnosticReportToFhir? ccdaDiagnosticReportToFhir = impl.ccdaDiagnosticReportToFhir;
                        if ccdaDiagnosticReportToFhir is CcdaDiagnosticReportToFhir {
                            mapCCDAToFHIRResult = ccdaDiagnosticReportToFhir(organizerElement);
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
