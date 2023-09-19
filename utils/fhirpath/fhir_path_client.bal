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

# Client method to access utils package for fhirpath evaluation.
#
# + fhirResource - requested fhir resource
# + fhirPath - fhirpath requested for evaluvation
# + return - result of the fhirpath expression
public isolated function getFhirPathResult(json fhirResource, string fhirPath) returns FhirPathResult {

    string|json|int|float|boolean|byte|error results = evaluateFhirPath(fhirResource, fhirPath);

    if results is error {
        FhirPathResult result = {
            resultenError: results.message()
        };
        return result;
    } else {
        FhirPathResult result = {
            result: results
        };
        return result;
    }
}

# Client record to hold the results of fhirpath evaluation.
#
# + result - Result of the fhirpath expression  
# + resultenError - Error message if the result is an error  
public type FhirPathResult record {
    string|json|int|float|boolean|byte result?;
    string resultenError?;
};
