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

import ballerina/test;

@test:Config {}
function testValidateSimpleValidPaths() {
    // Test basic valid FHIR paths
    test:assertTrue(validateFhirPath("Patient.id"), "Simple path should be valid");
    test:assertTrue(validateFhirPath("Patient.active"), "Boolean field path should be valid");
    test:assertTrue(validateFhirPath("Patient.gender"), "String field path should be valid");
    test:assertTrue(validateFhirPath("Observation.status"), "Different resource type should be valid");
    test:assertTrue(validateFhirPath("Medication.code"), "Another resource type should be valid");
}

@test:Config {}
function testValidateNestedValidPaths() {
    // Test nested field access
    test:assertTrue(validateFhirPath("Patient.managingOrganization.reference"), "Nested path should be valid");
    test:assertTrue(validateFhirPath("Patient.contact.name.family"), "Deep nested path should be valid");
    test:assertTrue(validateFhirPath("Observation.component.code.coding"), "Complex nested path should be valid");
    test:assertTrue(validateFhirPath("Patient.address.line.value"), "Multi-level nested path should be valid");
}

@test:Config {}
function testValidateArrayAccessValidPaths() {
    // Test array access patterns
    test:assertTrue(validateFhirPath("Patient.name[0]"), "Simple array access should be valid");
    test:assertTrue(validateFhirPath("Patient.name[0].given[0]"), "Nested array access should be valid");
    test:assertTrue(validateFhirPath("Patient.address[1].line[2]"), "Multiple array access should be valid");
    test:assertTrue(validateFhirPath("Patient.contact[0].telecom[1].value"), "Complex array access should be valid");
    test:assertTrue(validateFhirPath("Observation.component[10].valueQuantity"), "Large index should be valid");
}

@test:Config {}
function testValidateComplexValidPaths() {
    // Test complex combinations
    test:assertTrue(validateFhirPath("Patient.name[0].given"), "Array access with field should be valid");
    test:assertTrue(validateFhirPath("Patient.address[0].line[0].extension[0].valueString"), "Very complex path should be valid");
    test:assertTrue(validateFhirPath("Bundle.entry[0].resource.Patient.name[0].family"), "Bundle resource path should be valid");
    test:assertTrue(validateFhirPath("DiagnosticReport.result[0].reference"), "Reference path should be valid");
}

@test:Config {}
function testValidateResourceTypeVariations() {
    // Test different valid resource type formats
    test:assertTrue(validateFhirPath("Patient123.id"), "Resource type with numbers should be valid");
    test:assertTrue(validateFhirPath("Patient_Custom.id"), "Resource type with underscore should be valid");
    test:assertTrue(validateFhirPath("MyCustomResource.field"), "Custom resource type should be valid");
    test:assertTrue(validateFhirPath("A.field"), "Single letter resource type should be valid");
    test:assertTrue(validateFhirPath("Resource_123_Test.field"), "Complex resource type should be valid");
}

@test:Config {}
function testValidateFieldNameVariations() {
    // Test different valid field name formats
    test:assertTrue(validateFhirPath("Patient.field123"), "Field with numbers should be valid");
    test:assertTrue(validateFhirPath("Patient.field_name"), "Field with underscore should be valid");
    test:assertTrue(validateFhirPath("Patient.a"), "Single letter field should be valid");
    test:assertTrue(validateFhirPath("Patient.customField_123"), "Complex field name should be valid");
    test:assertTrue(validateFhirPath("Patient.UPPERCASE_FIELD"), "Uppercase field should be valid");
}

@test:Config {}
function testValidateEmptyAndWhitespaceInvalidPaths() {
    // Test empty and whitespace cases
    test:assertFalse(validateFhirPath(""), "Empty string should be invalid");
    test:assertFalse(validateFhirPath("   "), "Whitespace only should be invalid");
    test:assertFalse(validateFhirPath("\t"), "Tab only should be invalid");
    test:assertFalse(validateFhirPath("\n"), "Newline only should be invalid");
    test:assertFalse(validateFhirPath("  \t\n  "), "Mixed whitespace should be invalid");
}

@test:Config {}
function testValidateMissingDotInvalidPaths() {
    // Test paths without required dot notation
    test:assertFalse(validateFhirPath("Patient name"), "Space instead of dot should be invalid");
    test:assertFalse(validateFhirPath("Patient-name"), "Dash instead of dot should be invalid");
}

