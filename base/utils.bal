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

import ballerina/http;
import ballerina/lang.value;

# Get the FHIR context from the HTTP request context.
#
# + httpCtx - HTTP request context
# + return - FHIR context or error
public isolated function getFHIRContext(http:RequestContext httpCtx) returns FHIRContext|FHIRError {
    value:Cloneable|object {} fhirCtx = httpCtx.get(FHIR_CONTEXT_PROP_NAME);
    if fhirCtx is FHIRContext {
        return fhirCtx;
    }
    string diag = "Unable to find FHIR context in HTTP request context.";
    return createInternalFHIRError("FHIR Context not found", FATAL, PROCESSING_NOT_FOUND, diagnostic = diag);
}

# Get request resource entity from the FHIR context.
#
# + ctx - HTTP request context
# + return - FHIR resource entity or error
public isolated function getRequestResourceEntity(http:RequestContext ctx) returns FHIRResourceEntity|FHIRError {

    FHIRContext fhirCtx = check getFHIRContext(ctx);
    FHIRRequest? request = fhirCtx.getFHIRRequest();
    if request is FHIRRequest {
        FHIRResourceEntity? resourceEntity = request.getResourceEntity();
        if resourceEntity is FHIRResourceEntity {
            return resourceEntity;
        }
    }
    return createFHIRError("FHIR Request payload not found", ERROR, PROCESSING_NOT_FOUND);
}

# Set response resource entity to the FHIR context.
#
# + entity - FHIR resource entity
# + ctx - HTTP request context
# + return - Error if any
public isolated function setResponseResourceEntity(FHIRResourceEntity|FHIRContainerResourceEntity entity, 
                                                                            http:RequestContext ctx) returns FHIRError? {
    FHIRContext fhirCtx = check getFHIRContext(ctx);
    
    if entity is FHIRResourceEntity {
        FHIRResponse response = new(entity);
        fhirCtx.setFHIRResponse(response);
    } else {
        FHIRContainerResponse response = new(<FHIRContainerResourceEntity>entity);
        fhirCtx.setFHIRResponse(response);
    }
    
}

isolated function getResourceDefinition(typedesc resourceType) returns ResourceDefinitionRecord|FHIRTypeError {
    ResourceDefinitionRecord? def = resourceType.@ResourceDefinition;
    if def != () {
        return def;
    } else {
        string message = "Provided type does not represent a FHIR resource";
        string diagnostic = string `Unable to find resource definition of given resource of type : ${resourceType.toBalString()}`;
        return <FHIRTypeError> createInternalFHIRError(message, FATAL, PROCESSING, diagnostic = diagnostic);
    }
}

# Utility function to create request search parameter record.
# 
# + name - name of the search parameter
# + paramType - Search parameter type
# + originalValue - Original incoming search parameter value
# + typedValue - Typed (parsed/decoded) search parameter record
# + return - Created RequestSearchParameter
isolated function createSearchParameterWrapper(string & readonly name, FHIRSearchParameterType & readonly paramType, 
                                        string & readonly originalValue, FHIRTypedSearchParameter & readonly typedValue) 
                                                                                        returns RequestSearchParameter {
    RequestSearchParameter searchParam = {
        'type: paramType,
        name: name,
        value: originalValue,
        typedValue: typedValue
    };
    return searchParam;
}
