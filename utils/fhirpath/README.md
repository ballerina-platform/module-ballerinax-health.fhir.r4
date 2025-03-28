# FHIR R4 Utils FHIRPath package

A package containing FHIR related processors and utilities to evaluate FHIRPath expressions on FHIR resources to extract specific data elements.

## Package Overview

This package provides a comprehensive set of functions and utilities to facilitate querying and manipulating FHIR resources using FHIRPath expressions.

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://hl7.org/fhir/fhirpath.html |

Refer [API Documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath) for sample usage.

# FHIR R4 Utils FHIRPath module

## Module Overview
This module provides processors and utilities for implementing FHIR Path for accessing and 
manipulating FHIR resources.

### Sample Usage of the Module is Given Below:

```
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;
json patient = {
        "resourceType" : "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/Patient"
            ]
        },
        "active":true,
        "name":[
            {
                "use":"official",
                "family":"Chalmers",
                "given":[
                    "Peter",
                    "James"
                ]
            },
            {
                "use":"usual",
                "given":[
                    "Jim"
                ]
            }
        ],
        "gender":"male",
        "birthDate":"1974-12-25",
        "managingOrganization":{
            "reference":"Organization/1",
            "display":"Burgers University Medical Center"
        },
        "address":[
            {
                "use":"home",
                "line":[
                    "534 Erewhon St",
                    "sqw"
                ],
                "city":"PleasantVille",
                "district":"Rainbow",
                "state":"Vic",
                "postalCode":"3999",
                "country":"Australia"
            },
            {
                "use":"work",
                "line":[
                    "33[0] 6th St"
                ],
                "city":"Melbourne",
                "district":"Rainbow",
                "state":"Vic",
                "postalCode":"3000",
                "country":"Australia"
            }
        ]
    };

public function main() {
    string fPath = "Patient.address[4].city";
    fhirpath:FhirPathResult newFhirPathResult = fhirpath:getFhirPathResult(patient, fPath);
    if newFhirPathResult?.result is null {
        json outcome = newFhirPathResult?.resultenError;
        io:println(outcome.toString());
    }
    else {
        json outcome = newFhirPathResult?.result;
        io:println(outcome.toString());
    }
}
