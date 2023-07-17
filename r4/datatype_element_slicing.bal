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

# This element is sliced - slices follow.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations 
# + discriminator - Element values that are used to distinguish the slices 
# + description - Text description of how slicing works (or not)
# + ordered - If elements must be in same order as slices 
# + rules - closed | open | openAtEnd
@DataTypeDefinition {
    name: "ElementSlicing",
    baseType: Element,
    elements: {
        "discriminator": {
            name: "discriminator",
            dataType: ElementDiscriminator,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Element values that are used to distinguish the slices"
        },
        "description": {
            name: "description",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Text description of how slicing works (or not)"
        },
        "ordered": {
            name: "ordered",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            description: "If elements must be in same order as slices"
        },
        "rules": {
            name: "rules",
            dataType: ElementSlicingRules,
            min: 1,
            max: 1,
            isArray: false,
            description: "closed | open | openAtEnd",
            valueSet: "https://hl7.org/fhir/valueset-resource-slicing-rules.html"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ElementSlicing record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    ElementDiscriminator[] discriminator?;
    string description?;
    boolean ordered?;
    ElementSlicingRules rules;

|};

public enum ElementSlicingRules {
    closed,
    open,
    openAtEnd
}
