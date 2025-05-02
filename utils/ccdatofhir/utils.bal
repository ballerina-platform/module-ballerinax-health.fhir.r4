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

import ballerinax/health.fhir.r4;
import ballerina/log;

# getOperationOutcome - Returns an OperationOutcome resource with the given detail
#
# + detail - detail of the error
# + return - OperationOutcome resource
public isolated function getOperationOutcome(string detail) returns r4:OperationOutcome => {
    resourceType: "OperationOutcome",
    issue: [
        {
            severity: "error",
            code: "error",
            details: {
                text: detail
            }
        }
    ]
};

isolated function isXMLElementNotNull(xml? xmlElement) returns boolean => xmlElement is xml && xmlElement.length() > 0;

isolated function logAndThrowError(error err) returns error {
    log:printError("Error occurred while converting CCDA document.", err, stackTrace = err.stackTrace());
    return err;
}

# Retrieves an XML element by its ID attribute.
#
# + xmlElement - the XML element to search within
# + id - the ID of the element to find
# + return - the XML element with the specified ID, or null if not found
public isolated function getElementByID(xml xmlElement, string id) returns xml? {
    // First check immediate children
    xml filter = xmlElement.filter(x => x is xml:Element && x.getAttributes().hasKey("ID") && x.getAttributes().get("ID") == id);
    if (filter.length() > 0) {
        return filter[0];
    }
    
    // If not found in immediate children, recursively check all child elements
    xml children = xmlElement.children();
    foreach xml child in children {
        if (child is xml:Element) {
            xml? result = getElementByID(child, id);
            if (result is xml) {
                return result;
            }
        }
    }
    return ();
}
