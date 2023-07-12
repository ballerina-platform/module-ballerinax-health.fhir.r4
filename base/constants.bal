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

# This is the default FHIR XML namespace
public const FHIR_NAMESPACE = "http://hl7.org/fhir";

# This is the FHIR request context property name
public const FHIR_CONTEXT_PROP_NAME = "_OH_FHIR_REQUEST_CONTEXT_";

# This is the FHIR MIME type FHIR+XML
public const FHIR_MIME_TYPE_XML = "application/fhir+xml";

# This is the FHIR MIME type FHIR+JSON
public const FHIR_MIME_TYPE_JSON = "application/fhir+json";

# This is the FHIR common search parameter for profile
public const FHIR_SEARCH_PARAM_PROFILE = "_profile";

# This is the FHIR base IG name
public const FHIR_BASE_IG = "international";

# This is the regex for validating canonical URLs
const CANONICAL_REGEX = "^(https?|http)\\:\\/\\/[-a-zA-Z0-9+&@#\\/%~_!:,\\.;]*[-a-zA-Z0-9\\+&@#\\/%=~_](\\|[-a-zA-Z0-9]*)?";

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
    valueSetVersion: "version",
    filter: "filter"
};

public const TERMINOLOGY_SEARCH_DEFAULT_COUNT = 20;
public const TERMINOLOGY_SEARCH_MAXIMUM_COUNT = 300;
