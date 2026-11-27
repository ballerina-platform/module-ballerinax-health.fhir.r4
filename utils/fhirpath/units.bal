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
// QUANTITY UNITS
// ========================================
// Two unit systems are supported:
//   - Calendar durations (year, month, week, day, hour, minute, second, millisecond and their plurals).
//     Within the system a year is 12 months or 365 days and a month is 30 days; these conversions are
//     deliberately not transitive (1 year = 12 months, 1 month = 30 days, but 1 year ≠ 360 days).
//   - A UCUM subset: metric prefixes, base and derived metric units, common customary units, time units,
//     '%', powers of ten, annotations ({...}), products ('.'), quotients ('/'), exponents and parentheses.
//     Cel and [degF] are converted with their offsets when they are used on their own. Unknown bracketed
//     units ([IU], [HPF], ...) are treated as arbitrary units with a dimension of their own.
// Week, day, hour, minute, second and millisecond are equal to their UCUM counterparts; year and month are
// only equivalent to 'a' and 'mo'.

// Dimension vector of a unit: base unit symbol → exponent
type Dimensions map<int>;

// A parsed UCUM unit: value in base units = (value + offset) * factor
type UcumUnit record {|
    decimal factor;
    Dimensions dimensions;
    // Offset of a unit on a non-ratio scale (Cel, [degF]); only valid for a unit used on its own
    decimal offset = 0d;
    boolean special = false;
|};

// A quantity value with its unit (a UCUM code or a singular calendar duration keyword)
type QuantityValue record {|
    decimal value;
    string unit;
|};

final readonly & map<decimal> UCUM_PREFIXES = {
    "Y": 1E24d, "Z": 1E21d, "E": 1E18d, "P": 1E15d, "T": 1E12d, "G": 1E9d, "M": 1E6d, "k": 1E3d, "h": 1E2d,
    "da": 1E1d, "d": 1E-1d, "c": 1E-2d, "m": 1E-3d, "u": 1E-6d, "n": 1E-9d, "p": 1E-12d, "f": 1E-15d,
    "a": 1E-18d, "z": 1E-21d, "y": 1E-24d
};

// [factor, dimensions, metric (accepts prefixes)]
final readonly & map<[decimal, map<int>, boolean]> UCUM_ATOMS = {
    // Base units
    "m": [1d, {"m": 1}, true],
    "g": [1d, {"g": 1}, true],
    "s": [1d, {"s": 1}, true],
    "A": [1d, {"A": 1}, true],
    "K": [1d, {"K": 1}, true],
    "mol": [1d, {"mol": 1}, true],
    "cd": [1d, {"cd": 1}, true],
    "rad": [1d, {"rad": 1}, true],
    // Derived metric units
    "L": [0.001d, {"m": 3}, true],
    "l": [0.001d, {"m": 3}, true],
    "Hz": [1d, {"s": -1}, true],
    "N": [1000d, {"g": 1, "m": 1, "s": -2}, true],
    "Pa": [1000d, {"g": 1, "m": -1, "s": -2}, true],
    "bar": [100000000d, {"g": 1, "m": -1, "s": -2}, true],
    "J": [1000d, {"g": 1, "m": 2, "s": -2}, true],
    "W": [1000d, {"g": 1, "m": 2, "s": -3}, true],
    "C": [1d, {"A": 1, "s": 1}, true],
    "V": [1000d, {"g": 1, "m": 2, "s": -3, "A": -1}, true],
    "Ohm": [1000d, {"g": 1, "m": 2, "s": -3, "A": -2}, true],
    "cal": [4184d, {"g": 1, "m": 2, "s": -2}, true],
    "eq": [1d, {"mol": 1}, true],
    "osm": [1d, {"mol": 1}, true],
    "U": [0.0000000166666666666666666666666667d, {"mol": 1, "s": -1}, true],
    "kat": [1d, {"mol": 1, "s": -1}, true],
    "m[Hg]": [133322000d, {"g": 1, "m": -1, "s": -2}, true],
    "m[H2O]": [9806650d, {"g": 1, "m": -1, "s": -2}, true],
    "g%": [10000d, {"g": 1, "m": -3}, true],
    // Time
    "min": [60d, {"s": 1}, false],
    "h": [3600d, {"s": 1}, false],
    "d": [86400d, {"s": 1}, false],
    "wk": [604800d, {"s": 1}, false],
    "mo": [2629800d, {"s": 1}, false],
    "a": [31557600d, {"s": 1}, false],
    // Customary units
    "[in_i]": [0.0254d, {"m": 1}, false],
    "[ft_i]": [0.3048d, {"m": 1}, false],
    "[yd_i]": [0.9144d, {"m": 1}, false],
    "[mi_i]": [1609.344d, {"m": 1}, false],
    "[lb_av]": [453.59237d, {"g": 1}, false],
    "[oz_av]": [28.349523125d, {"g": 1}, false],
    "[gal_us]": [0.003785411784d, {"m": 3}, false],
    "[qt_us]": [0.000946352946d, {"m": 3}, false],
    "[pt_us]": [0.000473176473d, {"m": 3}, false],
    "[foz_us]": [0.0000295735295625d, {"m": 3}, false],
    "[degF]": [0.5555555555555555555555555555555556d, {"K": 1}, false],
    "Cel": [1d, {"K": 1}, false],
    "deg": [0.01745329251994329576923690768488613d, {"rad": 1}, false],
    // Dimensionless
    "%": [0.01d, {}, false],
    "[ppm]": [0.000001d, {}, false],
    "[ppth]": [0.001d, {}, false]
};

