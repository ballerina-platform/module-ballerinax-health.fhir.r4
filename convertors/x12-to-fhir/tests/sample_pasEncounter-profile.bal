import ballerinax/health.fhir.r4.davincipas;

davincipas:PASEncounter sampleEncounterProfile = {
    "resourceType": "Encounter",
    "id": "Encounter/SurgicalEncounterExample",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-encounter"
        ]
    },
    "text": {
        "status": "extensions",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Encounter</b><a name=\"SurgicalEncounterExample\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Encounter &quot;SurgicalEncounterExample&quot; </p><p style=\"margin-bottom: 0px\">Profile: <a href=\"StructureDefinition-profile-encounter.html\">PAS Encounter</a></p></div><p><b>PatientStatus</b>: Still a patient <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-AHANUBCPatientDischargeStatus.html\">AHA NUBC Patient Discharge Status Codes</a>#30)</span></p><p><b>status</b>: planned</p><p><b>class</b>: ambulatory (Details: http://terminology.hl7.org/CodeSystem/v3-ActCode code AMB = 'ambulatory', stated as 'null')</p><p><b>type</b>: 2 <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-AHANUBCPriorityTypeOfAdmitOrVisit.html\">AHA NUBC Priority (Type) of Admission or Visit</a>#2)</span></p><p><b>subject</b>: <a href=\"Patient-SubscriberExample.html\">Patient/SubscriberExample</a> &quot; SMITH&quot;</p><p><b>period</b>: 2020-07-02 --&gt; 2020-07-09</p><h3>Hospitalizations</h3><table class=\"grid\"><tr><td style=\"display: none\">-</td><td><b>AdmitSource</b></td></tr><tr><td style=\"display: none\">*</td><td>5 <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-AHANUBCPointOfOriginNonnewborn.html\">AHA NUBC Point of Origin for Non-newborn</a>#5)</span></td></tr></table></div>"
    },
    "extension": [
        {
            "url": "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-nursingHomeResidentialStatus",
            "valueCodeableConcept": {
                "coding": [
                    {
                        "system": "https://www.nubc.org/CodeSystem/PatDischargeStatus",
                        "code": "104",
                        "display": "Still a patient"
                    }
                ]
            }
        },
        {
            "url": "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-patientStatus",
            "valueCodeableConcept": {
                "coding": [
                    {
                        "system": "https://www.nubc.org/CodeSystem/PatDischargeStatus",
                        "code": "103",
                        "display": "Still a patient"
                    }
                ]
            }
        }
    ],
    "status": "planned",
    "class": {
        "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
        "code": "AMB"
    },
    "type": [
        {
            "coding": [
                {
                    "system": "https://www.nubc.org/CodeSystem/PriorityTypeOfAdmitOrVisit",
                    "code": "101"
                }
            ]
        }
    ],
    "subject": {
        "reference": "Patient/SubscriberExample"
    },
    "period": {
        "start": "2020-07-02",
        "end": "2020-07-09"
    },
    "hospitalization": {
        "admitSource": {
            "coding": [
                {
                    "system": "https://www.nubc.org/CodeSystem/PointOfOrigin",
                    "code": "102"
                }
            ]
        }
    }
};
