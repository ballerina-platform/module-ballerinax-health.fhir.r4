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

// Constants
const PATIENT_RESOURCE = "Patient";
const PATIENT_ID_QUERY_PARAM = "_id";
const PATIENT_QUERY_PARAM = "patient";
const HISTORY = "_history";
const METADATA = "metadata";
const LOCATION_HEADER = "Location";
const SUMMARY_OPERATION = "summary";
const IPS_SECTION_CONFIG = "ipsSectionConfig";
const IPS_META_DATA = "ipsMetaData";

// FHIR interaction records
# FHIR Read interaction.
#
# + interaction - Interaction type
# + id - target resource id
public type FHIRReadInteraction record {
    *r4:FHIRInteraction;

    r4:READ interaction = r4:READ;
    string id;
};

# FHIR Search interaction.
#
# + interaction - Interaction type
# + defaultProfile - International resource URL will set as default.
public type FHIRSearchInteraction record {
    *r4:FHIRInteraction;

    r4:SEARCH interaction = r4:SEARCH;
    string defaultProfile?;
};

# FHIR Create interaction.
#
# + interaction - Interaction type
public type FHIRCreateInteraction record {
    *r4:FHIRInteraction;

    r4:CREATE interaction = r4:CREATE;
};

# FHIR Update interaction.
#
# + interaction - Interaction type
# + id - Target resource id
public type FHIRUpdateInteraction record {
    *r4:FHIRInteraction;

    r4:UPDATE interaction = r4:UPDATE;
    string id;
};

# FHIR Instance History interaction.
#
# + interaction - Interaction type
# + id - target resource id
public type FHIRInstanceHistoryInteraction record {
    *r4:FHIRInteraction;

    r4:HISTORY interaction = r4:HISTORY;
    string id;
};

# FHIR VRead interaction.
#
# + interaction - Interaction type  
# + id - target resource id  
# + vid - target version id
public type FHIRVReadInteraction record {
    *r4:FHIRInteraction;

    r4:HISTORY interaction = r4:HISTORY;
    string id;
    string vid;
};

# FHIR History interaction.
#
# + interaction - Interaction type 
public type FHIRHistoryInteraction record {
    *r4:FHIRInteraction;

    r4:HISTORY interaction = r4:HISTORY;
};

# FHIR Patch interaction.
#
# + interaction - Interaction type
# + id - Target resource id
public type FHIRPatchInteraction record {
    *r4:FHIRInteraction;

    r4:PATCH interaction = r4:PATCH;
    string id;
};

# FHIR Delete interaction.
#
# + interaction - Interaction type
# + id - Target resource id
public type FHIRDeleteInteraction record {
    *r4:FHIRInteraction;

    r4:DELETE interaction = r4:DELETE;
    string id;
};

# FHIR Capabilities interaction.
#
# + interaction - Interaction type
public type FHIRCapabilitiesInteraction record {
    *r4:FHIRInteraction;

    r4:CAPABILITIES interaction = r4:CAPABILITIES;
};

