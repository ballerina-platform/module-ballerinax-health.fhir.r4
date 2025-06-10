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

const string CODESYSTEM_LOOKUP = "/CodeSystem/%24lookup";
const string VALUESET_VALIDATE_CODE = "/ValueSet/%24validate-code";

configurable TerminologyConfig? terminologyConfig = ();

# Retrieve an HTTP client configured for the terminology service.
#
# This function creates and returns an `http:Client` instance to interact with the terminology service API.
# If authentication details (token URL, client ID, and client secret) are provided in the `terminologyConfig`,
# the client is configured with authentication. Otherwise, a basic client is created without authentication.
#
# + return - An `http:Client` instance if successful, or an `error` if the client creation fails
isolated function getTerminologyClient() returns http:Client|error {
    http:ClientAuthConfig? authConfig;

    if terminologyConfig?.tokenUrl is () || terminologyConfig?.clientId is () || terminologyConfig?.clientSecret is () ||
        terminologyConfig?.tokenUrl == "" || terminologyConfig?.clientId == "" || terminologyConfig?.clientSecret == "" {
        return check new (<string>terminologyConfig?.terminologyServiceApi);
    } else {
        authConfig = {
            tokenUrl: <string>terminologyConfig?.tokenUrl,
            clientId: <string>terminologyConfig?.clientId,
            clientSecret: <string>terminologyConfig?.clientSecret
        };

        return check new (<string>terminologyConfig?.terminologyServiceApi, auth = authConfig);
    }
}

# Extract terminology codes from the given data.
#
# + data - Input data to extract terminology codes from
# + return - An array of extracted `Term` records
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

# Extract codes from a coding element in the given data.
#
# + data - Input data containing coding elements
# + return - An array of extracted `Term` records
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

# Validate terminology codes using a terminology service.
#
# + terms - Array of `Term` records to validate
# + return - An array of error messages if validation fails, or `null` if validation succeeds
isolated function validateTerminologyCodes(Term[] terms) returns string[]|error? {
    http:Client termClient = check getTerminologyClient();

    string[] errors = [];

    foreach Term term in terms {
        string queryParams = string `?system=${term.system}&code=${term.code}${(term.'version is string ? "&version=" + <string>term.'version : "")}&_format=json`;

        // Send GET request to ValueSet validate-code API
        http:Response|http:Error valuesetResponse = termClient->get(VALUESET_VALIDATE_CODE + queryParams);

        if valuesetResponse is http:Response {
            if valuesetResponse.statusCode == 404 {
                // Send GET request to CodeSystem lookup API
                http:Response|http:Error codesystemResponse = termClient->get(CODESYSTEM_LOOKUP + queryParams);

                if codesystemResponse is http:Response {
                    if codesystemResponse.statusCode == 404 {
                        errors.push("Invalid code: " + term.code + " in system: " + term.system);
                    }
                }
            }
        }
    }

    return errors.length() == 0 ? null : errors;
}

# Check if the terminology service is available.
#
# + return - `true` if the service is available, `false` otherwise, or an error if the check fails
isolated function isTerminologyServiceAvailable() returns boolean|error? {
    if terminologyConfig?.terminologyServiceApi is () {
        log:printDebug("Terminology service API is not configured.");
        return false;
    }
    http:Client termClient = check new (<string>terminologyConfig?.terminologyServiceApi);
    http:Response|http:Error healthCheckResponse = termClient->head("/");

    if healthCheckResponse is http:Error {
        log:printError("Terminology service is not available: " + healthCheckResponse.message());
        return false;
    }

    return true;
}

# Validate terminology data by extracting and validating terminology codes.
#
# + data - Input data to validate
# + return - An array of error messages if validation fails, or `null` if validation succeeds
isolated function validateTerminologyData(anydata data) returns string[]|error? {
    boolean|error? isService = isTerminologyServiceAvailable();
    if isService is error {
        return isService;
    } else if isService is boolean && !isService {
        return;
    }

    Term[] result = extractTerminologyCodes(data);

    return validateTerminologyCodes(result);
}
