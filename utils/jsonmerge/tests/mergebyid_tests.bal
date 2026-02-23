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

@test:Config {}
function testComplexMergeByIdStrategy() {
    // Create complex updates JSON object with nested arrays
    json updatesJson = {
        "companyName": "TechCorp",
        "employees": [
            {
                "id": 1,
                "name": "John Doe",
                "department": "Engineering",
                "skills": ["Java", "Python"],
                "projects": [
                    {
                        "projectId": "P001",
                        "name": "Project Alpha",
                        "status": "In Progress"
                    }
                ]
            },
            {
                "id": 2,
                "name": "Jane Smith",
                "department": "Marketing",
                "skills": ["SEO", "Content Writing"]
            }
        ],
        "location": "San Francisco"
    };

    // Create complex original JSON object with nested arrays
    json originalJson = {
        "companyName": "TechCorp Inc",
        "employees": [
            {
                "id": 1,
                "name": "John Doe",
                "department": "Engineering",
                "salary": 75000,
                "projects": [
                    {
                        "projectId": "P001",
                        "name": "Project Alpha",
                        "budget": 100000
                    }
                ]
            },
            {
                "id": 3,
                "name": "Bob Johnson",
                "department": "Sales",
                "salary": 65000
            }
        ],
        "founded": 2010
    };

    // Define IDs map for merging strategy
    map<string[]> idsMap = {
        "employees": ["id"],
        "employees.projects": ["projectId"]
    };

    // Perform deep merge with mergeById strategy
    json|error mergeResult = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Complex MergeById Strategy ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if mergeResult is json {
        io:println("Result: " + mergeResult.toJsonString());
    } else {
        io:println("Error: " + mergeResult.message());
    }

}

