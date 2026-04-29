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

final readonly & string[] SYSTEM_PRIMITIVE_NAMES = ["Boolean", "Integer", "String", "Decimal", "Quantity", "Date", "DateTime", "Time", "Any"];

final readonly & map<string> FHIR_FIELD_TYPES = {
    "Patient.gender": "code",
    "Patient.name": "HumanName",
    "Questionnaire.url": "uri",
    "ValueSet.version": "string",
    "Observation.status": "code",
    "Observation.valueQuantity": "Quantity"
};

isolated function getDeclaredFhirType(Expr? e) returns string? {
    if e is MemberAccessExpr {
        Expr tgt = e.target;
        if tgt is IdentifierExpr {
            return FHIR_FIELD_TYPES[tgt.name + "." + e.member];
        }
    }
    return ();
}

isolated function fhirTypeIsA(string child, string parent) returns boolean {
    string c = child.toLowerAscii();
    string p = parent.toLowerAscii();
    if c == p { return true; }
    if p == "string" {
        return c == "code" || c == "id" || c == "markdown" || c == "uri"
            || c == "url" || c == "canonical" || c == "oid" || c == "uuid"
            || c == "base64binary" || c == "date" || c == "datetime"
            || c == "time" || c == "instant";
    }
    if p == "uri" {
        return c == "url" || c == "canonical" || c == "oid" || c == "uuid";
    }
    if p == "quantity" {
        return c == "age" || c == "duration";
    }
    if p == "element" || p == "resource" || p == "domainresource" { return true; }
    return false;
}

isolated function isKnownFhirType(string typeName) returns boolean {
    string name = typeName;
    if name.includes(".") {
        int? dot = name.lastIndexOf(".");
        if dot is int { name = name.substring(dot + 1); }
    }
    if name.length() == 0 { return false; }
    foreach int i in 0 ..< name.length() {
        string ch = name.substring(i, i + 1);
        if ch >= "0" && ch <= "9" { return false; }
    }
    return true;
}

isolated function exactFhirTypeMatch(json item, string typeName, string? declaredFhirType) returns boolean {
    string simpleName = typeName.toLowerAscii();
    if simpleName.includes(".") {
        int? dot = simpleName.lastIndexOf(".");
        if dot is int { simpleName = simpleName.substring(dot + 1); }
    }
    if item is map<json> {
        json fhirTypeTag = item["__fhirType"];
        if fhirTypeTag is string {
            return fhirTypeTag.toLowerAscii() == simpleName;
        }
        json rt = item["resourceType"];
        if rt is string { return rt.toLowerAscii() == simpleName; }
        if declaredFhirType is string {
            return declaredFhirType.toLowerAscii() == simpleName;
        }
        return simpleName == "element" || simpleName == "backboneelement"
            || simpleName == "resource" || simpleName == "domainresource";
    }
    if item is string {
        if declaredFhirType is string {
            return declaredFhirType.toLowerAscii() == simpleName;
        }
        return simpleName == "string" || simpleName == "code" || simpleName == "id"
            || simpleName == "markdown" || simpleName == "uri" || simpleName == "url"
            || simpleName == "canonical" || simpleName == "oid" || simpleName == "uuid"
            || simpleName == "date" || simpleName == "datetime" || simpleName == "instant"
            || simpleName == "time" || simpleName == "base64binary";
    }
    if item is boolean { return simpleName == "boolean"; }
    if item is int { return simpleName == "integer" || simpleName == "positiveint" || simpleName == "unsignedint"; }
    if item is decimal || item is float { return simpleName == "decimal"; }
    return false;
}

isolated function isSystemTypeName(string typeName) returns boolean {
    foreach string n in SYSTEM_PRIMITIVE_NAMES {
        if typeName == n { return true; }
    }
    return false;
}

isolated function isSystemSourceExpr(Expr? e) returns boolean {
    if e is LiteralExpr { return true; }
    if e is UnaryExpr { return isSystemSourceExpr(e.operand); }
    if e is QuantityLiteralExpr { return true; }
    return false;
}

isolated function applyTypeFunction(json[] collection, Expr[] params, Expr? targetExpr) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("type", "0 parameters", params.length());
    }
    if collection.length() == 0 { return []; }
    boolean isSystemSource = isSystemSourceExpr(targetExpr);
    json[] results = [];
    foreach json item in collection {
        results.push(classInfoOf(item, isSystemSource));
    }
    return results;
}

