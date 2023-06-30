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
    map<CodeSystem> codeSystems;
    map<ValueSet> valueSets;
|};

# Record type ro represent terminology
public type Terminology TerminologyRecord;

# Terminology loader definition
public type TerminologyLoader distinct object {
    public function load() returns Terminology|FHIRError;
};

# An in-memory implementation of a terminology loader
public class InMemoryTerminologyLoader {
    *TerminologyLoader;

    private final json[] codeSystems;
    private final json[] valueSets;

    public function init(json[] codeSystems, json[] valueSets) {

        self.codeSystems = codeSystems;
        self.valueSets = valueSets;

    }

    # load terminology
    # + return - Terminology populated
    public function load() returns Terminology|FHIRError {

        map<CodeSystem> codeSystemMap = {};
        foreach json jCodeSystem in self.codeSystems {
            CodeSystem|error c = jCodeSystem.cloneWithType();
            if c is error {
                FHIRError fHIRError = createFHIRError("Error occurred while type casting json code system to CodeSystem type", ERROR,
                                                                        PROCESSING, diagnostic = c.message(), cause = c);
                log:printError(fHIRError.toBalString());
            } else {
                string key = string `${<string>c.url}|${<string>c.'version}`;
                codeSystemMap[key] = c;
            }
        }

        map<ValueSet> valueSetMap = {};
        foreach json jValueSet in self.valueSets {
            ValueSet|error v = jValueSet.cloneWithType();
            if v is error {
                FHIRError fHIRError = createFHIRError("Error occurred while type casting json value set to ValueSet type", ERROR,
                                                                        PROCESSING, diagnostic = v.message(), cause = v);
                log:printError(fHIRError.toBalString());
            } else {
                string key = string `${<string>v.url}|${<string>v.'version}`;
                valueSetMap[key] = v;
            }
        }

        Terminology terminology = {
            codeSystems: codeSystemMap,
            valueSets: valueSetMap
        };
        return terminology;
    }
}
