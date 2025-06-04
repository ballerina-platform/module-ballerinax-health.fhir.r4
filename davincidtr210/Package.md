Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/us/davinci-dtr/ implementation guide.

# FHIR R4 davincidtr210 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/us/davinci-dtr/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). DTRStdQuestionnaire | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). DTRQuestionnairePackageInputParameters | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). DTRQuestionnaireNextQuestionnaireInputParameters | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). DTRQuestionnaireNextQuestionnaireOutputParameters | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). DTRQuestionnairePackageOutputParameters | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). DTRQuestionnaireAdapt | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). DTRQuestionnaireAdaptSearch | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). DTRQuestionnaireResponse | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). DTRLogErrorsInputParameters | [[Definition]][s9] [[Ballerina Record]][m9] |

[m1]: https://lib.ballerina.io/healthcare/davincidtr210/1.0.0#DTRStdQuestionnaire
[m2]: https://lib.ballerina.io/healthcare/davincidtr210/1.0.0#DTRQuestionnairePackageInputParameters
[m3]: https://lib.ballerina.io/healthcare/davincidtr210/1.0.0#DTRQuestionnaireNextQuestionnaireInputParameters
[m4]: https://lib.ballerina.io/healthcare/davincidtr210/1.0.0#DTRQuestionnaireNextQuestionnaireOutputParameters
[m5]: https://lib.ballerina.io/healthcare/davincidtr210/1.0.0#DTRQuestionnairePackageOutputParameters
[m6]: https://lib.ballerina.io/healthcare/davincidtr210/1.0.0#DTRQuestionnaireAdapt
[m7]: https://lib.ballerina.io/healthcare/davincidtr210/1.0.0#DTRQuestionnaireAdaptSearch
[m8]: https://lib.ballerina.io/healthcare/davincidtr210/1.0.0#DTRQuestionnaireResponse
[m9]: https://lib.ballerina.io/healthcare/davincidtr210/1.0.0#DTRLogErrorsInputParameters

[s1]: http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-std-questionnaire
[s2]: http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-qpackage-input-parameters
[s3]: http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-next-question-input-parameters
[s4]: http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-next-question-output-parameters
[s5]: http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-qpackage-output-parameters
[s6]: http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-questionnaire-adapt
[s7]: http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-questionnaire-adapt-search
[s8]: http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-questionnaireresponse
[s9]: http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-log-errors-input-parameters
