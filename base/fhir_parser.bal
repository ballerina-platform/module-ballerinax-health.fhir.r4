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

# Function to validate against API Config and parse FHIR resource payload.
#
# + payload - FHIR resource payload  
# + apiConfig - APIConfig of the FHIR resource API
# + return - Record representation of the FHIR resource if success.
isolated function validateAndParse(json|xml payload, ResourceAPIConfig apiConfig)
                                                            returns anydata|FHIRValidationError|FHIRParseError? {
    readonly & Profile profile = check validateAndExtractProfile(payload, apiConfig);
    return check parseFHIRResource(profile, payload);
}

# Function to parse FHIR Payload into FHIR Resource model.
# Note : When using inside FHIR templates, use ballerinax/health.fhir.r4.parser module instead of this.
#
# + payload - FHIR payload  
# + targetFHIRModelType - (Optional) target model type to parse. Derived from payload if not given  
# + targetProfile - (Optional) target profile to parse. Derived from payload if not given
# + return - returns FHIR model (Need to cast to relevant type by the caller). FHIRParseError if error ocurred
public isolated function parse(json|xml|string payload, typedesc<anydata>? targetFHIRModelType = (), string? targetProfile = ()) returns anydata|FHIRParseError {
    json|xml _payload;
    if payload is string {
        json|error parsedJsonPayload = payload.fromJsonString();
        if parsedJsonPayload is json {
            _payload = parsedJsonPayload;
        } else {
            xml|error parsedXmlPayload = xml:fromString(payload);
            if parsedXmlPayload is xml {
                _payload = parsedXmlPayload;
            } else {
                return <FHIRParseError>createFHIRError("Failed to parse string payload to json or xml", ERROR, INVALID_STRUCTURE, errorType = PARSE_ERROR);
            }
        }
    } else {
        _payload = payload;
    }

    string|FHIRValidationError resourceType = extractResourceType(_payload);
    if resourceType is FHIRValidationError {
        return <FHIRParseError>createParserErrorFrom(resourceType);
    }
    Profile resourceProfile;
    if targetProfile != () {
        (Profile & readonly)? profile = fhirRegistry.findProfile(targetProfile);
        if profile is (Profile & readonly) {
            resourceProfile = profile.clone();
        } else {
            string msg = string `Failed to find FHIR profile for the resource type : ${resourceType}`;
            return <FHIRParseError>createFHIRError(msg, ERROR, INVALID_STRUCTURE, errorType = PARSE_ERROR);
        }
    } else if targetFHIRModelType != () {
        ResourceDefinitionRecord|FHIRTypeError resourceDefinition = getResourceDefinition(targetFHIRModelType);
        if resourceDefinition is ResourceDefinitionRecord {
            string? profile = resourceDefinition.profile;
            if profile != () {
                map<Profile & readonly> & readonly perResourceProfiles = fhirRegistry.getResourceProfiles(resourceType);
                if perResourceProfiles.hasKey(profile) {
                    resourceProfile = perResourceProfiles.get(profile);
                } else {
                    string msg = string `Failed to find FHIR profile for the resource type : ${resourceType}`;
                    return <FHIRParseError>createFHIRError(msg, ERROR, INVALID_STRUCTURE, errorType = PARSE_ERROR);
                }
            } else {
                string msg = string `Failed to find FHIR profile in the definition of the resource type : ${resourceType}`;
                return <FHIRParseError>createFHIRError(msg, ERROR, INVALID_STRUCTURE, errorType = PARSE_ERROR);
            }
        } else {
            return createParserErrorFrom(resourceDefinition);
        }
    } else {
        string[]? payloadProfiles = extractProfiles(_payload);
        if payloadProfiles != () && payloadProfiles.length() > 0 {
            (Profile & readonly)? profile = fhirRegistry.findProfile(payloadProfiles[0]).clone();
            if profile is (Profile & readonly) {
                resourceProfile = profile.clone();
            } else {
                string msg = "Failed to find FHIR profile for the profile URL : " + payloadProfiles[0];
                return <FHIRParseError>createFHIRError(msg, ERROR, INVALID_STRUCTURE, errorType = PARSE_ERROR);
            }
        } else {
            (Profile & readonly)? profile = fhirRegistry.findBaseProfile(resourceType);
            if profile is (Profile & readonly) {
                resourceProfile = profile.clone();
            } else {
                string msg = "Failed to find FHIR profile for the resource type : " + resourceType;
                return <FHIRParseError>createFHIRError(msg, ERROR, INVALID_STRUCTURE, errorType = PARSE_ERROR);
            }
        }
    }
    return parseFHIRResource(resourceProfile, _payload);
}

