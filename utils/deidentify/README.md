# FHIR Resource De-Identification Package

A highly extensible Ballerina package for de-identifying FHIR resources using FHIRPath expressions. This utility provides built-in de-identification operations and allows developers to implement custom de-identification functions while maintaining FHIR compliance.

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Package Version      | 1.0.0                |
| Ballerina Version    | 2201.12.2            |

## Features

- **FHIRPath-based Rules**: Use FHIRPath expressions to target specific fields in FHIR resources to de-identify
- **Built-in Operations**: Support for mask, encrypt, hash, and redact operations
- **Custom Functions**: Write and register your own de-identification functions
- **Bundle Support**: Handles both single FHIR resources and FHIR Bundles
- **Runtime Configuration**: Externally configurable rules and keys
- **FHIR Validation**: Optional FHIR resource validation
- **Error Handling**: Configurable error handling with skip-on-error capability
- **Thread Safe**: Isolated functions for concurrent operations

## Usage

Import the package in your Ballerina project:

```ballerina
import ballerinax/health.fhir.r4utils.deidentify;
```

## Quick Start
By default the package is configured to mask all `Patient.name` fields. You can use the `deIdentifyFhirData` function to de-identify a FHIR resource or Bundle.

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

## Configuration
Create a `Config.toml` file to define de-identification rules and keys:

```toml
[ballerinax.health.fhir.r4utils.deidentify]
cryptoHashKey = "your-secure-hash-key"
encryptKey = "your-secure-encrypt-key"
skipOnError = true
fhirResourceValidation = true
```

## Built-in De-identification Operations
The package provides several built-in operations that can be applied to FHIR resources, upon configuration using FHIRPath expressions. You can configure which operations to use in which fhir path, in your `Config.toml` file under `fhirPathRules`.

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
fhirPath = "Patient.telecom.value"
operation = "hash"
```
Note: `Patient.telecom` is an array, so `Patient.telecom.value` points to all the `value` fields of each telecom entry, and the `hash` operation will be applied to each of them. i.e. Hashing all phone numbers.

### 4. Redact Operation
Completely removes the specified field from the resource.

```toml
[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.address"
operation = "redact"
```

## Configuration Options

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `cryptoHashKey` | string | "wso2-healthcare-hash" | Key used for hashing operations. Change in production. |
| `encryptKey` | string | "wso2-healthcare-encrypt" | Key used for encryption operations. Change in production. |
| `skipOnError` | boolean | true | Skip errors and continue processing |
| `fhirResourceValidation` | boolean | true | Validate FHIR resource structure |
| `fhirPathRules` | FHIRPathRule[] | Default mask rule | Array of de-identification rules |

After configuring all the rules, you can run the de-identification process as shown in the Quick Start section.

## Creating Custom De-identification Functions

The package allows you to implement custom de-identification logic by writing functions that conform to the `fhirpath:ModificationFunction` type from the FHIRPath utilities. Then you can register these functions to be used in your de-identification rules. You can configure these custom functions the same way mentioned above in your `Config.toml` file.

### Custom Function Signature

```ballerina
import ballerinax/health.fhir.r4utils.fhirpath;

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

### Configuration with Custom Functions

Update your `Config.toml` to use custom operations:

```toml
[ballerinax.health.fhir.r4utils.deidentify]
cryptoHashKey = "your-secure-hash-key"
encryptKey = "your-secure-encrypt-key"
skipOnError = true
fhirResourceValidation = false

# Custom de-identification rules
[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.name.family"
operation = "pseudonymize"

[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.name.given"
operation = "mask"

[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.birthDate"
operation = "removeDay"

[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.id"
operation = "encrypt"  # Built-in operation

[[ballerinax.health.fhir.r4utils.deidentify.fhirPathRules]]
fhirPath = "Patient.address"
operation = "redact"   # Built-in operation
```

### Registering & Using Custom Functions

```ballerina
import ballerina/crypto;
import ballerina/io;
import ballerinax/health.fhir.r4utils.deidentify;
import ballerinax/health.fhir.r4utils.fhirpath;
import ballerina/lang.regexp;

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

// Custom function to remove the day from a date
isolated function removeDayFromDate(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        // Assuming the date is in the format "YYYY-MM-DD"
        // Split the string using "-" delimiter with regexp
        regexp:RegExp|error regexResult = regexp:fromString("-");
        if regexResult is error {
            return fhirpath:createModificationFunctionError("Error creating regex pattern", (), value.toString());
        }
        string[] parts = regexp:split(regexResult, value);
        if parts.length() == 3 {
            // Return the date with the day removed
            return parts[0] + "-" + parts[1];
        }
        // If the date format is not as expected, return a shifted date or an error
        io:println("Invalid date format, returning a shifted date.");
        return fhirpath:createModificationFunctionError("Invalid date format, returning a shifted date.", (), value.toString());
    }
    return value;
}

// Custom partial masking function
isolated function customMaskingFunction(json value) returns json|fhirpath:ModificationFunctionError {
    return "** MASKED **";
}

public function main() {
    // Create a map of custom operations
    map<fhirpath:ModificationFunction> customOperations = {
        "pseudonymize": pseudonymizeFunction,
        "removeDay": removeDayFromDate,
        "mask": customMaskingFunction
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
    if result is json {
        io:println("De-identified patient data: ", result);
    } else {
        io:println("Error during de-identification: ", result.message());
    }
}

```

## Bundle Support

The utility automatically detects and processes FHIR Bundles:

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.deidentify;

public function main() {

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

    json|deidentify:DeIdentificationError result = deidentify:deIdentifyFhirData(bundleResource);
    io:println("De-identified bundle data: ", result);
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

Following utility functions are available for encryption, hashing, and other operations, and are used by the built-in de-identification operations.

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
Note: This function can be used to decrypt data that was encrypted by the built-in `encryptWithKey` function.

```ballerina
public isolated function decryptWithKey(string encryptedText, string keyString) 
    returns string|DeIdentificationError
```

## Error Handling

```ballerina
json|deidentify:DeIdentificationError result = deidentify:deIdentifyFhirData(patientResource);

if result is deidentify:DeIdentificationError {
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
