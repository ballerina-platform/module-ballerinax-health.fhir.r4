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

// ========================================
// COLLECTION FUNCTIONS
// ========================================

isolated function applyCountFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("count", "0 parameters", params.length());
    }
    return [collection.length()];
}

isolated function applyIsDistinctFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("isDistinct", "0 parameters", params.length());
    }
    FhirPathItem[] seen = [];
    foreach FhirPathItem item in collection {
        foreach FhirPathItem existing in seen {
            if isJsonEqual(item, existing) {
                return [false];
            }
        }
        seen.push(item);
    }
    return [true];
}

isolated function applyDistinctFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("distinct", "0 parameters", params.length());
    }
    FhirPathItem[] result = [];
    foreach FhirPathItem item in collection {
        boolean found = false;
        foreach FhirPathItem existing in result {
            if isJsonEqual(item, existing) {
                found = true;
                break;
            }
        }
        if !found {
            result.push(item);
        }
    }
    return result;
}

isolated function applyLastFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("last", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    return [collection[collection.length() - 1]];
}

isolated function applyTailFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("tail", "0 parameters", params.length());
    }
    if collection.length() <= 1 {
        return [];
    }
    return collection.slice(1);
}

isolated function applySkipFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("skip", "1 parameter", params.length());
    }
    FhirPathItem[] nResult = check evaluate(params[0], context, env);
    if nResult.length() == 0 {
        return [];
    }
    int n = toInt(nResult[0]);
    if n <= 0 {
        return collection;
    }
    if n >= collection.length() {
        return [];
    }
    return collection.slice(n);
}

isolated function applyTakeFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("take", "1 parameter", params.length());
    }
    FhirPathItem[] nResult = check evaluate(params[0], context, env);
    if nResult.length() == 0 {
        return [];
    }
    int n = toInt(nResult[0]);
    if n <= 0 {
        return [];
    }
    if n >= collection.length() {
        return collection;
    }
    return collection.slice(0, n);
}

isolated function applySingleFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("single", "0 parameters", params.length());
    }
    if collection.length() == 1 {
        return [collection[0]];
    }
    if collection.length() == 0 {
        return [];
    }
    return error FHIRPathInterpreterError("single() called on collection with more than one element",
        token = {tokenType: IDENTIFIER, lexeme: "single", literal: (), position: 0});
}

isolated function applyCombineFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() < 1 || params.length() > 2 {
        return fnError("combine", "1 or 2 parameters", params.length());
    }
    if params.length() == 2 {
        // preserveOrder: the input items are always followed by the other items in order
        FhirPathItem[] preserveOrder = check evaluate(params[1], context, env);
        if preserveOrder.length() > 1 || (preserveOrder.length() == 1 && valueOf(preserveOrder[0]) !is boolean) {
            return error FHIRPathInterpreterError("combine() preserveOrder must be a Boolean",
                token = {tokenType: IDENTIFIER, lexeme: "combine", literal: (), position: 0});
        }
    }
    FhirPathItem[] otherResult = check evaluate(params[0], context, env);
    FhirPathItem[] result = [...collection, ...otherResult];
    return result;
}

isolated function applyUnionFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("union", "1 parameter", params.length());
    }
    FhirPathItem[] otherResult = check evaluate(params[0], context, env);
    FhirPathItem[] combined = [...collection, ...otherResult];
    return applyDistinctToItems(combined);
}

isolated function applyIntersectFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("intersect", "1 parameter", params.length());
    }
    FhirPathItem[] otherResult = check evaluate(params[0], context, env);
    FhirPathItem[] result = [];
    foreach FhirPathItem item in collection {
        boolean inOther = false;
        foreach FhirPathItem otherItem in otherResult {
            if isJsonEqual(item, otherItem) {
                inOther = true;
                break;
            }
        }
        if inOther {
            boolean alreadyAdded = false;
            foreach FhirPathItem existing in result {
                if isJsonEqual(item, existing) {
                    alreadyAdded = true;
                    break;
                }
            }
            if !alreadyAdded {
                result.push(item);
            }
        }
    }
    return result;
}

