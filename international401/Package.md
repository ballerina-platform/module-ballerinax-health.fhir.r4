Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/R4/ implementation guide.

# FHIR R4 International package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/R4/               |


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
| 5). observation_bodyheight | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). EventDefinition | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). observation_heartrate | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). DocumentManifest | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). MessageDefinition | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). Goal | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). MedicinalProductPackaged | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). Endpoint | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). EnrollmentRequest | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). Consent | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). CapabilityStatement | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). Medication | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). Measure | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). ResearchSubject | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). Familymemberhistoryforgeneticsanalysis | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). Subscription | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). GraphDefinition | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). DocumentReference | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). ShareableLibrary | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). Parameters | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). CoverageEligibilityResponse | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). MeasureReport | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). ActualGroup | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). SubstanceReferenceInformation | [[Definition]][s28] [[Ballerina Record]][m28] |
| 29). PractitionerRole | [[Definition]][s29] [[Ballerina Record]][m29] |
| 30). RelatedPerson | [[Definition]][s30] [[Ballerina Record]][m30] |
| 31). ServiceRequest | [[Definition]][s31] [[Ballerina Record]][m31] |
| 32). SupplyRequest | [[Definition]][s32] [[Ballerina Record]][m32] |
| 33). ProvenanceRelevantHistory | [[Definition]][s33] [[Ballerina Record]][m33] |
| 34). Practitioner | [[Definition]][s34] [[Ballerina Record]][m34] |
| 35). VerificationResult | [[Definition]][s35] [[Ballerina Record]][m35] |
| 36). GroupDefinition | [[Definition]][s36] [[Ballerina Record]][m36] |
| 37). observation_bp | [[Definition]][s37] [[Ballerina Record]][m37] |
| 38). SubstanceProtein | [[Definition]][s38] [[Ballerina Record]][m38] |
| 39). BodyStructure | [[Definition]][s39] [[Ballerina Record]][m39] |
| 40). ShareablePlanDefinition | [[Definition]][s40] [[Ballerina Record]][m40] |
| 41). Slot | [[Definition]][s41] [[Ballerina Record]][m41] |
| 42). Contract | [[Definition]][s42] [[Ballerina Record]][m42] |
| 43). Person | [[Definition]][s43] [[Ballerina Record]][m43] |
| 44). RiskAssessment | [[Definition]][s44] [[Ballerina Record]][m44] |
| 45). CDSHooksServicePlanDefinition | [[Definition]][s45] [[Ballerina Record]][m45] |
| 46). Group | [[Definition]][s46] [[Ballerina Record]][m46] |
| 47). ResearchDefinition | [[Definition]][s47] [[Ballerina Record]][m47] |
| 48). PaymentNotice | [[Definition]][s48] [[Ballerina Record]][m48] |
| 49). MedicinalProductManufactured | [[Definition]][s49] [[Ballerina Record]][m49] |
| 50). Organization | [[Definition]][s50] [[Ballerina Record]][m50] |
| 51). ImplementationGuide | [[Definition]][s51] [[Ballerina Record]][m51] |
| 52). CareTeam | [[Definition]][s52] [[Ballerina Record]][m52] |
| 53). observation_vitalspanel | [[Definition]][s53] [[Ballerina Record]][m53] |
| 54). ImagingStudy | [[Definition]][s54] [[Ballerina Record]][m54] |
| 55). FamilyMemberHistory | [[Definition]][s55] [[Ballerina Record]][m55] |
| 56). ChargeItem | [[Definition]][s56] [[Ballerina Record]][m56] |
| 57). EHRSFMRecordLifecycleEvent_AuditEvent | [[Definition]][s57] [[Ballerina Record]][m57] |
| 58). ResearchElementDefinition | [[Definition]][s58] [[Ballerina Record]][m58] |
| 59). ObservationDefinition | [[Definition]][s59] [[Ballerina Record]][m59] |
| 60). ServiceRequest_Genetics | [[Definition]][s60] [[Ballerina Record]][m60] |
| 61). SubstanceSpecification | [[Definition]][s61] [[Ballerina Record]][m61] |
| 62). Encounter | [[Definition]][s62] [[Ballerina Record]][m62] |
| 63). Substance | [[Definition]][s63] [[Ballerina Record]][m63] |
| 64). ShareableActivityDefinition | [[Definition]][s64] [[Ballerina Record]][m64] |
| 65). SearchParameter | [[Definition]][s65] [[Ballerina Record]][m65] |
| 66). ProfileforHLAGenotypingResults | [[Definition]][s66] [[Ballerina Record]][m66] |
| 67). Communication | [[Definition]][s67] [[Ballerina Record]][m67] |
| 68). InsurancePlan | [[Definition]][s68] [[Ballerina Record]][m68] |
| 69). ActivityDefinition | [[Definition]][s69] [[Ballerina Record]][m69] |
| 70). ExampleLipidProfile | [[Definition]][s70] [[Ballerina Record]][m70] |
| 71). Linkage | [[Definition]][s71] [[Ballerina Record]][m71] |
| 72). EHRSFMRecordLifecycleEvent_Provenance | [[Definition]][s72] [[Ballerina Record]][m72] |
| 73). Observation_genetics | [[Definition]][s73] [[Ballerina Record]][m73] |
| 74). SubstanceSourceMaterial | [[Definition]][s74] [[Ballerina Record]][m74] |
| 75). ImmunizationEvaluation | [[Definition]][s75] [[Ballerina Record]][m75] |
| 76). observation_bodytemp | [[Definition]][s76] [[Ballerina Record]][m76] |
| 77). DeviceUseStatement | [[Definition]][s77] [[Ballerina Record]][m77] |
| 78). EvidenceSynthesisProfile | [[Definition]][s78] [[Ballerina Record]][m78] |
| 79). RequestGroup | [[Definition]][s79] [[Ballerina Record]][m79] |
| 80). MessageHeader | [[Definition]][s80] [[Ballerina Record]][m80] |
| 81). DeviceRequest | [[Definition]][s81] [[Ballerina Record]][m81] |
| 82). ImmunizationRecommendation | [[Definition]][s82] [[Ballerina Record]][m82] |
| 83). observation_oxygensat | [[Definition]][s83] [[Ballerina Record]][m83] |
| 84). Task | [[Definition]][s84] [[Ballerina Record]][m84] |
| 85). Provenance | [[Definition]][s85] [[Ballerina Record]][m85] |
| 86). Questionnaire | [[Definition]][s86] [[Ballerina Record]][m86] |
| 87). PICOElementProfile | [[Definition]][s87] [[Ballerina Record]][m87] |
| 88). ComputablePlanDefinition | [[Definition]][s88] [[Ballerina Record]][m88] |
| 89). ExplanationOfBenefit | [[Definition]][s89] [[Ballerina Record]][m89] |
| 90). MedicinalProductPharmaceutical | [[Definition]][s90] [[Ballerina Record]][m90] |
| 91). ResearchStudy | [[Definition]][s91] [[Ballerina Record]][m91] |
| 92). Specimen | [[Definition]][s92] [[Ballerina Record]][m92] |
| 93). CarePlan | [[Definition]][s93] [[Ballerina Record]][m93] |
| 94). AllergyIntolerance | [[Definition]][s94] [[Ballerina Record]][m94] |
| 95). StructureDefinition | [[Definition]][s95] [[Ballerina Record]][m95] |
| 96). ChargeItemDefinition | [[Definition]][s96] [[Ballerina Record]][m96] |
| 97). EpisodeOfCare | [[Definition]][s97] [[Ballerina Record]][m97] |
| 98). CQF_Questionnaire | [[Definition]][s98] [[Ballerina Record]][m98] |
| 99). Procedure | [[Definition]][s99] [[Ballerina Record]][m99] |
| 100). List | [[Definition]][s100] [[Ballerina Record]][m100] |
| 101). ConceptMap | [[Definition]][s101] [[Ballerina Record]][m101] |
| 102). CDSHooksRequestGroup | [[Definition]][s102] [[Ballerina Record]][m102] |
| 103). OperationDefinition | [[Definition]][s103] [[Ballerina Record]][m103] |
| 104). Immunization | [[Definition]][s104] [[Ballerina Record]][m104] |
| 105). MedicationRequest | [[Definition]][s105] [[Ballerina Record]][m105] |
| 106). EffectEvidenceSynthesis | [[Definition]][s106] [[Ballerina Record]][m106] |
| 107). BiologicallyDerivedProduct | [[Definition]][s107] [[Ballerina Record]][m107] |
| 108). Device | [[Definition]][s108] [[Ballerina Record]][m108] |
| 109). ShareableMeasure | [[Definition]][s109] [[Ballerina Record]][m109] |
| 110). VisionPrescription | [[Definition]][s110] [[Ballerina Record]][m110] |
| 111). Media | [[Definition]][s111] [[Ballerina Record]][m111] |
| 112). MedicinalProductContraindication | [[Definition]][s112] [[Ballerina Record]][m112] |
| 113). MolecularSequence | [[Definition]][s113] [[Ballerina Record]][m113] |
| 114). EvidenceVariable | [[Definition]][s114] [[Ballerina Record]][m114] |
| 115). MedicinalProduct | [[Definition]][s115] [[Ballerina Record]][m115] |
| 116). ClinicalDocument | [[Definition]][s116] [[Ballerina Record]][m116] |
| 117). DeviceMetric | [[Definition]][s117] [[Ballerina Record]][m117] |
| 118). observation_headcircum | [[Definition]][s118] [[Ballerina Record]][m118] |
| 119). Flag | [[Definition]][s119] [[Ballerina Record]][m119] |
| 120). SubstanceNucleicAcid | [[Definition]][s120] [[Ballerina Record]][m120] |
| 121). RiskEvidenceSynthesis | [[Definition]][s121] [[Ballerina Record]][m121] |
| 122). observation_vitalsigns | [[Definition]][s122] [[Ballerina Record]][m122] |
| 123). AppointmentResponse | [[Definition]][s123] [[Ballerina Record]][m123] |
| 124). DeviceMetricObservationProfile | [[Definition]][s124] [[Ballerina Record]][m124] |
| 125). StructureMap | [[Definition]][s125] [[Ballerina Record]][m125] |
| 126). AdverseEvent | [[Definition]][s126] [[Ballerina Record]][m126] |
| 127). CQLLibrary | [[Definition]][s127] [[Ballerina Record]][m127] |
| 128). GuidanceResponse | [[Definition]][s128] [[Ballerina Record]][m128] |
| 129). DiagnosticReport_Genetics | [[Definition]][s129] [[Ballerina Record]][m129] |
| 130). Observation | [[Definition]][s130] [[Ballerina Record]][m130] |
| 131). MedicationAdministration | [[Definition]][s131] [[Ballerina Record]][m131] |
| 132). EnrollmentResponse | [[Definition]][s132] [[Ballerina Record]][m132] |
| 133). Library | [[Definition]][s133] [[Ballerina Record]][m133] |
| 134). Binary | [[Definition]][s134] [[Ballerina Record]][m134] |
| 135). MedicinalProductInteraction | [[Definition]][s135] [[Ballerina Record]][m135] |
| 136). MedicationStatement | [[Definition]][s136] [[Ballerina Record]][m136] |
| 137). CommunicationRequest | [[Definition]][s137] [[Ballerina Record]][m137] |
| 138). TestScript | [[Definition]][s138] [[Ballerina Record]][m138] |
| 139). SubstancePolymer | [[Definition]][s139] [[Ballerina Record]][m139] |
| 140). Basic | [[Definition]][s140] [[Ballerina Record]][m140] |
| 141). TestReport | [[Definition]][s141] [[Ballerina Record]][m141] |
| 142). ClaimResponse | [[Definition]][s142] [[Ballerina Record]][m142] |
| 143). MedicationDispense | [[Definition]][s143] [[Ballerina Record]][m143] |
| 144). observation_bodyweight | [[Definition]][s144] [[Ballerina Record]][m144] |
| 145). DiagnosticReport | [[Definition]][s145] [[Ballerina Record]][m145] |
| 146). OrganizationAffiliation | [[Definition]][s146] [[Ballerina Record]][m146] |
| 147). HealthcareService | [[Definition]][s147] [[Ballerina Record]][m147] |
| 148). MedicinalProductIndication | [[Definition]][s148] [[Ballerina Record]][m148] |
| 149). ProfileforCatalog | [[Definition]][s149] [[Ballerina Record]][m149] |
| 150). NutritionOrder | [[Definition]][s150] [[Ballerina Record]][m150] |
| 151). TerminologyCapabilities | [[Definition]][s151] [[Ballerina Record]][m151] |
| 152). CDSHooksGuidanceResponse | [[Definition]][s152] [[Ballerina Record]][m152] |
| 153). Evidence | [[Definition]][s153] [[Ballerina Record]][m153] |
| 154). AuditEvent | [[Definition]][s154] [[Ballerina Record]][m154] |
| 155). PaymentReconciliation | [[Definition]][s155] [[Ballerina Record]][m155] |
| 156). Condition | [[Definition]][s156] [[Ballerina Record]][m156] |
| 157). SpecimenDefinition | [[Definition]][s157] [[Ballerina Record]][m157] |
| 158). Composition | [[Definition]][s158] [[Ballerina Record]][m158] |
| 159). DetectedIssue | [[Definition]][s159] [[Ballerina Record]][m159] |
| 160). CompartmentDefinition | [[Definition]][s160] [[Ballerina Record]][m160] |
| 161). MedicinalProductIngredient | [[Definition]][s161] [[Ballerina Record]][m161] |
| 162). MedicationKnowledge | [[Definition]][s162] [[Ballerina Record]][m162] |
| 163). Patient | [[Definition]][s163] [[Ballerina Record]][m163] |
| 164). Coverage | [[Definition]][s164] [[Ballerina Record]][m164] |
| 165). QuestionnaireResponse | [[Definition]][s165] [[Ballerina Record]][m165] |
| 166). CoverageEligibilityRequest | [[Definition]][s166] [[Ballerina Record]][m166] |
| 167). NamingSystem | [[Definition]][s167] [[Ballerina Record]][m167] |
| 168). MedicinalProductUndesirableEffect | [[Definition]][s168] [[Ballerina Record]][m168] |
| 169). ExampleScenario | [[Definition]][s169] [[Ballerina Record]][m169] |
| 170). observation_resprate | [[Definition]][s170] [[Ballerina Record]][m170] |
| 171). SupplyDelivery | [[Definition]][s171] [[Ballerina Record]][m171] |
| 172). Schedule | [[Definition]][s172] [[Ballerina Record]][m172] |
| 173). DeviceDefinition | [[Definition]][s173] [[Ballerina Record]][m173] |
| 174). ClinicalImpression | [[Definition]][s174] [[Ballerina Record]][m174] |
| 175). PlanDefinition | [[Definition]][s175] [[Ballerina Record]][m175] |
| 176). MedicinalProductAuthorization | [[Definition]][s176] [[Ballerina Record]][m176] |
| 177). observation_bmi | [[Definition]][s177] [[Ballerina Record]][m177] |
| 178). Claim | [[Definition]][s178] [[Ballerina Record]][m178] |
| 179). Location | [[Definition]][s179] [[Ballerina Record]][m179] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Appointment
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Account
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Invoice
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CatalogEntry
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_bodyheight
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#EventDefinition
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_heartrate
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DocumentManifest
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MessageDefinition
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Goal
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProductPackaged
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Endpoint
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#EnrollmentRequest
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Consent
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CapabilityStatement
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Medication
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Measure
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ResearchSubject
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Familymemberhistoryforgeneticsanalysis
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Subscription
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#GraphDefinition
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DocumentReference
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ShareableLibrary
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Parameters
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CoverageEligibilityResponse
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MeasureReport
[m27]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ActualGroup
[m28]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SubstanceReferenceInformation
[m29]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#PractitionerRole
[m30]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#RelatedPerson
[m31]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ServiceRequest
[m32]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SupplyRequest
[m33]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ProvenanceRelevantHistory
[m34]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Practitioner
[m35]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#VerificationResult
[m36]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#GroupDefinition
[m37]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_bp
[m38]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SubstanceProtein
[m39]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#BodyStructure
[m40]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ShareablePlanDefinition
[m41]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Slot
[m42]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Contract
[m43]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Person
[m44]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#RiskAssessment
[m45]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CDSHooksServicePlanDefinition
[m46]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Group
[m47]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ResearchDefinition
[m48]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#PaymentNotice
[m49]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProductManufactured
[m50]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Organization
[m51]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ImplementationGuide
[m52]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CareTeam
[m53]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_vitalspanel
[m54]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ImagingStudy
[m55]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#FamilyMemberHistory
[m56]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ChargeItem
[m57]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#EHRSFMRecordLifecycleEvent_AuditEvent
[m58]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ResearchElementDefinition
[m59]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ObservationDefinition
[m60]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ServiceRequest_Genetics
[m61]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SubstanceSpecification
[m62]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Encounter
[m63]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Substance
[m64]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ShareableActivityDefinition
[m65]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SearchParameter
[m66]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ProfileforHLAGenotypingResults
[m67]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Communication
[m68]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#InsurancePlan
[m69]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ActivityDefinition
[m70]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ExampleLipidProfile
[m71]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Linkage
[m72]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#EHRSFMRecordLifecycleEvent_Provenance
[m73]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Observation_genetics
[m74]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SubstanceSourceMaterial
[m75]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ImmunizationEvaluation
[m76]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_bodytemp
[m77]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DeviceUseStatement
[m78]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#EvidenceSynthesisProfile
[m79]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#RequestGroup
[m80]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MessageHeader
[m81]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DeviceRequest
[m82]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ImmunizationRecommendation
[m83]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_oxygensat
[m84]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Task
[m85]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Provenance
[m86]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Questionnaire
[m87]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#PICOElementProfile
[m88]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ComputablePlanDefinition
[m89]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ExplanationOfBenefit
[m90]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProductPharmaceutical
[m91]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ResearchStudy
[m92]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Specimen
[m93]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CarePlan
[m94]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#AllergyIntolerance
[m95]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#StructureDefinition
[m96]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ChargeItemDefinition
[m97]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#EpisodeOfCare
[m98]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CQF_Questionnaire
[m99]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Procedure
[m100]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#List
[m101]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ConceptMap
[m102]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CDSHooksRequestGroup
[m103]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#OperationDefinition
[m104]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Immunization
[m105]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicationRequest
[m106]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#EffectEvidenceSynthesis
[m107]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#BiologicallyDerivedProduct
[m108]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Device
[m109]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ShareableMeasure
[m110]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#VisionPrescription
[m111]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Media
[m112]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProductContraindication
[m113]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MolecularSequence
[m114]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#EvidenceVariable
[m115]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProduct
[m116]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ClinicalDocument
[m117]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DeviceMetric
[m118]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_headcircum
[m119]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Flag
[m120]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SubstanceNucleicAcid
[m121]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#RiskEvidenceSynthesis
[m122]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_vitalsigns
[m123]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#AppointmentResponse
[m124]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DeviceMetricObservationProfile
[m125]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#StructureMap
[m126]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#AdverseEvent
[m127]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CQLLibrary
[m128]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#GuidanceResponse
[m129]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DiagnosticReport_Genetics
[m130]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Observation
[m131]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicationAdministration
[m132]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#EnrollmentResponse
[m133]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Library
[m134]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Binary
[m135]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProductInteraction
[m136]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicationStatement
[m137]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CommunicationRequest
[m138]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#TestScript
[m139]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SubstancePolymer
[m140]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Basic
[m141]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#TestReport
[m142]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ClaimResponse
[m143]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicationDispense
[m144]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_bodyweight
[m145]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DiagnosticReport
[m146]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#OrganizationAffiliation
[m147]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#HealthcareService
[m148]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProductIndication
[m149]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ProfileforCatalog
[m150]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#NutritionOrder
[m151]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#TerminologyCapabilities
[m152]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CDSHooksGuidanceResponse
[m153]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Evidence
[m154]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#AuditEvent
[m155]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#PaymentReconciliation
[m156]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Condition
[m157]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SpecimenDefinition
[m158]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Composition
[m159]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DetectedIssue
[m160]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CompartmentDefinition
[m161]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProductIngredient
[m162]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicationKnowledge
[m163]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Patient
[m164]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Coverage
[m165]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#QuestionnaireResponse
[m166]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#CoverageEligibilityRequest
[m167]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#NamingSystem
[m168]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProductUndesirableEffect
[m169]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ExampleScenario
[m170]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_resprate
[m171]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#SupplyDelivery
[m172]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Schedule
[m173]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#DeviceDefinition
[m174]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#ClinicalImpression
[m175]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#PlanDefinition
[m176]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#MedicinalProductAuthorization
[m177]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#observation_bmi
[m178]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Claim
[m179]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Location

