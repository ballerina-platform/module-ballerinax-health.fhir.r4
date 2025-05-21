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
import ballerinax/health.fhir.r4;

@test:Config {}
function testGetOperationOutcome() returns error? {
    r4:OperationOutcome operationOutcome = getOperationOutcome("This is test error message");
    test:assertEquals(operationOutcome.issue[0].severity, "error", "OperationOutcome severity is not equal to error");
    test:assertEquals(operationOutcome.issue[0].details?.text, "This is test error message", "OperationOutcome message is not equal to message");
}
