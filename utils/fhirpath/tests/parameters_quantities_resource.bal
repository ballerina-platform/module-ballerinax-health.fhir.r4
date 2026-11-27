// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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

// FHIRPath test fixture: parameters-example-quantities (from the official FHIRPath test suite inputs)
function getParametersQuantitiesResource() returns json {
    return {"resourceType": "Parameters", "id": "example-quantities", "parameter": [{"name": "no-unit", "valueQuantity": {"value": 1}}, {"name": "no-unit-2", "valueQuantity": {"value": 1}}, {"name": "unit-text", "valueQuantity": {"value": 1, "unit": "tablets"}}, {"name": "unit-text-2", "valueQuantity": {"value": 1, "unit": "tablets"}}]};
}
