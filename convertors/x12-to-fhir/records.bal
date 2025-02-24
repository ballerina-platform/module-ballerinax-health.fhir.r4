import ballerina/edi;

public isolated function fromEdiString(string ediText) returns X12_005010X217_278A1|error {
    edi:EdiSchema ediSchema = check edi:getSchema(schemaJson);
    json dataJson = check edi:fromEdiString(ediText, ediSchema);
    return dataJson.cloneWithType();
}

public isolated function toEdiString(X12_005010X217_278A1 data) returns string|error {
    edi:EdiSchema ediSchema = check edi:getSchema(schemaJson);
    return edi:toEdiString(data, ediSchema);
}

public isolated function getSchema() returns edi:EdiSchema|error {
    return edi:getSchema(schemaJson);
}

public isolated function fromEdiStringWithSchema(string ediText, edi:EdiSchema schema) returns X12_005010X217_278A1|error {
    json dataJson = check edi:fromEdiString(ediText, schema);
    return dataJson.cloneWithType();
}

public isolated function toEdiStringWithSchema(X12_005010X217_278A1 data, edi:EdiSchema ediSchema) returns string|error {
    return edi:toEdiString(data, ediSchema);
}

public type TransactionSetHeader_Type record {|
    string code = "ST";
    string ST01__TransactionSetIdentifierCode;
    string ST02__TransactionSetControlNumber;
    string ST03__ImplementationGuideVersionName;
|};

public type BeginningOfHierarchicalTransaction_Type record {|
    string code = "BHT";
    string BHT01__HierarchicalStructureCode;
    string BHT02__TransactionSetPurposeCode;
    string BHT03__SubmitterTransactionIdentifier;
    string BHT04__TransactionSetCreationDate;
    string BHT05__TransactionSetCreationTime;
    string BHT06__TransactionTypeCode?;
|};

public type UtilizationManagementOrganizationUMOLevel_Type record {|
    string code = "HL";
    string HL01__HierarchicalIDNumber;
    string HL02?;
    string HL03__HierarchicalLevelCode;
    string HL04__HierarchicalChildCode;
|};

public type UtilizationManagementOrganizationUMOName_Type record {|
    string code = "NM1";
    string NM101__EntityIdentifierCode;
    string NM102__EntityTypeQualifier;
    string NM103__UtilizationManagementOrganizationUMOLastOrOrganizationName?;
    string NM104__UtilizationManagementOrganizationUMOFirstName?;
    string NM105__UtilizationManagementOrganizationUMOMiddleName?;
    string NM106?;
    string NM107__UtilizationManagementOrganizationUMONameSuffix?;
    string NM108__IdentificationCodeQualifier;
    string NM109__UtilizationManagementOrganizationUMOIdentifier;
    string NM110?;
    string NM111?;
    string NM112?;
|};

public type Loop_2010A_GType record {|
    UtilizationManagementOrganizationUMOName_Type? UtilizationManagementOrganizationUMOName?;
|};

public type RequesterLevel_Type record {|
    string code = "HL";
    string HL01__HierarchicalIDNumber;
    string HL02__HierarchicalParentIDNumber;
    string HL03__HierarchicalLevelCode;
    string HL04__HierarchicalChildCode;
|};

public type RequesterName_Type record {|
    string code = "NM1";
    string NM101__EntityIdentifierCode;
    string NM102__EntityTypeQualifier;
    string NM103__RequesterLastOrOrganizationName?;
    string NM104__RequesterFirstName?;
    string NM105__RequesterMiddleName?;
    string NM106?;
    string NM107__RequesterNameSuffix?;
    string NM108__IdentificationCodeQualifier;
    string NM109__RequesterIdentifier;
    string NM110?;
    string NM111?;
    string NM112?;
|};

public type RequesterSupplementalIdentification_Type record {|
    string code = "REF";
    string REF01__ReferenceIdentificationQualifier;
    string REF02__RequesterSupplementalIdentifier;
    string REF03?;
    string REF04?;
|};

public type RequesterAddress_Type record {|
    string code = "N3";
    string N301__RequesterAddressLine;
    string N302__RequesterAddressLine?;
|};

public type RequesterCityStateZIPCode_Type record {|
    string code = "N4";
    string N401__RequesterCityName;
    string N402__RequesterStateOrProvinceCode?;
    string N403__RequesterPostalZoneOrZIPCode?;
    string N404__CountryCode?;
    string N405?;
    string N406?;
    string N407__CountrySubdivisionCode?;
|};

public type RequesterContactInformation_Type record {|
    string code = "PER";
    string PER01__ContactFunctionCode;
    string PER02__RequesterContactName?;
    string PER03__CommunicationNumberQualifier?;
    string PER04__RequesterContactCommunicationNumber?;
    string PER05__CommunicationNumberQualifier?;
    string PER06__RequesterContactCommunicationNumber?;
    string PER07__CommunicationNumberQualifier?;
    string PER08__RequesterContactCommunicationNumber?;
    string PER09?;
|};

public type RequesterProviderInformation_Type record {|
    string code = "PRV";
    string PRV01__ProviderCode;
    string PRV02__ReferenceIdentificationQualifier?;
    string PRV03__ProviderTaxonomyCode?;
    string PRV04?;
    string PRV05?;
    string PRV06?;
|};

public type Loop_2010B_GType record {|
    RequesterName_Type? RequesterName?;
    RequesterSupplementalIdentification_Type? RequesterSupplementalIdentification?;
    RequesterAddress_Type RequesterAddress?;
    RequesterCityStateZIPCode_Type RequesterCityStateZIPCode?;
    RequesterContactInformation_Type RequesterContactInformation?;
    RequesterProviderInformation_Type? RequesterProviderInformation?;
|};

public type SubscriberLevel_Type record {|
    string code = "HL";
    string HL01__HierarchicalIDNumber;
    string HL02__HierarchicalParentIDNumber;
    string HL03__HierarchicalLevelCode;
    string HL04__HierarchicalChildCode;
|};

// NM1 - 2010C
public type SubscriberName_Type record {|
    string code = "NM1";
    string NM101__EntityIdentifierCode;
    string NM102__EntityTypeQualifier;
    string NM103__SubscriberLastName?;
    string NM104__SubscriberFirstName?;
    string NM105__SubscriberMiddleNameOrInitial?;
    string NM106__SubscriberNamePrefix?;
    string NM107__SubscriberNameSuffix?;
    string NM108__IdentificationCodeQualifier;
    string NM109__SubscriberPrimaryIdentifier;
    string NM110?;
    string NM111?;
    string NM112?;
|};

