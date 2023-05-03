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

# A series of measurements taken by a device
# Elements defined in Ancestors: id, extension.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + origin - Zero value and units  
# + period - Number of milliseconds between samples 
# + factor - Multiply data by this before adding to origin  
# + lowerLimit - Lower limit of detection  
# + upperLimit - Upper limit of detection  
# + dimensions - Number of sample points at each time point  
# + data - Decimal values with spaces, or E | U | L 
@DataTypeDefinition {
    name: "SimpleData",
    baseType: Element,
    elements: {
        "origin": {
            name: "origin",
            dataType: SimpleQuantity,
            min: 1,
            max: 1,
            isArray: false,
            description: "Zero value and units"
        },
        "period": {
            name: "period",
            dataType: decimal,
            min: 1,
            max: 1,
            isArray: false,
            description: "Number of milliseconds between samples"
        },
        "factor": {
            name: "denominator",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "Multiply data by this before adding to origin"
        },
        "lowerLimit": {
            name: "lowerLimit",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "Lower limit of detection"
        },
        "upperLimit": {
            name: "upperLimit",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "Upper limit of detection"
        },
        "dimensions": {
            name: "dimensions",
            dataType: positiveInt,
            min: 0,
            max: 1,
            isArray: false,
            description: "Number of sample points at each time point"
        },
        "data": {
            name: "data",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Decimal values with spaces, or E | U | L "
        }

    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}

public type SimpleData record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    SimpleQuantity origin?;
    decimal period?;
    decimal factor?;
    decimal lowerLimit?;
    decimal upperLimit?;
    positiveInt dimensions;
    string data?;

|};