isolated function applyExcludeFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("exclude", "1 parameter", params.length());
    }
    FhirPathItem[] otherResult = check evaluate(params[0], context, env);
    FhirPathItem[] result = [];
    foreach FhirPathItem item in collection {
        boolean inOther = false;
        foreach FhirPathItem otherItem in otherResult {
            if isJsonEqual(item, otherItem) {
                inOther = true;
                break;
            }
        }
        if !inOther {
            result.push(item);
        }
    }
    return result;
}

isolated function applySelectFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("select", "1 parameter", params.length());
    }
    Expr criteriaExpr = params[0];
    FhirPathItem[] results = [];
    int i = 0;
    foreach FhirPathItem item in collection {
        FhirPathEnv itemEnv = {index: i, total: env?.total, scope: env.scope.childScope()};
        FhirPathItem[] itemResult = check evaluate(criteriaExpr, item, itemEnv);
        foreach FhirPathItem val in itemResult {
            results.push(val);
        }
        i += 1;
    }
    return results;
}

isolated function applySortFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() <= 1 {
        return collection;
    }
    // Key selectors with their direction; `-key` is accepted as a legacy form of `key desc`
    [Expr, boolean][] selectors = [];
    foreach Expr param in params {
        if param is SortArgumentExpr {
            selectors.push([param.key, param.isDescending]);
        } else if param is UnaryExpr && param.operator.tokenType == MINUS {
            selectors.push([param.operand, true]);
        } else {
            selectors.push([param, false]);
        }
    }

    // Evaluate every key once per item ($index is undefined in sort())
    [FhirPathItem, FhirPathItem?[]][] keyed = [];
    foreach FhirPathItem item in collection {
        FhirPathItem?[] keys = [];
        foreach [Expr, boolean] [selector, _] in selectors {
            FhirPathItem[] keyResult = check evaluate(selector, item, {total: env?.total, scope: env.scope.childScope()});
            if keyResult.length() > 1 {
                return error FHIRPathInterpreterError("sort() key selector returned more than one item",
                    token = {tokenType: IDENTIFIER, lexeme: "sort", literal: (), position: 0});
            }
            keys.push(keyResult.length() == 1 ? keyResult[0] : ());
        }
        keyed.push([item, keys]);
    }

    // Stable insertion sort
    foreach int i in 1 ..< keyed.length() {
        [FhirPathItem, FhirPathItem?[]] current = keyed[i];
        int j = i - 1;
        while j >= 0 && check compareSortEntries(keyed[j], current, selectors) > 0 {
            keyed[j + 1] = keyed[j];
            j -= 1;
        }
        keyed[j + 1] = current;
    }
    return from [FhirPathItem, FhirPathItem?[]] [item, _] in keyed select item;
}

isolated function compareSortEntries([FhirPathItem, FhirPathItem?[]] a, [FhirPathItem, FhirPathItem?[]] b,
        [Expr, boolean][] selectors) returns int|FHIRPathInterpreterError {
    if selectors.length() == 0 {
        return compareSortValues(a[0], b[0]);
    }
    foreach int k in 0 ..< selectors.length() {
        int c = check compareSortValues(a[1][k], b[1][k]);
        if c != 0 {
            return selectors[k][1] ? -c : c;
        }
    }
    return 0;
}

// Orders two sort keys with the comparison operator semantics; empty sorts before any value
isolated function compareSortValues(FhirPathItem? a, FhirPathItem? b) returns int|FHIRPathInterpreterError {
    if a is () || b is () {
        return a is () ? (b is () ? 0 : -1) : 1;
    }
    if jsonValuesEqual(a, b) == true {
        return 0;
    }
    json av = systemValueOf(a);
    json bv = systemValueOf(b);
    if av is map<json> && bv is map<json> && av["value"] is () {
        // Complex values have no defined ordering; keep their relative order
        return compareJsonValues(a, b);
    }
    FhirPathItem[]|FHIRPathInterpreterError less = applyComparisonOperator([a], [b], "<");
    if less is FHIRPathInterpreterError {
        return error FHIRPathInterpreterError("sort() cannot order values of incompatible types",
            token = {tokenType: IDENTIFIER, lexeme: "sort", literal: (), position: 0});
    }
    if less.length() == 0 {
        if av is string && bv is string {
            return av < bv ? -1 : 1;
        }
        return error FHIRPathInterpreterError("sort() cannot order values of incompatible types",
            token = {tokenType: IDENTIFIER, lexeme: "sort", literal: (), position: 0});
    }
    return valueOf(less[0]) == true ? -1 : 1;
}

