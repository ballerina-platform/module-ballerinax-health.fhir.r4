// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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

# Interface for consent enforcement implementations.
# Defines the contract for checking if a resource type is authorized based on consent data.
public type ConsentEnforcer object {

    # Enforces consent by checking if the resource type is authorized
    #
    # + userID - The user ID for which consent needs to be enforced
    # + return - ConsentContext containing consented resource types or error if enforcement fails
    public isolated function enforce(string userID) returns r4:ConsentContext|error;
};

