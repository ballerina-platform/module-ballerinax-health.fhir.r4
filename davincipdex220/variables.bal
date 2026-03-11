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

import ballerinax/health.fhir.r4;

# Terminology processor instance
public final r4:TerminologyProcessor terminologyProcessor = r4:terminologyProcessor;

# FHIR registry instance
public final r4:FHIRRegistry fhirRegistry = r4:fhirRegistry;

public json[] FHIR_VALUE_SETS = [];
public json[] FHIR_CODE_SYSTEMS = [];

// Operations in Da Vinci PDex IG (key = operation name)
final readonly & map<r4:FHIROperationDefinition[]> DAVINCIPDEX_IG_OPERATIONS = {
    // $bulk-member-match: Type-level operation on Group
    // Canonical URL: http://hl7.org/fhir/us/davinci-pdex/OperationDefinition/BulkMemberMatch
    // Spec: https://hl7.org/fhir/us/davinci-pdex/
    "bulk-member-match": [
        {
            name: "bulk-member-match",
            instanceLevel: false,
            typeLevel: true,
            systemLevel: false,
            affectsState: true,
            'resource: ["Group"],
            'parameter: [
                {
                    name: "MemberBundle",
                    use: r4:INPUT,
                    min: 1,
                    max: "*",
                    'type: "Bundle",
                    documentation: "A repeating parameter. Each MemberBundle contains a Bundle with parts: MemberPatient (HRex Patient Demographics, 1..1), CoverageToMatch (HRex Coverage, 1..1), Consent (HRex Consent, 1..1), and optionally CoverageToLink (HRex Coverage, 0..1).",
                    part: [
                        {
                            name: "MemberPatient",
                            use: r4:INPUT,
                            min: 1,
                            max: "1",
                            'type: "Resource",
                            documentation: "Patient demographics conforming to the HRex Patient Demographics profile."
                        },
                        {
                            name: "CoverageToMatch",
                            use: r4:INPUT,
                            min: 1,
                            max: "1",
                            'type: "Resource",
                            documentation: "Coverage record conforming to the HRex Coverage profile used for matching."
                        },
                        {
                            name: "Consent",
                            use: r4:INPUT,
                            min: 1,
                            max: "1",
                            'type: "Resource",
                            documentation: "Consent record conforming to the HRex Consent profile."
                        },
                        {
                            name: "CoverageToLink",
                            use: r4:INPUT,
                            min: 0,
                            max: "1",
                            'type: "Resource",
                            documentation: "Optional coverage record conforming to HRex Coverage to link after successful match."
                        }
                    ]
                },
                {
                    name: "MatchedMembers",
                    use: r4:OUTPUT,
                    min: 1,
                    max: "1",
                    'type: "Resource",
                    documentation: "Group resource (PDexMemberMatchGroup) containing successfully matched members."
                },
                {
                    name: "NonMatchedMembers",
                    use: r4:OUTPUT,
                    min: 0,
                    max: "1",
                    'type: "Resource",
                    documentation: "Group resource (PDexMemberNoMatchGroup) containing members for whom no match was found."
                },
                {
                    name: "ConsentConstrainedMembers",
                    use: r4:OUTPUT,
                    min: 0,
                    max: "1",
                    'type: "Resource",
                    documentation: "Group resource (PDexMemberNoMatchGroup) containing members excluded due to consent constraints."
                }
            ]
        }
    ],
    // $davinci-data-export: Instance-level operation on Group
    // Canonical URL: http://hl7.org/fhir/us/davinci-atr/OperationDefinition/davinci-data-export
    // Spec: https://hl7.org/fhir/us/davinci-atr/STU2.1/OperationDefinition-davinci-data-export.html
    "davinci-data-export": [
        {
            name: "davinci-data-export",
            instanceLevel: true,
            typeLevel: false,
            systemLevel: false,
            affectsState: false,
            'resource: ["Group"],
            'parameter: [
                {
                    name: "patient",
                    use: r4:INPUT,
                    min: 0,
                    max: "*",
                    'type: "Reference",
                    documentation: "Members whose data should be exported. When omitted, data for all members in the Group is exported."
                },
                {
                    name: "exportType",
                    use: r4:INPUT,
                    min: 0,
                    max: "1",
                    'type: "canonical",
                    documentation: "Specifies the export type. In the PDex payer-to-payer context, use 'hl7.fhir.us.davinci-pdex#payertopayer'."
                },
                {
                    name: "_since",
                    use: r4:INPUT,
                    min: 0,
                    max: "1",
                    'type: "instant",
                    documentation: "Resources updated after this instant will be included in the export."
                },
                {
                    name: "_until",
                    use: r4:INPUT,
                    min: 0,
                    max: "1",
                    'type: "instant",
                    documentation: "Resources updated before this instant will be included in the export."
                },
                {
                    name: "_type",
                    use: r4:INPUT,
                    min: 0,
                    max: "1",
                    'type: "string",
                    documentation: "Comma-delimited list of FHIR resource types to include in the export. When omitted, all supported types are exported."
                },
                {
                    name: "_typeFilter",
                    use: r4:INPUT,
                    min: 0,
                    max: "1",
                    'type: "string",
                    documentation: "List of FHIR search queries to restrict the resources included in the export."
                }
            ]
        }
    ]
};
