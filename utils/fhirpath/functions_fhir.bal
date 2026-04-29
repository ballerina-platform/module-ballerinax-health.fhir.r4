// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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

// ========================================
// FHIR-SPECIFIC FUNCTIONS
// ========================================

# Implements the FHIRPath extension() function.
# Returns extension(s) matching the given URL from FHIR resources.
#
# + collection - The collection to search for extensions
# + params - Function parameters [url expression]
# + context - The current evaluation context
# + env - The evaluation environment
# + return - Matching extension objects, or an error
isolated function applyExtensionFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("extension", "1 parameter", params.length());
    }
    json[] urlResult = check evaluate(params[0], context, env);
    if urlResult.length() == 0 {
        return [];
    }
    json urlVal = urlResult[0];
    if urlVal !is string {
        return [];
    }
    string url = urlVal;

    json[] result = [];
    foreach json item in collection {
        if item is map<json> {
            json extField = item["extension"];
            if extField is json[] {
                foreach json ext in extField {
                    if ext is map<json> {
                        json extUrl = ext["url"];
                        if extUrl is string && extUrl == url {
                            result.push(ext);
                        }
                    }
                }
            }
            // Also check modifierExtension
            json modExtField = item["modifierExtension"];
            if modExtField is json[] {
                foreach json ext in modExtField {
                    if ext is map<json> {
                        json extUrl = ext["url"];
                        if extUrl is string && extUrl == url {
                            result.push(ext);
                        }
                    }
                }
            }
        }
    }
    return result;
}

# Implements the FHIRPath resolve() function.
# In a pure FHIRPath context without a resolution service this returns empty.
# Implementations that have access to a resource repository should override this.
#
# + collection - The collection of references to resolve
# + params - Function parameters (none expected)
# + return - Resolved resources, or empty if resolution is not available
isolated function applyResolveFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("resolve", "0 parameters", params.length());
    }
    // No resolution service available — return empty
    return [];
}

# Implements the FHIRPath conformsTo() function.
# Without a terminology service, this always returns true as a stub.
#
# + collection - The collection to check
# + params - Function parameters [url expression]
# + context - The current evaluation context
# + env - The evaluation environment
# + return - [true] as a stub (requires terminology service for real validation)
isolated function applyConformsToFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("conformsTo", "1 parameter", params.length());
    }
    json[] urlResult = check evaluate(params[0], context, env);
    if urlResult.length() == 0 {
        return [];
    }
    json urlVal = urlResult[0];
    if urlVal !is string {
        return [];
    }
    string url = urlVal;

    // Only handle HL7 FHIR StructureDefinition URLs for basic conformance check
    string sdPrefix = "http://hl7.org/fhir/StructureDefinition/";
    if !url.startsWith(sdPrefix) {
        return error FHIRPathInterpreterError(string `conformsTo() unsupported profile URL: ${url}`,
            token = {tokenType: IDENTIFIER, lexeme: "conformsTo", literal: (), position: 0});
    }

    string profileResourceType = url.substring(sdPrefix.length());

    foreach json item in collection {
        if item is map<json> {
            json|error rt = item["resourceType"];
            if rt is string && rt == profileResourceType {
                return [true];
            }
        }
    }
    return [false];
}

# Implements the FHIRPath memberOf() function.
# Without a terminology service, this always returns false as a stub.
#
# + collection - The collection to check
# + params - Function parameters [valueset url expression]
# + context - The current evaluation context
# + env - The evaluation environment
# + return - [false] as a stub (requires terminology service for real validation)
isolated function applyMemberOfFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("memberOf", "1 parameter", params.length());
    }
    // Stub: without a terminology service we cannot validate membership
    return [false];
}

# Implements the FHIRPath hasExtension() convenience function.
# Returns true if any item in the collection has an extension with the given URL.
#
# + collection - The collection to check
# + params - Function parameters [url expression]
# + context - The current evaluation context
# + env - The evaluation environment
# + return - Boolean result, or an error
isolated function applyHasExtensionFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    json[] exts = check applyExtensionFunction(collection, params, context, env);
    return [exts.length() > 0];
}
