// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
import ballerina/data.xmldata;

public type OrganizerComponent record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    boolean contextConductionInd?;
    INT sequenceNumber?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    INT priorityNumber?;
    BL seperatableInd?;
    Act act?;
    Encounter encounter?;
    Observation observation?;
    ObservationMedia observationMedia?;
    Organizer organizer?;
    Procedure procedure?;
    RegionOfInterest regionOfInterest?;
    SubstanceAdministration substanceAdministration?;
    Supply supply?;
|};

public type Informant record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    string contextControlCode?;
    AssignedEntity assignedEntity?;
    RelatedEntity relatedEntity?;
|};

public type INT_POS record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    int value?;
|};

public type OrganizationPartOf record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    Organization wholeOrganization?;
|};

public type PlayingEntity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    CE code?;
    PQ[] quantity?;
    PN[] name?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    TS birthTime?;
    ED desc?;
|};

public type PQ record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string unit?;
    @xmldata:Attribute
    decimal value?;
    @xmldata:Attribute
    string displayName?;
    @xmldata:Attribute
    string code?;
    @xmldata:Attribute
    string codeSystem?;
    PQR[] translation?;
    ED originalText?;
    string xmlText?;
|};

public type PreconditionBase record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    II id;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition?;
|};

public type AssociatedEntity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code?;
    AD[] addr?;
    TEL[] telecom?;
    Person associatedPerson?;
    Organization scopingOrganization?;
|};

public type CS record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string code?;
    @xmldata:Attribute
    string codeSystem?;
    @xmldata:Attribute
    string codeSystemName?;
    @xmldata:Attribute
    string codeSystemVersion?;
    @xmldata:Attribute
    string displayName?;
    @xmldata:Attribute
    string valueSet?;
    @xmldata:Attribute
    string valueSetVersion?;
    ED originalText?;
    CR qualifier?;
    CD translation?;
|};

public type NonXMLBody record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    ED text;
    CE confidentialityCode?;
    CS languageCode?;
|};

public type BL record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    boolean value?;
|};

public type InFulfillmentOf record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    Order 'order;
|};

public type ParticipantRole record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code?;
    AD[] addr?;
    TEL[] telecom?;
    Device playingDevice?;
    PlayingEntity playingEntity?;
    Entity scopingEntity?;
|};

public type Organizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id?;
    CD code?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    OrganizerComponent[] component?;
|};

public type EIVL_TS record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string value?;
    @xmldata:Attribute
    string operator?;
    CE event?;
    IVL_PQ offset?;
|};

public type Encounter record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id?;
    CD code?;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CE dischargeDispositionCode?;
    CE priorityCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

public type IVL_TS record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string value?;
    @xmldata:Attribute
    string operator?;
    IVXB_TS low?;
    TS center?;
    PQ width?;
    IVXB_TS high?;
|};

public type RelatedEntity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    CE code?;
    AD[] addr?;
    TEL[] telecom?;
    IVL_TS effectiveTime?;
    Person relatedPerson?;
|};

public type Participant1 record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode;
    @xmldata:Attribute
    string contextControlCode?;
    CE functionCode?;
    IVL_TS time?;
    AssociatedEntity associatedEntity;
|};

public type IntendedRecipient record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    AD[] addr?;
    TEL[] telecom?;
    Person informationRecipient?;
    Organization receivedOrganization?;
|};

public type PatientRole record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    AD[] addr?;
    TEL[] telecom?;
    Patient patient?;
    Organization providerOrganization?;
|};

public type SC record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string representation?;
    @xmldata:Attribute
    string mediaType?;
    @xmldata:Attribute
    string language?;
    string xmlText?;
    @xmldata:Attribute
    string code?;
    @xmldata:Attribute
    string codeSystem?;
    @xmldata:Attribute
    string codeSystemName?;
    @xmldata:Attribute
    string codeSystemVersion?;
    @xmldata:Attribute
    string displayName?;
|};

