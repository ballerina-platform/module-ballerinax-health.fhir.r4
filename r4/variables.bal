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

// AUTO-GENERATED FILE.
// This file is auto-generated by WSO2 Healthcare.


# Terminology processor instance
public final TerminologyProcessor terminologyProcessor = new();

# FHIR registry instance
public final FHIRRegistry fhirRegistry = new();

# Modifier to Search parameter compatibility mapping
final readonly & ModifierMap SEARCH_PARAM_MODIFIER_MAP = {
    modifierTypeMapping: {
        "above" : [REFERENCE, TOKEN, URI],
        "below" : [REFERENCE, TOKEN, URI],
        "code-text" : [REFERENCE, TOKEN],
        "contains" : [STRING, URI],
        "exact": [STRING],
        "identifier": [REFERENCE],
        "in": [TOKEN],
        "missing": [DATE, NUMBER, QUANTITY, REFERENCE, STRING, TOKEN, URI],
        "not": [TOKEN],
        "not-in": [REFERENCE, TOKEN],
        "of-type": [TOKEN],
        "text": [REFERENCE, TOKEN, STRING],
        "text-advanced": [REFERENCE, TOKEN]
    }
};

# Search Parameters for all resources
public final readonly & map<CommonSearchParameterDefinition> COMMON_SEARCH_PARAMETERS = {
    "_id": {
            name: "_id",
            'type: TOKEN,
            base: ["Resource"],
            expression: "Resource.id",
            default: (),
            effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
            preProcessor: (),
            postProcessor:  ()
    },
    "_lastUpdated": {
        name: "_lastUpdated",
        'type: DATE,
        base: ["Resource"],
        expression: "Resource.meta.lastUpdated",
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: (),
        postProcessor:  ()
    },
    "_tag": {
        name: "_tag",
        'type: TOKEN,
        base: ["Resource"],
        expression: "Resource.meta.tag",
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: (),
        postProcessor:  ()
    },
    "_profile": {
        name: "_profile",
        'type: URI,
        base: ["Resource"],
        expression: "Resource.meta.profile",
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: _profileSearchParamPreProcessor,
        postProcessor:  ()
    },
    "_security": {
        name: "_security",
        'type: TOKEN,
        base: ["Resource"],
        expression: "Resource.meta.security",
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: (),
        postProcessor:  ()
    },
    "_source": {
        name: "_source",
        'type: URI,
        base: ["Resource"],
        expression: "Resource.meta.source",
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: (),
        postProcessor:  ()
    },
    "_text": {
        name: "_text",
        'type: STRING,
        base: ["DomainResource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: (),
        postProcessor:  ()
    },
    "_content": {
        name: "_content",
        'type: STRING,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: (),
        postProcessor:  ()
    },
    "_list": {
        name: "_list",
        'type: TOKEN,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: (),
        postProcessor:  ()
    },
    "_has": {
        name: "_has",
        'type: COMPOSITE,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: (),
        postProcessor:  ()
    },
    "_type": {
        name: "_type",
        'type: TOKEN,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_RESOURCE_COMMON,
        preProcessor: (),
        postProcessor:  ()
    }
};

# Search Parameter to control search results
public final readonly & map<CommonSearchParameterDefinition> CONTROL_SEARCH_PARAMETERS = {
    "_sort": {
        name: "_sort",
        'type: STRING,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_SEARCH_RESULT,
        preProcessor: (),
        postProcessor:  ()
    },
    "_count": {
        name: "_count",
        'type: NUMBER,
        base: ["Resource"],
        expression: (),
        default: 10,
        effectiveLevel: SEARCH_PARAM_CATEGORY_SEARCH_RESULT,
        preProcessor: paginationSearchParamPreProcessor,
        postProcessor: paginationSearchParamPostProcessor
    },
    "_offset": {
        name: "_offset",
        'type: NUMBER,
        base: ["Resource"],
        expression: (),
        default: 0,
        effectiveLevel: SEARCH_PARAM_CATEGORY_SEARCH_RESULT,
        preProcessor: paginationSearchParamPreProcessor,
        postProcessor: paginationSearchParamPostProcessor
    },
    "_include": {
        name: "_include",
        'type: TOKEN,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_SEARCH_RESULT,
        preProcessor: (),
        postProcessor:  ()
    },
    "_revinclude": {
        name: "_revinclude",
        'type: TOKEN,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_SEARCH_RESULT,
        preProcessor: (),
        postProcessor:  ()
    },
    "_summary": {
        name: "_summary",
        'type: TOKEN,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_SEARCH_RESULT,
        preProcessor: (),
        postProcessor:  ()
    },
    "_elements": {
        name: "_elements",
        'type: STRING,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_SEARCH_RESULT,
        preProcessor: (),
        postProcessor:  ()
    },
    "_contained": {
        name: "_contained",
        'type: TOKEN,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_SEARCH_RESULT,
        preProcessor: (),
        postProcessor:  ()
    },
    "_containedType": {
        name: "_containedType",
        'type: TOKEN,
        base: ["Resource"],
        expression: (),
        default: (),
        effectiveLevel: SEARCH_PARAM_CATEGORY_SEARCH_RESULT,
        preProcessor: (),
        postProcessor:  ()
    }
};

public json[] FHIR_VALUE_SETS = [];
public json[] FHIR_CODE_SYSTEMS = [];
