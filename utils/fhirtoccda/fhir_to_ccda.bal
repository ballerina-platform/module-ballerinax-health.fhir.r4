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

// --------------------------------------------------------------------------------------------#
// Source FHIR to C-CDA - Resource Mappings
// --------------------------------------------------------------------------------------------#

import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;
    // import ballerina/data.xmldata;
import ballerina/uuid;

# Transform FHIR resources to C-CDA format.
#
# + bundle - FHIR Bundle containing resources to be transformed
# + customMapper - Custom mapper to be used for the transformation
# + return - C-CDA document as ContinuityofCareDocumentCCD
public isolated function fhirToCcda(r4:Bundle bundle, FhirToCcdaMapper? customMapper = ()) returns ContinuityofCareDocumentCCD|r4:FHIRError {
    r4:BundleEntry[]? entries = bundle?.entry;
    r4:Resource[] fhirResources = [];
    if entries != () {
        foreach r4:BundleEntry entry in entries {
            fhirResources.push(<r4:Resource>entry?.'resource);
        }
    }
    if customMapper == () {
        return transformToCcda(fhirResources, defaultMapper);
    }
    FhirToCcdaMapper mapper = {...defaultMapper};
    foreach string key in customMapper.keys() {
        mapper[key] = customMapper.get(key);
    }
    return transformToCcda(fhirResources, mapper);
}

isolated function transformToCcda(r4:Resource[] fhirResources, FhirToCcdaMapper? customMapper = ()) returns ContinuityofCareDocumentCCD {
    FhirToCcdaMapper mapper;

    lock {
        mapper = customMapper != () ? customMapper : defaultMapper;
    }

    // Find patient resource
    uscore501:USCorePatientProfile? patient = ();
    foreach r4:Resource 'resource in fhirResources {
        if 'resource is uscore501:USCorePatientProfile {
            patient = 'resource;
            break;
        }
    }

    if patient == () {
        return createEmptyCcda();
    }

    // Transform patient to C-CDA recordTarget
    FhirToPatient fhirToPatient = mapper.fhirToPatient;
    RecordTarget[] recordTargets = [];
    RecordTarget? recordTarget = fhirToPatient(patient, fhirResources);
    if recordTarget != () {
        recordTargets.push(recordTarget);
    }

    // Transform allergy intolerance resources
    FhirToAllergyIntolerance fhirToAllergyIntolerance = mapper.fhirToAllergyIntolerance;
    Act[] allergyActs = [];
    foreach r4:Resource 'resource in fhirResources {
        if 'resource is uscore501:USCoreAllergyIntolerance {
            Act? allergyAct = fhirToAllergyIntolerance('resource, fhirResources);
            if allergyAct != () {
                allergyActs.push(allergyAct);
            }
        }
    }

    // Create C-CDA document structure
    ContinuityofCareDocumentCCD ccda = {
        clinicalDocType: "ContinuityofCareDocumentCCD",
        classCode: "DOCCLIN",
        moodCode: "EVN",
        realmCode: {code: "US"},
        typeId: {root: "2.16.840.1.113883.1.3", extension: "POCD_HD000040"},
        templateId: [
            {root: "2.16.840.1.113883.10.20.22.1.2"},
            {root: "2.16.840.1.113883.10.20.22.1.2", extension: "2015-08-01"}
        ],
        id: {root: generateUUID()},
        code: {code: "34133-9", codeSystem: "2.16.840.1.113883.6.1", displayName: "Summarization of Episode Note"},
        title: {xmlText: "Continuity of Care Document"},
        statusCode: {code: "active"},
        effectiveTime: {value: getCurrentDateTime()},
        confidentialityCode: {code: "N", codeSystem: "2.16.840.1.113883.5.25"},
        languageCode: {code: "en-US"},
        recordTarget: recordTargets,
        author: [], // Will be populated based on available practitioner resources
        custodian: (),
        component: createAllergyActComponent(allergyActs)
    };

    return ccda;
}

isolated function createEmptyCcda() returns ContinuityofCareDocumentCCD {
    return {
        clinicalDocType: "ContinuityofCareDocumentCCD",
        classCode: "DOCCLIN",
        moodCode: "EVN",
        realmCode: {code: "US"},
        typeId: {root: "2.16.840.1.113883.1.3", extension: "POCD_HD000040"},
        templateId: [
            {root: "2.16.840.1.113883.10.20.22.1.2"},
            {root: "2.16.840.1.113883.10.20.22.1.2", extension: "2015-08-01"}
        ],
        id: {root: generateUUID()},
        code: {code: "34133-9", codeSystem: "2.16.840.1.113883.6.1", displayName: "Summarization of Episode Note"},
        title: {xmlText: "Continuity of Care Document"},
        statusCode: {code: "active"},
        effectiveTime: {value: getCurrentDateTime()},
        confidentialityCode: {code: "N", codeSystem: "2.16.840.1.113883.5.25"},
        languageCode: {code: "en-US"},
        recordTarget: [],
        author: [],
        custodian: (),
        component: createDefaultComponent()
    };
}

isolated function createDefaultCustodian() returns Custodian {
    return {
        assignedCustodian: {
            representedCustodianOrganization: {
                id: [{root: generateUUID()}],
                name: {xmlText: "Default Healthcare Organization"},
                addr: (),
                telecom: []
            }
        }
    };
}

isolated function createDefaultComponent() returns Component {
    return {
        structuredBody: {
            component: []
        }
    };
}

isolated function createAllergyActComponent(Act[] allergyActs) returns Component {
    Component component = createDefaultComponent();
    Section section = {
        code: {
            code: "48765-2",
            codeSystem: "2.16.840.1.113883.6.1",
            displayName: "Allergy Intolerance"
        },
        entry: []
    };
    component.structuredBody.component = [
        {
            section: section
        }
    ];
    foreach Act allergyAct in allergyActs {
        (<Entry[]>section.entry).push({
            act: allergyAct
        });
    }
    return component;
}


isolated function generateUUID() returns string {
    return "urn:uuid:" + uuid:createType4AsString();
}

isolated function getCurrentDateTime() returns string {
    // Return current date time in HL7 format
    return "20250101000000";
} 