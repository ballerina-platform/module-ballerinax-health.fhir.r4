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

// Test data setup for Patient resources
json patient1 = {
    "resourceType": "Patient",
    "id": "patient-001",
    "name": [
        {
            "family": "Smith",
            "given": ["John", "Michael"]
        }
    ],
    "gender": "male",
    "birthDate": "1985-03-15",
    "telecom": [
        {
            "system": "phone",
            "value": "555-1234"
        }
    ]
};

json patient2 = {
    "resourceType": "Patient",
    "id": "patient-002",
    "name": [
        {
            "family": "Johnson",
            "given": ["Sarah", "Elizabeth"]
        }
    ],
    "gender": "female",
    "birthDate": "1990-07-22",
    "address": [
        {
            "line": ["123 Main St"],
            "city": "Springfield",
            "state": "IL"
        }
    ]
};

json patient3 = {
    "resourceType": "Patient",
    "id": "patient-003",
    "name": [
        {
            "family": "Williams",
            "given": ["Robert"]
        }
    ],
    "gender": "male"
};

// Test successful bundle de-identification with multiple Patient resources
@test:Config {}
function testBundleDeIdentificationWithMultiplePatients() {
    json bundleResource = {
        "resourceType": "Bundle",
        "id": "test-bundle-001",
        "type": "collection",
        "entry": [
            {
                "resource": patient1
            },
            {
                "resource": patient2
            },
            {
                "resource": patient3
            }
        ]
    };

    json|DeIdentificationError result = deIdentify(bundleResource);

    test:assertTrue(result is json, msg = "Expected successful bundle de-identification");

    if result is json {
        // Verify it's still a bundle
        json|error resourceType = result.resourceType;
        test:assertEquals(resourceType, "Bundle", msg = "Expected resource type to remain Bundle");

        // Verify bundle structure
        json|error entryField = result.entry;
        test:assertTrue(entryField is json[], msg = "Expected entry to be an array");

        if entryField is json[] {
            test:assertEquals(entryField.length(), 3, msg = "Expected 3 entries in bundle");

            // Check first patient de-identification
            json firstEntry = entryField[0];
            if firstEntry is map<json> {
                json|error resourceField = firstEntry.get("resource");
                if resourceField is map<json> {
                    json|error nameField = resourceField.get("name");
                    if nameField is json[] && nameField.length() > 0 {
                        json firstName = nameField[0];
                        if firstName is map<json> {
                            json|error familyName = firstName.get("family");
                            test:assertEquals(familyName, "*****", msg = "Expected first patient family name to be masked");
                        }
                    }
                }
            }

            // Check second patient de-identification
            json secondEntry = entryField[1];
            if secondEntry is map<json> {
                json|error resourceField = secondEntry.get("resource");
                if resourceField is map<json> {
                    json|error nameField = resourceField.get("name");
                    if nameField is json[] && nameField.length() > 0 {
                        json firstName = nameField[0];
                        if firstName is map<json> {
                            json|error familyName = firstName.get("family");
                            test:assertEquals(familyName, "*****", msg = "Expected second patient family name to be masked");
                        }
                    }
                }
            }
        }
    }
}

// Test bundle with mixed resource types (Patient and non-Patient)
@test:Config {}
function testBundleWithMixedResourceTypes() {
    json observationResource = {
        "resourceType": "Observation",
        "id": "obs-001",
        "status": "final",
        "subject": {
            "reference": "Patient/patient-001"
        }
    };

    json bundleResource = {
        "resourceType": "Bundle",
        "id": "mixed-bundle",
        "type": "collection",
        "entry": [
            {
                "resource": patient1
            },
            {
                "resource": observationResource
            },
            {
                "resource": patient2
            }
        ]
    };

    json|DeIdentificationError result = deIdentify(bundleResource);

    test:assertTrue(result is json, msg = "Expected successful processing of mixed bundle");

    if result is json {
        json|error entryField = result.entry;
        if entryField is json[] {
            test:assertEquals(entryField.length(), 3, msg = "Expected 3 entries in mixed bundle");

            // Verify Patient resources were de-identified
            json firstEntry = entryField[0];
            if firstEntry is map<json> {
                json|error resourceField = firstEntry.get("resource");
                if resourceField is map<json> {
                    json|error resourceType = resourceField.get("resourceType");
                    test:assertEquals(resourceType, "Patient", msg = "Expected first entry to be Patient");

                    json|error nameField = resourceField.get("name");
                    if nameField is json[] && nameField.length() > 0 {
                        json firstName = nameField[0];
                        if firstName is map<json> {
                            json|error familyName = firstName.get("family");
                            test:assertEquals(familyName, "*****", msg = "Expected Patient name to be masked");
                        }
                    }
                }
            }

            // Verify Observation resource remained unchanged
            json secondEntry = entryField[1];
            if secondEntry is map<json> {
                json|error resourceField = secondEntry.get("resource");
                if resourceField is map<json> {
                    json|error resourceType = resourceField.get("resourceType");
                    test:assertEquals(resourceType, "Observation", msg = "Expected second entry to be Observation");

                    json|error status = resourceField.get("status");
                    test:assertEquals(status, "final", msg = "Expected Observation status to remain unchanged");
                }
            }
        }
    }
}

