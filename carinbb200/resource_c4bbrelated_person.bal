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

public const string PROFILE_BASE_C4BBRELATEDPERSON = "http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-RelatedPerson";
public const RESOURCE_NAME_C4BBRELATEDPERSON = "RelatedPerson";

# FHIR C4BBRelatedPerson resource record.
#
# + resourceType - The type of the resource describes
# + identifier - Identifier for a person within a particular scope.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + period - The period of time during which this relationship is or was active. If there are no dates defined, then the interval is unknown.
# + address - Address where the related person can be contacted or visited.
# + gender - Administrative Gender - the gender that the person is considered to have for administration and record keeping purposes.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + active - Whether this related person record is in active use.
# + photo - Image of the person.
# + language - The base language in which the resource is written.
# + birthDate - The date on which the related person was born.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + patient - The patient this person is related to.
# + name - A name associated with the person.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + telecom - A contact detail for the person, e.g. a telephone number or an email address.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + communication - A language which may be used to communicate with about the patient's health.
# + relationship - The nature of the relationship between a patient and the related person.
@r4:ResourceDefinition {
    resourceType: "RelatedPerson",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-RelatedPerson",
    elements: {
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.identifier"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.extension"
        },
        "period" : {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "RelatedPerson.period"
        },
        "address" : {
            name: "address",
            dataType: r4:Address,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.address"
        },
        "gender" : {
            name: "gender",
            dataType: C4BBRelatedPersonGender,
            min: 0,
            max: 1,
            isArray: false,
            path: "RelatedPerson.gender",
            valueSet: "http://hl7.org/fhir/ValueSet/administrative-gender|4.0.1"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.modifierExtension"
        },
        "active" : {
            name: "active",
            dataType: boolean,
            min: 1,
            max: 1,
            isArray: false,
            path: "RelatedPerson.active"
        },
        "photo" : {
            name: "photo",
            dataType: r4:Attachment,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.photo"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "RelatedPerson.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "birthDate" : {
            name: "birthDate",
            dataType: r4:date,
            min: 0,
            max: 1,
            isArray: false,
            path: "RelatedPerson.birthDate"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.contained"
        },
        "meta" : {
            name: "meta",
            dataType: C4BBRelatedPersonMeta,
            min: 1,
            max: 1,
            isArray: false,
            path: "RelatedPerson.meta"
        },
        "patient" : {
            name: "patient",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "RelatedPerson.patient"
        },
        "name" : {
            name: "name",
            dataType: r4:HumanName,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.name"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "RelatedPerson.implicitRules"
        },
        "telecom" : {
            name: "telecom",
            dataType: r4:ContactPoint,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.telecom"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "RelatedPerson.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "RelatedPerson.text"
        },
        "communication" : {
            name: "communication",
            dataType: C4BBRelatedPersonCommunication,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.communication"
        },
        "relationship" : {
            name: "relationship",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "RelatedPerson.relationship",
            valueSet: "http://hl7.org/fhir/ValueSet/relatedperson-relationshiptype"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type C4BBRelatedPerson record {|
    *r4:DomainResource;

    RESOURCE_NAME_C4BBRELATEDPERSON resourceType = RESOURCE_NAME_C4BBRELATEDPERSON;

    r4:Identifier[] identifier?;
    r4:Extension[] extension?;
    r4:Period period?;
    r4:Address[] address?;
    C4BBRelatedPersonGender gender?;
    r4:Extension[] modifierExtension?;
    boolean active;
    r4:Attachment[] photo?;
    r4:code language?;
    r4:date birthDate?;
    r4:Resource[] contained?;
    C4BBRelatedPersonMeta meta;
    r4:Reference patient;
    r4:HumanName[] name?;
    r4:uri implicitRules?;
    r4:ContactPoint[] telecom?;
    string id?;
    r4:Narrative text?;
    C4BBRelatedPersonCommunication[] communication?;
    r4:CodeableConcept[] relationship?;
    r4:Element ...;
|};

# C4BBRelatedPersonGender enum
public enum C4BBRelatedPersonGender {
   CODE_GENDER_OTHER = "other",
   CODE_GENDER_FEMALE = "female",
   CODE_GENDER_MALE = "male",
   CODE_GENDER_UNKNOWN = "unknown"
}

# FHIR C4BBRelatedPersonCommunication datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + language - The ISO-639-1 alpha 2 code in lower case for the language, optionally followed by a hyphen and the ISO-3166-1 alpha 2 code for the region in upper case; e.g. 'en' for English, or 'en-US' for American English versus 'en-EN' for England English.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + preferred - Indicates whether or not the patient prefers this language (over other languages he masters up a certain level).
@r4:DataTypeDefinition {
    name: "C4BBRelatedPersonCommunication",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "RelatedPerson.communication.extension"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "RelatedPerson.communication.modifierExtension"
        },
        "language": {
            name: "language",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            description: "The ISO-639-1 alpha 2 code in lower case for the language, optionally followed by a hyphen and the ISO-3166-1 alpha 2 code for the region in upper case; e.g. 'en' for English, or 'en-US' for American English versus 'en-EN' for England English.",
            path: "RelatedPerson.communication.language"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "RelatedPerson.communication.id"
        },
        "preferred": {
            name: "preferred",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            description: "Indicates whether or not the patient prefers this language (over other languages he masters up a certain level).",
            path: "RelatedPerson.communication.preferred"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type C4BBRelatedPersonCommunication record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    r4:Extension[] modifierExtension?;
    r4:CodeableConcept language;
    string id?;
    boolean preferred?;
|};

# FHIR C4BBRelatedPersonMeta datatype record.
#
# + lastUpdated - When the resource last changed - e.g. when the version changed.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + security - Security labels applied to this resource. These tags connect specific resources to the overall security policy and infrastructure.
# + versionId - The version specific identifier, as it appears in the version portion of the URL. This value changes when the resource is created, updated, or deleted.
# + profile - A list of profiles (references to [StructureDefinition](http://hl7.org/fhir/R4/structuredefinition.html#) resources) that this resource claims to conform to. The URL is a reference to [StructureDefinition.url](http://hl7.org/fhir/R4/structuredefinition-definitions.html#StructureDefinition.url).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'source - A uri that identifies the source system of the resource. This provides a minimal amount of [Provenance](http://hl7.org/fhir/R4/provenance.html#) information that can be used to track or differentiate the source of information in the resource. The source may identify another FHIR server, document, message, database, etc.
# + tag - Tags applied to this resource. Tags are intended to be used to identify and relate resources to process and workflow, and applications are not required to consider the tags when interpreting the meaning of a resource.
@r4:DataTypeDefinition {
    name: "C4BBRelatedPersonMeta",
    baseType: (),
    elements: {
        "lastUpdated": {
            name: "lastUpdated",
            dataType: r4:instant,
            min: 1,
            max: 1,
            isArray: false,
            description: "When the resource last changed - e.g. when the version changed.",
            path: "RelatedPerson.meta.lastUpdated"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "RelatedPerson.meta.extension"
        },
        "security": {
            name: "security",
            dataType: r4:Coding,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Security labels applied to this resource. These tags connect specific resources to the overall security policy and infrastructure.",
            path: "RelatedPerson.meta.security"
        },
        "versionId": {
            name: "versionId",
            dataType: r4:id,
            min: 0,
            max: 1,
            isArray: false,
            description: "The version specific identifier, as it appears in the version portion of the URL. This value changes when the resource is created, updated, or deleted.",
            path: "RelatedPerson.meta.versionId"
        },
        "profile": {
            name: "profile",
            dataType: r4:canonical,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            description: "A list of profiles (references to [StructureDefinition](http://hl7.org/fhir/R4/structuredefinition.html#) resources) that this resource claims to conform to. The URL is a reference to [StructureDefinition.url](http://hl7.org/fhir/R4/structuredefinition-definitions.html#StructureDefinition.url).",
            path: "RelatedPerson.meta.profile"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "RelatedPerson.meta.id"
        },
        "source": {
            name: "source",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            description: "A uri that identifies the source system of the resource. This provides a minimal amount of [Provenance](http://hl7.org/fhir/R4/provenance.html#) information that can be used to track or differentiate the source of information in the resource. The source may identify another FHIR server, document, message, database, etc.",
            path: "RelatedPerson.meta.source"
        },
        "tag": {
            name: "tag",
            dataType: r4:Coding,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Tags applied to this resource. Tags are intended to be used to identify and relate resources to process and workflow, and applications are not required to consider the tags when interpreting the meaning of a resource.",
            path: "RelatedPerson.meta.tag"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type C4BBRelatedPersonMeta record {|
    *r4:Meta;

    r4:instant lastUpdated;
    r4:Extension[] extension?;
    r4:Coding[] security?;
    r4:id versionId?;
    @constraint:Array {
        minLength: {
            value: 1,
            message: "Validation failed for $.RelatedPerson.meta.profile constraint. This field must be an array containing at least one item."
        },
        maxLength: {
            value: 1,
            message: "Validation failed for $.RelatedPerson.meta.profile constraint. This field must be an array containing at most one item."
        }
    }
    r4:canonical[] profile;
    string id?;
    r4:uri 'source?;
    r4:Coding[] tag?;
|};

