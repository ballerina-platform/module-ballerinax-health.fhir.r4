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

# FhirPathError is the error object that is returned when an error occurs during the evaluation of a FHIRPath expression.
public type FHIRPathError distinct error;

# Method to create a FHIRPathError
#
# + errorMsg - the reason for the occurence of error
# + fhirPath - the fhirpath expression that is being evaluated
# + return - the error object
public isolated function createFhirPathError(string errorMsg, string? fhirPath) returns error {
    FHIRPathError fhirPathError = error(errorMsg, fhirpath = fhirPath);
    return fhirPathError;
}

# Error type to handle errors in patient matching
public type PatientMatchingError distinct error;

# Method to create a PatientMatchingError
#
# + errorMsg - the reason for the occurence of error
# + return - the error object
public isolated function createPatientMatchingError(string errorMsg) returns error {
    PatientMatchingError patientMatchingError = error(errorMsg);
    return patientMatchingError;
}