isolated function classInfoOf(json item, boolean isSystem) returns map<json> {
    if item is map<json> {
        json rt = item["resourceType"];
        if rt is string { return {"namespace": "FHIR", "name": rt}; }
    }
    if isSystem {
        if item is int { return {"namespace": "System", "name": "Integer"}; }
        if item is decimal || item is float { return {"namespace": "System", "name": "Decimal"}; }
        if item is string { return {"namespace": "System", "name": "String"}; }
        if item is boolean { return {"namespace": "System", "name": "Boolean"}; }
    } else {
        if item is boolean { return {"namespace": "FHIR", "name": "boolean"}; }
        if item is int { return {"namespace": "FHIR", "name": "integer"}; }
        if item is decimal || item is float { return {"namespace": "FHIR", "name": "decimal"}; }
        if item is string { return {"namespace": "FHIR", "name": "string"}; }
    }
    return {"namespace": "FHIR", "name": "unknown"};
}

isolated function applyToIntegerFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("toInteger", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
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

isolated function applyToDecimalFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("toDecimal", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
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

isolated function applyToStringFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("toString", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
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

isolated function applyToBooleanFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("toBoolean", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
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

isolated function applyToDateFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("toDate", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        // Accept @YYYY-MM-DD format or plain YYYY-MM-DD
        string s = val.startsWith("@") ? val : "@" + val;
        return [s];
    }
    return [];
}

isolated function applyToDateTimeFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("toDateTime", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        string s = val.startsWith("@") ? val : "@" + val;
        return [s];
    }
    return [];
}

isolated function applyToTimeFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("toTime", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        string s = val.startsWith("@T") ? val : "@T" + val;
        return [s];
    }
    return [];
}

isolated function applyConvertsToIntegerFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
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

isolated function applyConvertsToDecimalFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is decimal || val is int || val is float { return [true]; }
    if val is boolean { return [true]; }
    if val is string {
        decimal|error d = decimal:fromString(val);
        return [d is decimal];
    }
    return [false];
}

isolated function applyConvertsToStringFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is map<json> {
        return [val["value"] !is () && val["unit"] !is ()];
    }
    return [val is string || val is int || val is decimal || val is float || val is boolean];
}

isolated function applyConvertsToBooleanFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
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

isolated function applyConvertsToDateFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        string s = val.startsWith("@") ? val.substring(1) : val;
        return [isDateFormat(s)];
    }
    return [false];
}

isolated function applyConvertsToDateTimeFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        string s = val.startsWith("@") ? val.substring(1) : val;
        return [isDateFormat(s) || isDateTimeFormat(s)];
    }
    return [false];
}

isolated function applyConvertsToTimeFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        string s = val.startsWith("@T") ? val.substring(2) : val.startsWith("T") ? val.substring(1) : val;
        return [isTimeFormat(s)];
    }
    return [false];
}

isolated function applyConvertsToQuantityFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is int || val is decimal || val is float { return [true]; }
    if val is boolean { return [true]; }
    if val is string { return [isValidQuantityString(val)]; }
    if val is map<json> {
        return [val["value"] !is () && val["unit"] !is ()];
    }
    return [false];
}

isolated function applyToQuantityFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("toQuantity", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
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

isolated function applyOfTypeFunction(json[] collection, Expr[] params, json context, FhirPathEnv env, Expr? targetExpr = ()) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("ofType", "1 parameter", params.length());
    }
    string typeName = extractTypeName(params[0]);
    if typeName.length() == 0 {
        return fnError("ofType", "a type name", 0);
    }
    if !isKnownFhirType(typeName) {
        return error FHIRPathInterpreterError(string `ofType(): unknown type '${typeName}'`,
            token = {tokenType: IDENTIFIER, lexeme: "ofType", literal: (), position: 0});
    }
    string? declaredType = getDeclaredFhirType(targetExpr);
    json[] result = [];
    foreach json item in collection {
        if exactFhirTypeMatch(item, typeName, declaredType) {
            result.push(item);
        }
    }
    return result;
}

isolated function applyHasValueFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("hasValue", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [false];
    }
    json val = collection[0];
    return [val !is () && !(val is map<json>) && !(val is json[])];
}

