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
// INTERPRETER FOR FHIRPATH EXPRESSIONS
// ========================================
// Tree-walking interpreter for the complete FHIRPath N1 normative grammar.

# Represents an interpreter runtime error with token information.
#
# + token - The token where the runtime error occurred
type InterpreterError record {|
    FhirPathToken token;
|};

# Error type for FHIRPath interpreter runtime errors.
type FHIRPathInterpreterError distinct error<InterpreterError>;

isolated class VariableScope {
    private map<json & readonly> vars = {};
    private map<boolean> localDefs = {};

    isolated function define(string name, json value) returns boolean {
        lock {
            if self.localDefs.hasKey(name) { return false; }
            self.vars[name] = value.cloneReadOnly();
            self.localDefs[name] = true;
        }
        return true;
    }

    isolated function get(string name) returns (json & readonly)? {
        lock { return self.vars[name]; }
    }

    isolated function hasKey(string name) returns boolean {
        lock { return self.vars.hasKey(name); }
    }

    private isolated function inherit(map<json & readonly> & readonly snapshot) {
        lock {
            foreach var [k, v] in snapshot.entries() {
                self.vars[k] = v;
            }
        }
    }

    isolated function childScope() returns VariableScope {
        map<json & readonly> & readonly snapshot;
        lock { snapshot = self.vars.cloneReadOnly(); }
        VariableScope child = new VariableScope();
        child.inherit(snapshot);
        return child;
    }
}

# Evaluation environment carrying $index, $total, and named variables.
#
# + index - Current iteration index ($index)
# + total - Running aggregate total ($total)
# + scope - Named variables defined via defineVariable()
type FhirPathEnv record {|
    int index?;
    json total?;
    VariableScope scope;
|};

// ========================================
// PUBLIC ENTRY POINTS
// ========================================

# Interprets a FHIRPath expression against a JSON context object.
#
# + expression - The parsed FHIRPath expression (AST)
# + context - The JSON context object (typically a FHIR resource)
# + variables - optional map of variable bindings available in the expression
# + return - A collection of JSON results, or a FhirpathInterpreterError if evaluation fails
isolated function interpret(Expr expression, json context, map<json>? variables = ()) returns FHIRPathInterpreterError|json[] {
    VariableScope scope = new VariableScope();
    if variables is map<json> {
        foreach var [k, v] in variables.entries() {
            _ = scope.define(k, v);
        }
    }
    FhirPathEnv env = {scope: scope};
    return evaluate(expression, context, env);
}

# Evaluates a FHIRPath expression node against a context.
# Dispatches to the appropriate visitor function based on expression type.
#
# + expr - The expression node to evaluate
# + context - The current evaluation context (JSON value, serves as $this)
# + env - The evaluation environment ($index, $total, variables)
# + return - A collection of JSON results, or a FhirpathInterpreterError if evaluation fails
isolated function evaluate(Expr expr, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    match expr.kind {
        "Literal" => {
            return visitLiteralExpr(<LiteralExpr>expr, context);
        }
        "Identifier" => {
            return visitIdentifierExpr(<IdentifierExpr>expr, context, env);
        }
        "MemberAccess" => {
            return visitMemberAccessExpr(<MemberAccessExpr>expr, context, env);
        }
        "Indexer" => {
            return visitIndexerExpr(<IndexerExpr>expr, context, env);
        }
        "Function" => {
            return visitFunctionExpr(<FunctionExpr>expr, context, env);
        }
        "Binary" => {
            return visitBinaryExpr(<BinaryExpr>expr, context, env);
        }
        "Unary" => {
            return visitUnaryExpr(<UnaryExpr>expr, context, env);
        }
        "ExternalConstant" => {
            return visitExternalConstantExpr(<ExternalConstantExpr>expr, env);
        }
        "QuantityLiteral" => {
            return visitQuantityLiteralExpr(<QuantityLiteralExpr>expr);
        }
    }
    return [];
}

// ========================================
// VISITOR FUNCTIONS
// ========================================

isolated function visitLiteralExpr(LiteralExpr expr, json context) returns json[] {
    json value = <json>expr.value;
    if value is () {
        return [];
    }
    return [value];
}

isolated function visitIdentifierExpr(IdentifierExpr expr, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    // Special variables
    if expr.name == "$this" {
        return wrapInCollection(context);
    }
    if expr.name == "$index" {
        return [env.index ?: 0];
    }
    if expr.name == "$total" {
        json? total = env?.total;
        if total is () {
            return [];
        }
        return [total];
    }

    // Named variables defined by defineVariable()
    if env.scope.hasKey(expr.name) {
        return wrapInCollection(env.scope.get(expr.name));
    }

    if context is () {
        return [];
    }

    if context is map<json> {
        string fieldName = expr.name;

        // Check resource type match
        json|error resourceTypeValue = context.resourceType;
        if resourceTypeValue !is error && resourceTypeValue is string {
            if fieldName == resourceTypeValue {
                return [context];
            }
        }

        if context.hasKey(fieldName) {
            json fieldValue = context[fieldName];
            return wrapInCollection(fieldValue);
        }
        // FHIR polymorphic type access: "value" matches "valueQuantity", "valueString", etc.
        json[] polyResults = fhirPolymorphicAccess(context, fieldName);
        if polyResults.length() > 0 {
            return polyResults;
        }
        return [];
    }

    return [];
}

isolated function visitMemberAccessExpr(MemberAccessExpr expr, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    json[] targetResults = check evaluate(expr.target, context, env);

    json[] results = [];
    foreach json item in targetResults {
        json[] memberResults = check accessMember(item, expr.member);
        foreach json memberValue in memberResults {
            results.push(memberValue);
        }
    }

    return results;
}

isolated function accessMember(json item, string memberName) returns FHIRPathInterpreterError|json[] {
    if item is () {
        return [];
    }
    if item is map<json> {
        if item.hasKey(memberName) {
            json fieldValue = item[memberName];
            return wrapInCollection(fieldValue);
        }
        // FHIR polymorphic type access: "value" matches "valueQuantity", etc.
        json[] polyResults = fhirPolymorphicAccess(item, memberName);
        if polyResults.length() > 0 {
            return polyResults;
        }
        return [];
    }
    if item is json[] {
        json[] results = [];
        foreach json element in item {
            json[] elementResults = check accessMember(element, memberName);
            foreach json value in elementResults {
                results.push(value);
            }
        }
        return results;
    }
    return [];
}

// Returns values matching FHIR choice-type fields (e.g. "value" matches "valueQuantity")
isolated function fhirPolymorphicAccess(map<json> obj, string fieldName) returns json[] {
    json[] results = [];
    string prefix = fieldName;
    foreach string key in obj.keys() {
        if key.length() > prefix.length() && key.startsWith(prefix) {
            string suffix = key.substring(prefix.length());
            string nextChar = suffix.substring(0, 1);
            if nextChar >= "A" && nextChar <= "Z" {
                json val = obj[key];
                if val is map<json> {
                    map<json> annotated = {};
                    foreach [string, json] [k, v] in val.entries() {
                        annotated[k] = v;
                    }
                    annotated["__fhirType"] = suffix;
                    results.push(annotated);
                } else {
                    results.push(val);
                }
            }
        }
    }
    return results;
}

isolated function visitIndexerExpr(IndexerExpr expr, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    json[] targetResults = check evaluate(expr.target, context, env);
    json[] indexResults = check evaluate(expr.index, context, env);

    if indexResults.length() != 1 {
        return [];
    }

    json indexValue = indexResults[0];
    int index;
    if indexValue is int {
        index = indexValue;
    } else if indexValue is decimal {
        index = <int>indexValue;
    } else if indexValue is float {
        if indexValue % 1.0 != 0.0 {
            return [];
        }
        index = <int>indexValue;
    } else {
        return [];
    }

    if index < 0 || index >= targetResults.length() {
        return [];
    }
    return wrapInCollection(targetResults[index]);
}

isolated function visitUnaryExpr(UnaryExpr expr, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    json[] operandResults = check evaluate(expr.operand, context, env);
    if operandResults.length() == 0 {
        return [];
    }
    json val = operandResults[0];
    if expr.operator.tokenType == MINUS {
        if val is int { return [-val]; }
        if val is decimal { return [-val]; }
        if val is float { return [-val]; }
        return error FHIRPathInterpreterError(
            "Unary minus cannot be applied to a non-numeric value",
            token = expr.operator);
    }
    // PLUS is a no-op
    return [val];
}

isolated function visitExternalConstantExpr(ExternalConstantExpr expr, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if env.scope.hasKey(expr.name) {
        return wrapInCollection(env.scope.get(expr.name));
    }
    match expr.name {
        "sct" => { return ["http://snomed.info/sct"]; }
        "loinc" => { return ["http://loinc.org"]; }
        "ucum" => { return ["http://unitsofmeasure.org"]; }
    }
    if expr.name.startsWith("vs-") {
        return ["http://hl7.org/fhir/ValueSet/" + expr.name.substring(3)];
    }
    if expr.name.startsWith("ext-") {
        return ["http://hl7.org/fhir/StructureDefinition/" + expr.name.substring(4)];
    }
    FhirPathToken dummyToken = {tokenType: IDENTIFIER, lexeme: "%" + expr.name, literal: (), position: 0};
    return error FHIRPathInterpreterError("Undefined constant: %" + expr.name, token = dummyToken);
}

