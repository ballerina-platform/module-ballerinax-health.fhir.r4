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

# A Coding is a representation of a defined concept using a symbol from a defined "code system".
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + system - Identity of the terminology system  
# + 'version - Version of the system - if relevant
# + code - Symbol in syntax defined by the system  
# + display - Representation defined by the system  
# + userSelected - If this coding was chosen directly by the user
@DataTypeDefinition {
    name: "Coding",
    baseType: Element,
    elements: {
        "system": {
            name: "system",
            dataType: uri,
            min: 0,
            max: 1,
            isArray: false,
            description: "Identity of the terminology system"
        },
        "version": {
            name: "version",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Version of the system - if relevant"
        },
        "code": {
            name: "code",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "Symbol in syntax defined by the system"
        },
        "display": {
            name: "display",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Representation defined by the system"
        },
        "userSelected": {
            name: "userSelected",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            description: "If this coding was chosen directly by the user"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type Coding record {|
    *Element;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    uri system?;
    string 'version?;
    code code?;
    string display?;
    boolean userSelected?;
|};
