// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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
// Source FHIR to C-CDA - Allergy Intolerance Mappings
// --------------------------------------------------------------------------------------------#

import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

# Map FHIR USCore AllergyIntolerance to C-CDA Allergy Activity
#
# + allergy - FHIR USCore AllergyIntolerance resource
# + allResources - All FHIR resources for context
# + return - C-CDA Act (Allergy Concern Act)
isolated function fhirToAllergyIntolerance(uscore501:USCoreAllergyIntolerance allergy, r4:Resource[] allResources) returns Act? {

    // Create the main Allergy Concern Act with proper template ID
    Act allergyAct = {
        classCode: "ACT",
        moodCode: "EVN",
        id: [{root: generateUUID()}],
        code: {code: "CONC", codeSystem: "2.16.840.1.113883.5.6", displayName: "Concern"},
        statusCode: {code: "active"},
        effectiveTime: {value: getCurrentDateTime()},
        entryRelationship: [],
        templateId: [{root: "2.16.840.1.113883.10.20.22.4.30"}]
    };

    // Map identifiers
    if allergy.identifier is r4:Identifier[] {
        II[] ids = [];
        foreach r4:Identifier identifier in <r4:Identifier[]>allergy.identifier {
            II? id = mapFhirIdentifierToCcdaId(identifier);
            if id != () {
                ids.push(id);
            }
        }
        if ids.length() > 0 {
            allergyAct.id = ids;
        }
    }

    // Map clinical status to Allergy Status Observation
    if allergy.clinicalStatus is r4:CodeableConcept {
        EntryRelationship allergyStatusObs = createAllergyStatusObservation(<r4:CodeableConcept>allergy.clinicalStatus);
        if allergyAct.entryRelationship is EntryRelationship[] {
            (<EntryRelationship[]>allergyAct.entryRelationship).push(allergyStatusObs);
        } else {
            allergyAct.entryRelationship = [allergyStatusObs];
        }
    }

    // Create the main Allergy - Intolerance Observation
    Observation allergyObs = createAllergyIntoleranceObservation(allergy);
    
    // Add the observation as an entry relationship
    EntryRelationship allergyObsEntry = {
        typeCode: "SUBJ",
        observation: allergyObs
    };
    
    if allergyAct.entryRelationship is EntryRelationship[] {
        (<EntryRelationship[]>allergyAct.entryRelationship).push(allergyObsEntry);
    } else {
        allergyAct.entryRelationship = [allergyObsEntry];
    }

    // Map encounter reference
    if allergy.encounter is r4:Reference {
        EntryRelationship? encounterRef = createEncounterReference(<r4:Reference>allergy.encounter);
        if encounterRef != () {
            if allergyAct.entryRelationship is EntryRelationship[] {
                (<EntryRelationship[]>allergyAct.entryRelationship).push(<EntryRelationship>encounterRef);
            } else {
                allergyAct.entryRelationship = [<EntryRelationship>encounterRef];
            }
        }
    }

    // Map onset information
    if allergy.onsetDateTime is r4:dateTime {
        TS? mapFhirDateTimeToCcdaDateTimeResult = mapFhirDateTimeToCcdaDateTime(<r4:dateTime>allergy.onsetDateTime);
        if mapFhirDateTimeToCcdaDateTimeResult is TS {
            allergyAct.effectiveTime = {
                low: {value: mapFhirDateTimeToCcdaDateTimeResult.value}
            };
        }
    } else if allergy.onsetPeriod is r4:Period {
        IVL_TS onsetTime = createOnsetPeriod(<r4:Period>allergy.onsetPeriod);
        allergyAct.effectiveTime = onsetTime;
    }

    // Map recorded date and recorder to assigned author
    if allergy.recordedDate is r4:dateTime {
        Author assignedAuthor = createAssignedAuthor(<r4:dateTime>allergy.recordedDate, allergy.recorder, allResources);
        allergyAct.author = [assignedAuthor];
    }

    // Map notes
    if allergy.note is r4:Annotation[] {
        foreach r4:Annotation note in <r4:Annotation[]>allergy.note {
            EntryRelationship commentAct = createCommentActivity(note);
            if allergyAct.entryRelationship is EntryRelationship[] {
                (<EntryRelationship[]>allergyAct.entryRelationship).push(commentAct);
            } else {
                allergyAct.entryRelationship = [commentAct];
            }
        }
    }

    // Map reactions
    if allergy.reaction is uscore501:USCoreAllergyIntoleranceReaction[] {
        foreach uscore501:USCoreAllergyIntoleranceReaction reaction in <uscore501:USCoreAllergyIntoleranceReaction[]>allergy.reaction {
            EntryRelationship reactionObs = createReactionObservation(reaction);
            if allergyAct.entryRelationship is EntryRelationship[] {
                (<EntryRelationship[]>allergyAct.entryRelationship).push(reactionObs);
            } else {
                allergyAct.entryRelationship = [reactionObs];
            }
        }
    }

    return allergyAct;
}