public type CR record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    boolean inverted?;
    CV name?;
    CD value?;
|};

public type Section record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code?;
    ST title?;
    record {} text?;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

public type Place record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    EN name?;
    AD addr?;
|};

public type II record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string assigningAuthorityName?;
    @xmldata:Attribute
    boolean displayable?;
    @xmldata:Attribute
    string root?;
    @xmldata:Attribute
    string extension?;
|};

public type Performer1 record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode;
    CE functionCode?;
    IVL_TS time?;
    AssignedEntity assignedEntity;
|};

public type Author record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    string contextControlCode?;
    CE functionCode?;
    TS time;
    AssignedAuthor assignedAuthor;
|};

public type Act record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

public type HealthCareFacility record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code?;
    Place location?;
    Organization serviceProviderOrganization?;
|};

public type Custodian record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    AssignedCustodian assignedCustodian;
|};

public type PN record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string use?;
    string[] item;
    ENXP[] delimiter?;
    ENXP[] family?;
    ENXP[] given?;
    ENXP[] prefix?;
    ENXP[] suffix?;
    string xmlText?;
    IVL_TS validTime?;
|};

public type Birthplace record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    Place place;
|};

public type Organization record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    II[] id?;
    ON[] name?;
    TEL[] telecom?;
    AD[] addr?;
    CE standardIndustryClassCode?;
    OrganizationPartOf asOrganizationPartOf?;
|};

public type MO record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string currency?;
    @xmldata:Attribute
    decimal value?;
|};

public type LanguageCommunication record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    CS languageCode?;
    CE modeCode?;
    CE proficiencyLevelCode?;
    BL preferenceInd?;
|};

public type AssignedAuthor record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code?;
    AD[] addr?;
    TEL[] telecom?;
    Person assignedPerson?;
    AuthoringDevice assignedAuthoringDevice?;
    Organization representedOrganization?;
|};

public type ADXP record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string representation?;
    @xmldata:Attribute
    string mediaType?;
    @xmldata:Attribute
    string language?;
    string xmlText?;
    @xmldata:Attribute
    string partType?;
|};

public type ObservationMedia record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id?;
    CS languageCode?;
    ED value;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
|};

public type ComponentOf record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    EncompassingEncounter encompassingEncounter;
|};

public type SpecimenRole record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    PlayingEntity specimenPlayingEntity?;
|};

public type RelatedDocument record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode;
    ParentDocument parentDocument;
|};

public type IVXB_PQ record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string unit?;
    @xmldata:Attribute
    decimal value?;
    PQR[] translation?;
    @xmldata:Attribute
    boolean inclusive?;
|};

public type Order record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II[] id;
    CE code?;
    CE priorityCode?;
|};

public type LegalAuthenticator record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    string contextControlCode?;
    TS time;
    CS signatureCode;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED signatureText?;
    AssignedEntity assignedEntity;
|};

public type LabeledDrug record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    CE code?;
    EN name?;
|};

public type ON record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string use?;
    string[] item?;
    ENXP[] delimiter?;
    ENXP family?;
    ENXP given?;
    ENXP[] prefix?;
    ENXP[] suffix?;
    string xmlText?;
    IVL_TS validTime?;
|};

public type ParentDocument record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II[] id;
    CD code?;
    ED text?;
    II setId?;
    INT versionNumber?;
|};

public type RecordTarget record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    string contextControlCode?;
    PatientRole patientRole;
|};

public type TN record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string use?;
    string[] item?;
    ENXP delimiter?;
    ENXP family?;
    ENXP given?;
    ENXP prefix?;
    ENXP suffix?;
    string xmlText?;
    IVL_TS validTime?;
|};

public type SubjectPerson record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    II[] id?;
    PN[] name?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED desc?;
    CE administrativeGenderCode?;
    TS birthTime?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    BL deceasedInd?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    TS deceasedTime?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    BL multipleBirthInd?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    INT_POS multipleBirthOrderNumber?;
