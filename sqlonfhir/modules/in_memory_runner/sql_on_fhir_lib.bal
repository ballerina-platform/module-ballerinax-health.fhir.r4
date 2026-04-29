import ballerinax/health.fhir.r4utils.fhirpath;

import mahima_de_silva/sql_on_fhir_lib;

// Column type for validation
type ColumnDefinition record {
    string name;
};

# Type definition for custom FHIRPath extension functions
# + nodes - Array of FHIR nodes to process
# + return - Array of extracted values
public type GetResourceKeyFunction isolated function (json[] nodes) returns json[]|error;

# Type definition for getReferenceKey extension function with options
# + nodes - Array of FHIR nodes to process
# + resourceType - Optional resource type to filter by
# + return - Array of extracted reference keys
public type GetReferenceKeyFunction isolated function (json[] nodes, string? resourceType) returns json[]|error;

# Configuration record for FHIRPath extension functions
# + getResourceKey - Custom implementation for getResourceKey function
# + getReferenceKey - Custom implementation for getReferenceKey function
public type FhirPathExtensions record {|
    GetResourceKeyFunction getResourceKey?;
    GetReferenceKeyFunction getReferenceKey?;
|};

# Default implementation of getResourceKey - extracts id from nodes
# + nodes - Array of FHIR nodes
# + return - Array of resource ids
public isolated function defaultGetResourceKey(json[] nodes) returns json[]|error {
    json[] result = [];
    foreach json node in nodes {
        if node is map<json> && node.hasKey("id") {
            result.push(node["id"]);
        }
    }
    return result;
}

# Default implementation of getReferenceKey - extracts reference key from reference string
# + nodes - Array of FHIR nodes containing reference field
# + resourceType - Optional resource type to filter by
# + return - Array of extracted reference keys
public isolated function defaultGetReferenceKey(json[] nodes, string? resourceType) returns json[]|error {
    json[] result = [];
    foreach json node in nodes {
        if node is map<json> && node.hasKey("reference") {
            string reference = <string>node["reference"];
            // Remove double slashes
            string cleanRef = re `//`.replaceAll(reference, "");
            // Split by /_history to get base reference
            string[] historyParts = re `/_history`.split(cleanRef);
            string basePart = historyParts[0];

            // Split by / to get type and key
            string[] parts = re `/`.split(basePart);
            if parts.length() >= 2 {
                string refType = parts[parts.length() - 2];
                string key = parts[parts.length() - 1];

                if resourceType is () {
                    // No filter, return all keys
                    result.push(key);
                } else if resourceType == refType {
                    // Filter matches, return key
                    result.push(key);
                }
                // Otherwise, filter doesn't match, skip this node
            }
        }
    }
    return result;
}

// Store for extension functions (module-level to be accessible across functions)
isolated FhirPathExtensions currentExtensions = {};

isolated function processConstants(sql_on_fhir_lib:ViewDefinitionConstant[]? constants) returns map<json>|error {
    map<json> result = {};
    foreach sql_on_fhir_lib:ViewDefinitionConstant c in (constants ?: []) {
        map<json> cJson = <map<json>>c.toJson();
        boolean found = false;
        foreach string key in cJson.keys() {
            if key.startsWith("value") {
                result[c.name] = cJson[key];
                found = true;
                break;
            }
        }
        if !found {
            return error("Constant '" + c.name + "' has no value");
        }
    }
    return result;
}

// Helper to check if path contains getResourceKey() call
isolated function containsGetResourceKey(string path) returns boolean {
    return path.includes(".getResourceKey()") || path.startsWith("getResourceKey()");
}

// Helper to check if path contains getReferenceKey() call
isolated function containsGetReferenceKey(string path) returns boolean {
    return path.includes(".getReferenceKey(") || path.startsWith("getReferenceKey(");
}

// Helper to extract base path before extension function call
isolated function extractBasePath(string path, string funcName) returns string {
    // Check for function at start (without dot)
    string funcNameWithoutDot = funcName.startsWith(".") ? funcName.substring(1) : funcName;
    if path.startsWith(funcNameWithoutDot) {
        return "";
    }
    int? idx = path.indexOf(funcName);
    if idx is int && idx > 0 {
        return path.substring(0, idx);
    }
    return "";
}

