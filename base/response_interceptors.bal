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
import ballerina/log;

# Response error interceptor to post-process FHIR responses
public isolated service class FHIRResponseInterceptor {
    *http:ResponseInterceptor;

    final ResourceAPIConfig apiConfig;
    private final readonly & map<SearchParamConfig> searchParamConfigMap;

    public function init(ResourceAPIConfig apiConfig) {
        self.apiConfig = apiConfig;

        map<SearchParamConfig> searchParamConfigs = {};
        // process seach parameters
        foreach SearchParamConfig item in self.apiConfig.searchParameters {
            if item.active {
                searchParamConfigs[item.name] = item;
            }
        }
        self.searchParamConfigMap = searchParamConfigs.cloneReadOnly();
    }

    remote isolated function interceptResponse(http:RequestContext ctx, http:Response res) returns http:NextService|FHIRError? {
        log:printDebug("Execute: FHIR Response Interceptor");
        FHIRContext fhirContext = check getFHIRContext(ctx);
        fhirContext.setDirection(OUT);

        check self.postProcessSearchParameters(fhirContext);

        if (fhirContext.isInErrorState()) {
            // set the proper response code
            res.statusCode = fhirContext.getErrorCode();
        }
        return getNextService(ctx);
    }

    isolated function postProcessSearchParameters(FHIRContext context) returns FHIRError? {
        map<RequestSearchParameter[]> & readonly searchParameters = context.getRequestSearchParameters();

        foreach string paramName in searchParameters.keys() {
            RequestSearchParameter[] searchParams = searchParameters.get(paramName);
            foreach RequestSearchParameter searchParam in searchParams {
                if self.searchParamConfigMap.hasKey(paramName) {
                    SearchParamConfig & readonly paramConfig = self.searchParamConfigMap.get(paramName);
                    SearchParameterPostProcessor? postProcessor = paramConfig.postProcessor;
                    if postProcessor != () {
                        FHIRSearchParameterDefinition? definition = fhirRegistry.getResourceSearchParameterByName(self.apiConfig.resourceType, paramName);
                        if definition != () {
                            check postProcessor(definition, searchParam, context);
                        }
                    }
                } else if COMMON_SEARCH_PARAMETERS.hasKey(paramName) {
                    // post process common search parameter
                    CommonSearchParameterDefinition & readonly definition = COMMON_SEARCH_PARAMETERS.get(paramName);
                    CommonSearchParameterPostProcessor? & readonly postProcessor = definition.postProcessor;
                    if postProcessor != () {
                        check postProcessor(definition, searchParam, context);
                    }
                }
            }
        }
    }
}
