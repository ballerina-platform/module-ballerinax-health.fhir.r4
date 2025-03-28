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
import io.ballerina.runtime.api.concurrent.StrandMetadata;
import io.ballerina.runtime.api.types.ResourceMethodType;
import io.ballerina.runtime.api.types.ServiceType;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;

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

    public static void addFhirServiceToHolder(BObject holder, BObject service) {
        holder.addNativeData("FHIR_SERVICE", service);
    }

    public static BObject getFhirServiceFromHolder(BObject holder) {
        return (BObject) holder.getNativeData("FHIR_SERVICE");
    }

    public static Object executeWithID(Environment environment, BString id, BObject fhirCtx, BObject service,
                                              ResourceMethodType resourceMethod) {
        ServiceType serviceType = (ServiceType) service.getType();
        return environment.getRuntime().callMethod(service, resourceMethod.getName(),
                new StrandMetadata(serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName()), ModuleUtils.getProperties("executeWithID")), id, fhirCtx);
    }

    public static Object executeWithIDAndVID(Environment environment, BString id, BString vid, BObject fhirCtx,
                                             BObject service, ResourceMethodType resourceMethod) {
        ServiceType serviceType = (ServiceType) service.getType();
        return environment.getRuntime().callMethod(service, resourceMethod.getName(),
                new StrandMetadata(serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName()), ModuleUtils.getProperties("executeWithIDAndVID")), id, vid, fhirCtx);
    }

    public static Object executeWithNoParam(Environment environment, BObject fhirCtx, BObject service,
                                         ResourceMethodType resourceMethod) {
        ServiceType serviceType = (ServiceType) service.getType();
        return environment.getRuntime().callMethod(service, resourceMethod.getName(),
                new StrandMetadata(serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName()), ModuleUtils.getProperties("executeWithNoParam")), fhirCtx);
    }

    public static Object executeWithPayload(Environment environment, BMap r4Payload, BObject fhirCtx, BObject service,
                                       ResourceMethodType resourceMethod) {
        ServiceType serviceType = (ServiceType) service.getType();
        return environment.getRuntime().callMethod(service, resourceMethod.getName(),
                new StrandMetadata(serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName()), ModuleUtils.getProperties("executeWithPayload")), fhirCtx, r4Payload);
    }

    public static Object executeWithIDAndPayload(Environment environment, BString id, BMap patchPayload,
                                                 BObject fhirCtx, BObject service, ResourceMethodType resourceMethod) {
        ServiceType serviceType = (ServiceType) service.getType();
        return environment.getRuntime().callMethod(service, resourceMethod.getName(), new StrandMetadata(
                serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName()), ModuleUtils.getProperties("executeWithIDAndPayload")), id, fhirCtx, patchPayload);
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
            if (isDebugEnabled != null && isDebugEnabled.equals("true")) {
                logDebug("Resource method accessor: " + resourceMethod.getAccessor() +
                     " with resource path: " + String.join("/", resourceMethod.getResourcePath()) + ", and request path: " + String.join("/",path));
            }
            if (accessor.equalsIgnoreCase(resourceMethod.getAccessor()) && isPathsMatching(resourceMethod.getResourcePath(), servicePath, path)) {
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
