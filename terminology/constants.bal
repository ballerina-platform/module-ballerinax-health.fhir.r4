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

# This is a map of implemented search params for CodeSystems.
# These are defined as a map because to make the search process ease.
public const map<string> CODESYSTEMS_SEARCH_PARAMS = {
    _id: "id",
    name: "name",
    title: "title",
    url: "url",
    'version: "version",
    status: "status",
    system: "system",
    description: "description",
    publisher: "publisher"
};

# This is a map of implemented search params for CodeSystems.
# These are defined as a map because to make the search process ease.
public const map<string> CONCEPT_MAPS_SEARCH_PARAMS = {
    id: "id",
    name: "name",
    title: "title",
    url: "url",
    'version: "version",
    status: "status",
    publisher: "publisher"
};

# This is a map of implemented search params for ValueSets.
# These define as a map because to make the search process ease
public const map<string> VALUESETS_SEARCH_PARAMS = {
    _id: "id",
    name: "name",
    title: "title",
    url: "url",
    'version: "version",
    status: "status",
    description: "description",
    publisher: "publisher"
};

# This is a map of implemented search params for ValueSets.
# These define as a map because to make the search process ease
public const map<string> VALUESETS_EXPANSION_PARAMS = {
    url: "url",
    valueSetVersion: "valueSetVersion",
    filter: "filter",
    _offset: "_offset",
    _count: "_count"
};

public const TERMINOLOGY_SEARCH_DEFAULT_COUNT = 20;
public const TERMINOLOGY_SEARCH_MAXIMUM_COUNT = 300;
public const SEARCH_COUNT_ATTRIBUTE = "_count";
public const SEARCH_OFFSET_ATTRIBUTE = "_offset";
public const FILTER = "filter";
public const DISPLAY = "display";
public const DEFINITION = "definition";
public const OUTCOME = "outcome";
public const DEFAULT_VERSION = "0.0.0";

public enum CodeSystemSubsumption {
    EQUIVALENT = "equivalent",
    NOT_SUBSUMED = "not-subsumed",
    SUBSUMED = "subsumed",
    SUBSUMED_BY = "subsumed-by"
}
