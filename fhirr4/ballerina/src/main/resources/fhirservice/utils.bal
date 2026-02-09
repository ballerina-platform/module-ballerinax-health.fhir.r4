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
import ballerina/time;
import ballerina/file;
import ballerina/io;
import ballerina/jwt;

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

isolated function handleConditionalHeader(string conditionalUrl, string resourcePath) returns r4:FHIRError? {
    int? indexOfSearchParams = conditionalUrl.indexOf("?");
    string searchParams = indexOfSearchParams is int ? conditionalUrl.substring(indexOfSearchParams) : "";

    do {
        r4:Bundle bundle;
        http:Response? response = ();

        lock {
            if conditionalInvokationClient is () {
                return;
            }

            // send a http request to the resourcePath
            response = check (<http:Client>conditionalInvokationClient)->get(resourcePath + searchParams);
        }

        if response is http:Response {
            if response.statusCode == http:STATUS_NOT_FOUND {
                // allow to create a new resource if no entries are found
                log:printDebug("No existing resource found for the given search criteria, allowing creation of a new resource");
                return;
            } 

            // Extract the entity and decode to r4:Bundle
            bundle = check parser:parse(check response.getJsonPayload()).ensureType();
        } else {
            return r4:createFHIRError("Failed to get a valid HTTP response", r4:ERROR, r4:INVALID);
        }

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
<<<<<<< HEAD
=======

# Retrieves all headers from an HTTP request
#
# + request - The HTTP request object
# + return - A map containing all header names as keys and their first values as strings
isolated function getRequestHeaders(http:Request request) returns map<string> {
    
    map<string> headers = {};
    string[] headerNames = request.getHeaderNames();
    
    foreach string headerName in headerNames {
        string[]|http:HeaderNotFoundError headerValues = request.getHeaders(headerName);
        if headerValues is string[] && headerValues.length() > 0 {
            if headerValues.length() == 1 {
                headers[headerName] = headerValues[0];
            } else {
                // Join multiple values with comma and space as per HTTP specification
                headers[headerName] = string:'join(", ", ...headerValues);
            }
        }
    }
    return headers;
}

# Retrieves all headers from an HTTP response
#
# + response - The HTTP response object
# + return - A map containing all header names as keys and their values as strings
isolated function getResponseHeaders(http:Response response) returns map<string> {
    
    map<string> headers = {};
    string[] headerNames = response.getHeaderNames();
    
    foreach string headerName in headerNames {
        string[]|http:HeaderNotFoundError headerValues = response.getHeaders(headerName);
        if headerValues is string[] && headerValues.length() > 0 {
            if headerValues.length() == 1 {
                headers[headerName] = headerValues[0];
            } else {
                // Join multiple values with comma and space as per HTTP specification
                headers[headerName] = string:'join(", ", ...headerValues);
            }
        }
    }
    return headers;
}

# Retrieves more information from the configured URL
#
# + data - The log data to send to retrieve more information
# + moreInfoClient - The HTTP client to use for fetching more information
# + return - A JSON object containing additional information
isolated function getMoreInfo(json data, http:Client|http:ClientError moreInfoClient) returns json {
    
    if moreInfoClient is http:ClientError {
        log:printError(`[AnalyticsResponseInterceptor] Failed to create HTTP client for fetching additional information`);
        return {};
    } else {
        http:Response|http:ClientError result = moreInfoClient->/.post(data);
        if (result is http:Response) {
            json|error payload = result.getJsonPayload();
            if payload is json {
                return payload;
            } else {
                log:printError(`[AnalyticsResponseInterceptor] Failed to extract JSON payload from More Info response.`);
                return {};
            }
        } else {
            log:printError(`[AnalyticsResponseInterceptor] Failed to fetch more info from ${analytics.enrichAnalyticsPayload?.url} [Error]: ${result.toString()}`);
            return {};
        }
    }
}

isolated function enrichAnalyticsData(map<string> analyticsData) {
    
    http:Client|http:ClientError? dataEnrichHttpClient;

    final string? moreInfoUrl = analytics.enrichAnalyticsPayload?.url;
    final string? moreInfoUsername = analytics.enrichAnalyticsPayload?.username;
    final string? moreInfoPassword = analytics.enrichAnalyticsPayload?.password;

    if moreInfoUrl is () {
        dataEnrichHttpClient = ();
    } else if moreInfoUsername !is () && moreInfoPassword !is () {
        dataEnrichHttpClient = new (moreInfoUrl, auth = {
            username: moreInfoUsername,
            password: moreInfoPassword
        });
    } else {
        dataEnrichHttpClient = new (moreInfoUrl);
    }

    if dataEnrichHttpClient !is http:ClientError && dataEnrichHttpClient is http:Client {
        json moreInfo = getMoreInfo(analyticsData.toJson(), dataEnrichHttpClient);

        log:printDebug(`[AnalyticsResponseInterceptor] More info fetched from: ${analytics.enrichAnalyticsPayload?.url} [More info]: ${moreInfo.toString()}`);
        foreach var [key, value] in (<map<json>>moreInfo).entries() {
            analyticsData[key] = value.toString();
        }
    }
}

// Calculate civil time for next day 12 AM
isolated function calculateDelayUntilMidnight() returns time:Civil {
    time:Utc currentUtc = time:utcNow();
    time:Civil currentCivil = time:utcToCivil(currentUtc);

    // Calculate next midnight
    time:Civil nextMidnight = {
        year: currentCivil.year,
        month: currentCivil.month,
        day: currentCivil.day + 1,
        hour: 0,
        minute: 0,
        second: 0.0,
        utcOffset: currentCivil.utcOffset
    };

    return nextMidnight;
}

# Check if the request path matches any of the excluded APIs for analytics
# 
# + requestPath - the API request path
# + return - true if the request path matches any of the excluded APIs, false otherwise
isolated function isFileExist(string requestPath) returns boolean|error? {

    return file:test(requestPath, file:EXISTS);
}

# Check if the request path matches any of the excluded APIs for analytics
#
# + requestPath - the API request path
# + return - true if the request path matches any of the excluded APIs, false otherwise
isolated function isExcludedApi(string requestPath) returns boolean {
    
    foreach string excludedApi in analytics.excludedApis {
        if requestPath.toLowerAscii().includes(excludedApi.toLowerAscii()) {
            log:printWarn(`[AnalyticsResponseInterceptor] Request path ${requestPath} is excluded from analytics. 
                                                                                    Skipping analytics data writing.`);
            return true;
        }
    }
    return false;
}

# Write data to a file at the specified path
#
# + path - The file path where the data should be written
# + data - The string data to write to the file
# + return - An error if the write operation fails, otherwise returns nothing
isolated function writeDataToFile(string path, string data) returns error? {
    
    return io:fileWriteString(path, data, io:APPEND);
}

# Decode a JWT token and return its header and payload
#
# + jwt - The JWT token string to decode
# + return - A tuple containing the decoded JWT
isolated function decodeJWT(string jwt) returns [jwt:Header, jwt:Payload]|error {

    return jwt:decode(jwt);
}

# Extract analytics data from the decoded JWT based on the configured attributes
#
# + dataAttributes - The list of attributes to extract from the JWT payload
# + jwtPayload - The decoded JWT payload
# + return - A map containing the extracted analytics data
isolated function extractAnalyaticsDataFromJWT(string[] dataAttributes, jwt:Payload jwtPayload) returns map<string> {

    return map from string attrKey in dataAttributes
            where jwtPayload[attrKey] !== ()
            select [attrKey, jwtPayload[attrKey].toString()];
}

# Convert a map to a JSON object
#
#  + data - The map to convert to JSON
# + return - A JSON object representing the input map
isolated function convertMapToJson(map<string> data) returns json {
    
    return map from string headerKey in data.keys()
            select [headerKey, data[headerKey].toString()];
}


>>>>>>> 653d368... Add CMS analytics implementation
