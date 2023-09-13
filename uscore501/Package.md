
# FHIR R4 USCore package

Package containing the FHIR R4 USCore resources types

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/us/core/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). USCorePediatricBMIforAgeObservationProfile | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). USCoreDocumentReferenceProfile | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). USCoreGoalProfile | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). USCoreCarePlanProfile | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). USCorePractitionerProfile | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). USCoreMedicationProfile | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). USCoreDiagnosticReportProfileNoteExchange | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). USCoreOrganizationProfile | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). USCoreMedicationRequestProfile | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). USCoreSmokingStatusProfile | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). USCoreLocation | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). USCoreProvenance | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). USCoreVitalSignsProfile | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). USCoreDiagnosticReportProfileLaboratoryReporting | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). USCoreEncounterProfile | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). USCorePractitionerRoleProfile | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). USCorePatientProfile | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). USCoreAllergyIntolerance | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). USCoreCareTeam | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). USCorePediatricWeightForHeightObservationProfile | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). USCoreLaboratoryResultObservationProfile | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). USCoreImmunizationProfile | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). USCoreProcedureProfile | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). USCorePulseOximetryProfile | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). USCoreCondition | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). USCoreImplantableDeviceProfile | [[Definition]][s26] [[Ballerina Record]][m26] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCorePediatricBMIforAgeObservationProfile
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreDocumentReferenceProfile
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreGoalProfile
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreCarePlanProfile
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCorePractitionerProfile
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreMedicationProfile
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreDiagnosticReportProfileNoteExchange
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreOrganizationProfile
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreMedicationRequestProfile
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreSmokingStatusProfile
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreLocation
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreProvenance
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreVitalSignsProfile
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreDiagnosticReportProfileLaboratoryReporting
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreEncounterProfile
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCorePractitionerRoleProfile
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCorePatientProfile
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreAllergyIntolerance
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreCareTeam
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCorePediatricWeightForHeightObservationProfile
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreLaboratoryResultObservationProfile
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreImmunizationProfile
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreProcedureProfile
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCorePulseOximetryProfile
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreCondition
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.1.0#USCoreImplantableDeviceProfile

[s1]: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age
[s2]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference
[s3]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal
[s4]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan
[s5]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner
[s6]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication
[s7]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note
[s8]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization
[s9]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest
[s10]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus
[s11]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-location
[s12]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance
[s13]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs
[s14]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab
[s15]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter
[s16]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole
[s17]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
[s18]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance
[s19]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam
[s20]: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height
[s21]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
[s22]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization
[s23]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure
[s24]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry
[s25]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition
[s26]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device
