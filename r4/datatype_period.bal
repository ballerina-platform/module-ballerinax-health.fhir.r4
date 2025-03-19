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

# A time period defined by a start and end date/time. 
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations 
# + 'start - Starting time with inclusive boundary  
# + end - End time with inclusive boundary, if not ongoing
@DataTypeDefinition {
    name: "Period",
    baseType: Element,
    elements: {
        "start": {
            name: "start",
            dataType: dateTime,
            min: 0,
            max: 1,
            isArray: false,
            description: "Starting time with inclusive boundary"
        },
        "end": {
            name: "end",
            dataType: dateTime,
            min: 0,
            max: 1,
            isArray: false,
            description: "End time with inclusive boundary, if not ongoing"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type Period record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    dateTime 'start?;
    dateTime end?;
|};
