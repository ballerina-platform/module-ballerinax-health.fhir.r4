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
import ballerinax/health.clients.fhir as fhir_client;

configurable TerminologyConfig? terminologyConfig = ();

final boolean terminologyValidationEnabled = initializeTerminologyValidation();
final fhir_client:FHIRConnector? fhirConnector = check getFHIRConnectorConfig();

function initializeTerminologyValidation() returns boolean {
    if terminologyConfig?.isTerminologyValidationEnabled is false || terminologyConfig?.terminologyServiceApi is () {
        log:printDebug("Terminology validation is disabled or terminology service API is not configured.");
        return false;
    }
    if !isTerminologyServiceAvailable() {
        log:printInfo("Terminology service is not available. Skipping FHIR Connector creation.");
        return false;
    }
    return true;
}

function getFHIRConnectorConfig() returns fhir_client:FHIRConnector|error? {
    if !terminologyValidationEnabled {
        return ();
    }

    fhir_client:FHIRConnector connector;

    if terminologyConfig?.tokenUrl is () || terminologyConfig?.clientId is () || terminologyConfig?.clientSecret is () ||
        terminologyConfig?.tokenUrl == "" || terminologyConfig?.clientId == "" || terminologyConfig?.clientSecret == "" {
        connector = check new ({
            baseURL: terminologyConfig?.terminologyServiceApi.toString(),
            mimeType: fhir_client:FHIR_JSON
        });
    } else {
        connector = check new ({
            baseURL: terminologyConfig?.terminologyServiceApi.toString(),
            mimeType: fhir_client:FHIR_JSON,
            authConfig: {
                tokenUrl: terminologyConfig?.tokenUrl.toString(),
                clientId: terminologyConfig?.clientId.toString(),
                clientSecret: terminologyConfig?.clientSecret.toString()
            }
        });
    }

    log:printInfo("FHIR Connector created successfully for terminology service: " + terminologyConfig?.terminologyServiceApi.toString());
    return connector;
}

function isTerminologyServiceAvailable() returns boolean {
    if terminologyConfig?.terminologyServiceApi is () {
        log:printDebug("Terminology service API is not configured.");
        return false;
    }
    http:Client|http:ClientError termClient = new (<string>terminologyConfig?.terminologyServiceApi);

    if termClient is http:ClientError {
        return false;
    }

    http:Response|http:Error healthCheckResponse = termClient->head("/");

    if healthCheckResponse is http:Error {
        return false;
    }

    return true;
}

isolated function extractTerminologyCodes(anydata data) returns Term[] {
    Term[] result = [];

    if data is map<anydata> {
        if data.hasKey("valueCode") && data.hasKey("url") {
            result.push({
                code: <string>data["valueCode"],
                system: <string>data["url"]
            });

            // check is there is not other properties in the map
            if data.length() == 2 {
                return result;
            }
        }

        foreach var [key, value] in data.entries() {
            if key == "valueCoding" && value is map<anydata> {
                Term[] codingResult = extractCodesFromCodingElement(value);
                foreach Term item in codingResult {
                    result.push(item);
                }
            } else if key == "coding" && value is anydata[] {
                foreach anydata item in value {
                    Term[] codeableResult = extractCodesFromCodingElement(item);
                    foreach Term codeableItem in codeableResult {
                        result.push(codeableItem);
                    }
                }
            } else if value is map<anydata> || value is anydata[] {
                Term[] nestedResult = extractTerminologyCodes(value);
                foreach Term item in nestedResult {
                    result.push(item);
                }
            }
        }
    } else if data is anydata[] {
        foreach anydata item in data {
            Term[] arrayResult = extractTerminologyCodes(item);
            foreach Term arrayItem in arrayResult {
                result.push(arrayItem);
            }
        }
    }

    return result;
}

isolated function extractCodesFromCodingElement(anydata data) returns Term[] {
    Term[] result = [];

    if data is map<anydata> {
        if data.hasKey("code") && data.hasKey("system") {
            result.push({
                code: <string>data["code"],
                system: <string>data["system"],
                'version: data.hasKey("version") ? <string>data["version"] : null
            });
        }
        if data.hasKey("extension") {
            Term[] extensionResult = extractTerminologyCodes(data["extension"]);
            foreach Term item in extensionResult {
                result.push(item);
            }
        }
    }

    return result;
}

isolated function validateTerminologyData(anydata data) returns string[]? {
    Term[] terms = extractTerminologyCodes(data);

    string[] errors = [];
    int responseStatusCode = 0;

    if fhirConnector is () {
        log:printDebug("FHIR Connector is not available. Skipping terminology validation.");
        return ();
    }

    foreach Term term in terms {
        map<string[]> queryParamsMap = {
            "system": [term.system],
            "code": [term.code],
            "version": term.'version is string ? ([<string>term.'version]) : []
        };

        // Send GET request to ValueSet validate-code API
        fhir_client:FHIRResponse|fhir_client:FHIRError valuesetResponse = (<fhir_client:FHIRConnector>fhirConnector)->callOperation(
            VALUE_SET,
            operationName = VALIDATE_CODE,
            mode = http:GET,
            queryParameters = queryParamsMap,
            returnMimeType = fhir_client:FHIR_JSON);

        if valuesetResponse is fhir_client:FHIRResponse {
            // get the HTTP status code from the response
            responseStatusCode = valuesetResponse.httpStatusCode;
        } else if valuesetResponse is fhir_client:FHIRServerError {
            // if the response is an error, extract the HTTP status code
            fhir_client:FHIRServerErrorDetails valuesetErrorDetails = valuesetResponse.detail();
            responseStatusCode = valuesetErrorDetails.httpStatusCode;
        }

        if responseStatusCode == http:STATUS_NOT_FOUND {
            // ValueSet NOT_FOUND or invalid code (terminology service returns 404 for both cases), proceed to check CodeSystem
            // Send GET request to CodeSystem lookup API
            fhir_client:FHIRResponse|fhir_client:FHIRError codesystemResponse = (<fhir_client:FHIRConnector>fhirConnector)->callOperation(
                CODE_SYSTEM,
                operationName = LOOKUP,
                mode = http:GET,
                queryParameters = queryParamsMap,
                returnMimeType = fhir_client:FHIR_JSON);

            if codesystemResponse is fhir_client:FHIRResponse {
                responseStatusCode = codesystemResponse.httpStatusCode;
            } else if codesystemResponse is fhir_client:FHIRServerError {
                fhir_client:FHIRServerErrorDetails codesystemErrorDetails = codesystemResponse.detail();
                responseStatusCode = codesystemErrorDetails.httpStatusCode;
            }

            if responseStatusCode == http:STATUS_NOT_FOUND {
                // If the code is not found in CodeSystem, add an error message
                errors.push("Terminology code '" + term.code + "' with system '" + term.system + "' not found.");
            } else if responseStatusCode == http:STATUS_BAD_REQUEST {
                // Can't find CodeSystem or ValueSet for the given system and code, but the terminology service is configured to ignore this error
                // and assume that the code is valid.
                // This is a common scenario when the CodeSystem is not added to the terminology service.
                log:printDebug("CodeSystem or ValueSet not found. System: '" + term.system + "', Code: '" + term.code + "'. Assuming the code is valid.");
            }
            // ignore other response codes as they are not relevant for validation
        } else if responseStatusCode == http:STATUS_BAD_REQUEST {
            errors.push("Terminology code '" + term.code + "' with system '" + term.system + "' not found.");
        }
        // ignore other response codes as they are not relevant for validation
    }

    return errors.length() == 0 ? () : errors;
}
