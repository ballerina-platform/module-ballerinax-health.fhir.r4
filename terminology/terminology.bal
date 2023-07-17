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

import ballerinax/health.fhir.r4;

# Function type which will be used to extend and retrieve CodeSystem or ValueSet by external source
public type TerminologyRetriever isolated function (r4:uri system, r4:code code)
                                                        returns r4:CodeSystem|r4:ValueSet|r4:FHIRError;

# Function to create CodeableConcept record from given system and code
#
# + system - CodeSystem or ValueSet system uri
# + code - Selected code from the system
# + terminologyRetriever - Terminology retriever function to reteieve CodeSystem or ValueSet from external source
# + return - Created CodeableConcept or error if not found
public function createCodeableConcept(r4:uri system, r4:code code,
                            TerminologyRetriever? terminologyRetriever = ()) returns r4:CodeableConcept|r4:FHIRError {
    return r4:terminologyProcessor.createCodeableConcept(system, code, terminologyRetriever);
}

# Function to create Coding record from given system and code
#
# + system - CodeSystem or ValueSet system uri
# + code - Selected code from the system
# + terminologyRetriever - Terminology retriever function to reteieve CodeSystem or ValueSet from external source
# + return - Created Coding or error if not found
public function createCoding(r4:uri system, r4:code code,
                                    TerminologyRetriever? terminologyRetriever = ()) returns r4:Coding|r4:FHIRError {
    return r4:terminologyProcessor.createCoding(system, code, terminologyRetriever);
}