public type SubscriberSupplementalIdentification_Type record {|
    string code = "REF";
    string REF01__ReferenceIdentificationQualifier;
    string REF02__SubscriberSupplementalIdentifier;
    string REF03?;
    string REF04?;
|};

public type SubscriberAddress_Type record {|
    string code = "N3";
    string N301__SubscriberAddressLine;
    string N302__SubscriberAddressLine?;
|};

public type SubscriberCityStateZIPCode_Type record {|
    string code = "N4";
    string N401__SubscriberCityName;
    string N402__SubscriberStateCode?;
    string N403__SubscriberPostalZoneOrZIPCode?;
    string N404__CountryCode?;
    string N405?;
    string N406?;
    string N407__CountrySubdivisionCode?;
|};

public type SubscriberDemographicInformation_Type record {|
    string code = "DMG";
    string DMG01__DateTimePeriodFormatQualifier;
    string DMG02__SubscriberBirthDate;
    string DMG03__SubscriberGenderCode?;
    string DMG04?;
    string DMG05?;
    string DMG06?;
    string DMG07?;
    string DMG08?;
    string DMG09?;
    string DMG10?;
    string DMG11?;
|};

public type SubscriberRelationship_Type record {|
    string code = "INS";
    string INS01__InsuredIndicator;
    string INS02__IndividualRelationshipCode;
    string INS03?;
    string INS04?;
    string INS05?;
    string INS06?;
    string INS07?;
    string INS08__EmploymentStatusCode;
    string INS09?;
    string INS10?;
    string INS11?;
    string INS12?;
    string INS13?;
    string INS14?;
    string INS15?;
    string INS16?;
    string INS17?;
|};

public type Loop_2010C_GType record {|
    SubscriberName_Type SubscriberName?;
    SubscriberSupplementalIdentification_Type SubscriberSupplementalIdentification?;
    SubscriberAddress_Type SubscriberAddress?;
    SubscriberCityStateZIPCode_Type SubscriberCityStateZIPCode?;
    SubscriberDemographicInformation_Type SubscriberDemographicInformation?;
    SubscriberRelationship_Type SubscriberRelationship?;
|};

public type DependentLevel_Type record {|
    string code = "HL";
    string HL01__HierarchicalIDNumber;
    string HL02__HierarchicalParentIDNumber;
    string HL03__HierarchicalLevelCode;
    string HL04__HierarchicalChildCode;
|};

public type DependentName_Type record {|
    string code = "NM1";
    string NM101__EntityIdentifierCode;
    string NM102__EntityTypeQualifier;
    string NM103__DependentLastName?;
    string NM104__DependentFirstName?;
    string NM105__DependentMiddleName?;
    string NM106?;
    string NM107__DependentNameSuffix?;
    string NM108?;
    string NM109?;
    string NM110?;
    string NM111?;
    string NM112?;
|};

public type DependentSupplementalIdentification_Type record {|
    string code = "REF";
    string REF01__ReferenceIdentificationQualifier;
    string REF02__DependentSupplementalIdentifier;
    string REF03?;
    string REF04?;
|};

public type DependentAddress_Type record {|
    string code = "N3";
    string N301__DependentAddressLine;
    string N302__DependentAddressLine?;
|};

public type DependentCityStateZIPCode_Type record {|
    string code = "N4";
    string N401__DependentCityName;
    string N402__DependentStateCode?;
    string N403__DependentPostalZoneOrZIPCode?;
    string N404__CountryCode?;
    string N405?;
    string N406?;
    string N407__CountrySubdivisionCode?;
|};

public type DependentDemographicInformation_Type record {|
    string code = "DMG";
    string DMG01__DateTimePeriodFormatQualifier;
    string DMG02__DependentBirthDate;
    string DMG03__DependentGenderCode?;
    string DMG04?;
    string DMG05?;
    string DMG06?;
    string DMG07?;
    string DMG08?;
    string DMG09?;
    string DMG10?;
    string DMG11?;
|};

public type DependentRelationship_Type record {|
    string code = "INS";
    string INS01__InsuredIndicator;
    string INS02__IndividualRelationshipCode;
    string INS03?;
    string INS04?;
    string INS05?;
    string INS06?;
    string INS07?;
    string INS08?;
    string INS09?;
    string INS10?;
    string INS11?;
    string INS12?;
    string INS13?;
    string INS14?;
    string INS15?;
    string INS16?;
    string INS17__BirthSequenceNumber?;
|};

public type Loop_2010D_GType record {|
    DependentName_Type DependentName?;
    DependentSupplementalIdentification_Type DependentSupplementalIdentification?;
    DependentAddress_Type DependentAddress?;
    DependentCityStateZIPCode_Type DependentCityStateZIPCode?;
    DependentDemographicInformation_Type DependentDemographicInformation?;
    DependentRelationship_Type DependentRelationship?;
|};

public type PatientEventLevel_Type record {|
    string code = "HL";
    string HL01__HierarchicalIDNumber;
    string HL02__HierarchicalParentIDNumber;
    string HL03__HierarchicalLevelCode;
    string HL04__HierarchicalChildCode;
|};

public type PatientEventTrackingNumber_Type record {|
    string code = "TRN";
    string TRN01__TraceTypeCode;
    string TRN02__PatientEventTraceNumber;
    string TRN03__TraceAssigningEntityIdentifier;
    string TRN04__TraceAssigningEntityAdditionalIdentifier?;
|};

public type UM04_HealthCareServiceLocationInformation_2000E_GType record {|
    string UM04_01_FacilityTypeCode;
    string UM04_02_FacilityCodeQualifier;
    string UM04_03?;
|};

public type UM05_RelatedCausesInformation_2000E_GType record {|
    string UM05_01_RelatedCausesCode;
    string UM05_02_RelatedCausesCode?;
    string UM05_03_RelatedCausesCode?;
    string UM05_04_StateOrProvinceCode?;
    string UM05_05_CountryCode?;
|};

public type HealthCareServicesReviewInformation_Type record {|
    string code = "UM";
    string UM01__RequestCategoryCode;
    string UM02__CertificationTypeCode;
    string UM03__ServiceTypeCode?;
    UM04_HealthCareServiceLocationInformation_2000E_GType? UM04_HealthCareServiceLocationInformation_2000E?;
    UM05_RelatedCausesInformation_2000E_GType? UM05_RelatedCausesInformation_2000E?;
    string UM06__LevelOfServiceCode?;
    string UM07__CurrentHealthConditionCode?;
    string UM08__PrognosisCode?;
    string UM09__ReleaseOfInformationCode?;
    string UM10__DelayReasonCode?;
|};

public type PreviousReviewAuthorizationNumber_Type record {|
    string code = "REF";
    string REF01__ReferenceIdentificationQualifier;
    string REF02__PreviousReviewAuthorizationNumber;
    string REF03?;
    string REF04?;
|};