// Offsets (in the unit itself) of units on non-ratio scales: K = (value + offset) * factor
final readonly & map<decimal> UCUM_OFFSETS = {"Cel": 273.15d, "[degF]": 459.67d};

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

// Calendar duration ↔ UCUM definite duration counterparts
final readonly & map<string> CALENDAR_TO_UCUM = {
    "year": "a", "month": "mo", "week": "wk", "day": "d", "hour": "h", "minute": "min", "second": "s", "millisecond": "ms"
};
final readonly & map<string> UCUM_TO_CALENDAR = {
    "a": "year", "mo": "month", "wk": "week", "d": "day", "h": "hour", "min": "minute", "s": "second", "ms": "millisecond"
};

// ========================================
// CONVERSION
// ========================================

# Converts a quantity value between units. Conversions between calendar and UCUM units are performed
# within the system of the source unit, and the result is then labelled with the target unit.
#
# + value - The quantity value
# + fromUnit - The unit of the value (a UCUM code or a calendar duration keyword)
# + toUnit - The target unit (a UCUM code or a calendar duration keyword)
# + return - The value expressed in the target unit, or () when the units are not commensurable
isolated function convertQuantity(decimal value, string fromUnit, string toUnit) returns decimal? {
    string fromKey = normalizeCalendarUnit(fromUnit);
    string toKey = normalizeCalendarUnit(toUnit);
    if fromKey == toKey {
        return value;
    }
    if isCalendarUnit(fromKey) {
        string target = isCalendarUnit(toKey) ? toKey : (UCUM_TO_CALENDAR[toKey] ?: "");
        decimal? factor = calendarFactor(fromKey, target);
        return (factor is decimal) ? (value * factor).round(CONVERSION_FRACTION_DIGITS) : ();
    }
    string target = isCalendarUnit(toKey) ? (CALENDAR_TO_UCUM[toKey] ?: "") : toKey;
    return convertUcum(value, fromKey, target);
}

// Converts between UCUM units, honouring the offsets of Cel and [degF]
isolated function convertUcum(decimal value, string fromUnit, string toUnit) returns decimal? {
    if fromUnit == toUnit {
        return value;
    }
    UcumUnit? sourceUnit = parseUcumUnit(fromUnit);
    UcumUnit? targetUnit = parseUcumUnit(toUnit);
    if sourceUnit is () || targetUnit is () || !sameDimensions(sourceUnit.dimensions, targetUnit.dimensions) {
        return ();
    }
    decimal base = (value + sourceUnit.offset) * sourceUnit.factor;
    // Rounded so that conversions through repeating factors (e.g. 5/9 for [degF]) compare equal
    return (base / targetUnit.factor - targetUnit.offset).round(CONVERSION_FRACTION_DIGITS);
}

