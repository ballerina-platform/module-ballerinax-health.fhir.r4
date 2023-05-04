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
import ballerinax/health.fhir.r4;

# Represents a FHIR listener endpoint
public isolated class Listener {

    private final http:Listener ls;
    private final r4:ResourceAPIConfig config;
    private http:Service httpService = isolated service object {};

    public isolated function init(int port, r4:ResourceAPIConfig config) returns error? {
        self.ls = check new (port);
        self.config = config;
    }

    public isolated function 'start() returns error? {
        return self.ls.'start();
    }

    public isolated function gracefulStop() returns error? {
        return self.ls.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.ls.immediateStop();
    }

    public isolated function attach(Service fhirService, string[]|string? name = ()) returns error? {
        Holder holder = new (fhirService);
        lock {
            self.httpService = getHttpService(holder, self.config);
            check self.ls.attach(self.httpService, name.cloneReadOnly());
        }
    }

    public isolated function detach(Service fhirService) returns error? {
        lock {
            check self.ls.detach(self.httpService);
        }
    }
}
