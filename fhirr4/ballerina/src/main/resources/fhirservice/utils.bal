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
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.ips;
import ballerinax/health.fhir.r4.parser;
import ballerina/http;
import ballerina/log;

isolated http:Client? conditionalInvokationClient = ();

isolated function createConditionalInvokationClient(int port) returns error? {
    lock {
	    conditionalInvokationClient = check new ("http://localhost:" + port.toBalString());
    }
}

isolated function addPagination(r4:PaginationContext paginationContext, map<r4:RequestSearchParameter[]> requestSearchParameters,
        r4:Bundle bundle, string path) returns r4:Bundle {
    r4:BundleLink[] allLinks = [];

    // construct query string from processed search params
    string qString = "";
    foreach r4:RequestSearchParameter[] params in requestSearchParameters {
        foreach r4:RequestSearchParameter param in params {
            if param.name == COUNT {
                continue;
            }
            qString = qString + string `${param.name}=${param.value}&`;
        }
    }
    if qString.endsWith("&") {
        qString = qString.substring(0, qString.length() - 1);
    }

    int currentpage = paginationContext.page;
    int pageSize = paginationContext.pageSize;

    // populate self link
    r4:BundleLink selfLink = constructUrl(qString, "self", path, pageSize, currentpage);

    allLinks.push(selfLink);

    r4:BundleEntry[]? entries = bundle.entry;
    if entries is r4:BundleEntry[] && entries.length() < pageSize {
        // no next link
    } else {
        // populate next link
        r4:BundleLink nextLink = constructUrl(qString, "next", path, pageSize, currentpage + 1);
        allLinks.push(nextLink);
    }

    if currentpage > 1 {
        // previous link exists
        // populate previous link
        r4:BundleLink prevLink = constructUrl(qString, "prev", path, pageSize, currentpage - 1);
        allLinks.push(prevLink);
    }

    bundle.link = allLinks;
    return bundle;
}

isolated function constructUrl(string qString, string relation, string path, int count, int page) returns r4:BundleLink {
    string url = qString.length() > 0 ? string `${path}?${qString}&${PAGE}=${page}&${COUNT}=${count}` : string `${path}?${PAGE}=${page}&${COUNT}=${count}`;
    return {
        relation: relation,
        url: string `${url}`
    };
}

isolated function handleBundleInfo(r4:Bundle bundle, r4:FHIRContext fhirCtx, string path) returns r4:Bundle {
    r4:PaginationContext? paginationContext = <r4:PaginationContext?>fhirCtx.getPaginationContext();
    if paginationContext is r4:PaginationContext {
        if paginationContext.paginationEnabled {
            return addPagination(paginationContext, fhirCtx.getRequestSearchParameters(), bundle, path);
        } else {
            // populate bundle total
            r4:BundleEntry[]? entries = bundle.entry;
            if entries is r4:BundleEntry[] {
                bundle.total = entries.length();
            }
            return bundle;
        }
    }
    return bundle;
}

isolated function handleConditionalHeader(string conditionalUrl, string resourcePath, string authHeader = "") returns r4:FHIRError? {
    int? indexOfSearchParams = conditionalUrl.indexOf("?");
    string searchParams = indexOfSearchParams is int ? conditionalUrl.substring(indexOfSearchParams) : "";

    do {
        r4:Bundle bundle;

        // Obtain client reference inside lock (isolated module-level var requires lock access)
        http:Client? clientRef;
        lock {
            clientRef = conditionalInvokationClient;
        }

        if clientRef is () {
            return;
        }

        // Build headers and make HTTP call outside lock (mutable map not allowed inside lock)
        map<string|string[]> reqHeaders = {};
        if authHeader != "" {
            reqHeaders["Authorization"] = authHeader;
        }
        http:Response response = check clientRef->get(resourcePath + searchParams, reqHeaders);

        if response.statusCode == http:STATUS_NOT_FOUND {
            // allow to create a new resource if no entries are found
            log:printDebug("No existing resource found for the given search criteria, allowing creation of a new resource");
            return;
        }

        // Extract the entity and decode to r4:Bundle
        bundle = check parser:parse(check response.getJsonPayload()).ensureType();

        r4:BundleEntry[]? entries = bundle.entry;
        if entries is r4:BundleEntry[] {
            // check the bundle entry count
            if entries.length() == 0 {
                // allow to create a new resource if no entries are found
                log:printDebug("No existing resource found for the given search criteria, allowing creation of a new resource");
                return;
            } else if entries.length() == 1 {
                // exising resource found, return 200
                log:printDebug("Existing resource found for the given search criteria, returning 200 OK");
                return r4:createFHIRError(
                        "Resource already exists for the given search criteria",
                        r4:INFORMATION,
                        r4:PROCESSING_DUPLICATE,
                        httpStatusCode = http:STATUS_OK);
            } else {
                // return 412 Precondition Failed if more than one entry is found
                log:printDebug("Multiple resources found for the given search criteria, returning 412 Precondition Failed");
                return r4:createFHIRError(
                        "Multiple resources found for the given search criteria",
                        r4:ERROR,
                        r4:INVALID,
                        httpStatusCode = http:STATUS_PRECONDITION_FAILED);
            }
        } else {
            return r4:createFHIRError("Invalid response received while handling conditional search", r4:ERROR, r4:INVALID);
        }
    } on fail var e {
        // log the error and return a FHIR error
        return r4:createFHIRError("Error while handling conditional search: " + e.message(), r4:ERROR, r4:INVALID);
    }
}

