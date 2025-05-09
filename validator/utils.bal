import ballerina/http;

const string TERMINOLOFY_SERVICE_API = "http://localhost:9090/fhir/r4";
const string CODESYSTEM_LOOKUP = "/Codesystem/%24lookup";
const string VALUESET_VALIDATE_CODE = "/Valueset/%24validate-code";

type Term record {
    string code;
    string system;
    string version?;
};

isolated function extractCodesAndSystems(anydata data) returns Term[] {
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
                Term[] codingResult = extractFromR4Coding(value);
                foreach Term item in codingResult {
                    result.push(item);
                }
            } else if key == "coding" && value is anydata[] {
                foreach anydata item in value {
                    Term[] codeableResult = extractFromR4Coding(item);
                    foreach Term codeableItem in codeableResult {
                        result.push(codeableItem);
                    }
                }
            } else if value is map<anydata> || value is anydata[] {
                Term[] nestedResult = extractCodesAndSystems(value);
                foreach Term item in nestedResult {
                    result.push(item);
                }
            }
        }
    } else if data is anydata[] {
        foreach anydata item in data {
            Term[] arrayResult = extractCodesAndSystems(item);
            foreach Term arrayItem in arrayResult {
                result.push(arrayItem);
            }
        }
    }

    return result;
}

isolated function extractFromR4Coding(anydata data) returns Term[] {
    Term[] result = [];

    if data is map<anydata> {
        if data.hasKey("code") && data.hasKey("system") {
            result.push({
                code: <string>data["code"],
                system: <string>data["system"],
                version: data.hasKey("version") ? <string>data["version"] : null
            });
        }
        if data.hasKey("extension") {
            Term[] extensionResult = extractCodesAndSystems(data["extension"]);
            foreach Term item in extensionResult {
                result.push(item);
            }
        }
    }

    return result;
}

isolated function checkTerminologyValidity(Term[] terms) returns string[]|error? {
    http:Client termClient = check new (TERMINOLOFY_SERVICE_API);

    string[] errors = [];

    foreach Term term in terms {
        string queryParams = string `?system=${term.system}&code=${term.code}${(term.version is string ? "&version=" + <string>term.version : "")}`;

        // Send GET request to ValueSet validate-code API
        http:Response|http:Error valuesetResponse = termClient->get(VALUESET_VALIDATE_CODE + queryParams);

        if valuesetResponse is http:Response {
            // response is 200 is valid code in the system
            // response is 400 is not defined terminology
            // response is 404 is not found terminology

            if valuesetResponse.statusCode == 404 {
                // Send GET request to CodeSystem lookup API
                http:Response|http:Error codesystemResponse = termClient->get(CODESYSTEM_LOOKUP + queryParams);

                if codesystemResponse is http:Response {
                    if codesystemResponse.statusCode == 404 {
                        errors.push("Invalid code: " + term.code + " in system: " + term.system);
                    }

                    // skip not defined terminologies (statusCode == 400)
                }
            }
        }
    }

    if errors.length() == 0 {
        return;
    }

    return errors;
}

isolated function isTerminologyService() returns boolean|error? {
    http:Client termClient = check new (TERMINOLOFY_SERVICE_API);
    http:Response|http:Error healthCheckResponse = termClient->head("/");

    if healthCheckResponse is http:Error {
        return false;
    }

    return true;
}

public isolated function validateTerminologies(anydata data) returns string[]|error? {
    boolean|error? isService = isTerminologyService();
    if isService is error {
        return isService;
    } else if isService is boolean && !isService {
        return;
    }

    Term[] result = extractCodesAndSystems(data);

    return checkTerminologyValidity(result);
}
