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

# Base Resource.
#
# + resourceType - Type of resource
# + id - Logical id of this artifact 
# + meta - Metadata about the resource
# + implicitRules - A set of rules under which this content was created
# + language - Language of the resource content Common Languages(http://hl7.org/fhir/valueset-languages.html) (Preferred but limited to AllLanguages)
@ResourceDefinition {
    resourceType: "Resource",
    profile: (),
    baseType: (),
    elements: {
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Logical id of this artifact"
        },
        "meta": {
            name: "meta",
            dataType: Meta,
            min: 0,
            max: 1,
            isArray: false,
            description: "Metadata about the resource"
        },
        "implicitRules": {
            name: "implicitRules",
            dataType: uri,
            min: 0,
            max: 1,
            isArray: false,
            description: "A set of rules under which this content was created"
        },
        "language": {
            name: "language",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "Language of the resource content Common Languages(http://hl7.org/fhir/valueset-languages.html) (Preferred but limited to AllLanguages)"
        }
    },
    serializers: {
        'xml: fhirResourceXMLSerializer,
        'json: fhirResourceJsonSerializer
    }
}
public type Resource record {
    string resourceType;
    string id?;
    Meta meta?;
    uri implicitRules?;
    code language?;
};
