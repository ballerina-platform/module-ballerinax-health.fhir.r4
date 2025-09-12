Ballerina package containing FHIR resource data models
compliant with http://hl7.org.au/fhir/ implementation guide.

# FHIR R4 health_fhir_r4_aubase410 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org.au/fhir/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). AUBaseComposition | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). AUBaseMedicationRequest | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). AUBasePathologyResult | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). AUBasePatient | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). AUBaseDiagnosticResult | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). AUBasePractitioner | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). AUBaseLocation | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). AUBaseHealthcareService | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). AUBaseDiagnosticImagingResult | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). AUBaseMedication | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). AUBaseDiagnosticReport | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). AUMedicineList | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). AUBaseDiagnosticRequest | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). AUBaseMedicationAdministration | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). AUBaseMedicationStatement | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). AUBaseSpecimen | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). AUBaseBodyStructure | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). AUBaseMedicationDispense | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). AUBaseCondition | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). AUBaseDiagnosticImagingReport | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). AUHealthProgramParticipationSummary | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). AUBaseRelatedPerson | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). AUBasePathologyReport | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). AUBaseSubstance | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). AUBasePractitionerRole | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). AUBaseOrganisation | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). AUBaseAllergyIntolerance | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). AUBaseImmunisation | [[Definition]][s28] [[Ballerina Record]][m28] |
| 29). AUAssertionNoRelevantFinding | [[Definition]][s29] [[Ballerina Record]][m29] |
| 30). AUBaseProcedure | [[Definition]][s30] [[Ballerina Record]][m30] |
| 31). AUBaseEncounter | [[Definition]][s31] [[Ballerina Record]][m31] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseComposition
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseMedicationRequest
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBasePathologyResult
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBasePatient
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseDiagnosticResult
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBasePractitioner
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseLocation
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseHealthcareService
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseDiagnosticImagingResult
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseMedication
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseDiagnosticReport
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUMedicineList
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseDiagnosticRequest
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseMedicationAdministration
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseMedicationStatement
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseSpecimen
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseBodyStructure
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseMedicationDispense
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseCondition
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseDiagnosticImagingReport
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUHealthProgramParticipationSummary
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseRelatedPerson
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBasePathologyReport
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseSubstance
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBasePractitionerRole
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseOrganisation
[m27]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseAllergyIntolerance
[m28]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseImmunisation
[m29]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUAssertionNoRelevantFinding
[m30]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseProcedure
[m31]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.0#AUBaseEncounter

[s1]: http://hl7.org.au/fhir/StructureDefinition/au-composition
[s2]: http://hl7.org.au/fhir/StructureDefinition/au-medicationrequest
[s3]: http://hl7.org.au/fhir/StructureDefinition/au-pathologyresult
[s4]: http://hl7.org.au/fhir/StructureDefinition/au-patient
[s5]: http://hl7.org.au/fhir/StructureDefinition/au-diagnosticresult
[s6]: http://hl7.org.au/fhir/StructureDefinition/au-practitioner
[s7]: http://hl7.org.au/fhir/StructureDefinition/au-location
[s8]: http://hl7.org.au/fhir/StructureDefinition/au-healthcareservice
[s9]: http://hl7.org.au/fhir/StructureDefinition/au-imagingresult
[s10]: http://hl7.org.au/fhir/StructureDefinition/au-medication
[s11]: http://hl7.org.au/fhir/StructureDefinition/au-diagnosticreport
[s12]: http://hl7.org.au/fhir/StructureDefinition/au-medlist
[s13]: http://hl7.org.au/fhir/StructureDefinition/au-diagnosticrequest
[s14]: http://hl7.org.au/fhir/StructureDefinition/au-medicationadministration
[s15]: http://hl7.org.au/fhir/StructureDefinition/au-medicationstatement
[s16]: http://hl7.org.au/fhir/StructureDefinition/au-specimen
[s17]: http://hl7.org.au/fhir/StructureDefinition/au-bodystructure
[s18]: http://hl7.org.au/fhir/StructureDefinition/au-medicationdispense
[s19]: http://hl7.org.au/fhir/StructureDefinition/au-condition
[s20]: http://hl7.org.au/fhir/StructureDefinition/au-imagingreport
[s21]: http://hl7.org.au/fhir/StructureDefinition/au-healthprogramparticipation
[s22]: http://hl7.org.au/fhir/StructureDefinition/au-relatedperson
[s23]: http://hl7.org.au/fhir/StructureDefinition/au-pathologyreport
[s24]: http://hl7.org.au/fhir/StructureDefinition/au-substance
[s25]: http://hl7.org.au/fhir/StructureDefinition/au-practitionerrole
[s26]: http://hl7.org.au/fhir/StructureDefinition/au-organization
[s27]: http://hl7.org.au/fhir/StructureDefinition/au-allergyintolerance
[s28]: http://hl7.org.au/fhir/StructureDefinition/au-immunization
[s29]: http://hl7.org.au/fhir/StructureDefinition/au-norelevantfinding
[s30]: http://hl7.org.au/fhir/StructureDefinition/au-procedure
[s31]: http://hl7.org.au/fhir/StructureDefinition/au-encounter
