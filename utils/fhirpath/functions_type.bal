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
// TYPE CONVERSION AND CHECKING FUNCTIONS
// ========================================

# Returns true when a type specifier names a known System or FHIR type.
#
# + specifier - The type specifier
# + return - Whether the type is known
isolated function isKnownTypeSpecifier(string specifier) returns boolean {
    [string, string][] candidates = resolveTypeSpecifier(specifier);
    if candidates.length() == 0 {
        return false;
    }
    foreach [string, string] [namespace, name] in candidates {
        if namespace == SYSTEM_NS && SYSTEM_TYPE_NAMES.indexOf(name) is () {
            return false;
        }
        if namespace == FHIR_NS && !FHIR_TYPE_BASE.hasKey(name) {
            return false;
        }
    }
    return true;
}

isolated function applyTypeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("type", "0 parameters", params.length());
    }
    FhirPathItem[] results = [];
    foreach FhirPathItem item in collection {
        results.push(typeInfoOf(item));
    }
    return results;
}

// Reflection type information (SimpleTypeInfo / ClassInfo) of an item
isolated function typeInfoOf(FhirPathItem item) returns map<json> {
    [string, string] [namespace, name] = typeOfItem(item);
    map<json> info = {"namespace": namespace, "name": name};
    if namespace == SYSTEM_NS {
        info["baseType"] = "System.Any";
    } else {
        string? base = FHIR_TYPE_BASE[name];
        if base is string && base != "" {
            info["baseType"] = "FHIR." + base;
        }
    }
    return info;
}

isolated function applyToIntegerFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toInteger", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is int {
        return [val];
    } else if val is decimal {
        return [<int>val];
    } else if val is float {
        return [<int>val];
    } else if val is boolean {
        return [val ? 1 : 0];
    } else if val is string {
        int|error i = int:fromString(val);
        if i is int {
            return [i];
        }
        return [];
    }
    return [];
}

isolated function applyToLongFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toLong", "0 parameters", params.length());
    }
    FhirPathItem? input = check singleInput(collection, "toLong");
    if input is () {
        return [];
    }
    int? converted = toLongValue(input);
    return (converted is int) ? [systemItem("Long", converted)] : [];
}

isolated function applyConvertsToLongFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("convertsToLong", "0 parameters", params.length());
    }
    FhirPathItem? input = check singleInput(collection, "convertsToLong");
    if input is () {
        return [];
    }
    return [toLongValue(input) is int];
}

// Long conversion: Integer/Long values, Booleans (1/0) and strings matching (\+|-)?\d+ within 64 bits
isolated function toLongValue(FhirPathItem item) returns int? {
    string kind = systemTypeOf(item);
    json val = valueOf(item);
    if (kind == "Integer" || kind == "Long") && val is int {
        return val;
    }
    if val is boolean {
        return val ? 1 : 0;
    }
    if kind == "String" && val is string && re `(\+|-)?[0-9]+`.isFullMatch(val) {
        int|error parsed = int:fromString(val.startsWith("+") ? val.substring(1) : val);
        return parsed is int ? parsed : ();
    }
    return ();
}

isolated function applyToDecimalFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toDecimal", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is decimal {
        return [val];
    } else if val is int {
        return [<decimal>val];
    } else if val is float {
        decimal|error d = decimal:fromString(val.toString());
        if d is decimal {
            return [d];
        }
        return [];
    } else if val is boolean {
        return [val ? 1d : 0d];
    } else if val is string {
        decimal|error d = decimal:fromString(val);
        if d is decimal {
            return [d];
        }
        return [];
    }
    return [];
}

