import ballerina/io;

public function main() returns error? {
    json viewDef = {
        "resource": "Patient",
        "select": [
            {"column": [{"name": "id", "path": "id"}]},
            {
                "forEach": "name.given",
                "column": [{"name": "family", "path": "family"}]
            }
        ]
    };

    TranspilerContext ctx = {resourceAlias: "r", resourceColumn: "resource", tableName: "fhir_resources"};
    string result = check generateQuery(viewDef, ctx);

    io:println(result);

    // string result2 = check transpile("Patient.id", {resourceAlias: "r"});
    // io:println(result2);
}
