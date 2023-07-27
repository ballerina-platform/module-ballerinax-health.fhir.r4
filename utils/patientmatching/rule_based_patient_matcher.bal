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
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4utils.fhirpath;
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

    public isolated function matchPatients(PatientMatchRequestData patientMatchRequestData, ConfigurationRecord? config) returns error|http:Response {
        json[] parametersArray = patientMatchRequestData.'parameter;
        international401:Patient|error sourcePatient = (check parametersArray[0].'resource).cloneWithType();
        if sourcePatient is error {
            return throwFHIRError("Error occurred while getting the source patient from the request.", cause = sourcePatient);
        }
        string|error strPatientCount = (check parametersArray[1].valueInteger).cloneWithType();
        if strPatientCount is error {
            return throwFHIRError("Error occurred while getting the expected patient count from the request.", cause = strPatientCount);
        }
        string|error strOnlyCertainMatches = (check parametersArray[2].valueBoolean).cloneWithType();
        if strOnlyCertainMatches is error {
            return throwFHIRError("Error occurred while getting the OnlyCertainMatches boolean flag from the request.", cause = strOnlyCertainMatches);
        }
        int|error patientCount = int:fromString(strPatientCount);
        if patientCount is error {
            return throwFHIRError("Error occurred while casting the patient count string to integer.", cause = patientCount);
        }
        boolean|error onlyCertainMatches = boolean:fromString(strOnlyCertainMatches);
        if onlyCertainMatches is error {
            return throwFHIRError("Error occurred while casting the onlyCertainMatches flag from string to boolean.", cause = onlyCertainMatches);
        }
        r4:BundleEntry[]|error? patientArray = self.getMatchingPatients(<international401:Patient>sourcePatient, config ?: {});
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
        if patientArray.length() >= patientCount {
            patientArray.setLength(patientCount);
        }
        r4:Bundle bundle = {
            'type: SEARCH_SET,
            total: patientArray.length(),
            entry: patientArray,
            timestamp: time:utcNow().toString()
        };
        response.setJsonPayload(bundle.toJson());
        return response;
    }

    isolated function getMpiDbClient(ConfigurationRecord config) returns sql:Client|error {
        MPIDbConfig|error dbConfig = self.getMPIConfigData(config);
        if dbConfig is error {
            return throwFHIRError("Error occurred while getting the configurations details for the database client from config.json file.", cause = dbConfig);
        }
        mysql:Client dbClient = check new (dbConfig.host, dbConfig.username, dbConfig.password, dbConfig.database, dbConfig.port);
        return dbClient;
    }

    isolated function getMatchingPatients(international401:Patient patient, ConfigurationRecord config) returns error|r4:BundleEntry[] {
        stream<map<anydata>, sql:Error?>|error dbPatientStream = self.getMPIData(patient, check self.getPatientMatcherRuleData(config), config);
        if dbPatientStream is error {
            return throwFHIRError("Error occurred while getting the matching patients from MPI.", cause = dbPatientStream);
        }
        map<anydata>[]|sql:Error patientArray = from map<anydata> patientRecords in dbPatientStream
            select patientRecords;
        if patientArray is sql:Error {
            return throwFHIRError("Error occurred while getting the matching patients from MPI.", cause = patientArray);
        }
        r4:BundleEntrySearch search = {
            mode: "match",
            score: 1.0
        };
        return from var 'resource in patientArray select {'resource, search};
    }

    isolated function getMPIData(international401:Patient patient, RulesRecord rulesTable, ConfigurationRecord config) returns stream<map<anydata>, sql:Error?>|error {
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
        string? host = config?.masterPatientIndexHost;
        if host is () {
            return throwFHIRError("Error; masterPatientIndexHost can not be null in the config.json file.", cause = host);
        }
        int? port = config?.masterPatientIndexPort;
        if port is () {
            return throwFHIRError("Error; masterPatientIndexPort can not be null in the config.json file.", cause = port);
        }
        string? database = config?.masterPatientIndexDb;
        if database is () {
            return throwFHIRError("Error; masterPatientIndexDb can not be null in the config.json file.", cause = database);
        }
        string? username = config?.masterPatientIndexDbUser;
        if username is () {
            return throwFHIRError("Error; masterPatientIndexDbUser can not be null in the config.json file.", cause = username);
        }
        string? password = config?.masterPatientIndexDbPassword;
        if password is () {
            return throwFHIRError("Error; masterPatientIndexDbPassword can not be null in the config.json file.", cause = password);
        }
        return {host, port, database, username, password};
    }

    isolated function getSQLQuery(international401:Patient patient, RulesRecord rulesTable, ConfigurationRecord config) returns (error|string) {
        string[]? MPIColumnNames = config?.masterPatientIndexColumnNames;
        if MPIColumnNames is () {
            return throwFHIRError("Error; MPIColumnNames can not be null in the config.json file.", cause = MPIColumnNames);
        }
        string? MPITableName = config?.masterPatientIndexTableName;
        if MPITableName is () {
            return throwFHIRError("Error; MPITableName can not be null in the config.json file.", cause = MPITableName);
        }
        string tableName = <string>MPITableName;
        string query = string `SELECT * FROM  ${tableName} WHERE `;
        json[] parameters = <json[]>MPIColumnNames;
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
        string[]? fhirpaths = config?.fhirpaths;
        if fhirpaths is () {
            return throwFHIRError("Error; FHIRPath rules can not be null in the config.json file.", cause = fhirpaths);
        }
        return {fhirpathArray: from json path in <json[]>fhirpaths select path.toString()};
    }
};

isolated function throwFHIRError(string message, error? cause) returns r4:FHIRError {
    if cause is error {
        return r4:createFHIRError(message = message, errServerity = r4:ERROR,
                        code = r4:TRANSIENT_EXCEPTION, diagnostic = cause.detail().toString(), cause = cause, httpStatusCode = http:STATUS_BAD_REQUEST);
    }
    return r4:createFHIRError(message = message, errServerity = r4:ERROR,
                        code = r4:TRANSIENT_EXCEPTION, httpStatusCode = http:STATUS_BAD_REQUEST);
}

# Record to hold the patient match request.
public type PatientMatchRequestData record {
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
    string[] fhirpaths?;
    # column names of the MPI table
    string[] masterPatientIndexColumnNames?;
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