|};

public type StructuredBody record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CE confidentialityCode?;
    CS languageCode?;
    InfrastructureRoot[] component;
|};

public type PQR record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string code?;
    @xmldata:Attribute
    string codeSystem?;
    @xmldata:Attribute
    string codeSystemName?;
    @xmldata:Attribute
    string codeSystemVersion?;
    @xmldata:Attribute
    string displayName?;
    @xmldata:Attribute
    string valueSet?;
    @xmldata:Attribute
    string valueSetVersion?;
    ED originalText?;
    CR qualifier?;
    CD translation?;
    @xmldata:Attribute
    decimal value?;
|};

public type RegionOfInterest record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CS code;
    INT[] value;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
|};

public type Patient record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    II id?;
    PN[] name?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED desc?;
    CE administrativeGenderCode?;
    TS birthTime?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    BL deceasedInd?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    TS deceasedTime?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    BL multipleBirthInd?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    INT_POS multipleBirthOrderNumber?;
    CE maritalStatusCode?;
    CE religiousAffiliationCode?;
    CE[] raceCode?;
    CE[] ethnicGroupCode?;
    Guardian[] guardian?;
    Birthplace birthplace?;
    LanguageCommunication[] languageCommunication?;
|};

public type RTO_PQ_PQ record {|
    @xmldata:Attribute
    string nullFlavor?;
    PQ numerator?;
    PQ denominator?;
|};

public type AlternateIdentification record {|
    @xmldata:Attribute
    string classCode;
    @xmldata:Namespace {uri: "urn:hl7-org:v3"}
    II id;
    @xmldata:Namespace {uri: "urn:hl7-org:v3"}
    CD code?;
    @xmldata:Namespace {uri: "urn:hl7-org:v3"}
    CS statusCode?;
    @xmldata:Namespace {uri: "urn:hl7-org:v3"}
    IVL_TS effectiveTime?;
|};

public type ClinicalDocument record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    II id;
    CE code;
    ST title?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode?;
    II setId?;
    INT versionNumber?;
    TS copyTime?;
    RecordTarget[] recordTarget;
    Author[] author;
    DataEnterer dataEnterer?;
    Informant[] informant?;
    Custodian custodian;
    InformationRecipient[] informationRecipient?;
    LegalAuthenticator legalAuthenticator?;
    Authenticator[] authenticator?;
    Participant1[] participant?;
    InFulfillmentOf[] inFulfillmentOf?;
    DocumentationOf[] documentationOf?;
    RelatedDocument[] relatedDocument?;
    Authorization[] authorization?;
    ComponentOf componentOf?;
    Component component;
|};

public type Specimen record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    SpecimenRole specimenRole;
|};

public type INT record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    int value?;
|};

public type SXCM_TS record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string value?;
    @xmldata:Attribute
    string operator?;
    IVXB_TS low?;
    IVXB_TS high?;
|};

public type Entry record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    boolean contextConductionInd?;
    Act act?;
    Encounter encounter?;
    Observation observation?;
    ObservationMedia observationMedia?;
    Organizer organizer?;
    Procedure procedure?;
    RegionOfInterest regionOfInterest?;
    SubstanceAdministration substanceAdministration?;
    Supply supply?;
|};

public type DocumentationOf record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    ServiceEvent serviceEvent;
|};

public type SubstanceAdministration record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id?;
    CD code?;
    @xmldata:Attribute
    boolean negationInd?;
    ED text?;
    CS statusCode?;
    SXCM_TS[] effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CE routeCode?;
    CD[] approachSiteCode?;
    IVL_PQ doseQuantity?;
    IVL_PQ rateQuantity?;
    RTO_PQ_PQ maxDoseQuantity?;
    CE administrationUnitCode?;
    InfrastructureRoot consumable;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

public type InfrastructureRoot record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    BL contextConductionInd?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    ManufacturedProduct manufacturedProduct?;
    Section section?;
    HealthCareFacility healthCareFacility?;
    AssignedEntity assignedEntity?;