// Fractional digits kept in UCUM conversion results
const CONVERSION_FRACTION_DIGITS = 24;

// Number of `toUnit` units in one `fromUnit` unit within the calendar system
isolated function calendarFactor(string fromUnit, string toUnit) returns decimal? {
    if fromUnit == "year" && toUnit == "month" {
        return 12d;
    }
    if fromUnit == "month" && toUnit == "year" {
        return 1d / 12d;
    }
    decimal? fromSeconds = CALENDAR_UNIT_SECONDS[fromUnit];
    decimal? toSeconds = CALENDAR_UNIT_SECONDS[toUnit];
    return (fromSeconds is decimal && toSeconds is decimal) ? fromSeconds / toSeconds : ();
}

// Magnitude of a unit in its system's base (seconds for calendar units), used to pick the least or most
// granular of two commensurable units
isolated function unitMagnitude(string unit) returns decimal? {
    if isCalendarUnit(unit) {
        return CALENDAR_UNIT_SECONDS[unit];
    }
    UcumUnit? parsed = parseUcumUnit(unit);
    return (parsed is UcumUnit) ? parsed.factor : ();
}

# Expresses two quantities in a common unit so their values can be compared.
# Equality and comparison (`equivalence` false) convert to the least granular unit and treat calendar and UCUM
# years/months as not comparable; equivalence treats them as equivalent.
#
# + a - The first quantity
# + b - The second quantity
# + equivalence - Whether the values are aligned for equivalence
# + return - The two values in the common unit, or () when the quantities are not comparable
isolated function alignQuantities(QuantityValue a, QuantityValue b, boolean equivalence) returns [decimal, decimal]? {
    string ua = normalizeCalendarUnit(a.unit);
    string ub = normalizeCalendarUnit(b.unit);
    if ua == ub {
        return [a.value, b.value];
    }
    boolean calendarA = isCalendarUnit(ua);
    boolean calendarB = isCalendarUnit(ub);
    if calendarA != calendarB {
        // Mixed systems: compare in UCUM, except that years and months are only equivalent
        string ucumA = calendarA ? (CALENDAR_TO_UCUM[ua] ?: ua) : ua;
        string ucumB = calendarB ? (CALENDAR_TO_UCUM[ub] ?: ub) : ub;
        if !equivalence && (isYearOrMonth(ucumA) || isYearOrMonth(ucumB)) {
            return ();
        }
        return alignQuantities({value: a.value, unit: ucumA}, {value: b.value, unit: ucumB}, equivalence);
    }
    // Express both values in the least granular unit of the two
    decimal? magnitudeA = unitMagnitude(ua);
    decimal? magnitudeB = unitMagnitude(ub);
    if magnitudeA is () || magnitudeB is () {
        return ();
    }
    string target = magnitudeA >= magnitudeB ? ua : ub;
    decimal? va = convertQuantity(a.value, ua, target);
    decimal? vb = convertQuantity(b.value, ub, target);
    return (va is decimal && vb is decimal) ? [va, vb] : ();
}

