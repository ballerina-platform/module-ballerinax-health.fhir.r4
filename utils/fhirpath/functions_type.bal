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
    } else if val is boolean {
        return [val ? 1 : 0];
    } else if val is string {
        if !re `(\+|-)?[0-9]+`.isFullMatch(val) {
            return [];
        }
        int|error i = int:fromString(val.startsWith("+") ? val.substring(1) : val);
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
        return (parsed is int) ? parsed : ();
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
        // fromString keeps the integer's scale (a numeric conversion would yield 1.0 for 1)
        decimal|error d = decimal:fromString(val.toString());
        return (d is decimal) ? [d] : [];
    } else if val is float {
        decimal|error d = decimal:fromString(val.toString());
        if d is decimal {
            return [d];
        }
        return [];
    } else if val is boolean {
        return [val ? 1d : 0d];
    } else if val is string {
        decimal? d = decimalFromString(val);
        return (d is decimal) ? [d] : [];
    }
    return [];
}

// Decimal conversion of a string matching (\+|-)?\d+(\.\d+)?; an integer may carry a Long suffix ('42L')
isolated function decimalFromString(string val) returns decimal? {
    if !re `(\+|-)?[0-9]+((\.[0-9]+)|L)?`.isFullMatch(val) {
        return ();
    }
    string digits = val.endsWith("L") ? val.substring(0, val.length() - 1) : val;
    decimal|error d = decimal:fromString(digits.startsWith("+") ? digits.substring(1) : digits);
    return d is decimal ? d : ();
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

isolated function applyToDateFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    string? converted = check convertDateTimeInput(collection, params, context, env, "toDate", false);
    return (converted is string) ? [systemItem("Date", converted)] : [];
}

isolated function applyConvertsToDateFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    return [check convertDateTimeInput(collection, params, context, env, "convertsToDate", false) is string];
}

isolated function applyToDateTimeFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    string? converted = check convertDateTimeInput(collection, params, context, env, "toDateTime", true);
    return (converted is string) ? [systemItem("DateTime", converted)] : [];
}

isolated function applyConvertsToDateTimeFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    return [check convertDateTimeInput(collection, params, context, env, "convertsToDateTime", true) is string];
}

// Shared by toDate()/toDateTime() and their convertsTo variants. Returns the '@'-prefixed Date (or DateTime
// when `toDateTime` is set) the single input converts to, or () when it does not convert.
isolated function convertDateTimeInput(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env,
        string name, boolean toDateTime) returns string?|FHIRPathInterpreterError {
    if params.length() > 1 {
        return fnError(name, "0 or 1 parameter", params.length());
    }
    FhirPathItem? input = check singleInput(collection, name);
    if input is () {
        return ();
    }
    string kind = systemTypeOf(input);
    json val = systemValueOf(input);
    if val !is string {
        return ();
    }
    if kind == "Date" || kind == "DateTime" {
        // The format parameter is ignored for non-string inputs
        string datePart = datePartOf(val);
        if !toDateTime {
            return "@" + datePart;
        }
        return kind == "Date" ? "@" + datePart + "T" : val;
    }
    if kind != "String" {
        return ();
    }
    DateTimeParts? parts;
    if params.length() == 1 {
        string? format = check stringParam(params[0], context, env);
        if format is () {
            return ();
        }
        parts = parseDateTimeWithFormat(val, format);
    } else {
        parts = toDateTime ? parseIsoDateTime(val) : parseIsoDate(val);
    }
    if parts is () {
        return ();
    }
    return toDateTime ? "@" + formatDateTimeParts(parts) : "@" + formatDateParts(parts);
}

isolated function applyToTimeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toTime", "0 parameters", params.length());
    }
    string? converted = check convertTimeInput(collection, "toTime");
    return (converted is string) ? [systemItem("Time", converted)] : [];
}

isolated function applyConvertsToTimeFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    return [check convertTimeInput(collection, "convertsToTime") is string];
}

isolated function convertTimeInput(FhirPathItem[] collection, string name) returns string?|FHIRPathInterpreterError {
    FhirPathItem? input = check singleInput(collection, name);
    if input is () {
        return ();
    }
    string kind = systemTypeOf(input);
    json val = systemValueOf(input);
    if val !is string {
        return ();
    }
    if kind == "Time" {
        return val;
    }
    if kind == "String" {
        string s = val.startsWith("T") ? val.substring(1) : val;
        return isTimeFormat(s) ? "@T" + s : ();
    }
    return ();
}

isolated function applyConvertsToIntegerFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    // Integers, Booleans and strings matching (\+|-)?\d+ convert; Decimals do not
    if val is int || val is boolean { return [true]; }
    if val is string {
        return [re `(\+|-)?[0-9]+`.isFullMatch(val)];
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
        return [decimalFromString(val) is decimal];
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

isolated function applyConvertsToQuantityFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if collection.length() == 0 {
        return [];
    }
    return [check convertQuantityInput(collection, params, context, env, "convertsToQuantity") is TypedValue];
}

