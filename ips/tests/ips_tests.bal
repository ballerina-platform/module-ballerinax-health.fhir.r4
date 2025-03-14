import ballerina/test;
import ballerinax/health.fhir.r4;

// write test cases of usage of getIpsBundle function

@test:Config
function testIpsBundleCreation() {
    IpsBundleData sampleData = {
        composition: {
            id: "comp-001",
            status: "final",
            subject: {reference: "Patient/pat-001"},
            date: "2025-01-01",
            author: [
                {
                    "reference": "Practitioner/1c616b24-3895-48c4-9a02-9a64110351ef"
                }
            ],
            section: [],
            title: "Summary of Patient Health Information",
            'type: {
                coding: [
                    {
                        system: "http://loinc.org",
                        code: "60591-5",
                        display: "Patient summary Document"
                    }
                ]
            }
        },
        patient: {
            id: "pat-001",
            name: [
                {
                    use: "official",
                    text: "John Doe"
                }
            ],
            gender: "male",
            birthDate: "1980-01-01"
        },
        organization: [
            {
                id: "org-001",
                name: "City Hospital"
            }
        ]
    };

    r4:Bundle ipsBundle = getIpsBundle(sampleData);
    test:assertEquals(ipsBundle.'type, "document");
    r4:BundleEntry[]? entry = ipsBundle.entry;
    if entry is r4:BundleEntry[] {
        test:assertEquals(entry.length(), 3);
    } else {
        test:assertFail("Bundle entry is not available");
    }

}
