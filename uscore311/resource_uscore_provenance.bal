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

import ballerina/constraint;
import ballerinax/health.fhir.r4;

public const string PROFILE_BASE_USCOREPROVENANCE = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance";
public const RESOURCE_NAME_USCOREPROVENANCE = "Provenance";

# FHIR USCoreProvenance resource record.
#
# + resourceType - The type of the resource describes
# + reason - The reason that the activity was taking place.
# + agent - An actor taking a role in an activity for which it can be assigned some degree of responsibility for the activity taking place.
# * agent Slicings
# 1) USCoreProvenanceAgentProvenanceAuthor: Actor involved
#       - min = 0
#       - max = *
#
# 2) USCoreProvenanceAgentProvenanceTransmitter: Actor involved
#       - min = 0
#       - max = 1
#
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + activity - An activity is something that occurs over a period of time and acts upon or with entities; it may include consuming, processing, transforming, modifying, relocating, using, or generating entities.
# + signature - A digital signature on the target Reference(s). The signer should match a Provenance.agent. The purpose of the signature is indicated.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + language - The base language in which the resource is written.
# + occurredPeriod - The period during which the activity occurred.
# + recorded - The instant of time at which the activity was recorded.
# + target - The Reference(s) that were generated or updated by the activity described in this resource. A provenance can point to more than one target if multiple resources were created/updated by the same activity.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + location - Where the activity occurred, if relevant.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + entity - An entity used in this activity.
# + occurredDateTime - The period during which the activity occurred.
# + policy - Policy or plan the activity was defined by. Typically, a single activity may have multiple applicable policy documents, such as patient consent, guarantor funding, etc.
@r4:ResourceDefinition {
    resourceType: "Provenance",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance",
    elements: {
        "reason" : {
            name: "reason",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Provenance.reason",
            valueSet: "http://terminology.hl7.org/ValueSet/v3-PurposeOfUse"
        },
        "agent" : {
            name: "agent",
            dataType: USCoreProvenanceAgent,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Provenance.agent"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Provenance.extension"
        },
        "activity" : {
            name: "activity",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "Provenance.activity",
            valueSet: "http://hl7.org/fhir/ValueSet/provenance-activity-type"
        },
        "signature" : {
            name: "signature",
            dataType: r4:Signature,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Provenance.signature"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Provenance.modifierExtension"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Provenance.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "occurredPeriod" : {
            name: "occurredPeriod",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "Provenance.occurred[x]"
        },
        "recorded" : {
            name: "recorded",
            dataType: r4:instant,
            min: 1,
            max: 1,
            isArray: false,
            path: "Provenance.recorded"
        },
        "target" : {
            name: "target",
            dataType: r4:Reference,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Provenance.target"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Provenance.contained"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Provenance.meta"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Provenance.implicitRules"
        },
        "location" : {
            name: "location",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "Provenance.location"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Provenance.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Provenance.text"
        },
        "entity" : {
            name: "entity",
            dataType: USCoreProvenanceEntity,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Provenance.entity"
        },
        "occurredDateTime" : {
            name: "occurredDateTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "Provenance.occurred[x]"
        },
        "policy" : {
            name: "policy",
            dataType: r4:uri,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Provenance.policy"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type USCoreProvenance record {|
    *r4:DomainResource;

    RESOURCE_NAME_USCOREPROVENANCE resourceType = RESOURCE_NAME_USCOREPROVENANCE;

    r4:CodeableConcept[] reason?;
    @constraint:Array {
        minLength: {
            value: 1,
            message: "Validation failed for $.Provenance.agent constraint. This field must be an array containing at least one item."
        },
        maxLength: {
            value: 1,
            message: "Validation failed for $.Provenance.agent constraint. This field must be an array containing at most one item."
        }
    }
    USCoreProvenanceAgent[] agent;
    r4:Extension[] extension?;
    r4:CodeableConcept activity?;
    r4:Signature[] signature?;
    r4:Extension[] modifierExtension?;
    r4:code language?;
    r4:Period occurredPeriod?;
    r4:instant recorded;
    @constraint:Array {
        minLength: {
            value: 1,
            message: "Validation failed for $.Provenance.target constraint. This field must be an array containing at least one item."
        },
        maxLength: {
            value: 1,
            message: "Validation failed for $.Provenance.target constraint. This field must be an array containing at most one item."
        }
    }
    r4:Reference[] target;
    r4:Resource[] contained?;
    r4:Meta meta?;
    r4:uri implicitRules?;
    r4:Reference location?;
    string id?;
    r4:Narrative text?;
    USCoreProvenanceEntity[] entity?;
    r4:dateTime occurredDateTime?;
    r4:uri[] policy?;
    r4:Element ...;
|};

# FHIR USCoreProvenanceAgentTypeCodingOne datatype record.
#
# + system - The identification of the code system that defines the meaning of the symbol in the code.
# + code - A symbol in syntax defined by the system. The symbol may be a predefined code or an expression in a syntax defined by the coding system (e.g. post-coordination).
@r4:DataTypeDefinition {
    name: "USCoreProvenanceAgentTypeCodingOne",
    baseType: (),
    elements: {
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "The identification of the code system that defines the meaning of the symbol in the code.",
            path: "Provenance.agent.type.coding.system"
        },
        "code": {
            name: "code",
            dataType: r4:code,
            min: 1,
            max: 1,
            isArray: false,
            description: "A symbol in syntax defined by the system. The symbol may be a predefined code or an expression in a syntax defined by the coding system (e.g. post-coordination).",
            path: "Provenance.agent.type.coding.code"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreProvenanceAgentTypeCodingOne record {|
    *r4:Coding;

    r4:uri system = "http://hl7.org/fhir/us/core/CodeSystem/us-core-provenance-participant-type";
    r4:code code = "transmitter";
|};

# FHIR USCoreProvenanceAgentTypeCoding datatype record.
#
# + system - The identification of the code system that defines the meaning of the symbol in the code.
# + code - A symbol in syntax defined by the system. The symbol may be a predefined code or an expression in a syntax defined by the coding system (e.g. post-coordination).
@r4:DataTypeDefinition {
    name: "USCoreProvenanceAgentTypeCoding",
    baseType: (),
    elements: {
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "The identification of the code system that defines the meaning of the symbol in the code.",
            path: "Provenance.agent.type.coding.system"
        },
        "code": {
            name: "code",
            dataType: r4:code,
            min: 1,
            max: 1,
            isArray: false,
            description: "A symbol in syntax defined by the system. The symbol may be a predefined code or an expression in a syntax defined by the coding system (e.g. post-coordination).",
            path: "Provenance.agent.type.coding.code"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreProvenanceAgentTypeCoding record {|
    *r4:Coding;

    r4:uri system = "http://terminology.hl7.org/CodeSystem/provenance-participant-type";
    r4:code code = "author";
|};

# USCoreProvenanceEntityRole enum
public enum USCoreProvenanceEntityRole {
   CODE_ROLE_REMOVAL = "removal",
   CODE_ROLE_DERIVATION = "derivation",
   CODE_ROLE_SOURCE = "source",
   CODE_ROLE_QUOTATION = "quotation",
   CODE_ROLE_REVISION = "revision"
}

# FHIR USCoreProvenanceEntity datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + role - How the entity was used during the activity.
# + what - Identity of the Entity used. May be a logical or physical uri and maybe absolute or relative.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
@r4:DataTypeDefinition {
    name: "USCoreProvenanceEntity",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Provenance.entity.extension"
        },
        "role": {
            name: "role",
            dataType: USCoreProvenanceEntityRole,
            min: 1,
            max: 1,
            isArray: false,
            description: "How the entity was used during the activity.",
            path: "Provenance.entity.role"
        },
        "what": {
            name: "what",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            description: "Identity of the Entity used. May be a logical or physical uri and maybe absolute or relative.",
            path: "Provenance.entity.what"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Provenance.entity.modifierExtension"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Provenance.entity.id"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreProvenanceEntity record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    USCoreProvenanceEntityRole role;
    r4:Reference what;
    r4:Extension[] modifierExtension?;
    string id?;
|};

# FHIR USCoreProvenanceAgentType datatype record.
#
# + coding - A reference to a code defined by a terminology system.
@r4:DataTypeDefinition {
    name: "USCoreProvenanceAgentType",
    baseType: (),
    elements: {
        "coding": {
            name: "coding",
            dataType: USCoreProvenanceAgentTypeCoding,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            description: "A reference to a code defined by a terminology system.",
            path: "Provenance.agent.type.coding"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreProvenanceAgentType record {|
    *r4:CodeableConcept;

    @constraint:Array {
        minLength: {
            value: 1,
            message: "Validation failed for $.Provenance.agent.type.coding constraint. This field must be an array containing at least one item."
        },
        maxLength: {
            value: 1,
            message: "Validation failed for $.Provenance.agent.type.coding constraint. This field must be an array containing at most one item."
        }
    }
    USCoreProvenanceAgentTypeCoding[] coding;
|};

# FHIR USCoreProvenanceAgent datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + role - The function of the agent with respect to the activity. The security role enabling the agent with respect to the activity.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + onBehalfOf - The individual, device, or organization for whom the change was made.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - The participation the agent had with respect to the activity.
# + who - The individual, device or organization that participated in the event.
@r4:DataTypeDefinition {
    name: "USCoreProvenanceAgent",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Provenance.agent.extension"
        },
        "role": {
            name: "role",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "The function of the agent with respect to the activity. The security role enabling the agent with respect to the activity.",
            path: "Provenance.agent.role"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Provenance.agent.modifierExtension"
        },
        "onBehalfOf": {
            name: "onBehalfOf",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "The individual, device, or organization for whom the change was made.",
            path: "Provenance.agent.onBehalfOf"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Provenance.agent.id"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The participation the agent had with respect to the activity.",
            path: "Provenance.agent.type"
        },
        "who": {
            name: "who",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            description: "The individual, device or organization that participated in the event.",
            path: "Provenance.agent.who"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreProvenanceAgent record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    r4:CodeableConcept[] role?;
    r4:Extension[] modifierExtension?;
    r4:Reference onBehalfOf?;
    string id?;
    r4:CodeableConcept 'type?;
    r4:Reference who;
|};

# FHIR USCoreProvenanceAgentProvenanceAuthor datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + role - The function of the agent with respect to the activity. The security role enabling the agent with respect to the activity.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + onBehalfOf - The individual, device, or organization for whom the change was made.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - The participation the agent had with respect to the activity.
# + who - The individual, device or organization that participated in the event.
@r4:DataTypeDefinition {
    name: "USCoreProvenanceAgentProvenanceAuthor",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Provenance.agent.extension"
        },
        "role": {
            name: "role",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "The function of the agent with respect to the activity. The security role enabling the agent with respect to the activity.",
            path: "Provenance.agent.role"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Provenance.agent.modifierExtension"
        },
        "onBehalfOf": {
            name: "onBehalfOf",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "The individual, device, or organization for whom the change was made.",
            path: "Provenance.agent.onBehalfOf"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Provenance.agent.id"
        },
        "type": {
            name: "type",
            dataType: USCoreProvenanceAgentType,
            min: 1,
            max: 1,
            isArray: false,
            description: "The participation the agent had with respect to the activity.",
            path: "Provenance.agent.type"
        },
        "who": {
            name: "who",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            description: "The individual, device or organization that participated in the event.",
            path: "Provenance.agent.who"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreProvenanceAgentProvenanceAuthor record {|
    *USCoreProvenanceAgent;

    r4:Extension[] extension?;
    r4:CodeableConcept[] role?;
    r4:Extension[] modifierExtension?;
    r4:Reference onBehalfOf?;
    string id?;
    USCoreProvenanceAgentType 'type;
    r4:Reference who;
|};

# FHIR USCoreProvenanceAgentTypeOne datatype record.
#
# + coding - A reference to a code defined by a terminology system.
@r4:DataTypeDefinition {
    name: "USCoreProvenanceAgentTypeOne",
    baseType: (),
    elements: {
        "coding": {
            name: "coding",
            dataType: USCoreProvenanceAgentTypeCodingOne,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            description: "A reference to a code defined by a terminology system.",
            path: "Provenance.agent.type.coding"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreProvenanceAgentTypeOne record {|
    *r4:CodeableConcept;

    @constraint:Array {
        minLength: {
            value: 1,
            message: "Validation failed for $.Provenance.agent.type.coding constraint. This field must be an array containing at least one item."
        },
        maxLength: {
            value: 1,
            message: "Validation failed for $.Provenance.agent.type.coding constraint. This field must be an array containing at most one item."
        }
    }
    USCoreProvenanceAgentTypeCodingOne[] coding;
|};

# FHIR USCoreProvenanceAgentProvenanceTransmitter datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + role - The function of the agent with respect to the activity. The security role enabling the agent with respect to the activity.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + onBehalfOf - The individual, device, or organization for whom the change was made.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - The participation the agent had with respect to the activity.
# + who - The individual, device or organization that participated in the event.
@r4:DataTypeDefinition {
    name: "USCoreProvenanceAgentProvenanceTransmitter",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Provenance.agent.extension"
        },
        "role": {
            name: "role",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "The function of the agent with respect to the activity. The security role enabling the agent with respect to the activity.",
            path: "Provenance.agent.role"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Provenance.agent.modifierExtension"
        },
        "onBehalfOf": {
            name: "onBehalfOf",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "The individual, device, or organization for whom the change was made.",
            path: "Provenance.agent.onBehalfOf"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Provenance.agent.id"
        },
        "type": {
            name: "type",
            dataType: USCoreProvenanceAgentTypeOne,
            min: 1,
            max: 1,
            isArray: false,
            description: "The participation the agent had with respect to the activity.",
            path: "Provenance.agent.type"
        },
        "who": {
            name: "who",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            description: "The individual, device or organization that participated in the event.",
            path: "Provenance.agent.who"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreProvenanceAgentProvenanceTransmitter record {|
    *USCoreProvenanceAgent;

    r4:Extension[] extension?;
    r4:CodeableConcept[] role?;
    r4:Extension[] modifierExtension?;
    r4:Reference onBehalfOf?;
    string id?;
    USCoreProvenanceAgentTypeOne 'type;
    r4:Reference who;
|};
