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

isolated function applyCountFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("count", "0 parameters", params.length());
    }
    return [collection.length()];
}

isolated function applyIsDistinctFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("isDistinct", "0 parameters", params.length());
    }
    json[] seen = [];
    foreach json item in collection {
        foreach json existing in seen {
            if isJsonEqual(item, existing) {
                return [false];
            }
        }
        seen.push(item);
    }
    return [true];
}

isolated function applyDistinctFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("distinct", "0 parameters", params.length());
    }
    json[] result = [];
    foreach json item in collection {
        boolean found = false;
        foreach json existing in result {
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

isolated function applyLastFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("last", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    return [collection[collection.length() - 1]];
}

isolated function applyTailFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("tail", "0 parameters", params.length());
    }
    if collection.length() <= 1 {
        return [];
    }
    return collection.slice(1);
}

isolated function applySkipFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("skip", "1 parameter", params.length());
    }
    json[] nResult = check evaluate(params[0], context, env);
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

isolated function applyTakeFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("take", "1 parameter", params.length());
    }
    json[] nResult = check evaluate(params[0], context, env);
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

isolated function applySingleFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
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

isolated function applyCombineFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("combine", "1 parameter", params.length());
    }
    json[] otherResult = check evaluate(params[0], context, env);
    json[] result = [...collection, ...otherResult];
    return result;
}

isolated function applyUnionFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("union", "1 parameter", params.length());
    }
    json[] otherResult = check evaluate(params[0], context, env);
    json[] combined = [...collection, ...otherResult];
    return applyDistinctToItems(combined);
}