isolated function applyAllFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() == 0 {
        // all() with no args: all items must be truthy
        foreach FhirPathItem item in collection {
            if !isTruthyValue(item) {
                return [false];
            }
        }
        return [true];
    }
    if params.length() != 1 {
        return fnError("all", "0 or 1 parameter", params.length());
    }
    Expr criteriaExpr = params[0];
    int i = 0;
    foreach FhirPathItem item in collection {
        FhirPathEnv itemEnv = {index: i, total: env?.total, scope: env.scope.childScope()};
        FhirPathItem[] criteriaResult = check evaluate(criteriaExpr, item, itemEnv);
        if criteriaResult.length() == 0 || !isTruthyValue(criteriaResult[0]) {
            return [false];
        }
        i += 1;
    }
    return [true];
}

isolated function applyRepeatFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("repeat", "1 parameter", params.length());
    }
    Expr criteriaExpr = params[0];
    FhirPathItem[] result = [];
    FhirPathItem[] current = collection;
    // Keep applying criteria until no new items are produced
    boolean changed = true;
    // Track visited items to avoid infinite loops
    FhirPathItem[] visited = [...collection];

    while changed {
        changed = false;
        FhirPathItem[] nextBatch = [];
        int idx = 0;
        foreach FhirPathItem item in current {
            FhirPathEnv itemEnv = {index: idx, total: env?.total, scope: env.scope.childScope()};
            FhirPathItem[] itemResult = check evaluate(criteriaExpr, item, itemEnv);
            idx += 1;
            foreach FhirPathItem newItem in itemResult {
                boolean alreadyVisited = false;
                foreach FhirPathItem v in visited {
                    if isJsonEqual(newItem, v) {
                        alreadyVisited = true;
                        break;
                    }
                }
                if !alreadyVisited {
                    nextBatch.push(newItem);
                    result.push(newItem);
                    visited.push(newItem);
                    changed = true;
                }
            }
        }
        current = nextBatch;
    }
    return result;
}

isolated function applyAggregateFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() < 1 || params.length() > 2 {
        return fnError("aggregate", "1 or 2 parameters", params.length());
    }
    Expr aggregatorExpr = params[0];
    FhirPathItem total = ();
    if params.length() == 2 {
        FhirPathItem[] initResult = check evaluate(params[1], context, env);
        if initResult.length() > 0 {
            total = initResult[0];
        }
    }
    int i = 0;
    foreach FhirPathItem item in collection {
        FhirPathEnv itemEnv = {index: i, total: total, scope: env.scope.childScope()};
        FhirPathItem[] aggResult = check evaluate(aggregatorExpr, item, itemEnv);
        if aggResult.length() > 0 {
            total = aggResult[0];
        }
        i += 1;
    }
    if total is () {
        return [];
    }
    return [total];
}

isolated function applySubsetOfFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("subsetOf", "1 parameter", params.length());
    }
    FhirPathItem[] otherResult = check evaluate(params[0], context, env);
    foreach FhirPathItem item in collection {
        boolean found = false;
        foreach FhirPathItem otherItem in otherResult {
            if isJsonEqual(item, otherItem) {
                found = true;
                break;
            }
        }
        if !found {
            return [false];
        }
    }
    return [true];
}

isolated function applySupersetOfFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("supersetOf", "1 parameter", params.length());
    }
    FhirPathItem[] otherResult = check evaluate(params[0], context, env);
    foreach FhirPathItem item in otherResult {
        boolean found = false;
        foreach FhirPathItem selfItem in collection {
            if isJsonEqual(item, selfItem) {
                found = true;
                break;
            }
        }
        if !found {
            return [false];
        }
    }
    return [true];
}

