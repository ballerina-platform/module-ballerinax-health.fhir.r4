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
    "resourceType": "Patient",
    "id": "123344",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "identifier": [
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR"
                    }
                ]
            },
            "system": "urn:oid:1.2.36.146.595.217.0.1",
            "value": "12345",
            "period": {
                "start": "2001-05-06"
            },
            "assigner": {
                "display": "Acme Healthcare"
            }
        }
    ],
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "(03) 5555 6473",
            "use": "work",
            "rank": 1
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "deceasedBoolean": false,
    "address": [
        {
            "use": "home",
            "type": "both",
            "text": "534 Erewhon St PeasantVille, Rainbow, Vic  3999",
            "line": [
                "534 Erewhon St"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "period": {
                "start": "1974-12-25"
            }
        }
    ],
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

json TEST_FHIR_RESOURCE_JSON_PATIENT_02 = {
    "resourceType": "Patient",
    "extension": [
        {
            "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
            "extension": [
                {
                    "url": "ombCategory",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2106-3",
                        "display": "White"
                    }
                },
                {
                    "url": "ombCategory",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "1002-5",
                        "display": "American Indian or Alaska Native"
                    }
                },
                {
                    "url": "ombCategory",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2028-9",
                        "display": "Asian"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "1586-7",
                        "display": "Shoshone"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2036-2",
                        "display": "Filipino"
                    }
                },
                {
                    "url": "text",
                    "valueString": "Mixed"
                }
            ]
        },
        {
            "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity",
            "extension": [
                {
                    "url": "ombCategory",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2135-2",
                        "display": "Hispanic or Latino"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2184-0",
                        "display": "Dominican"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2148-5",
                        "display": "Mexican"
                    }
                },
                {
                    "url": "text",
                    "valueString": "Hispanic or Latino"
                }
            ]
        },
        {
            "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex",
            "valueCode": "F"
        }
    ],
    "gender": "female",
    "telecom": [
        {
            "system": "phone",
            "use": "home",
            "value": "555-555-5555"
        },
        {
            "system": "email",
            "value": "amy.shaw@example.com"
        }
    ],
    "id": "101",
    "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n\t\t\t<p>\n\t\t\t\t<b>Generated Narrative with Details</b>\n\t\t\t</p>\n\t\t\t<p>\n\t\t\t\t<b>id</b>: example</p>\n\t\t\t<p>\n\t\t\t\t<b>identifier</b>: Medical Record Number = 1032702 (USUAL)</p>\n\t\t\t<p>\n\t\t\t\t<b>active</b>: true</p>\n\t\t\t<p>\n\t\t\t\t<b>name</b>: Amy V. Shaw </p>\n\t\t\t<p>\n\t\t\t\t<b>telecom</b>: ph: 555-555-5555(HOME), amy.shaw@example.com</p>\n\t\t\t<p>\n\t\t\t\t<b>gender</b>: </p>\n\t\t\t<p>\n\t\t\t\t<b>birthsex</b>: Female</p>\n\t\t\t<p>\n\t\t\t\t<b>birthDate</b>: Feb 20, 2007</p>\n\t\t\t<p>\n\t\t\t\t<b>address</b>: 49 Meadow St Mounds OK 74047 US </p>\n\t\t\t<p>\n\t\t\t\t<b>race</b>: White, American Indian or Alaska Native, Asian, Shoshone, Filipino</p>\n\t\t\t<p>\n\t\t\t\t<b>ethnicity</b>: Hispanic or Latino, Dominican, Mexican</p>\n\t\t</div>"
    },
    "identifier": [
        {
            "system": "http://hospital.smarthealthit.org",
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR",
                        "display": "Medical Record Number"
                    }
                ],
                "text": "Medical Record Number"
            },
            "value": "1032702"
        }
    ],
    "address": [
        {
            "country": "US",
            "city": "Mounds",
            "line": [
                "49 Meadow St"
            ],
            "postalCode": "74047",
            "state": "OK"
        }
    ],
    "active": true,
    "birthDate": "2007-02-20",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
        ]
    },
    "name": [
        {
            "given": [
                "Jack",
                "V."
            ],
            "family": "Shaw"
        }
    ]
};

