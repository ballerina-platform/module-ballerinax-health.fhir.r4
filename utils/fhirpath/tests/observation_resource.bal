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

function getObservationResource() returns json {
    return {
    "resourceType": "Observation",
    "id": "example",
    "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative with Details</b></p><p><b>id</b>: example</p><p><b>status</b>: final</p><p><b>category</b>: Vital Signs <span>(Details : {http://terminology.hl7.org/CodeSystem/observation-category code 'vital-signs' = 'Vital Signs', given as 'Vital Signs'})</span></p><p><b>code</b>: Body Weight <span>(Details : {LOINC code '29463-7' = 'Body weight', given as 'Body Weight'}; {LOINC code '3141-9' = 'Body weight Measured', given as 'Body weight Measured'}; {SNOMED CT code '27113001' = 'Body weight', given as 'Body weight'}; {http://acme.org/devices/clinical-codes code 'body-weight' = 'body-weight', given as 'Body Weight'})</span></p><p><b>subject</b>: <a>Patient/example</a></p><p><b>encounter</b>: <a>Encounter/example</a></p><p><b>effective</b>: 28/03/2016</p><p><b>value</b>: 185 lbs<span> (Details: UCUM code [lb_av] = 'lb_av')</span></p></div>"
    },
    "extension": [
        {
            "url": "http://example.com/fhir/StructureDefinition/patient-age",
            "valueAge": {
                "value": 41,
                "system": "http://unitsofmeasure.org",
                "code": "a"
            }
        }
    ],
    "status": "final",
    "category": [
        {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                    "code": "vital-signs",
                    "display": "Vital Signs"
                }
            ]
        }
    ],
    "code": {
        "coding": [
            {
                "system": "http://loinc.org",
                "code": "29463-7",
                "display": "Body Weight"
            },
            {
                "system": "http://loinc.org",
                "code": "3141-9",
                "display": "Body weight Measured"
            },
            {
                "system": "http://snomed.info/sct",
                "code": "27113001",
                "display": "Body weight"
            },
            {
                "system": "http://acme.org/devices/clinical-codes",
                "code": "body-weight",
                "display": "Body Weight"
            },
            {
                "system": "http://i18n.example/rtl-code/",
                "code": "كتلة-الجسم",
                "display": "كتلة الجسم"
            }
        ]
    },
    "subject": {
        "reference": "Patient/example"
    },
    "encounter": {
        "reference": "Encounter/example"
    },
    "effectiveDateTime": "2016-03-28",
    "valueQuantity": {
        "value": 185,
        "unit": "lbs",
        "system": "http://unitsofmeasure.org",
        "code": "[lb_av]"
    }
};
}
