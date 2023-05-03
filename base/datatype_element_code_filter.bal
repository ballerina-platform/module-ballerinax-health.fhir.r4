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

# What codes are expected.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + path - A code-valued attribute to filter on
# + searchParam - A coded (token) parameter to search on  
# + valueSet - Valueset for the filter 
# + code - What code is expected
@DataTypeDefinition {
    name: "ElementCodeFilter",
    baseType: Element,
    elements: {
        "path": {
            name: "path",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "A code-valued attribute to filter on"
        },
        "searchParam": {
            name: "searchParam",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded (token) parameter to search on"
        },
        "valueSet": {
            name: "valueSet",
            dataType: canonical,
            min: 0,
            max: 1,
            isArray: false,
            description: "Valueset for the filter"
        },
        "code": {
            name: "code",
            dataType: Coding,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "What code is expected"
        }

    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ElementCodeFilter record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    string path?;
    string searchParam?;
    canonical valueSet?;
    Coding[] code?;
|};