json TEST_FHIR_RESOURCE_JSON_PATIENT_02_INVALID_TERMINOLOGY = {
    "resourceType": "Patient",
    "extension": [
        {
            "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
            "extension": [
                {
                    "url": "ombCategory",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "invalid-code", // Invalid code
                        "display": "White"
                    }
                },
                {
                    "url": "ombCategory",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "1002-5",
                        "display": "American Indian or Alaska Native"
                    }
                },
                {
                    "url": "ombCategory",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2028-9",
                        "display": "Asian"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "1586-7",
                        "display": "Shoshone"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2036-2",
                        "display": "Filipino"
                    }
                },
                {
                    "url": "text",
                    "valueString": "Mixed"
                }
            ]
        },
        {
            "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity",
            "extension": [
                {
                    "url": "ombCategory",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2135-2",
                        "display": "Hispanic or Latino"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "invalid-code", // Invalid code
                        "display": "Dominican"
                    }
                },
                {
                    "url": "detailed",
                    "valueCoding": {
                        "system": "urn:oid:2.16.840.1.113883.6.238",
                        "code": "2148-5",
                        "display": "Mexican"
                    }
                },
                {
                    "url": "text",
                    "valueString": "Hispanic or Latino"
                }
            ]
        },
        {
            "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex",
            "valueCode": "F"
        }
    ],
    "gender": "female",
    "telecom": [
        {
            "system": "phone",
            "use": "home",
            "value": "555-555-5555"
        },
        {
            "system": "email",
            "value": "amy.shaw@example.com"
        }
    ],
    "id": "101",
    "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n\t\t\t<p>\n\t\t\t\t<b>Generated Narrative with Details</b>\n\t\t\t</p>\n\t\t\t<p>\n\t\t\t\t<b>id</b>: example</p>\n\t\t\t<p>\n\t\t\t\t<b>identifier</b>: Medical Record Number = 1032702 (USUAL)</p>\n\t\t\t<p>\n\t\t\t\t<b>active</b>: true</p>\n\t\t\t<p>\n\t\t\t\t<b>name</b>: Amy V. Shaw </p>\n\t\t\t<p>\n\t\t\t\t<b>telecom</b>: ph: 555-555-5555(HOME), amy.shaw@example.com</p>\n\t\t\t<p>\n\t\t\t\t<b>gender</b>: </p>\n\t\t\t<p>\n\t\t\t\t<b>birthsex</b>: Female</p>\n\t\t\t<p>\n\t\t\t\t<b>birthDate</b>: Feb 20, 2007</p>\n\t\t\t<p>\n\t\t\t\t<b>address</b>: 49 Meadow St Mounds OK 74047 US </p>\n\t\t\t<p>\n\t\t\t\t<b>race</b>: White, American Indian or Alaska Native, Asian, Shoshone, Filipino</p>\n\t\t\t<p>\n\t\t\t\t<b>ethnicity</b>: Hispanic or Latino, Dominican, Mexican</p>\n\t\t</div>"
    },
    "identifier": [
        {
            "system": "http://hospital.smarthealthit.org",
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR",
                        "display": "Medical Record Number"
                    }
                ],
                "text": "Medical Record Number"
            },
            "value": "1032702"
        }
    ],
    "address": [
        {
            "country": "US",
            "city": "Mounds",
            "line": [
                "49 Meadow St"
            ],
            "postalCode": "74047",
            "state": "OK"
        }
    ],
    "active": true,
    "birthDate": "2007-02-20",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
        ]
    },
    "name": [
        {
            "given": [
                "Jack",
                "V."
            ],
            "family": "Shaw"
        }
    ]
};