isolated function applyToStringFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toString", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is string {
        if dateTimeKind(val) is string {
            return [val.startsWith("@T") ? val.substring(2) : val.substring(1)];
        }
        return [val];
    } else if val is boolean {
        return [val.toString()];
    } else if val is int {
        return [val.toString()];
    } else if val is decimal {
        return [val.toString()];
    } else if val is float {
        return [val.toString()];
    } else if val is map<json> {
        json unitJson = val["unit"];
        json valJson = val["value"];
        if unitJson is string {
            decimal dval;
            if valJson is decimal { dval = valJson; }
            else if valJson is int { dval = <decimal>valJson; }
            else if valJson is float { dval = <decimal>valJson; }
            else { return []; }
            return [quantityToString(dval, unitJson)];
        }
    }
    return [];
}

isolated function applyToBooleanFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toBoolean", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is boolean {
        return [val];
    } else if val is int {
        if val == 1 { return [true]; }
        if val == 0 { return [false]; }
        return [];
    } else if val is decimal {
        if val == 1d { return [true]; }
        if val == 0d { return [false]; }
        return [];
    } else if val is string {
        string lower = val.toLowerAscii();
        if lower == "true" || lower == "t" || lower == "yes" || lower == "y" || lower == "1" || lower == "1.0" {
            return [true];
        }
        if lower == "false" || lower == "f" || lower == "no" || lower == "n" || lower == "0" || lower == "0.0" {
            return [false];
        }
        return [];
    }
    return [];
}

isolated function applyToDateFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toDate", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is string {
        // Accept @YYYY-MM-DD format or plain YYYY-MM-DD
        string s = val.startsWith("@") ? val : "@" + val;
        return [s];
    }
    return [];
}

isolated function applyToDateTimeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toDateTime", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is string {
        string s = val.startsWith("@") ? val : "@" + val;
        return [s];
    }
    return [];
}

isolated function applyToTimeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toTime", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is string {
        string s = val.startsWith("@T") ? val : "@T" + val;
        return [s];
    }
    return [];
}

isolated function applyConvertsToIntegerFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is int { return [true]; }
    if val is decimal || val is float { return [true]; }
    if val is boolean { return [true]; }
    if val is string {
        int|error i = int:fromString(val);
        if i is int { return [true]; }
        decimal|error d = decimal:fromString(val);
        return [d is decimal];
    }
    return [false];
}

isolated function applyConvertsToDecimalFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is decimal || val is int || val is float { return [true]; }
    if val is boolean { return [true]; }
    if val is string {
        decimal|error d = decimal:fromString(val);
        return [d is decimal];
    }
    return [false];
}

isolated function applyConvertsToStringFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is map<json> {
        return [val["value"] !is () && val["unit"] !is ()];
    }
    return [val is string || val is int || val is decimal || val is float || val is boolean];
}

isolated function applyConvertsToBooleanFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is boolean { return [true]; }
    if val is int { return [val == 0 || val == 1]; }
    if val is decimal { return [val == 0d || val == 1d]; }
    if val is string {
        string lower = val.toLowerAscii();
        return [lower == "true" || lower == "false" || lower == "t" || lower == "f"
            || lower == "yes" || lower == "no" || lower == "y" || lower == "n"
            || lower == "1" || lower == "0" || lower == "1.0" || lower == "0.0"];
    }
    return [false];
}

isolated function applyConvertsToDateFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is string {
        string s = val.startsWith("@") ? val.substring(1) : val;
        return [isDateFormat(s)];
    }
    return [false];
}

isolated function applyConvertsToDateTimeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is string {
        string s = val.startsWith("@") ? val.substring(1) : val;
        return [isDateFormat(s) || isDateTimeFormat(s)];
    }
    return [false];
}

isolated function applyConvertsToTimeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is string {
        string s = val.startsWith("@T") ? val.substring(2) : val.startsWith("T") ? val.substring(1) : val;
        return [isTimeFormat(s)];
    }
    return [false];
}

isolated function applyConvertsToQuantityFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is int || val is decimal || val is float { return [true]; }
    if val is boolean { return [true]; }
    if val is string { return [isValidQuantityString(val)]; }
    if val is map<json> {
        return [val["value"] !is () && val["unit"] !is ()];
    }
    return [false];
}

