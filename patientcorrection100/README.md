## Overview

Patient Corrections (1.0.0) FHIR R4 model package for patient-initiated correction workflows. It provides typed resources for correction tasks, communication threads, and correction bundles.

> **Trademark Notice:** FHIR® and the FHIR® logo are the registered trademarks of [Health Level Seven International](https://www.hl7.org/) and their use does not constitute endorsement by HL7®.

### Key Features

- Typed records aligned to patient-corrections IG profiles
- Models for correction task lifecycle and messaging
- Bundle profile support for correction exchange packaging
- Helps implement correction workflows with type safety

Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/uv/patient-corrections/ implementation guide.

# FHIR R4 health_fhir_r4_patient_corrections package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/uv/patient-corrections/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). PatientCorrectionTask | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). PatientCorrectionCommunication | [[Definition]][s2] [[Ballerina Record]][m2] |
| 2). PatientCorrectionBundle | [[Definition]][s3] [[Ballerina Record]][m3] |

[m1]: https://lib.ballerina.io/healthcare/health.fhir.r4.patient.corrections/1.0.0#PatientCorrectionTask
[m2]: https://lib.ballerina.io/healthcare/health.fhir.r4.patient.corrections/1.0.0#PatientCorrectionCommunication
[m3]: https://lib.ballerina.io/healthcare/health.fhir.r4.patient.corrections/1.0.0#PatientCorrectionBundle

[s1]: http://hl7.org/fhir/uv/patient-corrections/StructureDefinition/patient-correction-task
[s2]: http://hl7.org/fhir/uv/patient-corrections/StructureDefinition/patient-correction-communication
[s3]: http://hl7.org/fhir/uv/patient-corrections/StructureDefinition/patient-correction-bundle
