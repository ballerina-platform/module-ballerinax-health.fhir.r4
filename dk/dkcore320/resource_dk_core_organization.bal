// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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

public const string PROFILE_BASE_DKCOREORGANIZATION = "http://hl7.dk/fhir/core/StructureDefinition/dk-core-organization";
public const RESOURCE_NAME_DKCOREORGANIZATION = "Organization";

# FHIR DkCoreOrganization resource record.
#
# + resourceType - The type of the resource describes
# + partOf - The organization of which this organization forms a part.
# + identifier - Identifier for the organization that is used to identify the organization across multiple disparate systems.
# * identifier Slicings
# 1) DkCoreOrganizationIdentifierKOMBIT_ORG_ID: [DA] Organisationsenheds-id som specificeret af FK-ORG
# - min = 0
# - max = 1
#
# 2) DkCoreOrganizationIdentifierYdernummer: [DA] Ydernummer
# - min = 0
# - max = 1
#
# 3) DkCoreOrganizationIdentifierProducentID: [DA] Producent Id
# - min = 0
# - max = 1
#
# 4) DkCoreOrganizationIdentifierCVR_ID: VAT identification number, [DA] CVR-nummer
# - min = 0
# - max = 1
#
# 5) DkCoreOrganizationIdentifierEAN_ID: GLN identifier, [DA] EAN-nummer
# - min = 0
# - max = 1
#
# 6) DkCoreOrganizationIdentifierKommunekode: [DA] Kommunekode
# - min = 0
# - max = 1
#
# 7) DkCoreOrganizationIdentifierRegionskode: [DA] Regionskode
# - min = 0
# - max = 1
#
# 8) DkCoreOrganizationIdentifierSOR_ID: [DA] SOR-id
# - min = 0
# - max = 1
#
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + address - An address for the organization.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + active - Whether the organization's record is still in active use.
# + language - The base language in which the resource is written.
# + 'type - The kind(s) of organization that this is.
# + endpoint - Technical endpoints providing access to services operated for the organization.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + contact - Contact for the organization for a certain purpose.
# + name - A name associated with the organization.
# + alias - A list of alternate names that the organization is known as, or was known as in the past.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + telecom - A contact detail for the organization.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
@r4:ResourceDefinition {
    resourceType: "Organization",
    baseType: r4:DomainResource,
    profile: "http://hl7.dk/fhir/core/StructureDefinition/dk-core-organization",
    elements: {
        "partOf": {
            name: "partOf",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "Organization.partOf"
        },
        "identifier": {
            name: "identifier",
            dataType: r4:Identifier,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.identifier"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.extension"
        },
        "address": {
            name: "address",
            dataType: r4:Address,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.address"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.modifierExtension"
        },
        "active": {
            name: "active",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            path: "Organization.active"
        },
        "language": {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Organization.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.type",
            valueSet: "http://hl7.dk/fhir/core/ValueSet/sor-organization-type"
        },
        "endpoint": {
            name: "endpoint",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.endpoint"
        },
        "contained": {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.contained"
        },
        "meta": {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Organization.meta"
        },
        "contact": {
            name: "contact",
            dataType: DkCoreOrganizationContact,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.contact"
        },
        "name": {
            name: "name",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Organization.name"
        },
        "alias": {
            name: "alias",
            dataType: string,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.alias"
        },
        "implicitRules": {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Organization.implicitRules"
        },
        "telecom": {
            name: "telecom",
            dataType: r4:ContactPoint,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Organization.telecom"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Organization.id"
        },
        "text": {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Organization.text"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type DkCoreOrganization record {|
    *r4:DomainResource;

    RESOURCE_NAME_DKCOREORGANIZATION resourceType = RESOURCE_NAME_DKCOREORGANIZATION;

    r4:Reference partOf?;
    @constraint:Array {
        minLength: {
            value: 1,
            message: "Validation failed for $.Organization.identifier constraint. This field must be an array containing at least one item."
        },
        maxLength: {
            value: 1,
            message: "Validation failed for $.Organization.identifier constraint. This field must be an array containing at most one item."
        }
    }
    r4:Identifier[] identifier;
    r4:Extension[] extension?;
    r4:Address[] address?;
    r4:Extension[] modifierExtension?;
    boolean active?;
    r4:code language?;
    r4:CodeableConcept[] 'type?;
    r4:Reference[] endpoint?;
    r4:Resource[] contained?;
    r4:Meta meta?;
    DkCoreOrganizationContact[] contact?;
    string name?;
    string[] alias?;
    r4:uri implicitRules?;
    r4:ContactPoint[] telecom?;
    string id?;
    r4:Narrative text?;
    r4:Element...;
|};

# FHIR DkCoreOrganizationIdentifierProducentID datatype record.
#
@r4:DataTypeDefinition {
    name: "DkCoreOrganizationIdentifierProducentID",
    baseType: (),
    elements: {
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreOrganizationIdentifierProducentID record {|
    *r4:Identifier;

|};

# FHIR DkCoreOrganizationIdentifierYdernummer datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + period - Time period during which identifier is/was valid for use.
# + system - Establishes the namespace for the value - that is, a URL that describes a set values that are unique.
# + use - The purpose of this identifier.
# + assigner - Organization that issued/manages the identifier.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.
# + value - The portion of the identifier typically relevant to the user and which is unique within the context of the system.
@r4:DataTypeDefinition {
    name: "DkCoreOrganizationIdentifierYdernummer",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Organization.identifier.extension"
        },
        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Organization.identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Organization.identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreOrganizationIdentifierUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Organization.identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Organization.identifier.assigner"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Organization.identifier.id"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Organization.identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Organization.identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreOrganizationIdentifierYdernummer record {|
    *r4:Identifier;

    r4:Extension[] extension?;
    r4:Period period?;
    r4:uri system = "urn:oid:1.2.208.176.1.4";
    DkCoreOrganizationIdentifierUse use?;
    r4:Reference assigner?;
    string id?;
    r4:CodeableConcept 'type?;
    string value;
|};

# FHIR DkCoreOrganizationIdentifierRegionskode datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + period - Time period during which identifier is/was valid for use.
# + system - Establishes the namespace for the value - that is, a URL that describes a set values that are unique.
# + use - The purpose of this identifier.
# + assigner - Organization that issued/manages the identifier.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.
# + value - The portion of the identifier typically relevant to the user and which is unique within the context of the system.
@r4:DataTypeDefinition {
    name: "DkCoreOrganizationIdentifierRegionskode",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Organization.identifier.extension"
        },
        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Organization.identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Organization.identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreOrganizationIdentifierUseTwo,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Organization.identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Organization.identifier.assigner"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Organization.identifier.id"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Organization.identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Organization.identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreOrganizationIdentifierRegionskode record {|
    *r4:Identifier;

    r4:Extension[] extension?;
    r4:Period period?;
    r4:uri system = "http://hl7.dk/fhir/core/CodeSystem/dk-core-regional-subdivision-codes";
    DkCoreOrganizationIdentifierUseTwo use?;
    r4:Reference assigner?;
    string id?;
    r4:CodeableConcept 'type?;
    string value;
|};

# DkCoreOrganizationIdentifierUse enum
public enum DkCoreOrganizationIdentifierUse {
    CODE_USE_SECONDARY = "secondary",
    CODE_USE_TEMP = "temp",
    CODE_USE_USUAL = "usual",
    CODE_USE_OLD = "old",
    CODE_USE_OFFICIAL = "official"
}

# FHIR DkCoreOrganizationIdentifierSOR_ID datatype record.
#
@r4:DataTypeDefinition {
    name: "DkCoreOrganizationIdentifierSOR_ID",
    baseType: (),
    elements: {
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreOrganizationIdentifierSOR_ID record {|
    *r4:Identifier;

|};

# FHIR DkCoreOrganizationContact datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + address - Visiting or postal addresses for the contact.
# + purpose - Indicates a purpose for which the contact can be reached.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + name - A name associated with the contact.
# + telecom - A contact detail (e.g. a telephone number or an email address) by which the party may be contacted.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
@r4:DataTypeDefinition {
    name: "DkCoreOrganizationContact",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Organization.contact.extension"
        },
        "address": {
            name: "address",
            dataType: r4:Address,
            min: 0,
            max: 1,
            isArray: false,
            description: "Visiting or postal addresses for the contact.",
            path: "Organization.contact.address"
        },
        "purpose": {
            name: "purpose",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Indicates a purpose for which the contact can be reached.",
            path: "Organization.contact.purpose"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Organization.contact.modifierExtension"
        },
        "name": {
            name: "name",
            dataType: r4:HumanName,
            min: 0,
            max: 1,
            isArray: false,
            description: "A name associated with the contact.",
            path: "Organization.contact.name"
        },
        "telecom": {
            name: "telecom",
            dataType: r4:ContactPoint,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "A contact detail (e.g. a telephone number or an email address) by which the party may be contacted.",
            path: "Organization.contact.telecom"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Organization.contact.id"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreOrganizationContact record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    r4:Address address?;
    r4:CodeableConcept purpose?;
    r4:Extension[] modifierExtension?;
    r4:HumanName name?;
    r4:ContactPoint[] telecom?;
    string id?;
|};

# DkCoreOrganizationIdentifierUseTwo enum
public enum DkCoreOrganizationIdentifierUseTwo {
    CODE_USE_SECONDARY = "secondary",
    CODE_USE_TEMP = "temp",
    CODE_USE_USUAL = "usual",
    CODE_USE_OLD = "old",
    CODE_USE_OFFICIAL = "official"
}

# FHIR DkCoreOrganizationIdentifierKOMBIT_ORG_ID datatype record.
#
@r4:DataTypeDefinition {
    name: "DkCoreOrganizationIdentifierKOMBIT_ORG_ID",
    baseType: (),
    elements: {
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreOrganizationIdentifierKOMBIT_ORG_ID record {|
    *r4:Identifier;

|};

# FHIR DkCoreOrganizationIdentifierKommunekode datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + period - Time period during which identifier is/was valid for use.
# + system - Establishes the namespace for the value - that is, a URL that describes a set values that are unique.
# + use - The purpose of this identifier.
# + assigner - Organization that issued/manages the identifier.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.
# + value - The portion of the identifier typically relevant to the user and which is unique within the context of the system.
@r4:DataTypeDefinition {
    name: "DkCoreOrganizationIdentifierKommunekode",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Organization.identifier.extension"
        },
        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Organization.identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Organization.identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreOrganizationIdentifierUseOne,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Organization.identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Organization.identifier.assigner"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Organization.identifier.id"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Organization.identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Organization.identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreOrganizationIdentifierKommunekode record {|
    *r4:Identifier;

    r4:Extension[] extension?;
    r4:Period period?;
    r4:uri system = "http://hl7.dk/fhir/core/CodeSystem/dk-core-municipality-codes";
    DkCoreOrganizationIdentifierUseOne use?;
    r4:Reference assigner?;
    string id?;
    r4:CodeableConcept 'type?;
    string value;
|};

# FHIR DkCoreOrganizationIdentifierCVR_ID datatype record.
#
@r4:DataTypeDefinition {
    name: "DkCoreOrganizationIdentifierCVR_ID",
    baseType: (),
    elements: {
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreOrganizationIdentifierCVR_ID record {|
    *r4:Identifier;

|};

# FHIR DkCoreOrganizationIdentifierEAN_ID datatype record.
#
@r4:DataTypeDefinition {
    name: "DkCoreOrganizationIdentifierEAN_ID",
    baseType: (),
    elements: {
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreOrganizationIdentifierEAN_ID record {|
    *r4:Identifier;

|};

# DkCoreOrganizationIdentifierUseOne enum
public enum DkCoreOrganizationIdentifierUseOne {
    CODE_USE_SECONDARY = "secondary",
    CODE_USE_TEMP = "temp",
    CODE_USE_USUAL = "usual",
    CODE_USE_OLD = "old",
    CODE_USE_OFFICIAL = "official"
}