isolated function visitQuantityLiteralExpr(QuantityLiteralExpr expr) returns json[] {
    // Represent as a map with value and unit for quantity arithmetic
    return [{"value": expr.value, "unit": expr.unit}];
}

// ========================================
// BINARY EXPRESSION
// ========================================

isolated function visitBinaryExpr(BinaryExpr expr, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    TokenType operatorType = expr.operator.tokenType;

    // IS and AS: don't evaluate the right side as a value; it's a type name
    if operatorType == IS {
        json[] leftResults = check evaluate(expr.left, context, env);
        string typeName = extractTypeName(expr.right);
        if leftResults.length() == 0 { return [false]; }
        return [matchesFhirType(leftResults[0], typeName, isSystemSourceExpr(expr.left), getDeclaredFhirType(expr.left))];
    }
    if operatorType == AS {
        json[] leftResults = check evaluate(expr.left, context, env);
        string typeName = extractTypeName(expr.right);
        if !isKnownFhirType(typeName) {
            return error FHIRPathInterpreterError(string `as: unknown type '${typeName}'`,
                token = expr.operator);
        }
        if leftResults.length() > 1 {
            return error FHIRPathInterpreterError("as: cannot cast a collection with more than 1 item",
                token = expr.operator);
        }
        string? declaredType = getDeclaredFhirType(expr.left);
        json[] result = [];
        foreach json item in leftResults {
            if exactFhirTypeMatch(item, typeName, declaredType) {
                result.push(item);
            }
        }
        return result;
    }

    // Short-circuit evaluation for logical operators
    if operatorType == AND {
        json[] leftResults = check evaluate(expr.left, context, env);
        if leftResults.length() > 0 && !isTruthy(leftResults) {
            return [false];
        }
        json[] rightResults = check evaluate(expr.right, context, env);
        return applyAndOperator(leftResults, rightResults);
    }
    if operatorType == OR {
        json[] leftResults = check evaluate(expr.left, context, env);
        if leftResults.length() > 0 && isTruthy(leftResults) {
            return [true];
        }
        json[] rightResults = check evaluate(expr.right, context, env);
        return applyOrOperator(leftResults, rightResults);
    }
    if operatorType == IMPLIES {
        json[] leftResults = check evaluate(expr.left, context, env);
        // false implies X = true; empty implies X = unknown
        if leftResults.length() > 0 && !isTruthy(leftResults) {
            return [true];
        }
        json[] rightResults = check evaluate(expr.right, context, env);
        return applyImpliesOperator(leftResults, rightResults);
    }

    if operatorType == PIPE {
        json[] leftResults = check evaluate(expr.left, context, {scope: env.scope.childScope(), index: env?.index, total: env?.total});
        json[] rightResults = check evaluate(expr.right, context, {scope: env.scope.childScope(), index: env?.index, total: env?.total});
        return applyUnionOperator(leftResults, rightResults);
    }

    json[] leftResults = check evaluate(expr.left, context, env);
    json[] rightResults = check evaluate(expr.right, context, env);

    match operatorType {
        EQUAL => { return applyEqualityOperator(leftResults, rightResults, true); }
        BANG_EQUAL => { return applyEqualityOperator(leftResults, rightResults, false); }
        TILDE => { return applyEquivalenceOperator(leftResults, rightResults, true); }
        BANG_TILDE => { return applyEquivalenceOperator(leftResults, rightResults, false); }
        XOR => { return applyXorOperator(leftResults, rightResults); }
        LESS_THAN => { return applyComparisonOperator(leftResults, rightResults, "<"); }
        GREATER_THAN => { return applyComparisonOperator(leftResults, rightResults, ">"); }
        LESS_EQUAL => { return applyComparisonOperator(leftResults, rightResults, "<="); }
        GREATER_EQUAL => { return applyComparisonOperator(leftResults, rightResults, ">="); }
        PLUS => { return applyAdditiveOperator(leftResults, rightResults, "+"); }
        MINUS => { return applyAdditiveOperator(leftResults, rightResults, "-"); }
        AMPERSAND => { return applyConcatenateOperator(leftResults, rightResults); }
        STAR => { return applyMultiplicativeOperator(leftResults, rightResults, "*"); }
        SLASH => { return applyMultiplicativeOperator(leftResults, rightResults, "/"); }
        DIV => { return applyMultiplicativeOperator(leftResults, rightResults, "div"); }
        MOD => { return applyMultiplicativeOperator(leftResults, rightResults, "mod"); }
        IN => { return applyInOperator(leftResults, rightResults); }
        CONTAINS => { return applyInOperator(rightResults, leftResults); }
    }

    return error FHIRPathInterpreterError(string `Unknown binary operator: ${expr.operator.lexeme}`,
        token = expr.operator);
}

# Extracts the type name string from a type expression right-hand side.
#
# + expr - The expression node representing the type name
# + return - The fully-qualified type name string, or empty string if unresolvable
isolated function extractTypeName(Expr expr) returns string {
    if expr is IdentifierExpr {
        return expr.name;
    }
    if expr is LiteralExpr && expr.value is string {
        return <string>expr.value;
    }
    if expr is MemberAccessExpr {
        string targetName = extractTypeName(expr.target);
        if targetName.length() > 0 {
            return targetName + "." + expr.member;
        }
        return expr.member;
    }
    return "";
}

// ========================================
// OPERATOR IMPLEMENTATIONS
// ========================================

isolated function applyEqualityOperator(json[] left, json[] right, boolean checkEqual) returns json[] {
    if left.length() == 0 || right.length() == 0 {
        return [];
    }
    if left.length() == 1 && right.length() == 1 {
        boolean? areEqual = jsonValuesEqual(left[0], right[0]);
        if areEqual is () { return []; }
        return checkEqual ? [areEqual] : [!areEqual];
    }
    if left.length() == right.length() {
        boolean allEqual = true;
        foreach int i in 0 ..< left.length() {
            boolean? eq = jsonValuesEqual(left[i], right[i]);
            if eq is () { return []; }
            if !eq {
                allEqual = false;
                break;
            }
        }
        return checkEqual ? [allEqual] : [!allEqual];
    }
    return [!checkEqual];
}

isolated function applyEquivalenceOperator(json[] left, json[] right, boolean checkEquivalent) returns json[] {
    if left.length() == 0 && right.length() == 0 {
        return [checkEquivalent];
    }
    if left.length() == 0 || right.length() == 0 {
        return [!checkEquivalent];
    }
    if left.length() != right.length() {
        return [!checkEquivalent];
    }
    // Multi-element equivalence is set-based (order-independent):
    // every element in left must have an equivalent in right, and vice versa.
    boolean allLeftInRight = true;
    foreach json lItem in left {
        boolean found = false;
        foreach json rItem in right {
            if jsonValuesEquivalent(lItem, rItem) {
                found = true;
                break;
            }
        }
        if !found {
            allLeftInRight = false;
            break;
        }
    }
    boolean allRightInLeft = true;
    if allLeftInRight {
        foreach json rItem in right {
            boolean found = false;
            foreach json lItem in left {
                if jsonValuesEquivalent(rItem, lItem) {
                    found = true;
                    break;
                }
            }
            if !found {
                allRightInLeft = false;
                break;
            }
        }
    }
    boolean equiv = allLeftInRight && allRightInLeft;
    return checkEquivalent ? [equiv] : [!equiv];
}

isolated function applyAndOperator(json[] left, json[] right) returns json[] {
    boolean leftEmpty = left.length() == 0;
    boolean rightEmpty = right.length() == 0;

    if (!leftEmpty && !isTruthy(left)) || (!rightEmpty && !isTruthy(right)) {
        return [false];
    }
    if leftEmpty || rightEmpty {
        return [];
    }
    return [true];
}

isolated function applyOrOperator(json[] left, json[] right) returns json[] {
    boolean leftEmpty = left.length() == 0;
    boolean rightEmpty = right.length() == 0;

    if (!leftEmpty && isTruthy(left)) || (!rightEmpty && isTruthy(right)) {
        return [true];
    }
    if leftEmpty || rightEmpty {
        return [];
    }
    return [false];
}

isolated function applyXorOperator(json[] left, json[] right) returns json[] {
    if left.length() == 0 || right.length() == 0 {
        return [];
    }
    return [isTruthy(left) != isTruthy(right)];
}

isolated function applyImpliesOperator(json[] left, json[] right) returns json[] {
    boolean leftEmpty = left.length() == 0;
    boolean rightEmpty = right.length() == 0;

    // false implies X = true
    if !leftEmpty && !isTruthy(left) {
        return [true];
    }
    // empty implies false = empty; empty implies empty = empty
    if leftEmpty {
        if rightEmpty { return []; }
        if isTruthy(right) { return [true]; }
        return [];
    }
    // true implies X
    if rightEmpty { return []; }
    return [isTruthy(right)];
}