# Create Allergy - Intolerance Observation
isolated function createAllergyIntoleranceObservation(uscore501:USCoreAllergyIntolerance allergy) returns Observation {
    Observation allergyObs = {
        classCode: "OBS",
        moodCode: "EVN",
        code: {code: "48765-2", codeSystem: "2.16.840.1.113883.6.1", displayName: "Allergy - Intolerance Observation"},
        templateId: [{root: "2.16.840.1.113883.10.20.22.4.7"}],
        entryRelationship: []
    };

    // Map identifiers
    if allergy.identifier is r4:Identifier[] {
        II[] ids = [];
        foreach r4:Identifier identifier in <r4:Identifier[]>allergy.identifier {
            II? id = mapFhirIdentifierToCcdaId(identifier);
            if id != () {
                ids.push(id);
            }
        }
        if ids.length() > 0 {
            allergyObs.id = ids;
        }
    }

    // Map type and category to methodCode (since value expects PQ[])
    if allergy.'type is uscore501:USCoreAllergyIntoleranceType {
        CE? typeValue = mapFhirAllergyTypeToCcdaValue(<uscore501:USCoreAllergyIntoleranceType>allergy.'type, allergy.category);
        if typeValue != () {
            allergyObs.methodCode = [<CE>typeValue];
        }
    }

    // Map criticality
    if allergy.criticality is uscore501:USCoreAllergyIntoleranceCriticality {
        EntryRelationship criticalityObs = createCriticalityObservation(<uscore501:USCoreAllergyIntoleranceCriticality>allergy.criticality);
        if allergyObs.entryRelationship is EntryRelationship[] {
            (<EntryRelationship[]>allergyObs.entryRelationship).push(criticalityObs);
        } else {
            allergyObs.entryRelationship = [criticalityObs];
        }
    }

    // Map code (allergen) to participant/participantRole/playingEntity/code
    if allergy.code is r4:CodeableConcept {
        Participant2 allergenParticipant = createAllergenParticipant(<r4:CodeableConcept>allergy.code);
        allergyObs.participant = [allergenParticipant];
    }

    // Map onset information
    if allergy.onsetDateTime is r4:dateTime {
        TS? onsetTime = mapFhirDateTimeToCcdaDateTime(<r4:dateTime>allergy.onsetDateTime);
        if onsetTime != () {
            allergyObs.effectiveTime = {
                low: {value: onsetTime.value}
            };
        }
    }

    // Map reactions
    if allergy.reaction is uscore501:USCoreAllergyIntoleranceReaction[] {
        foreach uscore501:USCoreAllergyIntoleranceReaction reaction in <uscore501:USCoreAllergyIntoleranceReaction[]>allergy.reaction {
            EntryRelationship reactionObs = createReactionObservation(reaction);
            if allergyObs.entryRelationship is EntryRelationship[] {
                (<EntryRelationship[]>allergyObs.entryRelationship).push(reactionObs);
            } else {
                allergyObs.entryRelationship = [reactionObs];
            }
        }
    }

    return allergyObs;
}

# Map FHIR Allergy Status to C-CDA CE Value
isolated function mapFhirAllergyStatusToCcdaValue(r4:CodeableConcept clinicalStatus) returns CE[] {
    CE[] values = [];
    
    // Extract the clinical status code from the CodeableConcept
    if clinicalStatus.coding is r4:Coding[] {
        foreach r4:Coding coding in <r4:Coding[]>clinicalStatus.coding {
            string? statusCode = coding.code;
            if statusCode != () {
                CE? ceValue = ();
                
                match <string>statusCode {
                    "active" => {
                        ceValue = {
                            code: "55561003",
                            codeSystem: "http://snomed.info/sct",
                            displayName: "Active"
                        };
                    }
                    "inactive" => {
                        ceValue = {
                            code: "73425007", 
                            codeSystem: "http://snomed.info/sct",
                            displayName: "Inactive"
                        };
                    }
                    "resolved" => {
                        ceValue = {
                            code: "413322009",
                            codeSystem: "http://snomed.info/sct",
                            displayName: "Problem Resolved"
                        };
                    }
                    _ => {
                        // Default to active if unknown status
                        ceValue = {
                            code: "55561003",
                            codeSystem: "http://snomed.info/sct",
                            displayName: "Active"
                        };
                    }
                }
                
                if ceValue != () {
                    values.push(<CE>ceValue);
                }
            }
        }
    }
    
    return values;
}

