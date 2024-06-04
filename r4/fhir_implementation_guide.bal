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

# Represents FHIR Implementation Guide holding information and functionalities bound to it
public isolated class FHIRImplementationGuide {

    private final readonly & IGInfoRecord igRecord;

    public isolated function init(readonly & IGInfoRecord igRecord) {
        self.igRecord = igRecord;
    }

    public isolated function getName() returns string {
        return self.igRecord.name;
    }

    public isolated function getTerminology() returns Terminology {
        return self.igRecord.terminology;
    }

    public isolated function getProfiles() returns map<Profile> {
        return self.igRecord.profiles;
    }

    public isolated function getSearchParameters() returns map<FHIRSearchParameterDefinition[]>[] {
        return self.igRecord.searchParameters;
    }

    # Get IG FHIR operation definitions.
    #
    # + return - A map of FHIR operation definitions
    public isolated function getOperations() returns map<FHIROperationDefinition[]>? {
        return self.igRecord.operations;
    }
}

# Record to hold information about an implementation guide.
#
# + title - Name for this implementation guide (human friendly)
# + name - Name for this implementation guide (computer friendly)
# + terminology - terminology object  
# + profiles - profiles supported by the IG (key : profile uri)
# + searchParameters - search parameters defined in the IG (key: parameter name)
# + operations - operations defined in the IG (key: operation name)
public type IGInfoRecord record {|
    readonly string title;
    readonly string name;
    Terminology terminology;
    readonly & map<Profile> profiles;
    readonly & map<FHIRSearchParameterDefinition[]>[] searchParameters;
    readonly & map<FHIROperationDefinition[]> operations?;
|};
