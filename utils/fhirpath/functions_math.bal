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
// MATH FUNCTIONS
// ========================================

isolated function applyAbsFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "abs");
    if params.length() != 0 {
        return fnError("abs", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if systemTypeOf(collection[0]) == "Quantity" && val is map<json> {
        [decimal, string] [qValue, unit] = quantityParts(val);
        return [quantityItem(qValue < 0d ? -qValue : qValue, unit)];
    }
    if val is int {
        return [val < 0 ? -val : val];
    } else if val is decimal {
        return [val < 0d ? -val : val];
    } else if val is float {
        return [val < 0.0 ? -val : val];
    }
    return [];
}

isolated function applyCeilingFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "ceiling");
    if params.length() != 0 {
        return fnError("ceiling", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is int {
        return [val];
    } else if val is decimal {
        decimal d = val;
        int i = <int>d;
        return [d > <decimal>i ? i + 1 : i];
    } else if val is float {
        return [<int>float:ceiling(val)];
    }
    return [];
}

isolated function applyFloorFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "floor");
    if params.length() != 0 {
        return fnError("floor", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is int {
        return [val];
    } else if val is decimal {
        decimal d = val;
        int i = <int>d;
        return [d < <decimal>i ? i - 1 : i];
    } else if val is float {
        return [<int>float:floor(val)];
    }
    return [];
}

isolated function applyTruncateFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "truncate");
    if params.length() != 0 {
        return fnError("truncate", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    if val is int {
        return [val];
    } else if val is decimal {
        return [truncateDecimal(val)];
    } else if val is float {
        return [truncateDecimal(<decimal>val)];
    }
    return [];
}

isolated function applyRoundFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "round");
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    int precision = 0;
    if params.length() >= 1 {
        FhirPathItem[] precResult = check evaluate(params[0], context, env);
        if precResult.length() == 1 {
            json p = systemValueOf(precResult[0]);
            if p is int {
                precision = p;
            } else if p is decimal {
                precision = <int>p;
            }
        }
    }

    float fVal;
    if val is int {
        fVal = <float>val;
    } else if val is decimal {
        fVal = <float>val;
    } else if val is float {
        fVal = val;
    } else {
        return [];
    }

    float factor = float:pow(10.0, <float>precision);
    float rounded = float:round(fVal * factor) / factor;
    if precision == 0 {
        return [<int>rounded];
    }
    decimal|error d = decimal:fromString(rounded.toString());
    if d is decimal {
        return [d];
    }
    return [rounded];
}

