// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).

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

import ballerina/http;
import ballerina/log;
import ballerinax/health.clients.fhir;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

// FHIR errors for member match operation
// Error indicating no match was found
final r4:FHIRError & readonly NO_MATCH_ERROR = r4:createFHIRError("No match found", r4:ERROR,
        r4:PROCESSING_NOT_FOUND, httpStatusCode = http:STATUS_UNPROCESSABLE_ENTITY);

// Error indicating multiple matches were found
final r4:FHIRError & readonly MULTIPLE_MATCHES_ERROR = r4:createFHIRError("Multiple matches found", r4:ERROR,
        r4:PROCESSING_MULTIPLE_MATCHES, httpStatusCode = http:STATUS_UNPROCESSABLE_ENTITY);

// Error indicating a failure in processing the consent
final r4:FHIRError & readonly CONSENT_PROCESSING_ERROR = r4:createFHIRError("Consent processing failed",
        r4:ERROR, r4:PROCESSING, httpStatusCode = http:STATUS_UNPROCESSABLE_ENTITY);

// Error indicating an internal server error occurred during the member matching process
final r4:FHIRError & readonly INTERNAL_ERROR = r4:createFHIRError("Internal server error", r4:ERROR,
        r4:PROCESSING, httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);

# Default FHIR member matcher implementation.
public isolated class FhirMemberMatcher {
    *MemberMatcher;

    // Custom member matcher
    private final MemberMatcher? customMemberMatcher;

    // FHIR repository client
    private final fhir:FHIRConnector fhirClient;

    // Consent service client and headers
    private final map<string|string[]>? & readonly consentServiceClientHeaders;
    private final http:Client consentServiceClient;

    // Coverage service client and headers
    private final map<string|string[]>? & readonly coverageServiceClientHeaders;
    private final http:Client? coverageServiceClient;

    // TODO: Make the init() isolated once the FHIR connector's init() is made isolated
    // FHIR client issue: https://github.com/wso2-enterprise/open-healthcare/issues/1589
    public function init(MatcherConfig matcherConfig, MemberMatcher? customMemberMatcher) returns error? {
        // Initialize FHIR client
        self.fhirClient = check new (matcherConfig.fhirClientConfig);

        // Initialize consent service client and headers
        ExternalServiceConfig consentServiceConfig = matcherConfig.consentServiceConfig;
        self.consentServiceClient = check initHttpClient(consentServiceConfig.url, consentServiceConfig.clientConfig);
        self.consentServiceClientHeaders = consentServiceConfig?.requestHeaders.cloneReadOnly() ?: ();

        // Initialize coverage service client and headers
        ExternalServiceConfig? coverageServiceConfig = matcherConfig.coverageServiceConfig;
        if coverageServiceConfig != () && coverageServiceConfig.url != "" {
            self.coverageServiceClient = check initHttpClient(coverageServiceConfig.url,
                    coverageServiceConfig.clientConfig);
        } else {
            self.coverageServiceClient = ();
        }
        self.coverageServiceClientHeaders = coverageServiceConfig?.requestHeaders.cloneReadOnly() ?: ();

        // Initialize custom matcher
        self.customMemberMatcher = customMemberMatcher;
    }

    # Matches a member using provided demographics and coverage information.
    #
    # This function attempts to match a member. If a custom `MemberMatcher` is configured, it utilizes that for the 
    # matching process. Otherwise, it defaults to the following default matching logic,
    #
    # 1. Match the patient. If no matching patients are found, return a 422 error. 
    # 2. If one or more matching patients are found, match coverage for each patient.
    # 3. After matching, if only one patient is found with matching coverage(s), proceed; if not, return 422.
    # 4. Process consent. If valid consent is present, continue; else, return 422.
    # 5. Link new coverage if present.
    # 6. Return the member identifier of the matched patient.
    #
    # + memberMatchResources - The resources of the member match request
    # + return - A `MemberIdentifier` on successful match or `r4:FHIRError` on failure
    public isolated function matchMember(anydata memberMatchResources)
            returns MemberIdentifier|r4:FHIRError {
        // If a custom member matcher is available, use it to match the member
        MemberMatcher? customMemberMatcher = self.customMemberMatcher;
        if customMemberMatcher != () {
            return customMemberMatcher.matchMember(memberMatchResources);
        }

        if memberMatchResources !is MemberMatchResources {
            log:printError("Invalid type for \"memberMatchResources\". Expected type: MemberMatchResources.");
            return INTERNAL_ERROR;
        }

        // Member match resources
        uscore501:USCorePatientProfile memberPatient = memberMatchResources.memberPatient;
        HRexConsent consent = memberMatchResources.consent;
        HRexCoverage coverageToMatch = memberMatchResources.coverageToMatch;
        HRexCoverage? coverageToLink = memberMatchResources.coverageToLink;

        // The spec doesn't define a member matching logic. Therefore, this implementation uses the following:

        // Match patient
        map<string[]> patientSearchParams = constructPatientSearchParams(memberPatient);
        log:printDebug(string `Patient matching search params: ${patientSearchParams.toString()}`);
        uscore501:USCorePatientProfile[] matchedPatients = check searchPatients(patientSearchParams, self.fhirClient);

        r4:Reference patientReference = {};
        uscore501:USCorePatientProfile[] matchedPatientsWithMatchingCoverage = [];

        foreach uscore501:USCorePatientProfile matchedPatient in matchedPatients {
            // Update patient reference
            string? patientId = matchedPatient.id;
            if patientId == () {
                log:printError(string `Missing resource ID in patient resource: ${matchedPatient.toString()}`);
                continue;
            }
            patientReference = {reference: "Patient/" + patientId};

            // Match coverage
            map<string[]> coverageSearchParams = constructCoverageSearchParams(coverageToMatch,
                patientReference);
            log:printDebug(string `Coverage matching search params: ${coverageSearchParams.toString()}`);
            if check isCoverageMatchFound(coverageSearchParams, self.fhirClient) {
                matchedPatientsWithMatchingCoverage.push(matchedPatient);
            }
        }

        if matchedPatientsWithMatchingCoverage.length() == 0 {
            return NO_MATCH_ERROR;
        } else if matchedPatientsWithMatchingCoverage.length() > 1 {
            return MULTIPLE_MATCHES_ERROR;
        }

        // Process consent using consent service 
        updateConsentPatientAndPerformer(consent, patientReference);
        check processConsent(consent, self.consentServiceClient,
                self.consentServiceClientHeaders);

        // Link new coverage using coverage service
        if coverageToLink != () {
            http:Client? coverageServiceClient = self.coverageServiceClient;
            if coverageServiceClient != () {
                updateCoverageBeneficiary(coverageToLink, patientReference);
                _ = start linkCoverage(coverageToLink.clone(), coverageServiceClient,
                        self.coverageServiceClientHeaders);
            } else {
                log:printDebug("Coverage service client is nil. Coverage linking is not supported");
            }
        }

        // Get member identifier of the matched patient
        MemberIdentifier? memberIdentifier = getPatientMemberIdentifier(matchedPatientsWithMatchingCoverage[0]);
        if memberIdentifier == () { // No member identifier for the matched patient
            log:printError("No member identifier found for the matched patient");
            return NO_MATCH_ERROR;
        }

        return memberIdentifier;
    }
}

