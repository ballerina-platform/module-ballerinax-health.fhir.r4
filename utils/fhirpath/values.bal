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
// TYPED VALUES
// ========================================
// Collections hold FhirPathItem values. A plain JSON primitive is a System value typed by its
// shape (boolean → Boolean, int → Integer, decimal/float → Decimal, string → String). Values whose
// type cannot be inferred from the JSON alone are wrapped in a TypedValue:
//   - System.Long, System.Date, System.DateTime, System.Time and System.Quantity values
//   - every value navigated from a FHIR resource (typed from the FHIR model in model_info.bal)
//
// Payload conventions:
//   - System Date/DateTime/Time payloads keep the literal '@' prefix: "@2014-01-25", "@2014-01-25T10:30",
//     "@T10:30". FHIR date/time payloads are the raw resource strings ("2014-01-25").
//   - System Quantity payloads are {"value": <decimal>, "unit": <string>} maps.

const SYSTEM_NS = "System";
const FHIR_NS = "FHIR";

final readonly & string[] SYSTEM_TYPE_NAMES = ["Any", "Boolean", "String", "Integer", "Long", "Decimal",
    "Date", "DateTime", "Time", "Quantity"];

# A collection item with an explicit FHIRPath type.
class TypedValue {
    # The JSON payload (a primitive, or the object for complex FHIR values)
    final json value;
    # Type namespace: "System" or "FHIR"
    final string namespace;
    # Type name within the namespace (e.g. "Long", "date", "HumanName", "BackboneElement")
    final string name;
    # Key into FHIR_ELEMENT_TYPES used to type child elements (a type name or a backbone element path)
    final string? modelKey;
    # The `_name` sibling of a FHIR primitive, holding its id and extensions
    final json primitiveElement;

    isolated function init(json value, string namespace, string name, string? modelKey = (), json primitiveElement = ()) {
        self.value = value;
        self.namespace = namespace;
        self.name = name;
        self.modelKey = modelKey;
        self.primitiveElement = primitiveElement;
    }
}

# An item of a FHIRPath collection.
type FhirPathItem json|TypedValue;

# Returns the JSON payload of an item.
#
# + item - The collection item
# + return - The raw JSON value
isolated function valueOf(FhirPathItem item) returns json {
    if item is TypedValue {
        return item.value;
    }
    return item;
}

# Returns the payload of an item after the implicit conversion of FHIR primitives to System types,
# so FHIR date/dateTime/instant/time values use the System '@' representation.
#
# + item - The collection item
# + return - The JSON value in its System representation
isolated function systemValueOf(FhirPathItem item) returns json {
    if item !is TypedValue {
        return item;
    }
    json value = item.value;
    if item.namespace == FHIR_NS && value is string {
        string name = item.name;
        if name == "date" || name == "dateTime" || name == "instant" {
            return "@" + value;
        }
        if name == "time" {
            return "@T" + value;
        }
    }
    return value;
}

# Returns the [namespace, name] type of an item.
#
# + item - The collection item
# + return - The namespace and type name
isolated function typeOfItem(FhirPathItem item) returns [string, string] {
    if item is TypedValue {
        return [item.namespace, item.name];
    }
    if item is boolean { return [SYSTEM_NS, "Boolean"]; }
    if item is int { return [SYSTEM_NS, "Integer"]; }
    if item is decimal || item is float { return [SYSTEM_NS, "Decimal"]; }
    if item is string { return [SYSTEM_NS, "String"]; }
    if item is map<json> {
        json rt = item["resourceType"];
        if rt is string { return [FHIR_NS, rt]; }
    }
    return [SYSTEM_NS, "Any"];
}

# Creates a System-typed item.
#
# + name - The System type name
# + value - The payload
# + return - The typed item
isolated function systemItem(string name, json value) returns TypedValue {
    return new TypedValue(value, SYSTEM_NS, name);
}

# Creates a System Quantity item.
#
# + value - The numeric value
# + unit - The unit (UCUM code or calendar duration keyword)
# + return - The typed item
isolated function quantityItem(decimal value, string unit) returns TypedValue {
    return systemItem("Quantity", {"value": value, "unit": unit});
}