# Execute a search request to find matching resources for conditional operations.
# This function is used for conditional update and conditional delete operations to find existing resources based on search criteria provided in the request header.
# Resource server should support get requests with search parameters. 
# + resourcePath - The resource path (e.g., "/Patient")
# + searchParams - The search query string (e.g., "?identifier=12345")
# + authHeader - The authorization header for authentication (optional, defaults to empty string)
# + return - A Bundle with search results or FHIRError on failure
isolated function HandleSearchForConditionalInteractions(string resourcePath, string searchParams, string authHeader = "")
        returns r4:Bundle|r4:FHIRError {

    log:printDebug(string `Executing conditional search: ${resourcePath}${searchParams}`);

    // Check if conditional invocation client is initialized
    http:Client? httpClient;
    lock {
        httpClient = conditionalInvokationClient;
    }

    if httpClient is () {
        log:printError("Conditional invocation client is not initialized");
        return r4:createFHIRError(
            "Internal server error: HTTP client not initialized",
            r4:ERROR, r4:PROCESSING,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
        );
    }

    // Construct full URL for search
    string searchUrl = resourcePath + searchParams;

    // Execute HTTP GET request, forwarding the Authorization header if present
    map<string|string[]> reqHeaders = {};
    if authHeader != "" {
        reqHeaders["Authorization"] = authHeader;
    }
    http:Response|http:ClientError response = httpClient->get(searchUrl, reqHeaders);

    if response is http:ClientError {
        log:printError("Error executing conditional search", response);
        return r4:createFHIRError(
            string `Failed to execute search for conditional update: ${response.message()}`,
            r4:ERROR, r4:PROCESSING,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
        );
    }

    int statusCode = response.statusCode;

    if statusCode == http:STATUS_NOT_FOUND {
        // No resources found - return empty bundle
        r4:Bundle emptyBundle = {
            resourceType: "Bundle",
            'type: r4:BUNDLE_TYPE_SEARCHSET,
            total: 0,
            entry: []
        };
        return emptyBundle;
    }

    if statusCode != http:STATUS_OK {
        log:printError(string `Unexpected status code from search: ${statusCode}`);
        return r4:createFHIRError(
            string `Search returned unexpected status code: ${statusCode}`,
            r4:ERROR, r4:PROCESSING,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
        );
    }

    // Parse response as Bundle
    json|http:ClientError jsonPayload = response.getJsonPayload();
    if jsonPayload is http:ClientError {
        log:printError("Error parsing search response", jsonPayload);
        return r4:createFHIRError(
            "Failed to parse search response as JSON",
            r4:ERROR, r4:PROCESSING,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
        );
    }

    // Validate it's a Bundle
    json|error resourceTypeJson = jsonPayload.resourceType;
    if resourceTypeJson is error {
        return r4:createFHIRError(
            "Search response has no resourceType field",
            r4:ERROR, r4:PROCESSING,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
        );
    }

    string resourceType = resourceTypeJson.toString();
    if resourceType != "Bundle" {
        return r4:createFHIRError(
            "Search response is not a FHIR Bundle",
            r4:ERROR, r4:PROCESSING,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
        );
    }

    // Convert to Bundle type
    r4:Bundle|error bundle = jsonPayload.cloneWithType(r4:Bundle);
    if bundle is error {
        log:printError("Error converting to Bundle type", bundle);
        return r4:createFHIRError(
            "Failed to convert search response to Bundle",
            r4:ERROR, r4:PROCESSING,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
        );
    }

    log:printDebug(string `Search returned ${bundle.total ?: 0} matches`);
    return bundle;
}

