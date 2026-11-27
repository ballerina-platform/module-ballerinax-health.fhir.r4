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

isolated function applyTodayFunction(Expr[] params, time:Utc evaluationTime) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("today", "0 parameters", params.length());
    }
    time:Civil civil = time:utcToCivil(evaluationTime);
    string dateStr = string `@${civil.year}-${zeroPad(civil.month)}-${zeroPad(civil.day)}`;
    return [dateStr];
}

isolated function applyNowFunction(Expr[] params, time:Utc evaluationTime) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("now", "0 parameters", params.length());
    }
    time:Civil civil = time:utcToCivil(evaluationTime);
    decimal second = civil.second ?: 0d;
    int wholeSeconds = <int>second.floor();
    int millis = <int>((second - <decimal>wholeSeconds) * 1000d).floor();
    // Same instant and precision as timeOfDay() (timeOfDay() is now().timeOf())
    string dtStr = string `@${civil.year}-${zeroPad(civil.month)}-${zeroPad(civil.day)}T${zeroPad(civil.hour)}:${zeroPad(civil.minute)}:${zeroPad(wholeSeconds)}.${zeroPad3(millis)}+00:00`;
    return [dtStr];
}

isolated function applyTimeOfDayFunction(Expr[] params, time:Utc evaluationTime) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("timeOfDay", "0 parameters", params.length());
    }
    time:Civil civil = time:utcToCivil(evaluationTime);
    decimal second = civil.second ?: 0d;
    int wholeSeconds = <int>second.floor();
    int millis = <int>((second - <decimal>wholeSeconds) * 1000d).floor();
    return [systemItem("Time", string `@T${zeroPad(civil.hour)}:${zeroPad(civil.minute)}:${zeroPad(wholeSeconds)}.${zeroPad3(millis)}`)];
}

// Date/time component extraction: yearOf(), monthOf(), dayOf(), hourOf(), minuteOf(), secondOf(),
// millisecondOf(), timezoneOffsetOf(), dateOf() and timeOf()
isolated function applyDateTimeComponentFunction(FhirPathItem[] collection, Expr[] params, string name)
        returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError(name, "0 parameters", params.length());
    }
    FhirPathItem? input = check singleInput(collection, name);
    if input is () {
        return [];
    }
    json val = systemValueOf(input);
    string? kind = dateTimeKind(val);
    if kind is () || val !is string {
        return [];
    }
    string s = val.substring(1);
    string datePart = kind == "Time" ? "" : datePartOf(val);
    string timeWithTz = "";
    if kind == "Time" {
        timeWithTz = s.substring(1);
    } else if kind == "DateTime" {
        timeWithTz = s.substring(datePart.length() + 1);
    }
    [string, string] [timePart, tz] = extractTzFromTime(timeWithTz);

    match name {
        "yearOf" => { return kind == "Time" ? [] : componentAt(datePart, 0, 4); }
        "monthOf" => { return kind == "Time" ? [] : componentAt(datePart, 5, 7); }
        "dayOf" => { return kind == "Time" ? [] : componentAt(datePart, 8, 10); }
        "hourOf" => { return kind == "Date" ? [] : componentAt(timePart, 0, 2); }
        "minuteOf" => { return kind == "Date" ? [] : componentAt(timePart, 3, 5); }
        "secondOf" => { return kind == "Date" ? [] : componentAt(timePart, 6, 8); }
        "millisecondOf" => {
            if kind == "Date" || timePart.length() < 10 || timePart.substring(8, 9) != "." {
                return [];
            }
            string fraction = timePart.substring(9);
            while fraction.length() < 3 {
                fraction += "0";
            }
            return componentAt(fraction, 0, 3);
        }
        "timezoneOffsetOf" => {
            if kind != "DateTime" || tz == "" {
                return [];
            }
            if tz == "Z" {
                return [0.0d];
            }
            int|error hours = int:fromString(tz.substring(1, 3));
            int|error minutes = int:fromString(tz.substring(4, 6));
            if hours is error || minutes is error {
                return [];
            }
            decimal offset = <decimal>hours + <decimal>minutes / 60d;
            return [tz.startsWith("-") ? -offset : offset];
        }
        "dateOf" => { return kind == "Time" ? [] : [systemItem("Date", "@" + datePart)]; }
        "timeOf" => { return kind != "DateTime" || timePart == "" ? [] : [systemItem("Time", "@T" + timePart)]; }
    }
    return [];
}