# Adds (or subtracts, with `sign` -1) two quantities in the most granular of their units. Calendar years and
# months must be converted explicitly first; mixed calendar/UCUM operands give a calendar unit result.
#
# + a - The left quantity
# + b - The right quantity
# + sign - 1 to add, -1 to subtract
# + return - The result, or () when the units are not commensurable
isolated function addQuantities(QuantityValue a, QuantityValue b, decimal sign) returns QuantityValue? {
    string ua = normalizeCalendarUnit(a.unit);
    string ub = normalizeCalendarUnit(b.unit);
    if ua == ub {
        return {value: a.value + sign * b.value, unit: ua};
    }
    boolean calendarA = isCalendarUnit(ua);
    boolean calendarB = isCalendarUnit(ub);
    // Calendar years and months (and UCUM years/months mixed with calendar units) need explicit conversion
    if ua == "year" || ua == "month" || ub == "year" || ub == "month"
            || (calendarA != calendarB && (isYearOrMonth(ua) || isYearOrMonth(ub))) {
        return ();
    }
    if calendarA != calendarB {
        // Mixed systems: the result is expressed in calendar units
        string calendarUa = calendarA ? ua : (UCUM_TO_CALENDAR[ua] ?: "");
        string calendarUb = calendarB ? ub : (UCUM_TO_CALENDAR[ub] ?: "");
        if calendarUa == "" || calendarUb == "" {
            return ();
        }
        return addQuantities({value: a.value, unit: calendarUa}, {value: b.value, unit: calendarUb}, sign);
    }
    if !calendarA && (isSpecialUnit(ua) || isSpecialUnit(ub)) {
        return ();
    }
    decimal? magnitudeA = unitMagnitude(ua);
    decimal? magnitudeB = unitMagnitude(ub);
    if magnitudeA is () || magnitudeB is () {
        return ();
    }
    string target = magnitudeA <= magnitudeB ? ua : ub;
    decimal? va = convertQuantity(a.value, ua, target);
    decimal? vb = convertQuantity(b.value, ub, target);
    return (va is decimal && vb is decimal) ? {value: va + sign * vb, unit: target} : ();
}

# Multiplies or divides two quantities, combining their units. Calendar units and units on non-ratio scales
# are not supported.
#
# + a - The left quantity
# + b - The right quantity
# + divide - Whether to divide instead of multiply
# + return - The result, or () when it cannot be computed (unsupported units or division by zero)
isolated function multiplyQuantities(QuantityValue a, QuantityValue b, boolean divide) returns QuantityValue? {
    string ua = normalizeCalendarUnit(a.unit);
    string ub = normalizeCalendarUnit(b.unit);
    if isCalendarUnit(ua) || isCalendarUnit(ub) || isSpecialUnit(ua) || isSpecialUnit(ub) {
        return ();
    }
    if divide && b.value == 0d {
        return ();
    }
    map<int> combined = unitTerms(ua);
    foreach [string, int] [term, exponent] in unitTerms(ub).entries() {
        int total = (combined[term] ?: 0) + (divide ? -exponent : exponent);
        if total == 0 {
            _ = combined.removeIfHasKey(term);
        } else {
            combined[term] = total;
        }
    }
    return {value: divide ? a.value / b.value : a.value * b.value, unit: formatUnitTerms(combined)};
}

// ========================================
// UCUM PARSING
// ========================================

# Parses a UCUM unit expression.
#
# + unit - The UCUM unit (e.g. "mg", "km/h", "kg.m/s2", "mm[Hg]", "10*3/uL", "Cel")
# + return - The unit's conversion factor and dimensions, or () when the unit is not understood
isolated function parseUcumUnit(string unit) returns UcumUnit? {
    string expression = stripAnnotations(unit);
    if expression == "1" {
        return {factor: 1d, dimensions: {}};
    }
    decimal? offset = UCUM_OFFSETS[expression];
    if offset is decimal {
        [decimal, map<int>, boolean] atom = UCUM_ATOMS.get(expression);
        return {factor: atom[0], dimensions: atom[1].clone(), offset, special: true};
    }
    [UcumUnit, int]? parsed = parseUcumTerms(expression, 0);
    if parsed is () || parsed[1] != expression.length() {
        return ();
    }
    return parsed[0];
}

// term (('.' | '/') term)*, with an optional leading '/'
isolated function parseUcumTerms(string s, int startIndex) returns [UcumUnit, int]? {
    UcumUnit result = {factor: 1d, dimensions: {}};
    int pos = startIndex;
    boolean invert = false;
    if pos < s.length() && s.substring(pos, pos + 1) == "/" {
        invert = true;
        pos += 1;
    }
    while true {
        [UcumUnit, int]? term = parseUcumTerm(s, pos);
        if term is () {
            return ();
        }
        result = combineUnits(result, term[0], invert);
        pos = term[1];
        if pos >= s.length() {
            break;
        }
        string op = s.substring(pos, pos + 1);
        if op == "." {
            invert = false;
        } else if op == "/" {
            invert = true;
        } else {
            break;
        }
        pos += 1;
    }
    return [result, pos];
}

