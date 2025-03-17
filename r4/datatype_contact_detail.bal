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

# The ContactDetail structure defines general contact details.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + name - Name of an individual to contact
# + telecom - Contact details for individual or organization
@DataTypeDefinition {
    name: "ContactDetail",
    baseType: Element,
    elements: {
        "name": {
            name: "name",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Name of an individual to contact"
        },
        "telecom": {
            name: "telecom",
            dataType: ContactPoint,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Contact details for individual or organization"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ContactDetail record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    string name?;
    ContactPoint[] telecom?;
|};
