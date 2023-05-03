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

# Element values that are used to distinguish the slices.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + 'type - value | exists | pattern | type | profile  
# + path - Path to element value
@DataTypeDefinition {
    name: "ElementDiscriminator",
    baseType: Element,
    elements: {
        "type": {
            name: "type",
            dataType: ElementDiscriminatorType,
            min: 1,
            max: 1,
            isArray: false,
            description: "value | exists | pattern | type | profile",
            valueSet: "https://hl7.org/fhir/valueset-discriminator-type.html"
        },
        "path": {
            name: "path",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "Path to element value"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ElementDiscriminator record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    ElementDiscriminatorType 'type;
    string path;
|};

public enum ElementDiscriminatorType {
    value,
    exists,
    pattern,
    'type,
    profile
}
