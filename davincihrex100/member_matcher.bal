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
import ballerinax/health.clients.fhir;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

# Holds the resources required for member matching.
#
# + memberPatient - The `USCorePatientProfile` of the member. This resource contains the patient's
# demographic and other identifying information necessary for the matching process
# + consent - The `HRexConsent` resource that specifies the member's consent status for data sharing and
# processing, ensuring compliance with privacy regulations
# + coverageToMatch - The `HRexCoverage` resource representing the insurance coverage information that needs 
# to be matched
# + coverageToLink - An optional `HRexCoverage` resource with new coverage information that, if provided, 
# to be linked to the member's profile upon successful matching
public type MemberMatchResources record {|
    uscore501:USCorePatientProfile memberPatient;
    HRexConsent consent;
    HRexCoverage coverageToMatch;
    HRexCoverage? coverageToLink;
|};

# Represents a member identifier value.
public type MemberIdentifier string;

# Configuration for connecting to an external service.
#
# + url - The endpoint URL of the external service
# + requestHeaders - Map of request headers to include in each HTTP request to the service.
# Useful for specifying authentication tokens, content types, or other custom headers. This is an optional field.
# + clientConfig - Optional configuration for the HTTP client used to connect to the service. This can
# include settings like proxy configurations, and timeout values. This is an optional field.
public type ExternalServiceConfig record {|
    string url;
    map<string|string[]> requestHeaders?;
    http:ClientConfiguration clientConfig?;
|};

# Configuration for the member matcher.
#
# + fhirClientConfig - Configuration for the FHIR repository client.
# + consentServiceConfig - Configuration for the external consent service, responsible for
# managing and verifying consent related to member data.
# + coverageServiceConfig - Configuration for an external coverage service, used
# for linking new coverage information. This is an optional field.
public type MatcherConfig record {|
    fhir:FHIRConnectorConfig fhirClientConfig;
    ExternalServiceConfig consentServiceConfig;
    ExternalServiceConfig coverageServiceConfig?;
|};

# Defines an abstract member matcher for FHIR-based member matching.
#
# This object serves as an interface for implementing custom member matching logic.
public type MemberMatcher isolated object {
    # Matches a member using patient demographics and coverage information.
    #
    # + memberMatchResources - The resources used for performing the member matching operation.
    # + return - A `MemberIdentifier` if a match is found, or a `r4:FHIRError` indicating
    # an error.
    public isolated function matchMember(anydata memberMatchResources)
            returns MemberIdentifier|r4:FHIRError;
};
