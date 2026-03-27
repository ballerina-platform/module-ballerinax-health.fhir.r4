## Overview

Belgium Federal Core Clinical (1.0.0) FHIR R4 model package for Belgian clinical data exchange. It includes profile-based types for observations, score results, and problem records.

> **Trademark Notice:** FHIR® and the FHIR® logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7®.

### Key Features

- Typed models aligned with Belgian core-clinical profiles
- Support for BeObservation, BeScoreResult, and BeProblem resources
- Improves correctness for clinical payload construction
- Compatible with parser and validator packages in this repository
- JSON-oriented profile modeling for FHIR R4

Ballerina package containing FHIR resource data models
compliant with https://www.ehealth.fgov.be/standards/fhir/core-clinical/ implementation guide.

# FHIR R4 health_fhir_r4_be_clinical100 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://www.ehealth.fgov.be/standards/fhir/core-clinical/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). BeScoreResult | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). BeObservation | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). BeProblem | [[Definition]][s3] [[Ballerina Record]][m3] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.be.clinical100/1.0.0#BeScoreResult
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.be.clinical100/1.0.0#BeObservation
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.be.clinical100/1.0.0#BeProblem

[s1]: https://www.ehealth.fgov.be/standards/fhir/core-clinical/StructureDefinition/be-scoreresult
[s2]: https://www.ehealth.fgov.be/standards/fhir/core-clinical/StructureDefinition/be-observation
[s3]: https://www.ehealth.fgov.be/standards/fhir/core-clinical/StructureDefinition/be-problem
