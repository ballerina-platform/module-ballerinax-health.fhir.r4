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
// Source C-CDA to FHIR - Observation Resource Mappings
// --------------------------------------------------------------------------------------------#

import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;
import ballerina/uuid;

xmlns "urn:hl7-org:v3" as v3;
xmlns "http://www.w3.org/2001/XMLSchema-instance" as xsi;

// --------------------------------------------------------------------------------------------#
// Core Observation Mapping Function
// --------------------------------------------------------------------------------------------#

# Map CCDA Observation to FHIR Observation Resource.
#
# + observationElement - CCDA Observation Element
# + parentDocument - CCDA Document
# + return - FHIR Observation Resource
public isolated function ccdaToObservation(xml observationElement, xml parentDocument) returns uscore501:USCoreVitalSignsProfile? {
    if !isXMLElementNotNull(observationElement) {
        return ();
    }

    uscore501:USCoreVitalSignsProfile observation = {
        status: "final",
        code: {},
        subject: {}
    ,category: []};

    // Extract XML elements
    xml idElement = observationElement/<v3:id|id>;
    xml statusCodeElement = observationElement/<v3:statusCode|statusCode>;
    xml codeElement = observationElement/<v3:code|code>;
    xml effectiveTimeElement = observationElement/<v3:effectiveTime|effectiveTime>;
    xml valueElement = observationElement/<v3:value|value>;
    xml interpretationCodeElement = observationElement/<v3:interpretationCode|interpretationCode>;
    xml referenceRangeElement = observationElement/<v3:referenceRange|referenceRange>;
    xml authorElement = observationElement/<v3:author|author>;
    xml performerElement = observationElement/<v3:performer|performer>;
    xml componentElement = observationElement/<v3:component|component>;
    xml entryRelationshipElement = observationElement/<v3:entryRelationship|entryRelationship>;

    // Map identifiers and extract ID for FHIR resource
    r4:Identifier[] identifiers = [];
    string? resourceId = ();
    foreach xml idElem in idElement {
        r4:Identifier? identifier = mapCcdaIdToFhirIdentifier(idElem);
        if identifier is r4:Identifier {
            identifiers.push(identifier);
        }
        // Extract root attribute for FHIR resource ID
        string|error? rootAttr = idElem.root;
        if rootAttr is string && resourceId is () {
            resourceId = rootAttr;
        }
    }
    if identifiers.length() > 0 {
        observation.identifier = identifiers;
    }

    // Map status code
    observation.status = uscore501:CODE_STATUS_FINAL;

    // Map code
    r4:CodeableConcept? codeableConcept = mapCcdaCodingToFhirCodeableConcept(codeElement, parentDocument);
    if codeableConcept is r4:CodeableConcept {
        observation.code = codeableConcept;
    }

    // Map effective time
    r4:dateTime? effectiveDateTime = mapCcdaDateTimeToFhirDateTime(effectiveTimeElement);
    if effectiveDateTime is r4:dateTime {
        observation.effectiveDateTime = effectiveDateTime;
    } else {
        // Try to map as period
        xml lowElement = effectiveTimeElement/<v3:low|low>;
        xml highElement = effectiveTimeElement/<v3:high|high>;
        r4:dateTime? lowDateTime = mapCcdaDateTimeToFhirDateTime(lowElement);
        r4:dateTime? highDateTime = mapCcdaDateTimeToFhirDateTime(highElement);

        if lowDateTime is r4:dateTime || highDateTime is r4:dateTime {
            r4:Period period = {};
            if lowDateTime is r4:dateTime {
                period.'start = lowDateTime;
            }
            if highDateTime is r4:dateTime {
                period.end = highDateTime;
            }
            observation.effectivePeriod = period;
        }
    }

    // Map value - can be Quantity, CodeableConcept, String, Boolean, Integer, Range, Ratio, SampledData, Time, DateTime, or Period
    observation = mapCcdaValueToFhirObservationValue(observation, valueElement, parentDocument);

    // Map interpretation
    r4:CodeableConcept? interpretation = mapCcdaCodingToFhirCodeableConcept(interpretationCodeElement, parentDocument);
    if interpretation is r4:CodeableConcept {
        observation.interpretation = [interpretation];
    }

    // Map reference range
    uscore501:USCoreVitalSignsProfileReferenceRange[]? referenceRanges = mapCcdaReferenceRangeToFhirReferenceRange(referenceRangeElement, parentDocument);
    if referenceRanges is uscore501:USCoreVitalSignsProfileReferenceRange[] && referenceRanges.length() > 0 {
        observation.referenceRange = referenceRanges;
    }

    // Map components (for multi-component observations like blood pressure)
    uscore501:USCoreVitalSignsProfileComponent[]? components = mapCcdaComponentsToFhirComponents(componentElement, parentDocument);
    if components is uscore501:USCoreVitalSignsProfileComponent[] && components.length() > 0 {
        observation.component = components;
    }

    // Set ID for the observation - use C-CDA id/@root if available, otherwise generate UUID
    if resourceId is string {
        observation.id = resourceId;
    } else {
        observation.id = uuid:createRandomUuid();
    }

    // Set default subject reference if not already set
    if observation.subject == {} {
        observation.subject = {
            reference: "Patient/patient"
        };
    }

    return observation;
}

