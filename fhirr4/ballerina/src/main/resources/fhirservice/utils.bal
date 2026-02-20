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
import ballerina/lang.regexp;

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

# Retrieves all headers from an HTTP request
#
# + request - The HTTP request object
# + excludeAuthHeader - A boolean flag indicating whether to exclude the Authorization header from the result
# 
# + return - A map containing all header names as keys and their first values as strings
isolated function getRequestHeaders(http:Request request, boolean excludeAuthHeader) returns map<string> & readonly {
    
    map<string> headers = {};
    string[] headerNames = request.getHeaderNames();
    
    foreach string headerName in headerNames {
        string[]|http:HeaderNotFoundError headerValues = request.getHeaders(headerName);
        if headerValues is string[] && headerValues.length() > 0 {
            string lowerCaseHeaderName = headerName.toLowerAscii();

            // Skip authorization header if exists
            if excludeAuthHeader && lowerCaseHeaderName == AUTHORIZATION_HEADER {
                continue;
            }

            if headerValues.length() == 1 {
                headers[lowerCaseHeaderName] = headerValues[0];
            } else {
                // Join multiple values with comma and space as per HTTP specification
                headers[lowerCaseHeaderName] = string:'join(", ", ...headerValues);
            }
        }
    }
    return headers.cloneReadOnly();
}

# Retrieves all headers from an HTTP response
#
# + response - The HTTP response object
# + return - A map containing all header names as keys and their values as strings
isolated function getResponseHeaders(http:Response response) returns map<string> & readonly {
    
    map<string> headers = {};
    string[] headerNames = response.getHeaderNames();
    
    foreach string headerName in headerNames {
        string[]|http:HeaderNotFoundError headerValues = response.getHeaders(headerName);
        if headerValues is string[] && headerValues.length() > 0 {
            string lowerCaseHeaderName = headerName.toLowerAscii();
            if headerValues.length() == 1 {
                headers[lowerCaseHeaderName] = headerValues[0];
            } else {
                // Join multiple values with comma and space as per HTTP specification
                headers[lowerCaseHeaderName] = string:'join(", ", ...headerValues);
            }
        }
    }
    return headers.cloneReadOnly();
}

# Retrieves more information from the configured URL
#
# + data - The log data to send to retrieve more information
# + dataEnrichmentHttpClient - The HTTP client to use for fetching more information
# + return - A JSON object containing additional information
isolated function getAnalyticsEnrichmentData(json data, http:Client|http:ClientError dataEnrichmentHttpClient) returns json {
    
    if dataEnrichmentHttpClient is http:ClientError {
        log:printError(`[AnalyticsResponseInterceptor] Failed to create HTTP client for fetching additional information`);
        return {};
    } else {
        http:Response|http:ClientError result = dataEnrichmentHttpClient->/.post(data);
        if (result is http:Response) {
            json|error payload = result.getJsonPayload();
            if payload is json {
                return payload;
            } else {
                log:printError(`[AnalyticsResponseInterceptor] Failed to extract JSON payload from More Info response.`);
                return {};
            }
        } else {
            log:printError(`[AnalyticsResponseInterceptor] Failed to fetch analytics enrichment data. Make sure the URL is correct and the service is reachable. ${result.toString()}`);
            return {};
        }
    }
}

# Call the analytics data enrichment service to fetch additional information and enrich the analytics data
# 
# + analyticsData - The analytics data to enrich with additional information
# + dataEnrichHttpClient - The HTTP client to use for fetching additional information
isolated function enrichAnalyticsData(map<string> analyticsData, (http:Client|http:ClientError)? dataEnrichHttpClient) {
    
    if dataEnrichHttpClient !is http:ClientError && dataEnrichHttpClient is http:Client {
        json enrichmentData = getAnalyticsEnrichmentData(analyticsData.toJson(), dataEnrichHttpClient);
        log:printDebug(`[AnalyticsResponseInterceptor] Analytics enrichment data fetched from: ${analytics.enrichPayload?.url} [Enrichment Data]: ${enrichmentData.toString()}`);
        if enrichmentData is map<json> {
            foreach var [key, value] in enrichmentData.entries() {
                analyticsData[key] = value.toString();
            }
        } else {
            log:printWarn("[AnalyticsResponseInterceptor] Enrichment data response is not a JSON object.");
        }
    }
}