# Create Allergy Status Observation
isolated function createAllergyStatusObservation(r4:CodeableConcept clinicalStatus) returns EntryRelationship {
    Observation statusObs = {
        classCode: "OBS",
        moodCode: "EVN",
        code: {code: "33999-4", codeSystem: "2.16.840.1.113883.6.1", displayName: "Allergy Status"},
        templateId: [{root: "2.16.840.1.113883.10.20.22.4.28"}],
        interpretationCode: mapFhirAllergyStatusToCcdaValue(clinicalStatus)
    };

    return {
        typeCode: "SUBJ",
        observation: statusObs
    };
}

# Create Criticality Observation
isolated function createCriticalityObservation(uscore501:USCoreAllergyIntoleranceCriticality criticality) returns EntryRelationship {
    Observation criticalityObs = {
        classCode: "OBS",
        moodCode: "EVN",
        code: {code: "82606-5", codeSystem: "2.16.840.1.113883.6.1", displayName: "Criticality"},
        templateId: [{root: "2.16.840.1.113883.1.11.20549"}],
        methodCode: [<CE>mapFhirCriticalityToCcdaValue(criticality)]
    };

    return {
        typeCode: "SUBJ",
        observation: criticalityObs
    };
}

# Create Allergen Participant
isolated function createAllergenParticipant(r4:CodeableConcept allergenCode) returns Participant2 {
    PlayingEntity playingEntity = {
        code: mapFhirCodeableConceptToCcdaCoding(allergenCode)
    };

    ParticipantRole participantRole = {
        playingEntity: playingEntity
    };

    return {
        typeCode: "CSM",
        participantRole: participantRole
    };
}

# Create Encounter Reference
isolated function createEncounterReference(r4:Reference encounterRef) returns EntryRelationship? {
    if encounterRef.reference is string {
        string encounterId = extractReferenceId(<string>encounterRef.reference);
        II[] ids = [{root: encounterId}];
        Act encounterAct = {
            classCode: "ENC",
            moodCode: "INT",
            id: ids,
            code: {code: "46240-8", codeSystem: "2.16.840.1.113883.6.1", displayName: "Encounter"}
        };
        return {
            typeCode: "REFR",
            act: encounterAct
        };
    } else {
        return ();
    }
}

# Create Onset Period
isolated function createOnsetPeriod(r4:Period period) returns IVL_TS {
    IVL_TS onsetTime = {};

    if period.'start is r4:dateTime {
        TS? mapFhirDateTimeToCcdaDateTimeResult = mapFhirDateTimeToCcdaDateTime(<r4:dateTime>period.'start);
        if mapFhirDateTimeToCcdaDateTimeResult is TS {
            onsetTime.low = {value: mapFhirDateTimeToCcdaDateTimeResult.value};
        }
    }

    // Note: effectiveTime/high should not be mapped from onsetPeriod per specification
    // Only map the start time

    return onsetTime;
}

# Create Assigned Author
isolated function createAssignedAuthor(r4:dateTime recordedDate, r4:Reference? recorder, r4:Resource[] allResources) returns Author {
    Author author = {
        time: {value: mapFhirDateTimeToCcdaDateTime(<r4:dateTime>recordedDate).value},
        assignedAuthor: {id: [{root: generateUUID()}]}
    };

    if recorder != () {
        // Find the referenced practitioner in allResources
        uscore501:USCorePractitionerProfile? practitioner = findPractitionerByReference(<r4:Reference>recorder, allResources);
        if practitioner != () {
            author.assignedAuthor = createAssignedAuthorFromPractitioner(practitioner);
        }
    }

    return author;
}

# Create Comment Activity
isolated function createCommentActivity(r4:Annotation note) returns EntryRelationship {
    Act commentAct = {
        classCode: "ACT",
        moodCode: "EVN",
        code: {code: "48767-8", codeSystem: "2.16.840.1.113883.6.1", displayName: "Comment"},
        text: {xmlText: note.text}
    };

    return {
        typeCode: "SUBJ",
        act: commentAct
    };
}

