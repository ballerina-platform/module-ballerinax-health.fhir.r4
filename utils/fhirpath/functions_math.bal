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

isolated function applyAbsFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("abs", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    if val is int {
        return [val < 0 ? -val : val];
    } else if val is decimal {
        return [val < 0d ? -val : val];
    } else if val is float {
        return [val < 0.0 ? -val : val];
    }
    return [];
}

isolated function applyCeilingFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("ceiling", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
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

isolated function applyFloorFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("floor", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
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

isolated function applyTruncateFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("truncate", "0 parameters", params.length());
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
    }
    return [];
}

isolated function applyRoundFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
    int precision = 0;
    if params.length() >= 1 {
        json[] precResult = check evaluate(params[0], context, env);
        if precResult.length() == 1 {
            json p = precResult[0];
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

isolated function applySqrtFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return fnError("sqrt", "0 parameters", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json val = collection[0];
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

isolated function applyPowerFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("power", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json[] expResult = check evaluate(params[0], context, env);
    if expResult.length() == 0 {
        return [];
    }
    float base = toFloat(collection[0]);
    float exp = toFloat(expResult[0]);
    float result = float:pow(base, exp);
    if result.isNaN() || result.isInfinite() {
        return [];
    }
    if result == float:floor(result) && exp >= 0.0 {
        return [<int>result];
    }
    decimal|error d = decimal:fromString(result.toString());
    if d is decimal {
        return [d];
    }
    return [result];
}

isolated function applyExpFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
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

isolated function applyLnFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
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

isolated function applyLogFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return fnError("log", "1 parameter", params.length());
    }
    if collection.length() == 0 {
        return [];
    }
    json[] baseResult = check evaluate(params[0], context, env);
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

isolated function toFloat(json val) returns float {
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

isolated function fnError(string name, string expected, int got) returns FHIRPathInterpreterError {
    return error FHIRPathInterpreterError(
        string `${name}() requires ${expected}, got ${got}`,
        token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
}
