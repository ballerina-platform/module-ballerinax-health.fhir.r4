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

# A CodeableConcept represents a value that is usually supplied by providing a reference to one or more terminologies or 
# ontologies but may also be defined by the provision of text.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + coding - Code defined by a terminology system  
# + text - Plain text representation of the concept
@DataTypeDefinition {
    name: "CodeableConcept",
    baseType: Element,
    elements: {
        "coding": {
            name: "coding",
            dataType: Coding,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Code defined by a terminology system"
        },
        "text": {
            name: "text",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Plain text representation of the concept"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type CodeableConcept record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    Coding[] coding?;
    string text?;
|};
