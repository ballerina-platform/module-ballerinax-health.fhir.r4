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
import ballerina/jwt;
import ballerina/lang.regexp;
import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.parser;

const SPACE_CHARACTER = " ";
const SCOPES = "scope";
const IDP_CLAIMS = "idp_claims";
const X_JWT_HEADER = "x-jwt-assertion";

# FHIR Pre-processor implementation.
public isolated class FHIRPreprocessor {

    final r4:ResourceAPIConfig apiConfig;
    // All the active search parameters
    private final readonly & map<r4:SearchParamConfig> searchParamConfigMap;

    # Initialize the FHIR pre-processor
    #
    # + apiConfig - The API configuration
    public isolated function init(r4:ResourceAPIConfig apiConfig) {
        self.apiConfig = apiConfig;

        map<r4:SearchParamConfig> searchParamConfigs = {};
        // process common seach parameters
        foreach r4:CommonSearchParameterDefinition item in r4:COMMON_SEARCH_PARAMETERS {
            r4:SearchParamConfig searchParamConfig = {
                name: item.name,
                active: true
            };
            searchParamConfigs[item.name] = searchParamConfig;
        }

        // process resource specific seach parameters
        foreach r4:SearchParamConfig item in self.apiConfig.searchParameters {
            searchParamConfigs[item.name] = item;
        }
        self.searchParamConfigMap = searchParamConfigs.cloneReadOnly();
    }

    # Process the FHIR Read interaction.
    #
    # + fhirResourceType - The FHIR resource type
    # + id - The FHIR resource id
    # + httpRequest - The HTTP request
    # + httpCtx - The HTTP request context
    # + return - The next service or an error
    public isolated function processRead(string fhirResourceType, string id, http:Request httpRequest, http:RequestContext httpCtx)
                                                                                    returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : read");
        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        // Create interaction
        readonly & FHIRReadInteraction readInteraction = {id: id};

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (readInteraction, fhirResourceType, (), {}, clientHeaders.acceptType);

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        // Handle SMART security
        if fhirResourceType == PATIENT_RESOURCE {
            _ = check self.handleSmartSecurity(fhirSecurity, id);
        }

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, ());

        // Create FHIR context
        r4:FHIRContext fCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fCtx, httpCtx);
    }

    # Process the FHIR Search interaction.
    #
    # + fhirResourceType - The FHIR resource type
    # + httpRequest - The HTTP request
    # + httpCtx - The HTTP request context
    # + return - The next service or an error
    public isolated function processSearch(string fhirResourceType, http:Request httpRequest, http:RequestContext httpCtx)
                                                                                    returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : search");

        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        // extract search parameters from request
        map<r4:RequestSearchParameter[]> requestSearchParameters =
                                                    check self.processSearchParameters(fhirResourceType, httpRequest);

        // Create interaction
        readonly & FHIRSearchInteraction searchInteraction = {};

        r4:FHIRRequest fhirRequest = new (searchInteraction,
            fhirResourceType,
            (),
            requestSearchParameters.cloneReadOnly(),
            clientHeaders.acceptType
        );

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        // Handle SMART security
        string? id = fhirResourceType == PATIENT_RESOURCE ? httpRequest.getQueryParamValue(PATIENT_ID_QUERY_PARAM) : httpRequest.getQueryParamValue(PATIENT_QUERY_PARAM);
        _ = check self.handleSmartSecurity(fhirSecurity, id);

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, ());

        // Create FHIR context
        r4:FHIRContext fCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fCtx, httpCtx);
    }

    # Process the FHIR Create interaction.
    #
    # + resourceType - The FHIR resource type
    # + payload - The payload
    # + httpRequest - The HTTP request
    # + httpCtx - The HTTP request context
    # + return - The next service or an error
    public isolated function processCreate(string resourceType, json|xml payload, http:Request httpRequest,
            http:RequestContext httpCtx) returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : Create");
        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        if self.apiConfig.resourceType != resourceType {
            string diagMsg = string `Request path level resource type : \" ${resourceType}\" does not match API config resource type: 
                \"${self.apiConfig.resourceType}\"`;
            return r4:createInternalFHIRError("API resource type and API config does not match", r4:ERROR, r4:PROCESSING, diagnostic = diagMsg);
        }

        // Validate and parse payload to FHIR resource model and create resource entity
        anydata parsedResource = check parser:validateAndParse(payload, self.apiConfig);
        r4:FHIRResourceEntity resourceEntity = new (parsedResource);

        // Create interaction
        readonly & FHIRCreateInteraction createInteraction = {};

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (createInteraction, resourceType, resourceEntity, {}, clientHeaders.acceptType);

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, payload);

        // Create FHIR context
        r4:FHIRContext fhirCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fhirCtx, httpCtx);
    }

    # Process the FHIR Instance History interaction.
    #
    # + fhirResourceType - The FHIR resource type
    # + id - The FHIR resource id
    # + httpRequest - The HTTP request
    # + httpCtx - The HTTP request context
    # + return - Error if occurs
    public isolated function processInstanceHistory(string fhirResourceType, string id, http:Request httpRequest, http:RequestContext httpCtx)
                                                                                    returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : instance history");
        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        // Create interaction
        readonly & FHIRInstanceHistoryInteraction historyInteraction = {id: id};

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (historyInteraction, fhirResourceType, (), {}, clientHeaders.acceptType);

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        // Handle SMART security
        if fhirResourceType == PATIENT_RESOURCE {
            _ = check self.handleSmartSecurity(fhirSecurity, id);
        }

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, ());

        // Create FHIR context
        r4:FHIRContext fCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fCtx, httpCtx);
    }

    # Process the FHIR Vread interaction.
    #
    # + fhirResourceType - The FHIR resource type  
    # + id - The FHIR resource id  
    # + vid - Resource's version id  
    # + httpRequest - The HTTP request  
    # + httpCtx - The HTTP request context
    # + return - Error if occurs
    public isolated function processVread(string fhirResourceType, string id, string vid, http:Request httpRequest, http:RequestContext httpCtx)
                                                                                    returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : vread");
        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        // Create interaction
        readonly & FHIRVReadInteraction vreadInteraction = {id: id, vid: vid};

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (vreadInteraction, fhirResourceType, (), {}, clientHeaders.acceptType);

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        // Handle SMART security
        if fhirResourceType == PATIENT_RESOURCE {
            _ = check self.handleSmartSecurity(fhirSecurity, id);
        }

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, ());

        // Create FHIR context
        r4:FHIRContext fCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fCtx, httpCtx);
    }

    # Process the FHIR History interaction.
    #
    # + httpRequest - The HTTP request  
    # + httpCtx - The HTTP request context
    # + return - Error if occurs
    public isolated function processHistory(http:Request httpRequest, http:RequestContext httpCtx)
                                                                                    returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : vread");
        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        // Create interaction
        readonly & FHIRHistoryInteraction historyInteraction = {};

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (historyInteraction, (), (), {}, clientHeaders.acceptType);

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, ());

        // Create FHIR context
        r4:FHIRContext fCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fCtx, httpCtx);
    }

    # Process the FHIR Capabilities interaction.
    #
    # + httpRequest - The HTTP request  
    # + httpCtx - The HTTP request context
    # + return - Error if occurs
    public isolated function processCapability(http:Request httpRequest, http:RequestContext httpCtx)
                                                                                    returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : vread");
        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        // Create interaction
        readonly & FHIRCapabilitiesInteraction capabilitiesInteraction = {};

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (capabilitiesInteraction, (), (), {}, clientHeaders.acceptType);

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, ());

        // Create FHIR context
        r4:FHIRContext fCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fCtx, httpCtx);
    }

    # Process the FHIR Update interaction.
    #
    # + fhirResourceType - The FHIR resource type  
    # + id - The FHIR resource id  
    # + payload - Request payload  
    # + httpRequest - The HTTP request  
    # + httpCtx - The HTTP request context
    # + return - The next service or an error
    public isolated function processUpdate(string fhirResourceType, string id, json payload, http:Request httpRequest, http:RequestContext httpCtx)
                                                                                    returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : update");
        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        // Create interaction
        readonly & FHIRUpdateInteraction updateInteraction = {id: id};

        if self.apiConfig.resourceType != fhirResourceType {
            string diagMsg = string `Request path level resource type : \" ${fhirResourceType}\" does not match API config resource type: 
                \"${self.apiConfig.resourceType}\"`;
            return r4:createInternalFHIRError("API resource type and API config does not match", r4:ERROR, r4:PROCESSING, diagnostic = diagMsg);
        }

        // Validate and parse payload to FHIR resource model and create resource entity
        anydata parsedResource = check parser:validateAndParse(payload, self.apiConfig);
        r4:FHIRResourceEntity resourceEntity = new (parsedResource);

        // Validate resource ID
        json|error idInPayload = payload.id;
        if idInPayload is error {
            return r4:createFHIRError("Payload doesn't have the mandatory ID field", r4:ERROR, r4:PROCESSING,
                                        errorType = r4:VALIDATION_ERROR, httpStatusCode = http:STATUS_BAD_REQUEST);
        } else {
            if idInPayload.toString() != id {
                return r4:createFHIRError("Payload ID doesn't match with the resource ID", r4:ERROR, r4:PROCESSING,
                                            errorType = r4:VALIDATION_ERROR, httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (updateInteraction, fhirResourceType, resourceEntity, {}, clientHeaders.acceptType);

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        // Handle SMART security
        if fhirResourceType == PATIENT_RESOURCE {
            _ = check self.handleSmartSecurity(fhirSecurity, id);
        }

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, ());

        // Create FHIR context
        r4:FHIRContext fCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fCtx, httpCtx);
    }

    # Process the FHIR Patch interaction.
    #
    # + fhirResourceType - The FHIR resource type  
    # + id - The FHIR resource id  
    # + payload - Request payload  
    # + httpRequest - The HTTP request  
    # + httpCtx - The HTTP request context
    # + return - The next service or an error
    public isolated function processPatch(string fhirResourceType, string id, json payload, http:Request httpRequest, http:RequestContext httpCtx)
                                                                                    returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : patch");
        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientPatchRequestHeaders(httpRequest);

        // Create interaction
        readonly & FHIRPatchInteraction patchInteraction = {id: id};

        if self.apiConfig.resourceType != fhirResourceType {
            string diagMsg = string `Request path level resource type : \" ${fhirResourceType}\" does not match API config resource type: 
                \"${self.apiConfig.resourceType}\"`;
            return r4:createInternalFHIRError("API resource type and API config does not match", r4:ERROR, r4:PROCESSING, diagnostic = diagMsg);
        }

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (patchInteraction, fhirResourceType, (), {}, clientHeaders.acceptType);

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        // Handle SMART security
        if fhirResourceType == PATIENT_RESOURCE {
            _ = check self.handleSmartSecurity(fhirSecurity, id);
        }

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, ());

        // Create FHIR context
        r4:FHIRContext fCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fCtx, httpCtx);
    }

    # Process the FHIR Delete interaction.
    #
    # + fhirResourceType - FHIR resource  
    # + id - Resource ID  
    # + httpRequest - The HTTP request  
    # + httpCtx - The HTTP request context
    # + return - Error if occurs
    public isolated function processDelete(string fhirResourceType, string id, http:Request httpRequest, http:RequestContext httpCtx)
                                                                                    returns r4:FHIRError? {
        log:printDebug("Pre-processing FHIR interaction : delete");
        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        // Create interaction
        readonly & FHIRDeleteInteraction deleteInteraction = {id: id};

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (deleteInteraction, fhirResourceType, (), {}, clientHeaders.acceptType);

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        // Handle SMART security
        if fhirResourceType == PATIENT_RESOURCE {
            _ = check self.handleSmartSecurity(fhirSecurity, id);
        }

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, ());

        // Create FHIR context
        r4:FHIRContext fCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fCtx, httpCtx);
    }

    isolated function processSearchParameters(string fhirResourceType, http:Request request)
                                                                returns map<r4:RequestSearchParameter[]>|r4:FHIRError {
        map<r4:RequestSearchParameter[]> processedSearchParams = {};
        r4:SearchParamCollection searchParamDefinitions = r4:fhirRegistry.getResourceSearchParameters(fhirResourceType);

        map<string[]> requestQueryParams = request.getQueryParams();
        foreach string originalParamName in requestQueryParams.keys() {

            // Decode search parameter key and seperate name and modifier
            // Refer: http://hl7.org/fhir/search.html#modifiers
            r4:RequestQueryParameter queryParam =
                            check r4:decodeSearchParameterKey(originalParamName, requestQueryParams.get(originalParamName));
            r4:RequestSearchParameter[] processResult;
            if searchParamDefinitions.hasKey(queryParam.name) {
                // Processing search parameters bound to resource
                log:printDebug(string `Processing resource bound search parameter: ${queryParam.name}`);

                // check whether it is active in the resource API config
                if self.searchParamConfigMap.hasKey(queryParam.name) && self.searchParamConfigMap.get(queryParam.name).active {

                    r4:SearchParamConfig & readonly searchParamConfig = self.searchParamConfigMap.get(queryParam.name);
                    r4:FHIRSearchParameterDefinition parameterDef = searchParamDefinitions.get(queryParam.name);

                    // pre process search parameters
                    processResult = check processResourceBoundSearchParameter(parameterDef, fhirResourceType,
                                                                                searchParamConfig, queryParam);

                } else {
                    string diagnose = string `Unsupported search parameter \"${queryParam.name}\" for resource type 
                        \"${fhirResourceType}\". Supported search parameters are: 
                        ${r4:extractActiveSearchParameterNames(self.searchParamConfigMap).toBalString()}`;
                    return r4:createFHIRError(string `Unsupported search parameter : ${queryParam.name}`, r4:ERROR, r4:PROCESSING,
                                                    diagnostic = diagnose, httpStatusCode = http:STATUS_BAD_REQUEST);
                }
            } else if r4:COMMON_SEARCH_PARAMETERS.hasKey(queryParam.name) {
                // processing common search parameter
                log:printDebug(string `Processing common search parameter: ${queryParam.name}`);
                r4:CommonSearchParameterDefinition parameterDef = r4:COMMON_SEARCH_PARAMETERS.get(queryParam.name);

                processResult = check processCommonSearchParameter(parameterDef, fhirResourceType, queryParam,
                                                                    self.apiConfig, self.searchParamConfigMap);

            } else if r4:CONTROL_SEARCH_PARAMETERS.hasKey(queryParam.name) {
                // processing control search parameter
                log:printDebug(string `Processing control search parameter: ${queryParam.name}`);
                r4:CommonSearchParameterDefinition parameterDef = r4:CONTROL_SEARCH_PARAMETERS.get(queryParam.name);

                processResult = check processCommonSearchParameter(parameterDef, fhirResourceType, queryParam,
                                                                        self.apiConfig, self.searchParamConfigMap);

            } else {
                string diagnose = string `Unknown search parameter \"${queryParam.name}\" for resource type 
                    \"${fhirResourceType}\". Valid/Supported search parameters for this search are: 
                    ${self.searchParamConfigMap.keys().toString()}`;
                return r4:createFHIRError(string `Unknown search parameter : ${queryParam.name}`, r4:ERROR, r4:PROCESSING,
                                            diagnostic = diagnose, httpStatusCode = http:STATUS_BAD_REQUEST);
            }

            // add process result to pre-processed search parameter map
            if processResult.length() > 0 {
                if processedSearchParams.hasKey(queryParam.name) {
                    r4:RequestSearchParameter[] paramArray = processedSearchParams.get(queryParam.name);
                    foreach r4:RequestSearchParameter item in processResult {
                        paramArray.push(item);
                    }
                } else {
                    processedSearchParams[queryParam.name] = processResult;
                }
            }
        }

        // process rest of the common search parameters and populate default values
        foreach r4:CommonSearchParameterDefinition sParam in r4:COMMON_SEARCH_PARAMETERS {
            if !processedSearchParams.hasKey(sParam.name) {
                r4:RequestSearchParameter? defaultParam = check getCommonSearchParamDefault(sParam, self.apiConfig);
                if defaultParam != () {
                    processedSearchParams[sParam.name] = [defaultParam];
                }
            }
        }
        // process rest of the search control parameters and populate default values
        foreach r4:CommonSearchParameterDefinition sParam in r4:CONTROL_SEARCH_PARAMETERS {
            if !processedSearchParams.hasKey(sParam.name) {
                r4:RequestSearchParameter? defaultParam = check getCommonSearchParamDefault(sParam, self.apiConfig);
                if defaultParam != () {
                    processedSearchParams[sParam.name] = [defaultParam];
                }
            }
        }

        return processedSearchParams;
    }

    isolated function handleSmartSecurity(r4:FHIRSecurity fhirSecurity, string? id) returns r4:FHIRError? {
        r4:AuthzConfig? authzConfig = self.apiConfig.authzConfig;
        if authzConfig is r4:AuthzConfig {
            _ = check r4:handleSmartSecurity(authzConfig, fhirSecurity, id);
        }
    }
}

