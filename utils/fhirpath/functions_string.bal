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

import ballerina/regex;
import ballerina/lang.'array as langArray;

// ========================================
// STRING FUNCTIONS
// ========================================

isolated function applyLengthFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("length", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        return [val.length()];
    }
    return [];
}

isolated function applyTrimFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("trim", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        return [val.trim()];
    }
    return [];
}

isolated function applyToCharsFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("toChars", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        json[] chars = [];
        foreach int i in 0 ..< val.length() {
            chars.push(val.substring(i, i + 1));
        }
        return chars;
    }
    return [];
}

isolated function applySplitFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("split", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val !is string {
        return [];
    }
    json[] sepResult = check evaluate(params[0], context, env);
    if sepResult.length() == 0 {
        return [];
    }
    json sep = sepResult[0];
    if sep !is string {
        return [];
    }
    if sep == "" {
        json[] chars = [];
        foreach int i in 0 ..< val.length() {
            chars.push(val.substring(i, i + 1));
        }
        return chars;
    }
    json[] result = [];
    string remaining = val;
    while remaining.includes(sep) {
        int idx = remaining.indexOf(sep) ?: 0;
        result.push(remaining.substring(0, idx));
        remaining = remaining.substring(idx + sep.length());
    }
    result.push(remaining);
    return result;
}

isolated function applyJoinFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() > 1 {
        return fnError("join", "0 or 1 parameter", params.length());
    }
    string sep = "";
    if params.length() == 1 {
        json[] sepResult = check evaluate(params[0], context, env);
        if sepResult.length() > 0 && sepResult[0] is string {
            sep = <string>sepResult[0];
        }
    }
    string[] parts = [];
    foreach json item in collection {
        if item is string {
            parts.push(item);
        } else {
            parts.push(item.toString());
        }
    }
    return [string:'join(sep, ...parts)];
}

isolated function applyStartsWithFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("startsWith", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json[] prefResult = check evaluate(params[0], context, env);
    if prefResult.length() == 0 {
        return [];
    }
    json val = collection[0];
    json pref = prefResult[0];
    if val is string && pref is string {
        return [val.startsWith(pref)];
    }
    return [];
}

isolated function applyEndsWithFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("endsWith", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json[] suffResult = check evaluate(params[0], context, env);
    if suffResult.length() == 0 {
        return [];
    }
    json val = collection[0];
    json suff = suffResult[0];
    if val is string && suff is string {
        return [val.endsWith(suff)];
    }
    return [];
}

isolated function applyContainsStringFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("contains", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val !is string {
        return error FHIRPathInterpreterError("contains() requires a String input, got non-string value",
            token = {tokenType: IDENTIFIER, lexeme: "contains", literal: (), position: 0});
    }
    json[] subResult = check evaluate(params[0], context, env);
    if subResult.length() == 0 {
        return error FHIRPathInterpreterError("contains() substring parameter evaluated to empty",
            token = {tokenType: IDENTIFIER, lexeme: "contains", literal: (), position: 0});
    }
    json sub = subResult[0];
    if sub !is string {
        return error FHIRPathInterpreterError("contains() substring must be a String",
            token = {tokenType: IDENTIFIER, lexeme: "contains", literal: (), position: 0});
    }
    return [val.includes(sub)];
}

isolated function applyIndexOfFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("indexOf", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json[] subResult = check evaluate(params[0], context, env);
    if subResult.length() == 0 {
        return [];
    }
    json val = collection[0];
    json sub = subResult[0];
    if val is string && sub is string {
        int? idx = val.indexOf(sub);
        return [idx is int ? idx : -1];
    }
    return [];
}