// --------------------------------------------------------------------------------------------#
// Vital Signs Specific Mapping Functions
// --------------------------------------------------------------------------------------------#

# Map CCDA Vital Signs Organizer to FHIR Observation (Vital Signs Panel).
#
# + organizerElement - CCDA Vital Signs Organizer Element
# + parentDocument - CCDA Document
# + return - FHIR Observation Resource (Vital Signs Panel) and array of component observations
public isolated function ccdaVitalSignsOrganizerToFhirObservation(xml organizerElement, xml parentDocument)
    returns [uscore501:USCoreVitalSignsProfile, uscore501:USCoreVitalSignsProfile[]]? {

    if !isXMLElementNotNull(organizerElement) {
        return ();
    }

    // Create panel observation
    uscore501:USCoreVitalSignsProfile panelObservation = {
        status: "final",
        code: {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "85353-1",
                    display: "Vital signs, weight, height, head circumference, oxygen saturation and BMI panel"
                }
            ]
        },
        subject: {},
        category: [{
            coding: [
                {
                    system: "http://terminology.hl7.org/CodeSystem/observation-category",
                    code: "vital-signs",
                    display: "Vital Signs"
                }
            ]
        }]
    };

    // Extract XML elements
    xml idElement = organizerElement/<v3:id|id>;
    xml statusCodeElement = organizerElement/<v3:statusCode|statusCode>;
    xml effectiveTimeElement = organizerElement/<v3:effectiveTime|effectiveTime>;
    xml componentElements = organizerElement/<v3:component|component>;

    // Map identifiers
    r4:Identifier[] identifiers = [];
    foreach xml idElem in idElement {
        r4:Identifier? identifier = mapCcdaIdToFhirIdentifier(idElem);
        if identifier is r4:Identifier {
            identifiers.push(identifier);
        }
    }
    if identifiers.length() > 0 {
        panelObservation.identifier = identifiers;
    }

    // Map status
    panelObservation.status = uscore501:CODE_STATUS_FINAL;

    // Map effective time
    r4:dateTime? effectiveDateTime = mapCcdaDateTimeToFhirDateTime(effectiveTimeElement);
    if effectiveDateTime is r4:dateTime {
        panelObservation.effectiveDateTime = effectiveDateTime;
    }

    // Generate ID for panel observation
    panelObservation.id = uuid:createRandomUuid();

    // Process component observations
    uscore501:USCoreVitalSignsProfile[] componentObservations = [];
    r4:Reference[] hasMemberReferences = [];

    foreach xml componentElement in componentElements {
        xml observationElement = componentElement/<v3:observation|observation>;
        uscore501:USCoreVitalSignsProfile? componentObs = ccdaVitalSignObservationToFhirObservation(observationElement, parentDocument);

        if componentObs is uscore501:USCoreVitalSignsProfile {
            componentObservations.push(componentObs);
            // Add reference to hasMember
            if componentObs?.id is string {
                hasMemberReferences.push({
                    reference: string `Observation/${componentObs.id ?: ""}`
                });
            }
        }
    }

    if hasMemberReferences.length() > 0 {
        panelObservation.hasMember = hasMemberReferences;
    }

    return [panelObservation, componentObservations];
}

# Map CCDA Vital Sign Observation to FHIR Observation.
#
# + observationElement - CCDA Observation Element
# + parentDocument - CCDA Document
# + return - FHIR Observation Resource
public isolated function ccdaVitalSignObservationToFhirObservation(xml observationElement, xml parentDocument)
    returns uscore501:USCoreVitalSignsProfile? {

    if !isXMLElementNotNull(observationElement) {
        return ();
    }

    uscore501:USCoreVitalSignsProfile? observation = ccdaToObservation(observationElement, parentDocument);

    if observation is uscore501:USCoreVitalSignsProfile {
        // Add vital-signs category
        observation.category = [{
            coding: [
                {
                    system: "http://terminology.hl7.org/CodeSystem/observation-category",
                    code: "vital-signs",
                    display: "Vital Signs"
                }
            ]
        }];

        // Check if this is a blood pressure observation
        xml codeElement = observationElement/<v3:code|code>;
        string|error? codeValue = codeElement.code;

        if codeValue is string {
            // Handle blood pressure as special case - map to US Core Blood Pressure profile
            if codeValue == "85354-9" {
                observation = enhanceBloodPressureObservation(observation);
            }
        }
    }

    return observation;
}

