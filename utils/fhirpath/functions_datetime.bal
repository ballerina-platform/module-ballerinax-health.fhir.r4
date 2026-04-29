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

import ballerina/time;

// ========================================
// DATE/TIME FUNCTIONS
// ========================================

isolated function applyTodayFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("today", "0 parameters", params.length());
    }
    time:Civil civil = time:utcToCivil(time:utcNow());
    string dateStr = string `@${civil.year}-${zeroPad(civil.month)}-${zeroPad(civil.day)}`;
    return [dateStr];
}

isolated function applyNowFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("now", "0 parameters", params.length());
    }
    time:Civil civil = time:utcToCivil(time:utcNow());
    int hour = civil.hour;
    int minute = civil.minute;
    decimal second = civil.second ?: 0d;
    string dtStr = string `@${civil.year}-${zeroPad(civil.month)}-${zeroPad(civil.day)}T${zeroPad(hour)}:${zeroPad(minute)}:${zeroPad(<int>second)}+00:00`;
    return [dtStr];
}

isolated function applyLowBoundaryFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() > 1 {
        return fnError("lowBoundary", "0 or 1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];

    // Determine precision: for strings use value's own precision as default,
    // numeric types default to 8
    int precision = 8;
    if val is string && params.length() == 0 {
        precision = dateTimePrecision(val);
    }
    if params.length() == 1 {
        json[] precResult = check evaluate(params[0], context, env);
        if precResult.length() > 0 && precResult[0] is int {
            precision = <int>precResult[0];
        }
    }

    if val is decimal {
        if precision < 0 || precision > 28 {
            return [];
        }
        decimal half = computeHalfUlp(val, precision);
        return [val - half];
    } else if val is float {
        if precision < 0 || precision > 28 {
            return [];
        }
        decimal dval = <decimal>val;
        decimal half = computeHalfUlp(dval, precision);
        return [dval - half];
    } else if val is int {
        if precision < 0 || precision > 28 {
            return [];
        }
        return [val];
    }
    if val is string {
        return [dateTimeLowBoundary(val, precision)];
    }
    return [];
}

isolated function applyHighBoundaryFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() > 1 {
        return fnError("highBoundary", "0 or 1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];

    int precision = 8;
    if val is string && params.length() == 0 {
        precision = dateTimePrecision(val);
    }
    if params.length() == 1 {
        json[] precResult = check evaluate(params[0], context, env);
        if precResult.length() > 0 && precResult[0] is int {
            precision = <int>precResult[0];
        }
    }

    if val is decimal {
        if precision < 0 || precision > 28 {
            return [];
        }
        decimal half = computeHalfUlp(val, precision);
        return [val + half];
    } else if val is float {
        if precision < 0 || precision > 28 {
            return [];
        }
        decimal dval = <decimal>val;
        decimal half = computeHalfUlp(dval, precision);
        return [dval + half];
    } else if val is int {
        if precision < 0 || precision > 28 {
            return [];
        }
        return [val];
    }
    if val is string {
        return [check dateTimeHighBoundary(val, precision)];
    }
    return [];
}

isolated function applyPrecisionFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("precision", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is decimal {
        string s = val.toString();
        int? dotIdx = s.indexOf(".");
        if dotIdx is int {
            return [s.length() - dotIdx - 1];
        }
        return [0];
    } else if val is int {
        return [0];
    }
    if val is string {
        return [dateTimePrecision(val)];
    }
    return [];
}

// ========================================
// HELPERS
// ========================================

isolated function zeroPad(int n) returns string {
    string s = n.toString();
    return s.length() < 2 ? "0" + s : s;
}

isolated function zeroPad3(int n) returns string {
    string s = n.toString();
    while s.length() < 3 {
        s = "0" + s;
    }
    return s;
}

isolated function addDaysToDateParts(int year, int month, int day, int n) returns [int, int, int] {
    int y = year;
    int m = month;
    int d = day + n;
    while d > lastDayOfMonth(y, m) {
        d -= lastDayOfMonth(y, m);
        m += 1;
        if m > 12 {
            m = 1;
            y += 1;
        }
    }
    while d < 1 {
        m -= 1;
        if m < 1 {
            m = 12;
            y -= 1;
        }
        d += lastDayOfMonth(y, m);
    }
    return [y, m, d];
}

isolated function addMonthsToDateParts(int year, int month, int day, int n) returns [int, int, int] {
    int y = year;
    int m = month + n;
    while m > 12 {
        m -= 12;
        y += 1;
    }
    while m < 1 {
        m += 12;
        y -= 1;
    }
    int d = day;
    int maxDay = lastDayOfMonth(y, m);
    if d > maxDay {
        d = maxDay;
    }
    return [y, m, d];
}

isolated function addYearsToDateParts(int year, int month, int day, int n) returns [int, int, int] {
    int y = year + n;
    int d = day;
    int maxDay = lastDayOfMonth(y, month);
    if d > maxDay {
        d = maxDay;
    }
    return [y, month, d];
}

isolated function computeHalfUlp(decimal val, int precision) returns decimal {
    // half unit in the last place = 5 * 10^-(precision+1)
    decimal factor = 5d;
    foreach int i in 0 ..< precision + 1 {
        factor = factor / 10d;
    }
    return factor;
}

isolated function lastDayOfMonth(int year, int month) returns int {
    if month == 2 {
        boolean isLeap = (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
        return isLeap ? 29 : 28;
    }
    if month == 4 || month == 6 || month == 9 || month == 11 {
        return 30;
    }
    return 31;
}

// Returns [timeWithoutTz, tzSuffix]. tzSuffix is "" when no timezone is present.
isolated function extractTzFromTime(string s) returns [string, string] {
    if s.endsWith("Z") {
        return [s.substring(0, s.length() - 1), "Z"];
    }
    if s.length() >= 6 {
        string last6 = s.substring(s.length() - 6);
        if last6.startsWith("+") || last6.startsWith("-") {
            return [s.substring(0, s.length() - 6), last6];
        }
    }
    return [s, ""];
}

// Expand time part (no tz) to HH:MM:SS.sss for low boundary.
// Bare "HH" (2 chars) is treated as HH:00 so only seconds/ms are uncertain.
isolated function expandTimeLow(string timeNoTz) returns string {
    string t = timeNoTz.length() == 2 ? timeNoTz + ":00" : timeNoTz;
    if t.length() <= 5 {
        t = t + ":00";
    }
    if t.length() <= 8 {
        t = t + ".000";
    }
    return t;
}

// Expand time part (no tz) to HH:MM:SS.sss for high boundary.
isolated function expandTimeHigh(string timeNoTz) returns string {
    string t = timeNoTz.length() == 2 ? timeNoTz + ":00" : timeNoTz;
    if t.length() <= 5 {
        t = t + ":59";
    }
    if t.length() <= 8 {
        t = t + ".999";
    }
    return t;
}

// Expand a date-only string to the appropriate low boundary at the given precision.
isolated function expandDateLow(string datePart, int precision) returns string {
    if datePart.length() == 4 {
        if precision <= 4 { return datePart; }
        if precision <= 6 { return datePart + "-01"; }
        if precision <= 8 { return datePart + "-01-01"; }
        return datePart + "-01-01T00:00:00.000+14:00";
    }
    if datePart.length() == 7 {
        if precision <= 6 { return datePart; }
        if precision <= 8 { return datePart + "-01"; }
        return datePart + "-01T00:00:00.000+14:00";
    }
    if datePart.length() == 10 {
        if precision <= 8 { return datePart; }
        return datePart + "T00:00:00.000+14:00";
    }
    return datePart;
}

// Expand a date-only string to the appropriate high boundary at the given precision.
isolated function expandDateHigh(string datePart, int precision) returns string|FHIRPathInterpreterError {
    if datePart.length() == 4 {
        if precision <= 4 { return datePart; }
        if precision <= 6 { return datePart + "-12"; }
        if precision <= 8 { return datePart + "-12-31"; }
        return datePart + "-12-31T23:59:59.999-12:00";
    }
    if datePart.length() == 7 {
        int|error yearResult = int:fromString(datePart.substring(0, 4));
        int|error monthResult = int:fromString(datePart.substring(5, 7));
        if yearResult is error || monthResult is error {
            return error FHIRPathInterpreterError(
                string `Invalid date format: ${datePart}`,
                token = {tokenType: IDENTIFIER, lexeme: "highBoundary", literal: (), position: 0});
        }
        int year = yearResult;
        int month = monthResult;
        int lastDay = lastDayOfMonth(year, month);
        if precision <= 6 { return datePart; }
        if precision <= 8 { return datePart + "-" + zeroPad(lastDay); }
        return datePart + "-" + zeroPad(lastDay) + "T23:59:59.999-12:00";
    }
    if datePart.length() == 10 {
        if precision <= 8 { return datePart; }
        return datePart + "T23:59:59.999-12:00";
    }
    return datePart;
}

isolated function dateTimeLowBoundary(string val, int precision) returns string {
    boolean hasAt = val.startsWith("@");
    string s = hasAt ? val.substring(1) : val;
    string prefix = hasAt ? "@" : "";

    // Time-only (starts with T)
    if s.startsWith("T") {
        if precision >= 9 {
            string timePart = s.substring(1);
            [string, string] extracted = extractTzFromTime(timePart);
            return prefix + "T" + expandTimeLow(extracted[0]) + extracted[1];
        }
        return val;
    }

    int? tIdx = s.indexOf("T");
    if tIdx is () {
        // Date only
        return prefix + expandDateLow(s, precision);
    }

    // DateTime
    string datePart = s.substring(0, tIdx);
    string afterT = s.substring(tIdx + 1);
    [string, string] extracted = extractTzFromTime(afterT);

    if precision <= 8 {
        return prefix + datePart;
    }
    string tzToUse = extracted[1] == "" ? "+14:00" : extracted[1];
    return prefix + datePart + "T" + expandTimeLow(extracted[0]) + tzToUse;
}

isolated function dateTimeHighBoundary(string val, int precision) returns string|FHIRPathInterpreterError {
    boolean hasAt = val.startsWith("@");
    string s = hasAt ? val.substring(1) : val;
    string prefix = hasAt ? "@" : "";

    // Time-only (starts with T)
    if s.startsWith("T") {
        if precision >= 9 {
            string timePart = s.substring(1);
            [string, string] extracted = extractTzFromTime(timePart);
            return prefix + "T" + expandTimeHigh(extracted[0]) + extracted[1];
        }
        return val;
    }

    int? tIdx = s.indexOf("T");
    if tIdx is () {
        // Date only
        return prefix + check expandDateHigh(s, precision);
    }

    // DateTime
    string datePart = s.substring(0, tIdx);
    string afterT = s.substring(tIdx + 1);
    [string, string] extracted = extractTzFromTime(afterT);

    if precision <= 8 {
        return prefix + datePart;
    }
    string tzToUse = extracted[1] == "" ? "-12:00" : extracted[1];
    return prefix + datePart + "T" + expandTimeHigh(extracted[0]) + tzToUse;
}

// Count digit characters only (excludes -, :, ., T separators)
isolated function countSigDigits(string s) returns int {
    int count = 0;
    foreach int i in 0 ..< s.length() {
        if isDigit(s.substring(i, i + 1)) {
            count += 1;
        }
    }
    return count;
}

isolated function dateTimePrecision(string val) returns int {
    string s = val.startsWith("@") ? val.substring(1) : val;
    if s.startsWith("T") {
        // Time-only: @T10:30:00.000[tz]
        string timeStr = s.substring(1);
        [string, string] extracted = extractTzFromTime(timeStr);
        return countSigDigits(extracted[0]);
    }
    int? tIdx = s.indexOf("T");
    if tIdx is int {
        // DateTime: @2014-01-05T10:30:00.000[tz]
        string datePart = s.substring(0, tIdx);
        string afterT = s.substring(tIdx + 1);
        [string, string] extracted = extractTzFromTime(afterT);
        return countSigDigits(datePart) + countSigDigits(extracted[0]);
    }
    // Date-only: @2014, @2014-01, @2014-01-05
    return countSigDigits(s);
}
