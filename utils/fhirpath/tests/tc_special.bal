// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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

function getSpecialTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testHasTemplateId2",
            group: "cdaTests",
            expression: "ClinicalDocument.hasTemplateIdOf('http://hl7.org/cda/us/ccda/StructureDefinition/ContinuityofCareDocumentCCD')",
            resourceKey: "ccda",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testHasTemplateId3",
            group: "cdaTests",
            expression: "recordTarget.patientRole.hasTemplateIdOf('http://hl7.org/cda/us/ccda/StructureDefinition/ContinuityofCareDocumentCCD')",
            resourceKey: "ccda",
            expected: [false],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testIndex",
            group: "index-part",
            expression: "Patient.telecom.select(iif(value='(03) 3410 5613', $index, {} ))",
            resourceKey: "patient",
            expected: [2],
            expectError: false
        },
        {
            name: "test_from_zulip_1",
            group: "from-Zulip",
            expression: "(true and 'foo').empty()",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_from_zulip_2",
            group: "from-Zulip",
            expression: "(true | 'foo').allTrue()",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testContainedId",
            group: "miscEngineTests",
            expression: "contained.id",
            resourceKey: "patient_container",
            expected: ["1"],
            expectError: false
        },
        {
            name: "test_testMultipleResolve",
            group: "miscEngineTests",
            expression: "composition.exists() implies ( composition.resolve().section.entry.reference.where(resolve() is Observation) .where($this in (%resource.result.reference | %resource.result.reference.resolve().hasMember.reference)).exists() )",
            resourceKey: "diagnosticreport",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testPrimitiveExtensions",
            group: "miscEngineTests",
            expression: "Patient.name.given.select($this.hasValue())",
            resourceKey: "patient_name_ext",
            expected: [false, true],
            expectError: false
        },
        {
            name: "test_testPrimitiveExtensionsElement",
            group: "miscEngineTests",
            expression: "Patient.name.given.select($this.hasValue())",
            resourceKey: "patient_name_ext",
            expected: [false, true],
            expectError: false
        }
    ];
}
