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

@DataTypeDefinition {
    name: "Availability",
    baseType: Element,
    elements: {
        "availableTime": {
            name: "availableTime",
            dataType: AvailableTime,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Times the Service Site is available"
        },
        "notAvailableTime": {
            name: "notAvailableTime",
            dataType: NotAvailableTime,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Not available this time due to provided reason"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type Availability record {|
    AvailableTime[] availableTime?;
    NotAvailableTime[] notAvailableTime?;
|};

@DataTypeDefinition {
    name: "AvailableTime",
    baseType: Element,
    elements: {
        "daysOfWeek": {
            name: "daysOfWeek",
            dataType: code,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            description: "mon | tue | wed | thu | fri | sat | sun",
            valueSet: "http://hl7.org/fhir/ValueSet/days-of-week"
        },
        "allDay": {
            name: "allDay",
            dataType: boolean,
            min: 0,
            max: 1,
            isArray: false,
            description: "Always available? e.g. 24 hour service"
        },
        "availableStartTime": {
            name: "availableStartTime",
            dataType: time,
            min: 0,
            max: 1,
            isArray: false,
            description: "Opening time of day (ignored if allDay = true)"
        },
        "availableEndTime": {
            name: "availableEndTime",
            dataType: time,
            min: 0,
            max: 1,
            isArray: false,
            description: "Closing time of day (ignored if allDay = true)"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type AvailableTime record {|
    *Element;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    string daysOfWeek?;
    string allDay?;
    string availableStartTime?;
    string availableEndTime?;
|};

@DataTypeDefinition {
    name: "NotAvailableTime",
    baseType: Element,
    elements: {
        "description": {
            name: "description",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Reason presented to the user explaining why time not available"
        },
        "during": {
            name: "during",
            dataType: Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Service not available from this date"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type NotAvailableTime record {|
    *Element;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    string description?;
    Period during?;
|};
