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
import ballerina/test;
import ballerinax/health.fhir.r4.international401;

RuleBasedPatientMatcher rpm = new RuleBasedPatientMatcher();

MPIDbConfig mpiDbConfig = {
    host: "localhost",
    port: 3306,
    database: "patient_db",
    username: "root",
    password: "0207THEnu$an"
};

RulesRecord rule = {
    fhirpathArray: ["patient.id"]
};

@test:Config {}
public function testForMatch() returns error? {

    ConfigurationRecord config = {
        "fhirpaths": ["Patient.name.given[1]", "Patient.name.family", "Patient.gender", "Patient.birthDate"],
        "masterPatientIndexColumnNames": ["FirstName", "LastName", "gender", "dob"],
        "masterPatientIndexTableName": "patient",
        "masterPatientIndexHost": "localhost",
        "masterPatientIndexPort": 3306,
        "masterPatientIndexDb": "patient_db",
        "masterPatientIndexDbUser": "root",
        "masterPatientIndexDbPassword": "0207THEnu$an"
    };
    json|http:ClientError jsonPayload = getResponse().getJsonPayload();
    if jsonPayload is json {
        error|http:Response matchPatients = rpm.matchPatients(getRequst(), config);
        if matchPatients is http:Response {
            test:assertEquals(matchPatients.getJsonPayload(), <anydata>jsonPayload, msg = "faild");
        }
    }

    MPIDbConfig|error mPIConfigData = rpm.getMPIConfigData(config);

    if mPIConfigData is MPIDbConfig {
        test:assertEquals(mPIConfigData, <anydata>mpiDbConfig, msg = "faild");
    }

    ConfigurationRecord configTestOne = {
        "fhirpaths": ["Patient.name.given[1]", "Patient.name.family", "Patient.gender", "Patient.birthDate"],
        "masterPatientIndexColumnNames": ["FirstName", "LastName", "gender", "dob"],
        "masterPatientIndexHost": "localhost",
        "masterPatientIndexPort": 3306,
        "masterPatientIndexDbUser": "root",
        "masterPatientIndexDbPassword": "0207THEnu$an"
    };
    MPIDbConfig|error mPIConfigTestOne = rpm.getMPIConfigData(configTestOne);

    if mPIConfigTestOne is error {
        test:assertEquals(mPIConfigTestOne.message(), "Error; masterPatientIndexDb can not be null in the config.json file.", msg = "faild");
    }

    ConfigurationRecord configTestTwo = {
        "fhirpaths": ["Patient.name.given[1]", "Patient.name.family", "Patient.gender", "Patient.birthDate"],
        "masterPatientIndexColumnNames": ["FirstName", "LastName", "gender", "dob"],
        "masterPatientIndexTableName": "patient",
        "masterPatientIndexHost": "localhost",
        "masterPatientIndexPort": 3306,
        "masterPatientIndexDb": "patient_db",
        "masterPatientIndexDbPassword": "0207THEnu$an"
    };

    MPIDbConfig|error mPIConfigTestTwo = rpm.getMPIConfigData(configTestTwo);

    if mPIConfigTestTwo is error {
        test:assertEquals(mPIConfigTestTwo.message(), "Error; masterPatientIndexDbUser can not be null in the config.json file.", msg = "faild");
    }

    ConfigurationRecord configTestThree = {
        "MPIColumnNames": ["FirstName", "LastName", "gender", "dob"],
        "masterPatientIndexTableName": "patient",
        "masterPatientIndexHost": "localhost",
        "masterPatientIndexPort": 3306,
        "masterPatientIndexDb": "patient_db",
        "masterPatientIndexDbPassword": "0207THEnu$an"
    };

    RulesRecord|error patientMatcherRuleData = rpm.getPatientMatcherRuleData(configTestThree);

    if patientMatcherRuleData is error {
        test:assertEquals(patientMatcherRuleData.message(), "Error; FHIRPath rules can not be null in the config.json file.", msg = "faild");
    }

    ConfigurationRecord configTestFour = {
        "fhirpaths": ["Patient.name.given[1]", "Patient.name.family", "Patient.gender", "Patient.birthDate"],
        "masterPatientIndexTableName": "patient",
        "masterPatientIndexHost": "localhost",
        "masterPatientIndexPort": 3306,
        "masterPatientIndexDb": "patient_db",
        "masterPatientIndexDbUser": "root",
        "masterPatientIndexDbPassword": "0207THEnu$an"
    };
    error|string sQLQuery = rpm.getSQLQuery(patient, rule, configTestFour);

    if sQLQuery is error {
        test:assertEquals(sQLQuery.message(), "Error; MPIColumnNames can not be null in the config.json file.", msg = "faild");
    }

    ConfigurationRecord configTestFive = {
        "fhirpaths": ["Patient.name.given[1]", "Patient.name.family", "Patient.gender", "Patient.birthDate"],
        "masterPatientIndexColumnNames": ["FirstName", "LastName", "gender", "dob"],
        "masterPatientIndexHost": "localhost",
        "masterPatientIndexPort": 3306,
        "masterPatientIndexDb": "patient_db",
        "masterPatientIndexDbUser": "root",
        "masterPatientIndexDbPassword": "0207THEnu$an"
    };
    error|string sQLQueryTwo = rpm.getSQLQuery(patient, rule, configTestFive);

    if sQLQueryTwo is error {
        test:assertEquals(sQLQueryTwo.message(), "Error; MPITableName can not be null in the config.json file.", msg = "faild");
    }

    ConfigurationRecord configSix = {
        "fhirpaths": ["Patient.name.given[1]", "Patient.name.family", "Patient.gender", "Patient.birthDate"],
        "masterPatientIndexColumnNames": ["FirstName", "LastName", "gender", "dob"],
        "masterPatientIndexTableName": "patient",
        "masterPatientIndexHost": "localhost",
        "masterPatientIndexPort": 3306,
        "masterPatientIndexDb": "patient_db",
        "masterPatientIndexDbUser": "root",
        "masterPatientIndexDbPassword": "0207THEnu$an"
    };
    RulesRecord ruleTwo = {
    fhirpathArray: ["Patient.school"]
};
    error|string sQLQueryThree = rpm.getSQLQuery(patient, ruleTwo, configSix);

    if sQLQueryThree is error {
        test:assertEquals(sQLQueryThree.message(), "No result found for the given FHIRPath expression in the patient: ", msg = "faild");
    }

}