# Construct query string from search parameters map.
#
# + params - Map of search parameters
# + return - Query string (e.g., "?identifier=123&name=John")
isolated function constructSearchQueryString(map<r4:RequestSearchParameter[]> params) returns string {
    if params.length() == 0 {
        return "";
    }

    string[] queryParts = [];

    foreach r4:RequestSearchParameter[] paramArray in params {
        foreach r4:RequestSearchParameter param in paramArray {
            // Format: name=value
            string paramString = param.name + "=" + param.value;
            queryParts.push(paramString);
        }
    }

    return "?" + string:'join("&", ...queryParts);
}

isolated function handleIpsGeneration(string patientId, r4:FHIRServiceInfo patientServiceInfo, map<string> serviceResourceMap, r4:OperationConfig[] patientOperationConfigs) returns r4:Bundle|error {
    log:printDebug("Handling IPS generation for Patient resource with ID: " + patientId);

    foreach r4:OperationConfig patientOperation in patientOperationConfigs {
        if patientOperation.name == SUMMARY_OPERATION {
            ips:IpsSectionConfig[]|error? ipsSectionConfig = ();
            ips:IpsMetaData|error? ipsMetaData = ();

            json? additionalProperties = patientOperation?.additionalProperties;
            if additionalProperties is map<json> {
                ipsSectionConfig = additionalProperties[IPS_SECTION_CONFIG].cloneWithType();
                ipsMetaData = additionalProperties[IPS_META_DATA].cloneWithType();
            } else {
                log:printDebug("IPS Section Config is not provided, using default configuration.");
            }
            
            ips:IPSContext|error ipsContext = new (
                serviceResourceMap, 
                ipsMetaData = ipsMetaData is ips:IpsMetaData? ? ipsMetaData : (),
                ipsSectionConfig = ipsSectionConfig is ips:IpsSectionConfig[]? ? ipsSectionConfig : ()
            );

            if ipsContext is error {
                log:printError("Error initializing IPS context: " + ipsContext.message());
                return r4:createFHIRError(ipsContext.message(), r4:ERROR, r4:PROCESSING);
            }

            lock {
                r4:Bundle|error ipsBundle = ips:generateIps(patientId, ipsContext);
                if ipsBundle is error {
                    log:printError("Error generating IPS bundle: " + ipsBundle.message());
                    return r4:createFHIRError(ipsBundle.message(), r4:ERROR, r4:PROCESSING);
                }

                return ipsBundle;
            }
        }
    }
    
    return r4:createFHIRError("IPS operation not supported for Patient resource",
            r4:ERROR, r4:PROCESSING, diagnostic = "The '$summary' operation for IPS generation is not available for Patient resources. Please ensure the IPS operation is properly configured.",
            httpStatusCode = http:STATUS_BAD_REQUEST);
}

isolated function validateOperationConfigs(r4:ResourceAPIConfig apiConfig) returns r4:FHIRError? {
    foreach r4:OperationConfig operation in apiConfig.operations {
        // validate the summary operation
        if operation.name == SUMMARY_OPERATION {
            json? additionalProperties = operation?.additionalProperties;
            if additionalProperties is map<json> {
                ips:IpsSectionConfig[]|error? ipsSectionConfig = additionalProperties[IPS_SECTION_CONFIG].cloneWithType();
                ips:IpsMetaData|error? ipsMetaData = additionalProperties[IPS_META_DATA].cloneWithType();
                if ipsSectionConfig is ips:IpsSectionConfig[] && ipsMetaData is ips:IpsMetaData? {
                    string[]? errors = ips:validateSectionConfig(ipsSectionConfig, ipsMetaData);
                    if errors is string[] {
                        if errors.length() > 0 {
                            return r4:createFHIRError("IPS Section Config validation failed: " + errors.toString().substring(1, errors.toString().length() - 1), r4:ERROR, r4:INVALID);
                        }
                    }
                }
            }
        }

        // add the validation for other operations if needed
    }
    return;
}