isolated function applyComparisonOperator(json[] left, json[] right, string op) returns FHIRPathInterpreterError|json[] {
    if left.length() == 0 || right.length() == 0 {
        return [];
    }
    json l = left[0];
    json r = right[0];

    // Numeric comparison
    if (l is int || l is decimal || l is float) && (r is int || r is decimal || r is float) {
        float lf = toFloat(l);
        float rf = toFloat(r);
        if op == "<" { return [lf < rf]; }
        if op == ">" { return [lf > rf]; }
        if op == "<=" { return [lf <= rf]; }
        if op == ">=" { return [lf >= rf]; }
    }

    // Incompatible: numeric vs non-numeric non-null value
    boolean lNumeric = l is int || l is decimal || l is float;
    boolean rNumeric = r is int || r is decimal || r is float;
    if (lNumeric && !rNumeric && r !is ()) || (rNumeric && !lNumeric && l !is ()) {
        return error FHIRPathInterpreterError(
            string `Cannot compare numeric and non-numeric types with '${op}'`,
            token = {tokenType: IDENTIFIER, lexeme: op, literal: (), position: 0});
    }

    // String comparison (includes date/time literals)
    if l is string && r is string {
        // Timezone-aware datetime comparison: normalize both to UTC minutes
        if l.startsWith("@") && r.startsWith("@") {
            int? lMin = datetimeToUTCMinutes(l);
            int? rMin = datetimeToUTCMinutes(r);
            if lMin is int && rMin is int {
                if op == "<" { return [lMin < rMin]; }
                if op == ">" { return [lMin > rMin]; }
                if op == "<=" { return [lMin <= rMin]; }
                if op == ">=" { return [lMin >= rMin]; }
            }
            // Precision-aware comparison: incompatible precision → uncertain → empty
            string kindL = fhirDateType(l);
            string kindR = fhirDateType(r);
            if kindL != kindR { return []; }
            string normL = normalizeDateTimeNoTz(stripTimezone(l));
            string normR = normalizeDateTimeNoTz(stripTimezone(r));
            if normL.length() != normR.length() { return []; }
            if op == "<" { return [normL < normR]; }
            if op == ">" { return [normL > normR]; }
            if op == "<=" { return [normL <= normR]; }
            if op == ">=" { return [normL >= normR]; }
        }
        if op == "<" { return [l < r]; }
        if op == ">" { return [l > r]; }
        if op == "<=" { return [l <= r]; }
        if op == ">=" { return [l >= r]; }
    }

    // Quantity comparison (FHIR Quantity map vs map or map vs string literal)
    if l is map<json> || r is map<json> {
        map<json>? lq = l is map<json> ? <map<json>>l : (l is string ? parseQuantityFromString(<string>l) : ());
        map<json>? rq = r is map<json> ? <map<json>>r : (r is string ? parseQuantityFromString(<string>r) : ());
        if lq is map<json> && rq is map<json> {
            json lv = lq["value"];
            json rv = rq["value"];
            if (lv is int || lv is decimal || lv is float) && (rv is int || rv is decimal || rv is float) {
                string? lu = lq["unit"] is string ? <string>lq["unit"] : ();
                string? lc = lq["code"] is string ? <string>lq["code"] : ();
                string? ru = rq["unit"] is string ? <string>rq["unit"] : ();
                string? rc = rq["code"] is string ? <string>rq["code"] : ();
                if unitsMatch(lu, lc, ru, rc) {
                    float lf = toFloat(lv);
                    float rf = toFloat(rv);
                    if op == "<" { return [lf < rf]; }
                    if op == ">" { return [lf > rf]; }
                    if op == "<=" { return [lf <= rf]; }
                    if op == ">=" { return [lf >= rf]; }
                }
                string effectiveL = (lu ?: lc) ?: "";
                string effectiveR = (ru ?: rc) ?: "";
                string? normLU = quantityUnitCanonical(effectiveL);
                string? normRU = quantityUnitCanonical(effectiveR);
                if normLU is string && normRU is string && normLU == normRU {
                    float lf = toFloat(lv);
                    float rf = toFloat(rv);
                    if op == "<" { return [lf < rf]; }
                    if op == ">" { return [lf > rf]; }
                    if op == "<=" { return [lf <= rf]; }
                    if op == ">=" { return [lf >= rf]; }
                }
            }
        }
    }

    return [];
}

isolated function applyAdditiveOperator(json[] left, json[] right, string op) returns FHIRPathInterpreterError|json[] {
    if left.length() == 0 || right.length() == 0 {
        return [];
    }
    json l = left[0];
    json r = right[0];

    if op == "+" {
        if l is string && r is string {
            return [l + r];
        }
        if (l is int || l is decimal || l is float) && (r is int || r is decimal || r is float) {
            return numericBinaryOp(l, r, "+");
        }
        if l is string && l.startsWith("@") && r is map<json> {
            return addDateTimeQuantity(l, r, "+");
        }
        if l is string && l.startsWith("@") && (r is int || r is decimal || r is float) {
            return error FHIRPathInterpreterError(
                "Cannot add a plain number to a date/time without a unit",
                token = {tokenType: IDENTIFIER, lexeme: "+", literal: (), position: 0});
        }
    } else if op == "-" {
        if (l is int || l is decimal || l is float) && (r is int || r is decimal || r is float) {
            return numericBinaryOp(l, r, "-");
        }
        if l is string && l.startsWith("@") && r is map<json> {
            return addDateTimeQuantity(l, r, "-");
        }
    }
    return [];
}

isolated function addDateTimeQuantity(string dateTimeStr, map<json> qty, string op) returns FHIRPathInterpreterError|json[] {
    json qVal = qty["value"];
    json qUnit = qty["unit"];
    if !(qVal is decimal || qVal is int || qVal is float) || !(qUnit is string) {
        return [];
    }
    decimal value = qVal is decimal ? qVal : (qVal is int ? <decimal>qVal : <decimal><float>qVal);
    if op == "-" {
        value = -value;
    }
    string unit = <string>qUnit;
    string lower = unit.toLowerAscii();

    string canonicalUnit;
    if lower == "day" || lower == "days" || lower == "d" {
        canonicalUnit = "day";
    } else if lower == "week" || lower == "weeks" || lower == "wk" {
        canonicalUnit = "week";
    } else if lower == "month" || lower == "months" {
        canonicalUnit = "month";
    } else if lower == "year" || lower == "years" {
        canonicalUnit = "year";
    } else if lower == "hour" || lower == "hours" || lower == "h" {
        canonicalUnit = "hour";
    } else if lower == "minute" || lower == "minutes" || lower == "min" {
        canonicalUnit = "minute";
    } else if lower == "second" || lower == "seconds" || lower == "s" {
        canonicalUnit = "second";
    } else if lower == "millisecond" || lower == "milliseconds" || lower == "ms" {
        canonicalUnit = "millisecond";
    } else {
        return error FHIRPathInterpreterError(
            string `Unsupported unit for date/time arithmetic: '${unit}'`,
            token = {tokenType: IDENTIFIER, lexeme: unit, literal: (), position: 0});
    }

    string s = dateTimeStr.substring(1);
    if s.startsWith("T") {
        return addQuantityToTimeOnly(s.substring(1), canonicalUnit, value);
    }
    int? tIdx = s.indexOf("T");
    if tIdx is () {
        return addQuantityToDateOnly(s, canonicalUnit, value);
    }
    return addQuantityToDateTimeStr(s, tIdx, canonicalUnit, value);
}

isolated function addQuantityToTimeOnly(string timeStr, string unit, decimal value) returns FHIRPathInterpreterError|json[] {
    if unit == "day" || unit == "week" || unit == "month" || unit == "year" {
        return error FHIRPathInterpreterError(
            string `Cannot add ${unit}s to a time-only value`,
            token = {tokenType: IDENTIFIER, lexeme: unit, literal: (), position: 0});
    }

    string[] colonParts = re`:`.split(timeStr);
    if colonParts.length() < 2 {
        return [];
    }
    int|error hourParse = int:fromString(colonParts[0]);
    int|error minParse = int:fromString(colonParts[1]);
    if hourParse is error || minParse is error {
        return [];
    }
    int hour = hourParse;
    int minute = minParse;
    int second = 0;
    int ms = 0;
    boolean hasMs = false;
    boolean hasSec = false;

    if colonParts.length() >= 3 {
        hasSec = true;
        string secPart = colonParts[2];
        int? dotIdx = secPart.indexOf(".");
        if dotIdx is int {
            hasMs = true;
            int|error secParse = int:fromString(secPart.substring(0, dotIdx));
            int|error msParse = int:fromString(secPart.substring(dotIdx + 1));
            if secParse is error || msParse is error { return []; }
            second = secParse;
            ms = msParse;
        } else {
            int|error secParse = int:fromString(secPart);
            if secParse is error { return []; }
            second = secParse;
        }
    }

    decimal msDecimal = 0;
    if unit == "millisecond" { msDecimal = value; }
    else if unit == "second" { msDecimal = value * 1000d; }
    else if unit == "minute" { msDecimal = value * 60000d; }
    else if unit == "hour" { msDecimal = value * 3600000d; }

    int totalMs = ms + (second * 1000) + (minute * 60000) + (hour * 3600000) + <int>msDecimal;
    int msInDay = 86400000;
    totalMs = ((totalMs % msInDay) + msInDay) % msInDay;

    int newHour = totalMs / 3600000;
    int rem = totalMs % 3600000;
    int newMinute = rem / 60000;
    rem = rem % 60000;
    int newSecond = rem / 1000;
    int newMs = rem % 1000;

    string result;
    if hasMs {
        result = string `@T${zeroPad(newHour)}:${zeroPad(newMinute)}:${zeroPad(newSecond)}.${zeroPad3(newMs)}`;
    } else if hasSec {
        result = string `@T${zeroPad(newHour)}:${zeroPad(newMinute)}:${zeroPad(newSecond)}`;
    } else {
        result = string `@T${zeroPad(newHour)}:${zeroPad(newMinute)}`;
    }
    return [result];
}