isolated function setFHIRContext(r4:FHIRContext ctx, http:RequestContext httpCtx) {
    httpCtx.set(r4:FHIR_CONTEXT_PROP_NAME, ctx);
}

isolated function getNextService(http:RequestContext httpCtx) returns http:NextService?|r4:FHIRError {
    http:NextService|error? next = httpCtx.next();
    if next is error {
        return r4:createInternalFHIRError("Error occurred while retrieving next service", r4:ERROR, r4:PROCESSING, cause = next);
    }
    return next;
}

isolated function processResourceBoundSearchParameter(r4:FHIRSearchParameterDefinition definition,
        string fhirResourceType,
        readonly & r4:SearchParamConfig config,
        r4:RequestQueryParameter queryParam)
                                                                        returns r4:RequestSearchParameter[]|r4:FHIRError {
    r4:SearchParameterPreProcessor? customPreprocessor = config.preProcessor;
    if customPreprocessor != () {
        // If integration developer has registered a custom preprocessor
        return check customPreprocessor(definition, fhirResourceType, queryParam);
    } else {
        return check preprocessGeneralSearchParameter(definition, queryParam);
    }
}

isolated function processCommonSearchParameter(r4:CommonSearchParameterDefinition definition,
        string fhirResourceType,
        r4:RequestQueryParameter queryParam,
        r4:ResourceAPIConfig apiConfig,
        map<r4:SearchParamConfig> & readonly searchParamConfigMap)
                                                                        returns r4:RequestSearchParameter[]|r4:FHIRError {
    if searchParamConfigMap.hasKey(definition.name) {
        // The common search parameter behavior is override via Resource API Config
        r4:SearchParamConfig & readonly paramConfig = searchParamConfigMap.get(definition.name);
        if paramConfig.active {
            //Check whether preprocessor is overriden
            readonly & r4:SearchParameterPreProcessor? customPreprocessor = paramConfig?.preProcessor;
            if customPreprocessor != () {
                // Create temporary FHIR Search parameter definition from common search parameter definition
                r4:FHIRSearchParameterDefinition tempParamDef = {
                    name: definition.name,
                    'type: definition.'type,
                    base: definition.base,
                    expression: definition.expression
                };
                return check customPreprocessor(tempParamDef, fhirResourceType, queryParam);
            }
        } else {
            string diagnose = string `Unsupported search parameter \"${queryParam.name}\" for resource type \" 
                ${fhirResourceType}\". Supported search parameters are: ${r4:extractActiveSearchParameterNames(searchParamConfigMap).toBalString()}`;
            return r4:createFHIRError(string `Unsupported search parameter : ${queryParam.name}`, r4:ERROR, r4:PROCESSING_NOT_SUPPORTED, diagnostic = diagnose,
                httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
        }
    }
    // If we reach here, the developer haven't override the search parameter
    r4:CommonSearchParameterPreProcessor? preProcessor = definition.preProcessor;
    if preProcessor != () {
        // Execute dedicated pre-processor
        return check preProcessor(definition, queryParam, apiConfig);
    } else {
        // general type based pre precessing
        return check preprocessGeneralSearchParameter(definition, queryParam);
    }
}

isolated function getCommonSearchParamDefault(r4:CommonSearchParameterDefinition definition, r4:ResourceAPIConfig apiConfig)
                                                                        returns r4:RequestSearchParameter|r4:FHIRError? {

    anydata value;
    anydata|r4:SearchParameterDefaultValueProcessor? default = definition.default;
    if default != () {
        if default is r4:SearchParameterDefaultValueProcessor {
            r4:SearchParameterDefaultValueProcessor defaultFn = <r4:SearchParameterDefaultValueProcessor>default;
            value = check defaultFn(definition, apiConfig);
        } else {
            value = default;
        }
        return check r4:createRequestSearchParameter(definition, (), value);
    }
    return ();
}

isolated function preprocessGeneralSearchParameter(r4:FHIRSearchParameterDefinition|r4:CommonSearchParameterDefinition definition,
        r4:RequestQueryParameter queryParam) returns r4:RequestSearchParameter[]|r4:FHIRError {
    r4:RequestSearchParameter[] parameters = [];
    foreach string value in queryParam.values {
        r4:RequestSearchParameter? requestSearchParam =
                                            check r4:createRequestSearchParameter(definition, queryParam.modifier, value);
        if requestSearchParam != () {
            parameters.push(requestSearchParam);
        }
    }
    return parameters;
}

// Private functions

# Function to validate FHIR request in HTTP level.
#
# + request - HTTP request object
# + return - FHIRRequestMimeHeaders containing details extracted from about MIME types. FHIRError otherwise
isolated function validateClientRequestHeaders(http:Request request) returns r4:FHIRRequestMimeHeaders|r4:FHIRError {
    r4:FHIRRequestMimeHeaders headers = {};
    string contentType = request.getContentType();

    match contentType {
        "" => {
            // Accept since it is not mandatory
        }
        "application/fhir+json" => {
            headers.contentType = r4:JSON;
        }
        _ => {
            string message = string `Unsupported Content-Type header value of \"${contentType}\" was provided in the request. 
                Only \"application/fhir+json\" is supported.`;
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, message, errorType = r4:VALIDATION_ERROR, httpStatusCode = http:STATUS_UNSUPPORTED_MEDIA_TYPE);
        }
    }

    string|http:HeaderNotFoundError acceptHeader = request.getHeader("Accept");
    if acceptHeader is string {
        string[] acceptParts = regexp:split(re `,`, acceptHeader.trim());
        boolean isValidMimeType = false;
        foreach var part in acceptParts {
            string[] typeAndParams = regexp:split(re `;`, part.trim());

            // Extract MIME type
            string mimeType = typeAndParams[0].trim().toLowerAscii();
            match mimeType {
                "*/*" => {
                    // Client accepts anything, go with the default
                    isValidMimeType = true;
                }
                "application/fhir+json" => {
                    headers.acceptType = r4:JSON;
                    isValidMimeType = true;
                }
            }
        }
        if !isValidMimeType {
            string message = string `Unsupported Accept header value of \"${acceptHeader}\" was provided in the request. 
                    Only \"application/fhir+json\" is supported.`;
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, message, errorType = r4:VALIDATION_ERROR, httpStatusCode = http:STATUS_NOT_ACCEPTABLE);
        }
    }

    return headers;
}

