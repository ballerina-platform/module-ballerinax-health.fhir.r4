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

# What dates/date ranges are expected.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + path - A date-valued attribute to filter on
# + searchParam - A date valued parameter to search on 
# + valueDateTime - The value of the filter, as a DateTime 
# + valuePeriod - The value of the filter, as a Period  
# + valueDuration - The value of the filter, as a Duration value
@DataTypeDefinition {
    name: "ElementDateFilter",
    baseType: Element,
    elements: {
        "path": {
            name: "path",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "A date-valued attribute to filter on"
        },
        "searchParam": {
            name: "searchParam",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "A date valued parameter to search on"
        },
        "valueDateTime": {
            name: "valueDateTime",
            dataType: dateTime,
            min: 0,
            max: 1,
            isArray: false,
            description: "The value of the filter, as a DateTime"
        },
        "valuePeriod": {
            name: "valuePeriod",
            dataType: Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "The value of the filter, as a Period"
        },
        "valueDuration": {
            name: "valueDuration",
            dataType: Duration,
            min: 0,
            max: 1,
            isArray: false,
            description: "The value of the filter, as a Duration value"
        }

    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    },
    validator: dataFilterDataTypeValidationFunction

}
public type ElementDateFilter record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    string path?;
    string searchParam?;
    dateTime valueDateTime?;
    Period valuePeriod?;
    Duration valueDuration?;

|};

# This function validates the data type definition of the ElementDateFilter record.
#
# + data - data to be validated
# + elementContextDefinition - element context definition
# + return - FHIRValidationError array or else nil
public isolated function dataFilterDataTypeValidationFunction(anydata data,
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
        dateTime? valueDateTimeVal = ();
        if mapObj.hasKey("valueDateTime") {
            valueDateTimeVal = <dateTime?>mapObj.get("valueDateTime");
        }
        Period? valuePeriodVal = ();
        if mapObj.hasKey("valuePeriod") {
            valuePeriodVal = <Period?>mapObj.get("valuePeriod");
        }
        Duration? valueDurationVal = ();
        if mapObj.hasKey("valueDuration") {
            valueDurationVal = <Duration?>mapObj.get("valueDuration");
        }
        boolean valueDateTimeValCheck = valueDateTimeVal is ();
        boolean valuePeriodValCheck = valuePeriodVal is ();
        boolean valueDurationValCheck = valueDurationVal is ();

        boolean expression = (valueDateTimeValCheck) && (valuePeriodValCheck) &&
                        (!valueDurationValCheck) || (valueDateTimeValCheck) && (!valuePeriodValCheck) &&
                        (valueDurationValCheck) || (!valueDateTimeValCheck) && (valuePeriodValCheck) &&
                        (valueDurationValCheck);

        if (expression) {
            return;
        }
        else {
            string diagnosticMsg = "Error occurred due to incorrect definition of value attribute in DataFilter element according to FHIR Specification";
            return <FHIRValidationError>createInternalFHIRError(
                            "Error occurred due to incorrect data type definition", FATAL, PROCESSING,
                    diagnostic = diagnosticMsg);
        }

    }

}
