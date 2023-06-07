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
import ballerinax/mysql;
import ballerina/sql;
import ballerina/http;

const RESULT = "result";

# Record to hold Fhirpath rules
#
# + fhirpathArray - array of Fhirpath rules
public type RulesRecord record {
    string[] fhirpathArray;
};

# Record to hold MPI database configuration details
#
# + host - host name of MPI database 
# + username - username of MPI database  
# + password - password of MPI database 
# + database - database name of MPI database  
# + port - port of MPI database
public type MPIDbConfig record {
    string host;
    int port;
    string username;
    string password;
    string database;
};

# Implementation of the RuleBasedPatientMatching Algorithm
public class RuleBasedPatientMatching {
    *PatientMatcher;

    public isolated function verifyPatient(r4:Patient sourcePatient, r4:Patient targetPatient, json config) returns error|http:Response {

        RulesRecord|error rulesRecord = self.getPatientMatcherRuleData(config);
        http:Response response = new;

        if rulesRecord is error {
            return createPatientMatchingError("Error in getting rules from patientMatcherConfig.json file");
        }

        int score = 0;
        foreach string fhirpathRule in rulesRecord.fhirpathArray {
            string fhirPathRule = fhirpathRule;
            FhirPathResult resultMapPatientOne = getFhirPathResult(<map<json>>sourcePatient.toJson(), fhirPathRule);
            FhirPathResult resultMapPatientTwo = getFhirPathResult(<map<json>>targetPatient.toJson(), fhirPathRule);
            if resultMapPatientOne.hasKey(RESULT) && resultMapPatientTwo.hasKey(RESULT) {
                if resultMapPatientOne.get(RESULT) is string && resultMapPatientTwo.get(RESULT) is string {
                    string str1 = <string>resultMapPatientOne.get(RESULT);
                    string str2 = <string>resultMapPatientTwo.get(RESULT);
                    if str1.equalsIgnoreCaseAscii(str2) {
                        score = score + 1;
                    } else {
                        response.setJsonPayload(false);
                        response.statusCode = 200;
                        break;
                    }

                } else {
                    if resultMapPatientOne.get(RESULT) == resultMapPatientTwo.get(RESULT) {
                        score = score + 1;
                    } else {
                        response.setJsonPayload(false);
                        response.statusCode = 200;
                        break;
                    }
                }

            } else {
                return createFhirPathError("No result found for the given FHIRPath expression in one of the patient: ", fhirPathRule);
            }
        }

        if <int>score == rulesRecord.fhirpathArray.length() {
            response.setJsonPayload(true);
            response.statusCode = 200;
        }

        return response;

    }

    public isolated function matchPatients(r4:Patient newPatient, json config) returns error|http:Response {
        record {}|error|() patient = self.getMatchingPatients(newPatient, config);
        if patient is () {
            http:Response response = new;
            response.setJsonPayload("No matching patient found");
            response.statusCode = 200;
            return response;
        }
        if patient is error {
            return createPatientMatchingError("Error in getting patients from the master patient index database");
        } else {
            http:Response response = new;
            map<anydata> mapResult = <map<anydata>>patient.get("value");
            response.setJsonPayload(mapResult.toJson());
            response.statusCode = 200;
            return response;

        }
    }

    public isolated function getMpiDbClient(json config) returns sql:Client|error {

        MPIDbConfig|error dbConfig = self.getMPIConfigData(config);
        if dbConfig is error {
            return createPatientMatchingError("Error in getting database configuration details from patientMatcherConfig.json file");
        }
        mysql:Client dbClient = check new (dbConfig.host, dbConfig.username, dbConfig.password, dbConfig.database, dbConfig.port);
        return dbClient;

    }

    isolated function getMatchingPatients(r4:Patient patient, json config) returns record {}|error|() {
        stream<record {}, sql:Error?>|error dbPatientStream = self.getMPIData(patient, check self.getPatientMatcherRuleData(config), config);
        if dbPatientStream is error {
            return createPatientMatchingError("Error in getting patient details stream from the master patient index database");

        }
        while (true) {
            record {}|()|sql:Error? nextRawInDb = dbPatientStream.next();
            if nextRawInDb is () {
                return ();
            }
            if nextRawInDb is record {} {
                return nextRawInDb;
            } else {
                return createPatientMatchingError(nextRawInDb.message());
            }
        }
    }

    isolated function getMPIData(r4:Patient patient, RulesRecord rulesTable, json config) returns stream<record {}, sql:Error?>|error {

        sql:Client|error dbClient = self.getMpiDbClient(config);

        if dbClient is error {
            return createPatientMatchingError("Error in getting database client");
        }
        error|string qry = self.getSQLQuery(patient, rulesTable, config);
        if qry is error {
            return createPatientMatchingError("Error in getting SQL query from patientMatcherConfig.json file");
        }
        sql:ParameterizedQuery queryString = ``;
        queryString.strings = [qry];
        stream<record {}, sql:Error?> resultStream = dbClient->query(queryString);
        return resultStream;
    }

