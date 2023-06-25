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
import ballerina/test;

@test:Config {}
public function subTypingTest() returns error? {

    // The following example is a simple serialized Patient resource to parse
    json input = {
        "resourceType": "Patient",
        "name": [
            {
                "family": "Simpson"
            }
        ]
    };

    // Parse it - you can pass the input (as a string or a json) and the
    // type of the resource you want to parse.
    Patient patient = check parse(input).ensureType();
    test:assertTrue(patient is DomainResource, msg = "FHIR resource is not a Domain Resource. " +
    "Every FHIR resource should be a Domain Resource.");
}
