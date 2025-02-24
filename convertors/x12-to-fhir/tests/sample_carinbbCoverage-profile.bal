import ballerinax/health.fhir.r4.carinbb200;
import ballerinax/health.fhir.r4;

carinbb200:C4BBCoverage sampleCoverageProfile = {
  "resourceType" : "Coverage",
  "id" : "Coverage/InsuranceExample",
  "meta" : {
    "lastUpdated" : "2020-10-30T09:48:01.8462752-04:00",
    "profile" : [
      ""
    ]
  },
  "language" : "en-US",
  "text" : {
    "status" : "generated",
    "div" : ""
  },
  "identifier" : [
    {
      "type" : {
        "coding" : [
          {
            "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
            "code" : "MB",
            "display" : "Member Number"
          }
        ],
        "text" : "An identifier for the insured of an insurance policy (this insured always has a subscriber), usually assigned by the insurance carrier."
      },
      "system" : "https://www.upmchealthplan.com/fhir/memberidentifier",
      "value" : "88800933501",
      "assigner" : {
        "reference" : "Organization/Payer2",
        "display" : "UPMC Health Plan"
      }
    }
  ],
  "status" : "active",
  "policyHolder" : {
    "reference" : "Patient/Patient1"
  },
  "subscriber" : {
    "reference" : "Patient/Patient1"
  },
  "subscriberId" : "888009335",
  "beneficiary" : {
    "reference" : "Patient/Patient1"
  },
  "dependent" : "01",
  "relationship" : {
    "coding" : [
      {
        "system" : "http://terminology.hl7.org/CodeSystem/subscriber-relationship",
        "code" : "common"
      }
    ],
    "text" : "Self"
  },
  "period" : {
    "start" : "2020-01-01"
  },
  "payor" : coveragePayorReference,
  "class" : [
    {
      "type" : {
        "coding" : [
          {
            "system" : "http://terminology.hl7.org/CodeSystem/coverage-class",
            "code" : "group",
            "display" : "Group"
          }
        ],
        "text" : "An employee group"
      },
      "value" : "MCHMO1",
      "name" : "MEDICARE HMO PLAN"
    },
    {
      "type" : {
        "coding" : [
          {
            "system" : "http://terminology.hl7.org/CodeSystem/coverage-class",
            "code" : "plan",
            "display" : "Plan"
          }
        ],
        "text" : "A specific suite of benefits."
      },
      "value" : "GR5",
      "name" : "GR5-HMO DEDUCTIBLE"
    }
  ],
  "network" : "GR5-HMO DEDUCTIBLE"
};

r4:Reference coveragePayorReference = {
    reference : "Organization/Payer2",
    display : "UPMC Health Plan"
};