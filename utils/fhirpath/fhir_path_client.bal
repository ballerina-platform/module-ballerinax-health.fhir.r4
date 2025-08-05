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

# Retrieve the value(s) of a given FHIR path from the JSON resource.
#
# + fhirResource - The JSON FHIR resource to query
# + fhirPathExpression - The FHIR path expression to evaluate
# + validateFHIRResource - Whether to validate the FHIR resource
# + return - The retrieved value(s) or an error
public isolated function getFhirPathValues(json fhirResource, string fhirPathExpression, boolean validateFHIRResource = fhirResourceValidation) returns json|FHIRPathError {

    // Retrieve values using the FHIR path expression
    return retrieveFhirPathValues(fhirResource, fhirPathExpression, validateFHIRResource);
}

# Change the value(s) of matching FHIR paths in the JSON resource using a given value.
#
# + fhirResource - The JSON FHIR resource to update
# + fhirPathExpression - The FHIR path (dot notation, e.g., "Patient.name[0].family")
# + newValue - The value to set at the path, or () to remove the path
# + allowPathCreation - Whether to create missing paths (defaults to configurable value)
# + validateFHIRResource - parameter description
# + return - The updated JSON resource or error
public isolated function setFhirPathValuesWithNewValue(json fhirResource, string fhirPathExpression, json newValue,
        boolean allowPathCreation = createMissingPaths, boolean validateFHIRResource = fhirResourceValidation) returns json|FHIRPathError {
    return setFhirPathValues(fhirResource, fhirPathExpression, newValue, allowPathCreation = allowPathCreation, validateFHIRResource = validateFHIRResource);
}

# Set the value(s) of matching FHIR paths in the JSON resource using a given function.
#
# + fhirResource - The JSON FHIR resource to update
# + fhirPathExpression - The FHIR path (dot notation, e.g., "Patient.name[0].family")
# + validateFHIRResource - parameter description
# + modificationFunction - Function to modify the value at the path (ex: pass a hash function to hash the value)
# + return - The updated JSON resource or error
public isolated function setFhirPathValuesWithFunction(json fhirResource, string fhirPathExpression, ModificationFunction modificationFunction,
        boolean validateFHIRResource = fhirResourceValidation) returns json|FHIRPathError {
    return setFhirPathValues(fhirResource, fhirPathExpression, modificationFunction = modificationFunction, allowPathCreation = false, validateFHIRResource = validateFHIRResource);
}
