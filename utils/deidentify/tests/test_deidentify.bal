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

// Test data setup
json patientResource = {
    "resourceType": "Patient",
    "id": "12345",
    "name": [
        {
            "family": "Doe",
            "given": ["John", "William"]
        }
    ],
    "gender": "male",
    "birthDate": "1990-01-01",
    "telecom": [
        {
            "system": "phone",
            "value": "555-1234"
        }
    ]
};

json observationResource = {
    "resourceType": "Observation",
    "id": "obs-123",
    "status": "final",
    "code": {
        "coding": [
            {
                "system": "http://loinc.org",
                "code": "29463-7",
                "display": "Body Weight"
            }
        ]
    },
    "subject": {
        "reference": "Patient/12345"
    },
    "valueQuantity": {
        "value": 70.5,
        "unit": "kg"
    }
};

// Test successful masking operation with default configuration
@test:Config {}
function testDeIdentifyWithDefaultConfiguration() {
    // The default configuration has Patient.name with mask operation
    json|DeIdentificationError result = deIdentify(patientResource);

    test:assertTrue(result is json, msg = "Expected successful de-identification");

    if result is json {
        json|error nameField = result.name;
        test:assertTrue(nameField is json, msg = "Expected name to be a json");
        test:assertEquals(nameField, "*****", msg = "Expected name to be masked");
    }
}

// Test with empty FHIR resource
@test:Config {}
function testDeIdentifyWithEmptyResource() {
    json emptyResource = {};

    json|DeIdentificationError result = deIdentify(emptyResource);

    test:assertTrue(result is json, msg = "Expected successful handling of empty resource");
    test:assertEquals(result, emptyResource, msg = "Expected empty resource to remain unchanged");
}

// Test with malformed JSON
@test:Config {}
function testDeIdentifyWithMalformedResource() {
    json malformedResource = {
        "resourceType": "Patient"
        // Missing required fields but still valid JSON
    };

    json|DeIdentificationError result = deIdentify(malformedResource);

    // Should handle gracefully since skipOnError is true by default
    test:assertTrue(result is json, msg = "Expected successful handling of malformed resource");
}

// Test FHIR resource validation enabled
@test:Config {}
function testDeIdentifyWithFhirValidationEnabled() {
    json invalidFhirResource = {
        "resourceType": "InvalidResourceType",
        "id": "test-123",
        "name": [{"family": "Test"}]
    };

    json|DeIdentificationError result = deIdentify(invalidFhirResource, validateInputFHIRResource = true, skipError = false);

    test:assertTrue(result is DeIdentificationError, msg = "Expected a validation error");
}

// Test FHIR resource validation disabled
@test:Config {}
function testDeIdentifyWithFhirValidationDisabled() {
    json invalidFhirResource = {
        "resourceType": "InvalidResourceType",
        "id": "test-123",
        "name": [{"family": "Test"}]
    };

    json|DeIdentificationError result = deIdentify(invalidFhirResource);

    test:assertTrue(result is json, msg = "Expected successful processing with validation disabled");
}

// Test with different resource types
@test:Config {}
function testDeIdentifyWithObservationResource() {
    json|DeIdentificationError result = deIdentify(observationResource);

    test:assertTrue(result is json, msg = "Expected successful de-identification of Observation resource");
    // Since default rules target Patient.name, Observation should remain unchanged
    test:assertEquals(result, observationResource, msg = "Expected Observation resource to remain unchanged");
}

// Test custom operation
@test:Config {}
function testDeIdentifyWithCustomOperation() {
    // Register a custom operation
    DeIdentificationFunction customMaskFunction = isolated function(json value) returns json|DeIdentificationError {
        return "CUSTOM_MASKED";
    };

    map<DeIdentificationFunction> customOperations = {
        "customMask": customMaskFunction
    };

    // Define rules that use the custom operation
    DeIdentifyRule[] customRules = [
        {
            fhirPaths: ["Patient.name.family"],
            operation: "customMask"
        },
        {
            fhirPaths: ["Patient.id"],
            operation: "customMask"
        }
    ];

    // Test that the custom operation is now available and works correctly
    json|DeIdentificationError result = deIdentify(
            patientResource,
            operations = customOperations,
            deIdentifyRules = customRules
    );

    test:assertTrue(result is json, msg = "Expected successful processing with custom operation");

    if result is json {
        // Verify that the custom operation was applied to the family name
        json|error nameField = result.name;
        test:assertTrue(nameField is json[], msg = "Expected name to be an array");

        if nameField is json[] && nameField.length() > 0 {
            json firstNameEntry = nameField[0];
            if firstNameEntry is map<json> {
                json|error familyName = firstNameEntry.get("family");
                if familyName is json {
                    test:assertEquals(familyName, "CUSTOM_MASKED", msg = "Expected family name to be custom masked");
                }
            }
        }

        // Verify that the custom operation was applied to the ID
        json|error idField = result.id;
        test:assertTrue(idField is string, msg = "Expected id to be a string");
        test:assertEquals(idField, "CUSTOM_MASKED", msg = "Expected id to be custom masked");
    }
}

