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

import ballerinax/health.fhir.r4;


final r4:ResourceAPIConfig apiConfig = {
    resourceType: "Patient",
    authzConfig: (),
    profiles: [
        "http://hl7.org/fhir/StructureDefinition/Patient"
    ],
    defaultProfile: (),
    searchParameters: [
        {
            name: "birthdate",
            active: true,
            information: {
                description: "[Patient](patient.html): The patient's date of birth",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-birthdate"
            }
        },
        {
            name: "email",
            active: true,
            information: {
                description: "[Patient](patient.html): A value in an email contact",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-email"
            }
        },
        {
            name: "organization",
            active: true,
            information: {
                description: "The organization that is the custodian of the patient record",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/Patient-organization"
            }
        },
        {
            name: "address",
            active: true,
            information: {
                description: "[Patient](patient.html): A server defined search that may match any of the string fields in the Address, including line, city, district, state, country, postalCode, and/or text",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-address"
            }
        },
        {
            name: "address-use",
            active: true,
            information: {
                description: "[Patient](patient.html): A use code specified in an address",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-address-use"
            }
        },
        {
            name: "phonetic",
            active: true,
            information: {
                description: "[Patient](patient.html): A portion of either family or given name using some kind of phonetic matching algorithm",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-phonetic"
            }
        },
        {
            name: "address-country",
            active: true,
            information: {
                description: "[Patient](patient.html): A country specified in an address",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-address-country"
            }
        },
        {
            name: "phone",
            active: true,
            information: {
                description: "[Patient](patient.html): A value in a phone contact",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-phone"
            }
        },
        {
            name: "active",
            active: true,
            information: {
                description: "Whether the patient record is active",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/Patient-active"
            }
        },
        {
            name: "language",
            active: true,
            information: {
                description: "Language code (irrespective of use value)",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/Patient-language"
            }
        },
        {
            name: "name",
            active: true,
            information: {
                description: "A server defined search that may match any of the string fields in the HumanName, including family, give, prefix, suffix, suffix, and/or text",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/Patient-name"
            }
        },
        {
            name: "address-city",
            active: true,
            information: {
                description: "[Patient](patient.html): A city specified in an address",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-address-city"
            }
        },
        {
            name: "gender",
            active: true,
            information: {
                description: "[Patient](patient.html): Gender of the patient",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-gender"
            }
        },
        {
            name: "telecom",
            active: true,
            information: {
                description: "[Patient](patient.html): The value in any kind of telecom details of the patient",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-telecom"
            }
        },
        {
            name: "address-state",
            active: true,
            information: {
                description: "[Patient](patient.html): A state specified in an address",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-address-state"
            }
        },
        {
            name: "given",
            active: true,
            information: {
                description: "[Patient](patient.html): A portion of the given name of the patient",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-given"
            }
        },
        {
            name: "address-postalcode",
            active: true,
            information: {
                description: "[Patient](patient.html): A postalCode specified in an address",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-address-postalcode"
            }
        },
        {
            name: "deceased",
            active: true,
            information: {
                description: "This patient has been marked as deceased, or has a death date entered",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/Patient-deceased"
            }
        },
        {
            name: "death-date",
            active: true,
            information: {
                description: "The date of death has been provided and satisfies this search value",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/Patient-death-date"
            }
        },
        {
            name: "family",
            active: true,
            information: {
                description: "[Patient](patient.html): A portion of the family name of the patient",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-family"
            }
        },
        {
            name: "identifier",
            active: true,
            information: {
                description: "A patient identifier",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/Patient-identifier"
            }
        },
        {
            name: "link",
            active: true,
            information: {
                description: "All patients linked to the given patient",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/Patient-link"
            }
        },
        {
            name: "general-practitioner",
            active: true,
            information: {
                description: "Patient's nominated general practitioner, not the organization that manages the record",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/Patient-general-practitioner"
            }
        }
    ],
    operations: [

    ],
    serverConfig: ()
};

final r4:ResourceAPIConfig apiConfigNoPagination = {
    resourceType: "Patient",
    authzConfig: (),
    profiles: [
        "http://hl7.org/fhir/StructureDefinition/Patient"
    ],
    defaultProfile: (),
    searchParameters: [
        {
            name: "birthdate",
            active: true,
            information: {
                description: "[Patient](patient.html): The patient's date of birth",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-birthdate"
            }
        },
        {
            name: "given",
            active: true,
            information: {
                description: "[Patient](patient.html): A portion of the given name of the patient",
                builtin: false,
                documentation: "http://hl7.org/fhir/SearchParameter/individual-given"
            }
        }
    ],
    operations: [

    ],
    serverConfig: (),
    paginationConfig: {
        enabled: false}
};