public type PreviousReviewAdministrativeReferenceNumber_Type record {|
    string code = "REF";
    string REF01__ReferenceIdentificationQualifier;
    string REF02__PreviousAdministrativeReferenceNumber;
    string REF03?;
    string REF04?;
|};

public type AccidentDate_Type record {|
    string code = "DTP";
    string DTP01__DateTimeQualifier;
    string DTP02__DateTimePeriodFormatQualifier;
    string DTP03__AccidentDate;
|};

public type LastMenstrualPeriodDate_Type record {|
    string code = "DTP";
    string DTP01__DateTimeQualifier;
    string DTP02__DateTimePeriodFormatQualifier;
    string DTP03__LastMenstrualPeriodDate;
|};

public type EstimatedDateOfBirth_Type record {|
    string code = "DTP";
    string DTP01__DateTimeQualifier;
    string DTP02__DateTimePeriodFormatQualifier;
    string DTP03__EstimatedBirthDate;
|};

public type OnsetOfCurrentSymptomsOrIllnessDate_Type record {|
    string code = "DTP";
    string DTP01__DateTimeQualifier;
    string DTP02__DateTimePeriodFormatQualifier;
    string DTP03__OnsetDate;
|};

public type EventDate_Type record {|
    string code = "DTP";
    string DTP01__DateTimeQualifier;
    string DTP02__DateTimePeriodFormatQualifier;
    string DTP03__ProposedOrActualEventDate;
|};

public type AdmissionDate_Type record {|
    string code = "DTP";
    string DTP01__DateTimeQualifier;
    string DTP02__DateTimePeriodFormatQualifier;
    string DTP03__ProposedOrActualAdmissionDate;
|};

public type DischargeDate_Type record {|
    string code = "DTP";
    string DTP01__DateTimeQualifier;
    string DTP02__DateTimePeriodFormatQualifier;
    string DTP03__ProposedOrActualDischargeDate;
|};

public type HI01_HealthCareCodeInformation_2000E_GType record {|
    string HI01_01_DiagnosisTypeCode;
    string HI01_02_DiagnosisCode;
    string HI01_03_DateTimePeriodFormatQualifier?;
    string HI01_04_DiagnosisDate?;
    string HI01_05?;
    string HI01_06?;
    string HI01_07?;
    string HI01_08?;
    string HI01_09?;
|};

public type HI02_HealthCareCodeInformation_2000E_GType record {|
    string HI02_01_DiagnosisTypeCode;
    string HI02_02_DiagnosisCode;
    string HI02_03_DateTimePeriodFormatQualifier?;
    string HI02_04_DiagnosisDate?;
    string HI02_05?;
    string HI02_06?;
    string HI02_07?;
    string HI02_08?;
    string HI02_09?;
|};

public type HI03_HealthCareCodeInformation_2000E_GType record {|
    string HI03_01_DiagnosisTypeCode;
    string HI03_02_DiagnosisCode;
    string HI03_03_DateTimePeriodFormatQualifier?;
    string HI03_04_DiagnosisDate?;
    string HI03_05?;
    string HI03_06?;
    string HI03_07?;
    string HI03_08?;
    string HI03_09?;
|};

public type HI04_HealthCareCodeInformation_2000E_GType record {|
    string HI04_01_DiagnosisTypeCode;
    string HI04_02_DiagnosisCode;
    string HI04_03_DateTimePeriodFormatQualifier?;
    string HI04_04_DiagnosisDate?;
    string HI04_05?;
    string HI04_06?;
    string HI04_07?;
    string HI04_08?;
    string HI04_09?;
|};

public type HI05_HealthCareCodeInformation_2000E_GType record {|
    string HI05_01_DiagnosisTypeCode;
    string HI05_02_DiagnosisCode;
    string HI05_03_DateTimePeriodFormatQualifier?;
    string HI05_04_DiagnosisDate?;
    string HI05_05?;
    string HI05_06?;
    string HI05_07?;
    string HI05_08?;
    string HI05_09?;
|};

public type HI06_HealthCareCodeInformation_2000E_GType record {|
    string HI06_01_DiagnosisTypeCode;
    string HI06_02_DiagnosisCode;
    string HI06_03_DateTimePeriodFormatQualifier?;
    string HI06_04_DiagnosisDate?;
    string HI06_05?;
    string HI06_06?;
    string HI06_07?;
    string HI06_08?;
    string HI06_09?;
|};

public type HI07_HealthCareCodeInformation_2000E_GType record {|
    string HI07_01_DiagnosisTypeCode;
    string HI07_02_DiagnosisCode;
    string HI07_03_DateTimePeriodFormatQualifier?;
    string HI07_04_DiagnosisDate?;
    string HI07_05?;
    string HI07_06?;
    string HI07_07?;
    string HI07_08?;
    string HI07_09?;
|};

public type HI08_HealthCareCodeInformation_2000E_GType record {|
    string HI08_01_DiagnosisTypeCode;
    string HI08_02_DiagnosisCode;
    string HI08_03_DateTimePeriodFormatQualifier?;
    string HI08_04_DiagnosisDate?;
    string HI08_05?;
    string HI08_06?;
    string HI08_07?;
    string HI08_08?;
    string HI08_09?;
|};

public type HI09_HealthCareCodeInformation_2000E_GType record {|
    string HI09_01_DiagnosisTypeCode;
    string HI09_02_DiagnosisCode;
    string HI09_03_DateTimePeriodFormatQualifier?;
    string HI09_04_DiagnosisDate?;
    string HI09_05?;
    string HI09_06?;
    string HI09_07?;
    string HI09_08?;
    string HI09_09?;
|};

public type HI10_HealthCareCodeInformation_2000E_GType record {|
    string HI10_01_DiagnosisTypeCode;
    string HI10_02_DiagnosisCode;
    string HI10_03_DateTimePeriodFormatQualifier?;
    string HI10_04_DiagnosisDate?;
    string HI10_05?;
    string HI10_06?;
    string HI10_07?;
    string HI10_08?;
    string HI10_09?;
|};

public type HI11_HealthCareCodeInformation_2000E_GType record {|
    string HI11_01_DiagnosisTypeCode;
    string HI11_02_DiagnosisCode;
    string HI11_03_DateTimePeriodFormatQualifier?;
    string HI11_04_DiagnosisDate?;
    string HI11_05?;
    string HI11_06?;
    string HI11_07?;
    string HI11_08?;
    string HI11_09?;
|};