# Searches for patients matching the given search parameters in a FHIR server.
#
# + patientSearchParams - A map of patient search parameters used for searching the FHIR server
# + fhirClient - The FHIR client instance used to communicate with the FHIR server
# + return - An array of `USCorePatientProfile` patients or an `r4:FHIRError` if an error occurs 
# during the search operation
isolated function searchPatients(map<string[]> patientSearchParams,
        fhir:FHIRConnector fhirClient) returns uscore501:USCorePatientProfile[]|r4:FHIRError {
    // Search for matching patients
    r4:Bundle patientBundle = check executeFhirSearch(fhirClient, "Patient", patientSearchParams);
    log:printDebug(string `Matching patients bundle: ${patientBundle.toString()}`);

    r4:BundleEntry[]? patientBundleEntries = patientBundle.entry;
    if patientBundleEntries == () || patientBundleEntries.length() == 0 { // No matches
        return [];
    }

    uscore501:USCorePatientProfile[] matches = [];
    foreach r4:BundleEntry bundleEntry in patientBundleEntries {
        uscore501:USCorePatientProfile|error matchedPatient = bundleEntry?.'resource.cloneWithType();
        if matchedPatient is uscore501:USCorePatientProfile {
            matches.push(matchedPatient);
        } else {
            log:printError("Matched patient resource is not a valid US Core patient resource", matchedPatient);
        }
    }

    return matches;
}

