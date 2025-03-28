# FHIR R4 Base package

The package containing the FHIR R4 Data types, Base Resource Types, Error Types, Utilities, etc.

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/ |

This package includes,

1. FHIR R4 Data types
2. FHIR Base Resource types ([Bundle][m1], [CodeSystem][m2], [OperationOutcome][m3], [ValueSet][m4])
3. FHIR resource serializers
4. Miscellaneous utilities required to create, access elements, manipulate FHIR resources
5. Defined FHIR error types and utilities for FHIR error handling

**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4/4.3.2#Bundle
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4/4.3.2#CodeSystem
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4/4.3.2#OperationOutcome
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4/4.3.2#ValueSet
