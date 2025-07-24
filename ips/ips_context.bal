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
import ballerinax/health.clients.fhir;
import ballerinax/health.fhir.r4;

# IPSContext: Overview and Usage
#
# The `IPSContext` class encapsulates all necessary details required to generate an International Patient Summary (IPS) document for a particular patient.
#
# It serves as the central context for IPS generation, containing:
# - **Metadata**: Information about the IPS document, such as authors and custodian.
# - **Service Resource Map**: A mapping to identify which FHIR service endpoint should be used for each resource type.
# - **FHIR Clients**: A map of initialized FHIR client connectors, used to send requests and fetch resources needed for the IPS document.
# - **Section Configuration**: Configurable details for each IPS section, allowing customization per IPS Implementation Guide.
#
# By maintaining these details, `IPSContext` enables efficient and accurate generation of IPS documents, ensuring that all required patient data is retrieved and organized according to IPS standards.
public isolated class IPSContext {
    # Metadata for the IPS document
    private final IpsMetaData ipsMetaData;

    # Map of FHIR service URLs to their initialized FHIR clients
    private map<fhir:FHIRConnector> fhirClients = {};

    # Map of IPS section to section config (configurable, with default per IPS IG)
    private final IpsSectionConfig[] ipsSectionConfig;

    # Initializes the `IPSContext` instance with FHIR service-resource mapping, section-resource configuration, and section codes.
    #
    # + serviceResourceMap - Map of FHIR resource types to their corresponding service URLs.
    # + ipsMetaData - (optional) Metadata for the IPS document, including authors and custodian.
    # + ipsSectionConfig - (optional) Array of section configuration objects for IPS sections. If not provided, defaults are used.
    # + return - An `error` if initialization fails, otherwise nil.
    public isolated function init(
            map<string> serviceResourceMap,
            IpsMetaData? ipsMetaData = (),
            IpsSectionConfig[]? ipsSectionConfig = ()
    ) returns error? {
        IpsMetaData ipsMetaDataConfig;
        if ipsMetaData is IpsMetaData {
            // ips configuration is provided while initializing the IPSContext
            ipsMetaDataConfig = ipsMetaData;
        } else if ips_meta_data_config is IpsMetaData {
            // use the default ips configuration from the config file
            ipsMetaDataConfig = check ips_meta_data_config.cloneWithType();
        } else {
            return error("IPS metadata is required for IPSContext initialization");
        }

        // Validate authors and custodian references
        if !isValidAuthorReferences(ipsMetaDataConfig.authors) || !isValidCustodianReference(ipsMetaDataConfig.custodian) {
            return error("Invalid IPS metadata: authors or custodian reference is not valid");
        }
        self.ipsSectionConfig = ipsSectionConfig is IpsSectionConfig[] ? ipsSectionConfig.clone() : DEFAULT_SECTION_CONFIG;
        self.ipsMetaData = ipsMetaDataConfig.clone();

        // Initialize FHIR clients for each service URL (reuse connectors for duplicate URLs)
        map<string> serviceMap = serviceResourceMap;
        map<fhir:FHIRConnector> urlToConnector = {};
        foreach string resourceType in serviceMap.keys() {
            string? serviceUrl = serviceMap[resourceType];
            if serviceUrl is string {
                lock {
                    if urlToConnector.hasKey(serviceUrl) {
                        fhir:FHIRConnector? fhirConnector = urlToConnector[serviceUrl];
                        if fhirConnector is fhir:FHIRConnector {
                            self.fhirClients[resourceType] = fhirConnector;
                            continue; // Skip to next resource type if already initialized
                        } else {
                            _ = urlToConnector.remove(serviceUrl); // Remove invalid connector
                        }
                    }
                    fhir:FHIRConnector fhirConnector = check new ({baseURL: serviceUrl}, enableCapabilityStatementValidation = false);
                    self.fhirClients[resourceType] = fhirConnector;
                    urlToConnector[serviceUrl] = fhirConnector;
                }
            }
        }
        urlToConnector.removeAll();
    }

    # Get the section-resource config (section to section configs)
    # + return - Map of section names to section config
    public isolated function getSectionConfigs() returns IpsSectionConfig[] {
        lock {
            return self.ipsSectionConfig.cloneReadOnly();
        }
    }

    # Get the FHIR client for a given resource type.
    # + resourceType - The resource type to get the client for
    # + return - The FHIR client instance or error if not found
    public isolated function getFHIRClient(string resourceType) returns fhir:FHIRConnector|error {
        lock {
            if self.fhirClients.hasKey(resourceType) {
                fhir:FHIRConnector? clientOpt = self.fhirClients[resourceType];
                if clientOpt is fhir:FHIRConnector {
                    return clientOpt;
                }
            }
        }
        return error("FHIR client not found for service: " + resourceType);
    }

    # Returns an array of FHIR `Reference` objects for each author in the IPS metadata.
    # Each author string is wrapped as a FHIR reference.
    # + return - Array of `r4:Reference` representing the authors.
    public isolated function getIpsAuthorReferences() returns r4:Reference[] {
        lock {
            r4:Reference[] compositionAuthors = [];
	        foreach string author in self.ipsMetaData.authors {
	            compositionAuthors.push({reference: author});
	        }
	        return compositionAuthors.cloneReadOnly();
        }
    }

    # Returns a FHIR `Reference` object for the custodian organization in the IPS metadata.
    # If the custodian is not set or is empty, returns nil.
    # + return - `r4:Reference?` representing the custodian organization, or nil if not available.
    public isolated function getIpsCustodianReference() returns r4:Reference? {
        lock {
            r4:Reference? custodianRef = ();
            if self.ipsMetaData.custodian is string && self.ipsMetaData.custodian != "" {
                // Create a reference for the custodian organization
                custodianRef = {reference: self.ipsMetaData.custodian};
            }
            return custodianRef.cloneReadOnly();
        }
    }

    # Returns the metadata for the IPS document.
    # This includes the composition status, bundle identifier, title, custodian, and authors.
    # + return - `IpsMetaData` object containing metadata for the IPS document.
    public isolated function getIpsMetaData() returns IpsMetaData {
        lock {
            return self.ipsMetaData.cloneReadOnly();
        }
    }

    isolated function createFHIRConnector(string serviceUrl) returns fhir:FHIRConnector|error {
        fhir:FHIRConnector fhirConnector = check new (
            {
                baseURL: serviceUrl
            }, 
            enableCapabilityStatementValidation = false
        );
        return fhirConnector;
    }
}
