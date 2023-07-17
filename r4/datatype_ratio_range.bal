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

# DesRange of ratio values
# Rule: One of lowNumerator or highNumerator and denominator SHALL be present, or all are absent. 
# If all are absent, there SHALL be some extension present
# Rule: If present, lowNumerator SHALL have a lower value than highNumerator Elements 
# defined in Ancestors: id, extensioncription.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + lowNumerator - Low Numerator value 
# + highNumerator - High Numerator value
# + denominator - Denominator value
@DataTypeDefinition {
    name: "RangeRatio",
    baseType: Element,
    elements: {
        "lowNumerator": {
            name: "lowNumerator",
            dataType: SimpleQuantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Low Numerator value"
        },
        "highNumerator": {
            name: "highNumerator",
            dataType: SimpleQuantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "High Numerator value"
        },
        "denominator": {
            name: "denominator",
            dataType: SimpleQuantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Denominator value"
        }

    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type RatioRange record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    SimpleQuantity highNumerator?;
    SimpleQuantity lowNumerator?;
    SimpleQuantity denominator?;
|};