isolated function addQuantityToDateOnly(string dateStr, string unit, decimal value) returns FHIRPathInterpreterError|json[] {
    if unit == "hour" || unit == "minute" || unit == "second" || unit == "millisecond" {
        return [];
    }
    int i = <int>value;
    int intVal = value < <decimal>i ? i - 1 : i;

    if dateStr.length() == 4 {
        int|error yearParse = int:fromString(dateStr);
        if yearParse is error { return []; }
        int year = yearParse;
        if unit == "year" {
            return ["@" + (year + intVal).toString()];
        }
        return [];
    }

    if dateStr.length() == 7 {
        int|error yearParse = int:fromString(dateStr.substring(0, 4));
        int|error monthParse = int:fromString(dateStr.substring(5, 7));
        if yearParse is error || monthParse is error { return []; }
        int year = yearParse;
        int month = monthParse;
        if unit == "year" {
            return ["@" + (year + intVal).toString() + "-" + zeroPad(month)];
        }
        if unit == "month" {
            [int, int, int] [y, m, _] = addMonthsToDateParts(year, month, 1, intVal);
            return ["@" + y.toString() + "-" + zeroPad(m)];
        }
        return [];
    }

    if dateStr.length() < 10 {
        return [];
    }
    int|error yearParse = int:fromString(dateStr.substring(0, 4));
    int|error monthParse = int:fromString(dateStr.substring(5, 7));
    int|error dayParse = int:fromString(dateStr.substring(8, 10));
    if yearParse is error || monthParse is error || dayParse is error { return []; }
    int year = yearParse;
    int month = monthParse;
    int day = dayParse;

    int newYear;
    int newMonth;
    int newDay;
    if unit == "day" {
        [newYear, newMonth, newDay] = addDaysToDateParts(year, month, day, intVal);
    } else if unit == "week" {
        [newYear, newMonth, newDay] = addDaysToDateParts(year, month, day, intVal * 7);
    } else if unit == "month" {
        [newYear, newMonth, newDay] = addMonthsToDateParts(year, month, day, intVal);
    } else if unit == "year" {
        [newYear, newMonth, newDay] = addYearsToDateParts(year, month, day, intVal);
    } else {
        return [];
    }
    return ["@" + newYear.toString() + "-" + zeroPad(newMonth) + "-" + zeroPad(newDay)];
}

isolated function addQuantityToDateTimeStr(string s, int tIdx, string unit, decimal value) returns FHIRPathInterpreterError|json[] {
    string datePart = s.substring(0, tIdx);
    string afterT = s.substring(tIdx + 1);
    [string, string] [timeNoTz, tzSuffix] = extractTzFromTime(afterT);

    if datePart.length() < 10 {
        return [];
    }
    int|error yearParse = int:fromString(datePart.substring(0, 4));
    int|error monthParse = int:fromString(datePart.substring(5, 7));
    int|error dayParse = int:fromString(datePart.substring(8, 10));
    if yearParse is error || monthParse is error || dayParse is error { return []; }
    int year = yearParse;
    int month = monthParse;
    int day = dayParse;

    int hour = 0;
    int minute = 0;
    int second = 0;
    int ms = 0;
    boolean hasMs = false;

    if timeNoTz.length() >= 5 {
        int|error hParse = int:fromString(timeNoTz.substring(0, 2));
        int|error minParse = int:fromString(timeNoTz.substring(3, 5));
        if hParse is error || minParse is error { return []; }
        hour = hParse;
        minute = minParse;
    }
    if timeNoTz.length() >= 8 {
        string secAndMs = timeNoTz.substring(6);
        int? dotIdx = secAndMs.indexOf(".");
        if dotIdx is int {
            hasMs = true;
            int|error secParse = int:fromString(secAndMs.substring(0, dotIdx));
            int|error msParse = int:fromString(secAndMs.substring(dotIdx + 1));
            if secParse is error || msParse is error { return []; }
            second = secParse;
            ms = msParse;
        } else {
            int|error secParse = int:fromString(secAndMs);
            if secParse is error { return []; }
            second = secParse;
        }
    }

    int extraDays = 0;

    if unit == "millisecond" || unit == "second" || unit == "minute" || unit == "hour" {
        decimal msDecimal = 0;
        if unit == "millisecond" { msDecimal = value; }
        else if unit == "second" { msDecimal = value * 1000d; }
        else if unit == "minute" { msDecimal = value * 60000d; }
        else if unit == "hour" { msDecimal = value * 3600000d; }

        int totalMs = ms + <int>msDecimal;
        ms = ((totalMs % 1000) + 1000) % 1000;
        int carryS = totalMs / 1000;

        int totalS = second + carryS;
        second = ((totalS % 60) + 60) % 60;
        int carryMin = totalS / 60;

        int totalMin = minute + carryMin;
        minute = ((totalMin % 60) + 60) % 60;
        int carryH = totalMin / 60;

        int totalH = hour + carryH;
        hour = ((totalH % 24) + 24) % 24;
        extraDays = totalH / 24;
    } else {
        int i = <int>value;
        int intVal = value < <decimal>i ? i - 1 : i;
        int newYear;
        int newMonth;
        int newDay;
        if unit == "day" {
            [newYear, newMonth, newDay] = addDaysToDateParts(year, month, day, intVal);
        } else if unit == "week" {
            [newYear, newMonth, newDay] = addDaysToDateParts(year, month, day, intVal * 7);
        } else if unit == "month" {
            [newYear, newMonth, newDay] = addMonthsToDateParts(year, month, day, intVal);
        } else if unit == "year" {
            [newYear, newMonth, newDay] = addYearsToDateParts(year, month, day, intVal);
        } else {
            return [];
        }
        year = newYear;
        month = newMonth;
        day = newDay;
    }

    if extraDays != 0 {
        [year, month, day] = addDaysToDateParts(year, month, day, extraDays);
    }

    string newDatePart = year.toString() + "-" + zeroPad(month) + "-" + zeroPad(day);
    string newTimePart;
    if hasMs {
        newTimePart = zeroPad(hour) + ":" + zeroPad(minute) + ":" + zeroPad(second) + "." + zeroPad3(ms);
    } else {
        newTimePart = zeroPad(hour) + ":" + zeroPad(minute) + ":" + zeroPad(second);
    }
    return ["@" + newDatePart + "T" + newTimePart + tzSuffix];
}

isolated function applyConcatenateOperator(json[] left, json[] right) returns json[] {
    // & always concatenates strings; empty collection treated as ""
    string lStr = left.length() > 0 ? jsonToString(left[0]) : "";
    string rStr = right.length() > 0 ? jsonToString(right[0]) : "";
    return [lStr + rStr];
}

isolated function applyMultiplicativeOperator(json[] left, json[] right, string op) returns json[] {
    if left.length() == 0 || right.length() == 0 {
        return [];
    }
    json l = left[0];
    json r = right[0];

    if (l is int || l is decimal || l is float) && (r is int || r is decimal || r is float) {
        return numericBinaryOp(l, r, op);
    }
    return [];
}

isolated function applyUnionOperator(json[] left, json[] right) returns json[] {
    json[] combined = [...left, ...right];
    return applyDistinctToItems(combined);
}

isolated function applyInOperator(json[] left, json[] right) returns json[] {
    if left.length() == 0 {
        return [];
    }
    if right.length() == 0 {
        return [false];
    }
    // Each element of left must be in right
    // For single-element left: true if left[0] is in right
    if left.length() == 1 {
        foreach json item in right {
            boolean? eq = jsonValuesEqual(left[0], item);
            if eq == true {
                return [true];
            }
        }
        return [false];
    }
    // For multi-element left: check if all elements are in right
    foreach json leftItem in left {
        boolean found = false;
        foreach json rightItem in right {
            boolean? eq = jsonValuesEqual(leftItem, rightItem);
            if eq == true {
                found = true;
                break;
            }
        }
        if !found {
            return [false];
        }
    }
    return [true];
}

// ========================================
// FUNCTION CALL DISPATCHER
// ========================================

