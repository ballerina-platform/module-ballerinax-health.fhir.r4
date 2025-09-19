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

import ballerina/crypto;
import ballerina/log;

# Function to hash a string using HMAC with SHA256 and a given key.
#
# + value - The string value to be hashed.
# + hashKey - The key to be used for hashing.
# + return - The hashed string or an error.
public isolated function hashWithKey(string value, string hashKey = cryptoHashKey) returns string|DeIdentificationError {
    byte[] input = value.toBytes();

    // The key used for the HMAC generation.
    byte[] key = hashKey.toBytes();

    // HMAC generation for the input value using the SHA256 hashing algorithm, and returning the HMAC value using the Hex encoding.
    byte[]|crypto:Error output = crypto:hmacSha256(input, key);
    if output is crypto:Error {
        log:printError("Error while hashing value", output);
        return createDeIdentificationError("Error while hashing with key");
    }
    log:printDebug("Successfully generated HMAC with SHA256");
    return output.toBase16();
};

# Function to encrypt a string using AES-ECB with a given key.
#
# + plaintext - The plaintext string to be encrypted.
# + keyString - The key to be used for encryption.
# + return - The encrypted string or an error.
public isolated function encryptWithKey(string plaintext, string keyString = encryptKey) returns string|DeIdentificationError {
    // Convert plaintext to bytes
    byte[] plaintextBytes = plaintext.toBytes();

    byte[16] aesKey = prepareAesKey(keyString);

    // Encrypt using AES-ECB
    byte[]|crypto:Error encryptedBytes = crypto:encryptAesEcb(plaintextBytes, aesKey);

    if encryptedBytes is crypto:Error {
        return createDeIdentificationError("Error while encrypting with key");
    }

    // Convert encrypted bytes to base16 string for storage/transmission
    return encryptedBytes.toBase16();
}

# Function to decrypt a string that was encrypted using AES-ECB with a given key.
#
# + encryptedText - The encrypted string in base16 format to be decrypted.
# + keyString - The key to be used for decryption.
# + return - The decrypted string or an error.
public isolated function decryptWithKey(string encryptedText, string keyString) returns string|DeIdentificationError {
    // Convert encrypted text from base16 back to bytes
    byte[] encryptedBytes = [];

    // Manual hex string to byte array conversion
    int textLength = encryptedText.length();
    if textLength % 2 != 0 {
        return error("Invalid encrypted text format: hex string length must be even");
    }

    foreach int i in 0 ..< (textLength / 2) {
        string hexPair = encryptedText.substring(i * 2, i * 2 + 2);

        // Convert hex pair to byte value manually
        int byteValue = 0;
        foreach int j in 0 ..< 2 {
            string hexChar = hexPair.substring(j, j + 1);
            int digitValue = 0;

            if hexChar >= "0" && hexChar <= "9" {
                int|error charCode = int:fromString(hexChar);
                if charCode is error {
                    return error("Invalid hex character: " + hexChar);
                }
                digitValue = charCode;
            } else if hexChar >= "A" && hexChar <= "F" {
                digitValue = hexChar.toCodePointInts()[0] - "A".toCodePointInts()[0] + 10;
            } else if hexChar >= "a" && hexChar <= "f" {
                digitValue = hexChar.toCodePointInts()[0] - "a".toCodePointInts()[0] + 10;
            } else {
                return error("Invalid hex character: " + hexChar);
            }

            byteValue = byteValue * 16 + digitValue;
        }

        encryptedBytes.push(<byte>byteValue);
    }

    byte[16] aesKey = prepareAesKey(keyString);

    // Decrypt using AES-ECB
    byte[]|crypto:Error decryptedBytes = crypto:decryptAesEcb(encryptedBytes, aesKey);

    if decryptedBytes is crypto:Error {
        return createDeIdentificationError(decryptedBytes.message());
    }

    // Convert decrypted bytes back to string
    string|error decryptedString = string:fromBytes(decryptedBytes);
    if decryptedString is error {
        return createDeIdentificationError(decryptedString.message());
    }

    return decryptedString;
}

# DeIdentificationError is the error object that is returned when an error occurs during the de-identification process.
public type DeIdentificationError distinct error;

# Method to create a DeIdentificationError
#
# + errorMsg - the reason for the occurrence of error
# + fhirPath - the fhirpath expression that is being evaluated
# + operation - parameter description
# + return - the error object
isolated function createDeIdentificationError(string errorMsg, string? fhirPath = (), string? operation = ()) returns DeIdentificationError {
    DeIdentificationError deIdentificationError = error(errorMsg, fhirPath = fhirPath, operation = operation);
    return deIdentificationError;
}

isolated function isEmptyResource(json fhirData) returns boolean {
    if fhirData is () {
        return true;
    }

    if fhirData is map<json> {
        // Check if the map is completely empty
        if fhirData.length() == 0 {
            return true;
        }
    }

    if fhirData is json[] {
        return fhirData.length() == 0;
    }

    if fhirData is string {
        string trimmedData = fhirData.trim();
        return trimmedData.length() == 0;
    }

    // For other types (int, float, decimal, boolean), they are not considered empty
    return false;
}

# Utility function to prepare a 16-byte AES key from a string
#
# + keyString - The key string to be prepared
# + return - A 16-byte array for AES-128
isolated function prepareAesKey(string keyString) returns byte[16] {
    byte[] keyBytes = keyString.toBytes();
    byte[16] aesKey = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    int keyLength = keyBytes.length() < 16 ? keyBytes.length() : 16;
    foreach int i in 0 ..< keyLength {
        aesKey[i] = keyBytes[i];
    }
    return aesKey;
}

# Function to modify the value at the path
public type DeIdentificationFunction isolated function (json param) returns json|error;

