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
public const LOINC_SYSTEM = "http://loinc.org";
public const IPS_SECTION_CODE = "60591-5";
public const IPS_SECTION_DISPLAY = "Patient summary";

# IpsSectionName
# Enum of all possible IPS section names, using canonical codes from the IPS Implementation Guide:
# https://hl7.org/fhir/uv/ips/StructureDefinition-Composition-uv-ips-definitions.html#diff_Composition.section
# https://hl7.org/fhir/uv/ips/StructureDefinition-Composition-uv-ips.html#profile
public enum IpsSectionName {
    // Required sections
    PROBLEMS = "PROBLEMS",
    MEDICATIONS = "MEDICATIONS",
    ALLERGIES = "ALLERGIES",
    // Recommended sections
    IMMUNIZATIONS = "IMMUNIZATIONS",
    RESULTS = "RESULTS",
    PROCEDURE_HISTORY = "PROCEDURE_HISTORY",
    MEDICAL_DEVICES = "MEDICAL_DEVICES",
    // Optional sections
    VITAL_SIGNS = "VITAL_SIGNS",
    PAST_ILLNESS_HISTORY = "PAST_ILLNESS_HISTORY",
    FUNCTIONAL_STATUS = "FUNCTIONAL_STATUS",
    PLAN_OF_CARE = "PLAN_OF_CARE",
    SOCIAL_HISTORY = "SOCIAL_HISTORY",
    PREGNANCY_HISTORY = "PREGNANCY_HISTORY",
    ADVANCE_DIRECTIVES = "ADVANCE_DIRECTIVES"
}

# IPS section LOINC codes as per HL7 IPS Implementation Guide:
# https://hl7.org/fhir/uv/ips/StructureDefinition-Composition-uv-ips-definitions.html#Composition.section
# https://hl7.org/fhir/uv/ips/StructureDefinition-Composition-uv-ips.html#profile
#
# The keys are values from the `IpsSectionName` enum.
# The values are [LOINC code, display name] for each section.
final map<Coding> & readonly IPS_SECTION_LOINC_CODES = {
    // Required sections
    PROBLEMS: {code: "11450-4", display: "Problem list"},
    MEDICATIONS: {code: "10160-0", display: "Medication use"},
    ALLERGIES: {code: "48765-2", display: "Allergies &or adverse reactions"},
    // Recommended sections
    IMMUNIZATIONS: {code: "11369-6", display: "Immunization"},
    RESULTS: {code: "30954-2", display: "Relevant diagnostic tests &or laboratory data"},
    PROCEDURE_HISTORY: {code: "47519-4", display: "History of procedures"},
    MEDICAL_DEVICES: {code: "46264-8", display: "History of medical device use"},
    // Optional sections
    VITAL_SIGNS: {code: "8716-3", display: "Vital Signs"},
    PAST_ILLNESS_HISTORY: {code: "11348-0", display: "Past illness"},
    FUNCTIONAL_STATUS: {code: "47420-5", display: "Functional status assessment note"},
    PLAN_OF_CARE: {code: "18776-5", display: "Plan of care note"},
    SOCIAL_HISTORY: {code: "29762-2", display: "Social history"},
    PREGNANCY_HISTORY: {code: "10162-6", display: "History of pregnancies"},
    ADVANCE_DIRECTIVES: {code: "42348-3", display: "Advance healthcare directives"}
};

# Required sections for the IPS.
# These are the mandatory sections that must be included in the IPS as per the HL7 IPS
# Implementation Guide.
# See: https://hl7.org/fhir/uv/ips/StructureDefinition-Composition
final IpsSectionName[] & readonly REQUIRED_SECTIONS = [
    PROBLEMS,
    MEDICATIONS,
    ALLERGIES
];

## Maps each IPS section to the FHIR resource types that should be included in that section.
#
# This constant is used to determine which FHIR resources are relevant for each IPS section when generating the IPS document.
# The mapping follows the HL7 IPS Implementation Guide, ensuring that each section contains the appropriate resource types for international interoperability.
final map<string[]> & readonly IPS_COMPOSITION_SECTION_RESOURCE_TYPES = {
    PROBLEMS: ["Condition"],
    MEDICATIONS: ["MedicationStatement", "MedicationRequest", "MedicationAdministration", "MedicationDispense"],
    ALLERGIES: ["AllergyIntolerance"],
    IMMUNIZATIONS: ["Immunization"],
    RESULTS: ["Observation", "DiagnosticReport"],
    PROCEDURE_HISTORY: ["Procedure"],
    MEDICAL_DEVICES: ["DeviceUseStatement"],
    VITAL_SIGNS: ["Observation"],
    PAST_ILLNESS_HISTORY: ["Condition"],
    FUNCTIONAL_STATUS: ["Condition", "ClinicalImpression"],
    PLAN_OF_CARE: ["CarePlan"],
    SOCIAL_HISTORY: ["Observation"],
    PREGNANCY_HISTORY: ["Observation"],
    ADVANCE_DIRECTIVES: ["Consent"]
};

const DEFAULT_IPS_COMPOSITION_TITLE = "International Patient Summary";
const DEFAULT_IPS_BUNDLE_IDENTIFIER = "urn:oid:2.16.724.4.8.10.200.10";

# Default titles for each IPS section.
# These titles are used when generating the IPS Bundle and can be overridden in the section configuration.
final map<string> & readonly DEFAULT_IPS_SECTION_TITLES = {
    PROBLEMS: "Active Problems",
    MEDICATIONS: "Medication Summary",
    ALLERGIES: "Allergies and Intolerances",
    IMMUNIZATIONS: "Immunizations",
    RESULTS: "Diagnostic Results",
    PROCEDURE_HISTORY: "History of Procedures",
    MEDICAL_DEVICES: "History of Medical Device Use",
    VITAL_SIGNS: "Vital Signs",
    PAST_ILLNESS_HISTORY: "Past Illness History",
    FUNCTIONAL_STATUS: "Functional Status",
    PLAN_OF_CARE: "Plan of Care",
    SOCIAL_HISTORY: "Social History",
    PREGNANCY_HISTORY: "Pregnancy History",
    ADVANCE_DIRECTIVES: "Advance Directives"
};

# Mandatory sections and recommended sections for the International Patient Summary (IPS).
# This configuration is based on the IPS Implementation Guide and defines the resources
# See: https://hl7.org/fhir/uv/ips
final IpsSectionConfig[] & readonly DEFAULT_SECTION_CONFIG = [
    // Required sections as per IPS Implementation Guide
    {
        sectionName: PROBLEMS,
        resources: [
            {resourceType: "Condition"}
        ]
    },
    {
        sectionName: ALLERGIES,
        resources: [
            {resourceType: "AllergyIntolerance"}
        ]
    },
    {
        sectionName: MEDICATIONS,
        resources: [
            {resourceType: "MedicationStatement"}
        ]
    },
    // Recommended sections
    {
        sectionName: IMMUNIZATIONS,
        resources: [
            {resourceType: "Immunization"}
        ]
    },
    {
        sectionName: RESULTS,
        resources: [
            {resourceType: "Observation", searchParams: {"category": "laboratory"}},
            {resourceType: "DiagnosticReport"}
        ]
    },
    {
        sectionName: PROCEDURE_HISTORY,
        resources: [
            {resourceType: "Procedure"}
        ]
    },
    {
        sectionName: MEDICAL_DEVICES,
        resources: [
            {resourceType: "DeviceUseStatement"}
        ]
    }
];

