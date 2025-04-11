Ballerina package containing FHIR resource data models
compliant with http://medcomfhir.dk/ig/core/ implementation guide.

# FHIR R4 medcom240 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://medcomfhir.dk/ig/core/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). MedComCoreMedia | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). MedComCorePractitionerRole | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). MedComCoreCareTeam | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). MedComCoreDiagnosticReport | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). MedComCorePatient | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). MedComCorePractitioner | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). MedComCoreEncounter | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). MedComCoreOrganization | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). MedComCoreObservation | [[Definition]][s9] [[Ballerina Record]][m9] |

[m1]: https://lib.ballerina.io/healthcare/medcom240/1.0.0#MedComCoreMedia
[m2]: https://lib.ballerina.io/healthcare/medcom240/1.0.0#MedComCorePractitionerRole
[m3]: https://lib.ballerina.io/healthcare/medcom240/1.0.0#MedComCoreCareTeam
[m4]: https://lib.ballerina.io/healthcare/medcom240/1.0.0#MedComCoreDiagnosticReport
[m5]: https://lib.ballerina.io/healthcare/medcom240/1.0.0#MedComCorePatient
[m6]: https://lib.ballerina.io/healthcare/medcom240/1.0.0#MedComCorePractitioner
[m7]: https://lib.ballerina.io/healthcare/medcom240/1.0.0#MedComCoreEncounter
[m8]: https://lib.ballerina.io/healthcare/medcom240/1.0.0#MedComCoreOrganization
[m9]: https://lib.ballerina.io/healthcare/medcom240/1.0.0#MedComCoreObservation

[s1]: http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-media
[s2]: http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-practitionerrole
[s3]: http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-careteam
[s4]: http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-diagnosticreport
[s5]: http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-patient
[s6]: http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-practitioner
[s7]: http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-encounter
[s8]: http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-organization
[s9]: http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-observation
