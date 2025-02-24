import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.davincipas;
import ballerinax/health.fhir.r4.parser;

public function transform(r4:Bundle bundle) returns X12_005010X217_278A1|error {

    if bundle.entry is r4:BundleEntry[] {
        r4:BundleEntry[]? entries = bundle.entry;
        if entries is r4:BundleEntry[] {
            foreach var entry in entries {
                r4:BundleEntry? bundleEntry = entry;
                if bundleEntry is r4:BundleEntry {
                    if bundleEntry?.'resource is anydata {
                        r4:DomainResource resourceData = <r4:DomainResource>bundleEntry?.'resource;
                        if resourceData.resourceType == "Claim" {
                            davincipas:PASClaim|error claimFromBundle = trap <davincipas:PASClaim>resourceData;
                            if claimFromBundle is error {
                                return claimFromBundle;
                            } else {
                                davincipas:PASClaim|r4:FHIRParseError parse = check parser:parse(resourceData.toJson(), davincipas:PASClaim).ensureType();
                                if parse is error {
                                    return parse;
                                }
                                return claimTo278A1(parse, bundle);
                            }
                        }
                    }
                }
            }
        }
    }
    return error("Claim resource is not present in the provided bundle");
};

public function claimTo278A1(davincipas:PASClaim claim, r4:Bundle bundle) returns X12_005010X217_278A1|error => {

    TransactionSetHeader: {
        code: "ST",
        ST01__TransactionSetIdentifierCode: "278",
        ST02__TransactionSetControlNumber: "del", //Replace with correct value
        ST03__ImplementationGuideVersionName: "005010X217"
    },
    BeginningOfHierarchicalTransaction: {
        code: "BHT",
        BHT01__HierarchicalStructureCode: "0007",
        BHT02__TransactionSetPurposeCode: "13",
        BHT03__SubmitterTransactionIdentifier: getIdentifierValue(bundle.identifier),
        BHT04__TransactionSetCreationDate: getTimestamp(bundle.timestamp),
        BHT05__TransactionSetCreationTime: getTimestamp(bundle.timestamp)
    },
    Loop_2000A: {
        UtilizationManagementOrganizationUMOLevel: {
            HL01__HierarchicalIDNumber: "1",
            HL03__HierarchicalLevelCode: "20",
            HL04__HierarchicalChildCode: "1"
        },
        Loop_2010A: {
            UtilizationManagementOrganizationUMOName: check getUtilizationManagementOrganizationUMOName_Type(bundle, claim)
        },
        Loop_2000B: {
            RequesterLevel: {
                HL01__HierarchicalIDNumber: "2",
                HL02__HierarchicalParentIDNumber: "1",
                HL03__HierarchicalLevelCode: "21",
                HL04__HierarchicalChildCode: "1"
            },
            Loop_2010B: {
                RequesterName: check getRequesterName_Type(bundle, claim),
                RequesterAddress: check getRequesterAddress_Type(bundle, claim),
                RequesterCityStateZIPCode: check getRequesterCityStateZIPCode_Type(bundle, claim),
                RequesterContactInformation: check getRequesterContactInformation_Type(bundle, claim)
            },
            Loop_2000C: {
                SubscriberLevel: {
                    HL01__HierarchicalIDNumber: "3",
                    HL02__HierarchicalParentIDNumber: "2",
                    HL03__HierarchicalLevelCode: "22",
                    HL04__HierarchicalChildCode: "1"
                },
                Loop_2010C: {
                    SubscriberName: check getSubscriberName_Type(bundle, claim),
                    SubscriberSupplementalIdentification: check getSubscriberSupplementalIdentification_Type(bundle, claim),
                    SubscriberAddress: check getSubscriberAddress_Type(bundle, claim),
                    SubscriberCityStateZIPCode: check getSubscriberCityStateZIPCode_Type(bundle, claim),
                    SubscriberDemographicInformation: check getSubscriberDemographicInformation_Type(bundle, claim),
                    SubscriberRelationship: check getSubscriberRelationship_Type(bundle, claim)
                },
                Loop_2000D: loop_2000Dstatus(bundle, claim) ? check getLoop_2000D_GType(bundle, claim) : {},
                Loop_2000E: {
                    // HL - 2000E
                    PatientEventLevel: {
                        HL01__HierarchicalIDNumber: "del", //Replace with correct value, refer doc
                        HL02__HierarchicalParentIDNumber: "del", //Replace with correct value, refer doc
                        HL03__HierarchicalLevelCode: "EV",
                        HL04__HierarchicalChildCode: "1"
                    },
                    PatientEventTrackingNumber: getPatientEventLevel_Type(claim),
                    HealthCareServicesReviewInformation: check getHealthCareServicesReviewInformation_Type(claim),
                    //https://github.com/wso2-enterprise/open-healthcare/issues/1586
                    AccidentDate: getAccidentDate_Type(claim),
                    EventDate: getEventDate_Type(claim),
                    AdmissionDate: getAdmissionDate_Type(claim),
                    DischargeDate: getDischargeDate_Type(claim),
                    PatientDiagnosis: getPatientDiagnosis_Type(claim),
                    InstitutionalClaimCode: getInstitutionalClaimCode_Type(bundle, claim),
                    //TODO - PWK - 2000E     https://github.com/wso2-enterprise/internal-support-ballerina/issues/689  (Can use spread operator to place key balues here)
                    MessageText: getMessageText_Type(claim),
                    Loop_2010EA: {
                        PatientEventProviderName: getPatientEventProviderName_Type(bundle, claim),
                        PatientEventProviderSupplementalInformation: getPatientEventProviderSupplementalInformation_Type(bundle, claim),
                        PatientEventProviderAddress: getPatientEventProviderAddress_Type(bundle, claim),
                        PatientEventProviderCityStateZIPCode: getPatientEventProviderCityStateZIPCode_Type(bundle, claim),
                        PatientEventProviderContactInformation: getPatientEventProviderContactInformation_Type(bundle, claim),
                        PatientEventProviderInformation: getPatientEventProviderInformation_Type(bundle, claim)
                    },
                    //TODO - 2000F   https://github.com/wso2-enterprise/internal-support-ballerina/issues/689
                    //TODO - 2010F   https://github.com/wso2-enterprise/internal-support-ballerina/issues/689

                    // Loop_2010EB is not defined in the PAS Claim profile.
                    // Loop_2010EC is not defined in the PAS Claim profile.

                    Loop_2000F: {
                        ServiceLevel: getServiceLevel_Type(),
                        ServiceTraceNumber: getServiceTraceNumber_Type(claim),
                        HealthCareServicesReviewInformation: check getHealthCareServicesReviewInformation_Type(claim),
                        PreviousReviewAuthorizationNumber: getPreviousReviewAuthorizationNumber_Type(claim),
                        PreviousReviewAdministrativeReferenceNumber: getPreviousReviewAdministrativeReferenceNumber_Type(claim),
                        ServiceDate: getServiceDate_Type(claim),
                        ProfessionalService: getProfessionalService_Type(claim),
                        InstitutionalServiceLine: getInstitutionalServiceLine(claim),
                        HealthCareServicesDelivery: getHealthCareServicesDelivery(claim)

                    }
                }
            }
        }
    }
    // TransactionSetTrailer: {

    // }
};

public function getLoop_2000D_GType(r4:Bundle bundle, davincipas:PASClaim claim) returns Loop_2000D_GType|error => {

    //HL - 2000D
    DependentLevel: {
        HL01__HierarchicalIDNumber: "del", //Replace with correct value
        HL02__HierarchicalParentIDNumber: "del", //Replace with correct value
        HL03__HierarchicalLevelCode: "23",
        HL04__HierarchicalChildCode: "1"
    },
    Loop_2010D: {
        DependentName: check getDependentName_Type(bundle, claim),
        DependentSupplementalIdentification: getDependentSupplementalIdentification_Type(bundle, claim),
        DependentAddress: getDependentAddress_Type(bundle, claim),
        DependentCityStateZIPCode: getDependentCityStateZIPCode_Type(bundle, claim),
        DependentDemographicInformation: getDependentDemographicInformation_Type(bundle, claim),
        DependentRelationship: getDependentRelationship_Type(bundle, claim)
    }

};
