Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/ implementation guide.

# FHIR R4 International package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/               |


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
| 19). Family_member_history_for_genetics_analysis | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). Subscription | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). GraphDefinition | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). DocumentReference | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). Shareable_Library | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). Parameters | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). CoverageEligibilityResponse | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). MeasureReport | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). Actual_Group | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). SubstanceReferenceInformation | [[Definition]][s28] [[Ballerina Record]][m28] |
| 29). PractitionerRole | [[Definition]][s29] [[Ballerina Record]][m29] |
| 30). RelatedPerson | [[Definition]][s30] [[Ballerina Record]][m30] |
| 31). ServiceRequest | [[Definition]][s31] [[Ballerina Record]][m31] |
| 32). SupplyRequest | [[Definition]][s32] [[Ballerina Record]][m32] |
| 33). Provenance_Relevant_History | [[Definition]][s33] [[Ballerina Record]][m33] |
| 34). Practitioner | [[Definition]][s34] [[Ballerina Record]][m34] |
| 35). VerificationResult | [[Definition]][s35] [[Ballerina Record]][m35] |
| 36). Group_Definition | [[Definition]][s36] [[Ballerina Record]][m36] |
| 37). observation_bp | [[Definition]][s37] [[Ballerina Record]][m37] |
| 38). SubstanceProtein | [[Definition]][s38] [[Ballerina Record]][m38] |
| 39). BodyStructure | [[Definition]][s39] [[Ballerina Record]][m39] |
| 40). Shareable_PlanDefinition | [[Definition]][s40] [[Ballerina Record]][m40] |
| 41). Slot | [[Definition]][s41] [[Ballerina Record]][m41] |
| 42). Contract | [[Definition]][s42] [[Ballerina Record]][m42] |
| 43). Person | [[Definition]][s43] [[Ballerina Record]][m43] |
| 44). RiskAssessment | [[Definition]][s44] [[Ballerina Record]][m44] |
| 45). CDS_Hooks_Service_PlanDefinition | [[Definition]][s45] [[Ballerina Record]][m45] |
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
| 57). EHRS_FM_Record_Lifecycle_Event___Audit_Event | [[Definition]][s57] [[Ballerina Record]][m57] |
| 58). ResearchElementDefinition | [[Definition]][s58] [[Ballerina Record]][m58] |
| 59). ObservationDefinition | [[Definition]][s59] [[Ballerina Record]][m59] |
| 60). ServiceRequest_Genetics | [[Definition]][s60] [[Ballerina Record]][m60] |
| 61). SubstanceSpecification | [[Definition]][s61] [[Ballerina Record]][m61] |
| 62). Encounter | [[Definition]][s62] [[Ballerina Record]][m62] |
| 63). Substance | [[Definition]][s63] [[Ballerina Record]][m63] |
| 64). Shareable_ActivityDefinition | [[Definition]][s64] [[Ballerina Record]][m64] |
| 65). SearchParameter | [[Definition]][s65] [[Ballerina Record]][m65] |
| 66). Profile_for_HLA_Genotyping_Results | [[Definition]][s66] [[Ballerina Record]][m66] |
| 67). Communication | [[Definition]][s67] [[Ballerina Record]][m67] |
| 68). InsurancePlan | [[Definition]][s68] [[Ballerina Record]][m68] |
| 69). ActivityDefinition | [[Definition]][s69] [[Ballerina Record]][m69] |
| 70). Example_Lipid_Profile | [[Definition]][s70] [[Ballerina Record]][m70] |
| 71). Linkage | [[Definition]][s71] [[Ballerina Record]][m71] |
| 72). EHRS_FM_Record_Lifecycle_Event___Provenance | [[Definition]][s72] [[Ballerina Record]][m72] |
| 73). Observation_genetics | [[Definition]][s73] [[Ballerina Record]][m73] |
| 74). SubstanceSourceMaterial | [[Definition]][s74] [[Ballerina Record]][m74] |
| 75). ImmunizationEvaluation | [[Definition]][s75] [[Ballerina Record]][m75] |
| 76). observation_bodytemp | [[Definition]][s76] [[Ballerina Record]][m76] |
| 77). DeviceUseStatement | [[Definition]][s77] [[Ballerina Record]][m77] |
| 78). Evidence_Synthesis_Profile | [[Definition]][s78] [[Ballerina Record]][m78] |
| 79). RequestGroup | [[Definition]][s79] [[Ballerina Record]][m79] |
| 80). MessageHeader | [[Definition]][s80] [[Ballerina Record]][m80] |
| 81). DeviceRequest | [[Definition]][s81] [[Ballerina Record]][m81] |
| 82). ImmunizationRecommendation | [[Definition]][s82] [[Ballerina Record]][m82] |
| 83). observation_oxygensat | [[Definition]][s83] [[Ballerina Record]][m83] |
| 84). Task | [[Definition]][s84] [[Ballerina Record]][m84] |
| 85). Provenance | [[Definition]][s85] [[Ballerina Record]][m85] |
| 86). Questionnaire | [[Definition]][s86] [[Ballerina Record]][m86] |
| 87). PICO_Element_Profile | [[Definition]][s87] [[Ballerina Record]][m87] |
| 88). Computable_PlanDefinition | [[Definition]][s88] [[Ballerina Record]][m88] |
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
| 102). CDS_Hooks_RequestGroup | [[Definition]][s102] [[Ballerina Record]][m102] |
| 103). OperationDefinition | [[Definition]][s103] [[Ballerina Record]][m103] |
| 104). Immunization | [[Definition]][s104] [[Ballerina Record]][m104] |
| 105). MedicationRequest | [[Definition]][s105] [[Ballerina Record]][m105] |
| 106). EffectEvidenceSynthesis | [[Definition]][s106] [[Ballerina Record]][m106] |
| 107). BiologicallyDerivedProduct | [[Definition]][s107] [[Ballerina Record]][m107] |
| 108). Device | [[Definition]][s108] [[Ballerina Record]][m108] |
| 109). Shareable_Measure | [[Definition]][s109] [[Ballerina Record]][m109] |
| 110). VisionPrescription | [[Definition]][s110] [[Ballerina Record]][m110] |
| 111). Media | [[Definition]][s111] [[Ballerina Record]][m111] |
| 112). MedicinalProductContraindication | [[Definition]][s112] [[Ballerina Record]][m112] |
| 113). MolecularSequence | [[Definition]][s113] [[Ballerina Record]][m113] |
| 114). EvidenceVariable | [[Definition]][s114] [[Ballerina Record]][m114] |
| 115). MedicinalProduct | [[Definition]][s115] [[Ballerina Record]][m115] |
| 116). Clinical_Document | [[Definition]][s116] [[Ballerina Record]][m116] |
| 117). DeviceMetric | [[Definition]][s117] [[Ballerina Record]][m117] |
| 118). observation_headcircum | [[Definition]][s118] [[Ballerina Record]][m118] |
| 119). Flag | [[Definition]][s119] [[Ballerina Record]][m119] |
| 120). SubstanceNucleicAcid | [[Definition]][s120] [[Ballerina Record]][m120] |
| 121). RiskEvidenceSynthesis | [[Definition]][s121] [[Ballerina Record]][m121] |
| 122). observation_vitalsigns | [[Definition]][s122] [[Ballerina Record]][m122] |
| 123). AppointmentResponse | [[Definition]][s123] [[Ballerina Record]][m123] |
| 124). Device_Metric_Observation_Profile | [[Definition]][s124] [[Ballerina Record]][m124] |
| 125). StructureMap | [[Definition]][s125] [[Ballerina Record]][m125] |
| 126). AdverseEvent | [[Definition]][s126] [[Ballerina Record]][m126] |
| 127). CQL_Library | [[Definition]][s127] [[Ballerina Record]][m127] |
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
| 149). Profile_for_Catalog | [[Definition]][s149] [[Ballerina Record]][m149] |
| 150). NutritionOrder | [[Definition]][s150] [[Ballerina Record]][m150] |
| 151). TerminologyCapabilities | [[Definition]][s151] [[Ballerina Record]][m151] |
| 152). CDS_Hooks_GuidanceResponse | [[Definition]][s152] [[Ballerina Record]][m152] |
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

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Appointment
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Account
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Invoice
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CatalogEntry
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_bodyheight
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#EventDefinition
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_heartrate
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#DocumentManifest
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MessageDefinition
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Goal
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProductPackaged
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Endpoint
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#EnrollmentRequest
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Consent
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CapabilityStatement
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Medication
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Measure
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ResearchSubject
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Family_member_history_for_genetics_analysis
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Subscription
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#GraphDefinition
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#DocumentReference
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Shareable_Library
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Parameters
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CoverageEligibilityResponse
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MeasureReport
[m27]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Actual_Group
[m28]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SubstanceReferenceInformation
[m29]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#PractitionerRole
[m30]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#RelatedPerson
[m31]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ServiceRequest
[m32]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SupplyRequest
[m33]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Provenance_Relevant_History
[m34]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Practitioner
[m35]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#VerificationResult
[m36]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Group_Definition
[m37]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_bp
[m38]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SubstanceProtein
[m39]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#BodyStructure
[m40]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Shareable_PlanDefinition
[m41]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Slot
[m42]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Contract
[m43]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Person
[m44]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#RiskAssessment
[m45]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CDS_Hooks_Service_PlanDefinition
[m46]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Group
[m47]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ResearchDefinition
[m48]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#PaymentNotice
[m49]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProductManufactured
[m50]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Organization
[m51]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ImplementationGuide
[m52]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CareTeam
[m53]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_vitalspanel
[m54]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ImagingStudy
[m55]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#FamilyMemberHistory
[m56]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ChargeItem
[m57]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#EHRS_FM_Record_Lifecycle_Event___Audit_Event
[m58]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ResearchElementDefinition
[m59]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ObservationDefinition
[m60]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ServiceRequest_Genetics
[m61]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SubstanceSpecification
[m62]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Encounter
[m63]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Substance
[m64]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Shareable_ActivityDefinition
[m65]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SearchParameter
[m66]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Profile_for_HLA_Genotyping_Results
[m67]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Communication
[m68]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#InsurancePlan
[m69]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ActivityDefinition
[m70]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Example_Lipid_Profile
[m71]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Linkage
[m72]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#EHRS_FM_Record_Lifecycle_Event___Provenance
[m73]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Observation_genetics
[m74]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SubstanceSourceMaterial
[m75]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ImmunizationEvaluation
[m76]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_bodytemp
[m77]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#DeviceUseStatement
[m78]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Evidence_Synthesis_Profile
[m79]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#RequestGroup
[m80]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MessageHeader
[m81]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#DeviceRequest
[m82]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ImmunizationRecommendation
[m83]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_oxygensat
[m84]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Task
[m85]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Provenance
[m86]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Questionnaire
[m87]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#PICO_Element_Profile
[m88]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Computable_PlanDefinition
[m89]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ExplanationOfBenefit
[m90]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProductPharmaceutical
[m91]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ResearchStudy
[m92]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Specimen
[m93]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CarePlan
[m94]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#AllergyIntolerance
[m95]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#StructureDefinition
[m96]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ChargeItemDefinition
[m97]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#EpisodeOfCare
[m98]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CQF_Questionnaire
[m99]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Procedure
[m100]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#List
[m101]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ConceptMap
[m102]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CDS_Hooks_RequestGroup
[m103]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#OperationDefinition
[m104]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Immunization
[m105]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicationRequest
[m106]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#EffectEvidenceSynthesis
[m107]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#BiologicallyDerivedProduct
[m108]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Device
[m109]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Shareable_Measure
[m110]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#VisionPrescription
[m111]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Media
[m112]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProductContraindication
[m113]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MolecularSequence
[m114]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#EvidenceVariable
[m115]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProduct
[m116]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Clinical_Document
[m117]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#DeviceMetric
[m118]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_headcircum
[m119]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Flag
[m120]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SubstanceNucleicAcid
[m121]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#RiskEvidenceSynthesis
[m122]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_vitalsigns
[m123]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#AppointmentResponse
[m124]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Device_Metric_Observation_Profile
[m125]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#StructureMap
[m126]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#AdverseEvent
[m127]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CQL_Library
[m128]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#GuidanceResponse
[m129]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#DiagnosticReport_Genetics
[m130]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Observation
[m131]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicationAdministration
[m132]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#EnrollmentResponse
[m133]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Library
[m134]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Binary
[m135]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProductInteraction
[m136]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicationStatement
[m137]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CommunicationRequest
[m138]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#TestScript
[m139]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SubstancePolymer
[m140]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Basic
[m141]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#TestReport
[m142]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ClaimResponse
[m143]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicationDispense
[m144]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_bodyweight
[m145]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#DiagnosticReport
[m146]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#OrganizationAffiliation
[m147]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#HealthcareService
[m148]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProductIndication
[m149]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Profile_for_Catalog
[m150]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#NutritionOrder
[m151]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#TerminologyCapabilities
[m152]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CDS_Hooks_GuidanceResponse
[m153]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Evidence
[m154]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#AuditEvent
[m155]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#PaymentReconciliation
[m156]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Condition
[m157]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SpecimenDefinition
[m158]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Composition
[m159]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#DetectedIssue
[m160]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CompartmentDefinition
[m161]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProductIngredient
[m162]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicationKnowledge
[m163]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Patient
[m164]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Coverage
[m165]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#QuestionnaireResponse
[m166]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#CoverageEligibilityRequest
[m167]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#NamingSystem
[m168]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProductUndesirableEffect
[m169]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ExampleScenario
[m170]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_resprate
[m171]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#SupplyDelivery
[m172]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Schedule
[m173]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#DeviceDefinition
[m174]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#ClinicalImpression
[m175]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#PlanDefinition
[m176]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#MedicinalProductAuthorization
[m177]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#observation_bmi
[m178]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Claim
[m179]: https://lib.ballerina.io/ballerinax/health.fhir.r4.international/1.1.1#Location