isolated function applyNotFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("not", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    if collection.length() > 1 {
        return error FHIRPathInterpreterError("not() requires at most one item in the collection",
            token = {tokenType: IDENTIFIER, lexeme: "not", literal: (), position: 0});
    }
    json val = systemValueOf(collection[0]);
    if val is boolean {
        return [!val];
    }
    return error FHIRPathInterpreterError("not() requires a boolean value",
        token = {tokenType: IDENTIFIER, lexeme: "not", literal: (), position: 0});
}

isolated function applyChildrenFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("children", "0 parameters", params.length());
    }
    FhirPathItem[] result = [];
    foreach FhirPathItem item in collection {
        result.push(...allChildItems(item));
    }
    return result;
}

isolated function applyDescendantsFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("descendants", "0 parameters", params.length());
    }
    FhirPathItem[] result = [];
    foreach FhirPathItem item in collection {
        collectDescendants(item, result);
    }
    return result;
}

isolated function collectDescendants(FhirPathItem item, FhirPathItem[] result) {
    foreach FhirPathItem child in allChildItems(item) {
        result.push(child);
        collectDescendants(child, result);
    }
}

// Shared by allTrue(), anyTrue(), allFalse() and anyFalse(): `target` is the value looked for and
// `matchAny` selects "any item matches" instead of "all items match"
isolated function applyBooleanAggregate(FhirPathItem[] collection, Expr[] params, string name, boolean target, boolean matchAny)
        returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError(name, "0 parameters", params.length());
    }
    boolean found = false;
    boolean allMatch = true;
    foreach FhirPathItem item in collection {
        json val = valueOf(item);
        if val !is boolean {
            return error FHIRPathInterpreterError(string `${name}() requires a collection of Boolean values`,
                token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
        }
        if val == target {
            found = true;
        } else {
            allMatch = false;
        }
    }
    return [matchAny ? found : allMatch];
}

isolated function applyCoalesceFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env)
        returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() == 0 {
        return fnError("coalesce", "at least 1 parameter", 0);
    }
    FhirPathItem? input = check singleInput(collection, "coalesce");
    // Arguments are evaluated lazily against the input item; evaluation stops at the first non-empty one
    foreach Expr param in params {
        FhirPathItem[] result = check evaluate(param, input, {index: 0, total: env?.total, scope: env.scope.childScope()});
        if result.length() > 0 {
            return result;
        }
    }
    return [];
}

const REPEAT_ALL_MAX_ITEMS = 100000;

isolated function applyRepeatAllFunction(FhirPathItem[] collection, Expr[] params, FhirPathEnv env)
        returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("repeatAll", "1 parameter", params.length());
    }
    FhirPathItem[] result = [];
    FhirPathItem[] queue = collection;
    while queue.length() > 0 {
        FhirPathItem[] next = [];
        foreach FhirPathItem item in queue {
            // $index is undefined for repeatAll()
            FhirPathItem[] itemResult = check evaluate(params[0], item, {total: env?.total, scope: env.scope.childScope()});
            result.push(...itemResult);
            next.push(...itemResult);
        }
        if result.length() > REPEAT_ALL_MAX_ITEMS {
            return error FHIRPathInterpreterError(
                string `repeatAll() produced more than ${REPEAT_ALL_MAX_ITEMS} items; the projection probably does not terminate`,
                token = {tokenType: IDENTIFIER, lexeme: "repeatAll", literal: (), position: 0});
        }
        queue = next;
    }
    return result;
}

// ========================================
// AGGREGATES
// ========================================

isolated function applySumFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("sum", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    string kind = check aggregateKind(collection, "sum", ["Integer", "Long", "Decimal", "Quantity"]);
    if kind == "Quantity" {
        [decimal, string] [total, unit] = check sumQuantities(collection, "sum");
        return [quantityItem(total, unit)];
    }
    decimal total = 0d;
    foreach FhirPathItem item in collection {
        total += toDecimalValue(valueOf(item));
    }
    if kind == "Decimal" {
        return [total];
    }
    int intTotal = <int>total;
    return [kind == "Long" ? systemItem("Long", intTotal) : intTotal];
}