// Helper to extract parameter from getReferenceKey call
isolated function extractReferenceKeyParam(string path) returns string? {
    int? startIdx = path.indexOf(".getReferenceKey(");
    int parenStart;
    if startIdx is () {
        // Check if it starts with getReferenceKey( (no leading dot)
        if path.startsWith("getReferenceKey(") {
            parenStart = "getReferenceKey(".length();
        } else {
            return ();
        }
    } else {
        parenStart = <int>startIdx + ".getReferenceKey(".length();
    }
    int? endIdx = path.indexOf(")", parenStart);
    if endIdx is () {
        return ();
    }
    string paramStr = path.substring(parenStart, <int>endIdx).trim();
    if paramStr.length() == 0 {
        return ();
    }
    // Remove surrounding quotes if present
    if (paramStr.startsWith("'") && paramStr.endsWith("'")) ||
        (paramStr.startsWith("\"") && paramStr.endsWith("\"")) {
        return paramStr.substring(1, paramStr.length() - 1);
    }
    return paramStr;
}

// Finds the position of the top-level = operator (not inside parentheses, not != <= >= ~=)
isolated function findTopLevelEquals(string path) returns int? {
    int parenDepth = 0;
    int i = 0;
    while i < path.length() {
        string ch = path.substring(i, i + 1);
        if ch == "(" {
            parenDepth += 1;
        } else if ch == ")" {
            parenDepth -= 1;
        } else if ch == "=" && parenDepth == 0 {
            string prev = i > 0 ? path.substring(i - 1, i) : "";
            string next = i + 1 < path.length() ? path.substring(i + 1, i + 2) : "";
            if prev != "!" && prev != "<" && prev != ">" && prev != "~" && next != "=" {
                return i;
            }
        }
        i += 1;
    }
    return ();
}

# Rewrites `.ofType(X)` → `X` (first letter uppercased) in a FHIRPath expression.
# e.g. `value.ofType(Range)` → `valueRange`, matching FHIR JSON's choice-type naming convention.
# + path - The FHIRPath expression to rewrite
# + return - Rewritten path with ofType calls replaced by capitalized type suffixes
isolated function rewriteOfType(string path) returns string {
    string result = path;
    int startIndex = 0;
    while true {
        int? ofTypeIdx = result.indexOf(".ofType(", startIndex);
        if ofTypeIdx is () {
            break;
        }
        int? closeParenIdx = result.indexOf(")", ofTypeIdx);
        if closeParenIdx is () {
            break;
        }
        string typeName = result.substring(ofTypeIdx + 8, closeParenIdx);
        if typeName.length() == 0 {
            startIndex = ofTypeIdx + 1;
            continue;
        }
        string capitalized = typeName.substring(0, 1).toUpperAscii() + typeName.substring(1);
        result = result.substring(0, ofTypeIdx) + capitalized + result.substring(closeParenIdx + 1);
        startIndex = ofTypeIdx + capitalized.length();
    }
    return result;
}