# Enhance Blood Pressure observation with US Core requirements.
#
# + observation - Base observation
# + return - Enhanced observation
isolated function enhanceBloodPressureObservation(uscore501:USCoreVitalSignsProfile observation) returns uscore501:USCoreVitalSignsProfile {
    // Ensure blood pressure observation doesn't have a direct value (only components should have values)
    observation.valueQuantity = ();
    observation.valueCodeableConcept = ();
    observation.valueString = ();
    observation.valueBoolean = ();
    observation.valueInteger = ();
    observation.valueRange = ();
    observation.valueRatio = ();
    observation.valueSampledData = ();
    observation.valueTime = ();
    observation.valueDateTime = ();
    observation.valuePeriod = ();

    return observation;
}

# Create a Blood Pressure Panel observation from systolic and diastolic observations.
#
# + systolicObs - Systolic blood pressure observation
# + diastolicObs - Diastolic blood pressure observation
# + organizerElement - The C-CDA organizer element
# + return - Blood Pressure Panel observation
public isolated function createBloodPressurePanel(
    uscore501:USCoreVitalSignsProfile systolicObs,
    uscore501:USCoreVitalSignsProfile diastolicObs,
    xml organizerElement
) returns uscore501:USCoreVitalSignsProfile {

    // Create Blood Pressure Panel observation
    uscore501:USCoreVitalSignsProfile bpPanel = {
        status: "final",
        code: {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "85354-9",
                    display: "Blood pressure panel with all children optional"
                }
            ],
            text: "Blood Pressure"
        },
        subject: {},
        category: [{
            coding: [
                {
                    system: "http://terminology.hl7.org/CodeSystem/observation-category",
                    code: "vital-signs",
                    display: "Vital Signs"
                }
            ]
        }]
    };

    // Extract ID from organizer if available
    xml idElement = organizerElement/<v3:id|id>;
    string|error? rootAttr = idElement.root;
    if rootAttr is string {
        bpPanel.id = rootAttr;
    } else {
        bpPanel.id = uuid:createRandomUuid();
    }

    // Extract effective time from organizer
    xml effectiveTimeElement = organizerElement/<v3:effectiveTime|effectiveTime>;
    r4:dateTime? effectiveDateTime = mapCcdaDateTimeToFhirDateTime(effectiveTimeElement);
    if effectiveDateTime is r4:dateTime {
        bpPanel.effectiveDateTime = effectiveDateTime;
    }

    // Create components from systolic and diastolic observations
    uscore501:USCoreVitalSignsProfileComponent[] components = [];

    // Systolic component
    if systolicObs.code is r4:CodeableConcept && systolicObs.valueQuantity is r4:Quantity {
        uscore501:USCoreVitalSignsProfileComponent systolicComponent = {
            code: systolicObs.code,
            valueQuantity: systolicObs.valueQuantity
        };
        components.push(systolicComponent);
    }

    // Diastolic component
    if diastolicObs.code is r4:CodeableConcept && diastolicObs.valueQuantity is r4:Quantity {
        uscore501:USCoreVitalSignsProfileComponent diastolicComponent = {
            code: diastolicObs.code,
            valueQuantity: diastolicObs.valueQuantity
        };
        components.push(diastolicComponent);
    }

    bpPanel.component = components;

    // Ensure no direct value on the panel (per constraint)
    bpPanel.valueQuantity = ();
    bpPanel.valueCodeableConcept = ();
    bpPanel.valueString = ();
    bpPanel.valueBoolean = ();
    bpPanel.valueInteger = ();
    bpPanel.valueRange = ();
    bpPanel.valueRatio = ();
    bpPanel.valueSampledData = ();
    bpPanel.valueTime = ();
    bpPanel.valueDateTime = ();
    bpPanel.valuePeriod = ();

    return bpPanel;
}