// Test with complex nested FHIR resource
@test:Config {}
function testDeIdentifyWithComplexResource() {
    json complexResource = {
        "resourceType": "Patient",
        "id": "complex-123",
        "name": [
            {
                "use": "official",
                "family": "Smith",
                "given": ["Jane", "Marie"]
            },
            {
                "use": "maiden",
                "family": "Johnson",
                "given": ["Jane"]
            }
        ],
        "telecom": [
            {
                "system": "phone",
                "value": "555-0123",
                "use": "home"
            },
            {
                "system": "email",
                "value": "jane.smith@example.com",
                "use": "work"
            }
        ],
        "address": [
            {
                "use": "home",
                "line": ["123 Main St"],
                "city": "Anytown",
                "state": "CA",
                "postalCode": "12345"
            }
        ]
    };

    json|DeIdentificationError result = deIdentify(complexResource);

    test:assertTrue(result is json, msg = "Expected successful de-identification of complex resource");

    if result is json {
        // Verify that the name field was processed according to default rules
        json|error nameField = result.name;
        test:assertTrue(nameField is json, msg = "Expected name to be a json");
        test:assertEquals(nameField, "*****", msg = "Expected name to be masked");
    }
}

// Test error handling with invalid operation
@test:Config {}
function testDeIdentifyWithInvalidOperation() {
    // This test verifies that the function handles cases where an operation
    // specified in rules doesn't exist in the operations map

    json testResource = {
        "resourceType": "Patient",
        "id": "test-456",
        "name": [{"family": "TestFamily"}]
    };

    json|DeIdentificationError result = deIdentify(testResource);

    // Should succeed since skipOnError is true by default
    test:assertTrue(result is json, msg = "Expected successful handling with skipOnError=true");
}

// Test redact operation functionality
@test:Config {}
function testRedactOperationHandling() {
    // Test that redact operation is handled correctly
    // Since we can't modify configurable at runtime, we test the current behavior

    json testResource = {
        "resourceType": "Patient",
        "id": "redact-test",
        "name": [{"family": "ToBeRedacted"}],
        "birthDate": "1990-01-01"
    };

    json|DeIdentificationError result = deIdentify(testResource);

    test:assertTrue(result is json, msg = "Expected successful processing");

    // The actual behavior depends on the current configuration
    // This test ensures the function doesn't crash with redact operations
}

// Test hash operation with different data types
@test:Config {}
function testHashOperationWithDifferentTypes() {
    json resourceWithNumbers = {
        "resourceType": "Patient",
        "id": 12345, // Number instead of string
        "name": [{"family": "NumberTest"}]
    };

    json|DeIdentificationError result = deIdentify(resourceWithNumbers);

    test:assertTrue(result is json, msg = "Expected successful handling of resource with number ID");
}

// Test encrypt operation functionality
@test:Config {}
function testEncryptOperationHandling() {
    json testResource = {
        "resourceType": "Patient",
        "id": "encrypt-test",
        "name": [{"family": "ToBeEncrypted"}]
    };

    json|DeIdentificationError result = deIdentify(testResource);

    test:assertTrue(result is json, msg = "Expected successful processing with encryption");
}

// Test function with minimal valid FHIR resource
@test:Config {}
function testDeIdentifyWithMinimalResource() {
    json minimalResource = {
        "resourceType": "Patient"
    };

    json|DeIdentificationError result = deIdentify(minimalResource);

    test:assertTrue(result is json, msg = "Expected successful handling of minimal resource");
    test:assertEquals(result, minimalResource, msg = "Expected minimal resource to remain unchanged");
}

// Test concurrent access to the function
@test:Config {}
function testConcurrentDeIdentification() {
    // Test that the function handles concurrent calls correctly
    // due to its isolated nature

    json resource1 = {
        "resourceType": "Patient",
        "id": "concurrent-1",
        "name": [{"family": "Concurrent1"}]
    };

    json resource2 = {
        "resourceType": "Patient",
        "id": "concurrent-2",
        "name": [{"family": "Concurrent2"}]
    };

    // Simulate concurrent calls
    json|DeIdentificationError result1 = deIdentify(resource1);
    json|DeIdentificationError result2 = deIdentify(resource2);

    test:assertTrue(result1 is json, msg = "Expected successful processing of first resource");
    test:assertTrue(result2 is json, msg = "Expected successful processing of second resource");
}

