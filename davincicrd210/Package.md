Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/davinci-crd/ implementation guide.

# FHIR R4 davincicrd210 package

## Package Overview

|                      |                                     |
| -------------------- | ----------------------------------- |
| FHIR version         | R4                                  |
| Implementation Guide | http://hl7.org/fhir/us/davinci-crd/ |

**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                              |                                               |
| ---------------------------- | --------------------------------------------- |
| 1). CRDAppointmentBase       | [[Definition]][s1] [[Ballerina Record]][m1]   |
| 2). CRDServiceRequest        | [[Definition]][s2] [[Ballerina Record]][m2]   |
| 3). CRDDeviceRequest         | [[Definition]][s3] [[Ballerina Record]][m3]   |
| 4). CRDDevice                | [[Definition]][s4] [[Ballerina Record]][m4]   |
| 5). CRDCoverage              | [[Definition]][s5] [[Ballerina Record]][m5]   |
| 6). CRDPatient               | [[Definition]][s6] [[Ballerina Record]][m6]   |
| 7). CRDVisionPrescription    | [[Definition]][s7] [[Ballerina Record]][m7]   |
| 8). CRDAppointmentWithOrder  | [[Definition]][s8] [[Ballerina Record]][m8]   |
| 9). CRDEncounter             | [[Definition]][s9] [[Ballerina Record]][m9]   |
| 10). CRDLocation             | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). CRDCommunicationRequest | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). CRDTaskDispatch         | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). CRDMedicationRequest    | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). CRDOrganization         | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). CRDNutritionOrder       | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). CRDTaskQuestionnaire    | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). CRDAppointmentNoOrder   | [[Definition]][s17] [[Ballerina Record]][m17] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDAppointmentBase
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDServiceRequest
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDDeviceRequest
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDDevice
[m5]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDCoverage
[m6]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDPatient
[m7]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDVisionPrescription
[m8]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDAppointmentWithOrder
[m9]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDEncounter
[m10]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDLocation
[m11]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDCommunicationRequest
[m12]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDTaskDispatch
[m13]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDMedicationRequest
[m14]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDOrganization
[m15]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDNutritionOrder
[m16]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDTaskQuestionnaire
[m17]: https://lib.ballerina.io/ballerinax/health.fhir.r4.davincicrd210/1.0.0#CRDAppointmentNoOrder
[s1]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-appointment-base
[s2]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-servicerequest
[s3]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-devicerequest
[s4]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-device
[s5]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-coverage
[s6]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-patient
[s7]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-visionprescription
[s8]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-appointment-with-order
[s9]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-encounter
[s10]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-location
[s11]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-communicationrequest
[s12]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-task-dispatch
[s13]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-medicationrequest
[s14]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-organization
[s15]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-nutritionorder
[s16]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-taskquestionnaire
[s17]: http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-appointment-no-order
