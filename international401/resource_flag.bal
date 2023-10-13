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

public const string PROFILE_BASE_FLAG = "http://hl7.org/fhir/StructureDefinition/Flag";
public const RESOURCE_NAME_FLAG = "Flag";

# FHIR Flag resource record.
#
# + resourceType - The type of the resource describes
# + identifier - Business identifiers assigned to this flag by the performer or other systems which remain constant as the resource is updated and propagates from server to server.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + period - The period of time from the activation of the flag to inactivation of the flag. If the flag is active, the end of the period should be unspecified.
# + code - The coded value or textual component of the flag to display to the user.
# + author - The person, organization or device that created the flag.
# + subject - The patient, location, group, organization, or practitioner etc. this is about record this flag is associated with.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + language - The base language in which the resource is written.
# + encounter - This alert is only relevant during the encounter.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + category - Allows a flag to be divided into different categories like clinical, administrative etc. Intended to be used as a means of filtering which flags are displayed to particular user or in a given context.
# + status - Supports basic workflow.
@r4:ResourceDefinition {
    resourceType: "Flag",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/Flag",
    elements: {
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Flag.identifier"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Flag.extension"
        },
        "period" : {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "Flag.period"
        },
        "code" : {
            name: "code",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            path: "Flag.code",
            valueSet: "http://hl7.org/fhir/ValueSet/flag-code"
        },
        "author" : {
            name: "author",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "Flag.author"
        },
        "subject" : {
            name: "subject",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "Flag.subject"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Flag.modifierExtension"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Flag.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "encounter" : {
            name: "encounter",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "Flag.encounter"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Flag.contained"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Flag.meta"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Flag.implicitRules"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Flag.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Flag.text"
        },
        "category" : {
            name: "category",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Flag.category",
            valueSet: "http://hl7.org/fhir/ValueSet/flag-category"
        },
        "status" : {
            name: "status",
            dataType: FlagStatus,
            min: 1,
            max: 1,
            isArray: false,
            path: "Flag.status",
            valueSet: "http://hl7.org/fhir/ValueSet/flag-status|4.0.1"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type Flag record {|
    *r4:DomainResource;

    RESOURCE_NAME_FLAG resourceType = RESOURCE_NAME_FLAG;

    r4:Identifier[] identifier?;
    r4:Extension[] extension?;
    r4:Period period?;
    r4:CodeableConcept code;
    r4:Reference author?;
    r4:Reference subject;
    r4:Extension[] modifierExtension?;
    r4:code language?;
    r4:Reference encounter?;
    r4:Resource[] contained?;
    r4:Meta meta?;
    r4:uri implicitRules?;
    string id?;
    r4:Narrative text?;
    r4:CodeableConcept[] category?;
    FlagStatus status;
    r4:Element ...;
|};

# FlagStatus enum
public enum FlagStatus {
   CODE_STATUS_INACTIVE = "inactive",
   CODE_STATUS_ACTIVE = "active",
   CODE_STATUS_ENTERED_IN_ERROR = "entered-in-error"
}

