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


public const string PROFILE_BASE_DEVICEUSESTATEMENT = "http://hl7.org/fhir/StructureDefinition/DeviceUseStatement";
public const RESOURCE_NAME_DEVICEUSESTATEMENT = "DeviceUseStatement";

# FHIR DeviceUseStatement resource record.
#
# + resourceType - The type of the resource describes
# + identifier - An external identifier for this statement such as an IRI.
# + note - Details about the device statement that were not represented at all or sufficiently in one of the attributes provided in a class. These may include for example a comment, an instruction, or a note associated with the statement.
# + extension - May be used to represent additional information that is not part of the basic definition of the resource. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer can define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
# + timingTiming - How often the device was used.
# + timingPeriod - How often the device was used.
# + subject - The patient who used the device.
# + modifierExtension - May be used to represent additional information that is not part of the basic definition of the resource and that modifies the understanding of the element that contains it and/or the understanding of the containing element's descendants. Usually modifier elements provide negation or qualification. To make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions. Modifier extensions SHALL NOT change the meaning of any elements on Resource or DomainResource (including cannot change the meaning of modifierExtension itself).
# + reasonReference - Indicates another resource whose existence justifies this DeviceUseStatement.
# + language - The base language in which the resource is written.
# + 'source - Who reported the device was being used by the patient.
# + bodySite - Indicates the anotomic location on the subject's body where the device was used ( i.e. the target).
# + contained - These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
# + meta - The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content might not always be associated with version changes to the resource.
# + derivedFrom - Allows linking the DeviceUseStatement to the underlying Request, or to other information that supports or is used to derive the DeviceUseStatement.
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content. Often, this is a reference to an implementation guide that defines the special rules along with other profiles etc.
# + recordedOn - The time at which the statement was made/recorded.
# + id - The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
# + reasonCode - Reason or justification for the use of the device.
# + text - A human-readable narrative that contains a summary of the resource and can be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it 'clinically safe' for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
# + device - The details of the device used.
# + basedOn - A plan, proposal or order that is fulfilled in whole or in part by this DeviceUseStatement.
# + status - A code representing the patient or other source's judgment about the state of the device used that this statement is about. Generally this will be active or completed.
# + timingDateTime - How often the device was used.
@ResourceDefinition {
    resourceType: "DeviceUseStatement",
    baseType: DomainResource,
    profile: "http://hl7.org/fhir/StructureDefinition/DeviceUseStatement",
    elements: {
        "identifier" : {
            name: "identifier",
            dataType: Identifier,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "DeviceUseStatement.identifier"
        },
        "note" : {
            name: "note",
            dataType: Annotation,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "DeviceUseStatement.note"
        },
        "extension" : {
            name: "extension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "DeviceUseStatement.extension"
        },
        "timingTiming" : {
            name: "timingTiming",
            dataType: Timing,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.timing[x]"
        },
        "timingPeriod" : {
            name: "timingPeriod",
            dataType: Period,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.timing[x]"
        },
        "subject" : {
            name: "subject",
            dataType: Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.subject"
        },
        "modifierExtension" : {
            name: "modifierExtension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "DeviceUseStatement.modifierExtension"
        },
        "reasonReference" : {
            name: "reasonReference",
            dataType: Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "DeviceUseStatement.reasonReference"
        },
        "language" : {
            name: "language",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "source" : {
            name: "source",
            dataType: Reference,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.source"
        },
        "bodySite" : {
            name: "bodySite",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.bodySite",
            valueSet: "http://hl7.org/fhir/ValueSet/body-site"
        },
        "contained" : {
            name: "contained",
            dataType: Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "DeviceUseStatement.contained"
        },
        "meta" : {
            name: "meta",
            dataType: Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.meta"
        },
        "derivedFrom" : {
            name: "derivedFrom",
            dataType: Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "DeviceUseStatement.derivedFrom"
        },
        "implicitRules" : {
            name: "implicitRules",
            dataType: uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.implicitRules"
        },
        "recordedOn" : {
            name: "recordedOn",
            dataType: dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.recordedOn"
        },
        "id" : {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.id"
        },
        "reasonCode" : {
            name: "reasonCode",
            dataType: CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "DeviceUseStatement.reasonCode"
        },
        "text" : {
            name: "text",
            dataType: Narrative,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.text"
        },
        "device" : {
            name: "device",
            dataType: Reference,
            min: 1,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.device"
        },
        "basedOn" : {
            name: "basedOn",
            dataType: Reference,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            path: "DeviceUseStatement.basedOn"
        },
        "status" : {
            name: "status",
            dataType: DeviceUseStatementStatus,
            min: 1,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.status",
            valueSet: "http://hl7.org/fhir/ValueSet/device-statement-status|4.0.1"
        },
        "timingDateTime" : {
            name: "timingDateTime",
            dataType: dateTime,
            min: 0,
            max: 1,
            isArray: false,
            path: "DeviceUseStatement.timing[x]"
        }
    },
    serializers: {
        'xml: fhirResourceXMLSerializer,
        'json: fhirResourceJsonSerializer
    }
}
public type DeviceUseStatement record {|
    *DomainResource;

    RESOURCE_NAME_DEVICEUSESTATEMENT resourceType = RESOURCE_NAME_DEVICEUSESTATEMENT;

    BaseDeviceUseStatementMeta meta = {
        profile : [PROFILE_BASE_DEVICEUSESTATEMENT]
    };
    Identifier[] identifier?;
    Annotation[] note?;
    Extension[] extension?;
    Timing timingTiming?;
    Period timingPeriod?;
    Reference subject;
    Extension[] modifierExtension?;
    Reference[] reasonReference?;
    code language?;
    Reference 'source?;
    CodeableConcept bodySite?;
    Resource[] contained?;
    Reference[] derivedFrom?;
    uri implicitRules?;
    dateTime recordedOn?;
    string id?;
    CodeableConcept[] reasonCode?;
    Narrative text?;
    Reference device;
    Reference[] basedOn?;
    DeviceUseStatementStatus status;
    dateTime timingDateTime?;
|};

@DataTypeDefinition {
    name: "BaseDeviceUseStatementMeta",
    baseType: Meta,
    elements: {},
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type BaseDeviceUseStatementMeta record {|
    *Meta;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    id versionId?;
    instant lastUpdated?;
    uri 'source?;
    canonical[] profile = ["http://hl7.org/fhir/StructureDefinition/DeviceUseStatement"];
    Coding[] security?;
    Coding[] tag?;
|};

# DeviceUseStatementStatus enum
public enum DeviceUseStatementStatus {
   CODE_STATUS_ACTIVE = "active",
   CODE_STATUS_COMPLETED = "completed",
   CODE_STATUS_ENTERED_IN_ERROR = "entered-in-error"
}

