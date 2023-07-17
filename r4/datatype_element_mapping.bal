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

# Map element to another set of definitions.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations 
# + identity - Reference to mapping declaration  
# + language - Computable language of mapping 
# + 'map - Details of the mapping
# + comment - Comments about the mapping or its use
@DataTypeDefinition {
    name: "Range",
    baseType: Element,
    elements: {
        "identity": {
            name: "identity",
            dataType: id,
            min: 1,
            max: 1,
            isArray: false,
            description: "Reference to mapping declaration"
        },
        "language": {
            name: "language",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "Computable language of mapping",
            valueSet: "https://hl7.org/fhir/valueset-mimetypes.html"
        },
        "map": {
            name: "map",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "Details of the mapping"
        },
        "comment": {
            name: "comment",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Comments about the mapping or its use"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ElementMapping record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    id identity;
    code language?;
    string 'map;
    string comment?;
|};