# Evaluates a FHIRPath expression with support for custom extension functions
# + node - The FHIR resource node to evaluate against
# + path - The FHIRPath expression
# + extensions - Optional custom extension functions
# + constants - FHIRPath variables accessible via %name syntax
# + return - Array of values from the FHIRPath evaluation
isolated function evaluateFhirPath(json node, string path, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    string rewrittenPath = rewriteOfType(path);
    // Only pass variables whose %name is actually referenced in the path.
    // Passing a variable named "id" to a path that is simply "id" causes the
    // FHIRPath library to resolve the bare identifier as a variable lookup
    // instead of a property access.
    map<json> relevantVars = {};
    foreach [string, json] [key, value] in constants.entries() {
        if rewrittenPath.includes("%" + key) {
            relevantVars[key] = value;
        }
    }
    map<json>? vars = relevantVars.length() > 0 ? relevantVars : ();

    // Handle compound expressions: custom function on either side of =
    // e.g. "getResourceKey() = link.other.getReferenceKey(Patient)"
    if containsGetResourceKey(rewrittenPath) || containsGetReferenceKey(rewrittenPath) {
        int? eqIdx = findTopLevelEquals(rewrittenPath);
        if eqIdx is int {
            string lhs = rewrittenPath.substring(0, eqIdx).trim();
            string rhs = rewrittenPath.substring(eqIdx + 1).trim();
            json[] lhsResult = check evaluateFhirPath(node, lhs, extensions, constants);
            json[] rhsResult = check evaluateFhirPath(node, rhs, extensions, constants);
            if lhsResult.length() == 0 || rhsResult.length() == 0 {
                return [];
            }
            if lhsResult.length() != rhsResult.length() {
                return [false];
            }
            foreach int idx in 0 ..< lhsResult.length() {
                if lhsResult[idx] != rhsResult[idx] {
                    return [false];
                }
            }
            return [true];
        }
    }

    // Check for getResourceKey() function call
    if containsGetResourceKey(rewrittenPath) {
        string basePath = extractBasePath(rewrittenPath, ".getResourceKey()");
        json[] nodes = basePath.length() > 0 ? check fhirpath:getValuesFromFhirPath(node, basePath, variables = vars) : [node];
        GetResourceKeyFunction getResourceKeyFn = extensions?.getResourceKey ?: defaultGetResourceKey;
        return getResourceKeyFn(nodes);
    }

    // Check for getReferenceKey() function call with optional parameter
    if containsGetReferenceKey(rewrittenPath) {
        string basePath = extractBasePath(rewrittenPath, ".getReferenceKey(");
        json[] nodes = basePath.length() > 0 ? check fhirpath:getValuesFromFhirPath(node, basePath, variables = vars) : [node];
        string? resourceTypeParam = extractReferenceKeyParam(rewrittenPath);
        GetReferenceKeyFunction getReferenceKeyFn = extensions?.getReferenceKey ?: defaultGetReferenceKey;
        return getReferenceKeyFn(nodes, resourceTypeParam);
    }

    // Standard FHIRPath evaluation
    return fhirpath:getValuesFromFhirPath(node, rewrittenPath, variables = vars);
}

// Validates column definitions for duplicates and unionAll branch consistency
isolated function validateColumnsTyped(sql_on_fhir_lib:ViewDefinitionSelect[] selects, ColumnDefinition[] C) returns ColumnDefinition[]|error {
    ColumnDefinition[] ret = C.clone();

    foreach sql_on_fhir_lib:ViewDefinitionSelect sel in selects {
        // Validate column definitions within this select node
        foreach sql_on_fhir_lib:ViewDefinitionSelectColumn col in (sel.column ?: []) {
            foreach ColumnDefinition existing in ret {
                if existing.name == col.name {
                    return error("Column Already Defined: " + col.name);
                }
            }
            ret.push({name: col.name});
        }

        // Recurse into nested selects
        if sel.'select != () {
            ColumnDefinition[] validated = check validateColumnsTyped(sel.'select ?: [], ret);
            foreach ColumnDefinition c in validated {
                boolean exists = false;
                foreach ColumnDefinition existingCol in ret {
                    if existingCol.name == c.name {
                        exists = true;
                        break;
                    }
                }
                if !exists {
                    ret.push(c);
                }
            }
        }

        // Validate unionAll branches for consistency
        if sel.unionAll != () {
            sql_on_fhir_lib:ViewDefinitionSelect[] unionBranches = sel.unionAll ?: [];
            if unionBranches.length() > 0 {
                ColumnDefinition[] u0 = check validateColumnsTyped([unionBranches[0]], ret);
                string[] u0Names = [];
                foreach ColumnDefinition col in u0 {
                    boolean existsInRet = false;
                    foreach ColumnDefinition existingCol in ret {
                        if existingCol.name == col.name {
                            existsInRet = true;
                            break;
                        }
                    }
                    if !existsInRet {
                        u0Names.push(col.name);
                    }
                }

                foreach int i in 1 ..< unionBranches.length() {
                    ColumnDefinition[] u = check validateColumnsTyped([unionBranches[i]], ret);
                    string[] uNames = [];
                    foreach ColumnDefinition col in u {
                        boolean existsInRet = false;
                        foreach ColumnDefinition existingCol in ret {
                            if existingCol.name == col.name {
                                existsInRet = true;
                                break;
                            }
                        }
                        if !existsInRet {
                            uNames.push(col.name);
                        }
                    }
                    if u0Names.length() != uNames.length() {
                        return error("Union Branches Inconsistent: column count mismatch");
                    }
                    foreach int j in 0 ..< u0Names.length() {
                        if u0Names[j] != uNames[j] {
                            return error("Union Branches Inconsistent: column names or order mismatch");
                        }
                    }
                }

                foreach string name in u0Names {
                    ret.push({name: name});
                }
            }
        }
    }

    return ret;
}

