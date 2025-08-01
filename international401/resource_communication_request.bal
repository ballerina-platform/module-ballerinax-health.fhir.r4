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

public const string PROFILE_BASE_COMMUNICATIONREQUEST = "http://hl7.org/fhir/StructureDefinition/CommunicationRequest";
public const RESOURCE_NAME_COMMUNICATIONREQUEST = "CommunicationRequest";

# FHIR CommunicationRequest resource record.
#
# + resourceType - The type of the resource describes
# + note - Comments made about the request by the requester, sender, recipient, subject or other participants.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + subject - The patient or group that is the focus of this communication request.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + about - Other resources that pertain to this communication request and to which this communication request should be associated.
# + reasonReference - Indicates another resource whose existence justifies this request.
# + language - The base language in which the resource is written.
# + medium - A channel that was used for this communication (e.g. email, fax).
# + statusReason - Captures the reason for the current state of the CommunicationRequest.
# + payload - Text, attachment(s), or resource(s) to be communicated to the recipient.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + reasonCode - Describes why the request is being made in coded or textual form.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + doNotPerform - If true indicates that the CommunicationRequest is asking for the specified action to *not* occur.
# + basedOn - A plan or proposal that is fulfilled in whole or in part by this request.
# + requester - The device, individual, or organization who initiated the request and has responsibility for its activation.
# + identifier - Business identifiers assigned to this communication request by the performer or other systems which remain constant as the resource is updated and propagates from server to server.
# + authoredOn - For draft requests, indicates the date of initial creation. For requests with other statuses, indicates the date of activation.
# + replaces - Completed or terminated request(s) whose function is taken by this new request.
# + encounter - The Encounter during which this CommunicationRequest was created or to which the creation of this record is tightly associated.
# + priority - Characterizes how quickly the proposed act must be initiated. Includes concepts such as stat, urgent, routine.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + occurrencePeriod - The time when this communication is to occur.
# + sender - The entity (e.g. person, organization, clinical information system, or device) which is to be the source of the communication.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + recipient - The entity (e.g. person, organization, clinical information system, device, group, or care team) which is the intended target of the communication.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + occurrenceDateTime - The time when this communication is to occur.
# + category - The type of message to be sent such as alert, notification, reminder, instruction, etc.
# + groupIdentifier - A shared identifier common to all requests that were authorized more or less simultaneously by a single author, representing the identifier of the requisition, prescription or similar form.
# + status - The status of the proposal or order.
@r4:ResourceDefinition {
    resourceType: "CommunicationRequest",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/CommunicationRequest",
    elements: {
        "note" : {
            name: "note",
            dataType: r4:Annotation,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.note"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.extension"
        },
        "subject" : {
            name: "subject",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.subject"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.modifierExtension"
        },
        "about" : {
            name: "about",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.about"
        },
        "reasonReference" : {
            name: "reasonReference",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.reasonReference"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "medium" : {
            name: "medium",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.medium",
            valueSet: "http://terminology.hl7.org/ValueSet/v3-ParticipationMode"
        },
        "statusReason" : {
            name: "statusReason",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.statusReason"
        },
        "payload" : {
            name: "payload",
            dataType: CommunicationRequestPayload,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.payload"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.id"
        },
        "reasonCode" : {
            name: "reasonCode",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.reasonCode",
            valueSet: "http://terminology.hl7.org/ValueSet/v3-ActReason"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.text"
        },
        "doNotPerform" : {
            name: "doNotPerform",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.doNotPerform"
        },
        "basedOn" : {
            name: "basedOn",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.basedOn"
        },
        "requester" : {
            name: "requester",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.requester"
        },
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.identifier"
        },
        "authoredOn" : {
            name: "authoredOn",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.authoredOn"
        },
        "replaces" : {
            name: "replaces",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.replaces"
        },
        "encounter" : {
            name: "encounter",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.encounter"
        },
        "priority" : {
            name: "priority",
            dataType: CommunicationRequestPriority,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.priority",
            valueSet: "http://hl7.org/fhir/ValueSet/request-priority|4.0.1"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.contained"
        },
        "occurrencePeriod" : {
            name: "occurrencePeriod",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.occurrence[x]"
        },
        "sender" : {
            name: "sender",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.sender"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.meta"
        },
        "recipient" : {
            name: "recipient",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.recipient"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.implicitRules"
        },
        "occurrenceDateTime" : {
            name: "occurrenceDateTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.occurrence[x]"
        },
        "category" : {
            name: "category",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CommunicationRequest.category",
            valueSet: "http://hl7.org/fhir/ValueSet/communication-category"
        },
        "groupIdentifier" : {
            name: "groupIdentifier",
            dataType: r4:Identifier,
            min: 0,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.groupIdentifier"
        },
        "status" : {
            name: "status",
            dataType: CommunicationRequestStatus,
            min: 1,
            max: 1,
            isArray: false,
            path: "CommunicationRequest.status",
            valueSet: "http://hl7.org/fhir/ValueSet/request-status|4.0.1"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type CommunicationRequest record {|
    *r4:DomainResource;

    RESOURCE_NAME_COMMUNICATIONREQUEST resourceType = RESOURCE_NAME_COMMUNICATIONREQUEST;

    r4:Annotation[] note?;
    r4:Extension[] extension?;
    r4:Reference subject?;
    r4:Extension[] modifierExtension?;
    r4:Reference[] about?;
    r4:Reference[] reasonReference?;
    r4:code language?;
    r4:CodeableConcept[] medium?;
    r4:CodeableConcept statusReason?;
    CommunicationRequestPayload[] payload?;
    string id?;
    r4:CodeableConcept[] reasonCode?;
    r4:Narrative text?;
    boolean doNotPerform?;
    r4:Reference[] basedOn?;
    r4:Reference requester?;
    r4:Identifier[] identifier?;
    r4:dateTime authoredOn?;
    r4:Reference[] replaces?;
    r4:Reference encounter?;
    CommunicationRequestPriority priority?;
    r4:Resource[] contained?;
    r4:Period occurrencePeriod?;
    r4:Reference sender?;
    r4:Meta meta?;
    r4:Reference[] recipient?;
    r4:uri implicitRules?;
    r4:dateTime occurrenceDateTime?;
    r4:CodeableConcept[] category?;
    r4:Identifier groupIdentifier?;
    CommunicationRequestStatus status;
    r4:Element ...;
|};

# CommunicationRequestStatus enum
public enum CommunicationRequestStatus {
   CODE_STATUS_DRAFT = "draft",
   CODE_STATUS_ACTIVE = "active",
   CODE_STATUS_COMPLETED = "completed",
   CODE_STATUS_REVOKED = "revoked",
   CODE_STATUS_ENTERED_IN_ERROR = "entered-in-error",
   CODE_STATUS_ON_HOLD = "on-hold",
   CODE_STATUS_UNKNOWN = "unknown"
}

# CommunicationRequestPriority enum
public enum CommunicationRequestPriority {
   CODE_PRIORITY_STAT = "stat",
   CODE_PRIORITY_ROUTINE = "routine",
   CODE_PRIORITY_URGENT = "urgent",
   CODE_PRIORITY_ASAP = "asap"
}

# FHIR CommunicationRequestPayload datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + contentReference - The communicated content (or for multi-part communications, one portion of the communication).
# + contentString - The communicated content (or for multi-part communications, one portion of the communication).
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + contentAttachment - The communicated content (or for multi-part communications, one portion of the communication).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
@r4:DataTypeDefinition {
    name: "CommunicationRequestPayload",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "CommunicationRequest.payload.extension"
        },
        "contentReference": {
            name: "contentReference",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "The communicated content (or for multi-part communications, one portion of the communication).",
            path: "CommunicationRequest.payload.content[x]"
        },
        "contentString": {
            name: "contentString",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "The communicated content (or for multi-part communications, one portion of the communication).",
            path: "CommunicationRequest.payload.content[x]"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "CommunicationRequest.payload.modifierExtension"
        },
        "contentAttachment": {
            name: "contentAttachment",
            dataType: r4:Attachment,
            min: 0,
            max: 1,
            isArray: false,
            description: "The communicated content (or for multi-part communications, one portion of the communication).",
            path: "CommunicationRequest.payload.content[x]"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "CommunicationRequest.payload.id"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type CommunicationRequestPayload record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    r4:Reference contentReference;
    string contentString;
    r4:Extension[] modifierExtension?;
    r4:Attachment contentAttachment;
    string id?;
|};