# Checks if there is a matching coverage based on the given search parameters.
#
# + coverageSearchParams - A map of coverage search parameters used for searching the FHIR server
# + fhirClient - The FHIR client instance used to communicate with the FHIR server
# + return - `true` if at least one matching coverage is found, `false` if no matches found, 
# or an `r4:FHIRError` if an error occurs during the search operation
isolated function isCoverageMatchFound(map<string[]> coverageSearchParams,
        fhir:FHIRConnector fhirClient) returns boolean|r4:FHIRError {
    // Search for matching coverages
    r4:Bundle coverageBundle = check executeFhirSearch(fhirClient, "Coverage", coverageSearchParams);
    log:printDebug(string `Matching coverages bundle: ${coverageBundle.toString()}`);

    r4:BundleEntry[]? coverageBundleEntries = coverageBundle.entry;
    if coverageBundleEntries == () || coverageBundleEntries.length() == 0 {
        return false;
    }

    return true;
}

# Retrieves the member identifier from a US Core patient.
#
# + patient - The US Core Patient Profile to be searched
# + return - A `MemberIdentifier` if a matching identifier is found, or `()` if no matching
# identifier is found
isolated function getPatientMemberIdentifier(uscore501:USCorePatientProfile patient) returns MemberIdentifier? {
    foreach uscore501:USCorePatientProfileIdentifier identifier in patient.identifier {
        r4:Coding[]? identifierCodings = identifier?.'type?.coding;
        if identifierCodings == () {
            continue;
        }

        foreach r4:Coding coding in identifierCodings {
            if coding.system == "http://terminology.hl7.org/CodeSystem/v2-0203" && coding.code == "MB" {
                return identifier.value;
            }
        }
    }
    return;
}

# Processes the consent by sending it to the consent service using the consent service client.
#
# + consent - The consent to be sent to the consent service
# + consentServiceClient - The consent service client
# + headers - The headers for the request. This is an optional parameter.
# + return - A `r4:FHIRError` is there is an error processing the consent, or `()` otherwise 
isolated function processConsent(HRexConsent consent, http:Client consentServiceClient,
        map<string|string[]>? headers) returns r4:FHIRError? {
    // Send request to consent service
    http:Response|http:ClientError consentPostRes = consentServiceClient->post("/", consent, headers);
    if consentPostRes is http:ClientError {
        log:printError("Error sending consent to the consent service", consentPostRes);
        return INTERNAL_ERROR;
    }

    log:printDebug("Consent service response info", statusCode = consentPostRes.statusCode,
            payload = getHttpResponseTextPayload(consentPostRes));

    // Check consent service response
    if consentPostRes.statusCode != http:STATUS_OK && consentPostRes.statusCode != http:STATUS_CREATED {
        log:printError("Received a non-successful response from the consent service",
                statusCode = consentPostRes.statusCode);
        return CONSENT_PROCESSING_ERROR;
    }
}

# Sends coverage to the coverage service to be linked.
#
# + coverageToLink - The coverage to send
# + coverageServiceClient - Client for the coverage service
# + headers - The headers for the request. This is an optional parameter.
isolated function linkCoverage(HRexCoverage coverageToLink, http:Client coverageServiceClient,
        map<string|string[]>? headers) {
    // Send POST request to coverage service
    http:Response|http:ClientError coveragePostRes = coverageServiceClient->post("/", coverageToLink, headers);
    if coveragePostRes is http:Response {
        log:printDebug("Coverage service response info", statusCode = coveragePostRes.statusCode,
            payload = getHttpResponseTextPayload(coveragePostRes));
    } else {
        log:printError("Error sending coverage to the coverage service", coveragePostRes);
    }
}

