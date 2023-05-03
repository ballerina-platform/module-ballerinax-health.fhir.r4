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

# Order of the results.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations 
# + path - The name of the attribute to perform the sort 
# + direction - ascending | descending
@DataTypeDefinition {
    name: "ElementSort",
    baseType: Element,
    elements: {
        "path": {
            name: "path",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The name of the attribute to perform the sort"
        },
        "direction	": {
            name: "direction",
            dataType: DirectionCode,
            min: 1,
            max: 1,
            isArray: false,
            description: "ascending | descending"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ElementSort record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    string path;
    DirectionCode direction;
|};

public enum DirectionCode {
    'ascending,
    'descending
}