# Function to validate FHIR request in HTTP level.
#
# + request - HTTP request object
# + return - FHIRRequestMimeHeaders containing details extracted from about MIME types. FHIRError otherwise
isolated function validateClientPatchRequestHeaders(http:Request request) returns r4:FHIRRequestMimeHeaders|r4:FHIRError {
    r4:FHIRRequestMimeHeaders headers = {};
    string contentType = request.getContentType();

    match contentType {
        "" => {
            // Accept since it is not mandatory
        }
        "application/fhir+json" => {
            headers.contentType = r4:JSON;
        }
        "application/json-patch+json" => {
            headers.contentType = r4:JSON;
        }
        _ => {
            string message = string `Unsupported Content-Type header value of \"${contentType}\" was provided in the request. 
                Only \"application/fhir+json\" and \"application/json-patch+json\" are supported.`;
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, message, errorType = r4:VALIDATION_ERROR, httpStatusCode = http:STATUS_UNSUPPORTED_MEDIA_TYPE);
        }
    }

    string|http:HeaderNotFoundError acceptHeader = request.getHeader("Accept");
    if acceptHeader is string {
        match acceptHeader {
            "" => {
                // Accept since it is not mandatory
            }
            "*/*" => {
                // Client accepts anything, go with the default
            }
            "application/fhir+json" => {
                headers.acceptType = r4:JSON;
            }
            _ => {
                string message = string `Unsupported Accept header value of \"${acceptHeader}\" was provided in the request. 
                    Only \"application/fhir+json\" is supported.`;
                return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, message, errorType = r4:VALIDATION_ERROR, httpStatusCode = http:STATUS_NOT_ACCEPTABLE);
            }
        }
    }

    return headers;
}

