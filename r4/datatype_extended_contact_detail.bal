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

@DataTypeDefinition {
    name: "ExtendedContactDetail",
    baseType: Element,
    elements: {
        "purpose": {
            name: "purpose",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "The type of contact"
        },
        "name": {
            name: "name",
            dataType: HumanName,
            min: 0,
            max: int:MAX_VALUE,
            isArray: false,
            description: "A name associated with the contact person"
        },
        "telecom": {
            name: "telecom",
            dataType: ContactPoint,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "A contact detail for the person, e.g. a telephone number or an email address"
        },
        "address": {
            name: "address",
            dataType: Address,
            min: 0,
            max: 1,
            isArray: false,
            description: "Visiting or postal addresses for the contact"
        },
        "organization": {
            name: "organization",
            dataType: Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that is associated with the contact"
        },
        "period": {
            name: "period",
            dataType: Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period when the contact detail is applicable"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ExtendedContactDetail record {|
    CodeableConcept purpose?;
    HumanName name?;
    ContactPoint telecom?;
    Address address?;
    Reference organization?;
    Period period?;
|};
