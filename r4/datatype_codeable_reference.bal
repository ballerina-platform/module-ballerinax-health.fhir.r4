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

# Reference to a resource or a concept.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations  
# + concept - Reference to a concept (by class)
# + reference - Reference to a resource (by instance)
@DataTypeDefinition {
    name: "CodeableReference",
    baseType: Element,
    elements: {
        "concept": {
            name: "concept",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Reference to a concept (by class)"
        },
        "reference": {
            name: "reference",
            dataType: Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Reference to a resource (by instance)"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type CodeableReference record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    CodeableConcept concept?;
    Reference reference?;
|};
