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

import ballerina/http;
import ballerina/log;

# FHIR Authorization request record.
#
# + fhirSecurity - FHIRSecurity record containg backend JWT  
# + patientId - Authorized patient ID  
# + privilegedClaimUrl - Claim that has privilege to access all patients
public type AuthzRequest record {|
    FHIRSecurity fhirSecurity;
    string patientId?;
    string privilegedClaimUrl?;
|};

# FHIR Authorization scopes.
public enum AuthzScope {
    PATIENT, PRACTITIONER, PRIVILEGED
};

# FHIR Authorization response record.
#
# + isAuthorized - Whether the user is authorized to view requested patient data  
# + scope - Granted scope
public type AuthzResponse record {|
    boolean isAuthorized;
    AuthzScope scope?;
|};

# FHIR Authorization service configuration record.
#
# + authzServiceUrl - Authorization service URL  
# + privilegedClaimUrl - Claim that has privilege to access all patients
public type AuthzConfig record {|
    string authzServiceUrl;
    string? privilegedClaimUrl;
|};

# Call authz service and handle response.
#
# + patientId - Requested patient ID  
# + authzConfig - Authorization service configuration  
# + fhirSecurity - FHIRSecurity record containg backend JWT
# + return - returns FHIRError if authz service call fails or user is not authorized
public isolated function handleSmartSecurity(AuthzConfig authzConfig, FHIRSecurity fhirSecurity, string? patientId = ()) returns FHIRError? {
    AuthzRequest authzRequest = {
        fhirSecurity: fhirSecurity,
        patientId: patientId,
        privilegedClaimUrl: authzConfig.privilegedClaimUrl
    };
    http:Client|http:ClientError authzClient = new (authzConfig.authzServiceUrl);
    if authzClient is http:ClientError {
        return clientErrorToFhirError(authzClient);
    } else {

        AuthzResponse|http:ClientError authzRes = authzClient->post("/", authzRequest);
        if authzRes is http:ClientError {
            return clientErrorToFhirError(authzRes);
        } else {
            if !authzRes.isAuthorized {
                return createFHIRError("Unauthorized", ERROR, SECURITY, httpStatusCode = http:STATUS_UNAUTHORIZED);
            }
            log:printDebug("User authorized", PatientId = patientId, Scope = authzRes.scope);
        }
    }
}
