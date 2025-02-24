import ballerinax/health.fhir.r4;

r4:BundleEntry sampleBundleEntry_org1 = {
    fullUrl: "http://example.com/entry1",
    'resource: sampleOrganizationProfile
};

r4:BundleEntry sampleBundleEntry2_org2 = {
    fullUrl: "http://example.com/entry2",
    'resource: sampleOrganizationProfile2
};

//Bundle entry with coverage profile
r4:BundleEntry sampleBundleEntry3_coverage = {
    fullUrl: "http://example.com/entry3",
    'resource: sampleCoverageProfile
};

r4:BundleEntry sampleBundleEntry4_Patient = {
    fullUrl: "http://example.com/entry4",
    'resource: samplePatientProfile
};

r4:BundleEntry sampleBundleEntry5_Encounter = {
    fullUrl: "http://example.com/entry5",
    'resource: sampleEncounterProfile
};
r4:BundleEntry sampleBundleEntry6_Practitioner = {
    fullUrl: "http://example.com/entry5",
    'resource: samplePractitionerProfile
};

r4:BundleEntry sampleBundleEntry7_Claim = {
    fullUrl: "http://example.com/entry5",
    'resource: claim
};

r4:Bundle bundle = {
    "resourceType": "Bundle",
    "id": "bundle-example",
    "meta": {
        "lastUpdated": "2014-08-18T01:43:30Z"
    },
    "type": "searchset",
    "total": 3,
    "link": [
        {
            "relation": "self",
            "url": "https://example.com/base/MedicationRequest?patient=347&_include=MedicationRequest.medication&_count=2"
        },
        {
            "relation": "next",
            "url": "https://example.com/base/MedicationRequest?patient=347&searchId=ff15fd40-ff71-4b48-b366-09c706bed9d0&page=2"
        }
    ],
    "entry": [sampleBundleEntry_org1, sampleBundleEntry2_org2, sampleBundleEntry3_coverage, sampleBundleEntry4_Patient, sampleBundleEntry5_Encounter, sampleBundleEntry6_Practitioner, sampleBundleEntry7_Claim]
};

