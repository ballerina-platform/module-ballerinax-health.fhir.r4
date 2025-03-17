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

# A definition of a set of people that apply to some clinically related context, for example people contraindicated for a certain medication.
#
# + id - Unique id for inter-element referencing  
# + extension - Additional content defined by implementations
# + modifierExtension - Extensions that cannot be ignored even if unrecognized
# + ageRange - The age range of the specific population  
# + ageCodeableConcept - The age concept of the specific population  
# + gender - The gender of the specific population  
# + race - Race of the specific population  
# + physiologicalCondition - The existing physiological conditions of the specific population to which this applies
@DataTypeDefinition {
    name: "Population",
    baseType: BackboneElement,
    elements: {
        "ageRange": {
            name: "ageRange",
            dataType: Range,
            min: 0,
            max: 1,
            isArray: false,
            description: "The age range of the specific population"
        },
        "ageCodeableConcept": {
            name: "ageCodeableConcept",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The age defined concept of the specific population"
        },
        "gender": {
            name: "gender",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The gender of the specific population"
        },
        "race": {
            name: "race",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Race of the specific population"
        },
        "physiologicalCondition": {
            name: "physiologicalCondition",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The existing physiological conditions of the specific population to which this applies"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    },
    validator: populationDataTypeValidationFunction
}
public type Population record {|
    *BackboneElement;
    //Inherited child element from "BackboneElement" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    Extension[] modifierExtension?;
    //Inherited child element from "BackboneElement" (Redefining to maintain order when serialize) (END)

    Range ageRange?;
    CodeableConcept ageCodeableConcept?;
    CodeableConcept gender?;
    CodeableConcept race?;
    CodeableConcept physiologicalCondition?;

|};

public isolated function populationDataTypeValidationFunction(anydata data,
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
        Range? ageRangeVal = <Range?>mapObj.get("ageRange");
        CodeableConcept? ageCodeableConceptVal = <CodeableConcept?>mapObj.get("ageCodeableConcept");

        boolean ageRangeValCheck = ageRangeVal is ();
        boolean ageCodeableConceptValCheck = ageCodeableConceptVal is ();

        boolean expression = (ageRangeValCheck) && (!ageCodeableConceptValCheck)
                        || (!ageRangeValCheck) && (ageCodeableConceptValCheck);

        if (expression) {
            return;
        }
        else {
            string diagnosticMsg = "Error occurred due to incorrect definition of timing attribute " +
                            "of TriggerDefinition element according to FHIR Specificatio";
            return <FHIRValidationError>createInternalFHIRError(
                            "Error occurred due to incorrect data type definition", FATAL, PROCESSING,
                    diagnostic = diagnosticMsg);
        }
    }
}
