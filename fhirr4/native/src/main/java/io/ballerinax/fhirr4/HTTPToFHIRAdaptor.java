/*
 * Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org).
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerinax.fhirr4;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Future;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.async.StrandMetadata;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.types.ResourceMethodType;
import io.ballerina.runtime.api.types.ServiceType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;

import static io.ballerinax.fhirr4.ModuleUtils.getModule;
import static io.ballerinax.fhirr4.Utils.isPathsMatching;

import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Class responsible for mapping a FHIR service to its underlying HTTP service
 */
public class HTTPToFHIRAdaptor {

    private static final String MODULE_NAME = "ballerinax/health.fhirr4";

    public static final String PATH_PARAM_IDENTIFIER = "^";
    // Special escape character used to escape the special characters in the path parameter
    public static final String SPECIAL_ESCAPE_CHAR = "\\";

    private HTTPToFHIRAdaptor(){}

    public static final StrandMetadata EXECUTE_WITH_ID = new StrandMetadata(getModule().getOrg(),
                                                                            getModule().getName(),
                                                                            getModule().getMajorVersion(),
                                                                            "executeWithID");

    public static final StrandMetadata EXECUTE_WITH_ID_AND_VID = new StrandMetadata(getModule().getOrg(),
                                                                            getModule().getName(),
                                                                            getModule().getMajorVersion(),
                                                                            "executeWithIDAndVID");

    public static final StrandMetadata EXECUTE_WITH_NO_PARAM = new StrandMetadata(getModule().getOrg(),
                                                                                  getModule().getName(),
                                                                                  getModule().getMajorVersion(),
                                                                                  "executeWithNoParam");

    public static final StrandMetadata EXECUTE_WITH_PAYLOAD = new StrandMetadata(getModule().getOrg(),
                                                                                 getModule().getName(),
                                                                                 getModule().getMajorVersion(),
                                                                                 "executeWithPayload");

    public static final StrandMetadata EXECUTE_WITH_ID_AND_PAYLOAD = new StrandMetadata(getModule().getOrg(),
                                                                                    getModule().getName(),
                                                                                    getModule().getMajorVersion(),
                                                                                    "executeWithIDAndPayload");

    public static void addFhirServiceToHolder(BObject holder, BObject service) {
        holder.addNativeData("FHIR_SERVICE", service);
    }

    public static BObject getFhirServiceFromHolder(BObject holder) {
        return (BObject) holder.getNativeData("FHIR_SERVICE");
    }