isolated function applyIntersectFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("intersect", "1 parameter", params.length());
    }
    json[] otherResult = check evaluate(params[0], context, env);
    json[] result = [];
    foreach json item in collection {
        boolean inOther = false;
        foreach json otherItem in otherResult {
            if isJsonEqual(item, otherItem) {
                inOther = true;
                break;
            }
        }
        if inOther {
            boolean alreadyAdded = false;
            foreach json existing in result {
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

isolated function applyExcludeFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("exclude", "1 parameter", params.length());
    }
    json[] otherResult = check evaluate(params[0], context, env);
    json[] result = [];
    foreach json item in collection {
        boolean inOther = false;
        foreach json otherItem in otherResult {
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

isolated function applySelectFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("select", "1 parameter", params.length());
    }
    Expr criteriaExpr = params[0];
    json[] results = [];
    int i = 0;
    foreach json item in collection {
        FhirPathEnv itemEnv = {index: i, total: env?.total, scope: env.scope.childScope()};
        json[] itemResult = check evaluate(criteriaExpr, item, itemEnv);
        foreach json val in itemResult {
            results.push(val);
        }
        i += 1;
    }
    return results;
}

isolated function applySortFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if collection.length() <= 1 {
        return collection;
    }
    // Basic sort: sort primitives by natural ordering
    // If a criteria expression is provided, sort by that
    if params.length() == 0 {
        return sortCollection(collection);
    }
    if params.length() > 1 {
        return fnError("sort", "0 or 1 parameter", params.length());
    }
    // With criteria: evaluate criteria for each item and sort by result
    Expr criteria = params[0];
    json[][] keyedItems = [];
    int idx = 0;
    foreach json item in collection {
        FhirPathEnv itemEnv = {index: idx, total: env?.total, scope: env.scope.childScope()};
        json[] keyResult = check evaluate(criteria, item, itemEnv);
        keyedItems.push([item, keyResult.length() > 0 ? keyResult[0] : ()]);
        idx += 1;
    }
    // Simple insertion sort by key
    int n = keyedItems.length();
    foreach int i in 1 ..< n {
        json[] current = keyedItems[i];
        int j = i - 1;
        while j >= 0 && compareJsonValues(keyedItems[j][1], current[1]) > 0 {
            keyedItems[j + 1] = keyedItems[j];
            j -= 1;
        }
        keyedItems[j + 1] = current;
    }
    json[] result = [];
    foreach json[] pair in keyedItems {
        result.push(pair[0]);
    }
    return result;
}

isolated function applyAllFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() == 0 {
        // all() with no args: all items must be truthy
        foreach json item in collection {
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
    foreach json item in collection {
        FhirPathEnv itemEnv = {index: i, total: env?.total, scope: env.scope.childScope()};
        json[] criteriaResult = check evaluate(criteriaExpr, item, itemEnv);
        if criteriaResult.length() == 0 || !isTruthyValue(criteriaResult[0]) {
            return [false];
        }
        i += 1;
    }
    return [true];
}

isolated function applyRepeatFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("repeat", "1 parameter", params.length());
    }
    Expr criteriaExpr = params[0];
    json[] result = [];
    json[] current = collection;
    // Keep applying criteria until no new items are produced
    boolean changed = true;
    // Track visited items to avoid infinite loops
    json[] visited = [...collection];

    while changed {
        changed = false;
        json[] nextBatch = [];
        int idx = 0;
        foreach json item in current {
            FhirPathEnv itemEnv = {index: idx, total: env?.total, scope: env.scope.childScope()};
            json[] itemResult = check evaluate(criteriaExpr, item, itemEnv);
            idx += 1;
            foreach json newItem in itemResult {
                boolean alreadyVisited = false;
                foreach json v in visited {
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

isolated function applyAggregateFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() < 1 || params.length() > 2 {
        return fnError("aggregate", "1 or 2 parameters", params.length());
    }
    Expr aggregatorExpr = params[0];
    json total = ();
    if params.length() == 2 {
        json[] initResult = check evaluate(params[1], context, env);
        if initResult.length() > 0 {
            total = initResult[0];
        }
    }
    int i = 0;
    foreach json item in collection {
        FhirPathEnv itemEnv = {index: i, total: total, scope: env.scope.childScope()};
        json[] aggResult = check evaluate(aggregatorExpr, item, itemEnv);
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

isolated function applySubsetOfFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("subsetOf", "1 parameter", params.length());
    }
    json[] otherResult = check evaluate(params[0], context, env);
    foreach json item in collection {
        boolean found = false;
        foreach json otherItem in otherResult {
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

isolated function applySupersetOfFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("supersetOf", "1 parameter", params.length());
    }
    json[] otherResult = check evaluate(params[0], context, env);
    foreach json item in otherResult {
        boolean found = false;
        foreach json selfItem in collection {
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

isolated function applyNotFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
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
    json val = collection[0];
    if val is boolean {
        return [!val];
    }
    return error FHIRPathInterpreterError("not() requires a boolean value",
        token = {tokenType: IDENTIFIER, lexeme: "not", literal: (), position: 0});
}

isolated function applyChildrenFunction(json[] collection, Expr[] params, json context) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("children", "0 parameters", params.length());
    }
    json[] result = [];
    foreach json item in collection {
        if item is map<json> {
            foreach var [_, v] in item.entries() {
                if v is json[] {
                    foreach json elem in v {
                        result.push(elem);
                    }
                } else {
                    result.push(v);
                }
            }
        } else if item is json[] {
            foreach json elem in item {
                result.push(elem);
            }
        }
    }
    return result;
}

isolated function applyDescendantsFunction(json[] collection, Expr[] params, json context) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("descendants", "0 parameters", params.length());
    }
    json[] result = [];
    foreach json item in collection {
        collectDescendants(item, result);
    }
    return result;
}

isolated function collectDescendants(json item, json[] result) {
    if item is map<json> {
        foreach var [_, v] in item.entries() {
            if v is json[] {
                foreach json elem in v {
                    result.push(elem);
                    collectDescendants(elem, result);
                }
            } else if v !is () {
                result.push(v);
                collectDescendants(v, result);
            }
        }
    } else if item is json[] {
        foreach json elem in item {
            result.push(elem);
            collectDescendants(elem, result);
        }
    }
}

// ========================================
// COLLECTION HELPERS
// ========================================

isolated function applyDistinctToItems(json[] items) returns json[] {
    json[] result = [];
    foreach json item in items {
        boolean found = false;
        foreach json existing in result {
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

isolated function sortCollection(json[] collection) returns json[] {
    if collection.length() <= 1 {
        return collection;
    }
    json[] result = [...collection];
    int n = result.length();
    // Insertion sort
    foreach int i in 1 ..< n {
        json current = result[i];
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

isolated function compareJsonValues(json a, json b) returns int {
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
            int c = compareJsonValues(a[i], b[i]);
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
            int c = compareJsonValues(valA, valB);
            if c != 0 { return c; }
        }
        if keysA.length() < keysB.length() { return -1; }
        if keysA.length() > keysB.length() { return 1; }
        return 0;
    }
    return 0;
}

isolated function isJsonEqual(json a, json b) returns boolean {
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
            if !isJsonEqual(a[i], b[i]) { return false; }
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
            if !isJsonEqual(valA, valB) { return false; }
        }
        return true;
    }
    return false;
}

isolated function isTruthyValue(json val) returns boolean {
    if val is boolean { return val; }
    if val is () { return false; }
    return true;
}