# Create Reaction Observation
isolated function createReactionObservation(uscore501:USCoreAllergyIntoleranceReaction reaction) returns EntryRelationship {
    Observation reactionObs = {
        classCode: "OBS",
        moodCode: "EVN",
        entryRelationship: []
    ,code: {code: "ASSERTION", codeSystem: "2.16.840.1.113883.5.4"}};

    // Map manifestation
    if reaction.manifestation is r4:CodeableConcept[] {
        CE[] manifestations = [];
        foreach r4:CodeableConcept manifestation in <r4:CodeableConcept[]>reaction.manifestation {
            CE? ccdaManifestation = mapFhirCodeableConceptToCcdaCoding(manifestation);
            if ccdaManifestation != () {
                manifestations.push(ccdaManifestation);
            }
        }
        if manifestations.length() > 0 {
            PQ[] manifestationsPQ = [];
            foreach CE manifestation in manifestations {
                if manifestation.code != () {
                    decimal|error manifestationCode = decimal:fromString(<string>manifestation.code);
                    if manifestationCode is decimal {
                        manifestationsPQ.push({value: manifestationCode});
                    }
                }
            }
            reactionObs.value = manifestationsPQ; // Use first manifestation as primary value
        }
    }

    // Map onset (only if AllergyIntolerance.onset was not available)
    if reaction.onset is r4:dateTime {
        IVL_TS reactionOnset = {
            low: {value: mapFhirDateTimeToCcdaDateTime(<r4:dateTime>reaction.onset).value}
        };
        reactionObs.effectiveTime = reactionOnset;
    }

    // Map severity
    if reaction.severity is uscore501:USCoreAllergyIntoleranceReactionSeverity {
        EntryRelationship severityObs = createSeverityObservation(<uscore501:USCoreAllergyIntoleranceReactionSeverity>reaction.severity);
        if reactionObs.entryRelationship is EntryRelationship[] {
            (<EntryRelationship[]>reactionObs.entryRelationship).push(severityObs);
        } else {
            reactionObs.entryRelationship = [severityObs];
        }
    }

    return {
        typeCode: "MFST",
        observation: reactionObs
    };
}

# Create Severity Observation
isolated function createSeverityObservation(uscore501:USCoreAllergyIntoleranceReactionSeverity severity) returns EntryRelationship {
        Observation severityObs = {
        classCode: "OBS",
        moodCode: "EVN",
        code: {code: "SEV", codeSystem: "2.16.840.1.113883.5.4", displayName: "Severity"},
        value: []
    };

    CE? severityValue = mapFhirSeverityToCcdaValue(severity);
    if severityValue != () {
        decimal|error severityCode = decimal:fromString(<string>severityValue.code);
        if severityCode is decimal {
            PQ[] severityPQ = [{value: severityCode}];
            severityObs.value = severityPQ;
        }
    }
    return {
        typeCode: "SUBJ",
        observation: severityObs
    };
}

# Map FHIR Allergy Type to C-CDA Value
isolated function mapFhirAllergyTypeToCcdaValue(
    uscore501:USCoreAllergyIntoleranceType 'type,
    uscore501:USCoreAllergyIntoleranceCategory[]? categories
) returns CE? {
    string? code = ();
    string? codeSystem = "http://snomed.info/sct";
    string? displayName = ();

    boolean hasFood = false;
    boolean hasMedication = false;
    boolean hasBiologicOrEnv = false;

    if categories is uscore501:USCoreAllergyIntoleranceCategory[] {
        foreach var cat in categories {
            if cat == "food" {
                hasFood = true;
            } else if cat == "medication" {
                hasMedication = true;
            } else if cat == "biologic" || cat == "environment" {
                hasBiologicOrEnv = true;
            }
        }
    }

    match 'type {
        "allergy" => {
            if hasFood {
                code = "414285001";
                displayName = "Allergy to food";
            } else if hasMedication {
                code = "416098002";
                displayName = "Allergy to drug";
            } else if hasBiologicOrEnv {
                code = "419199007";
                displayName = "Allergy to substance";
            } else {
                code = "419199007";
                displayName = "Allergy to substance";
            }
        }
        "intolerance" => {
            if hasFood {
                code = "235719002";
                displayName = "Intolerance to food";
            } else if hasMedication {
                code = "59037007";
                displayName = "Intolerance to drug";
            } else {
                code = "420134006";
                displayName = "Propensity to adverse reaction";
            }
        }
        "adverse-reaction" => {
            code = "420134006";
            displayName = "Propensity to adverse reaction";
        }
    }

    if code != () {
        return {
            code: code,
            codeSystem: codeSystem,
            displayName: displayName
        };
    }
    return ();
}