# Returns the System date/time type of an '@'-prefixed string payload, or () for other values.
#
# + value - A JSON payload
# + return - "Date", "DateTime", "Time" or ()
isolated function dateTimeKind(json value) returns string? {
    if value !is string || !value.startsWith("@") {
        return ();
    }
    string s = value.substring(1);
    return s.startsWith("T") ? "Time" : (s.includes("T") ? "DateTime" : "Date");
}

# Wraps a JSON value produced by a function as a collection, typing '@'-prefixed date/time strings.
# Use this for results computed from System values (e.g. date arithmetic).
#
# + value - The computed value
# + return - The typed item
isolated function computedItem(json value) returns FhirPathItem {
    string? kind = dateTimeKind(value);
    if kind is string {
        return systemItem(kind, value);
    }
    if value is map<json> && value["resourceType"] is () && value.hasKey("value") && value.hasKey("unit") {
        return systemItem("Quantity", value);
    }
    return value;
}

# Types the plain JSON results of a computation that may produce dates, times or quantities.
#
# + items - The computed results
# + return - The typed results
isolated function typedResults(FhirPathItem[] items) returns FhirPathItem[] {
    FhirPathItem[] results = [];
    foreach FhirPathItem item in items {
        results.push(item is TypedValue ? item : computedItem(item));
    }
    return results;
}

# Converts a JSON value into a collection, typing resources by their resourceType.
# Arrays become one item per element.
#
# + value - The JSON value (e.g. an input resource or an external variable)
# + return - The collection
isolated function toCollection(json value) returns FhirPathItem[] {
    if value is () {
        return [];
    }
    FhirPathItem[] items = [];
    if value is json[] {
        foreach json element in value {
            if element !is () {
                items.push(rootItem(element));
            }
        }
        return items;
    }
    items.push(rootItem(value));
    return items;
}

# Types a top-level JSON value: resources become FHIR-typed items, other values are left untyped.
#
# + value - The JSON value
# + return - The collection item
isolated function rootItem(json value) returns FhirPathItem {
    if value is map<json> {
        json rt = value["resourceType"];
        if rt is string {
            return new TypedValue(value, FHIR_NS, rt, rt);
        }
    }
    return value;
}

# Converts a collection to the JSON returned by the public API.
#
# + items - The collection
# + return - The JSON values
isolated function toOutputJson(FhirPathItem[] items) returns json[] {
    return from FhirPathItem item in items select valueOf(item);
}

// ========================================
// MODEL-AWARE NAVIGATION
// ========================================

# Returns the children of an item reachable through the given element name, typed from the FHIR model.
# Choice elements are matched by their base name (e.g. "value" matches "valueQuantity").
#
# + item - The parent item
# + name - The element name
# + return - The child items
isolated function childItems(FhirPathItem item, string name) returns FhirPathItem[] {
    json parent = valueOf(item);
    string? modelKey = modelKeyOf(item);
    if parent !is map<json> {
        if parent is json[] {
            FhirPathItem[] results = [];
            foreach json element in parent {
                results.push(...childItems(element, name));
            }
            return results;
        }
        // Primitive: navigate into its `_name` sibling element (id, extension)
        if item is TypedValue {
            json element = item.primitiveElement;
            if element is map<json> {
                return childrenOfKey(element, item.name, name, name);
            }
        }
        return [];
    }
    if parent.hasKey(name) {
        return childrenOfKey(parent, modelKey, name, name);
    }
    // Choice element: "value" → "valueQuantity", "valueString", ...
    FhirPathItem[] results = [];
    foreach string key in parent.keys() {
        if key.length() > name.length() && key.startsWith(name) {
            string suffix = key.substring(name.length());
            string first = suffix.substring(0, 1);
            if first >= "A" && first <= "Z" && isChoiceExpansion(modelKey, name) {
                results.push(...childrenOfKey(parent, modelKey, key, name));
            }
        }
    }
    return results;
}

# Returns every child element of an item, typed from the FHIR model.
#
# + item - The parent item
# + return - The child items
isolated function allChildItems(FhirPathItem item) returns FhirPathItem[] {
    json parent = valueOf(item);
    FhirPathItem[] results = [];
    if parent is map<json> {
        string? modelKey = modelKeyOf(item);
        foreach string key in parent.keys() {
            results.push(...childrenOfKey(parent, modelKey, key, key));
        }
    } else if parent is json[] {
        foreach json element in parent {
            if element !is () {
                results.push(element);
            }
        }
    }
    return results;
}