|};

public type SXPR_TS record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string value?;
    @xmldata:Attribute
    string operator?;
    SXCM_TS[] comp;
|};

public type Criterion record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CD code?;
    ED text?;
    BL value?;
|};

public type ObservationRange record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CD code?;
    ED text?;
    BL value?;
    CE interpretationCode?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InfrastructureRoot[] precondition1?;
|};

public type ManufacturedProduct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    LabeledDrug manufacturedLabeledDrug?;
    Material manufacturedMaterial?;
    Organization manufacturerOrganization?;
|};

public type Entity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    II[] id?;
    CE code?;
    ED desc?;
|};

public type IVXB_TS record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string value?;
    @xmldata:Attribute
    boolean inclusive?;
|};

public type Precondition2 record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    boolean negationInd?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS conjunctionCode;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    PreconditionBase allTrue?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    PreconditionBase allFalse?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    PreconditionBase atLeastOneTrue?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    PreconditionBase atLeastOneFalse?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    PreconditionBase onlyOneTrue?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    PreconditionBase onlyOneFalse?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Criterion criterion?;
|};

public type EncompassingEncounter record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II[] id?;
    CE code?;
    IVL_TS effectiveTime;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CE admissionReferralSourceCode?;
    CE dischargeDispositionCode?;
    InfrastructureRoot responsibleParty?;
    EncounterParticipant[] encounterParticipant?;
    InfrastructureRoot location?;
|};

public type InFulfillmentOf1 record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode;
    @xmldata:Attribute
    boolean inversionInd?;
    @xmldata:Attribute
    boolean negationInd?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InfrastructureRoot actReference;
|};

public type Supply record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id?;
    CD code?;
    ED text?;
    CS statusCode?;
    SXCM_TS[] effectiveTime?;
    CE[] priorityCode?;
    IVL_INT repeatNumber?;
    BL independentInd?;
    PQ quantity?;
    IVL_TS expectedUseTime?;
    InfrastructureRoot product?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

public type EN record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string use?;
    string[] item?;
    ENXP[] delimiter?;
    ENXP[] family?;
    ENXP[] given?;
    ENXP[] prefix?;
    ENXP[] suffix?;
    string xmlText?;
    IVL_TS validTime?;
|};

public type IVXB_INT record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    int value?;
    @xmldata:Attribute
    boolean inclusive?;
|};

public type CV record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string code?;
    @xmldata:Attribute
    string codeSystem?;
    @xmldata:Attribute
    string codeSystemName?;
    @xmldata:Attribute
    string codeSystemVersion?;
    @xmldata:Attribute
    string displayName?;
    @xmldata:Attribute
    string valueSet?;
    @xmldata:Attribute
    string valueSetVersion?;
    ED originalText?;
    CR qualifier?;
    CD translation?;
|};

public type ExternalAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II[] id?;
    CD code?;
    ED text?;
|};

public type CO record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string code?;
    @xmldata:Attribute
    string codeSystem?;
    @xmldata:Attribute
    string codeSystemName?;
    @xmldata:Attribute
    string codeSystemVersion?;
    @xmldata:Attribute
    string displayName?;
    @xmldata:Attribute
    string valueSet?;
    @xmldata:Attribute
    string valueSetVersion?;
    ED originalText?;
    CR qualifier?;
    CD translation?;
|};

public type AssignedCustodian record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    CustodianOrganization representedCustodianOrganization;
|};

public type InformationRecipient record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    IntendedRecipient intendedRecipient;
|};

public type Subject record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    string contextControlCode?;
    CE awarenessCode?;
    RelatedSubject relatedSubject;
|};

public type Material record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    CE code?;
    EN name?;
    ST lotNumberText?;
|};

public type Guardian record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code?;
    AD[] addr?;
    TEL[] telecom?;
    Person guardianPerson?;
    Organization guardianOrganization?;
