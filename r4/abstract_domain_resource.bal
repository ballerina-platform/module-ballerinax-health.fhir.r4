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

# A resource with narrative, extensions, and contained resources.
# * Rule: If the resource is contained in another resource, it SHALL NOT contain nested Resources.
# * Rule: If the resource is contained in another resource, it SHALL be referred to from elsewhere in the resource or SHALL refer to the containing resource
# * Rule: If a resource is contained in another resource, it SHALL NOT have a meta.versionId or a meta.lastUpdated.
# * Rule: If a resource is contained in another resource, it SHALL NOT have a security label.
# * Guideline: A resource should have narrative for robust management.
#
# + text - Text summary of the resource, for human interpretation
# + contained - Contained, inline Resources
# + extension - Additional content defined by implementations
# + modifierExtension - Extensions that cannot be ignored
@ResourceDefinition {
    resourceType: "DomainResource",
    baseType: Resource,
    profile: (),
    elements: {
        "text": {
            name: "text",
            dataType: Narrative,
            min: 0,
            max: 1,
            isArray: false,
            description: "Text summary of the resource, for human interpretation"
        },
        "contained": {
            name: "contained",
            dataType: Resource,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Contained, inline Resources"
        },
        "extension": {
            name: "extension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Additional content defined by implementations"
        },
        "modifierExtension": {
            name: "modifierExtension",
            dataType: Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: false,
            description: "Extensions that cannot be ignored"
        }
    },
    serializers: {
        'xml: fhirResourceXMLSerializer,
        'json: fhirResourceJsonSerializer
    }
}
public type DomainResource record {
    *Resource;
    Narrative text?;
    Resource[] contained?;
    Extension[] extension?;
    Extension[] modifierExtension?;
};
