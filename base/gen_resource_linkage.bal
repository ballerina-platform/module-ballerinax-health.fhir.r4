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

public const string PROFILE_BASE_LINKAGE = "http://hl7.org/fhir/StructureDefinition/Linkage";
public const RESOURCE_NAME_LINKAGE = "Linkage";

# FHIR Linkage resource record.
#
# + resourceType - The type of the resource describes
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + item - Identifies which record considered as the reference to the same real-world occurrence as well as how the items should be evaluated within the collection of linked items.
# + author - Identifies the user or organization responsible for asserting the linkages as well as the user or organization who establishes the context in which the nature of each linkage is evaluated.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + active - Indicates whether the asserted set of linkages are considered to be 'in effect'.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + language - The base language in which the resource is written.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
@ResourceDefinition {
    resourceType: "Linkage",
    baseType: DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/Linkage",
    elements: {
        "contained" : {
            name: "contained",
            dataType: Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Linkage.contained"
        },
        "extension" : {
            name: "extension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Linkage.extension"
        },
        "item" : {
            name: "item",
            dataType: LinkageItem,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Linkage.item"
        },
        "author" : {
            name: "author",
            dataType: Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "Linkage.author"
        },
        "meta" : {
            name: "meta",
            dataType: Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Linkage.meta"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Linkage.modifierExtension"
        },
        "active" : {
            name: "active",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            path: "Linkage.active"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Linkage.implicitRules"
        },
        "language" : {
            name: "language",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Linkage.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Linkage.id"
        },
        "text" : {
            name: "text",
            dataType: Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Linkage.text"
        }
    },
    serializers: {
        'xml: fhirResourceXMLSerializer,
        'json: fhirResourceJsonSerializer
    }
}
public type Linkage record {|
    *DomainResource;

    RESOURCE_NAME_LINKAGE resourceType = RESOURCE_NAME_LINKAGE;

    BaseLinkageMeta meta = {
        profile : [PROFILE_BASE_LINKAGE]
    };
    Resource[] contained?;
    Extension[] extension?;
    @constraint:Array {
       minLength: 1
    }
    LinkageItem[] item;
    Reference author?;
    Extension[] modifierExtension?;
    boolean active?;
    uri implicitRules?;
    code language?;
    string id?;
    Narrative text?;
|};

@DataTypeDefinition {
    name: "BaseLinkageMeta",
    baseType: Meta,
    elements: {},
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type BaseLinkageMeta record {|
    *Meta;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    id versionId?;
    instant lastUpdated?;
    uri 'source?;
    canonical[] profile = ["http://hl7.org/fhir/StructureDefinition/Linkage"];
    Coding[] security?;
    Coding[] tag?;
|};

# FHIR LinkageItem datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + 'resource - The resource instance being linked as part of the group.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - Distinguishes which item is 'source of truth' (if any) and which items are no longer considered to be current representations.
@DataTypeDefinition {
    name: "LinkageItem",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Linkage.item.extension"
        },
        "resource": {
            name: "resource",
            dataType: Reference,
            min: 1,
            max: 1,
            isArray: false,
            description: "The resource instance being linked as part of the group.",
            path: "Linkage.item.resource"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Linkage.item.modifierExtension"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Linkage.item.id"
        },
        "type": {
            name: "type",
            dataType: LinkageItemType,
            min: 1,
            max: 1,
            isArray: false,
            description: "Distinguishes which item is 'source of truth' (if any) and which items are no longer considered to be current representations.",
            path: "Linkage.item.type"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type LinkageItem record {|
    Extension[] extension?;
    Reference 'resource;
    Extension[] modifierExtension?;
    string id?;
    LinkageItemType 'type;
|};

# LinkageItemType enum
public enum LinkageItemType {
   CODE_TYPE_ALTERNATE = "alternate",
   CODE_TYPE_HISTORICAL = "historical",
   CODE_TYPE_SOURCE = "source"
}

