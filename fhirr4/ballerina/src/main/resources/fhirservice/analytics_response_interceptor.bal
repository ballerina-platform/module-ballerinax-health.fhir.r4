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
import ballerina/log;
import ballerinax/health.fhir.r4;

# AnalyticsConfig Record.
#
# + enabled - if analytics is enabled or not
# + publisher - the analytics publisher to use (e.g., "moesif", "opensearch")
public type AnalyticsConfig readonly & record {|
    boolean enabled = false;
    string[] attributes = ["fhirUser", "client_id", "iss"];
    string publisher = "opensearch";
|};

# Mandatory header to be present in the request for analytics
const X_JWT_HEADER = "x-jwt-assertion";

configurable AnalyticsConfig analytics = {};

# AnalyticsResponseInterceptor is an HTTP response interceptor that publishes analytics data
isolated service class AnalyticsResponseInterceptor {
    *http:ResponseInterceptor;

    private r4:FhirAnalyticsPublisher? analyticsPublisher = ();

    # Initializes the appropriate analytics publisher based on configuration
    #
    # + apiConfig - The API configuration
    function init(r4:ResourceAPIConfig apiConfig) {
        
        if analytics.enabled {
            // Select the appropriate publisher based on configuration
            if analytics.publisher == "moesif" {
                r4:FhirAnalyticsPublisher? fhirAnalyticsPublisher = r4:fhirRegistry.getFhirAnalyticsPublisher(analytics.publisher);
                if fhirAnalyticsPublisher is r4:FhirAnalyticsPublisher {
                    self.analyticsPublisher = fhirAnalyticsPublisher;
                    log:printDebug(`[AnalyticsResponseInterceptor] Moesif analytics publisher obtained from FHIR registry.`);
                } else {
                    r4:fhirRegistry.registerAnalyticsPublisher(analytics.publisher, new MoesifAnalyticsPublisher(apiConfig));
                    self.analyticsPublisher = r4:fhirRegistry.getFhirAnalyticsPublisher(analytics.publisher);
                    log:printDebug(`[AnalyticsResponseInterceptor] Moesif was not found in registry. Registered now.`);
                }
            } else if analytics.publisher == "opensearch" {
                r4:FhirAnalyticsPublisher? fhirAnalyticsPublisher = r4:fhirRegistry.getFhirAnalyticsPublisher(analytics.publisher);
                if fhirAnalyticsPublisher is r4:FhirAnalyticsPublisher {
                    self.analyticsPublisher = fhirAnalyticsPublisher;
                    log:printDebug(`[AnalyticsResponseInterceptor] OpenSearch analytics publisher obtained from FHIR registry.`);
                } else {
                    r4:fhirRegistry.registerAnalyticsPublisher(analytics.publisher, new OpenSearchAnalyticsPublisher(apiConfig));
                    self.analyticsPublisher = r4:fhirRegistry.getFhirAnalyticsPublisher(analytics.publisher);
                    log:printDebug(`[AnalyticsResponseInterceptor] OpenSearch analytics publisher was not found in registry. Registered now.`);
                }
            } else {
                log:printWarn(`[AnalyticsResponseInterceptor] Invalid analytics publisher name configured. Skipping analytics data publishing.`);
                self.analyticsPublisher = ();
            }
        }
    }

    remote isolated function interceptResponse(http:RequestContext ctx, http:Request req, http:Response res) returns http:NextService|error? {

        if !analytics.enabled {
            log:printDebug(`[AnalyticsResponseInterceptor] Analytics is disabled. Skipping analytics data publishing.`);
            return ctx.next();
        }

        map<string[]> requestHeaders = getRequestHeaders(req);
        map<string[]> responseHeaders = getResponseHeaders(res);
        json|http:ClientError requestPayload = req.getJsonPayload();
        json|http:ClientError responsePayload = res.getJsonPayload();
        int statusCode = res.statusCode;
        string requestPath  = req.rawPath;

        string|error xJWT = req.getHeader(X_JWT_HEADER);
        if xJWT is error {
            log:printWarn(`[AnalyticsResponseInterceptor] Skipped publishing analytics data. Error: Missing x-jwt-assertion header.`);
            return ctx.next();
        }

        r4:FhirAnalyticsPublisher? analyticsPublisher;
        lock {
	        analyticsPublisher = self.analyticsPublisher;
        }

        // Publish analytics data asynchronously
        if analyticsPublisher is r4:FhirAnalyticsPublisher {
            log:printDebug(`[AnalyticsResponseInterceptor] Publishing analytics data using ${analytics.publisher} publisher.`);
            future<error?> _ = start analyticsPublisher.publish(requestHeaders.cloneReadOnly(), requestPayload.clone(), responseHeaders.cloneReadOnly(), responsePayload.clone(), statusCode, requestPath.cloneReadOnly());
        }
        return ctx.next();
    }
}