isolated function applySubstringFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() < 1 || params.length() > 2 {
        return fnError("substring", "1 or 2 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val !is string {
        return [];
    }
    json[] startResult = check evaluate(params[0], context, env);
    if startResult.length() == 0 {
        return [];
    }
    int startIdx = toInt(startResult[0]);
    if startIdx < 0 {
        startIdx = 0;
    }
    if params.length() == 2 {
        json[] lenResult = check evaluate(params[1], context, env);
        if lenResult.length() == 0 {
            return [];
        }
        int len = toInt(lenResult[0]);
        int endIdx = startIdx + len;
        if startIdx >= val.length() {
            return [""];
        }
        if endIdx > val.length() {
            endIdx = val.length();
        }
        return [val.substring(startIdx, endIdx)];
    }
    if startIdx >= val.length() {
        return [""];
    }
    return [val.substring(startIdx)];
}

isolated function applyReplaceFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 2 {
        return fnError("replace", "2 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val !is string {
        return [];
    }
    json[] patResult = check evaluate(params[0], context, {scope: env.scope.childScope(), index: env?.index, total: env?.total});
    json[] repResult = check evaluate(params[1], context, {scope: env.scope.childScope(), index: env?.index, total: env?.total});
    if patResult.length() == 0 || repResult.length() == 0 {
        return [];
    }
    json pat = patResult[0];
    json rep = repResult[0];
    if pat is string && rep is string {
        if pat == "" {
            string buffer = rep;
            foreach string ch in val {
                buffer = buffer + ch + rep;
            }
            return [buffer];
        }
        string buffer = "";
        int startIdx = 0;
        while startIdx <= val.length() {
            int? matchIdx = val.indexOf(pat, startIdx);
            if matchIdx is () {
                buffer += val.substring(startIdx);
                break;
            }
            buffer += val.substring(startIdx, matchIdx) + rep;
            startIdx = matchIdx + pat.length();
        }
        return [buffer];
    }
    return [val];
}

isolated function applyMatchesFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("matches", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val !is string {
        return [];
    }
    json[] regexResult = check evaluate(params[0], context, env);
    if regexResult.length() == 0 {
        return [];
    }
    json regexVal = regexResult[0];
    if regexVal !is string {
        return [];
    }
    boolean|error matched = trap regex:matches(val, regexVal);
    if matched is boolean {
        return [matched];
    }
    return [false];
}

isolated function applyMatchesFullFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("matchesFull", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val !is string {
        return [];
    }
    json[] regexResult = check evaluate(params[0], context, env);
    if regexResult.length() == 0 {
        return [];
    }
    json regexVal = regexResult[0];
    if regexVal !is string {
        return [];
    }
    // Full-string match: anchor pattern and use regex:matches
    string anchored = "^(?:" + regexVal + ")$";
    boolean|error matched = trap regex:matches(val, anchored);
    if matched is boolean {
        return [matched];
    }
    return [false];
}

isolated function applyReplaceMatchesFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 2 {
        return fnError("replaceMatches", "2 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val !is string {
        return [];
    }
    json[] regexResult = check evaluate(params[0], context, {scope: env.scope.childScope(), index: env?.index, total: env?.total});
    json[] repResult = check evaluate(params[1], context, {scope: env.scope.childScope(), index: env?.index, total: env?.total});
    if regexResult.length() == 0 || repResult.length() == 0 {
        return [];
    }
    json regexVal = regexResult[0];
    json rep = repResult[0];
    if regexVal is string && rep is string {
        if regexVal == "" {
            return [val];
        }
        string|error result = trap regex:replaceAll(val, regexVal, rep);
        if result is string {
            return [result];
        }
        return [val];
    }
    return [val];
}

