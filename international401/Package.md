
# FHIR R4 international package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://hl7.org/fhir/R4/ |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). Appointment | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). Account | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). Invoice | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). CatalogEntry | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). EventDefinition | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). DocumentManifest | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). MessageDefinition | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). Goal | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). MedicinalProductPackaged | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). Endpoint | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). EnrollmentRequest | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). Consent | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). CapabilityStatement | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). Medication | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). Measure | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). ResearchSubject | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). Subscription | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). GraphDefinition | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). DocumentReference | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). Parameters | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). CoverageEligibilityResponse | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). MeasureReport | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). SubstanceReferenceInformation | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). PractitionerRole | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). RelatedPerson | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). ServiceRequest | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). SupplyRequest | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). Practitioner | [[Definition]][s28] [[Ballerina Record]][m28] |
| 29). VerificationResult | [[Definition]][s29] [[Ballerina Record]][m29] |
| 30). SubstanceProtein | [[Definition]][s30] [[Ballerina Record]][m30] |
| 31). BodyStructure | [[Definition]][s31] [[Ballerina Record]][m31] |
| 32). Slot | [[Definition]][s32] [[Ballerina Record]][m32] |
| 33). Contract | [[Definition]][s33] [[Ballerina Record]][m33] |
| 34). Person | [[Definition]][s34] [[Ballerina Record]][m34] |
| 35). RiskAssessment | [[Definition]][s35] [[Ballerina Record]][m35] |
| 36). Group | [[Definition]][s36] [[Ballerina Record]][m36] |
| 37). ResearchDefinition | [[Definition]][s37] [[Ballerina Record]][m37] |
| 38). PaymentNotice | [[Definition]][s38] [[Ballerina Record]][m38] |
| 39). MedicinalProductManufactured | [[Definition]][s39] [[Ballerina Record]][m39] |
| 40). Organization | [[Definition]][s40] [[Ballerina Record]][m40] |
| 41). ImplementationGuide | [[Definition]][s41] [[Ballerina Record]][m41] |
| 42). CareTeam | [[Definition]][s42] [[Ballerina Record]][m42] |
| 43). ImagingStudy | [[Definition]][s43] [[Ballerina Record]][m43] |
| 44). FamilyMemberHistory | [[Definition]][s44] [[Ballerina Record]][m44] |
| 45). ChargeItem | [[Definition]][s45] [[Ballerina Record]][m45] |
| 46). ResearchElementDefinition | [[Definition]][s46] [[Ballerina Record]][m46] |
| 47). ObservationDefinition | [[Definition]][s47] [[Ballerina Record]][m47] |
| 48). SubstanceSpecification | [[Definition]][s48] [[Ballerina Record]][m48] |
| 49). Encounter | [[Definition]][s49] [[Ballerina Record]][m49] |
| 50). Substance | [[Definition]][s50] [[Ballerina Record]][m50] |
| 51). SearchParameter | [[Definition]][s51] [[Ballerina Record]][m51] |
| 52). Communication | [[Definition]][s52] [[Ballerina Record]][m52] |
| 53). InsurancePlan | [[Definition]][s53] [[Ballerina Record]][m53] |
| 54). ActivityDefinition | [[Definition]][s54] [[Ballerina Record]][m54] |
| 55). Linkage | [[Definition]][s55] [[Ballerina Record]][m55] |
| 56). SubstanceSourceMaterial | [[Definition]][s56] [[Ballerina Record]][m56] |
| 57). ImmunizationEvaluation | [[Definition]][s57] [[Ballerina Record]][m57] |
| 58). DeviceUseStatement | [[Definition]][s58] [[Ballerina Record]][m58] |
| 59). RequestGroup | [[Definition]][s59] [[Ballerina Record]][m59] |
| 60). MessageHeader | [[Definition]][s60] [[Ballerina Record]][m60] |
| 61). DeviceRequest | [[Definition]][s61] [[Ballerina Record]][m61] |
| 62). ImmunizationRecommendation | [[Definition]][s62] [[Ballerina Record]][m62] |
| 63). Task | [[Definition]][s63] [[Ballerina Record]][m63] |
| 64). Provenance | [[Definition]][s64] [[Ballerina Record]][m64] |
| 65). Questionnaire | [[Definition]][s65] [[Ballerina Record]][m65] |
| 66). ExplanationOfBenefit | [[Definition]][s66] [[Ballerina Record]][m66] |
| 67). MedicinalProductPharmaceutical | [[Definition]][s67] [[Ballerina Record]][m67] |
| 68). ResearchStudy | [[Definition]][s68] [[Ballerina Record]][m68] |
| 69). Specimen | [[Definition]][s69] [[Ballerina Record]][m69] |
| 70). CarePlan | [[Definition]][s70] [[Ballerina Record]][m70] |
| 71). AllergyIntolerance | [[Definition]][s71] [[Ballerina Record]][m71] |
| 72). StructureDefinition | [[Definition]][s72] [[Ballerina Record]][m72] |
| 73). ChargeItemDefinition | [[Definition]][s73] [[Ballerina Record]][m73] |
| 74). EpisodeOfCare | [[Definition]][s74] [[Ballerina Record]][m74] |
| 75). Procedure | [[Definition]][s75] [[Ballerina Record]][m75] |
| 76). List | [[Definition]][s76] [[Ballerina Record]][m76] |
| 77). ConceptMap | [[Definition]][s77] [[Ballerina Record]][m77] |
| 78). OperationDefinition | [[Definition]][s78] [[Ballerina Record]][m78] |
| 79). Immunization | [[Definition]][s79] [[Ballerina Record]][m79] |
| 80). MedicationRequest | [[Definition]][s80] [[Ballerina Record]][m80] |
| 81). EffectEvidenceSynthesis | [[Definition]][s81] [[Ballerina Record]][m81] |
| 82). BiologicallyDerivedProduct | [[Definition]][s82] [[Ballerina Record]][m82] |
| 83). Device | [[Definition]][s83] [[Ballerina Record]][m83] |
| 84). VisionPrescription | [[Definition]][s84] [[Ballerina Record]][m84] |
| 85). Media | [[Definition]][s85] [[Ballerina Record]][m85] |
| 86). MedicinalProductContraindication | [[Definition]][s86] [[Ballerina Record]][m86] |
| 87). MolecularSequence | [[Definition]][s87] [[Ballerina Record]][m87] |
| 88). EvidenceVariable | [[Definition]][s88] [[Ballerina Record]][m88] |
| 89). MedicinalProduct | [[Definition]][s89] [[Ballerina Record]][m89] |
| 90). DeviceMetric | [[Definition]][s90] [[Ballerina Record]][m90] |
| 91). Flag | [[Definition]][s91] [[Ballerina Record]][m91] |
| 92). SubstanceNucleicAcid | [[Definition]][s92] [[Ballerina Record]][m92] |
| 93). RiskEvidenceSynthesis | [[Definition]][s93] [[Ballerina Record]][m93] |
| 94). observation-vitalsigns | [[Definition]][s94] [[Ballerina Record]][m94] |
| 95). AppointmentResponse | [[Definition]][s95] [[Ballerina Record]][m95] |
| 96). StructureMap | [[Definition]][s96] [[Ballerina Record]][m96] |
| 97). AdverseEvent | [[Definition]][s97] [[Ballerina Record]][m97] |
| 98). GuidanceResponse | [[Definition]][s98] [[Ballerina Record]][m98] |
| 99). Observation | [[Definition]][s99] [[Ballerina Record]][m99] |
| 100). MedicationAdministration | [[Definition]][s100] [[Ballerina Record]][m100] |
| 101). EnrollmentResponse | [[Definition]][s101] [[Ballerina Record]][m101] |
| 102). Library | [[Definition]][s102] [[Ballerina Record]][m102] |
| 103). Binary | [[Definition]][s103] [[Ballerina Record]][m103] |
| 104). MedicinalProductInteraction | [[Definition]][s104] [[Ballerina Record]][m104] |
| 105). MedicationStatement | [[Definition]][s105] [[Ballerina Record]][m105] |
| 106). CommunicationRequest | [[Definition]][s106] [[Ballerina Record]][m106] |
| 107). TestScript | [[Definition]][s107] [[Ballerina Record]][m107] |
| 108). SubstancePolymer | [[Definition]][s108] [[Ballerina Record]][m108] |
| 109). Basic | [[Definition]][s109] [[Ballerina Record]][m109] |
| 110). TestReport | [[Definition]][s110] [[Ballerina Record]][m110] |
| 111). ClaimResponse | [[Definition]][s111] [[Ballerina Record]][m111] |
| 112). MedicationDispense | [[Definition]][s112] [[Ballerina Record]][m112] |
| 113). DiagnosticReport | [[Definition]][s113] [[Ballerina Record]][m113] |
| 114). OrganizationAffiliation | [[Definition]][s114] [[Ballerina Record]][m114] |
| 115). HealthcareService | [[Definition]][s115] [[Ballerina Record]][m115] |
| 116). MedicinalProductIndication | [[Definition]][s116] [[Ballerina Record]][m116] |
| 117). NutritionOrder | [[Definition]][s117] [[Ballerina Record]][m117] |
| 118). TerminologyCapabilities | [[Definition]][s118] [[Ballerina Record]][m118] |
| 119). Evidence | [[Definition]][s119] [[Ballerina Record]][m119] |
| 120). AuditEvent | [[Definition]][s120] [[Ballerina Record]][m120] |
| 121). PaymentReconciliation | [[Definition]][s121] [[Ballerina Record]][m121] |
| 122). Condition | [[Definition]][s122] [[Ballerina Record]][m122] |
| 123). SpecimenDefinition | [[Definition]][s123] [[Ballerina Record]][m123] |
| 124). Composition | [[Definition]][s124] [[Ballerina Record]][m124] |
| 125). DetectedIssue | [[Definition]][s125] [[Ballerina Record]][m125] |
| 126). CompartmentDefinition | [[Definition]][s126] [[Ballerina Record]][m126] |
| 127). MedicinalProductIngredient | [[Definition]][s127] [[Ballerina Record]][m127] |
| 128). MedicationKnowledge | [[Definition]][s128] [[Ballerina Record]][m128] |
| 129). Patient | [[Definition]][s129] [[Ballerina Record]][m129] |
| 130). Coverage | [[Definition]][s130] [[Ballerina Record]][m130] |
| 131). QuestionnaireResponse | [[Definition]][s131] [[Ballerina Record]][m131] |
| 132). CoverageEligibilityRequest | [[Definition]][s132] [[Ballerina Record]][m132] |
| 133). NamingSystem | [[Definition]][s133] [[Ballerina Record]][m133] |
| 134). MedicinalProductUndesirableEffect | [[Definition]][s134] [[Ballerina Record]][m134] |
| 135). ExampleScenario | [[Definition]][s135] [[Ballerina Record]][m135] |
| 136). SupplyDelivery | [[Definition]][s136] [[Ballerina Record]][m136] |
| 137). Schedule | [[Definition]][s137] [[Ballerina Record]][m137] |
| 138). DeviceDefinition | [[Definition]][s138] [[Ballerina Record]][m138] |
| 139). ClinicalImpression | [[Definition]][s139] [[Ballerina Record]][m139] |
| 140). PlanDefinition | [[Definition]][s140] [[Ballerina Record]][m140] |
| 141). MedicinalProductAuthorization | [[Definition]][s141] [[Ballerina Record]][m141] |
| 142). Claim | [[Definition]][s142] [[Ballerina Record]][m142] |
| 143). Location | [[Definition]][s143] [[Ballerina Record]][m143] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Appointment
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Account
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Invoice
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#CatalogEntry
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#EventDefinition
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#DocumentManifest
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MessageDefinition
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Goal
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProductPackaged
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Endpoint
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#EnrollmentRequest
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Consent
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#CapabilityStatement
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Medication
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Measure
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ResearchSubject
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Subscription
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#GraphDefinition
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#DocumentReference
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Parameters
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#CoverageEligibilityResponse
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MeasureReport
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SubstanceReferenceInformation
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#PractitionerRole
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#RelatedPerson
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ServiceRequest
[m27]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SupplyRequest
[m28]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Practitioner
[m29]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#VerificationResult
[m30]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SubstanceProtein
[m31]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#BodyStructure
[m32]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Slot
[m33]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Contract
[m34]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Person
[m35]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#RiskAssessment
[m36]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Group
[m37]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ResearchDefinition
[m38]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#PaymentNotice
[m39]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProductManufactured
[m40]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Organization
[m41]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ImplementationGuide
[m42]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#CareTeam
[m43]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ImagingStudy
[m44]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#FamilyMemberHistory
[m45]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ChargeItem
[m46]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ResearchElementDefinition
[m47]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ObservationDefinition
[m48]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SubstanceSpecification
[m49]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Encounter
[m50]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Substance
[m51]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SearchParameter
[m52]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Communication
[m53]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#InsurancePlan
[m54]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ActivityDefinition
[m55]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Linkage
[m56]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SubstanceSourceMaterial
[m57]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ImmunizationEvaluation
[m58]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#DeviceUseStatement
[m59]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#RequestGroup
[m60]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MessageHeader
[m61]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#DeviceRequest
[m62]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ImmunizationRecommendation
[m63]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Task
[m64]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Provenance
[m65]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Questionnaire
[m66]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ExplanationOfBenefit
[m67]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProductPharmaceutical
[m68]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ResearchStudy
[m69]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Specimen
[m70]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#CarePlan
[m71]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#AllergyIntolerance
[m72]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#StructureDefinition
[m73]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ChargeItemDefinition
[m74]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#EpisodeOfCare
[m75]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Procedure
[m76]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#List
[m77]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ConceptMap
[m78]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#OperationDefinition
[m79]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Immunization
[m80]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicationRequest
[m81]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#EffectEvidenceSynthesis
[m82]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#BiologicallyDerivedProduct
[m83]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Device
[m84]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#VisionPrescription
[m85]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Media
[m86]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProductContraindication
[m87]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MolecularSequence
[m88]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#EvidenceVariable
[m89]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProduct
[m90]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#DeviceMetric
[m91]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Flag
[m92]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SubstanceNucleicAcid
[m93]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#RiskEvidenceSynthesis
[m94]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#observation-vitalsigns
[m95]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#AppointmentResponse
[m96]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#StructureMap
[m97]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#AdverseEvent
[m98]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#GuidanceResponse
[m99]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Observation
[m100]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicationAdministration
[m101]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#EnrollmentResponse
[m102]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Library
[m103]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Binary
[m104]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProductInteraction
[m105]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicationStatement
[m106]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#CommunicationRequest
[m107]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#TestScript
[m108]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SubstancePolymer
[m109]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Basic
[m110]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#TestReport
[m111]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ClaimResponse
[m112]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicationDispense
[m113]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#DiagnosticReport
[m114]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#OrganizationAffiliation
[m115]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#HealthcareService
[m116]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProductIndication
[m117]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#NutritionOrder
[m118]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#TerminologyCapabilities
[m119]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Evidence
[m120]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#AuditEvent
[m121]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#PaymentReconciliation
[m122]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Condition
[m123]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SpecimenDefinition
[m124]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Composition
[m125]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#DetectedIssue
[m126]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#CompartmentDefinition
[m127]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProductIngredient
[m128]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicationKnowledge
[m129]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Patient
[m130]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Coverage
[m131]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#QuestionnaireResponse
[m132]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#CoverageEligibilityRequest
[m133]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#NamingSystem
[m134]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProductUndesirableEffect
[m135]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ExampleScenario
[m136]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#SupplyDelivery
[m137]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Schedule
[m138]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#DeviceDefinition
[m139]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#ClinicalImpression
[m140]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#PlanDefinition
[m141]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#MedicinalProductAuthorization
[m142]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Claim
[m143]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/1.0.0#Location

