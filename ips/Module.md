Ballerina package containing FHIR resource data models
compliant with http://hl7.org/fhir/uv/ips/ implementation guide.

# FHIR R4 ips package

## Package Overview

|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/uv/ips/               |

## Sample usage

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.ips;

public function main() returns error? {
json bundleJson = {
        "resourceType": "Bundle",
        "id": "IPS-examples-Bundle-01",
        "language": "en-GB",
        "identifier": {
            "system": "urn:oid:2.16.724.4.8.10.200.10",
            "value": "175bd032-8b00-4728-b2dc-748bb1501aed"
        },
        "type": "document",
        "timestamp": "2017-12-11T14:30:00+01:00",
        "entry": [
            {
                "fullUrl": "urn:uuid:2b90dd2b-2dab-4c75-9bb9-a355e07401e8",
                "resource": {
                    "resourceType": "Patient",
                    "id": "2b90dd2b-2dab-4c75-9bb9-a355e07401e8",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>identifier</b>: id: 574687583</p><p><b>active</b>: true</p><p><b>name</b>: Martha DeLarosa </p><p><b>telecom</b>: <a href=\"tel:+31788700800\">+31788700800</a></p><p><b>gender</b>: female</p><p><b>birthDate</b>: 1972-05-01</p><p><b>address</b>: Laan Van Europa 1600 Dordrecht 3317 DB Netherlands </p><h3>Contacts</h3><table class=\"grid\"><tr><td>-</td><td><b>Relationship</b></td><td><b>Name</b></td><td><b>Telecom</b></td><td><b>Address</b></td></tr><tr><td>*</td><td><span title=\"Codes: {http://terminology.hl7.org/CodeSystem/v3-RoleCode MTH}\">mother</span></td><td>Martha Mum </td><td><a href=\"tel:+33-555-20036\">+33-555-20036</a></td><td>Promenade des Anglais 111 Lyon 69001 France </td></tr></table></div>"
                    },
                    "identifier": [
                        {
                            "system": "urn:oid:2.16.840.1.113883.2.4.6.3",
                            "value": "574687583"
                        }
                    ],
                    "active": true,
                    "name": [
                        {
                            "family": "DeLarosa",
                            "given": [
                                "Martha"
                            ]
                        }
                    ],
                    "telecom": [
                        {
                            "system": "phone",
                            "value": "+31788700800",
                            "use": "home"
                        }
                    ],
                    "gender": "female",
                    "birthDate": "1972-05-01",
                    "address": [
                        {
                            "line": [
                                "Laan Van Europa 1600"
                            ],
                            "city": "Dordrecht",
                            "postalCode": "3317 DB",
                            "country": "Netherlands"
                        }
                    ]
                }
            }
        ]
};
    // Accepts a FHIR R4 Bundle or IpsData record and returns constructed IPS Bundle
    r4:Bundle|error ipsBundle = ips:getIpsBundle(check bundleJson.cloneWithType(r4:Bundle));
    if ipsBundle is r4:Bundle {
        io:println("IPS Bundle: " + ipsBundle.toString());
    } else {
        io:println("Error: " + ipsBundle.toString());
    }
}
```

## Customizing IPS Generation

You can override the default IPS generation logic by assigning your own implementation to the `ips:generateIps` function. This allows you to inject custom logic for constructing the IPS Bundle.

### Example

```ballerina
import ballerinax/health.fhir.r4.ips;
import ballerina/log;
import ballerinax/health.fhir.r4;

// Custom implementation for generating an IPS Bundle.
// The custom function must have the same signature as `GenerateIps`, with the first parameter as `patientId` and the second as `IPSContext`.
public isolated function generateIpsCustomImpl(string patientId, ips:IPSContext context) returns r4:Bundle|error {
    r4:Bundle ipsBundle = {
        'type: "document",
        'id: "ips-bundle-" + patientId,
        'meta: {
            'profile: ["http://hl7.org/fhir/uv/ips/StructureDefinition/InternationalPatientSummary"]
        },
        entry: []
    };
    return ipsBundle;
}

