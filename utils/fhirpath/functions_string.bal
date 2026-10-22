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

isolated function applyLengthFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("length", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val is string {
        return [val.length()];
    }
    return [];
}

isolated function applyTrimFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("trim", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val is string {
        return [val.trim()];
    }
    return [];
}

isolated function applyToCharsFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("toChars", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val is string {
        FhirPathItem[] chars = [];
        foreach int i in 0 ..< val.length() {
            chars.push(val.substring(i, i + 1));
        }
        return chars;
    }
    return [];
}

isolated function applySplitFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("split", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val !is string {
        return [];
    }
    FhirPathItem[] sepResult = check evaluate(params[0], context, env);
    if sepResult.length() == 0 {
        return [];
    }
    json sep = valueOf(sepResult[0]);
    if sep !is string {
        return [];
    }
    if sep == "" {
        FhirPathItem[] chars = [];
        foreach int i in 0 ..< val.length() {
            chars.push(val.substring(i, i + 1));
        }
        return chars;
    }
    FhirPathItem[] result = [];
    string remaining = val;
    while remaining.includes(sep) {
        int idx = remaining.indexOf(sep) ?: 0;
        result.push(remaining.substring(0, idx));
        remaining = remaining.substring(idx + sep.length());
    }
    result.push(remaining);
    return result;
}

isolated function applyJoinFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() > 1 {
        return fnError("join", "0 or 1 parameter", params.length());
    }
    string sep = "";
    if params.length() == 1 {
        FhirPathItem[] sepResult = check evaluate(params[0], context, env);
        json sepVal = sepResult.length() > 0 ? valueOf(sepResult[0]) : ();
        if sepVal is string {
            sep = sepVal;
        }
    }
    string[] parts = [];
    foreach FhirPathItem item in collection {
        json val = valueOf(item);
        parts.push(val is string ? val : val.toString());
    }
    return [string:'join(sep, ...parts)];
}

isolated function applyStartsWithFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("startsWith", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    FhirPathItem[] prefResult = check evaluate(params[0], context, env);
    if prefResult.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    json pref = valueOf(prefResult[0]);
    if val is string && pref is string {
        return [val.startsWith(pref)];
    }
    return [];
}

isolated function applyEndsWithFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("endsWith", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    FhirPathItem[] suffResult = check evaluate(params[0], context, env);
    if suffResult.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    json suff = valueOf(suffResult[0]);
    if val is string && suff is string {
        return [val.endsWith(suff)];
    }
    return [];
}

isolated function applyContainsStringFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("contains", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val !is string {
        return error FHIRPathInterpreterError("contains() requires a String input, got non-string value",
            token = {tokenType: IDENTIFIER, lexeme: "contains", literal: (), position: 0});
    }
    FhirPathItem[] subResult = check evaluate(params[0], context, env);
    if subResult.length() == 0 {
        return error FHIRPathInterpreterError("contains() substring parameter evaluated to empty",
            token = {tokenType: IDENTIFIER, lexeme: "contains", literal: (), position: 0});
    }
    json sub = valueOf(subResult[0]);
    if sub !is string {
        return error FHIRPathInterpreterError("contains() substring must be a String",
            token = {tokenType: IDENTIFIER, lexeme: "contains", literal: (), position: 0});
    }
    return [val.includes(sub)];
}

isolated function applyIndexOfFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("indexOf", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    FhirPathItem[] subResult = check evaluate(params[0], context, env);
    if subResult.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    json sub = valueOf(subResult[0]);
    if val is string && sub is string {
        int? idx = val.indexOf(sub);
        return [idx is int ? idx : -1];
    }
    return [];
}

isolated function applyLastIndexOfFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError("lastIndexOf", "1 parameter", params.length());
    }
    FhirPathItem? input = check singleInput(collection, "lastIndexOf");
    if input is () {
        return [];
    }
    FhirPathItem[] subResult = check evaluate(params[0], context, env);
    if subResult.length() == 0 {
        return [];
    }
    json val = valueOf(input);
    json sub = valueOf(subResult[0]);
    if val is string && sub is string {
        if sub == "" {
            return [val.length()];
        }
        int? idx = val.lastIndexOf(sub);
        return [idx is int ? idx : -1];
    }
    return [];
}

