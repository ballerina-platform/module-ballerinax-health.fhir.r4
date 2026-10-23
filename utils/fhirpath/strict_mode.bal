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
// STRICT MODE (COMPILE-TIME PATH CHECKS)
// ========================================
// An optional check performed before evaluation (see "Type safety and strict evaluation" in the FHIRPath
// specification). The possible types of each sub-expression are inferred from the FHIR R4 model, starting from
// the input resource's type, and navigation the model rules out is reported as an error:
//   - an element that is not defined on any of the possible types (e.g. Patient.name.given1)
//   - a type name that does not match the context (e.g. Encounter.name on a Patient)
//   - a choice element accessed by its expanded name (e.g. Observation.valueQuantity instead of value)
//   - navigation into System values (e.g. 'abc'.length)
//   - toString() on a value whose possible types are all complex (e.g. a Period)
//   - an iif() criterion that cannot be a Boolean
// Type tests narrow the possible types of $this for the operand they guard: in `A implies B`, `A and B` and
// `iif(A, B, ..)` B is checked assuming A is true; in `A or B` and `iif(A, .., B)` B is checked assuming A is false,
// where A is built from `$this is T`, `$this.is(T)`, `.not()`, `and` and `or`. An operand whose narrowed type set is
// empty is unreachable and is not checked.
// Where the type cannot be determined (children(), resolve(), abstract Resource elements, functions not modelled
// below, resources outside the FHIR model) checking stops for that branch, as the specification allows.

// A static type is a list of possible types (FHIR model keys or "System.<name>"); () means unknown
type StaticType string[]?;

// Functions whose result has the type of their input
final readonly & string[] TYPE_PRESERVING_FUNCTIONS = ["where", "first", "last", "tail", "skip", "take", "single",
    "distinct", "intersect", "exclude", "sort", "trace", "defineVariable", "combine", "union"];

// Functions whose parameters are evaluated with $this set to each input item
final readonly & string[] SCOPED_FUNCTIONS = ["where", "select", "exists", "all", "repeat", "repeatAll", "sort", "iif",
    "aggregate", "coalesce", "trace"];

# Checks an expression against the FHIR model for strict mode.
#
# + expr - The parsed expression
# + fhirResource - The input resource, whose type is the root context type
# + focus - The possible types of the focus ($this) when it is not the input resource
# + return - An error describing the first invalid navigation, or ()
isolated function checkStrictPaths(Expr expr, json fhirResource, StaticType|false focus = false) returns FHIRPathInterpreterError? {
    StaticType root = staticRootType(fhirResource);
    _ = check inferStaticType(expr, focus is false ? root : focus, root);
}

isolated function staticRootType(json fhirResource) returns StaticType {
    [string, string] [namespace, rootType] = typeOfItem(rootItem(fhirResource));
    return namespace == FHIR_NS && FHIR_ELEMENT_TYPES.hasKey(rootType) ? [rootType] : ();
}