[s1]: http://hl7.org/fhir/R4/R4/StructureDefinition/Appointment
[s2]: http://hl7.org/fhir/R4/R4/StructureDefinition/Account
[s3]: http://hl7.org/fhir/R4/R4/StructureDefinition/Invoice
[s4]: http://hl7.org/fhir/R4/R4/StructureDefinition/CatalogEntry
[s5]: http://hl7.org/fhir/R4/R4/StructureDefinition/bodyheight
[s6]: http://hl7.org/fhir/R4/R4/StructureDefinition/EventDefinition
[s7]: http://hl7.org/fhir/R4/R4/StructureDefinition/heartrate
[s8]: http://hl7.org/fhir/R4/R4/StructureDefinition/DocumentManifest
[s9]: http://hl7.org/fhir/R4/R4/StructureDefinition/MessageDefinition
[s10]: http://hl7.org/fhir/R4/StructureDefinition/Goal
[s11]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProductPackaged
[s12]: http://hl7.org/fhir/R4/StructureDefinition/Endpoint
[s13]: http://hl7.org/fhir/R4/StructureDefinition/EnrollmentRequest
[s14]: http://hl7.org/fhir/R4/StructureDefinition/Consent
[s15]: http://hl7.org/fhir/R4/StructureDefinition/CapabilityStatement
[s16]: http://hl7.org/fhir/R4/StructureDefinition/Medication
[s17]: http://hl7.org/fhir/R4/StructureDefinition/Measure
[s18]: http://hl7.org/fhir/R4/StructureDefinition/ResearchSubject
[s19]: http://hl7.org/fhir/R4/StructureDefinition/familymemberhistory-genetic
[s20]: http://hl7.org/fhir/R4/StructureDefinition/Subscription
[s21]: http://hl7.org/fhir/R4/StructureDefinition/GraphDefinition
[s22]: http://hl7.org/fhir/R4/StructureDefinition/DocumentReference
[s23]: http://hl7.org/fhir/R4/StructureDefinition/shareablelibrary
[s24]: http://hl7.org/fhir/R4/StructureDefinition/Parameters
[s25]: http://hl7.org/fhir/R4/StructureDefinition/CoverageEligibilityResponse
[s26]: http://hl7.org/fhir/R4/StructureDefinition/MeasureReport
[s27]: http://hl7.org/fhir/R4/StructureDefinition/actualgroup
[s28]: http://hl7.org/fhir/R4/StructureDefinition/SubstanceReferenceInformation
[s29]: http://hl7.org/fhir/R4/StructureDefinition/PractitionerRole
[s30]: http://hl7.org/fhir/R4/StructureDefinition/RelatedPerson
[s31]: http://hl7.org/fhir/R4/StructureDefinition/ServiceRequest
[s32]: http://hl7.org/fhir/R4/StructureDefinition/SupplyRequest
[s33]: http://hl7.org/fhir/R4/StructureDefinition/provenance-relevant-history
[s34]: http://hl7.org/fhir/R4/StructureDefinition/Practitioner
[s35]: http://hl7.org/fhir/R4/StructureDefinition/VerificationResult
[s36]: http://hl7.org/fhir/R4/StructureDefinition/groupdefinition
[s37]: http://hl7.org/fhir/R4/StructureDefinition/bp
[s38]: http://hl7.org/fhir/R4/StructureDefinition/SubstanceProtein
[s39]: http://hl7.org/fhir/R4/StructureDefinition/BodyStructure
[s40]: http://hl7.org/fhir/R4/StructureDefinition/shareableplandefinition
[s41]: http://hl7.org/fhir/R4/StructureDefinition/Slot
[s42]: http://hl7.org/fhir/R4/StructureDefinition/Contract
[s43]: http://hl7.org/fhir/R4/StructureDefinition/Person
[s44]: http://hl7.org/fhir/R4/StructureDefinition/RiskAssessment
[s45]: http://hl7.org/fhir/R4/StructureDefinition/cdshooksserviceplandefinition
[s46]: http://hl7.org/fhir/R4/StructureDefinition/Group
[s47]: http://hl7.org/fhir/R4/StructureDefinition/ResearchDefinition
[s48]: http://hl7.org/fhir/R4/StructureDefinition/PaymentNotice
[s49]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProductManufactured
[s50]: http://hl7.org/fhir/R4/StructureDefinition/Organization
[s51]: http://hl7.org/fhir/R4/StructureDefinition/ImplementationGuide
[s52]: http://hl7.org/fhir/R4/StructureDefinition/CareTeam
[s53]: http://hl7.org/fhir/R4/StructureDefinition/vitalspanel
[s54]: http://hl7.org/fhir/R4/StructureDefinition/ImagingStudy
[s55]: http://hl7.org/fhir/R4/StructureDefinition/FamilyMemberHistory
[s56]: http://hl7.org/fhir/R4/StructureDefinition/ChargeItem
[s57]: http://hl7.org/fhir/R4/StructureDefinition/ehrsrle-auditevent
[s58]: http://hl7.org/fhir/R4/StructureDefinition/ResearchElementDefinition
[s59]: http://hl7.org/fhir/R4/StructureDefinition/ObservationDefinition
[s60]: http://hl7.org/fhir/R4/StructureDefinition/servicerequest-genetics
[s61]: http://hl7.org/fhir/R4/StructureDefinition/SubstanceSpecification
[s62]: http://hl7.org/fhir/R4/StructureDefinition/Encounter
[s63]: http://hl7.org/fhir/R4/StructureDefinition/Substance
[s64]: http://hl7.org/fhir/R4/StructureDefinition/shareableactivitydefinition
[s65]: http://hl7.org/fhir/R4/StructureDefinition/SearchParameter
[s66]: http://hl7.org/fhir/R4/StructureDefinition/hlaresult
[s67]: http://hl7.org/fhir/R4/StructureDefinition/Communication
[s68]: http://hl7.org/fhir/R4/StructureDefinition/InsurancePlan
[s69]: http://hl7.org/fhir/R4/StructureDefinition/ActivityDefinition
[s70]: http://hl7.org/fhir/R4/StructureDefinition/lipidprofile
[s71]: http://hl7.org/fhir/R4/StructureDefinition/Linkage
[s72]: http://hl7.org/fhir/R4/StructureDefinition/ehrsrle-provenance
[s73]: http://hl7.org/fhir/R4/StructureDefinition/observation-genetics
[s74]: http://hl7.org/fhir/R4/StructureDefinition/SubstanceSourceMaterial
[s75]: http://hl7.org/fhir/R4/StructureDefinition/ImmunizationEvaluation
[s76]: http://hl7.org/fhir/R4/StructureDefinition/bodytemp
[s77]: http://hl7.org/fhir/R4/StructureDefinition/DeviceUseStatement
[s78]: http://hl7.org/fhir/R4/StructureDefinition/synthesis
[s79]: http://hl7.org/fhir/R4/StructureDefinition/RequestGroup
[s80]: http://hl7.org/fhir/R4/StructureDefinition/MessageHeader
[s81]: http://hl7.org/fhir/R4/StructureDefinition/DeviceRequest
[s82]: http://hl7.org/fhir/R4/StructureDefinition/ImmunizationRecommendation
[s83]: http://hl7.org/fhir/R4/StructureDefinition/oxygensat
[s84]: http://hl7.org/fhir/R4/StructureDefinition/Task
[s85]: http://hl7.org/fhir/R4/StructureDefinition/Provenance
[s86]: http://hl7.org/fhir/R4/StructureDefinition/Questionnaire
[s87]: http://hl7.org/fhir/R4/StructureDefinition/picoelement
[s88]: http://hl7.org/fhir/R4/StructureDefinition/computableplandefinition
[s89]: http://hl7.org/fhir/R4/StructureDefinition/ExplanationOfBenefit
[s90]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProductPharmaceutical
[s91]: http://hl7.org/fhir/R4/StructureDefinition/ResearchStudy
[s92]: http://hl7.org/fhir/R4/StructureDefinition/Specimen
[s93]: http://hl7.org/fhir/R4/StructureDefinition/CarePlan
[s94]: http://hl7.org/fhir/R4/StructureDefinition/AllergyIntolerance
[s95]: http://hl7.org/fhir/R4/StructureDefinition/StructureDefinition
[s96]: http://hl7.org/fhir/R4/StructureDefinition/ChargeItemDefinition
[s97]: http://hl7.org/fhir/R4/StructureDefinition/EpisodeOfCare
[s98]: http://hl7.org/fhir/R4/StructureDefinition/cqf-questionnaire
[s99]: http://hl7.org/fhir/R4/StructureDefinition/Procedure
[s100]: http://hl7.org/fhir/R4/StructureDefinition/List
[s101]: http://hl7.org/fhir/R4/StructureDefinition/ConceptMap
[s102]: http://hl7.org/fhir/R4/StructureDefinition/cdshooksrequestgroup
[s103]: http://hl7.org/fhir/R4/StructureDefinition/OperationDefinition
[s104]: http://hl7.org/fhir/R4/StructureDefinition/Immunization
[s105]: http://hl7.org/fhir/R4/StructureDefinition/MedicationRequest
[s106]: http://hl7.org/fhir/R4/StructureDefinition/EffectEvidenceSynthesis
[s107]: http://hl7.org/fhir/R4/StructureDefinition/BiologicallyDerivedProduct
[s108]: http://hl7.org/fhir/R4/StructureDefinition/Device
[s109]: http://hl7.org/fhir/R4/StructureDefinition/shareablemeasure
[s110]: http://hl7.org/fhir/R4/StructureDefinition/VisionPrescription
[s111]: http://hl7.org/fhir/R4/StructureDefinition/Media
[s112]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProductContraindication
[s113]: http://hl7.org/fhir/R4/StructureDefinition/MolecularSequence
[s114]: http://hl7.org/fhir/R4/StructureDefinition/EvidenceVariable
[s115]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProduct
[s116]: http://hl7.org/fhir/R4/StructureDefinition/clinicaldocument
[s117]: http://hl7.org/fhir/R4/StructureDefinition/DeviceMetric
[s118]: http://hl7.org/fhir/R4/StructureDefinition/headcircum
[s119]: http://hl7.org/fhir/R4/StructureDefinition/Flag
[s120]: http://hl7.org/fhir/R4/StructureDefinition/SubstanceNucleicAcid
[s121]: http://hl7.org/fhir/R4/StructureDefinition/RiskEvidenceSynthesis
[s122]: http://hl7.org/fhir/R4/StructureDefinition/vitalsigns
[s123]: http://hl7.org/fhir/R4/StructureDefinition/AppointmentResponse
[s124]: http://hl7.org/fhir/R4/StructureDefinition/devicemetricobservation
[s125]: http://hl7.org/fhir/R4/StructureDefinition/StructureMap
[s126]: http://hl7.org/fhir/R4/StructureDefinition/AdverseEvent
[s127]: http://hl7.org/fhir/R4/StructureDefinition/cqllibrary
[s128]: http://hl7.org/fhir/R4/StructureDefinition/GuidanceResponse
[s129]: http://hl7.org/fhir/R4/StructureDefinition/diagnosticreport-genetics
[s130]: http://hl7.org/fhir/R4/StructureDefinition/Observation
[s131]: http://hl7.org/fhir/R4/StructureDefinition/MedicationAdministration
[s132]: http://hl7.org/fhir/R4/StructureDefinition/EnrollmentResponse
[s133]: http://hl7.org/fhir/R4/StructureDefinition/Library
[s134]: http://hl7.org/fhir/R4/StructureDefinition/Binary
[s135]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProductInteraction
[s136]: http://hl7.org/fhir/R4/StructureDefinition/MedicationStatement
[s137]: http://hl7.org/fhir/R4/StructureDefinition/CommunicationRequest
[s138]: http://hl7.org/fhir/R4/StructureDefinition/TestScript
[s139]: http://hl7.org/fhir/R4/StructureDefinition/SubstancePolymer
[s140]: http://hl7.org/fhir/R4/StructureDefinition/Basic
[s141]: http://hl7.org/fhir/R4/StructureDefinition/TestReport
[s142]: http://hl7.org/fhir/R4/StructureDefinition/ClaimResponse
[s143]: http://hl7.org/fhir/R4/StructureDefinition/MedicationDispense
[s144]: http://hl7.org/fhir/R4/StructureDefinition/bodyweight
[s145]: http://hl7.org/fhir/R4/StructureDefinition/DiagnosticReport
[s146]: http://hl7.org/fhir/R4/StructureDefinition/OrganizationAffiliation
[s147]: http://hl7.org/fhir/R4/StructureDefinition/HealthcareService
[s148]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProductIndication
[s149]: http://hl7.org/fhir/R4/StructureDefinition/catalog
[s150]: http://hl7.org/fhir/R4/StructureDefinition/NutritionOrder
[s151]: http://hl7.org/fhir/R4/StructureDefinition/TerminologyCapabilities
[s152]: http://hl7.org/fhir/R4/StructureDefinition/cdshooksguidanceresponse
[s153]: http://hl7.org/fhir/R4/StructureDefinition/Evidence
[s154]: http://hl7.org/fhir/R4/StructureDefinition/AuditEvent
[s155]: http://hl7.org/fhir/R4/StructureDefinition/PaymentReconciliation
[s156]: http://hl7.org/fhir/R4/StructureDefinition/Condition
[s157]: http://hl7.org/fhir/R4/StructureDefinition/SpecimenDefinition
[s158]: http://hl7.org/fhir/R4/StructureDefinition/Composition
[s159]: http://hl7.org/fhir/R4/StructureDefinition/DetectedIssue
[s160]: http://hl7.org/fhir/R4/StructureDefinition/CompartmentDefinition
[s161]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProductIngredient
[s162]: http://hl7.org/fhir/R4/StructureDefinition/MedicationKnowledge
[s163]: http://hl7.org/fhir/R4/StructureDefinition/Patient
[s164]: http://hl7.org/fhir/R4/StructureDefinition/Coverage
[s165]: http://hl7.org/fhir/R4/StructureDefinition/QuestionnaireResponse
[s166]: http://hl7.org/fhir/R4/StructureDefinition/CoverageEligibilityRequest
[s167]: http://hl7.org/fhir/R4/StructureDefinition/NamingSystem
[s168]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProductUndesirableEffect
[s169]: http://hl7.org/fhir/R4/StructureDefinition/ExampleScenario
[s170]: http://hl7.org/fhir/R4/StructureDefinition/resprate
[s171]: http://hl7.org/fhir/R4/StructureDefinition/SupplyDelivery
[s172]: http://hl7.org/fhir/R4/StructureDefinition/Schedule
[s173]: http://hl7.org/fhir/R4/StructureDefinition/DeviceDefinition
[s174]: http://hl7.org/fhir/R4/StructureDefinition/ClinicalImpression
[s175]: http://hl7.org/fhir/R4/StructureDefinition/PlanDefinition
[s176]: http://hl7.org/fhir/R4/StructureDefinition/MedicinalProductAuthorization
[s177]: http://hl7.org/fhir/R4/StructureDefinition/bmi
[s178]: http://hl7.org/fhir/R4/StructureDefinition/Claim
[s179]: http://hl7.org/fhir/R4/StructureDefinition/Location
