Ballerina package containing FHIR resource data models
compliant with http://hl7.org.au/fhir/ implementation guide.

# FHIR R4 aubase421 package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org.au/fhir/               |


**Note:**
**This package only supports FHIR JSON payload format only. FHIR XML payload support will be added soon.**

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). AUBaseComposition | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). AUBaseMedicationRequest | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). AUBasePathologyResult | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). AUBasePatient | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). AUBaseCoverage | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). AUBaseDiagnosticResult | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). AUBasePractitioner | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). AUBaseLocation | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). AUBaseHealthcareService | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). AUBaseDiagnosticImagingResult | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). AUBaseMedication | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). AUBaseDiagnosticReport | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). AUMedicineList | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). AUBaseDiagnosticRequest | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). AUBaseMedicationAdministration | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). AUBaseMedicationStatement | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). AUBaseSpecimen | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). AUBaseBodyStructure | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). AUBaseMedicationDispense | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). AUBaseCondition | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). AUBaseDiagnosticImagingReport | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). AUHealthProgramParticipationSummary | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). AUBaseRelatedPerson | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). AUBasePathologyReport | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). AUBaseSubstance | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). AUBasePractitionerRole | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). AUBaseOrganisation | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). AUBaseAllergyIntolerance | [[Definition]][s28] [[Ballerina Record]][m28] |
| 29). AUBaseImmunisation | [[Definition]][s29] [[Ballerina Record]][m29] |
| 30). AUAssertionNoRelevantFinding | [[Definition]][s30] [[Ballerina Record]][m30] |
| 31). AUBaseProcedure | [[Definition]][s31] [[Ballerina Record]][m31] |
| 32). AUBaseEncounter | [[Definition]][s32] [[Ballerina Record]][m32] |

[m1]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseComposition
[m2]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseMedicationRequest
[m3]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBasePathologyResult
[m4]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBasePatient
[m5]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseCoverage
[m6]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseDiagnosticResult
[m7]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBasePractitioner
[m8]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseLocation
[m9]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseHealthcareService
[m10]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseDiagnosticImagingResult
[m11]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseMedication
[m12]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseDiagnosticReport
[m13]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUMedicineList
[m14]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseDiagnosticRequest
[m15]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseMedicationAdministration
[m16]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseMedicationStatement
[m17]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseSpecimen
[m18]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseBodyStructure
[m19]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseMedicationDispense
[m20]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseCondition
[m21]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseDiagnosticImagingReport
[m22]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUHealthProgramParticipationSummary
[m23]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseRelatedPerson
[m24]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBasePathologyReport
[m25]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseSubstance
[m26]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBasePractitionerRole
[m27]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseOrganisation
[m28]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseAllergyIntolerance
[m29]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseImmunisation
[m30]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUAssertionNoRelevantFinding
[m31]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseProcedure
[m32]: https://lib.ballerina.io/healthcare/aubase421/1.0.0#AUBaseEncounter

