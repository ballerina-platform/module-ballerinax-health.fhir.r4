// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).
import ballerina/constraint;

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

# Contributor information Elements defined in Ancestors: id, extension.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + 'type - author | editor | reviewer | endorser  ContributorType (Required)
# + name - Who contributed the content  
# + contact - Contact details of the contributor
@DataTypeDefinition {
    name: "Contributor",
    baseType: Element,
    elements: {
        "type": {
            name: "type",
            dataType: code,
            min: 1,
            max: 1,
            isArray: false,
            description: "author | editor | reviewer | endorser"
        },
        "name": {
            name: "name",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "Who contributed the content"
        },
        "contact": {
            name: "contact",
            dataType: ContactDetail,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Contact details of the contributor"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type Contributor record {|
    *Element;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    @constraint:String {
        pattern: re`author|editor|reviewer|endorser`
    }
    string | ContributorType 'type;
    string name;
    ContactDetail[] contact?;
|};

public enum ContributorType {
    author,
    editor,
    reviewer,
    endorser
}
