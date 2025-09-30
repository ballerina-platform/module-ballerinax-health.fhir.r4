Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/davinci-pas/ implementation guide.

# FHIR R4 health_fhir_r4_davincipas package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/us/davinci-pas/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). PASLocation | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). PASSubscription | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). PASDeviceRequest | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). PASClaim | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). PASRequestor | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). PASBeneficiary | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). PASPractitionerRole | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). PASClaimInquiryResponse | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). PASCommunicationRequest | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). PASInsurer | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). PASServiceRequest | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). PASClaimInquiry | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). PASTask | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). PASClaimResponse | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). PASOrganization | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). PASSubscriber | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). PASNutritionOrder | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). PASMedicationRequest | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). PASCoverage | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). PASPractitioner | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). PASClaimUpdate | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). PASClaimResponseBase | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). PASEncounter | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). PASClaimBase | [[Definition]][s24] [[Ballerina Record]][m24] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASLocation
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASSubscription
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASDeviceRequest
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASClaim
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASRequestor
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASBeneficiary
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASPractitionerRole
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASClaimInquiryResponse
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASCommunicationRequest
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASInsurer
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASServiceRequest
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASClaimInquiry
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASTask
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASClaimResponse
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASOrganization
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASSubscriber
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASNutritionOrder
[m18]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASMedicationRequest
[m19]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASCoverage
[m20]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASPractitioner
[m21]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASClaimUpdate
[m22]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASClaimResponseBase
[m23]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASEncounter
[m24]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincipas/1.0.0#PASClaimBase

[s1]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-location
[s2]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-subscription
[s3]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-devicerequest
[s4]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claim
[s5]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-requestor
[s6]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-beneficiary
[s7]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-practitionerrole
[s8]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claiminquiryresponse
[s9]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-communicationrequest
[s10]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-insurer
[s11]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-servicerequest
[s12]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claim-inquiry
[s13]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-task
[s14]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claimresponse
[s15]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-organization
[s16]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-subscriber
[s17]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-nutritionorder
[s18]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-medicationrequest
[s19]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-coverage
[s20]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-practitioner
[s21]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claim-update
[s22]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claimresponse-base
[s23]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-encounter
[s24]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claim-base