@test:Config {}
function testValidateInvalidResourceTypeFormats() {
    // Test invalid resource type formats
    test:assertFalse(validateFhirPath("123Patient.id"), "Resource type starting with number should be invalid");
    test:assertFalse(validateFhirPath("_Patient.id"), "Resource type starting with underscore should be invalid");
    test:assertFalse(validateFhirPath("-Patient.id"), "Resource type starting with dash should be invalid");
    test:assertFalse(validateFhirPath(".Patient.id"), "Resource type starting with dot should be invalid");
    test:assertFalse(validateFhirPath("Patient-.id"), "Resource type ending with dash should be invalid");
    test:assertFalse(validateFhirPath("Patient..id"), "Double dot should be invalid");
}

@test:Config {}
function testValidateInvalidFieldNameFormats() {
    // Test invalid field name formats
    test:assertFalse(validateFhirPath("Patient.123field"), "Field starting with number should be invalid");
    test:assertFalse(validateFhirPath("Patient._field"), "Field starting with underscore should be invalid");
    test:assertFalse(validateFhirPath("Patient.-field"), "Field starting with dash should be invalid");
    test:assertFalse(validateFhirPath("Patient.field-name"), "Field with dash should be invalid");
    test:assertFalse(validateFhirPath("Patient.field."), "Field ending with dot should be invalid");
    test:assertFalse(validateFhirPath("Patient..field"), "Double dot before field should be invalid");
}

@test:Config {}
function testValidateInvalidArrayAccessFormats() {
    // Test invalid array access syntax
    test:assertFalse(validateFhirPath("Patient.name[]"), "Empty brackets should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[abc]"), "Non-numeric index should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[-1]"), "Negative index should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[0"), "Missing closing bracket should be invalid");
    test:assertFalse(validateFhirPath("Patient.name0]"), "Missing opening bracket should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[0.5]"), "Decimal index should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[0][1]"), "Double brackets should be invalid");
}

@test:Config {}
function testValidateSpecialCharacterInvalidPaths() {
    // Test paths with special characters
    test:assertFalse(validateFhirPath("Patient.name@field"), "At symbol should be invalid");
    test:assertFalse(validateFhirPath("Patient.name#field"), "Hash symbol should be invalid");
    test:assertFalse(validateFhirPath("Patient.name$field"), "Dollar symbol should be invalid");
    test:assertFalse(validateFhirPath("Patient.name%field"), "Percent symbol should be invalid");
    test:assertFalse(validateFhirPath("Patient.name&field"), "Ampersand should be invalid");
    test:assertFalse(validateFhirPath("Patient.name*field"), "Asterisk should be invalid");
    test:assertFalse(validateFhirPath("Patient.name+field"), "Plus should be invalid");
    test:assertFalse(validateFhirPath("Patient.name=field"), "Equals should be invalid");
}

@test:Config {}
function testValidateWhitespaceInPathsInvalidPaths() {
    // Test paths with whitespace in inappropriate places
    test:assertFalse(validateFhirPath("Patient .id"), "Space before dot should be invalid");
    test:assertFalse(validateFhirPath("Patient. id"), "Space after dot should be invalid");
    test:assertFalse(validateFhirPath("Patient.i d"), "Space in field name should be invalid");
    test:assertFalse(validateFhirPath("Pat ient.id"), "Space in resource type should be invalid");
    test:assertFalse(validateFhirPath("Patient.name [0]"), "Space before bracket should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[ 0]"), "Space after opening bracket should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[0 ]"), "Space before closing bracket should be invalid");
}

@test:Config {}
function testValidateMalformedNestedPathsInvalidPaths() {
    // Test malformed nested paths
    test:assertFalse(validateFhirPath("Patient.name..family"), "Double dot in nested path should be invalid");
    test:assertFalse(validateFhirPath("Patient.name."), "Trailing dot should be invalid");
    test:assertFalse(validateFhirPath(".Patient.name"), "Leading dot should be invalid");
    test:assertFalse(validateFhirPath("Patient.name.[0]"), "Dot before bracket should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[0]."), "Trailing dot after bracket should be invalid");
}

@test:Config {}
function testValidateComplexInvalidCombinations() {
    // Test complex invalid combinations
    test:assertFalse(validateFhirPath("Patient.name[0]field"), "Missing dot after bracket should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[0.field"), "Malformed bracket should be invalid");
    test:assertFalse(validateFhirPath("Patient.name0].field"), "Malformed bracket should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[0][field]"), "Mixed bracket types should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[field][0]"), "Mixed bracket types should be invalid");
}

