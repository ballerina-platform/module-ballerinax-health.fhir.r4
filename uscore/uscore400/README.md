Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/core/ implementation guide.

# FHIR R4 uscore400 package

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
| 4). USCoreHeadCircumferenceProfile | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). USCoreCarePlanProfile | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). USCorePractitionerProfile | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). USCoreMedicationProfile | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). USCoreDiagnosticReportProfileNoteExchange | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). USCoreOrganizationProfile | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). USCorePediatricHeadOccipitalFrontalCircumferencePercentileProfile | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). USCoreBloodPressureProfile | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). USCoreMedicationRequestProfile | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). USCoreBodyHeightProfile | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). USCoreBodyTemperatureProfile | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). USCoreSmokingStatusProfile | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). USCoreLocation | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). USCoreProvenance | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). USCoreBMIProfileProfile | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). USCoreVitalSignsProfile | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). USCoreDiagnosticReportProfileLaboratoryReporting | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). USCoreEncounterProfile | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). USCorePractitionerRoleProfile | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). USCoreHeartRateProfile | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). USCorePatientProfile | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). USCoreAllergyIntolerance | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). USCoreCareTeam | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). USCorePediatricWeightForHeightObservationProfile | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). USCoreBodyWeightProfile | [[Definition]][s28] [[Ballerina Record]][m28] |
| 29). USCoreRespiratoryRateProfile | [[Definition]][s29] [[Ballerina Record]][m29] |
| 30). USCoreLaboratoryResultObservationProfile | [[Definition]][s30] [[Ballerina Record]][m30] |
| 31). USCoreImmunizationProfile | [[Definition]][s31] [[Ballerina Record]][m31] |
| 32). USCoreProcedureProfile | [[Definition]][s32] [[Ballerina Record]][m32] |
| 33). USCorePulseOximetryProfile | [[Definition]][s33] [[Ballerina Record]][m33] |
| 34). USCoreCondition | [[Definition]][s34] [[Ballerina Record]][m34] |
| 35). USCoreImplantableDeviceProfile | [[Definition]][s35] [[Ballerina Record]][m35] |

[m1]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCorePediatricBMIforAgeObservationProfile
[m2]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreDocumentReferenceProfile
[m3]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreGoalProfile
[m4]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreHeadCircumferenceProfile
[m5]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreCarePlanProfile
[m6]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCorePractitionerProfile
[m7]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreMedicationProfile
[m8]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreDiagnosticReportProfileNoteExchange
[m9]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreOrganizationProfile
[m10]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCorePediatricHeadOccipitalFrontalCircumferencePercentileProfile
[m11]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreBloodPressureProfile
[m12]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreMedicationRequestProfile
[m13]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreBodyHeightProfile
[m14]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreBodyTemperatureProfile
[m15]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreSmokingStatusProfile
[m16]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreLocation
[m17]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreProvenance
[m18]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreBMIProfileProfile
[m19]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreVitalSignsProfile
[m20]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreDiagnosticReportProfileLaboratoryReporting
[m21]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreEncounterProfile
[m22]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCorePractitionerRoleProfile
[m23]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreHeartRateProfile
[m24]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCorePatientProfile
[m25]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreAllergyIntolerance
[m26]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreCareTeam
[m27]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCorePediatricWeightForHeightObservationProfile
[m28]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreBodyWeightProfile
[m29]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreRespiratoryRateProfile
[m30]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreLaboratoryResultObservationProfile
[m31]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreImmunizationProfile
[m32]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreProcedureProfile
[m33]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCorePulseOximetryProfile
[m34]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreCondition
[m35]: https://lib.ballerina.io/ballerinax/uscore400/1.0.0#USCoreImplantableDeviceProfile

[s1]: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age
[s2]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference
[s3]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal
[s4]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-head-circumference
[s5]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan
[s6]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner
[s7]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication
[s8]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note
[s9]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization
[s10]: http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile
[s11]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-blood-pressure
[s12]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest
[s13]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-height
[s14]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-temperature
[s15]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus
[s16]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-location
[s17]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance
[s18]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-bmi
[s19]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs
[s20]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab
[s21]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter
[s22]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole
[s23]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-heart-rate
[s24]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
[s25]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance
[s26]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam
[s27]: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height
[s28]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-weight
[s29]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-respiratory-rate
[s30]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
[s31]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization
[s32]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure
[s33]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry
[s34]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition
[s35]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device
