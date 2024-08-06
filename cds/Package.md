Ballerina package containing CDS data models
compliant with https://cds-hooks.hl7.org/2.0/ implementation guide.

# CDS package

## Package Overview

|                      |                        |
|----------------------|------------------------|
| CDS                  | 2.0                    |
| Implementation Guide | http://hl7.org/fhir/   |

## Capabilities and features

### CDS resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). CdsService | [[Definition]][s1] |
| 2). CdsRequest | [[Definition]][s2] |
| 3). FhirAuthorization | [[Definition]][s3] |
| 4). OrderSignContext | [[Definition]][s4] |
| 5). OrderSelectContext | [[Definition]][s5] |
| 6). OrderDispatchContext | [[Definition]][s6] |
| 7). AppointmentBookContext | [[Definition]][s7] |
| 8). PatientViewContext | [[Definition]][s8] |
| 9). EncounterStartContext | [[Definition]][s9] |
| 10). EncounterDischargeContext | [[Definition]][s10] |
| 11). CdsResponse | [[Definition]][s11] |
| 12). Card | [[Definition]][s12] |
| 13). Source | [[Definition]][s13] |
| 14). Suggestion | [[Definition]][s14] |
| 15). Action | [[Definition]][s15] |
| 16). Link | [[Definition]][s16] |
| 17). Feedback | [[Definition]][s17] |
| 18). AcceptedSuggestion | [[Definition]][s18] |
| 19). OverrideReason | [[Definition]][s19] |

[s1]: https://cds-hooks.hl7.org/2.0/#response
[s2]: https://cds-hooks.hl7.org/2.0/#http-request_1
[s3]: https://cds-hooks.hl7.org/2.0/#passing-the-access-token-to-the-cds-service
[s4]: https://cds-hooks.hl7.org/hooks/order-sign/STU1/order-sign/
[s5]: https://cds-hooks.hl7.org/hooks/order-select/STU1/order-select/
[s6]: https://cds-hooks.hl7.org/hooks/order-dispatch/STU1/order-dispatch/
[s7]: https://cds-hooks.hl7.org/hooks/appointment-book/STU1/appointment-book/
[s8]: https://cds-hooks.hl7.org/hooks/patient-view/STU1/patient-view/
[s9]: https://cds-hooks.hl7.org/hooks/encounter-start/STU1/encounter-start/
[s10]: https://cds-hooks.hl7.org/hooks/encounter-discharge/STU1/encounter-discharge/
[s11]: https://cds-hooks.hl7.org/2.0/#http-response
[s12]: https://cds-hooks.hl7.org/2.0/#card-attributes
[s13]: https://cds-hooks.hl7.org/2.0/#sources
[s14]: https://cds-hooks.hl7.org/2.0/#suggestion
[s15]: https://cds-hooks.hl7.org/2.0/#action
[s16]: https://cds-hooks.hl7.org/2.0/#link
[s17]: https://cds-hooks.hl7.org/2.0/#feedback
[s18]: https://cds-hooks.hl7.org/2.0/#suggestion-accepted
[s19]: https://cds-hooks.hl7.org/2.0/#overridereason