|};

public type EncounterParticipant record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode;
    IVL_TS time?;
    AssignedEntity assignedEntity?;
|};

public type DataEnterer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    string contextControlCode?;
    TS time?;
    AssignedEntity assignedEntity;
|};

public type ANY record {|
    @xmldata:Attribute
    string nullFlavor?;
|};

public type Authorization record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    Consent consent;
|};

public type Precondition record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    Criterion criterion;
|};

public type Reference record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode;
    BL seperatableInd?;
    ExternalAct externalAct?;
    ExternalObservation externalObservation?;
    ExternalProcedure externalProcedure?;
    ExternalDocument externalDocument?;
|};

public type ServiceEvent record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II[] id?;
    CE code?;
    IVL_TS effectiveTime?;
    Performer1[] performer?;
|};

public type Component record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    boolean contextConductionInd?;
    NonXMLBody nonXMLBody?;
    StructuredBody structuredBody?;
    Act act?;
|};

public type IdentifiedBy record {|
    @xmldata:Attribute
    string typeCode;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    AlternateIdentification alternateIdentification;
|};

public type ExternalObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II[] id?;
    CD code?;
    ED text?;
|};

public type ENXP record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string representation?;
    @xmldata:Attribute
    string mediaType?;
    @xmldata:Attribute
    string language?;
    string xmlText?;
    @xmldata:Attribute
    string partType?;
    @xmldata:Attribute
    string qualifier?;
|};

public type Performer2 record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CE functionCode?;
    IVL_TS time?;
    CE modeCode?;
    AssignedEntity assignedEntity;
|};

public type CD record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string code?;
    @xmldata:Attribute
    string codeSystem?;
    @xmldata:Attribute
    string codeSystemName?;
    @xmldata:Attribute
    string codeSystemVersion?;
    @xmldata:Attribute
    string displayName?;
    @xmldata:Attribute
    string valueSet?;
    @xmldata:Attribute
    string valueSetVersion?;
    ED originalText?;
    CR[] qualifier?;
    CD[] translation?;
|};

public type REAL record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    decimal value?;
|};

public type TEL record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string value?;
    IVL_TS[] useablePeriod?;
    @xmldata:Attribute
    string use?;
|};

public type AD record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    boolean isNotOrdered?;
    @xmldata:Attribute
    string use?;
    string[] item?;
    ADXP delimiter?;
    ADXP country?;
    ADXP state?;
    ADXP county?;
    ADXP city?;
    ADXP postalCode?;
    //TODO: need to cross check with the schema
    ADXP[] streetAddressLine?;
    ADXP houseNumber?;
    ADXP houseNumberNumeric?;
    ADXP direction?;
    ADXP streetName?;
    ADXP streetNameBase?;
    ADXP streetNameType?;
    ADXP additionalLocator?;
    ADXP unitID?;
    ADXP unitType?;
    ADXP careOf?;
    ADXP censusTract?;
    ADXP deliveryAddressLine?;
    ADXP deliveryInstallationType?;
    ADXP deliveryInstallationArea?;
    ADXP deliveryInstallationQualifier?;
    ADXP deliveryMode?;
    ADXP deliveryModeIdentifier?;
    ADXP buildingNumberSuffix?;
    ADXP postBox?;
    ADXP precinct?;
    string xmlText?;
    IVL_TS[] useablePeriod?;
|};

public type IVL_PQ record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string unit?;
    @xmldata:Attribute
    decimal value?;
    PQR[] translation?;
    @xmldata:Attribute
    string operator?;
    IVXB_PQ low?;
    PQ center?;
    PQ width?;
    IVXB_PQ high?;
|};

public type Participant2 record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode;
    @xmldata:Attribute
    string contextControlCode?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CE functionCode?;
    IVL_TS time?;
    CE awarenessCode?;
    ParticipantRole participantRole;
|};

public type ExternalProcedure record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II[] id?;
    CD code?;
    ED text?;
