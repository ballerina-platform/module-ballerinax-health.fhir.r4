import ballerina/test;

public function getResource() returns map<json> {
    map<json> patientPayload = {
        "resourceType" : "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/Patient"
            ]
        },
        "active":true,
        "name":[
            {
                "use":"official",
                "family":"Chalmers",
                "given":[
                    "Peter",
                    "James"
                ]
            },
            {
                "use":"usual",
                "given":[
                    "Jim"
                ]
            }
        ],
        "gender":"male",
        "birthDate":"1974-12-25",
        "managingOrganization":{
            "reference":"Organization/1",
            "display":"Burgers University Medical Center"
        },
        "address":[
            {
                "use":"home",
                "line":[
                    "534 Erewhon St",
                    "sqw"
                ],
                "city":"PleasantVille",
                "district":"Rainbow",
                "state":"Vic",
                "postalCode":"3999",
                "country":"Australia"
            },
            {
                "use":"work",
                "line":[
                    "33[0] 6th St"
                ],
                "city":"Melbourne",
                "district":"Rainbow",
                "state":"Vic",
                "postalCode":"3000",
                "country":"Australia"
            }
        ]
    };
    return patientPayload;

}

public function getOrgResource() returns map<json> {
    map<json> org ={
        "resourceType" : "Organization",
        address: [
            {
                "use":"work",
                "line":[
                    "33[0] 6th St"
                ],
                "city":"Melbourne",
                "district":"Rainbow",
                "state":"Vic",
                "postalCode":"3000",
                "country":"Australia"
            }
        ],
        active: false,
        language: "eng",
        contact: [
            {
            address: {
                    "use":"work",
                    "line":[
                        "33[0] 6th St"
                    ],
                    "city":"Melbourne",
                    "district":"Rainbow",
                    "state":"Vic",
                    "postalCode":"3000",
                    "country":"Australia"
                    }
            }  
        ],
        id: "test_ID",
        name: "test_name"
    };
    return org;    
}

@test:Config {}
public function testFunction() returns error? {
    // Unit Test for HappyPaths.
    test:assertEquals(evaluateFhirPath(getResource(), "Patient.id"),"1", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(), "Patient.address[0].line[0]"),"534 Erewhon St", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(), "Patient.address.line[1]"),"sqw", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(), "Patient.address[0].city"),"PleasantVille", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(), "Patient.address[1].line[0]"),"33[0] 6th St", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(), "Patient.address[1].city"),"Melbourne", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(), "Patient.name[0].use"),"official", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(), "Patient.name[0].given[0]"),"Peter", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(),"Patient.active"),true, msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(),"Patient.managingOrganization.reference"),"Organization/1", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(),"Patient.managingOrganization.display"),"Burgers University Medical Center", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(),"Patient.address.use"),<anydata[]>(["home","work"]), msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(),"Patient.name.given"),<anydata[]>([["Peter","James"],["Jim"]]), msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(),"Patient.name[0].given"),<anydata[]>["Peter","James"], msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getResource(),"Patient.name.given[0]"),<anydata[]> ["Peter","Jim"], msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getOrgResource(), "Organization.address.use"),"work", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getOrgResource(), "Organization.language"),"eng", msg = "Failed!");
    test:assertEquals(evaluateFhirPath(getOrgResource(), "Organization.contact[0].address.line"),<anydata>["33[0] 6th St"], msg = "Failed!");


    // Unit tests for error paths.
    string|json|int|float|boolean|byte|error evaluateFhirPathResult = evaluateFhirPath(getResource(), "Patient.mother[a]");
    if evaluateFhirPathResult is error {
        test:assertEquals(evaluateFhirPathResult.message() ,"The given FhirPath expression is incorrect as it contains english " +
                "letter instead of number for array access", msg = "Failed!");
    }
    string|json|int|float|boolean|byte|error testOne = evaluateFhirPath(getResource(), "Pat.name");
    if testOne is error {
        test:assertEquals(testOne.message() ,"Resource is not match with the FhirPath expression", msg = "Failed!");
    }
    string|json|int|float|boolean|byte|error testTwo = evaluateFhirPath(getResource(), "Patient.address.name");
    if testTwo is error {
        test:assertEquals(testTwo.message() ,"The given FhirPath expression is incorrect for the given FHIR resource", msg = "Failed!");
    }
    string|json|int|float|boolean|byte|error testThree = evaluateFhirPath(getResource(), "Patient.name[0].given[a]");
    if testThree is error {
        test:assertEquals(testThree.message() ,"The given FhirPath expression is incorrect as it contains english letter instead of number for array access", msg = "Failed!");
    }
    string|json|int|float|boolean|byte|error testFour = evaluateFhirPath(getResource(), "Patient.meta.profile[8]");
    if testFour is error {
        test:assertEquals(testFour.message() ,"The given array index is incorrect for the given FHIRresource", msg = "Failed!");
    }
    string|json|int|float|boolean|byte|error testFive = evaluateFhirPath(getResource(), "Patient.address.mor");
    if testFive is error {
        test:assertEquals(testFive.message() ,"The given FhirPath expression is incorrect for the given FHIR resource", msg = "Failed!");
    }
    FhirPathResult fhirPathResult = getFhirPathResult(getResource(), "Patient.address.mor" );
    string? testSix = fhirPathResult?.resultenError;
    if testSix !is () {
        test:assertEquals(testSix, "The given FhirPath expression is incorrect for the given FHIR resource", msg = "Failed!");
    }

    FhirPathResult fhirPathResultTwo = getFhirPathResult(getResource(), "Patient.id" );
    string? testSeven = <string?>fhirPathResultTwo?.result;
    if testSeven !is () {
        test:assertEquals(testSeven, "1", msg = "Failed!");
    }
 }
