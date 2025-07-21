// Copyright (c) 2023-2025, WSO2 LLC. (http://www.wso2.com).

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

# Client method to access utils package for fhirpath evaluation.
#
# + fhirResource - requested fhir resource
# + fhirPath - fhirpath requested for evaluation
# + return - result of the fhirpath expression
public isolated function getFhirPathResult(json fhirResource, string fhirPath) returns FhirPathResult {
    json|error results = getFhirPathValues(fhirResource, fhirPath);

    if results is error {
        return {
            'error: {
                message: results.message()
            }
        };
    }

    return {result: results};
}

# Update the FHIR resource at the given FHIRPath with the provided value.
#
# + fhirResource - The FHIR resource to update
# + fhirPathExpression - The FHIRPath expression (dot notation)
# + value - The value to set at the path
# + allowPathCreation - Whether to create missing paths (optional, defaults to configurable value)
# + return - The updated FHIR resource or error
public isolated function updateFhirPathValue(json fhirResource, string fhirPathExpression, json value, boolean? allowPathCreation = ()) returns FhirPathResult {
    json|error result = allowPathCreation is boolean ?
        setFhirPathValues(fhirResource, fhirPathExpression, value, allowPathCreation) :
        setFhirPathValues(fhirResource, fhirPathExpression, value);

    if result is error {
        return {
            'error: {
                message: result.message()
            }
        };
    }

    return {result: result};
}

# Client record to hold the results of fhirpath evaluation.
#
# + result - Result of the fhirpath expression
# + error - Error message if the result is an error
public type FhirPathResult record {
    json result?;
    FhirPathErrorRecord 'error?;
};

# Record to hold FhirPath request parameters.
#
# + fhirResource - the FHIR Resource which the FhirPath expression is evaluated against
# + fhirPath - the FhirPath expression
public type FhirPathRequest record {|
    json fhirResource;
    string[]|string fhirPath;
|};

# Record to hold FhirPath error Message.
#
# + message - error message
public type FhirPathErrorRecord record {
    string message;
};
