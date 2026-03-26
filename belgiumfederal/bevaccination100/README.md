## Overview

Belgium Federal Vaccination (1.0.0) FHIR R4 profile package for vaccination interoperability in Belgian healthcare contexts. It provides typed records for vaccination-specific profile exchanges.

> **Trademark Notice:** FHIR® and the FHIR® logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7®.

### Key Features

- Profile-aligned BeVaccination resource model
- StructureDefinition-backed typing for vaccination payloads
- Supports standards-compliant vaccination data exchange
- Works with parser and validator utilities in this repository
- JSON-first FHIR R4 interoperability support

Ballerina package containing FHIR resource data models
compliant with https://www.ehealth.fgov.be/standards/fhir/vaccination/ implementation guide.

# FHIR R4 health_fhir_r4_be_vaccination100 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://www.ehealth.fgov.be/standards/fhir/vaccination/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). BeVaccination | [[Definition]][s1] [[Ballerina Record]][m1] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.be.vaccination100/1.0.0#BeVaccination

[s1]: https://www.ehealth.fgov.be/standards/fhir/vaccination/StructureDefinition/be-vaccination