# Create a Pulse Oximetry observation from oxygen saturation and optional inhaled oxygen observations.
#
# + oxygenSatObs - Oxygen saturation observation (59408-5 or 2708-6)
# + inhaledO2ConcObs - Optional inhaled oxygen concentration observation (3150-0)
# + inhaledO2FlowObs - Optional inhaled oxygen flow rate observation (3151-8)
# + return - Pulse Oximetry observation
public isolated function createPulseOximetryObservation(
    uscore501:USCoreVitalSignsProfile oxygenSatObs,
    uscore501:USCoreVitalSignsProfile? inhaledO2ConcObs,
    uscore501:USCoreVitalSignsProfile? inhaledO2FlowObs
) returns uscore501:USCoreVitalSignsProfile {

    // Create Pulse Oximetry observation with dual coding (59408-5 and 2708-6)
    uscore501:USCoreVitalSignsProfile pulseOxObs = {
        status: oxygenSatObs.status,
        code: {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "59408-5",
                    display: "Oxygen saturation in Arterial blood by Pulse oximetry"
                },
                {
                    system: "http://loinc.org",
                    code: "2708-6",
                    display: "Oxygen saturation in Arterial blood"
                }
            ],
            text: oxygenSatObs.code?.text ?: "Oxygen saturation"
        },
        subject: oxygenSatObs.subject,
        category: [{
            coding: [
                {
                    system: "http://terminology.hl7.org/CodeSystem/observation-category",
                    code: "vital-signs",
                    display: "Vital Signs"
                }
            ]
        }]
    };

    // Copy ID, effective time, and identifiers from oxygen saturation observation
    if oxygenSatObs?.id is string {
        pulseOxObs.id = oxygenSatObs.id;
    } else {
        pulseOxObs.id = uuid:createRandomUuid();
    }

    if oxygenSatObs?.identifier is r4:Identifier[] {
        pulseOxObs.identifier = oxygenSatObs.identifier;
    }

    if oxygenSatObs?.effectiveDateTime is r4:dateTime {
        pulseOxObs.effectiveDateTime = oxygenSatObs.effectiveDateTime;
    }

    if oxygenSatObs?.effectivePeriod is r4:Period {
        pulseOxObs.effectivePeriod = oxygenSatObs.effectivePeriod;
    }

    // Set the valueQuantity to the oxygen saturation value
    if oxygenSatObs?.valueQuantity is r4:Quantity {
        pulseOxObs.valueQuantity = oxygenSatObs.valueQuantity;
    }

    // Create components for inhaled oxygen measurements if they exist
    uscore501:USCoreVitalSignsProfileComponent[] components = [];

    // Add Inhaled Oxygen Concentration component if present
    if inhaledO2ConcObs is uscore501:USCoreVitalSignsProfile {
        if inhaledO2ConcObs.code is r4:CodeableConcept && inhaledO2ConcObs.valueQuantity is r4:Quantity {
            uscore501:USCoreVitalSignsProfileComponent o2ConcComponent = {
                code: inhaledO2ConcObs.code,
                valueQuantity: inhaledO2ConcObs.valueQuantity
            };
            components.push(o2ConcComponent);
        }
    }

    // Add Inhaled Oxygen Flow Rate component if present
    if inhaledO2FlowObs is uscore501:USCoreVitalSignsProfile {
        if inhaledO2FlowObs.code is r4:CodeableConcept && inhaledO2FlowObs.valueQuantity is r4:Quantity {
            uscore501:USCoreVitalSignsProfileComponent o2FlowComponent = {
                code: inhaledO2FlowObs.code,
                valueQuantity: inhaledO2FlowObs.valueQuantity
            };
            components.push(o2FlowComponent);
        }
    }

    // Set components if any exist
    if components.length() > 0 {
        pulseOxObs.component = components;
    }

    return pulseOxObs;
}

// --------------------------------------------------------------------------------------------#
// Result Observation Mapping (for Laboratory Results)
// --------------------------------------------------------------------------------------------#