    public static Object executeWithID(Environment environment, BString id, BObject fhirCtx, BObject service,
                                              ResourceMethodType resourceMethod) {
        Future future = environment.markAsync();
        ExecutionCallback executionCallback = new ExecutionCallback(future);
        ServiceType serviceType = (ServiceType) service.getType();
        Type returnType = TypeCreator.createUnionType(PredefinedTypes.TYPE_ANY, PredefinedTypes.TYPE_ERROR);
        if (resourceMethod != null) {
            if (serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName())) {
                environment.getRuntime().invokeMethodAsyncConcurrently(service, resourceMethod.getName(), null,
                                                                       EXECUTE_WITH_ID, executionCallback,
                                                                       null, returnType, id, true, fhirCtx, true);
            } else {
                environment.getRuntime().invokeMethodAsyncSequentially(service, resourceMethod.getName(), null,
                                                                       EXECUTE_WITH_ID, executionCallback,
                                                                       null, returnType, id, true, fhirCtx, true);
            }
        }
        return null;
    }

    public static Object executeWithIDAndVID(Environment environment, BString id, BString vid, BObject fhirCtx,
                                             BObject service, ResourceMethodType resourceMethod) {
        Future future = environment.markAsync();
        ExecutionCallback executionCallback = new ExecutionCallback(future);
        ServiceType serviceType = (ServiceType) service.getType();
        Type returnType = TypeCreator.createUnionType(PredefinedTypes.TYPE_ANY, PredefinedTypes.TYPE_ERROR);
        if (resourceMethod != null) {
            if (serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName())) {
                environment.getRuntime().invokeMethodAsyncConcurrently(service, resourceMethod.getName(), null,
                                                                       EXECUTE_WITH_ID_AND_VID, executionCallback,
                                                                       null, returnType, id, true, vid, true, fhirCtx,
                                                                       true);
            } else {
                environment.getRuntime().invokeMethodAsyncSequentially(service, resourceMethod.getName(), null,
                                                                       EXECUTE_WITH_ID_AND_VID, executionCallback,
                                                                       null, returnType, id, true, vid, true, fhirCtx,
                                                                       true);
            }
        }
        return null;
    }

    public static Object executeWithNoParam(Environment environment, BObject fhirCtx, BObject service,
                                         ResourceMethodType resourceMethod) {
        Future future = environment.markAsync();
        ExecutionCallback executionCallback = new ExecutionCallback(future);
        ServiceType serviceType = (ServiceType) service.getType();
        Type returnType = TypeCreator.createUnionType(PredefinedTypes.TYPE_ANY, PredefinedTypes.TYPE_ERROR);
        if (resourceMethod != null) {
            if (serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName())) {
                environment.getRuntime().invokeMethodAsyncConcurrently(service, resourceMethod.getName(), null,
                                                                       EXECUTE_WITH_NO_PARAM, executionCallback,
                                                                       null, returnType, fhirCtx, true);
            } else {
                environment.getRuntime().invokeMethodAsyncSequentially(service, resourceMethod.getName(), null,
                                                                       EXECUTE_WITH_NO_PARAM, executionCallback,
                                                                       null, returnType, fhirCtx, true);
            }
        }
        return null;
    }

    public static Object executeWithPayload(Environment environment, BMap r4Payload, BObject fhirCtx, BObject service,
                                       ResourceMethodType resourceMethod) {
        Future future = environment.markAsync();
        ExecutionCallback executionCallback = new ExecutionCallback(future);
        ServiceType serviceType = (ServiceType) service.getType();
        Type returnType = TypeCreator.createUnionType(PredefinedTypes.TYPE_ANY, PredefinedTypes.TYPE_ERROR);
        if (resourceMethod != null) {
            if (serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName())) {
                environment.getRuntime().invokeMethodAsyncConcurrently(service, resourceMethod.getName(), null,
                                                                       EXECUTE_WITH_PAYLOAD, executionCallback,
                                                                       null, returnType, fhirCtx, true,
                                                                       r4Payload, true);
            } else {
                environment.getRuntime().invokeMethodAsyncSequentially(service, resourceMethod.getName(), null,
                                                                       EXECUTE_WITH_PAYLOAD, executionCallback,
                                                                       null, returnType, fhirCtx, true,
                                                                       r4Payload, true);
            }
        }
        return null;
    }

    public static Object executeWithIDAndPayload(Environment environment, BString id, BMap patchPayload,
                                                 BObject fhirCtx, BObject service, ResourceMethodType resourceMethod) {
        Future future = environment.markAsync();
        ExecutionCallback executionCallback = new ExecutionCallback(future);
        ServiceType serviceType = (ServiceType) service.getType();
        Type returnType = TypeCreator.createUnionType(PredefinedTypes.TYPE_ANY, PredefinedTypes.TYPE_ERROR);
        if (resourceMethod != null) {
            if (serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName())) {
                environment.getRuntime().invokeMethodAsyncConcurrently(service, resourceMethod.getName(), null,
                                          EXECUTE_WITH_ID_AND_PAYLOAD, executionCallback,null, returnType, id, true,
                                          fhirCtx, true, patchPayload, true);
            } else {
                environment.getRuntime().invokeMethodAsyncSequentially(service, resourceMethod.getName(), null,
                                          EXECUTE_WITH_ID_AND_PAYLOAD, executionCallback,null, returnType, id, true,
                                          fhirCtx, true, patchPayload, true);
            }
        }
        return null;
    }

    public static Object getResourceMethod(BObject service, BArray servicePath, BArray path, BString accessor) {
        ServiceType serviceType = (ServiceType) service.getType();
        return getResourceMethod(serviceType, servicePath.getStringArray(), path.getStringArray(), accessor.getValue());
    }

    public static Object isHavingPathParam(ResourceMethodType resourceMethod) { 
        String[] paths = resourceMethod.getResourcePath();
        for (String s : paths) {
            if (PATH_PARAM_IDENTIFIER.equals(s)) {
                return true;
            }
        }
        return false;
    }
    
    private static ResourceMethodType getResourceMethod(ServiceType serviceType, String[] servicePath, String[] path, String accessor) {        
        String isDebugEnabled = System.getenv("BAL_FHIR_SERVICE_DEBUG_ENABLED");
        if (isDebugEnabled != null && isDebugEnabled.equals("true")) {
            logDebug("Entering getResourceMethod with accessor: " + accessor +
                 ", servicePath: " + String.join("/", servicePath) +
                 ", path: " + String.join("/", path));
        }
        for (ResourceMethodType resourceMethod : serviceType.getResourceMethods()) {
            if (accessor.equalsIgnoreCase(resourceMethod.getAccessor()) && isPathsMatching(resourceMethod.getResourcePath(), servicePath, path)) {
                if (isDebugEnabled != null && isDebugEnabled.equals("true")) {
                    logDebug("Matched resource method: " + resourceMethod.getAccessor() +
                         " with path: " + String.join("/", resourceMethod.getResourcePath()));
                }
                return resourceMethod;
            }
        }
        return null;
    }

    private static String getCurrentTimestamp() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
        return OffsetDateTime.now().format(formatter);
    }

    private static void logDebug(String message) {
        System.err.println("time=" + getCurrentTimestamp() + " level=DEBUG" + 
                           " module=" + MODULE_NAME + " message=\"" + message + "\"");
    }

}
