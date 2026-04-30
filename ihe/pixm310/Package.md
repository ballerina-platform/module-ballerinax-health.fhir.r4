Ballerina package containing FHIR resource data models
compliant with https://profiles.ihe.net/ITI/PIXm/ implementation guide.

# FHIR R4 health.fhir.r4.ihe.pixm310 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://profiles.ihe.net/ITI/PIXm/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). PIXmPatientBirthDateRequired | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). PIXmQueryParametersIn | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). AuditPixmFeedSourceUpdate | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). AuditPixmQueryManager | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). AuditPixmQueryConsumer | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). AuditPixmFeedManagerCreate | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). AuditPixmFeedManagerUpdate | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). AuditPixmFeedManagerDelete | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). PIXmPatient | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). AuditPixmFeedSourceDelete | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). PIXmQueryParametersOut | [[Definition]][s11] [[Ballerina Record]][m11] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#PIXmPatientBirthDateRequired
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#PIXmQueryParametersIn
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedSourceUpdate
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmQueryManager
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmQueryConsumer
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedManagerCreate
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedManagerUpdate
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedManagerDelete
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#PIXmPatient
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#AuditPixmFeedSourceDelete
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.ihe.pixm310/1.0.0#PIXmQueryParametersOut

[s1]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Patient.BirthDateRequired
[s2]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Query.Parameters.In
[s3]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Update.Audit.Source
[s4]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Query.Audit.Manager
[s5]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Query.Audit.Consumer
[s6]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Create.Audit.Manager
[s7]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Update.Audit.Manager
[s8]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Delete.Audit.Manager
[s9]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Patient
[s10]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Feed.Delete.Audit.Source
[s11]: https://profiles.ihe.net/ITI/PIXm/StructureDefinition/IHE.PIXm.Query.Parameters.Out