// '(' terms ')' exponent? | component
isolated function parseUcumTerm(string s, int startIndex) returns [UcumUnit, int]? {
    if startIndex >= s.length() {
        return ();
    }
    if s.substring(startIndex, startIndex + 1) != "(" {
        int end = startIndex;
        int depth = 0;
        while end < s.length() {
            string ch = s.substring(end, end + 1);
            if ch == "[" {
                depth += 1;
            } else if ch == "]" {
                depth -= 1;
            } else if depth == 0 && (ch == "." || ch == "/" || ch == "(" || ch == ")") {
                break;
            }
            end += 1;
        }
        UcumUnit? component = parseUcumComponent(s.substring(startIndex, end));
        return (component is UcumUnit) ? [component, end] : ();
    }
    [UcumUnit, int]? inner = parseUcumTerms(s, startIndex + 1);
    if inner is () || inner[1] >= s.length() || s.substring(inner[1], inner[1] + 1) != ")" {
        return ();
    }
    UcumUnit unit = inner[0];
    int pos = inner[1] + 1;
    // Exponent after a parenthesised group
    int expEnd = pos;
    if expEnd < s.length() && (s.substring(expEnd, expEnd + 1) == "-" || s.substring(expEnd, expEnd + 1) == "+") {
        expEnd += 1;
    }
    while expEnd < s.length() && isDigit(s.substring(expEnd, expEnd + 1)) {
        expEnd += 1;
    }
    if expEnd > pos {
        int|error exponent = int:fromString(s.substring(pos, expEnd));
        if exponent is error {
            return ();
        }
        unit = powerUnit(unit, exponent);
    }
    return [unit, expEnd];
}

// A single component: an integer factor, 10*n / 10^n, or a (prefixed) atom with an optional exponent
isolated function parseUcumComponent(string component) returns UcumUnit? {
    if component == "" {
        return ();
    }
    if re `[0-9]+`.isFullMatch(component) {
        decimal|error factor = decimal:fromString(component);
        return (factor is decimal) ? {factor, dimensions: {}} : ();
    }
    if component.startsWith("10*") || component.startsWith("10^") {
        int|error exponent = int:fromString(component.substring(3));
        if exponent is error {
            return ();
        }
        return {factor: exponent >= 0 ? pow10(exponent) : 1d / pow10(-exponent), dimensions: {}};
    }
    [string, int] [symbol, exponent] = splitUnitExponent(component);
    UcumUnit? atom = parseUcumAtom(symbol);
    return (atom is UcumUnit) ? powerUnit(atom, exponent) : ();
}

// Splits a trailing (optionally signed) exponent from a unit component: "cm2" → ["cm", 2], "s-1" → ["s", -1]
isolated function splitUnitExponent(string component) returns [string, int] {
    int split = component.length();
    while split > 0 && isDigit(component.substring(split - 1, split)) {
        split -= 1;
    }
    if split == 0 || split == component.length() || component.endsWith("]") {
        return [component, 1];
    }
    boolean negative = component.substring(split - 1, split) == "-";
    if negative || component.substring(split - 1, split) == "+" {
        split -= 1;
        if split == 0 {
            return [component, 1];
        }
    }
    int exponent = digitsToInt(component.substring(negative || component.substring(split, split + 1) == "+" ? split + 1 : split));
    return [component.substring(0, split), negative ? -exponent : exponent];
}

// An atom with an optional metric prefix; unknown bracketed units are arbitrary units of their own dimension
isolated function parseUcumAtom(string symbol) returns UcumUnit? {
    [decimal, map<int>, boolean]? atom = UCUM_ATOMS[symbol];
    if atom is [decimal, map<int>, boolean] {
        return {factor: atom[0], dimensions: atom[1].clone()};
    }
    foreach int prefixLength in [2, 1] {
        if symbol.length() > prefixLength {
            decimal? prefix = UCUM_PREFIXES[symbol.substring(0, prefixLength)];
            [decimal, map<int>, boolean]? prefixed = UCUM_ATOMS[symbol.substring(prefixLength)];
            if prefix is decimal && prefixed is [decimal, map<int>, boolean] && prefixed[2] {
                return {factor: prefix * prefixed[0], dimensions: prefixed[1].clone()};
            }
        }
    }
    if re `\[[^\[\]]+\]`.isFullMatch(symbol) {
        return {factor: 1d, dimensions: {[symbol]: 1}};
    }
    return ();
}

