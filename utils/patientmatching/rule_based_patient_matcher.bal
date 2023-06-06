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
import ballerina/sql;
import ballerina/time;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4utils as fhirpath;
import ballerinax/mysql;

const SEARCH_SET = "searchset";
const RESULT = "result";

# Record to hold fhirpath rules.
public type RulesRecord record {|
    # array of fhirpath rules
    string[] fhirpathArray;
|};

# Record to hold MPI database configuration details.
public type MPIDbConfig record {|
    # host name of MPI database
    string host;
    # port of MPI database
    int port;
    # username of MPI database
    string username;
    # password of MPI database
    string password;
    # database name of MPI database
    string database;
|};

# Implementation of the RuleBasedPatientMatching Algorithm.
public isolated class RuleBasedPatientMatcher {
    *PatientMatcher;

    public isolated function matchPatients(PatientMatchRequest patientMatchRequest, ConfigurationRecord? config) returns error|http:Response {
        json[] parametersArray = patientMatchRequest.'parameter;
        r4:Patient|error sourcePatient = (check parametersArray[0].'resource).cloneWithType();
        string|error strPatientCount = (check parametersArray[1].valueInteger).cloneWithType();
        string|error strOnlyCertainMatches = (check parametersArray[2].valueBoolean).cloneWithType();
        if sourcePatient is error {
            return throwFHIRError("Error occurred while getting the source patient from the request.", cause = sourcePatient);
        }
        if strPatientCount is error {
            return throwFHIRError("Error occurred while getting the expected patient count from the request." , cause = strPatientCount);
        }
        if strOnlyCertainMatches is error {
            return throwFHIRError("Error occurred while getting the OnlyCertainMatches boolean flag from the request.",cause = strOnlyCertainMatches);
        }

        int|error patientCount = int:fromString(strPatientCount);
        boolean|error onlyCertainMatches = boolean:fromString(strOnlyCertainMatches);
        if patientCount is error {
            return throwFHIRError("Error occurred while casting the patient count string to integer." ,cause = patientCount);
        }
        if onlyCertainMatches is error {
            return throwFHIRError("Error occurred while casting the onlyCertainMatches flag from string to boolean.",cause = onlyCertainMatches);
        }

        r4:BundleEntry[]|error? patientArray = self.getMatchingPatients(<r4:Patient>sourcePatient, config ?: {});
        if patientArray is () {
            http:Response response = new;
            response.setJsonPayload("No matching patient found");
            return response;
        }
        if patientArray is error {
            return throwFHIRError("Error occurred while getting the matching patients from MPI.", cause = patientArray);
        }
        http:Response response = new;
        if onlyCertainMatches is true && patientArray.length() > 1 {
            response.setJsonPayload("Multiple matching patients found while onlyCertainMatches flag is true");
        }
        if patientArray.length() < patientCount {
            r4:Bundle bundle = {
                'type: SEARCH_SET,
                total: patientArray.length(),
                'entry: patientArray,
                timestamp: time:utcNow().toString()
            };
            response.setJsonPayload(bundle.toJson());
        } else {
            patientArray.setLength(patientCount);
            r4:Bundle bundle = {
                'type: SEARCH_SET,
                total: patientArray.length(),
                'entry: patientArray,
                timestamp: time:utcNow().toString()
            };
            response.setJsonPayload(bundle.toJson());
        }
        return response;
    }

    isolated function getMpiDbClient(ConfigurationRecord config) returns sql:Client|error {
        MPIDbConfig|error dbConfig = self.getMPIConfigData(config);
        if dbConfig is error {
            return throwFHIRError("Error occurred while getting the configurations details for the database client from config.json file.",cause = dbConfig);
        }
        mysql:Client dbClient = check new (dbConfig.host, dbConfig.username, dbConfig.password, dbConfig.database, dbConfig.port);
        return dbClient;
    }

    isolated function getMatchingPatients(r4:Patient patient, ConfigurationRecord config) returns error|r4:BundleEntry[] {
        stream<record {}, sql:Error?>|error dbPatientStream = self.getMPIData(patient, check self.getPatientMatcherRuleData(config), config);
        if dbPatientStream is error {
            return throwFHIRError("Error occurred while getting the matching patients from MPI.",cause = dbPatientStream);
        }
        r4:BundleEntry[] patients = [];
        map<anydata>[]|sql:Error patientArray = from record {} patientRecords in dbPatientStream
            select patientRecords;
        if patientArray is sql:Error {
            return throwFHIRError("Error occurred while getting the matching patients from MPI.",cause = patientArray);
        }
        r4:BundleEntrySearch bundleEntrySearch = {
            mode: "match",
            score: 1.0
        };
        foreach int i in 0 ... patientArray.length()-1 {
            r4:BundleEntry bundleEntry = {
                'resource: patientArray[i],
                search: bundleEntrySearch
            };
            patients.push(bundleEntry);
        }
        return patients;
    }

    isolated function getMPIData(r4:Patient patient, RulesRecord rulesTable, ConfigurationRecord config) returns stream<record {}, sql:Error?>|error {
        sql:Client|error dbClient = self.getMpiDbClient(config);
        if dbClient is error {
            return throwFHIRError("Error occurred while getting the database client to access MPI.", cause = dbClient);
        }
        error|string qry = self.getSQLQuery(patient, rulesTable, config);
        if qry is error {
            return throwFHIRError("Error occurred while generating SQL query.", cause = qry);
        }
        sql:ParameterizedQuery queryString = ``;
        queryString.strings = [qry];
        stream<record {}, sql:Error?> resultStream = dbClient->query(queryString);
        return resultStream;
    }

    isolated function getMPIConfigData(ConfigurationRecord config) returns MPIDbConfig|error {
        json|error masterPatientIndexHost = config?.masterPatientIndexHost;
        json|error masterPatientIndexPort = config?.masterPatientIndexPort;
        json|error masterPatientIndexDb = config?.masterPatientIndexDb;
        json|error masterPatientIndexDbUser = config?.masterPatientIndexDbUser;
        json|error masterPatientIndexDbPassword = config?.masterPatientIndexDbPassword;
        if masterPatientIndexHost is error {
            return throwFHIRError("Error occurred while getting the masterPatientIndexHost from the config.json file.", cause = masterPatientIndexHost);
        }
        if masterPatientIndexPort is error {
            return throwFHIRError("Error occurred while getting the masterPatientIndexPort from the config.json file.", cause = masterPatientIndexPort);
        }
        if masterPatientIndexDb is error {
            return throwFHIRError("Error occurred while getting the masterPatientIndexDb from the config.json file.",cause = masterPatientIndexDb);
        }
        if masterPatientIndexDbUser is error {
            return throwFHIRError("Error occurred while getting the masterPatientIndexDbUser from the config.json file.",cause = masterPatientIndexDbUser);
        }
        if masterPatientIndexDbPassword is error {
            return throwFHIRError("Error occurred while getting the masterPatientIndexDbPassword from the config.json file.", cause = masterPatientIndexDbPassword);
        }
        MPIDbConfig mpiDbConfig = {
            host: <string>masterPatientIndexHost,
            port: <int>masterPatientIndexPort,
            database: <string>masterPatientIndexDb,
            username: <string>masterPatientIndexDbUser,
            password: <string>masterPatientIndexDbPassword
        };
        return mpiDbConfig;
    }

    isolated function getSQLQuery(r4:Patient patient, RulesRecord rulesTable, ConfigurationRecord config) returns (error|string) {
        json|error MPIColumnNames = config?.masterPatientIndexColumnNames;
        json|error MPITableName = config?.masterPatientIndexTableName;
        if MPIColumnNames is error {
            return throwFHIRError("Error occurred while getting the MPIColumnNames from the config.json file.", cause = MPIColumnNames);
        }
        if MPITableName is error {
            return throwFHIRError("Error occurred while getting the MPITableName from the config.json file.", cause = MPITableName);
        }
        json[] parameters = <json[]>MPIColumnNames;
        string tableName = <string>MPITableName;
        string query = string `SELECT * FROM  ${tableName} WHERE `;
        int lastIndex = parameters.length() - 1;
        foreach int i in 0 ... parameters.length() {
            string fhirPathRule = rulesTable.fhirpathArray[i];
            fhirpath:FhirPathResult fhirPathResult = fhirpath:getFhirPathResult(<map<json>>patient.toJson(), fhirPathRule);
            if i == lastIndex {
                string fhirPathRuleLastIndex = rulesTable.fhirpathArray[i];
                map<anydata> resultMapLastIndex = fhirpath:getFhirPathResult(<map<json>>patient.toJson(), fhirPathRuleLastIndex);
                if resultMapLastIndex.hasKey(RESULT) {
                    json resultValue = <json>fhirPathResult.get(RESULT);
                    if resultValue is json[] {
                        resultValue = resultValue[0];
                    }
                    string queryParam = string `${"\""}${resultValue.toString()}${"\""}`;
                    query = string `${query} ${parameters[i].toString()} = ${queryParam}`;
                    break;
                } else {
                    return fhirpath:createFhirPathError("No result found for the given FHIRPath expression in the patient: ", fhirPathRuleLastIndex);
                }
            }
            if fhirPathResult.hasKey(RESULT) {
                json resultPath = <json>fhirPathResult.get(RESULT);
                if resultPath is json[] {
                    resultPath = resultPath[0];
                }
                string queryParam = string `${"\""}${resultPath.toString()}${"\""}`;
                query = string `${query} ${parameters[i].toString()} = ${queryParam} AND `;
            } else {
                return fhirpath:createFhirPathError("No result found for the given FHIRPath expression in the patient: ", fhirPathRule);
            }
        }
        return query;
    }

    isolated function getPatientMatcherRuleData(ConfigurationRecord config) returns RulesRecord|error {
        json|error fhirpaths = config?.fhirpaths;
        if fhirpaths is error {
            return throwFHIRError("Error occurred while getting the FHIRPath rules from the config.json file." ,cause = fhirpaths);
        }
        return {fhirpathArray: from json path in <json[]>fhirpaths select path.toString()};
    }
};

isolated function throwFHIRError(string message, error cause) returns r4:FHIRError => r4:createFHIRError(message = message, errServerity = r4:ERROR,
                        code = r4:TRANSIENT_EXCEPTION, diagnostic = cause.detail().toString(), cause = cause, httpStatusCode = http:STATUS_BAD_REQUEST);

# Record to hold the patient match request.
public type PatientMatchRequest record {
    # resource type name
    string resourceType;
    # resource Id
    string id;
    # parameter resource in fhir specification
    json[] 'parameter;
};

# Record to hold the configuration details for the rule based patient matching algorithm.
public type ConfigurationRecord record {
    # fhirpaths to be used in the patient matching algorithm 
    json fhirpaths?;
    # column names of the MPI table
    json masterPatientIndexColumnNames?;
    # MPI table name
    string masterPatientIndexTableName?;
    # MPI DB host
    string masterPatientIndexHost?;
    # MPI DB port
    int masterPatientIndexPort?;
    # MPI DB name
    string masterPatientIndexDb?;
    # MPI DB username
    string masterPatientIndexDbUser?;
    # MPI DB password for the username
    string masterPatientIndexDbPassword?;
};
