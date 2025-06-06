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

public const string PROFILE_BASE_PLANNETENDPOINT = "http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Endpoint";
public const RESOURCE_NAME_PLANNETENDPOINT = "Endpoint";

# FHIR PlannetEndpoint resource record.
#
# + resourceType - The type of the resource describes
# + identifier - Identifier for the organization that is used to identify the endpoint across multiple disparate systems.
# + extension - An Extension
# + period - The interval during which the endpoint is expected to be operational.
# + address - The uri that describes the actual end-point to connect to.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + language - The base language in which the resource is written.
# + connectionType - A coded value that represents the technical details of the usage of this endpoint, such as what WSDLs should be used in what way. (e.g. XDS.b/DICOM/cds-hook).
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + managingOrganization - The organization that manages this endpoint (even if technically another organization is hosting this in the cloud, it is the organization associated with the data).
# + payloadType - The payload type describes the acceptable content that can be communicated on the endpoint.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + contact - Contact details for a human to contact about the subscription. The primary use of this for system administrator troubleshooting.
# + name - A friendly name that this endpoint can be referred to with.
# + header - Additional headers / information to send as part of the notification.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + payloadMimeType - The mime type to send the payload in - e.g. application/fhir+xml, application/fhir+json. If the mime type is not specified, then the sender could send any content (including no content depending on the connectionType).
# + status - active | suspended | error | off | test.
@r4:ResourceDefinition {
    resourceType: "Endpoint",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Endpoint",
    elements: {
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Endpoint.identifier"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Endpoint.extension"
        },
        "period" : {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "Endpoint.period"
        },
        "address" : {
            name: "address",
            dataType: r4:urlType,
            min: 1,
            max: 1,
            isArray: false,
            path: "Endpoint.address"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Endpoint.modifierExtension"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Endpoint.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "connectionType" : {
            name: "connectionType",
            dataType: r4:Coding,
            min: 1,
            max: 1,
            isArray: false,
            path: "Endpoint.connectionType",
            valueSet: "http://hl7.org/fhir/us/davinci-pdex-plan-net/ValueSet/EndpointConnectionTypeVS"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Endpoint.contained"
        },
        "managingOrganization" : {
            name: "managingOrganization",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "Endpoint.managingOrganization"
        },
        "payloadType" : {
            name: "payloadType",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: true,
            path: "Endpoint.payloadType",
            valueSet: "http://hl7.org/fhir/us/davinci-pdex-plan-net/ValueSet/EndpointPayloadTypeVS"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Endpoint.meta"
        },
        "contact" : {
            name: "contact",
            dataType: PlannetEndpointContact,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Endpoint.contact"
        },
        "name" : {
            name: "name",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Endpoint.name"
        },
        "header" : {
            name: "header",
            dataType: string,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Endpoint.header"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Endpoint.implicitRules"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Endpoint.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Endpoint.text"
        },
        "payloadMimeType" : {
            name: "payloadMimeType",
            dataType: r4:code,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Endpoint.payloadMimeType",
            valueSet: "http://hl7.org/fhir/ValueSet/mimetypes|4.0.1"
        },
        "status" : {
            name: "status",
            dataType: PlannetEndpointStatus,
            min: 1,
            max: 1,
            isArray: false,
            path: "Endpoint.status",
            valueSet: "http://hl7.org/fhir/ValueSet/endpoint-status|4.0.1"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type PlannetEndpoint record {|
    *r4:DomainResource;

    RESOURCE_NAME_PLANNETENDPOINT resourceType = RESOURCE_NAME_PLANNETENDPOINT;

    r4:Identifier[] identifier?;
    r4:Extension[] extension?;
    r4:Period period?;
    r4:urlType address;
    r4:Extension[] modifierExtension?;
    r4:code language?;
    r4:Coding connectionType;
    r4:Resource[] contained?;
    r4:Reference managingOrganization?;
    @constraint:Array {
        minLength: {
            value: 1,
            message: "Validation failed for $.Endpoint.payloadType constraint. This field must be an array containing at least one item."
        },
        maxLength: {
            value: 1,
            message: "Validation failed for $.Endpoint.payloadType constraint. This field must be an array containing at most one item."
        }
    }
    r4:CodeableConcept[] payloadType;
    r4:Meta meta?;
    PlannetEndpointContact[] contact?;
    string name?;
    string[] header?;
    r4:uri implicitRules?;
    string id?;
    r4:Narrative text?;
    r4:code[] payloadMimeType?;
    PlannetEndpointStatus status;
    r4:Element ...;
|};

# FHIR PlannetEndpointContact datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + period - Time period when the contact point was/is in use.
# + system - Telecommunications form for contact point - what communications system is required to make use of the contact.
# + use - Identifies the purpose for the contact point.
# + rank - Specifies a preferred order in which to use a set of contacts. ContactPoints with lower rank values are more preferred than those with higher rank values.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + value - The actual contact point details, in a form that is meaningful to the designated communication system (i.e. phone number or email address).
@r4:DataTypeDefinition {
    name: "PlannetEndpointContact",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Endpoint.contact.extension"
        },
        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period when the contact point was/is in use.",
            path: "Endpoint.contact.period"
        },
        "system": {
            name: "system",
            dataType: PlannetEndpointContactSystem,
            min: 0,
            max: 1,
            isArray: false,
            description: "Telecommunications form for contact point - what communications system is required to make use of the contact.",
            path: "Endpoint.contact.system"
        },
        "use": {
            name: "use",
            dataType: PlannetEndpointContactUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "Identifies the purpose for the contact point.",
            path: "Endpoint.contact.use"
        },
        "rank": {
            name: "rank",
            dataType: r4:positiveInt,
            min: 0,
            max: 1,
            isArray: false,
            description: "Specifies a preferred order in which to use a set of contacts. ContactPoints with lower rank values are more preferred than those with higher rank values.",
            path: "Endpoint.contact.rank"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Endpoint.contact.id"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "The actual contact point details, in a form that is meaningful to the designated communication system (i.e. phone number or email address).",
            path: "Endpoint.contact.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type PlannetEndpointContact record {|
    *r4:ContactPoint;

    r4:Extension[] extension?;
    r4:Period period?;
    PlannetEndpointContactSystem system?;
    PlannetEndpointContactUse use?;
    r4:positiveInt rank?;
    string id?;
    string value?;
|};

# PlannetEndpointStatus enum
public enum PlannetEndpointStatus {
   CODE_STATUS_TEST = "test",
   CODE_STATUS_ACTIVE = "active",
   CODE_STATUS_ERROR = "error",
   CODE_STATUS_ENTERED_IN_ERROR = "entered-in-error",
   CODE_STATUS_SUSPENDED = "suspended",
   CODE_STATUS_OFF = "off"
}

# PlannetEndpointContactSystem enum
public enum PlannetEndpointContactSystem {
   CODE_SYSTEM_OTHER = "other",
   CODE_SYSTEM_PAGER = "pager",
   CODE_SYSTEM_PHONE = "phone",
   CODE_SYSTEM_SMS = "sms",
   CODE_SYSTEM_FAX = "fax",
   CODE_SYSTEM_EMAIL = "email",
   CODE_SYSTEM_URL = "url"
}

# PlannetEndpointContactUse enum
public enum PlannetEndpointContactUse {
   CODE_USE_TEMP = "temp",
   CODE_USE_WORK = "work",
   CODE_USE_OLD = "old",
   CODE_USE_MOBILE = "mobile",
   CODE_USE_HOME = "home"
}

