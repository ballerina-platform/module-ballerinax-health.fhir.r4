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
const RESULT = "result";

# Client method to access utils package for fhirpath evaluation.
#
# + fhirResource - requested fhir resource
# + fhirPath - fhirpath requested for evaluvation
# + return - result of the fhirpath expression
public isolated function getFhirPathResult(map<json> fhirResource, string fhirPath) returns FhirPathResult {

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

public isolated function compareResources(ResourceCompareRequestData resourceCompareRequestData) returns error|http:Response {
    http:Response response = new;
    int score = 0;
    foreach string fhirPathRule in resourceCompareRequestData.fhirPaths {
        FhirPathResult resultMapSourceResource = getFhirPathResult(<map<json>>resourceCompareRequestData.sourceResource.toJson(), fhirPathRule);
        FhirPathResult resultMapTargetResource = getFhirPathResult(<map<json>>resourceCompareRequestData.targetResource.toJson(), fhirPathRule);
        if !(resultMapSourceResource?.result is () || resultMapTargetResource?.result is ()) {
            return error("No result found for the given FHIRPath expression in one of the resources");
        }
        if resultMapSourceResource.get(RESULT) is string && resultMapTargetResource.get(RESULT) is string {
            string strResultSourceResource = <string>resultMapSourceResource.get(RESULT);
            string strResultTargetResource = <string>resultMapTargetResource.get(RESULT);
            if strResultSourceResource.equalsIgnoreCaseAscii(strResultTargetResource) {
                score = score + 1;
            } else {
                response.setJsonPayload(false);
                break;
            }
        } else {
            if resultMapSourceResource.get(RESULT) == resultMapTargetResource.get(RESULT) {
                score = score + 1;
            } else {
                response.setJsonPayload(false);
                break;
            }
        }

    }
    if score == resourceCompareRequestData.fhirPaths.length() {
        response.setJsonPayload(true);
    }
    return response;
}

# Record to hold the resource details to be compared.
public type ResourceCompareRequestData record {|
    # Resource to be Comapred 
    map<json> sourceResource;
    # Resource to be Comapred against  
    map<json> targetResource;
    # Rules to be applied for the comparison 
    string[] fhirPaths;
|};
