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
//
// MANUALLY EDITED FILE.
// This file is manually edited referring to the Patient Request for Corrections Implementation Guide.
// https://build.fhir.org/ig/HL7/fhir-patient-correction/StructureDefinition-patient-correction-bundle.html

import ballerinax/health.fhir.r4 as r4;

public const string PROFILE_BASE_PATIENTCORRECTIONBUNDLE = "http://hl7.org/fhir/uv/patient-corrections/StructureDefinition/patient-correction-bundle";
public const RESOURCE_NAME_PATIENTCORRECTIONBUNDLE = "Bundle";

@r4:ContainerDefinition {
    name: "Bundle",
    baseType: r4:Resource,
    profile: PROFILE_BASE_PATIENTCORRECTIONBUNDLE,
    elements: {
        "resourceType": {
            name: "resourceType",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "Type of the resource [Bundle]"
        },
        "identifier": {
            name: "identifier",
            dataType: r4:Identifier,
            min: 0,
            max: 1,
            isArray: false,
            description: "Persistent identifier for the bundle"
        },
        "type": {
            name: "type",
            dataType: r4:code,
            min: 1,
            max: 1,
            isArray: false,
            description: "collection",
            valueSet: "http://hl7.org/fhir/ValueSet/bundle-type"
        },
        "timestamp": {
            name: "timestamp",
            dataType: r4:instant,
            min: 0,
            max: 1,
            isArray: false,
            description: "When the bundle was assembled"
        },
        "total": {
            name: "total",
            dataType: r4:unsignedInt,
            min: 0,
            max: 1,
            isArray: false,
            description: "If search, the total number of matches"
        },
        "link": {
            name: "link",
            dataType: r4:BundleLink,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Links related to this Bundle"
        },
        "entry": {
            name: "entry",
            dataType: BundleEntry,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Entry in the bundle - will have a resource or information"
        },
        "signature": {
            name: "signature",
            dataType: r4:Signature,
            min: 0,
            max: 1,
            isArray: false,
            description: "Digital Signature"
        }
    },
    serializers: {
        'xml: r4:fhirBundleXmlSerializer,
        'json: r4:fhirBundleJsonSerializer
    }
}
public type PatientCorrectionBundle record {|
    *r4:Bundle;
    //Inherited child element from "Resource" (Redefining to maintain order when serialize) (START)
    RESOURCE_NAME_PATIENTCORRECTIONBUNDLE resourceType = RESOURCE_NAME_PATIENTCORRECTIONBUNDLE;
    string id?;
    r4:BaseBundleMeta meta = {
        profile: [PROFILE_BASE_PATIENTCORRECTIONBUNDLE]
    };
    r4:uri implicitRules?;
    r4:code language?;
    //Inherited child element from "Resource" (Redefining to maintain order when serialize) (END)

    r4:Identifier identifier?;
    r4:BundleType 'type = r4:BUNDLE_TYPE_COLLECTION;
    r4:instant timestamp?;
    r4:unsignedInt total?;
    r4:BundleLink[] link?;
    BundleEntry[] entry?;
    r4:Signature signature?;
|};


@r4:DataTypeDefinition {
    name: "BundleEntry",
    baseType: (),
    elements: {
        "link": {
            name: "link",
            dataType: r4:BundleLink,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Links related to this entry"
        },
        "fullUrl": {
            name: "fullUrl",
            dataType: r4:uri,
            min: 0,
            max: 1,
            isArray: false,
            description: "URI for resource (Absolute URL server address or URI for UUID/OID)"
        },
        "resource": {
            name: "resource",
            dataType: PatientCorrectionCommunication,
            min: 0,
            max: 1,
            isArray: false,
            description: "A resource in the bundle"
        },
        "search": {
            name: "search",
            dataType: r4:BundleEntrySearch,
            min: 0,
            max: 1,
            isArray: false,
            description: "Search related information"
        },
        "request": {
            name: "request",
            dataType: r4:BundleEntryRequest,
            min: 0,
            max: 1,
            isArray: false,
            description: "Additional execution information (transaction/batch/history)"
        },
        "response": {
            name: "response",
            dataType: r4:BundleEntryResponse,
            min: 0,
            max: 1,
            isArray: false,
            description: "Results of execution (transaction/batch/history)"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type BundleEntry record {|
    *r4:BundleEntry;

    r4:BundleLink[] link?;
    r4:uri fullUrl?;
    PatientCorrectionCommunication 'resource?;
    r4:BundleEntrySearch search?;
    r4:BundleEntryRequest request?;
    r4:BundleEntryResponse response?;
|};