isolated function applyToQuantityFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toQuantity", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is int {
        return [{"value": <decimal>val, "unit": "1"}];
    }
    if val is decimal {
        return [{"value": val, "unit": "1"}];
    }
    if val is float {
        decimal|error d = decimal:fromString(val.toString());
        if d is decimal { return [{"value": d, "unit": "1"}]; }
        return [];
    }
    if val is boolean {
        return [{"value": val ? 1d : 0d, "unit": "1"}];
    }
    if val is string {
        map<json>? q = parseQuantityFromString(val);
        if q is () { return []; }
        json unitJson = q["unit"];
        json valJson = q["value"];
        if unitJson !is string || valJson !is decimal { return []; }
        return [quantityToString(<decimal>valJson, <string>unitJson)];
    }
    if val is map<json> {
        if val["value"] !is () && val["unit"] !is () {
            return [val];
        }
    }
    return [];
}

isolated function applyOfTypeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("ofType", "1 parameter", params.length());
    }
    string typeName = extractTypeName(params[0]);
    if typeName.length() == 0 {
        return fnError("ofType", "a type name", 0);
    }
    if !isKnownTypeSpecifier(typeName) {
        return error FHIRPathInterpreterError(string `ofType(): unknown type '${typeName}'`,
            token = {tokenType: IDENTIFIER, lexeme: "ofType", literal: (), position: 0});
    }
    FhirPathItem[] result = [];
    foreach FhirPathItem item in collection {
        if itemHasExactType(item, typeName) {
            result.push(item);
        }
    }
    return result;
}

isolated function applyHasValueFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("hasValue", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [false];
    }
    json val = systemValueOf(collection[0]);
    return [val !is () && !(val is map<json>) && !(val is json[])];
}

isolated function applyIifFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() < 2 || params.length() > 3 {
        return fnError("iif", "2 or 3 parameters", params.length());
    }
    FhirPathItem[] criterionResult = check evaluate(params[0], context, env);
    boolean criterion = criterionResult.length() > 0 && isTruthyValue(criterionResult[0]);

    if criterion {
        return check evaluate(params[1], context, env);
    } else if params.length() == 3 {
        return check evaluate(params[2], context, env);
    }
    return [];
}

isolated function applyPathnameFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env)
        returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() > 1 {
        return fnError("pathname", "0 or 1 parameter", params.length());
    }
    boolean short = false;
    if params.length() == 1 {
        FhirPathItem[] shortResult = check evaluate(params[0], context, env);
        short = shortResult.length() > 0 && valueOf(shortResult[0]) == true;
    }
    FhirPathItem[] result = [];
    foreach FhirPathItem item in collection {
        // Only navigated items have a location; computed values are excluded
        if item is TypedValue {
            string? path = short ? item.shortPath : item.path;
            if path is string {
                result.push(path);
            }
        }
    }
    return result;
}

isolated function applyTraceFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    // trace() is a no-op in production (side-effect only for debugging)
    return collection;
}

isolated function applyIsTypeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("is", "1 parameter", params.length());
    }
    string typeName = extractTypeName(params[0]);
    if typeName.length() == 0 {
        return [];
    }
    return applyIsType(collection, typeName);
}

// Shared by the `is` operator and is() function
isolated function applyIsType(FhirPathItem[] collection, string typeName) returns FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    return [itemIsOfType(collection[0], typeName)];
}

isolated function applyAsTypeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("as", "1 parameter", params.length());
    }
    string typeName = extractTypeName(params[0]);
    if typeName.length() == 0 {
        return fnError("as", "a type name", 0);
    }
    return applyAsType(collection, typeName, "as()");
}

