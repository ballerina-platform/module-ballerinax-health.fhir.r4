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

import ballerina/http;
import ballerina/log;
import ballerina/url;
import ballerinax/health.fhir.r4;

// Constants for API communication
const string CONTENT_TYPE_JSON = "application/json";
const string ACCEPT_HEADER = "application/json";
const string CONSENTS_API_PATH = "/api/v1/consents";
const string VALIDATE_CONSENT_API_PATH = "/api/v1/consents/validate";
const string ACTIVE_CONSENT_STATUS = "ACTIVE";
const string DEFAULT_ORG_ID = "ORG-001";

# ConsentEnforcementConfig Record.
#
# + enabled - if consent enforcement is enabled or not
# + openFgcClient - Configuration for Open FGC client
public type ConsentEnforcementConfig readonly & record {|
    boolean enabled = false;
    OpenFgcClientConfig openFgcClient?;
|};

# OpenFgcClientConfig Record.
#
# + url - Open FGC server URL
# + username - Open FGC client basicAuth username
# + password - Open FGC client basicAuth password
# + orgId - Organization ID for API requests
public type OpenFgcClientConfig record {|
    string url?;
    string username?;
    string password?;
    string orgId = DEFAULT_ORG_ID;
|};

configurable ConsentEnforcementConfig consentEnforcement = {};

