// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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

import ballerina/constraint;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;

public const string PROFILE_BASE_PDEXMULTIMEMBERMATCHRESPONSEPARAMETERS = "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-out";
public const RESOURCE_NAME_PDEXMULTIMEMBERMATCHRESPONSEPARAMETERS = "Parameters";

# FHIR PDexMultiMemberMatchResponseParameters resource record.
#
# Defines the output of a `$bulk-member-match` operation.
# (Canonical: http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-out)
#
# + resourceType - The type of the resource describes
# + meta - The metadata about the resource.
# + 'parameter - Operation output parameters (1..3), closed slicing by name:
# * parameter Slicings
# 1) PDexMultiMemberMatchResponseParametersParameterMatchedMembers (1..1)
# 2) PDexMultiMemberMatchResponseParametersParameterNonMatchedMembers (0..1)
# 3) PDexMultiMemberMatchResponseParametersParameterConsentConstrainedMembers (0..1)
#
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed.
# + language - The base language in which the resource is written.
# + id - The logical id of the resource.
@r4:ResourceDefinition {
    resourceType: "Parameters",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-out",
    elements: {
        "meta": {
            name: "meta",
            dataType: r4:Meta,
            min: 0,
            max: 1,
            isArray: false,
            path: "Parameters.meta"
        },
        "parameter": {
            name: "parameter",
            dataType: PDexMultiMemberMatchResponseParametersParameter,
            min: 1,
            max: 3,
            isArray: true,
            path: "Parameters.parameter"
        },
        "implicitRules": {
            name: "implicitRules",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            path: "Parameters.implicitRules"
        },
        "language": {
            name: "language",
            dataType: r4:code,
            min: 0,
            max: 1,
            isArray: false,
            path: "Parameters.language",
            valueSet: "http://hl7.org/fhir/ValueSet/languages"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            path: "Parameters.id"
        }
    },
    serializers: {
        'xml: r4:fhirResourceXMLSerializer,
        'json: r4:fhirResourceJsonSerializer
    }
}
public type PDexMultiMemberMatchResponseParameters record {|
    *r4:DomainResource;

    RESOURCE_NAME_PDEXMULTIMEMBERMATCHRESPONSEPARAMETERS resourceType = RESOURCE_NAME_PDEXMULTIMEMBERMATCHRESPONSEPARAMETERS;

    r4:Meta meta?;
    @constraint:Array {
        minLength: {
            value: 1,
            message: "Validation failed for $.Parameters.parameter constraint. This field must contain at least one item."
        },
        maxLength: {
            value: 3,
            message: "Validation failed for $.Parameters.parameter constraint. This field must contain at most 3 items."
        }
    }
    PDexMultiMemberMatchResponseParametersParameter[] 'parameter;
    r4:uri implicitRules?;
    r4:code language?;
    string id?;
    r4:Element ...;
|};

# FHIR PDexMultiMemberMatchResponseParametersParameter datatype record.
#
# Base type for a response parameter entry.
#
# + modifierExtension - Modifier extensions.
# + extension - Extensions.
# + 'resource - Group resource holding matched or unmatched members.
# + part - Named parts of a multi-part parameter.
# + name - The name of the parameter.
# + id - Unique id for the element within a resource.
@r4:DataTypeDefinition {
    name: "PDexMultiMemberMatchResponseParametersParameter",
    baseType: (),
    elements: {
        "modifierExtension": {
            name: "modifierExtension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Modifier extensions.",
            path: "Parameters.parameter.modifierExtension"
        },
        "extension": {
            name: "extension",
            dataType: r4:Extension,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Extensions.",
            path: "Parameters.parameter.extension"
        },
        "resource": {
            name: "resource",
            dataType: r4:Resource,
            min: 0,
            max: 1,
            isArray: false,
            description: "Group resource holding matched or unmatched members.",
            path: "Parameters.parameter.resource"
        },
        "part": {
            name: "part",
            dataType: international401:ParametersParameter,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Named parts of a multi-part parameter.",
            path: "Parameters.parameter.part"
        },
        "name": {
            name: "name",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The name of the parameter.",
            path: "Parameters.parameter.name"
        },
        "id": {
            name: "id",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique id for the element within a resource.",
            path: "Parameters.parameter.id"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type PDexMultiMemberMatchResponseParametersParameter record {|
    *r4:BackboneElement;

    r4:Extension[] modifierExtension?;
    r4:Extension[] extension?;
    r4:Resource 'resource?;
    international401:ParametersParameter[] part?;
    string name;
    string id?;
|};

# Slice: MatchedMembers (1..1) — PDexMemberMatchGroup.
# + 'resource - Group resource (PDexMemberMatchGroup profile) of successfully matched members.
# + name - Fixed value "MatchedMembers".
# + modifierExtension - Modifier extensions.
# + extension - Extensions.
# + part - Named parts of a multi-part parameter.
# + id - Unique id for the element within a resource.
public type PDexMultiMemberMatchResponseParametersParameterMatchedMembers record {|
    *PDexMultiMemberMatchResponseParametersParameter;

    r4:Extension[] modifierExtension?;
    r4:Extension[] extension?;
    r4:Resource 'resource;
    international401:ParametersParameter[] part?;
    string name = "MatchedMembers";
    string id?;
|};

# Slice: NonMatchedMembers (0..1) — PDexMemberNoMatchGroup.
# + 'resource - Group resource (PDexMemberNoMatchGroup profile) of members for whom no match was found.
# + name - Fixed value "NonMatchedMembers".
# + modifierExtension - Modifier extensions.
# + extension - Extensions.
# + part - Named parts of a multi-part parameter.
# + id - Unique id for the element within a resource.
public type PDexMultiMemberMatchResponseParametersParameterNonMatchedMembers record {|
    *PDexMultiMemberMatchResponseParametersParameter;

    r4:Extension[] modifierExtension?;
    r4:Extension[] extension?;
    r4:Resource 'resource;
    international401:ParametersParameter[] part?;
    string name = "NonMatchedMembers";
    string id?;
|};

# Slice: ConsentConstrainedMembers (0..1) — PDexMemberNoMatchGroup.
# + 'resource - Group resource (PDexMemberNoMatchGroup profile) of members excluded due to consent.
# + name - Fixed value "ConsentConstrainedMembers".
# + modifierExtension - Modifier extensions.
# + extension - Extensions.
# + part - Named parts of a multi-part parameter.
# + id - Unique id for the element within a resource.
public type PDexMultiMemberMatchResponseParametersParameterConsentConstrainedMembers record {|
    *PDexMultiMemberMatchResponseParametersParameter;

    r4:Extension[] modifierExtension?;
    r4:Extension[] extension?;
    r4:Resource 'resource;
    international401:ParametersParameter[] part?;
    string name = "ConsentConstrainedMembers";
    string id?;
|};
