// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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

function getQuestionnaireResource() returns json {
    return {
    "resourceType": "Questionnaire",
    "id": "3141",
    "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n      <pre>\n            1.Comorbidity?\n              1.1 Cardial Comorbidity\n                1.1.1 Angina?\n                1.1.2 MI?\n              1.2 Vascular Comorbidity?\n              ...\n            Histopathology\n              Abdominal\n                pT category?\n              ...\n          </pre>\n    </div>"
    },
    "url": "http://hl7.org/fhir/Questionnaire/3141",
    "title": "Cancer Quality Forum Questionnaire 2012",
    "status": "draft",
    "subjectType": [
        "Patient"
    ],
    "date": "2012-01",
    "item": [
        {
            "linkId": "1",
            "code": [
                {
                    "system": "http://example.org/system/code/sections",
                    "code": "COMORBIDITY"
                }
            ],
            "type": "group",
            "item": [
                {
                    "linkId": "1.1",
                    "code": [
                        {
                            "system": "http://example.org/system/code/questions",
                            "code": "COMORB"
                        }
                    ],
                    "prefix": "1",
                    "type": "choice",
                    "answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow",
                    "item": [
                        {
                            "linkId": "1.1.1",
                            "code": [
                                {
                                    "system": "http://example.org/system/code/sections",
                                    "code": "CARDIAL"
                                }
                            ],
                            "type": "group",
                            "enableWhen": [
                                {
                                    "question": "1.1",
                                    "operator": "=",
                                    "answerCoding": {
                                        "system": "http://terminology.hl7.org/CodeSystem/v2-0136",
                                        "code": "Y"
                                    }
                                }
                            ],
                            "item": [
                                {
                                    "linkId": "1.1.1.1",
                                    "code": [
                                        {
                                            "system": "http://example.org/system/code/questions",
                                            "code": "COMORBCAR"
                                        }
                                    ],
                                    "prefix": "1.1",
                                    "type": "choice",
                                    "answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow",
                                    "item": [
                                        {
                                            "linkId": "1.1.1.1.1",
                                            "code": [
                                                {
                                                    "system": "http://example.org/system/code/questions",
                                                    "code": "COMCAR00",
                                                    "display": "Angina Pectoris"
                                                },
                                                {
                                                    "system": "http://snomed.info/sct",
                                                    "code": "194828000",
                                                    "display": "Angina (disorder)"
                                                }
                                            ],
                                            "prefix": "1.1.1",
                                            "type": "choice",
                                            "answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow"
                                        },
                                        {
                                            "linkId": "1.1.1.1.2",
                                            "code": [
                                                {
                                                    "system": "http://snomed.info/sct",
                                                    "code": "22298006",
                                                    "display": "Myocardial infarction (disorder)"
                                                }
                                            ],
                                            "prefix": "1.1.2",
                                            "type": "choice",
                                            "answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow"
                                        }
                                    ]
                                },
                                {
                                    "linkId": "1.1.1.2",
                                    "code": [
                                        {
                                            "system": "http://example.org/system/code/questions",
                                            "code": "COMORBVAS"
                                        }
                                    ],
                                    "prefix": "1.2",
                                    "type": "choice",
                                    "answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow"
                                }
                            ]
                        }
                    ]
                }
            ]
        },
        {
            "linkId": "2",
            "code": [
                {
                    "system": "http://example.org/system/code/sections",
                    "code": "HISTOPATHOLOGY"
                }
            ],
            "type": "group",
            "item": [
                {
                    "linkId": "2.1",
                    "code": [
                        {
                            "system": "http://example.org/system/code/sections",
                            "code": "ABDOMINAL"
                        }
                    ],
                    "type": "group",
                    "item": [
                        {
                            "linkId": "2.1.2",
                            "code": [
                                {
                                    "system": "http://example.org/system/code/questions",
                                    "code": "STADPT",
                                    "display": "pT category"
                                }
                            ],
                            "type": "choice"
                        }
                    ]
                }
            ]
        }
    ]
};
}