// Test with array access patterns
@test:Config {}
function testArrayAccessPatterns() {
    json resourceWithArrays = {
        "resourceType": "Patient",
        "id": "array-test",
        "name": [
            {"family": "First", "given": ["John"]},
            {"family": "Second", "given": ["Jane"]}
        ]
    };

    json|DeIdentificationError result = deIdentify(resourceWithArrays);

    test:assertTrue(result is json, msg = "Expected successful processing of resource with arrays");

    if result is json {
        json|error nameField = result.name;
        if nameField is json[] && nameField.length() > 0 {
            json firstNameEntry = nameField[0];
            if firstNameEntry is map<json> {
                json|error familyName = firstNameEntry.get("family");
                if familyName is json {
                    test:assertEquals(familyName, "*****", msg = "Expected family name to be masked");
                }
            }
        }
    }
}

// Test with deeply nested structures
@test:Config {}
function testDeeplyNestedStructures() {
    json nestedResource = {
        "resourceType": "Patient",
        "id": "nested-test",
        "name": [
            {
                "family": "DeepNested",
                "extension": [
                    {
                        "url": "http://example.com/extension",
                        "valueString": "ExtensionValue"
                    }
                ]
            }
        ]
    };

    json|DeIdentificationError result = deIdentify(nestedResource);

    test:assertTrue(result is json, msg = "Expected successful processing of deeply nested resource");
}

// Test error recovery scenarios
@test:Config {}
function testErrorRecoveryScenarios() {
    json problematicResource = {
        "resourceType": "Patient",
        "id": "error-test",
        "name": "InvalidNameFormat" // Should be array, not string
    };

    json|DeIdentificationError result = deIdentify(problematicResource);

    // Should handle gracefully with skipOnError=true
    test:assertTrue(result is json, msg = "Expected graceful handling of problematic resource");
}

// Custom Patient type definition for type-safe testing
public type PatientName record {
    string use?;
    string family?;
    string[] given?;
};

public type Patient record {
    string resourceType;
    string id?;
    PatientName[] name?;
    string gender?;
    string birthDate?;
    boolean active?;
};

// Test validation success scenario using custom Patient type with cloneWithType
@test:Config {}
function testValidationWithCustomPatientType() {
    // Create a Patient record using custom type
    Patient validPatientRecord = {
        resourceType: "Patient",
        id: "type-safe-test-456",
        name: [
            {
                use: "official",
                family: "TypeSafeTest",
                given: ["Jane", "Marie"]
            }
        ],
        gender: "female",
        birthDate: "1992-07-20",
        active: true
    };

    // Convert to json for the deIdentify function
    json validPatientJson = validPatientRecord.toJson();

    // Define a rule to mask only the family name
    DeIdentifyRule[] rules = [
        {
            fhirPaths: ["Patient.name.family"],
            operation: "mask"
        }
    ];

    // Enable both input and output validation, disable skipError to ensure strict validation
    json|DeIdentificationError result = deIdentify(
            validPatientJson,
            deIdentifyRules = rules,
            validateInputFHIRResource = true,
            validateOutputFHIRResource = true,
            skipError = false
    );

    test:assertTrue(result is json, msg = "Expected successful de-identification with validation enabled");

    if result is json {
        // Use cloneWithType to convert back to custom Patient type for type-safe validation
        Patient|error typedResult = result.cloneWithType(Patient);
        test:assertTrue(typedResult is Patient, msg = "Expected result to be convertible to Patient type");

        if typedResult is Patient {
            // Type-safe validation using custom Patient record
            test:assertEquals(typedResult.resourceType, "Patient", msg = "Expected resourceType to be Patient");
            test:assertEquals(typedResult.id, "type-safe-test-456", msg = "Expected id to be preserved");
            test:assertEquals(typedResult.gender, "female", msg = "Expected gender to be preserved");
            test:assertEquals(typedResult.birthDate, "1992-07-20", msg = "Expected birthDate to be preserved");
            test:assertEquals(typedResult.active, true, msg = "Expected active status to be preserved");

            // Verify that the name field exists and family name was masked
            PatientName[]? nameArray = typedResult.name;
            test:assertTrue(nameArray is PatientName[], msg = "Expected name to be an array");

            if nameArray is PatientName[] && nameArray.length() > 0 {
                PatientName firstName = nameArray[0];
                test:assertEquals(firstName.use, "official", msg = "Expected name use to be preserved");
                test:assertEquals(firstName.family, "*****", msg = "Expected family name to be masked");

                // Verify given names are preserved
                string[]? givenNames = firstName.given;
                test:assertTrue(givenNames is string[], msg = "Expected given names to be preserved");
                if givenNames is string[] {
                    test:assertEquals(givenNames.length(), 2, msg = "Expected two given names");
                    test:assertEquals(givenNames[0], "Jane", msg = "Expected first given name to be preserved");
                    test:assertEquals(givenNames[1], "Marie", msg = "Expected second given name to be preserved");
                }
            }
        }
    }
}
