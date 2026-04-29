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

function getDiagnosticreportResource() returns json {
    return {
    "resourceType": "DiagnosticReport",
    "id": "dgr-1.p2.pass",
    "contained": [
        {
            "resourceType": "Composition",
            "id": "comp",
            "status": "final",
            "type": {
                "coding": [
                    {
                        "system": "http://loinc.org",
                        "code": "LP29684-5"
                    }
                ]
            },
            "subject": [
                {
                    "reference": "Patient/b248b1b2-1686-4b94-9936-37d7a5f94b51"
                }
            ],
            "date": "2013-02-13T11:45:33+11:00",
            "author": [
                {
                    "reference": "Practitioner/example"
                }
            ],
            "title": "Diagnostic Report",
            "section": [
                {
                    "entry": [
                        {
                            "reference": "#obs2"
                        },
                        {
                            "reference": "#obs1"
                        }
                    ]
                },
                {
                    "entry": [
                        {
                            "reference": "#foo"
                        },
                        {
                            "reference": "#bar"
                        }
                    ]
                }
            ]
        },
        {
            "resourceType": "Basic",
            "id": "foo",
            "code": {
                "coding": [
                    {
                        "system": "http://loinc.org",
                        "code": "LP29684-5"
                    }
                ]
            }
        },
        {
            "resourceType": "Basic",
            "id": "bar",
            "code": {
                "coding": [
                    {
                        "system": "http://loinc.org",
                        "code": "LP29684-5"
                    }
                ]
            }
        },
        {
            "resourceType": "Observation",
            "id": "obs1",
            "status": "final",
            "code": {
                "coding": [
                    {
                        "system": "http://loinc.org",
                        "code": "47527-7"
                    }
                ]
            },
            "subject": {
                "reference": "Patient/b248b1b2-1686-4b94-9936-37d7a5f94b51"
            },
            "effectiveDateTime": "2013-02-11T10:33:33+11:00",
            "issued": "2013-02-13T11:45:33+11:00",
            "valueQuantity": {
                "value": 1.0,
                "unit": "mg/dL",
                "system": "http://unitsofmeasure.org",
                "code": "mg/dL"
            },
            "hasMember": [
                {
                    "reference": "#obs2"
                }
            ]
        },
        {
            "resourceType": "Observation",
            "id": "obs2",
            "status": "final",
            "code": {
                "coding": [
                    {
                        "system": "http://loinc.org",
                        "code": "47527-7"
                    }
                ]
            },
            "subject": {
                "reference": "Patient/b248b1b2-1686-4b94-9936-37d7a5f94b51"
            },
            "effectiveDateTime": "2013-02-11T10:33:33+11:00",
            "issued": "2013-02-13T11:45:33+11:00",
            "valueQuantity": {
                "value": 1.0,
                "unit": "mg/dL",
                "system": "http://unitsofmeasure.org",
                "code": "mg/dL"
            }
        }
    ],
    "status": "final",
    "code": {
        "coding": [
            {
                "system": "http://loinc.org",
                "code": "47527-7"
            }
        ]
    },
    "subject": {
        "reference": "Patient/b248b1b2-1686-4b94-9936-37d7a5f94b51"
    },
    "effectiveDateTime": "2013-02-11T10:33:33+11:00",
    "issued": "2013-02-13T11:45:33+11:00",
    "performer": [
        {
            "reference": "Practitioner/example"
        }
    ],
    "result": [
        {
            "reference": "#obs1"
        }
    ],
    "composition": {
        "reference": "#comp"
    }
};
}
