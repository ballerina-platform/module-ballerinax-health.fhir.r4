// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.

// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein is strictly forbidden, unless permitted by WSO2 in accordance with
// the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
// For specific language governing the permissions and limitations under
// this license, please see the license as well as any agreement you’ve
// entered into with WSO2 governing the purchase of this software and any
// associated services.

import ballerinax/health.fhir.r4;
import ballerina/http;
import ballerina/sql;

# Abstract Patient Matcher
public type PatientMatcher distinct object {
    # Abstract Method to match patients
    #
    # + newPatient - new Patient who is being added to the system  
    # + config - Configuration for Patient Matching Algorithm
    # + return - Return Value Description
    public isolated function matchPatients(r4:Patient newPatient, json config) returns error|http:Response;

    # Abstract Method to verify patients
    #
    # + sourcePatient - new Patient who is being added to the system  
    # + targetPatient - old Patient who is already in the system  
    # + config - Configuration for Patient Matching Algorithm
    # + return - return true if the two patients are matched, false otherwise
    public isolated function verifyPatient(r4:Patient sourcePatient, r4:Patient targetPatient, json config) returns error|http:Response;

    # Abstract Method to get MPI DB Client
    #
    # + config - Configuration for Patient Matching Algorithm
    # + return - return MPI DB Client
    public isolated function getMpiDbClient(json config) returns sql:Client|error;

};

# Record to store matching result
#
# + newPatient - new Patient who is being added to the system
# + matchedPatient - Matched Patient 
# + ismatch - flag to indicate whether the two patients are matched 
public type MatchingResult record {
    r4:Patient newPatient;
    r4:Patient?|record {}? matchedPatient;
    boolean ismatch;
};

# Method to get Patient Matching Configuration
#
# + fileContend - Parameter Description
# + return - PatientMatcher Object or error
public isolated function getPatientMatcher(json fileContend) returns PatientMatcher|error {
    json|error algorithm = fileContend.algorithm;
    if algorithm is "rulebased" {
        return new RuleBasedPatientMatching();
    } else {
        return createPatientMatchingError("Could not find the type of the matching algorithm in the configuration file");
    }
}
