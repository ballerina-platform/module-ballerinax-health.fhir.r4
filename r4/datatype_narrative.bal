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

# Human-readable summary of the resource (essential clinical and business information).
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + status - [generated | extensions | additional | empty] NarrativeStatus(http://hl7.org/fhir/valueset-narrative-status.html) (Required)  
# + div - Limited xhtml content
# * Rule: The narrative SHALL contain only the basic html formatting elements and attributes described in 
# chapters 7-11 (except section 4 of chapter 9) and 15 of the HTML 4.0 standard, <a> elements 
# (either name or href), images and internally contained style attributes
# * Rule: The narrative SHALL have some non-whitespace content
@DataTypeDefinition {
    name: "Narrative",
    baseType: Element,
    elements: {
        "status": {
            name: "status",
            dataType: code,
            min: 1,
            max: 1,
            isArray: false,
            description: "[generated | extensions | additional | empty] NarrativeStatus(http://hl7.org/fhir/valueset-narrative-status.html) (Required)"
        },
        "div": {
            name: "div",
            dataType: xhtml,
            min: 1,
            max: 1,
            isArray: false,
            description: "Limited xhtml content"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type Narrative record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    StatusCode status;
    xhtml div;
|};

public enum StatusCode {
    generated, extensions, additional, empty
}
