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

# Data type and Profile for this element.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations  
# + code - Data type or Resource (reference to definition)  
# + profile - Profiles (StructureDefinition or IG) - one must apply
# + targetProfile - Profile (StructureDefinition or IG) on the Reference/canonical target - one must apply 
# + aggregation - contained | referenced | bundled - how aggregated 
# + versioning - either | independent | specific
@DataTypeDefinition {
    name: "ElementType",
    baseType: Element,
    elements: {
        "code": {
            name: "code",
            dataType: uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Data type or Resource (reference to definition)",
            valueSet: "https://hl7.org/fhir/valueset-fhir-element-types.html"
        },
        "profile": {
            name: "profile",
            dataType: canonical,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Profiles (StructureDefinition or IG) - one must apply"
        },
        "targetProfile": {
            name: "targetProfile",
            dataType: canonical,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Profile (StructureDefinition or IG) on the Reference/canonical target - one must apply"
        },
        "aggregation": {
            name: "aggregation",
            dataType: TypeAggregation,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "contained | referenced | bundled - how aggregated",
            valueSet: "https://hl7.org/fhir/valueset-resource-aggregation-mode.html"
        },
        "versioning": {
            name: "versioning",
            dataType: TypeVersioning,
            min: 0,
            max: 1,
            isArray: false,
            description: "either | independent | specific",
            valueSet: "https://hl7.org/fhir/valueset-reference-version-rules.html"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ElementType record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    uri code;
    canonical[] profile?;
    canonical[] targetProfile?;
    string | TypeAggregation[] aggregation?;
    @constraint:String {
        pattern: re`either|independent|specific`
    }
    TypeVersioning versioning?;
|};

public enum TypeAggregation {
    contained,
    referenced,
    bundled
}

public enum TypeVersioning {
    either,
    independent,
    specific
}