// Register the custom implementation for the IPS generation function within the init function.
public function initCustomImplementationForGenerateIps() {
    ips:registerCustomGenerateIps(generateIpsCustomImpl);
}
```

## Capabilities and features

### Supported FHIR resource types

|                  |                                             |
|------------------|---------------------------------------------|
| 1). MedicationStatementIPS | [[Definition]][s1] [[Ballerina Record]][m1] |
| 2). MedicationRequestIPS | [[Definition]][s2] [[Ballerina Record]][m2] |
| 3). DeviceObserverUvIps | [[Definition]][s3] [[Ballerina Record]][m3] |
| 4). ObservationPregnancyStatusUvIps | [[Definition]][s4] [[Ballerina Record]][m4] |
| 5). OrganizationUvIps | [[Definition]][s5] [[Ballerina Record]][m5] |
| 6). ImagingStudyUvIps | [[Definition]][s6] [[Ballerina Record]][m6] |
| 7). ObservationResultsUvIps | [[Definition]][s7] [[Ballerina Record]][m7] |
| 8). PractitionerRoleUvIps | [[Definition]][s8] [[Ballerina Record]][m8] |
| 9). ImmunizationUvIps | [[Definition]][s9] [[Ballerina Record]][m9] |
| 10). DeviceUvIps | [[Definition]][s10] [[Ballerina Record]][m10] |
| 11). ObservationPregnancyEddUvIps | [[Definition]][s11] [[Ballerina Record]][m11] |
| 12). ObservationResultsRadiologyUvIps | [[Definition]][s12] [[Ballerina Record]][m12] |
| 13). ObservationPregnancyOutcomeUvIps | [[Definition]][s13] [[Ballerina Record]][m13] |
| 14). ProcedureUvIps | [[Definition]][s14] [[Ballerina Record]][m14] |
| 15). DiagnosticReportUvIps | [[Definition]][s15] [[Ballerina Record]][m15] |
| 16). DeviceUseStatementUvIps | [[Definition]][s16] [[Ballerina Record]][m16] |
| 17). CompositionUvIps | [[Definition]][s17] [[Ballerina Record]][m17] |
| 18). ObservationAlcoholUseUvIps | [[Definition]][s18] [[Ballerina Record]][m18] |
| 19). ConditionUvIps | [[Definition]][s19] [[Ballerina Record]][m19] |
| 20). ObservationResultsPathologyUvIps | [[Definition]][s20] [[Ballerina Record]][m20] |
| 21). AllergyIntoleranceUvIps | [[Definition]][s21] [[Ballerina Record]][m21] |
| 22). ObservationTobaccoUseUvIps | [[Definition]][s22] [[Ballerina Record]][m22] |
| 23). ObservationResultsLaboratoryUvIps | [[Definition]][s23] [[Ballerina Record]][m23] |
| 24). PractitionerUvIps | [[Definition]][s24] [[Ballerina Record]][m24] |
| 25). MedicationIPS | [[Definition]][s25] [[Ballerina Record]][m25] |
| 26). MediaObservationUvIps | [[Definition]][s26] [[Ballerina Record]][m26] |
| 27). SpecimenUvIps | [[Definition]][s27] [[Ballerina Record]][m27] |
| 28). PatientUvIps | [[Definition]][s28] [[Ballerina Record]][m28] |

[m1]: https://lib.ballerina.io/ballerinax/ips/1.0.0#MedicationStatementIPS
[m2]: https://lib.ballerina.io/ballerinax/ips/1.0.0#MedicationRequestIPS
[m3]: https://lib.ballerina.io/ballerinax/ips/1.0.0#DeviceObserverUvIps
[m4]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationPregnancyStatusUvIps
[m5]: https://lib.ballerina.io/ballerinax/ips/1.0.0#OrganizationUvIps
[m6]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ImagingStudyUvIps
[m7]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationResultsUvIps
[m8]: https://lib.ballerina.io/ballerinax/ips/1.0.0#PractitionerRoleUvIps
[m9]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ImmunizationUvIps
[m10]: https://lib.ballerina.io/ballerinax/ips/1.0.0#DeviceUvIps
[m11]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationPregnancyEddUvIps
[m12]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationResultsRadiologyUvIps
[m13]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationPregnancyOutcomeUvIps
[m14]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ProcedureUvIps
[m15]: https://lib.ballerina.io/ballerinax/ips/1.0.0#DiagnosticReportUvIps
[m16]: https://lib.ballerina.io/ballerinax/ips/1.0.0#DeviceUseStatementUvIps
[m17]: https://lib.ballerina.io/ballerinax/ips/1.0.0#CompositionUvIps
[m18]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationAlcoholUseUvIps
[m19]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ConditionUvIps
[m20]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationResultsPathologyUvIps
[m21]: https://lib.ballerina.io/ballerinax/ips/1.0.0#AllergyIntoleranceUvIps
[m22]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationTobaccoUseUvIps
[m23]: https://lib.ballerina.io/ballerinax/ips/1.0.0#ObservationResultsLaboratoryUvIps
[m24]: https://lib.ballerina.io/ballerinax/ips/1.0.0#PractitionerUvIps
[m25]: https://lib.ballerina.io/ballerinax/ips/1.0.0#MedicationIPS
[m26]: https://lib.ballerina.io/ballerinax/ips/1.0.0#MediaObservationUvIps
[m27]: https://lib.ballerina.io/ballerinax/ips/1.0.0#SpecimenUvIps
[m28]: https://lib.ballerina.io/ballerinax/ips/1.0.0#PatientUvIps

[s1]: http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationStatement-uv-ips
[s2]: http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationRequest-uv-ips
[s3]: http://hl7.org/fhir/uv/ips/StructureDefinition/Device-observer-uv-ips
[s4]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-status-uv-ips
[s5]: http://hl7.org/fhir/uv/ips/StructureDefinition/Organization-uv-ips
[s6]: http://hl7.org/fhir/uv/ips/StructureDefinition/ImagingStudy-uv-ips
[s7]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-uv-ips
[s8]: http://hl7.org/fhir/uv/ips/StructureDefinition/PractitionerRole-uv-ips
[s9]: http://hl7.org/fhir/uv/ips/StructureDefinition/Immunization-uv-ips
[s10]: http://hl7.org/fhir/uv/ips/StructureDefinition/Device-uv-ips
[s11]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-edd-uv-ips
[s12]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-radiology-uv-ips
[s13]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-outcome-uv-ips
[s14]: http://hl7.org/fhir/uv/ips/StructureDefinition/Procedure-uv-ips
[s15]: http://hl7.org/fhir/uv/ips/StructureDefinition/DiagnosticReport-uv-ips
[s16]: http://hl7.org/fhir/uv/ips/StructureDefinition/DeviceUseStatement-uv-ips
[s17]: http://hl7.org/fhir/uv/ips/StructureDefinition/Composition-uv-ips
[s18]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-alcoholuse-uv-ips
[s19]: http://hl7.org/fhir/uv/ips/StructureDefinition/Condition-uv-ips
[s20]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-pathology-uv-ips
[s21]: http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-uv-ips
[s22]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-tobaccouse-uv-ips
[s23]: http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-laboratory-uv-ips
[s24]: http://hl7.org/fhir/uv/ips/StructureDefinition/Practitioner-uv-ips
[s25]: http://hl7.org/fhir/uv/ips/StructureDefinition/Medication-uv-ips
[s26]: http://hl7.org/fhir/uv/ips/StructureDefinition/Media-observation-uv-ips
[s27]: http://hl7.org/fhir/uv/ips/StructureDefinition/Specimen-uv-ips
[s28]: http://hl7.org/fhir/uv/ips/StructureDefinition/Patient-uv-ips
