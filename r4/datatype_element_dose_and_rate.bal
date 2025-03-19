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

# Amount of medication administered.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + 'type - The kind of dose or rate specified 
# + doseRange - Amount of medication per dose
# + doseQuantity - Amount of medication per dose 
# + rateRatio - Amount of medication per unit of time
# + rateRange - Amount of medication per unit of time 
# + rateQuantity - Amount of medication per unit of time
@DataTypeDefinition {
    name: "DoseAndRate",
    baseType: Element,
    elements: {
        "type": {
            name: "type",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The kind of dose or rate specified",
            valueSet: "https://hl7.org/fhir/valueset-dose-rate-type.html"
        },
        "doseRange": {
            name: "doseRange",
            dataType: Range,
            min: 0,
            max: 1,
            isArray: false,
            description: "Amount of medication per dose"
        },
        "doseQuantity": {
            name: "doseQuantity",
            dataType: SimpleQuantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Amount of medication per dose"
        },
        "rateRatio": {
            name: "rateRatio",
            dataType: Range,
            min: 0,
            max: 1,
            isArray: false,
            description: "Amount of medication per unit of time"
        },
        "rateRange": {
            name: "rateRange",
            dataType: Range,
            min: 0,
            max: 1,
            isArray: false,
            description: "Amount of medication per unit of time"
        },
        "rateQuantity": {
            name: "rateQuantity",
            dataType: SimpleQuantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Amount of medication per unit of time"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    },
    validator: doseAndRateDataTypeValidationFunction
}
public type ElementDoseAndRate record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    CodeableConcept 'type?;
    Range doseRange?;
    SimpleQuantity doseQuantity?;
    Ratio rateRatio?;
    Range rateRange?;
    SimpleQuantity rateQuantity?;
|};

# This function validates the data type of the DoseAndRate element
#
# + data - Data to be validated
# + elementContextDefinition - Element context definition
# + return - FHIRValidationError array if validation fails
public isolated function doseAndRateDataTypeValidationFunction(anydata data,
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
        Range? doseRangeVal = <Range?>mapObj.get("doseRange");
        SimpleQuantity? doseQuantityVal = <SimpleQuantity?>mapObj.get("doseQuantity");

        boolean doseRangeValCheck = doseRangeVal is ();
        boolean doseQuantityValCheck = doseQuantityVal is ();
        boolean expression = (doseRangeValCheck) && (!doseQuantityValCheck) || (!doseRangeValCheck) && (doseQuantityValCheck);

        Ratio? rateRatioVal = <Ratio?>mapObj.get("rateRatio");
        Range? rateRangeVal = <Range?>mapObj.get("rateRange");
        SimpleQuantity? rateQuantityVal = <SimpleQuantity?>mapObj.get("rateQuantity");

        boolean rateRatioValCheck = rateRatioVal is ();
        boolean rateRangeValCheck = rateRangeVal is ();
        boolean rateQuantityValCheck = rateQuantityVal is ();
        boolean expressionTwo = (rateRatioValCheck) && (rateRangeValCheck) && (!rateQuantityValCheck)
                        || (rateRatioValCheck) && (!rateRangeValCheck) && (rateQuantityValCheck) || (!rateRatioValCheck)
                        && (rateRangeValCheck) && (rateQuantityValCheck);

        if (expression) {
            if (expressionTwo) {
                return;
            }
            else {
                string diagnosticMsg = "Error occurred due to incorrect definition of rate attribute in DoseAndRate element according to FHIR Specification";
                return <FHIRValidationError>createInternalFHIRError(
                                "Error occurred due to incorrect data type definition", FATAL, PROCESSING,
                        diagnostic = diagnosticMsg);
            }
        }
        else {
            string diagnosticMsg = "Error occurred due to incorrect definition of dose attribute in DoseAndRate element according to FHIR Specification";
            return <FHIRValidationError>createInternalFHIRError(
                            "Error occurred due to incorrect data type definition", FATAL, PROCESSING,
                    diagnostic = diagnosticMsg);
        }
    }
}
