import ballerina/http;
import ballerina/lang.regexp;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.parser;
import ballerinax/health.fhir.r4.validator;

public isolated function validateContext(CdsRequest cdsRequest, CdsService cdsService) returns CdsError? {

    Hook hook = <Hook>cdsRequest.hook;
    Context context = cdsRequest.context;
    string errorMessage = string `Context validation failed: ${hook}`;
    string description = string `Context should only contains set of data allowed by the specification: https://cds-hooks.hl7.org/hooks/${hook}/STU1/${hook}/#context`;

    Context|error clone = createCdsError(string `Unkown hook: ${hook}`, 400);
    match hook {
        PATIENT_VIEW => {
            clone = context.cloneWithType(PatientViewContext);
        }

        ORDER_SIGN => {
            clone = context.cloneWithType(OrderSignContext);
        }

        ORDER_SELECT => {
            clone = context.cloneWithType(OrderSelectContext);
        }

        ORDER_DISPATCH => {
            clone = context.cloneWithType(OrderDispatchContext);
        }

        ENCOUNTER_START => {
            clone = context.cloneWithType(EncounterStartContext);
        }

        ENCOUNTER_DISCHARGE => {
            clone = context.cloneWithType(EncounterDischargeContext);
        }
    }

    if ((clone is error)) {
        return createCdsError(errorMessage, 400, description = description);
    }

    return;
}

public isolated function validateAndProcessPrefetch(CdsRequest cdsRequest, CdsService cdsService) returns CdsRequest|CdsError {
    map<string> prefetchTemplates = {};
    map<r4:DomainResource> prefetchData = {};
    CdsRequest request = cdsRequest.clone();

    // If the CDS service has no prefetch templates defined, then no need to validate the request
    if cdsService.prefetch is map<string> {
        prefetchTemplates = <map<string>>cdsService.prefetch;
        if (prefetchTemplates.keys().length() < 1) {
            return request;
        }
    } else {
        return request;
    }

    if (request.prefetch is map<r4:DomainResource>) {
        prefetchData = <map<r4:DomainResource>>request.prefetch;
    }

    // If there are no any prefetch data in the request, or
    // required prefetch template keys are not matching with keys in the request prefetch data 
    //then following should we given in the request to fetch the required FHIR data
    string[] templateKeys = prefetchTemplates.keys().sort();
    string[] dataKeys = prefetchData.keys().sort();
    if (templateKeys != dataKeys || templateKeys.count() > dataKeys.count()) {
        // 1. Fhir server url
        if (request.fhirServer !is string) {
            return createCdsError("Can not find fhirServer url in the request", 400);
        }

        // 2. FhirAuthorization object contains access token, scopes etc
        if (request.fhirAuthorization !is FhirAuthorization) {
            return createCdsError("Can not find fhirAuthorization in the request", 400);
        }

        // Fetch missing prefetch FHIR data
        foreach string templateId in prefetchTemplates.keys() {
            if (!prefetchData.hasKey(templateId)) {
                request = check fetchFhirResource(templateId, prefetchTemplates.get(templateId), request);
            } else {
                r4:FHIRValidationError? validated = validator:validate(prefetchData.get(templateId));
                if validated is r4:FHIRValidationError {
                    return createCdsError(string `FHIR data provided for prefetch ${templateId} in the request is not valid`, 412, cause = validated);
                }
            }
        }
    } else {
        foreach var key in prefetchData.keys() {
            r4:FHIRValidationError? validated = validator:validate(prefetchData.get(key));
            if validated is r4:FHIRValidationError {
                return createCdsError(string `FHIR data provided for the prefetch: ${key}`, 400, cause = validated);
            }
        }
    }

    return request;
}

isolated function fetchFhirResource(string prefetchTemplateKey, string prefetchTemplate, CdsRequest cdsRequest) returns CdsError|CdsRequest {
    string template = prefetchTemplate.clone();
    string split = regexp:split(re `\.`, regexp:split(re `\}\}`, regexp:split(re `\{\{`, prefetchTemplate)[1])[0])[1];
    string fhirServer = <string>cdsRequest.fhirServer;
    anydata contextValue = cdsRequest.context.get(split);
    if contextValue is string {
        template = regexp:replace(re `\{\{context.${split}\}\}`, template, contextValue);
    }

    if (fhirServer.endsWith("/")) {
        fhirServer = fhirServer.substring(0, fhirServer.length() - 1);
    }

    if (!(template.startsWith("/"))) {
        template = string `/${template}`;
    }

    http:Client|http:ClientError fhirClient = new (fhirServer);
    if (fhirClient is http:Client) {
        map<string|string[]> headers = {
            "Authorization": string `Bearer ${(<FhirAuthorization>cdsRequest.fhirAuthorization).access_token}`
        };
        http:Response|http:ClientError response = fhirClient->get(template, headers);
        if (response is http:Response) {
            json|http:ClientError jsonPayload = response.getJsonPayload();
            if (jsonPayload is http:ClientError) {
                return createCdsError(string `FHIR data retrieved for : ${fhirServer}${template} is not JSON`, 412, cause = jsonPayload);
            } else {
                r4:DomainResource|error parsedResource = parser:parse(jsonPayload).ensureType(r4:DomainResource);
                if parsedResource is r4:DomainResource {
                    if (parsedResource is r4:OperationOutcome) {
                        return createCdsError(string `FHIR data retrieved for : ${fhirServer}${template} is not valid`, 412);
                    } else {
                        r4:FHIRValidationError? validatedData = validator:validate(jsonPayload);
                        if validatedData is r4:FHIRValidationError {
                            return createCdsError(string `FHIR data retrieved for : ${fhirServer}${template} is not valid`, 412, cause = validatedData);
                        } else {
                            cdsRequest.prefetch[prefetchTemplateKey] = parsedResource;
                            return cdsRequest;
                        }
                    }
                } else {
                    return createCdsError(string `Data retrieved for : ${fhirServer}${template} is not FHIR data`, 412, cause = parsedResource);
                }
            }
        } else {
            return createCdsError(string `Something went wrong while fetching the FHIR resource: ${fhirServer}${template}`, 500, cause = response);
        }
    } else {
        return createCdsError(string `Can not make a HTTP client for the server url: ${fhirServer}`, 400, cause = fhirClient);
    }
}

# Create a CDS type error.
#
# + message - Message to be added to the error.  
# + statusCode - Http status code.  
# + description - Human readable description about the issue.  
# + cause - (optional) original error.
# + return - CDS error record
public isolated function createCdsError(string message, int statusCode, string? description = (), error? cause = ()) returns CdsError {
    return error(message, message = message, code = statusCode, description = description, cause = cause);
}

# Create HTTP response from a CDS error record.
#
# + cdsError - CDS error record.
# + return - return HTTP response.
public isolated function cdsErrorToHttpResponse(CdsError cdsError) returns http:Response {
    http:Response response = new;

    response.statusCode = cdsError.detail().code;
    json responBody = {
        "message": cdsError.message()
    };

    string? description = cdsError.detail().description;
    if (description is string) {
        json|error mergeJson = responBody.mergeJson({"description": description});
        if mergeJson is json {
            responBody = mergeJson;
        }
    }

    response.setJsonPayload(responBody);
    return response;
}