public type HI12_HealthCareCodeInformation_2000E_GType record {|
    string HI12_01_DiagnosisTypeCode;
    string HI12_02_DiagnosisCode;
    string HI12_03_DateTimePeriodFormatQualifier?;
    string HI12_04_DiagnosisDate?;
    string HI12_05?;
    string HI12_06?;
    string HI12_07?;
    string HI12_08?;
    string HI12_09?;
|};

public type PatientDiagnosis_Type record {|
    string code = "HI";
    HI01_HealthCareCodeInformation_2000E_GType HI01_HealthCareCodeInformation_2000E;
    HI02_HealthCareCodeInformation_2000E_GType? HI02_HealthCareCodeInformation_2000E?;
    HI03_HealthCareCodeInformation_2000E_GType? HI03_HealthCareCodeInformation_2000E?;
    HI04_HealthCareCodeInformation_2000E_GType? HI04_HealthCareCodeInformation_2000E?;
    HI05_HealthCareCodeInformation_2000E_GType? HI05_HealthCareCodeInformation_2000E?;
    HI06_HealthCareCodeInformation_2000E_GType? HI06_HealthCareCodeInformation_2000E?;
    HI07_HealthCareCodeInformation_2000E_GType? HI07_HealthCareCodeInformation_2000E?;
    HI08_HealthCareCodeInformation_2000E_GType? HI08_HealthCareCodeInformation_2000E?;
    HI09_HealthCareCodeInformation_2000E_GType? HI09_HealthCareCodeInformation_2000E?;
    HI10_HealthCareCodeInformation_2000E_GType? HI10_HealthCareCodeInformation_2000E?;
    HI11_HealthCareCodeInformation_2000E_GType? HI11_HealthCareCodeInformation_2000E?;
    HI12_HealthCareCodeInformation_2000E_GType? HI12_HealthCareCodeInformation_2000E?;
|};

public type HealthCareServicesDelivery_Type record {|
    string code = "HSD";
    string HSD01__QuantityQualifier?;
    string HSD02__ServiceUnitCount?;
    string HSD03__UnitOrBasisForMeasurementCode?;
    string HSD04__SampleSelectionModulus?;
    string HSD05__TimePeriodQualifier?;
    string HSD06__PeriodCount?;
    string HSD07__DeliveryFrequencyCode?;
    string HSD08__DeliveryPatternTimeCode?;
|};

public type AmbulanceCertificationInformation_Type record {|
    string code = "CRC";
    string CRC01__CodeCategory;
    string CRC02__CertificationConditionIndicator;
    string CRC03__ConditionCode;
    string CRC04__ConditionCode?;
    string CRC05__ConditionCode?;
    string CRC06__ConditionCode?;
    string CRC07__ConditionCode?;
|};

public type ChiropracticCertificationInformation_Type record {|
    string code = "CRC";
    string CRC01__CodeCategory;
    string CRC02__CertificationConditionIndicator;
    string CRC03__ConditionCode;
    string CRC04__ConditionCode?;
    string CRC05__ConditionCode?;
    string CRC06__ConditionCode?;
    string CRC07__ConditionCode?;
|};

public type DurableMedicalEquipmentInformation_Type record {|
    string code = "CRC";
    string CRC01__CodeCategory;
    string CRC02__CertificationConditionIndicator;
    string CRC03__ConditionCode;
    string CRC04__ConditionCode?;
    string CRC05__ConditionCode?;
    string CRC06__ConditionCode?;
    string CRC07__ConditionCode?;
|};

public type OxygenTherapyCertificationInformation_Type record {|
    string code = "CRC";
    string CRC01__CodeCategory;
    string CRC02__CertificationConditionIndicator;
    string CRC03__ConditionCode;
    string CRC04__ConditionCode?;
    string CRC05__ConditionCode?;
    string CRC06__ConditionCode?;
    string CRC07__ConditionCode?;
|};

public type FunctionalLimitationsInformation_Type record {|
    string code = "CRC";
    string CRC01__CodeCategory;
    string CRC02__CertificationConditionIndicator;
    string CRC03__ConditionCode;
    string CRC04__ConditionCode?;
    string CRC05__ConditionCode?;
    string CRC06__ConditionCode?;
    string CRC07__ConditionCode?;
|};

public type ActivitiesPermittedInformation_Type record {|
    string code = "CRC";
    string CRC01__CodeCategory;
    string CRC02__CertificationConditionIndicator;
    string CRC03__ConditionCode;
    string CRC04__ConditionCode?;
    string CRC05__ConditionCode?;
    string CRC06__ConditionCode?;
    string CRC07__ConditionCode?;
|};

public type MentalStatusInformation_Type record {|
    string code = "CRC";
    string CRC01__CodeCategory;
    string CRC02__CertificationConditionIndicator;
    string CRC03__ConditionCode;
    string CRC04__ConditionCode?;
    string CRC05__ConditionCode?;
    string CRC06__ConditionCode?;
    string CRC07__ConditionCode?;
|};

public type InstitutionalClaimCode_Type record {|
    string code = "CL1";
    string CL101__AdmissionTypeCode?;
    string CL102__AdmissionSourceCode?;
    string CL103__PatientStatusCode?;
    string CL104__NursingHomeResidentialStatusCode?;
|};

public type AmbulanceTransportInformation_Type record {|
    string code = "CR1";
    string CR101__UnitOrBasisForMeasurementCode?;
    string CR102__PatientWeight?;
    string CR103__AmbulanceTransportCode;
    string CR104__AmbulanceTransportReasonCode?;
    string CR105__UnitOrBasisForMeasurementCode?;
    string CR106__TransportDistance?;
    string CR107?;
    string CR108?;
    string CR109__RoundTripPurposeDescription?;
    string CR110__StretcherPurposeDescription?;
|};

public type SpinalManipulationServiceInformation_Type record {|
    string code = "CR2";
    string CR201__TreatmentSeriesNumber?;
    string CR202__TreatmentCount?;
    string CR203__SubluxationLevelCode?;
    string CR204__SubluxationLevelCode?;
    string CR205?;
    string CR206?;
    string CR207?;
    string CR208__PatientConditionCode;
    string CR209__ComplicationIndicator;
    string CR210__PatientConditionDescription?;
    string CR211__PatientConditionDescription?;
    string CR212__XrayAvailabilityIndicator?;
|};

public type HomeOxygenTherapyInformation_Type record {|
    string code = "CR5";
    string CR501?;
    string CR502?;
    string CR503__OxygenEquipmentTypeCode;
    string CR504__OxygenEquipmentTypeCode?;
    string CR505__EquipmentReasonDescription?;
    string CR506__OxygenFlowRate;
    string CR507__DailyOxygenUseCount?;
    string CR508__OxygenUsePeriodHourCount?;
    string CR509__RespiratoryTherapistOrderText?;
    string CR510__ArterialBloodGasQuantity?;
    string CR511__OxygenSaturationQuantity?;
    string CR512__OxygenTestConditionCode?;
    string CR513__OxygenTestFindingsCode?;
    string CR514__OxygenTestFindingsCode?;
    string CR515__OxygenTestFindingsCode?;
    string CR516__PortableOxygenSystemFlowRate?;
    string CR517__OxygenDeliverySystemCode;
    string CR518__OxygenEquipmentTypeCode?;
|};

