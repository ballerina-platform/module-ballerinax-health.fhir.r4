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

function getNavigationTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_testPolymorphismA",
            group: "testObservations",
            expression: "Observation.value.unit",
            resourceKey: "observation",
            expected: ["lbs"],
            expectError: false
        },
        {
            name: "test_testPolymorphismB",
            group: "testObservations",
            expression: "Observation.valueQuantity.unit",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testPolymorphismIsA1",
            group: "testObservations",
            expression: "Observation.value.is(Quantity)",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testPolymorphismIsA2",
            group: "testObservations",
            expression: "Observation.value is Quantity",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testPolymorphismIsA3",
            group: "testObservations",
            expression: "Observation.issued is instant",
            resourceKey: "observation",
            expected: [],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testPolymorphismIsB",
            group: "testObservations",
            expression: "Observation.value.is(Period).not()",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPolymorphismAsA",
            group: "testObservations",
            expression: "Observation.value.as(Quantity).unit",
            resourceKey: "observation",
            expected: ["lbs"],
            expectError: false
        },
        {
            name: "test_testPolymorphismAsAFunction",
            group: "testObservations",
            expression: "(Observation.value as Quantity).unit",
            resourceKey: "observation",
            expected: ["lbs"],
            expectError: false
        },
        {
            name: "test_testPolymorphismAsB",
            group: "testObservations",
            expression: "(Observation.value as Period).unit",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testPolymorphismAsBFunction",
            group: "testObservations",
            expression: "Observation.value.as(Period).start",
            resourceKey: "observation",
            expected: [],
            expectError: false
        },
        {
            name: "test_testPolymorphicsA",
            group: "polymorphics",
            expression: "Observation.value.exists()",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPolymorphicsC",
            group: "polymorphics",
            expression: "Observation.valueQuantity.exists()",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testPolymorphicsD",
            group: "polymorphics",
            expression: "Observation.valueString.exists()",
            resourceKey: "observation",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testFHIRPathIsFunction1",
            group: "testInheritance",
            expression: "Patient.gender.is(code)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFHIRPathIsFunction2",
            group: "testInheritance",
            expression: "Patient.gender.is(string)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFHIRPathIsFunction3",
            group: "testInheritance",
            expression: "Patient.gender.is(id)",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testFHIRPathIsFunction4",
            group: "testInheritance",
            expression: "Questionnaire.url.is(uri)",
            resourceKey: "questionnaire",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFHIRPathIsFunction5",
            group: "testInheritance",
            expression: "Questionnaire.url.is(url)",
            resourceKey: "questionnaire",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testFHIRPathIsFunction6",
            group: "testInheritance",
            expression: "ValueSet.version.is(string)",
            resourceKey: "valueset",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFHIRPathIsFunction7",
            group: "testInheritance",
            expression: "ValueSet.version.is(code)",
            resourceKey: "valueset",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testFHIRPathIsFunction8",
            group: "testInheritance",
            expression: "Observation.extension('http://example.com/fhir/StructureDefinition/patient-age').value is Age",
            resourceKey: "observation",
            expected: [true],
            expectError: false
        },
        {
            name: "test_testFHIRPathIsFunction9",
            group: "testInheritance",
            expression: "Observation.extension('http://example.com/fhir/StructureDefinition/patient-age').value is Quantity",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            // TODO: enable once implementation supports this
            disabled: true
        },
        {
            name: "test_testFHIRPathIsFunction10",
            group: "testInheritance",
            expression: "Observation.extension('http://example.com/fhir/StructureDefinition/patient-age').value is Duration",
            resourceKey: "observation",
            expected: [false],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction11",
            group: "testInheritance",
            expression: "Patient.gender.as(string)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction12",
            group: "testInheritance",
            expression: "Patient.gender.as(code)",
            resourceKey: "patient",
            expected: ["male"],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction13",
            group: "testInheritance",
            expression: "Patient.gender.as(id)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction14",
            group: "testInheritance",
            expression: "ValueSet.version.as(string)",
            resourceKey: "valueset",
            expected: ["20150622"],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction15",
            group: "testInheritance",
            expression: "ValueSet.version.as(code)",
            resourceKey: "valueset",
            expected: [],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction16",
            group: "testInheritance",
            expression: "Patient.gender.ofType(string)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction17",
            group: "testInheritance",
            expression: "Patient.gender.ofType(code)",
            resourceKey: "patient",
            expected: ["male"],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction18",
            group: "testInheritance",
            expression: "Patient.gender.ofType(id)",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction19",
            group: "testInheritance",
            expression: "ValueSet.version.ofType(string)",
            resourceKey: "valueset",
            expected: ["20150622"],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction20",
            group: "testInheritance",
            expression: "ValueSet.version.ofType(code)",
            resourceKey: "valueset",
            expected: [],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction21",
            group: "testInheritance",
            expression: "Patient.name.as(HumanName).use",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testFHIRPathAsFunction22",
            group: "testInheritance",
            expression: "Patient.name.ofType(HumanName).use",
            resourceKey: "patient",
            expected: ["official", "usual", "maiden"],
            expectError: false
        },
        {
            name: "test_testFHIRPathAsFunction23",
            group: "testInheritance",
            expression: "Patient.gender.as(string1)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testFHIRPathAsFunction24",
            group: "testInheritance",
            expression: "Patient.gender.ofType(string1)",
            resourceKey: "patient",
            expected: [],
            expectError: true
        },
        {
            name: "test_testPatientTelecomTypes",
            group: "testMiscellaneousAccessorTests",
            expression: "telecom.use",
            resourceKey: "patient",
            expected: ["home", "work", "mobile", "old"],
            expectError: false
        }
    ];
}
