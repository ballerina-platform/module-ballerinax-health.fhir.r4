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

import ballerina/http;
# FhirAnalyticsPublisher interface defines the contract for all analytics publisher implementations.
# Each implementation must provide its own logic for publishing analytics data.
public type FhirAnalyticsPublisher isolated object {

    # Publishes the analytics data to the configured destination
    #
    # + requestHeaders - The HTTP request headers
    # + requestPayload - The HTTP request payload
    # + responseHeaders - The HTTP response headers
    # + responsePayload - The HTTP response payload
    # + statusCode - The HTTP status code of the response
    # + requestPath - The request path of the API call
    # + return - An error if the publishing fails
    public isolated function publish(map<string[]> requestHeaders, json|http:ClientError requestPayload, 
                                map<string[]> responseHeaders, json|http:ClientError responsePayload, int statusCode, 
                                string requestPath) returns error?;
};
