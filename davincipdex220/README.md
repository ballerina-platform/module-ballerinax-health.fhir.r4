## Overview

Da Vinci Payer Data Exchange (PDex) (2.2.0) FHIR R4 package for payer-to-payer member matching and data export workflows. It provides typed contracts for PDex operations that support member identity resolution and asynchronous clinical data exchange.

> **Trademark Notice:** FHIR(R) and the FHIR(R) logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7(R).

### Key Features

- Typed contracts for `$bulk-member-match` on `Group`
- Typed contracts for `$davinci-data-export` on `Group/[id]`
- Supports asynchronous export initiation and job tracking response models
- Integrates with existing FHIR R4 error handling types

# FHIR R4 health.fhir.r4.davincipdex220 package

## Package Overview

|                      |                                      |
| -------------------- | ------------------------------------ |
| FHIR version         | R4                                   |
| Implementation Guide | https://hl7.org/fhir/us/davinci-pdex/ |

**Note:**
**This package only supports FHIR JSON payload format. FHIR XML payload support is not included.**

## Capabilities and features

### Supported operation contracts

|                    | Description |
| ------------------ | ----------- |
| `BulkMemberMatcher` | Handles `$bulk-member-match` requests on `Group` |
| `DaVinciDataExporter` | Handles `$davinci-data-export` requests on `Group/[id]` |
| `BulkMemberMatchResources` | Input resource bundle contract for member match |
| `BulkMemberMatchResult` | Output contract for member match results |
| `DataExportParameters` | Input contract for data export filters and controls |
| `DataExportJob` | Asynchronous export initiation response contract |
