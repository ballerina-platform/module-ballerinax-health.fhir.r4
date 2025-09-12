Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/core/ implementation guide.

# FHIR R4 health_fhir_r4_uscore700 package

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
| 2). USCoreDocumentReferenceProfile | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). USCoreDiagnosticReportProfileNoteExchange | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). USCoreCareExperiencePreferenceProfile | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). USCoreBloodPressureProfile | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). USCoreSpecimenProfile | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). USCoreSmokingStatusProfile | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). USCoreObservationClinicalResultProfile | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). USCoreVitalSignsProfile | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). USCoreLocationProfile | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). USCoreDiagnosticReportProfileLaboratoryReporting | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). USCoreSimpleObservationProfile | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). USCorePractitionerRoleProfile | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). USCoreServiceRequestProfile | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). USCoreBodyWeightProfile | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). USCoreAverageBloodPressureProfile | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). USCoreCoverageProfile | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). USCoreImmunizationProfile | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). USCoreMedicationDispenseProfile | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). USCoreProcedureProfile | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). USCoreObservationSexualOrientationProfile | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). USCoreImplantableDeviceProfile | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). USCoreObservationOccupationProfile | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). USCorePediatricBMIforAgeObservationProfile | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). USCoreGoalProfile | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). USCoreHeadCircumferenceProfile | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). USCoreCarePlanProfile | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). USCorePractitionerProfile | [[Definition]][s28] [[Ballerina Record]][m28] |
| 29). USCoreMedicationProfile | [[Definition]][s29] [[Ballerina Record]][m29] |
| 30). USCoreBMIProfile | [[Definition]][s30] [[Ballerina Record]][m30] |
| 31). USCoreOrganizationProfile | [[Definition]][s31] [[Ballerina Record]][m31] |
| 32). USCorePediatricHeadOccipitalFrontalCircumferencePercentileProfile | [[Definition]][s32] [[Ballerina Record]][m32] |
| 33). USCoreObservationPregnancyIntentProfile | [[Definition]][s33] [[Ballerina Record]][m33] |
| 34). USCoreRelatedPersonProfile | [[Definition]][s34] [[Ballerina Record]][m34] |
| 35). USCoreMedicationRequestProfile | [[Definition]][s35] [[Ballerina Record]][m35] |
| 36). USCoreBodyHeightProfile | [[Definition]][s36] [[Ballerina Record]][m36] |
| 37). USCoreBodyTemperatureProfile | [[Definition]][s37] [[Ballerina Record]][m37] |
| 38). USCoreTreatmentInterventionPreferenceProfile | [[Definition]][s38] [[Ballerina Record]][m38] |
| 39). USCoreObservationScreeningAssessmentProfile | [[Definition]][s39] [[Ballerina Record]][m39] |
| 40). USCoreProvenance | [[Definition]][s40] [[Ballerina Record]][m40] |
| 41). USCoreEncounterProfile | [[Definition]][s41] [[Ballerina Record]][m41] |
| 42). USCoreConditionEncounterDiagnosisProfile | [[Definition]][s42] [[Ballerina Record]][m42] |
| 43). USCoreObservationPregnancyStatusProfile | [[Definition]][s43] [[Ballerina Record]][m43] |
| 44). USCoreHeartRateProfile | [[Definition]][s44] [[Ballerina Record]][m44] |
| 45). USCorePatientProfile | [[Definition]][s45] [[Ballerina Record]][m45] |
| 46). USCoreQuestionnaireResponseProfile | [[Definition]][s46] [[Ballerina Record]][m46] |
| 47). USCoreAllergyIntolerance | [[Definition]][s47] [[Ballerina Record]][m47] |
| 48). USCoreCareTeam | [[Definition]][s48] [[Ballerina Record]][m48] |
| 49). USCorePediatricWeightForHeightObservationProfile | [[Definition]][s49] [[Ballerina Record]][m49] |
| 50). USCoreRespiratoryRateProfile | [[Definition]][s50] [[Ballerina Record]][m50] |
| 51). USCoreLaboratoryResultObservationProfile | [[Definition]][s51] [[Ballerina Record]][m51] |
| 52). USCorePulseOximetryProfile | [[Definition]][s52] [[Ballerina Record]][m52] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreConditionProblemsHealthConcernsProfile
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreDocumentReferenceProfile
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreDiagnosticReportProfileNoteExchange
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreCareExperiencePreferenceProfile
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreBloodPressureProfile
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreSpecimenProfile
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreSmokingStatusProfile
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreObservationClinicalResultProfile
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreVitalSignsProfile
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreLocationProfile
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreDiagnosticReportProfileLaboratoryReporting
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreSimpleObservationProfile
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCorePractitionerRoleProfile
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreServiceRequestProfile
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreBodyWeightProfile
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreAverageBloodPressureProfile
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreCoverageProfile
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreImmunizationProfile
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreMedicationDispenseProfile
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreProcedureProfile
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreObservationSexualOrientationProfile
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreImplantableDeviceProfile
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreObservationOccupationProfile
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCorePediatricBMIforAgeObservationProfile
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreGoalProfile
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreHeadCircumferenceProfile
[m27]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreCarePlanProfile
[m28]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCorePractitionerProfile
[m29]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreMedicationProfile
[m30]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreBMIProfile
[m31]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreOrganizationProfile
[m32]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCorePediatricHeadOccipitalFrontalCircumferencePercentileProfile
[m33]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreObservationPregnancyIntentProfile
[m34]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreRelatedPersonProfile
[m35]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreMedicationRequestProfile
[m36]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreBodyHeightProfile
[m37]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreBodyTemperatureProfile
[m38]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreTreatmentInterventionPreferenceProfile
[m39]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreObservationScreeningAssessmentProfile
[m40]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreProvenance
[m41]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreEncounterProfile
[m42]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreConditionEncounterDiagnosisProfile
[m43]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreObservationPregnancyStatusProfile
[m44]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreHeartRateProfile
[m45]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCorePatientProfile
[m46]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreQuestionnaireResponseProfile
[m47]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreAllergyIntolerance
[m48]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreCareTeam
[m49]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCorePediatricWeightForHeightObservationProfile
[m50]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreRespiratoryRateProfile
[m51]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCoreLaboratoryResultObservationProfile
[m52]: https://lib.ballerina.io/ballerinax/health.fhir.r4.uscore700/1.0.0#USCorePulseOximetryProfile

[s1]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-problems-health-concerns
[s2]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference
[s3]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note
[s4]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-care-experience-preference
[s5]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-blood-pressure
[s6]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-specimen
[s7]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus
[s8]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-clinical-result
[s9]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs
[s10]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-location
[s11]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab
[s12]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-simple-observation
[s13]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole
[s14]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-servicerequest
[s15]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-weight
[s16]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-average-blood-pressure
[s17]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-coverage
[s18]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization
[s19]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationdispense
[s20]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure
[s21]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-sexual-orientation
[s22]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device
[s23]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-occupation
[s24]: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age
[s25]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal
[s26]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-head-circumference
[s27]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan
[s28]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner
[s29]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication
[s30]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-bmi
[s31]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization
[s32]: http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile
[s33]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-pregnancyintent
[s34]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-relatedperson
[s35]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest
[s36]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-height
[s37]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-temperature
[s38]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-treatment-intervention-preference
[s39]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-screening-assessment
[s40]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance
[s41]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter
[s42]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis
[s43]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-pregnancystatus
[s44]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-heart-rate
[s45]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
[s46]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-questionnaireresponse
[s47]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance
[s48]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam
[s49]: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height
[s50]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-respiratory-rate
[s51]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
[s52]: http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry
