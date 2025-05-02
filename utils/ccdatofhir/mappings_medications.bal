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

import ballerina/uuid;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

# Map CCDA Medication Activity to FHIR MedicationRequest
#
# + substanceAdministrationElement - CCDA Medication Activity Element
# + parentDocument - CCDA Document
# + return - FHIR MedicationRequest
isolated function ccdaToMedication(xml substanceAdministrationElement, xml parentDocument) returns uscore501:USCoreMedicationRequestProfile? {
    if isXMLElementNotNull(substanceAdministrationElement) {
        uscore501:USCoreMedicationRequestProfile medication = {
            medicationReference: {},
            subject: {},
            medicationCodeableConcept: {},
            intent: "option",
            status: "unknown",
            requester: {},
            authoredOn: ""
        };

        string|error? negationId = substanceAdministrationElement.negationInd;
        xml idElement = substanceAdministrationElement/<v3:id|id>;
        xml statusCodeElement = substanceAdministrationElement/<v3:statusCode|statusCode>;
        xml effectiveTimeElement = substanceAdministrationElement/<v3:effectiveTime|effectiveTime>;
        xml routeCodeElement = substanceAdministrationElement/<v3:routeCode|routeCode>;
        xml doseQuantityElement = substanceAdministrationElement/<v3:doseQuantity|doseQuantity>;
        xml rateQuantityElement = substanceAdministrationElement/<v3:rateQuantity|rateQuantity>;
        xml maxDoseQuantityElement = substanceAdministrationElement/<v3:maxDoseQuantity|maxDoseQuantity>;
        xml manufacturedMaterialElement = substanceAdministrationElement/<v3:consumable|consumable>/<v3:manufacturedProduct|manufacturedProduct>/<v3:manufacturedMaterial|manufacturedMaterial>;
        xml entryRelationshipElement = substanceAdministrationElement/<v3:entryRelationship|entryRelationship>;
        xml codeElement = entryRelationshipElement/<v3:substanceAdministration|substanceAdministration>/<v3:code|code>;
        xml substanceAdministrationTextElement = entryRelationshipElement/<v3:substanceAdministration|substanceAdministration>/<v3:text|text>;
        xml actElement = entryRelationshipElement/<v3:act|act>;
        xml actCodeElement = actElement/<v3:code|code>;
        xml actTextElement = actElement/<v3:text|text>;

        if negationId == "true" {
            medication.doNotPerform = true;
        }

        int index = 0;
        foreach xml idElem in idElement {
            r4:Identifier? mapCcdaIdToFhirIdentifierResult = mapCcdaIdToFhirIdentifier(idElem);
            if mapCcdaIdToFhirIdentifierResult is r4:Identifier {
                medication.identifier[index] = mapCcdaIdToFhirIdentifierResult;
                index = index + 1;
            }
        }

        medication.status = mapCcdatoFhirMedicationRequestStatus(statusCodeElement);

        uscore501:USCoreMedicationRequestProfileDosageInstruction dosageInstruction = {};
        string|error? effectiveTimeValue = effectiveTimeElement.value;
        if effectiveTimeValue is string {
            dosageInstruction.timing.event = [effectiveTimeValue];
        }

        r4:dateTime? mapCCDAEffectiveTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveTimeElement);
        if mapCCDAEffectiveTimetoFHIRDateTimeResult is r4:dateTime {
            medication.authoredOn = mapCCDAEffectiveTimetoFHIRDateTimeResult != "" ? mapCCDAEffectiveTimetoFHIRDateTimeResult : "";
        }

        xml effectiveLowTimeElement = effectiveTimeElement/<v3:low|low>;
        r4:dateTime? mapCCDAEffectiveLowTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveLowTimeElement);
        if mapCCDAEffectiveLowTimetoFHIRDateTimeResult is r4:dateTime {
            dosageInstruction.timing.repeat.boundsPeriod.'start = mapCCDAEffectiveLowTimetoFHIRDateTimeResult;
        }

        xml effectiveHighTimeElement = effectiveTimeElement/<v3:high|high>;
        r4:dateTime? mapCCDAEffectiveHighTimetoFHIRDateTimeResult = mapCcdaDateTimeToFhirDateTime(effectiveHighTimeElement);
        if mapCCDAEffectiveHighTimetoFHIRDateTimeResult is r4:dateTime {
            dosageInstruction.timing.repeat.boundsPeriod.end = mapCCDAEffectiveHighTimetoFHIRDateTimeResult;
        }

        if dosageInstruction != {} {
            medication.dosageInstruction = [dosageInstruction];
        }

        medication.dosageInstruction[0].route = mapCcdaCodingToFhirCodeableConcept(routeCodeElement, parentDocument);

        string|error? doseValue = doseQuantityElement.value;
        string|error? doseUnit = doseQuantityElement.unit;
        if doseValue is string {
            decimal|error doseDecimalVal = decimal:fromString(doseValue);
            medication.dosageInstruction[0].doseAndRate = [
                {
                    doseQuantity: {
                        value: doseDecimalVal is decimal ? doseDecimalVal : (),
                        unit: doseUnit is string ? doseUnit : ()
                    }
                }
            ];
        }

        string|error? rateValue = rateQuantityElement.value;
        string|error? rateUnit = rateQuantityElement.unit;
        if rateValue is string {
            decimal|error rateDecimalVal = decimal:fromString(rateValue);
            medication.dosageInstruction[0].doseAndRate = [
                {
                    rateQuantity: {
                        value: rateDecimalVal is decimal ? rateDecimalVal : (),
                        unit: rateUnit is string ? rateUnit : ()
                    }
                }
            ];
        }

        string|error? maxDoseValue = maxDoseQuantityElement.value;
        string|error? maxDoseUnit = maxDoseQuantityElement.unit;
        if maxDoseValue is string {
            decimal|error maxDoseDecimalVal = decimal:fromString(maxDoseValue);
            medication.dosageInstruction[0].maxDosePerAdministration = {
                value: maxDoseDecimalVal is decimal ? maxDoseDecimalVal : (),
                unit: maxDoseUnit is string ? maxDoseUnit : ()
            };
        }

        xml manufacturedMaterialCodeElement = manufacturedMaterialElement/<v3:code|code>;
        r4:CodeableConcept? mapCcdaCodingtoFhirCodeableConceptResult = mapCcdaCodingToFhirCodeableConcept(manufacturedMaterialCodeElement, parentDocument);
        if mapCcdaCodingtoFhirCodeableConceptResult is r4:CodeableConcept {
            medication.medicationCodeableConcept = mapCcdaCodingtoFhirCodeableConceptResult;
        }

        string|error? entryRelationshipTypeCode = entryRelationshipElement.typeCode;
        if entryRelationshipTypeCode is string && entryRelationshipTypeCode == "RSON" {
            xml entryRelationshipObservationElement = entryRelationshipElement/<v3:observation|observation>;
            xml entryRelationshipObservationValueElement = entryRelationshipObservationElement/<v3:value|value>;

            if entryRelationshipObservationValueElement is xml:Element {
                r4:CodeableConcept? reasonCode = mapCcdaCodingToFhirCodeableConcept(entryRelationshipObservationValueElement, parentDocument);
                if reasonCode is r4:CodeableConcept {
                    medication.reasonCode = [reasonCode];
                }
            }
        } else if entryRelationshipTypeCode is string && entryRelationshipTypeCode == "SUBJ" {
            xml entryRelationshipObservationActCodeElement = entryRelationshipElement/<v3:act>/<v3:code>;
            r4:CodeableConcept? additionalInstruction = mapCcdaCodingToFhirCodeableConcept(entryRelationshipObservationActCodeElement, parentDocument);

            if additionalInstruction is r4:CodeableConcept {
                dosageInstruction = {
                    additionalInstruction: [additionalInstruction]
                };
            }
        }

        string|error? codeCode = codeElement.code;
        if codeCode == "76662-6" {
            // First try to get text from reference
            xml? referenceVal = substanceAdministrationTextElement/<v3:reference|reference>;
            string|error? textVal = referenceVal is xml ? referenceVal.value : ();

            // If reference is not present, try to get data from originalText directly
            if textVal is () || textVal is error {
                dosageInstruction.patientInstruction = substanceAdministrationTextElement.data();
            } else {
                if textVal.startsWith("#") {
                    xml? referenceElement = getElementByID(parentDocument, textVal.substring(1));
                    textVal = referenceElement is xml ? referenceElement.data() : ();
                    dosageInstruction.patientInstruction = textVal is string ? textVal : ();
                }
            }
        }
        medication.dosageInstruction = [dosageInstruction];

        string|error? actCodeValue = actCodeElement.code;
        if actCodeValue == "48767-8" {
            r4:Annotation 'annotation = {
                text: actTextElement.data()
            };
            medication.note = ['annotation];
        }
        //generate the id for the medication
        medication.id = uuid:createRandomUuid();
        return medication;
    }
    return ();
}

isolated function mapCcdatoFhirMedicationRequestStatus(xml codingElement) returns uscore501:USCoreMedicationRequestProfileStatus {
    string|error? codeVal = codingElement.code;
    if codeVal is string {
        match codeVal {
            "active" => {
                return r4:CODE_STATUS_ACTIVE;
            }
            "aborted" => {
                return uscore501:CODE_STATUS_STOPPED;
            }
            "completed" => {
                return uscore501:CODE_STATUS_COMPLETED;
            }
            "nullified" => {
                return uscore501:CODE_STATUS_ENTERED_IN_ERROR;
            }
            "suspended" => {
                return uscore501:CODE_STATUS_ON_HOLD;
            }
        }
    }
    return uscore501:CODE_STATUS_ENTERED_IN_ERROR;
}
