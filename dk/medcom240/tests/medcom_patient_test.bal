// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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

import ballerina/test;
import ballerinax/health.fhir.r4 as r4;

@test:Config {}
// Test case 1: Creating a valid PhdPatient record with mandatory fields
function testCreateValidMedcomPatient() returns error? {

    // Create a valid MedComCorePatient
    MedComCorePatient patient = {
        resourceType: RESOURCE_NAME_MEDCOMCOREPATIENT,
        identifier: [
            <MedComCorePatientIdentifierCpr>{
                value: "0101010101"
            }
        ],
        name: [
            <MedComCorePatientNameOfficial>{
                family: "Jensen",
                given: ["Peter"]
            }
        ],
        gender: "male",
        birthDate: "1990-01-01",
        active: true,
        telecom: [
            {
                system: "phone",
                value: "+4512345678",
                use: "home"
            }
        ],
        address: [
            {
                line: ["Hovedgaden 1"],
                city: "København",
                postalCode: "1000",
                country: "DK"
            }
        ],
        meta: {
            profile: ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-patient"]
        }
    };

    r4:HumanName nameElement = <r4:HumanName>patient.name[0];
    r4:Identifier slicedIdentifier = <r4:Identifier>patient.identifier[0];

    //assert Name slice
    test:assertTrue(nameElement.use.toString().equalsIgnoreCaseAscii("official"), "Fixed value for name[X].use has not been set");
    //assert Identifier slice
    test:assertTrue(slicedIdentifier.system.toString().equalsIgnoreCaseAscii("urn:oid:1.2.208.176.1.2"), "Fixed value for identifier.system has not been set");
}