public type HomeHealthCareInformation_Type record {|
    string code = "CR6";
    string CR601__PrognosisCode;
    string CR602__HomeHealthStartDate;
    string CR603__DateTimePeriodFormatQualifier?;
    string CR604__HomeHealthCertificationPeriod?;
    string CR605?;
    string CR606?;
    string CR607__MedicareCoverageIndicator;
    string CR608__CertificationTypeCode;
    string CR609__SurgeryDate?;
    string CR610__ProductOrServiceIDQualifier?;
    string CR611__SurgicalProcedureCode?;
    string CR612__PhysicianOrderDate?;
    string CR613__LastVisitDate?;
    string CR614__PhysicianContactDate?;
    string CR615__DateTimePeriodFormatQualifier?;
    string CR616__LastAdmissionPeriod?;
    string CR617__PatientLocationCode?;
    string CR618?;
    string CR619?;
    string CR620?;
    string CR621?;
|};

public type AdditionalPatientInformation_Type record {|
    string code = "PWK";
    string PWK01__AttachmentReportTypeCode;
    string PWK02__ReportTransmissionCode;
    string PWK03?;
    string PWK04?;
    string PWK05__IdentificationCodeQualifier?;
    string PWK06__AttachmentControlNumber?;
    string PWK07__AttachmentDescription?;
    string PWK08?;
    string PWK09?;
|};

public type MessageText_Type record {|
    string code = "MSG";
    string MSG01__FreeFormMessageText;
    string MSG02?;
    string MSG03?;
|};

public type PatientEventProviderName_Type record {|
    string code = "NM1";
    string NM101__EntityIdentifierCode;
    string NM102__EntityTypeQualifier;
    string NM103__PatientEventProviderLastOrOrganizationName?;
    string NM104__PatientEventProviderFirstName?;
    string NM105__PatientEventProviderMiddleName?;
    string NM106__PatientEventProviderNamePrefix?;
    string NM107__PatientEventProviderNameSuffix?;
    string NM108__IdentificationCodeQualifier?;
    string NM109__PatientEventProviderIdentifier?;
    string NM110?;
    string NM111?;
    string NM112?;
|};

public type PatientEventProviderSupplementalInformation_Type record {|
    string code = "REF";
    string REF01__ReferenceIdentificationQualifier;
    string REF02__PatientEventProviderSupplementalIdentifier;
    string REF03__LicenseNumberStateCode?;
    string REF04?;
|};

public type PatientEventProviderAddress_Type record {|
    string code = "N3";
    string N301__PatientEventProviderAddressLine;
    string N302__PatientEventProviderAddressLine?;
|};

public type PatientEventProviderCityStateZIPCode_Type record {|
    string code = "N4";
    string N401__PatientEventProviderCityName;
    string N402__PatientEventProviderStateCode?;
    string N403__PatientEventProviderPostalZoneOrZIPCode?;
    string N404__CountryCode?;
    string N405?;
    string N406?;
    string N407__CountrySubdivisionCode?;
|};

public type PatientEventProviderContactInformation_Type record {|
    string code = "PER";
    string PER01__ContactFunctionCode;
    string PER02__PatientEventProviderContactName?;
    string PER03__CommunicationNumberQualifier?;
    string PER04__PatientEventProviderContactCommunicationsNumber?;
    string PER05__CommunicationNumberQualifier?;
    string PER06__PatientEventProviderContactCommunicationsNumber?;
    string PER07__CommunicationNumberQualifier?;
    string PER08__PatientEventProviderContactCommunicationsNumber?;
    string PER09?;
|};

public type PatientEventProviderInformation_Type record {|
    string code = "PRV";
    string PRV01__ProviderCode;
    string PRV02__ReferenceIdentificationQualifier;
    string PRV03__ProviderTaxonomyCode;
    string PRV04?;
    string PRV05?;
    string PRV06?;
|};

public type Loop_2010EA_GType record {|
    PatientEventProviderName_Type? PatientEventProviderName?;
    PatientEventProviderSupplementalInformation_Type? PatientEventProviderSupplementalInformation?;
    PatientEventProviderAddress_Type? PatientEventProviderAddress?;
    PatientEventProviderCityStateZIPCode_Type? PatientEventProviderCityStateZIPCode?;
    PatientEventProviderContactInformation_Type? PatientEventProviderContactInformation?;
    PatientEventProviderInformation_Type? PatientEventProviderInformation?;
|};

public type PatientEventTransportInformation_Type record {|
    string code = "NM1";
    string NM101__EntityIdentifierCode;
    string NM102__EntityTypeQualifier;
    string NM103__PatientEventTransportLocationName?;
    string NM104?;
    string NM105?;
    string NM106?;
    string NM107?;
    string NM108?;
    string NM109?;
    string NM110?;
    string NM111?;
    string NM112?;
|};

public type PatientEventTransportLocationAddress_Type record {|
    string code = "N3";
    string N301__PatientEventTransportLocationAddressLine;
    string N302__PatientEventTransportLocationAddressLine?;
|};

public type PatientEventTransportLocationCityStateZIPCode_Type record {|
    string code = "N4";
    string N401__PatientEventTransportLocationCityName?;
    string N402__PatientEventTransportLocationStateOrProvinceCode?;
    string N403__PatientEventTransportLocationPostalZoneOrZIPCode?;
    string N404?;
    string N405?;
    string N406?;
    string N407?;
|};

public type Loop_2010EB_GType record {|
    PatientEventTransportInformation_Type? PatientEventTransportInformation?;
    PatientEventTransportLocationAddress_Type? PatientEventTransportLocationAddress?;
    PatientEventTransportLocationCityStateZIPCode_Type? PatientEventTransportLocationCityStateZIPCode?;
|};

public type PatientEventOtherUMOName_Type record {|
    string code = "NM1";
    string NM101__EntityIdentifierCode;
    string NM102__EntityTypeQualifier;
    string NM103__OtherUMOName?;
    string NM104?;
    string NM105?;
    string NM106?;
    string NM107?;
    string NM108?;
    string NM109?;
    string NM110?;
    string NM111?;
    string NM112?;
|};

