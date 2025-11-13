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