# Map CCDA Result Observation to FHIR Observation (Lab Result).
#
# + observationElement - CCDA Result Observation Element
# + parentDocument - CCDA Document
# + return - FHIR Observation Resource (US Core Laboratory Result)
public isolated function ccdaResultObservationToFhirObservation(xml observationElement, xml parentDocument)
    returns uscore501:USCoreLaboratoryResultObservationProfile? {

    if !isXMLElementNotNull(observationElement) {
        return ();
    }

    // Create base observation
    uscore501:USCoreVitalSignsProfile? baseObservation = ccdaToObservation(observationElement, parentDocument);

    if baseObservation !is uscore501:USCoreVitalSignsProfile {
        return ();
    }

    // Convert to US Core Lab Result profile
    uscore501:USCoreLaboratoryResultObservationProfile labResult = {
        status: baseObservation.status,
        code: baseObservation.code,
        subject: baseObservation.subject,
        category: [{
            coding: [
                {
                    system: "http://terminology.hl7.org/CodeSystem/observation-category",
                    code: "laboratory",
                    display: "Laboratory"
                }
            ]
        }]
    };

    // Copy fields from base observation
    if baseObservation?.id is string {
        labResult.id = baseObservation.id;
    }
    if baseObservation?.identifier is r4:Identifier[] {
        labResult.identifier = baseObservation.identifier;
    }
    if baseObservation?.effectiveDateTime is r4:dateTime {
        labResult.effectiveDateTime = baseObservation.effectiveDateTime;
    }
    if baseObservation?.effectivePeriod is r4:Period {
        labResult.effectivePeriod = baseObservation.effectivePeriod;
    }
    if baseObservation?.valueQuantity is r4:Quantity {
        labResult.valueQuantity = baseObservation.valueQuantity;
    }
    if baseObservation?.valueCodeableConcept is r4:CodeableConcept {
        labResult.valueCodeableConcept = baseObservation.valueCodeableConcept;
    }
    if baseObservation?.valueString is string {
        labResult.valueString = baseObservation.valueString;
    }
    if baseObservation?.interpretation is r4:CodeableConcept[] {
        labResult.interpretation = baseObservation.interpretation;
    }
    if baseObservation?.referenceRange is uscore501:USCoreVitalSignsProfileReferenceRange[] {
        labResult.referenceRange = baseObservation.referenceRange;
    }
    if baseObservation?.component is uscore501:USCoreVitalSignsProfileComponent[] {
        labResult.component = baseObservation.component;
    }

    return labResult;
}

// --------------------------------------------------------------------------------------------#
// Social History Observation Mappings
// --------------------------------------------------------------------------------------------#

# Map CCDA Social History Observation to FHIR Observation.
#
# + observationElement - CCDA Social History Observation Element
# + parentDocument - CCDA Document
# + return - FHIR Observation Resource
public isolated function ccdaSocialHistoryObservationToFhirObservation(xml observationElement, xml parentDocument)
    returns uscore501:USCoreObservationSocialHistoryProfile? {

    if !isXMLElementNotNull(observationElement) {
        return ();
    }

    uscore501:USCoreVitalSignsProfile? observation = ccdaToObservation(observationElement, parentDocument);

    if observation is uscore501:USCoreVitalSignsProfile {
        // Add social-history category
        observation.category = [{
            coding: [
                {
                    system: "http://terminology.hl7.org/CodeSystem/observation-category",
                    code: "social-history",
                    display: "Social History"
                }
            ]
        }];
    }

    return <uscore501:USCoreObservationSocialHistoryProfile>observation;
}

# Map CCDA Smoking Status Observation to FHIR Observation (US Core Smoking Status).
#
# + observationElement - CCDA Smoking Status Observation Element
# + parentDocument - CCDA Document
# + return - FHIR Observation Resource (US Core Smoking Status)
public isolated function ccdaSmokingStatusToFhirObservation(xml observationElement, xml parentDocument)
    returns uscore501:USCoreSmokingStatusProfile? {

    if !isXMLElementNotNull(observationElement) {
        return ();
    }

    uscore501:USCoreObservationSocialHistoryProfile? baseObservation = ccdaSocialHistoryObservationToFhirObservation(observationElement, parentDocument);

    if baseObservation !is uscore501:USCoreObservationSocialHistoryProfile {
        return ();
    }

    // Convert to US Core Smoking Status profile
    uscore501:USCoreSmokingStatusProfile smokingStatus = {
        status: baseObservation.status,
        code: {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "72166-2",
                    display: "Tobacco smoking status NHIS"
                }
            ]
        },
        subject: baseObservation.subject
    ,category: []};

    // Copy fields from base observation
    if baseObservation?.id is string {
        smokingStatus.id = baseObservation.id;
    }
    if baseObservation?.identifier is r4:Identifier[] {
        smokingStatus.identifier = baseObservation.identifier;
    }
    if baseObservation?.effectiveDateTime is r4:dateTime {
        smokingStatus.effectiveDateTime = baseObservation.effectiveDateTime;
    }
    if baseObservation?.valueCodeableConcept is r4:CodeableConcept {
        smokingStatus.valueCodeableConcept = baseObservation.valueCodeableConcept;
    }
    if baseObservation?.category is r4:CodeableConcept[] {
        smokingStatus.category = baseObservation.category;
    }

    return smokingStatus;
}

