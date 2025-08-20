# FHIR De-Identification Utility

A highly extensible Ballerina package for de-identifying FHIR resources using FHIRPath expressions. This utility provides built-in de-identification operations and allows developers to implement custom de-identification functions while maintaining FHIR compliance.

## Features

- **FHIRPath-based Rules**: Use FHIRPath expressions to target specific fields in FHIR resources to de-identify
- **Built-in Operations**: Support for mask, encrypt, hash, and redact operations
- **Custom Functions**: Write and register your own de-identification functions
- **Bundle Support**: Handles both single FHIR resources and FHIR Bundles
- **Runtime Configuration**: Externally configurable rules and keys
- **FHIR Validation**: Optional FHIR resource validation
- **Error Handling**: Configurable error handling with skip-on-error capability
- **Thread Safe**: Isolated functions for concurrent operations

## Installation

Add the following dependency to your `Ballerina.toml`:

```toml
[[dependency]]
org = "ballerinax"
name = "health.fhir.r4utils.deidentify"
version = "1.0.0"
```

## Quick Start

```ballerina
import ballerinax/health.fhir.r4utils.deidentify;
import ballerina/io;

public function main() {
    json patientResource = {
        "resourceType": "Patient",
        "id": "12345",
        "name": [
            {
                "family": "Doe",
                "given": ["John"]
            }
        ],
        "gender": "male"
    };

    json|deidentify:DeIdentificationError result = deidentify:deIdentifyFhirData(patientResource);

    if result is json {
        io:println("De-identified resource:");
        io:println(result.toJsonString());
    } else {
        io:println(`Error: ${result.message()}`);
    }
}
```

## Creating Custom De-identification Functions

The package allows you to implement custom de-identification logic by writing functions that conform to the `ModificationFunction` type from the FHIRPath utilities:

### Custom Function Signature

```ballerina
import ballerinax/health.fhir.r4utils.fhirpath;

// The function signature for custom operations
public type ModificationFunction = fhirpath:ModificationFunction;
```

### Example: Implementing Custom Functions

```ballerina
import ballerinax/health.fhir.r4utils.fhirpath;
import ballerina/crypto;

// Custom pseudonymization function
isolated function pseudonymizeFunction(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        // Generate a consistent pseudonym based on the original value
        byte[] hashedBytes = crypto:hashSha256(value.toBytes());
        string pseudonym = "PSEUDO_" + hashedBytes.toBase64();
        return pseudonym;
    }
    return value;
}

// Custom date shifting function
isolated function shiftDateFunction(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        // Shift dates by a random number of days (simplified example)
        // In practice, you'd parse the date and shift consistently
        return "2024-01-01"; // Placeholder shifted date
    }
    return value;
}

// Custom partial masking function
isolated function partialMaskFunction(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string && value.length() > 4 {
        // Keep first 2 and last 2 characters, mask the middle
        string masked = value.substring(0, 2) + "***" + value.substring(value.length() - 2);
        return masked;
    }
    return "*****";
}
```

### Registering Custom Functions

```ballerina
import ballerinax/health.fhir.r4utils.fhirpath;

public function main() {
    // Create a map of custom operations
    map<fhirpath:ModificationFunction> customOperations = {
        "pseudonymize": pseudonymizeFunction,
        "shiftDate": shiftDateFunction,
        "partialMask": partialMaskFunction
    };
    
    // Register your custom functions
    deidentify:registerModificationFunctions(customOperations);
    
    // Now you can use these operations in your configuration
    json patient = {
        "resourceType": "Patient",
        "id": "patient-123",
        "name": [{"family": "Smith", "given": ["John"]}],
        "birthDate": "1990-05-15"
    };
    
    json|deidentify:DeIdentificationError result = deidentify:deIdentifyFhirData(patient);
}
```

### Configuration with Custom Functions

Update your `Config.toml` to use custom operations:

```toml
# Configuration for FHIR De-identification Utility
[ballerinax.health.fhir.r4utils.deidentify]
cryptoHashKey = "your-secure-hash-key"
encryptKey = "your-secure-encrypt-key"
skipOnError = true
fhirResourceValidation = true

# Custom de-identification rules
[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.name.family"
operation = "pseudonymize"

[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.name.given"
operation = "partialMask"

[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.birthDate"
operation = "shiftDate"

[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.id"
operation = "encrypt"  # Built-in operation

[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.address"
operation = "redact"   # Built-in operation
```

## Built-in Operations

### 1. Mask Operation
Replaces sensitive data with asterisks (`*****`).

```toml
[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.name"
operation = "mask"
```

### 2. Encrypt Operation
Encrypts data using AES-ECB encryption with a configurable key.

```toml
[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.id"
operation = "encrypt"
```

