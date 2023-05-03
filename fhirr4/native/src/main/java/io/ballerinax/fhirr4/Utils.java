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

import io.ballerina.runtime.api.types.ResourceMethodType;

import java.util.List;

public class Utils {

    /**
     * Checks if the length of the resource path is equal to the size of the request path.
     *
     * @param resourceMethod Ballerina service's resource method object
     * @param paths the list of paths of the request
     * @return {@code true} if the length of the resource path array is equal to the size of the provided list of paths,
     *         {@code false} otherwise
     */
    static boolean isPathsMatching(ResourceMethodType resourceMethod, List<String> paths) {
        return resourceMethod.getResourcePath().length == paths.size();
    }
}