isolated function visitFunctionExpr(FunctionExpr expr, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    json[] targetResults;
    Expr? targetExpr = expr.target;
    if targetExpr is Expr {
        targetResults = check evaluate(targetExpr, context, env);
    } else {
        targetResults = wrapInCollection(context);
    }

    string name = expr.name;
    Expr[] params = expr.params;

    // ---- Existence ----
    if name == "empty" { return applyEmptyFunction(targetResults, params); }
    if name == "exists" { return applyExistsFunction(targetResults, params, context, env); }
    if name == "not" { return applyNotFunction(targetResults, params); }
    if name == "hasValue" { return applyHasValueFunction(targetResults, params); }

    // ---- Navigation ----
    if name == "where" { return applyWhereFunction(targetResults, params, context, env); }
    if name == "select" { return applySelectFunction(targetResults, params, context, env); }
    if name == "repeat" { return applyRepeatFunction(targetResults, params, context, env); }
    if name == "children" { return applyChildrenFunction(targetResults, params, context); }
    if name == "descendants" { return applyDescendantsFunction(targetResults, params, context); }

    // ---- Subsetting ----
    if name == "first" { return applyFirstFunction(targetResults, params); }
    if name == "last" { return applyLastFunction(targetResults, params); }
    if name == "tail" {
        Expr? te = expr.target;
        if te is FunctionExpr && (te.name == "children" || te.name == "descendants") {
            return error FHIRPathInterpreterError("tail() cannot be applied to an unordered collection from children() or descendants()",
                token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
        }
        return applyTailFunction(targetResults, params);
    }
    if name == "skip" {
        Expr? te = expr.target;
        if te is FunctionExpr && (te.name == "children" || te.name == "descendants") {
            return error FHIRPathInterpreterError("skip() cannot be applied to an unordered collection from children() or descendants()",
                token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
        }
        return applySkipFunction(targetResults, params, context, env);
    }
    if name == "take" {
        Expr? te = expr.target;
        if te is FunctionExpr && (te.name == "children" || te.name == "descendants") {
            return error FHIRPathInterpreterError("take() cannot be applied to an unordered collection from children() or descendants()",
                token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
        }
        return applyTakeFunction(targetResults, params, context, env);
    }
    if name == "single" { return applySingleFunction(targetResults, params); }

    // ---- Aggregation ----
    if name == "count" { return applyCountFunction(targetResults, params); }
    if name == "distinct" { return applyDistinctFunction(targetResults, params); }
    if name == "isDistinct" { return applyIsDistinctFunction(targetResults, params); }
    if name == "all" { return applyAllFunction(targetResults, params, context, env); }
    if name == "aggregate" { return applyAggregateFunction(targetResults, params, context, env); }
    if name == "sum" { return applySumFunction(targetResults, params); }

    // ---- Combining ----
    if name == "combine" { return applyCombineFunction(targetResults, params, context, env); }
    if name == "union" { return applyUnionFunction(targetResults, params, context, env); }
    if name == "intersect" { return applyIntersectFunction(targetResults, params, context, env); }
    if name == "exclude" { return applyExcludeFunction(targetResults, params, context, env); }
    if name == "subsetOf" { return applySubsetOfFunction(targetResults, params, context, env); }
    if name == "supersetOf" { return applySupersetOfFunction(targetResults, params, context, env); }

    // ---- Ordering ----
    if name == "sort" { return applySortFunction(targetResults, params, context, env); }

    // ---- Math ----
    if name == "abs" { return applyAbsFunction(targetResults, params); }
    if name == "ceiling" { return applyCeilingFunction(targetResults, params); }
    if name == "floor" { return applyFloorFunction(targetResults, params); }
    if name == "truncate" { return applyTruncateFunction(targetResults, params); }
    if name == "round" { return applyRoundFunction(targetResults, params, context, env); }
    if name == "sqrt" { return applySqrtFunction(targetResults, params); }
    if name == "power" { return applyPowerFunction(targetResults, params, context, env); }
    if name == "exp" { return applyExpFunction(targetResults, params); }
    if name == "ln" { return applyLnFunction(targetResults, params); }
    if name == "log" { return applyLogFunction(targetResults, params, context, env); }

    // ---- String ----
    if name == "length" { return applyLengthFunction(targetResults, params); }
    if name == "trim" { return applyTrimFunction(targetResults, params); }
    if name == "toChars" { return applyToCharsFunction(targetResults, params); }
    if name == "split" { return applySplitFunction(targetResults, params, context, env); }
    if name == "join" { return applyJoinFunction(targetResults, params, context, env); }
    if name == "startsWith" { return applyStartsWithFunction(targetResults, params, context, env); }
    if name == "endsWith" { return applyEndsWithFunction(targetResults, params, context, env); }
    if name == "contains" {
        // String contains (single-arg): different from collection 'in/contains'
        if params.length() == 1 {
            return applyContainsStringFunction(targetResults, params, context, env);
        }
        // No-arg contains() is an error
        return fnError("contains", "1 parameter", params.length());
    }
    if name == "indexOf" { return applyIndexOfFunction(targetResults, params, context, env); }
    if name == "substring" { return applySubstringFunction(targetResults, params, context, env); }
    if name == "replace" { return applyReplaceFunction(targetResults, params, context, env); }
    if name == "matches" { return applyMatchesFunction(targetResults, params, context, env); }
    if name == "matchesFull" { return applyMatchesFullFunction(targetResults, params, context, env); }
    if name == "replaceMatches" { return applyReplaceMatchesFunction(targetResults, params, context, env); }
    if name == "encode" { return applyEncodeDecodeFunction("encode", targetResults, params, context, env); }
    if name == "decode" { return applyEncodeDecodeFunction("decode", targetResults, params, context, env); }
    if name == "escape" { return applyEscapeUnescapeFunction("escape", targetResults, params, context, env); }
    if name == "unescape" { return applyEscapeUnescapeFunction("unescape", targetResults, params, context, env); }
    if name == "upper" { return applyUpperFunction(targetResults, params); }
    if name == "lower" { return applyLowerFunction(targetResults, params); }

    // ---- Type conversion ----
    if name == "toInteger" { return applyToIntegerFunction(targetResults, params); }
    if name == "toDecimal" { return applyToDecimalFunction(targetResults, params); }
    if name == "toString" { return applyToStringFunction(targetResults, params); }
    if name == "toBoolean" { return applyToBooleanFunction(targetResults, params); }
    if name == "toDate" { return applyToDateFunction(targetResults, params); }
    if name == "toDateTime" { return applyToDateTimeFunction(targetResults, params); }
    if name == "toTime" { return applyToTimeFunction(targetResults, params); }
    if name == "toQuantity" { return applyToQuantityFunction(targetResults, params); }
    if name == "convertsToInteger" { return applyConvertsToIntegerFunction(targetResults, params); }
    if name == "convertsToDecimal" { return applyConvertsToDecimalFunction(targetResults, params); }
    if name == "convertsToString" { return applyConvertsToStringFunction(targetResults, params); }
    if name == "convertsToBoolean" { return applyConvertsToBooleanFunction(targetResults, params); }
    if name == "convertsToDate" { return applyConvertsToDateFunction(targetResults, params); }
    if name == "convertsToDateTime" { return applyConvertsToDateTimeFunction(targetResults, params); }
    if name == "convertsToTime" { return applyConvertsToTimeFunction(targetResults, params); }
    if name == "convertsToQuantity" { return applyConvertsToQuantityFunction(targetResults, params); }
    if name == "type" { return applyTypeFunction(targetResults, params, targetExpr); }
    if name == "ofType" { return applyOfTypeFunction(targetResults, params, context, env, targetExpr); }
    if name == "is" {
        if params.length() != 1 {
            return fnError("is", "1 parameter", params.length());
        }
        string isTypeName = extractTypeName(params[0]);
        if isTypeName.length() == 0 { return []; }
        if targetResults.length() == 0 { return [false]; }
        return [matchesFhirType(targetResults[0], isTypeName, isSystemSourceExpr(targetExpr), getDeclaredFhirType(targetExpr))];
    }
    if name == "as" { return applyAsTypeFunction(targetResults, params, context, env, targetExpr); }

    // ---- Logic ----
    if name == "iif" { return applyIifFunction(targetResults, params, context, env); }

    // ---- Date/time ----
    if name == "today" { return applyTodayFunction(targetResults, params); }
    if name == "now" { return applyNowFunction(targetResults, params); }
    if name == "lowBoundary" { return applyLowBoundaryFunction(targetResults, params, context, env); }
    if name == "highBoundary" { return applyHighBoundaryFunction(targetResults, params, context, env); }
    if name == "precision" { return applyPrecisionFunction(targetResults, params); }

    // ---- FHIR-specific ----
    if name == "extension" { return applyExtensionFunction(targetResults, params, context, env); }
    if name == "resolve" { return applyResolveFunction(targetResults, params); }
    if name == "conformsTo" { return applyConformsToFunction(targetResults, params, context, env); }
    if name == "memberOf" { return applyMemberOfFunction(targetResults, params, context, env); }
    if name == "hasExtension" { return applyHasExtensionFunction(targetResults, params, context, env); }

    // ---- Utility ----
    if name == "trace" { return applyTraceFunction(targetResults, params, context, env); }
    if name == "defineVariable" { return applyDefineVariableFunction(targetResults, params, context, env); }

    return error FHIRPathInterpreterError(string `Unknown function '${name}'`,
        token = {tokenType: IDENTIFIER, lexeme: name, literal: (), position: 0});
}

// ========================================
// CORE FUNCTION IMPLEMENTATIONS
// ========================================

isolated function applyWhereFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() != 1 {
        return error FHIRPathInterpreterError(
            string `where() requires exactly 1 parameter, got ${params.length()}`,
            token = {tokenType: IDENTIFIER, lexeme: "where", literal: (), position: 0});
    }

    Expr conditionExpr = params[0];
    json[] results = [];
    int i = 0;

    foreach json item in collection {
        FhirPathEnv itemEnv = {index: i, total: env?.total, scope: env.scope.childScope()};
        json[] conditionResult = check evaluate(conditionExpr, item, itemEnv);
        if isTruthy(conditionResult) {
            results.push(item);
        }
        i += 1;
    }

    return results;
}

isolated function applyEmptyFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return error FHIRPathInterpreterError(
            string `empty() requires 0 parameters, got ${params.length()}`,
            token = {tokenType: IDENTIFIER, lexeme: "empty", literal: (), position: 0});
    }
    return [collection.length() == 0];
}

isolated function applyExistsFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() > 1 {
        return error FHIRPathInterpreterError(
            string `exists() requires 0 or 1 parameter, got ${params.length()}`,
            token = {tokenType: IDENTIFIER, lexeme: "exists", literal: (), position: 0});
    }

    if params.length() == 0 {
        return [collection.length() > 0];
    }

    Expr criteriaExpr = params[0];
    int i = 0;
    foreach json item in collection {
        FhirPathEnv itemEnv = {index: i, total: env?.total, scope: env.scope.childScope()};
        json[] criteriaResult = check evaluate(criteriaExpr, item, itemEnv);
        if isTruthy(criteriaResult) {
            return [true];
        }
        i += 1;
    }

    return [false];
}

