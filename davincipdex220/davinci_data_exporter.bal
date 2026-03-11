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

# Parameters for the `$davinci-data-export` operation.
# All fields are optional per the Da Vinci ATR IG specification.
# The operation is instance-level on Group: `POST [base]/Group/[id]/$davinci-data-export`
#
# + patient - References to specific members whose data should be exported.
# When omitted, data for all members in the Group is exported.
# + exportType - Canonical URL identifying the export type / use case.
# In the PDex payer-to-payer context use `hl7.fhir.us.davinci-pdex#payertopayer`.
# + _since - Resources updated after this instant will be included.
# Format: FHIR instant (e.g., `2024-01-01T00:00:00Z`).
# Claims and clinical data are limited to records within the past 5 years.
# + _until - Resources updated before this instant will be included.
# Format: FHIR instant.
# + _type - Comma-delimited list of FHIR resource types to include.
# When omitted, all supported resource types are exported.
# + _typeFilter - Comma-delimited list of FHIR search queries to restrict exported resources.
public type DataExportParameters record {|
    r4:Reference[] patient?;
    string exportType?;
    string _since?;
    string _until?;
    string _type?;
    string _typeFilter?;
|};

# Represents an asynchronous export job initiated by `$davinci-data-export`.
# Implementors return this to indicate the export has been accepted for processing.
#
# + contentLocation - URL for polling the export status. Returned as the
# `Content-Location` HTTP response header (per FHIR Async Request Pattern).
# + statusCode - HTTP status code for the initial kick-off response. Defaults to `202 Accepted`.
public type DataExportJob record {|
    string contentLocation;
    int statusCode = 202;
|};

# Defines an abstract Da Vinci data exporter for the `$davinci-data-export` operation.
#
# This object serves as an interface for implementing payer-to-payer bulk data export.
# The operation is instance-level on Group: `POST [base]/Group/[id]/$davinci-data-export`
# Defined in Da Vinci ATR IG (used in PDex payer-to-payer exchange):
# http://hl7.org/fhir/us/davinci-atr/OperationDefinition/davinci-data-export
public type DaVinciDataExporter isolated object {
    # Initiates a Da Vinci data export for the given Group instance.
    #
    # + groupId - The logical ID of the Group resource (from the request URL).
    # + params - Export parameters controlling member scope, date range, resource types, and output.
    # + return - A `DataExportJob` with the polling URL on success, or a `r4:FHIRError`
    # if the export cannot be initiated.
    public isolated function initiateExport(string groupId, DataExportParameters params)
            returns DataExportJob|r4:FHIRError;
};
