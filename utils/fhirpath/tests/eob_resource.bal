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

function getEobResource() returns json {
    return {
    "resourceType": "ExplanationOfBenefit",
    "id": "example",
    "supportingInfo": [
        {
            "sequence": 1,
            "category": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType",
                        "code": "additionalbodysite"
                    }
                ]
            }
        },
        {
            "sequence": 2,
            "category": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType",
                        "code": "additionalbodysite"
                    }
                ]
            }
        }
    ],
    "item": [
        {
            "sequence": 1,
            "informationSequence": [
                2
            ]
        },
        {
            "sequence": 2,
            "informationSequence": [
                1
            ]
        }
    ]
};
}