# Executes a FHIR search with given parameters.
#
# + fhirClient - The FHIR client to perform the search
# + 'resource - The type of FHIR resource to search for
# + searchParams - The search parameters as a map
# + return - A `r4:Bundle` on a successful search, or `r4:FHIRError` on failure
isolated function executeFhirSearch(fhir:FHIRConnector fhirClient, string 'resource,
        map<string[]> searchParams) returns r4:Bundle|r4:FHIRError {
    fhir:FHIRResponse|fhir:FHIRError searchRes = fhirClient->search('resource, mode = fhir:GET, searchParameters = searchParams);
    if searchRes is fhir:FHIRError {
        log:printError("FHIR search error", searchRes);
        return INTERNAL_ERROR;
    }

    r4:Bundle|error searchBundle = searchRes.'resource.cloneWithType();
    if searchBundle is error {
        log:printError("FHIR search response is not a valid FHIR Bundle", searchBundle);
        return INTERNAL_ERROR;
    }

    return searchBundle;
}

# Constructs search parameters for patient search.
#
# + patient - The `USCorePatientProfile` resource
# + return - A map of search parameters for the patient search
isolated function constructPatientSearchParams(uscore501:USCorePatientProfile patient)
        returns map<string[]> {
    // TODO: Add custom search parameters support
    // Issue: https://github.com/wso2-enterprise/open-healthcare/issues/1603

    map<string[]> patientSearchParams = {};

    // identifier
    constructAndAddPatientIdentifierParam(patient, patientSearchParams);

    // given, family
    constructAndAddPatientNameParams(patient, patientSearchParams);

    // telecom
    constructAndAddPatientTelecomParam(patient, patientSearchParams);

    // gender
    addSearchParam("gender", [patient.gender], patientSearchParams);

    // birthdate
    addSearchParam("birthdate", optionalStrToArray(patient.birthDate), patientSearchParams);

    // address, address-ciy, address-country, address-state, address-postalcode
    constructAndAddPatientAddressParams(patient, patientSearchParams);

    // language
    constructAndAddPatientLanguageParam(patient, patientSearchParams);

    return patientSearchParams;
}

# Constructs search parameters for coverage search.
#
# + coverage - The `USCorePatientProfile` resource
# + beneficiary - The beneficiary of the coverage
# + return - A map of search parameters for the patient search
isolated function constructCoverageSearchParams(HRexCoverage coverage, r4:Reference beneficiary) returns map<string[]> {
    // TODO: Add custom search parameters support
    // Issue: https://github.com/wso2-enterprise/open-healthcare/issues/1603
    map<string[]> coverageSearchParams = {};

    // identifier
    constructAndAddCoverageIdentifierParam(coverage, coverageSearchParams);

    // subscriber
    addSearchParam("subscriber", optionalStrToArray(coverage.subscriber?.reference), coverageSearchParams);

    // beneficiary
    addSearchParam("beneficiary", optionalStrToArray(beneficiary.reference), coverageSearchParams);

    // payor
    constructAndAddCoveragePayorParam(coverage, coverageSearchParams);

    return coverageSearchParams;
}

# Updates the patient and performer references in a `HRexConsent` resource.
#
# + consent - The consent to update
# + patientReference - The patient reference to set
isolated function updateConsentPatientAndPerformer(HRexConsent consent, r4:Reference patientReference) {
    consent.patient = patientReference;
    if consent.performer.length() > 0 {
        consent.performer[0] = patientReference;
    }
}

# Updates the beneficiary reference in a `HRexCoverage` resource.
#
# + coverageToLink - The coverage to update
# + patientReference - The patient reference to set as beneficiary
isolated function updateCoverageBeneficiary(HRexCoverage coverageToLink, r4:Reference patientReference) {
    coverageToLink.beneficiary = patientReference;
}

# Adds a search parameter to the search parameters map.
#
# + searchParam - The search parameter name
# + values - The array of values for the search parameter
# + searchParams - The map of search parameters to update
isolated function addSearchParam(string searchParam, string[] values, map<string[]> searchParams) {
    if values.length() != 0 { // Only add if there are values
        if searchParams.hasKey(searchParam) {
            searchParams.get(searchParam).push(...values);
        } else {
            searchParams[searchParam] = values;
        }
    }
}

# Converts an optional string to an array.
#
# + value - The optional string value to convert
# + return - An array of strings, either empty or containing the input string
isolated function optionalStrToArray(string? value) returns string[]
    => value == () ? [] : [value];

# Retrieves the text payload from an HTTP response.
#
# + response - The HTTP response to extract the text payload from
# + return - The text payload as a string if present, or `()` if not present or in case of an error
isolated function getHttpResponseTextPayload(http:Response response) returns string? {
    string|http:ClientError textPayload = response.getTextPayload();
    return textPayload is string ? textPayload : ();
}

# Initializes an HTTP client.
#
# + url - The URL of the service the client will connect to
# + clientConfig - Configuration for the client. This is an optional parameter
# + return - An `http:Client` instance on success or an `http:ClientError` on failure
isolated function initHttpClient(string url,
        http:ClientConfiguration? clientConfig) returns http:Client|http:ClientError
        => clientConfig != () ? new (url, clientConfig) : new (url);
