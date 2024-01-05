Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/core/ implementation guide.

# FHIR R4 USCore package

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
| 1). USCoreConditionProblemsHealthConcernsProfile | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). USCorePediatricBMIforAgeObservationProfile | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). USCoreDocumentReferenceProfile | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). USCoreGoalProfile | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). USCoreHeadCircumferenceProfile | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). USCoreCarePlanProfile | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). USCorePractitionerProfile | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). USCoreMedicationProfile | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). USCoreBMIProfile | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). USCoreDiagnosticReportProfileNoteExchange | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). USCoreOrganizationProfile | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). USCorePediatricHeadOccipitalFrontalCircumferencePercentileProfile | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). USCoreBloodPressureProfile | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). USCoreRelatedPersonProfile | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). USCoreMedicationRequestProfile | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). USCoreBodyHeightProfile | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). USCoreBodyTemperatureProfile | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). USCoreSmokingStatusProfile | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). USCoreLocation | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). USCoreProvenance | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). USCoreVitalSignsProfile | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). USCoreDiagnosticReportProfileLaboratoryReporting | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). USCoreObservationSDOHAssessment | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). USCoreEncounterProfile | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). USCoreObservationSurveyProfile | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). USCoreConditionEncounterDiagnosisProfile | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). USCorePractitionerRoleProfile | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). USCoreHeartRateProfile | [[Definition]][s28] [[Ballerina Record]][m28] |
| 29). USCoreServiceRequestProfile | [[Definition]][s29] [[Ballerina Record]][m29] |
| 30). USCoreObservationImagingResultProfile | [[Definition]][s30] [[Ballerina Record]][m30] |
| 31). USCorePatientProfile | [[Definition]][s31] [[Ballerina Record]][m31] |
| 32). USCoreQuestionnaireResponseProfile | [[Definition]][s32] [[Ballerina Record]][m32] |
| 33). USCoreAllergyIntolerance | [[Definition]][s33] [[Ballerina Record]][m33] |
| 34). USCoreCareTeam | [[Definition]][s34] [[Ballerina Record]][m34] |
| 35). USCorePediatricWeightForHeightObservationProfile | [[Definition]][s35] [[Ballerina Record]][m35] |
| 36). USCoreBodyWeightProfile | [[Definition]][s36] [[Ballerina Record]][m36] |
| 37). USCoreRespiratoryRateProfile | [[Definition]][s37] [[Ballerina Record]][m37] |
| 38). USCoreLaboratoryResultObservationProfile | [[Definition]][s38] [[Ballerina Record]][m38] |
| 39). USCoreImmunizationProfile | [[Definition]][s39] [[Ballerina Record]][m39] |
| 40). USCoreObservationClinicalTestResultProfile | [[Definition]][s40] [[Ballerina Record]][m40] |
| 41). USCoreProcedureProfile | [[Definition]][s41] [[Ballerina Record]][m41] |
| 42). USCoreObservationSexualOrientationProfile | [[Definition]][s42] [[Ballerina Record]][m42] |
| 43). USCorePulseOximetryProfile | [[Definition]][s43] [[Ballerina Record]][m43] |
| 44). USCoreObservationSocialHistoryProfile | [[Definition]][s44] [[Ballerina Record]][m44] |
| 45). USCoreImplantableDeviceProfile | [[Definition]][s45] [[Ballerina Record]][m45] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreConditionProblemsHealthConcernsProfile
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCorePediatricBMIforAgeObservationProfile
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreDocumentReferenceProfile
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreGoalProfile
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreHeadCircumferenceProfile
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreCarePlanProfile
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCorePractitionerProfile
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreMedicationProfile
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreBMIProfile
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreDiagnosticReportProfileNoteExchange
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreOrganizationProfile
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCorePediatricHeadOccipitalFrontalCircumferencePercentileProfile
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreBloodPressureProfile
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreRelatedPersonProfile
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreMedicationRequestProfile
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreBodyHeightProfile
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreBodyTemperatureProfile
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreSmokingStatusProfile
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreLocation
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreProvenance
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreVitalSignsProfile
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreDiagnosticReportProfileLaboratoryReporting
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreObservationSDOHAssessment
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreEncounterProfile
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreObservationSurveyProfile
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreConditionEncounterDiagnosisProfile
[m27]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCorePractitionerRoleProfile
[m28]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreHeartRateProfile
[m29]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreServiceRequestProfile
[m30]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreObservationImagingResultProfile
[m31]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCorePatientProfile
[m32]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreQuestionnaireResponseProfile
[m33]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreAllergyIntolerance
[m34]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreCareTeam
[m35]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCorePediatricWeightForHeightObservationProfile
[m36]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreBodyWeightProfile
[m37]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreRespiratoryRateProfile
[m38]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreLaboratoryResultObservationProfile
[m39]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreImmunizationProfile
[m40]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreObservationClinicalTestResultProfile
[m41]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreProcedureProfile
[m42]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreObservationSexualOrientationProfile
[m43]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCorePulseOximetryProfile
[m44]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreObservationSocialHistoryProfile
[m45]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore501/1.3.1#USCoreImplantableDeviceProfile

[s1]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-problems-health-concerns
[s2]: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age
[s3]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference
[s4]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal
[s5]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-head-circumference
[s6]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan
[s7]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner
[s8]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication
[s9]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-bmi
[s10]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note
[s11]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization
[s12]: http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile
[s13]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-blood-pressure
[s14]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-relatedperson
[s15]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest
[s16]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-height
[s17]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-temperature
[s18]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus
[s19]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-location
[s20]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance
[s21]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs
[s22]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab
[s23]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-sdoh-assessment
[s24]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter
[s25]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-survey
[s26]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis
[s27]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole
[s28]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-heart-rate
[s29]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-servicerequest
[s30]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-imaging
[s31]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
[s32]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-questionnaireresponse
[s33]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance
[s34]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam
[s35]: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height
[s36]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-weight
[s37]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-respiratory-rate
[s38]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
[s39]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization
[s40]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-clinical-test
[s41]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure
[s42]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-sexual-orientation
[s43]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry
[s44]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-social-history
[s45]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device