isolated function applyEncodeDecodeFunction(string funcName, json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError(funcName, "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val !is string {
        return [];
    }
    json[] fmtResult = check evaluate(params[0], context, env);
    if fmtResult.length() == 0 {
        return [];
    }
    json fmt = fmtResult[0];
    if fmt !is string {
        return [];
    }
    if fmt == "base64" {
        if funcName == "encode" {
            return [val.toBytes().toBase64()];
        } else {
            byte[]|error bytes = langArray:fromBase64(val);
            if bytes is byte[] {
                string|error decoded = string:fromBytes(bytes);
                if decoded is string {
                    return [decoded];
                }
            }
            return [];
        }
    } else if fmt == "hex" || fmt == "base16" {
        if funcName == "encode" {
            return [bytesToHex(val.toBytes())];
        } else {
            byte[]|error bytes = hexToBytes(val);
            if bytes is byte[] {
                string|error decoded = string:fromBytes(bytes);
                if decoded is string {
                    return [decoded];
                }
            }
            return [];
        }
    } else if fmt == "urlbase64" {
        if funcName == "encode" {
            string b64 = val.toBytes().toBase64();
            string urlSafe = strReplaceAll(strReplaceAll(strReplaceAll(b64, "+", "-"), "/", "_"), "=", "");
            return [urlSafe];
        }
    }
    return [];
}

isolated function applyEscapeUnescapeFunction(string funcName, json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError(funcName, "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val !is string {
        return [];
    }
    json[] fmtResult = check evaluate(params[0], context, env);
    if fmtResult.length() == 0 {
        return [];
    }
    json fmt = fmtResult[0];
    if fmt !is string {
        return [];
    }
    if fmt == "json" || fmt == "html" {
        if funcName == "escape" {
            string result = strReplaceAll(strReplaceAll(strReplaceAll(strReplaceAll(val, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), "\"", "&quot;");
            return [result];
        } else {
            string result = strReplaceAll(strReplaceAll(strReplaceAll(strReplaceAll(val, "&amp;", "&"), "&lt;", "<"), "&gt;", ">"), "&quot;", "\"");
            return [result];
        }
    }
    return [val];
}

// ========================================
// HELPERS
// ========================================

isolated function strReplaceAll(string str, string needle, string replacement) returns string {
    if needle == "" {
        return str;
    }
    string buffer = "";
    int startIdx = 0;
    while startIdx <= str.length() {
        int? matchIdx = str.indexOf(needle, startIdx);
        if matchIdx is () {
            buffer += str.substring(startIdx);
            break;
        }
        buffer += str.substring(startIdx, matchIdx) + replacement;
        startIdx = matchIdx + needle.length();
    }
    return buffer;
}

isolated function toInt(json val) returns int {
    if val is int {
        return val;
    } else if val is decimal {
        return <int>val;
    } else if val is float {
        return <int>val;
    } else if val is string {
        int|error i = int:fromString(val);
        return i is int ? i : 0;
    }
    return 0;
}

isolated function bytesToHex(byte[] bytes) returns string {
    string result = "";
    string hexChars = "0123456789abcdef";
    foreach byte b in bytes {
        int hi = (b >> 4) & 0xF;
        int lo = b & 0xF;
        result = result + hexChars.substring(hi, hi + 1) + hexChars.substring(lo, lo + 1);
    }
    return result;
}

isolated function hexToBytes(string hex) returns byte[]|error {
    if hex.length() % 2 != 0 {
        return error("Invalid hex string length");
    }
    byte[] result = [];
    foreach int i in 0 ..< hex.length() / 2 {
        string byteStr = hex.substring(i * 2, i * 2 + 2);
        int|error hi = hexCharToInt(byteStr.substring(0, 1));
        int|error lo = hexCharToInt(byteStr.substring(1, 2));
        if hi is error || lo is error {
            return error("Invalid hex character");
        }
        result.push(<byte>((hi * 16) + lo));
    }
    return result;
}

isolated function hexCharToInt(string ch) returns int|error {
    string lower = ch.toLowerAscii();
    if lower >= "0" && lower <= "9" {
        int|error v = int:fromString(lower);
        return v;
    }
    if lower == "a" { return 10; }
    if lower == "b" { return 11; }
    if lower == "c" { return 12; }
    if lower == "d" { return 13; }
    if lower == "e" { return 14; }
    if lower == "f" { return 15; }
    return error("Invalid hex char: " + ch);
}

isolated function applyUpperFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("upper", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        return [val.toUpperAscii()];
    }
    return [];
}

isolated function applyLowerFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("lower", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is string {
        return [val.toLowerAscii()];
    }
    return [];
}
