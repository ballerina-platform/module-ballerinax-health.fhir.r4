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

// AUTO-GENERATED FILE.
// This file is auto-generated by Ballerina.

import ballerinax/health.fhir.r4;

public const string PROFILE_BASE_MEDICALHISTORY = "http://openhie.org/fhir/sri-lanka/StructureDefinition/medical-history";
public const RESOURCE_NAME_MEDICALHISTORY = "Condition";

# FHIR MedicalHistory resource record.
#
# + resourceType - The type of the resource describes
# + note - Additional information about the Condition. This is a general notes/comments entry for description of the Condition, its diagnosis and prognosis.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + code - Identification of the condition, problem or diagnosis.
# + evidence - Supporting evidence / manifestations that are the basis of the Condition's verification status, such as evidence that confirmed or refuted the condition.
# + onsetRange - Estimated or actual date or date-time the condition began, in the opinion of the clinician.
# + abatementDateTime - The date or estimated date that the condition resolved or went into remission. This is called 'abatement' because of the many overloaded connotations associated with 'remission' or 'resolution' - Conditions are never really resolved, but they can abate.
# + subject - Indicates the patient or group who the condition record is associated with.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + language - The base language in which the resource is written.
# + clinicalStatus - The clinical status of the condition.
# + onsetDateTime - Estimated or actual date or date-time the condition began, in the opinion of the clinician.
# + onsetString - Estimated or actual date or date-time the condition began, in the opinion of the clinician.
# + onsetAge - Estimated or actual date or date-time the condition began, in the opinion of the clinician.
# + abatementPeriod - The date or estimated date that the condition resolved or went into remission. This is called 'abatement' because of the many overloaded connotations associated with 'remission' or 'resolution' - Conditions are never really resolved, but they can abate.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + abatementString - The date or estimated date that the condition resolved or went into remission. This is called 'abatement' because of the many overloaded connotations associated with 'remission' or 'resolution' - Conditions are never really resolved, but they can abate.
# + severity - A subjective assessment of the severity of the condition as evaluated by the clinician.
# + identifier - Business identifiers assigned to this condition by the performer or other systems which remain constant as the resource is updated and propagates from server to server.
# + recorder - reason(s) why this should be supported.
# + onsetPeriod - Estimated or actual date or date-time the condition began, in the opinion of the clinician.
# + verificationStatus - reason(s) why this should be supported.
# + recordedDate - The recordedDate represents when this particular Condition record was created in the system, which is often a system-generated date.
# + abatementRange - The date or estimated date that the condition resolved or went into remission. This is called 'abatement' because of the many overloaded connotations associated with 'remission' or 'resolution' - Conditions are never really resolved, but they can abate.
# + encounter - The Encounter during which this Condition was created or to which the creation of this record is tightly associated.
# + bodySite - The anatomical location where this condition manifests itself.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + asserter - reason(s) why this should be supported.
# + stage - Clinical stage or grade of a condition. May include formal severity assessments.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + category - reason(s) why this should be supported.
# + abatementAge - The date or estimated date that the condition resolved or went into remission. This is called 'abatement' because of the many overloaded connotations associated with 'remission' or 'resolution' - Conditions are never really resolved, but they can abate.
@r4:ResourceDefinition {
    resourceType: "Condition",
    baseType: r4:DomainResource,
    profile: "http://openhie.org/fhir/sri-lanka/StructureDefinition/medical-history",
    elements: {
        "note" : {
            name: "note",
            dataType: r4:Annotation,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Condition.note"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Condition.extension"
        },
        "code" : {
            name: "code",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            path: "Condition.code",
            valueSet: "http://openhie.org/fhir/sri-lanka/ValueSet/vs-medical-conditions"
        },
        "evidence" : {
            name: "evidence",
            dataType: MedicalHistoryEvidence,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Condition.evidence"
        },
        "onsetRange" : {
            name: "onsetRange",
            dataType: r4:Range,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.onset[x]"
        },
        "abatementDateTime" : {
            name: "abatementDateTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.abatement[x]"
        },
        "subject" : {
            name: "subject",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "Condition.subject"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Condition.modifierExtension"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "clinicalStatus" : {
            name: "clinicalStatus",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            path: "Condition.clinicalStatus",
            valueSet: "http://hl7.org/fhir/ValueSet/condition-clinical|4.0.1"
        },
        "onsetDateTime" : {
            name: "onsetDateTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.onset[x]"
        },
        "onsetString" : {
            name: "onsetString",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.onset[x]"
        },
        "onsetAge" : {
            name: "onsetAge",
            dataType: r4:Age,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.onset[x]"
        },
        "abatementPeriod" : {
            name: "abatementPeriod",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.abatement[x]"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.text"
        },
        "abatementString" : {
            name: "abatementString",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.abatement[x]"
        },
        "severity" : {
            name: "severity",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.severity",
            valueSet: "http://hl7.org/fhir/ValueSet/condition-severity"
        },
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Condition.identifier"
        },
        "recorder" : {
            name: "recorder",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.recorder"
        },
        "onsetPeriod" : {
            name: "onsetPeriod",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.onset[x]"
        },
        "verificationStatus" : {
            name: "verificationStatus",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.verificationStatus",
            valueSet: "http://hl7.org/fhir/ValueSet/condition-ver-status|4.0.1"
        },
        "recordedDate" : {
            name: "recordedDate",
            dataType: r4:dateTime,
            min: 1,
            max: 1,
            isArray: false,
            path: "Condition.recordedDate"
        },
        "abatementRange" : {
            name: "abatementRange",
            dataType: r4:Range,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.abatement[x]"
        },
        "encounter" : {
            name: "encounter",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "Condition.encounter"
        },
        "bodySite" : {
            name: "bodySite",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Condition.bodySite",
            valueSet: "http://hl7.org/fhir/ValueSet/body-site"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Condition.contained"
        },
        "asserter" : {
            name: "asserter",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.asserter"
        },
        "stage" : {
            name: "stage",
            dataType: MedicalHistoryStage,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Condition.stage"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.meta"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.implicitRules"
        },
        "category" : {
            name: "category",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Condition.category",
            valueSet: "http://hl7.org/fhir/ValueSet/condition-category"
        },
        "abatementAge" : {
            name: "abatementAge",
            dataType: r4:Age,
            min: 0,
            max: 1,
            isArray: false,
            path: "Condition.abatement[x]"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type MedicalHistory record {|
    *r4:DomainResource;

    RESOURCE_NAME_MEDICALHISTORY resourceType = RESOURCE_NAME_MEDICALHISTORY;

    r4:Annotation[] note?;
    r4:Extension[] extension?;
    r4:CodeableConcept code;
    MedicalHistoryEvidence[] evidence?;
    r4:Range onsetRange?;
    r4:dateTime abatementDateTime?;
    r4:Reference subject;
    r4:Extension[] modifierExtension?;
    r4:code language?;
    r4:CodeableConcept clinicalStatus;
    r4:dateTime onsetDateTime?;
    string onsetString?;
    r4:Age onsetAge?;
    r4:Period abatementPeriod?;
    string id?;
    r4:Narrative text?;
    string abatementString?;
    r4:CodeableConcept severity?;
    r4:Identifier[] identifier?;
    r4:Reference recorder?;
    r4:Period onsetPeriod?;
    r4:CodeableConcept verificationStatus?;
    r4:dateTime recordedDate;
    r4:Range abatementRange?;
    r4:Reference encounter;
    r4:CodeableConcept[] bodySite?;
    r4:Resource[] contained?;
    r4:Reference asserter?;
    MedicalHistoryStage[] stage?;
    r4:Meta meta?;
    r4:uri implicitRules?;
    r4:CodeableConcept[] category?;
    r4:Age abatementAge?;
    r4:Element ...;
|};

# FHIR MedicalHistoryEvidence datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + code - A manifestation or symptom that led to the recording of this condition.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + detail - Links to other relevant information, including pathology reports.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
@r4:DataTypeDefinition {
    name: "MedicalHistoryEvidence",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Condition.evidence.extension"
        },
        "code": {
            name: "code",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "A manifestation or symptom that led to the recording of this condition.",
            path: "Condition.evidence.code"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Condition.evidence.modifierExtension"
        },
        "detail": {
            name: "detail",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Links to other relevant information, including pathology reports.",
            path: "Condition.evidence.detail"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Condition.evidence.id"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type MedicalHistoryEvidence record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    r4:CodeableConcept[] code?;
    r4:Extension[] modifierExtension?;
    r4:Reference[] detail?;
    string id?;
|};

# FHIR MedicalHistoryStage datatype record.
#
# + summary - A simple summary of the stage such as 'Stage 3'. The determination of the stage is disease-specific.
# + assessment - Reference to a formal record of the evidence on which the staging assessment is based.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - The kind of staging, such as pathological or clinical staging.
@r4:DataTypeDefinition {
    name: "MedicalHistoryStage",
    baseType: (),
    elements: {
        "summary": {
            name: "summary",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A simple summary of the stage such as 'Stage 3'. The determination of the stage is disease-specific.",
            path: "Condition.stage.summary"
        },
        "assessment": {
            name: "assessment",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Reference to a formal record of the evidence on which the staging assessment is based.",
            path: "Condition.stage.assessment"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Condition.stage.extension"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Condition.stage.modifierExtension"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Condition.stage.id"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The kind of staging, such as pathological or clinical staging.",
            path: "Condition.stage.type"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type MedicalHistoryStage record {|
    *r4:BackboneElement;

    r4:CodeableConcept summary?;
    r4:Reference[] assessment?;
    r4:Extension[] extension?;
    r4:Extension[] modifierExtension?;
    string id?;
    r4:CodeableConcept 'type?;
|};