isolated function applySubstringFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() < 1 || params.length() > 2 {
        return fnError("substring", "1 or 2 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val !is string {
        return [];
    }
    FhirPathItem[] startResult = check evaluate(params[0], context, env);
    if startResult.length() == 0 {
        return [];
    }
    int startIdx = toInt(startResult[0]);
    if startIdx < 0 {
        startIdx = 0;
    }
    if params.length() == 2 {
        FhirPathItem[] lenResult = check evaluate(params[1], context, env);
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

isolated function applyReplaceFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 2 {
        return fnError("replace", "2 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val !is string {
        return [];
    }
    FhirPathItem[] patResult = check evaluate(params[0], context, {scope: env.scope.childScope(), index: env?.index, total: env?.total});
    FhirPathItem[] repResult = check evaluate(params[1], context, {scope: env.scope.childScope(), index: env?.index, total: env?.total});
    if patResult.length() == 0 || repResult.length() == 0 {
        return [];
    }
    json pat = valueOf(patResult[0]);
    json rep = valueOf(repResult[0]);
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

isolated function applyMatchesFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    return applyRegexMatch(collection, params, context, env, "matches", false);
}

isolated function applyMatchesFullFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    return applyRegexMatch(collection, params, context, env, "matchesFull", true);
}

// matches() succeeds when the regex matches any part of the input, matchesFull() when it matches all of it
isolated function applyRegexMatch(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env,
        string name, boolean full) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() < 1 || params.length() > 2 {
        return fnError(name, "1 or 2 parameters", params.length());
    }
    FhirPathItem? input = check singleInput(collection, name);
    if input is () {
        return [];
    }
    json val = valueOf(input);
    if val !is string {
        return [];
    }
    string? pattern = check stringParam(params[0], context, env);
    if pattern is () {
        return [];
    }
    string flags = params.length() == 2 ? (check stringParam(params[1], context, env) ?: "") : "";
    string prefix = check regexFlagPrefix(flags, name);
    string regexStr = full ? prefix + "(?:" + pattern + ")" : prefix + ".*?(?:" + pattern + ").*";
    boolean|error matched = trap regex:matches(val, regexStr);
    if matched is error {
        return error FHIRPathInterpreterError(string `${name}(): invalid regular expression '${pattern}'`,
            token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
    }
    return [matched];
}

isolated function applyReplaceMatchesFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() < 2 || params.length() > 3 {
        return fnError("replaceMatches", "2 or 3 parameters", params.length());
    }
    FhirPathItem? input = check singleInput(collection, "replaceMatches");
    if input is () {
        return [];
    }
    json val = valueOf(input);
    if val !is string {
        return [];
    }
    string? pattern = check stringParam(params[0], context, env);
    string? substitution = check stringParam(params[1], context, env);
    if pattern is () || substitution is () {
        return [];
    }
    if pattern == "" {
        return [val];
    }
    string flags = params.length() == 3 ? (check stringParam(params[2], context, env) ?: "") : "";
    string prefix = check regexFlagPrefix(flags, "replaceMatches");
    final readonly & map<int> groupIndexes = captureGroupIndexes(pattern).cloneReadOnly();
    final string replacement = substitution;
    string|error result = trap regex:replaceAll(val, prefix + pattern,
        isolated function(regex:Match matched) returns string => expandSubstitution(replacement, matched, groupIndexes));
    if result is error {
        return error FHIRPathInterpreterError(string `replaceMatches(): invalid regular expression '${pattern}'`,
            token = {tokenType: IDENTIFIER, lexeme: "replaceMatches", literal: (), position: 0});
    }
    return [result];
}

