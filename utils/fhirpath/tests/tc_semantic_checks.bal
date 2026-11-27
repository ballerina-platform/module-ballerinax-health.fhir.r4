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

// The official FHIRPath test suite's semantic (static type) checks (group isSemanticChecks): type tests narrow the
// possible types of $this for the operand they guard. Each expression is evaluated in strict mode with every
// Observation.effective node as its focus; contextType declares the focus type for the checks while evaluation
// uses the (dateTime) data in the example. Verified with the conformance tooling in scripts/conformance.
function getSemanticChecksTestCases() returns FHIRPathTestCase[] {
    return [
        {
            name: "test_isEffectOnLogic1Base",
            group: "isSemanticChecks",
            expression: "$this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective"
        },
        {
            name: "test_isEffectOnLogic2Base",
            group: "isSemanticChecks",
            expression: "$this.toString().length() > 10",
            resourceKey: "observation",
            expected: [false],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "dateTime"
        },
        {
            name: "test_isEffectOnLogic3Base",
            group: "isSemanticChecks",
            expression: "$this.toString().length() > 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isEffectOnLogic1",
            group: "isSemanticChecks",
            expression: "$this is dateTime implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective"
        },
        {
            name: "test_isEffectOnLogic2",
            group: "isSemanticChecks",
            expression: "$this is dateTime implies $this.toString().length() > 10",
            resourceKey: "observation",
            expected: [false],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "dateTime"
        },
        {
            name: "test_isEffectOnLogic3",
            group: "isSemanticChecks",
            expression: "$this is dateTime implies $this.toString().length() > 10",
            resourceKey: "observation",
            expected: [false],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardFnImplies",
            group: "isSemanticChecks",
            expression: "$this.is(dateTime) implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardFnImpliesBad",
            group: "isSemanticChecks",
            expression: "$this.is(Period) implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|Timing"
        },
        {
            name: "test_isGuardImpliesBad",
            group: "isSemanticChecks",
            expression: "$this is Period implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|Timing"
        },
        {
            name: "test_isGuardImpliesEmpty",
            group: "isSemanticChecks",
            expression: "$this is dateTime implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|Timing"
        },
        {
            name: "test_isGuardOrTypesImplies",
            group: "isSemanticChecks",
            expression: "($this is dateTime or $this is instant) implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOrTypesImpliesBad",
            group: "isSemanticChecks",
            expression: "($this is dateTime or $this is Period) implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOrTypesImpliesAll",
            group: "isSemanticChecks",
            expression: "($this is dateTime or $this is Period) implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective"
        },
        {
            name: "test_isGuardOrFnTypesImpliesBad",
            group: "isSemanticChecks",
            expression: "($this.is(dateTime) or $this.is(Period)) implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardAndOtherImplies",
            group: "isSemanticChecks",
            expression: "($this is dateTime and %resource.status = 'final') implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOtherAndImplies",
            group: "isSemanticChecks",
            expression: "(%resource.status = 'final' and $this is dateTime) implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOrOtherImpliesBad",
            group: "isSemanticChecks",
            expression: "($this is dateTime or %resource.status = 'final') implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOrOtherImpliesNoParensBad",
            group: "isSemanticChecks",
            expression: "$this is dateTime or %resource.status = 'final' implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOrInnerImplies",
            group: "isSemanticChecks",
            expression: "$this is Period or (%resource.status = 'final' implies $this.toString().length() >= 10)",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOrInnerImpliesBad",
            group: "isSemanticChecks",
            expression: "$this is Period or (%resource.status = 'final' implies $this.toString().length() >= 10)",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|Timing"
        },
        {
            name: "test_isGuardAnd",
            group: "isSemanticChecks",
            expression: "$this is dateTime and $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardAndBad",
            group: "isSemanticChecks",
            expression: "$this is Period and $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|Timing"
        },
        {
            name: "test_isGuardOr",
            group: "isSemanticChecks",
            expression: "$this is Period or $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOr2",
            group: "isSemanticChecks",
            expression: "$this is Period or $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|dateTime"
        },
        {
            name: "test_isGuardOrBad",
            group: "isSemanticChecks",
            expression: "$this is Period or $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|Timing"
        },
        {
            name: "test_isGuardOrBoth",
            group: "isSemanticChecks",
            expression: "$this is Period or $this is Timing or $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|Timing"
        },
        {
            name: "test_isGuardXorBad",
            group: "isSemanticChecks",
            expression: "$this is dateTime xor $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardXorBad2",
            group: "isSemanticChecks",
            expression: "$this is dateTime xor $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [false],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|dateTime"
        },
        {
            name: "test_isGuardNotImplies",
            group: "isSemanticChecks",
            expression: "($this is Period).not() implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardNotImpliesBad",
            group: "isSemanticChecks",
            expression: "($this is Period).not() implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|Timing"
        },
        {
            name: "test_isGuardIifTrue",
            group: "isSemanticChecks",
            expression: "iif($this is dateTime, $this.toString().length() >= 10, true)",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardIifElse",
            group: "isSemanticChecks",
            expression: "iif($this is Period, true, $this.toString().length() >= 10)",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardIifBad",
            group: "isSemanticChecks",
            expression: "iif($this is Period, $this.toString().length() >= 10, true)",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardNested",
            group: "isSemanticChecks",
            expression: "$this is Period implies ($this is dateTime implies $this.toString().length() >= 10)",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period|Timing"
        },
        {
            name: "test_isGuardSupertypeBad",
            group: "isSemanticChecks",
            expression: "$this is Element implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOtherExpressionBad",
            group: "isSemanticChecks",
            expression: "$this.start is dateTime implies $this.toString().length() >= 10",
            resourceKey: "observation",
            expected: [],
            expectError: true,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardOfType",
            group: "isSemanticChecks",
            expression: "$this.ofType(dateTime).toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        },
        {
            name: "test_isGuardAs",
            group: "isSemanticChecks",
            expression: "($this as dateTime).toString().length() >= 10",
            resourceKey: "observation",
            expected: [true],
            expectError: false,
            strict: true,
            context: "Observation.effective",
            contextType: "Period"
        }
    ];
}