### 3. Hash Operation
Creates a hash of the data using HMAC-SHA256.

```toml
[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.telecom[0].value"
operation = "hash"
```

### 4. Redact Operation
Completely removes the specified field from the resource.

```toml
[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.address"
operation = "redact"
```

## Bundle Support

The utility automatically detects and processes FHIR Bundles:

```ballerina
json bundleResource = {
    "resourceType": "Bundle",
    "id": "bundle-example",
    "entry": [
        {
            "resource": {
                "resourceType": "Patient",
                "id": "patient-1",
                "name": [{"family": "Smith", "given": ["John"]}]
            }
        },
        {
            "resource": {
                "resourceType": "Patient",
                "id": "patient-2", 
                "name": [{"family": "Doe", "given": ["Jane"]}]
            }
        }
    ]
};

json|DeIdentificationError result = deIdentifyFhirData(bundleResource);
```

## Advanced Custom Function Examples

### Format-Preserving Encryption

```ballerina
import ballerina/regex;

isolated function formatPreservingEncrypt(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        // Preserve format for phone numbers, SSNs, etc.
        if regex:matches(value, "\\d{3}-\\d{3}-\\d{4}") {
            // Phone number format
            return "555-000-0000";
        } else if regex:matches(value, "\\d{3}-\\d{2}-\\d{4}") {
            // SSN format
            return "000-00-0000";
        }
        // Default encryption for other strings
        string|DeIdentificationError encrypted = encryptWithKey(value);
        return encrypted is string ? encrypted : value;
    }
    return value;
}
```

### Context-Aware De-identification

```ballerina
isolated function contextAwareFunction(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        // Different handling based on content type detection
        if value.includes("@") {
            // Email address
            string[] parts = regex:split(value, "@");
            if parts.length() == 2 {
                return "user***@" + parts[1];
            }
        } else if regex:matches(value, "\\d+") {
            // Numeric identifier
            return "ID" + crypto:hashSha256(value.toBytes()).toBase16().substring(0, 8);
        }
        // Default masking
        return "*****";
    }
    return value;
}
```

## API Reference

### Core Functions

#### `deIdentifyFhirData`
De-identifies a FHIR resource or Bundle based on configured rules.

```ballerina
public isolated function deIdentifyFhirData(
    json fhirResource, 
    boolean validateFHIRResource = fhirResourceValidation, 
    boolean skipError = skipOnError
) returns json|DeIdentificationError
```

**Parameters:**
- `fhirResource`: The FHIR resource or Bundle to de-identify
- `validateFHIRResource`: Whether to validate FHIR resource structure (default: from config)
- `skipError`: Whether to skip errors and continue processing (default: from config)

#### `registerModificationFunctions`
Register custom modification functions for additional operations.

```ballerina
public isolated function registerModificationFunctions(
    map<fhirpath:ModificationFunction> functions
)
```

### Utility Functions

#### `hashWithKey`
```ballerina
public isolated function hashWithKey(string value, string hashKey = cryptoHashKey) 
    returns string|DeIdentificationError
```

#### `encryptWithKey`
```ballerina
public isolated function encryptWithKey(string plaintext, string keyString = encryptKey) 
    returns string|DeIdentificationError
```

#### `decryptWithKey`
```ballerina
public isolated function decryptWithKey(string encryptedText, string keyString) 
    returns string|DeIdentificationError
```

## Configuration Options

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `cryptoHashKey` | string | "wso2-healthcare-hash" | Key used for hashing operations |
| `encryptKey` | string | "wso2-healthcare-encrypt" | Key used for encryption operations |
| `skipOnError` | boolean | true | Skip errors and continue processing |
| `fhirResourceValidation` | boolean | true | Validate FHIR resource structure |
| `fhirPathRules` | FHIRPathRule[] | Default mask rule | Array of de-identification rules |

## Error Handling

```ballerina
json|DeIdentificationError result = deIdentifyFhirData(patientResource);

if result is DeIdentificationError {
    io:println(`Error: ${result.message()}`);
    // Access additional error details
    string? fhirPath = result.detail()["fhirPath"];
    string? operation = result.detail()["operation"];
}
```

## Best Practices

1. **Security**: Use strong, unique keys for encryption and hashing
2. **Consistency**: Ensure custom functions produce deterministic results
3. **Performance**: Optimize custom functions for high-volume processing
4. **Error Handling**: Implement robust error handling in custom functions
5. **Testing**: Write comprehensive tests for custom de-identification logic
6. **Compliance**: Ensure operations meet regulatory requirements (HIPAA, GDPR, etc.)

## Dependencies

- **ballerina/crypto**: For encryption and hashing operations
- **ballerina/log**: For logging
- **ballerinax/health.fhir.r4utils.fhirpath**: For FHIRPath evaluation