public function getRequst() returns PatientMatchRequestData {
    return {
        "resourceType": "Parameters",
        "id": "example",
        "parameter": [
            {
                "name": "resource",
                "resource": {
                    "resourceType": "Patient",
                    "identifier": [
                        {
                            "use": "official",
                            "type": {
                                "coding": [
                                    {
                                        "system": "http://hl7.org/fhir/v2/0203",
                                        "code": "MR"
                                    }
                                ]
                            },
                            "system": "urn:oid:1.2.36.146.595.217.0.1",
                            "value": "12345"
                        }
                    ],
                    "id": "123",
                    "name": [
                        {
                            "use": "official",
                            "family": "Cox",
                            "given": [
                                "charles",
                                "Brian",
                                "che"

                            ]
                        }
                    ],
                    "gender": "male",
                    "birthDate": "2019-07-18"
                }
            },
            {
                "name": "count",
                "valueInteger": "1"
            },
            {
                "name": "onlyCertainMatches",
                "valueBoolean": "false"
            }
        ]
    };
}

public function getResponse() returns http:Response {
    http:Response response = new;
    json load = {
        "resourceType": "Bundle",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/Bundle"
            ]
        },
        "type": "searchset",
        "timestamp": "[1688100428,0.790215000]",
        "total": 1,
        "entry": [
            {
                "resource": {
                    "gender": "male",
                    "addr_line1": "1088 Abernathy Estate",
                    "FirstName": "Brian",
                    "mobile": "555-164-6702",
                    "addr_postalCode": "02215",
                    "language": "en-US",
                    "SSN": "999-24-4970",
                    "addr_state": "Massachusetts",
                    "insurance_coverage": "Medicaid",
                    "dob": "2019-07-18",
                    "addr_line2": null,
                    "id": 1,
                    "LastName": "Cox",
                    "addr_city": "Brookline",
                    "maritalStatus": "S",
                    "addr_country": "US"
                },
                "search": {
                    "mode": "match",
                    "score": 1.0
                }
            }
        ]
    };
    response.statusCode = 200;
    response.setPayload(load);
    return response;
}

international401:Patient patient = {
    "resourceType": "Patient",
    "identifier": [
        {
            "use": "official",
            "type": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/v2/0203",
                        "code": "MR"
                    }
                ]
            },
            "system": "urn:oid:1.2.36.146.595.217.0.1",
            "value": "12345"
        }
    ],
    "id": "123",
    "name": [
        {
            "use": "official",
            "family": "Cox",
            "given": [
                "charles",
                "Brian",
                "che"

            ]
        }
    ],
    "gender": "male",
    "birthDate": "2019-07-18"
};
