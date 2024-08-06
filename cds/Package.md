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
| 1). CdsService | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). CdsRequest | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). FhirAuthorization | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). OrderSignContext | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). OrderSelectContext | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). OrderDispatchContext | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). AppointmentBookContext | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). PatientViewContext | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). EncounterStartContext | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). EncounterDischargeContext | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). CdsResponse | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). Card | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). Source | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). Suggestion | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). Action | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). Link | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). Feedback | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). AcceptedSuggestion | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). OverrideReason | [[Definition]][s19] [[Ballerina Record]][m19] |

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

[m1]: http://hl7.org/fhir/StructureDefinition/Appointment
[m2]: http://hl7.org/fhir/StructureDefinition/Account
[m3]: http://hl7.org/fhir/StructureDefinition/Invoice
[m4]: http://hl7.org/fhir/StructureDefinition/CatalogEntry
[m5]: http://hl7.org/fhir/StructureDefinition/bodyheight
[m6]: http://hl7.org/fhir/StructureDefinition/EventDefinition
[m7]: http://hl7.org/fhir/StructureDefinition/heartrate
[m8]: http://hl7.org/fhir/StructureDefinition/DocumentManifest
[m9]: http://hl7.org/fhir/StructureDefinition/MessageDefinition
[m10]: http://hl7.org/fhir/StructureDefinition/Goal
[m11]: http://hl7.org/fhir/StructureDefinition/MedicinalProductPackaged
[m12]: http://hl7.org/fhir/StructureDefinition/Endpoint
[m13]: http://hl7.org/fhir/StructureDefinition/EnrollmentRequest
[m14]: http://hl7.org/fhir/StructureDefinition/Consent
[m15]: http://hl7.org/fhir/StructureDefinition/CapabilityStatement
[m16]: http://hl7.org/fhir/StructureDefinition/Medication
[m17]: http://hl7.org/fhir/StructureDefinition/Measure
[m18]: http://hl7.org/fhir/StructureDefinition/ResearchSubject
[m19]: http://hl7.org/fhir/StructureDefinition/familymemberhistory-genetic