# Initialize the HTTP client for fetching analytics enrichment data based on the configuration
# 
# + return - An initialized HTTP client or an error if the client could not be created
isolated function initializeEnrichmentHttpClient() returns http:Client|http:ClientError? {
    http:Client?|http:ClientError? dataEnrichHttpClient;

    final string? enrichAnalyticsDataUrl = analytics.enrichPayload?.url;
    final string? username = analytics.enrichPayload?.username;
    final string? password = analytics.enrichPayload?.password;

    if enrichAnalyticsDataUrl is () {
        dataEnrichHttpClient = ();
    } else if ((username !is () && password !is ()) && (username != "" && password != "")) {
        dataEnrichHttpClient = new (enrichAnalyticsDataUrl, auth = {
            username: username,
            password: password
        });
    } else {
        dataEnrichHttpClient = new (enrichAnalyticsDataUrl);
    }
    return check dataEnrichHttpClient;
}


# Calculate the delay until the next midnight and return it as a time:Civil value
# 
# + currentUtc - The current time in UTC
# + zone - The time zone to consider for calculating the next midnight
# + return - The time:Civil value representing the next midnight
isolated function calculateDelayUntilMidnight(time:Utc currentUtc, time:Zone zone) returns error|time:Civil {
    
    time:Utc nextDayUtc = time:utcAddSeconds(currentUtc, 86400);
    time:Civil nextDayCivil = zone.utcToCivil(nextDayUtc);

    //todo: Add the proper fix after fixing the issue: https://github.com/wso2-enterprise/wso2-integration-internal/issues/4614
    string nextDayCivilStr = check time:civilToString(nextDayCivil);
    time:Civil nextDayCivilFromStr = check time:civilFromString(nextDayCivilStr);
    
    nextDayCivilFromStr.hour = 0;
    nextDayCivilFromStr.minute = 0;
    nextDayCivilFromStr.second = 0.0;
    
    return nextDayCivilFromStr;
}

# Check if the file exists at the given request path
# 
# + requestPath - the API request path
# + return - true if the request path matches any of the excluded APIs, false otherwise
isolated function isFileExist(string requestPath) returns boolean|error? {

    return file:test(requestPath, file:EXISTS);
}

# Validate whether the incoming API request path matches the allowed/excluded API contexts configured for analytics writing and return the validation result
# 
# Only one list should be configured at a time.
# 
# When allowed list is configured, the request path should match at least one of the regex patterns in the allowed list to be allowed for analytics writing.
# When excluded list is configured, and if the path matches any of the regex patterns in the excluded list, it will not be allowed for analytics writing.
# 
# If both allowed and excluded lists are configured, only the excluded list is considered for validation. If the request path matches any of the regex patterns in the excluded list, it will not be allowed for analytics writing, even if it matches a pattern in the allowed list.
# 
# The lists support regex patterns. For example, if you want to allow all APIs under the "Patient" context, you can add "Patient/.*" to the allowed list. If you want to exclude all APIs under the "Observation" context, you can add "Observation/.*" to the excluded list.
# 
# In all the cases, the first match will be given priority. For example, if the allowed list has two regexes that matches the path, the first match will win.
# 
# + path - the API request path after removing the FHIR base path
# + allowedList - the list of allowed API contexts configured for analytics writing
# + excludedList - the list of excluded API contexts configured for analytics writing
# + return - true if the request path matches the allowed/excluded API contexts for analytics writing
isolated function isApiAllowed(string path, (string[] & readonly)? allowedList, (string[] & readonly)? excludedList) returns boolean|error? {
    
    // If only allowed list is configured
    if (allowedList !is () && (excludedList is () || excludedList.length() == 0)) {
        if (allowedList.length() > 0) {

            boolean pathMatchesInAllowedList = false;

            // check allowed list and return
            foreach string item in allowedList {
                string:RegExp pattern = check regexp:fromString(item);
                // return true at the earliest match found in the included list
                if (path.matches(pattern)) {
                    pathMatchesInAllowedList = true;
                    break;
                }
            }
            return pathMatchesInAllowedList;
        }
    }

    if (excludedList !is () && (allowedList is () || allowedList.length() == 0)) {
        // If only included list is configured
        if (excludedList.length() > 0) {

            boolean pathMatchesInExcludedList = true;

            // check excluded list and return
            foreach string item in excludedList {
                string:RegExp pattern = check regexp:fromString(item);
                // return true at the earliest match found in the excluded list
                if (path.matches(pattern)) {
                    pathMatchesInExcludedList = false;
                    break;
                }
            }
            return pathMatchesInExcludedList;
        }
    }

    // If both lists are configured, the priority is given for the excluded list. Allowed list is ignored.
    if (excludedList !is () && allowedList !is ()) {

        if (excludedList.length() > 0) {

            boolean pathMatchesInExcludedList = false;

            // check existance in excluded list
            foreach string item in excludedList {
                string:RegExp excludedPattern = check regexp:fromString(item);
                if (path.matches(excludedPattern)) {
                    pathMatchesInExcludedList = true;
                    break;
                }
            }

            // If path matches in both lists, don't allow
            if pathMatchesInExcludedList {
                return false;
            } else {
                // If path doesn't match in the excluded list, allow
                return true;
            }
        }   
    }
    return true;
}

