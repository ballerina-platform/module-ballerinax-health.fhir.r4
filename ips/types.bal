// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

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

import ballerinax/health.fhir.r4;

# Generate an IPS (International Patient Summary) Bundle using the provided IPS Context.
#
# + patientId - The ID of the patient for whom the IPS Bundle is being generated.
# + context - The IPSContext containing all necessary data to construct the IPS Bundle.
# + return - The constructed FHIR R4 Bundle or an error if generation fails.
#
# When implementing a custom implementation for the `generateIps` function, you need to create the implementation function with the same function signature: the first parameter should be the `patientId` and the second parameter should be the `IPSContext`.
# To interact with the `IPSContext`, use the public functions in the `IPSContext` class.
#
# Refer to the documentation of the `IPSContext` class for available public functions.
public type GenerateIps isolated function (string patientId, IPSContext context) returns r4:Bundle|error;