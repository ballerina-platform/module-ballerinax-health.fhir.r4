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

public const string PROFILE_BASE_PASPRACTITIONER = "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-practitioner";
public const RESOURCE_NAME_PASPRACTITIONER = "Practitioner";

# FHIR PASPractitioner resource record.
#
# + resourceType - The type of the resource describes
# + identifier - An identifier that applies to this person in this role.
# * identifier Slicings
# 1) PASPractitionerIdentifierNPI: An identifier intended for computation
#       - min = 0
#       - max = 1
#
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + address - Address(es) of the practitioner that are not role specific (typically home address). Work addresses are not typically entered in this property as they are usually role dependent.
# + gender - Administrative Gender - the gender that the person is considered to have for administration and record keeping purposes.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + active - Whether this practitioner's record is in active use.
# + photo - Image of the person.
# + language - The base language in which the resource is written.
# + birthDate - The date of birth for the practitioner.
# + qualification - The official certifications, training, and licenses that authorize or otherwise pertain to the provision of care by the practitioner. For example, a medical license issued by a medical board authorizing the practitioner to practice medicine within a certian locality.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + name - The name(s) associated with the practitioner.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + telecom - A contact detail for the practitioner, e.g. a telephone number or an email address.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + communication - A language the practitioner can use in patient communication.
@r4:ResourceDefinition {
    resourceType: "Practitioner",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-practitioner",
    elements: {
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.identifier"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.extension"
        },
        "address" : {
            name: "address",
            dataType: r4:Address,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.address"
        },
        "gender" : {
            name: "gender",
            dataType: PASPractitionerGender,
            min: 0,
            max: 1,
            isArray: false,
            path: "Practitioner.gender",
            valueSet: "http://hl7.org/fhir/ValueSet/administrative-gender|4.0.1"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.modifierExtension"
        },
        "active" : {
            name: "active",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            path: "Practitioner.active"
        },
        "photo" : {
            name: "photo",
            dataType: r4:Attachment,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.photo"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Practitioner.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "birthDate" : {
            name: "birthDate",
            dataType: r4:date,
            min: 0,
            max: 1,
            isArray: false,
            path: "Practitioner.birthDate"
        },
        "qualification" : {
            name: "qualification",
            dataType: PASPractitionerQualification,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.qualification"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.contained"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Practitioner.meta"
        },
        "name" : {
            name: "name",
            dataType: r4:HumanName,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.name"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Practitioner.implicitRules"
        },
        "telecom" : {
            name: "telecom",
            dataType: r4:ContactPoint,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.telecom"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Practitioner.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Practitioner.text"
        },
        "communication" : {
            name: "communication",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Practitioner.communication",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type PASPractitioner record {|
    *r4:DomainResource;

    RESOURCE_NAME_PASPRACTITIONER resourceType = RESOURCE_NAME_PASPRACTITIONER;

    @constraint:Array {
       minLength: 1
    }
    ProfileIdentifier[] identifier;
    r4:Extension[] extension?;
    r4:Address[] address?;
    PASPractitionerGender gender?;
    r4:Extension[] modifierExtension?;
    boolean active?;
    r4:Attachment[] photo?;
    r4:code language?;
    r4:date birthDate?;
    PASPractitionerQualification[] qualification?;
    r4:Resource[] contained?;
    r4:Meta meta?;
    @constraint:Array {
       minLength: 1
    }
    r4:HumanName[] name;
    r4:uri implicitRules?;
    r4:ContactPoint[] telecom?;
    string id?;
    r4:Narrative text?;
    r4:CodeableConcept[] communication?;
    r4:Element ...;
|};

# PASPractitionerGender enum
public enum PASPractitionerGender {
   CODE_GENDER_OTHER = "other",
   CODE_GENDER_FEMALE = "female",
   CODE_GENDER_MALE = "male",
   CODE_GENDER_UNKNOWN = "unknown"
}

# FHIR PASPractitionerIdentifierNPI datatype record.
#
# + system - Establishes the namespace for the value - that is, a URL that describes a set values that are unique.
@r4:DataTypeDefinition {
    name: "PASPractitionerIdentifierNPI",
    baseType: (),
    elements: {
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Practitioner.identifier.system"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type PASPractitionerIdentifierNPI record {|
    *r4:Identifier;

    r4:uri system = "http://hl7.org/fhir/sid/us-npi";
|};

# FHIR PASPractitionerQualification datatype record.
#
# + identifier - An identifier that applies to this person's qualification in this role.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + period - Period during which the qualification is valid.
# + code - Coded representation of the qualification.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + issuer - Organization that regulates and issues the qualification.
@r4:DataTypeDefinition {
    name: "PASPractitionerQualification",
    baseType: (),
    elements: {
        "identifier": {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "An identifier that applies to this person's qualification in this role.",
            path: "Practitioner.qualification.identifier"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Practitioner.qualification.extension"
        },
        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Period during which the qualification is valid.",
            path: "Practitioner.qualification.period"
        },
        "code": {
            name: "code",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            description: "Coded representation of the qualification.",
            path: "Practitioner.qualification.code"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Practitioner.qualification.modifierExtension"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Practitioner.qualification.id"
        },
        "issuer": {
            name: "issuer",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that regulates and issues the qualification.",
            path: "Practitioner.qualification.issuer"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type PASPractitionerQualification record {|
    *r4:BackboneElement;

    r4:Identifier[] identifier?;
    r4:Extension[] extension?;
    r4:Period period?;
    r4:CodeableConcept code;
    r4:Extension[] modifierExtension?;
    string id?;
    r4:Reference issuer?;
|};

# PASPractitionerNameUse enum
public enum PASPractitionerNameUse {
   CODE_USE_MAIDEN = "maiden",
   CODE_USE_TEMP = "temp",
   CODE_USE_USUAL = "usual",
   CODE_USE_OLD = "old",
   CODE_USE_NICKNAME = "nickname",
   CODE_USE_OFFICIAL = "official",
   CODE_USE_ANONYMOUS = "anonymous"
}

