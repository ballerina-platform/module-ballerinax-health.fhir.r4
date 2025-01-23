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

public const string PROFILE_BASE_USCORESPECIMENPROFILE = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-specimen";
public const RESOURCE_NAME_USCORESPECIMENPROFILE = "Specimen";

# FHIR USCoreSpecimenProfile resource record.
#
# + resourceType - The type of the resource describes
# + container - The container holding the specimen. The recursive nature of containers; i.e. blood in tube in tray in rack is not addressed here.
# + accessionIdentifier - The identifier assigned by the lab when accessioning specimen(s). This is not necessarily the same as the specimen identifier, depending on local lab procedures.
# + identifier - Id for specimen.
# + note - To communicate any details or issues about the specimen or during the specimen collection. (for example: broken vial, sent with patient, frozen).
# + parent - Reference to the parent (source) specimen which is used when the specimen was either derived from or a component of another specimen.
# + request - Details concerning a service request that required a specimen to be collected.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + subject - Where the specimen came from. This may be from patient(s), from a location (e.g., the source of an environmental sample), or a sampling of a substance or a device.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + language - The base language in which the resource is written.
# + collection - Details concerning the specimen collection.
# + 'type - The kind of material that forms the specimen.
# + condition - A mode or state of being that describes the nature of the specimen.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + receivedTime - Time when specimen was received for processing or testing.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + processing - Details concerning processing and processing steps for the specimen.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + status - The availability of the specimen.
@r4:ResourceDefinition {
    resourceType: "Specimen",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-specimen",
    elements: {
        "container" : {
            name: "container",
            dataType: USCoreSpecimenProfileContainer,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.container"
        },
        "accessionIdentifier" : {
            name: "accessionIdentifier",
            dataType: r4:Identifier,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.accessionIdentifier"
        },
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.identifier"
        },
        "note" : {
            name: "note",
            dataType: r4:Annotation,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.note"
        },
        "parent" : {
            name: "parent",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.parent"
        },
        "request" : {
            name: "request",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.request"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.extension"
        },
        "subject" : {
            name: "subject",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.subject"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.modifierExtension"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "collection" : {
            name: "collection",
            dataType: USCoreSpecimenProfileCollection,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.collection"
        },
        "type" : {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            path: "Specimen.type",
            valueSet: "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1099.54"
        },
        "condition" : {
            name: "condition",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.condition",
            valueSet: "http://terminology.hl7.org/ValueSet/v2-0493"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.contained"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.meta"
        },
        "receivedTime" : {
            name: "receivedTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.receivedTime"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.implicitRules"
        },
        "processing" : {
            name: "processing",
            dataType: USCoreSpecimenProfileProcessing,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Specimen.processing"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.text"
        },
        "status" : {
            name: "status",
            dataType: USCoreSpecimenProfileStatus,
            min: 0,
            max: 1,
            isArray: false,
            path: "Specimen.status",
            valueSet: "http://hl7.org/fhir/ValueSet/specimen-status|4.0.1"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type USCoreSpecimenProfile record {|
    *r4:DomainResource;

    RESOURCE_NAME_USCORESPECIMENPROFILE resourceType = RESOURCE_NAME_USCORESPECIMENPROFILE;

    USCoreSpecimenProfileContainer[] container?;
    r4:Identifier accessionIdentifier?;
    r4:Identifier[] identifier?;
    r4:Annotation[] note?;
    r4:Reference[] parent?;
    r4:Reference[] request?;
    r4:Extension[] extension?;
    r4:Reference subject?;
    r4:Extension[] modifierExtension?;
    r4:code language?;
    USCoreSpecimenProfileCollection collection?;
    r4:CodeableConcept 'type;
    r4:CodeableConcept[] condition?;
    r4:Resource[] contained?;
    r4:Meta meta?;
    r4:dateTime receivedTime?;
    r4:uri implicitRules?;
    USCoreSpecimenProfileProcessing[] processing?;
    string id?;
    r4:Narrative text?;
    USCoreSpecimenProfileStatus status?;
    r4:Element ...;
|};

# FHIR USCoreSpecimenProfileCollection datatype record.
#
# + duration - The span of time over which the collection of a specimen occurred.
# + bodySite - Anatomical location from which the specimen was collected (if subject is a patient). This is the target site. This element is not used for environmental specimens.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + fastingStatusDuration - Abstinence or reduction from some or all food, drink, or both, for a period of time prior to sample collection.
# + quantity - The quantity of specimen collected; for instance the volume of a blood sample, or the physical measurement of an anatomic pathology sample.
# + collectedPeriod - Time when specimen was collected from subject - the physiologically relevant time.
# + method - A coded value specifying the technique that is used to perform the procedure.
# + collectedDateTime - Time when specimen was collected from subject - the physiologically relevant time.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + fastingStatusCodeableConcept - Abstinence or reduction from some or all food, drink, or both, for a period of time prior to sample collection.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + collector - Person who collected the specimen.
@r4:DataTypeDefinition {
    name: "USCoreSpecimenProfileCollection",
    baseType: (),
    elements: {
        "duration": {
            name: "duration",
            dataType: r4:Duration,
            min: 0,
            max: 1,
            isArray: false,
            description: "The span of time over which the collection of a specimen occurred.",
            path: "Specimen.collection.duration"
        },
        "bodySite": {
            name: "bodySite",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Anatomical location from which the specimen was collected (if subject is a patient). This is the target site. This element is not used for environmental specimens.",
            path: "Specimen.collection.bodySite"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Specimen.collection.extension"
        },
        "fastingStatusDuration": {
            name: "fastingStatusDuration",
            dataType: r4:Duration,
            min: 0,
            max: 1,
            isArray: false,
            description: "Abstinence or reduction from some or all food, drink, or both, for a period of time prior to sample collection.",
            path: "Specimen.collection.fastingStatus[x]"
        },
        "quantity": {
            name: "quantity",
            dataType: r4:Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "The quantity of specimen collected; for instance the volume of a blood sample, or the physical measurement of an anatomic pathology sample.",
            path: "Specimen.collection.quantity"
        },
        "collectedPeriod": {
            name: "collectedPeriod",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time when specimen was collected from subject - the physiologically relevant time.",
            path: "Specimen.collection.collected[x]"
        },
        "method": {
            name: "method",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded value specifying the technique that is used to perform the procedure.",
            path: "Specimen.collection.method"
        },
        "collectedDateTime": {
            name: "collectedDateTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time when specimen was collected from subject - the physiologically relevant time.",
            path: "Specimen.collection.collected[x]"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Specimen.collection.modifierExtension"
        },
        "fastingStatusCodeableConcept": {
            name: "fastingStatusCodeableConcept",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Abstinence or reduction from some or all food, drink, or both, for a period of time prior to sample collection.",
            path: "Specimen.collection.fastingStatus[x]"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Specimen.collection.id"
        },
        "collector": {
            name: "collector",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Person who collected the specimen.",
            path: "Specimen.collection.collector"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreSpecimenProfileCollection record {|
    *r4:BackboneElement;

    r4:Duration duration?;
    r4:CodeableConcept bodySite?;
    r4:Extension[] extension?;
    r4:Duration fastingStatusDuration?;
    r4:Quantity quantity?;
    r4:Period collectedPeriod?;
    r4:CodeableConcept method?;
    r4:dateTime collectedDateTime?;
    r4:Extension[] modifierExtension?;
    r4:CodeableConcept fastingStatusCodeableConcept?;
    string id?;
    r4:Reference collector?;
|};

# FHIR USCoreSpecimenProfileProcessing datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + timePeriod - A record of the time or period when the specimen processing occurred. For example the time of sample fixation or the period of time the sample was in formalin.
# + description - Textual description of procedure.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + procedure - A coded value specifying the procedure used to process the specimen.
# + timeDateTime - A record of the time or period when the specimen processing occurred. For example the time of sample fixation or the period of time the sample was in formalin.
# + additive - Material used in the processing step.
@r4:DataTypeDefinition {
    name: "USCoreSpecimenProfileProcessing",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Specimen.processing.extension"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Specimen.processing.modifierExtension"
        },
        "timePeriod": {
            name: "timePeriod",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "A record of the time or period when the specimen processing occurred. For example the time of sample fixation or the period of time the sample was in formalin.",
            path: "Specimen.processing.time[x]"
        },
        "description": {
            name: "description",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Textual description of procedure.",
            path: "Specimen.processing.description"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Specimen.processing.id"
        },
        "procedure": {
            name: "procedure",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded value specifying the procedure used to process the specimen.",
            path: "Specimen.processing.procedure"
        },
        "timeDateTime": {
            name: "timeDateTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            description: "A record of the time or period when the specimen processing occurred. For example the time of sample fixation or the period of time the sample was in formalin.",
            path: "Specimen.processing.time[x]"
        },
        "additive": {
            name: "additive",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Material used in the processing step.",
            path: "Specimen.processing.additive"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreSpecimenProfileProcessing record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    r4:Extension[] modifierExtension?;
    r4:Period timePeriod?;
    string description?;
    string id?;
    r4:CodeableConcept procedure?;
    r4:dateTime timeDateTime?;
    r4:Reference[] additive?;
|};

# FHIR USCoreSpecimenProfileContainer datatype record.
#
# + identifier - Id for container. There may be multiple; a manufacturer's bar code, lab assigned identifier, etc. The container ID may differ from the specimen id in some circumstances.
# + specimenQuantity - The quantity of specimen in the container; may be volume, dimensions, or other appropriate measurements, depending on the specimen type.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + description - Textual description of the container.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + 'type - The type of container associated with the specimen (e.g. slide, aliquot, etc.).
# + additiveReference - Introduced substance to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.
# + additiveCodeableConcept - Introduced substance to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.
# + capacity - The capacity (volume or other measure) the container may contain.
@r4:DataTypeDefinition {
    name: "USCoreSpecimenProfileContainer",
    baseType: (),
    elements: {
        "identifier": {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Id for container. There may be multiple; a manufacturer's bar code, lab assigned identifier, etc. The container ID may differ from the specimen id in some circumstances.",
            path: "Specimen.container.identifier"
        },
        "specimenQuantity": {
            name: "specimenQuantity",
            dataType: r4:Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "The quantity of specimen in the container; may be volume, dimensions, or other appropriate measurements, depending on the specimen type.",
            path: "Specimen.container.specimenQuantity"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Specimen.container.extension"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Specimen.container.modifierExtension"
        },
        "description": {
            name: "description",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Textual description of the container.",
            path: "Specimen.container.description"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Specimen.container.id"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The type of container associated with the specimen (e.g. slide, aliquot, etc.).",
            path: "Specimen.container.type"
        },
        "additiveReference": {
            name: "additiveReference",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Introduced substance to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.",
            path: "Specimen.container.additive[x]"
        },
        "additiveCodeableConcept": {
            name: "additiveCodeableConcept",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Introduced substance to preserve, maintain or enhance the specimen. Examples: Formalin, Citrate, EDTA.",
            path: "Specimen.container.additive[x]"
        },
        "capacity": {
            name: "capacity",
            dataType: r4:Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "The capacity (volume or other measure) the container may contain.",
            path: "Specimen.container.capacity"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type USCoreSpecimenProfileContainer record {|
    *r4:BackboneElement;

    r4:Identifier[] identifier?;
    r4:Quantity specimenQuantity?;
    r4:Extension[] extension?;
    r4:Extension[] modifierExtension?;
    string description?;
    string id?;
    r4:CodeableConcept 'type?;
    r4:Reference additiveReference?;
    r4:CodeableConcept additiveCodeableConcept?;
    r4:Quantity capacity?;
|};

# USCoreSpecimenProfileStatus enum
public enum USCoreSpecimenProfileStatus {
   CODE_STATUS_UNAVAILABLE = "unavailable",
   CODE_STATUS_AVAILABLE = "available",
   CODE_STATUS_UNSATISFACTORY = "unsatisfactory",
   CODE_STATUS_ENTERED_IN_ERROR = "entered-in-error"
}

