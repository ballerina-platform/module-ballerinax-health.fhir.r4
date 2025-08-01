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

# When the event is to occur.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations 
# + boundsDuration - (Start and/or end) limits 
# + boundsRange - Range of lengths  
# + boundsPeriod - Range of lengths, or (Start and/or end) limits  
# + count - Number of times to repeat
# + countMax - Maximum number of times to repeat 
# + duration - How long when it happens  
# + durationMax - How long when it happens (Max)
# + durationUnit - Funit of time (UCUM) UnitsOfTime (Required)
# + frequency - Event occurs frequency times per period
# + frequencyMax - Event occurs up to frequencyMax times per period 
# + period - Event occurs frequency times per period
# + periodMax - Upper limit of period (3-4 hours)
# + periodUnit - unit of time (UCUM)UnitsOfTime (Required) 
# + dayOfWeek - DaysOfWeek (Required)
# + timeOfDay - Time of day for action
# + when - Code for time period of occurrence EventTiming (Required) 
# + offset - Minutes from event (before or after)
@DataTypeDefinition {
    name: "RepeatElement",
    baseType: Element,
    elements: {
        "boundsDuration": {
            name: "boundsDuration",
            dataType: Duration,
            min: 0,
            max: 1,
            isArray: false,
            description: "(Start and/or end) limits"
        },
        "boundsRange": {
            name: "boundsRange",
            dataType: Range,
            min: 0,
            max: 1,
            isArray: false,
            description: "Range of lengths"
        },
        "boundsPeriod": {
            name: "boundsPeriod",
            dataType: Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Range of lengths, or (Start and/or end) limits"
        },
        "count": {
            name: "count",
            dataType: positiveInt,
            min: 0,
            max: 1,
            isArray: false,
            description: "Number of times to repeat"
        },
        "countMax": {
            name: "countMax",
            dataType: positiveInt,
            min: 0,
            max: 1,
            isArray: false,
            description: "Maximum number of times to repeat"
        },
        "duration": {
            name: "duration",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "How long when it happens"
        },
        "durationMax": {
            name: "durationMax",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "How long when it happens (Max)"
        },
        "durationUnit": {
            name: "durationUnit",
            dataType: Element,
            min: 0,
            max: 1,
            isArray: false,
            description: "s | min | h | d | wk | mo | a - unit of time (UCUM) UnitsOfTime (Required)"
        },
        "frequency": {
            name: "frequency",
            dataType: positiveInt,
            min: 0,
            max: 1,
            isArray: false,
            description: "Event occurs frequency times per period"
        },
        "frequencyMax": {
            name: "frequencyMax",
            dataType: positiveInt,
            min: 0,
            max: 1,
            isArray: false,
            description: "Event occurs up to frequencyMax times per period"
        },
        "period": {
            name: "period",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "Event occurs frequency times per period"
        },
        "periodMax": {
            name: "periodMax",
            dataType: decimal,
            min: 0,
            max: 1,
            isArray: false,
            description: "Upper limit of period (3-4 hours)"
        },
        "periodUnit": {
            name: "periodUnit",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "s | min | h | d | wk | mo | a - unit of time (UCUM)UnitsOfTime (Required)"
        },
        "dayOfWeek": {
            name: "dayOfWeek",
            dataType: code,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "mon | tue | wed | thu | fri | sat | sun DaysOfWeek (Required)"
        },
        "timeOfDay": {
            name: "timeOfDay",
            dataType: time,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Time of day for action"
        },
        "when": {
            name: "when",
            dataType: code,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Code for time period of occurrence EventTiming (Required)",
            valueSet: "https://hl7.org/fhir/valueset-event-timing.html"
        },
        "offset": {
            name: "offset",
            dataType: unsignedInt,
            min: 0,
            max: 1,
            isArray: false,
            description: "Minutes from event (before or after)"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    },
    validator: repeatElementDataTypeValidationFunction

}

public type ElementRepeat record {
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    Duration boundsDuration?;
    Range boundsRange?;
    Period boundsPeriod?;
    positiveInt count?;
    positiveInt countMax?;
    decimal duration?;
    decimal durationMax?;
    Timecode durationUnit?;
    positiveInt frequency?;
    positiveInt frequencyMax?;
    decimal period?;
    decimal periodMax?;
    Timecode periodUnit?;
    Daycode[] dayOfWeek?;
    time[] timeOfDay?;
    code[] when?;
    unsignedInt offset?;

};

public enum Timecode {
    s,
    min,
    h,
    d,
    wk,
    mo,
    a
}

public enum Daycode {
    mon,
    tue,
    wed,
    thu,
    fri,
    sat,
    sun
}

# This function validates the data type of the element
#
# + data - data to be validated
# + elementContextDefinition - Element context definition
# + return - FHIRValidationError array if validation fails, else nil
public isolated function repeatElementDataTypeValidationFunction(anydata data,
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
        Duration? boundsDurationVal = ();
        if mapObj.hasKey("boundsDuration") {
            boundsDurationVal = <Duration?>mapObj.get("boundsDuration");
        }
        Range? boundsRangeVal = ();
        if mapObj.hasKey("boundsRange") {
            boundsRangeVal = <Range?>mapObj.get("boundsRange");
        }
        Period? boundsPeriodVal = ();
        if mapObj.hasKey("boundsPeriod") {
            boundsPeriodVal = <Period?>mapObj.get("boundsPeriod");
        }
        boolean boundsDurationValCheck = boundsDurationVal is ();
        boolean boundsRangeValCheck = boundsRangeVal is ();
        boolean boundsPeriodValCheck = boundsPeriodVal is ();

        boolean expression = (boundsDurationValCheck) && (boundsRangeValCheck) && (!boundsPeriodValCheck)
                        || (boundsDurationValCheck) && (!boundsRangeValCheck) && (boundsPeriodValCheck) || (!boundsDurationValCheck)
                        && (boundsRangeValCheck) && (boundsPeriodValCheck);

        if (expression) {
            return;
        }
        else {
            string diagnosticMsg = "Error occurred due to incorrect definition of bounds element according to FHIR Specificatio";
            return <FHIRValidationError>createInternalFHIRError(
                            "Error occurred due to incorrect data type definition", FATAL, PROCESSING,
                    diagnostic = diagnosticMsg);
        }

    }

}
