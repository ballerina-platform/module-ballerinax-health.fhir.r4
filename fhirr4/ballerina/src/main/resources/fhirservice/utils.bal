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
import ballerina/lang.regexp;
import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.ips;
import ballerinax/health.fhir.r4.parser;

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
