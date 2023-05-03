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

# Condition that must evaluate to true.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + key - Target of 'condition' reference above 
# + requirements - Why this constraint is necessary or appropriate
# + severity - error | warning
# + human - Human description of constraint  
# + expression - FHIRPath expression of constraint  
# + xpath - XPath expression of constraint
# + 'source - Reference to original source of constraint
@DataTypeDefinition {
    name: "ElementConstraint",
    baseType: Element,
    elements: {
        "key": {
            name: "key",
            dataType: id,
            min: 1,
            max: 1,
            isArray: false,
            description: "Target of 'condition' reference above"
        },
        "requirements": {
            name: "requirements",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Why this constraint is necessary or appropriate"
        },
        "severity": {
            name: "severity",
            dataType: code,
            min: 1,
            max: 1,
            isArray: false,
            description: "error | warning",
            valueSet: "https://hl7.org/fhir/valueset-constraint-severity.html"
        },
        "human": {
            name: "human",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "Human description of constraint"
        },
        "expression": {
            name: "expression",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "FHIRPath expression of constraint"
        },
        "xpath": {
            name: "xpath",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "XPath expression of constraint"
        },
        "source": {
            name: "source",
            dataType: canonical,
            min: 0,
            max: 1,
            isArray: false,
            description: "Reference to original source of constraint"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ElementConstraint record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    id key;
    string requirements?;
    string severity;
    string human;
    string expression?;
    string xpath?;
    canonical 'source?;
|};
