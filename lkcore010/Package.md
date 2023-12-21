# FHIR R4 LKCore package

The Ballerina package containing FHIR resource data models compliant with https://lk-gov-health-hiu.github.io/fhir-ig/ 
and https://jembi.github.io/Sri-Lanka/ implementation guides.

## Package Overview

| FHIR Version          | R4                                                                                            |
|-----------------------|-----------------------------------------------------------------------------------------------|
| Implementation Guides | https://lk-gov-health-hiu.github.io/fhir-ig/ <br></br> https://jembi.github.io/Sri-Lanka/ |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). GenericServiceRequest | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). NotifiableDiseasesNotified | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). BloodPressure | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). FollowUpAtHLC | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). MedicalHistory | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). Procedures | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). HHIMSPatient | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). InvestigationsTask | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). ImagingServiceRequest | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). DrugDispensation | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). TargetFacilityEncounter | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). LKCoreLocation | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). GenericObservation | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). Imaging | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). InvestigationsServiceRequest | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). Height | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). CVDRiskCategory | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). LKCorePractitioner | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). HIMSComposition | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). TotalCholesterol | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). Prescriptions | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). GeneralReferralServiceRequest | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). BMI | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). RiskBehaviourTobaccoSmoker | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). ImagingTask | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). LKCorePatient | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). GeneralPractitioner | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). FastingBloodSugar | [[Definition]][s28] [[Ballerina Record]][m28] |
| 29). Allergies | [[Definition]][s29] [[Ballerina Record]][m29] |
| 30). Weight | [[Definition]][s30] [[Ballerina Record]][m30] |
| 31). RiskBehaviourPhysicalActivity | [[Definition]][s31] [[Ballerina Record]][m31] |
| 32). GenericTask | [[Definition]][s32] [[Ballerina Record]][m32] |
| 33). RandomBloodSugar | [[Definition]][s33] [[Ballerina Record]][m33] |
| 34). ReferralTask | [[Definition]][s34] [[Ballerina Record]][m34] |
| 35). Injections | [[Definition]][s35] [[Ballerina Record]][m35] |
| 36). LKCoreAllergyIntolerance | [[Definition]][s36] [[Ballerina Record]][m36] |
| 37). ProvidersLocation | [[Definition]][s37] [[Ballerina Record]][m37] |
| 38). ServiceProvider | [[Definition]][s38] [[Ballerina Record]][m38] |
| 39). HIMSPatient | [[Definition]][s39] [[Ballerina Record]][m39] |
| 40). LKCoreOrganization | [[Definition]][s40] [[Ballerina Record]][m40] |
| 41). FollowUpPlanServiceRequest | [[Definition]][s41] [[Ballerina Record]][m41] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#GenericServiceRequest
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#NotifiableDiseasesNotified
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#BloodPressure
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#FollowUpAtHLC
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#MedicalHistory
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#Procedures
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#HHIMSPatient
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#InvestigationsTask
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#ImagingServiceRequest
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#DrugDispensation
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#TargetFacilityEncounter
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#LKCoreLocation
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#GenericObservation
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#Imaging
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#InvestigationsServiceRequest
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#Height
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#CVDRiskCategory
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#LKCorePractitioner
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#HIMSComposition
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#TotalCholesterol
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#Prescriptions
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#GeneralReferralServiceRequest
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#BMI
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#RiskBehaviourTobaccoSmoker
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#ImagingTask
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#LKCorePatient
[m27]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#GeneralPractitioner
[m28]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#FastingBloodSugar
[m29]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#Allergies
[m30]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#Weight
[m31]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#RiskBehaviourPhysicalActivity
[m32]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#GenericTask
[m33]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#RandomBloodSugar
[m34]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#ReferralTask
[m35]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#Injections
[m36]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#LKCoreAllergyIntolerance
[m37]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#ProvidersLocation
[m38]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#ServiceProvider
[m39]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#HIMSPatient
[m40]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#LKCoreOrganization
[m41]: https://lib.ballerina.io/ballerinax/health.fhir.r4.lkcore010/0.1.0#FollowUpPlanServiceRequest

