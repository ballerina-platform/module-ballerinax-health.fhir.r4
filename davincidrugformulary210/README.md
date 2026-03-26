
## Overview

Da Vinci Drug Formulary (2.1.0) FHIR R4 model package for formulary and payer coverage exchange. It includes typed resources for formulary items, plans, and graph definitions.

> **Trademark Notice:** FHIR® and the FHIR® logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7®.

### Key Features

- Ballerina records aligned to Da Vinci Drug Formulary profiles
- Models for formulary, formulary drugs/items, and insurance plan structures

Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/davinci-drug-formulary/ implementation guide.

# FHIR R4 health_fhir_r4_davincidrugformulary210 package

## Package Overview

|                      |                                                |
| -------------------- | ---------------------------------------------- |
| FHIR version         | R4                                             |
| Implementation Guide | http://hl7.org/fhir/us/davinci-drug-formulary/ |

**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                                               |                                             |
| --------------------------------------------- | ------------------------------------------- |
| 1). InsurancePlanLocation                     | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). FormularyDrug                             | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). PayerInsurancePlan                        | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). PayerInsurancePlanBulkDataGraphDefinition | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). FormularyItem                             | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). FormularyBulkDataGraphDefinition          | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). Formulary                                 | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). InsurancePlanCoverage                     | [[Definition]][s8] [[Ballerina Record]][m8] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincidrugformulary210/1.0.0#InsurancePlanLocation
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincidrugformulary210/1.0.0#FormularyDrug
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincidrugformulary210/1.0.0#PayerInsurancePlan
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincidrugformulary210/1.0.0#PayerInsurancePlanBulkDataGraphDefinition
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincidrugformulary210/1.0.0#FormularyItem
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincidrugformulary210/1.0.0#FormularyBulkDataGraphDefinition
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincidrugformulary210/1.0.0#Formulary
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincidrugformulary210/1.0.0#InsurancePlanCoverage
[s1]: http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-InsurancePlanLocation
[s2]: http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyDrug
[s3]: http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PayerInsurancePlan
[s4]: http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PayerInsurancePlanBulkDataGraphDefinition
[s5]: http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyItem
[s6]: http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyBulkDataGraphDefinition
[s7]: http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-Formulary
[s8]: http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/insurance-plan-coverage