[s1]: http://hl7.org/fhir/StructureDefinition/Appointment
[s2]: http://hl7.org/fhir/StructureDefinition/Account
[s3]: http://hl7.org/fhir/StructureDefinition/Invoice
[s4]: http://hl7.org/fhir/StructureDefinition/CatalogEntry
[s5]: http://hl7.org/fhir/StructureDefinition/EventDefinition
[s6]: http://hl7.org/fhir/StructureDefinition/DocumentManifest
[s7]: http://hl7.org/fhir/StructureDefinition/MessageDefinition
[s8]: http://hl7.org/fhir/StructureDefinition/Goal
[s9]: http://hl7.org/fhir/StructureDefinition/MedicinalProductPackaged
[s10]: http://hl7.org/fhir/StructureDefinition/Endpoint
[s11]: http://hl7.org/fhir/StructureDefinition/EnrollmentRequest
[s12]: http://hl7.org/fhir/StructureDefinition/Consent
[s13]: http://hl7.org/fhir/StructureDefinition/CapabilityStatement
[s14]: http://hl7.org/fhir/StructureDefinition/Medication
[s15]: http://hl7.org/fhir/StructureDefinition/Measure
[s16]: http://hl7.org/fhir/StructureDefinition/ResearchSubject
[s17]: http://hl7.org/fhir/StructureDefinition/Subscription
[s18]: http://hl7.org/fhir/StructureDefinition/GraphDefinition
[s19]: http://hl7.org/fhir/StructureDefinition/DocumentReference
[s20]: http://hl7.org/fhir/StructureDefinition/Parameters
[s21]: http://hl7.org/fhir/StructureDefinition/CoverageEligibilityResponse
[s22]: http://hl7.org/fhir/StructureDefinition/MeasureReport
[s23]: http://hl7.org/fhir/StructureDefinition/SubstanceReferenceInformation
[s24]: http://hl7.org/fhir/StructureDefinition/PractitionerRole
[s25]: http://hl7.org/fhir/StructureDefinition/RelatedPerson
[s26]: http://hl7.org/fhir/StructureDefinition/ServiceRequest
[s27]: http://hl7.org/fhir/StructureDefinition/SupplyRequest
[s28]: http://hl7.org/fhir/StructureDefinition/Practitioner
[s29]: http://hl7.org/fhir/StructureDefinition/VerificationResult
[s30]: http://hl7.org/fhir/StructureDefinition/SubstanceProtein
[s31]: http://hl7.org/fhir/StructureDefinition/BodyStructure
[s32]: http://hl7.org/fhir/StructureDefinition/Slot
[s33]: http://hl7.org/fhir/StructureDefinition/Contract
[s34]: http://hl7.org/fhir/StructureDefinition/Person
[s35]: http://hl7.org/fhir/StructureDefinition/RiskAssessment
[s36]: http://hl7.org/fhir/StructureDefinition/Group
[s37]: http://hl7.org/fhir/StructureDefinition/ResearchDefinition
[s38]: http://hl7.org/fhir/StructureDefinition/PaymentNotice
[s39]: http://hl7.org/fhir/StructureDefinition/MedicinalProductManufactured
[s40]: http://hl7.org/fhir/StructureDefinition/Organization
[s41]: http://hl7.org/fhir/StructureDefinition/ImplementationGuide
[s42]: http://hl7.org/fhir/StructureDefinition/CareTeam
[s43]: http://hl7.org/fhir/StructureDefinition/ImagingStudy
[s44]: http://hl7.org/fhir/StructureDefinition/FamilyMemberHistory
[s45]: http://hl7.org/fhir/StructureDefinition/ChargeItem
[s46]: http://hl7.org/fhir/StructureDefinition/ResearchElementDefinition
[s47]: http://hl7.org/fhir/StructureDefinition/ObservationDefinition
[s48]: http://hl7.org/fhir/StructureDefinition/SubstanceSpecification
[s49]: http://hl7.org/fhir/StructureDefinition/Encounter
[s50]: http://hl7.org/fhir/StructureDefinition/Substance
[s51]: http://hl7.org/fhir/StructureDefinition/SearchParameter
[s52]: http://hl7.org/fhir/StructureDefinition/Communication
[s53]: http://hl7.org/fhir/StructureDefinition/InsurancePlan
[s54]: http://hl7.org/fhir/StructureDefinition/ActivityDefinition
[s55]: http://hl7.org/fhir/StructureDefinition/Linkage
[s56]: http://hl7.org/fhir/StructureDefinition/SubstanceSourceMaterial
[s57]: http://hl7.org/fhir/StructureDefinition/ImmunizationEvaluation
[s58]: http://hl7.org/fhir/StructureDefinition/DeviceUseStatement
[s59]: http://hl7.org/fhir/StructureDefinition/RequestGroup
[s60]: http://hl7.org/fhir/StructureDefinition/MessageHeader
[s61]: http://hl7.org/fhir/StructureDefinition/DeviceRequest
[s62]: http://hl7.org/fhir/StructureDefinition/ImmunizationRecommendation
[s63]: http://hl7.org/fhir/StructureDefinition/Task
[s64]: http://hl7.org/fhir/StructureDefinition/Provenance
[s65]: http://hl7.org/fhir/StructureDefinition/Questionnaire
[s66]: http://hl7.org/fhir/StructureDefinition/ExplanationOfBenefit
[s67]: http://hl7.org/fhir/StructureDefinition/MedicinalProductPharmaceutical
[s68]: http://hl7.org/fhir/StructureDefinition/ResearchStudy
[s69]: http://hl7.org/fhir/StructureDefinition/Specimen
[s70]: http://hl7.org/fhir/StructureDefinition/CarePlan
[s71]: http://hl7.org/fhir/StructureDefinition/AllergyIntolerance
[s72]: http://hl7.org/fhir/StructureDefinition/StructureDefinition
[s73]: http://hl7.org/fhir/StructureDefinition/ChargeItemDefinition
[s74]: http://hl7.org/fhir/StructureDefinition/EpisodeOfCare
[s75]: http://hl7.org/fhir/StructureDefinition/Procedure
[s76]: http://hl7.org/fhir/StructureDefinition/List
[s77]: http://hl7.org/fhir/StructureDefinition/ConceptMap
[s78]: http://hl7.org/fhir/StructureDefinition/OperationDefinition
[s79]: http://hl7.org/fhir/StructureDefinition/Immunization
[s80]: http://hl7.org/fhir/StructureDefinition/MedicationRequest
[s81]: http://hl7.org/fhir/StructureDefinition/EffectEvidenceSynthesis
[s82]: http://hl7.org/fhir/StructureDefinition/BiologicallyDerivedProduct
[s83]: http://hl7.org/fhir/StructureDefinition/Device
[s84]: http://hl7.org/fhir/StructureDefinition/VisionPrescription
[s85]: http://hl7.org/fhir/StructureDefinition/Media
[s86]: http://hl7.org/fhir/StructureDefinition/MedicinalProductContraindication
[s87]: http://hl7.org/fhir/StructureDefinition/MolecularSequence
[s88]: http://hl7.org/fhir/StructureDefinition/EvidenceVariable
[s89]: http://hl7.org/fhir/StructureDefinition/MedicinalProduct
[s90]: http://hl7.org/fhir/StructureDefinition/DeviceMetric
[s91]: http://hl7.org/fhir/StructureDefinition/Flag
[s92]: http://hl7.org/fhir/StructureDefinition/SubstanceNucleicAcid
[s93]: http://hl7.org/fhir/StructureDefinition/RiskEvidenceSynthesis
[s94]: http://hl7.org/fhir/StructureDefinition/vitalsigns
[s95]: http://hl7.org/fhir/StructureDefinition/AppointmentResponse
[s96]: http://hl7.org/fhir/StructureDefinition/StructureMap
[s97]: http://hl7.org/fhir/StructureDefinition/AdverseEvent
[s98]: http://hl7.org/fhir/StructureDefinition/GuidanceResponse
[s99]: http://hl7.org/fhir/StructureDefinition/Observation
[s100]: http://hl7.org/fhir/StructureDefinition/MedicationAdministration
[s101]: http://hl7.org/fhir/StructureDefinition/EnrollmentResponse
[s102]: http://hl7.org/fhir/StructureDefinition/Library
[s103]: http://hl7.org/fhir/StructureDefinition/Binary
[s104]: http://hl7.org/fhir/StructureDefinition/MedicinalProductInteraction
[s105]: http://hl7.org/fhir/StructureDefinition/MedicationStatement
[s106]: http://hl7.org/fhir/StructureDefinition/CommunicationRequest
[s107]: http://hl7.org/fhir/StructureDefinition/TestScript
[s108]: http://hl7.org/fhir/StructureDefinition/SubstancePolymer
[s109]: http://hl7.org/fhir/StructureDefinition/Basic
[s110]: http://hl7.org/fhir/StructureDefinition/TestReport
[s111]: http://hl7.org/fhir/StructureDefinition/ClaimResponse
[s112]: http://hl7.org/fhir/StructureDefinition/MedicationDispense
[s113]: http://hl7.org/fhir/StructureDefinition/DiagnosticReport
[s114]: http://hl7.org/fhir/StructureDefinition/OrganizationAffiliation
[s115]: http://hl7.org/fhir/StructureDefinition/HealthcareService
[s116]: http://hl7.org/fhir/StructureDefinition/MedicinalProductIndication
[s117]: http://hl7.org/fhir/StructureDefinition/NutritionOrder
[s118]: http://hl7.org/fhir/StructureDefinition/TerminologyCapabilities
[s119]: http://hl7.org/fhir/StructureDefinition/Evidence
[s120]: http://hl7.org/fhir/StructureDefinition/AuditEvent
[s121]: http://hl7.org/fhir/StructureDefinition/PaymentReconciliation
[s122]: http://hl7.org/fhir/StructureDefinition/Condition
[s123]: http://hl7.org/fhir/StructureDefinition/SpecimenDefinition
[s124]: http://hl7.org/fhir/StructureDefinition/Composition
[s125]: http://hl7.org/fhir/StructureDefinition/DetectedIssue
[s126]: http://hl7.org/fhir/StructureDefinition/CompartmentDefinition
[s127]: http://hl7.org/fhir/StructureDefinition/MedicinalProductIngredient
[s128]: http://hl7.org/fhir/StructureDefinition/MedicationKnowledge
[s129]: http://hl7.org/fhir/StructureDefinition/Patient
[s130]: http://hl7.org/fhir/StructureDefinition/Coverage
[s131]: http://hl7.org/fhir/StructureDefinition/QuestionnaireResponse
[s132]: http://hl7.org/fhir/StructureDefinition/CoverageEligibilityRequest
[s133]: http://hl7.org/fhir/StructureDefinition/NamingSystem
[s134]: http://hl7.org/fhir/StructureDefinition/MedicinalProductUndesirableEffect
[s135]: http://hl7.org/fhir/StructureDefinition/ExampleScenario
[s136]: http://hl7.org/fhir/StructureDefinition/SupplyDelivery
[s137]: http://hl7.org/fhir/StructureDefinition/Schedule
[s138]: http://hl7.org/fhir/StructureDefinition/DeviceDefinition
[s139]: http://hl7.org/fhir/StructureDefinition/ClinicalImpression
[s140]: http://hl7.org/fhir/StructureDefinition/PlanDefinition
[s141]: http://hl7.org/fhir/StructureDefinition/MedicinalProductAuthorization
[s142]: http://hl7.org/fhir/StructureDefinition/Claim
[s143]: http://hl7.org/fhir/StructureDefinition/Location