# Map CCDA Pregnancy Observation to FHIR Observation (US Core Pregnancy Status).
#
# + observationElement - CCDA Pregnancy Observation Element
# + parentDocument - CCDA Document
# + return - FHIR Observation Resource (US Core Pregnancy Status)
public isolated function ccdaPregnancyObservationToFhirObservation(xml observationElement, xml parentDocument)
    returns uscore501:USCoreObservationSocialHistoryProfile? {

    if !isXMLElementNotNull(observationElement) {
        return ();
    }

    uscore501:USCoreObservationSocialHistoryProfile? observation = ccdaSocialHistoryObservationToFhirObservation(observationElement, parentDocument);

    if observation is uscore501:USCoreObservationSocialHistoryProfile {
        // Ensure code is set to pregnancy status
        observation.code = {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "82810-3",
                    display: "Pregnancy status"
                }
            ]
        };

        // Check for Estimated Date of Delivery in entryRelationship
        xml entryRelationshipElements = observationElement/<v3:entryRelationship|entryRelationship>;
        foreach xml entryRelationship in entryRelationshipElements {
            xml nestedObservation = entryRelationship/<v3:observation|observation>;
            xml nestedCode = nestedObservation/<v3:code|code>;
            string|error? nestedCodeValue = nestedCode.code;

            if nestedCodeValue is string && nestedCodeValue == "11778-8" {
                // This is Estimated Date of Delivery
                xml nestedValue = nestedObservation/<v3:value|value>;
                r4:dateTime? eddDateTime = mapCcdaDateTimeToFhirDateTime(nestedValue);

                if eddDateTime is r4:dateTime {
                    uscore501:USCoreObservationSocialHistoryProfileComponent component = {
                        code: {
                            coding: [
                                {
                                    system: "http://loinc.org",
                                    code: "11778-8",
                                    display: "Delivery date Estimated"
                                }
                            ]
                        },
                        valueDateTime: eddDateTime
                    };

                    if observation?.component is uscore501:USCoreObservationSocialHistoryProfileComponent[] {
                        uscore501:USCoreObservationSocialHistoryProfileComponent[] existingComponents = observation.component ?: [];
                        observation.component = [...existingComponents, component];
                    } else {
                        observation.component = [component];
                    }
                }
            }
        }
    }

    return observation;
}


# Map CCDA value element to FHIR Observation value[x].
#
# + observation - FHIR Observation being built
# + valueElement - CCDA value element
# + parentDocument - CCDA parent document
# + return - Updated FHIR Observation
isolated function mapCcdaValueToFhirObservationValue(uscore501:USCoreVitalSignsProfile observation, xml valueElement, xml parentDocument)
    returns uscore501:USCoreVitalSignsProfile {

    if !isXMLElementNotNull(valueElement) {
        return observation;
    }

    string|error? xsiType = valueElement.xsi:'type;

    if xsiType is string {
        match xsiType {
            "PQ" => {
                // Physical Quantity - map to valueQuantity
                r4:Quantity? quantity = mapCcdaPQToFhirQuantity(valueElement);
                if quantity is r4:Quantity {
                    observation.valueQuantity = quantity;
                }
            }
            "CD" | "CE" | "CV" => {
                // Coded value - map to valueCodeableConcept
                r4:CodeableConcept? codeableConcept = mapCcdaCodingToFhirCodeableConcept(valueElement, parentDocument);
                if codeableConcept is r4:CodeableConcept {
                    observation.valueCodeableConcept = codeableConcept;
                }
            }
            "ST" | "ED" => {
                // String or Encapsulated Data - map to valueString
                string valueStr = valueElement.data();
                if valueStr.trim() != "" {
                    observation.valueString = valueStr;
                }
            }
            "BL" => {
                // Boolean - map to valueBoolean
                string|error? boolValue = valueElement.value;
                if boolValue is string {
                    observation.valueBoolean = boolValue.toLowerAscii() == "true";
                }
            }
            "INT" => {
                // Integer - map to valueInteger
                string|error? intValue = valueElement.value;
                if intValue is string {
                    int|error intResult = int:fromString(intValue);
                    if intResult is int {
                        observation.valueInteger = intResult;
                    }
                }
            }
            "IVL_PQ" => {
                // Interval of Physical Quantity - map to valueRange
                r4:Range? range = mapCcdaIVLPQToFhirRange(valueElement);
                if range is r4:Range {
                    observation.valueRange = range;
                }
            }
            "TS" => {
                // Timestamp - map to valueDateTime
                r4:dateTime? dateTime = mapCcdaDateTimeToFhirDateTime(valueElement);
                if dateTime is r4:dateTime {
                    observation.valueDateTime = dateTime;
                }
            }
        }
    } else {
        // If no xsi:type, try to infer from attributes
        string|error? valueAttr = valueElement.value;
        string|error? unitAttr = valueElement.unit;

        if valueAttr is string && unitAttr is string {
            // Likely a quantity
            r4:Quantity? quantity = mapCcdaPQToFhirQuantity(valueElement);
            if quantity is r4:Quantity {
                observation.valueQuantity = quantity;
            }
        } else if valueAttr is string {
            // Check if it's numeric
            decimal|error decimalValue = decimal:fromString(valueAttr);
            if decimalValue is decimal {
                observation.valueQuantity = {value: decimalValue};
            } else {
                observation.valueString = valueAttr;
            }
        }
    }

    return observation;
}

