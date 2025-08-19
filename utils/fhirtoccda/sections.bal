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

public type ClincialDocument record {
    string clinicalDocType?;
};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type NoteActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AdvanceDirectiveOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
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
    OrganizerComponent[] component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type USRealmPersonNamePNUSFIELDED record {|
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type InstructionsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type UDIOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II id;
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
    OrganizerComponent[] component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ExpirationDateObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    TS value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DeviceIdentifierObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    II value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AnesthesiaSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type FamilyHistoryObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DischargeMedication record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type FunctionalStatusOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
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
    OrganizerComponent[] component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ComplicationsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AllergyStatusObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CE value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AdvanceDirectiveObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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
    Reference[] reference;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    InfrastructureRoot[] referenceRange?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type BrandNameObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    ED value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PreoperativeDiagnosisSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PlannedProcedure record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
    @xmldata:Attribute
    boolean negationInd?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    CE[] methodCode?;
    CD[] approachSiteCode?;
    CD[] targetSiteCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author author?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ManufacturingDateObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    TS value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProgressTowardGoalObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicationsAdministeredSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ActivitiesSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CriticalityObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SubstanceAdministeredAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type BirthSexObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PlannedCoverage record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicalEquipmentOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ResultsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CourseofCareSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HospitalCourseSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PriorityPreference record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PregnancyIntentionInNextYear record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SurgicalDrainsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SubjectiveSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AdvanceDirectivesSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type NutritionalStatusObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
    CE[] interpretationCode?;
    CE[] methodCode?;
    CD[] targetSiteCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    InfrastructureRoot[] referenceRange?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PrognosisObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type OperativeNoteFluidsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProceduresSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CarePlan record {|
    *ClincialDocument;
    string clinicalDocType = "CarePlan";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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
    DocumentationOf[] documentationOf;
    RelatedDocument[] relatedDocument?;
    Authorization[] authorization?;
    ComponentOf componentOf?;
    Component component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CareTeamOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
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
    OrganizerComponent[] component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type RiskConcernAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProblemConcernAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PatientReferralAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ImmunizationMedicationInformation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    LabeledDrug manufacturedLabeledDrug?;
    Material manufacturedMaterial;
    Organization manufacturerOrganization?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HospitalDischargePhysicalSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type USRealmHeader record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DistinctIdentificationCodeObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    ED value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CareTeamMemberScheduleObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ST derivationExpr?;
    ED text;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    IVL_TS value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SubstanceOrDeviceAllergyIntoleranceObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type GoalObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MentalStatusSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type LotOrBatchNumberObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    ED value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicationActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    @xmldata:Attribute
    boolean negationInd?;
    ED text?;
    CS statusCode;
    SXCM_TS[] effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CE routeCode?;
    CD approachSiteCode?;
    IVL_PQ doseQuantity;
    IVL_PQ rateQuantity?;
    RTO_PQ_PQ maxDoseQuantity?;
    CE administrationUnitCode?;
    InfrastructureRoot consumable;
    Subject subject?;
    Specimen[] specimen?;
    Performer2 performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SexObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type FamilyHistoryDeathObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProcedureEstimatedBloodLossSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type USRealmAddress record {|
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
    ADXP streetAddressLine?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PhysicalExamSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type LatexSafetyObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type USRealmDateTimeInterval record {|
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type EntryReference record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicationsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type UnstructuredDocument record {|
    *ClincialDocument;
    string clinicalDocType = "UnstructuredDocument";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type LongitudinalCareWoundObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
    CE[] interpretationCode?;
    CE[] methodCode?;
    CD targetSiteCode?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CareExperiencePreference record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ED value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CompanyNameObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    ED value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HospitalConsultationsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicationInformation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    LabeledDrug manufacturedLabeledDrug?;
    Material manufacturedMaterial;
    Organization manufacturerOrganization?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type OperativeNoteSurgicalProcedureSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type GeneralStatusSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProblemStatus record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HealthConcernAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProcedureDispositionSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicalGeneralHistorySection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ModelNumberObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    ED value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AssessmentScaleSupportingObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HospitalAdmissionDiagnosis record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type NonMedicinalSupplyActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ExternalDocumentReference record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II id;
    CD code;
    ED text?;
    II setId?;
    INT versionNumber?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProblemObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProcedureFindingsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type EncounterDiagnosis record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ServiceDeliveryLocation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code;
    AD addr?;
    TEL[] telecom?;
    Device playingDevice?;
    PlayingEntity playingEntity;
    Entity scopingEntity?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SocialHistorySection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AllergiesAndIntolerancesSection record {|
   *Section;
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    record {} text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AllergyConcernAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HandoffCommunicationParticipants record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author;
    Informant[] informant?;
    Participant2[] participant;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SensoryStatus record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AgeObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    PQ value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicationFreeTextSig record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id?;
    CD code;
    @xmldata:Attribute
    boolean negationInd?;
    ED text;
    CS statusCode?;
    SXCM_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CE routeCode?;
    CD approachSiteCode?;
    IVL_PQ doseQuantity?;
    IVL_PQ rateQuantity?;
    RTO_PQ_PQ maxDoseQuantity?;
    CE administrationUnitCode?;
    InfrastructureRoot consumable;
    Subject subject?;
    Specimen specimen?;
    Performer2 performer?;
    Author[] author?;
    Informant informant?;
    Participant2 participant?;
    EntryRelationship entryRelationship?;
    Reference[] reference?;
    Precondition precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PostoperativeDiagnosisSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ContinuityofCareDocumentCCD record {|
    *ClincialDocument;
    string clinicalDocType = "ContinuityofCareDocumentCCD";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
    II setId?;
    INT versionNumber?;
    TS copyTime?;
    RecordTarget[] recordTarget;
    Author[] author?;
    DataEnterer dataEnterer?;
    Informant[] informant?;
    Custodian custodian?;
    InformationRecipient[] informationRecipient?;
    LegalAuthenticator legalAuthenticator?;
    Authenticator[] authenticator?;
    Participant1[] participant?;
    InFulfillmentOf[] inFulfillmentOf?;
    DocumentationOf documentationOf?;
    RelatedDocument[] relatedDocument?;
    Authorization[] authorization?;
    ComponentOf componentOf?;
    Component component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MRISafetyObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProcedureNote record {|
    *ClincialDocument;
    string clinicalDocType = "ProcedureNote";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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
    DocumentationOf[] documentationOf;
    RelatedDocument[] relatedDocument?;
    Authorization authorization?;
    ComponentOf componentOf?;
    Component component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProblemSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CatalogNumberObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    ED value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProcedureSpecimensTakenSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type USRealmDateTime record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string value?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type NutritionSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AuthorParticipation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    string contextControlCode?;
    CE functionCode?;
    TS time;
    AssignedAuthor assignedAuthor;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HighestPressureUlcerStage record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicalEquipmentSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type GenderIdentityObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SmokingStatus record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD[] value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type FunctionalStatusObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DrugMonitoringAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ResultOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
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
    OrganizerComponent[] component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type NotesSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type WoundCharacteristic record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type TobaccoUse record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HealthStatusEvaluationsandOutcomesSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProgressNote record {|
    *ClincialDocument;
    string clinicalDocType = "ProgressNote";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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
    DocumentationOf documentationOf?;
    RelatedDocument[] relatedDocument?;
    Authorization[] authorization?;
    ComponentOf componentOf;
    Component component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicationAdherence record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HospitalDischargeDiagnosis record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type FamilyHistorySection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PolicyActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DisabilityStatusObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type USRealmHeaderforPatientGeneratedDocument record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
    II setId?;
    INT versionNumber?;
    TS copyTime?;
    RecordTarget recordTarget;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SerialNumberObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    ED value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ReasonforVisitSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CareTeamMemberAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2 performer;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SpecimenCollectionProcedure record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id?;
    CD code;
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
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type NumberofPressureUlcersObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    INT value;
    CE[] interpretationCode?;
    CE[] methodCode?;
    CD[] targetSiteCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    InfrastructureRoot[] referenceRange?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type NutritionAssessment record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CommentActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text;
    CS statusCode?;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author author?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CaregiverCharacteristics record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
    CE[] interpretationCode?;
    CE[] methodCode?;
    CD[] targetSiteCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    InfrastructureRoot[] referenceRange?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type EncountersSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ReferralNote record {|
    *ClincialDocument;
    string clinicalDocType = "ReferralNote";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
    II setId?;
    INT versionNumber?;
    TS copyTime?;
    RecordTarget[] recordTarget;
    Author[] author;
    DataEnterer dataEnterer?;
    Informant[] informant?;
    Custodian custodian;
    InformationRecipient informationRecipient;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PastMedicalHistory record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PlannedProcedureSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProcedureImplantsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SpecimenConditionObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicationSupplyOrder record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    ED text?;
    CS statusCode;
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
    Author author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type GoalsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type NutritionRecommendation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text?;
    CS statusCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type VitalSignsOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
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
    OrganizerComponent[] component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CoverageActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MentalStatusObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AverageBloodPressureOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id?;
    CD code;
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
    OrganizerComponent[] component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type USRealmPatientNamePTNUSFIELDED record {|
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AssessmentSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ImmunizationsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type OperativeNote record {|
    *ClincialDocument;
    string clinicalDocType = "OperativeNote";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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
    DocumentationOf[] documentationOf;
    RelatedDocument[] relatedDocument?;
    Authorization authorization?;
    ComponentOf componentOf?;
    Component component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ReasonforReferralSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ObjectiveSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProcedureDescriptionSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PlannedInterventionAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    CS languageCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type FamilyHistoryOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    Subject subject;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    OrganizerComponent[] component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CareTeamsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AssessmentScaleObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ChiefComplaintandReasonforVisitSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProvenanceAssemblerParticipation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string typeCode;
    @xmldata:Attribute
    string contextControlCode?;
    CE functionCode;
    IVL_TS time;
    AssociatedEntity associatedEntity;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MentalStatusOrganizer record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
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
    OrganizerComponent[] component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DischargeSummary record {|
    *ClincialDocument;
    string clinicalDocType = "DischargeSummary";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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
    ComponentOf componentOf;
    Component component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AuthorizationActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II id;
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
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ConsultationNote record {|
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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
    InFulfillmentOf[] inFulfillmentOf;
    DocumentationOf[] documentationOf?;
    RelatedDocument[] relatedDocument?;
    Authorization[] authorization?;
    ComponentOf componentOf;
    Component component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HealthStatusObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type TreatmentInterventionPreference record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ED value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SexualOrientationObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type OutcomeObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY value?;
    CE[] interpretationCode?;
    CE[] methodCode?;
    CD[] targetSiteCode?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    InfrastructureRoot[] referenceRange?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProcedureIndicationsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SocialHistoryObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProcedureActivityProcedure record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
    @xmldata:Attribute
    boolean negationInd?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    CS languageCode?;
    CE methodCode?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DischargeMedicationsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AllergyIntoleranceObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PreconditionforSubstanceAdministration record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CD code;
    ED text?;
    CD value;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PostprocedureDiagnosis record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type TransferSummary record {|
    *ClincialDocument;
    string clinicalDocType = "TransferSummary";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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
    DocumentationOf documentationOf;
    RelatedDocument[] relatedDocument?;
    Authorization[] authorization?;
    ComponentOf componentOf?;
    Component component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CharacteristicsofHomeEnvironment record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AdmissionMedication record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PlannedMedicationActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    @xmldata:Attribute
    boolean negationInd?;
    ED text?;
    CS statusCode;
    SXCM_TS[] effectiveTime;
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
    Author author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type FunctionalStatusSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ReactionObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type BasicIndustryObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PlannedSupply record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    ED text?;
    CS statusCode;
    SXCM_TS effectiveTime?;
    CE[] priorityCode?;
    IVL_INT repeatNumber?;
    BL independentInd?;
    PQ quantity?;
    IVL_TS expectedUseTime?;
    InfrastructureRoot product?;
    Subject subject?;
    Specimen[] specimen?;
    Performer2[] performer?;
    Author author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type RelatedPersonRelationshipAndNameParticipant record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string typeCode;
    @xmldata:Attribute
    string contextControlCode?;
    CE functionCode?;
    IVL_TS time?;
    AssociatedEntity associatedEntity;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ImplantableDeviceStatusObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SectionTimeRangeObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ST derivationExpr?;
    ED text;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    IVL_TS value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ReviewofSystemsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SeverityObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type InterventionAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ResultObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value;
    CE[] interpretationCode?;
    CE methodCode?;
    CD targetSiteCode?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PlanofTreatmentSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProductInstance record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    II[] id;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code?;
    AD[] addr?;
    TEL[] telecom?;
    Device playingDevice;
    PlayingEntity playingEntity?;
    Entity scopingEntity;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type VitalSignsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HealthConcernsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AdmissionMedicationsSectionEntriesOptional record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SmokingStatusMeaningfulUse record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ChiefComplaintSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type Indication record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AdmissionDiagnosisSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PreoperativeDiagnosis record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    EntryRelationship[] entryRelationship;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HospitalDischargeStudiesSummarySection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HistoryandPhysical record {|
    *ClincialDocument;
    string clinicalDocType = "HistoryandPhysical";
    @xmldata:Attribute
    string nullFlavor?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    CS realmCode;
    II typeId;
    II[] templateId;
    II id;
    CE code;
    ST title;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    CS statusCode?;
    TS effectiveTime;
    CE confidentialityCode;
    CS languageCode;
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
    ComponentOf componentOf;
    Component component;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type AssessmentandPlanSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ImmunizationActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    @xmldata:Attribute
    boolean negationInd;
    ED text?;
    CS statusCode;
    SXCM_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CE routeCode?;
    CD approachSiteCode?;
    IVL_PQ doseQuantity?;
    IVL_PQ rateQuantity?;
    RTO_PQ_PQ maxDoseQuantity?;
    CE administrationUnitCode?;
    InfrastructureRoot consumable;
    Subject subject?;
    Specimen[] specimen?;
    Performer2 performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PayersSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DischargeDiagnosisSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type Instruction record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text?;
    CS statusCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HospitalDischargeInstructionsSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ImmunizationNotGivenReason record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type WoundMeasurementObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    PQ value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CulturalandReligiousObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PostprocedureDiagnosisSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type EncounterActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
    ED text?;
    CS statusCode?;
    IVL_TS effectiveTime;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PlannedImmunizationActivity record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    @xmldata:Attribute
    boolean negationInd?;
    ED text?;
    CS statusCode;
    SXCM_TS effectiveTime;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type BasicOccupationObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type TribalAffiliationObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    ANY[] value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type CareTeamTypeObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PlannedEncounter record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code?;
    ED text?;
    CS statusCode;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type VitalSignObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    PQ value;
    CE interpretationCode?;
    CE methodCode?;
    CD targetSiteCode?;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type EstimatedDateofDelivery record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    TS value;
    CE interpretationCode?;
    CE methodCode?;
    CD targetSiteCode?;
    Subject subject?;
    Specimen specimen?;
    Performer2 performer?;
    Author[] author?;
    Informant informant?;
    Participant2 participant?;
    EntryRelationship entryRelationship?;
    Reference reference?;
    Precondition precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    Precondition2[] precondition2?;
    InfrastructureRoot referenceRange?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type MedicationDispense record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    II[] id;
    CD code;
    ED text?;
    CS statusCode;
    SXCM_TS effectiveTime?;
    CE[] priorityCode?;
    IVL_INT repeatNumber?;
    BL independentInd?;
    PQ quantity?;
    IVL_TS expectedUseTime?;
    InfrastructureRoot product;
    Subject subject?;
    Specimen[] specimen?;
    Performer2 performer?;
    Author[] author?;
    Informant[] informant?;
    Participant2[] participant?;
    EntryRelationship[] entryRelationship?;
    Reference[] reference?;
    Precondition[] precondition?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    InFulfillmentOf1[] inFulfillmentOf1?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type HistoryofPresentIllnessSection record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string ID?;
    @xmldata:Attribute
    string classCode?;
    @xmldata:Attribute
    string moodCode?;
    II id?;
    CE code;
    ST title;
    xml text;
    CE confidentialityCode?;
    CS languageCode?;
    Subject subject?;
    Author[] author?;
    Informant[] informant?;
    Entry[] entry?;
    InfrastructureRoot[] component?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type ProvenanceAuthorParticipation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string typeCode?;
    @xmldata:Attribute
    string contextControlCode?;
    CE functionCode?;
    TS time;
    AssignedAuthor assignedAuthor;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DrugVehicle record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    II[] id?;
    @xmldata:Namespace {uri: "urn:hl7-org:sdtc"}
    IdentifiedBy[] identifiedBy?;
    CE code;
    AD[] addr?;
    TEL[] telecom?;
    Device playingDevice?;
    PlayingEntity playingEntity;
    Entity scopingEntity?;
|};

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type Reason record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type PregnancyObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime?;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type SelfCareActivitiesADLandIADL record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
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
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DeceasedObservation record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id;
    CD code;
    ST derivationExpr?;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
    CE priorityCode?;
    IVL_INT repeatNumber?;
    CS languageCode?;
    CD value;
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

@xmldata:Namespace {uri: "urn:hl7-org:v3"}
public type DateOfDiagnosisAct record {|
    @xmldata:Attribute
    string nullFlavor?;
    CS[] realmCode?;
    II typeId?;
    II[] templateId;
    @xmldata:Attribute
    string classCode;
    @xmldata:Attribute
    string moodCode;
    @xmldata:Attribute
    boolean negationInd?;
    II[] id?;
    CD code;
    ED text?;
    CS statusCode;
    IVL_TS effectiveTime;
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