isolated function applyIifFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() < 2 || params.length() > 3 {
        return fnError("iif", "2 or 3 parameters", params.length());
    }
    json[] criterionResult = check evaluate(params[0], context, env);
    boolean criterion = criterionResult.length() > 0 && isTruthyValue(criterionResult[0]);

    if criterion {
        return check evaluate(params[1], context, env);
    } else if params.length() == 3 {
        return check evaluate(params[2], context, env);
    }
    return [];
}

isolated function applyTraceFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    // trace() is a no-op in production (side-effect only for debugging)
    return collection;
}

isolated function applyIsTypeFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("is", "1 parameter", params.length());
    }
    string typeName = extractTypeName(params[0]);
    if typeName.length() == 0 {
        return [];
    }
    if collection.length() == 0 {
        return [false];
    }
    return [matchesFhirType(collection[0], typeName)];
}

isolated function applyAsTypeFunction(json[] collection, Expr[] params, json context, FhirPathEnv env, Expr? targetExpr = ()) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("as", "1 parameter", params.length());
    }
    string typeName = extractTypeName(params[0]);
    if typeName.length() == 0 {
        return fnError("as", "a type name", 0);
    }
    if !isKnownFhirType(typeName) {
        return error FHIRPathInterpreterError(string `as(): unknown type '${typeName}'`,
            token = {tokenType: IDENTIFIER, lexeme: "as", literal: (), position: 0});
    }
    if collection.length() > 1 {
        return error FHIRPathInterpreterError("as(): cannot cast a collection with more than 1 item",
            token = {tokenType: IDENTIFIER, lexeme: "as", literal: (), position: 0});
    }
    string? declaredType = getDeclaredFhirType(targetExpr);
    json[] result = [];
    foreach json item in collection {
        if exactFhirTypeMatch(item, typeName, declaredType) {
            result.push(item);
        }
    }
    return result;
}

// ========================================
// TYPE CHECKING HELPERS
// ========================================

isolated function matchesFhirType(json item, string typeName, boolean isLiteralSource = false, string? declaredFhirType = ()) returns boolean {
    string lowerType = typeName.toLowerAscii();
    boolean isSystemQualified = lowerType.startsWith("system.");
    boolean isFhirQualified = lowerType.startsWith("fhir.");
    boolean isSystemContext = isSystemQualified || (!isFhirQualified && isSystemTypeName(typeName));

    string simpleName;
    if lowerType.includes(".") {
        int? lastDot = lowerType.lastIndexOf(".");
        simpleName = lastDot is int ? lowerType.substring(lastDot + 1) : lowerType;
    } else {
        simpleName = lowerType;
    }

    if item is () { return false; }

    if item is map<json> {
        if isSystemContext { return false; }
        json fhirTypeTag = item["__fhirType"];
        if fhirTypeTag is string {
            return fhirTypeIsA(fhirTypeTag, typeName);
        }
        json resourceType = item["resourceType"];
        if resourceType is string {
            return resourceType.toLowerAscii() == simpleName;
        }
        return simpleName == "element" || simpleName == "backboneelement"
            || simpleName == "resource" || simpleName == "domainresource";
    }

    if isSystemContext {
        if !isLiteralSource { return false; }
        if item is boolean { return simpleName == "boolean"; }
        if item is int { return simpleName == "integer" || simpleName == "positiveint" || simpleName == "unsignedint"; }
        if item is decimal || item is float { return simpleName == "decimal"; }
        if item is string {
            return simpleName == "string" || simpleName == "date" || simpleName == "datetime" || simpleName == "time";
        }
        return false;
    }

    if item is boolean { return simpleName == "boolean"; }
    if item is int { return simpleName == "integer" || simpleName == "positiveint" || simpleName == "unsignedint"; }
    if item is decimal || item is float { return simpleName == "decimal"; }
    if item is string {
        if declaredFhirType is string {
            return fhirTypeIsA(declaredFhirType, typeName);
        }
        return simpleName == "string" || simpleName == "code" || simpleName == "id"
            || simpleName == "markdown" || simpleName == "uri" || simpleName == "url"
            || simpleName == "canonical" || simpleName == "oid" || simpleName == "uuid"
            || simpleName == "date" || simpleName == "datetime" || simpleName == "instant"
            || simpleName == "time" || simpleName == "base64binary";
    }
    return false;
}

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
