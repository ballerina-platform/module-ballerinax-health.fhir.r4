# Da Vinci Payer Data Exchange (PDex) FHIR R4 Module

This module provides support for the [Da Vinci Payer Data Exchange (PDex) Implementation Guide v2.2.0](https://hl7.org/fhir/us/davinci-pdex/).

It includes:
- **`$bulk-member-match`** – Type-level operation on `Group` (`[base]/Group/$bulk-member-match`). Enables payers to match multiple members against another payer's records in bulk. Defined in the PDex IG.
- **`$davinci-data-export`** – Instance-level operation on `Group` (`[base]/Group/[id]/$davinci-data-export`). Exports payer member health data asynchronously. Defined in the Da Vinci ATR IG (used in PDex payer-to-payer exchange).

## Usage

Implement the `BulkMemberMatcher` object type to handle `$bulk-member-match` requests:

```ballerina
public isolated class MyBulkMatcher {
    *davincipdex220:BulkMemberMatcher;

    public isolated function matchMembers(davincipdex220:BulkMemberMatchResources resources)
            returns davincipdex220:BulkMemberMatchResult|r4:FHIRError {
        // Custom matching logic
    }
}
```

Implement `DaVinciDataExporter` to handle `$davinci-data-export` requests:

```ballerina
public isolated class MyDataExporter {
    *davincipdex220:DaVinciDataExporter;

    public isolated function initiateExport(string? groupId, davincipdex220:DataExportParameters params)
            returns davincipdex220:DataExportJob|r4:FHIRError {
        // Initiate async bulk export and return polling URL
    }
}
```
