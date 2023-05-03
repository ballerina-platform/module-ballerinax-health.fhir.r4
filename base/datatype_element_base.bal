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

# Base definition information for tools.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + path - Path that identifies the base element  
# + min - Min cardinality of the base element 
# + max - Max cardinality of the base element
@DataTypeDefinition {
    name: "ElementBase",
    baseType: Element,
    elements: {
        "path": {
            name: "path",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "Path that identifies the base element"
        },
        "min": {
            name: "min",
            dataType: unsignedInt,
            min: 1,
            max: 1,
            isArray: false,
            description: "Min cardinality of the base element"
        },
        "max": {
            name: "max",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "Max cardinality of the base element"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ElementBase record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    string path;
    unsignedInt min;
    string max;
|};