public type REF04_ReferenceIdentifier_2010EC_GType record {|
    string REF04_01_ReferenceIdentificationQualifier;
    string REF04_02_OtherUMODenialReason;
    string REF04_03_ReferenceIdentificationQualifier?;
    string REF04_04_OtherUMODenialReason?;
    string REF04_05_ReferenceIdentificationQualifier?;
    string REF04_06_ReferenceIdentification?;
|};

public type OtherUMODenialReason_Type record {|
    string code = "REF";
    string REF01__ReferenceIdentificationQualifier;
    string REF02__OtherUMODenialReason;
    string REF03?;
    REF04_ReferenceIdentifier_2010EC_GType? REF04_ReferenceIdentifier_2010EC?;
|};

public type OtherUMODenialDate_Type record {|
    string code = "DTP";
    string DTP01__DateTimeQualifier;
    string DTP02__DateTimePeriodFormatQualifier;
    string DTP03__OtherUMODenialDate;
|};

public type Loop_2010EC_GType record {|
    PatientEventOtherUMOName_Type? PatientEventOtherUMOName?;
    OtherUMODenialReason_Type? OtherUMODenialReason?;
    OtherUMODenialDate_Type? OtherUMODenialDate?;
|};

public type ServiceLevel_Type record {|
    string code = "HL";
    string HL01__HierarchicalIDNumber;
    string HL02__HierarchicalParentIDNumber;
    string HL03__HierarchicalLevelCode;
    string HL04__HierarchicalChildCode;
|};

public type ServiceTraceNumber_Type record {|
    string code = "TRN";
    string TRN01__TraceTypeCode;
    string TRN02__ServiceTraceNumber;
    string TRN03__TraceAssigningEntityIdentifier;
    string TRN04__TraceAssigningEntityAdditionalIdentifier?;
|};

public type ServiceDate_Type record {|
    string code = "DTP";
    string DTP01__DateTimeQualifier;
    string DTP02__DateTimePeriodFormatQualifier;
    string DTP03__ProposedOrActualServiceDate;
|};

public type SV101_CompositeMedicalProcedureIdentifier_2000F_GType record {|
    string SV101_01_ProductOrServiceIDQualifier;
    string SV101_02_ProcedureCode;
    string SV101_03_ProcedureModifier?;
    string SV101_04_ProcedureModifier?;
    string SV101_05_ProcedureModifier?;
    string SV101_06_ProcedureModifier?;
    string SV101_07_ProcedureCodeDescription?;
    string SV101_08_ProcedureCode?;
|};

public type SV107_CompositeDiagnosisCodePointer_2000F_GType record {|
    string SV107_01_DiagnosisCodePointer;
    string SV107_02_DiagnosisCodePointer?;
    string SV107_03_DiagnosisCodePointer?;
    string SV107_04_DiagnosisCodePointer?;
|};

public type ProfessionalService_Type record {|
    string code = "SV1";
    SV101_CompositeMedicalProcedureIdentifier_2000F_GType SV101_CompositeMedicalProcedureIdentifier_2000F;
    string SV102__ServiceLineAmount?;
    string SV103__UnitOrBasisForMeasurementCode?;
    string SV104__ServiceUnitCount?;
    string SV105?;
    string SV106?;
    SV107_CompositeDiagnosisCodePointer_2000F_GType? SV107_CompositeDiagnosisCodePointer_2000F?;
    string SV108?;
    string SV109?;
    string SV110?;
    string SV111__EPSDTIndicator?;
    string SV112?;
    string SV113?;
    string SV114?;
    string SV115?;
    string SV116?;
    string SV117?;
    string SV118?;
    string SV119?;
    string SV120__NursingHomeLevelOfCare?;
    string SV121?;
|};

public type SV202_CompositeMedicalProcedureIdentifier_2000F_GType record {|
    string SV202_01_ProductOrServiceIDQualifier;
    string SV202_02_ProcedureCode;
    string SV202_03_ProcedureModifier?;
    string SV202_04_ProcedureModifier?;
    string SV202_05_ProcedureModifier?;
    string SV202_06_ProcedureModifier?;
    string SV202_07_ProcedureCodeDescription?;
    string SV202_08_ProcedureCode?;
|};

public type InstitutionalServiceLine_Type record {|
    string code = "SV2";
    string SV201__ServiceLineRevenueCode?;
    SV202_CompositeMedicalProcedureIdentifier_2000F_GType? SV202_CompositeMedicalProcedureIdentifier_2000F?;
    string SV203__ServiceLineAmount?;
    string SV204__UnitOrBasisForMeasurementCode?;
    string SV205__ServiceUnitCount?;
    string SV206__ServiceLineRate?;
    string SV207?;
    string SV208?;
    string SV209__NursingHomeResidentialStatusCode?;
    string SV210__NursingHomeLevelOfCare?;
|};

public type SV301_CompositeMedicalProcedureIdentifier_2000F_GType record {|
    string SV301_01_ProductOrServiceIDQualifier;
    string SV301_02_ProcedureCode;
    string SV301_03_ProcedureModifier?;
    string SV301_04_ProcedureModifier?;
    string SV301_05_ProcedureModifier?;
    string SV301_06_ProcedureModifier?;
    string SV301_07_ProcedureCodeDescription?;
    string SV301_08_ProcedureCode?;
|};

public type SV304_OralCavityDesignation_2000F_GType record {|
    string SV304_01_OralCavityDesignationCode;
    string SV304_02_OralCavityDesignationCode?;
    string SV304_03_OralCavityDesignationCode?;
    string SV304_04_OralCavityDesignationCode?;
    string SV304_05_OralCavityDesignationCode?;
|};

public type DentalService_Type record {|
    string code = "SV3";
    SV301_CompositeMedicalProcedureIdentifier_2000F_GType SV301_CompositeMedicalProcedureIdentifier_2000F;
    string SV302__ServiceLineAmount?;
    string SV303?;
    SV304_OralCavityDesignation_2000F_GType? SV304_OralCavityDesignation_2000F?;
    string SV305__ProsthesisCrownOrInlayCode?;
    string SV306__ServiceUnitCount;
    string SV307__Description?;
    string SV308?;
    string SV309?;
    string SV310?;
    string SV311?;
|};

public type TOO03_ToothSurface_2000F_GType record {|
    string TOO03_01_ToothSurfaceCode;
    string TOO03_02_ToothSurfaceCode?;
    string TOO03_03_ToothSurfaceCode?;
    string TOO03_04_ToothSurfaceCode?;
    string TOO03_05_ToothSurfaceCode?;
|};

public type ToothInformation_Type record {|
    string code = "TOO";
    string TOO01__CodeListQualifierCode;
    string TOO02__ToothCode;
    TOO03_ToothSurface_2000F_GType? TOO03_ToothSurface_2000F?;
|};

