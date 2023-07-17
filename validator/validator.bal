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

import ballerina/constraint;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.parser;

# This method will validate FHIR resource.
# Validation consist of Structure, cardinality, Value domain, Profile, json.
#
# + data - FHIR resource (can be in json or anydata)
# + targetFHIRModelType - (Optional) target model type to validate. Derived from payload if not given
# + return - If the validation fails, return validation error
public isolated function validate(json|anydata data, typedesc<anydata>? targetFHIRModelType = ()) returns r4:FHIRValidationError? {

    anydata finalData;

    if data is json {
        anydata|r4:FHIRParseError parsedResult = parser:parse(data, targetFHIRModelType);

        if parsedResult is r4:FHIRParseError {
            return <r4:FHIRValidationError>r4:createFHIRError("FHIR resource validation failed", r4:ERROR, r4:INVALID, parsedResult.message(),
                                                errorType = r4:VALIDATION_ERROR, cause = parsedResult);
        } else {
            finalData = parsedResult;
        }
    } else {
        finalData = data;
    }

    // Get the types of the FHIR resources, it can be international or any specific FHIR profiles like Uscore
    typedesc<anydata> typeDescOfData = typeof finalData;

    anydata|constraint:Error validationResult = constraint:validate(finalData, typeDescOfData);

    if validationResult is constraint:Error {
        return <r4:FHIRValidationError>r4:createFHIRError("FHIR resource validation failed",r4:ERROR, r4:INVALID, validationResult.message(),
                                                errorType = r4:VALIDATION_ERROR, cause = validationResult);
    }

}

# This method will validate parsed FHIR resource.
# Validation consist of Structure, cardinality, Value domain, Profile.
# This is only for internal use.
#
# + data - parsed FHIR resource
# + return - If the validation fails, return validation error
isolated function validateFhirResource(anydata data) returns r4:FHIRValidationError? {
    return validate(data);
}
