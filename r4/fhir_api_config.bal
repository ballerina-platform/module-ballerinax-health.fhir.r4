// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

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

# Function type to be implemented to override the operation pre-processing
public type OperationPreProcessor function (FHIROperationDefinition definition, FHIRContext context) returns FHIRError?;

# Function type to be implemented to override the operation post-processing
public type OperationPostProcessor function (FHIROperationDefinition definition, FHIRContext context) returns FHIRError?;

# Redefined FHIR read-only FHIR resource API config
public type ResourceAPIConfig readonly & ResourceAPIConfigType;

# API Config representation.
#
# + resourceType - FHIR resource type of the API  
# + profiles - profiles supported by the API  
# + defaultProfile - default profile that the FHIR API is supporting  
# + searchParameters - Search parameters supported by the FHIR API  
# + operations - Operations supported by the FHIR API  
# + serverConfig - Serevr configuration  
# + authzConfig - Authorization service configuration
# + auditConfig - Audit service configuration
public type ResourceAPIConfigType record {|
    readonly string resourceType;
    readonly string[] profiles;
    readonly string? defaultProfile;
    readonly SearchParamConfig[] searchParameters;
    readonly OperationConfig[] operations;
    readonly ServerConfig? serverConfig;
    readonly AuthzConfig? authzConfig;
    readonly AuditConfig auditConfig?;
|};

# Search parameter configuration.
#
# + name - Name of the search parameter  
# + active - Is this search parameter is activated or deactivated  
# + preProcessor - Override this search parameter pre-processing function. If the integration  developer wants to take control of pre-processing the search parameter.  
# + postProcessor - Override this search parameter post-processing function. If the integration  developer wants to take control of post-processing the search parameter
# + information - Meta infomation about the search parameter (no processed, just for information)
public type SearchParamConfig record {|
    readonly string name;
    readonly boolean active;
    readonly & SearchParameterPreProcessor preProcessor?;
    readonly & SearchParameterPostProcessor postProcessor?;
    readonly Information information?;
|};

# Operation configuration.
#
# + name - Name of the operation
# + active - Is this operation is activated or deactivated
# + preProcessor - Override this operation pre-processing function. If the integration  developer wants to take control of pre-processing the operation.  
# + postProcessor - Override this operation post-processing function. If the integration  developer wants to take control of post-processing the operation.
# + information - Meta infomation about the operation (no processed, just for information)
public type OperationConfig record {|
    readonly string name;
    readonly boolean active;
    readonly & OperationPreProcessor preProcessor?;
    readonly & OperationPostProcessor postProcessor?;
    readonly Information information?;
|};

# Information about a rest feature.
#
# + description - Description
# + builtin - Is this feature is available as a built-in feature
# + documentation - Documentation link
public type Information record {|
    readonly string description;
    readonly boolean builtin?;
    readonly string documentation?;
|};

# FHIR Server configurations.
#
# + apis - list of FHIR APIs that is implemented in the organization
public type ServerConfig record {|
    readonly map<ApiInfo> apis;
|};

# FHIR API information.
#
# + resourceType - FHIR resource type
# + searchParameters - supported search parameters
public type ApiInfo record {|
    readonly string resourceType;
    readonly string[] searchParameters;
|};
