Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/davinci-pas/ implementation guide.

# FHIR R4 davincipas package

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
| 2). PASDeviceRequest | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). PASClaim | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). PASRequestor | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). PASBeneficiary | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). PASPractitionerRole | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). PASClaimInquiryResponse | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). PASCommunicationRequest | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). PASInsurer | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). PASServiceRequest | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). PASClaimInquiry | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). PASTask | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). PASClaimResponse | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). PASOrganization | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). PASSubscriber | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). PASNutritionOrder | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). PASMedicationRequest | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). PASCoverage | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). PASPractitioner | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). PASClaimUpdate | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). PASClaimResponseBase | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). PASEncounter | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). PASClaimBase | [[Definition]][s23] [[Ballerina Record]][m23] |

[m1]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASLocation
[m2]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASDeviceRequest
[m3]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASClaim
[m4]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASRequestor
[m5]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASBeneficiary
[m6]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASPractitionerRole
[m7]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASClaimInquiryResponse
[m8]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASCommunicationRequest
[m9]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASInsurer
[m10]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASServiceRequest
[m11]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASClaimInquiry
[m12]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASTask
[m13]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASClaimResponse
[m14]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASOrganization
[m15]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASSubscriber
[m16]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASNutritionOrder
[m17]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASMedicationRequest
[m18]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASCoverage
[m19]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASPractitioner
[m20]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASClaimUpdate
[m21]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASClaimResponseBase
[m22]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASEncounter
[m23]: https://lib.ballerina.io/healthcare/davincipas/1.0.0#PASClaimBase

[s1]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-location
[s2]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-devicerequest
[s3]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claim
[s4]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-requestor
[s5]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-beneficiary
[s6]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-practitionerrole
[s7]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claiminquiryresponse
[s8]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-communicationrequest
[s9]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-insurer
[s10]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-servicerequest
[s11]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claim-inquiry
[s12]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-task
[s13]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claimresponse
[s14]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-organization
[s15]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-subscriber
[s16]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-nutritionorder
[s17]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-medicationrequest
[s18]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-coverage
[s19]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-practitioner
[s20]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claim-update
[s21]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claimresponse-base
[s22]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-encounter
[s23]: http://hl7.org/fhir/us/davinci-pas/StructureDefinition/profile-claim-base
