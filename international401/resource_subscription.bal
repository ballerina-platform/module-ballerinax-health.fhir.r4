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

public const string PROFILE_BASE_SUBSCRIPTION = "http://hl7.org/fhir/StructureDefinition/Subscription";
public const RESOURCE_NAME_SUBSCRIPTION = "Subscription";

# FHIR Subscription resource record.
#
# + resourceType - The type of the resource describes
# + reason - A description of why this subscription is defined.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + criteria - The rules that the server should use to determine when to generate notifications for this subscription.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + channel - Details where to send notifications when resources are received that meet the criteria.
# + language - The base language in which the resource is written.
# + 'error - A record of the last error that occurred when the server processed a notification.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + contact - Contact details for a human to contact about the subscription. The primary use of this for system administrator troubleshooting.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + end - The time for the server to turn the subscription off.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + status - The status of the subscription, which marks the server state for managing the subscription.
@r4:ResourceDefinition {
    resourceType: "Subscription",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/Subscription",
    elements: {
        "reason" : {
            name: "reason",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            path: "Subscription.reason"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Subscription.extension"
        },
        "criteria" : {
            name: "criteria",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            path: "Subscription.criteria"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Subscription.modifierExtension"
        },
        "channel" : {
            name: "channel",
            dataType: SubscriptionChannel,
            min: 1,
            max: 1,
            isArray: false,
            path: "Subscription.channel"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Subscription.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "error" : {
            name: "error",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Subscription.error"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Subscription.contained"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Subscription.meta"
        },
        "contact" : {
            name: "contact",
            dataType: r4:ContactPoint,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Subscription.contact"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Subscription.implicitRules"
        },
        "end" : {
            name: "end",
            dataType: r4:instant,
            min: 0,
            max: 1,
            isArray: false,
            path: "Subscription.end"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Subscription.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Subscription.text"
        },
        "status" : {
            name: "status",
            dataType: SubscriptionStatus,
            min: 1,
            max: 1,
            isArray: false,
            path: "Subscription.status",
            valueSet: "http://hl7.org/fhir/ValueSet/subscription-status|4.0.1"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type Subscription record {|
    *r4:DomainResource;

    RESOURCE_NAME_SUBSCRIPTION resourceType = RESOURCE_NAME_SUBSCRIPTION;

    string reason;
    r4:Extension[] extension?;
    string criteria;
    r4:Extension[] modifierExtension?;
    SubscriptionChannel channel;
    r4:code language?;
    string 'error?;
    r4:Resource[] contained?;
    r4:Meta meta?;
    r4:ContactPoint[] contact?;
    r4:uri implicitRules?;
    r4:instant end?;
    string id?;
    r4:Narrative text?;
    SubscriptionStatus status;
    r4:Element ...;
|};

# SubscriptionChannelType enum
public enum SubscriptionChannelType {
   CODE_TYPE_REST_HOOK = "rest-hook",
   CODE_TYPE_WEBSOCKET = "websocket",
   CODE_TYPE_SMS = "sms",
   CODE_TYPE_MESSAGE = "message",
   CODE_TYPE_EMAIL = "email"
}

# SubscriptionStatus enum
public enum SubscriptionStatus {
   CODE_STATUS_REQUESTED = "requested",
   CODE_STATUS_ACTIVE = "active",
   CODE_STATUS_ERROR = "error",
   CODE_STATUS_OFF = "off"
}

# FHIR SubscriptionChannel datatype record.
#
# + endpoint - The url that describes the actual end-point to send messages to.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + payload - The mime type to send the payload in - either application/fhir+xml, or application/fhir+json. If the payload is not present, then there is no payload in the notification, just a notification. The mime type 'text/plain' may also be used for Email and SMS subscriptions.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + header - Additional headers / information to send as part of the notification.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - The type of channel to send notifications on.
@r4:DataTypeDefinition {
    name: "SubscriptionChannel",
    baseType: (),
    elements: {
        "endpoint": {
            name: "endpoint",
            dataType: r4:urlType,
            min: 0,
            max: 1,
            isArray: false,
            description: "The url that describes the actual end-point to send messages to.",
            path: "Subscription.channel.endpoint"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Subscription.channel.extension"
        },
        "payload": {
            name: "payload",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            description: "The mime type to send the payload in - either application/fhir+xml, or application/fhir+json. If the payload is not present, then there is no payload in the notification, just a notification. The mime type 'text/plain' may also be used for Email and SMS subscriptions.",
            path: "Subscription.channel.payload"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Subscription.channel.modifierExtension"
        },
        "header": {
            name: "header",
            dataType: string,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Additional headers / information to send as part of the notification.",
            path: "Subscription.channel.header"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Subscription.channel.id"
        },
        "type": {
            name: "type",
            dataType: SubscriptionChannelType,
            min: 1,
            max: 1,
            isArray: false,
            description: "The type of channel to send notifications on.",
            path: "Subscription.channel.type"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type SubscriptionChannel record {|
    *r4:BackboneElement;

    r4:urlType endpoint?;
    r4:Extension[] extension?;
    r4:code payload?;
    r4:Extension[] modifierExtension?;
    string[] header?;
    string id?;
    SubscriptionChannelType 'type;
|};