// Test empty bundle
@test:Config {}
function testEmptyBundle() {
    json emptyBundle = {
        "resourceType": "Bundle",
        "id": "empty-bundle",
        "type": "collection",
        "entry": []
    };

    json|DeIdentificationError result = deIdentify(emptyBundle);

    test:assertTrue(result is json, msg = "Expected successful processing of empty bundle");

    if result is json {
        json|error entryField = result.entry;
        if entryField is json[] {
            test:assertEquals(entryField.length(), 0, msg = "Expected empty entry array");
        }
    }
}

// Test bundle without entry field
@test:Config {}
function testBundleWithoutEntryField() {
    json bundleWithoutEntry = {
        "resourceType": "Bundle",
        "id": "no-entry-bundle",
        "type": "collection"
    };

    json|DeIdentificationError result = deIdentify(bundleWithoutEntry);

    test:assertTrue(result is json, msg = "Expected successful processing of bundle without entry field");
    test:assertEquals(result, bundleWithoutEntry, msg = "Expected bundle to remain unchanged");
}

// Test bundle with invalid entry format
@test:Config {}
function testBundleWithInvalidEntryFormat() {
    json invalidBundle = {
        "resourceType": "Bundle",
        "id": "invalid-bundle",
        "type": "collection",
        "entry": "invalid-entry-format" // Should be array, not string
    };

    json|DeIdentificationError result = deIdentify(invalidBundle);

    test:assertTrue(result is DeIdentificationError, msg = "Expected error for invalid entry format");
}

// Test bundle with entry missing resource field
@test:Config {}
function testBundleWithMissingResourceField() {
    json bundleWithMissingResource = {
        "resourceType": "Bundle",
        "id": "missing-resource-bundle",
        "type": "collection",
        "entry": [
            {
                "resource": patient1
            },
            {
                "fullUrl": "Patient/patient-002"
                // Missing resource field
            },
            {
                "resource": patient3
            }
        ]
    };

    json|DeIdentificationError result = deIdentify(bundleWithMissingResource, skipError = true);

    test:assertTrue(result is json, msg = "Expected successful processing with skipError=true");

    if result is json {
        json|error entryField = result.entry;
        if entryField is json[] {
            test:assertEquals(entryField.length(), 3, msg = "Expected all 3 entries to be preserved");

            // First entry should be de-identified
            json firstEntry = entryField[0];
            if firstEntry is map<json> {
                json|error resourceField = firstEntry.get("resource");
                if resourceField is map<json> {
                    json|error nameField = resourceField.get("name");
                    if nameField is json[] && nameField.length() > 0 {
                        json firstName = nameField[0];
                        if firstName is map<json> {
                            json|error familyName = firstName.get("family");
                            test:assertEquals(familyName, "*****", msg = "Expected first patient name to be masked");
                        }
                    }
                }
            }

            // Second entry should remain unchanged (no resource field)
            json secondEntry = entryField[1];
            if secondEntry is map<json> {
                json|error fullUrl = secondEntry.get("fullUrl");
                test:assertEquals(fullUrl, "Patient/patient-002", msg = "Expected fullUrl to remain unchanged");
            }
        }
    }
}

// Test bundle with skipError=false and missing resource field
@test:Config {}
function testBundleWithMissingResourceFieldNoSkip() {
    json bundleWithMissingResource = {
        "resourceType": "Bundle",
        "id": "missing-resource-bundle-no-skip",
        "type": "collection",
        "entry": [
            {
                "resource": patient1
            },
            {
                "fullUrl": "Patient/patient-002"
                // Missing resource field
            }
        ]
    };

    json|DeIdentificationError result = deIdentify(bundleWithMissingResource, validateInputFHIRResource = true, skipError = false);

    test:assertTrue(result is DeIdentificationError, msg = "Expected error with skipError=false");
}

// Test large bundle with many Patient resources
@test:Config {}
function testLargeBundleWithManyPatients() {
    json[] entries = [];

    // Create 50 Patient resources
    foreach int i in 0 ..< 50 {
        json patientResource = {
            "resourceType": "Patient",
            "id": "patient-" + i.toString().padZero(3),
            "name": [
                {
                    "family": "TestFamily" + i.toString(),
                    "given": ["TestGiven" + i.toString()]
                }
            ],
            "gender": i % 2 == 0 ? "male" : "female"
        };

        entries.push({
            "resource": patientResource
        });
    }

    json largeBundle = {
        "resourceType": "Bundle",
        "id": "large-bundle",
        "type": "collection",
        "entry": entries
    };

    json|DeIdentificationError result = deIdentify(largeBundle);

    test:assertTrue(result is json, msg = "Expected successful processing of large bundle");

    if result is json {
        json|error entryField = result.entry;
        if entryField is json[] {
            test:assertEquals(entryField.length(), 50, msg = "Expected all 50 entries to be processed");

            // Verify random entries are de-identified
            json tenthEntry = entryField[9];
            if tenthEntry is map<json> {
                json|error resourceField = tenthEntry.get("resource");
                if resourceField is map<json> {
                    json|error nameField = resourceField.get("name");
                    if nameField is json[] && nameField.length() > 0 {
                        json firstName = nameField[0];
                        if firstName is map<json> {
                            json|error familyName = firstName.get("family");
                            test:assertEquals(familyName, "*****", msg = "Expected 10th patient name to be masked");
                        }
                    }
                }
            }
        }
    }
}
