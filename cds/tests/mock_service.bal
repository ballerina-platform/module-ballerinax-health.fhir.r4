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

import ballerina/http;

listener http:Listener mockListener = new (9092);

service /fhir/r4 on mockListener {

    resource function get Patient/[string id]() returns json {
        if id == "593380" {
            return {
                "resourceType": "Patient",
                "id": "593380",
                "gender": "male",
                "birthDate": "1925-12-23",
                "active": true
            };
        } else {
            // Validate error case: returns OperationOutcome which is "not valid" for the prefetch expectation of a Patient or generic validation
            return {
                "resourceType": "OperationOutcome",
                "issue": []
            };
        }
    }
}

service /baseR4sd on mockListener {

    resource function get Patient/[string id]() returns http:Response {
        http:Response res = new;
        res.setTextPayload("<html>Not JSON</html>");
        res.statusCode = 200;
        return res;
    }
}