isolated function combineUnits(UcumUnit a, UcumUnit b, boolean divide) returns UcumUnit {
    Dimensions dimensions = a.dimensions.clone();
    foreach [string, int] [base, exponent] in b.dimensions.entries() {
        int total = (dimensions[base] ?: 0) + (divide ? -exponent : exponent);
        if total == 0 {
            _ = dimensions.removeIfHasKey(base);
        } else {
            dimensions[base] = total;
        }
    }
    return {factor: divide ? a.factor / b.factor : a.factor * b.factor, dimensions};
}

isolated function powerUnit(UcumUnit unit, int exponent) returns UcumUnit {
    UcumUnit result = {factor: 1d, dimensions: {}};
    foreach int i in 0 ..< (exponent < 0 ? -exponent : exponent) {
        result = combineUnits(result, unit, exponent < 0);
    }
    return result;
}

isolated function sameDimensions(Dimensions a, Dimensions b) returns boolean {
    if a.length() != b.length() {
        return false;
    }
    foreach [string, int] [base, exponent] in a.entries() {
        if b[base] != exponent {
            return false;
        }
    }
    return true;
}

isolated function stripAnnotations(string unit) returns string {
    string result = re `\{[^}]*\}`.replaceAll(unit.trim(), "");
    // An annotation on its own (e.g. "{beats}/min") stands for the unit 1
    return result == "" || result.startsWith("/") ? "1" + result : result;
}

// ========================================
// UNIT ALGEBRA
// ========================================

// Splits a unit expression into terms with exponents ("kg.m/s2" → {kg: 1, m: 1, s: -2}); parenthesised groups
// are kept as opaque terms
isolated function unitTerms(string unit) returns map<int> {
    string expression = stripAnnotations(unit);
    map<int> terms = {};
    boolean invert = false;
    int pos = 0;
    while pos < expression.length() {
        string ch = expression.substring(pos, pos + 1);
        if ch == "/" || ch == "." {
            invert = ch == "/";
            pos += 1;
            continue;
        }
        int end = pos;
        int depth = 0;
        while end < expression.length() {
            string c = expression.substring(end, end + 1);
            if c == "[" || c == "(" {
                depth += 1;
            } else if c == "]" || c == ")" {
                depth -= 1;
            } else if depth == 0 && (c == "." || c == "/") {
                break;
            }
            end += 1;
        }
        [string, int] [symbol, exponent] = splitUnitExponent(expression.substring(pos, end));
        if symbol != "1" {
            int total = (terms[symbol] ?: 0) + (invert ? -exponent : exponent);
            if total == 0 {
                _ = terms.removeIfHasKey(symbol);
            } else {
                terms[symbol] = total;
            }
        }
        pos = end;
    }
    return terms;
}

// Formats unit terms as a UCUM expression: numerator terms joined with '.', then each denominator term after '/'
isolated function formatUnitTerms(map<int> terms) returns string {
    string numerator = "";
    string denominator = "";
    foreach string symbol in terms.keys().sort() {
        int exponent = terms.get(symbol);
        if exponent > 0 {
            numerator += (numerator == "" ? "" : ".") + symbol + (exponent == 1 ? "" : exponent.toString());
        } else {
            denominator += "/" + symbol + (exponent == -1 ? "" : (-exponent).toString());
        }
    }
    if numerator == "" {
        return denominator == "" ? "1" : denominator;
    }
    return numerator + denominator;
}

// ========================================
// UNIT CLASSIFICATION
// ========================================

isolated function isCalendarUnit(string unit) returns boolean {
    return CALENDAR_UNIT_SECONDS.hasKey(unit);
}

isolated function isYearOrMonth(string ucumUnit) returns boolean {
    return ucumUnit == "a" || ucumUnit == "mo";
}

isolated function isSpecialUnit(string unit) returns boolean {
    return UCUM_OFFSETS.hasKey(stripAnnotations(unit));
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
