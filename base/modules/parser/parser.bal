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

import health.fhir.r4;

# Function to parse FHIR Payload into FHIR Resource model
#
# + payload - FHIR resource payload
# + targetFHIRModelType - (Optional) target model type to parse. Derived from payload if not given
# + return - returns FHIR model (Need to cast to relevant type by the caller). FHIRParseError if error ocurred
public isolated function parse(json|xml payload, typedesc<anydata>? targetFHIRModelType = ())
                                                                                    returns anydata|r4:FHIRParseError {
    return r4:parse(payload, targetFHIRModelType);
}
