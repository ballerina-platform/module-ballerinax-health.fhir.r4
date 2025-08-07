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
import ballerina/log;
import ballerina/test;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

final string ccdaDocumentXml = string `<ClinicalDocument xmlns="urn:hl7-org:v3">
    <realmCode code="US" />
    <typeId extension="POCD_HD000040" root="2.16.840.1.113883.1.3" />
    <templateId root="1.2.840.114350.1.72.1.51693" />
    <templateId root="2.16.840.1.113883.10.20.22.1.1" />
    <templateId root="2.16.840.1.113883.10.20.22.1.1" extension="2015-08-01" />
    <templateId root="2.16.840.1.113883.10.20.22.1.9" />
    <templateId root="2.16.840.1.113883.10.20.22.1.9" extension="2015-08-01" />
    <id assigningAuthorityName="EPC" root="1.2.840.114350.1.13.2.2.7.8.688883.3914097842" />
    <code code="11506-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"
        displayName="Subsequent evaluation note" />
    <title>Encounter Summary</title>
    <effectiveTime value="20240612164532-0500" />
    <confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25" displayName="Normal" />
    <languageCode code="en-US" />
    <setId assigningAuthorityName="EPC" extension="99a8bff4-5bbe-11ed-b9f8-3503834d5bac"
        root="1.2.840.114350.1.13.2.2.7.1.1" />
    <versionNumber value="3" />
    <recordTarget>
        <patientRole>
            <id root="1.2.840.114350.1.13.2.2.7.3.688884.100" extension="AAH5MCC1MZL2L8D" />
            <id assigningAuthorityName="ANTHEM/BCBS" root="1.2.840.114350.1.13.2.2.7.5.698077.2700"
                extension="SWU567W10338" />
            <addr use="HP">
                <streetAddressLine>120 E COLUMBIA</streetAddressLine>
                <city>ELMHURST</city>
                <state>IL</state>
                <postalCode>60126</postalCode>
                <country>USA</country>
                <useablePeriod xsi:type="IVL_TS"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                    <low value="20181024" />
                    <high nullFlavor="UNK" />
                </useablePeriod>
            </addr>
            <addr use="HP">
                <streetAddressLine>6104 WOODCREEK DR</streetAddressLine>
                <city>BURR RIDGE</city>
                <state>IL</state>
                <postalCode>60527</postalCode>
                <country>USA</country>
                <useablePeriod xsi:type="IVL_TS"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                    <low value="20181024" />
                    <high value="20181023" />
                </useablePeriod>
            </addr>
            <telecom use="HP" value="tel:+1-630-347-2012" />
            <telecom use="WP" value="tel:+1-847-373-7020" />
            <telecom value="mailto:newellhmp@gmail.com" />
            <patient>
                <name use="L">
                    <given>Brian</given>
                    <given>C</given>
                    <family>Newell</family>
                    <validTime>
                        <low nullFlavor="NA" />
                        <high nullFlavor="NA" />
                    </validTime>
                </name>
                <administrativeGenderCode code="M" codeSystem="2.16.840.1.113883.5.1"
                    codeSystemName="AdministrativeGenderCode" displayName="Male" />
                <birthTime value="19851016" />
                <sdtc:deceasedInd value="false" xmlns:sdtc="urn:hl7-org:sdtc" />
                <maritalStatusCode code="S" codeSystem="2.16.840.1.113883.5.2"
                    codeSystemName="MaritalStatusCode" displayName="Single" />
                <raceCode code="2106-3" codeSystem="2.16.840.1.113883.6.238"
                    codeSystemName="CDC Race and Ethnicity" displayName="White" />
                <ethnicGroupCode code="2186-5" codeSystem="2.16.840.1.113883.6.238"
                    codeSystemName="CDC Race and Ethnicity" displayName="Not Hispanic or Latino" />
                <languageCommunication>
                    <languageCode code="eng" />
                    <modeCode code="EWR" codeSystem="2.16.840.1.113883.5.60"
                        displayName="Expressed Written" />
                    <preferenceInd value="false" />
                </languageCommunication>
            </patient>
            <providerOrganization>
                <id root="1.2.840.114350.1.13.2.2.7.2.688879" extension="2800" />
                <name>Advocate Aurora Health</name>
                <telecom nullFlavor="NI" />
                <addr use="WP">
                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                    <city>Milwaukee</city>
                    <state>WI</state>
                    <postalCode>53215</postalCode>
                    <country>USA</country>
                </addr>
            </providerOrganization>
        </patientRole>
    </recordTarget>
    <author>
        <time value="20240612164532-0500" />
        <assignedAuthor>
            <id root="1.2.840.114350.1.1" extension="10.6" />
            <addr nullFlavor="NA" />
            <telecom nullFlavor="NA" />
            <assignedAuthoringDevice>
                <manufacturerModelName>Epic - Version 10.6</manufacturerModelName>
                <softwareName>Epic - Version 10.6</softwareName>
            </assignedAuthoringDevice>
            <representedOrganization>
                <id root="1.2.840.114350.1.13.2.2.7.2.688879" extension="2800" />
                <name>Advocate Aurora Health</name>
                <telecom nullFlavor="NI" />
                <addr use="WP">
                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                    <city>Milwaukee</city>
                    <state>WI</state>
                    <postalCode>53215</postalCode>
                    <country>USA</country>
                </addr>
            </representedOrganization>
        </assignedAuthor>
    </author>
    <custodian>
        <assignedCustodian>
            <representedCustodianOrganization>
                <id root="1.2.840.114350.1.13.2.2.7.2.688879" extension="2800" />
                <name>Advocate Aurora Health</name>
                <telecom nullFlavor="NI" />
                <addr use="WP">
                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                    <city>Milwaukee</city>
                    <state>WI</state>
                    <postalCode>53215</postalCode>
                    <country>USA</country>
                </addr>
            </representedCustodianOrganization>
        </assignedCustodian>
    </custodian>
    <legalAuthenticator>
        <time value="20240612164532-0500" />
        <signatureCode code="S" />
        <assignedEntity>
            <id root="1.2.840.114350.1.13.2.2.7.2.697780" extension=" K00595" />
            <code nullFlavor="UNK" />
            <addr nullFlavor="UNK" />
            <telecom nullFlavor="UNK" />
            <assignedPerson>
                <name nullFlavor="UNK" />
                <sdtc:desc xmlns:sdtc="urn:hl7-org:sdtc">Pop Health, Vice President For Health
                    Information And Coding</sdtc:desc>
            </assignedPerson>
        </assignedEntity>
    </legalAuthenticator>
    <documentationOf typeCode="DOC">
        <serviceEvent classCode="PCPR">
            <templateId root="2.16.840.1.113883.10.20.21.3.1" />
            <effectiveTime>
                <low value="20221103123000-0500" />
                <high value="20221103124136-0500" />
            </effectiveTime>
            <performer typeCode="PRF">
                <functionCode code="PCP" codeSystem="2.16.840.1.113883.5.88"
                    codeSystemName="ParticipationFunction" displayName="Primary Care Provider">
                    <originalText>General</originalText>
                </functionCode>
                <time>
                    <low value="20221103" />
                    <high nullFlavor="NI" />
                </time>
                <assignedEntity>
                    <id root="2.16.840.1.113883.4.6" extension="1194824953" />
                    <code code="207R00000X" codeSystem="2.16.840.1.113883.6.101"
                        displayName="INTERNAL MEDICINE PHYSICIAN">
                        <originalText>Internal Medicine</originalText>
                        <translation code="32" codeSystem="1.2.840.114350.1.72.1.7.7.10.688867.4160"
                            codeSystemName="Epic.DXC.StandardProviderSpecialtyType"
                            displayName="Internal Medicine" />
                        <translation code="17" codeSystem="1.2.840.114350.1.13.2.2.7.10.836982.1050"
                            codeSystemName="Epic.SER.ProviderSpecialty"
                            displayName="Internal Medicine" />
                    </code>
                    <addr use="WP">
                        <streetAddressLine>305 N YORK RD</streetAddressLine>
                        <city>ELMHURST</city>
                        <state>IL</state>
                        <postalCode>60126-1634</postalCode>
                    </addr>
                    <telecom use="WP" value="tel:+1-847-818-7626" />
                    <telecom value="fax:+1-630-415-3492" />
                    <assignedPerson>
                        <name use="L">
                            <given>Janet</given>
                            <family>Aganad</family>
                            <suffix qualifier="AC"> DO</suffix>
                            <validTime>
                                <low nullFlavor="UNK" />
                                <high nullFlavor="UNK" />
                            </validTime>
                        </name>
                    </assignedPerson>
                    <representedOrganization classCode="ORG">
                        <name>Alexian Brothers Medical Group</name>
                        <telecom nullFlavor="UNK" />
                        <addr use="WP">
                            <streetAddressLine>1000 REMINGTON BLVD</streetAddressLine>
                            <city>BOLINGBROOK</city>
                            <state>IL</state>
                            <postalCode>60440-4708</postalCode>
                        </addr>
                    </representedOrganization>
                </assignedEntity>
            </performer>
        </serviceEvent>
    </documentationOf>
    <componentOf>
        <encompassingEncounter>
            <id root="1.2.840.114350.1.13.2.2.7.3.698084.8" extension="10369754624" />
            <code code="99203" codeSystem="2.16.840.1.113883.6.12"
                displayName="OFFICE OR OTHER OUTPATIENT VISIT NEW PT 30 OR MORE LOW MDM LVL 3">
                <originalText>Walk In</originalText>
                <translation code="AMB" codeSystem="2.16.840.1.113883.5.4" displayName="Ambulatory" />
                <translation code="2" codeSystem="1.2.840.114350.1.72.1.30" displayName="Walk-In" />
                <translation code="4" codeSystem="1.2.840.114350.1.72.1.30.1" />
            </code>
            <effectiveTime>
                <low value="20221103123000-0500" />
                <high value="20221103124136-0500" />
            </effectiveTime>
            <responsibleParty>
                <assignedEntity>
                    <id root="2.16.840.1.113883.4.6" extension="1447424932" />
                    <addr use="WP">
                        <streetAddressLine>6831 W North Ave</streetAddressLine>
                        <city>OAK PARK</city>
                        <state>IL</state>
                        <postalCode>60302-1023</postalCode>
                        <country>USA</country>
                    </addr>
                    <telecom use="WP" value="tel:+1-708-298-0540" />
                    <telecom value="fax:+1-708-298-0541" />
                    <assignedPerson>
                        <name>
                            <given>Valerie</given>
                            <family>Baron</family>
                        </name>
                    </assignedPerson>
                    <representedOrganization>
                        <name>Advocate Aurora Health</name>
                    </representedOrganization>
                </assignedEntity>
            </responsibleParty>
            <encounterParticipant typeCode="ATND">
                <time value="20221103123000-0500" />
                <assignedEntity>
                    <id root="2.16.840.1.113883.4.6" extension="1447424932" />
                    <code nullFlavor="OTH">
                        <originalText>Nurse Practitioner - Family</originalText>
                        <translation code="19" codeSystem="1.2.840.114350.1.72.1.7.7.10.688867.4160"
                            codeSystemName="Epic.DXC.StandardProviderSpecialtyType"
                            displayName="Family Medicine" />
                        <translation code="1034"
                            codeSystem="1.2.840.114350.1.13.2.2.7.10.836982.1050"
                            codeSystemName="Epic.SER.ProviderSpecialty"
                            displayName="Nurse Practitioner - Family" />
                    </code>
                    <addr use="WP">
                        <streetAddressLine>6831 W North Ave</streetAddressLine>
                        <county>COOK</county>
                        <city>OAK PARK</city>
                        <state>IL</state>
                        <postalCode>60302-1023</postalCode>
                        <country>USA</country>
                    </addr>
                    <telecom use="WP" value="tel:+1-708-298-0540" />
                    <telecom value="fax:+1-708-298-0541" />
                    <assignedPerson>
                        <name use="L">
                            <given>Valerie</given>
                            <family>Baron</family>
                            <suffix qualifier="AC"> CNP</suffix>
                            <validTime>
                                <low nullFlavor="UNK" />
                                <high nullFlavor="UNK" />
                            </validTime>
                        </name>
                    </assignedPerson>
                </assignedEntity>
            </encounterParticipant>
            <encounterParticipant typeCode="ATND">
                <time value="20221103123000-0500" />
                <assignedEntity>
                    <id nullFlavor="UNK" />
                    <addr nullFlavor="UNK" />
                    <telecom nullFlavor="UNK" />
                    <assignedPerson>
                        <name use="L">
                            <given>Admg</given>
                            <given>Wag Villa</given>
                            <family>Park</family>
                            <validTime>
                                <low nullFlavor="UNK" />
                                <high nullFlavor="UNK" />
                            </validTime>
                        </name>
                    </assignedPerson>
                </assignedEntity>
            </encounterParticipant>
            <location>
                <healthCareFacility>
                    <id root="1.2.840.114350.1.13.2.2.7.2.686980" extension="900050531120" />
                    <code nullFlavor="UNK">
                        <originalText>Urgent Care</originalText>
                        <translation code="105"
                            codeSystem="1.2.840.114350.1.72.1.7.7.10.688867.4150"
                            codeSystemName="Epic.DepartmentSpecialty" displayName="Urgent Care" />
                    </code>
                    <location>
                        <name>Advocate Clinic at Walgreens - Villa Park</name>
                        <addr use="WP">
                            <streetAddressLine>200 E ROOSEVELT RD</streetAddressLine>
                            <city>VILLA PARK</city>
                            <state>IL</state>
                            <postalCode>60181-3500</postalCode>
                        </addr>
                    </location>
                    <serviceProviderOrganization>
                        <id root="1.2.840.114350.1.13.2.2.7.2.696570" extension="90005053" />
                        <name>ADVOCATE MEDICAL GROUP WALGREENS VILLA PARK 200 E ROOSEVELT</name>
                        <addr use="WP">
                            <streetAddressLine>200 E ROOSEVELT RD</streetAddressLine>
                            <city>VILLA PARK</city>
                            <state>IL</state>
                            <postalCode>60181-3500</postalCode>
                        </addr>
                        <asOrganizationPartOf>
                            <wholeOrganization>
                                <name>Advocate Aurora Health</name>
                                <addr use="WP">
                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                    <city>Milwaukee</city>
                                    <state>WI</state>
                                    <postalCode>53215</postalCode>
                                    <country>USA</country>
                                </addr>
                            </wholeOrganization>
                        </asOrganizationPartOf>
                    </serviceProviderOrganization>
                </healthCareFacility>
            </location>
        </encompassingEncounter>
    </componentOf>
    <component>
        <structuredBody>
            <component>
                <section>
                    <templateId root="2.16.840.1.113883.10.20.22.2.12" />
                    <code code="29299-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"
                        displayName="REASON FOR VISIT" />
                    <title>Reason for Visit</title>
                    <text>
                        <list>
                            <item>
                                <table>
                                    <colgroup>
                                        <col width="25%" />
                                        <col width="75%" />
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>Reason</th>
                                            <th>Comments</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr ID="rfv2">
                                            <td ID="reasonrfv2">Illness</td>
                                            <td ID="rfv2comments">Sinus pressure in face, sinus
                                                headache, nasal congestion, left ear pressure
                                                symptoms started about 2 weeks ago</td>
                                        </tr>
                                        <tr ID="rfv3">
                                            <td ID="reasonrfv3">Office Visit</td>
                                            <td />
                                        </tr>
                                    </tbody>
                                </table>
                            </item>
                        </list>
                    </text>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="1.2.840.114350.1.72.7" />
                            <id root="1.2.840.114350.1.13.2.2.7.2.728286"
                                extension="HRV-520-10369754624-1" />
                            <code code="8661-1" codeSystem="2.16.840.1.113883.6.1"
                                codeSystemName="LOINC" displayName="Chief Complaint" />
                            <statusCode code="completed" />
                            <effectiveTime nullFlavor="UNK" />
                            <value nullFlavor="UNK" xsi:type="CD"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                <originalText>Illness</originalText>
                            </value>
                        </observation>
                    </entry>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="1.2.840.114350.1.72.7" />
                            <id root="1.2.840.114350.1.13.2.2.7.2.728286"
                                extension="HRV-1620-10369754624-2" />
                            <code code="8661-1" codeSystem="2.16.840.1.113883.6.1"
                                codeSystemName="LOINC" displayName="Chief Complaint" />
                            <statusCode code="completed" />
                            <effectiveTime nullFlavor="UNK" />
                            <value nullFlavor="UNK" xsi:type="CD"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                <originalText>Office Visit</originalText>
                            </value>
                        </observation>
                    </entry>
                </section>
            </component>
            <component>
                <section>
                    <templateId root="2.16.840.1.113883.10.20.22.2.22" />
                    <templateId root="2.16.840.1.113883.10.20.22.2.22" extension="2015-08-01" />
                    <templateId root="2.16.840.1.113883.10.20.22.2.22.1" />
                    <templateId root="2.16.840.1.113883.10.20.22.2.22.1" extension="2015-08-01" />
                    <code code="46240-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"
                        displayName="History of Hospitalizations+Outpatient visits Narrative" />
                    <title>Encounter Details</title>
                    <text>
                        <table>
                            <colgroup>
                                <col width="10%" />
                                <col width="15%" />
                                <col width="25%" span="3" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Type</th>
                                    <th>Department</th>
                                    <th>Care Team (Latest Contact Info)</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ID="encounter4" styleCode="xRowNormal">
                                    <td>11/03/2022 12:30 PM CDT</td>
                                    <td ID="encounter4type">Walk In</td>
                                    <td>
                                        <paragraph>Advocate Clinic at Walgreens - Villa Park</paragraph>
                                        <paragraph>200 E ROOSEVELT RD</paragraph>
                                        <paragraph>VILLA PARK, IL 60181-3500</paragraph>
                                        <paragraph>800-323-8622</paragraph>
                                    </td>
                                    <td>
                                        <paragraph styleCode="Bold">Baron, Valerie, CNP</paragraph>
                                        <paragraph>6831 W North Ave</paragraph>
                                        <paragraph>OAK PARK, IL 60302-1023</paragraph>
                                        <paragraph>708-298-0540 (Work)</paragraph>
                                        <paragraph>708-298-0541 (Fax)</paragraph>
                                    </td>
                                    <td>
                                        <content ID="encounter4desc">Acute bacterial sinusitis
                                            (Primary Dx)</content>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </text>
                    <entry>
                        <encounter classCode="ENC" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.49"
                                extension="2015-08-01" />
                            <id assigningAuthorityName="EPIC"
                                root="1.2.840.114350.1.13.2.2.7.3.698084.8" extension="10369754624" />
                            <code code="99203" codeSystem="2.16.840.1.113883.6.12">
                                <originalText>
                                    <reference value="#encounter4type" />
                                </originalText>
                                <translation code="175"
                                    codeSystem="1.2.840.114350.1.13.2.2.7.4.698084.30"
                                    codeSystemName="Epic.EncounterType" />
                                <translation code="AMB" codeSystem="2.16.840.1.113883.5.4" />
                                <translation code="2" codeSystem="1.2.840.114350.1.72.1.30" />
                                <translation code="4" codeSystem="1.2.840.114350.1.72.1.30.1" />
                            </code>
                            <text>
                                <reference value="#encounter4" />
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime>
                                <low value="20221103123000-0500" />
                                <high value="20221103124136-0500" />
                            </effectiveTime>
                            <performer typeCode="PRF">
                                <time>
                                    <low nullFlavor="UNK" />
                                    <high nullFlavor="UNK" />
                                </time>
                                <assignedEntity classCode="ASSIGNED">
                                    <id root="2.16.840.1.113883.4.6" extension="1447424932" />
                                    <code nullFlavor="OTH">
                                        <originalText>Nurse Practitioner - Family</originalText>
                                        <translation code="19"
                                            codeSystem="1.2.840.114350.1.72.1.7.7.10.688867.4160"
                                            codeSystemName="Epic.DXC.StandardProviderSpecialtyType"
                                            displayName="Family Medicine" />
                                        <translation code="1034"
                                            codeSystem="1.2.840.114350.1.13.2.2.7.10.836982.1050"
                                            codeSystemName="Epic.SER.ProviderSpecialty"
                                            displayName="Nurse Practitioner - Family" />
                                    </code>
                                    <addr use="WP">
                                        <streetAddressLine>6831 W North Ave</streetAddressLine>
                                        <county>COOK</county>
                                        <city>OAK PARK</city>
                                        <state>IL</state>
                                        <postalCode>60302-1023</postalCode>
                                        <country>USA</country>
                                    </addr>
                                    <telecom use="WP" value="tel:+1-708-298-0540" />
                                    <telecom value="fax:+1-708-298-0541" />
                                    <assignedPerson>
                                        <name>
                                            <given>Valerie</given>
                                            <family>Baron</family>
                                            <suffix qualifier="AC">CNP</suffix>
                                        </name>
                                    </assignedPerson>
                                    <representedOrganization classCode="ORG">
                                        <name>Advocate Aurora Health</name>
                                        <telecom nullFlavor="NI" />
                                        <addr use="WP">
                                            <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                            <city>Milwaukee</city>
                                            <state>WI</state>
                                            <postalCode>53215</postalCode>
                                            <country>USA</country>
                                        </addr>
                                    </representedOrganization>
                                </assignedEntity>
                            </performer>
                            <author>
                                <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                    extension="2019-10-01" />
                                <time value="20221103124103-0500" />
                                <assignedAuthor>
                                    <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                    <addr nullFlavor="UNK" />
                                    <telecom nullFlavor="UNK" />
                                    <representedOrganization>
                                        <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                            extension="2800" />
                                        <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                        <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                        <name>Advocate Aurora Health</name>
                                        <addr use="WP">
                                            <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                            <city>Milwaukee</city>
                                            <state>WI</state>
                                            <postalCode>53215</postalCode>
                                            <country>USA</country>
                                        </addr>
                                    </representedOrganization>
                                </assignedAuthor>
                            </author>
                            <participant typeCode="LOC">
                                <participantRole classCode="SDLOC">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.32" />
                                    <id root="1.2.840.114350.1.13.2.2.7.2.686980"
                                        extension="900050531120" />
                                    <code nullFlavor="UNK">
                                        <originalText>Urgent Care</originalText>
                                        <translation code="105"
                                            codeSystem="1.2.840.114350.1.72.1.7.7.10.688867.4150"
                                            codeSystemName="Epic.DepartmentSpecialty"
                                            displayName="Urgent Care" />
                                    </code>
                                    <addr use="WP">
                                        <streetAddressLine>200 E ROOSEVELT RD</streetAddressLine>
                                        <city>VILLA PARK</city>
                                        <state>IL</state>
                                        <postalCode>60181-3500</postalCode>
                                    </addr>
                                    <playingEntity classCode="PLC">
                                        <name>Advocate Clinic at Walgreens - Villa Park</name>
                                        <desc>Urgent Care</desc>
                                    </playingEntity>
                                </participantRole>
                            </participant>
                            <entryRelationship typeCode="COMP">
                                <act classCode="ACT" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.64" />
                                    <code code="48767-8" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC" />
                                    <text>
                                        <reference value="#encounter4desc" />
                                    </text>
                                    <statusCode code="completed" />
                                </act>
                            </entryRelationship>
                            <entryRelationship typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.80" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.80"
                                        extension="2015-08-01" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.1099.1"
                                        extension="10369754624-34090-concern" />
                                    <code code="29308-4" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC" displayName="Diagnosis" />
                                    <statusCode code="active" />
                                    <entryRelationship typeCode="SUBJ" inversionInd="false">
                                        <observation classCode="OBS" moodCode="EVN">
                                            <templateId root="2.16.840.1.113883.10.20.22.4.4" />
                                            <templateId root="2.16.840.1.113883.10.20.22.4.4"
                                                extension="2015-08-01" />
                                            <templateId root="2.16.840.1.113883.10.20.22.4.4"
                                                extension="2022-06-01" />
                                            <id root="1.2.840.114350.1.13.2.2.7.1.1099.1"
                                                extension="10369754624-34090" />
                                            <code code="282291009"
                                                codeSystem="2.16.840.1.113883.6.96"
                                                codeSystemName="SNOMED CT">
                                                <translation code="29308-4"
                                                    codeSystem="2.16.840.1.113883.6.1"
                                                    codeSystemName="LOINC" displayName="Diagnosis" />
                                            </code>
                                            <text>Acute bacterial sinusitis</text>
                                            <statusCode code="completed" />
                                            <effectiveTime>
                                                <low nullFlavor="UNK" />
                                            </effectiveTime>
                                            <value xsi:type="CD" code="75498004"
                                                codeSystem="2.16.840.1.113883.6.96"
                                                codeSystemName="SNOMED CT"
                                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                                <originalText>Acute bacterial sinusitis</originalText>
                                                <translation code="J01.90"
                                                    codeSystem="2.16.840.1.113883.6.90"
                                                    codeSystemName="ICD10"
                                                    displayName="Acute bacterial sinusitis" />
                                                <translation code="461.9"
                                                    codeSystem="2.16.840.1.113883.6.103"
                                                    codeSystemName="ICD9"
                                                    displayName="Acute bacterial sinusitis" />
                                                <translation code="24035"
                                                    codeSystem="2.16.840.1.113883.3.247.1.1"
                                                    codeSystemName="Intelligent Medical Objects ProblemIT"
                                                    displayName="Acute bacterial sinusitis" />
                                            </value>
                                            <author>
                                                <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                                <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                                    extension="2019-10-01" />
                                                <time value="20221103123501-0500" />
                                                <assignedAuthor>
                                                    <id root="1.2.840.114350.1.13.2.2.7.1.1133"
                                                        extension="151651478" />
                                                    <id root="2.16.840.1.113883.4.6"
                                                        extension="1447424932" />
                                                    <code nullFlavor="OTH">
                                                        <originalText>Nurse Practitioner - Family</originalText>
                                                        <translation code="19"
                                                            codeSystem="1.2.840.114350.1.72.1.7.7.10.688867.4160"
                                                            codeSystemName="Epic.DXC.StandardProviderSpecialtyType"
                                                            displayName="Family Medicine" />
                                                        <translation code="1034"
                                                            codeSystem="1.2.840.114350.1.13.2.2.7.10.836982.1050"
                                                            codeSystemName="Epic.SER.ProviderSpecialty"
                                                            displayName="Nurse Practitioner - Family" />
                                                    </code>
                                                    <addr use="WP">
                                                        <streetAddressLine>6831 W North Ave</streetAddressLine>
                                                        <county>COOK</county>
                                                        <city>OAK PARK</city>
                                                        <state>IL</state>
                                                        <postalCode>60302-1023</postalCode>
                                                        <country>USA</country>
                                                    </addr>
                                                    <telecom use="WP" value="tel:+1-708-298-0540" />
                                                    <telecom use="WP" value="fax:+1-708-298-0541" />
                                                    <assignedPerson>
                                                        <name use="L">
                                                            <given>Valerie</given>
                                                            <family>Baron</family>
                                                            <suffix qualifier="AC"> CNP</suffix>
                                                            <validTime>
                                                                <low nullFlavor="UNK" />
                                                                <high nullFlavor="UNK" />
                                                            </validTime>
                                                        </name>
                                                    </assignedPerson>
                                                    <representedOrganization>
                                                        <id
                                                            root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                            extension="2800" />
                                                        <id root="2.16.840.1.113883.4.2"
                                                            nullFlavor="UNK" />
                                                        <id root="2.16.840.1.113883.4.6"
                                                            nullFlavor="UNK" />
                                                        <name>Advocate Aurora Health</name>
                                                        <addr use="WP">
                                                            <streetAddressLine>750 West Virginia
                                                                Street</streetAddressLine>
                                                            <city>Milwaukee</city>
                                                            <state>WI</state>
                                                            <postalCode>53215</postalCode>
                                                            <country>USA</country>
                                                        </addr>
                                                    </representedOrganization>
                                                </assignedAuthor>
                                            </author>
                                            <participant typeCode="LOC">
                                                <participantRole classCode="SDLOC">
                                                    <templateId
                                                        root="2.16.840.1.113883.10.20.22.4.32" />
                                                    <code nullFlavor="UNK">
                                                        <translation code="0"
                                                            codeSystem="1.2.840.114350.1.72.1.7.7.10.698084.18465"
                                                            codeSystemName="Epic.isEDDX" />
                                                    </code>
                                                    <addr nullFlavor="UNK" />
                                                    <playingEntity classCode="PLC">
                                                        <name nullFlavor="UNK" />
                                                    </playingEntity>
                                                </participantRole>
                                            </participant>
                                            <entryRelationship typeCode="REFR">
                                                <observation classCode="OBS" moodCode="EVN">
                                                    <templateId
                                                        root="2.16.840.1.113883.10.20.22.4.6" />
                                                    <templateId
                                                        root="2.16.840.1.113883.10.20.22.4.6"
                                                        extension="2019-06-20" />
                                                    <code code="33999-4"
                                                        codeSystem="2.16.840.1.113883.6.1"
                                                        displayName="Status" />
                                                    <statusCode code="completed" />
                                                    <effectiveTime>
                                                        <low nullFlavor="UNK" />
                                                    </effectiveTime>
                                                    <value xsi:type="CD" code="55561003"
                                                        codeSystem="2.16.840.1.113883.6.96"
                                                        displayName="Active"
                                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                                </observation>
                                            </entryRelationship>
                                            <entryRelationship typeCode="REFR">
                                                <observation classCode="OBS" moodCode="EVN">
                                                    <templateId
                                                        root="2.16.840.1.113883.10.20.24.3.166"
                                                        extension="2019-12-01" />
                                                    <code code="263486008"
                                                        codeSystem="2.16.840.1.113883.6.96"
                                                        codeSystemName="SNOMED CT"
                                                        displayName="Rank" />
                                                    <value xsi:type="INT" value="1"
                                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                                </observation>
                                            </entryRelationship>
                                        </observation>
                                    </entryRelationship>
                                </act>
                            </entryRelationship>
                        </encounter>
                    </entry>
                </section>
            </component>
            <component>
                <section>
                    <templateId root="2.16.840.1.113883.10.20.22.2.17" />
                    <templateId root="2.16.840.1.113883.10.20.22.2.17" extension="2015-08-01" />
                    <code code="29762-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"
                        displayName="Social history Narrative" />
                    <title>Social History</title>
                    <text>
                        <table ID="sochist9">
                            <colgroup>
                                <col width="25%" span="2" />
                                <col width="13%" />
                                <col width="12%" />
                                <col width="25%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Tobacco Use</th>
                                    <th>Types</th>
                                    <th>Packs/Day</th>
                                    <th>Years Used</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Smoking Tobacco: Never</td>
                                    <td />
                                    <td ID="sochist9packsperday" />
                                    <td />
                                    <td />
                                </tr>
                                <tr ID="sochist9smokeless" styleCode="xRowAlt">
                                    <td>Smokeless Tobacco: Never</td>
                                    <td />
                                    <td />
                                    <td />
                                    <td />
                                </tr>
                            </tbody>
                        </table>
                        <table>
                            <colgroup>
                                <col width="25%" span="2" />
                                <col width="50%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Alcohol Use</th>
                                    <th>Standard Drinks/Week</th>
                                    <th>Comments</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td ID="alcoholStatus">Yes</td>
                                    <td>0 (1 standard drink = 0.6 oz pure alcohol)</td>
                                    <td />
                                </tr>
                            </tbody>
                        </table>
                        <table ID="sdohassess2">
                            <colgroup>
                                <col width="50%" />
                                <col width="25%" span="2" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Inadequate Housing</th>
                                    <th>Answer</th>
                                    <th>Date Recorded</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ID="sdohassess2pair1">
                                    <td ID="sdohassess2pair1ques">Social Determinants: Housing
                                        (Overall Score Helper) </td>
                                    <td ID="sdohassess2pair1ans">0</td>
                                    <td>11/03/2022</td>
                                </tr>
                            </tbody>
                        </table>
                        <table>
                            <colgroup>
                                <col width="25%" span="4" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Sexually Active</th>
                                    <th>Birth Control</th>
                                    <th>Partners</th>
                                    <th>Comments</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Yes</td>
                                    <td>None</td>
                                    <td>Female</td>
                                    <td />
                                </tr>
                            </tbody>
                        </table>
                        <table>
                            <colgroup>
                                <col width="50%" />
                                <col width="25%" span="2" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Sex and Gender Information</th>
                                    <th>Value</th>
                                    <th>Date Recorded</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ID="BirthSex12">
                                    <td>Sex Assigned at Birth</td>
                                    <td ID="BirthSex12Value">Not on file</td>
                                    <td />
                                </tr>
                                <tr ID="GenderIdentity10">
                                    <td>Gender Identity</td>
                                    <td ID="GenderIdentity10Value">Not on file</td>
                                    <td />
                                </tr>
                                <tr ID="SexualOrientation11">
                                    <td>Sexual Orientation</td>
                                    <td ID="SexualOrientation11Value">Not on file</td>
                                    <td />
                                </tr>
                            </tbody>
                        </table>
                        <table>
                            <colgroup>
                                <col width="25%" span="2" />
                                <col width="50%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Job Start Date</th>
                                    <th>Occupation</th>
                                    <th>Industry</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Not on file</td>
                                    <td ID="sochist13">Not on file</td>
                                    <td ID="sochist14">Not on file</td>
                                </tr>
                            </tbody>
                        </table>
                        <footnote ID="subTitle8" styleCode="xSectionSubTitle">documented as of this
                            encounter</footnote>
                    </text>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.78" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.78"
                                extension="2014-06-09" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.1040.1"
                                extension="Z28967392^^72166-2" />
                            <code code="72166-2" codeSystem="2.16.840.1.113883.6.1"
                                codeSystemName="LOINC" displayName="Tobacco smoking status NHIS" />
                            <text>
                                <reference value="#sochist9" />
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime value="20221103" />
                            <value xsi:type="CD" code="266919005"
                                codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"
                                displayName="Never smoked tobacco"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                            <author>
                                <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                    extension="2019-10-01" />
                                <time value="20221103" />
                                <assignedAuthor>
                                    <id root="1.2.840.114350.1.13.2.2.7.1.1133"
                                        extension="799835920" />
                                    <id root="1.2.840.114350.1.13.2.2.7.2.697780" extension="C53425" />
                                    <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                    <addr nullFlavor="UNK" />
                                    <telecom nullFlavor="UNK" />
                                    <assignedPerson>
                                        <name use="L">
                                            <given>Kiera</given>
                                            <given>T</given>
                                            <family>Gray</family>
                                            <validTime>
                                                <low nullFlavor="UNK" />
                                                <high nullFlavor="UNK" />
                                            </validTime>
                                        </name>
                                    </assignedPerson>
                                    <representedOrganization>
                                        <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                            extension="2800" />
                                        <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                        <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                        <name>Advocate Aurora Health</name>
                                        <addr use="WP">
                                            <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                            <city>Milwaukee</city>
                                            <state>WI</state>
                                            <postalCode>53215</postalCode>
                                            <country>USA</country>
                                        </addr>
                                    </representedOrganization>
                                </assignedAuthor>
                            </author>
                        </observation>
                    </entry>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.38" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38"
                                extension="2015-08-01" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.1040.8"
                                extension="Z28967392^^713914004" />
                            <code code="229819007" codeSystem="2.16.840.1.113883.6.96"
                                codeSystemName="SNOMED-CT" displayName="Tobacco use and exposure">
                                <translation code="88031-0" codeSystem="2.16.840.1.113883.6.1"
                                    codeSystemName="LOINC" displayName="Smokeless tobacco status" />
                            </code>
                            <text>
                                <reference value="#sochist9smokeless" />
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime value="20221103" />
                            <value xsi:type="CD" code="451381000124107"
                                codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"
                                displayName="Smokeless tobacco non-user"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                            <author>
                                <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                    extension="2019-10-01" />
                                <time value="20221103" />
                                <assignedAuthor>
                                    <id root="1.2.840.114350.1.13.2.2.7.1.1133"
                                        extension="799835920" />
                                    <id root="1.2.840.114350.1.13.2.2.7.2.697780" extension="C53425" />
                                    <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                </assignedAuthor>
                            </author>
                        </observation>
                    </entry>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.38" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38"
                                extension="2015-08-01" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.1040.12"
                                extension="Z28967392^55114.98^897148007" />
                            <code code="897148007" codeSystem="2.16.840.1.113883.6.96"
                                codeSystemName="SNOMED CT" displayName="Alcoholic beverage intake">
                                <translation code="11331-6" codeSystem="2.16.840.1.113883.6.1"
                                    codeSystemName="LOINC" displayName="History of Alcohol Use" />
                            </code>
                            <statusCode code="completed" />
                            <effectiveTime value="20221103" />
                            <value xsi:type="CD" code="219006" codeSystem="2.16.840.1.113883.6.96"
                                codeSystemName="SNOMED CT"
                                displayName="Current drinker of alcohol (finding)"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                <originalText>
                                    <reference value="#alcoholStatus" />
                                </originalText>
                            </value>
                        </observation>
                    </entry>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.38" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38"
                                extension="2015-08-01" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38"
                                extension="2022-06-01" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.1040.21"
                                extension="5753506626-97003-Z28967392" />
                            <code code="8689-2" codeSystem="2.16.840.1.113883.6.1"
                                codeSystemName="LOINC" displayName="History of Social function" />
                            <statusCode code="completed" />
                            <effectiveTime value="20221103" />
                            <entryRelationship typeCode="SPRT">
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.69" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.69"
                                        extension="2022-06-01" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.83687972"
                                        extension="5753506626-97003-Z28967392" />
                                    <code code="88028-6" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC" displayName="Tobacco use panel">
                                        <originalText>Patient History</originalText>
                                    </code>
                                    <text>
                                        <reference nullFlavor="UNK" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103" />
                                    <value nullFlavor="UNK" xsi:type="CD"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <interpretationCode nullFlavor="OTH">
                                        <originalText>Low Risk </originalText>
                                        <translation code="X-SDOH-RISK-1"
                                            codeSystem="1.2.840.114350.1.72.1.8.1"
                                            codeSystemName="Epic.Sdoh" displayName="Low Risk " />
                                    </interpretationCode>
                                    <entryRelationship typeCode="COMP">
                                        <observation classCode="OBS" moodCode="EVN">
                                            <templateId root="2.16.840.1.113883.10.20.22.4.86" />
                                            <templateId root="2.16.840.1.113883.10.20.22.4.86"
                                                extension="2022-06-01" />
                                            <id root="1.2.840.114350.1.13.2.2.7.1.83687972"
                                                extension="cer97028-5753506626-97003-Z28967392" />
                                            <code code="72166-2" codeSystem="2.16.840.1.113883.6.1"
                                                codeSystemName="LOINC"
                                                displayName="Tobacco smoking status NHIS">
                                                <originalText>Smoking Tobacco Use</originalText>
                                            </code>
                                            <statusCode code="completed" />
                                            <value xsi:type="CD" code="LA18978-9"
                                                codeSystem="2.16.840.1.113883.6.1"
                                                codeSystemName="LOINC" displayName="Never smoker"
                                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                                <originalText>Never</originalText>
                                                <translation code="8392000"
                                                    codeSystem="2.16.840.1.113883.6.96"
                                                    codeSystemName="SNOMED CT"
                                                    displayName="Non-smoker (finding)" />
                                            </value>
                                        </observation>
                                    </entryRelationship>
                                    <entryRelationship typeCode="COMP">
                                        <observation classCode="OBS" moodCode="EVN">
                                            <templateId root="2.16.840.1.113883.10.20.22.4.86" />
                                            <templateId root="2.16.840.1.113883.10.20.22.4.86"
                                                extension="2022-06-01" />
                                            <id root="1.2.840.114350.1.13.2.2.7.1.83687972"
                                                extension="cer97078-5753506626-97003-Z28967392" />
                                            <code code="88031-0" codeSystem="2.16.840.1.113883.6.1"
                                                codeSystemName="LOINC"
                                                displayName="Smokeless tobacco status">
                                                <originalText>Smokeless Tobacco Use</originalText>
                                            </code>
                                            <statusCode code="completed" />
                                            <value xsi:type="CD" code="LA4519-0"
                                                codeSystem="2.16.840.1.113883.6.1"
                                                codeSystemName="LOINC" displayName="Never used"
                                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                                <originalText>Never</originalText>
                                                <translation code="228512004"
                                                    codeSystem="2.16.840.1.113883.6.96"
                                                    codeSystemName="SNOMED CT"
                                                    displayName="Never chewed tobacco (finding)" />
                                            </value>
                                        </observation>
                                    </entryRelationship>
                                    <entryRelationship typeCode="COMP">
                                        <observation classCode="OBS" moodCode="EVN">
                                            <templateId root="2.16.840.1.113883.10.20.22.4.86" />
                                            <templateId root="2.16.840.1.113883.10.20.22.4.86"
                                                extension="2022-06-01" />
                                            <id root="1.2.840.114350.1.13.2.2.7.1.83687972"
                                                extension="cer97148-5753506626-97003-Z28967392" />
                                            <code nullFlavor="UNK">
                                                <originalText>Passive Exposure</originalText>
                                            </code>
                                            <statusCode code="completed" />
                                            <value nullFlavor="OTH" xsi:type="CD"
                                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                                <originalText>Not on file</originalText>
                                            </value>
                                        </observation>
                                    </entryRelationship>
                                </observation>
                            </entryRelationship>
                        </observation>
                    </entry>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.38" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38"
                                extension="2015-08-01" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38"
                                extension="2022-06-01" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.1040.21"
                                extension="5753506626-100018-Z28967392" />
                            <code code="8689-2" codeSystem="2.16.840.1.113883.6.1"
                                codeSystemName="LOINC" displayName="History of Social function" />
                            <statusCode code="completed" />
                            <effectiveTime value="20221103" />
                            <entryRelationship typeCode="SPRT">
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.69" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.69"
                                        extension="2022-06-01" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.83687972"
                                        extension="5753506626-100018-Z28967392" />
                                    <code nullFlavor="UNK">
                                        <originalText>Inadequate Housing</originalText>
                                    </code>
                                    <text>
                                        <reference value="#sdohassess2" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103" />
                                    <value nullFlavor="UNK" xsi:type="CD"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <interpretationCode nullFlavor="OTH">
                                        <originalText>Not on file</originalText>
                                        <translation code="X-SDOH-RISK-0"
                                            codeSystem="1.2.840.114350.1.72.1.8.1"
                                            codeSystemName="Epic.Sdoh" displayName="Unknown" />
                                    </interpretationCode>
                                    <entryRelationship typeCode="COMP">
                                        <observation classCode="OBS" moodCode="EVN">
                                            <templateId root="2.16.840.1.113883.10.20.22.4.86" />
                                            <templateId root="2.16.840.1.113883.10.20.22.4.86"
                                                extension="2022-06-01" />
                                            <id root="1.2.840.114350.1.13.2.2.7.1.83687972"
                                                extension="cer21060003-5753506626-100018-Z28967392" />
                                            <code nullFlavor="UNK">
                                                <originalText>
                                                    <reference value="#sdohassess2pair1ques" />
                                                </originalText>
                                            </code>
                                            <text>
                                                <reference value="#sdohassess2pair1" />
                                            </text>
                                            <statusCode code="completed" />
                                            <value nullFlavor="OTH" xsi:type="CD"
                                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                                <originalText>
                                                    <reference value="#sdohassess2pair1ans" />
                                                </originalText>
                                            </value>
                                        </observation>
                                    </entryRelationship>
                                </observation>
                            </entryRelationship>
                        </observation>
                    </entry>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.38" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38"
                                extension="2015-08-01" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.1040.5"
                                extension="Z28967392^66416^11351-4" />
                            <code code="11351-4" codeSystem="2.16.840.1.113883.6.1"
                                codeSystemName="LOINC" displayName="History of sexual behavior" />
                            <statusCode code="completed" />
                            <effectiveTime value="20221103" />
                            <value xsi:type="CD" code="228453005"
                                codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"
                                displayName="Sexually active"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                        </observation>
                    </entry>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.200"
                                extension="2016-06-01" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.1040.20" extension="Z28967392" />
                            <code code="76689-9" codeSystem="2.16.840.1.113883.6.1"
                                codeSystemName="LOINC" displayName="Sex assigned at birth" />
                            <text>
                                <reference value="#BirthSex12" />
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime value="19851016" />
                            <value nullFlavor="UNK" xsi:type="CD" codeSystem="2.16.840.1.113883.5.1"
                                codeSystemName="HL7 Gender"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                <originalText>
                                    <reference value="#BirthSex12Value" />
                                </originalText>
                            </value>
                        </observation>
                    </entry>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.34.3.45"
                                extension="2022-06-01" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38"
                                extension="2015-08-01" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.1040.46" extension="Z28967392" />
                            <code code="76691-5" codeSystem="2.16.840.1.113883.6.1"
                                codeSystemName="LOINC" displayName="Gender identity" />
                            <text>
                                <reference value="#GenderIdentity10" />
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime>
                                <low nullFlavor="UNK" />
                            </effectiveTime>
                            <value nullFlavor="UNK" xsi:type="CD"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                <originalText>
                                    <reference value="#GenderIdentity10Value" />
                                </originalText>
                            </value>
                        </observation>
                    </entry>
                    <entry>
                        <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.501"
                                extension="2022-06-01" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.38"
                                extension="2015-08-01" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.1040.45" extension="Z28967392.1" />
                            <code code="76690-7" codeSystem="2.16.840.1.113883.6.1"
                                codeSystemName="LOINC" displayName="Sexual orientation" />
                            <text>
                                <reference value="#SexualOrientation11" />
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime>
                                <low nullFlavor="UNK" />
                            </effectiveTime>
                            <value nullFlavor="UNK" xsi:type="CD"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                <originalText>
                                    <reference value="#SexualOrientation11Value" />
                                </originalText>
                            </value>
                        </observation>
                    </entry>
                </section>
            </component>
            <component>
                <section>
                    <templateId root="2.16.840.1.113883.10.20.22.2.4" />
                    <templateId root="2.16.840.1.113883.10.20.22.2.4" extension="2015-08-01" />
                    <code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"
                        displayName="Vital signs" />
                    <title>Last Filed Vital Signs</title>
                    <text>
                        <table>
                            <colgroup>
                                <col width="25%" span="4" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Vital Sign</th>
                                    <th>Reading</th>
                                    <th>Time Taken</th>
                                    <th>Comments</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr styleCode="xRowNormal">
                                    <td styleCode="xcellHeader">Blood Pressure</td>
                                    <td><content ID="sysBP_5738405100">102</content>/<content
                                            ID="diaBP_5738405100">80</content></td>
                                    <td>11/03/2022 12:25 PM CDT</td>
                                    <td />
                                </tr>
                                <tr ID="pulse_5738405100" styleCode="xRowAlt">
                                    <td styleCode="xcellHeader">Pulse</td>
                                    <td>95</td>
                                    <td>11/03/2022 12:25 PM CDT</td>
                                    <td />
                                </tr>
                                <tr ID="temp_5738405100" styleCode="xRowNormal">
                                    <td styleCode="xcellHeader">Temperature</td>
                                    <td>36.6 °C (97.9 °F)</td>
                                    <td>11/03/2022 12:25 PM CDT</td>
                                    <td />
                                </tr>
                                <tr ID="resp_5738405100" styleCode="xRowAlt">
                                    <td styleCode="xcellHeader">Respiratory Rate</td>
                                    <td>16</td>
                                    <td>11/03/2022 12:25 PM CDT</td>
                                    <td />
                                </tr>
                                <tr ID="SpO2_5738405100" styleCode="xRowNormal">
                                    <td styleCode="xcellHeader">Oxygen Saturation</td>
                                    <td>96%</td>
                                    <td>11/03/2022 12:25 PM CDT</td>
                                    <td />
                                </tr>
                                <tr ID="inhaled_" styleCode="xRowAlt">
                                    <td styleCode="xcellHeader">Inhaled Oxygen Concentration</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td />
                                </tr>
                                <tr ID="weight_5738405100" styleCode="xRowNormal">
                                    <td styleCode="xcellHeader">Weight</td>
                                    <td>108.3 kg (238 lb 10.4 oz)</td>
                                    <td>11/03/2022 12:25 PM CDT</td>
                                    <td />
                                </tr>
                                <tr ID="height_5738405100" styleCode="xRowAlt">
                                    <td styleCode="xcellHeader">Height</td>
                                    <td>190.5 cm (6' 3")</td>
                                    <td>11/03/2022 12:25 PM CDT</td>
                                    <td />
                                </tr>
                                <tr ID="bmi_5738405100" styleCode="xRowNormal">
                                    <td styleCode="xcellHeader">Body Mass Index</td>
                                    <td>29.83</td>
                                    <td>11/03/2022 12:25 PM CDT</td>
                                    <td />
                                </tr>
                            </tbody>
                        </table>
                        <footnote ID="subTitle15" styleCode="xSectionSubTitle">documented in this
                            encounter</footnote>
                    </text>
                    <entry typeCode="DRIV">
                        <organizer classCode="CLUSTER" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.26" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.26"
                                extension="2015-08-01" />
                            <id root="1.2.840.114350.1.13.2.2.7.1.2109"
                                extension="5738405100-Z28967392" />
                            <code code="46680005" codeSystem="2.16.840.1.113883.6.96"
                                codeSystemName="SNOMED CT" displayName="Vital signs">
                                <translation code="74728-7" codeSystem="2.16.840.1.113883.6.1"
                                    codeSystemName="LOINC"
                                    displayName="Vital signs, weight, height, head circumference, oximetry, BMI, and BSA panel - HL7.CCDAr1.1" />
                            </code>
                            <statusCode code="completed" />
                            <effectiveTime value="20221103172500+0000" />
                            <component>
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.2109.1"
                                        extension="5738405100-sysBP-Z28967392" />
                                    <code code="8480-6" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC">
                                        <originalText>Systolic blood pressure</originalText>
                                    </code>
                                    <text>
                                        <reference value="#sysBP_5738405100" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103172500+0000" />
                                    <value xsi:type="PQ" value="102" unit="mm[Hg]"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103122925-0500" />
                                        <assignedAuthor>
                                            <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                            <addr nullFlavor="UNK" />
                                            <telecom nullFlavor="UNK" />
                                            <representedOrganization>
                                                <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                    extension="2800" />
                                                <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                                <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                                <name>Advocate Aurora Health</name>
                                                <addr use="WP">
                                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                                    <city>Milwaukee</city>
                                                    <state>WI</state>
                                                    <postalCode>53215</postalCode>
                                                    <country>USA</country>
                                                </addr>
                                            </representedOrganization>
                                        </assignedAuthor>
                                    </author>
                                </observation>
                            </component>
                            <component>
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.2109.1"
                                        extension="5738405100-diaBP-Z28967392" />
                                    <code code="8462-4" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC">
                                        <originalText>Diastolic blood pressure</originalText>
                                    </code>
                                    <text>
                                        <reference value="#diaBP_5738405100" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103172500+0000" />
                                    <value xsi:type="PQ" value="80" unit="mm[Hg]"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103122925-0500" />
                                        <assignedAuthor>
                                            <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                            <addr nullFlavor="UNK" />
                                            <telecom nullFlavor="UNK" />
                                            <representedOrganization>
                                                <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                    extension="2800" />
                                                <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                                <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                                <name>Advocate Aurora Health</name>
                                                <addr use="WP">
                                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                                    <city>Milwaukee</city>
                                                    <state>WI</state>
                                                    <postalCode>53215</postalCode>
                                                    <country>USA</country>
                                                </addr>
                                            </representedOrganization>
                                        </assignedAuthor>
                                    </author>
                                </observation>
                            </component>
                            <component>
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.2109.1"
                                        extension="5738405100-pulse-Z28967392" />
                                    <code code="8867-4" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC">
                                        <originalText>Heart rate</originalText>
                                    </code>
                                    <text>
                                        <reference value="#pulse_5738405100" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103172500+0000" />
                                    <value xsi:type="PQ" value="95" unit="/min"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103122925-0500" />
                                        <assignedAuthor>
                                            <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                            <addr nullFlavor="UNK" />
                                            <telecom nullFlavor="UNK" />
                                            <representedOrganization>
                                                <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                    extension="2800" />
                                                <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                                <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                                <name>Advocate Aurora Health</name>
                                                <addr use="WP">
                                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                                    <city>Milwaukee</city>
                                                    <state>WI</state>
                                                    <postalCode>53215</postalCode>
                                                    <country>USA</country>
                                                </addr>
                                            </representedOrganization>
                                        </assignedAuthor>
                                    </author>
                                </observation>
                            </component>
                            <component>
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.2109.1"
                                        extension="5738405100-tempC83-Z28967392" />
                                    <code code="8310-5" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC">
                                        <originalText>Body temperature</originalText>
                                    </code>
                                    <text>
                                        <reference value="#temp_5738405100" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103172500+0000" />
                                    <value xsi:type="PQ" value="36.61" unit="Cel"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103122925-0500" />
                                        <assignedAuthor>
                                            <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                            <addr nullFlavor="UNK" />
                                            <telecom nullFlavor="UNK" />
                                            <representedOrganization>
                                                <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                    extension="2800" />
                                                <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                                <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                                <name>Advocate Aurora Health</name>
                                                <addr use="WP">
                                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                                    <city>Milwaukee</city>
                                                    <state>WI</state>
                                                    <postalCode>53215</postalCode>
                                                    <country>USA</country>
                                                </addr>
                                            </representedOrganization>
                                        </assignedAuthor>
                                    </author>
                                </observation>
                            </component>
                            <component>
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.2109.1"
                                        extension="5738405100-resp-Z28967392" />
                                    <code code="9279-1" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC">
                                        <originalText>Respiratory rate</originalText>
                                    </code>
                                    <text>
                                        <reference value="#resp_5738405100" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103172500+0000" />
                                    <value xsi:type="PQ" value="16" unit="/min"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103122550-0500" />
                                        <assignedAuthor>
                                            <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                            <addr nullFlavor="UNK" />
                                            <telecom nullFlavor="UNK" />
                                            <representedOrganization>
                                                <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                    extension="2800" />
                                                <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                                <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                                <name>Advocate Aurora Health</name>
                                                <addr use="WP">
                                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                                    <city>Milwaukee</city>
                                                    <state>WI</state>
                                                    <postalCode>53215</postalCode>
                                                    <country>USA</country>
                                                </addr>
                                            </representedOrganization>
                                        </assignedAuthor>
                                    </author>
                                </observation>
                            </component>
                            <component>
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.2109.1"
                                        extension="5738405100-heightC83-Z28967392" />
                                    <code code="8302-2" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC">
                                        <originalText>Body height</originalText>
                                    </code>
                                    <text>
                                        <reference value="#height_5738405100" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103172500+0000" />
                                    <value xsi:type="PQ" value="190.5" unit="cm"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103122550-0500" />
                                        <assignedAuthor>
                                            <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                            <addr nullFlavor="UNK" />
                                            <telecom nullFlavor="UNK" />
                                            <representedOrganization>
                                                <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                    extension="2800" />
                                                <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                                <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                                <name>Advocate Aurora Health</name>
                                                <addr use="WP">
                                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                                    <city>Milwaukee</city>
                                                    <state>WI</state>
                                                    <postalCode>53215</postalCode>
                                                    <country>USA</country>
                                                </addr>
                                            </representedOrganization>
                                        </assignedAuthor>
                                    </author>
                                </observation>
                            </component>
                            <component>
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.2109.1"
                                        extension="5738405100-weightC83-Z28967392" />
                                    <code code="29463-7" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC">
                                        <originalText>Body weight</originalText>
                                    </code>
                                    <text>
                                        <reference value="#weight_5738405100" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103172500+0000" />
                                    <value xsi:type="PQ" value="108.25" unit="kg"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103122550-0500" />
                                        <assignedAuthor>
                                            <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                            <addr nullFlavor="UNK" />
                                            <telecom nullFlavor="UNK" />
                                            <representedOrganization>
                                                <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                    extension="2800" />
                                                <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                                <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                                <name>Advocate Aurora Health</name>
                                                <addr use="WP">
                                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                                    <city>Milwaukee</city>
                                                    <state>WI</state>
                                                    <postalCode>53215</postalCode>
                                                    <country>USA</country>
                                                </addr>
                                            </representedOrganization>
                                        </assignedAuthor>
                                    </author>
                                </observation>
                            </component>
                            <component>
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.2109.1"
                                        extension="5738405100-bmi-Z28967392" />
                                    <code code="39156-5" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC">
                                        <originalText>BMI</originalText>
                                    </code>
                                    <text>
                                        <reference value="#bmi_5738405100" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103172500+0000" />
                                    <value xsi:type="PQ" value="29.83" unit="kg/m2"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103122550-0500" />
                                        <assignedAuthor>
                                            <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                            <addr nullFlavor="UNK" />
                                            <telecom nullFlavor="UNK" />
                                            <representedOrganization>
                                                <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                    extension="2800" />
                                                <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                                <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                                <name>Advocate Aurora Health</name>
                                                <addr use="WP">
                                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                                    <city>Milwaukee</city>
                                                    <state>WI</state>
                                                    <postalCode>53215</postalCode>
                                                    <country>USA</country>
                                                </addr>
                                            </representedOrganization>
                                        </assignedAuthor>
                                    </author>
                                </observation>
                            </component>
                            <component>
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.27"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.1.2109.1"
                                        extension="5738405100-SpO2-Z28967392" />
                                    <code code="59408-5" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC">
                                        <originalText>Oxygen saturation in Arterial blood by Pulse
                                            oximetry</originalText>
                                    </code>
                                    <text>
                                        <reference value="#SpO2_5738405100" />
                                    </text>
                                    <statusCode code="completed" />
                                    <effectiveTime value="20221103172500+0000" />
                                    <value xsi:type="PQ" value="96" unit="%"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103122925-0500" />
                                        <assignedAuthor>
                                            <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                            <addr nullFlavor="UNK" />
                                            <telecom nullFlavor="UNK" />
                                            <representedOrganization>
                                                <id root="1.2.840.114350.1.13.2.2.7.2.688879"
                                                    extension="2800" />
                                                <id root="2.16.840.1.113883.4.2" nullFlavor="UNK" />
                                                <id root="2.16.840.1.113883.4.6" nullFlavor="UNK" />
                                                <name>Advocate Aurora Health</name>
                                                <addr use="WP">
                                                    <streetAddressLine>750 West Virginia Street</streetAddressLine>
                                                    <city>Milwaukee</city>
                                                    <state>WI</state>
                                                    <postalCode>53215</postalCode>
                                                    <country>USA</country>
                                                </addr>
                                            </representedOrganization>
                                        </assignedAuthor>
                                    </author>
                                </observation>
                            </component>
                        </organizer>
                    </entry>
                </section>
            </component>
            <component>
                <section>
                    <templateId root="2.16.840.1.113883.10.20.22.2.45" />
                    <templateId root="2.16.840.1.113883.10.20.22.2.45" extension="2014-06-09" />
                    <id root="00000000-50A4-89A4-20C6-F66CC71BA1BA" />
                    <code code="69730-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"
                        displayName="Instructions" />
                    <title>Patient Instructions</title>
                    <text>
                        <list ID="Instructions21" styleCode="xTOC">
                            <item>
                                <caption>Attachments</caption>
                                <paragraph styleCode="Bold">The following attachments cannot be sent
                                    through Care Everywhere.</paragraph>
                                <list>
                                    <item>Antibiotics, When to Use (English)</item>
                                    <item>Sinusitis (Antibiotic Treatment) (English)</item>
                                </list>
                            </item>
                        </list>
                        <footnote ID="subTitle20" styleCode="xSectionSubTitle">documented in this
                            encounter</footnote>
                    </text>
                    <entry>
                        <act classCode="ACT" moodCode="INT">
                            <templateId root="2.16.840.1.113883.10.20.22.4.20" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.20"
                                extension="2014-06-09" />
                            <code code="311401005" codeSystem="2.16.840.1.113883.6.96"
                                codeSystemName="SNOMED CT" displayName="Patient Education" />
                            <text>
                                <reference value="#Instructions21" />
                            </text>
                            <statusCode code="completed" />
                        </act>
                    </entry>
                </section>
            </component>
            <component>
                <section>
                    <templateId root="1.2.840.114350.1.72.2.10144" />
                    <code code="66149-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"
                        displayName="Prescribed medications" />
                    <title>Ordered Prescriptions</title>
                    <text>
                        <table>
                            <colgroup>
                                <col width="25%" span="2" />
                                <col width="13%" />
                                <col width="12%" span="2" />
                                <col width="13%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Prescription</th>
                                    <th>Sig</th>
                                    <th>Dispensed</th>
                                    <th>Refills</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr styleCode="xRowNormal">
                                    <td>
                                        <paragraph ID="med24">doxycycline hyclate (VIBRAMYCIN) 100
                                            MG capsule</paragraph>
                                        <content styleCode="xallIndent">Indications: <content
                                                ID="indication25">Acute bacterial sinusitis</content></content>
                                    </td>
                                    <td ID="sig24">Take 1 capsule by mouth in the morning and 1
                                        capsule in the evening. Do all this for 10 days.</td>
                                    <td>
                                        <paragraph>20 capsule</paragraph>
                                    </td>
                                    <td />
                                    <td>11/03/2022</td>
                                    <td>11/13/2022</td>
                                </tr>
                            </tbody>
                        </table>
                        <footnote ID="subTitle23" styleCode="xSectionSubTitle">documented in this
                            encounter</footnote>
                    </text>
                    <entry>
                        <substanceAdministration classCode="SBADM" moodCode="INT">
                            <templateId root="2.16.840.1.113883.10.20.22.4.16" />
                            <templateId root="2.16.840.1.113883.10.20.22.4.16"
                                extension="2014-06-09" />
                            <id root="1.2.840.114350.1.13.2.2.7.2.798268" extension="15626790004" />
                            <text>
                                <reference value="#sig24" />
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime xsi:type="IVL_TS"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                <low value="20221103" />
                                <high value="20221114055900+0000" />
                            </effectiveTime>
                            <routeCode code="C38288" codeSystem="2.16.840.1.113883.3.26.1.1"
                                codeSystemName="NCI Thesaurus" displayName="Oral">
                                <originalText>Oral</originalText>
                            </routeCode>
                            <doseQuantity unit="mg" value="100" />
                            <consumable nullFlavor="true" typeCod="CSM">
                                <manufacturedProduct classCode="MANU">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.23" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.23"
                                        extension="2014-06-09" />
                                    <manufacturedMaterial>
                                        <code code="1649988" codeSystem="2.16.840.1.113883.6.88"
                                            codeSystemName="RxNorm">
                                            <originalText>
                                                <reference value="#med24" />
                                            </originalText>
                                            <translation code="0143-3142-50"
                                                codeSystem="2.16.840.1.113883.6.69"
                                                codeSystemName="NDC" />
                                            <translation code="7065"
                                                codeSystem="2.16.840.1.113883.6.253"
                                                codeSystemName="Medispan Drug Descriptor ID" />
                                            <translation code="04000020100110"
                                                codeSystem="2.16.840.1.113883.6.68"
                                                codeSystemName="Medi-Span Generic Product Identifier" />
                                            <translation code="7065"
                                                codeSystem="2.16.840.1.113883.6.162"
                                                codeSystemName="Med-File (Medi-Span)" />
                                        </code>
                                    </manufacturedMaterial>
                                </manufacturedProduct>
                            </consumable>
                            <author>
                                <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                    extension="2019-10-01" />
                                <time value="20221103123637-0500" />
                                <assignedAuthor>
                                    <id root="1.2.840.114350.1.13.2.2.7.1.1133"
                                        extension="151651478" />
                                    <id root="2.16.840.1.113883.4.6" extension="1447424932" />
                                </assignedAuthor>
                            </author>
                            <entryRelationship typeCode="RSON">
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.19" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.19"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.6.798268.180"
                                        extension="15626790004.1" />
                                    <code code="282291009" codeSystem="2.16.840.1.113883.6.96"
                                        codeSystemName="SNOMED CT" />
                                    <text>Acute bacterial sinusitis<reference value="#indication25" /></text>
                                    <statusCode code="completed" />
                                    <value xsi:type="CD" code="75498004"
                                        codeSystem="2.16.840.1.113883.6.96"
                                        codeSystemName="SNOMED CT"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                </observation>
                            </entryRelationship>
                            <entryRelationship typeCode="SUBJ" inversionInd="true">
                                <act classCode="ACT" moodCode="INT">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.20" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.20"
                                        extension="2014-06-09" />
                                    <code code="311401005" codeSystem="2.16.840.1.113883.6.96"
                                        codeSystemName="SNOMED CT" />
                                    <text>
                                        <reference value="#sig24" />
                                    </text>
                                    <statusCode code="completed" />
                                    <author>
                                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                        <templateId root="2.16.840.1.113883.10.20.22.5.6"
                                            extension="2019-10-01" />
                                        <time value="20221103123637-0500" />
                                        <assignedAuthor>
                                            <id root="1.2.840.114350.1.13.2.2.7.1.1133"
                                                extension="151651478" />
                                            <id root="2.16.840.1.113883.4.6" extension="1447424932" />
                                        </assignedAuthor>
                                    </author>
                                </act>
                            </entryRelationship>
                            <entryRelationship typeCode="REFR">
                                <supply classCode="SPLY" moodCode="INT">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.17" />
                                    <templateId root="2.16.840.1.113883.10.20.22.4.17"
                                        extension="2014-06-09" />
                                    <id root="1.2.840.114350.1.13.2.2.7.2.798268"
                                        extension="15626790004" />
                                    <statusCode code="completed" />
                                    <repeatNumber nullFlavor="OTH" />
                                    <quantity value="20" />
                                    <product>
                                        <manufacturedProduct classCode="MANU">
                                            <templateId root="2.16.840.1.113883.10.20.22.4.23" />
                                            <templateId root="2.16.840.1.113883.10.20.22.4.23"
                                                extension="2014-06-09" />
                                            <manufacturedMaterial>
                                                <code code="1649988"
                                                    codeSystem="2.16.840.1.113883.6.88"
                                                    codeSystemName="RxNorm">
                                                    <originalText>
                                                        <reference value="#med24" />
                                                    </originalText>
                                                    <translation code="0143-3142-50"
                                                        codeSystem="2.16.840.1.113883.6.69"
                                                        codeSystemName="NDC" />
                                                    <translation code="7065"
                                                        codeSystem="2.16.840.1.113883.6.253"
                                                        codeSystemName="Medispan Drug Descriptor ID" />
                                                    <translation code="04000020100110"
                                                        codeSystem="2.16.840.1.113883.6.68"
                                                        codeSystemName="Medi-Span Generic Product Identifier" />
                                                    <translation code="7065"
                                                        codeSystem="2.16.840.1.113883.6.162"
                                                        codeSystemName="Med-File (Medi-Span)" />
                                                </code>
                                            </manufacturedMaterial>
                                        </manufacturedProduct>
                                    </product>
                                </supply>
                            </entryRelationship>
                            <entryRelationship typeCode="REFR">
                                <observation classCode="OBS" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.1.47" />
                                    <code code="33999-4" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC" displayName="Status" />
                                    <statusCode code="completed" />
                                    <value xsi:type="CE" code="73425007"
                                        codeSystem="2.16.840.1.113883.6.96"
                                        codeSystemName="SNOMED CT" displayName="No Longer Active"
                                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
                                </observation>
                            </entryRelationship>
                            <entryRelationship typeCode="COMP">
                                <substanceAdministration classCode="SBADM" moodCode="INT">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.147" />
                                    <code code="76662-6" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC" displayName="Medication Instructions" />
                                    <text>
                                        <reference value="#sig24" />
                                    </text>
                                    <consumable>
                                        <manufacturedProduct>
                                            <manufacturedLabeledDrug nullFlavor="NA" />
                                        </manufacturedProduct>
                                    </consumable>
                                </substanceAdministration>
                            </entryRelationship>
                        </substanceAdministration>
                    </entry>
                </section>
            </component>
        </structuredBody>
    </component>
</ClinicalDocument>`;

