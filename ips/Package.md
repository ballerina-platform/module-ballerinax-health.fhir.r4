Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/uv/ips/ implementation guide.

# FHIR R4 ips package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/uv/ips/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). MedicationStatementIPS | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). MedicationRequestIPS | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). DeviceObserverUvIps | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). ObservationPregnancyStatusUvIps | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). OrganizationUvIps | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). ImagingStudyUvIps | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). ObservationResultsUvIps | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). PractitionerRoleUvIps | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). ImmunizationUvIps | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). DeviceUvIps | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). ObservationPregnancyEddUvIps | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). ObservationResultsRadiologyUvIps | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). ObservationPregnancyOutcomeUvIps | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). ProcedureUvIps | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). DiagnosticReportUvIps | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). DeviceUseStatementUvIps | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). CompositionUvIps | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). ObservationAlcoholUseUvIps | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). ConditionUvIps | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). ObservationResultsPathologyUvIps | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). AllergyIntoleranceUvIps | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). ObservationTobaccoUseUvIps | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). ObservationResultsLaboratoryUvIps | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). PractitionerUvIps | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). MedicationIPS | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). MediaObservationUvIps | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). SpecimenUvIps | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). PatientUvIps | [[Definition]][s28] [[Ballerina Record]][m28] |

[m1]: https://lib.ballerina.io/ballerinax/ips/1.0.0#MedicationStatementIPS
[m2]: https://lib.ballerina.io/ballerinax/ips/1.0.0#MedicationRequestIPS
[m3]: https://lib.ballerina.io/ballerinax/ips/1.0.0#DeviceObserverUvIps
[m4]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationPregnancyStatusUvIps
[m5]: https://lib.ballerina.io/ballerinax/ips/1.0.0#OrganizationUvIps
[m6]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ImagingStudyUvIps
[m7]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationResultsUvIps
[m8]: https://lib.ballerina.io/ballerinax/ips/1.0.0#PractitionerRoleUvIps
[m9]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ImmunizationUvIps
[m10]: https://lib.ballerina.io/ballerinax/ips/1.0.0#DeviceUvIps
[m11]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationPregnancyEddUvIps
[m12]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationResultsRadiologyUvIps
[m13]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationPregnancyOutcomeUvIps
[m14]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ProcedureUvIps
[m15]: https://lib.ballerina.io/ballerinax/ips/1.0.0#DiagnosticReportUvIps
[m16]: https://lib.ballerina.io/ballerinax/ips/1.0.0#DeviceUseStatementUvIps
[m17]: https://lib.ballerina.io/ballerinax/ips/1.0.0#CompositionUvIps
[m18]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationAlcoholUseUvIps
[m19]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ConditionUvIps
[m20]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationResultsPathologyUvIps
[m21]: https://lib.ballerina.io/ballerinax/ips/1.0.0#AllergyIntoleranceUvIps
[m22]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationTobaccoUseUvIps
[m23]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationResultsLaboratoryUvIps
[m24]: https://lib.ballerina.io/ballerinax/ips/1.0.0#PractitionerUvIps
[m25]: https://lib.ballerina.io/ballerinax/ips/1.0.0#MedicationIPS
[m26]: https://lib.ballerina.io/ballerinax/ips/1.0.0#MediaObservationUvIps
[m27]: https://lib.ballerina.io/ballerinax/ips/1.0.0#SpecimenUvIps
[m28]: https://lib.ballerina.io/ballerinax/ips/1.0.0#PatientUvIps

[s1]: http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationStatement-uv-ips
[s2]: http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationRequest-uv-ips
[s3]: http://hl7.org/fhir/uv/ips/StructureDefinition/Device-observer-uv-ips
[s4]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-status-uv-ips
[s5]: http://hl7.org/fhir/uv/ips/StructureDefinition/Organization-uv-ips
[s6]: http://hl7.org/fhir/uv/ips/StructureDefinition/ImagingStudy-uv-ips
[s7]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-uv-ips
[s8]: http://hl7.org/fhir/uv/ips/StructureDefinition/PractitionerRole-uv-ips
[s9]: http://hl7.org/fhir/uv/ips/StructureDefinition/Immunization-uv-ips
[s10]: http://hl7.org/fhir/uv/ips/StructureDefinition/Device-uv-ips
[s11]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-edd-uv-ips
[s12]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-radiology-uv-ips
[s13]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-outcome-uv-ips
[s14]: http://hl7.org/fhir/uv/ips/StructureDefinition/Procedure-uv-ips
[s15]: http://hl7.org/fhir/uv/ips/StructureDefinition/DiagnosticReport-uv-ips
[s16]: http://hl7.org/fhir/uv/ips/StructureDefinition/DeviceUseStatement-uv-ips
[s17]: http://hl7.org/fhir/uv/ips/StructureDefinition/Composition-uv-ips
[s18]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-alcoholuse-uv-ips
[s19]: http://hl7.org/fhir/uv/ips/StructureDefinition/Condition-uv-ips
[s20]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-pathology-uv-ips
[s21]: http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-uv-ips
[s22]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-tobaccouse-uv-ips
[s23]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-laboratory-uv-ips
[s24]: http://hl7.org/fhir/uv/ips/StructureDefinition/Practitioner-uv-ips
[s25]: http://hl7.org/fhir/uv/ips/StructureDefinition/Medication-uv-ips
[s26]: http://hl7.org/fhir/uv/ips/StructureDefinition/Media-observation-uv-ips
[s27]: http://hl7.org/fhir/uv/ips/StructureDefinition/Specimen-uv-ips
[s28]: http://hl7.org/fhir/uv/ips/StructureDefinition/Patient-uv-ips