isolated function modelKeyOf(FhirPathItem item) returns string? {
    if item is TypedValue {
        return item.modelKey;
    }
    if item is map<json> {
        json rt = item["resourceType"];
        if rt is string { return rt; }
    }
    return ();
}

// True when `key` (a JSON property starting with `name`) is a choice-type expansion of `name`.
// Without model information any capitalised suffix is accepted.
isolated function isChoiceExpansion(string? modelKey, string name) returns boolean {
    string? elementType = modelElementType(modelKey, name);
    if elementType is string {
        return elementType.includes("|");
    }
    return modelKey is () || FHIR_ELEMENT_TYPES[modelKey] is ();
}

// Types the value(s) stored under `key` of `parent`. `name` is the FHIRPath element name, which differs
// from the key for choice elements.
isolated function childrenOfKey(map<json> parent, string? modelKey, string key, string name) returns FhirPathItem[] {
    json raw = parent[key];
    json primitiveElements = parent["_" + key];
    [string, string?] [typeName, childKey] = resolveChildType(modelKey, key, name);

    FhirPathItem[] results = [];
    if raw is json[] {
        foreach int i in 0 ..< raw.length() {
            json element = raw[i];
            json primitiveElement = primitiveElements is json[] && i < primitiveElements.length() ? primitiveElements[i] : ();
            if element is () && primitiveElement is () {
                continue;
            }
            results.push(typedChild(element, typeName, childKey, primitiveElement));
        }
    } else if raw !is () {
        results.push(typedChild(raw, typeName, childKey, primitiveElements));
    }
    return results;
}

isolated function typedChild(json value, string typeName, string? childKey, json primitiveElement) returns TypedValue {
    if value is map<json> {
        json rt = value["resourceType"];
        if rt is string {
            return new TypedValue(value, FHIR_NS, rt, rt);
        }
    }
    if typeName.startsWith("System.") {
        return new TypedValue(value, SYSTEM_NS, typeName.substring(7));
    }
    if typeName == "" {
        return new TypedValue(value, FHIR_NS, inferFhirType(value), (), primitiveElement);
    }
    return new TypedValue(value, FHIR_NS, typeName, childKey, primitiveElement);
}

// Resolves [typeName, modelKey] for the child `name` (stored under JSON property `key`) of `modelKey`.
// The type name is "" when the model has no information about the element.
isolated function resolveChildType(string? modelKey, string key, string name) returns [string, string?] {
    if modelKey is () {
        if key != name {
            string choiceType = choiceTypeFromSuffix(key.substring(name.length()), ());
            return [choiceType, FHIR_ELEMENT_TYPES.hasKey(choiceType) ? choiceType : ()];
        }
        return ["", ()];
    }
    string? elementType = modelElementType(modelKey, name);
    if elementType is () && key == name {
        // A choice element addressed by its expanded name (e.g. "valueQuantity")
        foreach [string, string] [baseName, types] in (FHIR_ELEMENT_TYPES[modelKey] ?: {}).entries() {
            if types.includes("|") && key.length() > baseName.length() && key.startsWith(baseName) {
                string choiceType = choiceTypeFromSuffix(key.substring(baseName.length()), types);
                return [choiceType, FHIR_ELEMENT_TYPES.hasKey(choiceType) ? choiceType : ()];
            }
        }
        return ["", ()];
    }
    if elementType is () {
        return ["", ()];
    }
    if elementType.includes("|") {
        string choiceType = choiceTypeFromSuffix(key.substring(name.length()), elementType);
        return [choiceType, FHIR_ELEMENT_TYPES.hasKey(choiceType) ? choiceType : ()];
    }
    if elementType.startsWith("#") {
        string ref = elementType.substring(1);
        int? dot = ref.lastIndexOf(".");
        string refType = dot is int ? (modelElementType(ref.substring(0, dot), ref.substring(dot + 1)) ?: "BackboneElement") : "BackboneElement";
        return [refType, ref];
    }
    string childPath = modelKey + "." + name;
    if FHIR_ELEMENT_TYPES.hasKey(childPath) {
        return [elementType, childPath];
    }
    return [elementType, FHIR_ELEMENT_TYPES.hasKey(elementType) ? elementType : ()];
}