# Map CCDA PQ (Physical Quantity) to FHIR Quantity.
#
# + pqElement - CCDA PQ element
# + return - FHIR Quantity
isolated function mapCcdaPQToFhirQuantity(xml pqElement) returns r4:Quantity? {
    string|error? valueStr = pqElement.value;
    string|error? unit = pqElement.unit;

    if valueStr !is string {
        return ();
    }

    decimal|error value = decimal:fromString(valueStr);
    if value !is decimal {
        return ();
    }

    r4:Quantity quantity = {value: value};

    if unit is string {
        quantity.unit = unit;
        quantity.code = unit;
        // UCUM units
        quantity.system = "http://unitsofmeasure.org";
    }

    return quantity;
}

# Map CCDA IVL_PQ (Interval Physical Quantity) to FHIR Range.
#
# + ivlPqElement - CCDA IVL_PQ element
# + return - FHIR Range
isolated function mapCcdaIVLPQToFhirRange(xml ivlPqElement) returns r4:Range? {
    xml lowElement = ivlPqElement/<v3:low|low>;
    xml highElement = ivlPqElement/<v3:high|high>;

    r4:Quantity? low = mapCcdaPQToFhirQuantity(lowElement);
    r4:Quantity? high = mapCcdaPQToFhirQuantity(highElement);

    if low is () && high is () {
        return ();
    }

    r4:Range range = {};
    if low is r4:Quantity {
        range.low = low;
    }
    if high is r4:Quantity {
        range.high = high;
    }

    return range;
}

# Map CCDA reference range to FHIR reference range.
#
# + referenceRangeElements - CCDA referenceRange elements
# + parentDocument - CCDA parent document
# + return - Array of FHIR ObservationReferenceRange
isolated function mapCcdaReferenceRangeToFhirReferenceRange(xml referenceRangeElements, xml parentDocument)
    returns uscore501:USCoreVitalSignsProfileReferenceRange[]? {

    if referenceRangeElements.length() == 0 {
        return ();
    }

    uscore501:USCoreVitalSignsProfileReferenceRange[] referenceRanges = [];

    foreach xml referenceRangeElement in referenceRangeElements {
        xml observationRange = referenceRangeElement/<v3:observationRange|observationRange>;
        xml valueElement = observationRange/<v3:value|value>;
        xml interpretationCodeElement = observationRange/<v3:interpretationCode|interpretationCode>;
        xml textElement = observationRange/<v3:text|text>;

        uscore501:USCoreVitalSignsProfileReferenceRange refRange = {};

        // Map range value (IVL_PQ)
        r4:Range? range = mapCcdaIVLPQToFhirRange(valueElement);
        if range is r4:Range {
            refRange.low = range?.low;
            refRange.high = range?.high;
        }

        // Map interpretation code (e.g., "N" for normal)
        r4:CodeableConcept? interpretationType = mapCcdaCodingToFhirCodeableConcept(interpretationCodeElement, parentDocument);
        if interpretationType is r4:CodeableConcept {
            refRange.'type = interpretationType;
        }

        // Map text
        string text = textElement.data();
        if text.trim() != "" {
            refRange.text = text;
        }

        referenceRanges.push(refRange);
    }

    return referenceRanges.length() > 0 ? referenceRanges : ();
}

