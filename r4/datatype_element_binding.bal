// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).
import ballerina/constraint;

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

# ValueSet details if this is coded.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations 
# + strength - required | extensible | preferred | example  
# + description - Human explanation of the value set
# + valueSet - Source of value set
@DataTypeDefinition {
    name: "ElementBinding",
    baseType: Element,
    elements: {
        "strength": {
            name: "strength",
            dataType: StrengthCode,
            min: 1,
            max: 1,
            isArray: false,
            description: "required | extensible | preferred | example",
            valueSet: "https://hl7.org/fhir/valueset-binding-strength.html"
        },
        "description": {
            name: "description",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Human explanation of the value set"
        },
        "valueSet": {
            name: "valueSet",
            dataType: canonical,
            min: 0,
            max: 1,
            isArray: false,
            description: "Source of value set"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ElementBinding record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    @constraint:String{
        pattern: re`required|extensible|preferred|example`
    }
    string | StrengthCode strength;
    string description?;
    canonical valueSet?;
|};

public enum StrengthCode {
    required,
    extensible,
    preferred,
    example
}
