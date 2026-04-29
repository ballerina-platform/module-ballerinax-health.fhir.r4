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

function getAppointmentResource() returns json {
    return {
    "resourceType": "Appointment",
    "id": "examplereq",
    "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">Brian MRI results discussion</div>"
    },
    "identifier": [
        {
            "system": "http://example.org/sampleappointment-identifier",
            "value": "123"
        }
    ],
    "status": "proposed",
    "serviceCategory": [
        {
            "coding": [
                {
                    "system": "http://example.org/service-category",
                    "code": "gp",
                    "display": "General Practice"
                }
            ]
        }
    ],
    "specialty": [
        {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "394814009",
                    "display": "General practice"
                }
            ]
        }
    ],
    "appointmentType": {
        "coding": [
            {
                "system": "http://terminology.hl7.org/CodeSystem/v2-0276",
                "code": "WALKIN",
                "display": "A previously unscheduled walk-in visit"
            }
        ]
    },
    "reason": [
        {
            "concept": {
                "coding": [
                    {
                        "system": "http://snomed.info/sct",
                        "code": "413095006"
                    }
                ],
                "text": "Clinical Review"
            }
        }
    ],
    "description": "Discussion on the results of your recent MRI",
    "minutesDuration": 15,
    "slot": [
        {
            "reference": "Slot/example"
        }
    ],
    "created": "2015-12-02",
    "note": [
        {
            "text": "Further expand on the results of the MRI and determine the next actions that may be appropriate."
        }
    ],
    "participant": [
        {
            "actor": {
                "reference": "Patient/example",
                "display": "Peter James Chalmers"
            },
            "required": true,
            "status": "needs-action"
        },
        {
            "type": [
                {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
                            "code": "ATND"
                        }
                    ]
                }
            ],
            "required": true,
            "status": "needs-action"
        },
        {
            "actor": {
                "reference": "Location/1",
                "display": "South Wing, second floor"
            },
            "required": true,
            "status": "accepted"
        }
    ],
    "requestedPeriod": [
        {
            "start": "2016-06-02",
            "end": "2016-06-09"
        }
    ]
};
}
