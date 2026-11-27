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

// Typed values and FHIR model information (System literal types, FHIR types from navigation,
// implicit FHIR → System conversions)
function getModelTypesTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_modelLongLiteralType",
            group: "testModelTypes",
            expression: "1L.type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_modelLongLiteralIs",
            group: "testModelTypes",
            expression: "1L.is(System.Long)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_modelLongLiteralOutput",
            group: "testModelTypes",
            expression: "1L",
            resourceKey: "patient",
            expected: [1],
            expectError: false
        },
        {
            name: "test_modelNegatedLongType",
            group: "testModelTypes",
            expression: "(-1L).type().name",
            resourceKey: "patient",
            expected: ["Long"],
            expectError: false
        },
        {
            name: "test_modelDateLiteralType",
            group: "testModelTypes",
            expression: "@2014-01-25.type().name",
            resourceKey: "patient",
            expected: ["Date"],
            expectError: false
        },
        {
            name: "test_modelDateTimeLiteralType",
            group: "testModelTypes",
            expression: "@2014-01-25T10:30.type().name",
            resourceKey: "patient",
            expected: ["DateTime"],
            expectError: false
        },
        {
            name: "test_modelTimeLiteralType",
            group: "testModelTypes",
            expression: "@T10:30.type().name",
            resourceKey: "patient",
            expected: ["Time"],
            expectError: false
        },
        {
            name: "test_modelQuantityLiteralType",
            group: "testModelTypes",
            expression: "(4.5 'mg').type().namespace + '.' + (4.5 'mg').type().name",
            resourceKey: "patient",
            expected: ["System.Quantity"],
            expectError: false
        },
        {
            name: "test_modelQuantityLiteralIsQuantity",
            group: "testModelTypes",
            expression: "(4.5 'mg').is(Quantity)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_modelStringLiteralNotDate",
            group: "testModelTypes",
            expression: "'2014-01-25'.is(Date)",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_modelPrimitiveType",
            group: "testModelTypes",
            expression: "Patient.birthDate.type().name",
            resourceKey: "patient",
            expected: ["date"],
            expectError: false
        },
        {
            name: "test_modelPrimitiveNamespace",
            group: "testModelTypes",
            expression: "Patient.birthDate.type().namespace",
            resourceKey: "patient",
            expected: ["FHIR"],
            expectError: false
        },
        {
            name: "test_modelComplexType",
            group: "testModelTypes",
            expression: "Patient.name.first().type().name",
            resourceKey: "patient",
            expected: ["HumanName"],
            expectError: false
        },
        {
            name: "test_modelBackboneType",
            group: "testModelTypes",
            expression: "Patient.contact.first().type().name",
            resourceKey: "patient",
            expected: ["BackboneElement"],
            expectError: false
        },
        {
            name: "test_modelBackboneChildType",
            group: "testModelTypes",
            expression: "Patient.contact.first().name.type().name",
            resourceKey: "patient",
            expected: ["HumanName"],
            expectError: false
        },
        {
            name: "test_modelChoiceType",
            group: "testModelTypes",
            expression: "Observation.value.type().name",
            resourceKey: "observation",
            expected: ["Quantity"],
            expectError: false
        },
        {
            name: "test_modelChoiceExpandedNameType",
            group: "testModelTypes",
            expression: "Observation.valueQuantity.type().name",
            resourceKey: "observation",
            expected: ["Quantity"],
            expectError: false
        },
        {
            name: "test_modelResourceBaseType",
            group: "testModelTypes",
            expression: "Patient.type().baseType",
            resourceKey: "patient",
            expected: ["FHIR.DomainResource"],
            expectError: false
        },
        {
            name: "test_modelIsInheritedResource",
            group: "testModelTypes",
            expression: "Patient.is(Resource)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_modelIsInheritedElement",
            group: "testModelTypes",
            expression: "Patient.name.first().is(Element)",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_modelIsPrimitiveNotSystem",
            group: "testModelTypes",
            expression: "Patient.birthDate.is(Date)",
            resourceKey: "patient",
            expected: [false],
            expectError: false
        },
        {
            name: "test_modelOfTypeComplexBase",
            group: "testModelTypes",
            expression: "Patient.name.ofType(Element).count()",
            resourceKey: "patient",
            expected: [3],
            expectError: false
        },
        {
            name: "test_modelContentReferenceType",
            group: "testModelTypes",
            expression: "Questionnaire.item.item.first().type().name",
            resourceKey: "questionnaire",
            expected: ["BackboneElement"],
            expectError: false
        },
        {
            name: "test_modelContentReferenceNavigation",
            group: "testModelTypes",
            expression: "Questionnaire.item.item.item.linkId.first()",
            resourceKey: "questionnaire",
            expected: ["1.1.1"],
            expectError: false
        },
        {
            name: "test_modelFhirDateLessThan",
            group: "testModelTypes",
            expression: "Patient.birthDate < @2000-01-01",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_modelFhirDateArithmetic",
            group: "testModelTypes",
            expression: "(Patient.birthDate + 1 year) = @1975-12-25",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_modelFhirDateArithmeticType",
            group: "testModelTypes",
            expression: "(Patient.birthDate + 1 year).type().name",
            resourceKey: "patient",
            expected: ["Date"],
            expectError: false
        },
        {
            name: "test_modelFhirDateToString",
            group: "testModelTypes",
            expression: "Patient.birthDate.toString()",
            resourceKey: "patient",
            expected: ["1974-12-25"],
            expectError: false
        },
        {
            name: "test_modelDateTimeVsDateCompare",
            group: "testModelTypes",
            expression: "@2015-02-04T14:34 > @2014-01-01",
            resourceKey: "patient",
            expected: [true],
            expectError: false
        },
        {
            name: "test_modelDateTimeVsDateUncertain",
            group: "testModelTypes",
            expression: "@2014-01-01T14:34 > @2014-01-01",
            resourceKey: "patient",
            expected: [],
            expectError: false
        },
        {
            name: "test_modelChoiceOutputUnchanged",
            group: "testModelTypes",
            expression: "Observation.value",
            resourceKey: "observation",
            expected: [{"value": 185, "unit": "lbs", "system": "http://unitsofmeasure.org", "code": "[lb_av]"}],
            expectError: false
        },
        {
            name: "test_modelDefineVariableCollection",
            group: "testModelTypes",
            expression: "Patient.defineVariable('g', name.given).select(%g.count())",
            resourceKey: "patient",
            expected: [5],
            expectError: false
        }
    ];
}
