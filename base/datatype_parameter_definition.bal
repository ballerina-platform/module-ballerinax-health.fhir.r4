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

# Definition of a parameter to a module.
#
# + id - Unique id for the element within a resource (for internal references) 
# + extension - Additional Content defined by implementations
# + name - Name used to access the parameter value  
# + use - in | out  
# + min - Minimum cardinality  
# + max - Maximum cardinality (a number of *)  
# + documentation - A brief description of the parameter 
# + 'type - What type of value  
# + profile - What profile the value is expected to be
@DataTypeDefinition {
    name: "ParameterDefinition",
    baseType: Element,
    elements: {
        "name": {
            name: "name",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "Name used to access the parameter value"
        },
        "use": {
            name: "use",
            dataType: code,
            min: 1,
            max: 1,
            isArray: false,
            description: "in | out",
            valueSet: "https://hl7.org/fhir/valueset-operation-parameter-use.html"
        },
        "min": {
            name: "min",
            dataType: integer,
            min: 0,
            max: 1,
            isArray: false,
            description: "Minimum cardinality"
        },
        "max": {
            name: "max",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Maximum cardinality (a number of *)"
        },
        "documentation": {
            name: "documentation",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "A brief description of the parameter"
        },
        "type": {
            name: "type",
            dataType: code,
            min: 1,
            max: 1,
            isArray: false,
            description: "What type of value",
            valueSet: "https://hl7.org/fhir/valueset-all-types.html"
        },
        "profile": {
            name: "profile",
            dataType: canonical,
            min: 0,
            max: 1,
            isArray: false,
            description: "What profile the value is expected to be"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ParameterDefinition record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    code name?;
    ParameterDefinitionUse use;
    integer min?;
    string max?;
    string documentation?;
    code 'type;
    canonical profile?;

|};

public enum ParameterDefinitionUse {
    'in,
    out
}
