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
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.ips;
import ballerinax/health.fhir.r4.parser;

const SPACE_CHARACTER = " ";
const SCOPES = "scope";
const IDP_CLAIMS = "idp_claims";
const X_JWT_HEADER = "x-jwt-assertion";
const PAGE = "page";
const COUNT = "_count";

# FHIR Pre-processor implementation.
public isolated class FHIRPreprocessor {

    final r4:ResourceAPIConfig apiConfig;
    final boolean paginationEnabled;
    final int pageSize;
    // All the active search parameters
    private final readonly & map<r4:SearchParamConfig> searchParamConfigMap;
    // All the operations (base + API config defined)
    private final readonly & map<r4:OperationConfig> operationConfigMap;

    final DefaultConsentEnforcer consentEnforcer;

    # Initialize the FHIR pre-processor
    #
    # + apiConfig - The API configuration
    public isolated function init(r4:ResourceAPIConfig apiConfig) {
        self.apiConfig = apiConfig;
        self.paginationEnabled = apiConfig.paginationConfig.enabled;
        self.pageSize = apiConfig.paginationConfig.pageSize;

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
            r4:FHIRSearchParameterDefinition? searchParamDef = r4:fhirRegistry.getResourceSearchParameterByName(self.apiConfig.resourceType, item.name);
            if searchParamDef is () {
                r4:FHIRSearchParameterDefinition customSearchParamDef = {
                    name: item.name,
                    'type: (item.'type != () ? <r4:FHIRSearchParameterType>item.'type : r4:STRING),
                    expression: item.expression,
                    base: []
                };
                r4:fhirRegistry.addSearchParameter(self.apiConfig.resourceType, customSearchParamDef);
            }
        }
        self.searchParamConfigMap = searchParamConfigs.cloneReadOnly();

        // Operations
        map<r4:OperationConfig> operationConfigs = {};
        // Add base resource operation configs
        foreach r4:FHIROperationDefinition operationDefinition in r4:BASE_RESOURCE_OPERATIONS {
            // Operation params
            r4:FHIROperationParameterDefinition[]? 'parameter = operationDefinition.'parameter;
            r4:OperationParamConfig[]? operationParams = 'parameter != () ? 'parameter.map(
                isolated function(r4:FHIROperationParameterDefinition param) returns r4:OperationParamConfig {
                    return {name: param.name, active: true};
                }) : ();
            r4:OperationConfig operationConfig = {
                name: operationDefinition.name,
                active: true,
                parameters: operationParams.cloneReadOnly()
            };
            operationConfigs[operationDefinition.name] = operationConfig;
        }
        // Add resource specific operation configs
        foreach r4:OperationConfig operationConfig in self.apiConfig.operations {
            operationConfigs[operationConfig.name] = operationConfig;
            r4:FHIRError? regOpStatus = r4:fhirRegistry.registerResourceOperation(self.apiConfig.resourceType, operationConfig);
            if regOpStatus is r4:FHIRError {
                log:printError("Error occurred while registering resource operation to FHIR registry", regOpStatus);
            }
        }
        self.operationConfigMap = operationConfigs.cloneReadOnly();

        // Initialize the consent enforcer which will create the OpenFGC client
        self.consentEnforcer = new DefaultConsentEnforcer();
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

        // Create pagination context and set to FHIR context
        fCtx.setPaginationContext(check self.processPaginationParams(httpRequest));

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

        string|error isNoneExistHeader = httpRequest.getHeader("If-None-Exist");
        if isNoneExistHeader is string {
            // conditional create
            // Implemented according to the https://hl7.org/fhir/R4/http.html#ccreate FHIR specification
            log:printDebug("Conditional create interaction.");
            log:printDebug(string `Conditional header (If-None-Exist): ${isNoneExistHeader}`);
            _ = check handleConditionalHeader(isNoneExistHeader, httpRequest.rawPath);
        }

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

        // Create pagination context and set to FHIR context
        fCtx.setPaginationContext(check self.processPaginationParams(httpRequest));

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

        // Create pagination context and set to FHIR context
        fCtx.setPaginationContext(check self.processPaginationParams(httpRequest));

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

    # Processes a FHIR operation request.
    #
    # + fhirResourceType - The FHIR resource type
    # + fhirOperation - The FHIR operation to be processed
    # + operationRequestScope - The scope of the operation request
    # + payload - The payload of the request
    # + httpRequest - The HTTP request
    # + httpCtx - The HTTP context
    # + return - A `r4:FHIRError` if an error occurs during the processing, or `()` otherwise
    public isolated function processOperation(string fhirResourceType, string fhirOperation,
            r4:FHIRInteractionLevel operationRequestScope, json|xml? payload, http:Request httpRequest,
            http:RequestContext httpCtx) returns r4:FHIRError? {
        log:printDebug(string `Pre-processing FHIR operation : ${fhirOperation}`);

        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        r4:FHIRResourceEntity? resourceEntity = ();
        map<r4:RequestSearchParameter[]> requestOperationSearchParameters = {};

        // Get operation definitions for the resource type
        r4:OperationCollection resourceOperationDefinitions = r4:fhirRegistry.getResourceOperations(fhirResourceType);

        if resourceOperationDefinitions.hasKey(fhirOperation) { // Valid operation for the resource type 
            log:printDebug(string `Processing resource bound operation: ${fhirOperation}`);

            // Get operation definition and config
            r4:FHIROperationDefinition resourceOperationDefinition = resourceOperationDefinitions.get(fhirOperation);
            r4:OperationConfig? resourceOperationConfig = self.operationConfigMap.get(fhirOperation);

            map<r4:RequestSearchParameter[]>|r4:FHIRResourceEntity? processRes =
                    check preProcessOperation(fhirResourceType, fhirOperation, operationRequestScope,
                    resourceOperationDefinition, resourceOperationConfig, self.operationConfigMap, self.apiConfig,
                    payload, httpRequest, httpCtx, clientHeaders);

            if processRes is map<r4:RequestSearchParameter[]> { // GET invoked
                requestOperationSearchParameters = processRes;
            } else if processRes is r4:FHIRResourceEntity { // POST invoked
                resourceEntity = processRes;
            }
        } else if r4:BASE_RESOURCE_OPERATIONS.hasKey(fhirOperation) { // Base operation (common operation)
            log:printDebug(string `Processing base operation: ${fhirOperation}`);

            // Get base operation definition and config
            r4:FHIROperationDefinition baseOperationDefinition = r4:BASE_RESOURCE_OPERATIONS.get(fhirOperation);
            r4:OperationConfig baseOperationConfig = self.operationConfigMap.get(fhirOperation);

            map<r4:RequestSearchParameter[]>|r4:FHIRResourceEntity? processRes =
                    check preProcessOperation(fhirResourceType, fhirOperation, operationRequestScope,
                    baseOperationDefinition, baseOperationConfig, self.operationConfigMap, self.apiConfig,
                    payload, httpRequest, httpCtx, clientHeaders);

            if processRes is map<r4:RequestSearchParameter[]> {
                requestOperationSearchParameters = processRes;
            } else if processRes is r4:FHIRResourceEntity {
                resourceEntity = processRes;
            }
        } else { // Invalid operation for the resource type
            string message = "Unknown operation";
            string diagnostic = "Operation \"$" + fhirOperation + "\" is not known for resource type \""
                    + fhirResourceType + "\". Known and defined operations for \"" + fhirResourceType
                    + "\" resource: " + resourceOperationDefinitions.keys().toString() + ".";
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
        }

        // Create interaction
        readonly & r4:FHIROperationInteraction operationInteraction = {operation: fhirOperation};

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (operationInteraction, fhirResourceType,
            resourceEntity, requestOperationSearchParameters.cloneReadOnly(), clientHeaders.acceptType
        );

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, payload);

        // Create FHIR context
        r4:FHIRContext fhirCtx = new (fhirRequest, request, fhirSecurity);

        check addConsentContextToFHIRContext(fhirResourceType, httpRequest, fhirCtx, self.consentEnforcer);

        // Set FHIR context inside HTTP context
        setFHIRContext(fhirCtx, httpCtx);
    }

    # Processes a FHIR IPS generation operation request.
    # IPS generation is a special Patient-level operation with the following characteristics:
    # - POST request only
    # - Operation name: "summary" 
    # - Resource path: Patient/[id]/$summary or Patient/$summary
    # - Instance level operation scope
    #
    # + patientId - The patient ID for which to generate IPS
    # + payload - The payload of the request
    # + operationRequestScope - The scope of the operation request
    # + baseResourcePath - The base resource path for the operation
    # + patientOperationConfigs - The operation configurations for the Patient resource
    # + httpRequest - The HTTP request
    # + httpCtx - The HTTP context
    # + return - A `r4:FHIRError` if an error occurs during the processing, or a `r4:Bundle` containing the generated IPS
    # or `()` if the operation is not supported.
    public isolated function processIPSGenerateOperation(string patientId, json|xml? payload,
            r4:FHIRInteractionLevel operationRequestScope, string baseResourcePath, r4:OperationConfig[] patientOperationConfigs,
            http:Request httpRequest, http:RequestContext httpCtx) returns r4:FHIRError|r4:Bundle {
        log:printDebug("Pre-processing FHIR IPS generation operation");

        // Validate main HTTP headers
        r4:FHIRRequestMimeHeaders clientHeaders = check validateClientRequestHeaders(httpRequest);

        r4:FHIRResourceEntity? resourceEntity = ();
        map<r4:RequestSearchParameter[]> requestOperationSearchParameters = {};

        // Get operation definitions for Patient resource type
        r4:OperationCollection resourceOperationDefinitions = ips:fhirRegistry.getResourceOperations(PATIENT_RESOURCE);

        if resourceOperationDefinitions.hasKey(SUMMARY_OPERATION) { // Valid IPS operation for Patient
            log:printDebug(string `Processing IPS generation operation: ${SUMMARY_OPERATION} for Patient/${patientId}`);

            // Get operation definition and config
            r4:FHIROperationDefinition resourceOperationDefinition = resourceOperationDefinitions.get(SUMMARY_OPERATION);

            if self.operationConfigMap.hasKey(SUMMARY_OPERATION) {
                r4:OperationConfig? resourceOperationConfig = self.operationConfigMap.get(SUMMARY_OPERATION);
                // Process the operation
                map<r4:RequestSearchParameter[]>|r4:FHIRResourceEntity? processRes =
                        check preProcessOperation(PATIENT_RESOURCE, SUMMARY_OPERATION, operationRequestScope,
                        resourceOperationDefinition, resourceOperationConfig, self.operationConfigMap, self.apiConfig,
                        payload, httpRequest, httpCtx, clientHeaders);

                if processRes is map<r4:RequestSearchParameter[]> { // For type level operations (POST)
                    requestOperationSearchParameters = processRes;
                } else if processRes is r4:FHIRResourceEntity { // For instance level operations (POST)
                    resourceEntity = processRes;
                }
            } else {
                return r4:createFHIRError("IPS operation not supported", r4:ERROR, r4:PROCESSING,
                        diagnostic = "The '$summary' operation for IPS generation is not available for Patient resources. " +
                                "Please ensure the IPS operation is properly configured.",
                        httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
            }
        } else { // IPS operation not available
            return r4:createFHIRError("IPS operation not supported", r4:ERROR, r4:PROCESSING);
        }

        // Create interaction for IPS operation
        readonly & r4:FHIROperationInteraction operationInteraction = {operation: SUMMARY_OPERATION};

        // Create FHIR request
        r4:FHIRRequest fhirRequest = new (operationInteraction, PATIENT_RESOURCE,
            resourceEntity, requestOperationSearchParameters.cloneReadOnly(), clientHeaders.acceptType
        );

        // Populate JWT information in FHIR context
        readonly & r4:FHIRSecurity fhirSecurity = check getFHIRSecurity(httpRequest);

        // Handle SMART security for Patient resources - use the patient ID from the path
        _ = check self.handleSmartSecurity(fhirSecurity, patientId);

        // Generate IPS (International Patient Summary) for the patient
        log:printDebug(string `Generating IPS for Patient/${patientId}`);
        r4:FHIRServiceInfo? patientServiceInfo = ips:fhirRegistry.getFHIRService(PATIENT_RESOURCE);
        if patientServiceInfo is () {
            string diagnostic = "No FHIR service found for Patient resource. Ensure the Patient resource is properly registered.";
            return r4:createFHIRError("Patient service not found", r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                    httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
        }

        // get all registered FHIR Services from the FHIR registry
        map<r4:FHIRServiceInfo> fhirServices = r4:fhirRegistry.getAllRegisteredFHIRServices();

        // add the fhir services to the serviceResourceMap
        map<string> serviceResourceMap = {};
        foreach string serviceName in fhirServices.keys() {
            r4:FHIRServiceInfo serviceInfo = fhirServices.get(serviceName);
            serviceResourceMap[serviceName] = string `${serviceInfo.serviceUrl}/${baseResourcePath}`;
        }

        r4:Bundle|error ipsBundle = handleIpsGeneration(patientId, patientServiceInfo, serviceResourceMap, patientOperationConfigs);

        if ipsBundle is error {
            return r4:createFHIRError("IPS generation failed", r4:ERROR, r4:PROCESSING,
                    diagnostic = ipsBundle.message(), httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
        }

        r4:HTTPRequest & readonly request = createHTTPRequestRecord(httpRequest, payload);

        // Create FHIR context
        r4:FHIRContext fhirCtx = new (fhirRequest, request, fhirSecurity);

        // Set FHIR context inside HTTP context
        setFHIRContext(fhirCtx, httpCtx);

        return ipsBundle;
    }

    isolated function processSearchParameters(string fhirResourceType, http:Request request)
                                                                returns map<r4:RequestSearchParameter[]>|r4:FHIRError {
        map<r4:RequestSearchParameter[]> processedSearchParams = {};
        r4:SearchParamCollection searchParamDefinitions = r4:fhirRegistry.getResourceSearchParameters(fhirResourceType);

        map<string[]> requestQueryParams = request.getQueryParams();
        if request.method == http:POST && request.getContentType().equalsIgnoreCaseAscii("application/x-www-form-urlencoded") {
            // Extract search parameters from the form data
            map<string>|http:ClientError formData = request.getFormParams();
            if formData is http:ClientError {
                return r4:createFHIRError("Error occurred while extracting form data", r4:ERROR, r4:PROCESSING,
                        httpStatusCode = http:STATUS_BAD_REQUEST);
            }
            foreach string paramName in formData.keys() {
                string paramValue = formData.get(paramName);
                requestQueryParams[paramName] = [paramValue];
            }
        }
        foreach string originalParamName in requestQueryParams.keys() {

            // Decode search parameter key and seperate name and modifier
            // Refer: http://hl7.org/fhir/search.html#modifiers
            string[]? paramValues = requestQueryParams[originalParamName];
            if paramValues is () || paramValues.length() == 0 {
                return r4:createFHIRError(string `Search parameter ${originalParamName} has no value`, r4:ERROR, r4:PROCESSING,
                        httpStatusCode = http:STATUS_BAD_REQUEST);
            }
            r4:RequestQueryParameter queryParam =
                            check r4:decodeSearchParameterKey(originalParamName, paramValues);
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
            } else if PAGE == queryParam.name {
                processResult = [];
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

    isolated function processPaginationParams(http:Request request) returns r4:PaginationContext|r4:FHIRError {
        int page = 1;
        int count = self.pageSize;
        if request.getQueryParamValue(PAGE) is string {
            if self.paginationEnabled {
                // multiple page parameters are not allowed. only the first value will be taken
                string? pageStr = request.getQueryParamValue(PAGE);
                if pageStr is string {
                    int|error pageInt = int:fromString(pageStr);
                    if pageInt is error {
                        return r4:createFHIRError(string `Invalid page number: ${pageStr}`, r4:ERROR, r4:PROCESSING, httpStatusCode = http:STATUS_BAD_REQUEST);
                    } else {
                        page = pageInt;
                    }
                }
            } else {
                // pagination not enabled. so can't process page parameter
                return r4:createFHIRError("Pagination not supported", r4:ERROR, r4:PROCESSING, httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }
        if request.getQueryParamValue(COUNT) is string {
            if self.paginationEnabled {
                string? countStr = request.getQueryParamValue(COUNT);
                if countStr is string {
                    int|error countInt = int:fromString(countStr);
                    if countInt is error {
                        return r4:createFHIRError(string `Invalid count value: ${countStr}`, r4:ERROR, r4:PROCESSING, httpStatusCode = http:STATUS_BAD_REQUEST);
                    } else {
                        count = countInt < self.pageSize ? countInt : count;
                    }
                }
            }
        }
        return {
            paginationEnabled: self.paginationEnabled,
            page: page,
            pageSize: count
        };
    }

    isolated function handleSmartSecurity(r4:FHIRSecurity fhirSecurity, string? id) returns r4:FHIRError? {
        r4:AuthzConfig? authzConfig = self.apiConfig.authzConfig;
        if authzConfig is r4:AuthzConfig {
            _ = check r4:handleSmartSecurity(authzConfig, fhirSecurity, id);
        }
    }
}

# Pre-processes a FHIR operation.
#
# + fhirResourceType - The FHIR resource type
# + fhirOperation - The FHIR operation to be pre-processed
# + operationRequestScope - The scope of the operation request
# + operationDefinition - The operation definition
# + operationConfig - The operation configuration
# + operationConfigMap - The operation configuration map
# + apiConfig - The API configuration
# + payload - The payload of the request
# + httpRequest - The HTTP request
# + httpCtx - The HTTP context
# + clientHeaders - The client headers
# + return - A map of processed request search parameters if the operation is a GET request, a `r4:FHIRResourceEntity` 
# if the operation is a POST request with a payload, a `r4:FHIRError` if an error occurs during the pre-processing, or 
# `()` if the operation is a POST request without a payload
isolated function preProcessOperation(string fhirResourceType, string fhirOperation,
        r4:FHIRInteractionLevel operationRequestScope, r4:FHIROperationDefinition operationDefinition,
        r4:OperationConfig? operationConfig, map<r4:OperationConfig> operationConfigMap, r4:ResourceAPIConfig apiConfig,
        json|xml? payload, http:Request httpRequest, http:RequestContext httpCtx, r4:FHIRRequestMimeHeaders clientHeaders)
        returns map<r4:RequestSearchParameter[]>|r4:FHIRResourceEntity|r4:FHIRError? {
    // Validate operation config
    if operationConfig == () || !operationConfig.active {
        string message = "Unsupported operation";
        string diagnostic = "Resource type \"$" + fhirResourceType + "\" does not support operation "
                + "\"" + fhirOperation + "\". Supported operations for \"" + fhirResourceType + "\" resource: "
                + extractActiveOperationNames(operationConfigMap).toBalString();
        return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    // Validate operation invocation scope
    string[] operationScopes = getOperationScopes(operationDefinition);
    if operationScopes.indexOf(operationRequestScope) == () {
        string message = "Invalid operation scope";
        string diagnostic = "Operation \"$" + fhirOperation + "\" does not support scope "
                + "\"" + operationRequestScope + "\". Supported scopes for \"$" + fhirOperation + "\" "
                + "operation: " + operationScopes.toBalString() + ".";
        return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    // Operation parameter definitions and configs
    r4:FHIROperationParameterDefinition[] operationParameterDefinitions = operationDefinition.'parameter ?: [];
    r4:OperationParamConfig[] operationParameterConfigs = operationConfig.parameters ?: [];

    // An operation can be GET or POST invoked
    if httpRequest.method == http:GET {
        // Custom pre-processor check
        r4:OperationPreProcessor? customPreProcessor = operationConfig.preProcessor;
        if customPreProcessor != () {
            return check customPreProcessor(operationDefinition, fhirResourceType, httpRequest.getQueryParams(), ());
        }

        // Only operations that does not affect the state can be invoked using GET
        if isStateAffectedByOperation(operationDefinition) {
            string message = "Invalid operation invocation";
            string diagnostic = "Operation \"$" + fhirOperation + "\" cannot be invoked using HTTP GET "
                    + "because it affects the state. Please use HTTP POST to invoke this operation.";
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                    httpStatusCode = http:STATUS_METHOD_NOT_ALLOWED);
        }

        // Process operation query parameters
        map<r4:RequestSearchParameter[]> requestOperationSearchParameters =
                check processOperationQueryParams(fhirOperation, operationRequestScope,
                operationParameterDefinitions, operationParameterConfigs, httpRequest);

        // Validate operation parameter cardinality
        check validateOperationParamCardinality(fhirOperation, operationParameterConfigs,
                requestOperationSearchParameters);

        return requestOperationSearchParameters;
    } else if httpRequest.method == http:POST {
        // Custom pre-processor check
        r4:OperationPreProcessor? customPreProcessor = operationConfig.preProcessor;
        if customPreProcessor != () {
            return check customPreProcessor(operationDefinition, fhirResourceType, (), payload);
        }

        // An operation invocation with no payload is valid if the operation has no parameters
        if payload == () {
            return;
        }

        // If there is a payload, it should be a valid Parameters or Bundle resource
        // Validate and parse payload
        anydata|r4:FHIRParseError parsedResource = parser:parse(payload);

        if parsedResource is r4:FHIRParseError {
            string message = "Invalid operation payload";
            string diagnostic = "Payload for operation \"$" + fhirOperation + "\" is not a valid \"Parameters\" "
                        + "or \"Bundle\" resource. Please provide a valid resource as the payload.";
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
        }

        international401:Parameters|r4:Bundle|error parsedParametersPayload = parsedResource.ensureType();

        if parsedParametersPayload is error {
            string message = "Invalid Resource Type in operation payload";
            string diagnostic = "ResourceType for operation \"$" + fhirOperation + "\" is not a valid \"Parameters\" "
                        + "or \"Bundle\" resource. Please provide a valid resource as the payload.";
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
        }

        // Process operation params of the payload only if it's a Parameters resource
        if parsedParametersPayload is international401:Parameters {
            map<international401:ParametersParameter[]> processedParams = check processOperationPayloadParams(fhirOperation,
                    operationRequestScope, operationParameterDefinitions, operationParameterConfigs, parsedParametersPayload);

            // Validate operation parameter cardinality
            check validateOperationParamCardinality(fhirOperation, operationParameterConfigs, processedParams);
        }

        return new r4:FHIRResourceEntity(parsedResource);
    } else {
        string message = "Invalid HTTP method";
        string diagnostic = "The HTTP method for an operation must be either GET or POST.";
        return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}

# Processes the query parameters of a FHIR operation GET request.
#
# + fhirOperation - The FHIR operation
# + operationRequestScope - The scope of the operation request
# + operationParamDefinitions - The operation parameter definitions
# + operationParamConfigs - The operation parameter configurations
# + httpRequest - The HTTP request from which the query parameters are retrieved
# + return - A map of processed operation search parameters, or a `r4:FHIRError` if an error occurs during the processing
isolated function processOperationQueryParams(string fhirOperation,
        r4:FHIRInteractionLevel operationRequestScope,
        r4:FHIROperationParameterDefinition[] operationParamDefinitions,
        r4:OperationParamConfig[] operationParamConfigs, http:Request httpRequest)
    returns map<r4:RequestSearchParameter[]>|r4:FHIRError {
    log:printDebug(string `Processing GET invoked operation params of operation: ${fhirOperation}`);

    map<r4:RequestSearchParameter[]> processedOperationSearchParams = {};
    map<string[]?> requestQueryParams = httpRequest.getQueryParams();

    // Process each parameter in the request
    foreach string originalParamName in requestQueryParams.keys() {
        string[] paramValues = requestQueryParams.get(originalParamName) ?: [];

        // When an operation parameter has a search type, search modifiers are available
        // Decode parameter and separate name and modifier
        r4:RequestQueryParameter queryParam = check r4:decodeSearchParameterKey(originalParamName, paramValues);

        // Process operation parameter
        check processOperationQueryParam(queryParam, fhirOperation, operationRequestScope,
                operationParamDefinitions, operationParamConfigs, processedOperationSearchParams);
    }

    return processedOperationSearchParams;
}

# Processes a single query parameter of a FHIR operation GET request.
#
# + queryParam - The query parameter to be processed
# + fhirOperation - The FHIR operation
# + operationRequestScope - The scope of the operation request
# + operationParamDefinitions - The operation parameter definitions
# + operationParamConfigs - The operation parameter configurations
# + processedOperationSearchParams - The map of processed operation search parameters
# + return - A `r4:FHIRError` if an error occurs during the processing, or `()` if the processing is successful
isolated function processOperationQueryParam(r4:RequestQueryParameter queryParam, string fhirOperation,
        r4:FHIRInteractionLevel operationRequestScope, r4:FHIROperationParameterDefinition[] operationParamDefinitions,
        r4:OperationParamConfig[] operationParamConfigs, map<r4:RequestSearchParameter[]> processedOperationSearchParams)
        returns r4:FHIRError? {
    // Split parameter name and parts
    string[] paramParts = regexp:split(re `\.`, queryParam.name);
    string paramName = paramParts[0];
    string[] remainingParts = paramParts.length() > 1 ? paramParts.slice(1) : [];

    // Get parameter definition
    r4:FHIROperationParameterDefinition? paramDefinition = getOperationParameterDefinition(paramName,
            operationParamDefinitions);

    if paramDefinition == () { // Unknown parameter
        return createUnknownOperationParamError(paramName, fhirOperation, operationParamDefinitions);
    }

    // Get parameter config
    r4:OperationParamConfig? paramConfig = getOperationParameterConfig(paramName, operationParamConfigs);

    if paramConfig == () || !paramConfig.active { // Unsupported parameter
        return createUnsupportedOperationParamError(paramName, fhirOperation, operationParamConfigs);
    }

    // Validate invocation scope based on config's scope
    check validateOperationParamScope(fhirOperation, paramConfig, operationRequestScope);

    // Process query parameter as a FHIR search parameter
    r4:RequestSearchParameter[] searchParams;
    if isMultiPartOperationParameter(paramDefinition) {
        // If there are remaining parts, process the part parameter
        if remainingParts.length() > 0 {
            searchParams = check processOperationPartQueryParam(fhirOperation, operationRequestScope, queryParam,
                    remainingParts[0], remainingParts.slice(1), paramDefinition, paramConfig, operationParamDefinitions,
                    operationParamConfigs);
        } else { // Multi-part parameter without parts
            return createMultiPartOperationParamWithoutPartsError(paramDefinition.name, fhirOperation,
                    operationParamDefinitions);
        }
    } else { // Not a multi-part parameter
        searchParams = check processOperationQueryParamAsSearchParam(queryParam, paramDefinition);
    }

    processedOperationSearchParams[queryParam.name] = searchParams;
}

# Processes a part of a multi-part query parameter of a FHIR operation GET request.
#
# + fhirOperation - The FHIR operation
# + operationRequestScope - The scope of the operation request
# + queryParam - The query parameter to be processed
# + partParamName - The name of the part parameter
# + remainingParts - The remaining parts of the multi-part parameter
# + currentParamDefinition - The current operation parameter definition
# + currentParamConfig - The current operation parameter configuration
# + operationParamDefinitions - The operation parameter definitions
# + operationParamConfigs - The operation parameter configurations
# + return - An array of processed search parameters, or a `r4:FHIRError` if an error occurs during the processing
isolated function processOperationPartQueryParam(string fhirOperation, r4:FHIRInteractionLevel operationRequestScope,
        r4:RequestQueryParameter queryParam, string partParamName, string[] remainingParts,
        r4:FHIROperationParameterDefinition currentParamDefinition, r4:OperationParamConfig currentParamConfig,
        r4:FHIROperationParameterDefinition[] operationParamDefinitions,
        r4:OperationParamConfig[] operationParamConfigs) returns r4:RequestSearchParameter[]|r4:FHIRError {
    // Get part parameter definition
    r4:FHIROperationParameterDefinition? partParamDefinition =
                getOperationPartParameterDefinition(partParamName, currentParamDefinition);

    if partParamDefinition == () { // Unknown part parameter
        return createUnknownOperationParamError(queryParam.name, fhirOperation, operationParamDefinitions);
    }

    // Get part parameter config
    r4:OperationParamConfig? partParamConfig = getOperationPartParameterConfig(partParamName, currentParamConfig);

    if partParamConfig == () || !partParamConfig.active { // Unsupported part parameter
        return createUnsupportedOperationParamError(queryParam.name, fhirOperation, operationParamConfigs);
    }

    // Validate invocation scope based on config's scope
    check validateOperationParamScope(fhirOperation, partParamConfig, operationRequestScope);

    // A part parameter can have parts of its own
    // For an example, see https://hl7.org/fhir/R4/codesystem-operation-find-matches.html
    if isMultiPartOperationParameter(partParamDefinition) {
        if remainingParts.length() > 0 {
            // Process next part parameter
            return processOperationPartQueryParam(fhirOperation, operationRequestScope, queryParam, remainingParts[0],
                    remainingParts.slice(1), partParamDefinition, partParamConfig, operationParamDefinitions,
                    operationParamConfigs);
        } else { // Multi-part parameter without parts
            return createMultiPartOperationParamWithoutPartsError(partParamName, fhirOperation,
                    operationParamDefinitions);
        }
    } else {
        // Process current (last) part parameter as search parameter
        return check processOperationQueryParamAsSearchParam(queryParam, partParamDefinition);
    }
}

# Processes a FHIR operation GET request query parameter as a search parameter.
#
# + queryParam - The FHIR operation request query parameter to process
# + paramDefinition - The definition of the query parameter
# + return - An array containing the processed search parameters if the processing is successful, 
# or a `r4:FHIRError` otherwise
isolated function processOperationQueryParamAsSearchParam(r4:RequestQueryParameter queryParam,
        r4:FHIROperationParameterDefinition paramDefinition) returns r4:RequestSearchParameter[]|r4:FHIRError {
    r4:FHIROperationParameterDefinition tmpParamDefinition;

    // FHIR operation parameters are either resources, data types, or search parameters
    // If the parameter has a 'searchType', it is a search parameter
    if paramDefinition.searchType != () {
        tmpParamDefinition = paramDefinition;
    } else { // Parameter is a data type or resource type
        string? 'type = paramDefinition.'type;

        // At this point, the parameter should have a type
        if 'type == () {
            // This shouldn't happen as the parameter definition should have a type
            string message = "Unknown parameter type";
            string diagnostic = "The type of parameter \"" + paramDefinition.name + "\" is unknown. "
                    + "Therefore, this parameter cannot be processed properly.";
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic);
        }

        // Only primitive types are supported for GET invoked operations.
        // Try to map the parameter type to a search parameter type
        r4:FHIRSearchParameterType|r4:FHIRError searchParamType = r4:primitiveTypeToSearchParamType('type);
        if searchParamType is r4:FHIRError { // Parameter type is not a primitive type
            string message = "Invalid operation invocation";
            string diagnostic = "Operation parameter \"" + queryParam.name + "\" cannot be invoked using "
                    + "HTTP GET method because its type \"" + 'type + "\" is not a primitive type. "
                    + "Please use HTTP POST method instead.";
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                    httpStatusCode = http:STATUS_METHOD_NOT_ALLOWED);
        }

        // New operation parameter definition including the mapped type as the search type
        r4:FHIROperationParameterDefinition newDefinition = {
            name: paramDefinition.name,
            use: paramDefinition.use,
            min: paramDefinition.min,
            max: paramDefinition.max,
            searchType: searchParamType
        };

        tmpParamDefinition = newDefinition;
    }

    // Create search params
    r4:RequestSearchParameter[] searchParams = [];

    foreach string value in queryParam.values {
        r4:RequestSearchParameter searchParam =
                    check r4:createRequestSearchParameter(tmpParamDefinition, queryParam.modifier, value);
        searchParams.push(searchParam);
    }

    return searchParams;
}

# Processes payload parameters of a POST invoked FHIR operation.
#
# + fhirOperation - The FHIR operation
# + operationRequestScope - The request scope of the operation
# + operationParamDefinitions - The parameter definitions for the operation
# + operationParamConfigs - The parameter configurations for the operation
# + parsedParametersPayload - The parsed parameters payload to process
# + return - A map of processed parameters, or a `r4:FHIRError` if a parameter cannot be processed
isolated function processOperationPayloadParams(string fhirOperation, r4:FHIRInteractionLevel operationRequestScope,
        r4:FHIROperationParameterDefinition[] operationParamDefinitions, r4:OperationParamConfig[] operationParamConfigs,
        international401:Parameters parsedParametersPayload) returns map<international401:ParametersParameter[]>|r4:FHIRError {
    log:printDebug(string `Processing POST invoked operation params of operation: ${fhirOperation}`);
    map<international401:ParametersParameter[]> processedOperationParams = {};

    international401:ParametersParameter[]? parameters = parsedParametersPayload.'parameter;
    if parameters != () {
        foreach international401:ParametersParameter 'parameter in parameters {
            check validateAndProcessOperationPayloadParam(fhirOperation, 'parameter, operationRequestScope,
                    operationParamDefinitions, operationParamConfigs, processedOperationParams);
        }
    }

    return processedOperationParams;
}

# Validates and processes a payload parameter of a POST invoked FHIR operation.
#
# + fhirOperation - The FHIR operation
# + 'parameter - The parameter to validate and process
# + operationRequestScope - The request scope of the operation
# + operationParamDefinitions - The parameter definitions for the operation
# + operationParamConfigs - The parameter configurations for the operation
# + processedOperationParams - The map of processed parameters
# + return - A `r4:FHIRError` if the parameter cannot be processed, nil otherwise
isolated function validateAndProcessOperationPayloadParam(string fhirOperation,
        international401:ParametersParameter 'parameter, r4:FHIRInteractionLevel operationRequestScope,
        r4:FHIROperationParameterDefinition[] operationParamDefinitions, r4:OperationParamConfig[] operationParamConfigs,
        map<international401:ParametersParameter[]> processedOperationParams) returns r4:FHIRError? {
    // Get parameter definition and config
    r4:FHIROperationParameterDefinition? parameterDefinition = getOperationParameterDefinition('parameter.name,
            operationParamDefinitions);
    r4:OperationParamConfig? parameterConfig = getOperationParameterConfig('parameter.name, operationParamConfigs);

    return processOperationPayloadParam(fhirOperation, 'parameter, 'parameter.name, operationRequestScope,
            parameterDefinition, parameterConfig, processedOperationParams, operationParamDefinitions,
            operationParamConfigs);
}

# Validates and processes a part parameter of a POST invoked FHIR operation payload.
#
# + fhirOperation - The FHIR operation to process
# + 'parameter - The part parameter to validate and process
# + fullParamName - The full name of the parameter
# + operationRequestScope - The request scope of the operation
# + currentParamDefinition - The current parameter definition for the operation
# + currentParamConfig - The current parameter configuration for the operation
# + operationParamDefinitions - The parameter definitions for the operation
# + operationParamConfigs - The parameter configurations for the operation
# + processedOperationParams - The map of processed parameters
# + return - A map of processed parameters, or a `r4:FHIRError` if the part parameter cannot be processed
isolated function validateAndProcessOperationPayloadPartParam(string fhirOperation,
        international401:ParametersParameter 'parameter, string fullParamName, r4:FHIRInteractionLevel operationRequestScope,
        r4:FHIROperationParameterDefinition currentParamDefinition, r4:OperationParamConfig currentParamConfig,
        r4:FHIROperationParameterDefinition[] operationParamDefinitions, r4:OperationParamConfig[] operationParamConfigs,
        map<international401:ParametersParameter[]> processedOperationParams) returns r4:FHIRError? {
    // Get part parameter definition and config
    r4:FHIROperationParameterDefinition? partParameterDefinition = getOperationPartParameterDefinition('parameter.name,
            currentParamDefinition);
    r4:OperationParamConfig? partParameterConfig = getOperationPartParameterConfig('parameter.name, currentParamConfig);

    return processOperationPayloadParam(fhirOperation, 'parameter, fullParamName, operationRequestScope,
            partParameterDefinition, partParameterConfig, processedOperationParams, operationParamDefinitions,
            operationParamConfigs);
}

# Processes a payload parameter of a FHIR operation.
#
# + fhirOperation - The FHIR operation
# + 'parameter - The payload parameter to process
# + paramName - The name of the payload parameter
# + operationRequestScope - The request scope of the operation
# + parameterDefinition - The definition of the payload parameter
# + parameterConfig - The configuration of the payload parameter
# + processedOperationParams - The map of processed parameters
# + operationParamDefinitions - The parameter definitions for the operation
# + operationParamConfigs - The parameter configurations for the operation
# + return - A `r4:FHIRError` if the parameter cannot be processed, nil otherwise
isolated function processOperationPayloadParam(string fhirOperation, international401:ParametersParameter 'parameter,
        string paramName, r4:FHIRInteractionLevel operationRequestScope,
        r4:FHIROperationParameterDefinition? parameterDefinition, r4:OperationParamConfig? parameterConfig,
        map<international401:ParametersParameter[]> processedOperationParams,
        r4:FHIROperationParameterDefinition[] operationParamDefinitions,
        r4:OperationParamConfig[] operationParamConfigs) returns r4:FHIRError? {

    if parameterDefinition == () { // Unknown parameter
        return createUnknownOperationParamError(paramName, fhirOperation, operationParamDefinitions);
    }

    if parameterConfig == () || !parameterConfig.active { // Unsupported parameter
        return createUnsupportedOperationParamError(paramName, fhirOperation, operationParamConfigs);
    }

    // Validate parameter invocation scope
    check validateOperationParamScope(fhirOperation, parameterConfig, operationRequestScope);

    if isMultiPartOperationParameter(parameterDefinition) {
        international401:ParametersParameter[]? paramParts = 'parameter.part;
        if paramParts != () {
            foreach international401:ParametersParameter partParam in paramParts {
                check validateAndProcessOperationPayloadPartParam(fhirOperation, partParam,
                        string `${paramName}.${partParam.name}`, operationRequestScope, parameterDefinition,
                        parameterConfig, operationParamDefinitions, operationParamConfigs, processedOperationParams);
            }
        } else { // Multi-part parameter invocation without parts
            return createMultiPartOperationParamWithoutPartsError(paramName, fhirOperation, operationParamDefinitions);
        }
    } else {
        if processedOperationParams.hasKey(paramName) {
            processedOperationParams.get(paramName).push('parameter);
        } else {
            processedOperationParams[paramName] = ['parameter];
        }
    }
}

# Validates the invocation scope of a FHIR operation parameter.
#
# + fhirOperation - The FHIR operation
# + paramConfig - The configuration of the parameter to validate
# + requestOperationScope - The request operation scope
# + return - A `r4:FHIRError` if the parameter does not support the request operation scope, nil otherwise
isolated function validateOperationParamScope(string fhirOperation, r4:OperationParamConfig paramConfig,
        r4:FHIRInteractionLevel requestOperationScope) returns r4:FHIRError? {
    // 'scope' element is not defined for R4 operation definitions. Therefore, we validate scope 
    // based on the API config. If a scope is not defined in the config, it is assumed that the 
    // parameter can be invoked at all scopes/levels (system, type, instance).
    r4:FHIRInteractionLevel[]? supportedScopes = paramConfig.scopes;
    if supportedScopes != () && supportedScopes.indexOf(requestOperationScope) == () {
        string message = "Invalid operation parameter scope";
        string diagnostic = "Parameter \"" + paramConfig.name + "\" of operation \"$" + fhirOperation + "\" "
                + "does not support scope \"" + requestOperationScope + "\". Supported scopes for operation parameter "
                + "\"" + paramConfig.name + "\": " + supportedScopes.toBalString() + ".";
        return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}

# Validates the cardinality of FHIR operation parameters.
#
# + fhirOperation - The FHIR operation
# + operationParamConfigs - The parameter configurations of the FHIR operation
# + parameters - The processed parameters of the FHIR operation
# + multiPartParam - The name of the multi-part parameter
# + return - A `r4:FHIRError` if the cardinality of a parameter is not valid, nil otherwise
isolated function validateOperationParamCardinality(string fhirOperation,
        r4:OperationParamConfig[] operationParamConfigs,
        map<r4:RequestSearchParameter[]>|map<international401:ParametersParameter[]> parameters,
        string? multiPartParam = ()) returns r4:FHIRError? {
    // Cardinality could vary based on the parameter's scope. However, as the 'scope' property 
    // is not defined in R4 operation definitions, we validate the cardinality defined in the API config.
    foreach r4:OperationParamConfig paramConfig in operationParamConfigs {
        // Get cardinalities
        var [minCardinality, maxCardinality] = getOperationParamCardinalities(paramConfig);

        // Get parameter parts
        r4:OperationParamConfig[]? partParamConfigs = paramConfig.parts;
        string paramName = multiPartParam != () ? string `${multiPartParam}.${paramConfig.name}` : paramConfig.name;

        if partParamConfigs != () { // Multi-part parameter
            return check validateOperationParamCardinality(fhirOperation, partParamConfigs, parameters, paramName);
        }

        int noOfProcessedParams = parameters.hasKey(paramName) ? parameters.get(paramName).length() : 0;

        // Check min cardinality
        if minCardinality != 0 && noOfProcessedParams < minCardinality {
            string message = "Too few operation parameters";
            string diagnostic = "The parameter \"" + paramName + "\" of operation \"$" + fhirOperation + "\" is "
                    + "expected to be present at least " + minCardinality.toString() + " times, but "
                    + noOfProcessedParams.toString() + " occurrences were found.";
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
        }

        // Check max cardinality
        if maxCardinality != -1 && noOfProcessedParams > maxCardinality {
            string message = "Too many operation parameters";
            string diagnostic = "The parameter \"" + paramName + "\" of operation \"$" + fhirOperation + "\" is "
                    + "expected to be present at most " + maxCardinality.toString() + " times, but "
                    + noOfProcessedParams.toString() + " occurrences were found.";
            return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
        }
    }
}

# Retrieves the cardinalities of a parameter of a FHIR operation.
#
# + 'parameter - The FHIR operation parameter definition or configuration to retrieve the cardinalities from
# + return - A tuple containing the minimum and maximum cardinalities of the parameter
isolated function getOperationParamCardinalities(r4:FHIROperationParameterDefinition|r4:OperationParamConfig 'parameter)
        returns [int, int] {
    int minCardinality = 'parameter.min ?: 0;
    int|error maxCardinality = int:fromString('parameter.max ?: "-1");
    if maxCardinality is error {
        return [minCardinality, -1];
    }
    return [minCardinality, maxCardinality];
}

# Checks if a FHIR operation affects the state.
#
# + operationDefinition - The FHIR operation definition to check
# + return - A boolean indicating whether the operation affects the state of a resource
isolated function isStateAffectedByOperation(r4:FHIROperationDefinition operationDefinition) returns boolean =>
    operationDefinition.affectsState ?: false;

# Checks if a parameter name follows the format of a FHIR operation part parameter.
#
# + paramName - The parameter name to check
# + return - A boolean indicating whether the parameter name follows the format of a FHIR operation part parameter
isolated function isOperationPartParamFormat(string paramName) returns boolean {
    // Operation part parameters are GET invoked in the format: <paramName>.<partName>...
    // For example, a part parameter invocation could look like: param.part1.subpart1
    return regexp:isFullMatch(re `^\w+\.\w+(?:\.\w+)*$`, paramName);
}

# Checks if an operation parameter is a multi-part parameter.
#
# + operationParameter - The operation parameter to check
# + return - A boolean indicating whether the operation parameter is a multi-part parameter
isolated function isMultiPartOperationParameter(r4:FHIROperationParameterDefinition
        |r4:OperationParamConfig operationParameter) returns boolean {
    if operationParameter is r4:FHIROperationParameterDefinition {
        // A multi-part parameter does not have a type, but has parts
        return operationParameter.'type == () && operationParameter.part != ();
    } else {
        return operationParameter.parts != ();
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
            // For _count parameter, use the configured pageSize instead of the hardcoded default
            if definition.name == COUNT {
                value = apiConfig.paginationConfig.pageSize;
            } else {
                value = default;
            }
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

    string[] contentTypeAndParams = regexp:split(re `;`, request.getContentType().trim());
    string contentType = contentTypeAndParams[0].trim().toLowerAscii();

    match contentType {
        "" => {
            // Accept since it is not mandatory
        }
        "application/fhir+json" => {
            headers.contentType = r4:JSON;
        }
        "application/x-www-form-urlencoded" => {
            // Accept for the POST search scenario
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

# Retrieves the operation parameter definition for a given parameter name.
#
# + paramName - The name of the operation parameter to find
# + parameterDefinitions - The parameter definitions to search
# + return - The matching parameter definition if found, nil otherwise
isolated function getOperationParameterDefinition(string paramName,
        r4:FHIROperationParameterDefinition[] parameterDefinitions) returns r4:FHIROperationParameterDefinition? {
    foreach r4:FHIROperationParameterDefinition paramDef in parameterDefinitions {
        if paramDef.name == paramName {
            return paramDef;
        }
    }
    return;
}

# Retrieves the operation part parameter definition for a given part parameter name.
#
# + partParamName - The name of the part parameter to find
# + multiPartParamDefinition - The multi-part operation parameter definition to search
# + return - The matching parameter definition if found, nil otherwise
isolated function getOperationPartParameterDefinition(string partParamName,
        r4:FHIROperationParameterDefinition multiPartParamDefinition) returns r4:FHIROperationParameterDefinition? {
    r4:FHIROperationParameterDefinition[]? parts = multiPartParamDefinition.part;
    return parts != () ? getOperationParameterDefinition(partParamName, parts) : ();
}

# Retrieves the operation parameter configuration for a given parameter name.
#
# + paramName - The name of the operation parameter to find
# + operationParameterConfigs - The operation parameter configs to search
# + return - The matching operation parameter config if found, nil otherwise
isolated function getOperationParameterConfig(string paramName,
        r4:OperationParamConfig[] operationParameterConfigs) returns r4:OperationParamConfig? {
    foreach r4:OperationParamConfig paramConfig in operationParameterConfigs {
        if paramConfig.name == paramName {
            return paramConfig;
        }
    }
    return;
}

# Retrieves the operation part parameter configuration for a given part parameter name.
#
# + partParamName - The name of the part parameter to find
# + multiPartParamConfig - The multi-part operation parameter configuration to search
# + return - The matching operation parameter config if found, nil otherwise
isolated function getOperationPartParameterConfig(string partParamName,
        r4:OperationParamConfig multiPartParamConfig) returns r4:OperationParamConfig? {
    r4:OperationParamConfig[]? parts = multiPartParamConfig.parts;
    return parts != () ? getOperationParameterConfig(partParamName, parts) : ();
}

# Extracts the names of active operations.
#
# + operationConfigMap - The operation configuration map to extract active operation names from
# + return - An array containing the names of active operations
isolated function extractActiveOperationNames(map<r4:OperationConfig> operationConfigMap) returns string[] {
    string[] activeOperations = [];
    foreach r4:OperationConfig operationConfig in operationConfigMap {
        if operationConfig.active {
            activeOperations.push(operationConfig.name);
        }
    }
    return activeOperations;
}

# Extracts the names of known operation input parameters.
#
# + paramDefinitions - The parameter definitions to extract input parameter names from
# + multiPartParam - The name of the multi-part parameter that the input parameters are part of, if any
# + return - An array containing the names of known input parameters
isolated function extractKnownOperationInParamNames(r4:FHIROperationParameterDefinition[] paramDefinitions,
        string? multiPartParam = ()) returns string[] {
    string[] knownParameters = [];
    foreach r4:FHIROperationParameterDefinition paramDefinition in paramDefinitions {
        if paramDefinition.use == r4:INPUT { // Only input parameters
            string paramName = multiPartParam != () ? string `${multiPartParam}.${paramDefinition.name}` : paramDefinition.name;
            if isMultiPartOperationParameter(paramDefinition) {
                // Check part parameters
                r4:FHIROperationParameterDefinition[]? partParamDefinitions = paramDefinition.part;
                if partParamDefinitions != () {
                    string[] partParams = extractKnownOperationInParamNames(partParamDefinitions, paramName);
                    knownParameters.push(...partParams);
                }
            } else {
                knownParameters.push(paramName);
            }
        }
    }
    return knownParameters;
}

# Extracts the names of active operation input parameters.
#
# + paramConfigs - The parameter configurations to extract input parameter names from
# + multiPartParam - The name of the multi-part parameter that the input parameters are part of, if any
# + return - An array containing the names of known input parameters
isolated function extractActiveOperationInParamNames(r4:OperationParamConfig[] paramConfigs,
        string? multiPartParam = ()) returns string[] {
    string[] activeParameters = [];
    foreach r4:OperationParamConfig paramConfig in paramConfigs {
        if paramConfig.active {
            string paramName = multiPartParam != () ? string `${multiPartParam}.${paramConfig.name}` : paramConfig.name;
            if isMultiPartOperationParameter(paramConfig) { // Multi-part parameter
                // Check part parameters
                r4:OperationParamConfig[]? partParamConfigs = paramConfig.parts;
                if partParamConfigs != () {
                    string[] partParams = extractActiveOperationInParamNames(partParamConfigs, paramName);
                    activeParameters.push(...partParams);
                }
            } else {
                activeParameters.push(paramName);
            }
        }
    }
    return activeParameters;
}

# Retrieves the scopes of a FHIR operation definition.
#
# + operationDefinition - The FHIR operation definition to extract scopes from.
# + return - An array of the FHIR interaction scopes of the operation definition.
isolated function getOperationScopes(r4:FHIROperationDefinition operationDefinition) returns string[] {
    string[] scopes = [];
    if operationDefinition.systemLevel {
        scopes.push(r4:FHIR_INTERACTION_SYSTEM);
    }
    if operationDefinition.typeLevel {
        scopes.push(r4:FHIR_INTERACTION_TYPE);
    }
    if operationDefinition.instanceLevel {
        scopes.push(r4:FHIR_INTERACTION_INSTANCE);
    }
    return scopes;
}

# Creates a `r4:FHIRError` for an unknown operation parameter.
#
# + paramName - The name of the unknown operation parameter
# + fhirOperation - The FHIR operation that the unknown parameter was part of
# + operationParamDefinitions - The operation parameter definitions for the FHIR operation
# + return - The created `r4:FHIRError`
isolated function createUnknownOperationParamError(string paramName, string fhirOperation,
        r4:FHIROperationParameterDefinition[] operationParamDefinitions) returns r4:FHIRError {
    string message = "Unknown operation parameter";
    string diagnostic = "Unknown parameter \"" + paramName + "\" for operation "
            + "\"$" + fhirOperation + "\". Known parameters for \"$" + fhirOperation + "\" operation: "
            + extractKnownOperationInParamNames(operationParamDefinitions).toBalString() + ".";
    return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
            httpStatusCode = http:STATUS_BAD_REQUEST);
}

# Creates a `r4:FHIRError` for an unsupported operation parameter.
#
# + paramName - The name of the unsupported operation parameter
# + fhirOperation - The FHIR operation that the unsupported parameter was part of
# + operationParamConfigs - The operation parameter configurations for the FHIR operation
# + return - The created `r4:FHIRError`
isolated function createUnsupportedOperationParamError(string paramName, string fhirOperation,
        r4:OperationParamConfig[] operationParamConfigs) returns r4:FHIRError {
    string message = "Unsupported operation parameter";
    string diagnostic = "Operation \"$" + fhirOperation + "\" does not support parameter \""
            + paramName + "\". Supported parameters for \"$" + fhirOperation + "\" operation: "
            + extractActiveOperationInParamNames(operationParamConfigs).toBalString() + ".";
    return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
            httpStatusCode = http:STATUS_BAD_REQUEST);
}

# Creates a `r4:FHIRError` for a multi-part operation parameter that is missing its parts.
#
# + paramName - The name of the multi-part operation parameter that is missing its parts
# + fhirOperation - The FHIR operation that the multi-part parameter was part of
# + operationParamDefinitions - The operation parameter definitions for the FHIR operation
# + return - The created `r4:FHIRError`
isolated function createMultiPartOperationParamWithoutPartsError(string paramName, string fhirOperation,
        r4:FHIROperationParameterDefinition[] operationParamDefinitions) returns r4:FHIRError {
    string message = "Invalid operation invocation";
    string diagnostic = "Multi-part parameter \"" + paramName + "\" requires its parts for operation \"$"
        + fhirOperation + "\". Please include all necessary parts for the multi-part parameter. "
        + "Known in parameters for \"$" + fhirOperation + "\" operation: "
        + extractKnownOperationInParamNames(operationParamDefinitions).toBalString() + ".";
    return r4:createFHIRError(message, r4:ERROR, r4:PROCESSING, diagnostic = diagnostic,
            httpStatusCode = http:STATUS_BAD_REQUEST);
}
