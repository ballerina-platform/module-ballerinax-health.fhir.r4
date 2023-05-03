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

import java.util.ArrayList;
import java.util.List;

import static io.ballerinax.fhirr4.ModuleUtils.getModule;
import static io.ballerinax.fhirr4.Utils.isPathsMatching;

/**
 * Class responsible for mapping a FHIR service to its underlying HTTP service
 */
public class HTTPToFHIRAdaptor {

    private HTTPToFHIRAdaptor(){}

    public static final StrandMetadata EXECUTE_READ_BY_ID = new StrandMetadata(getModule().getOrg(),
                                                                               getModule().getName(),
                                                                               getModule().getMajorVersion(),
                                                                               "executeReadByID");
    public static final StrandMetadata EXECUTE_SEARCH = new StrandMetadata(getModule().getOrg(),
                                                                               getModule().getName(),
                                                                               getModule().getMajorVersion(),
                                                                               "executeSearch");
    public static final StrandMetadata EXECUTE_CREATE = new StrandMetadata(getModule().getOrg(),
                                                                                   getModule().getName(),
                                                                                   getModule().getMajorVersion(),
                                                                                   "executeCreate");

    public static void addFhirServiceToHolder(BObject holder, BObject service) {
        holder.addNativeData("FHIR_SERVICE", service);
    }

    public static BObject getFhirServiceFromHolder(BObject holder) {
        return (BObject) holder.getNativeData("FHIR_SERVICE");
    }

    public static Object executeReadByID(Environment environment, BString id, BObject fhirCtx, BObject service,
                                              ResourceMethodType resourceMethod) {
        Future future = environment.markAsync();
        ExecutionCallback executionCallback = new ExecutionCallback(future);
        ServiceType serviceType = (ServiceType) service.getType();
        Type returnType = TypeCreator.createUnionType(PredefinedTypes.TYPE_ANY, PredefinedTypes.TYPE_ERROR);
        if (resourceMethod != null) {
            if (serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName())) {
                environment.getRuntime().invokeMethodAsyncConcurrently(service, resourceMethod.getName(), null,
                                                                       EXECUTE_READ_BY_ID, executionCallback,
                                                                       null, returnType, id, true, fhirCtx, true);
            } else {
                environment.getRuntime().invokeMethodAsyncSequentially(service, resourceMethod.getName(), null,
                                                                       EXECUTE_READ_BY_ID, executionCallback,
                                                                       null, returnType, id, true, fhirCtx, true);
            }
        }
        return null;
    }

    public static Object executeSearch(Environment environment, BObject fhirCtx, BObject service,
                                         ResourceMethodType resourceMethod) {
        Future future = environment.markAsync();
        ExecutionCallback executionCallback = new ExecutionCallback(future);
        ServiceType serviceType = (ServiceType) service.getType();
        Type returnType = TypeCreator.createUnionType(PredefinedTypes.TYPE_ANY, PredefinedTypes.TYPE_ERROR);
        if (resourceMethod != null) {
            if (serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName())) {
                environment.getRuntime().invokeMethodAsyncConcurrently(service, resourceMethod.getName(), null,
                                                                       EXECUTE_SEARCH, executionCallback,
                                                                       null, returnType, fhirCtx, true);
            } else {
                environment.getRuntime().invokeMethodAsyncSequentially(service, resourceMethod.getName(), null,
                                                                       EXECUTE_SEARCH, executionCallback,
                                                                       null, returnType, fhirCtx, true);
            }
        }
        return null;
    }

    public static Object executeCreate(Environment environment, BMap r4Payload, BObject fhirCtx, BObject service,
                                       ResourceMethodType resourceMethod) {
        Future future = environment.markAsync();
        ExecutionCallback executionCallback = new ExecutionCallback(future);
        ServiceType serviceType = (ServiceType) service.getType();
        Type returnType = TypeCreator.createUnionType(PredefinedTypes.TYPE_ANY, PredefinedTypes.TYPE_ERROR);
        if (resourceMethod != null) {
            if (serviceType.isIsolated() && serviceType.isIsolated(resourceMethod.getName())) {
                environment.getRuntime().invokeMethodAsyncConcurrently(service, resourceMethod.getName(), null,
                                                                       EXECUTE_CREATE, executionCallback,
                                                                       null, returnType, fhirCtx, true,
                                                                       r4Payload, true);
            } else {
                environment.getRuntime().invokeMethodAsyncSequentially(service, resourceMethod.getName(), null,
                                                                       EXECUTE_CREATE, executionCallback,
                                                                       null, returnType, fhirCtx, true,
                                                                       r4Payload, true);
            }
        }
        return null;
    }

    public static Object getResourceMethod(BObject service, BArray path, BString accessor) {
        ServiceType serviceType = (ServiceType) service.getType();
        List<String> pathList = getPathList(path);
        return getResourceMethod(serviceType, pathList, accessor.getValue());
    }

    private static List<String> getPathList(BArray pathArray) {
        List<String> result = new ArrayList<>();
        for (int i = 0; i < pathArray.size(); i++) {
            BString pathSegment = (BString) pathArray.get(i);
            result.add(pathSegment.getValue());
        }
        return result;
    }

    private static ResourceMethodType getResourceMethod(ServiceType serviceType, List<String> path, String accessor) {
        for (ResourceMethodType resourceMethod : serviceType.getResourceMethods()) {
            if (accessor.equals(resourceMethod.getAccessor()) && isPathsMatching(resourceMethod, path)) {
                return resourceMethod;
            }
        }
        return null;
    }

}
