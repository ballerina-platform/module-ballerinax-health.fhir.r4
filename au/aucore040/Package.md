Ballerina package containing FHIR resource data models
compliant with http://hl7.org.au/fhir/core/ implementation guide.

# FHIR R4 health_fhir_r4_aucore040 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org.au/fhir/core/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). AUCoreOrganization | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). AUCorePatient | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). AUCoreImmunization | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). AUCoreBodyWeight | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). AUCoreWaistCircumference | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). AUCoreEncounter | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). AUCoreProcedure | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). AUCoreAllergyIntolerance | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). AUCoreBodyHeight | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). AUCoreBodyTemperature | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). AUCorePractitioner | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). AUCoreMedication | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). AUCoreMedicationRequest | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). AUCoreCondition | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). AUCorePractitionerRole | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). AUCoreHeartRate | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). AUCoreSmokingStatus | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). AUCoreRespirationRate | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). AUCoreBloodPressure | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). AUCorePathologyResult | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). AUCoreDiagnosticResult | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). AUCoreLocation | [[Definition]][s22] [[Ballerina Record]][m22] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreOrganization
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCorePatient
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreImmunization
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreBodyWeight
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreWaistCircumference
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreEncounter
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreProcedure
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreAllergyIntolerance
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreBodyHeight
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreBodyTemperature
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCorePractitioner
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreMedication
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreMedicationRequest
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreCondition
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCorePractitionerRole
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreHeartRate
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreSmokingStatus
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreRespirationRate
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreBloodPressure
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCorePathologyResult
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreDiagnosticResult
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.aucore040/1.0.0#AUCoreLocation

[s1]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-organization
[s2]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-patient
[s3]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-immunization
[s4]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-bodyweight
[s5]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-waistcircum
[s6]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-encounter
[s7]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-procedure
[s8]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-allergyintolerance
[s9]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-bodyheight
[s10]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-bodytemp
[s11]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-practitioner
[s12]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-medication
[s13]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-medicationrequest
[s14]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-condition
[s15]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-practitionerrole
[s16]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-heartrate
[s17]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-smokingstatus
[s18]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-resprate
[s19]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-bloodpressure
[s20]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult-path
[s21]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult
[s22]: http://hl7.org.au/fhir/core/StructureDefinition/au-core-location
