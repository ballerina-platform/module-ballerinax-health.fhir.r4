# FHIR R4 Utils - De-Identification Package

A highly extensible Ballerina package for de-identifying FHIR resources using FHIRPath expressions. This utility provides built-in de-identification operations and also allows developers to implement custom de-identification functions while maintaining FHIR compliance.

## Features

- **FHIRPath-based Rules**: Use FHIRPath expressions to target specific fields in FHIR resources to de-identify
- **Built-in Operations**: Support for mask, encrypt, hash, and redact operations
- **Custom Deidentification Function support**: Provide your own de-identification functions and configure to use them
- **Bundle Support**: Handles both single FHIR resources and FHIR Bundles
- **Highly Configurable**: Easily configure rules and settings via a configuration file or programmatically
- **Input FHIR resource validation**: Optional FHIR input resource validation
- **Output FHIR resource validation**: Optional FHIR output resource validation
- **Error Handling**: Configurable error handling with skip-on-error capability
- **Thread Safe**: Isolated functions for concurrent operations

# Usage

Import the package in your Ballerina project and start using the de-identification functionality.

```ballerina
import ballerinax/health.fhir.r4utils.deidentify;
```

## Quick Start
By default, the package is configured to mask the `Patient.name` field. In a new ballerina project, you can use the following code to see it in action. Use `bal run` to execute the code.

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

    json|deidentify:DeIdentificationError result = deidentify:deIdentify(patientResource);

    if result is json {
        io:println("De-identified resource:");
        io:println(result.toJsonString());
    } else {
        io:println(`Error: ${result.message()}`);
    }
}
```

## Providing de-identification rules

The real usage of this package comes with the ability to define de-identification rules. There are two approaches:

1. You can provide de-identification rules in the `Config.toml` file under the `rules` section. Each rule consists of a list of FHIRPath expressions and a desired operation to perform.

Config.toml
```toml
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.id"]
operation = "mask"
```

Ballerina Code
```ballerina
json|deidentify:DeIdentificationError result = deidentify:deIdentify(patientResource);
```


2. You can also provide rules programmatically using the provided API. Use the `deIdentifyRules` parameter in the `deidentify:deIdentify` function to specify the rules. Rules should be an array  of `DeIdentifyRule` records, which contains `fhirPath` and `operation` fields.

Ballerina Code
```ballerina
deidentify:DeIdentifyRule[] rules = [
        {
            "fhirPaths": ["Patient.id"],
            "operation": "mask"
        }
    ];

json|deidentify:DeIdentificationError result = deidentify:deIdentify(patientResource, deIdentifyRules =  rules);
```

`fhirPaths`: Used to point to the specific elements in the FHIR resource you want to de-identify. Give a list of FHIR paths to apply the operation. Check out [FHIRPath documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath/latest) for more details on how to use FHIRPath expressions.

`operation`: Specifies the de-identification operation to perform on the targeted element. Similar to `mask`, there are several built-in de-identification operations available in the package, which you can use under `operation` in these rules.

## Built-in De-identification Operations

### 1. Mask Operation (`mask`)
Replaces sensitive data with asterisks (`*****`).

```toml
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.name", "Patient.address.line"]
operation = "mask"
```

### 2. Encrypt Operation (`encrypt`)
Encrypts data using AES-ECB encryption with a configurable key.

```toml
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.id"]
operation = "encrypt"
```

Important: Use `encryptKey` in Config.toml under `[ballerinax.health.fhir.r4utils.deidentify]` to configure the encryption key.

```toml
[ballerinax.health.fhir.r4utils.deidentify]
encryptKey = "your-secure-encrypt-key"
```
You can also set via an environment variable. Check the [ballerina documentation](https://ballerina.io/learn/provide-values-to-configurable-variables/#provide-via-environment-variables) for more details.

### 3. Hash Operation (`hash`)
Creates a hash of the data using HMAC-SHA256.

```toml
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.telecom.value"]
operation = "hash"
```

Important: Use `cryptoHashKey` in Config.toml under `[ballerinax.health.fhir.r4utils.deidentify]` to configure the hash key.

```toml
[ballerinax.health.fhir.r4utils.deidentify]
cryptoHashKey = "your-secure-hash-key"
```
You can also set via an environment variable. Check the [ballerina documentation](https://ballerina.io/learn/provide-values-to-configurable-variables/#provide-via-environment-variables) for more details.

### 4. Redact Operation (`redact`)
Completely removes the specified field from the resource.

```toml
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.address"]
operation = "redact"
```

## Extra configurations with Config.toml

You can set the following configurations in Config.toml to be applied globally. Check `Configurables` section in the package documentation for more details.

```toml
[ballerinax.health.fhir.r4utils.deidentify]
skipOnError = true
inputFHIRResourceValidation = true
outputFHIRResourceValidation = true
```

Without limiting to the built-in operations, you can create custom de-identification functions, and use them in your de-identification rules.

# Creating Custom De-identification Operations

The package allows you to implement custom de-identification logic by writing functions that conform to the `deidentify:DeIdentificationFunction`. Then you can provide these operations to the `deidentify:deIdentify` function to be used in your de-identification rules. You can configure these custom functions the same way mentioned above.

### Custom De-identification Operation Signature

```ballerina
isolated function FunctionName(json value) returns json|error
```

### Example: Implementing Custom De-identification Operations

```ballerina
import ballerina/crypto;