[s1]: http://hl7.org.au/fhir/StructureDefinition/au-composition
[s2]: http://hl7.org.au/fhir/StructureDefinition/au-medicationrequest
[s3]: http://hl7.org.au/fhir/StructureDefinition/au-pathologyresult
[s4]: http://hl7.org.au/fhir/StructureDefinition/au-patient
[s5]: http://hl7.org.au/fhir/StructureDefinition/au-coverage
[s6]: http://hl7.org.au/fhir/StructureDefinition/au-diagnosticresult
[s7]: http://hl7.org.au/fhir/StructureDefinition/au-practitioner
[s8]: http://hl7.org.au/fhir/StructureDefinition/au-location
[s9]: http://hl7.org.au/fhir/StructureDefinition/au-healthcareservice
[s10]: http://hl7.org.au/fhir/StructureDefinition/au-imagingresult
[s11]: http://hl7.org.au/fhir/StructureDefinition/au-medication
[s12]: http://hl7.org.au/fhir/StructureDefinition/au-diagnosticreport
[s13]: http://hl7.org.au/fhir/StructureDefinition/au-medlist
[s14]: http://hl7.org.au/fhir/StructureDefinition/au-diagnosticrequest
[s15]: http://hl7.org.au/fhir/StructureDefinition/au-medicationadministration
[s16]: http://hl7.org.au/fhir/StructureDefinition/au-medicationstatement
[s17]: http://hl7.org.au/fhir/StructureDefinition/au-specimen
[s18]: http://hl7.org.au/fhir/StructureDefinition/au-bodystructure
[s19]: http://hl7.org.au/fhir/StructureDefinition/au-medicationdispense
[s20]: http://hl7.org.au/fhir/StructureDefinition/au-condition
[s21]: http://hl7.org.au/fhir/StructureDefinition/au-imagingreport
[s22]: http://hl7.org.au/fhir/StructureDefinition/au-healthprogramparticipation
[s23]: http://hl7.org.au/fhir/StructureDefinition/au-relatedperson
[s24]: http://hl7.org.au/fhir/StructureDefinition/au-pathologyreport
[s25]: http://hl7.org.au/fhir/StructureDefinition/au-substance
[s26]: http://hl7.org.au/fhir/StructureDefinition/au-practitionerrole
[s27]: http://hl7.org.au/fhir/StructureDefinition/au-organization
[s28]: http://hl7.org.au/fhir/StructureDefinition/au-allergyintolerance
[s29]: http://hl7.org.au/fhir/StructureDefinition/au-immunization
[s30]: http://hl7.org.au/fhir/StructureDefinition/au-norelevantfinding
[s31]: http://hl7.org.au/fhir/StructureDefinition/au-procedure
[s32]: http://hl7.org.au/fhir/StructureDefinition/au-encounter

## Sample Usage

This section focuses on samples depicting how to use this package to implement FHIR related integrations

### Prerequisites

1. Install Ballerina 2201.6.0 or later

### 1. Parse JSON FHIR resource to FHIR resource model
Sample below is using the AUBasePatient resource in `health.fhir.r4.aubase421` package.

```ballerina
import ballerina/log;
import ballerinax/health.fhir.r4.aubase421;
import ballerinax/health.fhir.r4.parser;

public function main() {
    json patientPayload = {
        "resourceType": "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org.au/fhir/StructureDefinition/au-patient"
            ]
        },
        "active":true,
        "name": [
            {
                "use":"official",
                "family":"Chalmers",
                "given":[
                    "Peter",
                    "James"
                ]
            }
        ],
        "gender":"male",
        "birthDate": {
          "value" : "1974-12-25"
        },
        "managingOrganization": {
            "reference":"Organization/1"
        }
    };

    do {
        anydata parsedResult = check parser:parse(patientPayload, aubase421:AUBasePatient);
        aubase421:AUBasePatient patientModel = check parsedResult.ensureType();
        log:printInfo(string `Patient name : ${patientModel.name.toString()}`);
    } on fail error parseError {
    	log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}
```

### 2. Creating FHIR Resource models and serializing to JSON wire formats

```ballerina
import ballerina/log;
import ballerina/time;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.aubase421;

public function main() {
    aubase421:AUBasePatient patient = {
        meta: {
            lastUpdated: time:utcToString(time:utcNow()),
            profile: [aubase421:PROFILE_BASE_AUBASEPATIENT]
        },
        active: true,
        name: [{
            family: "Doe",
            given: ["Jhon"],
            use: r4:official,
            prefix: ["Mr"]
        }],
        address: [{
            line: ["652 S. Lantern Dr."],
            city: "New York",
            country: "United States",
            postalCode: "10022",
            'type: r4:physical,
            use: r4:home
        }]
    };
    r4:FHIRResourceEntity fhirEntity = new(patient);
    // Serialize FHIR resource record to Json payload
    json|r4:FHIRSerializerError jsonResult = fhirEntity.toJson();
    if jsonResult is json {
        log:printInfo(string `Patient resource JSON payload : ${jsonResult.toJsonString()}`);
    } else {
        log:printError(string `Error occurred while serializing to JSON payload : ${jsonResult.message()}`, jsonResult);
    }
}
```

