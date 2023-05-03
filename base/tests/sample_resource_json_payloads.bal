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

json TEST_FHIR_RESOURCE_JSON_PATIENT_01 = {
        "resourceType":"Patient",
        "id":"123344",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/Patient"
            ]
        },
        "identifier":[
            {
                "use":"usual",
                "type":{
                    "coding":[
                        {
                            "system":"http://terminology.hl7.org/CodeSystem/v2-0203",
                            "code":"MR"
                        }
                    ]
                },
                "system":"urn:oid:1.2.36.146.595.217.0.1",
                "value":"12345",
                "period":{
                    "start":"2001-05-06"
                },
                "assigner":{
                    "display":"Acme Healthcare"
                }
            }
        ],
        "active":true,
        "name":[
            {
                "use":"official",
                "family":"Chalmers",
                "given":[
                    "Peter",
                    "James"
                ]
            }
        ],
        "telecom":[
            {
                "system":"phone",
                "value":"(03) 5555 6473",
                "use":"work",
                "rank":1
            }
        ],
        "gender":"male",
        "birthDate":"1974-12-25",
        "deceasedBoolean":false,
        "address":[
            {
                "use":"home",
                "type":"both",
                "text":"534 Erewhon St PeasantVille, Rainbow, Vic  3999",
                "line":[
                    "534 Erewhon St"
                ],
                "city":"PleasantVille",
                "district":"Rainbow",
                "state":"Vic",
                "postalCode":"3999",
                "period":{
                    "start":"1974-12-25"
                }
            }
        ],
        "managingOrganization":{
            "reference":"Organization/1"
        }
    };

json TEST_FHIR_RESOURCE_JSON_INVALID_PATIENT_01 = {
        "resourceType":"Patient",
        "id":"123344",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/Patient"
            ]
        },
        "identifierr":[
            {
                "use":"usual",
                "type":{
                    "coding":[
                        {
                            "system":"http://terminology.hl7.org/CodeSystem/v2-0203",
                            "code":"MR"
                        }
                    ]
                },
                "system":"urn:oid:1.2.36.146.595.217.0.1",
                "value":"12345",
                "period":{
                    "start":"2001-05-06"
                },
                "assigner":{
                    "display":"Acme Healthcare"
                }
            }
        ],
        "active":true,
        "name":[
            {
                "use":"official",
                "family":"Chalmers",
                "given":[
                    "Peter",
                    "James"
                ]
            }
        ],
        "telecom":[
            {
                "system":"phone",
                "value":"(03) 5555 6473",
                "use":"work",
                "rank":1
            }
        ],
        "gender":"male",
        "birthDate":"1974-12-25",
        "deceasedBoolean":false,
        "address":[
            {
                "use":"home",
                "type":"both",
                "text":"534 Erewhon St PeasantVille, Rainbow, Vic  3999",
                "line":[
                    "534 Erewhon St"
                ],
                "city":"PleasantVille",
                "district":"Rainbow",
                "state":"Vic",
                "postalCode":"3999",
                "period":{
                    "start":"1974-12-25"
                }
            }
        ],
        "managingOrganization":{
            "reference":"Organization/1"
        }
    };
