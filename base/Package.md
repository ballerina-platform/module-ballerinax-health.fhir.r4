Package containing the FHIR R4 resources types

# FHIR R4 Base package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/               |

This package includes

1. FHIR R4 Data types
2. FHIR Base Resource types
3. FHIR resources parsers and serializers
4. Miscellaneous utilities required to create, access elements, manipulate FHIR resources
5. FHIR API request processors and Ballerina interceptors to implement FHIR APIs
6. Defined FHIR error types and utilities for FHIR error handling

**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR data types
This package supports all the data types defined in specification [Data Types](https://www.hl7.org/fhir/datatypes.html).

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| Appointment | [[Definition]][s1] [[Ballerina Record]][m1] |
| Account | [[Definition]][s2] [[Ballerina Record]][m2] |
| Invoice | [[Definition]][s3] [[Ballerina Record]][m3] |
| CatalogEntry | [[Definition]][s4] [[Ballerina Record]][m4] |
| EventDefinition | [[Definition]][s5] [[Ballerina Record]][m5] |
| DocumentManifest | [[Definition]][s6] [[Ballerina Record]][m6] |
| MessageDefinition | [[Definition]][s7] [[Ballerina Record]][m7] |
| Goal | [[Definition]][s8] [[Ballerina Record]][m8] |
| MedicinalProductPackaged | [[Definition]][s9] [[Ballerina Record]][m9] |
| Endpoint | [[Definition]][s10] [[Ballerina Record]][m10] |
| EnrollmentRequest | [[Definition]][s11] [[Ballerina Record]][m11] |
| Consent | [[Definition]][s12] [[Ballerina Record]][m12] |
| CapabilityStatement | [[Definition]][s13] [[Ballerina Record]][m13] |
| Medication | [[Definition]][s14] [[Ballerina Record]][m14] |
| Measure | [[Definition]][s15] [[Ballerina Record]][m15] |
| ResearchSubject | [[Definition]][s16] [[Ballerina Record]][m16] |
| Subscription | [[Definition]][s17] [[Ballerina Record]][m17] |
| GraphDefinition | [[Definition]][s18] [[Ballerina Record]][m18] |
| DocumentReference | [[Definition]][s19] [[Ballerina Record]][m19] |
| CoverageEligibilityResponse | [[Definition]][s20] [[Ballerina Record]][m20] |
| MeasureReport | [[Definition]][s21] [[Ballerina Record]][m21] |
| SubstanceReferenceInformation | [[Definition]][s22] [[Ballerina Record]][m22] |
| PractitionerRole | [[Definition]][s23] [[Ballerina Record]][m23] |
| RelatedPerson | [[Definition]][s24] [[Ballerina Record]][m24] |
| ServiceRequest | [[Definition]][s25] [[Ballerina Record]][m25] |
| SupplyRequest | [[Definition]][s26] [[Ballerina Record]][m26] |
| Practitioner | [[Definition]][s27] [[Ballerina Record]][m27] |
| VerificationResult | [[Definition]][s28] [[Ballerina Record]][m28] |
| SubstanceProtein | [[Definition]][s29] [[Ballerina Record]][m29] |
| BodyStructure | [[Definition]][s30] [[Ballerina Record]][m30] |
| Slot | [[Definition]][s31] [[Ballerina Record]][m31] |
| Contract | [[Definition]][s32] [[Ballerina Record]][m32] |
| Person | [[Definition]][s33] [[Ballerina Record]][m33] |
| RiskAssessment | [[Definition]][s34] [[Ballerina Record]][m34] |
| Group | [[Definition]][s35] [[Ballerina Record]][m35] |
| ResearchDefinition | [[Definition]][s36] [[Ballerina Record]][m36] |
| PaymentNotice | [[Definition]][s37] [[Ballerina Record]][m37] |
| MedicinalProductManufactured | [[Definition]][s38] [[Ballerina Record]][m38] |
| Organization | [[Definition]][s39] [[Ballerina Record]][m39] |
| ImplementationGuide | [[Definition]][s40] [[Ballerina Record]][m40] |
| CareTeam | [[Definition]][s41] [[Ballerina Record]][m41] |
| ImagingStudy | [[Definition]][s42] [[Ballerina Record]][m42] |
| FamilyMemberHistory | [[Definition]][s43] [[Ballerina Record]][m43] |
| ChargeItem | [[Definition]][s44] [[Ballerina Record]][m44] |
| ResearchElementDefinition | [[Definition]][s45] [[Ballerina Record]][m45] |
| ObservationDefinition | [[Definition]][s46] [[Ballerina Record]][m46] |
| SubstanceSpecification | [[Definition]][s47] [[Ballerina Record]][m47] |
| Encounter | [[Definition]][s48] [[Ballerina Record]][m48] |
| Substance | [[Definition]][s49] [[Ballerina Record]][m49] |
| SearchParameter | [[Definition]][s50] [[Ballerina Record]][m50] |
| Communication | [[Definition]][s51] [[Ballerina Record]][m51] |
| InsurancePlan | [[Definition]][s52] [[Ballerina Record]][m52] |
| Linkage | [[Definition]][s53] [[Ballerina Record]][m53] |
| SubstanceSourceMaterial | [[Definition]][s54] [[Ballerina Record]][m54] |
| ImmunizationEvaluation | [[Definition]][s55] [[Ballerina Record]][m55] |
| DeviceUseStatement | [[Definition]][s56] [[Ballerina Record]][m56] |
| RequestGroup | [[Definition]][s57] [[Ballerina Record]][m57] |
| MessageHeader | [[Definition]][s58] [[Ballerina Record]][m58] |
| DeviceRequest | [[Definition]][s59] [[Ballerina Record]][m59] |
| ImmunizationRecommendation | [[Definition]][s60] [[Ballerina Record]][m60] |
| Task | [[Definition]][s61] [[Ballerina Record]][m61] |
| Provenance | [[Definition]][s62] [[Ballerina Record]][m62] |
| Questionnaire | [[Definition]][s63] [[Ballerina Record]][m63] |
| ExplanationOfBenefit | [[Definition]][s64] [[Ballerina Record]][m64] |
| MedicinalProductPharmaceutical | [[Definition]][s65] [[Ballerina Record]][m65] |
| ResearchStudy | [[Definition]][s66] [[Ballerina Record]][m66] |
| Specimen | [[Definition]][s67] [[Ballerina Record]][m67] |
| CarePlan | [[Definition]][s68] [[Ballerina Record]][m68] |
| AllergyIntolerance | [[Definition]][s69] [[Ballerina Record]][m69] |
| StructureDefinition | [[Definition]][s70] [[Ballerina Record]][m70] |
| ChargeItemDefinition | [[Definition]][s71] [[Ballerina Record]][m71] |
| EpisodeOfCare | [[Definition]][s72] [[Ballerina Record]][m72] |
| OperationOutcome | [[Definition]][s73] [[Ballerina Record]][m73] |
| Procedure | [[Definition]][s74] [[Ballerina Record]][m74] |
| List | [[Definition]][s75] [[Ballerina Record]][m75] |
| ConceptMap | [[Definition]][s76] [[Ballerina Record]][m76] |
| ValueSet | [[Definition]][s77] [[Ballerina Record]][m77] |
| OperationDefinition | [[Definition]][s78] [[Ballerina Record]][m78] |
| Immunization | [[Definition]][s79] [[Ballerina Record]][m79] |
| MedicationRequest | [[Definition]][s80] [[Ballerina Record]][m80] |
| EffectEvidenceSynthesis | [[Definition]][s81] [[Ballerina Record]][m81] |
| BiologicallyDerivedProduct | [[Definition]][s82] [[Ballerina Record]][m82] |
| Device | [[Definition]][s83] [[Ballerina Record]][m83] |
| VisionPrescription | [[Definition]][s84] [[Ballerina Record]][m84] |
| Media | [[Definition]][s85] [[Ballerina Record]][m85] |
| MedicinalProductContraindication | [[Definition]][s86] [[Ballerina Record]][m86] |
| MolecularSequence | [[Definition]][s87] [[Ballerina Record]][m87] |
| EvidenceVariable | [[Definition]][s88] [[Ballerina Record]][m88] |
| MedicinalProduct | [[Definition]][s89] [[Ballerina Record]][m89] |
| DeviceMetric | [[Definition]][s90] [[Ballerina Record]][m90] |
| Flag | [[Definition]][s91] [[Ballerina Record]][m91] |
| CodeSystem | [[Definition]][s92] [[Ballerina Record]][m92] |
| SubstanceNucleicAcid | [[Definition]][s93] [[Ballerina Record]][m93] |
| RiskEvidenceSynthesis | [[Definition]][s94] [[Ballerina Record]][m94] |
| observation-vitalsigns | [[Definition]][s95] [[Ballerina Record]][m95] |
| AppointmentResponse | [[Definition]][s96] [[Ballerina Record]][m96] |
| StructureMap | [[Definition]][s97] [[Ballerina Record]][m97] |
| AdverseEvent | [[Definition]][s98] [[Ballerina Record]][m98] |
| GuidanceResponse | [[Definition]][s99] [[Ballerina Record]][m99] |
| Observation | [[Definition]][s100] [[Ballerina Record]][m100] |
| MedicationAdministration | [[Definition]][s101] [[Ballerina Record]][m101] |
| EnrollmentResponse | [[Definition]][s102] [[Ballerina Record]][m102] |
| Library | [[Definition]][s103] [[Ballerina Record]][m103] |
| Binary | [[Definition]][s104] [[Ballerina Record]][m104] |
| MedicinalProductInteraction | [[Definition]][s105] [[Ballerina Record]][m105] |
| MedicationStatement | [[Definition]][s106] [[Ballerina Record]][m106] |
| CommunicationRequest | [[Definition]][s107] [[Ballerina Record]][m107] |
| TestScript | [[Definition]][s108] [[Ballerina Record]][m108] |
| SubstancePolymer | [[Definition]][s109] [[Ballerina Record]][m109] |
| Basic | [[Definition]][s110] [[Ballerina Record]][m110] |
| TestReport | [[Definition]][s111] [[Ballerina Record]][m111] |
| ClaimResponse | [[Definition]][s112] [[Ballerina Record]][m112] |
| MedicationDispense | [[Definition]][s113] [[Ballerina Record]][m113] |
| DiagnosticReport | [[Definition]][s114] [[Ballerina Record]][m114] |
| OrganizationAffiliation | [[Definition]][s115] [[Ballerina Record]][m115] |
| HealthcareService | [[Definition]][s116] [[Ballerina Record]][m116] |
| MedicinalProductIndication | [[Definition]][s117] [[Ballerina Record]][m117] |
| NutritionOrder | [[Definition]][s118] [[Ballerina Record]][m118] |
| TerminologyCapabilities | [[Definition]][s119] [[Ballerina Record]][m119] |
| Evidence | [[Definition]][s120] [[Ballerina Record]][m120] |
| AuditEvent | [[Definition]][s121] [[Ballerina Record]][m121] |
| PaymentReconciliation | [[Definition]][s122] [[Ballerina Record]][m122] |
| Condition | [[Definition]][s123] [[Ballerina Record]][m123] |
| SpecimenDefinition | [[Definition]][s124] [[Ballerina Record]][m124] |
| Composition | [[Definition]][s125] [[Ballerina Record]][m125] |
| DetectedIssue | [[Definition]][s126] [[Ballerina Record]][m126] |
| Bundle | [[Definition]][s127] [[Ballerina Record]][m127] |
| CompartmentDefinition | [[Definition]][s128] [[Ballerina Record]][m128] |
| MedicinalProductIngredient | [[Definition]][s129] [[Ballerina Record]][m129] |
| MedicationKnowledge | [[Definition]][s130] [[Ballerina Record]][m130] |
| Patient | [[Definition]][s131] [[Ballerina Record]][m131] |
| Coverage | [[Definition]][s132] [[Ballerina Record]][m132] |
| QuestionnaireResponse | [[Definition]][s133] [[Ballerina Record]][m133] |
| CoverageEligibilityRequest | [[Definition]][s134] [[Ballerina Record]][m134] |
| NamingSystem | [[Definition]][s135] [[Ballerina Record]][m135] |
| MedicinalProductUndesirableEffect | [[Definition]][s136] [[Ballerina Record]][m136] |
| ExampleScenario | [[Definition]][s137] [[Ballerina Record]][m137] |
| SupplyDelivery | [[Definition]][s138] [[Ballerina Record]][m138] |
| Schedule | [[Definition]][s139] [[Ballerina Record]][m139] |
| DeviceDefinition | [[Definition]][s140] [[Ballerina Record]][m140] |
| ClinicalImpression | [[Definition]][s141] [[Ballerina Record]][m141] |
| PlanDefinition | [[Definition]][s142] [[Ballerina Record]][m142] |
| MedicinalProductAuthorization | [[Definition]][s143] [[Ballerina Record]][m143] |
| Claim | [[Definition]][s144] [[Ballerina Record]][m144] |
| Location | [[Definition]][s145] [[Ballerina Record]][m145] |

### Submodules

| Module              |                                                                      |
|---------------------|----------------------------------------------------------------------|
| [Parser][mod1]      | Sub module containing utilities required to parse and related needs. |
| [Terminology][mod2] | Sub module related to Terminology requirements                       |
| [Validator][mod3]   | Sub module related to FHIR Validation                                |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Appointment
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Account
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Invoice
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#CatalogEntry
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#EventDefinition
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#DocumentManifest
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MessageDefinition
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Goal
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProductPackaged
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Endpoint
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#EnrollmentRequest
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Consent
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#CapabilityStatement
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Medication
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Measure
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ResearchSubject
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Subscription
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#GraphDefinition
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#DocumentReference
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#CoverageEligibilityResponse
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MeasureReport
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SubstanceReferenceInformation
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#PractitionerRole
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#RelatedPerson
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ServiceRequest
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SupplyRequest
[m27]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Practitioner
[m28]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#VerificationResult
[m29]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SubstanceProtein
[m30]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#BodyStructure
[m31]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Slot
[m32]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Contract
[m33]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Person
[m34]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#RiskAssessment
[m35]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Group
[m36]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ResearchDefinition
[m37]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#PaymentNotice
[m38]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProductManufactured
[m39]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Organization
[m40]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ImplementationGuide
[m41]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#CareTeam
[m42]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ImagingStudy
[m43]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#FamilyMemberHistory
[m44]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ChargeItem
[m45]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ResearchElementDefinition
[m46]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ObservationDefinition
[m47]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SubstanceSpecification
[m48]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Encounter
[m49]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Substance
[m50]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SearchParameter
[m51]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Communication
[m52]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#InsurancePlan
[m53]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Linkage
[m54]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SubstanceSourceMaterial
[m55]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ImmunizationEvaluation
[m56]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#DeviceUseStatement
[m57]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#RequestGroup
[m58]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MessageHeader
[m59]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#DeviceRequest
[m60]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ImmunizationRecommendation
[m61]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Task
[m62]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Provenance
[m63]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Questionnaire
[m64]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ExplanationOfBenefit
[m65]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProductPharmaceutical
[m66]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ResearchStudy
[m67]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Specimen
[m68]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#CarePlan
[m69]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#AllergyIntolerance
[m70]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#StructureDefinition
[m71]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ChargeItemDefinition
[m72]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#EpisodeOfCare
[m73]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#OperationOutcome
[m74]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Procedure
[m75]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#List
[m76]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ConceptMap
[m77]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ValueSet
[m78]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#OperationDefinition
[m79]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Immunization
[m80]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicationRequest
[m81]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#EffectEvidenceSynthesis
[m82]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#BiologicallyDerivedProduct
[m83]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Device
[m84]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#VisionPrescription
[m85]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Media
[m86]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProductContraindication
[m87]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MolecularSequence
[m88]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#EvidenceVariable
[m89]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProduct
[m90]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#DeviceMetric
[m91]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Flag
[m92]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#CodeSystem
[m93]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SubstanceNucleicAcid
[m94]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#RiskEvidenceSynthesis
[m95]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#observation-vitalsigns
[m96]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#AppointmentResponse
[m97]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#StructureMap
[m98]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#AdverseEvent
[m99]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#GuidanceResponse
[m100]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Observation
[m101]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicationAdministration
[m102]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#EnrollmentResponse
[m103]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Library
[m104]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Binary
[m105]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProductInteraction
[m106]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicationStatement
[m107]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#CommunicationRequest
[m108]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#TestScript
[m109]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SubstancePolymer
[m110]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Basic
[m111]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#TestReport
[m112]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ClaimResponse
[m113]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicationDispense
[m114]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#DiagnosticReport
[m115]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#OrganizationAffiliation
[m116]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#HealthcareService
[m117]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProductIndication
[m118]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#NutritionOrder
[m119]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#TerminologyCapabilities
[m120]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Evidence
[m121]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#AuditEvent
[m122]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#PaymentReconciliation
[m123]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Condition
[m124]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SpecimenDefinition
[m125]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Composition
[m126]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#DetectedIssue
[m127]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Bundle
[m128]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#CompartmentDefinition
[m129]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProductIngredient
[m130]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicationKnowledge
[m131]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Patient
[m132]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Coverage
[m133]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#QuestionnaireResponse
[m134]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#CoverageEligibilityRequest
[m135]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#NamingSystem
[m136]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProductUndesirableEffect
[m137]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ExampleScenario
[m138]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#SupplyDelivery
[m139]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Schedule
[m140]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#DeviceDefinition
[m141]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#ClinicalImpression
[m142]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#PlanDefinition
[m143]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#MedicinalProductAuthorization
[m144]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Claim
[m145]: https://lib.ballerina.io/ballerinax/health.fhir.r4/1.0.0/#Location

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
[s20]: http://hl7.org/fhir/StructureDefinition/CoverageEligibilityResponse
[s21]: http://hl7.org/fhir/StructureDefinition/MeasureReport
[s22]: http://hl7.org/fhir/StructureDefinition/SubstanceReferenceInformation
[s23]: http://hl7.org/fhir/StructureDefinition/PractitionerRole
[s24]: http://hl7.org/fhir/StructureDefinition/RelatedPerson
[s25]: http://hl7.org/fhir/StructureDefinition/ServiceRequest
[s26]: http://hl7.org/fhir/StructureDefinition/SupplyRequest
[s27]: http://hl7.org/fhir/StructureDefinition/Practitioner
[s28]: http://hl7.org/fhir/StructureDefinition/VerificationResult
[s29]: http://hl7.org/fhir/StructureDefinition/SubstanceProtein
[s30]: http://hl7.org/fhir/StructureDefinition/BodyStructure
[s31]: http://hl7.org/fhir/StructureDefinition/Slot
[s32]: http://hl7.org/fhir/StructureDefinition/Contract
[s33]: http://hl7.org/fhir/StructureDefinition/Person
[s34]: http://hl7.org/fhir/StructureDefinition/RiskAssessment
[s35]: http://hl7.org/fhir/StructureDefinition/Group
[s36]: http://hl7.org/fhir/StructureDefinition/ResearchDefinition
[s37]: http://hl7.org/fhir/StructureDefinition/PaymentNotice
[s38]: http://hl7.org/fhir/StructureDefinition/MedicinalProductManufactured
[s39]: http://hl7.org/fhir/StructureDefinition/Organization
[s40]: http://hl7.org/fhir/StructureDefinition/ImplementationGuide
[s41]: http://hl7.org/fhir/StructureDefinition/CareTeam
[s42]: http://hl7.org/fhir/StructureDefinition/ImagingStudy
[s43]: http://hl7.org/fhir/StructureDefinition/FamilyMemberHistory
[s44]: http://hl7.org/fhir/StructureDefinition/ChargeItem
[s45]: http://hl7.org/fhir/StructureDefinition/ResearchElementDefinition
[s46]: http://hl7.org/fhir/StructureDefinition/ObservationDefinition
[s47]: http://hl7.org/fhir/StructureDefinition/SubstanceSpecification
[s48]: http://hl7.org/fhir/StructureDefinition/Encounter
[s49]: http://hl7.org/fhir/StructureDefinition/Substance
[s50]: http://hl7.org/fhir/StructureDefinition/SearchParameter
[s51]: http://hl7.org/fhir/StructureDefinition/Communication
[s52]: http://hl7.org/fhir/StructureDefinition/InsurancePlan
[s53]: http://hl7.org/fhir/StructureDefinition/Linkage
[s54]: http://hl7.org/fhir/StructureDefinition/SubstanceSourceMaterial
[s55]: http://hl7.org/fhir/StructureDefinition/ImmunizationEvaluation
[s56]: http://hl7.org/fhir/StructureDefinition/DeviceUseStatement
[s57]: http://hl7.org/fhir/StructureDefinition/RequestGroup
[s58]: http://hl7.org/fhir/StructureDefinition/MessageHeader
[s59]: http://hl7.org/fhir/StructureDefinition/DeviceRequest
[s60]: http://hl7.org/fhir/StructureDefinition/ImmunizationRecommendation
[s61]: http://hl7.org/fhir/StructureDefinition/Task
[s62]: http://hl7.org/fhir/StructureDefinition/Provenance
[s63]: http://hl7.org/fhir/StructureDefinition/Questionnaire
[s64]: http://hl7.org/fhir/StructureDefinition/ExplanationOfBenefit
[s65]: http://hl7.org/fhir/StructureDefinition/MedicinalProductPharmaceutical
[s66]: http://hl7.org/fhir/StructureDefinition/ResearchStudy
[s67]: http://hl7.org/fhir/StructureDefinition/Specimen
[s68]: http://hl7.org/fhir/StructureDefinition/CarePlan
[s69]: http://hl7.org/fhir/StructureDefinition/AllergyIntolerance
[s70]: http://hl7.org/fhir/StructureDefinition/StructureDefinition
[s71]: http://hl7.org/fhir/StructureDefinition/ChargeItemDefinition
[s72]: http://hl7.org/fhir/StructureDefinition/EpisodeOfCare
[s73]: http://hl7.org/fhir/StructureDefinition/OperationOutcome
[s74]: http://hl7.org/fhir/StructureDefinition/Procedure
[s75]: http://hl7.org/fhir/StructureDefinition/List
[s76]: http://hl7.org/fhir/StructureDefinition/ConceptMap
[s77]: http://hl7.org/fhir/StructureDefinition/ValueSet
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
[s92]: http://hl7.org/fhir/StructureDefinition/CodeSystem
[s93]: http://hl7.org/fhir/StructureDefinition/SubstanceNucleicAcid
[s94]: http://hl7.org/fhir/StructureDefinition/RiskEvidenceSynthesis
[s95]: http://hl7.org/fhir/StructureDefinition/vitalsigns
[s96]: http://hl7.org/fhir/StructureDefinition/AppointmentResponse
[s97]: http://hl7.org/fhir/StructureDefinition/StructureMap
[s98]: http://hl7.org/fhir/StructureDefinition/AdverseEvent
[s99]: http://hl7.org/fhir/StructureDefinition/GuidanceResponse
[s100]: http://hl7.org/fhir/StructureDefinition/Observation
[s101]: http://hl7.org/fhir/StructureDefinition/MedicationAdministration
[s102]: http://hl7.org/fhir/StructureDefinition/EnrollmentResponse
[s103]: http://hl7.org/fhir/StructureDefinition/Library
[s104]: http://hl7.org/fhir/StructureDefinition/Binary
[s105]: http://hl7.org/fhir/StructureDefinition/MedicinalProductInteraction
[s106]: http://hl7.org/fhir/StructureDefinition/MedicationStatement
[s107]: http://hl7.org/fhir/StructureDefinition/CommunicationRequest
[s108]: http://hl7.org/fhir/StructureDefinition/TestScript
[s109]: http://hl7.org/fhir/StructureDefinition/SubstancePolymer
[s110]: http://hl7.org/fhir/StructureDefinition/Basic
[s111]: http://hl7.org/fhir/StructureDefinition/TestReport
[s112]: http://hl7.org/fhir/StructureDefinition/ClaimResponse
[s113]: http://hl7.org/fhir/StructureDefinition/MedicationDispense
[s114]: http://hl7.org/fhir/StructureDefinition/DiagnosticReport
[s115]: http://hl7.org/fhir/StructureDefinition/OrganizationAffiliation
[s116]: http://hl7.org/fhir/StructureDefinition/HealthcareService
[s117]: http://hl7.org/fhir/StructureDefinition/MedicinalProductIndication
[s118]: http://hl7.org/fhir/StructureDefinition/NutritionOrder
[s119]: http://hl7.org/fhir/StructureDefinition/TerminologyCapabilities
[s120]: http://hl7.org/fhir/StructureDefinition/Evidence
[s121]: http://hl7.org/fhir/StructureDefinition/AuditEvent
[s122]: http://hl7.org/fhir/StructureDefinition/PaymentReconciliation
[s123]: http://hl7.org/fhir/StructureDefinition/Condition
[s124]: http://hl7.org/fhir/StructureDefinition/SpecimenDefinition
[s125]: http://hl7.org/fhir/StructureDefinition/Composition
[s126]: http://hl7.org/fhir/StructureDefinition/DetectedIssue
[s127]: http://hl7.org/fhir/StructureDefinition/Bundle
[s128]: http://hl7.org/fhir/StructureDefinition/CompartmentDefinition
[s129]: http://hl7.org/fhir/StructureDefinition/MedicinalProductIngredient
[s130]: http://hl7.org/fhir/StructureDefinition/MedicationKnowledge
[s131]: http://hl7.org/fhir/StructureDefinition/Patient
[s132]: http://hl7.org/fhir/StructureDefinition/Coverage
[s133]: http://hl7.org/fhir/StructureDefinition/QuestionnaireResponse
[s134]: http://hl7.org/fhir/StructureDefinition/CoverageEligibilityRequest
[s135]: http://hl7.org/fhir/StructureDefinition/NamingSystem
[s136]: http://hl7.org/fhir/StructureDefinition/MedicinalProductUndesirableEffect
[s137]: http://hl7.org/fhir/StructureDefinition/ExampleScenario
[s138]: http://hl7.org/fhir/StructureDefinition/SupplyDelivery
[s139]: http://hl7.org/fhir/StructureDefinition/Schedule
[s140]: http://hl7.org/fhir/StructureDefinition/DeviceDefinition
[s141]: http://hl7.org/fhir/StructureDefinition/ClinicalImpression
[s142]: http://hl7.org/fhir/StructureDefinition/PlanDefinition
[s143]: http://hl7.org/fhir/StructureDefinition/MedicinalProductAuthorization
[s144]: http://hl7.org/fhir/StructureDefinition/Claim
[s145]: http://hl7.org/fhir/StructureDefinition/Location

[mod1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.parser/1.0.0
[mod2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.terminology/1.0.0
[mod3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.validator/1.0.0