// Maps a choice suffix (e.g. "Quantity", "DateTime") to its FHIR type name, using the declared choices when known.
isolated function choiceTypeFromSuffix(string suffix, string? choices) returns string {
    if choices is string {
        foreach string choice in re `\|`.split(choices) {
            if choice.length() > 0 && choice.substring(0, 1).toUpperAscii() + choice.substring(1) == suffix {
                return choice;
            }
        }
    }
    if FHIR_TYPE_BASE.hasKey(suffix) {
        return suffix;
    }
    string lowered = suffix.substring(0, 1).toLowerAscii() + suffix.substring(1);
    if FHIR_TYPE_BASE.hasKey(lowered) {
        return lowered;
    }
    return suffix;
}

isolated function modelElementType(string? modelKey, string name) returns string? {
    if modelKey is () {
        return ();
    }
    map<string>? elements = FHIR_ELEMENT_TYPES[modelKey];
    if elements is () {
        return ();
    }
    return elements[name];
}

// FHIR type of a value navigated without model information, inferred from its JSON shape.
isolated function inferFhirType(json value) returns string {
    if value is boolean { return "boolean"; }
    if value is int { return "integer"; }
    if value is decimal || value is float { return "decimal"; }
    if value is string { return "string"; }
    return "Element";
}

// ========================================
// TYPE TESTS
// ========================================

# Resolves a type specifier to the [namespace, name] candidates it may denote. Unqualified names are
# looked up in the FHIR model first, then in System; a name defined in both (Quantity) denotes both.
#
# + specifier - The type specifier (e.g. "Patient", "FHIR.string", "System.Integer", "Quantity")
# + return - The candidate types (empty when the type is unknown)
isolated function resolveTypeSpecifier(string specifier) returns [string, string][] {
    if specifier.startsWith("System.") {
        return [[SYSTEM_NS, specifier.substring(7)]];
    }
    if specifier.startsWith("FHIR.") {
        return [[FHIR_NS, specifier.substring(5)]];
    }
    [string, string][] candidates = [];
    if FHIR_TYPE_BASE.hasKey(specifier) {
        candidates.push([FHIR_NS, specifier]);
    }
    if SYSTEM_TYPE_NAMES.indexOf(specifier) !is () {
        candidates.push([SYSTEM_NS, specifier]);
    }
    return candidates;
}

# Returns true when the item's type is the given type or derives from it.
#
# + item - The collection item
# + specifier - The type specifier
# + return - Whether the item is of the type
isolated function itemIsOfType(FhirPathItem item, string specifier) returns boolean {
    [string, string] [namespace, name] = typeOfItem(item);
    foreach [string, string] [targetNamespace, targetName] in resolveTypeSpecifier(specifier) {
        if namespace != targetNamespace {
            continue;
        }
        if targetName == name || (namespace == SYSTEM_NS && targetName == "Any") {
            return true;
        }
        if namespace == FHIR_NS && fhirTypeDerivesFrom(name, targetName) {
            return true;
        }
    }
    return false;
}

# Returns true when the item has exactly the given type. Complex FHIR types also match their base types
# (e.g. Age matches Quantity), primitive FHIR types only match themselves (code does not match string).
#
# + item - The collection item
# + specifier - The type specifier
# + return - Whether the item has the type
isolated function itemHasExactType(FhirPathItem item, string specifier) returns boolean {
    [string, string] [namespace, name] = typeOfItem(item);
    foreach [string, string] [targetNamespace, targetName] in resolveTypeSpecifier(specifier) {
        if namespace != targetNamespace {
            continue;
        }
        if targetName == name {
            return true;
        }
        if namespace == FHIR_NS && !isFhirPrimitiveType(name) && fhirTypeDerivesFrom(name, targetName) {
            return true;
        }
    }
    return false;
}

isolated function fhirTypeDerivesFrom(string typeName, string ancestor) returns boolean {
    string current = typeName;
    int depth = 0;
    while depth < 16 {
        string? base = FHIR_TYPE_BASE[current];
        if base is () || base == "" {
            return false;
        }
        if base == ancestor {
            return true;
        }
        current = base;
        depth += 1;
    }
    return false;
}

isolated function isFhirPrimitiveType(string typeName) returns boolean {
    return typeName.length() > 0 && typeName.substring(0, 1) >= "a" && typeName.substring(0, 1) <= "z";
}
