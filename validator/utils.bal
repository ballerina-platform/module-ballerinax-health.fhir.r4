import ballerina/http;
import ballerina/io;

public type Term record {
    string code;
    string system;
    string version?;
};

public isolated function extractCodesAndSystems(anydata data) returns Term[] {
    Term[] result = [];

    if data is map<anydata> {
        if data.hasKey("valueCode") && data.hasKey("url") {
            result.push({
                code: <string>data["valueCode"],
                system: <string>data["url"]
            });

            // check is there is not other properties in the map
            if data.length() == 2 {
                return result;
            }
        }

        foreach var [key, value] in data.entries() {
            if key == "valueCoding" && value is map<anydata> {
                Term[] codingResult = extractFromR4Coding(value);
                foreach Term item in codingResult {
                    result.push(item);
                }
            } else if key == "coding" && value is anydata[] {
                foreach anydata item in value {
                    Term[] codeableResult = extractFromR4Coding(item);
                    foreach Term codeableItem in codeableResult {
                        result.push(codeableItem);
                    }
                }
            } else if value is map<anydata> || value is anydata[] {
                Term[] nestedResult = extractCodesAndSystems(value);
                foreach Term item in nestedResult {
                    result.push(item);
                }
            }
        }
    } else if data is anydata[] {
        foreach anydata item in data {
            Term[] arrayResult = extractCodesAndSystems(item);
            foreach Term arrayItem in arrayResult {
                result.push(arrayItem);
            }
        }
    }

    return result;
}

public isolated function extractFromR4Coding(anydata data) returns Term[] {
    Term[] result = [];

    if data is map<anydata> {
        if data.hasKey("code") && data.hasKey("system") {
            result.push({
                code: <string>data["code"],
                system: <string>data["system"],
                version: data.hasKey("version") ? <string>data["version"] : null
            });
        }
        if data.hasKey("extension") {
            Term[] extensionResult = extractCodesAndSystems(data["extension"]);
            foreach Term item in extensionResult {
                result.push(item);
            }
        }
    }

    return result;
}

public isolated function checkTerminologyValidity(Term[] terms) returns string[]|error? {
    string[] errors = [];
    int successCount = 0;
    int failureCount = 0;
    int skipCount = 0;

    http:Client termClient = check new ("http://localhost:9090/fhir/r4");
    string codeSystemLookupEndpoint = "/Codesystem/%24lookup";
    string valueSetValidateEndpoint = "/Valueset/%24validate-code";

    foreach Term term in terms {
        string queryParams = string `?system=${term.system}&code=${term.code}${(term.version is string ? "&version=" + <string>term.version : "")}`;

        // Send GET request to ValueSet validate-code API
        http:Response|http:Error valuesetResponse = termClient->get(valueSetValidateEndpoint + queryParams);

        if valuesetResponse is http:Response {
            if valuesetResponse.statusCode == 200 {
                successCount += 1;
                // } else if valuesetResponse.statusCode == 404 {
                //     failureCount += 1;
                //     errors.push("Invalid code: " + term.code + " in system: " + term.system);
            } else if valuesetResponse.statusCode == 404 { // 400
                // Send GET request to CodeSystem lookup API
                http:Response|http:Error codesystemResponse = termClient->get(codeSystemLookupEndpoint + queryParams);

                if codesystemResponse is http:Response {
                    if codesystemResponse.statusCode == 200 {
                        successCount += 1;
                    } else if codesystemResponse.statusCode == 404 {
                        failureCount += 1;
                        errors.push("Invalid code: " + term.code + " in system: " + term.system);
                    } else if codesystemResponse.statusCode == 400 {
                        skipCount += 1;
                        io:println("System is not defined in terminology service: ", term.system);
                    }
                }
            }
        }
    }

    io:println("Validation Summary: Successes: ", successCount, ", Failures: ", failureCount, ", Skips: ", skipCount);

    if errors.length() == 0 {
        return;
    }

    return errors;
}

public isolated function validateTerminologies(anydata data) returns string[]|error? {
    Term[] result = extractCodesAndSystems(data);
    // io:println("Extracted Codes: ", result.length());

    return checkTerminologyValidity(result);
}

// public function main() {
//     json testData = {
//         "resourceType": "AllergyIntolerance",
//         "id": "example",
//         "meta": {
//             "profile": ["http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance"]
//         },
//         "text": {
//             "status": "generated",
//             "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: AllergyIntolerance</b><a name=\"example\"> </a><a name=\"hcexample\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource AllergyIntolerance &quot;example&quot; </p><p style=\"margin-bottom: 0px\">Profile: <a href=\"StructureDefinition-us-core-allergyintolerance.html\">US Core AllergyIntolerance Profile (version 7.0.0)</a></p></div><p><b>clinicalStatus</b>: Active <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.5.0/CodeSystem-allergyintolerance-clinical.html\">AllergyIntolerance Clinical Status Codes</a>#active)</span></p><p><b>verificationStatus</b>: Confirmed <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.5.0/CodeSystem-allergyintolerance-verification.html\">AllergyIntolerance Verification Status</a>#confirmed)</span></p><p><b>category</b>: medication</p><p><b>criticality</b>: high</p><p><b>code</b>: sulfonamide antibacterial <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT[US]</a>#763875007 &quot;Product containing sulfonamide (product)&quot;)</span></p><p><b>patient</b>: <a href=\"Patient-example.html\">Patient/example: Amy V. Shaw</a> &quot; SHAW&quot;</p><h3>Reactions</h3><table class=\"grid\"><tr><td style=\"display: none\">-</td><td><b>Manifestation</b></td><td><b>Severity</b></td></tr><tr><td style=\"display: none\">*</td><td>skin rash <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT[US]</a>#271807003)</span></td><td>mild</td></tr></table></div>"
//         },
//         "clinicalStatus": {
//             "coding": [
//                 {
//                     "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
//                     "code": "active"
//                 }
//             ]
//         },
//         "verificationStatus": {
//             "coding": [
//                 {
//                     "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
//                     "code": "confirmed"
//                 }
//             ]
//         },
//         "category": ["medication"],
//         "criticality": "high",
//         "code": {
//             "coding": [
//                 {
//                     "system": "http://snomed.info/sct",
//                     "version": "http://snomed.info/sct/731000124108",
//                     "code": "763875007",
//                     "display": "Product containing sulfonamide (product)"
//                 }
//             ],
//             "text": "sulfonamide antibacterial"
//         },
//         "patient": {
//             "reference": "Patient/example",
//             "display": "Amy V. Shaw"
//         },
//         "reaction": [
//             {
//                 "manifestation": [
//                     {
//                         "coding": [
//                             {
//                                 "system": "http://snomed.info/sct",
//                                 "version": "http://snomed.info/sct/731000124108",
//                                 "code": "271807003",
//                                 "display": "skin rash"
//                             }
//                         ],
//                         "text": "skin rash"
//                     }
//                 ],
//                 "severity": "mild"
//             }
//         ]
//     };

//     string[]|error? validationErrors = validateTerminologies(testData);

//     if validationErrors is string[] {
//         foreach string errorString in validationErrors {
//             io:println("Validation Error: ", errorString);
//         }
//     } else if validationErrors is error {
//         io:println("Error during validation: ", validationErrors.message());
//     } else {
//         io:println("No validation errors found.");
//     }

// }
