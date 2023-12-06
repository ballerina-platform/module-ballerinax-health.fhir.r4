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

public const string PROFILE_BASE_DEVICE_METRIC_OBSERVATION_PROFILE = "http://hl7.org/fhir/StructureDefinition/devicemetricobservation";
public const RESOURCE_NAME_DEVICE_METRIC_OBSERVATION_PROFILE = "Observation";

# FHIR Device_Metric_Observation_Profile resource record.
#
# + resourceType - The type of the resource describes
# + dataAbsentReason - Provides a reason why the expected value in the element Observation.value[x] is missing.
# + note - Comments about the observation or the results.
# + partOf - A larger event of which this particular Observation is a component or step. For example, an observation as part of a procedure.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + valueTime - The information determined as a result of making the observation, if the information has a simple value.
# + code - Describes what was observed. Sometimes this is called the observation 'name'.
# + subject - The patient, or group of patients, location, or device this observation is about and into whose record the observation is placed. If the actual focus of the observation is different from the subject (or a sample of, part, or region of the subject), the `focus` element or the `code` itself specifies the actual focus of the observation.
# + valueRange - The information determined as a result of making the observation, if the information has a simple value.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + focus - The actual focus of an observation when it is not the patient of record representing something or someone associated with the patient such as a spouse, parent, fetus, or donor. For example, fetus observations in a mother's record. The focus of an observation could also be an existing condition, an intervention, the subject's diet, another observation of the subject, or a body structure such as tumor or implanted device. An example use case would be using the Observation resource to capture whether the mother is trained to change her child's tracheostomy tube. In this example, the child is the patient of record and the mother is the focus.
# + language - The base language in which the resource is written.
# + valueCodeableConcept - The information determined as a result of making the observation, if the information has a simple value.
# + valueRatio - The information determined as a result of making the observation, if the information has a simple value.
# + specimen - The specimen that was used when this observation was made.
# + derivedFrom - The target resource that represents a measurement from which this observation value is derived. For example, a calculated anion gap or a fetal measurement based on an ultrasound image.
# + valueDateTime - The information determined as a result of making the observation, if the information has a simple value.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + issued - The date and time this version of the observation was made available to providers, typically after the results have been reviewed and verified.
# + basedOn - A plan, proposal or order that is fulfilled in whole or in part by this event. For example, a MedicationRequest may require a patient to have laboratory test performed before it is dispensed.
# + valueQuantity - The information determined as a result of making the observation, if the information has a simple value.
# + identifier - A unique identifier assigned to this observation.
# + performer - Who was responsible for asserting the observed value as 'true'.
# + method - Indicates the mechanism used to perform the observation.
# + hasMember - This observation is a group observation (e.g. a battery, a panel of tests, a set of vital sign measurements) that includes the target as a member of the group.
# + encounter - The healthcare event (e.g. a patient and healthcare provider interaction) during which this observation is made.
# + bodySite - Indicates the site on the subject's body where the observation was made (i.e. the target site).
# + component - Some observations have multiple component observations. These component observations are expressed as separate code value pairs that share the same attributes. Examples include systolic and diastolic component observations for blood pressure measurement and multiple component observations for genetics observations.
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + referenceRange - Guidance on how to interpret the value by comparison to a normal or recommended range. Multiple reference ranges are interpreted as an 'OR'. In other words, to represent two distinct target populations, two `referenceRange` elements would be used.
# + valueString - The information determined as a result of making the observation, if the information has a simple value.
# + effectiveDateTime - The time or time-period the observed value is asserted as being true. For biological subjects - e.g. human patients - this is usually called the 'physiologically relevant time'. This is usually either the time of the procedure or of specimen collection, but very often the source of the date/time is not known, only the date/time itself.
# + interpretation - A categorical assessment of an observation value. For example, high, low, normal.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + valueSampledData - The information determined as a result of making the observation, if the information has a simple value.
# + valuePeriod - The information determined as a result of making the observation, if the information has a simple value.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + category - A code that classifies the general type of observation being made.
# + device - The device used to generate the observation data.
# + status - The status of the result value.
@r4:ResourceDefinition {
    resourceType: "Observation",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/devicemetricobservation",
    elements: {
        "dataAbsentReason" : {
            name: "dataAbsentReason",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 0,
            isArray: false,
            path: "Observation.dataAbsentReason",
            valueSet: "http://hl7.org/fhir/ValueSet/data-absent-reason"
        },
        "note" : {
            name: "note",
            dataType: r4:Annotation,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.note"
        },
        "partOf" : {
            name: "partOf",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.partOf"
        },
        "extension" : {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.extension"
        },
        "valueTime" : {
            name: "valueTime",
            dataType: r4:time,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.value[x]"
        },
        "code" : {
            name: "code",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            path: "Observation.code",
            valueSet: "http://hl7.org/fhir/ValueSet/observation-codes"
        },
        "subject" : {
            name: "subject",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "Observation.subject"
        },
        "valueRange" : {
            name: "valueRange",
            dataType: r4:Range,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.value[x]"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.modifierExtension"
        },
        "focus" : {
            name: "focus",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.focus"
        },
        "language" : {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "valueCodeableConcept" : {
            name: "valueCodeableConcept",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.value[x]"
        },
        "valueRatio" : {
            name: "valueRatio",
            dataType: r4:Ratio,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.value[x]"
        },
        "specimen" : {
            name: "specimen",
            dataType: r4:Reference,
            min: 0,
            max: 0,
            isArray: false,
            path: "Observation.specimen"
        },
        "derivedFrom" : {
            name: "derivedFrom",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.derivedFrom"
        },
        "valueDateTime" : {
            name: "valueDateTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.value[x]"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.id"
        },
        "text" : {
            name: "text",
            dataType: r4:Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.text"
        },
        "issued" : {
            name: "issued",
            dataType: r4:instant,
            min: 0,
            max: 0,
            isArray: false,
            path: "Observation.issued"
        },
        "basedOn" : {
            name: "basedOn",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.basedOn"
        },
        "valueQuantity" : {
            name: "valueQuantity",
            dataType: r4:Quantity,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.value[x]"
        },
        "identifier" : {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.identifier"
        },
        "performer" : {
            name: "performer",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.performer"
        },
        "method" : {
            name: "method",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.method",
            valueSet: "http://hl7.org/fhir/ValueSet/observation-methods"
        },
        "hasMember" : {
            name: "hasMember",
            dataType: r4:Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.hasMember"
        },
        "encounter" : {
            name: "encounter",
            dataType: r4:Reference,
            min: 0,
            max: 0,
            isArray: false,
            path: "Observation.encounter"
        },
        "bodySite" : {
            name: "bodySite",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.bodySite",
            valueSet: "http://hl7.org/fhir/ValueSet/body-site"
        },
        "component" : {
            name: "component",
            dataType: Device_Metric_Observation_ProfileComponent,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.component"
        },
        "contained" : {
            name: "contained",
            dataType: r4:Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.contained"
        },
        "referenceRange" : {
            name: "referenceRange",
            dataType: Device_Metric_Observation_ProfileReferenceRange,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.referenceRange"
        },
        "valueString" : {
            name: "valueString",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.value[x]"
        },
        "effectiveDateTime" : {
            name: "effectiveDateTime",
            dataType: r4:dateTime,
            min: 1,
            max: 1,
            isArray: false,
            path: "Observation.effective[x]"
        },
        "interpretation" : {
            name: "interpretation",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.interpretation",
            valueSet: "http://hl7.org/fhir/ValueSet/observation-interpretation"
        },
        "meta" : {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.meta"
        },
        "valueSampledData" : {
            name: "valueSampledData",
            dataType: r4:SampledData,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.value[x]"
        },
        "valuePeriod" : {
            name: "valuePeriod",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.value[x]"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Observation.implicitRules"
        },
        "category" : {
            name: "category",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "Observation.category",
            valueSet: "http://hl7.org/fhir/ValueSet/observation-category"
        },
        "device" : {
            name: "device",
            dataType: r4:Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "Observation.device"
        },
        "status" : {
            name: "status",
            dataType: Device_Metric_Observation_ProfileStatus,
            min: 1,
            max: 1,
            isArray: false,
            path: "Observation.status",
            valueSet: "http://hl7.org/fhir/ValueSet/observation-status|4.0.1"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type Device_Metric_Observation_Profile record {|
    *r4:DomainResource;

    RESOURCE_NAME_DEVICE_METRIC_OBSERVATION_PROFILE resourceType = RESOURCE_NAME_DEVICE_METRIC_OBSERVATION_PROFILE;

    r4:CodeableConcept dataAbsentReason?;
    r4:Annotation[] note?;
    r4:Reference[] partOf?;
    r4:Extension[] extension?;
    r4:time valueTime?;
    r4:CodeableConcept code;
    r4:Reference subject;
    r4:Range valueRange?;
    r4:Extension[] modifierExtension?;
    r4:Reference[] focus?;
    r4:code language?;
    r4:CodeableConcept valueCodeableConcept?;
    r4:Ratio valueRatio?;
    r4:Reference specimen?;
    r4:Reference[] derivedFrom?;
    r4:dateTime valueDateTime?;
    string id?;
    r4:Narrative text?;
    r4:instant issued?;
    r4:Reference[] basedOn?;
    r4:Quantity valueQuantity?;
    r4:Identifier[] identifier?;
    r4:Reference[] performer?;
    r4:CodeableConcept method?;
    r4:Reference[] hasMember?;
    r4:Reference encounter?;
    r4:CodeableConcept bodySite?;
    Device_Metric_Observation_ProfileComponent[] component?;
    r4:Resource[] contained?;
    Device_Metric_Observation_ProfileReferenceRange referenceRange?;
    string valueString?;
    r4:dateTime effectiveDateTime;
    r4:CodeableConcept interpretation?;
    r4:Meta meta?;
    r4:SampledData valueSampledData?;
    r4:Period valuePeriod?;
    r4:uri implicitRules?;
    r4:CodeableConcept[] category?;
    r4:Reference device;
    Device_Metric_Observation_ProfileStatus status;
    r4:Element ...;
|};

# Device_Metric_Observation_ProfileStatus enum
public enum Device_Metric_Observation_ProfileStatus {
   CODE_STATUS_AMENDED = "amended",
   CODE_STATUS_FINAL = "final",
   CODE_STATUS_REGISTERED = "registered",
   CODE_STATUS_PRELIMINARY = "preliminary"
}

# FHIR Device_Metric_Observation_ProfileReferenceRange datatype record.
#
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + high - The value of the high bound of the reference range. The high bound of the reference range endpoint is inclusive of the value (e.g. reference range is >=5 - <=9). If the high bound is omitted, it is assumed to be meaningless (e.g. reference range is >= 2.3).
# + low - The value of the low bound of the reference range. The low bound of the reference range endpoint is inclusive of the value (e.g. reference range is >=5 - <=9). If the low bound is omitted, it is assumed to be meaningless (e.g. reference range is <=2.3).
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + appliesTo - Codes to indicate the target population this reference range applies to. For example, a reference range may be based on the normal population or a particular sex or race. Multiple `appliesTo` are interpreted as an 'AND' of the target populations. For example, to represent a target population of African American females, both a code of female and a code for African American would be used.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + text - Text based reference range in an observation which may be used when a quantitative range is not appropriate for an observation. An example would be a reference value of 'Negative' or a list or table of 'normals'.
# + 'type - Codes to indicate the what part of the targeted reference population it applies to. For example, the normal or therapeutic range.
# + age - The age at which this reference range is applicable. This is a neonatal age (e.g. number of weeks at term) if the meaning says so.
@r4:DataTypeDefinition {
    name: "Device_Metric_Observation_ProfileReferenceRange",
    baseType: (),
    elements: {
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Observation.referenceRange.extension"
        },
        "high": {
            name: "high",
            dataType: r4:Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "The value of the high bound of the reference range. The high bound of the reference range endpoint is inclusive of the value (e.g. reference range is >=5 - <=9). If the high bound is omitted, it is assumed to be meaningless (e.g. reference range is >= 2.3).",
            path: "Observation.referenceRange.high"
        },
        "low": {
            name: "low",
            dataType: r4:Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "The value of the low bound of the reference range. The low bound of the reference range endpoint is inclusive of the value (e.g. reference range is >=5 - <=9). If the low bound is omitted, it is assumed to be meaningless (e.g. reference range is <=2.3).",
            path: "Observation.referenceRange.low"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Observation.referenceRange.modifierExtension"
        },
        "appliesTo": {
            name: "appliesTo",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Codes to indicate the target population this reference range applies to. For example, a reference range may be based on the normal population or a particular sex or race. Multiple `appliesTo` are interpreted as an 'AND' of the target populations. For example, to represent a target population of African American females, both a code of female and a code for African American would be used.",
            path: "Observation.referenceRange.appliesTo"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Observation.referenceRange.id"
        },
        "text": {
            name: "text",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Text based reference range in an observation which may be used when a quantitative range is not appropriate for an observation. An example would be a reference value of 'Negative' or a list or table of 'normals'.",
            path: "Observation.referenceRange.text"
        },
        "type": {
            name: "type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Codes to indicate the what part of the targeted reference population it applies to. For example, the normal or therapeutic range.",
            path: "Observation.referenceRange.type"
        },
        "age": {
            name: "age",
            dataType: r4:Range,
            min: 0,
            max: 1,
            isArray: false,
            description: "The age at which this reference range is applicable. This is a neonatal age (e.g. number of weeks at term) if the meaning says so.",
            path: "Observation.referenceRange.age"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type Device_Metric_Observation_ProfileReferenceRange record {|
    *r4:BackboneElement;

    r4:Extension[] extension?;
    r4:Quantity high?;
    r4:Quantity low?;
    r4:Extension[] modifierExtension?;
    r4:CodeableConcept[] appliesTo?;
    string id?;
    string text?;
    r4:CodeableConcept 'type?;
    r4:Range age?;
|};

# FHIR Device_Metric_Observation_ProfileComponent datatype record.
#
# + valueBoolean - The information determined as a result of making the observation, if the information has a simple value.
# + dataAbsentReason - Provides a reason why the expected value in the element Observation.component.value[x] is missing.
# + extension - May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + valueTime - The information determined as a result of making the observation, if the information has a simple value.
# + code - Describes what was observed. Sometimes this is called the observation 'code'.
# + valueRange - The information determined as a result of making the observation, if the information has a simple value.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + valueCodeableConcept - The information determined as a result of making the observation, if the information has a simple value.
# + valueRatio - The information determined as a result of making the observation, if the information has a simple value.
# + valueString - The information determined as a result of making the observation, if the information has a simple value.
# + interpretation - A categorical assessment of an observation value. For example, high, low, normal.
# + valueSampledData - The information determined as a result of making the observation, if the information has a simple value.
# + valuePeriod - The information determined as a result of making the observation, if the information has a simple value.
# + valueDateTime - The information determined as a result of making the observation, if the information has a simple value.
# + id - Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.
# + valueInteger - The information determined as a result of making the observation, if the information has a simple value.
# + valueQuantity - The information determined as a result of making the observation, if the information has a simple value.
@r4:DataTypeDefinition {
    name: "Device_Metric_Observation_ProfileComponent",
    baseType: (),
    elements: {
        "valueBoolean": {
            name: "valueBoolean",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "dataAbsentReason": {
            name: "dataAbsentReason",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Provides a reason why the expected value in the element Observation.component.value[x] is missing.",
            path: "Observation.component.dataAbsentReason"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.",
            path: "Observation.component.extension"
        },
        "valueTime": {
            name: "valueTime",
            dataType: r4:time,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "code": {
            name: "code",
            dataType: r4:CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            description: "Describes what was observed. Sometimes this is called the observation 'code'.",
            path: "Observation.component.code"
        },
        "valueRange": {
            name: "valueRange",
            dataType: r4:Range,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "May be used to represent additional information that is not part of the basic definition of the element and that modifies the understanding of the element in which it is contained and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).",
            path: "Observation.component.modifierExtension"
        },
        "valueCodeableConcept": {
            name: "valueCodeableConcept",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "valueRatio": {
            name: "valueRatio",
            dataType: r4:Ratio,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "valueString": {
            name: "valueString",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "interpretation": {
            name: "interpretation",
            dataType: r4:CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "A categorical assessment of an observation value. For example, high, low, normal.",
            path: "Observation.component.interpretation"
        },
        "valueSampledData": {
            name: "valueSampledData",
            dataType: r4:SampledData,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "valuePeriod": {
            name: "valuePeriod",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "valueDateTime": {
            name: "valueDateTime",
            dataType: r4:dateTime,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.",
            path: "Observation.component.id"
        },
        "valueInteger": {
            name: "valueInteger",
            dataType: r4:integer,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        },
        "valueQuantity": {
            name: "valueQuantity",
            dataType: r4:Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "The information determined as a result of making the observation, if the information has a simple value.",
            path: "Observation.component.value[x]"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type Device_Metric_Observation_ProfileComponent record {|
    *r4:BackboneElement;

    boolean valueBoolean?;
    r4:CodeableConcept dataAbsentReason?;
    r4:Extension[] extension?;
    r4:time valueTime?;
    r4:CodeableConcept code;
    r4:Range valueRange?;
    r4:Extension[] modifierExtension?;
    r4:CodeableConcept valueCodeableConcept?;
    r4:Ratio valueRatio?;
    string valueString?;
    r4:CodeableConcept[] interpretation?;
    r4:SampledData valueSampledData?;
    r4:Period valuePeriod?;
    r4:dateTime valueDateTime?;
    string id?;
    r4:integer valueInteger?;
    r4:Quantity valueQuantity?;
|};