[s1]: http://hl7.org/fhir/StructureDefinition/Appointment
[s2]: http://hl7.org/fhir/StructureDefinition/Account
[s3]: http://hl7.org/fhir/StructureDefinition/Invoice
[s4]: http://hl7.org/fhir/StructureDefinition/CatalogEntry
[s5]: http://hl7.org/fhir/StructureDefinition/bodyheight
[s6]: http://hl7.org/fhir/StructureDefinition/EventDefinition
[s7]: http://hl7.org/fhir/StructureDefinition/heartrate
[s8]: http://hl7.org/fhir/StructureDefinition/DocumentManifest
[s9]: http://hl7.org/fhir/StructureDefinition/MessageDefinition
[s10]: http://hl7.org/fhir/StructureDefinition/Goal
[s11]: http://hl7.org/fhir/StructureDefinition/MedicinalProductPackaged
[s12]: http://hl7.org/fhir/StructureDefinition/Endpoint
[s13]: http://hl7.org/fhir/StructureDefinition/EnrollmentRequest
[s14]: http://hl7.org/fhir/StructureDefinition/Consent
[s15]: http://hl7.org/fhir/StructureDefinition/CapabilityStatement
[s16]: http://hl7.org/fhir/StructureDefinition/Medication
[s17]: http://hl7.org/fhir/StructureDefinition/Measure
[s18]: http://hl7.org/fhir/StructureDefinition/ResearchSubject
[s19]: http://hl7.org/fhir/StructureDefinition/familymemberhistory-genetic
[s20]: http://hl7.org/fhir/StructureDefinition/Subscription
[s21]: http://hl7.org/fhir/StructureDefinition/GraphDefinition
[s22]: http://hl7.org/fhir/StructureDefinition/DocumentReference
[s23]: http://hl7.org/fhir/StructureDefinition/shareablelibrary
[s24]: http://hl7.org/fhir/StructureDefinition/Parameters
[s25]: http://hl7.org/fhir/StructureDefinition/CoverageEligibilityResponse
[s26]: http://hl7.org/fhir/StructureDefinition/MeasureReport
[s27]: http://hl7.org/fhir/StructureDefinition/actualgroup
[s28]: http://hl7.org/fhir/StructureDefinition/SubstanceReferenceInformation
[s29]: http://hl7.org/fhir/StructureDefinition/PractitionerRole
[s30]: http://hl7.org/fhir/StructureDefinition/RelatedPerson
[s31]: http://hl7.org/fhir/StructureDefinition/ServiceRequest
[s32]: http://hl7.org/fhir/StructureDefinition/SupplyRequest
[s33]: http://hl7.org/fhir/StructureDefinition/provenance-relevant-history
[s34]: http://hl7.org/fhir/StructureDefinition/Practitioner
[s35]: http://hl7.org/fhir/StructureDefinition/VerificationResult
[s36]: http://hl7.org/fhir/StructureDefinition/groupdefinition
[s37]: http://hl7.org/fhir/StructureDefinition/bp
[s38]: http://hl7.org/fhir/StructureDefinition/SubstanceProtein
[s39]: http://hl7.org/fhir/StructureDefinition/BodyStructure
[s40]: http://hl7.org/fhir/StructureDefinition/shareableplandefinition
[s41]: http://hl7.org/fhir/StructureDefinition/Slot
[s42]: http://hl7.org/fhir/StructureDefinition/Contract
[s43]: http://hl7.org/fhir/StructureDefinition/Person
[s44]: http://hl7.org/fhir/StructureDefinition/RiskAssessment
[s45]: http://hl7.org/fhir/StructureDefinition/cdshooksserviceplandefinition
[s46]: http://hl7.org/fhir/StructureDefinition/Group
[s47]: http://hl7.org/fhir/StructureDefinition/ResearchDefinition
[s48]: http://hl7.org/fhir/StructureDefinition/PaymentNotice
[s49]: http://hl7.org/fhir/StructureDefinition/MedicinalProductManufactured
[s50]: http://hl7.org/fhir/StructureDefinition/Organization
[s51]: http://hl7.org/fhir/StructureDefinition/ImplementationGuide
[s52]: http://hl7.org/fhir/StructureDefinition/CareTeam
[s53]: http://hl7.org/fhir/StructureDefinition/vitalspanel
[s54]: http://hl7.org/fhir/StructureDefinition/ImagingStudy
[s55]: http://hl7.org/fhir/StructureDefinition/FamilyMemberHistory
[s56]: http://hl7.org/fhir/StructureDefinition/ChargeItem
[s57]: http://hl7.org/fhir/StructureDefinition/ehrsrle-auditevent
[s58]: http://hl7.org/fhir/StructureDefinition/ResearchElementDefinition
[s59]: http://hl7.org/fhir/StructureDefinition/ObservationDefinition
[s60]: http://hl7.org/fhir/StructureDefinition/servicerequest-genetics
[s61]: http://hl7.org/fhir/StructureDefinition/SubstanceSpecification
[s62]: http://hl7.org/fhir/StructureDefinition/Encounter
[s63]: http://hl7.org/fhir/StructureDefinition/Substance
[s64]: http://hl7.org/fhir/StructureDefinition/shareableactivitydefinition
[s65]: http://hl7.org/fhir/StructureDefinition/SearchParameter
[s66]: http://hl7.org/fhir/StructureDefinition/hlaresult
[s67]: http://hl7.org/fhir/StructureDefinition/Communication
[s68]: http://hl7.org/fhir/StructureDefinition/InsurancePlan
[s69]: http://hl7.org/fhir/StructureDefinition/ActivityDefinition
[s70]: http://hl7.org/fhir/StructureDefinition/lipidprofile
[s71]: http://hl7.org/fhir/StructureDefinition/Linkage
[s72]: http://hl7.org/fhir/StructureDefinition/ehrsrle-provenance
[s73]: http://hl7.org/fhir/StructureDefinition/observation-genetics
[s74]: http://hl7.org/fhir/StructureDefinition/SubstanceSourceMaterial
[s75]: http://hl7.org/fhir/StructureDefinition/ImmunizationEvaluation
[s76]: http://hl7.org/fhir/StructureDefinition/bodytemp
[s77]: http://hl7.org/fhir/StructureDefinition/DeviceUseStatement
[s78]: http://hl7.org/fhir/StructureDefinition/synthesis
[s79]: http://hl7.org/fhir/StructureDefinition/RequestGroup
[s80]: http://hl7.org/fhir/StructureDefinition/MessageHeader
[s81]: http://hl7.org/fhir/StructureDefinition/DeviceRequest
[s82]: http://hl7.org/fhir/StructureDefinition/ImmunizationRecommendation
[s83]: http://hl7.org/fhir/StructureDefinition/oxygensat
[s84]: http://hl7.org/fhir/StructureDefinition/Task
[s85]: http://hl7.org/fhir/StructureDefinition/Provenance
[s86]: http://hl7.org/fhir/StructureDefinition/Questionnaire
[s87]: http://hl7.org/fhir/StructureDefinition/picoelement
[s88]: http://hl7.org/fhir/StructureDefinition/computableplandefinition
[s89]: http://hl7.org/fhir/StructureDefinition/ExplanationOfBenefit
[s90]: http://hl7.org/fhir/StructureDefinition/MedicinalProductPharmaceutical
[s91]: http://hl7.org/fhir/StructureDefinition/ResearchStudy
[s92]: http://hl7.org/fhir/StructureDefinition/Specimen
[s93]: http://hl7.org/fhir/StructureDefinition/CarePlan
[s94]: http://hl7.org/fhir/StructureDefinition/AllergyIntolerance
[s95]: http://hl7.org/fhir/StructureDefinition/StructureDefinition
[s96]: http://hl7.org/fhir/StructureDefinition/ChargeItemDefinition
[s97]: http://hl7.org/fhir/StructureDefinition/EpisodeOfCare
[s98]: http://hl7.org/fhir/StructureDefinition/cqf-questionnaire
[s99]: http://hl7.org/fhir/StructureDefinition/Procedure
[s100]: http://hl7.org/fhir/StructureDefinition/List
[s101]: http://hl7.org/fhir/StructureDefinition/ConceptMap
[s102]: http://hl7.org/fhir/StructureDefinition/cdshooksrequestgroup
[s103]: http://hl7.org/fhir/StructureDefinition/OperationDefinition
[s104]: http://hl7.org/fhir/StructureDefinition/Immunization
[s105]: http://hl7.org/fhir/StructureDefinition/MedicationRequest
[s106]: http://hl7.org/fhir/StructureDefinition/EffectEvidenceSynthesis
[s107]: http://hl7.org/fhir/StructureDefinition/BiologicallyDerivedProduct
[s108]: http://hl7.org/fhir/StructureDefinition/Device
[s109]: http://hl7.org/fhir/StructureDefinition/shareablemeasure
[s110]: http://hl7.org/fhir/StructureDefinition/VisionPrescription
[s111]: http://hl7.org/fhir/StructureDefinition/Media
[s112]: http://hl7.org/fhir/StructureDefinition/MedicinalProductContraindication
[s113]: http://hl7.org/fhir/StructureDefinition/MolecularSequence
[s114]: http://hl7.org/fhir/StructureDefinition/EvidenceVariable
[s115]: http://hl7.org/fhir/StructureDefinition/MedicinalProduct
[s116]: http://hl7.org/fhir/StructureDefinition/clinicaldocument
[s117]: http://hl7.org/fhir/StructureDefinition/DeviceMetric
[s118]: http://hl7.org/fhir/StructureDefinition/headcircum
[s119]: http://hl7.org/fhir/StructureDefinition/Flag
[s120]: http://hl7.org/fhir/StructureDefinition/SubstanceNucleicAcid
[s121]: http://hl7.org/fhir/StructureDefinition/RiskEvidenceSynthesis
[s122]: http://hl7.org/fhir/StructureDefinition/vitalsigns
[s123]: http://hl7.org/fhir/StructureDefinition/AppointmentResponse
[s124]: http://hl7.org/fhir/StructureDefinition/devicemetricobservation
[s125]: http://hl7.org/fhir/StructureDefinition/StructureMap
[s126]: http://hl7.org/fhir/StructureDefinition/AdverseEvent
[s127]: http://hl7.org/fhir/StructureDefinition/cqllibrary
[s128]: http://hl7.org/fhir/StructureDefinition/GuidanceResponse
[s129]: http://hl7.org/fhir/StructureDefinition/diagnosticreport-genetics
[s130]: http://hl7.org/fhir/StructureDefinition/Observation
[s131]: http://hl7.org/fhir/StructureDefinition/MedicationAdministration
[s132]: http://hl7.org/fhir/StructureDefinition/EnrollmentResponse
[s133]: http://hl7.org/fhir/StructureDefinition/Library
[s134]: http://hl7.org/fhir/StructureDefinition/Binary
[s135]: http://hl7.org/fhir/StructureDefinition/MedicinalProductInteraction
[s136]: http://hl7.org/fhir/StructureDefinition/MedicationStatement
[s137]: http://hl7.org/fhir/StructureDefinition/CommunicationRequest
[s138]: http://hl7.org/fhir/StructureDefinition/TestScript
[s139]: http://hl7.org/fhir/StructureDefinition/SubstancePolymer
[s140]: http://hl7.org/fhir/StructureDefinition/Basic
[s141]: http://hl7.org/fhir/StructureDefinition/TestReport
[s142]: http://hl7.org/fhir/StructureDefinition/ClaimResponse
[s143]: http://hl7.org/fhir/StructureDefinition/MedicationDispense
[s144]: http://hl7.org/fhir/StructureDefinition/bodyweight
[s145]: http://hl7.org/fhir/StructureDefinition/DiagnosticReport
[s146]: http://hl7.org/fhir/StructureDefinition/OrganizationAffiliation
[s147]: http://hl7.org/fhir/StructureDefinition/HealthcareService
[s148]: http://hl7.org/fhir/StructureDefinition/MedicinalProductIndication
[s149]: http://hl7.org/fhir/StructureDefinition/catalog
[s150]: http://hl7.org/fhir/StructureDefinition/NutritionOrder
[s151]: http://hl7.org/fhir/StructureDefinition/TerminologyCapabilities
[s152]: http://hl7.org/fhir/StructureDefinition/cdshooksguidanceresponse
[s153]: http://hl7.org/fhir/StructureDefinition/Evidence
[s154]: http://hl7.org/fhir/StructureDefinition/AuditEvent
[s155]: http://hl7.org/fhir/StructureDefinition/PaymentReconciliation
[s156]: http://hl7.org/fhir/StructureDefinition/Condition
[s157]: http://hl7.org/fhir/StructureDefinition/SpecimenDefinition
[s158]: http://hl7.org/fhir/StructureDefinition/Composition
[s159]: http://hl7.org/fhir/StructureDefinition/DetectedIssue
[s160]: http://hl7.org/fhir/StructureDefinition/CompartmentDefinition
[s161]: http://hl7.org/fhir/StructureDefinition/MedicinalProductIngredient
[s162]: http://hl7.org/fhir/StructureDefinition/MedicationKnowledge
[s163]: http://hl7.org/fhir/StructureDefinition/Patient
[s164]: http://hl7.org/fhir/StructureDefinition/Coverage
[s165]: http://hl7.org/fhir/StructureDefinition/QuestionnaireResponse
[s166]: http://hl7.org/fhir/StructureDefinition/CoverageEligibilityRequest
[s167]: http://hl7.org/fhir/StructureDefinition/NamingSystem
[s168]: http://hl7.org/fhir/StructureDefinition/MedicinalProductUndesirableEffect
[s169]: http://hl7.org/fhir/StructureDefinition/ExampleScenario
[s170]: http://hl7.org/fhir/StructureDefinition/resprate
[s171]: http://hl7.org/fhir/StructureDefinition/SupplyDelivery
[s172]: http://hl7.org/fhir/StructureDefinition/Schedule
[s173]: http://hl7.org/fhir/StructureDefinition/DeviceDefinition
[s174]: http://hl7.org/fhir/StructureDefinition/ClinicalImpression
[s175]: http://hl7.org/fhir/StructureDefinition/PlanDefinition
[s176]: http://hl7.org/fhir/StructureDefinition/MedicinalProductAuthorization
[s177]: http://hl7.org/fhir/StructureDefinition/bmi
[s178]: http://hl7.org/fhir/StructureDefinition/Claim
[s179]: http://hl7.org/fhir/StructureDefinition/Location
