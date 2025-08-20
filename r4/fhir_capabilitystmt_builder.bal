// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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

# Configuration record for FHIR Capability Statement generation
#
# + status - The status of the capability statement
# + kind - The way this statement is intended to be used  
# + fhirVersion - The version of FHIR specification (default: "4.0.1")
# + softwareName - The name of the software
# + softwareVersion - The version of the software (default: "1.0.0") 
# + implementationDescription - Description of the implementation (default: "Ballerina FHIR Service")
# + format - Supported formats (default: ["json"])
# + title - A short, descriptive, user-friendly title for the capability statement
# + publisher - The name of the organization or individual that published the capability statement
# + description - A free text natural language description of the capability statement
# + contact - Contact details to assist a user in finding and communicating with the publisher
public type CapabilityStatementConfig record {|
    CapabilityStatementStatus status?;
    CapabilityStatementKind kind?;
    string fhirVersion?;
    string softwareName?;
    string softwareVersion?;
    string implementationDescription?;
    CapabilityStatementFormat[] format?;
    string title?;
    string publisher?;
    string description?;
    ContactDetail[] contact?;
|};

# Generate a FHIR Capability Statement based on FHIR API configurations.
#
# + config - Additional configuration for the capability statement elements
# + return - The generated FHIR Capability Statement or an error
public isolated function generateFHIRCapabilityStatement(CapabilityStatementConfig? config = ()) returns CapabilityStatement|error {

    CapabilityStatement capabilityStatement = {
        status: config?.status ?: CODE_STATUS_ACTIVE,
        kind: config?.kind ?: CODE_KIND_INSTANCE,
        date: time:utcToString(time:utcNow()),
        fhirVersion: config?.fhirVersion ?: "4.0.1",
        software: {
            name: config?.softwareName ?: "Ballerina FHIR Service",
            'version: config?.softwareVersion ?: "1.0.0"
        },
        implementation: {
            description: config?.implementationDescription ?: "Ballerina FHIR Service"
        },
        rest: [],
        format: config?.format ?: [CODE_FORMAT_JSON],
        title: config?.title,
        publisher: config?.publisher,
        description: config?.description,
        contact: config?.contact
    };

    FHIRServicesCollection allRegisteredFHIRServices = fhirRegistry.getAllRegisteredFHIRServices();
    
    // Collect all resource configurations
    CapabilityStatementRestResource[] resources = [];
    
    foreach var fhirSvc in allRegisteredFHIRServices {
        // Process each registered FHIR service
        ResourceAPIConfig? apiConfig = fhirSvc.apiConfig;
        if apiConfig is ResourceAPIConfig {
            
            // Create search parameters for this resource
            CapabilityStatementRestResourceSearchParam[] searchParams = [];
            foreach var searchParam in apiConfig.searchParameters {
                if searchParam.active {
                    CapabilityStatementRestResourceSearchParam capabilitySearchParam = {
                        name: searchParam.name,
                        'type: getCapabilitySearchParamType(searchParam.'type),
                        documentation: searchParam?.information?.description
                    };
                    searchParams.push(capabilitySearchParam);
                }
            }
            
            // Create operations for this resource  
            CapabilityStatementRestResourceOperation[] operations = [];
            foreach var operation in apiConfig.operations {
                if operation.active {
                    CapabilityStatementRestResourceOperation capabilityOperation = {
                        name: operation.name,
                        definition: "http://hl7.org/fhir/OperationDefinition/" + operation.name,
                        documentation: operation?.information?.description
                    };
                    operations.push(capabilityOperation);
                }
            }
            
            // Create resource interactions (standard FHIR REST operations)
            CapabilityStatementRestResourceInteraction[] interactions = [
                {code: "read"},
                {code: "search-type"},
                {code: "create"},
                {code: "update"},
                {code: "delete"}
            ];
            
            // Create the resource entry
            CapabilityStatementRestResource resourceEntry = {
                'type: apiConfig.resourceType,
                profile: apiConfig?.defaultProfile,
                supportedProfile: apiConfig.profiles.length() > 0 ? apiConfig.profiles : (),
                interaction: interactions,
                searchParam: searchParams.length() > 0 ? searchParams : (),
                operation: operations.length() > 0 ? operations : ()
            };
            
            resources.push(resourceEntry);
        }
    }
    
    // Create the REST configuration if we have resources
    if resources.length() > 0 {
        CapabilityStatementRest restConfig = {
            mode: "server",
            'resource: resources
        };
        capabilityStatement.rest = [restConfig];
    }

    return capabilityStatement;
};

// Helper function to map search parameter types to capability statement types
isolated function getCapabilitySearchParamType(FHIRSearchParameterType? paramType) returns CapabilityStatementRestResourceSearchParamType {
    if paramType is FHIRSearchParameterType {
        match paramType {
            "Number" => {return "number";}
            "Date" => {return "date";}
            "String" => {return "string";}
            "Token" => {return "token";}
            "Reference" => {return "reference";}
            "Composite" => {return "composite";}
            "Quantity" => {return "quantity";}
            "URI" => {return "uri";}
            "Special" => {return "special";}
        }
    }
    return "string";
}