isolated function applySqrtFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "sqrt");
    if params.length() != 0 {
        return fnError("sqrt", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = systemValueOf(collection[0]);
    float fVal = toFloat(val);
    if fVal < 0.0 {
        return [];
    }
    float result = float:sqrt(fVal);
    decimal|error d = decimal:fromString(result.toString());
    if d is decimal {
        return [d];
    }
    return [result];
}

isolated function applyPowerFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "power");
    if params.length() != 1 {
        return fnError("power", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    FhirPathItem[] expResult = check evaluate(params[0], context, env);
    if expResult.length() == 0 {
        return [];
    }
    float base = toFloat(collection[0]);
    float exp = toFloat(expResult[0]);
    float result = float:pow(base, exp);
    if result.isNaN() || result.isInfinite() {
        return [];
    }
    // Integer (or Long) operands give an Integer (or Long), computed exactly; a result that does not fit is empty
    string baseType = systemTypeOf(collection[0]);
    string expType = systemTypeOf(expResult[0]);
    if (baseType == "Integer" || baseType == "Long") && (expType == "Integer" || expType == "Long") && exp >= 0.0 {
        if float:abs(result) > 9.3e18 {
            return [];
        }
        int intBase = <int>systemValueOf(collection[0]);
        int power = 1;
        foreach int _ in 0 ..< <int>exp {
            int|error next = trap (power * intBase);
            if next is error {
                return [];
            }
            power = next;
            if power == 0 || power == 1 {
                break;
            }
        }
        if power == 1 && intBase == -1 && <int>exp % 2 == 1 {
            power = -1;
        }
        return integerResult([power], collection[0], expResult[0]);
    }
    decimal|error d = decimal:fromString(result.toString());
    if d is decimal {
        return [d];
    }
    return [result];
}

isolated function applyExpFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "exp");
    if params.length() != 0 {
        return fnError("exp", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    float result = float:exp(toFloat(collection[0]));
    decimal|error d = decimal:fromString(result.toString());
    if d is decimal {
        return [d];
    }
    return [result];
}

isolated function applyLnFunction(FhirPathItem[] collection, Expr[] params) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "ln");
    if params.length() != 0 {
        return fnError("ln", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    float fVal = toFloat(collection[0]);
    if fVal <= 0.0 {
        return [];
    }
    float result = float:log(fVal);
    decimal|error d = decimal:fromString(result.toString());
    if d is decimal {
        return [d];
    }
    return [result];
}

isolated function applyLogFunction(FhirPathItem[] collection, Expr[] params, FhirPathItem context, FhirPathEnv env) returns FHIRPathInterpreterError|FhirPathItem[] {
    check mathInput(collection, "log");
    if params.length() != 1 {
        return fnError("log", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    FhirPathItem[] baseResult = check evaluate(params[0], context, env);
    if baseResult.length() == 0 {
        return [];
    }
    float fVal = toFloat(collection[0]);
    float logBase = toFloat(baseResult[0]);
    if fVal <= 0.0 || logBase <= 0.0 || logBase == 1.0 {
        return [];
    }
    float result = float:log(fVal) / float:log(logBase);
    decimal|error d = decimal:fromString(result.toString());
    if d is decimal {
        return [d];
    }
    return [result];
}

// ========================================
// HELPERS
// ========================================

isolated function toFloat(FhirPathItem item) returns float {
    json val = valueOf(item);
    if val is int {
        return <float>val;
    } else if val is decimal {
        return <float>val;
    } else if val is float {
        return val;
    } else if val is string {
        float|error f = float:fromString(val);
        return f is float ? f : 0.0;
    }
    return 0.0;
}

// Math functions take a single Integer, Long, Decimal or Quantity
isolated function mathInput(FhirPathItem[] collection, string name) returns FHIRPathInterpreterError? {
    FhirPathItem? input = check singleInput(collection, name);
    if input is () {
        return ();
    }
    string kind = systemTypeOf(input);
    if kind != "Integer" && kind != "Long" && kind != "Decimal" && kind != "Quantity" {
        return error FHIRPathInterpreterError(string `${name}() requires a numeric input, got ${kind}`,
            token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
    }
    return ();
}

// Integer part of a decimal, truncated toward zero (a numeric cast would round)
isolated function truncateDecimal(decimal d) returns int {
    return <int>(d < 0d ? d.ceiling() : d.floor());
}

// [value, unit] of a quantity payload (FHIR Quantity code preferred over its display unit)
isolated function quantityParts(map<json> quantity) returns [decimal, string] {
    json code = quantity["code"];
    json unit = quantity["unit"];
    return [toDecimalValue(quantity["value"]), code is string ? code : (unit is string ? unit : "1")];
}

// Returns the single input item, () for an empty input, or an error when the input has several items
isolated function singleInput(FhirPathItem[] collection, string name) returns FhirPathItem?|FHIRPathInterpreterError {
    if collection.length() == 0 {
        return ();
    }
    if collection.length() > 1 {
        return error FHIRPathInterpreterError(string `${name}() requires a single input item, got ${collection.length()}`,
            token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
    }
    return collection[0];
}

isolated function fnError(string name, string expected, int got) returns FHIRPathInterpreterError {
    return error FHIRPathInterpreterError(
        string `${name}() requires ${expected}, got ${got}`,
        token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
}
