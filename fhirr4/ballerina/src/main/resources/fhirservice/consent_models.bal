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

# Represents a consent element with user approval status.
# Contains information about specific data elements that can be accessed under a consent purpose.
#
# + name - The name of the consent element (e.g., "fhir-patient-v1")
# + isUserApproved - Indicates whether the user has approved this element
# + value - Additional attributes or metadata associated with the element
# + isMandatory - Indicates whether this element is mandatory
# + type - The type of the element (e.g., "string-type")
# + description - Description of what this element allows
# + properties - Additional properties containing resource-specific information
public type ConsentElement record {|
    string name;
    boolean isUserApproved;
    record {} value?;
    boolean isMandatory?;
    string 'type?;
    string description?;
    record {} properties?;
|};

# Represents a purpose with associated elements.
# Defines the purpose for which consent is being requested along with the specific data elements.
#
# + name - The name of the consent purpose (e.g., "access-all-health-data")
# + elements - Array of consent elements associated with this purpose
public type ConsentPurpose record {|
    string name;
    ConsentElement[] elements;
|};

# Represents an authorization entry.
# Contains information about a user's authorization for a specific consent.
#
# + id - Unique identifier for the authorization
# + userId - The user ID associated with this authorization (e.g., "Patient/991")
# + type - The type of authorization (e.g., "authorisation")
# + status - The current status of the authorization (e.g., "APPROVED", "REJECTED")
# + updatedTime - The timestamp when this authorization was last updated (in milliseconds)
# + resources - Additional resource information associated with the authorization
public type ConsentAuthorization record {|
    string id?;
    string userId?;
    string 'type?;
    string status?;
    int updatedTime?;
    record {} resources?;
|};

# Represents a single consent record.
# Contains comprehensive information about a user's consent including purposes, authorizations, and validity.
#
# + id - Unique identifier for the consent
# + purposes - Array of purposes for which the consent is granted
# + createdTime - The timestamp when this consent was created (in milliseconds)
# + updatedTime - The timestamp when this consent was last updated (in milliseconds)
# + clientId - The client application ID that requested this consent
# + type - The type of consent (e.g., "healthcare")
# + status - The current status of the consent (e.g., "ACTIVE", "CREATED", "REVOKED")
# + frequency - The frequency of data access allowed under this consent
# + validityTime - The timestamp until which this consent is valid (in milliseconds)
# + recurringIndicator - Indicates whether this consent allows recurring access
# + dataAccessValidityDuration - Duration for which data access is valid under this consent
# + attributes - Additional custom attributes associated with the consent
# + authorizations - Array of authorization entries for this consent
public type Consent record {|
    string id?;
    ConsentPurpose[] purposes?;
    int createdTime?;
    int updatedTime?;
    string clientId?;
    string 'type?;
    string status?;
    int frequency?;
    int validityTime?;
    boolean recurringIndicator?;
    int dataAccessValidityDuration?;
    record {} attributes?;
    ConsentAuthorization[] authorizations?;
|};

# Represents metadata for the consent response.
# Contains pagination and result count information.
#
# + total - Total number of consents available matching the query
# + limit - Maximum number of consents returned in this response
# + offset - The starting position of the returned results
# + count - Actual number of consents returned in this response
public type ResponseMetadata record {|
    int total?;
    int 'limit?;
    int offset?;
    int count?;
|};

# Represents the complete consent response from the Open FGC API.
# Contains an array of consent records along with pagination metadata.
#
# + data - Array of consent records
# + metadata - Pagination and result count metadata
public type ConsentResponse record {|
    Consent[] data?;
    ResponseMetadata metadata?;
|};

# Represents a consent validation response containing detailed consent information.
# This is returned by the /api/v1/consents/validate endpoint.
#
# + isValid - Indicates whether the consent is valid
# + errorCode - Error code returned when validation fails
# + errorMessage - Error message returned when validation fails
# + errorDescription - Detailed description of the validation error
# + consentInformation - Detailed information about the validated consent
public type ConsentValidationResponse record {|
    boolean isValid?;
    int|string errorCode?;
    string errorMessage?;
    string errorDescription?;
    Consent consentInformation?;
|};
