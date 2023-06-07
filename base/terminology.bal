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

import ballerina/log;

# Holds Terminology information.
#
# + codeSystems - CodeSystems belong to the terminology
# + valueSets - ValueSets belong to the terminology
public type TerminologyRecord record {|
    readonly map<CodeSystem> codeSystems;
    readonly map<ValueSet> valueSets;
|};

# Record type ro represent terminology
public type Terminology readonly & TerminologyRecord;

# Terminology loader definition
public type TerminologyLoader distinct object {
    public function load() returns Terminology|FHIRError;
};

# An in-memory implementation of a terminology loader
public class InMemoryTerminologyLoader {
    *TerminologyLoader;
    
    final json[] codeSystems;
    final json[] valueSets;

    public function init(json[] codeSystems, json[] valueSets) {
        self.codeSystems = codeSystems;
        self.valueSets = valueSets;
    }

    # load terminology
    # + return - Terminology populated
    public function load() returns Terminology|FHIRError {
        map<CodeSystem> codeSystemMap = {};
        foreach json jCodeSystem in self.codeSystems {
            CodeSystem|error converted = jCodeSystem.cloneWithType(CodeSystem);
            if converted is error {
                FHIRError fHIRError = createFHIRError("Error occurred while type casting json code system to CodeSystem type", ERROR,
                                                                        PROCESSING, diagnostic = converted.message(), cause = converted);
                log:printError(fHIRError.toBalString());
            } else {
                codeSystemMap[<string>converted.url] = converted;
            }
        }

        map<ValueSet> valueSetMap = {};
        foreach json jValueSet in self.valueSets {
            ValueSet|error converted = jValueSet.cloneWithType(ValueSet);
            if converted is error {
                FHIRError fHIRError = createFHIRError("Error occurred while type casting json value set to ValueSet type", ERROR,
                                                                        PROCESSING, diagnostic = converted.message(), cause = converted);
                log:printError(fHIRError.toBalString());
            } else {
                valueSetMap[<string>converted.url] = converted;
            }
        }

        Terminology terminology = {
          codeSystems: codeSystemMap.cloneReadOnly(),
          valueSets: valueSetMap.cloneReadOnly()
        };
        return terminology;
    }
}