isolated function validateAndExtractProfile(json|xml payload, ResourceAPIConfig apiConfig)
                                                                    returns (readonly & Profile)|FHIRValidationError {
    string resourceType = check extractResourceType(payload);
    if !fhirRegistry.isSupportedResource(resourceType) {
        string diag = string `Payload contains unknown resource type : ${resourceType}`;
        return <FHIRValidationError>createFHIRError("Unknown FHIR resource type", ERROR, INVALID, diag,
                                                errorType = VALIDATION_ERROR, httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    if resourceType != apiConfig.resourceType {
        string msg = "Mismatching resource type of the FHIR resource with the resource API";
        string diagMsg = string `Payload resource type :\"${resourceType}\" but expected resource type :\" ${apiConfig.resourceType}\"`;
        return <FHIRValidationError>createFHIRError(msg, ERROR, INVALID, diagMsg,
                                                errorType = VALIDATION_ERROR, httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    string[]? profiles = extractProfiles(payload);
    if profiles != () && profiles.length() > 0 {
        map<Profile & readonly> & readonly resourceProfiles = fhirRegistry.getResourceProfiles(resourceType);
        // validate profiles
        foreach string profile in profiles {
            // check whether the profile is a valid profile
            if !resourceProfiles.hasKey(profile) {
                string diag = string `Unknown profile : ${profile}`;
                return <FHIRValidationError>createFHIRError("Invalid FHIR profile", ERROR, INVALID,
                                diagnostic = diag, errorType = VALIDATION_ERROR, httpStatusCode = http:STATUS_BAD_REQUEST);
            }

            // check whether the profile is supported according to API config
            if apiConfig.profiles.indexOf(profile) is () {
                string diag = string `FHIR server does not this FHIR profile : ${profile}`;
                return <FHIRValidationError>createFHIRError("Unsupported FHIR profile", ERROR, INVALID,
                                diagnostic = diag, errorType = VALIDATION_ERROR, httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }

        if profiles.length() == 1 {
            return fhirRegistry.getResourceProfiles(resourceType).get(profiles[0]);
        } else {
            // If there are multiple profiles, we select the matching default profile if configured
            // otherwise, default profile will be the base profile.
            string? defaultProfile = apiConfig.defaultProfile;
            if defaultProfile != () {
                return resourceProfiles.get(defaultProfile);
            }
        }
    }
    // get base IG profile (we reach here if profile is not mentioned in the request or if the request contains multiple
    // resources with no default profile in API config)
    (Profile & readonly)? profile = fhirRegistry.findBaseProfile(resourceType);
    if profile != () {
        return profile;
    }
    string diag = string `Matching profile not found for the resource type : ${resourceType}`;
    return <FHIRValidationError>createFHIRError("Profile not found", ERROR, PROCESSING,
                                diagnostic = diag, errorType = VALIDATION_ERROR, httpStatusCode = http:STATUS_BAD_REQUEST);

}

isolated function parseFHIRResource(Profile profile, json|xml payload) returns anydata|FHIRParseError {
    if payload is json {
        anydata|error cloneWithType = payload.cloneWithType(profile.modelType);
        if cloneWithType is error {
            return <FHIRParseError>createFHIRError("Failed to parse request body as JSON resource", ERROR, PROCESSING,
                                                    cloneWithType.detail().toString(), cause = cloneWithType, errorType = PARSE_ERROR,
                                                    httpStatusCode = http:STATUS_BAD_REQUEST);
        } else {
            return cloneWithType;
        }
    } else {
        // TODO: parse xml payload [https://github.com/wso2-enterprise/open-healthcare/issues/887]
        return <FHIRParseError>createFHIRError("XML format of FHIR resources not supported yet", ERROR,
                                                PROCESSING_NOT_SUPPORTED, errorType = PARSE_ERROR,
                                                httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }
}

isolated function extractProfiles(json|xml payload) returns string[]? {
    if payload is json {
        json|error profiles = payload?.meta?.profile;
        if profiles is json[] {
            string[] result = [];
            foreach json profile in profiles {
                if profile is string {
                    result.push(profile);
                }
            }
            return result;
        }
    } else {
        // TODO handle XML payload [https://github.com/wso2-enterprise/open-healthcare/issues/887]
    }
    return ();
}

isolated function extractResourceType(json|xml payload) returns string|FHIRValidationError {
    if payload is json {
        map<json> jsonPayload = <map<json>>payload;
        if jsonPayload.hasKey("resourceType") {
            json jResourceType = jsonPayload.get("resourceType");
            if jResourceType is string {
                return jResourceType;
            }
        }

    } else {
        // TODO handle XML payload [https://github.com/wso2-enterprise/open-healthcare/issues/887]
        return <FHIRValidationError>createFHIRError("XML format of FHIR resources not supported yet", ERROR,
                                                PROCESSING_NOT_SUPPORTED, errorType = VALIDATION_ERROR,
                                                httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }
    string message = "Failed to parse request body as JSON resource";
    string diagnostic = "Invalid JSON content detected, missing required element: \"resourceType\"";
    return <FHIRValidationError>createFHIRError(message, ERROR, PROCESSING, diagnostic = diagnostic,
                                errorType = VALIDATION_ERROR);
}
