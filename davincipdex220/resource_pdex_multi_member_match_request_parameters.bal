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

public const string PROFILE_BASE_PDEXMULTIMEMBERMATCHREQUESTPARAMETERS = "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-in";
public const RESOURCE_NAME_PDEXMULTIMEMBERMATCHREQUESTPARAMETERS = "Parameters";

# FHIR PDexMultiMemberMatchRequestParameters resource record.
#
# Defines the inputs to a `$bulk-member-match` operation performed by a payer system.
# (Canonical: http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-in)
#
# + resourceType - The type of the resource describes
# + meta - The metadata about the resource.
# + 'parameter - Repeating MemberBundle parameter (1..*). Each MemberBundle groups one member's
# match data using parts:
# * parameter Slicings
# 1) PDexMultiMemberMatchRequestParametersParameterMemberBundle: MemberBundle parameter
#       - min = 1
#       - max = *
#
# + implicitRules - A reference to a set of rules that were followed when the resource was constructed.
# + language - The base language in which the resource is written.
# + id - The logical id of the resource.
@r4:ResourceDefinition {
    resourceType: "Parameters",
    baseType: r4:DomainResource,
    profile: "http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-in",
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
            dataType: PDexMultiMemberMatchRequestParametersParameter,
            min: 1,
            max: int:MAX_VALUE,
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
public type PDexMultiMemberMatchRequestParameters record {|
    *r4:DomainResource;

    RESOURCE_NAME_PDEXMULTIMEMBERMATCHREQUESTPARAMETERS resourceType = RESOURCE_NAME_PDEXMULTIMEMBERMATCHREQUESTPARAMETERS;

    r4:Meta meta?;
    @constraint:Array {
        minLength: {
            value: 1,
            message: "Validation failed for $.Parameters.parameter constraint. This field must be an array containing at least one item."
        }
    }
    PDexMultiMemberMatchRequestParametersParameter[] 'parameter;
    r4:uri implicitRules?;
    r4:code language?;
    string id?;
    r4:Element ...;
|};

# FHIR PDexMultiMemberMatchRequestParametersParameter datatype record.
#
# Base type for a parameter entry in the multi-member-match request.
#
# + modifierExtension - Modifier extensions.
# + extension - Extensions.
# + part - Named parts of the parameter (MemberPatient, CoverageToMatch, Consent, CoverageToLink).
# + name - The name of the parameter.
# + id - Unique id for the element within a resource.
@r4:DataTypeDefinition {
    name: "PDexMultiMemberMatchRequestParametersParameter",
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
        "part": {
            name: "part",
            dataType: international401:ParametersParameter,
            min: 3,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Named parts: MemberPatient (1..1), CoverageToMatch (1..1), Consent (1..1), CoverageToLink (0..1).",
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
public type PDexMultiMemberMatchRequestParametersParameter record {|
    *r4:BackboneElement;

    r4:Extension[] modifierExtension?;
    r4:Extension[] extension?;
    international401:ParametersParameter[] part?;
    string name;
    string id?;
|};

# FHIR PDexMultiMemberMatchRequestParametersParameterMemberBundle datatype record.
#
# Represents a single member's match data bundle as a named parameter "MemberBundle".
# Parts: MemberPatient (1..1), CoverageToMatch (1..1), Consent (1..1), CoverageToLink (0..1).
#
# + modifierExtension - Modifier extensions.
# + extension - Extensions.
# + part - Named parts of this MemberBundle parameter (min 3, max 4).
# + name - Fixed value "MemberBundle".
# + id - Unique id for the element within a resource.
@r4:DataTypeDefinition {
    name: "PDexMultiMemberMatchRequestParametersParameterMemberBundle",
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
        "part": {
            name: "part",
            dataType: international401:ParametersParameter,
            min: 3,
            max: 4,
            isArray: true,
            description: "Named parts: MemberPatient (1..1), CoverageToMatch (1..1), Consent (1..1), CoverageToLink (0..1).",
            path: "Parameters.parameter.part"
        },
        "name": {
            name: "name",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "Fixed value: MemberBundle.",
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
public type PDexMultiMemberMatchRequestParametersParameterMemberBundle record {|
    *PDexMultiMemberMatchRequestParametersParameter;

    r4:Extension[] modifierExtension?;
    r4:Extension[] extension?;
    @constraint:Array {
        minLength: {
            value: 3,
            message: "Validation failed for $.Parameters.parameter.part constraint. MemberBundle must have at least 3 parts (MemberPatient, CoverageToMatch, Consent)."
        },
        maxLength: {
            value: 4,
            message: "Validation failed for $.Parameters.parameter.part constraint. MemberBundle can have at most 4 parts."
        }
    }
    international401:ParametersParameter[] part;
    string name = "MemberBundle";
    string id?;
|};