isolated function applyFirstFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if params.length() != 0 {
        return error FHIRPathInterpreterError(
            string `first() requires 0 parameters, got ${params.length()}`,
            token = {tokenType: IDENTIFIER, lexeme: "first", literal: (), position: 0});
    }
    if collection.length() == 0 {
        return [];
    }
    return [collection[0]];
}

isolated function applySumFunction(json[] collection, Expr[] params) returns FHIRPathInterpreterError|json[] {
    if collection.length() == 0 {
        return [0];
    }
    decimal sum = 0d;
    boolean hasDecimal = false;
    foreach json item in collection {
        if item is int { sum += <decimal>item; }
        else if item is decimal { sum += item; hasDecimal = true; }
        else if item is float { sum += <decimal>item; hasDecimal = true; }
    }
    if hasDecimal {
        return [sum];
    }
    return [<int>sum];
}

isolated function applyDefineVariableFunction(json[] collection, Expr[] params, json context, FhirPathEnv env) returns FHIRPathInterpreterError|json[] {
    if params.length() < 1 || params.length() > 2 {
        return fnError("defineVariable", "1 or 2 parameters", params.length());
    }

    json[] nameResult = check evaluate(params[0], context,
        {scope: env.scope.childScope(), index: env?.index, total: env?.total});
    if nameResult.length() == 0 { return collection; }
    json nameVal = nameResult[0];
    if nameVal !is string || nameVal == "" { return collection; }
    string varName = nameVal;

    if varName == "context" || varName == "$this" || varName == "$index" || varName == "$total" {
        FhirPathToken tok = {tokenType: IDENTIFIER, lexeme: varName, literal: (), position: 0};
        return error FHIRPathInterpreterError("Cannot defineVariable with reserved name '" + varName + "'", token = tok);
    }

    json varValue;
    if params.length() == 2 {
        json valContext = collection.length() == 1 ? collection[0] : (collection.length() == 0 ? () : collection);
        json[] valResult = check evaluate(params[1], valContext,
            {scope: env.scope.childScope(), index: env?.index, total: env?.total});
        varValue = valResult.length() > 0 ? valResult[0] : ();
    } else {
        varValue = context;
    }

    boolean ok = env.scope.define(varName, varValue);
    if !ok {
        FhirPathToken tok = {tokenType: IDENTIFIER, lexeme: varName, literal: (), position: 0};
        return error FHIRPathInterpreterError("Variable '" + varName + "' already defined in this scope", token = tok);
    }

    return collection;
}

// ========================================
// UTILITY FUNCTIONS
// ========================================

isolated function isTruthy(json[] result) returns boolean {
    if result.length() == 0 {
        return false;
    }
    if result.length() == 1 && result[0] is boolean {
        return <boolean>result[0];
    }
    return true;
}

isolated function wrapInCollection(json value) returns json[] {
    if value is () {
        return [];
    }
    if value is json[] {
        return value;
    }
    return [value];
}

// Returns boolean? where () means "unknown" (e.g. incomparable datetime types)
isolated function jsonValuesEqual(json a, json b) returns boolean? {
    if a is () && b is () { return true; }
    if a is () || b is () { return false; }
    if a is boolean && b is boolean { return a == b; }
    if a is string && b is string {
        if a.startsWith("@") || b.startsWith("@") {
            return compareDateTimeEqual(a, b);
        }
        return a == b;
    }
    if (a is int || a is decimal || a is float) && (b is int || b is decimal || b is float) {
        return toFloat(a) == toFloat(b);
    }
    if a is map<json> && b is map<json> {
        return compareQuantityValues(a, b);
    }
    // String vs quantity map (e.g., toQuantity() string result vs quantity literal map)
    if a is string && b is map<json> {
        map<json>? qa = parseQuantityFromString(a);
        if qa is map<json> { return compareQuantityValues(qa, b); }
        return ();
    }
    if a is map<json> && b is string {
        map<json>? qb = parseQuantityFromString(b);
        if qb is map<json> { return compareQuantityValues(a, qb); }
        return ();
    }
    return a.toString() == b.toString();
}

isolated function jsonValuesEquivalent(json a, json b) returns boolean {
    if a is () && b is () { return true; }
    if a is () || b is () { return false; }
    if a is boolean && b is boolean { return a == b; }
    if a is string && b is string {
        if a.startsWith("@") || b.startsWith("@") {
            return compareDateTimeEquivalent(a, b);
        }
        return a.toLowerAscii() == b.toLowerAscii();
    }
    if (a is int || a is decimal || a is float) && (b is int || b is decimal || b is float) {
        if a is decimal || b is decimal {
            decimal ad = a is decimal ? a : <decimal>toFloat(a);
            decimal bd = b is decimal ? b : <decimal>toFloat(b);
            return decimalsEquivalent(ad, bd);
        }
        return toFloat(a) == toFloat(b);
    }
    if a is map<json> && b is map<json> {
        return compareQuantityValuesEquivalent(a, b);
    }
    // String vs quantity map
    if a is string && b is map<json> {
        map<json>? qa = parseQuantityFromString(a);
        if qa is map<json> {
            boolean? eq = compareQuantityValues(qa, b);
            return eq == true;
        }
        return false;
    }
    if a is map<json> && b is string {
        map<json>? qb = parseQuantityFromString(b);
        if qb is map<json> {
            boolean? eq = compareQuantityValues(a, qb);
            return eq == true;
        }
        return false;
    }
    return a.toString().toLowerAscii() == b.toString().toLowerAscii();
}

// ========================================
// DATETIME COMPARISON HELPERS
// ========================================

isolated function fhirDateType(string s) returns string {
    if !s.startsWith("@") { return "other"; }
    string t = s.substring(1);
    if t.startsWith("T") { return "time"; }
    if t.includes("T") { return "datetime"; }
    return "date";
}

isolated function datetimeHasTimezone(string s) returns boolean {
    if !s.startsWith("@") { return false; }
    string t = s.substring(1);
    int? tIdx = t.indexOf("T");
    if tIdx is () { return false; }
    string timePart = t.substring(<int>tIdx + 1);
    if timePart.endsWith("Z") { return true; }
    // Look for +/- after the time digits (position >= 6 handles HH:MM:SS)
    foreach int i in 6 ..< timePart.length() {
        string ch = timePart.substring(i, i + 1);
        if ch == "+" || ch == "-" { return true; }
    }
    return false;
}

// Strips trailing all-zero fractional seconds and returns the normalized string
isolated function normalizeDateTimeNoTz(string s) returns string {
    string result = s;
    int? dotIdx = result.lastIndexOf(".");
    if dotIdx is int {
        string frac = result.substring(<int>dotIdx + 1);
        boolean allZero = frac.length() > 0;
        foreach int i in 0 ..< frac.length() {
            if frac.substring(i, i + 1) != "0" {
                allZero = false;
                break;
            }
        }
        if allZero {
            result = result.substring(0, <int>dotIdx);
        }
    }
    return result;
}

// Converts @YYYY-MM-DDTHH:MM:SS[.sss][Z|+HH:MM|-HH:MM] to total UTC minutes for comparison.
// Returns () if the string has no timezone.
isolated function datetimeToUTCMinutes(string s) returns int? {
    if !s.startsWith("@") { return (); }
    string t = s.substring(1);
    if t.length() < 19 || t.substring(10, 11) != "T" { return (); }
    int|error yr = int:fromString(t.substring(0, 4));
    int|error mo = int:fromString(t.substring(5, 7));
    int|error dy = int:fromString(t.substring(8, 10));
    int|error hr = int:fromString(t.substring(11, 13));
    int|error mn = int:fromString(t.substring(14, 16));
    int|error sc = int:fromString(t.substring(17, 19));
    if yr is error || mo is error || dy is error || hr is error || mn is error || sc is error { return (); }

    string suffix = t.length() > 19 ? t.substring(19) : "";
    // Skip fractional seconds
    if suffix.startsWith(".") {
        int i = 1;
        while i < suffix.length() {
            string ch = suffix.substring(i, i + 1);
            if ch == "+" || ch == "-" || ch == "Z" { break; }
            i += 1;
        }
        suffix = i < suffix.length() ? suffix.substring(i) : "";
    }
    int tzMinutes;
    if suffix == "Z" {
        tzMinutes = 0;
    } else if suffix.length() >= 6 && (suffix.startsWith("+") || suffix.startsWith("-")) {
        int|error tzHr = int:fromString(suffix.substring(1, 3));
        int|error tzMn = int:fromString(suffix.substring(4, 6));
        if tzHr is error || tzMn is error { return (); }
        int offset = <int>tzHr * 60 + <int>tzMn;
        tzMinutes = suffix.startsWith("+") ? offset : -offset;
    } else {
        return (); // No timezone
    }
    // UTC = local - offset; use approximate month-days for ordering only
    int total = <int>yr * 525960 + <int>mo * 44640 + <int>dy * 1440 + <int>hr * 60 + <int>mn - tzMinutes;
    return total;
}

