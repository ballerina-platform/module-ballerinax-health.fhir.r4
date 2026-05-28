// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
// 
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// Source: SQL-on-FHIR v2 test suite (https://github.com/FHIR/sql-on-fhir-v2)
import ballerina/test;
import mahima_de_silva/sql_on_fhir_lib;

json[] fnExtensionResources = [
    {
        "resourceType": "Patient",
        "id": "pt1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
            ]
        },
        "extension": [
            {
                "id": "birthsex",
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex",
                "valueCode": "F"
            },
            {
                "id": "race",
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
                        "url": "text",
                        "valueString": "Mixed"
                    }
                ]
            },
            {
                "id": "sex",
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex",
                "valueCode": "248152002"
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "pt2",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
            ]
        },
        "extension": [
            {
                "id": "birthsex",
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex",
                "valueCode": "M"
            },
            {
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race",
                "id": "race",
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
                        "url": "text",
                        "valueString": "Mixed"
                    }
                ]
            },
            {
                "id": "sex",
                "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex",
                "valueCode": "248152002"
            }
        ]
    },
    {
        "resourceType": "Patient",
        "id": "pt3",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
            ]
        },
        "extension": []
    }
];


@test:Config {}
function testSimpleExtension() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "id",
                        'type: "id"
                    },
                    {
                        name: "birthsex",
                        path: "extension('http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex').value.ofType(code).first()",
                        'type: "code"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "birthsex": "F"
        },
        {
            "id": "pt2",
            "birthsex": "M"
        },
        {
            "id": "pt3",
            "birthsex": ()
        }
    ];
    json[] result = check evaluate(fnExtensionResources, view);
    test:assertEquals(result, expected);}

@test:Config {}
function testNestedExtension() returns error? {
    sql_on_fhir_lib:ViewDefinition view = {
        'resource: "Patient",
        status: "active",
        'select: [
            {
                column: [
                    {
                        path: "id",
                        name: "id",
                        'type: "id"
                    },
                    {
                        name: "race_code",
                        path: "extension('http://hl7.org/fhir/us/core/StructureDefinition/us-core-race').extension('ombCategory').value.ofType(Coding).code.first()",
                        'type: "code"
                    }
                ]
            }
        ]
    };
    json[] expected = [
        {
            "id": "pt1",
            "race_code": "2106-3"
        },
        {
            "id": "pt2",
            "race_code": "2135-2"
        },
        {
            "id": "pt3",
            "race_code": ()
        }
    ];
    json[] result = check evaluate(fnExtensionResources, view);
    test:assertEquals(result, expected);}
