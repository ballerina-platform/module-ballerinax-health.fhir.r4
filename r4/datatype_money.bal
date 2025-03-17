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

# An amount of economic utility in some recognized currency.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + value - Numerical value (with implicit precision)
# + currency - ISO 4217 Currency Code (Required) (https://hl7.org/fhir/valueset-currencies.html)
@DataTypeDefinition {
    name: "Money",
    baseType: Element,
    elements: {
        "value": {
            name: "value",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "Numerical value (with implicit precision)"
        },
        "currency": {
            name: "currency",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "ISO 4217 Currency Code",
            valueSet: "https://hl7.org/fhir/valueset-currencies.html"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}

public type Money record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    decimal value?;
    code currency?;
|};
