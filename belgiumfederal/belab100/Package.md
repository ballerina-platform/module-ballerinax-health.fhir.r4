Ballerina package containing FHIR resource data models
compliant with https://www.ehealth.fgov.be/standards/fhir/lab/ implementation guide.

# FHIR R4 health_fhir_r4_be_lab100 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | https://www.ehealth.fgov.be/standards/fhir/lab/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). BeLaboratoryReport | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). BeLaboratoryReportComposition | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). BeSpecimenLaboratory | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). BeObservationLaboratory | [[Definition]][s4] [[Ballerina Record]][m4] |

[m1]: https://lib.ballerina.io/ballerinax/health.fhir.r4.be.lab100/1.0.0#BeLaboratoryReport
[m2]: https://lib.ballerina.io/ballerinax/health.fhir.r4.be.lab100/1.0.0#BeLaboratoryReportComposition
[m3]: https://lib.ballerina.io/ballerinax/health.fhir.r4.be.lab100/1.0.0#BeSpecimenLaboratory
[m4]: https://lib.ballerina.io/ballerinax/health.fhir.r4.be.lab100/1.0.0#BeObservationLaboratory

[s1]: https://www.ehealth.fgov.be/standards/fhir/lab/StructureDefinition/be-laboratory-report
[s2]: https://www.ehealth.fgov.be/standards/fhir/lab/StructureDefinition/be-laboratory-report-composition
[s3]: https://www.ehealth.fgov.be/standards/fhir/lab/StructureDefinition/be-specimen-laboratory
[s4]: https://www.ehealth.fgov.be/standards/fhir/lab/StructureDefinition/be-observation-laboratory