// Custom pseudonymization function
isolated function pseudonymizeFunction(json value) returns json|error {
    if value is string {
        // Generate a consistent pseudonym based on the original value
        byte[] hashedBytes = crypto:hashSha256(value.toBytes());
        string pseudonym = "PSEUDO_" + hashedBytes.toBase64();
        return pseudonym;
    }
    return error("Value is not a string", value = value);
}

// Custom date shifting function
isolated function shiftDateFunction(json value) returns json|error {
    if value is string {
        // Shift dates by a random number of days (simplified example)
        // In practice, you'd parse the date and shift consistently
        return "2024-01-01"; // Placeholder shifted date
    }
    return error("Value is not a string", value = value);
}

// Custom partial masking function
isolated function partialMaskFunction(json value) returns json|error {
    if value is string && value.length() > 4 {
        // Keep first 2 and last 2 characters, mask the middle
        string masked = value.substring(0, 2) + "***" + value.substring(value.length() - 2);
        return masked;
    }
    return error("Unsupported value type", value = value);
}
```

### Creating rules with custom operations

Update your `Config.toml` to use custom operations:

```toml
[ballerinax.health.fhir.r4utils.deidentify]
cryptoHashKey = "your-secure-hash-key"
encryptKey = "your-secure-encrypt-key"
skipOnError = true
inputFHIRResourceValidation = false
outputFHIRResourceValidation = false

# Custom de-identification rules
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.name.family"]
operation = "pseudonymize"

[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.name.given"]
operation = "mask"

[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.birthDate"]
operation = "removeDay"

[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.id"]
operation = "encrypt"  # Built-in operation

[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.address"]
operation = "redact"   # Built-in operation
```

Note: You can also create an array of de-identify rules and provide rules programmatically as mentioned above.

### Using Custom De-identification Operations
In order to use the custom de-identification operations, you need to create a map of type `map<deidentify:DeIdentificationFunction>` and pass it to the `deidentify:deIdentify` function under `operations` parameter. This map should be in the following format:

```ballerina
map<deidentify:DeIdentificationFunction> customOperations = {
    "pseudonymize": pseudonymizeFunction,
    "removeDay": removeDayFromDate,
    "mask": customMaskingFunction
};

```

Complete Example:
```ballerina
import ballerina/crypto;
import ballerina/io;
import ballerinax/health.fhir.r4utils.deidentify;
import ballerina/lang.regexp;

// Custom pseudonymization function
isolated function pseudonymizeFunction(json value) returns json|error {
    if value is string {
        // Generate a consistent pseudonym based on the original value
        byte[] hashedBytes = crypto:hashSha256(value.toBytes());
        string pseudonym = "PSEUDO_" + hashedBytes.toBase64();
        return pseudonym;
    }
    return error("Value is not a string", value = value);
}

// Custom function to remove the day from a date
isolated function removeDayFromDate(json value) returns json|error {
    if value is string {
        // Assuming the date is in the format "YYYY-MM-DD"
        // Split the string using "-" delimiter with regexp
        regexp:RegExp|error regexResult = regexp:fromString("-");
        if regexResult is error {
            return error("Error creating regex pattern", (), value.toString());
        }
        string[] parts = regexp:split(regexResult, value);
        if parts.length() == 3 {
            // Return the date with the day removed
            return parts[0] + "-" + parts[1];
        }
        // If the date format is not as expected, return a shifted date or an error
        io:println("Invalid date format, returning a shifted date.");
        return error("Invalid date format, returning a shifted date.", (), value.toString());
    }
    return error("Value is not a string", value = value);
}

// Custom partial masking function
isolated function customMaskingFunction(json value) returns json|error {
    return "** MASKED **";
}

public function main() {
    // Create a map of custom operations
    map<deidentify:DeIdentificationFunction> customOperations = {
        "pseudonymize": pseudonymizeFunction,
        "removeDay": removeDayFromDate,
        "mask": customMaskingFunction
    };

    // Now you can use these operations in your configuration
    json patient = {
        "resourceType": "Patient",
        "id": "patient-123",
        "name": [{"family": "Smith", "given": ["John"]}],
        "birthDate": "1990-05-15"
    };

    json|deidentify:DeIdentificationError result = deidentify:deIdentify(patient, operations = customOperations);
    if result is json {
        io:println("De-identified patient data: ", result);
    } else {
        io:println("Error during de-identification: ", result.message());
    }
}

```

## Bundle Support

The utility automatically detects and processes FHIR Bundles. You can pass a Bundle resource to the `deIdentify` function, and it will apply the de-identification rules to each entry in the Bundle. You can use the FHIR path expressions relative to the resource under bundle entries. For example use `Patient.id` to refer to the IDs of all the patient resources in the Bundle.

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

    json|deidentify:DeIdentificationError result = deidentify:deIdentify(bundleResource);
    io:println("De-identified bundle data: ", result);
}
```

## Best Practices

1. **Security**: Use strong, unique keys for encryption and hashing
2. **Consistency**: Ensure custom functions produce deterministic results
3. **Performance**: Optimize custom functions for high-volume processing
4. **Error Handling**: Implement robust error handling in custom functions
5. **Testing**: Write comprehensive tests for custom de-identification logic
6. **Compliance**: Ensure operations meet regulatory requirements (HIPAA, GDPR, etc.)
7. **Validation**: Use FHIR validation to ensure resource integrity before and after de-identification
