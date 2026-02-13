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

# FHIR Context class: used to transfer FHIR request related information down integration flow
public isolated class FHIRContext {
    private MessageDirection direction = IN;
    private final FHIRRequest fhirRequest;
    private final readonly & FHIRSecurity fhirSecurity;
    private final readonly & HTTPRequest httpRequest;
    private HTTPResponse? httpResponse = ();
    private FHIRResponse|FHIRContainerResponse? fhirResponse = ();
    private boolean inErrorState = false;
    private int errorCode = 500;
    private string rawPath = "";
    private map<anydata> properties = {};
    private PaginationContext? paginationContext = ();
    private ConsentContext? consentContext = ();

    public isolated function init(FHIRRequest request, readonly & HTTPRequest httpRequest, readonly & FHIRSecurity security) {
        self.fhirRequest = request;
        self.httpRequest = httpRequest;
        self.fhirSecurity = security;
    }

    # Set context direction : indicate whether the request is in request direction or response direction.
    #
    # + direction - message direction (IMPORTANT : This is used for internal processing hence adviced not to update)
    public isolated function setDirection(MessageDirection direction) {
        lock {
            self.direction = direction;
        }
    }

    # Get context direction : indicate whether the request is in request direction or response direction.
    #
    # + return - Message direction
    public isolated function getDirection() returns MessageDirection {
        lock {
            return self.direction;
        }
    }

    # Set the raw path of the requested resource.
    #
    # + path - raw path of the requested resource.
    public isolated function setRawPath(string path) {
        lock {
            self.rawPath = path;
        }
    }

    # Gets the raw path of the requested resource.
    # + return - return the raw path of the requested resource.
    public isolated function getRawPath() returns string {
        lock {
            return self.rawPath;
        }
    }

    # Set error state : indicate whether the request is in error state or not.
    # + return - whether the request is in error state or not.
    public isolated function isInErrorState() returns boolean {
        lock {
            return self.inErrorState;
        }
    }

    # Set error state : indicate whether the request is in error state or not.
    # + inErrorState - whether the request is in error state or not.
    public isolated function setInErrorState(boolean inErrorState) {
        lock {
            self.inErrorState = inErrorState;
        }
    }

    # Get error code : error code of the request, if in error.
    # + errorCode - error code of the request, if in error.
    public isolated function setErrorCode(int errorCode) {
        lock {
            self.errorCode = errorCode;
        }
    }

    # Get error code : error code of the request, if in error.
    # + return - error code of the request, if in error.
    public isolated function getErrorCode() returns int {
        lock {
            return self.errorCode;
        }
    }

    # Get FHIR request.
    # FHIR request parsed information about incoming FHIR request from the client application.
    #
    # + return - FHIR request object
    public isolated function getFHIRRequest() returns FHIRRequest? {
        return self.fhirRequest;
    }

    # Get FHIR security information.
    # FHIR request derived security information about incoming FHIR request from the client application.
    #
    # + return - FHIR security record
    public isolated function getFHIRSecurity() returns FHIRSecurity? {
        return self.fhirSecurity;
    }

    # Get incoming raw HTTP request information.
    #
    # + return - Incoming HTTP request
    public isolated function getHTTPRequest() returns HTTPRequest? {
        return self.httpRequest;
    }

    # Set FHIR response sent to client application.
    #
    # + response - FHIR response message
    isolated function setFHIRResponse(FHIRResponse|FHIRContainerResponse response) {
        lock {
            self.fhirResponse = response;
        }
    }

    # Get FHIR response.
    #
    # + return - FHIR response
    public isolated function getFHIRResponse() returns FHIRResponse|FHIRContainerResponse? {
        lock {
            return self.fhirResponse;
        }
    }

    # Set custom HTTP response sent to client.
    #
    # + response - HTTP response object
    public isolated function setHTTPResponse(HTTPResponse response) {
        lock {
            self.httpResponse = response.clone();
        }
    }

    # Get custom HTTP response object.
    #
    # + return - HTTP response object in the context.
    public isolated function getHTTPResponse() returns HTTPResponse? {
        lock {
            return self.httpResponse.clone();
        }
    }

    # Add a custom response header to the response.
    #
    # + headerName - Header name
    # + headerValue - Header value, for multiple values, use comma separated string
    public isolated function addResponseHeader(string headerName, string headerValue) {

        lock {
            if (self.httpResponse is ()) {
                self.httpResponse = {headers: {}, statusCode: ()};
            }

            HTTPResponse response = <HTTPResponse>self.httpResponse;

            // If the header already exists. Override the initial value of the header.
            response.headers[headerName] = headerValue;
        }

    }

    # Set a custom status code to the Response.
    #
    # + statusCode - HTTP status code
    public isolated function setResponseStatusCode(int statusCode) {

        lock {
            if (self.httpResponse is ()) {
                self.httpResponse = {headers: {}, statusCode: ()};
            }
            HTTPResponse response = <HTTPResponse>self.httpResponse;
            response.statusCode = statusCode;
        }
    }

    # Get a property from the fhir context.
    #
    # + key - property key
    # + return - property value
    public isolated function getProperty(string key) returns anydata? {
        lock {
            if self.properties.hasKey(key) {
                return self.properties.get(key).cloneReadOnly();
            }
        }
        return;
    }

    # Set a property to the fhir context.
    #
    # + key - property key  
    # + value - property value
    public isolated function setProperty(string key, anydata value) {
        lock {
            self.properties[key] = value.cloneReadOnly();
        }
    }

    # Set pagination info to fhir context.
    #
    # + paginationContext - Pagination context record with page size and page number
    public isolated function setPaginationContext(PaginationContext paginationContext) {
        lock {
            self.paginationContext = paginationContext.cloneReadOnly();
        }
    }

    # Get pagination info from fhir context.
    #
    # + return - Pagination context
    public isolated function getPaginationContext() returns PaginationContext? {
        lock {
            return self.paginationContext;
        }
    }

    # Set consent context to fhir context.
    #
    # + consentContext - Consent context record with consented resource types
    public isolated function setConsentContext(ConsentContext consentContext) {
        lock {
            self.consentContext = consentContext.cloneReadOnly();
        }
    }

    # Get consent context from fhir context.
    #
    # + return - Consent context
    public isolated function getConsentContext() returns ConsentContext? {
        lock {
            return self.consentContext;
        }
    }

    # Get FHIR interaction information parsed from the incoming FHIR request.
    # http://hl7.org/fhir/http.html#3.1.0.
    #
    # + return - FHIR interaction record
    public isolated function getInteraction() returns FHIRInteraction {
        return self.fhirRequest.getInteraction();
    }

    # Get target FHIR resource type.
    #
    # + return - FHIR resource type
    public isolated function getResourceType() returns string? {
        return self.fhirRequest.getResourceType();
    }

    # Get client accepted response format.
    #
    # + return - Client accepted FHIR payload format
    public isolated function getClientAcceptFormat() returns FHIRPayloadFormat {
        return self.fhirRequest.getClientAcceptFormat();
    }

    # Get FHIR User : End user information available in the JWT.
    #
    # + return - FHIR Usr information
    public isolated function getFHIRUser() returns readonly & FHIRUser? {
        return self.fhirSecurity.fhirUser;
    }

    # Get all request parameters.
    #
    # + return - Request search parameter map (Key of the map is name of the search parameter).
    public isolated function getRequestSearchParameters() returns readonly & map<readonly & RequestSearchParameter[]> {
        return self.fhirRequest.getSearchParameters();
    }

    # Get search parameter with given name.
    #
    # + name - Name of the search parameter
    # + return - Request search parameter array if available. Otherwise nil
    public isolated function getRequestSearchParameter(string name) returns readonly & RequestSearchParameter[]? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            return searchParameters.get(name);
        }
        return ();
    }

    # Function to get Number typed search parameter with given name from the FHIR API request.
    #
    # + name - Name of the search parameter
    # + return - Search parameter if exists, nil if not found and FHIRTypeError if search parameter is not Number type
    public isolated function getNumberSearchParameter(string name) returns NumberSearchParameter[]|FHIRTypeError? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            NumberSearchParameter[] paramArray = [];
            foreach readonly & RequestSearchParameter param in searchParameters.get(name) {
                FHIRTypedSearchParameter typedValue = param.typedValue;
                if typedValue is NumberSearchParameter {
                    paramArray.push(typedValue);
                } else {
                    string msg = "Search parameter type mismatch";
                    string diagMsg = string `FHIR Search parameter with name : ${name} is not a Number type search parameter.
                        Search parameter type : ${(typeof param).toBalString()}`;
                    return <FHIRTypeError>createInternalFHIRError(msg, ERROR, PROCESSING, diagnostic = diagMsg, errorType = TYPE_ERROR);
                }
            }
            return paramArray;
        }
        return ();
    }

    # Function to get Reference typed search parameter with given name from the FHIR API request.
    #
    # + name - Name of the search parameter
    # + return - Search parameter if exists, nil if not found and FHIRTypeError if search parameter is not Reference type
    public isolated function getReferenceSearchParameter(string name) returns ReferenceSearchParameter[]|FHIRTypeError? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            ReferenceSearchParameter[] paramArray = [];
            foreach readonly & RequestSearchParameter param in searchParameters.get(name) {
                FHIRTypedSearchParameter typedValue = param.typedValue;
                if typedValue is ReferenceSearchParameter {
                    paramArray.push(typedValue);
                } else {
                    string msg = "Search parameter type mismatch";
                    string diagMsg = string `FHIR Search parameter with name : ${name} is not a Reference type search parameter.
                        Search parameter type : ${(typeof param).toBalString()}`;
                    return <FHIRTypeError>createInternalFHIRError(msg, ERROR, PROCESSING, diagnostic = diagMsg, errorType = TYPE_ERROR);
                }
            }
            return paramArray;
        }
        return ();
    }

    # Function to get String typed search parameter with given name from the FHIR API request.
    #
    # + name - Name of the search parameter
    # + return - Search parameter if exists, nil if not found and FHIRTypeError if search parameter is not String type
    public isolated function getStringSearchParameter(string name) returns StringSearchParameter[]|FHIRTypeError? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            StringSearchParameter[] paramArray = [];
            foreach readonly & RequestSearchParameter param in searchParameters.get(name) {
                FHIRTypedSearchParameter typedValue = param.typedValue;
                if typedValue is StringSearchParameter {
                    paramArray.push(typedValue);
                } else {
                    string msg = "Search parameter type mismatch";
                    string diagMsg = string `FHIR Search parameter with name : ${name} is not a String type search parameter.
                        Search parameter type : ${(typeof param).toBalString()}`;
                    return <FHIRTypeError>createInternalFHIRError(msg, ERROR, PROCESSING, diagnostic = diagMsg, errorType = TYPE_ERROR);
                }
            }
            return paramArray;
        }
        return ();
    }

    # Function to get Token typed search parameter with given name from the FHIR API request.
    #
    # + name - Name of the search parameter
    # + return - Search parameter if exists, nil if not found and FHIRTypeError if search parameter is not Token type
    public isolated function getTokenSearchParameter(string name) returns TokenSearchParameter[]|FHIRTypeError? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            TokenSearchParameter[] paramArray = [];
            foreach readonly & RequestSearchParameter param in searchParameters.get(name) {
                FHIRTypedSearchParameter typedValue = param.typedValue;
                if typedValue is TokenSearchParameter {
                    paramArray.push(typedValue);
                } else {
                    string msg = "Search parameter type mismatch";
                    string diagMsg = string `FHIR Search parameter with name : ${name} is not a Token type search parameter.
                        Search parameter type : ${(typeof param).toBalString()}`;
                    return <FHIRTypeError>createInternalFHIRError(msg, ERROR, PROCESSING, diagnostic = diagMsg, errorType = TYPE_ERROR);
                }
            }
            return paramArray;
        }
        return ();
    }

    # Function to get URI typed search parameter with given name from the FHIR API request.
    #
    # + name - Name of the search parameter
    # + return - Search parameter if exists, nil if not found and FHIRTypeError if search parameter is not URI type
    public isolated function getURISearchParameter(string name) returns URISearchParameter[]|FHIRTypeError? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            URISearchParameter[] paramArray = [];
            foreach readonly & RequestSearchParameter param in searchParameters.get(name) {
                FHIRTypedSearchParameter typedValue = param.typedValue;
                if typedValue is URISearchParameter {
                    paramArray.push(typedValue);
                } else {
                    string msg = "Search parameter type mismatch";
                    string diagMsg = string `FHIR Search parameter with name : ${name} is not a URI type search parameter.
                        Search parameter type : ${(typeof param).toBalString()}`;
                    return <FHIRTypeError>createInternalFHIRError(msg, ERROR, PROCESSING, diagnostic = diagMsg, errorType = TYPE_ERROR);
                }
            }
            return paramArray;
        }
        return ();
    }

    # Function to get Date typed search parameter with given name from the FHIR API request.
    #
    # + name - Name of the search parameter
    # + return - Search parameter if exists, nil if not found and FHIRTypeError if search parameter is not Date type
    public isolated function getDateSearchParameter(string name) returns DateSearchParameter[]|FHIRTypeError? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            DateSearchParameter[] paramArray = [];
            foreach readonly & RequestSearchParameter param in searchParameters.get(name) {
                FHIRTypedSearchParameter typedValue = param.typedValue;
                if typedValue is DateSearchParameter {
                    paramArray.push(typedValue);
                } else {
                    string msg = "Search parameter type mismatch";
                    string diagMsg = string `FHIR Search parameter with name : ${name} is not a Date type search parameter.
                        Search parameter type : ${(typeof param).toBalString()}`;
                    return <FHIRTypeError>createInternalFHIRError(msg, ERROR, PROCESSING, diagnostic = diagMsg, errorType = TYPE_ERROR);
                }
            }
            return paramArray;
        }
        return ();
    }

    # Function to get Quantity typed search parameter with given name from the FHIR API request.
    #
    # + name - Name of the search parameter
    # + return - Search parameter if exists, nil if not found and FHIRTypeError if search parameter is not Quantity type
    public isolated function getQuantitySearchParameter(string name) returns QuantitySearchParameter[]|FHIRTypeError? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            QuantitySearchParameter[] paramArray = [];
            foreach readonly & RequestSearchParameter param in searchParameters.get(name) {
                FHIRTypedSearchParameter typedValue = param.typedValue;
                if typedValue is QuantitySearchParameter {
                    paramArray.push(typedValue);
                } else {
                    string msg = "Search parameter type mismatch";
                    string diagMsg = string `FHIR Search parameter with name : ${name} is not a Quantity type search parameter.
                        Search parameter type : ${(typeof param).toBalString()}`;
                    return <FHIRTypeError>createInternalFHIRError(msg, ERROR, PROCESSING, diagnostic = diagMsg, errorType = TYPE_ERROR);
                }
            }
            return paramArray;
        }
        return ();
    }

    # Function to get Composite typed search parameter with given name from the FHIR API request.
    #
    # + name - Name of the search parameter
    # + return - Search parameter if exists, nil if not found and FHIRTypeError if search parameter is not Composite type
    public isolated function getCompositeSearchParameter(string name) returns CompositeSearchParameter[]|FHIRTypeError? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            CompositeSearchParameter[] paramArray = [];
            foreach readonly & RequestSearchParameter param in searchParameters.get(name) {
                FHIRTypedSearchParameter typedValue = param.typedValue;
                if typedValue is CompositeSearchParameter {
                    paramArray.push(typedValue);
                } else {
                    string msg = "Search parameter type mismatch";
                    string diagMsg = string `FHIR Search parameter with name : ${name} is not a Composite type search parameter.
                        Search parameter type : ${(typeof param).toBalString()}`;
                    return <FHIRTypeError>createInternalFHIRError(msg, ERROR, PROCESSING, diagnostic = diagMsg, errorType = TYPE_ERROR);
                }
            }
            return paramArray;
        }
        return ();
    }

    # Function to get Special typed search parameter with given name from the FHIR API request.
    #
    # + name - Name of the search parameter
    # + return - Search parameter if exists, nill if not found and FHIRTypeError if search parameter is not Special type
    public isolated function getSpecialSearchParameter(string name) returns SpecialSearchParameter[]|FHIRTypeError? {
        map<RequestSearchParameter[] & readonly> & readonly searchParameters = self.fhirRequest.getSearchParameters();
        if searchParameters.hasKey(name) {
            SpecialSearchParameter[] paramArray = [];
            foreach readonly & RequestSearchParameter param in searchParameters.get(name) {
                FHIRTypedSearchParameter typedValue = param.typedValue;
                if typedValue is SpecialSearchParameter {
                    paramArray.push(typedValue);
                } else {
                    string msg = "Search parameter type mismatch";
                    string diagMsg = string `FHIR Search parameter with name : ${name} is not a Special type search parameter.
                        Search parameter type : ${(typeof param).toBalString()}`;
                    return <FHIRTypeError>createInternalFHIRError(msg, ERROR, PROCESSING, diagnostic = diagMsg, errorType = TYPE_ERROR);
                }
            }
            return paramArray;
        }
        return ();
    }
}
