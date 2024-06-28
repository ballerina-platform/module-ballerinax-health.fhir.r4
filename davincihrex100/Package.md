Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/davinci-hrex/ implementation guide.

# FHIR R4 Da Vinci HREX package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/us/davinci-hrex/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). HRexMemberMatchRequestParameters | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). HRexPractitioner | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). HRexMemberMatchResponseParameters | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). HRexProvenance | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). HRexConsent | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). HRexOrganization | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). HRexPractitionerRole | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). HRexCoverage | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). HRexTaskDataRequest | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). HRexPatientDemographics | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). HRexClaimResponse | [[Definition]][s11] [[Ballerina Record]][m11] |

[m1]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexMemberMatchRequestParameters
[m2]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexPractitioner
[m3]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexMemberMatchResponseParameters
[m4]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexProvenance
[m5]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexConsent
[m6]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexOrganization
[m7]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexPractitionerRole
[m8]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexCoverage
[m9]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexTaskDataRequest
[m10]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexPatientDemographics
[m11]: https://lib.ballerina.io/healthcare/hrex/1.0.0#HRexClaimResponse

[s1]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-in
[s2]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-practitioner
[s3]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-out
[s4]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-provenance
[s5]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-consent
[s6]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-organization
[s7]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-practitionerrole
[s8]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-coverage
[s9]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-task-data-request
[s10]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-patient-demographics
[s11]: http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-claimresponse