|};

public type Person record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    PN[] name?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED desc?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InfrastructureRoot[] asPatientRelationship?;
|};

public type RelatedSubject record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    II[] id?;
    CE code?;
    AD[] addr?;
    TEL[] telecom?;
    SubjectPerson subject?;
|};

public type MaintainedEntity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    IVL_TS effectiveTime?;
    Person maintainingPerson;
|};

public type PIVL_TS record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string value?;
    @xmldata:Attribute
    string operator?;
    IVL_TS phase?;
    PQ period?;
    @xmldata:Attribute
    string alignment?;
    @xmldata:Attribute
    boolean institutionSpecified?;
|};

public type ExternalDocument record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II[] id?;
    CD code?;
    ED text?;
    II setId?;
    INT versionNumber?;
|};

public type Device record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    CE code?;
    SC manufacturerModelName?;
    SC softwareName?;
|};

public type Consent record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II[] id?;
    CE code?;
    CS statusCode;
|};

public type ED record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string compression?;
    @xmldata:Attribute
    string integrityCheck?;
    @xmldata:Attribute
    string integrityCheckAlgorithm?;
    @xmldata:Attribute
    string language?;
    @xmldata:Attribute
    string mediaType?;
    @xmldata:Attribute
    string representation?;
    string xmlText?;
    TEL reference?;
    ED thumbnail?;
|};

public type IVL_INT record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    int value?;
    @xmldata:Attribute
    string operator?;
    IVXB_INT low?;
    INT center?;
    INT width?;
    IVXB_INT high?;
|};

public type AuthoringDevice record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    CE code?;
    SC manufacturerModelName?;
    SC softwareName?;
    MaintainedEntity[] asMaintainedEntity?;
|};

public type ST record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string representation?;
    @xmldata:Attribute
    string mediaType?;
    @xmldata:Attribute
    string language?;
    string xmlText?;
|};

public type TS record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string value?;
|};

public type CE record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string code?;
    @xmldata:Attribute
    string codeSystem?;
    @xmldata:Attribute
    string codeSystemName?;
    @xmldata:Attribute
    string codeSystemVersion?;
    @xmldata:Attribute
    string displayName?;
    @xmldata:Attribute
    string valueSet?;
    @xmldata:Attribute
    string valueSetVersion?;
    ED originalText?;
    CR qualifier?;
    CD[] translation?;
|};

public type QTY record {|
    @xmldata:Attribute
    string nullFlavor?;
|};

public type Observation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    PQ[] value?;
    CE[] interpretationCode?;
    CE[] methodCode?;
    CD[] targetSiteCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    InfrastructureRoot[] referenceRange?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

public type AssignedEntity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    II[] id;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code?;
    AD[] addr?;
    TEL[] telecom?;
    Person assignedPerson?;
    Organization representedOrganization?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    string patient?;
|};

public type Procedure record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id?;
    CD code?;
    @xmldata:Attribute
    boolean negationInd?;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    CE[] methodCode?;
    CD[] approachSiteCode?;
    CD[] targetSiteCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

public type Authenticator record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode?;
    TS time;
    CS signatureCode;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED signatureText?;
    AssignedEntity assignedEntity;
|};

public type EntryRelationship record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string typeCode;
    @xmldata:Attribute
    boolean inversionInd?;
    @xmldata:Attribute
    boolean contextConductionInd?;
    @xmldata:Attribute
    boolean negationInd?;
    INT sequenceNumber?;
    BL seperatableInd?;
    Act act?;
    Encounter encounter?;
    Observation observation?;
    ObservationMedia observationMedia?;
    Organizer organizer?;
    Procedure procedure?;
    RegionOfInterest regionOfInterest?;
    SubstanceAdministration substanceAdministration?;
    Supply supply?;
|};

public type CustodianOrganization record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string determinerCode?;
    II[] id;
    ON name?;
    TEL[] telecom?;
    AD addr?;
|};
