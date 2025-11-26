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

# Transform an C-CDA message to FHIR.
#
# + ccda - C-CDA message as a xml
# + customMapper - Custom mapper to be used for the transformation
# + return - FHIR Bundle
public isolated function ccdaToFhir(xml? ccda, CcdaToFhirMapper? customMapper = ()) returns r4:Bundle|r4:FHIRError {
    if ccda !is xml {
        return r4:createFHIRError("Failed to parse C-CDA payload to xml", r4:ERROR, r4:INVALID_STRUCTURE);
    }
    if customMapper == () {
        return transformToFhir(ccda, defaultMapper);
    }
    CcdaToFhirMapper mapper = {...defaultMapper};
    foreach string key in customMapper.keys() {
        mapper[key] = customMapper.get(key);
    }
    return transformToFhir(ccda, mapper);
}

isolated function transformToFhir(xml xmlDocument, CcdaToFhirMapper? customMapper = ()) returns r4:Bundle {
    xmlns "urn:hl7-org:v3" as v3;
    CcdaToFhirMapper mapper;

    lock {
        mapper = customMapper != () ? customMapper : defaultMapper;
    }

    r4:BundleEntry[] entries = [];
    string patientId = "";
    foreach var xmlPayload in xmlDocument {
        xml childElements = xmlPayload/<v3:recordTarget|recordTarget>;
        if childElements.length() > 0 {
            xml xmlContent = childElements.get(0);
            xml patientRoleElement = xmlContent/<v3:patientRole|patientRole>;
            CcdaToPatient ccdaToPatient = mapper.ccdaToPatient;
            uscore501:USCorePatientProfile? mapCCDAToFHIRPatientResult = ccdaToPatient(patientRoleElement, xmlDocument);
            if mapCCDAToFHIRPatientResult is uscore501:USCorePatientProfile {
                patientId = <string>mapCCDAToFHIRPatientResult.id;
                entries.push({'resource: mapCCDAToFHIRPatientResult});
            }
        }

        xml authorElement = xmlPayload/<v3:author|author>;
        CcdaToPractitioner ccdaToPractitioner = mapper.ccdaToPractitioner;
        uscore501:USCorePractitionerProfile? mapCCDAToFHIRPractitionerResult = ccdaToPractitioner(authorElement, xmlDocument);
        if mapCCDAToFHIRPractitionerResult is uscore501:USCorePractitionerProfile {
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
                xml encounterElement = entryElement/<v3:encounter|encounter>;

                anydata mapCCDAToFHIRResult;

                //actElement code
                xml actCodeElement = actElement/<v3:code|code>;
                string|error? actCodeVal = actCodeElement.code;
                if actCodeVal is string {
                    if actCodeVal == CCDA_DOCUMENT_REFERENCE_CODE {
                        CcdaToDocumentReference ccdaToDocumentReference = mapper.ccdaToDocumentReference;
                        mapCCDAToFHIRResult = ccdaToDocumentReference(actElement, xmlDocument);
                        if mapCCDAToFHIRResult is uscore501:USCoreDocumentReferenceProfile {
                            if patientId != "" {
                                mapCCDAToFHIRResult.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                            }
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                }

                match codeVal {
                    CCDA_ALLERGY_CODE => {
                        CcdaToAllergyIntolerance ccdaToAllergyIntolerance = mapper.ccdaToAllergyIntolerance;
                        mapCCDAToFHIRResult = ccdaToAllergyIntolerance(actElement, xmlDocument);
                        if mapCCDAToFHIRResult is [uscore501:USCoreAllergyIntolerance, uscore501:USCoreProvenance?] {
                            [uscore501:USCoreAllergyIntolerance, uscore501:USCoreProvenance?] result = mapCCDAToFHIRResult;
                            if patientId != "" {
                                result[0].patient = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                            }
                            entries.push({'resource: result[0]});
                            if result[1] is uscore501:USCoreProvenance {
                                entries.push({'resource: result[1]});
                            }
                        }
                    }
                    CCDA_CONDITION_CODE => {
                        CcdaToCondition ccdaToCondition = mapper.ccdaToCondition;
                        mapCCDAToFHIRResult = ccdaToCondition(sectionElement, actElement, xmlDocument);
                        if mapCCDAToFHIRResult is uscore501:USCoreCondition {
                            if patientId != "" {
                                mapCCDAToFHIRResult.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                            }
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_IMMUNIZATION_CODE => {
                        CcdaToImmunization ccdaToImmunization = mapper.ccdaToImmunization;
                        mapCCDAToFHIRResult = ccdaToImmunization(substanceAdministrationElement, xmlDocument);
                        if mapCCDAToFHIRResult is uscore501:USCoreImmunizationProfile {
                            if patientId != "" {
                                mapCCDAToFHIRResult.patient = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                            }
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_MEDICATION_CODE|CCDA_PRESCRIBED_MEDICATION_CODE => {
                        CcdaToMedication ccdaToMedication = mapper.ccdaToMedication;
                        mapCCDAToFHIRResult = ccdaToMedication(substanceAdministrationElement, xmlDocument);
                        if mapCCDAToFHIRResult is uscore501:USCoreMedicationRequestProfile {
                            if patientId != "" {
                                mapCCDAToFHIRResult.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                            }
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_PROCEDURE_CODE => {
                        CcdaToProcedure ccdaToProcedure = mapper.ccdaToProcedure;
                        mapCCDAToFHIRResult = ccdaToProcedure(procedureElement, xmlDocument);
                        if mapCCDAToFHIRResult is uscore501:USCoreProcedureProfile {
                            if patientId != "" {
                                mapCCDAToFHIRResult.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                            }
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_DIAGNOSTIC_REPORT_CODE => {
                        CcdaToDiagnosticReport ccdaToDiagnosticReport = mapper.ccdaToDiagnosticReport;
                        mapCCDAToFHIRResult = ccdaToDiagnosticReport(organizerElement, xmlDocument);
                        if mapCCDAToFHIRResult is uscore501:USCoreDiagnosticReportProfileLaboratoryReporting {
                            if patientId != "" {
                                mapCCDAToFHIRResult.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                            }
                            entries.push({'resource: mapCCDAToFHIRResult});
                        }
                    }
                    CCDA_ENCOUNTER_CODE => {
                        CcdaToEncounter ccdaToEncounter = mapper.ccdaToEncounter;
                        mapCCDAToFHIRResult = ccdaToEncounter(encounterElement, xmlDocument);
                        if mapCCDAToFHIRResult is r4:Resource[] {
                            foreach r4:Resource 'resource in mapCCDAToFHIRResult {
                                if patientId != "" && 'resource is uscore501:USCoreEncounterProfile {
                                    'resource.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                                }
                                entries.push({'resource: 'resource});
                            }
                        }

                    }
                    CCDA_OBSERVATION_CODE => {
                        // Check if entry contains an organizer (vital signs organizer)
                        if isXMLElementNotNull(organizerElement) {
                            // Process vital signs organizer - group BP observations into panel
                            xml organizerComponents = organizerElement/<v3:component|component>;

                            // Collect systolic and diastolic observations for BP panel
                            uscore501:USCoreVitalSignsProfile? systolicObs = ();
                            uscore501:USCoreVitalSignsProfile? diastolicObs = ();
                            uscore501:USCoreVitalSignsProfile[] otherObservations = [];

                            foreach xml organizerComponent in organizerComponents {
                                xml observationElement = organizerComponent/<v3:observation|observation>;
                                if isXMLElementNotNull(observationElement) {
                                    xml obsCodeElement = observationElement/<v3:code|code>;
                                    string|error? codeValue = obsCodeElement.code;

                                    uscore501:USCoreVitalSignsProfile? vitalSignObs = ccdaVitalSignObservationToFhirObservation(observationElement, xmlDocument);

                                    if vitalSignObs is uscore501:USCoreVitalSignsProfile {
                                        // Check if this is systolic or diastolic BP
                                        if codeValue is string {
                                            if codeValue == "8480-6" {
                                                systolicObs = vitalSignObs;
                                            } else if codeValue == "8462-4" {
                                                diastolicObs = vitalSignObs;
                                            } else {
                                                // Other vital signs
                                                otherObservations.push(vitalSignObs);
                                            }
                                        } else {
                                            otherObservations.push(vitalSignObs);
                                        }
                                    }
                                }
                            }

                            // Create Blood Pressure Panel if both systolic and diastolic are present
                            if systolicObs is uscore501:USCoreVitalSignsProfile && diastolicObs is uscore501:USCoreVitalSignsProfile {
                                uscore501:USCoreVitalSignsProfile bpPanel = createBloodPressurePanel(systolicObs, diastolicObs, organizerElement);
                                if patientId != "" {
                                    bpPanel.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                                }
                                entries.push({'resource: bpPanel});
                            } else {
                                // If only one BP observation is present, add them individually
                                if systolicObs is uscore501:USCoreVitalSignsProfile {
                                    if patientId != "" {
                                        systolicObs.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                                    }
                                    entries.push({'resource: systolicObs});
                                }
                                if diastolicObs is uscore501:USCoreVitalSignsProfile {
                                    if patientId != "" {
                                        diastolicObs.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                                    }
                                    entries.push({'resource: diastolicObs});
                                }
                            }

                            // Add other vital sign observations
                            foreach var obs in otherObservations {
                                if patientId != "" {
                                    obs.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                                }
                                entries.push({'resource: obs});
                            }
                        } else {
                            // Process as individual observation
                            CcdaToObservation ccdaToObservation = mapper.ccdaToObservation;
                            mapCCDAToFHIRResult = ccdaToObservation(entryElement, xmlDocument);
                            if mapCCDAToFHIRResult is uscore501:USCoreVitalSignsProfile {
                                if patientId != "" {
                                    mapCCDAToFHIRResult.subject = {reference: PATIENT_REFERENCE_PREFIX + patientId};
                                }
                                entries.push({'resource: mapCCDAToFHIRResult});
                            }
                        }
                    }
                }
            }
        }
    }
    return {
        'type: "collection",
        entry: entries
    };
}
