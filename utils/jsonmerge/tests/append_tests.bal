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

import ballerina/io;
import ballerina/test;

// Basic functionality tests
@test:Config {}
function testmergeJson_Primitives() returns error? {
    io:println("=== Test: Primitives ===");

    json updates = {a: 1, b: 2};
    json original = {b: 3, c: 4};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {a: 1, b: 2, c: 4};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_NestedObjects() returns error? {
    io:println("=== Test: NestedObjects ===");

    json updates = {a: {x: 1}, b: 2};
    json original = {a: {y: 2}, b: 3};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {a: {x: 1, y: 2}, b: 2};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_Arrays() returns error? {
    io:println("=== Test: Arrays ===");

    json updates = {arr: [3, 4]};
    json original = {arr: [1, 2]};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {arr: [1, 2, 3, 4]};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_Mixed() returns error? {
    io:println("=== Test: Mixed ===");
    json updates = {a: 1, b: [3], c: {x: 5}};
    json original = {b: [1, 2], c: {y: 6}};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {a: 1, b: [1, 2, 3], c: {x: 5, y: 6}};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Empty objects
@test:Config {}
function testmergeJson_EmptyUpdates() returns error? {
    io:println("=== Test: EmptyUpdates ===");
    json updates = {};
    json original = {a: 1, b: 2};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {a: 1, b: 2};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_EmptyOriginal() returns error? {
    io:println("=== Test: EmptyOriginal ===");
    json updates = {a: 1, b: 2};
    json original = {};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {a: 1, b: 2};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_BothEmpty() returns error? {
    io:println("=== Test: BothEmpty ===");
    json updates = {};
    json original = {};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Null values
@test:Config {}
function testmergeJson_NullValues() returns error? {
    io:println("=== Test: NullValues ===");
    json updates = {a: null, b: 2};
    json original = {a: 1, c: null};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {a: null, b: 2, c: null};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_NullOverwrite() returns error? {
    io:println("=== Test: NullOverwrite ===");
    json updates = {a: null};
    json original = {a: "value"};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {a: null};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Different data types
@test:Config {}
function testmergeJson_DifferentTypes() returns error? {
    io:println("=== Test: DifferentTypes ===");
    json updates = {a: "string", b: 42, c: true};
    json original = {a: 1, b: false, c: "text"};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {"a": "string", "b": 42, "c": true};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Array to non-array conversion
@test:Config {}
function testmergeJson_ArrayToNonArray() returns error? {
    io:println("=== Test: ArrayToNonArray ===");
    json updates = {a: [1, 2]};
    json original = {a: "string"};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertTrue(result is error);
}

@test:Config {}
function testmergeJson_NonArrayToArray() returns error? {
    io:println("=== Test: NonArrayToArray ===");
    json updates = {a: "string"};
    json original = {a: [1, 2]};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    test:assertTrue(result is error);
}

// Edge case: Object to non-object conversion
@test:Config {}
function testmergeJson_ObjectToNonObject() returns error? {
    io:println("=== Test: ObjectToNonObject ===");
    json updates = {a: {x: 1}};
    json original = {a: "string"};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    test:assertTrue(result is error);
}

@test:Config {}
function testmergeJson_NonObjectToObject() returns error? {
    io:println("=== Test: NonObjectToObject ===");
    json updates = {a: "string"};
    json original = {a: {x: 1}};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    test:assertTrue(result is error);
}

// Edge case: Empty arrays
@test:Config {}
function testmergeJson_EmptyArrays() returns error? {
    io:println("=== Test: EmptyArrays ===");
    json updates = {arr: []};
    json original = {arr: []};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {arr: []};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_EmptyUpdatesArray() returns error? {
    io:println("=== Test: EmptyUpdatesArray ===");
    json updates = {arr: []};
    json original = {arr: [1, 2]};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {arr: [1, 2]};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_EmptyOriginalArray() returns error? {
    io:println("=== Test: EmptyOriginalArray ===");
    json updates = {arr: [1, 2]};
    json original = {arr: []};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {arr: [1, 2]};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Deeply nested structures
@test:Config {}
function testmergeJson_DeeplyNested() returns error? {
    io:println("=== Test: DeeplyNested ===");
    json updates = {
        level1: {
            level2: {
                level3: {
                    value: "updates"
                }
            }
        }
    };
    json original = {
        level1: {
            level2: {
                level3: {
                    other: "original"
                }
            }
        }
    };
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {
        level1: {
            level2: {
                level3: {
                    value: "updates",
                    other: "original"
                }
            }
        }
    };
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Complex nested arrays and objects
@test:Config {}
function testmergeJson_ComplexNested() returns error? {
    io:println("=== Test: ComplexNested ===");
    json updates = {
        users: [
            {name: "Alice", age: 30}
        ],
        config: {
            settings: {
                theme: "dark"
            }
        }
    };
    json original = {
        users: [
            {name: "Bob", age: 25}
        ],
        config: {
            settings: {
                language: "en"
            },
            version: "1.0"
        }
    };
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {
        users: [
            {name: "Bob", age: 25},
            {name: "Alice", age: 30}
        ],
        config: {
            settings: {
                theme: "dark",
                language: "en"
            },
            version: "1.0"
        }
    };
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Updated tests for non-object inputs - now expecting errors
@test:Config {}
function testmergeJson_NonObjectUpdates() {
    io:println("=== Test: NonObjectUpdates ===");
    json updates = "string";
    json original = {a: 1, b: 2};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Updates JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_ArrayUpdates() {
    io:println("=== Test: ArrayUpdates ===");
    json updates = [1, 2, 3];
    json original = {a: 1, b: 2};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Updates JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_PrimitiveUpdates() {
    io:println("=== Test: PrimitiveUpdates ===");
    json updates = 42;
    json original = {a: 1, b: 2};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Updates JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_NonObjectOriginal() {
    io:println("=== Test: NonObjectOriginal ===");
    json updates = {a: 1, b: 2};
    json original = "string";
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Original JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_ArrayOriginal() {
    io:println("=== Test: ArrayOriginal ===");
    json updates = {a: 1, b: 2};
    json original = [1, 2, 3];
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Original JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_BothNonObjects() {
    io:println("=== Test: BothNonObjects ===");
    json updates = "updates";
    json original = "original";
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Updates JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_BothArrays() {
    io:println("=== Test: BothArrays ===");
    json updates = [1, 2];
    json original = [3, 4];
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Updates JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_PrimitivesToPrimitive() {
    io:println("=== Test: PrimitivesToPrimitive ===");
    json updates = 42;
    json original = "string";
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json|error result = mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Updates JSON must be a valid JSON object");
    }
}

// Edge case: Arrays with different types
@test:Config {}
function testmergeJson_MixedTypeArrays() returns error? {
    io:println("=== Test: MixedTypeArrays ===");
    json updates = {arr: ["string", 42, true]};
    json original = {arr: [1, false, "text"]};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {arr: [1, false, "text", "string", 42, true]};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Arrays with nested objects
@test:Config {}
function testmergeJson_ArraysWithObjects() returns error? {
    io:println("=== Test: ArraysWithObjects ===");
    json updates = {arr: [{id: 1, name: "Alice"}]};
    json original = {arr: [{id: 2, name: "Bob"}]};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {arr: [{id: 2, name: "Bob"}, {id: 1, name: "Alice"}]};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Boolean values
@test:Config {}
function testmergeJson_BooleanValues() returns error? {
    io:println("=== Test: BooleanValues ===");
    json updates = {flag1: true, flag2: false};
    json original = {flag1: false, flag3: true};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json expected = {flag1: true, flag2: false, flag3: true};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Numeric values (int, float, decimal)
@test:Config {}
function testmergeJson_NumericValues() returns error? {
    io:println("=== Test: NumericValues ===");
    json updates = {intVal: 42, floatVal: 3.14, decimalVal: 2.5d};
    json original = {intVal: 10, floatVal: 1.0, otherVal: 100};
    json expected = {intVal: 42, floatVal: 3.14, decimalVal: 2.5d, otherVal: 100};
    json result = check mergeJson(original, updates);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Test to verify cloning behavior (original should not be modified)
@test:Config {}
function testmergeJson_CloningBehavior() returns error? {
    io:println("=== Test: CloningBehavior ===");
    json updates = {a: 1};
    json original = {b: 2};
    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json originaloriginal = original.clone();

    json result = check mergeJson(original, updates);
    io:println("Result: ", result);

    // Verify original is not modified
    test:assertEquals(original, originaloriginal);

    // Verify result is correct
    json expected = {a: 1, b: 2};
    test:assertEquals(result, expected);
}

// Performance test with large nested structure
@test:Config {}
function testmergeJson_LargeStructure() returns error? {
    io:println("=== Test: LargeStructure ===");
    json updates = {
        data: {
            users: [
                {id: 1, profile: {name: "User1", settings: {theme: "dark"}}},
                {id: 2, profile: {name: "User2", settings: {theme: "light"}}}
            ],
            metadata: {
                version: "2.0",
                features: ["feature1", "feature2"]
            }
        }
    };

    json original = {
        data: {
            users: [
                {id: 3, profile: {name: "User3", settings: {language: "en"}}}
            ],
            metadata: {
                version: "1.0",
                features: ["feature3"],
                timestamp: "2023-01-01"
            }
        },
        config: {
            debug: true
        }
    };

    io:println("Updates: ", updates);
    io:println("Original: ", original);

    json result = check mergeJson(original, updates);
    io:println("Result: ", result);

    // Verify the structure is merged correctly
    test:assertTrue(result is map<json>);
    map<json> resultMap = <map<json>>result;
    test:assertTrue(resultMap.hasKey("data"));
    test:assertTrue(resultMap.hasKey("config"));
}
