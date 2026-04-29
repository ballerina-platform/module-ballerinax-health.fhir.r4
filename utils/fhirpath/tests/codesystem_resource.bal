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

function getCodesystemResource() returns json {
    return {
        "resourceType": "CodeSystem",
        "id": "example",
        "meta": {
            "profile": ["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]
        },
        "url": "http://hl7.org/fhir/CodeSystem/example",
        "identifier": [
            {
                "system": "http://acme.com/identifiers/codesystems",
                "value": "internal-cholesterol-inl"
            }
        ],
        "version": "20160128",
        "name": "ACMECholCodesBlood",
        "title": "ACME Codes for Cholesterol in Serum/Plasma",
        "status": "draft",
        "experimental": true,
        "date": "2016-01-28",
        "publisher": "Acme Co",
        "contact": [
            {
                "name": "FHIR project team",
                "telecom": [
                    {
                        "system": "url",
                        "value": "http://hl7.org/fhir"
                    }
                ]
            }
        ],
        "description": "This is an example code system that includes all the ACME codes for serum/plasma cholesterol from v2.36.",
        "caseSensitive": true,
        "content": "complete",
        "filter": [
            {
                "code": "acme-plasma",
                "description": "An internal filter used to select codes that are only used with plasma",
                "operator": ["="],
                "value": "the value of this filter is either 'true' or 'false'"
            }
        ],
        "concept": [
            {
                "code": "chol-mass",
                "display": "SChol (mmol/L)",
                "definition": "Serum Cholesterol, in mmol/L",
                "designation": [
                    {
                        "use": {
                            "system": "http://acme.com/config/fhir/codesystems/internal",
                            "code": "internal-label"
                        },
                        "value": "From ACME POC Testing"
                    }
                ]
            },
            {
                "code": "chol-mg",
                "display": "SChol (mg/L)",
                "definition": "Serum Cholesterol, in mg/L",
                "designation": [
                    {
                        "use": {
                            "system": "http://acme.com/config/fhir/codesystems/internal",
                            "code": "internal-label"
                        },
                        "value": "From Paragon Labs"
                    }
                ]
            },
            {
                "code": "chol",
                "display": "SChol",
                "definition": "Serum Cholesterol",
                "designation": [
                    {
                        "use": {
                            "system": "http://acme.com/config/fhir/codesystems/internal",
                            "code": "internal-label"
                        },
                        "value": "Obdurate Labs uses this with both kinds of units..."
                    }
                ]
            }
        ]
    };
}