public type AdditionalServiceInformation_Type record {|
    string code = "PWK";
    string PWK01__AttachmentReportTypeCode;
    string PWK02__ReportTransmissionCode;
    string PWK03?;
    string PWK04?;
    string PWK05__IdentificationCodeQualifier?;
    string PWK06__AttachmentControlNumber?;
    string PWK07__AttachmentDescription?;
    string PWK08?;
    string PWK09?;
|};

public type ServiceProviderName_Type record {|
    string code = "NM1";
    string NM101__EntityIdentifierCode;
    string NM102__EntityTypeQualifier;
    string NM103__ServiceProviderLastOrOrganizationName?;
    string NM104__ServiceProviderFirstName?;
    string NM105__ServiceProviderMiddleName?;
    string NM106__ServiceProviderNamePrefix?;
    string NM107__ServiceProviderNameSuffix?;
    string NM108__IdentificationCodeQualifier?;
    string NM109__ServiceProviderIdentifier?;
    string NM110?;
    string NM111?;
    string NM112?;
|};

public type ServiceProviderSupplementalIdentification_Type record {|
    string code = "REF";
    string REF01__ReferenceIdentificationQualifier;
    string REF02__ServiceProviderSupplementalIdentifier;
    string REF03__LicenseNumberStateCode?;
    string REF04?;
|};

public type ServiceProviderAddress_Type record {|
    string code = "N3";
    string N301__ServiceProviderAddressLine;
    string N302__ServiceProviderAddressLine?;
|};

public type ServiceProviderCityStateZIPCode_Type record {|
    string code = "N4";
    string N401__ServiceProviderCityName;
    string N402__ServiceProviderStateOrProvinceCode?;
    string N403__ServiceProviderPostalZoneOrZIPCode?;
    string N404__CountryCode?;
    string N405?;
    string N406?;
    string N407__CountrySubdivisionCode?;
|};

public type ServiceProviderContactInformation_Type record {|
    string code = "PER";
    string PER01__ContactFunctionCode;
    string PER02__ServiceProviderContactName?;
    string PER03__CommunicationNumberQualifier?;
    string PER04__ServiceProviderContactCommunicationNumber?;
    string PER05__CommunicationNumberQualifier?;
    string PER06__ServiceProviderContactCommunicationNumber?;
    string PER07__CommunicationNumberQualifier?;
    string PER08__ServiceProviderContactCommunicationNumber?;
    string PER09?;
|};

public type ServiceProviderInformation_Type record {|
    string code = "PRV";
    string PRV01__ProviderCode;
    string PRV02__ReferenceIdentificationQualifier;
    string PRV03__ProviderTaxonomyCode;
    string PRV04?;
    string PRV05?;
    string PRV06?;
|};

public type Loop_2010F_GType record {|
    ServiceProviderName_Type? ServiceProviderName?;
    ServiceProviderSupplementalIdentification_Type? ServiceProviderSupplementalIdentification?;
    ServiceProviderAddress_Type? ServiceProviderAddress?;
    ServiceProviderCityStateZIPCode_Type? ServiceProviderCityStateZIPCode?;
    ServiceProviderContactInformation_Type? ServiceProviderContactInformation?;
    ServiceProviderInformation_Type? ServiceProviderInformation?;
|};

public type Loop_2000F_GType record {|
    ServiceLevel_Type? ServiceLevel?;
    ServiceTraceNumber_Type? ServiceTraceNumber?;
    HealthCareServicesReviewInformation_Type? HealthCareServicesReviewInformation?;
    PreviousReviewAuthorizationNumber_Type? PreviousReviewAuthorizationNumber?;
    PreviousReviewAdministrativeReferenceNumber_Type? PreviousReviewAdministrativeReferenceNumber?;
    ServiceDate_Type? ServiceDate?;
    ProfessionalService_Type? ProfessionalService?;
    InstitutionalServiceLine_Type? InstitutionalServiceLine?;
    DentalService_Type? DentalService?;
    ToothInformation_Type? ToothInformation?;
    HealthCareServicesDelivery_Type? HealthCareServicesDelivery?;
    AdditionalServiceInformation_Type? AdditionalServiceInformation?;
    MessageText_Type? MessageText?;
    Loop_2010F_GType? Loop_2010F?;
|};

public type Loop_2000E_GType record {|
    PatientEventLevel_Type? PatientEventLevel?;
    PatientEventTrackingNumber_Type? PatientEventTrackingNumber?;
    HealthCareServicesReviewInformation_Type? HealthCareServicesReviewInformation?;
    PreviousReviewAuthorizationNumber_Type? PreviousReviewAuthorizationNumber?;
    PreviousReviewAdministrativeReferenceNumber_Type? PreviousReviewAdministrativeReferenceNumber?;
    AccidentDate_Type? AccidentDate?;
    LastMenstrualPeriodDate_Type? LastMenstrualPeriodDate?;
    EstimatedDateOfBirth_Type? EstimatedDateOfBirth?;
    OnsetOfCurrentSymptomsOrIllnessDate_Type? OnsetOfCurrentSymptomsOrIllnessDate?;
    EventDate_Type? EventDate?;
    AdmissionDate_Type? AdmissionDate?;
    DischargeDate_Type? DischargeDate?;
    PatientDiagnosis_Type? PatientDiagnosis?;
    HealthCareServicesDelivery_Type? HealthCareServicesDelivery?;
    AmbulanceCertificationInformation_Type? AmbulanceCertificationInformation?;
    ChiropracticCertificationInformation_Type? ChiropracticCertificationInformation?;
    DurableMedicalEquipmentInformation_Type? DurableMedicalEquipmentInformation?;
    OxygenTherapyCertificationInformation_Type? OxygenTherapyCertificationInformation?;
    FunctionalLimitationsInformation_Type? FunctionalLimitationsInformation?;
    ActivitiesPermittedInformation_Type? ActivitiesPermittedInformation?;
    MentalStatusInformation_Type? MentalStatusInformation?;
    InstitutionalClaimCode_Type? InstitutionalClaimCode?;
    AmbulanceTransportInformation_Type? AmbulanceTransportInformation?;
    SpinalManipulationServiceInformation_Type? SpinalManipulationServiceInformation?;
    HomeOxygenTherapyInformation_Type? HomeOxygenTherapyInformation?;
    HomeHealthCareInformation_Type? HomeHealthCareInformation?;
    AdditionalPatientInformation_Type? AdditionalPatientInformation?;
    MessageText_Type? MessageText?;
    Loop_2010EA_GType? Loop_2010EA?;
    Loop_2010EB_GType? Loop_2010EB?;
    Loop_2010EC_GType? Loop_2010EC?;
    Loop_2000F_GType? Loop_2000F?;
|};

