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

import ballerina/jballerina.java;
import ballerinax/health.fhir.r4;

isolated function getResourceMethod(service object {} serviceObject, string[] servicePath, string[] path, string accessor)
    returns handle? = @java:Method {
    'class: "io.ballerinax.fhirr4.HTTPToFHIRAdaptor"
} external;

isolated function executeWithID(string id, r4:FHIRContext fhirCtx, service object {} serviceObject, handle resourceMethod)
    returns any|error = @java:Method {
    'class: "io.ballerinax.fhirr4.HTTPToFHIRAdaptor"
} external;

isolated function executeWithIDAndVID(string id, string vid, r4:FHIRContext fhirCtx, service object {} serviceObject, handle resourceMethod)
    returns any|error = @java:Method {
    'class: "io.ballerinax.fhirr4.HTTPToFHIRAdaptor"
} external;

isolated function executeWithNoParam(r4:FHIRContext fhirCtx, service object {} serviceObject, handle resourceMethod)
    returns any|error = @java:Method {
    'class: "io.ballerinax.fhirr4.HTTPToFHIRAdaptor"
} external;

isolated function executeWithPayload(anydata payload, r4:FHIRContext fhirCtx, service object {} serviceObject, handle resourceMethod)
    returns any|error = @java:Method {
    'class: "io.ballerinax.fhirr4.HTTPToFHIRAdaptor"
} external;

isolated function executeWithIDAndPayload(string id, anydata payload, r4:FHIRContext fhirCtx, service object {} serviceObject, handle resourceMethod)
    returns any|error = @java:Method {
    'class: "io.ballerinax.fhirr4.HTTPToFHIRAdaptor"
} external;

isolated function isHavingPathParam(handle resourceMethod)
    returns boolean = @java:Method {
    'class: "io.ballerinax.fhirr4.HTTPToFHIRAdaptor"
} external;