# Default implementation of the ConsentEnforcer interface.
# Checks if the resource type matches any approved consent element.
public isolated class DefaultConsentEnforcer {
    *ConsentEnforcer;

    final http:Client? openFgcClient;
    final boolean enabled;
    final string orgId;

    # Initializes the DefaultConsentEnforcer and creates the OpenFGC client
    public isolated function init() {
        self.enabled = consentEnforcement.enabled;
        self.orgId = consentEnforcement.openFgcClient?.orgId ?: DEFAULT_ORG_ID;

        final string? openFgcUrl = consentEnforcement.openFgcClient?.url;
        final string? openFgcUsername = consentEnforcement.openFgcClient?.username;
        final string? openFgcPassword = consentEnforcement.openFgcClient?.password;

        // Initialize the openFgcClient for consent management
        if !consentEnforcement.enabled {
            self.openFgcClient = ();
        } else {
            if openFgcUrl is () {
                log:printError("Consent enforcement is enabled but OpenFGC URL is not configured");
                self.openFgcClient = ();
                return;
            }
            if openFgcUsername !is () && openFgcPassword !is () {
                http:Client|http:ClientError clientResult = new (openFgcUrl, auth = {
                    username: openFgcUsername,
                    password: openFgcPassword
                });
                if clientResult is http:Client {
                    self.openFgcClient = clientResult;
                } else {
                    log:printError(string `Failed to create OpenFGC client with authentication for URL: ${openFgcUrl}, username: ${openFgcUsername}`, 'error = clientResult);
                    self.openFgcClient = ();
                }
            } else {
                http:Client|http:ClientError clientResult = new (openFgcUrl);
                if clientResult is http:Client {
                    self.openFgcClient = clientResult;
                } else {
                    log:printError(string `Failed to create OpenFGC client for URL: ${openFgcUrl}`, 'error = clientResult);
                    self.openFgcClient = ();
                }
            }
        }
        return;
    }

    # Retrieves consent information related to action
    #
    # + userIds - Comma-separated user IDs to filter by
    # + consentStatuses - Comma-separated consent statuses to filter by
    # + return - ConsentResponse if successful, or an error if the consent details retrieval fails
    public isolated function getConsentDetails(string userIds, string consentStatuses = ACTIVE_CONSENT_STATUS) returns ConsentResponse|error {
        http:Client? openFgcClient = self.openFgcClient;
        if openFgcClient is () {
            return error("OpenFGC client is not configured");
        }

        log:printDebug("Retrieving consent details for userIds: " + userIds + " with consentStatuses: " + consentStatuses);

        map<string|string[]> headers = {
            "org-id": self.orgId,
            "Accept": ACCEPT_HEADER
        };

        string encodedConsentStatuses = check url:encode(consentStatuses, "UTF-8");
        string encodedUserIds = check url:encode(userIds, "UTF-8");
        string path = string `${CONSENTS_API_PATH}?consentStatuses=${encodedConsentStatuses}&userIds=${encodedUserIds}`;

        http:Response res = check openFgcClient->get(path, headers = headers);

        // Validate HTTP response status before deserialization
        int statusCode = res.statusCode;
        if statusCode < 200 || statusCode >= 300 {
            string errorBody = res.getTextPayload() is string ? check res.getTextPayload() : "Unable to read response body";
            log:printError(string `Failed to retrieve consent details. Status: ${statusCode}, Body: ${errorBody}`);
            return error(string `HTTP ${statusCode}: Failed to retrieve consent details - ${errorBody}`);
        }

        json payload = check res.getJsonPayload();

        // Parse the JSON response to ConsentResponse model
        ConsentResponse consentResponse = check payload.fromJsonWithType();

        return consentResponse;
    }

    # Validates a consent using its ID and retrieves detailed consent information
    #
    # + consentId - The unique identifier of the consent to validate
    # + return - ConsentValidationResponse if successful, or an error if validation fails
    public isolated function validateConsent(string consentId) returns ConsentValidationResponse|error {
        http:Client? openFgcClient = self.openFgcClient;
        if openFgcClient is () {
            return error("OpenFGC client is not configured");
        }

        log:printDebug(string `Validating consent: ${consentId}`);

        map<string|string[]> headers = {
            "org-id": self.orgId,
            "Content-Type": CONTENT_TYPE_JSON,
            "Accept": ACCEPT_HEADER
        };

        json payload = {
            "consentId": consentId
        };

        http:Response res = check openFgcClient->post(VALIDATE_CONSENT_API_PATH, payload, headers = headers);

        // Validate HTTP response status before deserialization
        int statusCode = res.statusCode;
        if statusCode < 200 || statusCode >= 300 {
            string errorBody = res.getTextPayload() is string ? check res.getTextPayload() : "Unable to read response body";
            log:printError(string `Failed to validate consent. Status: ${statusCode}, Body: ${errorBody}`);
            return error(string `HTTP ${statusCode}: Failed to validate consent - ${errorBody}`);
        }

        json responsePayload = check res.getJsonPayload();
        log:printDebug(string `Validation response: ${responsePayload.toJsonString()}`);

        // Parse the JSON response to ConsentValidationResponse model
        ConsentValidationResponse validationResponse = check responsePayload.fromJsonWithType();

        return validationResponse;
    }

    # Gets and validates all consents for a user
    #
    # + patientId - The patient ID to retrieve consents for
    # + return - ConsentResponse with validated consents or an error
    public isolated function getAndValidateConsents(string patientId) returns ConsentResponse|error {
        if !self.enabled {
            return error("Consent enforcement is disabled");
        }

        if self.openFgcClient is () {
            return error("OpenFGC client is not configured");
        }

        log:printDebug(string `Getting and validating consents for user: ${patientId}`);

        // Get consent details
        ConsentResponse consentListResult = check self.getConsentDetails(patientId);

        int totalConsents = consentListResult.metadata?.total ?: 0;
        log:printDebug(string `Successfully retrieved consent list. Total consents: ${totalConsents}`);

        // Validate each consent and collect detailed consent information
        Consent[] validatedConsents = [];
        Consent[]? consentData = consentListResult.data;
        if consentData !is () {
            foreach Consent consent in consentData {
                string? consentId = consent.id;
                if consentId is () {
                    return error("Consent record is missing consent ID");
                }
                ConsentValidationResponse|error validationResult = self.validateConsent(consentId);

                if validationResult is error {
                    log:printError(string `Error validating consent ${consentId}: ${validationResult.message()}`);
                    return error(string `Error validating consent ${consentId}: ${validationResult.message()}`, validationResult);
                }

                boolean? isValid = validationResult.isValid;
                if isValid == true {
                    log:printDebug(string `Consent ${consentId} is valid. Adding to validated consents.`);
                    Consent? consentInfo = validationResult.consentInformation;
                    if consentInfo !is () {
                        validatedConsents.push(consentInfo);
                    }
                } else {
                    log:printDebug(string `Consent ${consentId} is not valid.`);
                }
            }
        }

        log:printDebug(string `Successfully validated ${validatedConsents.length()} consents.`);

        return {
            data: validatedConsents,
            metadata: consentListResult.metadata
        };
    }

    # Retrieves resource types approved by user consent.
    # Iterates through all consents and collects resource types from approved consent elements.
    #
    # + userID - The user ID for which consent needs to be enforced
    # + return - ConsentContext containing consented resource types or error if enforcement fails
    public isolated function enforce(string userID) returns r4:ConsentContext|error {

        // Get and validate consents using the consent enforcer
        ConsentResponse|error consentResponse = self.getAndValidateConsents(userID);
        if consentResponse is error {
            log:printError(string `Error retrieving and validating consents for user ${userID}: ${consentResponse.message()}`);
            return consentResponse;
        }

        r4:ConsentContext consentContext;

        // Check if there are any consents to enforce
        Consent[]? consentData = consentResponse.data;
        if consentData is () || consentData.length() == 0 {
            log:printDebug("No consents found for the user");
            consentContext = {
                patientID: userID,
                consentedResourceTypes: []
            };
            return consentContext;
        }

        string[] approvedResourceTypes = [];

        // Collect resource types from approved consent elements
        foreach Consent consent in consentData {
            ConsentPurpose[]? purposes = consent.purposes;
            if purposes is () {
                continue;
            }
            foreach ConsentPurpose purpose in purposes {
                ConsentElement[]? elements = purpose.elements;
                if elements is () {
                    continue;
                }
                foreach ConsentElement element in elements {
                    boolean isApproved = element.isUserApproved;
                    if isApproved {
                        string elementName = element.name;
                        log:printDebug(string `Approved Consent Element - Purpose: ${purpose.name}, Element: ${elementName}, Status: ${isApproved.toString()}`);

                        record {}? props = element.properties;
                        if props !is () && props.hasKey("resourceType") {
                            // Safe type check instead of unsafe cast
                            anydata resourceTypeValue = props["resourceType"];
                            if resourceTypeValue is string {
                                if approvedResourceTypes.indexOf(resourceTypeValue) is () {
                                    approvedResourceTypes.push(resourceTypeValue);
                                }
                            }
                        }
                    }
                }
            }
        }

        consentContext = {
            patientID: userID,
            consentedResourceTypes: approvedResourceTypes.cloneReadOnly()
        };

        return consentContext;
    }
}