// FHIRPath equality for date/time strings (returns () for unknown)
isolated function compareDateTimeEqual(string a, string b) returns boolean? {
    string kindA = fhirDateType(a);
    string kindB = fhirDateType(b);
    if kindA != kindB { return (); } // Different types → unknown

    if kindA == "date" {
        return a == b;
    }
    if kindA == "datetime" {
        boolean aTz = datetimeHasTimezone(a);
        boolean bTz = datetimeHasTimezone(b);
        if aTz != bTz { return (); } // One has TZ, other doesn't → unknown
        if aTz && bTz {
            int? aMin = datetimeToUTCMinutes(a);
            int? bMin = datetimeToUTCMinutes(b);
            if aMin is () || bMin is () { return (); }
            return aMin == bMin;
        }
        return normalizeDateTimeNoTz(a) == normalizeDateTimeNoTz(b);
    }
    if kindA == "time" {
        return normalizeDateTimeNoTz(a) == normalizeDateTimeNoTz(b);
    }
    return a == b;
}

// FHIRPath equivalence for date/time strings (returns false for different types, not unknown)
isolated function compareDateTimeEquivalent(string a, string b) returns boolean {
    string kindA = fhirDateType(a);
    string kindB = fhirDateType(b);
    if kindA != kindB { return false; } // Different types → not equivalent

    if kindA == "date" {
        return a == b;
    }
    if kindA == "datetime" || kindA == "time" {
        // Equivalence ignores timezones — normalize by stripping TZ and sub-second zeros
        return normalizeDateTimeNoTz(stripTimezone(a)) == normalizeDateTimeNoTz(stripTimezone(b));
    }
    return a == b;
}

// Strips timezone suffix from a datetime string for equivalence comparison
isolated function stripTimezone(string s) returns string {
    if !s.startsWith("@") { return s; }
    string t = s.substring(1);
    int? tIdx = t.indexOf("T");
    if tIdx is () { return s; }
    string timePart = t.substring(<int>tIdx + 1);
    // Find where timezone starts (Z or +/-)
    string timeBase = timePart;
    foreach int i in 6 ..< timePart.length() {
        string ch = timePart.substring(i, i + 1);
        if ch == "+" || ch == "-" || ch == "Z" {
            timeBase = timePart.substring(0, i);
            break;
        }
    }
    return "@" + t.substring(0, <int>tIdx + 1) + timeBase;
}

// ========================================
// DECIMAL EQUIVALENCE HELPER
// ========================================

isolated function countDecimalPlacesStr(string s) returns int {
    int? dotIdx = s.indexOf(".");
    if dotIdx is () { return 0; }
    return s.length() - <int>dotIdx - 1;
}

isolated function decimalsEquivalent(decimal a, decimal b) returns boolean {
    int precA = countDecimalPlacesStr(a.toString());
    int precB = countDecimalPlacesStr(b.toString());
    int prec = precA < precB ? precA : precB;
    if prec == 0 {
        return a == b;
    }
    decimal factor = 1.0d;
    foreach int i in 0 ..< prec {
        factor *= 10.0d;
    }
    // Round to `prec` decimal places using truncation-towards-zero after +0.5
    decimal roundedA = <decimal>(<int>(a * factor + 0.5d)) / factor;
    decimal roundedB = <decimal>(<int>(b * factor + 0.5d)) / factor;
    return roundedA == roundedB;
}

// ========================================
// QUANTITY COMPARISON HELPERS
// ========================================

// Compares two JSON quantity maps for equality (= operator)
// FHIRPath quantity literal: {"value": N, "unit": "U"}
// FHIR resource quantity:    {"value": N, "unit": "display", "code": "U", ...}
isolated function compareQuantityValues(map<json> a, map<json> b) returns boolean? {
    json aVal = a["value"];
    json bVal = b["value"];
    if aVal is () || bVal is () { return (); }
    if !((aVal is int || aVal is decimal || aVal is float) && (bVal is int || bVal is decimal || bVal is float)) {
        return ();
    }
    if toFloat(aVal) != toFloat(bVal) { return false; }
    // Unit comparison: check "unit" and "code" fields cross-ways
    string? aUnit = a["unit"] is string ? <string>a["unit"] : ();
    string? aCode = a["code"] is string ? <string>a["code"] : ();
    string? bUnit = b["unit"] is string ? <string>b["unit"] : ();
    string? bCode = b["code"] is string ? <string>b["code"] : ();
    if unitsMatch(aUnit, aCode, bUnit, bCode) { return true; }
    // Cross-system normalization (UCUM↔calendar equivalences like d↔day, wk↔week)
    string effectiveA = (aUnit ?: aCode) ?: "";
    string effectiveB = (bUnit ?: bCode) ?: "";
    string? normA = quantityUnitCanonical(effectiveA);
    string? normB = quantityUnitCanonical(effectiveB);
    if normA is () || normB is () { return (); }
    return normA == normB;
}

isolated function quantityUnitCanonical(string unit) returns string? {
    string lower = unit.toLowerAscii();
    if lower == "d" || lower == "day" || lower == "days" { return "d"; }
    if lower == "wk" || lower == "week" || lower == "weeks" { return "wk"; }
    if lower == "h" || lower == "hour" || lower == "hours" { return "h"; }
    if lower == "min" || lower == "minute" || lower == "minutes" { return "min"; }
    if lower == "s" || lower == "second" || lower == "seconds" { return "s"; }
    if lower == "ms" || lower == "millisecond" || lower == "milliseconds" { return "ms"; }
    if lower == "mo" || lower == "month" || lower == "months" { return (); }
    if lower == "a" || lower == "year" || lower == "years" { return (); }
    return lower;
}

isolated function compareQuantityValuesEquivalent(map<json> a, map<json> b) returns boolean {
    boolean? eq = compareQuantityValues(a, b);
    if eq is () { return false; }
    return eq;
}

isolated function unitsMatch(string? aUnit, string? aCode, string? bUnit, string? bCode) returns boolean {
    // Try all combinations: compare case-insensitively
    string?[] aOptions = [aUnit, aCode];
    string?[] bOptions = [bUnit, bCode];
    foreach string? ao in aOptions {
        if ao is () { continue; }
        foreach string? bo in bOptions {
            if bo is () { continue; }
            if ao.toLowerAscii() == bo.toLowerAscii() { return true; }
        }
    }
    return false;
}

isolated function isEqual(anydata a, anydata b) returns boolean {
    if a is () && b is () { return true; }
    if a is () || b is () { return false; }
    return a == b;
}

isolated function jsonToString(json val) returns string {
    if val is string { return val; }
    if val is () { return ""; }
    return val.toString();
}

isolated function numericBinaryOp(json l, json r, string op) returns json[] {
    boolean useDecimal = (l is decimal || r is decimal);
    boolean useInt = (l is int && r is int) && (op == "div" || op == "mod");

    if useInt || (!useDecimal && op == "div") {
        int li = l is int ? l : <int>toFloat(l);
        int ri = r is int ? r : <int>toFloat(r);
        if op == "div" {
            if ri == 0 { return []; }
            return [li / ri];
        }
        if op == "mod" {
            if ri == 0 { return []; }
            return [li % ri];
        }
    }

    if l is int && r is int {
        if op == "+" { return [l + r]; }
        if op == "-" { return [l - r]; }
        if op == "*" { return [l * r]; }
        if op == "/" {
            if r == 0 { return []; }
            decimal result = <decimal>l / <decimal>r;
            return [result];
        }
        if op == "div" { if r == 0 { return []; } return [l / r]; }
        if op == "mod" { if r == 0 { return []; } return [l % r]; }
    }

    decimal ld = l is decimal ? l : <decimal>toFloat(l);
    decimal rd = r is decimal ? r : <decimal>toFloat(r);

    if op == "+" { return [ld + rd]; }
    if op == "-" { return [ld - rd]; }
    if op == "*" { return [ld * rd]; }
    if op == "/" {
        if rd == 0d { return []; }
        return [ld / rd];
    }
    if op == "div" {
        if rd == 0d { return []; }
        return [<int>(ld / rd)];
    }
    if op == "mod" {
        if rd == 0d { return []; }
        return [ld % rd];
    }

    return [];
}

// ========================================
// SET INTERPRETER (setValuesToFhirPath)
// ========================================

