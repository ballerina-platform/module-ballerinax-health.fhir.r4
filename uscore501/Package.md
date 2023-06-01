Package containing USCore FHIR resource types

# FHIR R4 USCore package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/us/core/               |

This package includes, FHIR USCore Resource types

**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| USCorePediatricBMIforAgeObservationProfile | [[Definition]][s1] [[Ballerina Record]][m1] |
| USCoreDocumentReferenceProfile | [[Definition]][s2] [[Ballerina Record]][m2] |
| USCoreGoalProfile | [[Definition]][s3] [[Ballerina Record]][m3] |
| USCoreCarePlanProfile | [[Definition]][s4] [[Ballerina Record]][m4] |
| USCorePractitionerProfile | [[Definition]][s5] [[Ballerina Record]][m5] |
| USCoreMedicationProfile | [[Definition]][s6] [[Ballerina Record]][m6] |
| USCoreDiagnosticReportProfileNoteExchange | [[Definition]][s7] [[Ballerina Record]][m7] |
| USCoreOrganizationProfile | [[Definition]][s8] [[Ballerina Record]][m8] |
| USCoreMedicationRequestProfile | [[Definition]][s9] [[Ballerina Record]][m9] |
| USCoreSmokingStatusProfile | [[Definition]][s10] [[Ballerina Record]][m10] |
| USCoreLocation | [[Definition]][s11] [[Ballerina Record]][m11] |
| USCoreProvenance | [[Definition]][s12] [[Ballerina Record]][m12] |
| USCoreVitalSignsProfile | [[Definition]][s13] [[Ballerina Record]][m13] |
| USCoreDiagnosticReportProfileLaboratoryReporting | [[Definition]][s14] [[Ballerina Record]][m14] |
| USCoreEncounterProfile | [[Definition]][s15] [[Ballerina Record]][m15] |
| USCorePractitionerRoleProfile | [[Definition]][s16] [[Ballerina Record]][m16] |
| USCorePatientProfile | [[Definition]][s17] [[Ballerina Record]][m17] |
| USCoreAllergyIntolerance | [[Definition]][s18] [[Ballerina Record]][m18] |
| USCoreCareTeam | [[Definition]][s19] [[Ballerina Record]][m19] |
| USCorePediatricWeightForHeightObservationProfile | [[Definition]][s20] [[Ballerina Record]][m20] |
| USCoreLaboratoryResultObservationProfile | [[Definition]][s21] [[Ballerina Record]][m21] |
| USCoreImmunizationProfile | [[Definition]][s22] [[Ballerina Record]][m22] |
| USCoreProcedureProfile | [[Definition]][s23] [[Ballerina Record]][m23] |
| USCorePulseOximetryProfile | [[Definition]][s24] [[Ballerina Record]][m24] |
| USCoreCondition | [[Definition]][s25] [[Ballerina Record]][m25] |
| USCoreImplantableDeviceProfile | [[Definition]][s26] [[Ballerina Record]][m26] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCorePediatricBMIforAgeObservationProfile
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreDocumentReferenceProfile
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreGoalProfile
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreCarePlanProfile
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCorePractitionerProfile
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreMedicationProfile
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreDiagnosticReportProfileNoteExchange
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreOrganizationProfile
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreMedicationRequestProfile
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreSmokingStatusProfile
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreLocation
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreProvenance
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreVitalSignsProfile
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreDiagnosticReportProfileLaboratoryReporting
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreEncounterProfile
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCorePractitionerRoleProfile
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCorePatientProfile
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreAllergyIntolerance
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreCareTeam
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCorePediatricWeightForHeightObservationProfile
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreLaboratoryResultObservationProfile
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreImmunizationProfile
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreProcedureProfile
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCorePulseOximetryProfile
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreCondition
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.0.3/#USCoreImplantableDeviceProfile

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