// Shared by the `as` operator and as() function
isolated function applyAsType(FhirPathItem[] collection, string typeName, string label) returns FHIRPathInterpreterError|FhirPathItem[] {
    if !isKnownTypeSpecifier(typeName) {
        return error FHIRPathInterpreterError(string `${label}: unknown type '${typeName}'`,
            token = {tokenType: IDENTIFIER, lexeme: "as", literal: (), position: 0});
    }
    if collection.length() > 1 {
        return error FHIRPathInterpreterError(string `${label}: cannot cast a collection with more than 1 item`,
            token = {tokenType: IDENTIFIER, lexeme: "as", literal: (), position: 0});
    }
    FhirPathItem[] result = [];
    foreach FhirPathItem item in collection {
        if itemHasExactType(item, typeName) {
            result.push(item);
        }
    }
    return result;
}

// ========================================
// FORMAT HELPERS
// ========================================

isolated function isDateFormat(string s) returns boolean {
    // YYYY or YYYY-MM or YYYY-MM-DD
    if s.length() == 4 { return isDigits(s); }
    if s.length() == 7 { return isDigits(s.substring(0, 4)) && s.substring(4, 5) == "-" && isDigits(s.substring(5)); }
    if s.length() == 10 { return isDigits(s.substring(0, 4)) && s.substring(4, 5) == "-" && isDigits(s.substring(5, 7)) && s.substring(7, 8) == "-" && isDigits(s.substring(8)); }
    return false;
}

isolated function isDateTimeFormat(string s) returns boolean {
    return s.includes("T") && isDateFormat(s.substring(0, (s.indexOf("T") ?: 0)));
}

isolated function isTimeFormat(string s) returns boolean {
    // HH or HH:MM or HH:MM:SS or HH:MM:SS.fff
    return s.length() >= 2 && isDigits(s.substring(0, 2));
}

isolated function isDigits(string s) returns boolean {
    foreach int i in 0 ..< s.length() {
        string ch = s.substring(i, i + 1);
        int|error cp = int:fromString(ch);
        if cp is error { return false; }
    }
    return true;
}

// ========================================
// QUANTITY HELPERS
// ========================================

final readonly & string[] QUANTITY_CALENDAR_UNITS = [
    "year", "month", "week", "day", "hour", "minute", "second", "millisecond",
    "years", "months", "weeks", "days", "hours", "minutes", "seconds", "milliseconds"
];

isolated function isCalendarQuantityUnit(string unit) returns boolean {
    foreach string kw in QUANTITY_CALENDAR_UNITS {
        if unit == kw { return true; }
    }
    return false;
}

isolated function quantityToString(decimal val, string unit) returns string {
    string valStr = val.toString();
    // Strip trailing ".0" for whole numbers (e.g., 1.0 → "1")
    if valStr.endsWith(".0") {
        valStr = valStr.substring(0, valStr.length() - 2);
    }
    if isCalendarQuantityUnit(unit) {
        return valStr + " " + unit;
    }
    return valStr + " '" + unit + "'";
}

isolated function parseQuantityFromString(string s) returns map<json>? {
    string trimmed = s.trim();
    if trimmed.length() == 0 {
        return ();
    }
    int? spaceIdx = trimmed.indexOf(" ");
    string numStr;
    string unitPart;
    if spaceIdx is () {
        numStr = trimmed;
        unitPart = "";
    } else {
        numStr = trimmed.substring(0, <int>spaceIdx);
        unitPart = trimmed.substring(<int>spaceIdx + 1).trim();
    }
    decimal|error d = decimal:fromString(numStr);
    if d is error {
        return ();
    }
    string unit;
    if unitPart.length() == 0 {
        unit = "1";
    } else if unitPart.startsWith("'") && unitPart.endsWith("'") && unitPart.length() >= 2 {
        unit = unitPart.substring(1, unitPart.length() - 1);
    } else if isCalendarQuantityUnit(unitPart) {
        unit = unitPart;
    } else {
        return ();
    }
    return {"value": d, "unit": unit};
}

isolated function isValidQuantityString(string s) returns boolean {
    return parseQuantityFromString(s) !is ();
}