// Infers the possible types of `expr` evaluated with focus `context`; `root` is the input resource type
isolated function inferStaticType(Expr expr, StaticType context, StaticType root) returns StaticType|FHIRPathInterpreterError {
    if expr is LiteralExpr {
        string? systemType = expr.systemType;
        anydata value = expr.value;
        if systemType is string {
            return ["System." + systemType];
        }
        return (value is ()) ? [] : ["System." + typeOfItem(<json>value)[1]];
    }
    if expr is QuantityLiteralExpr {
        return ["System.Quantity"];
    }
    if expr is IdentifierExpr {
        return staticIdentifier(expr.name, context);
    }
    if expr is MemberAccessExpr {
        StaticType target = check inferStaticType(expr.target, context, root);
        return staticMember(target, expr.member);
    }
    if expr is IndexerExpr {
        _ = check inferStaticType(expr.index, context, root);
        return inferStaticType(expr.target, context, root);
    }
    if expr is ExternalConstantExpr {
        return expr.name == "context" || expr.name == "resource" || expr.name == "rootResource" ? root : ();
    }
    if expr is UnaryExpr {
        _ = check inferStaticType(expr.operand, context, root);
        return ();
    }
    if expr is SortArgumentExpr {
        return inferStaticType(expr.key, context, root);
    }
    if expr is InstanceSelectorExpr {
        foreach [string, Expr] [_, valueExpr] in expr.elements {
            _ = check inferStaticType(valueExpr, context, root);
        }
        string typeName = expr.typeName.startsWith("FHIR.") ? expr.typeName.substring(5) : expr.typeName;
        return FHIR_ELEMENT_TYPES.hasKey(typeName) ? [typeName] : ();
    }
    if expr is BinaryExpr {
        TokenType op = expr.operator.tokenType;
        StaticType left = check inferStaticType(expr.left, context, root);
        if op == IS || op == AS {
            return op == AS ? staticTypeFromSpecifier(extractTypeName(expr.right)) : ["System.Boolean"];
        }
        if op == IMPLIES || op == AND || op == OR {
            // The right operand is only evaluated when the left one is true (implies, and) or false (or)
            StaticType guarded = narrowStaticType(expr.left, op != OR, context);
            if guarded is string[] && guarded.length() == 0 {
                return ["System.Boolean"];
            }
            _ = check inferStaticType(expr.right, guarded, root);
            return ["System.Boolean"];
        }
        StaticType right = check inferStaticType(expr.right, context, root);
        if op == PIPE {
            return (left is string[] && right is string[]) ? [...left, ...right] : ();
        }
        return ();
    }
    if expr is FunctionExpr {
        Expr? targetExpr = expr.target;
        StaticType input = targetExpr is Expr ? check inferStaticType(targetExpr, context, root) : context;
        if expr.name == "iif" && expr.params.length() >= 2 {
            return staticIif(expr.params, input, root);
        }
        if expr.name == "toString" && input is string[] && input.length() > 0 && input.every(isComplexStaticType) {
            return strictError(string `toString() requires a primitive value, not ${describeTypes(input)}`);
        }
        boolean scoped = SCOPED_FUNCTIONS.indexOf(expr.name) !is ();
        StaticType[] paramTypes = [];
        foreach Expr param in expr.params {
            if expr.name == "ofType" || expr.name == "as" || expr.name == "is" {
                paramTypes.push(());
                continue;
            }
            paramTypes.push(check inferStaticType(param, scoped ? input : context, root));
        }
        if TYPE_PRESERVING_FUNCTIONS.indexOf(expr.name) !is () {
            return input;
        }
        if (expr.name == "select" || expr.name == "repeat" || expr.name == "repeatAll") && paramTypes.length() == 1 {
            return paramTypes[0];
        }
        if (expr.name == "ofType" || expr.name == "as") && expr.params.length() == 1 {
            return staticTypeFromSpecifier(extractTypeName(expr.params[0]));
        }
        if expr.name == "extension" {
            return ["Extension"];
        }
        return ();
    }
    return ();
}

// iif(criterion, true-result [, otherwise-result]): the criterion must be able to be a Boolean, and each result is
// checked with $this narrowed by the criterion
isolated function staticIif(Expr[] params, StaticType input, StaticType root) returns StaticType|FHIRPathInterpreterError {
    StaticType criterion = check inferStaticType(params[0], input, root);
    if criterion is string[] && criterion.length() > 0
            && criterion.every(t => t != "System.Boolean" && t != "boolean") {
        return strictError(string `iif() criterion must be a Boolean, not ${describeTypes(criterion)}`);
    }
    StaticType[] results = [];
    foreach int i in 1 ..< params.length() {
        StaticType narrowed = narrowStaticType(params[0], i == 1, input);
        if narrowed is string[] && narrowed.length() == 0 {
            continue;
        }
        results.push(check inferStaticType(params[i], narrowed, root));
    }
    return ();
}

// The possible types of $this when `guard` evaluates to `outcome`, for guards built from `$this is T`,
// `$this.is(T)`, `.not()`, `and` and `or`; other guards do not narrow
isolated function narrowStaticType(Expr guard, boolean outcome, StaticType context) returns StaticType {
    if context is () {
        return ();
    }
    if guard is BinaryExpr {
        TokenType op = guard.operator.tokenType;
        if op == IS && isFocusExpr(guard.left) {
            return filterByType(context, extractTypeName(guard.right), outcome);
        }
        if (op == AND && outcome) || (op == OR && !outcome) {
            // Both operands have the outcome
            return narrowStaticType(guard.right, outcome, narrowStaticType(guard.left, outcome, context));
        }
        if op == AND || op == OR {
            // Either operand has the outcome
            return unionStaticTypes(narrowStaticType(guard.left, outcome, context), narrowStaticType(guard.right, outcome, context));
        }
        return context;
    }
    if guard is FunctionExpr {
        Expr? target = guard.target;
        if guard.name == "is" && guard.params.length() == 1 && (target is () || isFocusExpr(target)) {
            return filterByType(context, extractTypeName(guard.params[0]), outcome);
        }
        if guard.name == "not" && guard.params.length() == 0 && target is Expr {
            return narrowStaticType(target, !outcome, context);
        }
    }
    return context;
}

isolated function isFocusExpr(Expr expr) returns boolean {
    return expr is IdentifierExpr && expr.name == "$this";
}

// The types that are (`keep` true) or are not (`keep` false) of the given type
isolated function filterByType(string[] types, string specifier, boolean keep) returns string[] {
    [string, string][] candidates = resolveTypeSpecifier(specifier);
    return from string t in types
        where candidates.some(c => staticTypeIsA(t, c)) == keep
        select t;
}

