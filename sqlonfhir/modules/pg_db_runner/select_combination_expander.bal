// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import mahima_de_silva/sql_on_fhir_lib;

# Expand all possible `unionAll` combinations from a sql_on_fhir_lib:ViewDefinition's select array.
#
# The result is the Cartesian product of union choices across all select elements.
# Each `SelectCombination` records which union branch was taken for each element
# (-1 = no union, >= 0 = index into that element's `unionAll` array).
#
# + selects - top-level select elements from the sql_on_fhir_lib:ViewDefinition
# + return - every possible combination of union choices
isolated function expandCombinations(sql_on_fhir_lib:ViewDefinitionSelect[] selects) returns SelectCombination[] {
    SelectCombination[] combinations = [{selects: [], unionChoices: []}];
    foreach sql_on_fhir_lib:ViewDefinitionSelect sel in selects {
        combinations = expandSelectCombinations(sel, combinations);
    }
    return combinations;
}

# Expand combinations for a single select element against all current combinations.
#
# + sel - the select element to expand
# + currentCombinations - combinations accumulated so far
# + return - updated combinations with `sel` appended to each
isolated function expandSelectCombinations(
        sql_on_fhir_lib:ViewDefinitionSelect sel,
        SelectCombination[] currentCombinations) returns SelectCombination[] {

    SelectCombination[] newCombinations = [];
    foreach SelectCombination combination in currentCombinations {
        sql_on_fhir_lib:ViewDefinitionSelect[]? unionAll = sel.unionAll;
        if unionAll is sql_on_fhir_lib:ViewDefinitionSelect[] && unionAll.length() > 0 {
            SelectCombination[] expanded = expandUnionAllOptions(sel, unionAll, combination);
            foreach SelectCombination c in expanded {
                newCombinations.push(c);
            }
        } else {
            newCombinations.push(addNonUnionCombination(sel, combination));
        }
    }
    return newCombinations;
}

# Expand each unionAll option for a select element, handling nested unions recursively.
#
# + sel - the select element whose `unionAll` is being expanded
# + unionAll - the non-empty union branch array from `sel`
# + combination - the combination being extended
# + return - one new combination per union branch (multiplied by nested branches)
isolated function expandUnionAllOptions(
        sql_on_fhir_lib:ViewDefinitionSelect sel,
        sql_on_fhir_lib:ViewDefinitionSelect[] unionAll,
        SelectCombination combination) returns SelectCombination[] {

    SelectCombination[] newCombinations = [];
    foreach int i in 0 ..< unionAll.length() {
        sql_on_fhir_lib:ViewDefinitionSelect unionOption = unionAll[i];
        sql_on_fhir_lib:ViewDefinitionSelect[]? nested = unionOption.unionAll;
        if nested is sql_on_fhir_lib:ViewDefinitionSelect[] && nested.length() > 0 {
            SelectCombination[] expanded = expandNestedUnion(sel, i, unionOption, combination);
            foreach SelectCombination c in expanded {
                newCombinations.push(c);
            }
        } else {
            newCombinations.push(addSimpleUnionCombination(sel, i, combination));
        }
    }
    return newCombinations;
}

# Recursively expand a unionAll option that itself contains unionAll branches,
# then merge each nested result with the outer combination.
#
# + sel - the outer select element
# + unionIndex - index of `unionOption` within `sel.unionAll`
# + unionOption - the union branch that itself has nested `unionAll`
# + combination - the combination being extended
# + return - one new combination per leaf of the nested union tree
isolated function expandNestedUnion(
        sql_on_fhir_lib:ViewDefinitionSelect sel,
        int unionIndex,
        sql_on_fhir_lib:ViewDefinitionSelect unionOption,
        SelectCombination combination) returns SelectCombination[] {

    SelectCombination[] nestedCombinations = expandSelectCombinations(
            unionOption, [{selects: [], unionChoices: []}]);

    SelectCombination[] result = [];
    foreach SelectCombination nestedComb in nestedCombinations {
        result.push({
            selects: [...combination.selects, sel, ...nestedComb.selects],
            unionChoices: [...combination.unionChoices, unionIndex, ...nestedComb.unionChoices]
        });
    }
    return result;
}

# Build a combination for a simple unionAll branch (no nested unions).
#
# + sel - the select element containing the union
# + unionIndex - index of the chosen branch within `sel.unionAll`
# + combination - the combination being extended
# + return - new combination with `sel` appended and `unionIndex` recorded
isolated function addSimpleUnionCombination(
        sql_on_fhir_lib:ViewDefinitionSelect sel,
        int unionIndex,
        SelectCombination combination) returns SelectCombination {

    return {
        selects: [...combination.selects, sel],
        unionChoices: [...combination.unionChoices, unionIndex]
    };
}

# Build a combination for a select element that has no unionAll.
#
# + sel - the select element with no union branches
# + combination - the combination being extended
# + return - new combination with `sel` appended and `-1` recorded
isolated function addNonUnionCombination(
        sql_on_fhir_lib:ViewDefinitionSelect sel,
        SelectCombination combination) returns SelectCombination {

    return {
        selects: [...combination.selects, sel],
        unionChoices: [...combination.unionChoices, -1]
    };
}
