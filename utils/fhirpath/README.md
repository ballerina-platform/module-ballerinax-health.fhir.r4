# FHIR R4 Utils - FHIRPath Package

This package provides utilities for working with FHIR resources using FHIRPath expressions. It allows you to query, update, and manipulate FHIR resources in a type-safe manner using Ballerina.

## Package Overview

This package implements FHIRPath, a powerful expression language for querying and manipulating FHIR resources. It supports the FHIR R4 version and provides a set of functions to extract [FHIRPath expression](https://hl7.org/fhir/fhirpath.html) values, update resource values, and handle errors effectively.

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://hl7.org/fhir/fhirpath.html |

Refer to the [API Documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath) for detailed usage.

## Features

- **Query FHIR Resources**: Extract one or more values for a matching FHIRPath expression from FHIR resources
- **Update FHIR Resources**: Set values in FHIR resources at specified paths
- **Remove FHIR Resource Elements**: Remove elements from FHIR resources
- **Adding FHIR Resource Elements**: Support for creating new FHIR paths and adding elements to FHIR resources
- **Function-based Value Modification**: Apply custom functions to transform values during updates (useful for data masking, hashing, etc.)
- **Unified API**: Single function handles both direct value setting and function-based transformations
- **Validate FHIRPath Expressions**: Ensure that FHIRPath expressions are valid before evaluation
- **Validate FHIR Resources**: Ensure that FHIR resources provided and returned conform to the expected structure and types. (For more info visit https://central.ballerina.io/ballerinax/health.fhir.r4.validator/latest)
- **Error Handling**: Comprehensive error reporting for invalid paths or operations
- **Type Safety**: Strong typing support for Ballerina applications


## Usage Examples

### Basic FHIRPath Value Extraction

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

json patient = {
    "resourceType": "Patient",
    "id": "1",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        },
        {
            "use": "usual",
            "given": [
                "Jim"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    }
};

public function main() {
    // Get single value using FHIRPath
    json|error result = fhirpath:getValuesFromFhirPath(patient, "Patient.name[0].given[0]");
    if result is json {
        io:println("First given name: ", result);
    }
    // Get all given names from all name records
    json|error allGivenResult = fhirpath:getValuesFromFhirPath(patient, "Patient.name.given[0]");
    if allGivenResult is json {
        io:println("All first given names: ", allGivenResult);
    }
    // Handle errors
    json|error errorResult = fhirpath:getValuesFromFhirPath(patient, "Patient.invalidPath");
    if errorResult is error {
        io:println("Error: ", errorResult.message());
    }
}
```

### Updating FHIR Resources

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "active": true,
        "address": [
            {
                "use": "home",
                "line": ["123 Main St"],
                "city": "Anytown",
                "state": "CA",
                "postalCode": "12345"
            },
            {
                "use": "work",
                "line": ["456 Work St"],
                "city": "Worktown",
                "state": "CA",
                "postalCode": "67890"
            }
        ]
    };

    // Update a value in the FHIR resource
    json|error updateResult = fhirpath:setValuesToFhirPath(patient, "Patient.active", false);
    if updateResult is json {
        io:println("Updated patient after active status change: ", updateResult);
    }

    // Update multiple values in the FHIR resource
    json|error updatedAddresses = fhirpath:setValuesToFhirPath(patient, "Patient.address.line", "***", validateFHIRResource = false);
    if updatedAddresses is json {
        io:println("Updated patient after address line masking: ", updatedAddresses);
    }

    // Add a new value to the FHIR resource
    json|error newlyAdded = fhirpath:setValuesToFhirPath(patient, "Patient.gender", "male", validateFHIRResource = false);

    if newlyAdded is json {
        io:println("Updated patient after gender addition: ", newlyAdded);
    }
}

```

### Removing FHIR Resource Fields

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "active": true,
        "gender": "male",
        "name": [
            {
                "use": "official",
                "family": "Chalmers",
                "given": [
                    "Peter",
                    "James"
                ]
            },
            {
                "use": "usual",
                "family": "Fenders",
                "given": [
                    "Jim"
                ]
            }
        ]
    };

    // Remove a simple field
    json|error result = fhirpath:setValuesToFhirPath(patient, "Patient.gender", ());
    if result is json {
        io:println("Patient after removing gender: ", result);
    }

    // Remove multiple elements
    json|error multipleResult = fhirpath:setValuesToFhirPath(patient, "Patient.name.given", ());
    if multipleResult is json {
        io:println("Patient after removing all given names: ", multipleResult);
    }

    // Using low-level function for removal
    json|error directResult = fhirpath:setValuesToFhirPath(patient, "Patient.active", ());
    if directResult is json {
        io:println("Updated patient resource: ", directResult);
    }
}
```

### Function-based Value Modifications

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

// Define a custom modification function for data masking
isolated function maskOperation(json input) returns json|fhirpath:error {
    return "***MASKED***";
}

// Define a function to hash sensitive data
isolated function hashOperation(json input) returns json|fhirpath:error {
    if input is string {
        return "HASH_" + input.length().toString(); // Simple hash for example
    }
    return error("Expected string input for hashing", fhirPathValue = input.toString());
}

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "1",
        "name": [
            {
                "use": "official",
                "family": "Doe",
                "given": ["John", "Michael"]
            }
        ],
        "telecom": [
            {
                "system": "phone",
                "value": "+1-555-123-4567"
            },
            {
                "system": "email",
                "value": "john.doe@example.com"
            }
        ]
    };

    // Mask all phone numbers
    json|error maskedPhone = fhirpath:setValuesToFhirPath(patient, "Patient.telecom[0].value", maskOperation);
    if maskedPhone is json {
        io:println("Patient with masked phone: ", maskedPhone);
    }

    // Hash email addresses
    json|error hashedId = fhirpath:setValuesToFhirPath(patient, "Patient.id", hashOperation);
    if hashedId is json {
        io:println("Patient with hashed id: ", hashedId);
    }

    // Apply function to multiple values
    json|error maskedNames = fhirpath:setValuesToFhirPath(patient, "Patient.name.given", maskOperation, validateFHIRResource = false);
    if maskedNames is json {
        io:println("Patient with masked given names: ", maskedNames);
    }
}
```
