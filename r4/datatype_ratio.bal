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

# A ratio of two Quantity values - a numerator and a denominator
# Rule: Numerator and denominator SHALL both be present, or both are absent. If both are absent, 
# there SHALL be some extension present.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + numerator - Numerator value 
# + denominator - Denominator value
@DataTypeDefinition {
    name: "Range",
    baseType: Element,
    elements: {
        "numerator": {
            name: "numerator",
            dataType: SimpleQuantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Numerator value"
        },
        "denominator": {
            name: "denominator",
            dataType: SimpleQuantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Denominator value"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    },
    validator: ratioDataTypeValidationFunction
}
public type Ratio record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    SimpleQuantity numerator?;
    SimpleQuantity denominator?;
|};

public isolated function ratioDataTypeValidationFunction(anydata data,
        ElementAnnotationDefinition elementContextDefinition) returns (FHIRValidationError)? {
    DataTypeDefinitionRecord? dataTypeDefinition = (typeof data).@DataTypeDefinition;
    if dataTypeDefinition != () {
        map<anydata> mapObj = {};
        do {
            mapObj = check data.ensureType();
        } on fail error e {
            string diagnosticMsg = string `Error occurred while casting data of type: ${(typeof data).toBalString()} to map representation`;
            return <FHIRValidationError>createInternalFHIRError(
                            "Error occurred while casting data to map representation", FATAL, PROCESSING,
                    diagnostic = diagnosticMsg, cause = e);

        }
        SimpleQuantity? numeratorVal = <SimpleQuantity?>mapObj.get("numerator");
        SimpleQuantity? denominatorVal = <SimpleQuantity?>mapObj.get("denominator");

        boolean numeratorValCheck = numeratorVal is ();
        boolean denominatorValCheck = denominatorVal is ();
        boolean expression = (numeratorValCheck) && (denominatorValCheck) || (!numeratorValCheck) && (!denominatorValCheck);
        if (expression) {
            return;
        }
        else {
            string diagnosticMsg = "Error occurred due to incorrect definition of numerator or denominator " +
                            "attribute in Ratio element according to FHIR Specification";
            return <FHIRValidationError>createInternalFHIRError(
                            "Error occurred due to incorrect data type definition", FATAL, PROCESSING,
                    diagnostic = diagnosticMsg);
        }

    }
}
