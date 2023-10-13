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

public const string PROFILE_BASE_MEDICATIONSTATEMENT = "http://hl7.org/fhir/StructureDefinition/MedicationStatement";
public const RESOURCE_NAME_MEDICATIONSTATEMENT = "MedicationStatement";

# FHIR MedicationStatement resource record.
#
# + resourceType - The type of the resource describes
# + dosage - Indicates how the medication is/was or should be taken by the patient.
# + note - Provides extra information about the medication statement that is not conveyed by the other attributes.
# + partOf - A larger event of which this particular event is a component or step.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + subject - The person, animal or group who is/was taking the medication.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + reasonReference - Condition or observation that supports why the medication is being/was taken.
# + language - The base language in which the resource is written.
# + medicationReference - Identifies the medication being administered. This is either a link to a resource representing the details of the medication or a simple attribute carrying a code that identifies the medication from a known list of medications.
# + statusReason - Captures the reason for the current state of the MedicationStatement.
# + informationSource - The person or organization that provided the information about the taking of this medication. Note: Use derivedFrom when a MedicationStatement is derived from other resources, e.g. Claim or MedicationRequest.
# + context - The encounter or episode of care that establishes the context for this MedicationStatement.
# + derivedFrom - Allows linking the MedicationStatement to the underlying MedicationRequest, or to other information that supports or is used to derive the MedicationStatement.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + reasonCode - A reason for why the medication is being/was taken.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + dateAsserted - The date when the medication statement was asserted by the information source.
# + basedOn - A plan, proposal or order that is fulfilled in whole or in part by this event.
# + identifier - Identifiers associated with this Medication Statement that are defined by business processes and/or used to refer to it when a direct URL reference to the resource itself is not appropriate. They are business identifiers assigned to this resource by the performer or other systems and remain constant as the resource is updated and propagates from server to server.
# + effectivePeriod - The interval of time during which it is being asserted that the patient is/was/will be taking the medication (or was not taking, when the MedicationStatement.taken element is No).
# + medicationCodeableConcept - Identifies the medication being administered. This is either a link to a resource representing the details of the medication or a simple attribute carrying a code that identifies the medication from a known list of medications.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + effectiveDateTime - The interval of time during which it is being asserted that the patient is/was/will be taking the medication (or was not taking, when the MedicationStatement.taken element is No).
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + category - Indicates where the medication is expected to be consumed or administered.
# + status - A code representing the patient or other source's judgment about the state of the medication used that this statement is about. Generally, this will be active or completed.
@r4:ResourceDefinition {
    resourceType: "MedicationStatement",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/MedicationStatement",
    elements: {
        "dosage" : {
            name: "dosage",
            dataType: r4:Dosage,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.dosage"
        },
        "note" : {
            name: "note",
            dataType: r4:Annotation,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.note"
        },
        "partOf" : {
            name: "partOf",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.partOf"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.extension"
        },
        "subject" : {
            name: "subject",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "MedicationStatement.subject"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.modifierExtension"
        },
        "reasonReference" : {
            name: "reasonReference",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.reasonReference"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "medicationReference" : {
            name: "medicationReference",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "MedicationStatement.medication[x]",
            valueSet: "http://hl7.org/fhir/ValueSet/medication-codes"
        },
        "statusReason" : {
            name: "statusReason",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.statusReason",
            valueSet: "http://hl7.org/fhir/ValueSet/reason-medication-status-codes"
        },
        "informationSource" : {
            name: "informationSource",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.informationSource"
        },
        "context" : {
            name: "context",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.context"
        },
        "derivedFrom" : {
            name: "derivedFrom",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.derivedFrom"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.id"
        },
        "reasonCode" : {
            name: "reasonCode",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.reasonCode",
            valueSet: "http://hl7.org/fhir/ValueSet/condition-code"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.text"
        },
        "dateAsserted" : {
            name: "dateAsserted",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.dateAsserted"
        },
        "basedOn" : {
            name: "basedOn",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.basedOn"
        },
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.identifier"
        },
        "effectivePeriod" : {
            name: "effectivePeriod",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.effective[x]"
        },
        "medicationCodeableConcept" : {
            name: "medicationCodeableConcept",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            path: "MedicationStatement.medication[x]",
            valueSet: "http://hl7.org/fhir/ValueSet/medication-codes"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "MedicationStatement.contained"
        },
        "effectiveDateTime" : {
            name: "effectiveDateTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.effective[x]"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.meta"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.implicitRules"
        },
        "category" : {
            name: "category",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "MedicationStatement.category",
            valueSet: "http://hl7.org/fhir/ValueSet/medication-statement-category"
        },
        "status" : {
            name: "status",
            dataType: MedicationStatementStatus,
            min: 1,
            max: 1,
            isArray: false,
            path: "MedicationStatement.status",
            valueSet: "http://hl7.org/fhir/ValueSet/medication-statement-status|4.0.1"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type MedicationStatement record {|
    *r4:DomainResource;

    RESOURCE_NAME_MEDICATIONSTATEMENT resourceType = RESOURCE_NAME_MEDICATIONSTATEMENT;

    r4:Dosage[] dosage?;
    r4:Annotation[] note?;
    r4:Reference[] partOf?;
    r4:Extension[] extension?;
    r4:Reference subject;
    r4:Extension[] modifierExtension?;
    r4:Reference[] reasonReference?;
    r4:code language?;
    r4:Reference medicationReference;
    r4:CodeableConcept[] statusReason?;
    r4:Reference informationSource?;
    r4:Reference context?;
    r4:Reference[] derivedFrom?;
    string id?;
    r4:CodeableConcept[] reasonCode?;
    r4:Narrative text?;
    r4:dateTime dateAsserted?;
    r4:Reference[] basedOn?;
    r4:Identifier[] identifier?;
    r4:Period effectivePeriod?;
    r4:CodeableConcept medicationCodeableConcept;
    r4:Resource[] contained?;
    r4:dateTime effectiveDateTime?;
    r4:Meta meta?;
    r4:uri implicitRules?;
    r4:CodeableConcept category?;
    MedicationStatementStatus status;
    r4:Element ...;
|};

# MedicationStatementStatus enum
public enum MedicationStatementStatus {
   CODE_STATUS_STOPPED = "stopped",
   CODE_STATUS_INTENDED = "intended",
   CODE_STATUS_ACTIVE = "active",
   CODE_STATUS_NOT_TAKEN = "not-taken",
   CODE_STATUS_COMPLETED = "completed",
   CODE_STATUS_ENTERED_IN_ERROR = "entered-in-error",
   CODE_STATUS_ON_HOLD = "on-hold",
   CODE_STATUS_UNKNOWN = "unknown"
}

