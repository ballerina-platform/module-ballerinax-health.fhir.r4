import ballerina/io;
import ballerina/test;

// Basic functionality tests
@test:Config {}
function testmergeJson_Primitives() returns error? {
    io:println("=== Test: Primitives ===");

    json src = {a: 1, b: 2};
    json base = {b: 3, c: 4};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {a: 1, b: 2, c: 4};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_NestedObjects() returns error? {
    io:println("=== Test: NestedObjects ===");

    json src = {a: {x: 1}, b: 2};
    json base = {a: {y: 2}, b: 3};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {a: {x: 1, y: 2}, b: 2};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_Arrays() returns error? {
    io:println("=== Test: Arrays ===");

    json src = {arr: [3, 4]};
    json base = {arr: [1, 2]};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {arr: [1, 2, 3, 4]};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_Mixed() returns error? {
    io:println("=== Test: Mixed ===");
    json src = {a: 1, b: [3], c: {x: 5}};
    json base = {b: [1, 2], c: {y: 6}};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {a: 1, b: [1, 2, 3], c: {x: 5, y: 6}};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Empty objects
@test:Config {}
function testmergeJson_EmptySource() returns error? {
    io:println("=== Test: EmptySource ===");
    json src = {};
    json base = {a: 1, b: 2};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {a: 1, b: 2};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_EmptyBase() returns error? {
    io:println("=== Test: Emptybase ===");
    json src = {a: 1, b: 2};
    json base = {};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {a: 1, b: 2};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_BothEmpty() returns error? {
    io:println("=== Test: BothEmpty ===");
    json src = {};
    json base = {};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Null values
@test:Config {}
function testmergeJson_NullValues() returns error? {
    io:println("=== Test: NullValues ===");
    json src = {a: null, b: 2};
    json base = {a: 1, c: null};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {a: null, b: 2, c: null};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_NullOverwrite() returns error? {
    io:println("=== Test: NullOverwrite ===");
    json src = {a: null};
    json base = {a: "value"};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {a: null};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Different data types
@test:Config {}
function testmergeJson_DifferentTypes() returns error? {
    io:println("=== Test: DifferentTypes ===");
    json src = {a: "string", b: 42, c: true};
    json base = {a: 1, b: false, c: "text"};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {"a": "string", "b": 42, "c": true};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Array to non-array conversion
@test:Config {}
function testmergeJson_ArrayToNonArray() returns error? {
    io:println("=== Test: ArrayToNonArray ===");
    json src = {a: [1, 2]};
    json base = {a: "string"};
    io:println("Source: ", src);
    io:println("Base: ", base);

    // json expected = {a: [1, 2]};
    json|error result = mergeJson(base, src);
    io:println("Result: ", result);
    test:assertTrue(result is error);
}

@test:Config {}
function testmergeJson_NonArrayToArray() returns error? {
    io:println("=== Test: NonArrayToArray ===");
    json src = {a: "string"};
    json base = {a: [1, 2]};
    io:println("Source: ", src);
    io:println("Base: ", base);

    // json expected = {a:[1,2,"string"]};
    json|error result = mergeJson(base, src);
    test:assertTrue(result is error);
}

// Edge case: Object to non-object conversion
@test:Config {}
function testmergeJson_ObjectToNonObject() returns error? {
    io:println("=== Test: ObjectToNonObject ===");
    json src = {a: {x: 1}};
    json base = {a: "string"};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    test:assertTrue(result is error);
}

@test:Config {}
function testmergeJson_NonObjectToObject() returns error? {
    io:println("=== Test: NonObjectToObject ===");
    json src = {a: "string"};
    json base = {a: {x: 1}};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    test:assertTrue(result is error);
}

// Edge case: Empty arrays
@test:Config {}
function testmergeJson_EmptyArrays() returns error? {
    io:println("=== Test: EmptyArrays ===");
    json src = {arr: []};
    json base = {arr: []};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {arr: []};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_EmptySourceArray() returns error? {
    io:println("=== Test: EmptySourceArray ===");
    json src = {arr: []};
    json base = {arr: [1, 2]};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {arr: [1, 2]};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

@test:Config {}
function testmergeJson_EmptyBaseArray() returns error? {
    io:println("=== Test: EmptyBaseArray ===");
    json src = {arr: [1, 2]};
    json base = {arr: []};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {arr: [1, 2]};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Deeply nested structures
@test:Config {}
function testmergeJson_DeeplyNested() returns error? {
    io:println("=== Test: DeeplyNested ===");
    json src = {
        level1: {
            level2: {
                level3: {
                    value: "src"
                }
            }
        }
    };
    json base = {
        level1: {
            level2: {
                level3: {
                    other: "base"
                }
            }
        }
    };
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {
        level1: {
            level2: {
                level3: {
                    value: "src",
                    other: "base"
                }
            }
        }
    };
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Complex nested arrays and objects
@test:Config {}
function testmergeJson_ComplexNested() returns error? {
    io:println("=== Test: ComplexNested ===");
    json src = {
        users: [
            {name: "Alice", age: 30}
        ],
        config: {
            settings: {
                theme: "dark"
            }
        }
    };
    json base = {
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
    io:println("Source: ", src);
    io:println("Base: ", base);

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
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Updated tests for non-object inputs - now expecting errors
@test:Config {}
function testmergeJson_NonObjectSource() {
    io:println("=== Test: NonObjectSource ===");
    json src = "string";
    json base = {a: 1, b: 2};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Source JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_ArraySource() {
    io:println("=== Test: ArraySource ===");
    json src = [1, 2, 3];
    json base = {a: 1, b: 2};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Source JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_PrimitiveSource() {
    io:println("=== Test: PrimitiveSource ===");
    json src = 42;
    json base = {a: 1, b: 2};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Source JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_NonObjectBase() {
    io:println("=== Test: NonObjectbase ===");
    json src = {a: 1, b: 2};
    json base = "string";
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Base JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_ArrayBase() {
    io:println("=== Test: Arraybase ===");
    json src = {a: 1, b: 2};
    json base = [1, 2, 3];
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Base JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_BothNonObjects() {
    io:println("=== Test: BothNonObjects ===");
    json src = "source";
    json base = "base";
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Source JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_BothArrays() {
    io:println("=== Test: BothArrays ===");
    json src = [1, 2];
    json base = [3, 4];
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Source JSON must be a valid JSON object");
    }
}

@test:Config {}
function testmergeJson_PrimitivesToPrimitive() {
    io:println("=== Test: PrimitivesToPrimitive ===");
    json src = 42;
    json base = "string";
    io:println("Source: ", src);
    io:println("Base: ", base);

    json|error result = mergeJson(base, src);
    io:println("Result: ", result);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "Source JSON must be a valid JSON object");
    }
}

// Edge case: Arrays with different types
@test:Config {}
function testmergeJson_MixedTypeArrays() returns error? {
    io:println("=== Test: MixedTypeArrays ===");
    json src = {arr: ["string", 42, true]};
    json base = {arr: [1, false, "text"]};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {arr: [1, false, "text", "string", 42, true]};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Arrays with nested objects
@test:Config {}
function testmergeJson_ArraysWithObjects() returns error? {
    io:println("=== Test: ArraysWithObjects ===");
    json src = {arr: [{id: 1, name: "Alice"}]};
    json base = {arr: [{id: 2, name: "Bob"}]};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {arr: [{id: 2, name: "Bob"}, {id: 1, name: "Alice"}]};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Boolean values
@test:Config {}
function testmergeJson_BooleanValues() returns error? {
    io:println("=== Test: BooleanValues ===");
    json src = {flag1: true, flag2: false};
    json base = {flag1: false, flag3: true};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json expected = {flag1: true, flag2: false, flag3: true};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Edge case: Numeric values (int, float, decimal)
@test:Config {}
function testmergeJson_NumericValues() returns error? {
    io:println("=== Test: NumericValues ===");
    json src = {intVal: 42, floatVal: 3.14, decimalVal: 2.5d};
    json base = {intVal: 10, floatVal: 1.0, otherVal: 100};
    json expected = {intVal: 42, floatVal: 3.14, decimalVal: 2.5d, otherVal: 100};
    json result = check mergeJson(base, src);
    io:println("Result: ", result);
    test:assertEquals(result, expected);
}

// Test to verify cloning behavior (base should not be modified)
@test:Config {}
function testmergeJson_CloningBehavior() returns error? {
    io:println("=== Test: CloningBehavior ===");
    json src = {a: 1};
    json base = {b: 2};
    io:println("Source: ", src);
    io:println("Base: ", base);

    json originalbase = base.clone();

    json result = check mergeJson(base, src);
    io:println("Result: ", result);

    // Verify base is not modified
    test:assertEquals(base, originalbase);

    // Verify result is correct
    json expected = {a: 1, b: 2};
    test:assertEquals(result, expected);
}

// Performance test with large nested structure
@test:Config {}
function testmergeJson_LargeStructure() returns error? {
    io:println("=== Test: LargeStructure ===");
    json src = {
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

    json base = {
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

    io:println("Source: ", src);
    io:println("Base: ", base);

    json result = check mergeJson(base, src);
    io:println("Result: ", result);

    // Verify the structure is merged correctly
    test:assertTrue(result is map<json>);
    map<json> resultMap = <map<json>>result;
    test:assertTrue(resultMap.hasKey("data"));
    test:assertTrue(resultMap.hasKey("config"));
}
