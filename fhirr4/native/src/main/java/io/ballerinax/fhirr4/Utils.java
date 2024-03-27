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

import static io.ballerinax.fhirr4.HTTPToFHIRAdaptor.PATH_PARAM_IDENTIFIER;
import static io.ballerinax.fhirr4.HTTPToFHIRAdaptor.SPECIAL_ESCAPE_CHAR;

import java.util.Arrays;
import java.util.stream.Stream;

public class Utils {

    /**
     * Checks if the length of the resource path is equal to the size of the request path.
     *
     * @param resourcePaths Ballerina service's resource method path
     * @param requestPaths the list of paths of the request
     * @return {@code true} if the length of the resource path array is equal to the size of the provided list of paths,
     *         {@code false} otherwise
     */
    static boolean isPathsMatching(String[] resourcePaths, String[] servicePath, String[] requestPaths) {

        if (resourcePaths[0].equals(".") && (servicePath.length == requestPaths.length)) {
            return true;
        }

        if (servicePath.length == 0 && resourcePaths.length == requestPaths.length) {
            int count = requestPaths.length - 1;
            for (int i = resourcePaths.length - 1; i >= 0; i--) {
                if (requestPaths[count].equals(resourcePaths[i]) || (resourcePaths[i].equals(PATH_PARAM_IDENTIFIER))) {
                    if (resourcePaths[i].equals(PATH_PARAM_IDENTIFIER) && requestPaths[count].equals("_history")) {
                        break;
                    }
                    count--;
                    if (i == 0) {
                        return true;
                    }
                } else {
                    break;
                }
            }
        }

        resourcePaths = Stream.concat(Arrays.stream(servicePath), Arrays.stream(resourcePaths)).toArray(String[]::new);

        if (resourcePaths.length != requestPaths.length || requestPaths.length == 0) {
            return false;
        }
        for (int i = 0; i < resourcePaths.length; i++) {
            String value1 = resourcePaths[i].contains(SPECIAL_ESCAPE_CHAR) ? resourcePaths[i].replace(SPECIAL_ESCAPE_CHAR, "") : resourcePaths[i];
            String value2 = requestPaths[i];
            if ((!value1.equals(value2) && !value1.equals(PATH_PARAM_IDENTIFIER)) || (value1.equals(PATH_PARAM_IDENTIFIER) && value2.equals("_history"))) {
                return false;
            }
        }
        return true;
    }
}
