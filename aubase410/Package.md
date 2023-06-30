Package containing the AU Base FHIR resource types

# FHIR R4 AUBase package

## Package Overview

|                          |                          |
|--------------------------|--------------------------|
| FHIR version             | R4                       |
| Implementation Guide(IG) | http://hl7.org.au/fhir/  |
| IG                       | 4.1.0                    | 

This package includes, FHIR AUBase Resource types.

**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| AUBaseComposition | [[Definition]][s1] [[Ballerina Record]][m1] |
| AUBaseMedicationRequest | [[Definition]][s2] [[Ballerina Record]][m2] |
| AUBasePathologyResult | [[Definition]][s3] [[Ballerina Record]][m3] |
| AUBasePatient | [[Definition]][s4] [[Ballerina Record]][m4] |
| AUBaseDiagnosticResult | [[Definition]][s5] [[Ballerina Record]][m5] |
| AUBasePractitioner | [[Definition]][s6] [[Ballerina Record]][m6] |
| AUBaseLocation | [[Definition]][s7] [[Ballerina Record]][m7] |
| AUBaseHealthcareService | [[Definition]][s8] [[Ballerina Record]][m8] |
| AUBaseDiagnosticImagingResult | [[Definition]][s9] [[Ballerina Record]][m9] |
| AUBaseMedication | [[Definition]][s10] [[Ballerina Record]][m10] |
| AUBaseDiagnosticReport | [[Definition]][s11] [[Ballerina Record]][m11] |
| AUMedicineList | [[Definition]][s12] [[Ballerina Record]][m12] |
| AUBaseDiagnosticRequest | [[Definition]][s13] [[Ballerina Record]][m13] |
| AUBaseMedicationAdministration | [[Definition]][s14] [[Ballerina Record]][m14] |
| AUBaseMedicationStatement | [[Definition]][s15] [[Ballerina Record]][m15] |
| AUBaseSpecimen | [[Definition]][s16] [[Ballerina Record]][m16] |
| AUBaseBodyStructure | [[Definition]][s17] [[Ballerina Record]][m17] |
| AUBaseMedicationDispense | [[Definition]][s18] [[Ballerina Record]][m18] |
| AUBaseCondition | [[Definition]][s19] [[Ballerina Record]][m19] |
| AUBaseDiagnosticImagingReport | [[Definition]][s20] [[Ballerina Record]][m20] |
| AUHealthProgramParticipationSummary | [[Definition]][s21] [[Ballerina Record]][m21] |
| AUBaseRelatedPerson | [[Definition]][s22] [[Ballerina Record]][m22] |
| AUBasePathologyReport | [[Definition]][s23] [[Ballerina Record]][m23] |
| AUBaseSubstance | [[Definition]][s24] [[Ballerina Record]][m24] |
| AUBasePractitionerRole | [[Definition]][s25] [[Ballerina Record]][m25] |
| AUBaseOrganisation | [[Definition]][s26] [[Ballerina Record]][m26] |
| AUBaseAllergyIntolerance | [[Definition]][s27] [[Ballerina Record]][m27] |
| AUBaseImmunisation | [[Definition]][s28] [[Ballerina Record]][m28] |
| AUAssertionNoRelevantFinding | [[Definition]][s29] [[Ballerina Record]][m29] |
| AUBaseProcedure | [[Definition]][s30] [[Ballerina Record]][m30] |
| AUBaseEncounter | [[Definition]][s31] [[Ballerina Record]][m31] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseComposition
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseMedicationRequest
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBasePathologyResult
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBasePatient
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseDiagnosticResult
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBasePractitioner
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseLocation
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseHealthcareService
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseDiagnosticImagingResult
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseMedication
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseDiagnosticReport
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUMedicineList
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseDiagnosticRequest
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseMedicationAdministration
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseMedicationStatement
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseSpecimen
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseBodyStructure
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseMedicationDispense
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseCondition
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseDiagnosticImagingReport
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUHealthProgramParticipationSummary
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseRelatedPerson
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBasePathologyReport
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseSubstance
[m25]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBasePractitionerRole
[m26]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseOrganisation
[m27]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseAllergyIntolerance
[m28]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseImmunisation
[m29]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUAssertionNoRelevantFinding
[m30]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseProcedure
[m31]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aubase410/1.0.4#AUBaseEncounter

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
