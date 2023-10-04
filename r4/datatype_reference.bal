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

# A reference from one resource to another.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations 
# + reference - Literal reference, Relative, internal or absolute URL  
# * Rule : SHALL have a contained resource if a local reference is provided
# + 'type - Type the reference refers to (e.g. Patient) ResourceType(http://hl7.org/fhir/valueset-resource-types.html) (Extensible)  
# + identifier - Logical reference, when literal reference is not known  
# + display - Text alternative for the resource
@DataTypeDefinition {
    name: "Reference",
    baseType: Element,
    elements: {
        "reference": {
            name: "reference",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Literal reference, Relative, internal or absolute URL"
        },
        "type": {
            name: "type",
            dataType: uri,
            min: 0,
            max: 1,
            isArray: false,
            description: "Type the reference refers to (e.g. Patient)",
            valueSet: "http://hl7.org/fhir/valueset-resource-types.html"
        },
        "identifier": {
            name: "identifier",
            dataType: Identifier,
            min: 0,
            max: 1,
            isArray: false,
            description: "Logical reference, when literal reference is not known"
        },
        "display": {
            name: "display",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Text alternative for the resource"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type Reference record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    string reference?;
    string 'type?;
    Identifier identifier?;
    string display?;
|};

# Create a relative Reference to FHIR Resource.
#
# + referenceResourceModel - FHIR Resource model of the Reference
# + relativePathToReference - Relative path to Reference
# + return - FHIRError if the Reference resource type is not defined, else FHIR Reference
public isolated function createRelativeFhirReference(typedesc<anydata> referenceResourceModel, string relativePathToReference) returns Reference|FHIRError {
    return createNonContainedFhirReference(referenceResourceModel, relativePathToReference);
}

# Create an absolute Reference to FHIR Resource.
#
# + referenceResourceModel - FHIR Resource model of the Reference
# + absolutePathToReference - Absolute path to Reference
# + return - FHIRError if the Reference resource type is not defined, else FHIR Reference
public isolated function createAbsoluteFhirReference(typedesc<anydata> referenceResourceModel, string absolutePathToReference) returns Reference|FHIRError {
    return createNonContainedFhirReference(referenceResourceModel, absolutePathToReference);
}

# Create a contained Reference to FHIR Resource.
#
# + targetResource - FHIR Resource which the Reference is to be contained/embedded
# + resourceTypeReference - Resource typed Reference to be contained/embedded
# + return - FHIRError if the target FHIR Resource is not a valid FHIR resource, else FHIR Reference
public isolated function createContainedFhirReference(map<anydata> targetResource, Resource resourceTypeReference) returns Reference|FHIRError {
    anydata? targetContained = targetResource[REFERENCE_TYPE_CONTAINED];
    if targetContained is () {
        targetResource[REFERENCE_TYPE_CONTAINED] = [resourceTypeReference];
    } else if targetContained is Resource[] {
        targetContained.push(resourceTypeReference);
    }

    string? referenceId = resourceTypeReference.id;
    if referenceId !is string {
        return createFHIRError("Contained reference id is missing", ERROR, PROCESSING, errorType = PROCESSING_ERROR);
    }
    return createReference(string `#${referenceId}`, resourceTypeReference.resourceType);
}

isolated function createNonContainedFhirReference(typedesc<anydata> referenceResourceModel, string pathToReference) returns Reference|FHIRError {
    ResourceDefinitionRecord? def = referenceResourceModel.@ResourceDefinition;
    string? resourceType = def?.resourceType;

    if resourceType !is string {
        return createFHIRError("Resource type is not defined", ERROR, PROCESSING, errorType = PROCESSING_ERROR);
    }
    return createReference(pathToReference, resourceType);
}

isolated function createReference(string reference, string 'type) returns Reference => {reference, 'type};
