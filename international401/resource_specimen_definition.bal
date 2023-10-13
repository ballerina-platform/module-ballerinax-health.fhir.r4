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

public const string PROFILE_BASE_SPECIMENDEFINITION = "http://hl7.org/fhir/StructureDefinition/SpecimenDefinition";
public const RESOURCE_NAME_SPECIMENDEFINITION = "SpecimenDefinition";

# FHIR SpecimenDefinition resource record.
#
# + resourceType - The type of the resource describes
# + identifier - A business identifier associated with the kind of specimen.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + patientPreparation - Preparation of the patient for specimen collection.
# + timeAspect - Time aspect of specimen collection (duration or offset).
# + language - The base language in which the resource is written.
# + collection - The action to be performed for collecting the specimen.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + typeCollected - The kind of material to be collected.
# + typeTested - Specimen conditioned in a container as expected by the testing laboratory.
@r4:ResourceDefinition {
    resourceType: "SpecimenDefinition",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/SpecimenDefinition",
    elements: {
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: 1,
            isArray: false,
            path: "SpecimenDefinition.identifier"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "SpecimenDefinition.extension"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "SpecimenDefinition.modifierExtension"
        },
        "patientPreparation" : {
            name: "patientPreparation",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "SpecimenDefinition.patientPreparation",
            valueSet: "http://hl7.org/fhir/ValueSet/prepare-patient-prior-specimen-collection"
        },
        "timeAspect" : {
            name: "timeAspect",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "SpecimenDefinition.timeAspect"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "SpecimenDefinition.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "collection" : {
            name: "collection",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "SpecimenDefinition.collection",
            valueSet: "http://hl7.org/fhir/ValueSet/specimen-collection"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "SpecimenDefinition.contained"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "SpecimenDefinition.meta"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "SpecimenDefinition.implicitRules"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "SpecimenDefinition.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "SpecimenDefinition.text"
        },
        "typeCollected" : {
            name: "typeCollected",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "SpecimenDefinition.typeCollected",
            valueSet: "http://terminology.hl7.org/ValueSet/v2-0487"
        },
        "typeTested" : {
            name: "typeTested",
            dataType: SpecimenDefinitionTypeTested,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "SpecimenDefinition.typeTested"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type SpecimenDefinition record {|
    *r4:DomainResource;

    RESOURCE_NAME_SPECIMENDEFINITION resourceType = RESOURCE_NAME_SPECIMENDEFINITION;

    r4:Identifier identifier?;
    r4:Extension[] extension?;
    r4:Extension[] modifierExtension?;
    r4:CodeableConcept[] patientPreparation?;
    string timeAspect?;
    r4:code language?;
    r4:CodeableConcept[] collection?;
    r4:Resource[] contained?;
    r4:Meta meta?;
    r4:uri implicitRules?;
    string id?;
    r4:Narrative text?;
    r4:CodeableConcept typeCollected?;
    SpecimenDefinitionTypeTested[] typeTested?;
    r4:Element ...;
|};

# FHIR SpecimenDefinitionTypeTested datatype record.
#
# + container - The specimen's container.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + isDerived - Primary of secondary specimen.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + preference - The preference for this type of conditioned specimen.
# + rejectionCriterion - Criterion for rejection of the specimen in its container by the laboratory.
# + handling - Set of instructions for preservation/transport of the specimen at a defined temperature interval, prior the testing process.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + requirement - Requirements for delivery and special handling of this kind of conditioned specimen.
# + retentionTime - The usual time that a specimen of this kind is retained after the ordered tests are completed, for the purpose of additional testing.
# + 'type - The kind of specimen conditioned for testing expected by lab.
@r4:DataTypeDefinition {
    name: "SpecimenDefinitionTypeTested",
    baseType: (),
    elements: {
        "container": {
            name: "container",
            dataType: SpecimenDefinitionTypeTestedContainer,
            min: 0,
            max: 1,
            isArray: false,
            description: "The specimen's container.",
            path: "SpecimenDefinition.typeTested.container"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "SpecimenDefinition.typeTested.extension"
        },
        "isDerived": {
            name: "isDerived",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            description: "Primary of secondary specimen.",
            path: "SpecimenDefinition.typeTested.isDerived"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "SpecimenDefinition.typeTested.modifierExtension"
        },
        "preference": {
            name: "preference",
            dataType: SpecimenDefinitionTypeTestedPreference,
            min: 1,
            max: 1,
            isArray: false,
            description: "The preference for this type of conditioned specimen.",
            path: "SpecimenDefinition.typeTested.preference"
        },
        "rejectionCriterion": {
            name: "rejectionCriterion",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Criterion for rejection of the specimen in its container by the laboratory.",
            path: "SpecimenDefinition.typeTested.rejectionCriterion"
        },
        "handling": {
            name: "handling",
            dataType: SpecimenDefinitionTypeTestedHandling,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Set of instructions for preservation/transport of the specimen at a defined temperature interval, prior the testing process.",
            path: "SpecimenDefinition.typeTested.handling"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "SpecimenDefinition.typeTested.id"
        },
        "requirement": {
            name: "requirement",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Requirements for delivery and special handling of this kind of conditioned specimen.",
            path: "SpecimenDefinition.typeTested.requirement"
        },
        "retentionTime": {
            name: "retentionTime",
            dataType: r4:Duration,
            min: 0,
            max: 1,
            isArray: false,
            description: "The usual time that a specimen of this kind is retained after the ordered tests are completed, for the purpose of additional testing.",
            path: "SpecimenDefinition.typeTested.retentionTime"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The kind of specimen conditioned for testing expected by lab.",
            path: "SpecimenDefinition.typeTested.type"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type SpecimenDefinitionTypeTested record {|
    *r4:BackboneElement;

    SpecimenDefinitionTypeTestedContainer container?;
    r4:Extension[] extension?;
    boolean isDerived?;
    r4:Extension[] modifierExtension?;
    SpecimenDefinitionTypeTestedPreference preference;
    r4:CodeableConcept[] rejectionCriterion?;
    SpecimenDefinitionTypeTestedHandling[] handling?;
    string id?;
    string requirement?;
    r4:Duration retentionTime?;
    r4:CodeableConcept 'type?;
|};

# SpecimenDefinitionTypeTestedPreference enum
public enum SpecimenDefinitionTypeTestedPreference {
   CODE_PREFERENCE_ALTERNATE = "alternate",
   CODE_PREFERENCE_PREFERRED = "preferred"
}

# FHIR SpecimenDefinitionTypeTestedHandling datatype record.
#
# + temperatureRange - The temperature interval for this set of handling instructions.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + instruction - Additional textual instructions for the preservation or transport of the specimen. For instance, 'Protect from light exposure'.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + maxDuration - The maximum time interval of preservation of the specimen with these conditions.
# + temperatureQualifier - It qualifies the interval of temperature, which characterizes an occurrence of handling. Conditions that are not related to temperature may be handled in the instruction element.
@r4:DataTypeDefinition {
    name: "SpecimenDefinitionTypeTestedHandling",
    baseType: (),
    elements: {
        "temperatureRange": {
            name: "temperatureRange",
            dataType: r4:Range,
            min: 0,
            max: 1,
            isArray: false,
            description: "The temperature interval for this set of handling instructions.",
            path: "SpecimenDefinition.typeTested.handling.temperatureRange"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "SpecimenDefinition.typeTested.handling.extension"
        },
        "instruction": {
            name: "instruction",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Additional textual instructions for the preservation or transport of the specimen. For instance, 'Protect from light exposure'.",
            path: "SpecimenDefinition.typeTested.handling.instruction"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "SpecimenDefinition.typeTested.handling.modifierExtension"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "SpecimenDefinition.typeTested.handling.id"
        },
        "maxDuration": {
            name: "maxDuration",
            dataType: r4:Duration,
            min: 0,
            max: 1,
            isArray: false,
            description: "The maximum time interval of preservation of the specimen with these conditions.",
            path: "SpecimenDefinition.typeTested.handling.maxDuration"
        },
        "temperatureQualifier": {
            name: "temperatureQualifier",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "It qualifies the interval of temperature, which characterizes an occurrence of handling. Conditions that are not related to temperature may be handled in the instruction element.",
            path: "SpecimenDefinition.typeTested.handling.temperatureQualifier"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type SpecimenDefinitionTypeTestedHandling record {|
    *r4:BackboneElement;

    r4:Range temperatureRange?;
    r4:Extension[] extension?;
    string instruction?;
    r4:Extension[] modifierExtension?;
    string id?;
    r4:Duration maxDuration?;
    r4:CodeableConcept temperatureQualifier?;
|};

# FHIR SpecimenDefinitionTypeTestedContainerAdditive datatype record.
#
# + additiveSpecimenDefinitionReference - Substance introduced in the kind of container to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + additiveSpecimenDefinitionCodeableConcept - Substance introduced in the kind of container to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
@r4:DataTypeDefinition {
    name: "SpecimenDefinitionTypeTestedContainerAdditive",
    baseType: (),
    elements: {
        "additiveSpecimenDefinitionReference": {
            name: "additiveSpecimenDefinitionReference",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            description: "Substance introduced in the kind of container to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.",
            path: "SpecimenDefinition.typeTested.container.additive.additive[x]"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "SpecimenDefinition.typeTested.container.additive.extension"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "SpecimenDefinition.typeTested.container.additive.modifierExtension"
        },
        "additiveSpecimenDefinitionCodeableConcept": {
            name: "additiveSpecimenDefinitionCodeableConcept",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            description: "Substance introduced in the kind of container to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.",
            path: "SpecimenDefinition.typeTested.container.additive.additive[x]"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "SpecimenDefinition.typeTested.container.additive.id"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type SpecimenDefinitionTypeTestedContainerAdditive record {|
    *r4:BackboneElement;

    r4:Reference additiveSpecimenDefinitionReference;
    r4:Extension[] extension?;
    r4:Extension[] modifierExtension?;
    r4:CodeableConcept additiveSpecimenDefinitionCodeableConcept;
    string id?;
|};

# FHIR SpecimenDefinitionTypeTestedContainer datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + cap - Color of container cap.
# + material - The type of material of the container.
# + minimumVolumeSpecimenDefinitionString - The minimum volume to be conditioned in the container.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + description - The textual description of the kind of container.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - The type of container used to contain this kind of specimen.
# + minimumVolumeSpecimenDefinitionQuantity - The minimum volume to be conditioned in the container.
# + additive - Substance introduced in the kind of container to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.
# + capacity - The capacity (volume or other measure) of this kind of container.
# + preparation - Special processing that should be applied to the container for this kind of specimen.
@r4:DataTypeDefinition {
    name: "SpecimenDefinitionTypeTestedContainer",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "SpecimenDefinition.typeTested.container.extension"
        },
        "cap": {
            name: "cap",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Color of container cap.",
            path: "SpecimenDefinition.typeTested.container.cap"
        },
        "material": {
            name: "material",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The type of material of the container.",
            path: "SpecimenDefinition.typeTested.container.material"
        },
        "minimumVolumeSpecimenDefinitionString": {
            name: "minimumVolumeSpecimenDefinitionString",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "The minimum volume to be conditioned in the container.",
            path: "SpecimenDefinition.typeTested.container.minimumVolume[x]"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "SpecimenDefinition.typeTested.container.modifierExtension"
        },
        "description": {
            name: "description",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "The textual description of the kind of container.",
            path: "SpecimenDefinition.typeTested.container.description"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "SpecimenDefinition.typeTested.container.id"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The type of container used to contain this kind of specimen.",
            path: "SpecimenDefinition.typeTested.container.type"
        },
        "minimumVolumeSpecimenDefinitionQuantity": {
            name: "minimumVolumeSpecimenDefinitionQuantity",
            dataType: r4:Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "The minimum volume to be conditioned in the container.",
            path: "SpecimenDefinition.typeTested.container.minimumVolume[x]"
        },
        "additive": {
            name: "additive",
            dataType: SpecimenDefinitionTypeTestedContainerAdditive,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Substance introduced in the kind of container to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.",
            path: "SpecimenDefinition.typeTested.container.additive"
        },
        "capacity": {
            name: "capacity",
            dataType: r4:Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "The capacity (volume or other measure) of this kind of container.",
            path: "SpecimenDefinition.typeTested.container.capacity"
        },
        "preparation": {
            name: "preparation",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Special processing that should be applied to the container for this kind of specimen.",
            path: "SpecimenDefinition.typeTested.container.preparation"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type SpecimenDefinitionTypeTestedContainer record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    r4:CodeableConcept cap?;
    r4:CodeableConcept material?;
    string minimumVolumeSpecimenDefinitionString?;
    r4:Extension[] modifierExtension?;
    string description?;
    string id?;
    r4:CodeableConcept 'type?;
    r4:Quantity minimumVolumeSpecimenDefinitionQuantity?;
    SpecimenDefinitionTypeTestedContainerAdditive[] additive?;
    r4:Quantity capacity?;
    string preparation?;
|};

