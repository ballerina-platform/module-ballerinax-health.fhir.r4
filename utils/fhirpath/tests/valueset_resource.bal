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

function getValuesetResource() returns json {
    return {
    "resourceType": "ValueSet",
    "id": "example-expansion",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
        ]
    },
    "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><table class=\"grid\"><tr><td>http://loinc.org</td><td>14647-2</td><td>Cholesterol [Moles/volume] in Serum or Plasma</td></tr><tr><td colspan=\"3\"><b>Additional Cholesterol codes</b></td></tr><tr><td>http://loinc.org</td><td>2093-3</td><td>Cholesterol [Mass/volume] in Serum or Plasma</td></tr><tr><td>http://loinc.org</td><td>48620-9</td><td>Cholesterol [Mass/volume] in Serum or Plasma ultracentrifugate</td></tr><tr><td>http://loinc.org</td><td>9342-7</td><td>Cholesterol [Percentile]</td></tr><tr><td colspan=\"3\"><b>Cholesterol Ratios</b></td></tr><tr><td>http://loinc.org</td><td>2096-6</td><td>Cholesterol/Triglyceride [Mass Ratio] in Serum or Plasma</td></tr><tr><td>http://loinc.org</td><td>35200-5</td><td>Cholesterol/Triglyceride [Mass Ratio] in Serum or Plasma</td></tr><tr><td>http://loinc.org</td><td>48089-7</td><td>Cholesterol/Apolipoprotein B [Molar ratio] in Serum or Plasma</td></tr><tr><td>http://loinc.org</td><td>55838-7</td><td>Cholesterol/Phospholipid [Molar ratio] in Serum or Plasma</td></tr></table></div>"
    },
    "url": "http://hl7.org/fhir/ValueSet/example-expansion",
    "version": "20150622",
    "name": "LOINC Codes for Cholesterol in Serum/Plasma",
    "status": "draft",
    "experimental": true,
    "date": "2015-06-22",
    "publisher": "FHIR Project team",
    "contact": [
        {
            "telecom": [
                {
                    "system": "url",
                    "value": "http://hl7.org/fhir"
                }
            ]
        }
    ],
    "description": "This is an example value set that includes all the LOINC codes for serum/plasma cholesterol from v2.36.",
    "copyright": "This content from LOINC® is copyright © 1995 Regenstrief Institute, Inc. and the LOINC Committee, and available at no cost under the license at http://loinc.org/terms-of-use.",
    "compose": {
        "include": [
            {
                "system": "http://loinc.org",
                "filter": [
                    {
                        "property": "parent",
                        "op": "=",
                        "value": "LP43571-6"
                    }
                ]
            }
        ]
    },
    "expansion": {
        "extension": [
            {
                "url": "http://hl7.org/fhir/StructureDefinition/valueset-expansionSource",
                "valueUri": "http://hl7.org/fhir/ValueSet/example-extensional"
            }
        ],
        "identifier": "urn:uuid:42316ff8-2714-4680-9980-f37a6d1a71bc",
        "timestamp": "2015-06-22T13:56:07Z",
        "total": 8,
        "offset": 0,
        "parameter": [
            {
                "name": "version",
                "valueString": "2.50"
            }
        ],
        "contains": [
            {
                "system": "http://loinc.org",
                "version": "2.50",
                "code": "14647-2",
                "display": "Cholesterol [Moles/volume] in Serum or Plasma"
            },
            {
                "abstract": true,
                "display": "Cholesterol codes",
                "contains": [
                    {
                        "system": "http://loinc.org",
                        "version": "2.50",
                        "code": "2093-3",
                        "display": "Cholesterol [Mass/volume] in Serum or Plasma"
                    },
                    {
                        "system": "http://loinc.org",
                        "version": "2.50",
                        "code": "48620-9",
                        "display": "Cholesterol [Mass/volume] in Serum or Plasma ultracentrifugate"
                    },
                    {
                        "system": "http://loinc.org",
                        "version": "2.50",
                        "code": "9342-7",
                        "display": "Cholesterol [Percentile]"
                    }
                ]
            },
            {
                "abstract": true,
                "display": "Cholesterol Ratios",
                "contains": [
                    {
                        "system": "http://loinc.org",
                        "version": "2.50",
                        "code": "2096-6",
                        "display": "Cholesterol/Triglyceride [Mass Ratio] in Serum or Plasma"
                    },
                    {
                        "system": "http://loinc.org",
                        "version": "2.50",
                        "code": "35200-5",
                        "display": "Cholesterol/Triglyceride [Mass Ratio] in Serum or Plasma"
                    },
                    {
                        "system": "http://loinc.org",
                        "version": "2.50",
                        "code": "48089-7",
                        "display": "Cholesterol/Apolipoprotein B [Molar ratio] in Serum or Plasma"
                    },
                    {
                        "system": "http://loinc.org",
                        "version": "2.50",
                        "code": "55838-7",
                        "display": "Cholesterol/Phospholipid [Molar ratio] in Serum or Plasma"
                    }
                ]
            }
        ]
    }
};
}