// The integer in s[startIndex, endIndex), or empty when the component is not present
isolated function componentAt(string s, int startIndex, int endIndex) returns FhirPathItem[] {
    if s.length() < endIndex {
        return [];
    }
    int|error component = int:fromString(s.substring(startIndex, endIndex));
    return (component is int) ? [component] : [];
}

// ---- Date and time intervals: duration() and difference() ----

final readonly & string[] DATE_INTERVAL_PRECISIONS = ["year", "month", "week", "day"];
final readonly & string[] TIME_INTERVAL_PRECISIONS = ["hour", "minute", "second", "millisecond"];

// duration() counts whole calendar periods; difference() counts the period boundaries crossed
isolated function applyIntervalFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env,
        boolean boundaries) returns FHIRPathInterpreterError|FhirPathItem[] {
    string name = boundaries ? "difference" : "duration";
    if params.length() != 2 {
        return fnError(name, "2 parameters", params.length());
    }
    FhirPathItem? input = check singleInput(collection, name);
    FhirPathItem[] otherResult = check evaluate(params[0], context, env);
    string? precisionParam = check stringParam(params[1], context, env);
    if input is () || otherResult.length() == 0 || precisionParam is () {
        return [];
    }
    FhirPathItem? other = check singleInput(otherResult, name);
    if other is () {
        return [];
    }
    string precision = normalizeCalendarUnit(precisionParam);
    string kindA = systemTypeOf(input);
    string kindB = systemTypeOf(other);
    boolean isTime = kindA == "Time";
    boolean validKinds = isTime ? kindB == "Time"
        : (kindA == "Date" || kindA == "DateTime") && (kindB == "Date" || kindB == "DateTime");
    if !validKinds {
        return error FHIRPathInterpreterError(string `${name}() requires two Date, DateTime or Time values of the same kind`,
            token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
    }
    boolean bothDates = kindA == "Date" && kindB == "Date";
    boolean validPrecision = isTime ? TIME_INTERVAL_PRECISIONS.indexOf(precision) !is ()
        : (DATE_INTERVAL_PRECISIONS.indexOf(precision) !is () || (!bothDates && TIME_INTERVAL_PRECISIONS.indexOf(precision) !is ()));
    if !validPrecision {
        return error FHIRPathInterpreterError(string `${name}(): invalid precision '${precisionParam}'`,
            token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
    }
    DateTimeParts? a = intervalParts(<string>systemValueOf(input));
    DateTimeParts? b = intervalParts(<string>systemValueOf(other));
    if a is () || b is () || !hasPrecision(a, precision) || !hasPrecision(b, precision) {
        return [];
    }
    return [boundaries ? boundariesCrossed(a, b, precision) : wholePeriods(a, b, precision)];
}

// Components of an '@' date/time value; Time values have year 0
isolated function intervalParts(string value) returns DateTimeParts? {
    string s = value.substring(1);
    if !s.startsWith("T") {
        return parseIsoDateTime(s.endsWith("T") ? s.substring(0, s.length() - 1) : s);
    }
    [string, string] [timePart, _] = extractTzFromTime(s.substring(1));
    if !isTimeFormat(timePart) {
        return ();
    }
    return {
        year: 0,
        hour: digitsToInt(timePart.substring(0, 2)),
        minute: timePart.length() >= 5 ? digitsToInt(timePart.substring(3, 5)) : (),
        second: timePart.length() >= 8 ? digitsToInt(timePart.substring(6, 8)) : (),
        fraction: timePart.length() > 9 ? timePart.substring(9) : ()
    };
}

isolated function hasPrecision(DateTimeParts parts, string precision) returns boolean {
    match precision {
        "year" => { return true; }
        "month" => { return parts.month !is (); }
        "week"|"day" => { return parts.day !is (); }
        "hour" => { return parts.hour !is (); }
        "minute" => { return parts.minute !is (); }
        "second" => { return parts.second !is (); }
    }
    return parts.fraction !is ();
}

// Number of whole periods from a to b (negative when a is after b)
isolated function wholePeriods(DateTimeParts a, DateTimeParts b, string precision) returns int {
    if TIME_INTERVAL_PRECISIONS.indexOf(precision) !is () {
        int diff = absoluteMillis(b, true) - absoluteMillis(a, true);
        return diff / unitMillis(precision);
    }
    if compareParts(a, b) > 0 {
        return -wholePeriods(b, a, precision);
    }
    if precision == "year" || precision == "month" {
        int months = (b.year - a.year) * 12 + ((b.month ?: 1) - (a.month ?: 1));
        // A period is only complete once the remaining components of b reach those of a
        if (a.day is int && b.day is int && ((b.day ?: 1) < (a.day ?: 1)
                || ((b.day ?: 1) == (a.day ?: 1) && millisOfDay(b) < millisOfDay(a)))) {
            months -= 1;
        }
        if precision == "month" {
            return months;
        }
        int years = b.year - a.year;
        if b.month is int && a.month is int && months < years * 12 {
            years -= 1;
        }
        return years;
    }
    int days = daysFromCivil(b) - daysFromCivil(a);
    if millisOfDay(b) < millisOfDay(a) {
        days -= 1;
    }
    return precision == "week" ? days / 7 : days;
}

// Number of period boundaries crossed from a to b (weeks start on Sunday)
isolated function boundariesCrossed(DateTimeParts a, DateTimeParts b, string precision) returns int {
    match precision {
        "year" => { return b.year - a.year; }
        "month" => { return (b.year - a.year) * 12 + ((b.month ?: 1) - (a.month ?: 1)); }
        "day" => { return daysFromCivil(b) - daysFromCivil(a); }
        "week" => {
            // 1970-01-04 (day 3) was a Sunday
            return floorDiv(daysFromCivil(b) - 3, 7) - floorDiv(daysFromCivil(a) - 3, 7);
        }
    }
    int unit = unitMillis(precision);
    return floorDiv(absoluteMillis(b, true), unit) - floorDiv(absoluteMillis(a, true), unit);
}

isolated function compareParts(DateTimeParts a, DateTimeParts b) returns int {
    int dayDiff = daysFromCivil(a) - daysFromCivil(b);
    if dayDiff != 0 {
        return dayDiff;
    }
    return millisOfDay(a) - millisOfDay(b);
}

// Milliseconds since 1970-01-01T00:00Z (Time values: since midnight); `normalize` applies the timezone offset
isolated function absoluteMillis(DateTimeParts parts, boolean normalize) returns int {
    int millis = (parts.year == 0 && parts.month is () ? 0 : daysFromCivil(parts) * 86400000) + millisOfDay(parts);
    string? timezone = parts.timezone;
    if normalize && timezone is string && timezone != "Z" {
        int offsetMinutes = digitsToInt(timezone.substring(1, 3)) * 60 + digitsToInt(timezone.substring(4, 6));
        millis -= (timezone.startsWith("-") ? -offsetMinutes : offsetMinutes) * 60000;
    }
    return millis;
}

isolated function millisOfDay(DateTimeParts parts) returns int {
    string fraction = parts.fraction ?: "0";
    while fraction.length() < 3 {
        fraction += "0";
    }
    return (((parts.hour ?: 0) * 60 + (parts.minute ?: 0)) * 60 + (parts.second ?: 0)) * 1000 + digitsToInt(fraction.substring(0, 3));
}

isolated function unitMillis(string precision) returns int {
    match precision {
        "hour" => { return 3600000; }
        "minute" => { return 60000; }
        "second" => { return 1000; }
    }
    return 1;
}

// Days since 1970-01-01 of the (proleptic Gregorian) date in `parts`
isolated function daysFromCivil(DateTimeParts parts) returns int {
    int m = parts.month ?: 1;
    int d = parts.day ?: 1;
    int y = parts.year - (m <= 2 ? 1 : 0);
    int era = (y >= 0 ? y : y - 399) / 400;
    int yoe = y - era * 400;
    int doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1;
    int doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
    return era * 146097 + doe - 719468;
}

isolated function floorDiv(int a, int b) returns int {
    int q = a / b;
    return (a % b != 0 && ((a < 0) != (b < 0))) ? q - 1 : q;
}

isolated function applyBoundaryFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env,
        boolean high) returns FHIRPathInterpreterError|FhirPathItem[] {
    string name = high ? "highBoundary" : "lowBoundary";
    if params.length() > 1 {
        return fnError(name, "0 or 1 parameter", params.length());
    }
    FhirPathItem? input = check singleInput(collection, name);
    if input is () {
        return [];
    }
    int? precision = ();
    if params.length() == 1 {
        FhirPathItem[] precResult = check evaluate(params[0], context, env);
        json precVal = precResult.length() > 0 ? valueOf(precResult[0]) : ();
        if precVal !is int {
            return [];
        }
        precision = precVal;
    }
    string kind = systemTypeOf(input);
    json val = systemValueOf(input);

    if kind == "Integer" || kind == "Long" || kind == "Decimal" {
        decimal? bound = decimalBoundary(toDecimalValue(val), itemDecimalScale(input), precision ?: 8, high);
        return (bound is decimal) ? [bound] : [];
    }
    if kind == "Quantity" && val is map<json> {
        json qValue = val["value"];
        json code = val["code"];
        json unit = val["unit"];
        decimal? bound = decimalBoundary(toDecimalValue(qValue), decimalScale(qValue), precision ?: 8, high);
        return (bound is decimal) ? [quantityItem(bound, code is string ? code : (unit is string ? unit : "1"))] : [];
    }
    if val is string && (kind == "Date" || kind == "DateTime" || kind == "Time") {
        int targetPrecision = precision ?: defaultBoundaryPrecision(input, val);
        string bound = high ? check dateTimeHighBoundary(val, targetPrecision) : dateTimeLowBoundary(val, targetPrecision);
        if kind == "DateTime" && !bound.substring(1).includes("T") {
            bound += "T";
        }
        return [systemItem(kind, bound)];
    }
    return [];
}

// Largest precision (digits after the decimal point) supported for decimal boundaries
const MAX_DECIMAL_PRECISION = 28;

// Boundary of a decimal with `scale` significant fractional digits, expressed with `precision` fractional
// digits: the value is uncertain by half a unit in its last digit; the low boundary is truncated and the high
// boundary rounded half-up to the target precision. Negative values mirror the positive ones.
isolated function decimalBoundary(decimal value, int scale, int precision, boolean high) returns decimal? {
    if precision < 0 || precision > MAX_DECIMAL_PRECISION {
        return ();
    }
    if value < 0d {
        decimal? mirrored = decimalBoundary(-value, scale, precision, !high);
        return (mirrored is decimal) ? -mirrored : ();
    }
    decimal halfUnit = 5d / pow10(scale + 1);
    decimal bound = high ? value + halfUnit : value - halfUnit;
    if precision > scale {
        return bound;
    }
    decimal factor = pow10(precision);
    return high ? (bound * factor + 0.5d).floor() / factor : (bound * factor).floor() / factor;
}

// Number of fractional digits of a numeric item, using the written form of a decimal zero literal
isolated function itemDecimalScale(FhirPathItem item) returns int {
    if item is TypedValue {
        string? text = item.literalText;
        if text is string {
            return decimalScale(valueOf(item), text);
        }
    }
    return decimalScale(valueOf(item));
}

// Number of fractional digits of a numeric JSON value as written (0 for integers)
isolated function decimalScale(json val, string? text = ()) returns int {
    if val !is decimal && val !is float {
        return 0;
    }
    string s = (text ?: val.toString()).toUpperAscii();
    // Exponent notation: the precision is that of the mantissa shifted by the exponent (9.5E+2 → tens)
    int exponent = 0;
    int? eIdx = s.indexOf("E");
    if eIdx is int {
        string expText = s.substring(eIdx + 1);
        exponent = digitsToInt(expText.startsWith("+") || expText.startsWith("-") ? expText.substring(1) : expText)
            * (expText.startsWith("-") ? -1 : 1);
        s = s.substring(0, eIdx);
    }
    int? dotIdx = s.indexOf(".");
    return (dotIdx is int ? s.length() - dotIdx - 1 : 0) - exponent;
}

isolated function pow10(int exponent) returns decimal {
    decimal result = 1d;
    foreach int i in 0 ..< (exponent < 0 ? -exponent : exponent) {
        result *= 10d;
    }
    return exponent < 0 ? 1d / result : result;
}

isolated function applyPrecisionFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    if params.length() != 0 {
        return fnError("precision", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is decimal {
        return [int:max(itemDecimalScale(collection[0]), 0)];
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

// ---- Date/time string parsing (toDate / toDateTime) ----

// Components of a parsed date/time; components after the first missing one are absent
type DateTimeParts record {|
    int year;
    int? month = ();
    int? day = ();
    int? hour = ();
    int? minute = ();
    int? second = ();
    string? fraction = ();
    string? timezone = ();
|};

final readonly & string[] MONTH_NAMES = ["january", "february", "march", "april", "may", "june", "july", "august",
    "september", "october", "november", "december"];

// Parses an ISO date: YYYY, YYYY-MM or YYYY-MM-DD
isolated function parseIsoDate(string s) returns DateTimeParts? {
    if !re `[0-9]{4}(-[0-9]{2}(-[0-9]{2})?)?`.isFullMatch(s) {
        return ();
    }
    return validDateTimeParts({
        year: digitsToInt(s.substring(0, 4)),
        month: s.length() >= 7 ? digitsToInt(s.substring(5, 7)) : (),
        day: s.length() >= 10 ? digitsToInt(s.substring(8, 10)) : ()
    }) ?: ();
}

// Parses an ISO date/time: YYYY(-MM(-DD(T(HH(:mm(:ss(.fff)?)?)?)?(Z|(+|-)HH:mm)?)?)?)?
isolated function parseIsoDateTime(string s) returns DateTimeParts? {
    if !re `[0-9]{4}(-[0-9]{2}(-[0-9]{2}(T([0-9]{2}(:[0-9]{2}(:[0-9]{2}(\.[0-9]+)?)?)?(Z|[+-][0-9]{2}:[0-9]{2})?)?)?)?)?`.isFullMatch(s) {
        return ();
    }
    int? tIdx = s.indexOf("T");
    DateTimeParts? date = parseIsoDate(tIdx is int ? s.substring(0, tIdx) : s);
    if date is () || tIdx is () {
        return date;
    }
    [string, string] [timePart, timezone] = extractTzFromTime(s.substring(tIdx + 1));
    if timePart.length() > 0 {
        date.hour = digitsToInt(timePart.substring(0, 2));
    }
    if timePart.length() >= 5 {
        date.minute = digitsToInt(timePart.substring(3, 5));
    }
    if timePart.length() >= 8 {
        date.second = digitsToInt(timePart.substring(6, 8));
    }
    if timePart.length() > 9 {
        date.fraction = timePart.substring(9);
    }
    date.timezone = timezone == "" ? () : timezone;
    return validDateTimeParts(date);
}

// Parses a date/time using a FHIRPath format template (see "Date/DateTime String Format Codes")
isolated function parseDateTimeWithFormat(string input, string format) returns DateTimeParts? {
    int? year = ();
    int? month = ();
    int? day = ();
    int? hour = ();
    int? hour12 = ();
    string? meridiem = ();
    int? minute = ();
    int? second = ();
    string? fraction = ();
    string? timezone = ();

    int pos = 0;
    int f = 0;
    while f < format.length() {
        string code = format.substring(f, f + 1);
        int runEnd = f;
        while runEnd < format.length() && format.substring(runEnd, runEnd + 1) == code {
            runEnd += 1;
        }
        int run = runEnd - f;
        string rest = input.substring(pos);
        if code == "y" {
            int width = run == 2 ? 2 : 4;
            int? value = leadingDigits(rest, width, width);
            if value is () { return (); }
            year = run == 2 ? (value < 50 ? 2000 + value : 1900 + value) : value;
            pos += width;
        } else if code == "M" && run >= 3 {
            [int, int]? named = leadingMonthName(rest, run == 3);
            if named is () { return (); }
            [month, pos] = [named[0], pos + named[1]];
        } else if code == "M" || code == "d" || code == "H" || code == "h" || code == "m" || code == "s" {
            int minWidth = run >= 2 ? 2 : 1;
            int? value = leadingDigits(rest, minWidth, 2);
            if value is () { return (); }
            pos += digitRunLength(rest, 2);
            match code {
                "M" => { month = value; }
                "d" => { day = value; }
                "H" => { hour = value; }
                "h" => { hour12 = value; }
                "m" => { minute = value; }
                _ => { second = value; }
            }
        } else if code == "S" {
            if digitRunLength(rest, run) != run { return (); }
            fraction = rest.substring(0, run);
            pos += run;
        } else if code == "a" {
            string upper = rest.toUpperAscii();
            int width = upper.startsWith("AM") || upper.startsWith("PM") ? 2 : (upper.startsWith("A") || upper.startsWith("P") ? 1 : 0);
            if width == 0 { return (); }
            meridiem = upper.substring(0, 1);
            pos += width;
        } else if code == "Z" {
            string? offset = leadingTimezoneOffset(rest);
            if offset is () { return (); }
            timezone = offset == "Z" ? "Z" : offset.substring(0, 3) + ":" + offset.substring(offset.length() - 2);
            pos += offset.length();
        } else if code == "z" {
            // Time zone names cannot be mapped to offsets; accept and ignore them
            int width = 0;
            while width < rest.length() && re `[A-Za-z_/]`.isFullMatch(rest.substring(width, width + 1)) {
                width += 1;
            }
            if width == 0 { return (); }
            pos += width;
        } else {
            // Any other character is a literal
            if !rest.startsWith(format.substring(f, runEnd)) { return (); }
            pos += run;
        }
        f = runEnd;
    }
    if pos != input.length() || year is () {
        return ();
    }
    if hour12 is int {
        if hour12 < 1 || hour12 > 12 { return (); }
        hour = meridiem == "P" ? (hour12 % 12) + 12 : hour12 % 12;
    }
    return validDateTimeParts({year, month, day, hour, minute, second, fraction, timezone});
}

// Integer value of a string already validated to contain only digits
isolated function digitsToInt(string digits) returns int {
    int|error value = int:fromString(digits);
    return value is int ? value : 0;
}

// Reads between minWidth and maxWidth leading digits
isolated function leadingDigits(string s, int minWidth, int maxWidth) returns int? {
    int width = digitRunLength(s, maxWidth);
    if width < minWidth {
        return ();
    }
    int|error value = int:fromString(s.substring(0, width));
    return (value is int) ? value : ();
}

isolated function digitRunLength(string s, int maxWidth) returns int {
    int width = 0;
    while width < maxWidth && width < s.length() && isDigit(s.substring(width, width + 1)) {
        width += 1;
    }
    return width;
}

// Reads a leading English month name, returning [month, consumed length]
isolated function leadingMonthName(string s, boolean abbreviated) returns [int, int]? {
    string lower = s.toLowerAscii();
    foreach int i in 0 ..< MONTH_NAMES.length() {
        string name = abbreviated ? MONTH_NAMES[i].substring(0, 3) : MONTH_NAMES[i];
        if lower.startsWith(name) {
            return [i + 1, name.length()];
        }
    }
    return ();
}

// Reads a leading "Z", "+HHmm" or "+HH:mm" offset
isolated function leadingTimezoneOffset(string s) returns string? {
    if s.startsWith("Z") {
        return "Z";
    }
    if s.length() >= 6 && re `[+-][0-9]{2}:[0-9]{2}`.isFullMatch(s.substring(0, 6)) {
        return s.substring(0, 6);
    }
    if s.length() >= 5 && re `[+-][0-9]{4}`.isFullMatch(s.substring(0, 5)) {
        return s.substring(0, 5);
    }
    return ();
}

// Checks component ranges and that no component is present after a missing one
isolated function validDateTimeParts(DateTimeParts parts) returns DateTimeParts? {
    int? month = parts.month;
    int? day = parts.day;
    int? hour = parts.hour;
    int? minute = parts.minute;
    int? second = parts.second;
    if (month is () && day !is ()) || (day is () && hour !is ()) || (hour is () && minute !is ())
            || (minute is () && second !is ()) || (second is () && parts.fraction !is ()) {
        return ();
    }
    if (month is int && (month < 1 || month > 12)) || (hour is int && hour > 23) || (minute is int && minute > 59)
            || (second is int && second > 59) {
        return ();
    }
    if month is int && day is int && (day < 1 || day > lastDayOfMonth(parts.year, month)) {
        return ();
    }
    return parts;
}

isolated function formatDateParts(DateTimeParts parts) returns string {
    string result = zeroPad4(parts.year);
    int? month = parts.month;
    int? day = parts.day;
    if month is int {
        result += "-" + zeroPad(month);
        if day is int {
            result += "-" + zeroPad(day);
        }
    }
    return result;
}

isolated function formatDateTimeParts(DateTimeParts parts) returns string {
    string result = formatDateParts(parts) + "T";
    int? hour = parts.hour;
    int? minute = parts.minute;
    int? second = parts.second;
    string? fraction = parts.fraction;
    if hour is int {
        result += zeroPad(hour);
        if minute is int {
            result += ":" + zeroPad(minute);
            if second is int {
                result += ":" + zeroPad(second);
                if fraction is string {
                    result += "." + fraction;
                }
            }
        }
    }
    return result + (parts.timezone ?: "");
}

isolated function zeroPad4(int n) returns string {
    string s = n.toString();
    while s.length() < 4 {
        s = "0" + s;
    }
    return s;
}

// Maximum precision of the item's date/time type (Date 8, DateTime 17, Time 9)
isolated function defaultBoundaryPrecision(FhirPathItem item, string val) returns int {
    [string, string] [_, name] = typeOfItem(item);
    if name == "Date" || name == "date" { return 8; }
    if name == "DateTime" || name == "dateTime" || name == "instant" { return 17; }
    if name == "Time" || name == "time" { return 9; }
    return dateTimePrecision(val);
}

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
    if timeNoTz == "" {
        return "00:00:00.000";
    }
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
    if timeNoTz == "" {
        return "23:59:59.999";
    }
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