json TEST_FHIR_RESOURCE_JSON_PATIENT_WITHOUT_PROFILE = {
    "resourceType": "Patient",
    "id": "123344",
    "meta": {
        "profile": [
        ]
    },
    "identifier": [
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR"
                    }
                ]
            },
            "system": "urn:oid:1.2.36.146.595.217.0.1",
            "value": "12345",
            "period": {
                "start": "2001-05-06"
            },
            "assigner": {
                "display": "Acme Healthcare"
            }
        }
    ],
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "(03) 5555 6473",
            "use": "work",
            "rank": 1
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "deceasedBoolean": false,
    "address": [
        {
            "use": "home",
            "type": "both",
            "text": "534 Erewhon St PeasantVille, Rainbow, Vic  3999",
            "line": [
                "534 Erewhon St"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "period": {
                "start": "1974-12-25"
            }
        }
    ],
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

json TEST_FHIR_RESOURCE_JSON_INVALID_PROFILE = {
    "resourceType": "Patient",
    "id": "123344",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/ABCDPatient"
        ]
    },
    "identifier": [
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR"
                    }
                ]
            },
            "system": "urn:oid:1.2.36.146.595.217.0.1",
            "value": "12345",
            "period": {
                "start": "2001-05-06"
            },
            "assigner": {
                "display": "Acme Healthcare"
            }
        }
    ],
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "(03) 5555 6473",
            "use": "work",
            "rank": 1
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "deceasedBoolean": false,
    "address": [
        {
            "use": "home",
            "type": "both",
            "text": "534 Erewhon St PeasantVille, Rainbow, Vic  3999",
            "line": [
                "534 Erewhon St"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "period": {
                "start": "1974-12-25"
            }
        }
    ],
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

json TEST_FHIR_RESOURCE_JSON_WITH_NO_PROFILE_UNKNOWN_RESOURCE_TYPE = {
    "resourceType": "ABCDPatient",
    "id": "123344",
    "meta": {
        "profile": [
        ]
    },
    "identifier": [
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR"
                    }
                ]
            },
            "system": "urn:oid:1.2.36.146.595.217.0.1",
            "value": "12345",
            "period": {
                "start": "2001-05-06"
            },
            "assigner": {
                "display": "Acme Healthcare"
            }
        }
    ],
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "(03) 5555 6473",
            "use": "work",
            "rank": 1
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "deceasedBoolean": false,
    "address": [
        {
            "use": "home",
            "type": "both",
            "text": "534 Erewhon St PeasantVille, Rainbow, Vic  3999",
            "line": [
                "534 Erewhon St"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "period": {
                "start": "1974-12-25"
            }
        }
    ],
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

json TEST_FHIR_RESOURCE_JSON_INVALID_TYPE = {
    "resourceType": "ABCDPatient",
    "id": "123344",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "identifier": [
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR"
                    }
                ]
            },
            "system": "urn:oid:1.2.36.146.595.217.0.1",
            "value": "12345",
            "period": {
                "start": "2001-05-06"
            },
            "assigner": {
                "display": "Acme Healthcare"
            }
        }
    ],
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "(03) 5555 6473",
            "use": "work",
            "rank": 1
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "deceasedBoolean": false,
    "address": [
        {
            "use": "home",
            "type": "both",
            "text": "534 Erewhon St PeasantVille, Rainbow, Vic  3999",
            "line": [
                "534 Erewhon St"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "period": {
                "start": "1974-12-25"
            }
        }
    ],
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

json TEST_FHIR_RESOURCE_JSON_INVALID_TYPE_WITHOUT_PROFILE = {
    "resourceType": "ABCDPatient",
    "id": "123344",
    "meta": {
        "profile": [
        ]
    },
    "identifier": [
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR"
                    }
                ]
            },
            "system": "urn:oid:1.2.36.146.595.217.0.1",
            "value": "12345",
            "period": {
                "start": "2001-05-06"
            },
            "assigner": {
                "display": "Acme Healthcare"
            }
        }
    ],
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "(03) 5555 6473",
            "use": "work",
            "rank": 1
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "deceasedBoolean": false,
    "address": [
        {
            "use": "home",
            "type": "both",
            "text": "534 Erewhon St PeasantVille, Rainbow, Vic  3999",
            "line": [
                "534 Erewhon St"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "period": {
                "start": "1974-12-25"
            }
        }
    ],
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

json TEST_FHIR_RESOURCE_JSON_INVALID_PATIENT_01 = {
    "resourceType": "Patient",
    "id": "123344",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "identifierr": [
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR"
                    }
                ]
            },
            "system": "urn:oid:1.2.36.146.595.217.0.1",
            "value": "12345",
            "period": {
                "start": "2001-05-06"
            },
            "assigner": {
                "display": "Acme Healthcare"
            }
        }
    ],
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "(03) 5555 6473",
            "use": "work",
            "rank": 1
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "deceasedBoolean": false,
    "address": [
        {
            "use": "home",
            "type": "both",
            "text": "534 Erewhon St PeasantVille, Rainbow, Vic  3999",
            "line": [
                "534 Erewhon St"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "period": {
                "start": "1974-12-25"
            }
        }
    ],
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

xml TEST_FHIR_RESOURCE_XML_PATIENT_01 = xml `<Patient xmlns="http://hl7.org/fhir">
	<id value="example"/>
	<text>
		<status value="generated"/>
		<div xmlns="http://www.w3.org/1999/xhtml">
			<table>
				<tbody>
					<tr>
						<td>Name</td>
						<td>Peter James 
              <b>Chalmers</b> (&quot;Jim&quot;)
            </td>
					</tr>
					<tr>
						<td>Address</td>
						<td>534 Erewhon, Pleasantville, Vic, 3999</td>
					</tr>
					<tr>
						<td>Contacts</td>
						<td>Home: unknown. Work: (03) 5555 6473</td>
					</tr>
					<tr>
						<td>Id</td>
						<td>MRN: 12345 (Acme Healthcare)</td>
					</tr>
				</tbody>
			</table>
		</div>
	</text>
	<!--   MRN assigned by ACME healthcare on 6-May 2001   -->
	<identifier>
		<use value="usual"/>
		<type>
			<coding>
				<system value="http://terminology.hl7.org/CodeSystem/v2-0203"/>
				<code value="MR"/>
			</coding>
		</type>
		<system value="urn:oid:1.2.36.146.595.217.0.1"/>
		<value value="12345"/>
		<period>
			<start value="2001-05-06"/>
		</period>
		<assigner>
			<display value="Acme Healthcare"/>
		</assigner>
	</identifier>
	<active value="true"/>
	<!--   Peter James Chalmers, but called "Jim"   -->
	<name>
		<use value="official"/>
		<family value="Chalmers"/>
		<given value="Peter"/>
		<given value="James"/>
	</name>
	<name>
		<use value="usual"/>
		<given value="Jim"/>
	</name>
	<name>
    <!--  Maiden names apply for anyone whose name changes as a result of marriage - irrespective of gender  -->
    <use value="maiden"/>
    <family value="Windsor"/>
		<given value="Peter"/>
		<given value="James"/>
    <period>
      <end value="2002"/>
    </period>
	</name>
	<telecom>
		<use value="home"/>
		<!--   home communication details aren't known   -->
	</telecom>
	<telecom>
		<system value="phone"/>
		<value value="(03) 5555 6473"/>
		<use value="work"/>
		<rank value="1"/>
	</telecom>
	<telecom>
		<system value="phone"/>
		<value value="(03) 3410 5613"/>
		<use value="mobile"/>
		<rank value="2"/>
	</telecom>
	<telecom>
		<system value="phone"/>
		<value value="(03) 5555 8834"/>
		<use value="old"/>
		<period>
      <end value="2014"/>
		</period>
	</telecom>
	<!--   use FHIR code system for male / female   -->
	<gender value="male"/>
	<birthDate value="1974-12-25">
		<extension url="http://hl7.org/fhir/StructureDefinition/patient-birthTime">
			<valueDateTime value="1974-12-25T14:35:45-05:00"/>
		</extension>
	</birthDate>
	<deceasedBoolean value="false"/>
	<address>
		<use value="home"/>
		<type value="both"/>
		<text value="534 Erewhon St PeasantVille, Rainbow, Vic  3999"/>
		<line value="534 Erewhon St"/>
		<city value="PleasantVille"/>
		<district value="Rainbow"/>
		<state value="Vic"/>
		<postalCode value="3999"/>
		<period>
			<start value="1974-12-25"/>
		</period>
	</address>
	<contact>
		<relationship>
			<coding>
				<system value="http://terminology.hl7.org/CodeSystem/v2-0131"/>
				<code value="N"/>
			</coding>
		</relationship>
		<name>
			<family value="du March&#xE9;">
				<!--   the "du" part is a family name prefix (VV in iso 21090)   -->
				<extension url="http://hl7.org/fhir/StructureDefinition/humanname-own-prefix">
					<valueString value="VV"/>
				</extension>
			</family>
			<given value="B&#xE9;n&#xE9;dicte"/>
		</name>
		<telecom>
			<system value="phone"/>
			<value value="+33 (237) 998327"/>
		</telecom>
		<address>
			<use value="home"/>
			<type value="both"/>
			<line value="534 Erewhon St"/>
			<city value="PleasantVille"/>
			<district value="Rainbow"/>
			<state value="Vic"/>
			<postalCode value="3999"/>
			<period>
				<start value="1974-12-25"/>
			</period>
		</address>
		<gender value="female"/>
		<period>
			<!--   The contact relationship started in 2012   -->
			<start value="2012"/>
		</period>
	</contact>
	<managingOrganization>
		<reference value="Organization/1"/>
	</managingOrganization>
</Patient>`;

string TEST_FHIR_RESOURCE_JSON_PATIENT_01_STRING = string `{
        "resourceType" : "Patient",
    "id":  "123344",
    "meta" : {
    "profile": [
        "http://hl7.org/fhir/StructureDefinition/Patient"
    ]
},
    "identifier": [
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
    ] ,
 "active": true ,
 "name":[
{
"use":"official",
"family":"Chalmers",
"given":[
"Peter",
"James"
]
}
    ] ,
 "telecom":[
{
"system":"phone",
"value":"(03) 5555 6473",
"use":"work",
"rank":1
}
    ] ,
 "gender": "male" ,
 "birthDate": "1974-12-25" ,
 "deceasedBoolean": false ,
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
    ] ,
 "managingOrganization": {
 "reference": "Organization/1"
  }
}`;

string TEST_FHIR_RESOURCE_XML_PATIENT_01_STRING = string `<Patient xmlns="http://hl7.org/fhir">
	<id value="example"/>
	<text>
		<status value="generated"/>
		<div xmlns="http://www.w3.org/1999/xhtml">
			<table>
				<tbody>
					<tr>
						<td>Name</td>
						<td>Peter James 
              <b>Chalmers</b> (&quot;Jim&quot;)
            </td>
					</tr>
					<tr>
						<td>Address</td>
						<td>534 Erewhon, Pleasantville, Vic, 3999</td>
					</tr>
					<tr>
						<td>Contacts</td>
						<td>Home: unknown. Work: (03) 5555 6473</td>
					</tr>
					<tr>
						<td>Id</td>
						<td>MRN: 12345 (Acme Healthcare)</td>
					</tr>
				</tbody>
			</table>
		</div>
	</text>
	<!--   MRN assigned by ACME healthcare on 6-May 2001   -->
	<identifier>
		<use value="usual"/>
		<type>
			<coding>
				<system value="http://terminology.hl7.org/CodeSystem/v2-0203"/>
				<code value="MR"/>
			</coding>
		</type>
		<system value="urn:oid:1.2.36.146.595.217.0.1"/>
		<value value="12345"/>
		<period>
			<start value="2001-05-06"/>
		</period>
		<assigner>
			<display value="Acme Healthcare"/>
		</assigner>
	</identifier>
	<active value="true"/>
	<!--   Peter James Chalmers, but called "Jim"   -->
	<name>
		<use value="official"/>
		<family value="Chalmers"/>
		<given value="Peter"/>
		<given value="James"/>
	</name>
	<name>
		<use value="usual"/>
		<given value="Jim"/>
	</name>
	<name>
    <!--  Maiden names apply for anyone whose name changes as a result of marriage - irrespective of gender  -->
    <use value="maiden"/>
    <family value="Windsor"/>
		<given value="Peter"/>
		<given value="James"/>
    <period>
      <end value="2002"/>
    </period>
	</name>
	<telecom>
		<use value="home"/>
		<!--   home communication details aren't known   -->
	</telecom>
	<telecom>
		<system value="phone"/>
		<value value="(03) 5555 6473"/>
		<use value="work"/>
		<rank value="1"/>
	</telecom>
	<telecom>
		<system value="phone"/>
		<value value="(03) 3410 5613"/>
		<use value="mobile"/>
		<rank value="2"/>
	</telecom>
	<telecom>
		<system value="phone"/>
		<value value="(03) 5555 8834"/>
		<use value="old"/>
		<period>
      <end value="2014"/>
		</period>
	</telecom>
	<!--   use FHIR code system for male / female   -->
	<gender value="male"/>
	<birthDate value="1974-12-25">
		<extension url="http://hl7.org/fhir/StructureDefinition/patient-birthTime">
			<valueDateTime value="1974-12-25T14:35:45-05:00"/>
		</extension>
	</birthDate>
	<deceasedBoolean value="false"/>
	<address>
		<use value="home"/>
		<type value="both"/>
		<text value="534 Erewhon St PeasantVille, Rainbow, Vic  3999"/>
		<line value="534 Erewhon St"/>
		<city value="PleasantVille"/>
		<district value="Rainbow"/>
		<state value="Vic"/>
		<postalCode value="3999"/>
		<period>
			<start value="1974-12-25"/>
		</period>
	</address>
	<contact>
		<relationship>
			<coding>
				<system value="http://terminology.hl7.org/CodeSystem/v2-0131"/>
				<code value="N"/>
			</coding>
		</relationship>
		<name>
			<family value="du March&#xE9;">
				<!--   the "du" part is a family name prefix (VV in iso 21090)   -->
				<extension url="http://hl7.org/fhir/StructureDefinition/humanname-own-prefix">
					<valueString value="VV"/>
				</extension>
			</family>
			<given value="B&#xE9;n&#xE9;dicte"/>
		</name>
		<telecom>
			<system value="phone"/>
			<value value="+33 (237) 998327"/>
		</telecom>
		<address>
			<use value="home"/>
			<type value="both"/>
			<line value="534 Erewhon St"/>
			<city value="PleasantVille"/>
			<district value="Rainbow"/>
			<state value="Vic"/>
			<postalCode value="3999"/>
			<period>
				<start value="1974-12-25"/>
			</period>
		</address>
		<gender value="female"/>
		<period>
			<!--   The contact relationship started in 2012   -->
			<start value="2012"/>
		</period>
	</contact>
	<managingOrganization>
		<reference value="Organization/1"/>
	</managingOrganization>
</Patient>`;

string TEST_FHIR_RESOURCE_UNSUPPORTED_STRING = "hello";

json TEST_FHIR_RESOURCE_JSON_INVALID_PATIENT_02 = {
    "resourceType": "Patient",
    "id": "591841",
    "meta": {
        "versionId": "1",
        "lastUpdated": "2020-01-22T05:30:13.137+00:00",
        "source": "#KO38Q3spgrJoP5fa"
    },
    "identifier": [
        {
            "type": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/v2/0203",
                        "code": "MR"
                    }
                ]
            },
            "value": "18e5fd39-7444-4b30-91d4-57226deb2c78"
        }
    ],
    "name": [
        {
            "family": "Cushing",
            "given": ["Caleb"]
        }
    ],
    "birthDate": "jdlksjldjl"
};

json TEST_FHIR_RESOURCE_JSON_INVALID_PATIENT_03 = {
    "resourceType": "Patient",
    "id": "example-patient",
    "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">John Doe</div>"
    },
    "identifier": [],
    "extension": [
        {
            "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
            "valueCodeableConcept": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/v3/Race",
                        "code": "2106-3",
                        "display": "White"
                    }
                ]
            }
        }
    ],
    "name": [
        {
            "use": "official",
            "family": "Doe",
            "given": [
                "John"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "2000-01-01"
};

json TEST_FHIR_RESOURCE_JSON_VALID_PATIENT_01 = {
    "resourceType": "Patient",
    "id": "example-patient",
    "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">John Doe</div>"
    },
    "identifier": [
        {
            "system": "http://example.com/patient-ids",
            "value": "12345"
        }
    ],
    "extension": [
        {
            "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
            "valueCodeableConcept": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/v3/Race",
                        "code": "2106-3",
                        "display": "White"
                    }
                ]
            }
        }
    ],
    "name": [
        {
            "use": "official",
            "family": "Doe",
            "given": [
                "John"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "2000-01-01"
};
