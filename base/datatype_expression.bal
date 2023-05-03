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

# An expression that can be used to generate a value.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations 
# + description - Natural language description of the condition  
# + name - Short name assigned to expression for reuse 
# + language - text/cql | text/fhirpath | application/x-fhir-query | text/cql-identifier | text/cql-expression | etc.
# + expression - Expression in specified language  
# + reference - Where the expression is found
@DataTypeDefinition {
    name: "Expression",
    baseType: Element,
    elements: {
        "description": {
            name: "description",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Natural language description of the condition"
        },
        "name": {
            name: "name",
            dataType: id,
            min: 0,
            max: 1,
            isArray: false,
            description: "Short name assigned to expression for reuse"
        },
        "language": {
            name: "language",
            dataType: code,
            min: 1,
            max: 1,
            isArray: false,
            description: "text/cql | text/fhirpath | application/x-fhir-query | text/cql-identifier | text/cql-expression | etc.",
            valueSet: "https://hl7.org/fhir/valueset-expression-language.html"
        },
        "expression": {
            name: "expression",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Expression in specified language"
        },
        "reference": {
            name: "reference",
            dataType: uri,
            min: 0,
            max: 1,
            isArray: false,
            description: "Where the expression is found"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}

public type Expression record {
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    string description?;
    id name?;
    code language;
    string expression?;
    uri reference?;

};