# Interprets a FHIRPath expression to SET a value at the specified path.
#
# + expression - The parsed FHIRPath expression (AST)
# + context - The JSON context object (must be a map<json>)
# + newValue - The new value to set at the path
# + shouldRemove - Whether to remove the value instead of setting it
# + modificationFunction - Optional function to transform the existing value
# + return - The modified JSON context, or a FhirpathInterpreterError if evaluation fails
isolated function interpretSet(Expr expression, json context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FHIRPathInterpreterError|json {
    if context !is map<json> {
        return error FHIRPathInterpreterError("Context must be a JSON object for set operations",
            token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
    }

    map<json> contextClone = context.clone();
    FHIRPathInterpreterError|map<json> result = evaluateSet(expression, contextClone, newValue, shouldRemove, modificationFunction);
    return result;
}

isolated function evaluateSet(Expr expr, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FHIRPathInterpreterError|map<json> {
    match expr.kind {
        "Identifier" => {
            return visitIdentifierExprSet(<IdentifierExpr>expr, context, newValue, shouldRemove, modificationFunction);
        }
        "MemberAccess" => {
            return visitMemberAccessExprSet(<MemberAccessExpr>expr, context, newValue, shouldRemove, modificationFunction);
        }
        "Indexer" => {
            return visitIndexerExprSet(<IndexerExpr>expr, context, newValue, shouldRemove, modificationFunction);
        }
        _ => {
            return error FHIRPathInterpreterError("Unsupported expression type for set operation",
                token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
        }
    }
}

isolated function visitIdentifierExprSet(IdentifierExpr expr, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FHIRPathInterpreterError|map<json> {
    string fieldName = expr.name;

    json|error resourceTypeValue = context.resourceType;
    if resourceTypeValue !is error && resourceTypeValue is string {
        if fieldName == resourceTypeValue {
            return context;
        }
    }

    if shouldRemove {
        if context.hasKey(fieldName) {
            _ = context.remove(fieldName);
        }
        return context;
    }

    if !context.hasKey(fieldName) {
        return error FHIRPathInterpreterError(string `Path '${fieldName}' does not exist in the resource`,
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }

    json|error modifiedValue = getModifiedValueInternal(context[fieldName], modificationFunction, newValue);
    if modifiedValue is error {
        return error FHIRPathInterpreterError(modifiedValue.message(),
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }
    context[fieldName] = modifiedValue;

    return context;
}

isolated function visitMemberAccessExprSet(MemberAccessExpr expr, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FHIRPathInterpreterError|map<json> {
    Expr targetExpr = expr.target;
    string memberName = expr.member;

    json[] targetResults = check evaluate(targetExpr, context, {scope: new VariableScope()});

    if targetResults.length() > 0 {
        foreach json targetItem in targetResults {
            if targetItem is map<json> {
                if shouldRemove {
                    if targetItem.hasKey(memberName) {
                        _ = targetItem.remove(memberName);
                    }
                } else {
                    if !targetItem.hasKey(memberName) {
                        return error FHIRPathInterpreterError(string `Path '${memberName}' does not exist in the resource`,
                            token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
                    }
                    json currentValue = targetItem[memberName];
                    json|error modifiedValue = getModifiedValueInternal(currentValue, modificationFunction, newValue);
                    if modifiedValue is error {
                        return error FHIRPathInterpreterError(modifiedValue.message(),
                            token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
                    }
                    targetItem[memberName] = modifiedValue;
                }
            } else if targetItem is json[] {
                foreach json element in targetItem {
                    if element is map<json> {
                        if shouldRemove {
                            if element.hasKey(memberName) {
                                _ = element.remove(memberName);
                            }
                        } else {
                            if !element.hasKey(memberName) {
                                return error FHIRPathInterpreterError(string `Path '${memberName}' does not exist in the resource`,
                                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
                            }
                            json currentValue = element[memberName];
                            json|error modifiedValue = getModifiedValueInternal(currentValue, modificationFunction, newValue);
                            if modifiedValue is error {
                                return error FHIRPathInterpreterError(modifiedValue.message(),
                                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
                            }
                            element[memberName] = modifiedValue;
                        }
                    }
                }
            }
        }
        return context;
    }

    if shouldRemove {
        return context;
    }
    return error FHIRPathInterpreterError(string `Path '${memberName}' does not exist in the resource`,
        token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
}

isolated function visitIndexerExprSet(IndexerExpr expr, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FHIRPathInterpreterError|map<json> {
    json[] indexResults = check evaluate(expr.index, context, {scope: new VariableScope()});
    if indexResults.length() != 1 {
        return error FHIRPathInterpreterError("Index must be a single value",
            token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
    }

    int index;
    json indexValue = indexResults[0];
    if indexValue is int {
        index = indexValue;
    } else if indexValue is decimal {
        index = <int>indexValue;
    } else if indexValue is float {
        if indexValue % 1.0 != 0.0 {
            return error FHIRPathInterpreterError("Index must be a whole number",
                token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
        }
        index = <int>indexValue;
    } else {
        return error FHIRPathInterpreterError("Index must be numeric",
            token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
    }

    Expr targetExpr = expr.target;

    if targetExpr is IdentifierExpr {
        return setValueAtIndexedIdentifier(targetExpr, index, context, newValue, shouldRemove, modificationFunction);
    } else if targetExpr is MemberAccessExpr {
        return setValueAtIndexedMemberAccess(targetExpr, index, context, newValue, shouldRemove, modificationFunction);
    } else if targetExpr is IndexerExpr {
        return setValueAtNestedIndexer(targetExpr, index, context, newValue, shouldRemove, modificationFunction);
    }

    return context;
}

isolated function setValueAtIndexedIdentifier(IdentifierExpr expr, int index, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FHIRPathInterpreterError|map<json> {
    string fieldName = expr.name;

    if !context.hasKey(fieldName) {
        if shouldRemove { return context; }
        return error FHIRPathInterpreterError(string `Path '${fieldName}' does not exist in the resource`,
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }

    json fieldValue = context[fieldName];
    if fieldValue !is json[] {
        if shouldRemove { return context; }
        return error FHIRPathInterpreterError(string `Path '${fieldName}' is not an array`,
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }

    json[] arr = <json[]>fieldValue;

    if shouldRemove {
        if index >= 0 && index < arr.length() {
            json[] newArr = [];
            foreach int i in 0 ..< arr.length() {
                if i != index { newArr.push(arr[i]); }
            }
            context[fieldName] = newArr;
        }
        return context;
    }

    if index >= arr.length() {
        return error FHIRPathInterpreterError(string `Index ${index} is out of bounds for array '${fieldName}' with length ${arr.length()}`,
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }

    json|error modifiedValue = getModifiedValueInternal(arr[index], modificationFunction, newValue);
    if modifiedValue is error {
        return error FHIRPathInterpreterError(modifiedValue.message(),
            token = {tokenType: IDENTIFIER, lexeme: fieldName, literal: (), position: 0});
    }
    arr[index] = modifiedValue;

    return context;
}

isolated function setValueAtIndexedMemberAccess(MemberAccessExpr expr, int index, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FHIRPathInterpreterError|map<json> {
    json[] targetResults = check evaluate(expr.target, context, {scope: new VariableScope()});
    string memberName = expr.member;

    if targetResults.length() == 0 {
        if shouldRemove { return context; }
        return error FHIRPathInterpreterError(string `Path to '${memberName}' does not exist in the resource`,
            token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
    }

    foreach json targetItem in targetResults {
        if targetItem is map<json> {
            if !targetItem.hasKey(memberName) {
                if shouldRemove { continue; }
                return error FHIRPathInterpreterError(string `Path '${memberName}' does not exist`,
                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
            }

            json fieldValue = targetItem[memberName];
            if fieldValue !is json[] {
                if shouldRemove { continue; }
                return error FHIRPathInterpreterError(string `Path '${memberName}' is not an array`,
                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
            }

            json[] arr = <json[]>fieldValue;

            if shouldRemove {
                if index >= 0 && index < arr.length() {
                    json[] newArr = [];
                    foreach int i in 0 ..< arr.length() {
                        if i != index { newArr.push(arr[i]); }
                    }
                    targetItem[memberName] = newArr;
                }
                continue;
            }

            if index >= arr.length() {
                return error FHIRPathInterpreterError(string `Index ${index} is out of bounds for array '${memberName}' with length ${arr.length()}`,
                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
            }

            json|error modifiedValue = getModifiedValueInternal(arr[index], modificationFunction, newValue);
            if modifiedValue is error {
                return error FHIRPathInterpreterError(modifiedValue.message(),
                    token = {tokenType: IDENTIFIER, lexeme: memberName, literal: (), position: 0});
            }
            arr[index] = modifiedValue;
        }
    }

    return context;
}

isolated function setValueAtNestedIndexer(IndexerExpr expr, int outerIndex, map<json> context, json newValue, boolean shouldRemove, ModificationFunction? modificationFunction) returns FHIRPathInterpreterError|map<json> {
    json[] innerResults = check evaluate(expr, context, {scope: new VariableScope()});

    if innerResults.length() == 0 {
        if shouldRemove { return context; }
        return error FHIRPathInterpreterError("Path does not exist in the resource",
            token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
    }

    foreach json innerItem in innerResults {
        if innerItem is json[] {
            json[] arr = <json[]>innerItem;

            if shouldRemove {
                if outerIndex >= 0 && outerIndex < arr.length() {
                    json[] newArr = [];
                    foreach int i in 0 ..< arr.length() {
                        if i != outerIndex { newArr.push(arr[i]); }
                    }
                    while arr.length() > 0 {
                        _ = arr.pop();
                    }
                    foreach json item in newArr {
                        arr.push(item);
                    }
                }
                continue;
            }

            if outerIndex < 0 || outerIndex >= arr.length() {
                return error FHIRPathInterpreterError(string `Index ${outerIndex} is out of bounds for array with length ${arr.length()}`,
                    token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
            }

            json|error modifiedValue = getModifiedValueInternal(arr[outerIndex], modificationFunction, newValue);
            if modifiedValue is error {
                return error FHIRPathInterpreterError(modifiedValue.message(),
                    token = {tokenType: EOF, lexeme: "", literal: (), position: 0});
            }
            arr[outerIndex] = modifiedValue;
        }
    }

    return context;
}

# Function to modify the value at the path
public type ModificationFunction isolated function (json param) returns json|error;

isolated function getModifiedValueInternal(json currentValue, ModificationFunction? modificationFunction, json? newValue) returns json|error {
    if currentValue !is () && modificationFunction !is () {
        return modificationFunction(currentValue);
    }
    if newValue !is () {
        return newValue;
    }
    return currentValue;
}

// Shared helper — used by both interpreter and function files
isolated function applyIndex(json item, int index) returns FHIRPathInterpreterError|json[] {
    if item is () { return []; }
    if item !is json[] { return []; }
    json[] arr = <json[]>item;
    if index < 0 || index >= arr.length() { return []; }
    return wrapInCollection(arr[index]);
}