isolated function staticTypeIsA(string staticType, [string, string] target) returns boolean {
    [string, string] [namespace, name] = target;
    if staticType.startsWith("System.") {
        return namespace == SYSTEM_NS && (staticType.substring(7) == name || name == "Any");
    }
    // Backbone element paths are of type BackboneElement
    string typeName = staticType.includes(".") ? "BackboneElement" : staticType;
    return namespace == FHIR_NS && (typeName == name || fhirTypeDerivesFrom(typeName, name));
}

isolated function unionStaticTypes(StaticType a, StaticType b) returns StaticType {
    if a is () || b is () {
        return ();
    }
    string[] result = [...a];
    foreach string t in b {
        if result.indexOf(t) is () {
            result.push(t);
        }
    }
    return result;
}

// Complex FHIR types (and backbone elements) have no string representation; Quantity does
isolated function isComplexStaticType(string staticType) returns boolean {
    if staticType.startsWith("System.") {
        return false;
    }
    string typeName = staticType.includes(".") ? "BackboneElement" : staticType;
    return !isFhirPrimitiveType(typeName) && typeName != "Quantity" && !fhirTypeDerivesFrom(typeName, "Quantity");
}

// An identifier is a type name selecting the context (e.g. Patient), $this, or an element of the context
isolated function staticIdentifier(string name, StaticType context) returns StaticType|FHIRPathInterpreterError {
    if name == "$this" {
        return context;
    }
    if name.startsWith("$") || context is () {
        return ();
    }
    if !isFhirPrimitiveType(name) && FHIR_TYPE_BASE.hasKey(name) {
        string[] matching = from string t in context where t == name || fhirTypeDerivesFrom(t, name) select t;
        if matching.length() > 0 {
            return matching;
        }
        if !FHIR_ELEMENT_TYPES.hasKey(name) || fhirTypeDerivesFrom(name, "Resource") {
            return strictError(string `'${name}' does not match the context type ${describeTypes(context)}`);
        }
    }
    return staticMember(context, name);
}

// The possible types of element `name` of the given types; an error when no type defines it
isolated function staticMember(StaticType target, string name) returns StaticType|FHIRPathInterpreterError {
    if target is () {
        return ();
    }
    if target.length() == 0 {
        return [];
    }
    string[] result = [];
    boolean found = false;
    foreach string t in target {
        if t.startsWith("System.") {
            continue;
        }
        if !FHIR_ELEMENT_TYPES.hasKey(t) || t == "Resource" || t == "DomainResource" {
            // Abstract or unmodelled types: the actual type is only known at run time
            return ();
        }
        string? elementType = modelElementType(t, name);
        if elementType is () && name == "resourceType" && (t == "Resource" || fhirTypeDerivesFrom(t, "Resource")) {
            // Not a model element, but the JSON property every resource carries
            found = true;
            result.push("System.String");
            continue;
        }
        if elementType is () {
            string? choiceBase = expandedChoiceBase(t, name);
            if choiceBase is string {
                return strictError(string `Choice element '${choiceBase}' of ${t} must be accessed as '${choiceBase}', not '${name}'`);
            }
            continue;
        }
        found = true;
        if elementType.includes("|") {
            foreach string choice in re `\|`.split(elementType) {
                result.push(choice);
            }
        } else {
            [string, string?] [typeName, childKey] = resolveChildType(t, name, name);
            result.push(childKey ?: typeName);
        }
    }
    if !found {
        return strictError(string `'${name}' is not an element of ${describeTypes(target)}`);
    }
    return result;
}

// The choice element (e.g. "value") that `name` (e.g. "valueQuantity") expands, if any
isolated function expandedChoiceBase(string modelKey, string name) returns string? {
    foreach string baseName in (FHIR_ELEMENT_TYPES[modelKey] ?: {}).keys() {
        string types = modelElementType(modelKey, baseName) ?: "";
        if types.includes("|") && name.length() > baseName.length() && name.startsWith(baseName) {
            string suffix = name.substring(baseName.length());
            if choiceTypeFromSuffix(suffix, types) != suffix || types.includes(suffix) {
                return baseName;
            }
        }
    }
    return ();
}

isolated function staticTypeFromSpecifier(string specifier) returns StaticType {
    [string, string][] candidates = resolveTypeSpecifier(specifier);
    if candidates.length() == 0 {
        return ();
    }
    return from [string, string] [namespace, name] in candidates
        select namespace == SYSTEM_NS ? "System." + name : name;
}

isolated function describeTypes(string[] types) returns string {
    return types.length() == 1 ? types[0] : "(" + string:'join(" | ", ...types) + ")";
}

isolated function strictError(string message) returns FHIRPathInterpreterError {
    return error FHIRPathInterpreterError("Strict mode: " + message,
        token = {tokenType: IDENTIFIER, lexeme: "", literal: (), position: 0});
}
