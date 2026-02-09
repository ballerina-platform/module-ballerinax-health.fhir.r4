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

const X_JWT_HEADER = "x-jwt-assertion";
final string rotationErrorMessage = "Error rotating analytics log file";
final string logFileName = "cms-analytics.log";

# Represents a FHIR service type
public type Service distinct service object{};

# Represents the request information
public type Request record {|
    # Request time
    string time;
    # Full URI of the request
    string uri;
    # HTTP verb
    string verb;
    #API version
    string api_version?;
    # IP address of the requester
    string ip_address?;
    # Request headers
    json headers;
    # Request body
    json body?;
    # Transfer encoding
    string transfer_encoding?;
|};

# Represents the response information
public type Response record {|
    # Time of the response
    string time;
    # Status code of the response
    int status;
    # Response headers
    json headers;
    # Response body
    json body?;
    # Transfer encoding
    string transfer_encoding?;
|};

# Represents the complete analytics data structure
public type AnalyticsData record {|
    # Request
    Request request;
    # Response
    Response response?;
    # User ID
    string user_id?;
    # Company ID
    string company_id?;
    # Transaction ID
    string transaction_id?;
    # Trace ID
    string trace_id?;
    # Metadata
    json metadata?;
|};

# AnalyticsConfig Record.
#
# + enabled - if analytics is enabled or not
# + jwtAttributes - the attributes that should be extracted from JWT for analytics
# + shouldPublishPayloads - whether to include request/response payloads in analytics
# + analyticsFilePath - the file path where analytics logs are stored
# + excludedApis - list of API paths to exclude from analytics
public type AnalyticsConfig readonly & record {|
    boolean enabled = false;
    string[] jwtAttributes = ["fhirUser", "client_id", "iss"];
    boolean shouldPublishPayloads = false;
    string analyticsFilePath = "/logs/";
    string[] excludedApis = ["bulk-export"];
    AnalyticsPayloadEnrich enrichAnalyticsPayload?;
|};

# MoreInfoConfig Record.
#
# + enabled - if more info fetching is enabled or not  
# + url - the URL to fetch more information  
# + username - the username for the more info server  
# + password - the password for the more info server
public type AnalyticsPayloadEnrich readonly & record {|
    boolean enabled = false;
    string url?;
    string username?;
    string password?;
|};