public type Loop_2000D_GType record {|
    DependentLevel_Type? DependentLevel?;
    Loop_2010D_GType? Loop_2010D?;
    Loop_2000E_GType? Loop_2000E?;
|};

public type Loop_2010EA2_GType record {|
    PatientEventProviderName_Type PatientEventProviderName?;
    PatientEventProviderSupplementalInformation_Type PatientEventProviderSupplementalInformation?;
    PatientEventProviderAddress_Type PatientEventProviderAddress?;
    PatientEventProviderCityStateZIPCode_Type PatientEventProviderCityStateZIPCode?;
    PatientEventProviderContactInformation_Type PatientEventProviderContactInformation?;
    PatientEventProviderInformation_Type PatientEventProviderInformation?;
|};

public type Loop_2010EB2_GType record {|
    PatientEventTransportInformation_Type? PatientEventTransportInformation?;
    PatientEventTransportLocationAddress_Type? PatientEventTransportLocationAddress?;
    PatientEventTransportLocationCityStateZIPCode_Type? PatientEventTransportLocationCityStateZIPCode?;
|};

public type Loop_2010EC2_GType record {|
    PatientEventOtherUMOName_Type? PatientEventOtherUMOName?;
    OtherUMODenialReason_Type? OtherUMODenialReason?;
    OtherUMODenialDate_Type? OtherUMODenialDate?;
|};

public type Loop_2010F2_GType record {|
    ServiceProviderName_Type? ServiceProviderName?;
    ServiceProviderSupplementalIdentification_Type? ServiceProviderSupplementalIdentification?;
    ServiceProviderAddress_Type? ServiceProviderAddress?;
    ServiceProviderCityStateZIPCode_Type? ServiceProviderCityStateZIPCode?;
    ServiceProviderContactInformation_Type? ServiceProviderContactInformation?;
    ServiceProviderInformation_Type? ServiceProviderInformation?;
|};

public type Loop_2000F2_GType record {|
    ServiceLevel_Type? ServiceLevel?;
    ServiceTraceNumber_Type? ServiceTraceNumber?;
    HealthCareServicesReviewInformation_Type? HealthCareServicesReviewInformation?;
    PreviousReviewAuthorizationNumber_Type? PreviousReviewAuthorizationNumber?;
    PreviousReviewAdministrativeReferenceNumber_Type? PreviousReviewAdministrativeReferenceNumber?;
    ServiceDate_Type? ServiceDate?;
    ProfessionalService_Type? ProfessionalService?;
    InstitutionalServiceLine_Type? InstitutionalServiceLine?;
    DentalService_Type? DentalService?;
    ToothInformation_Type? ToothInformation?;
    HealthCareServicesDelivery_Type? HealthCareServicesDelivery?;
    AdditionalServiceInformation_Type? AdditionalServiceInformation?;
    MessageText_Type? MessageText?;
    Loop_2010F2_GType? Loop_2010F?;
|};

public type Loop_2000E2_GType record {|
    PatientEventLevel_Type? PatientEventLevel?;
    PatientEventTrackingNumber_Type PatientEventTrackingNumber?;
    HealthCareServicesReviewInformation_Type HealthCareServicesReviewInformation?;
    PreviousReviewAuthorizationNumber_Type? PreviousReviewAuthorizationNumber?;
    PreviousReviewAdministrativeReferenceNumber_Type? PreviousReviewAdministrativeReferenceNumber?;
    AccidentDate_Type AccidentDate?;
    LastMenstrualPeriodDate_Type? LastMenstrualPeriodDate?;
    EstimatedDateOfBirth_Type? EstimatedDateOfBirth?;
    OnsetOfCurrentSymptomsOrIllnessDate_Type? OnsetOfCurrentSymptomsOrIllnessDate?;
    EventDate_Type EventDate?;
    AdmissionDate_Type AdmissionDate?;
    DischargeDate_Type DischargeDate?;
    PatientDiagnosis_Type PatientDiagnosis?;
    HealthCareServicesDelivery_Type? HealthCareServicesDelivery?;
    AmbulanceCertificationInformation_Type? AmbulanceCertificationInformation?;
    ChiropracticCertificationInformation_Type? ChiropracticCertificationInformation?;
    DurableMedicalEquipmentInformation_Type? DurableMedicalEquipmentInformation?;
    OxygenTherapyCertificationInformation_Type? OxygenTherapyCertificationInformation?;
    FunctionalLimitationsInformation_Type? FunctionalLimitationsInformation?;
    ActivitiesPermittedInformation_Type? ActivitiesPermittedInformation?;
    MentalStatusInformation_Type? MentalStatusInformation?;
    InstitutionalClaimCode_Type InstitutionalClaimCode?;
    AmbulanceTransportInformation_Type? AmbulanceTransportInformation?;
    SpinalManipulationServiceInformation_Type? SpinalManipulationServiceInformation?;
    HomeOxygenTherapyInformation_Type? HomeOxygenTherapyInformation?;
    HomeHealthCareInformation_Type? HomeHealthCareInformation?;
    AdditionalPatientInformation_Type? AdditionalPatientInformation?;
    MessageText_Type MessageText?;
    Loop_2010EA2_GType? Loop_2010EA?;
    Loop_2010EB2_GType? Loop_2010EB?;
    Loop_2010EC2_GType? Loop_2010EC?;
    Loop_2000F2_GType? Loop_2000F?;
|};

public type Loop_2000C_GType record {|
    SubscriberLevel_Type? SubscriberLevel?;
    Loop_2010C_GType? Loop_2010C?;
    Loop_2000D_GType? Loop_2000D?;
    Loop_2000E2_GType? Loop_2000E?;
|};

public type Loop_2000B_GType record {|
    RequesterLevel_Type? RequesterLevel?;
    Loop_2010B_GType? Loop_2010B?;
    Loop_2000C_GType? Loop_2000C?;
|};

public type Loop_2000A_GType record {|
    UtilizationManagementOrganizationUMOLevel_Type? UtilizationManagementOrganizationUMOLevel?;
    Loop_2010A_GType? Loop_2010A?;
    Loop_2000B_GType? Loop_2000B?;
|};

public type TransactionSetTrailer_Type record {|
    string code = "SE";
    string SE01__TransactionSegmentCount;
    string SE02__TransactionSetControlNumber;
|};

public type X12_005010X217_278A1 record {|
    TransactionSetHeader_Type? TransactionSetHeader?;
    BeginningOfHierarchicalTransaction_Type? BeginningOfHierarchicalTransaction?;
    Loop_2000A_GType? Loop_2000A?;
    TransactionSetTrailer_Type? TransactionSetTrailer?;
|};