// Function to merge two maps
isolated function merge(json m1, json m2) returns json|error {
    json result = check m1.clone().mergeJson(m2);
    return result;
}

// Row product function - creates cartesian product of arrays of maps
isolated function rowProduct(json[][] parts) returns json[]|error {
    json[] result = [{}];

    foreach json[] partialRows in parts {
        json[] newResult = [];

        foreach json partialRow in partialRows {
            foreach json row in result {
                json merged = check merge(partialRow, row);
                newResult.push(merged);
            }
        }

        result = newResult;
    }

    return result;
}

// Determines the evaluation type for a ViewDefinitionSelect node
isolated function getOperationType(sql_on_fhir_lib:ViewDefinitionSelect sel) returns string {
    if sel.forEach != () {
        return "forEach";
    }
    if sel.forEachOrNull != () {
        return "forEachOrNull";
    }
    if sel.repeat != () {
        return "repeat";
    }
    if sel.unionAll != () && sel.'select == () && sel.column == () {
        return "unionAll";
    }
    if sel.column != () && sel.'select == () && sel.unionAll == () {
        return "column";
    }
    return "select";
}

isolated function doEvalTyped(sql_on_fhir_lib:ViewDefinitionSelect sel, json node, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    match getOperationType(sel) {
        "column" => {
            return columnOperationTyped(sel, node, extensions, constants);
        }
        "select" => {
            return selectOperationTyped(sel, node, extensions, constants);
        }
        "forEach" => {
            return forEachOperationTyped(sel, node, extensions, constants);
        }
        "forEachOrNull" => {
            return forEachOrNullOperationTyped(sel, node, extensions, constants);
        }
        "unionAll" => {
            return unionAllOperationTyped(sel, node, extensions, constants);
        }
        "repeat" => {
            return repeatOperationTyped(sel, node, extensions, constants);
        }
        _ => {
            return [];
        }
    }
}

isolated function columnOperationTyped(sql_on_fhir_lib:ViewDefinitionSelect sel, json node, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    map<anydata> result = {};
    foreach sql_on_fhir_lib:ViewDefinitionSelectColumn c in (sel.column ?: []) {
        json[] vs = check evaluateFhirPath(node, c.path, extensions, constants);
        if c.collection ?: false {
            result[c.name] = vs;
        } else if vs.length() === 1 {
            result[c.name] = vs[0];
        } else if vs.length() === 0 {
            result[c.name] = ();
        } else {
            return error("Collection flag is false for path: " + c.path);
        }
    }
    return [result.toJson()];
}

// Evaluates column, unionAll, then select children of a node against the given FHIR node,
// combining results via rowProduct. Used by select, forEach, forEachOrNull, and repeat operations.
isolated function evalSelectChildren(sql_on_fhir_lib:ViewDefinitionSelect sel, json node, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    json[][] parts = [];
    if sel.column != () {
        parts.push(check columnOperationTyped(sel, node, extensions, constants));
    }
    if sel.unionAll != () {
        parts.push(check unionAllOperationTyped(sel, node, extensions, constants));
    }
    foreach sql_on_fhir_lib:ViewDefinitionSelect childSel in (sel.'select ?: []) {
        parts.push(check doEvalTyped(childSel, node, extensions, constants));
    }
    return rowProduct(parts);
}

isolated function selectOperationTyped(sql_on_fhir_lib:ViewDefinitionSelect sel, json node, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    return evalSelectChildren(sel, node, extensions, constants);
}

isolated function forEachOperationTyped(sql_on_fhir_lib:ViewDefinitionSelect sel, json node, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    json[] nodes = check evaluateFhirPath(node, sel.forEach ?: "", extensions, constants);
    json[] results = [];
    foreach json nodeItem in nodes {
        results.push(...check evalSelectChildren(sel, nodeItem, extensions, constants));
    }
    return results;
}