# Function to get jwt details from request.
#
# + httpRequest - HTTP request object
# + return - FHIRSecurity details extracted from HTTP request object. FHIRError otherwise
isolated function getJwtDetails(http:Request httpRequest) returns readonly & r4:FHIRSecurity|r4:FHIRError {

    readonly & r4:FHIRSecurity fhirSecurity;
    string|error jwt = httpRequest.getHeader(X_JWT_HEADER);
    if jwt is string {
        [jwt:Header, jwt:Payload]|error headerPayload = jwt:decode(jwt);
        if headerPayload is [jwt:Header, jwt:Payload] {
            [jwt:Header, jwt:Payload] [header, payload] = headerPayload;
            readonly & r4:JWT jwtInfo = {
                header: header.cloneReadOnly(),
                payload: payload.cloneReadOnly()
            };
            if payload.hasKey(IDP_CLAIMS) {
                json idp_claims = <json>payload.get(IDP_CLAIMS);
                map<string>|error claimList = idp_claims.fromJsonWithType();
                if claimList is error {
                    string message = "IDP claims are not available";
                    return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, message,
                                            errorType = r4:PROCESSING_ERROR, httpStatusCode = http:STATUS_UNAUTHORIZED);
                }
                // Split the scope string
                string[] scopeslist = regexp:split(re `${SPACE_CHARACTER}`, <string>payload.get(SCOPES));
                json|error userName = idp_claims.username;
                if userName is error {
                    string message = "Username is not available";
                    return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, message,
                                            errorType = r4:PROCESSING_ERROR, httpStatusCode = http:STATUS_UNAUTHORIZED);
                } else {
                    readonly & r4:FHIRUser fhirUserInfo = {
                        userID: <string & readonly>userName.toString(),
                        scopes: <string[] & readonly>scopeslist.cloneReadOnly(),
                        claims: <map<string> & readonly>claimList.cloneReadOnly()
                    };
                    fhirSecurity = {
                        securedAPICall: true,
                        fhirUser: fhirUserInfo,
                        jwt: jwtInfo
                    };
                    return fhirSecurity;
                }

            } else {
                fhirSecurity = {
                    securedAPICall: true,
                    jwt: jwtInfo,
                    fhirUser: ()
                };
                return fhirSecurity;
            }
        } else {
            string message = "Error occured in JWT decode";
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, message,
                                    errorType = r4:PROCESSING_ERROR, httpStatusCode = http:STATUS_UNAUTHORIZED);
        }
    } else {
        fhirSecurity = {
            securedAPICall: false,
            jwt: (),
            fhirUser: ()
        };
        return fhirSecurity;
    }
}

isolated function getFHIRSecurity(http:Request request) returns readonly & r4:FHIRSecurity|r4:FHIRError {

    return getJwtDetails(request);
}

isolated function createHTTPRequestRecord(http:Request request, json|xml? payload) returns readonly & r4:HTTPRequest {
    map<string[]> headers = {};
    foreach string headerName in request.getHeaderNames() {
        string[]|http:HeaderNotFoundError headerResult = request.getHeaders(headerName);
        if headerResult is string[] {
            headers[headerName] = headerResult;
        }
    }

    return {
        headers: headers.cloneReadOnly(),
        payload: payload.cloneReadOnly()
    };
}
