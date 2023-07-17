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

public type Extension CodeableConceptExtension | ExtensionExtension | StringExtension | CodingExtension | CodeExtension | IntegerExtension
| CodeableConceptExtension | Base64BinaryExtension | BooleanExtension | CanonicalExtension | DateExtension | DateTimeExtension | DecimalExtension
| IdExtension | InstantExtension | Integer64Extension | MarkdownExtension | OidExtension | PositiveIntExtension | TimeExtension | UnsignedIntExtension
| UriExtension | UrlExtension | UuidExtension | AddressExtension | AgeExtension | AnnotationExtension | AttachmentExtension | CodeableReferenceExtension
| ContactPointExtension | CountExtension | DistanceExtension | DurationExtension | HumanNameExtension | IdentifierExtension | MoneyExtension
| PeriodExtension | QuantityExtension | RangeExtension | RatioExtension | RatioRangeExtension | ReferenceExtension | SampledDataExtension | SignatureExtension
| TimingExtension | ContactDetailExtension | DataRequirementExtension | ExpressionExtension | ParameterDefinitionExtension
| RelatedArtifactExtension | TriggerDefinitionExtension | UsageContextExtension | AvailabilityExtension | ExtendedContactDetailExtension | DosageExtension 
| MetaExtension;

# Every element in a resource or data type includes an optional "extension" child element that may be present
#  any number of times. 
#
# + url - identifies the meaning of the extension
# + extension - Additional content defined by implementations
@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url" : {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer, 
        'json: complexDataTypeJsonSerializer
    }
}
public type ExtensionExtension record {|
    *Element;

    uri url;
    Extension[] extension?;
|};

@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url" : {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueString" : {
            name: "valueString",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Value of extension"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer, 
        'json: complexDataTypeJsonSerializer
    }
}
public type StringExtension record {|
    uri url;
    string valueString;
|};

@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url" : {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueCoding" : {
            name: "valueCoding",
            dataType: Coding,
            min: 0,
            max: 1,
            isArray: false,
            description: "Value of extension"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer, 
        'json: complexDataTypeJsonSerializer
    }
}
public type CodingExtension record {|
    uri url;
    Coding valueCoding;
|};

@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url" : {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueCode" : {
            name: "valueCode",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "Value of extension"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer, 
        'json: complexDataTypeJsonSerializer
    }
}
public type CodeExtension record {|
    uri url;
    code valueCode;
|};

@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url" : {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueInteger" : {
            name: "valueInteger",
            dataType: integer,
            min: 0,
            max: 1,
            isArray: false,
            description: "Value of extension"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer, 
        'json: complexDataTypeJsonSerializer
    }
}
public type IntegerExtension record {|
    uri url;
    integer valueInteger;
|};

@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url" : {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueCodeableConcept" : {
            name: "valueCodeableConcept",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Value of extension"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer, 
        'json: complexDataTypeJsonSerializer
    }
}
public type CodeableConceptExtension record {|
    uri url;
    CodeableConcept valueCodeableConcept;
|};

public type Base64BinaryExtension record {|
    uri url;
    base64Binary valueBase64Binary; 
|};

public type BooleanExtension record {|
    uri url;
    boolean valueBoolean;
|};

public type CanonicalExtension record {|
    uri url;
    canonical valueCanonical;
|};

public type DateExtension record {|
    uri url;
    date valueDate;
|};

public type DateTimeExtension record {|
    uri url;
    dateTime valueDateTime;
|};

public type DecimalExtension record {|
    uri url;
    decimal valueDecimal;
|};

public type IdExtension record {|
    uri url;
    id valueId;
|};

public type InstantExtension record {|
    uri url;
    instant valueInstant;
|};

//generate extension record types for type valueInteger64
public type Integer64Extension record {|
    uri url;
    integer64 valueInteger64;
|};

public type MarkdownExtension record {|
    uri url;
    markdown valueMarkdown;
|};

public type OidExtension record {|
    uri url;
    oid valueOid;
|};

public type PositiveIntExtension record {|
    uri url;
    positiveInt valuePositiveInt;
|};

public type TimeExtension record {|
    uri url;
    time valueTime;
|};

public type UnsignedIntExtension record {|
    uri url;
    unsignedInt valueUnsignedInt;
|};

public type UriExtension record {|
    uri url;
    uri valueUri;
|};

public type UrlExtension record {|
    uri url;
    urlType valueUrl;
|};

public type UuidExtension record {|
    uri url;
    uuid valueUuid;
|};

public type AddressExtension record {|
    uri url;
    Address valueAddress;
|};

public type AgeExtension record {|
    uri url;
    Age valueAge;
|};

public type AnnotationExtension record {|
    uri url;
    Annotation valueAnnotation;
|};

public type AttachmentExtension record {|
    uri url;
    Attachment valueAttachment;
|};

public type CodeableReferenceExtension record {|
    uri url;
    CodeableReference valueCodeableReference;
|};

public type ContactPointExtension record {|
    uri url;
    ContactPoint valueContactPoint;
|};

public type CountExtension record {|
    uri url;
    Count valueCount;
|};

public type DistanceExtension record {|
    uri url;
    Distance valueDistance;
|};

public type DurationExtension record {|
    uri url;
    Duration valueDuration;
|};

public type HumanNameExtension record {|
    uri url;
    HumanName valueHumanName;
|};

public type IdentifierExtension record {|
    uri url;
    Identifier valueIdentifier;
|};

public type MoneyExtension record {|
    uri url;
    Money valueMoney;
|};

public type PeriodExtension record {|
    uri url;
    Period valuePeriod;
|};

public type QuantityExtension record {|
    uri url;
    Quantity valueQuantity;
|};

public type RangeExtension record {|
    uri url;
    Range valueRange;
|};

public type RatioExtension record {|
    uri url;
    Ratio valueRatio;
|};

public type RatioRangeExtension record {|
    uri url;
    RatioRange valueRatioRange;
|};

public type ReferenceExtension record {|
    uri url;
    Reference valueReference;
|};

public type SampledDataExtension record {|
    uri url;
    SampledData valueSampledData;
|};

public type SignatureExtension record {|
    uri url;
    Signature valueSignature;
|};

public type TimingExtension record {|
    uri url;
    Timing valueTiming;
|};

public type ContactDetailExtension record {|
    uri url;
    ContactDetail valueContactDetail;
|};

public type DataRequirementExtension record {|
    uri url;
    DataRequirement valueDataRequirement;
|};

public type ExpressionExtension record {|
    uri url;
    Expression valueExpression;
|};

public type ParameterDefinitionExtension record {|
    uri url;
    ParameterDefinition valueParameterDefinition;
|};

public type RelatedArtifactExtension record {|
    uri url;
    RelatedArtifact valueRelatedArtifact;
|};

public type TriggerDefinitionExtension record {|
    uri url;
    TriggerDefinition valueTriggerDefinition;
|};

public type UsageContextExtension record {|
    uri url;
    UsageContext valueUsageContext;
|};

public type AvailabilityExtension record {|
    uri url;
    Availability valueAvailability;
|};

public type ExtendedContactDetailExtension record {|
    uri url;
    ExtendedContactDetail valueExtendedContactDetail;
|};

public type DosageExtension record {|
    uri url;
    Dosage valueDosage;
|};

public type MetaExtension record {|
    uri url;
    Meta valueMeta;
|};