isolated function applyMinMaxFunction(FhirPathItem[] collection, Expr[] params, string name) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError(name, "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    _ = check aggregateKind(collection, name, ["Integer", "Long", "Decimal", "Quantity", "Date", "DateTime", "Time", "String"]);
    string op = name == "min" ? "<" : ">";
    FhirPathItem best = collection[0];
    foreach FhirPathItem item in collection.slice(1) {
        FhirPathItem[] better = check applyComparisonOperator([item], [best], op);
        if better.length() == 0 {
            // Values of different precision cannot be ordered
            return [];
        }
        if valueOf(better[0]) == true {
            best = item;
        }
    }
    return [best];
}

isolated function applyAvgFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("avg", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    string kind = check aggregateKind(collection, "avg", ["Integer", "Long", "Decimal", "Quantity"]);
    decimal count = <decimal>collection.length();
    if kind == "Quantity" {
        [decimal, string] [total, unit] = check sumQuantities(collection, "avg");
        return [quantityItem(total / count, unit)];
    }
    decimal total = 0d;
    foreach FhirPathItem item in collection {
        total += toDecimalValue(valueOf(item));
    }
    return [total / count];
}

// Checks that all items have the same (System) type, one of `allowed`, and returns it.
// Integer, Long and Decimal items may be mixed; the result is then the widest of them.
isolated function aggregateKind(FhirPathItem[] collection, string name, string[] allowed) returns string|FHIRPathInterpreterError {
    string kind = "";
    foreach FhirPathItem item in collection {
        string itemKind = systemTypeOf(item);
        if allowed.indexOf(itemKind) is () {
            return error FHIRPathInterpreterError(string `${name}() does not accept items of type ${itemKind}`,
                token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
        }
        if kind == "" || kind == itemKind {
            kind = itemKind;
        } else if isNumericKind(kind) && isNumericKind(itemKind) {
            kind = kind == "Decimal" || itemKind == "Decimal" ? "Decimal" : "Long";
        } else {
            return error FHIRPathInterpreterError(string `${name}() requires items of the same type, found ${kind} and ${itemKind}`,
                token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
        }
    }
    return kind;
}

isolated function isNumericKind(string kind) returns boolean {
    return kind == "Integer" || kind == "Long" || kind == "Decimal";
}

// Sums quantities that share a unit (unit conversion is not supported yet)
isolated function sumQuantities(FhirPathItem[] collection, string name) returns [decimal, string]|FHIRPathInterpreterError {
    decimal total = 0d;
    string? unit = ();
    foreach FhirPathItem item in collection {
        json q = valueOf(item);
        if q !is map<json> {
            continue;
        }
        json code = q["code"];
        json unitJson = q["unit"];
        string itemUnit = code is string ? code : (unitJson is string ? unitJson : "1");
        if unit is string && unit != itemUnit {
            return error FHIRPathInterpreterError(string `${name}() requires quantities with the same unit, found '${unit}' and '${itemUnit}'`,
                token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
        }
        unit = itemUnit;
        total += toDecimalValue(q["value"]);
    }
    return [total, unit ?: "1"];
}

isolated function toDecimalValue(json val) returns decimal {
    if val is decimal { return val; }
    if val is int { return <decimal>val; }
    if val is float { return <decimal>val; }
    return 0d;
}

// ========================================
// COLLECTION HELPERS
// ========================================

isolated function applyDistinctToItems(FhirPathItem[] items) returns FhirPathItem[] {
    FhirPathItem[] result = [];
    foreach FhirPathItem item in items {
        boolean found = false;
        foreach FhirPathItem existing in result {
            if isJsonEqual(item, existing) {
                found = true;
                break;
            }
        }
        if !found {
            result.push(item);
        }
    }
    return result;
}

isolated function sortCollection(FhirPathItem[] collection) returns FhirPathItem[] {
    if collection.length() <= 1 {
        return collection;
    }
    FhirPathItem[] result = [...collection];
    int n = result.length();
    // Insertion sort
    foreach int i in 1 ..< n {
        FhirPathItem current = result[i];
        int j = i - 1;
        while j >= 0 && compareJsonValues(result[j], current) > 0 {
            result[j + 1] = result[j];
            j -= 1;
        }
        result[j + 1] = current;
    }
    return result;
}

isolated function jsonTypeOrder(json v) returns int {
    if v is () { return 0; }
    if v is boolean { return 1; }
    if v is int || v is decimal || v is float { return 2; }
    if v is string { return 3; }
    if v is json[] { return 4; }
    return 5; // map<json>
}

isolated function compareJsonValues(FhirPathItem a, FhirPathItem b) returns int {
    return compareJsonPayloads(systemValueOf(a), systemValueOf(b));
}

isolated function compareJsonPayloads(json a, json b) returns int {
    int ta = jsonTypeOrder(a);
    int tb = jsonTypeOrder(b);
    if ta != tb {
        return ta < tb ? -1 : 1;
    }
    if a is () { return 0; }
    if a is boolean && b is boolean {
        if a == b { return 0; }
        return a ? 1 : -1;
    }
    if (a is int || a is decimal || a is float) && (b is int || b is decimal || b is float) {
        float fa = toFloat(a);
        float fb = toFloat(b);
        if fa < fb { return -1; }
        if fa > fb { return 1; }
        return 0;
    }
    if a is string && b is string {
        if a < b { return -1; }
        if a > b { return 1; }
        return 0;
    }
    if a is json[] && b is json[] {
        int lenCmp = a.length() < b.length() ? a.length() : b.length();
        foreach int i in 0 ..< lenCmp {
            int c = compareJsonPayloads(a[i], b[i]);
            if c != 0 { return c; }
        }
        if a.length() < b.length() { return -1; }
        if a.length() > b.length() { return 1; }
        return 0;
    }
    if a is map<json> && b is map<json> {
        string[] keysA = from string k in a.keys() order by k select k;
        string[] keysB = from string k in b.keys() order by k select k;
        int lenCmp = keysA.length() < keysB.length() ? keysA.length() : keysB.length();
        foreach int i in 0 ..< lenCmp {
            if keysA[i] < keysB[i] { return -1; }
            if keysA[i] > keysB[i] { return 1; }
            json valA = a[keysA[i]] ?: ();
            json valB = b[keysB[i]] ?: ();
            int c = compareJsonPayloads(valA, valB);
            if c != 0 { return c; }
        }
        if keysA.length() < keysB.length() { return -1; }
        if keysA.length() > keysB.length() { return 1; }
        return 0;
    }
    return 0;
}

isolated function isJsonEqual(FhirPathItem a, FhirPathItem b) returns boolean {
    return isJsonPayloadEqual(systemValueOf(a), systemValueOf(b));
}

isolated function isJsonPayloadEqual(json a, json b) returns boolean {
    if a is () && b is () { return true; }
    if a is () || b is () { return false; }
    if a is boolean && b is boolean { return a == b; }
    if a is string && b is string { return a == b; }
    if (a is int || a is decimal || a is float) && (b is int || b is decimal || b is float) {
        return toFloat(a) == toFloat(b);
    }
    if a is json[] && b is json[] {
        if a.length() != b.length() { return false; }
        foreach int i in 0 ..< a.length() {
            if !isJsonPayloadEqual(a[i], b[i]) { return false; }
        }
        return true;
    }
    if a is map<json> && b is map<json> {
        string[] keysA = from string k in a.keys() order by k select k;
        string[] keysB = from string k in b.keys() order by k select k;
        if keysA.length() != keysB.length() { return false; }
        foreach int i in 0 ..< keysA.length() {
            if keysA[i] != keysB[i] { return false; }
            json valA = a[keysA[i]] ?: ();
            json valB = b[keysA[i]] ?: ();
            if !isJsonPayloadEqual(valA, valB) { return false; }
        }
        return true;
    }
    return false;
}

isolated function isTruthyValue(FhirPathItem item) returns boolean {
    json val = valueOf(item);
    if val is boolean { return val; }
    if val is () { return false; }
    return true;
}
