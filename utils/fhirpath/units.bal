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
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// ========================================
// QUANTITY UNIT CONVERSION
// ========================================
// Time-valued quantities follow the FHIRPath "Time-valued unit conversions" table: calendar durations
// (year, month, week, ...) and UCUM definite durations ('a', 'mo', 'wk', ...) share factors except for
// years and months. A conversion between the two systems is performed within the source system and the
// result is then labelled with the toKey unit.

// Seconds per calendar duration unit
final readonly & map<decimal> CALENDAR_UNIT_SECONDS = {
    "year": 31536000d,
    "month": 2592000d,
    "week": 604800d,
    "day": 86400d,
    "hour": 3600d,
    "minute": 60d,
    "second": 1d,
    "millisecond": 0.001d
};

// Seconds per UCUM definite duration unit
final readonly & map<decimal> UCUM_TIME_UNIT_SECONDS = {
    "a": 31557600d,
    "mo": 2629800d,
    "wk": 604800d,
    "d": 86400d,
    "h": 3600d,
    "min": 60d,
    "s": 1d,
    "ms": 0.001d
};

// Calendar duration ↔ UCUM definite duration counterparts
final readonly & map<string> CALENDAR_TO_UCUM = {
    "year": "a", "month": "mo", "week": "wk", "day": "d", "hour": "h", "minute": "min", "second": "s", "millisecond": "ms"
};
final readonly & map<string> UCUM_TO_CALENDAR = {
    "a": "year", "mo": "month", "wk": "week", "d": "day", "h": "hour", "min": "minute", "s": "second", "ms": "millisecond"
};

# Converts a quantity value between units.
#
# + value - The quantity value
# + fromUnit - The unit of the value (a UCUM code or a calendar duration keyword)
# + toUnit - The toKey unit (a UCUM code or a calendar duration keyword)
# + return - The value expressed in the toKey unit, or () when the units are not commensurable
isolated function convertQuantity(decimal value, string fromUnit, string toUnit) returns decimal? {
    string fromKey = normalizeCalendarUnit(fromUnit);
    string toKey = normalizeCalendarUnit(toUnit);
    if fromKey == toKey {
        return value;
    }
    decimal? fromCalendar = CALENDAR_UNIT_SECONDS[fromKey];
    if fromCalendar is decimal {
        // Convert within the calendar system, mapping a UCUM target to its calendar counterpart
        decimal? targetSeconds = CALENDAR_UNIT_SECONDS[UCUM_TO_CALENDAR[toKey] ?: toKey];
        return (targetSeconds is decimal) ? value * fromCalendar / targetSeconds : ();
    }
    decimal? fromUcum = UCUM_TIME_UNIT_SECONDS[fromKey];
    if fromUcum is decimal {
        decimal? targetSeconds = UCUM_TIME_UNIT_SECONDS[CALENDAR_TO_UCUM[toKey] ?: toKey];
        return (targetSeconds is decimal) ? value * fromUcum / targetSeconds : ();
    }
    return ();
}

# Normalizes plural calendar duration keywords to their singular form (e.g. "days" → "day").
#
# + unit - The unit
# + return - The normalized unit
isolated function normalizeCalendarUnit(string unit) returns string {
    if unit.endsWith("s") && CALENDAR_UNIT_SECONDS.hasKey(unit.substring(0, unit.length() - 1)) {
        return unit.substring(0, unit.length() - 1);
    }
    return unit;
}
