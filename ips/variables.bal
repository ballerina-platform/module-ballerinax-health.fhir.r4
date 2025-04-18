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

// AUTO-GENERATED FILE.
// This file is auto-generated by Ballerina.

import ballerinax/health.fhir.r4;

# Terminology processor instance
public final r4:TerminologyProcessor terminologyProcessor = r4:terminologyProcessor;

# FHIR registry instance
public final r4:FHIRRegistry fhirRegistry = r4:fhirRegistry;

//Number of search params in INTERNATIONALPATIENTSUMMARYIG_IG_SEARCH_PARAMS_1  = 0
final readonly & map<r4:FHIRSearchParameterDefinition[]> INTERNATIONALPATIENTSUMMARYIG_IG_SEARCH_PARAMS_1 = {
    
};

public json[] FHIR_VALUE_SETS = [];
public json[] FHIR_CODE_SYSTEMS = [];

configurable string ips_bundle_identifier_system = "urn:oid:2.16.724.4.8.10.200.10";
configurable string ips_composition_status = "final";
configurable string ips_composition_title = "International Patient Summary";
configurable string ips_composition_problem_section_title = "Active Problems";
configurable string ips_composition_allergy_section_title = "Allergies";
configurable string ips_composition_medication_section_title = "Medications";
configurable string ips_composition_immunization_section_title = "Immunizations";
configurable string ips_composition_procedure_section_title = "Procedures";
configurable string ips_composition_diagnostic_report_section_title = "Diagnostic Reports";
configurable string[] attesters = [];
configurable string custodian = "";
configurable string author = "";