@test:Config {}
function testValidateUnicodeAndSpecialCasesInvalidPaths() {
    // Test unicode and special cases - using proper string literals
    test:assertFalse(validateFhirPath("Patient.naïve"), "Unicode characters should be invalid");
    test:assertFalse(validateFhirPath("Patient.名前"), "Non-ASCII characters should be invalid");
    test:assertFalse(validateFhirPath("Patient.field" + string `\u{0000}`), "Null character should be invalid");
    test:assertFalse(validateFhirPath("Patient.field\t"), "Tab character should be invalid");
    test:assertFalse(validateFhirPath("Patient.field\n"), "Newline character should be invalid");
}

@test:Config {}
function testValidateBoundaryConditions() {
    // Test boundary conditions
    test:assertTrue(validateFhirPath("A.b"), "Minimal valid path should be valid");
    test:assertTrue(validateFhirPath("Patient.name[0]"), "Single array access should be valid");
    test:assertTrue(validateFhirPath("Patient.name[999999]"), "Large array index should be valid");

    // Test very long but valid paths
    string longValidPath = "Patient.contact[0].organization[0].identifier[0].type[0].coding[0].system";
    test:assertTrue(validateFhirPath(longValidPath), "Long valid path should be valid");

    // Test invalid boundary cases
    test:assertFalse(validateFhirPath("A."), "Resource type with trailing dot should be invalid");
}

@test:Config {}
function testValidateEdgeCasesWithNumbers() {
    // Test edge cases with numbers in different positions
    test:assertTrue(validateFhirPath("Patient1.field2"), "Numbers in names should be valid");
    test:assertTrue(validateFhirPath("Resource123.field456"), "Multiple numbers should be valid");
    test:assertTrue(validateFhirPath("Patient.field[123456789]"), "Large number index should be valid");

    // Invalid number cases
    test:assertFalse(validateFhirPath("1Patient.field"), "Number at start of resource should be invalid");
    test:assertFalse(validateFhirPath("Patient.2field"), "Number at start of field should be invalid");
}

@test:Config {}
function testValidateArrayIndexEdgeCases() {
    // Test array index edge cases
    test:assertTrue(validateFhirPath("Patient.name[0]"), "Zero index should be valid");
    test:assertTrue(validateFhirPath("Patient.name[1]"), "Single digit index should be valid");
    test:assertTrue(validateFhirPath("Patient.name[10]"), "Double digit index should be valid");
    test:assertTrue(validateFhirPath("Patient.name[100]"), "Triple digit index should be valid");

    // Invalid array index cases
    test:assertFalse(validateFhirPath("Patient.name[ ]"), "Space in brackets should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[+1]"), "Plus sign in index should be invalid");
}

@test:Config {}
function testValidateMultipleArrayAccess() {
    // Test multiple array access patterns
    test:assertTrue(validateFhirPath("Patient.name[0].given[1]"), "Multiple array access should be valid");
    test:assertTrue(validateFhirPath("Patient.address[0].line[0].extension[1].valueString"), "Complex multiple array access should be valid");
    test:assertTrue(validateFhirPath("Bundle.entry[0].resource[1].identifier[2].value"), "Deep array access should be valid");

    // Invalid multiple array access
    test:assertFalse(validateFhirPath("Patient.name[0]given[1]"), "Missing dot between array accesses should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[0].[1]"), "Dot before second bracket should be invalid");
    test:assertFalse(validateFhirPath("Patient.name[0][1].given"), "Adjacent brackets should be invalid");
}

@test:Config {}
function testValidateRegexPatternBoundaries() {
    // Test regex pattern boundaries specifically
    test:assertTrue(validateFhirPath("A.b"), "Shortest valid path should pass");
    test:assertTrue(validateFhirPath("Z9_.z9_[999]"), "All valid characters should pass");

    // Test pattern start/end boundaries
    test:assertFalse(validateFhirPath(" Patient.id"), "Leading space should fail");
    test:assertFalse(validateFhirPath("Patient.id "), "Trailing space should fail");
    test:assertFalse(validateFhirPath("Patient.id\r"), "Carriage return should fail");
    test:assertFalse(validateFhirPath("Patient.id\r\n"), "CRLF should fail");
}
