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

# Holds the input for a `$bulk-member-match` operation.
#
# + requestParameters - A `PDexMultiMemberMatchRequestParameters` resource containing one or more
# `MemberBundle` parameters. Each bundle provides the demographics, coverage, and consent
# data for a single member to be matched.
public type BulkMemberMatchResources record {|
    PDexMultiMemberMatchRequestParameters requestParameters;
|};

# Holds the output of a `$bulk-member-match` operation.
#
# + responseParameters - A `PDexMultiMemberMatchResponseParameters` resource containing:
# - `MatchedMembers` (1..1): Group of successfully matched members (PDexMemberMatchGroup)
# - `NonMatchedMembers` (0..1): Group of unmatched members (PDexMemberNoMatchGroup)
# - `ConsentConstrainedMembers` (0..1): Group excluded due to consent (PDexMemberNoMatchGroup)
public type BulkMemberMatchResult record {|
    PDexMultiMemberMatchResponseParameters responseParameters;
|};

# Defines an abstract bulk member matcher for PDex `$bulk-member-match`.
#
# Implement this object type to provide custom member-matching logic for payer-to-payer
# bulk exchange. The operation is type-level on the `Group` resource:
# `POST [base]/Group/$bulk-member-match`
public type BulkMemberMatcher isolated object {
    # Performs member matching for multiple members in a single request.
    #
    # + resources - The input containing one or more MemberBundle parameters.
    # + return - A `BulkMemberMatchResult` with matched/unmatched/consent-constrained
    # Group resources on success, or a `r4:FHIRError` if the operation fails.
    public isolated function matchMembers(BulkMemberMatchResources resources)
            returns BulkMemberMatchResult|r4:FHIRError;
};
