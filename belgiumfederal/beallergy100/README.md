## Overview

Belgium Federal Allergy (1.0.0) FHIR R4 profile package for allergy-specific interoperability in Belgian healthcare workflows. It provides typed records aligned with the Belgian allergy implementation guide.

> **Trademark Notice:** FHIR® and the FHIR® logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7®.

### Key Features

- Profile-specific Ballerina records for Belgian allergy exchange
- StructureDefinition-aligned model for BeAllergyIntolerance
- Type-safe payload authoring for allergy data workflows
- Designed for integration with base `r4`, parser, and validator modules
- JSON-focused interoperability for FHIR R4 implementations

Ballerina package containing FHIR resource data models
compliant with https://www.ehealth.fgov.be/standards/fhir/allergy/ implementation guide.

# FHIR R4 health_fhir_r4_be_allergy100 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://www.ehealth.fgov.be/standards/fhir/allergy/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). BeAllergyIntolerance | [[Definition]][s1] [[Ballerina Record]][m1] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.be.allergy100/1.0.0#BeAllergyIntolerance

[s1]: https://www.ehealth.fgov.be/standards/fhir/allergy/StructureDefinition/be-allergyintolerance