# Remove the FHIR base path from the request path to get the API context for analytics validation
# 
# + rawRequestPath - The raw request path from the HTTP request
# + configuredBasePath - The configured base path for the FHIR server
# + return - The API context path after removing the FHIR base path
isolated function getApiPath(string rawRequestPath, string configuredBasePath) returns string {

    if configuredBasePath != "" && rawRequestPath.startsWith(configuredBasePath) {
        return rawRequestPath.substring(configuredBasePath.length());
    }
    return rawRequestPath;
}


# Check if the request path matches the excluded/allowed API contexts regex pattern for analytics exclusion/allowance
# 
# + 'resource - the API request path
# + configuredRegexPattern - the regex pattern to match against the request path
# + return - true if the request path matches the regex pattern, false otherwise
isolated function isValidRegex(string 'resource, string configuredRegexPattern) returns boolean|error? {

    string:RegExp|error? pattern = regexp:fromString(configuredRegexPattern);
    
    if pattern is error {
        log:printError(string `[AnalyticsResponseInterceptor] Invalid regex pattern provided for excluded API context regex: ${configuredRegexPattern}. Error: ${pattern.message()}`);
        return pattern;
    }
    if pattern !is () {
        return 'resource.matches(pattern);
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
isolated function extractAnalyticsDataFromJWT(string[] dataAttributes, jwt:Payload jwtPayload) returns map<string> {

    return map from string attrKey in dataAttributes
            where jwtPayload[attrKey] !== ()
            select [attrKey, jwtPayload[attrKey].toString()];
}

# Extract analytics data from the decoded JWT based on the configured attributes
#
# + jwtPayload - The decoded JWT payload
# + return - A map containing the extracted analytics data
isolated function extractFhirUserFromJWT(jwt:Payload jwtPayload) returns string? {

    anydata fhirUser = jwtPayload["fhirUser"];
    if fhirUser is () {
        return ();
    }
    return fhirUser.toString();
}

# Convert a map to a JSON object
#
#  + data - The map to convert to JSON
# + return - A JSON object representing the input map
isolated function convertMapToJson(map<string> data) returns json {
    
    return map from string headerKey in data.keys()
            select [headerKey, data[headerKey].toString()];
}

# Get the file path for analytics log based on the configuration, if not configured, return the default path
#
# + return - The file path for analytics log
isolated function getFilePathBasedOnConfiguration() returns string {
    if analytics.filePath == "" {
        return DEFAULT_FILE_LOCATION;
    } else {
        return analytics.filePath;
    }
}

# Get the file name for analytics log based on the configuration, if not configured, return the default file name
# 
# + return - The file name for analytics log
isolated function getFileNameBasedOnConfiguration() returns string {
    if analytics.fileName == "" {
        return LOG_FILE_NAME;
    } else {
        return analytics.fileName;
    }
}

# Check whether the configured path directory and file exists and if not handle and create them gracefully.
# 
# + return - An error if the directory or file creation fails, otherwise returns nothing
isolated function createFileIfNotExist() returns error? {
   
   string logFilePath = getFilePathBasedOnConfiguration();
   string logFileName = getFileNameBasedOnConfiguration() + LOG_FILE_EXTENSION;
   string logFileFullPath = logFilePath + file:pathSeparator + logFileName;

   boolean|error? dirExists = file:test(logFilePath, file:EXISTS);
    if dirExists is error {
        log:printError("Error checking analytics log directory existence at " + logFilePath, dirExists);
        return dirExists;
    } else {
        if dirExists is boolean && !dirExists {
            file:Error? dir = file:createDir(logFilePath, file:RECURSIVE);
            if dir is file:Error {
                log:printError(string `Failed to create directory for analytics logs at ${logFilePath}. Analytics data will not be written.`, dir);
                return dir;
            }
            log:printDebug(string `Directory ${logFilePath} created`);
            error? creationError = file:create(logFileFullPath);
            if creationError is error {
                log:printError(string `Configured directory ${logFilePath} doesn't exist. Error creating analytics log file: ${logFileName}. Analytics data will not be written.`, creationError);
                return creationError;
            }
            log:printDebug(string `File ${logFileName} created successfully inside directory ${logFilePath}`);
        } else {
            boolean|error? fileExists = isFileExist(logFileFullPath);
            if fileExists is error {
                log:printError(string `Error checking analytics log file existence at ${logFileFullPath}`, fileExists);
                return fileExists;
            } else {
                if fileExists is boolean && !fileExists { // check and create directory and proceed
                    error? creationError = file:create(logFileFullPath);
                    if creationError is error {
                        log:printError(string `Configured directory ${logFilePath} doesn't exist. Error creating analytics log file: ${logFileName}. Analytics data will not be written.`, creationError); //terminate
                        return creationError;
                    }
                    log:printDebug(string `File ${logFileName} created successfully inside directory ${logFilePath}`);
                }
            }
        }
    }
}

# Resolves the patient ID from the HTTP request.
# Tries to extract from the request path first, then from query parameters.
#
# + fhirResourceType - The FHIR resource type
# + httpRequest - The HTTP request
# + return - The resolved patient ID, or () if not found
isolated function resolvePatientID(string fhirResourceType, http:Request httpRequest) returns string? {
    string? patientId = ();

    // First, try to extract from path
    // Handles multiple scenarios:
    // - Patient/001 (Standard Resource ID)
    // - Patient/001/Observation (Patient Compartment)
    // - Patient/001$everything (Instance Operation)
    // - Patient/$export (Type-level Operation - no ID)
    // - Patient/_history (Interaction - no ID)
    // The path ID is only a patient ID if the resource type is Patient
    if fhirResourceType == PATIENT_RESOURCE {
        string rawPath = httpRequest.rawPath;
        // Use regex to extract patient ID from path
        // Pattern: Patient/{id} where id doesn't start with $ or _ and ends at /, $, or end of string
        regexp:Groups? groups = re `Patient/([^/$_][^/$]*)`.findGroups(rawPath);
        if groups is regexp:Groups && groups.length() > 1 {
            regexp:Span? idGroup = groups[1];
            if idGroup is regexp:Span {
                patientId = rawPath.substring(idGroup.startIndex, idGroup.endIndex);
            }
        }
        log:printDebug("Extracted patient ID from path: " + (patientId ?: "not found").toString());
    }

    // If not found in path, try query parameters
    if patientId is () {
        patientId = fhirResourceType == PATIENT_RESOURCE ? httpRequest.getQueryParamValue(PATIENT_ID_QUERY_PARAM) : httpRequest.getQueryParamValue(PATIENT_QUERY_PARAM);
    }

    log:printDebug("PatientID: " + (patientId ?: "not found").toString());

    return patientId;
}

isolated function addConsentContextToFHIRContext(string fhirResourceType, http:Request httpRequest, r4:FHIRContext fhirCtx, DefaultConsentEnforcer consentEnforcer) returns r4:FHIRError? {
    log:printDebug("Populating consent context");
    // Extract patient ID from the request (path or query parameters)
    string? patientId = resolvePatientID(fhirResourceType, httpRequest);

    // Skip consent validation if consent enforcer is not enabled or if patient ID is not found in the request (as consent is not applicable)
    if consentEnforcer.enabled && patientId !is () {
        r4:ConsentContext|error consentCtx = consentEnforcer.enforce(patientId);
        if consentCtx is error {
            log:printError("Consent enforcement failed: " + consentCtx.message());
            string message = "Consent enforcement failed";
            string diagnostic = "Consent enforcement for patient ID '" + patientId + "' failed: " + consentCtx.message();
            return r4:createInternalFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic);
        } else {
            fhirCtx.setConsentContext(consentCtx);
        }
    }
}

# Gets the civil date for the previous day
# 
# + return - civil date of the previous day
isolated function getPreviousCivilDate() returns time:Civil|error? {

    time:Zone|error zone = time:loadSystemZone();
    if zone is error {
        log:printError("Failed to load system time zone for scheduling file rotation task", zone);
        return zone;
    }

    // Adding less than a day is enough to get the previous date since we execute the job on midnight.
    time:Utc previousDayUtc = time:utcAddSeconds(time:utcNow(), -43200);
    time:Civil previousDayCivil = zone.utcToCivil(previousDayUtc);

    //todo: Add the proper fix after fixing the issue: https://github.com/wso2-enterprise/wso2-integration-internal/issues/4614
    string previousDayCivilStr = check time:civilToString(previousDayCivil);
    time:Civil previousDayCivilFromStr = check time:civilFromString(previousDayCivilStr);    
    return previousDayCivilFromStr;
}