@test:Config {}
function testPatientToCcda() returns error? {
    // Example patient resource
    uscore501:USCorePatientProfile examplePatient = {
        id: "example-patient-1",
        identifier: [
            {
                system: "http://hospital.example.org/identifiers/patient",
                value: "MRN12345"
            }
        ],
        name: [
            {
                family: "Smith",
                given: ["John", "Michael"]
            }
        ],
        gender: "male",
        birthDate: "1990-05-15"
    };

    r4:Bundle fhirBundle = {
        resourceType: "Bundle",
        entry: [
            {
                'resource: examplePatient
            }
        ]
        ,
        'type: "collection"
    };

    ContinuityofCareDocumentCCD|error ccdDoc = fhirToCcda(fhirBundle);
    if ccdDoc is error {
        log:printError("Error converting FHIR to CCDA: " + ccdDoc.message());
        return;
    }
    log:printInfo("Converted CCDA Document: ", ccdaDoc = ccdDoc);
    xml result = check xmldata:toXml(ccdDoc, {textFieldName: "xmlText"});
    log:printInfo("Converted CCDA Document: ", ccdaDoc = result);
}

@test:Config {}
function testAllergyToCcda() returns error? {
    // Example patient resource
    uscore501:USCoreAllergyIntolerance exampleAllergy = {
        code: {
            coding: [
                {
                    system: "http://snomed.info/sct",
                    code: "373873005",
                    display: "Pharmaceutical / biologic product"
                }
            ]
        },
        patient: {
            reference: "Patient/123"
        }
    };

    r4:Bundle fhirBundle = {
        resourceType: "Bundle",
        entry: [
            {
                'resource: exampleAllergy
            }
        ]
        ,
        'type: "collection"
    };

    ContinuityofCareDocumentCCD|error ccdDoc = fhirToCcda(fhirBundle);
    if ccdDoc is error {
        log:printError("Error converting FHIR to CCDA: " + ccdDoc.message());
        return;
    }
    log:printInfo("Converted CCDA Document for Allergy: ", ccdaDoc = ccdDoc);
    xml result = check xmldata:toXml(ccdDoc, {textFieldName: "xmlText"});
    log:printInfo("Converted CCDA Document for Allergy: ", ccdaDoc = result);
}