@test:Config {}
function testEmptyArraysMerge() {
    json updatesJson = {
        "items": [],
        "name": "Updates"
    };

    json originalJson = {
        "items": [],
        "description": "original"
    };

    map<string[]> idsMap = {
        "items": ["id"]
    };

    json|error result = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Empty Arrays Merge ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testTypeMismatchArrayToObject() {
    json updatesJson = {
        "data": [1, 2, 3]
    };

    json originalJson = {
        "data": {
            "type": "object",
            "value": "test"
        }
    };

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Type Mismatch - Array to Object ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testTypeMismatchObjectToArray() {
    json updatesJson = {
        "data": {
            "type": "object",
            "value": "updates"
        }
    };

    json originalJson = {
        "data": ["item1", "item2"]
    };

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Type Mismatch - Object to Array ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testPrimitiveToArrayMerge() {
    json updatesJson = {
        "tags": "important"
    };

    json originalJson = {
        "tags": ["urgent", "priority"]
    };

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Primitive to Array Merge ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testMissingIdFieldsInArray() {
    json updatesJson = {
        "users": [
            {
                "id": 1,
                "name": "Alice"
            },
            {
                "name": "Bob"
            }
        ]
    };

    json originalJson = {
        "users": [
            {
                "id": 1,
                "email": "alice@example.com"
            },
            {
                "id": 2,
                "name": "Charlie"
            }
        ]
    };

    map<string[]> idsMap = {
        "users": ["id"]
    };

    json|error result = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Missing ID Fields in Array ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }
}

@test:Config {}
function testPrimitiveArrayMerge() {
    json updatesJson = {
        "numbers": [1, 2, 3],
        "strings": ["a", "b"]
    };

    json originalJson = {
        "numbers": [4, 5, 6],
        "strings": ["c", "d"]
    };

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Primitive Array Merge ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testNestedObjectMerge() {
    json updatesJson = {
        "config": {
            "dataoriginal": {
                "host": "localhost",
                "port": 5432
            },
            "cache": {
                "enabled": true
            }
        }
    };

    json originalJson = {
        "config": {
            "dataoriginal": {
                "host": "remote-host",
                "username": "admin"
            },
            "logging": {
                "level": "info"
            }
        }
    };

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Nested Object Merge ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testEmptyUpdatesObject() {
    json updatesJson = {};

    json originalJson = {
        "name": "original",
        "items": [1, 2, 3]
    };

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Empty Updates Object ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testEmptyoriginalObject() {
    json updatesJson = {
        "name": "Updates",
        "items": [1, 2, 3]
    };

    json originalJson = {};

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Empty original Object ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}


@test:Config {}
function testNonObjectUpdatesError() {
    json updatesJson = "not an object";

    json originalJson = {
        "name": "original"
    };

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Non-Object Updates Error ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testMixedArrayElementTypes() {
    json updatesJson = {
        "items": [
            {
                "id": 1,
                "type": "object"
            },
            "primitive_string",
            42,
            true
        ]
    };

    json originalJson = {
        "items": [
            {
                "id": 1,
                "name": "Item 1"
            },
            "another_string",
            100
        ]
    };

    map<string[]> idsMap = {
        "items": ["id"]
    };

    json|error result = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Mixed Array Element Types ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testDeepNestedArrayMerge() {
    json updatesJson = {
        "level1": {
            "level2": {
                "items": [
                    {
                        "id": "A",
                        "data": "updates_data"
                    }
                ]
            }
        }
    };

    json originalJson = {
        "level1": {
            "level2": {
                "items": [
                    {
                        "id": "A",
                        "metadata": "original_metadata"
                    },
                    {
                        "id": "B",
                        "data": "original_only"
                    }
                ]
            }
        }
    };

    map<string[]> idsMap = {
        "level1.level2.items": ["id"]
    };

    json|error result = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Deep Nested Array Merge ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testAppendStrategyWithArrays() {
    json updatesJson = {
        "tags": ["new", "feature"],
        "categories": ["tech"]
    };

    json originalJson = {
        "tags": ["existing", "old"],
        "categories": ["business", "finance"]
    };

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Append Strategy with Arrays ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testNullValuesHandling() {
    json updatesJson = {
        "name": "Updates",
        "value": (),
        "data": {
            "field1": "test"
        }
    };

    json originalJson = {
        "name": (),
        "description": "original",
        "data": {
            "field2": "value"
        }
    };

    json|error result = mergeJson(originalJson, updatesJson, ());

    io:println("=== Test Case: Null Values Handling ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if result is json {
        io:println("Result: " + result.toJsonString());
    } else {
        io:println("Error: " + result.message());
    }

}

@test:Config {}
function testCompositeKeyMergeWithMultipleIds() {
    // Create updates JSON with composite key elements (id + code)
    json updatesJson = {
        "products": [
            {
                "id": 1,
                "code": "PROD_A",
                "name": "Product Alpha",
                "category": "Electronics",
                "price": 299.99,
                "features": ["Wireless", "Portable"]
            },
            {
                "id": 2,
                "code": "PROD_B",
                "name": "Product Beta",
                "category": "Software",
                "price": 99.99
            },
            {
                "id": 1,
                "code": "PROD_C",
                "name": "Product Charlie",
                "category": "Hardware",
                "price": 199.99
            }
        ],
        "metadata": {
            "source": "inventory_system"
        }
    };

    // Create original JSON with some matching and non-matching composite keys
    json originalJson = {
        "products": [
            {
                "id": 1,
                "code": "PROD_A",
                "name": "Product Alpha Original",
                "description": "High-quality electronics",
                "stock": 50,
                "supplier": "TechSupplier Inc"
            },
            {
                "id": 2,
                "code": "PROD_X",
                "name": "Product X-ray",
                "category": "Medical",
                "price": 1999.99
            },
            {
                "id": 3,
                "code": "PROD_D",
                "name": "Product Delta",
                "category": "Automotive",
                "price": 499.99
            }
        ],
        "metadata": {
            "original": "warehouse_system",
            "lastUpdated": "2024-01-15"
        }
    };

    // Define IDs map with composite key - need both id AND code to match
    map<string[]> idsMap = {
        "products": ["id", "code"] // Composite key: id + code
    };

    json|error mergeResult = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Composite Key Merge (ID + Code) ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if mergeResult is json {
        io:println("Result: " + mergeResult.toJsonString());
    } else {
        io:println("Error: " + mergeResult.message());
    }
    io:println("");
}

@test:Config {}
function testMultipleFieldMatchingScenario() {
    // Create updates with users having both userId and departmentCode
    json updatesJson = {
        "users": [
            {
                "userId": "U001",
                "departmentCode": "ENG",
                "name": "Alice Johnson",
                "role": "Senior Developer",
                "skills": ["Java", "React", "AWS"],
                "projects": [
                    {
                        "projectId": "P100",
                        "role": "Lead"
                    }
                ]
            },
            {
                "userId": "U002",
                "departmentCode": "MKT",
                "name": "Bob Smith",
                "role": "Marketing Manager",
                "campaigns": ["Campaign A", "Campaign B"]
            },
            {
                "userId": "U001",
                "departmentCode": "SAL",
                "name": "Alice Sales",
                "role": "Sales Rep"
            }
        ]
    };

    // Create original with some matching composite keys
    json originalJson = {
        "users": [
            {
                "userId": "U001",
                "departmentCode": "ENG",
                "name": "Alice Johnson",
                "email": "alice.johnson@company.com",
                "salary": 95000,
                "startDate": "2020-03-15",
                "projects": [
                    {
                        "projectId": "P100",
                        "budget": 50000
                    },
                    {
                        "projectId": "P200",
                        "role": "Contributor"
                    }
                ]
            },
            {
                "userId": "U003",
                "departmentCode": "HR",
                "name": "Carol White",
                "role": "HR Manager",
                "email": "carol.white@company.com"
            },
            {
                "userId": "U002",
                "departmentCode": "FIN",
                "name": "Bob Finance",
                "role": "Financial Analyst"
            }
        ]
    };

    // This demonstrates matching on both userId AND departmentCode
    map<string[]> idsMap = {
        "users": ["userId", "departmentCode"], // Composite key
        "users.projects": ["projectId"]
    };

    json|error mergeResult = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Multiple Field Matching (UserID + DepartmentCode) ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if mergeResult is json {
        io:println("Result: " + mergeResult.toJsonString());
    } else {
        io:println("Error: " + mergeResult.message());
    }
    io:println("");
}

@test:Config {}
function testTripleCompositeKeyScenario() {
    // Create updates with elements requiring 3 fields to match
    json updatesJson = {
        "transactions": [
            {
                "accountId": "ACC001",
                "transactionType": "DEBIT",
                "currency": "USD",
                "amount": 150.00,
                "description": "Online Purchase",
                "merchant": "Amazon"
            },
            {
                "accountId": "ACC001",
                "transactionType": "CREDIT",
                "currency": "USD",
                "amount": 500.00,
                "description": "Salary Deposit"
            },
            {
                "accountId": "ACC002",
                "transactionType": "DEBIT",
                "currency": "EUR",
                "amount": 75.50,
                "description": "ATM Withdrawal"
            }
        ]
    };

    json originalJson = {
        "transactions": [
            {
                "accountId": "ACC001",
                "transactionType": "DEBIT",
                "currency": "USD",
                "timestamp": "2024-01-15T10:30:00Z",
                "status": "COMPLETED",
                "fees": 2.50
            },
            {
                "accountId": "ACC001",
                "transactionType": "DEBIT",
                "currency": "EUR",
                "amount": 200.00,
                "description": "International Transfer"
            },
            {
                "accountId": "ACC003",
                "transactionType": "CREDIT",
                "currency": "USD",
                "amount": 1000.00,
                "description": "Bonus Payment"
            }
        ]
    };

    // Triple composite key: accountId + transactionType + currency
    map<string[]> idsMap = {
        "transactions": ["accountId", "transactionType", "currency"]
    };

    json|error mergeResult = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Triple Composite Key (AccountID + Type + Currency) ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if mergeResult is json {
        io:println("Result: " + mergeResult.toJsonString());
    } else {
        io:println("Error: " + mergeResult.message());
    }
    io:println("");
}

@test:Config {}
function testPartialCompositeKeyMatch() {
    // Test case where some elements have partial composite key matches
    json updatesJson = {
        "orders": [
            {
                "orderId": "ORD001",
                "customerId": "CUST001",
                "status": "PROCESSING",
                "items": ["Item A", "Item B"],
                "total": 299.99
            },
            {
                "orderId": "ORD002",
                "status": "SHIPPED",
                "items": ["Item C"],
                "total": 99.99
            },
            {
                "customerId": "CUST002",
                "status": "PENDING",
                "items": ["Item D"],
                "total": 199.99
            }
        ]
    };

    json originalJson = {
        "orders": [
            {
                "orderId": "ORD001",
                "customerId": "CUST001",
                "shippingAddress": "123 Main St",
                "paymentMethod": "Credit Card",
                "createdDate": "2024-01-10"
            },
            {
                "orderId": "ORD003",
                "customerId": "CUST003",
                "status": "DELIVERED",
                "total": 399.99
            }
        ]
    };

    // Composite key requiring both orderId AND customerId
    map<string[]> idsMap = {
        "orders": ["orderId", "customerId"]
    };

    json|error mergeResult = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Partial Composite Key Match ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if mergeResult is json {
        io:println("Result: " + mergeResult.toJsonString());
    } else {
        io:println("Error: " + mergeResult.message());
    }
    io:println("");
}

@test:Config {}
function testNestedCompositeKeyMerge() {
    // Test nested arrays with composite keys
    json updatesJson = {
        "departments": [
            {
                "deptId": "ENG",
                "name": "Engineering",
                "employees": [
                    {
                        "empId": "E001",
                        "teamCode": "BACKEND",
                        "name": "John Developer",
                        "skills": ["Java", "Spring"]
                    },
                    {
                        "empId": "E002",
                        "teamCode": "FRONTEND",
                        "name": "Jane UI",
                        "skills": ["React", "CSS"]
                    }
                ]
            }
        ]
    };

    json originalJson = {
        "departments": [
            {
                "deptId": "ENG",
                "budget": 500000,
                "employees": [
                    {
                        "empId": "E001",
                        "teamCode": "BACKEND",
                        "salary": 85000,
                        "startDate": "2022-01-15"
                    },
                    {
                        "empId": "E001",
                        "teamCode": "DEVOPS",
                        "name": "John DevOps",
                        "salary": 90000
                    }
                ]
            }
        ]
    };

    // Composite keys at multiple levels
    map<string[]> idsMap = {
        "departments": ["deptId"],
        "departments.employees": ["empId", "teamCode"]
    };

    json|error mergeResult = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Nested Composite Key Merge ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if mergeResult is json {
        io:println("Result: " + mergeResult.toJsonString());
    } else {
        io:println("Error: " + mergeResult.message());
    }
    io:println("");
}

@test:Config {}
function testMixedSingleAndCompositeKeys() {
    // Test mixing single and composite keys in same structure
    json updatesJson = {
        "customers": [
            {
                "customerId": "C001",
                "name": "Alice Corp",
                "orders": [
                    {
                        "orderId": "O001",
                        "productCode": "P100",
                        "quantity": 5,
                        "unitPrice": 29.99
                    }
                ]
            }
        ],
        "suppliers": [
            {
                "supplierId": "S001",
                "name": "Tech Supplies Inc",
                "contact": "tech@supplies.com"
            }
        ]
    };

    json originalJson = {
        "customers": [
            {
                "customerId": "C001",
                "address": "123 Business Ave",
                "orders": [
                    {
                        "orderId": "O001",
                        "productCode": "P100",
                        "shippingCost": 5.99,
                        "status": "SHIPPED"
                    },
                    {
                        "orderId": "O002",
                        "productCode": "P200",
                        "quantity": 2
                    }
                ]
            }
        ],
        "suppliers": [
            {
                "supplierId": "S001",
                "rating": 4.5,
                "verified": true
            }
        ]
    };

    // Mix of single and composite keys
    map<string[]> idsMap = {
        "customers": ["customerId"], // Single key
        "suppliers": ["supplierId"], // Single key
        "customers.orders": ["orderId", "productCode"] // Composite key
    };

    json|error mergeResult = mergeJson(originalJson, updatesJson, idsMap);

    io:println("=== Test Case: Mixed Single and Composite Keys ===");
    io:println("Updates: " + updatesJson.toJsonString());
    io:println("Original: " + originalJson.toJsonString());
    if mergeResult is json {
        io:println("Result: " + mergeResult.toJsonString());
    } else {
        io:println("Error: " + mergeResult.message());
    }
    io:println("");
}

@test:Config {}
function testComplexNestedJsonMerge() {
    // Create complex updates JSON with multiple levels of nesting
    json updatesJson = {
        "company": {
            "name": "TechCorp Solutions",
            "departments": [
                {
                    "deptId": "ENG001",
                    "name": "Engineering",
                    "budget": 750000,
                    "employees": [
                        {
                            "empId": "E001",
                            "name": "Alice Johnson",
                            "role": "Senior Developer",
                            "skills": ["Java", "Python", "React"],
                            "projects": [
                                {
                                    "projectId": "P100",
                                    "name": "Mobile App",
                                    "status": "In Progress",
                                    "tasks": [
                                        {
                                            "taskId": "T001",
                                            "title": "UI Design",
                                            "priority": "High"
                                        },
                                        {
                                            "taskId": "T002",
                                            "title": "Backend API",
                                            "priority": "Medium"
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "empId": "E002",
                            "name": "Bob Smith",
                            "role": "DevOps Engineer",
                            "skills": ["Docker", "Kubernetes"]
                        }
                    ]
                },
                {
                    "deptId": "MKT001",
                    "name": "Marketing",
                    "budget": 300000,
                    "campaigns": [
                        {
                            "campaignId": "C001",
                            "name": "Product Launch",
                            "channels": ["Social Media", "Email"]
                        }
                    ]
                }
            ]
        },
        "metadata": {
            "version": "2.0",
            "lastUpdated": "2024-01-15"
        }
    };

    // Create complex original JSON with overlapping and additional data
    json originalJson = {
        "company": {
            "name": "TechCorp Inc",
            "founded": 2015,
            "departments": [
                {
                    "deptId": "ENG001",
                    "name": "Engineering Department",
                    "location": "Building A",
                    "headCount": 25,
                    "employees": [
                        {
                            "empId": "E001",
                            "name": "Alice Johnson",
                            "email": "alice@techcorp.com",
                            "salary": 95000,
                            "projects": [
                                {
                                    "projectId": "P100",
                                    "name": "Mobile Application",
                                    "budget": 150000,
                                    "deadline": "2024-06-30",
                                    "tasks": [
                                        {
                                            "taskId": "T001",
                                            "title": "UI Design",
                                            "assignee": "Alice",
                                            "estimatedHours": 40
                                        },
                                        {
                                            "taskId": "T003",
                                            "title": "Testing",
                                            "priority": "Low"
                                        }
                                    ]
                                },
                                {
                                    "projectId": "P200",
                                    "name": "Web Portal",
                                    "status": "Planning"
                                }
                            ]
                        },
                        {
                            "empId": "E003",
                            "name": "Carol White",
                            "role": "QA Engineer",
                            "email": "carol@techcorp.com"
                        }
                    ]
                },
                {
                    "deptId": "HR001",
                    "name": "Human Resources",
                    "budget": 200000,
                    "policies": [
                        {
                            "policyId": "POL001",
                            "name": "Remote Work Policy",
                            "effective": "2024-01-01"
                        }
                    ]
                }
            ]
        },
        "metadata": {
            "version": "1.5",
            "createdBy": "System Admin"
        }
    };

    // Define complex keys map for nested array merging
    map<string[]> keysMap = {
        "company.departments": ["deptId"],
        "company.departments.employees": ["empId"],
        "company.departments.employees.projects": ["projectId"],
        "company.departments.employees.projects.tasks": ["taskId"],
        "company.departments.campaigns": ["campaignId"],
        "company.departments.policies": ["policyId"]
    };

    // Perform deep merge
    json|error mergeResult = mergeJson(originalJson, updatesJson, keysMap);

    io:println("=== Complex Nested JSON Merge Test ===");
    io:println("Updates JSON:");
    io:println(updatesJson.toJsonString());
    io:println("");
    io:println("Original JSON:");
    io:println(originalJson.toJsonString());
    io:println("");
    io:println("Keys Map:");
    io:println(keysMap.toString());
    io:println("");

    if mergeResult is json {
        io:println("Merge Result:");
        io:println(mergeResult.toJsonString());
        io:println("");

        // Additional verification can be added here
        map<json> resultMap = <map<json>>mergeResult;
        test:assertTrue(resultMap.hasKey("company"), "Result should have company key");
        test:assertTrue(resultMap.hasKey("metadata"), "Result should have metadata key");

    } else {
        io:println("Merge Error:");
        io:println(mergeResult.message());
        test:assertFail("Merge should not fail for valid inputs");
    }
}

@test:Config {}
function testDeeplyNestedArraysWithCompositeKeys() {
    // Test case with composite keys and deeply nested arrays
    json updatesJson = {
        "organization": {
            "regions": [
                {
                    "regionId": "US-WEST",
                    "name": "US West Coast",
                    "offices": [
                        {
                            "officeId": "SF001",
                            "city": "San Francisco",
                            "teams": [
                                {
                                    "teamId": "T001",
                                    "department": "Engineering",
                                    "members": [
                                        {
                                            "memberId": "M001",
                                            "role": "Lead",
                                            "name": "John Doe",
                                            "certifications": [
                                                {
                                                    "certId": "AWS001",
                                                    "name": "AWS Solutions Architect",
                                                    "level": "Professional"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ]
        }
    };

    json originalJson = {
        "organization": {
            "regions": [
                {
                    "regionId": "US-WEST",
                    "name": "US West Region",
                    "timezone": "PST",
                    "offices": [
                        {
                            "officeId": "SF001",
                            "city": "San Francisco",
                            "address": "123 Tech Street",
                            "teams": [
                                {
                                    "teamId": "T001",
                                    "department": "Engineering",
                                    "budget": 500000,
                                    "members": [
                                        {
                                            "memberId": "M001",
                                            "role": "Senior Lead",
                                            "email": "john.doe@company.com",
                                            "certifications": [
                                                {
                                                    "certId": "AWS001",
                                                    "name": "AWS Solutions Architect",
                                                    "expiryDate": "2025-12-31"
                                                },
                                                {
                                                    "certId": "GCP001",
                                                    "name": "Google Cloud Professional",
                                                    "level": "Associate"
                                                }
                                            ]
                                        },
                                        {
                                            "memberId": "M002",
                                            "role": "Developer",
                                            "name": "Jane Smith"
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ]
        }
    };

    // Complex nested keys mapping
    map<string[]> keysMap = {
        "organization.regions": ["regionId"],
        "organization.regions.offices": ["officeId"],
        "organization.regions.offices.teams": ["teamId"],
        "organization.regions.offices.teams.members": ["memberId"],
        "organization.regions.offices.teams.members.certifications": ["certId"]
    };

    json|error mergeResult = mergeJson(originalJson, updatesJson, keysMap);

    io:println("=== Deeply Nested Arrays with Composite Keys Test ===");
    io:println("Updates JSON:");
    io:println(updatesJson.toJsonString());
    io:println("");
    io:println("Original JSON:");
    io:println(originalJson.toJsonString());
    io:println("");

    if mergeResult is json {
        io:println("Merge Result:");
        io:println(mergeResult.toJsonString());
    } else {
        io:println("Merge Error:");
        io:println(mergeResult.message());
        test:assertFail("Deep nested merge should not fail");
    }
    io:println("");
}

@test:Config {}
function testMixedDataTypesInNestedArrays() {
    // Test case with mixed data types in nested structures
    json updatesJson = {
        "application": {
            "modules": [
                {
                    "moduleId": "AUTH",
                    "name": "Authentication Module",
                    "components": [
                        {
                            "componentId": "LOGIN",
                            "type": "UI",
                            "properties": {
                                "theme": "dark",
                                "features": ["2FA", "SSO"]
                            },
                            "dependencies": [
                                {
                                    "depId": "JWT_LIB",
                                    "version": "2.0.0",
                                    "configs": [
                                        {
                                            "configId": "SECRET",
                                            "value": "updated_secret",
                                            "encrypted": true
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "settings": {
                "debug": true,
                "logLevel": "INFO"
            }
        }
    };

    json originalJson = {
        "application": {
            "name": "Enterprise App",
            "version": "1.0.0",
            "modules": [
                {
                    "moduleId": "AUTH",
                    "name": "Authentication",
                    "enabled": true,
                    "components": [
                        {
                            "componentId": "LOGIN",
                            "type": "UI Component",
                            "status": "Active",
                            "properties": {
                                "theme": "light",
                                "timeout": 300
                            },
                            "dependencies": [
                                {
                                    "depId": "JWT_LIB",
                                    "version": "1.5.0",
                                    "source": "npm",
                                    "configs": [
                                        {
                                            "configId": "SECRET",
                                            "value": "default_secret",
                                            "description": "JWT signing secret"
                                        },
                                        {
                                            "configId": "EXPIRY",
                                            "value": "24h",
                                            "type": "duration"
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "settings": {
                "debug": false,
                "environment": "production"
            }
        }
    };

    map<string[]> keysMap = {
        "application.modules": ["moduleId"],
        "application.modules.components": ["componentId"],
        "application.modules.components.dependencies": ["depId"],
        "application.modules.components.dependencies.configs": ["configId"]
    };

    json|error mergeResult = mergeJson(originalJson, updatesJson, keysMap);

    io:println("=== Mixed Data Types in Nested Arrays Test ===");
    io:println("Updates JSON:");
    io:println(updatesJson.toJsonString());
    io:println("");
    io:println("Original JSON:");
    io:println(originalJson.toJsonString());
    io:println("");

    if mergeResult is json {
        io:println("Merge Result:");
        io:println(mergeResult.toJsonString());
    } else {
        io:println("Merge Error:");
        io:println(mergeResult.message());
        test:assertFail("Mixed data types merge should not fail");
    }
    io:println("");
}