isolated function forEachOrNullOperationTyped(sql_on_fhir_lib:ViewDefinitionSelect sel, json node, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    json[] nodes = check evaluateFhirPath(node, sel.forEachOrNull ?: "", extensions, constants);
    if nodes.length() == 0 {
        nodes = [{}];
    }
    json[] results = [];
    foreach json nodeItem in nodes {
        results.push(...check evalSelectChildren(sel, nodeItem, extensions, constants));
    }
    return results;
}

// Helper function to check if all results have the same columns
isolated function arraysUnique(json[] results) returns int {
    map<boolean> uniqueColumnSets = {};
    foreach var item in results {
        if item is map<anydata> {
            string columnSet = item.keys().sort().toString();
            uniqueColumnSets[columnSet] = true;
        }
    }
    return uniqueColumnSets.length();
}

isolated function unionAllOperationTyped(sql_on_fhir_lib:ViewDefinitionSelect sel, json node, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    json[] result = [];
    foreach sql_on_fhir_lib:ViewDefinitionSelect branch in (sel.unionAll ?: []) {
        result.push(...check doEvalTyped(branch, node, extensions, constants));
    }
    int uniqueCount = arraysUnique(result);
    if uniqueCount > 1 {
        return error(string `Union columns mismatch: found ${uniqueCount} different column sets`);
    }
    return result;
}

// Helper function to recursively traverse FHIR nodes
isolated function traverse(json currentNode, string[] paths, json[] result, boolean isRoot, FhirPathExtensions? extensions = (), map<json> constants = {}) returns error? {
    // Don't add the root node to results, only its children
    if !isRoot {
        result.push(currentNode);
    }

    // Recursively traverse using each path expression
    foreach string path in paths {
        json[] childNodes = check evaluateFhirPath(currentNode, path, extensions, constants);
        foreach json childNode in childNodes {
            // Only traverse if it's not an array
            if childNode !is json[] {
                check traverse(childNode, paths, result, false, extensions, constants);
            }
        }
    }
}

// Recursively traverse a FHIR node using path expressions
isolated function recursiveTraverse(string[] paths, json node, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    json[] result = [];
    check traverse(node, paths, result, true, extensions, constants);
    return result;
}

isolated function repeatOperationTyped(sql_on_fhir_lib:ViewDefinitionSelect sel, json node, FhirPathExtensions? extensions = (), map<json> constants = {}) returns json[]|error {
    json[] nodes = check recursiveTraverse(sel.repeat ?: [], node, extensions, constants);
    json[] results = [];
    foreach json nodeItem in nodes {
        results.push(...check evalSelectChildren(sel, nodeItem, extensions, constants));
    }
    return results;
}

# Evaluates FHIR resources against a view definition
# + resources - Array of FHIR resources to evaluate
# + viewDefinition - The view definition
# + extensions - Optional custom FHIRPath extension functions (getResourceKey, getReferenceKey)
# + return - Array of result rows or error
public isolated function evaluate(json[] resources, sql_on_fhir_lib:ViewDefinition viewDefinition, FhirPathExtensions? extensions = ()) returns json[]|error {
    _ = check validateColumnsTyped(viewDefinition.'select, []);
    map<json> constants = check processConstants(viewDefinition.constant);

    json[] results = [];
    foreach json 'resource in resources {
        // Filter by resource type
        if 'resource is map<json> {
            if 'resource["resourceType"] != viewDefinition.'resource {
                continue;
            }
        } else {
            continue;
        }

        // Apply top-level where filters
        boolean include = true;
        foreach sql_on_fhir_lib:ViewDefinitionWhere w in (viewDefinition.'where ?: []) {
            json[] vals = check evaluateFhirPath('resource, w.path, extensions, constants);
            json val = vals.length() > 0 ? vals[0] : ();
            if val !== () && val !is boolean {
                return error("'where' expression path should return 'boolean'");
            }
            if val === () || val === false {
                include = false;
                break;
            }
        }
        if !include {
            continue;
        }

        // Evaluate each top-level select and combine via row product
        json[][] parts = [];
        foreach sql_on_fhir_lib:ViewDefinitionSelect sel in viewDefinition.'select {
            parts.push(check doEvalTyped(sel, 'resource, extensions, constants));
        }
        results.push(...check rowProduct(parts));
    }

    return results;
}
