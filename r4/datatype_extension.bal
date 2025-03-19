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

public type Extension CodeableConceptExtension|StringExtension|CodingExtension|CodeExtension|IntegerExtension
|Base64BinaryExtension|BooleanExtension|CanonicalExtension|DateExtension|DateTimeExtension|DecimalExtension
|IdExtension|InstantExtension|Integer64Extension|MarkdownExtension|OidExtension|PositiveIntExtension|TimeExtension|UnsignedIntExtension
|UriExtension|UrlExtension|UuidExtension|AddressExtension|AgeExtension|AnnotationExtension|AttachmentExtension|CodeableReferenceExtension
|ContactPointExtension|CountExtension|DistanceExtension|DurationExtension|HumanNameExtension|IdentifierExtension|MoneyExtension
|PeriodExtension|QuantityExtension|RangeExtension|RatioExtension|RatioRangeExtension|ReferenceExtension|SampledDataExtension|SignatureExtension
|TimingExtension|ContactDetailExtension|DataRequirementExtension|ExpressionExtension|ParameterDefinitionExtension
|RelatedArtifactExtension|TriggerDefinitionExtension|UsageContextExtension|AvailabilityExtension|ExtendedContactDetailExtension|DosageExtension
|MetaExtension|ExtensionExtension;

# Every element in a resource or data type includes an optional "extension" child element that may be present
# any number of times. 
#
# + url - identifies the meaning of the extension
# + extension - Additional content defined by implementations
@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url": {
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
        "url": {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueString": {
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
    *Element;

    uri url;
    string valueString;
|};

@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url": {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueCoding": {
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
    *Element;

    uri url;
    Coding valueCoding;
|};

@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url": {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueCode": {
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
    *Element;

    uri url;
    code valueCode;
|};

@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url": {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueInteger": {
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
    *Element;

    uri url;
    integer valueInteger;
|};

@DataTypeDefinition {
    name: "Extension",
    baseType: Element,
    elements: {
        "url": {
            name: "url",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "identifies the meaning of the extension"
        },
        "valueCodeableConcept": {
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
    *Element;

    uri url;
    CodeableConcept valueCodeableConcept;
|};

public type Base64BinaryExtension record {|
    *Element;

    uri url;
    base64Binary valueBase64Binary;
|};

public type BooleanExtension record {|
    *Element;

    uri url;
    boolean valueBoolean;
|};

public type CanonicalExtension record {|
    *Element;

    uri url;
    canonical valueCanonical;
|};

public type DateExtension record {|
    *Element;

    uri url;
    date valueDate;
|};

public type DateTimeExtension record {|
    *Element;

    uri url;
    dateTime valueDateTime;
|};

public type DecimalExtension record {|
    *Element;

    uri url;
    decimal valueDecimal;
|};

public type IdExtension record {|
    *Element;

    uri url;
    id valueId;
|};

public type InstantExtension record {|
    *Element;

    uri url;
    instant valueInstant;
|};

//generate extension record types for type valueInteger64
public type Integer64Extension record {|
    *Element;

    uri url;
    integer64 valueInteger64;
|};

public type MarkdownExtension record {|
    *Element;

    uri url;
    markdown valueMarkdown;
|};

public type OidExtension record {|
    *Element;

    uri url;
    oid valueOid;
|};

public type PositiveIntExtension record {|
    *Element;

    uri url;
    positiveInt valuePositiveInt;
|};

public type TimeExtension record {|
    *Element;

    uri url;
    time valueTime;
|};

public type UnsignedIntExtension record {|
    *Element;

    uri url;
    unsignedInt valueUnsignedInt;
|};

public type UriExtension record {|
    *Element;

    uri url;
    uri valueUri;
|};

public type UrlExtension record {|
    *Element;

    uri url;
    urlType valueUrl;
|};

public type UuidExtension record {|
    *Element;

    uri url;
    uuid valueUuid;
|};

public type AddressExtension record {|
    *Element;

    uri url;
    Address valueAddress;
|};

public type AgeExtension record {|
    *Element;

    uri url;
    Age valueAge;
|};

public type AnnotationExtension record {|
    *Element;

    uri url;
    Annotation valueAnnotation;
|};

public type AttachmentExtension record {|
    *Element;

    uri url;
    Attachment valueAttachment;
|};

public type CodeableReferenceExtension record {|
    *Element;

    uri url;
    CodeableReference valueCodeableReference;
|};

public type ContactPointExtension record {|
    *Element;

    uri url;
    ContactPoint valueContactPoint;
|};

public type CountExtension record {|
    *Element;

    uri url;
    Count valueCount;
|};

public type DistanceExtension record {|
    *Element;

    uri url;
    Distance valueDistance;
|};

public type DurationExtension record {|
    *Element;

    uri url;
    Duration valueDuration;
|};

public type HumanNameExtension record {|
    *Element;

    uri url;
    HumanName valueHumanName;
|};

public type IdentifierExtension record {|
    *Element;

    uri url;
    Identifier valueIdentifier;
|};

public type MoneyExtension record {|
    *Element;

    uri url;
    Money valueMoney;
|};

public type PeriodExtension record {|
    *Element;

    uri url;
    Period valuePeriod;
|};

public type QuantityExtension record {|
    *Element;

    uri url;
    Quantity valueQuantity;
|};

public type RangeExtension record {|
    *Element;

    uri url;
    Range valueRange;
|};

public type RatioExtension record {|
    *Element;

    uri url;
    Ratio valueRatio;
|};

public type RatioRangeExtension record {|
    *Element;

    uri url;
    RatioRange valueRatioRange;
|};

public type ReferenceExtension record {|
    *Element;

    uri url;
    Reference valueReference;
|};

public type SampledDataExtension record {|
    *Element;

    uri url;
    SampledData valueSampledData;
|};

public type SignatureExtension record {|
    *Element;

    uri url;
    Signature valueSignature;
|};

public type TimingExtension record {|
    *Element;

    uri url;
    Timing valueTiming;
|};

public type ContactDetailExtension record {|
    *Element;

    uri url;
    ContactDetail valueContactDetail;
|};

public type DataRequirementExtension record {|
    *Element;

    uri url;
    DataRequirement valueDataRequirement;
|};

public type ExpressionExtension record {|
    *Element;

    uri url;
    Expression valueExpression;
|};

public type ParameterDefinitionExtension record {|
    *Element;

    uri url;
    ParameterDefinition valueParameterDefinition;
|};

public type RelatedArtifactExtension record {|
    *Element;

    uri url;
    RelatedArtifact valueRelatedArtifact;
|};

public type TriggerDefinitionExtension record {|
    *Element;

    uri url;
    TriggerDefinition valueTriggerDefinition;
|};

public type UsageContextExtension record {|
    *Element;

    uri url;
    UsageContext valueUsageContext;
|};

public type AvailabilityExtension record {|
    *Element;

    uri url;
    Availability valueAvailability;
|};

public type ExtendedContactDetailExtension record {|
    *Element;

    uri url;
    ExtendedContactDetail valueExtendedContactDetail;
|};

public type DosageExtension record {|
    *Element;

    uri url;
    Dosage valueDosage;
|};

public type MetaExtension record {|
    *Element;

    uri url;
    Meta valueMeta;
|};