[s1]: http://openhie.org/fhir/sri-lanka/StructureDefinition/generic-service-request
[s2]: http://openhie.org/fhir/sri-lanka/StructureDefinition/notifiable-diseases-notified
[s3]: http://openhie.org/fhir/sri-lanka/StructureDefinition/blood-pressure
[s4]: http://openhie.org/fhir/sri-lanka/StructureDefinition/follow-up-at-hlc
[s5]: http://openhie.org/fhir/sri-lanka/StructureDefinition/medical-history
[s6]: http://openhie.org/fhir/sri-lanka/StructureDefinition/procedure
[s7]: http://openhie.org/fhir/sri-lanka/StructureDefinition/hhims-patient
[s8]: http://openhie.org/fhir/sri-lanka/StructureDefinition/investigations-task
[s9]: http://openhie.org/fhir/sri-lanka/StructureDefinition/imaging-request
[s10]: http://openhie.org/fhir/sri-lanka/StructureDefinition/drug-dispensation
[s11]: http://openhie.org/fhir/sri-lanka/StructureDefinition/target-facility-encounter
[s12]: http://fhir.health.gov.lk/StructureDefinition/lk-core-location
[s13]: http://openhie.org/fhir/sri-lanka/StructureDefinition/generic-observation
[s14]: http://openhie.org/fhir/sri-lanka/StructureDefinition/imaging-study
[s15]: http://openhie.org/fhir/sri-lanka/StructureDefinition/investigations-request
[s16]: http://openhie.org/fhir/sri-lanka/StructureDefinition/height
[s17]: http://openhie.org/fhir/sri-lanka/StructureDefinition/cvd-risk-category
[s18]: http://fhir.health.gov.lk/StructureDefinition/lk-core-practitioner
[s19]: http://openhie.org/fhir/sri-lanka/StructureDefinition/hims-composition
[s20]: http://openhie.org/fhir/sri-lanka/StructureDefinition/total-cholesterol
[s21]: http://openhie.org/fhir/sri-lanka/StructureDefinition/medication-request
[s22]: http://openhie.org/fhir/sri-lanka/StructureDefinition/general-referral-request
[s23]: http://openhie.org/fhir/sri-lanka/StructureDefinition/bmi
[s24]: http://openhie.org/fhir/sri-lanka/StructureDefinition/risk-behaviour-tobacco-smoker
[s25]: http://openhie.org/fhir/sri-lanka/StructureDefinition/imaging-task
[s26]: http://fhir.health.gov.lk/StructureDefinition/lk-core-patient-profile
[s27]: http://openhie.org/fhir/sri-lanka/StructureDefinition/practitioner
[s28]: http://openhie.org/fhir/sri-lanka/StructureDefinition/fasting-blood-sugar
[s29]: http://openhie.org/fhir/sri-lanka/StructureDefinition/allergy-intolerance
[s30]: http://openhie.org/fhir/sri-lanka/StructureDefinition/weight
[s31]: http://openhie.org/fhir/sri-lanka/StructureDefinition/risk-behaviour-physical-activity
[s32]: http://openhie.org/fhir/sri-lanka/StructureDefinition/generic-task
[s33]: http://openhie.org/fhir/sri-lanka/StructureDefinition/random-blood-sugar
[s34]: http://openhie.org/fhir/sri-lanka/StructureDefinition/referral-task
[s35]: http://openhie.org/fhir/sri-lanka/StructureDefinition/injection
[s36]: http://fhir.health.gov.lk/StructureDefinition/lk-core-allergy-intolerance
[s37]: http://openhie.org/fhir/sri-lanka/StructureDefinition/providers-location
[s38]: http://openhie.org/fhir/sri-lanka/StructureDefinition/organization
[s39]: http://openhie.org/fhir/sri-lanka/StructureDefinition/hims-patient
[s40]: http://fhir.health.gov.lk/StructureDefinition/lk-core-organization
[s41]: http://openhie.org/fhir/sri-lanka/StructureDefinition/follow-up-plan