# Map FHIR Allergy Category to C-CDA Value
isolated function mapFhirAllergyCategoryToCcdaValue(uscore501:USCoreAllergyIntoleranceCategory category) returns CE? {
    string? code = ();
    string? codeSystem = "http://snomed.info/sct";
    string? displayName = ();

    match category {
        "medication" => {
            code = "373873005";
            displayName = "Pharmaceutical / biologic product";
        }
        "food" => {
            code = "255620007";
            displayName = "Food";
        }
        "environment" => {
            code = "260413007";
            displayName = "None";
        }
        "biologic" => {
            code = "373873005";
            displayName = "Pharmaceutical / biologic product";
        }
    }

    if code != () {
        return {
            code: code,
            codeSystem: codeSystem,
            displayName: displayName
        };
    }

    return ();
}

# Map FHIR Criticality to C-CDA Value
isolated function mapFhirCriticalityToCcdaValue(uscore501:USCoreAllergyIntoleranceCriticality criticality) returns CE? {
    string? code = ();
    string? codeSystem = ();
    string? displayName = ();

    match criticality {
        "low" => {
            code = "L";
            codeSystem = "2.16.840.1.113883.5.4";
            displayName = "Low";
        }
        "high" => {
            code = "H";
            codeSystem = "2.16.840.1.113883.5.4";
            displayName = "High";
        }
        "unable-to-assess" => {
            code = "U";
            codeSystem = "2.16.840.1.113883.5.4";
            displayName = "Unable to Assess";
        }
    }

    if code != () {
        return {
            code: code,
            codeSystem: codeSystem,
            displayName: displayName
        };
    }

    return ();
}

# Map FHIR Severity to C-CDA Value
isolated function mapFhirSeverityToCcdaValue(uscore501:USCoreAllergyIntoleranceReactionSeverity severity) returns CE? {
    string? code = ();
    string? codeSystem = ();
    string? displayName = ();

    match severity {
        "mild" => {
            code = "MILD";
            codeSystem = "2.16.840.1.113883.5.4";
            displayName = "Mild";
        }
        "moderate" => {
            code = "MOD";
            codeSystem = "2.16.840.1.113883.5.4";
            displayName = "Moderate";
        }
        "severe" => {
            code = "SEV";
            codeSystem = "2.16.840.1.113883.5.4";
            displayName = "Severe";
        }
    }

    if code != () {
        return {
            code: code,
            codeSystem: codeSystem,
            displayName: displayName
        };
    }

    return ();
}

# Helper function to extract reference ID from reference string
isolated function extractReferenceId(string reference) returns string {
    // Extract ID from reference like "Encounter/123" -> "123"
    string[] parts = re `$reference`.split("/");
    if parts.length() > 1 {
        return parts[1];
    }
    return reference;
}

# Helper function to find practitioner by reference
isolated function findPractitionerByReference(r4:Reference reference, r4:Resource[] allResources) returns uscore501:USCorePractitionerProfile? {
    if reference.reference is string {
        string targetId = extractReferenceId(<string>reference.reference);
        foreach r4:Resource 'resource in allResources {
            if 'resource is uscore501:USCorePractitionerProfile {
                uscore501:USCorePractitionerProfile practitioner = 'resource;
                if practitioner.id == targetId {
                    return practitioner;
                }
            }
        }
    } else {
        return ();
    }
}

# Helper function to create assigned author from practitioner
isolated function createAssignedAuthorFromPractitioner(uscore501:USCorePractitionerProfile practitioner) returns AssignedAuthor {
    AssignedAuthor assignedAuthor = {id: [{root: generateUUID()}]};

    if practitioner.name is uscore501:USCorePractitionerProfileName[] {
        PN[] names = [];
        foreach uscore501:USCorePractitionerProfileName name in <uscore501:USCorePractitionerProfileName[]>practitioner.name {
            PN? ccdaName = mapFhirNameToCcdaName(name);
            if ccdaName != () {
                names.push(ccdaName);
            }
        }
        if names.length() > 0 {
            assignedAuthor.assignedPerson = {
                name: names
            };
        }
    }

    return assignedAuthor;
}
