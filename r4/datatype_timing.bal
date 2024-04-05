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

# A timing schedule that specifies an event that may occur multiple times.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + event - When the event occurs
# + repeat - When the event is to occur  
# + code - BID | TID | QID | AM | PM | QD | QOD | + TimingAbbreviation (Preferred)
@DataTypeDefinition {
    name: "Timing",
    baseType: BackboneElement,
    elements: {
        "event": {
            name: "event",
            dataType: dateTime,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "When the event occurs"
        },
        "repeat": {
            name: "repeat",
            dataType: ElementRepeat,
            min: 0,
            max: 1,
            isArray: false,
            description: "When the event is to occur" +
            "+ Rule: if there's a duration, there needs to be duration units" +
            "+ Rule: if there's a period, there needs to be period units" +
            "+ Rule: duration SHALL be a non-negative value" +
            "+ Rule: period SHALL be a non-negative value" +
            "+ Rule: If there's a periodMax, there must be a period" +
            "+ Rule: If there's a durationMax, there must be a duration" +
            "+ Rule: If there's a countMax, there must be a count" +
            "+ Rule: If there's an offset, there must be a when (and not C, CM, CD, CV)" +
            "+ Rule: If there's a timeOfDay, there cannot be a when, or vice versa"
        },
        "code": {
            name: "code",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "BID | TID | QID | AM | PM | QD | QOD | + TimingAbbreviation (Preferred)",
            valueSet: "https://hl7.org/fhir/valueset-timing-abbreviation.html"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}

public type Timing record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    dateTime[] event?;
    ElementRepeat repeat?;
    CodeableConcept code?;

|};

public enum RepeatCode {
    BID,
    TID,
    QID,
    AM,
    PM,
    QD,
    QOD,
    Q1H,
    Q2H,
    Q3H,
    Q4H,
    Q6H,
    Q8H,
    BED,
    WK,
    MO
}
