Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/carin-bb/ implementation guide.

# FHIR R4 health_fhir_r4_carinbb200 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/us/carin-bb/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). C4BBOrganization | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). C4BBExplanationOfBenefitPharmacy | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). C4BBExplanationOfBenefitPharmacyBasis | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). C4BBExplanationOfBenefitProfessionalNonClinicianBasis | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). C4BBExplanationOfBenefit | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). C4BBExplanationOfBenefitOutpatientInstitutionalBasis | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). C4BBRelatedPerson | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). C4BBPatient | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). C4BBCoverage | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). C4BBExplanationOfBenefitOutpatientInstitutional | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). C4BBPractitioner | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). C4BBExplanationOfBenefitInpatientInstitutional | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). C4BBExplanationOfBenefitOral | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). C4BBExplanationOfBenefitOralBasis | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). C4BBExplanationOfBenefitProfessionalNonClinician | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). C4BBExplanationOfBenefitInpatientInstitutionalBasis | [[Definition]][s16] [[Ballerina Record]][m16] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBOrganization
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitPharmacy
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitPharmacyBasis
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitProfessionalNonClinicianBasis
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefit
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitOutpatientInstitutionalBasis
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBRelatedPerson
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBPatient
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBCoverage
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitOutpatientInstitutional
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBPractitioner
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitInpatientInstitutional
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitOral
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitOralBasis
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitProfessionalNonClinician
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.carinbb200/1.0.0#C4BBExplanationOfBenefitInpatientInstitutionalBasis

[s1]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-Organization
[s2]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Pharmacy
[s3]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Pharmacy-Basis
[s4]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Professional-NonClinician-Basis
[s5]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit
[s6]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Outpatient-Institutional-Basis
[s7]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-RelatedPerson
[s8]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-Patient
[s9]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-Coverage
[s10]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Outpatient-Institutional
[s11]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-Practitioner
[s12]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Inpatient-Institutional
[s13]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Oral
[s14]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Oral-Basis
[s15]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Professional-NonClinician
[s16]: http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Inpatient-Institutional-Basis
