# FHIR Terminology Package

A package containing utilities to perform search, read interactions on FHIR terminologies, including code systems and value sets.

## Package Overview

FHIR Terminology Package is a collection of standardized terminologies, including code systems, value sets, concept maps and other related artifacts. These packages provide a comprehensive set of codes and concepts that allow for accurate representation and exchange of healthcare data within the FHIR ecosystem.

This package provides the following functionalities required for FHIR terminology related requirements.

1. Get by Id
2. Search CodeSystems and ValueSets
3. CodeSystem-lookup - Given a code/system, or a Coding, get additional details about the concept, including definition, status, designations, and properties. One of the products of this operation is a complete decomposition of a code from a structured terminology
4. ValueSet-expand - Get the definition of a value set.
5. ValueSet-validate-code - Validate that a coded value is in the set of codes allowed by a value set.
6. CodeSystem-subsumes - Test the subsumption(The meaning of the hierarchy of concepts as represented in this resource) relationship between code/Coding A and code/Coding B given the semantics of subsumption in the underlying code system.
7. ConceptMap-translate - Translate a code from one value set to another, based on the existing value set and concept maps resources.


## Translate Operation

The translate operation takes a source value set URL and a target value set URL as input along with a terminology service. The system must have a concept map
in it with the matching source and target value systems. There can be more than one concept maps that satisfies this condition. In any case, the matching concept
maps are used to translate the code/s provided inside the codeable concept. As the response, an r4:Parameters resource will be returned.

#### Sample Concept Map

```
{
    "resourceType": "ConceptMap",
    "id": "sc-account-status",
    "url": "http://hl7.org/fhir/ConceptMap/sc-account-status",
    "version": "4.0.1",
    "status": "draft",
    "sourceCanonical": "http://hl7.org/fhir/ValueSet/account-status",
    "targetCanonical": "http://hl7.org/fhir/ValueSet/resource-status",
    "group": [
        {
            "source": "http://hl7.org/fhir/account-status",
            "target": "http://hl7.org/fhir/resource-status",
            "element": [
                {
                    "code": "entered-in-error",
                    "target": [
                        {
                            "code": "error",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "active",
                    "target": [
                        {
                            "code": "active",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "on-hold",
                    "target": [
                        {
                            "code": "suspended",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "inactive",
                    "target": [
                        {
                            "code": "inactive",
                            "equivalence": "equivalent"
                        }
                    ]
                },
                {
                    "code": "unknown",
                    "target": [
                        {
                            "code": "unknown",
                            "equivalence": "equivalent"
                        }
                    ]
                }
            ]
        }
    ]
}
```

#### Sample code to execute translate operation

```
import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.terminology;

public function main() returns r4:FHIRParseError? {
    r4:uri valueSet1Url = "http://hl7.org/fhir/ValueSet/account-status";
    r4:uri valueSet2Url = "http://hl7.org/fhir/ValueSet/resource-status";
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                system: "http://hl7.org/fhir/account-status",
                code: "active"
            }
        ]
    };
    r4:Parameters|r4:OperationOutcome result = terminology:translate(valueSet1Url, valueSet2Url, codeableConcept);
    io:println(result);
}
```

#### Response

Parameters named "match" in the response contains the translated code/s with the target code system URL. The parameter named "source" indicates from which concept map the match was found.

```
{
    "resourceType": "Parameters",
    "parameter": [
        {
            "name": "match",
            "part": [
                {
                    "valueCode": "equivalent",
                    "name": "equivalent"
                },
                {
                    "name": "concept",
                    "valueCoding": {
                        "system": "http://hl7.org/fhir/resource-status",
                        "code": "active",
                        "userSelected": false
                    }
                },
                {
                    "name": "source",
                    "valueUri": "http://hl7.org/fhir/ConceptMap/sc-account-status"
                }
            ]
        },
        {
            "name": "result",
            "valueBoolean": true
        }
    ]
}
```