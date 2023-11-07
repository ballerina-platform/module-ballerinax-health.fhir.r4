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

public const string PROFILE_BASE_COMPARTMENTDEFINITION = "http://hl7.org/fhir/StructureDefinition/CompartmentDefinition";
public const RESOURCE_NAME_COMPARTMENTDEFINITION = "CompartmentDefinition";

# FHIR CompartmentDefinition resource record.
#
# + resourceType - The type of the resource describes
# + date - The date (and optionally time) when the compartment definition was published. The date must change when the business version changes and it must change if the status code changes. In addition, it should change when the substantive content of the compartment definition changes.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + code - Which compartment this definition describes.
# + purpose - Explanation of why this compartment definition is needed and why it has been designed as it has.
# + 'resource - Information about how a resource is related to the compartment.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + description - A free text natural language description of the compartment definition from a consumer's perspective.
# + experimental - A Boolean value to indicate that this compartment definition is authored for testing purposes (or education/evaluation/marketing) and is not intended to be used for genuine usage.
# + language - The base language in which the resource is written.
# + 'version - The identifier that is used to identify this version of the compartment definition when it is referenced in a specification, model, design or instance. This is an arbitrary value managed by the compartment definition author and is not expected to be globally unique. For example, it might be a timestamp (e.g. yyyymmdd) if a managed version is not available. There is also no expectation that versions can be placed in a lexicographical sequence.
# + url - An absolute URI that is used to identify this compartment definition when it is referenced in a specification, model, design or an instance; also called its canonical identifier. This SHOULD be globally unique and SHOULD be a literal address at which at which an authoritative instance of this compartment definition is (or will be) published. This URL can be the target of a canonical reference. It SHALL remain the same when the compartment definition is stored on different servers.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + search - Whether the search syntax is supported,.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + contact - Contact details to assist a user in finding and communicating with the publisher.
# + name - A natural language name identifying the compartment definition. This name should be usable as an identifier for the module by machine processing applications such as code generation.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + publisher - The name of the organization or individual that published the compartment definition.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + useContext - The content was developed with a focus and intent of supporting the contexts that are listed. These contexts may be general categories (gender, age, ...) or may be references to specific programs (insurance plans, studies, ...) and may be used to assist with indexing and searching for appropriate compartment definition instances.
# + status - The status of this compartment definition. Enables tracking the life-cycle of the content.
@r4:ResourceDefinition {
    resourceType: "CompartmentDefinition",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/CompartmentDefinition",
    elements: {
        "date" : {
            name: "date",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.date"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CompartmentDefinition.extension"
        },
        "code" : {
            name: "code",
            dataType: CompartmentDefinitionCode,
            min: 1,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.code",
            valueSet: "http://hl7.org/fhir/ValueSet/compartment-type|4.0.1"
        },
        "purpose" : {
            name: "purpose",
            dataType: r4:markdown,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.purpose"
        },
        "resource" : {
            name: "resource",
            dataType: CompartmentDefinitionResource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CompartmentDefinition.resource"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CompartmentDefinition.modifierExtension"
        },
        "description" : {
            name: "description",
            dataType: r4:markdown,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.description"
        },
        "experimental" : {
            name: "experimental",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.experimental"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "version" : {
            name: "version",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.version"
        },
        "url" : {
            name: "url",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.url"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CompartmentDefinition.contained"
        },
        "search" : {
            name: "search",
            dataType: boolean,
            min: 1,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.search"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.meta"
        },
        "contact" : {
            name: "contact",
            dataType: r4:ContactDetail,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CompartmentDefinition.contact"
        },
        "name" : {
            name: "name",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.name"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.implicitRules"
        },
        "publisher" : {
            name: "publisher",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.publisher"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.text"
        },
        "useContext" : {
            name: "useContext",
            dataType: r4:UsageContext,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "CompartmentDefinition.useContext"
        },
        "status" : {
            name: "status",
            dataType: CompartmentDefinitionStatus,
            min: 1,
            max: 1,
            isArray: false,
            path: "CompartmentDefinition.status",
            valueSet: "http://hl7.org/fhir/ValueSet/publication-status|4.0.1"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type CompartmentDefinition record {|
    *r4:DomainResource;

    RESOURCE_NAME_COMPARTMENTDEFINITION resourceType = RESOURCE_NAME_COMPARTMENTDEFINITION;

    r4:dateTime date?;
    r4:Extension[] extension?;
    CompartmentDefinitionCode code;
    r4:markdown purpose?;
    CompartmentDefinitionResource[] 'resource?;
    r4:Extension[] modifierExtension?;
    r4:markdown description?;
    boolean experimental?;
    r4:code language?;
    string 'version?;
    r4:uri url;
    r4:Resource[] contained?;
    boolean search;
    r4:Meta meta?;
    r4:ContactDetail[] contact?;
    string name;
    r4:uri implicitRules?;
    string publisher?;
    string id?;
    r4:Narrative text?;
    r4:UsageContext[] useContext?;
    CompartmentDefinitionStatus status;
    r4:Element ...;
|};

# FHIR CompartmentDefinitionResource datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + code - The name of a resource supported by the server.
# + param - The name of a search parameter that represents the link to the compartment. More than one may be listed because a resource may be linked to a compartment in more than one way,.
# + documentation - Additional documentation about the resource and compartment.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
@r4:DataTypeDefinition {
    name: "CompartmentDefinitionResource",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "CompartmentDefinition.resource.extension"
        },
        "code": {
            name: "code",
            dataType: r4:code,
            min: 1,
            max: 1,
            isArray: false,
            description: "The name of a resource supported by the server.",
            path: "CompartmentDefinition.resource.code"
        },
        "param": {
            name: "param",
            dataType: string,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "The name of a search parameter that represents the link to the compartment. More than one may be listed because a resource may be linked to a compartment in more than one way,.",
            path: "CompartmentDefinition.resource.param"
        },
        "documentation": {
            name: "documentation",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Additional documentation about the resource and compartment.",
            path: "CompartmentDefinition.resource.documentation"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "CompartmentDefinition.resource.modifierExtension"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "CompartmentDefinition.resource.id"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type CompartmentDefinitionResource record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    r4:code code;
    string[] param?;
    string documentation?;
    r4:Extension[] modifierExtension?;
    string id?;
|};

# CompartmentDefinitionCode enum
public enum CompartmentDefinitionCode {
   CODE_CODE_PRACTITIONER = "Practitioner",
   CODE_CODE_DEVICE = "Device",
   CODE_CODE_PATIENT = "Patient",
   CODE_CODE_ENCOUNTER = "Encounter",
   CODE_CODE_RELATEDPERSON = "RelatedPerson"
}

# CompartmentDefinitionStatus enum
public enum CompartmentDefinitionStatus {
   CODE_STATUS_DRAFT = "draft",
   CODE_STATUS_ACTIVE = "active",
   CODE_STATUS_RETIRED = "retired",
   CODE_STATUS_UNKNOWN = "unknown"
}

