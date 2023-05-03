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


public const string PROFILE_BASE_CHARGEITEMDEFINITION = "http://hl7.org/fhir/StructureDefinition/ChargeItemDefinition";
public const RESOURCE_NAME_CHARGEITEMDEFINITION = "ChargeItemDefinition";

# FHIR ChargeItemDefinition resource record.
#
# + resourceType - The type of the resource describes
# + date - The date (and optionally time) when the charge item definition was published. The date must change when the business version changes and it must change if the status code changes. In addition, it should change when the substantive content of the charge item definition changes.
# + propertyGroup - Group of properties which are applicable under the same conditions. If no applicability rules are established for the group, then all properties always apply.
# + partOf - A larger definition of which this particular definition is a component or step.
# + copyright - A copyright statement relating to the charge item definition and/or its contents. Copyright statements are generally legal restrictions on the use and publishing of the charge item definition.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + approvalDate - The date on which the resource content was approved by the publisher. Approval happens once when the content is officially approved for usage.
# + code - The defined billing details in this resource pertain to the given billing code.
# + instance - The defined billing details in this resource pertain to the given product instance(s).
# + jurisdiction - A legal or geographic region in which the charge item definition is intended to be used.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + description - A free text natural language description of the charge item definition from a consumer's perspective.
# + experimental - A Boolean value to indicate that this charge item definition is authored for testing purposes (or education/evaluation/marketing) and is not intended to be used for genuine usage.
# + language - The base language in which the resource is written.
# + title - A short, descriptive, user-friendly title for the charge item definition.
# + contact - Contact details to assist a user in finding and communicating with the publisher.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + derivedFromUri - The URL pointing to an externally-defined charge item definition that is adhered to in whole or in part by this definition.
# + identifier - A formal identifier that is used to identify this charge item definition when it is represented in other formats, or referenced in a specification, model, design or an instance.
# + effectivePeriod - The period during which the charge item definition content was or is planned to be in active use.
# + replaces - As new versions of a protocol or guideline are defined, allows identification of what versions are replaced by a new instance.
# + 'version - The identifier that is used to identify this version of the charge item definition when it is referenced in a specification, model, design or instance. This is an arbitrary value managed by the charge item definition author and is not expected to be globally unique. For example, it might be a timestamp (e.g. yyyymmdd) if a managed version is not available. There is also no expectation that versions can be placed in a lexicographical sequence. To provide a version consistent with the Decision Support Service specification, use the format Major.Minor.Revision (e.g. 1.0.0). For more information on versioning knowledge assets, refer to the Decision Support Service specification. Note that a version is required for non-experimental active assets.
# + url - An absolute URI that is used to identify this charge item definition when it is referenced in a specification, model, design or an instance; also called its canonical identifier. This SHOULD be globally unique and SHOULD be a literal address at which at which an authoritative instance of this charge item definition is (or will be) published. This URL can be the target of a canonical reference. It SHALL remain the same when the charge item definition is stored on different servers.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + lastReviewDate - The date on which the resource content was last reviewed. Review happens periodically after approval but does not change the original approval date.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + publisher - The name of the organization or individual that published the charge item definition.
# + applicability - Expressions that describe applicability criteria for the billing code.
# + useContext - The content was developed with a focus and intent of supporting the contexts that are listed. These contexts may be general categories (gender, age, ...) or may be references to specific programs (insurance plans, studies, ...) and may be used to assist with indexing and searching for appropriate charge item definition instances.
# + status - The current state of the ChargeItemDefinition.
@ResourceDefinition {
    resourceType: "ChargeItemDefinition",
    baseType: DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/ChargeItemDefinition",
    elements: {
        "date" : {
            name: "date",
            dataType: dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.date"
        },
        "propertyGroup" : {
            name: "propertyGroup",
            dataType: ChargeItemDefinitionPropertyGroup,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.propertyGroup"
        },
        "partOf" : {
            name: "partOf",
            dataType: canonical,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.partOf"
        },
        "copyright" : {
            name: "copyright",
            dataType: markdown,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.copyright"
        },
        "extension" : {
            name: "extension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.extension"
        },
        "approvalDate" : {
            name: "approvalDate",
            dataType: date,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.approvalDate"
        },
        "code" : {
            name: "code",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.code",
            valueSet: "http://hl7.org/fhir/ValueSet/chargeitem-billingcodes"
        },
        "instance" : {
            name: "instance",
            dataType: Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.instance"
        },
        "jurisdiction" : {
            name: "jurisdiction",
            dataType: CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.jurisdiction",
            valueSet: "http://hl7.org/fhir/ValueSet/jurisdiction"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.modifierExtension"
        },
        "description" : {
            name: "description",
            dataType: markdown,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.description"
        },
        "experimental" : {
            name: "experimental",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.experimental"
        },
        "language" : {
            name: "language",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "title" : {
            name: "title",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.title"
        },
        "contact" : {
            name: "contact",
            dataType: ContactDetail,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.contact"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.id"
        },
        "text" : {
            name: "text",
            dataType: Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.text"
        },
        "derivedFromUri" : {
            name: "derivedFromUri",
            dataType: uri,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.derivedFromUri"
        },
        "identifier" : {
            name: "identifier",
            dataType: Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.identifier"
        },
        "effectivePeriod" : {
            name: "effectivePeriod",
            dataType: Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.effectivePeriod"
        },
        "replaces" : {
            name: "replaces",
            dataType: canonical,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.replaces"
        },
        "version" : {
            name: "version",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.version"
        },
        "url" : {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.url"
        },
        "contained" : {
            name: "contained",
            dataType: Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.contained"
        },
        "lastReviewDate" : {
            name: "lastReviewDate",
            dataType: date,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.lastReviewDate"
        },
        "meta" : {
            name: "meta",
            dataType: Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.meta"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.implicitRules"
        },
        "publisher" : {
            name: "publisher",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.publisher"
        },
        "applicability" : {
            name: "applicability",
            dataType: ChargeItemDefinitionApplicability,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.applicability"
        },
        "useContext" : {
            name: "useContext",
            dataType: UsageContext,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "ChargeItemDefinition.useContext"
        },
        "status" : {
            name: "status",
            dataType: ChargeItemDefinitionStatus,
            min: 1,
            max: 1,
            isArray: false,
            path: "ChargeItemDefinition.status",
            valueSet: "http://hl7.org/fhir/ValueSet/publication-status|4.0.1"
        }
    },
    serializers: {
        'xml: fhirResourceXMLSerializer,
        'json: fhirResourceJsonSerializer
    }
}
public type ChargeItemDefinition record {|
    *DomainResource;

    RESOURCE_NAME_CHARGEITEMDEFINITION resourceType = RESOURCE_NAME_CHARGEITEMDEFINITION;

    BaseChargeItemDefinitionMeta meta = {
        profile : [PROFILE_BASE_CHARGEITEMDEFINITION]
    };
    dateTime date?;
    ChargeItemDefinitionPropertyGroup[] propertyGroup?;
    canonical[] partOf?;
    markdown copyright?;
    Extension[] extension?;
    date approvalDate?;
    CodeableConcept code?;
    Reference[] instance?;
    CodeableConcept[] jurisdiction?;
    Extension[] modifierExtension?;
    markdown description?;
    boolean experimental?;
    code language?;
    string title?;
    ContactDetail[] contact?;
    string id?;
    Narrative text?;
    uri[] derivedFromUri?;
    Identifier[] identifier?;
    Period effectivePeriod?;
    canonical[] replaces?;
    string 'version?;
    uri url;
    Resource[] contained?;
    date lastReviewDate?;
    uri implicitRules?;
    string publisher?;
    ChargeItemDefinitionApplicability[] applicability?;
    UsageContext[] useContext?;
    ChargeItemDefinitionStatus status;
|};

@DataTypeDefinition {
    name: "BaseChargeItemDefinitionMeta",
    baseType: Meta,
    elements: {},
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type BaseChargeItemDefinitionMeta record {|
    *Meta;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    id versionId?;
    instant lastUpdated?;
    uri 'source?;
    canonical[] profile = ["http://hl7.org/fhir/StructureDefinition/ChargeItemDefinition"];
    Coding[] security?;
    Coding[] tag?;
|};

# FHIR ChargeItemDefinitionPropertyGroupPriceComponent datatype record.
#
# + amount - The amount calculated for this component.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + code - A code that identifies the component. Codes may be used to differentiate between kinds of taxes, surcharges, discounts etc.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + factor - The factor that has been applied on the base price for calculating this component.
# + 'type - This code identifies the type of the component.
@DataTypeDefinition {
    name: "ChargeItemDefinitionPropertyGroupPriceComponent",
    baseType: (),
    elements: {
        "amount": {
            name: "amount",
            dataType: Money,
            min: 0,
            max: 1,
            isArray: false,
            description: "The amount calculated for this component.",
            path: "ChargeItemDefinition.propertyGroup.priceComponent.amount"
        },
        "extension": {
            name: "extension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "ChargeItemDefinition.propertyGroup.priceComponent.extension"
        },
        "code": {
            name: "code",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A code that identifies the component. Codes may be used to differentiate between kinds of taxes, surcharges, discounts etc.",
            path: "ChargeItemDefinition.propertyGroup.priceComponent.code"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "ChargeItemDefinition.propertyGroup.priceComponent.modifierExtension"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "ChargeItemDefinition.propertyGroup.priceComponent.id"
        },
        "factor": {
            name: "factor",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "The factor that has been applied on the base price for calculating this component.",
            path: "ChargeItemDefinition.propertyGroup.priceComponent.factor"
        },
        "type": {
            name: "type",
            dataType: ChargeItemDefinitionPropertyGroupPriceComponentType,
            min: 1,
            max: 1,
            isArray: false,
            description: "This code identifies the type of the component.",
            path: "ChargeItemDefinition.propertyGroup.priceComponent.type"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ChargeItemDefinitionPropertyGroupPriceComponent record {|
    Money amount?;
    Extension[] extension?;
    CodeableConcept code?;
    Extension[] modifierExtension?;
    string id?;
    decimal factor?;
    ChargeItemDefinitionPropertyGroupPriceComponentType 'type;
|};

# FHIR ChargeItemDefinitionApplicability datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + expression - An expression that returns true or false, indicating whether the condition is satisfied. When using FHIRPath expressions, the %context environment variable must be replaced at runtime with the ChargeItem resource to which this definition is applied.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + description - A brief, natural language description of the condition that effectively communicates the intended semantics.
# + language - The media type of the language for the expression, e.g. 'text/cql' for Clinical Query Language expressions or 'text/fhirpath' for FHIRPath expressions.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
@DataTypeDefinition {
    name: "ChargeItemDefinitionApplicability",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "ChargeItemDefinition.applicability.extension"
        },
        "expression": {
            name: "expression",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "An expression that returns true or false, indicating whether the condition is satisfied. When using FHIRPath expressions, the %context environment variable must be replaced at runtime with the ChargeItem resource to which this definition is applied.",
            path: "ChargeItemDefinition.applicability.expression"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "ChargeItemDefinition.applicability.modifierExtension"
        },
        "description": {
            name: "description",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "A brief, natural language description of the condition that effectively communicates the intended semantics.",
            path: "ChargeItemDefinition.applicability.description"
        },
        "language": {
            name: "language",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "The media type of the language for the expression, e.g. 'text/cql' for Clinical Query Language expressions or 'text/fhirpath' for FHIRPath expressions.",
            path: "ChargeItemDefinition.applicability.language"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "ChargeItemDefinition.applicability.id"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ChargeItemDefinitionApplicability record {|
    Extension[] extension?;
    string expression?;
    Extension[] modifierExtension?;
    string description?;
    string language?;
    string id?;
|};

# ChargeItemDefinitionStatus enum
public enum ChargeItemDefinitionStatus {
   CODE_STATUS_DRAFT = "draft",
   CODE_STATUS_ACTIVE = "active",
   CODE_STATUS_RETIRED = "retired",
   CODE_STATUS_UNKNOWN = "unknown"
}

# FHIR ChargeItemDefinitionPropertyGroup datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + priceComponent - The price for a ChargeItem may be calculated as a base price with surcharges/deductions that apply in certain conditions. A ChargeItemDefinition resource that defines the prices, factors and conditions that apply to a billing code is currently under development. The priceComponent element can be used to offer transparency to the recipient of the Invoice of how the prices have been calculated.
@DataTypeDefinition {
    name: "ChargeItemDefinitionPropertyGroup",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "ChargeItemDefinition.propertyGroup.extension"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "ChargeItemDefinition.propertyGroup.modifierExtension"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "ChargeItemDefinition.propertyGroup.id"
        },
        "priceComponent": {
            name: "priceComponent",
            dataType: ChargeItemDefinitionPropertyGroupPriceComponent,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "The price for a ChargeItem may be calculated as a base price with surcharges/deductions that apply in certain conditions. A ChargeItemDefinition resource that defines the prices, factors and conditions that apply to a billing code is currently under development. The priceComponent element can be used to offer transparency to the recipient of the Invoice of how the prices have been calculated.",
            path: "ChargeItemDefinition.propertyGroup.priceComponent"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ChargeItemDefinitionPropertyGroup record {|
    Extension[] extension?;
    Extension[] modifierExtension?;
    string id?;
    ChargeItemDefinitionPropertyGroupPriceComponent[] priceComponent?;
|};

# ChargeItemDefinitionPropertyGroupPriceComponentType enum
public enum ChargeItemDefinitionPropertyGroupPriceComponentType {
   CODE_TYPE_SURCHARGE = "surcharge",
   CODE_TYPE_DEDUCTION = "deduction",
   CODE_TYPE_DISCOUNT = "discount",
   CODE_TYPE_TAX = "tax",
   CODE_TYPE_INFORMATIONAL = "informational",
   CODE_TYPE_BASE = "base"
}