# Map CCDA components to FHIR Observation components.
#
# + componentElements - CCDA component elements
# + parentDocument - CCDA parent document
# + return - Array of FHIR ObservationComponent
isolated function mapCcdaComponentsToFhirComponents(xml componentElements, xml parentDocument)
    returns uscore501:USCoreVitalSignsProfileComponent[]? {

    if componentElements.length() == 0 {
        return ();
    }

    uscore501:USCoreVitalSignsProfileComponent[] components = [];

    foreach xml componentElement in componentElements {
        xml observationElement = componentElement/<v3:observation|observation>;

        if !isXMLElementNotNull(observationElement) {
            continue;
        }

        xml codeElement = observationElement/<v3:code|code>;
        xml valueElement = observationElement/<v3:value|value>;
        xml interpretationCodeElement = observationElement/<v3:interpretationCode|interpretationCode>;
        xml referenceRangeElement = observationElement/<v3:referenceRange|referenceRange>;

        uscore501:USCoreVitalSignsProfileComponent component = {code: {}};

        // Map code
        r4:CodeableConcept? code = mapCcdaCodingToFhirCodeableConcept(codeElement, parentDocument);
        if code is r4:CodeableConcept {
            component.code = code;
        }

        // Map value
        string|error? xsiType = valueElement.xsi:'type;
        if xsiType is string {
            match xsiType {
                "PQ" => {
                    r4:Quantity? quantity = mapCcdaPQToFhirQuantity(valueElement);
                    if quantity is r4:Quantity {
                        component.valueQuantity = quantity;
                    }
                }
                "CD" | "CE" | "CV" => {
                    r4:CodeableConcept? codeableConcept = mapCcdaCodingToFhirCodeableConcept(valueElement, parentDocument);
                    if codeableConcept is r4:CodeableConcept {
                        component.valueCodeableConcept = codeableConcept;
                    }
                }
                "ST" => {
                    string valueStr = valueElement.data();
                    if valueStr.trim() != "" {
                        component.valueString = valueStr;
                    }
                }
            }
        } else {
            // Try to infer quantity
            r4:Quantity? quantity = mapCcdaPQToFhirQuantity(valueElement);
            if quantity is r4:Quantity {
                component.valueQuantity = quantity;
            }
        }

        // Map interpretation
        r4:CodeableConcept? interpretation = mapCcdaCodingToFhirCodeableConcept(interpretationCodeElement, parentDocument);
        if interpretation is r4:CodeableConcept {
            component.interpretation = [interpretation];
        }

        // Map reference range
        uscore501:USCoreVitalSignsProfileReferenceRange[]? referenceRanges = mapCcdaReferenceRangeToFhirReferenceRange(referenceRangeElement, parentDocument);
        if referenceRanges is uscore501:USCoreVitalSignsProfileReferenceRange[] && referenceRanges.length() > 0 {
            component.referenceRange = referenceRanges;
        }

        components.push(component);
    }

    return components.length() > 0 ? components : ();
}

// --------------------------------------------------------------------------------------------#
// LOINC Code Constants for Common Observations (for developer reference)
// --------------------------------------------------------------------------------------------#
// These constants can be moved to constants.bal later

// Vital Signs Section
const string LOINC_VITAL_SIGNS_PANEL = "85353-1";
const string LOINC_BLOOD_PRESSURE_PANEL = "85354-9";
const string LOINC_SYSTOLIC_BP = "8480-6";
const string LOINC_DIASTOLIC_BP = "8462-4";
const string LOINC_HEART_RATE = "8867-4";
const string LOINC_RESPIRATORY_RATE = "9279-1";
const string LOINC_OXYGEN_SATURATION = "59408-5";
const string LOINC_OXYGEN_SATURATION_ALT = "2708-6";
const string LOINC_INHALED_OXYGEN_FLOW_RATE = "3151-8";
const string LOINC_INHALED_OXYGEN_CONCENTRATION = "3150-0";
const string LOINC_BODY_TEMPERATURE = "8310-5";
const string LOINC_BODY_HEIGHT = "8302-2";
const string LOINC_BODY_WEIGHT = "29463-7";
const string LOINC_BMI = "39156-5";
const string LOINC_HEAD_CIRCUMFERENCE = "9843-4";

// Social History
const string LOINC_SMOKING_STATUS = "72166-2";
const string LOINC_PREGNANCY_STATUS = "82810-3";
const string LOINC_PREGNANCY_INTENTION = "86645-9";
const string LOINC_ESTIMATED_DELIVERY_DATE = "11778-8";

// Results Section
const string LOINC_RESULTS_SECTION = "30954-2";

// CCDA Template OIDs (for developer reference)
const string TEMPLATE_OID_VITAL_SIGNS_ORGANIZER = "2.16.840.1.113883.10.20.22.4.26";
const string TEMPLATE_OID_VITAL_SIGNS_OBSERVATION = "2.16.840.1.113883.10.20.22.4.27";
const string TEMPLATE_OID_RESULT_ORGANIZER = "2.16.840.1.113883.10.20.22.4.1";
const string TEMPLATE_OID_RESULT_OBSERVATION = "2.16.840.1.113883.10.20.22.4.2";
const string TEMPLATE_OID_SOCIAL_HISTORY_OBSERVATION = "2.16.840.1.113883.10.20.22.4.78";
const string TEMPLATE_OID_SMOKING_STATUS = "2.16.840.1.113883.10.20.22.4.78";
const string TEMPLATE_OID_PREGNANCY_OBSERVATION = "2.16.840.1.113883.10.20.15.3.8";
const string TEMPLATE_OID_PREGNANCY_INTENTION = "2.16.840.1.113883.10.20.15.3.1";
