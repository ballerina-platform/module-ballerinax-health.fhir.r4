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

# Describes a required data item.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations 
# + 'type - The type of the required data  
# + profile - The profile of the required data 
# + subjectCodeableConcept - Patient, Practitioner, RelatedPerson, Organization, Location, Device 
# + subjectReference - Patient, Practitioner, RelatedPerson, Organization, Location, Device
# + mustSupport - Indicates specific structure elements that are referenced by the knowledge module 
# + codeFilter - What codes are expected  
# + dateFilter - What dates/date ranges are expected 
# + 'limit - Number of results  
# + sort - Order of the results
@DataTypeDefinition {
    name: "DataRequirement",
    baseType: Element,
    elements: {
        "type": {
            name: "type",
            dataType: code,
            min: 1,
            max: 1,
            isArray: false,
            description: "The type of the required data",
            valueSet: "https://hl7.org/fhir/valueset-all-types.html"
        },
        "profile": {
            name: "profile",
            dataType: canonical,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "The profile of the required data"
        },
        "subjectCodeableConcept": {
            name: "subjectCodeableConcept",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "E.g. Patient, Practitioner, RelatedPerson, Organization, Location, Device",
            valueSet: "https://hl7.org/fhir/valueset-subject-type.html"
        },
        "subjectReference": {
            name: "subjectReference",
            dataType: Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "E.g. Patient, Practitioner, RelatedPerson, Organization, Location, Device",
            valueSet: "https://hl7.org/fhir/valueset-subject-type.html"
        },
        "mustSupport": {
            name: "mustSupport",
            dataType: string,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Indicates specific structure elements that are referenced by the knowledge module"
        },
        "codeFilter": {
            name: "codeFilter",
            dataType: ElementCodeFilter,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "What codes are expected"
        },
        "dateFilter": {
            name: "dateFilter",
            dataType: ElementDateFilter,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "What dates/date ranges are expected"
        },
        "limit": {
            name: "limit",
            dataType: positiveInt,
            min: 0,
            max: 1,
            isArray: true,
            description: "Number of results"
        },
        "sort": {
            name: "sort",
            dataType: ElementSort,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Order of the results"
        }

    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    },
    validator: dataRequirementDataTypeValidationFunction
}

public type DataRequirement record {
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    code 'type;
    canonical[] profile?;
    CodeableConcept subjectCodeableConcept?;
    Reference subjectReference?;
    string[] mustSupport?;
    ElementCodeFilter[] codeFilter?;
    ElementDateFilter[] dateFilter?;
    positiveInt 'limit?;
    ElementSort[] sort?;

};

# This function validates the data type of the DataRequirement element
#
# + data - Data to be validated
# + elementContextDefinition - Element context definition
# + return - FHIRValidationError array if validation fails or else nil
public isolated function dataRequirementDataTypeValidationFunction(anydata data,
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
        CodeableConcept? subjectCodeableConceptVal = <CodeableConcept?>mapObj.get("subjectCodeableConcept");
        Reference? subjectReferenceVal = <Reference?>mapObj.get("subjectReference");

        boolean subjectCodeableConceptValCheck = subjectCodeableConceptVal is ();
        boolean subjectReferenceValCheck = subjectReferenceVal is ();
        boolean expression = (subjectCodeableConceptValCheck) && (!subjectReferenceValCheck) || 
                        (!subjectCodeableConceptValCheck) && (subjectReferenceValCheck);

        if (expression) {
            return;
        }
        else {
            string diagnosticMsg = "Error occurred due to incorrect definition of subject attribute in DataRequirement element according to FHIR Specification";
            return <FHIRValidationError>createInternalFHIRError(
                            "Error occurred due to incorrect data type definition", FATAL, PROCESSING,
                            diagnostic = diagnosticMsg);
        }

    }
}
