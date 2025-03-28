# C-CDA to FHIR Package

Package containing C-CDA to FHIR pre-built mapping functionalities. 

## Package Overview

This package implements the CCDA to FHIR implementation guide (http://build.fhir.org/ig/HL7/ccda-on-fhir/CF-index.html).

1) C-CDA Allergy Intolerance Observation to FHIR USCore Allergy Intolerance Profile.
2) C-CDA Problem observation to FHIR USCore Condition Profile.
3) C-CDA Results to FHIR USCore Diagnostic Report Profile.
4) C-CDA Immunization Activity to FHIR USCore Immunization Profile. 
5) C-CDA Medication Activity to FHIR USCore Medication Profile.
6) C-CDA Patient Role Header to FHIR USCore Patient Profile.
7) C-CDA Author Header to FHIR USCore Practitioner Profile.
8) C-CDA Procedure Activity to FHIR USCore Procedure Profile.

## Usage

To use the package add following import to your Ballerina program.
```ballerina
import ballerinax/health.fhir.r4utils.ccdatofhir
```

This sample showcase how you can pass a C-CDA message and get a
FHIR R4 Bundle in return.

```ballerina
import ballerina/io;
import ballerinax/health.fhir.r4utils.ccdatofhir;
import ballerinax/health.fhir.r4;

xml msg = xml `<ClinicalDocument xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3" xmlns:voc="urn:hl7-org:v3/voc"        xmlns:sdtc="urn:hl7-org:sdtc">
        <realmCode code="US"/>
        <typeId extension="POCD_HD000040" root="2.16.840.1.113883.1.3"/>
        <templateId root="2.16.840.1.113883.10.20.22.1.2" extension="2014-06-09"/>
        <id extension="EHRVersion2.0" root="be84a8e4-a22e-4210-a4a6-b3c48273e84c"/>
        <code code="34133-9" displayName="Summary of episode note" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
        <title>Summary of Patient Chart</title>
        <effectiveTime value="20141015103026-0500"/>
        <component>
            <structuredBody>
                <component>
                    <section>
                        <templateId root="2.16.840.1.113883.10.20.22.2.5.1" extension="2014-06-09"/>
                        <code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="PROBLEM LIST"/>
                        <title>PROBLEMS</title>
                        <text>Problem Information</text>
                        <entry>
                            <act classCode="ACT" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.22.4.3" extension="2015-08-01" />
                                <templateId root="2.16.840.1.113883.10.20.22.4.3" />
                                <id extension="34689300001" root="1.3.6.1.4.1.22812.3.2009316.3.4.1" />
                                <code code="CONC" codeSystem="2.16.840.1.113883.5.6" />
                                <statusCode code="active" />
                                <effectiveTime xsi:type="IVL_TS">
                                    <low nullFlavor="NI" />
                                </effectiveTime>
                                <entryRelationship typeCode="SUBJ">
                                    <observation classCode="OBS" moodCode="EVN">
                                        <templateId root="2.16.840.1.113883.10.20.22.4.4" extension="2015-08-01" />
                                        <templateId root="2.16.840.1.113883.10.20.22.4.4" />
                                        <id extension="545069300001" root="1.3.6.1.4.1.22812.3.2009316.3.4.1.2.1" />
                                        <code code="55607006" codeSystem="2.16.840.1.113883.6.96">
                                            <translation nullFlavor="NI" />
                                        </code>
                                        <text>
                                            <reference value="#_5011447a-e27f-471d-9e1f-541148c5282f" />
                                        </text>
                                        <statusCode code="completed" />
                                        <effectiveTime xsi:type="IVL_TS">
                                            <low value="20120806" />
                                        </effectiveTime>
                                        <value xsi:type="CD" code="233604007" codeSystem="2.16.840.1.113883.6.96">
                                            <originalText>
                                                <!-- This reference resolves to: Pneumonia -->
                                                <reference value="#_5011447a-e27f-471d-9e1f-541148c5282f" />
                                            </originalText>
                                            <translation code="486" codeSystem="2.16.840.1.113883.6.103" />
                                            <translation code="J18.9" codeSystem="2.16.840.1.113883.6.90" />
                                            <translation code="87580" codeSystem="2.16.840.1.113883.3.247.1.1" />
                                        </value>
                                    </observation>
                                </entryRelationship>
                            </act>
                        </entry>
                    </section>
                </component>
            </structuredBody>
        </component>
    </ClinicalDocument>`;

public function main() returns error? {
    // Transform C-CDA message to FHIR R4.
    // You can pass a C-CDA message and get a FHIR R4 Bundle based on
    // the mappings defined at
    // http://build.fhir.org/ig/HL7/ccda-on-fhir/CF-index.html.

    r4:Bundle ccdatofhirResult = check ccdatofhir:ccdaToFhir(msg);
    io:println("Transformed FHIR message: ", ccdatofhirResult.toString());
}
```