// Expands $n and ${name} group references in a replaceMatches() substitution
isolated function expandSubstitution(string substitution, regex:Match matched, map<int> groupIndexes) returns string {
    string result = "";
    int i = 0;
    while i < substitution.length() {
        string ch = substitution.substring(i, i + 1);
        if ch == "$" && i + 1 < substitution.length() {
            int? groupIndex = ();
            int next = i + 1;
            if substitution.substring(next, next + 1) == "{" {
                int? close = substitution.indexOf("}", next);
                if close is int {
                    groupIndex = groupIndexes[substitution.substring(next + 1, close)];
                    next = close + 1;
                }
            } else {
                int end = next;
                while end < substitution.length() && isDigit(substitution.substring(end, end + 1)) {
                    end += 1;
                }
                if end > next {
                    groupIndex = digitsToInt(substitution.substring(next, end));
                    next = end;
                }
            }
            if groupIndex is int {
                // get() panics for an index past the last group; such references are kept literally
                regex:PartMatch?|error group = trap matched.groups.get(groupIndex);
                if group !is error {
                    result += group is regex:PartMatch ? group.matched : "";
                    i = next;
                    continue;
                }
            }
        }
        result += ch;
        i += 1;
    }
    return result;
}

// Maps capture group names to their indexes; numbered groups are also included under their index
isolated function captureGroupIndexes(string pattern) returns map<int> {
    map<int> indexes = {};
    int groupIndex = 0;
    boolean inClass = false;
    int i = 0;
    while i < pattern.length() {
        string ch = pattern.substring(i, i + 1);
        if ch == "\\" {
            i += 2;
            continue;
        }
        if inClass {
            inClass = ch != "]";
        } else if ch == "[" {
            inClass = true;
        } else if ch == "(" {
            string rest = pattern.substring(i + 1);
            if !rest.startsWith("?") {
                groupIndex += 1;
            } else if rest.startsWith("?<") && !rest.startsWith("?<=") && !rest.startsWith("?<!") {
                groupIndex += 1;
                int? close = rest.indexOf(">");
                if close is int {
                    indexes[rest.substring(2, close)] = groupIndex;
                }
            }
        }
        i += 1;
    }
    return indexes;
}

// Inline flags for a FHIRPath regex: always single-line mode (s), plus i (case-insensitive) and m (multi-line)
isolated function regexFlagPrefix(string flags, string name) returns string|FHIRPathInterpreterError {
    string inline = "s";
    foreach string flag in flags {
        if flag != "i" && flag != "m" {
            return error FHIRPathInterpreterError(string `${name}(): invalid regex flag '${flag}'`,
                token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
        }
        if !inline.includes(flag) {
            inline += flag;
        }
    }
    return "(?" + inline + ")";
}

// Evaluates a parameter expected to be a single String; () when it is empty
isolated function stringParam(Expr param, FhirPathItem context, FhirPathEnv env) returns string?|FHIRPathInterpreterError {
    FhirPathItem[] result = check evaluate(param, context, {scope: env.scope.childScope(), index: env?.index, total: env?.total});
    if result.length() == 0 {
        return ();
    }
    json val = valueOf(result[0]);
    return (val is string) ? val : ();
}

isolated function applyEncodeDecodeFunction(string funcName, FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError(funcName, "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val !is string {
        return [];
    }
    FhirPathItem[] fmtResult = check evaluate(params[0], context, env);
    if fmtResult.length() == 0 {
        return [];
    }
    json fmt = valueOf(fmtResult[0]);
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

isolated function applyEscapeUnescapeFunction(string funcName, FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 1 {
        return fnError(funcName, "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val !is string {
        return [];
    }
    FhirPathItem[] fmtResult = check evaluate(params[0], context, env);
    if fmtResult.length() == 0 {
        return [];
    }
    json fmt = valueOf(fmtResult[0]);
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

isolated function toInt(FhirPathItem item) returns int {
    json val = valueOf(item);
    if val is int {
        return val;
    } else if val is decimal {
        return <int>val;
    } else if val is float {
        return <int>val;
    } else if val is string {
        int|error i = int:fromString(val);
        return (i is int) ? i : 0;
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

isolated function applyUpperFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("upper", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val is string {
        return [val.toUpperAscii()];
    }
    return [];
}

isolated function applyLowerFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("lower", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = valueOf(collection[0]);
    if val is string {
        return [val.toLowerAscii()];
    }
    return [];
}
