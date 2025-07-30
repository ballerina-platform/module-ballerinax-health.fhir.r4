// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).
import ballerina/constraint;

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

# A measured or measurable amount
# Rule: If a code for the unit is present, the system SHALL also be present
# Elements defined in Ancestors: id, extension
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + value - Numerical value (with implicit precision)  
# + comparator - < | <= | >= | > - how to understand the value 
# + unit - Unit representation 
# + system - System that defines coded unit form 
# + code - Coded form of the unit
@DataTypeDefinition {
    name: "Quantity",
    baseType: Element,
    elements: {
        "value": {
            name: "value",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "Numerical value (with implicit precision)"
        },
        "comparator": {
            name: "comparator",
            dataType: QuantityComparatorCode,
            min: 0,
            max: 1,
            isArray: false,
            description: "< | <= | >= | > - how to understand the value",
            valueSet: "http://hl7.org/fhir/ValueSet/quantity-comparator"
        },
        "unit": {
            name: "unit",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unit representation"
        },
        "system": {
            name: "system",
            dataType: uri,
            min: 0,
            max: 1,
            isArray: false,
            description: "System that defines coded unit form"
        },
        "code": {
            name: "code",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Coded form of the unit"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type Quantity record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    decimal value?;
    @constraint:String {
        pattern: re`<|<=|>=|>`
    }
    string | QuantityComparatorCode comparator?;
    string unit?;
    uri system?;
    code code?;
|};

public type SimpleQuantity record {|
    *Quantity;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    decimal value?;
    string unit?;
    uri system?;
    code code?;
|};

public type Age record {|
    *Quantity;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    integer ageValue?;
    string unit?;
    uri system?;
    code code?;

|};

public type Distance record {|
    *Quantity;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    decimal distanceValue?;
    string unit?;
    uri system?;
    code code?;
|};

public type Duration record {|
    *Quantity;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    decimal durationValue?;
    string unit?;
    uri system?;
    code code?;
|};

public type Count record {|
    *Quantity;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    integer countValue?;
    string unit?;
    uri system?;
    code code?;
|};

public type MoneyQuantity record {|
    *Quantity;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    decimal moneyValue?;
    string unit?;
    uri system?;
    
    @constraint:String {
        pattern: re`<|<=|>=|>`
    }
    string | QuantityComparatorCode code?;
|};

public enum QuantityComparatorCode {
    LESS_THAN = "<",
    LESS_THAN_EQUAL = "<=",
    GREATER_THAN_EQUAL = ">=",
    GREATER_THAN = ">"
};