isolated function applyToQuantityFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    TypedValue? converted = check convertQuantityInput(collection, params, context, env, "toQuantity");
    return (converted is TypedValue) ? [converted] : [];
}

// Shared by toQuantity() and convertsToQuantity(): the Quantity the single input converts to,
// expressed in the requested unit when one is given
isolated function convertQuantityInput(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env,
        string name) returns TypedValue?|FHIRPathInterpreterError {
    if params.length() > 1 {
        return fnError(name, "0 or 1 parameter", params.length());
    }
    FhirPathItem? input = check singleInput(collection, name);
    if input is () {
        return ();
    }
    string kind = systemTypeOf(input);
    json val = valueOf(input);
    decimal value;
    string unit;
    if (kind == "Integer" || kind == "Long" || kind == "Decimal") && (val is int || val is decimal || val is float) {
        [value, unit] = [toDecimalValue(val), "1"];
    } else if val is boolean {
        [value, unit] = [val ? 1.0d : 0.0d, "1"];
    } else if kind == "String" && val is string {
        map<json>? parsed = parseQuantityFromString(val);
        if parsed is () {
            return ();
        }
        [value, unit] = [toDecimalValue(parsed["value"]), <string>parsed["unit"]];
    } else if kind == "Quantity" && val is map<json> && val["value"] !is () {
        json code = val["code"];
        json unitJson = val["unit"];
        [value, unit] = [toDecimalValue(val["value"]), code is string ? code : (unitJson is string ? unitJson : "1")];
    } else {
        return ();
    }
    if params.length() == 1 {
        string? targetUnit = check stringParam(params[0], context, env);
        if targetUnit is () {
            return ();
        }
        decimal? converted = convertQuantity(value, unit, targetUnit);
        if converted is () {
            return ();
        }
        return quantityItem(converted, targetUnit);
    }
    return quantityItem(value, unit);
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
    // iif() is scoped: the criterion and both results are evaluated with $this set to the input item
    FhirPathItem? input = check singleInput(collection, "iif");
    FhirPathEnv scopedEnv = {index: env?.index, total: env?.total, scope: env.scope.childScope()};
    FhirPathItem[] criterionResult = check evaluate(params[0], input, scopedEnv);
    if criterionResult.length() > 1 {
        return error FHIRPathInterpreterError("iif() criterion must be a single Boolean, got a collection",
            token = {tokenType: IDENTIFIER, lexeme: "iif", literal: (), position: 0});
    }
    // Singleton evaluation: a single item that is not a Boolean counts as true (iif('hi', ...), iif(0, ...))
    json criterionValue = criterionResult.length() == 1 ? valueOf(criterionResult[0]) : false;
    boolean criterion = criterionValue is boolean ? criterionValue : true;
    if criterion {
        return evaluate(params[1], input, scopedEnv);
    }
    return params.length() == 3 ? evaluate(params[2], input, scopedEnv) : [];
}

isolated function applyComparableFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env)
        returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("comparable", "1 parameter", params.length());
    }
    FhirPathItem[] other = check evaluate(params[0], context, env);
    // Empty unless both sides are single quantities (numbers implicitly convert with the unit '1')
    if collection.length() != 1 || other.length() != 1 || quantityOf(collection[0]) is () || quantityOf(other[0]) is () {
        return [];
    }
    return [alignQuantityItems(collection[0], other[0], false) is [decimal, decimal]];
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

isolated function isTimeFormat(string s) returns boolean {
    // HH or HH:MM or HH:MM:SS or HH:MM:SS.fff
    return re `[0-9]{2}(:[0-9]{2}(:[0-9]{2}(\.[0-9]+)?)?)?`.isFullMatch(s);
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
    int i = 0;
    if trimmed.startsWith("+") || trimmed.startsWith("-") {
        i = 1;
    }
    while i < trimmed.length() && isDigit(trimmed.substring(i, i + 1)) {
        i += 1;
    }
    if i < trimmed.length() && trimmed.substring(i, i + 1) == "." {
        i += 1;
        while i < trimmed.length() && isDigit(trimmed.substring(i, i + 1)) {
            i += 1;
        }
    }
    string numStr = trimmed.substring(0, i);
    if !re `(\+|-)?[0-9]+(\.[0-9]+)?`.isFullMatch(numStr) {
        return ();
    }
    decimal|error d = decimal:fromString(numStr.startsWith("+") ? numStr.substring(1) : numStr);
    if d is error {
        return ();
    }
    string unitPart = trimmed.substring(i).trim();
    string unit;
    if unitPart.length() == 0 {
        unit = "1";
    } else if unitPart.startsWith("'") && unitPart.endsWith("'") && unitPart.length() > 2
            && !unitPart.substring(1, unitPart.length() - 1).includes("'") {
        unit = unitPart.substring(1, unitPart.length() - 1);
    } else if isCalendarQuantityUnit(unitPart) {
        unit = unitPart;
    } else {
        return ();
    }
    return {"value": d, "unit": unit};
}

