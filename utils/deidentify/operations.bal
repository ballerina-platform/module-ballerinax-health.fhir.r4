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

# Star Mask Operation
#
# + value - The input value to be masked.
# + return - The masked value.
isolated function starMaskOperation(json value) returns json|error {
    return "*****";
}

# Encrypt Operation
#
# + value - The input value to be encrypted.
# + return - The encrypted value.
isolated function encryptOperation(json value) returns json|error {
    if value is string {
        string|DeIdentificationError encryptedValue = encryptWithKey(value);
        if encryptedValue is DeIdentificationError {
            return error("Error occurred during encryption.", value = value);
        }
        return encryptedValue;
    }
    return error("Invalid input provided for encryptOperation.", value = value.toString());
}

# Hash Operation
#
# + value - The input value to be hashed.
# + return - The hashed value.
isolated function hashOperation(json value) returns json|error {
    if value is string {
        string|DeIdentificationError hashedValue = hashWithKey(value);
        if hashedValue is DeIdentificationError {
            return error("Error occurred during hashing.", value = value);
        }
        return hashedValue;
    }
    return error("Invalid input provided for hashOperation.", value = value.toString());
}