    isolated function getMPIConfigData(json config) returns MPIDbConfig|error {

        json|error masterPatientIndexHost = config.rulebased.masterPatientIndexHost;
        json|error masterPatientIndexPort = config.rulebased.masterPatientIndexPort;
        json|error masterPatientIndexDb = config.rulebased.masterPatientIndexDb;
        json|error masterPatientIndexDbUser = config.rulebased.masterPatientIndexDbUser;
        json|error masterPatientIndexDbPassword = config.rulebased.masterPatientIndexDbPassword;

        if masterPatientIndexHost is error || masterPatientIndexPort is error || masterPatientIndexDb is error
            || masterPatientIndexDbUser is error || masterPatientIndexDbPassword is error {
            return createPatientMatchingError("Configuration error in setting up Master Patient Index Database configurations");
        } else {
            MPIDbConfig mpiDbConfig = {
                host: <string>masterPatientIndexHost,
                port: <int>masterPatientIndexPort,
                database: <string>masterPatientIndexDb,
                username: <string>masterPatientIndexDbUser,
                password: <string>masterPatientIndexDbPassword
            };
            return mpiDbConfig;
        }

    }

    isolated function getSQLQuery(r4:Patient patient, RulesRecord rulesTable, json config) returns (error|string) {

        json|error MPIColumnNames = config.rulebased.MPIColumnNames;
        json|error MPITableName = config.rulebased.MPITableName;

        if MPIColumnNames is error || MPITableName is error {
            return createPatientMatchingError("Configiration error in reading MPI Column Names and Table Name from the patientMatcherConfig.json file");
        } else {
            json[] parameters = <json[]>MPIColumnNames;
            string tableName = <string>MPITableName;
            string query = "SELECT * FROM " + tableName + " WHERE ";
            int lastIndex = parameters.length() - 1;

            foreach int i in 0 ... parameters.length() {
                string fhirPathRule = rulesTable.fhirpathArray[i];
                FhirPathResult fhirPathResult = getFhirPathResult(<map<json>>patient.toJson(), fhirPathRule);
                if i == lastIndex {
                    string fhirPathRuleLastIndex = rulesTable.fhirpathArray[i];
                    map<anydata> resultMapLastIndex = getFhirPathResult(<map<json>>patient.toJson(), fhirPathRuleLastIndex);
                    if resultMapLastIndex.hasKey(RESULT) {
                        string|json|int|float|boolean|byte resultValue = <string|json|int|float|boolean|byte>fhirPathResult.get(RESULT);
                        if fhirPathResult.get(RESULT) is json[] {
                            json[] resultJson = <json[]>fhirPathResult.get(RESULT);
                            json resultFirstElement = resultJson[0];
                            string queryParam = "\"" + resultFirstElement.toString() + "\"";
                            query = query + parameters[i].toString() + " = " + queryParam;
                        } else {
                            string queryParam = "\"" + resultValue.toString() + "\"";
                            query = query + parameters[i].toString() + " = " + queryParam;
                        }
                        break;
                    } else {
                        return createFhirPathError("No result found for the given FHIRPath expression in the patient: ", fhirPathRuleLastIndex);
                    }
                }

                if fhirPathResult.hasKey(RESULT) {
                    string|json[]|int|float|boolean|byte resultPath = <string|json[]|int|float|boolean|byte>fhirPathResult.get(RESULT);
                    if fhirPathResult.get(RESULT) is json[] {
                        json[] resultJson = <json[]>fhirPathResult.get(RESULT);
                        json resultFirstElement = resultJson[0];
                        string queryParam = "\"" + resultFirstElement.toString() + "\"";
                        query = query + parameters[i].toString() + " = " + queryParam + " AND ";
                    } else {
                        string queryParam = "\"" + resultPath.toString() + "\"";
                        query = query + parameters[i].toString() + " = " + queryParam + " AND ";
                    }

                } else {
                    return createFhirPathError("No result found for the given FHIRPath expression in the patient: ", fhirPathRule);
                }
            }
            return query;
        }

    }

    isolated function getPatientMatcherRuleData(json config) returns RulesRecord|error {
        json|error fhirpaths = config.rulebased.fhirpaths;

        if fhirpaths is error {
            return createPatientMatchingError("Configuration error in reading fhirpaths from patientMatcherConfig.json file");
        } else {
            string[] paths = [];
            json[] intermediateArray = <json[]>fhirpaths;
            foreach var path in intermediateArray {
                paths.push(path.toString());
            }
            RulesRecord rulesRecord = {
                fhirpathArray: paths
            };
            return rulesRecord;
        }
    }

};
