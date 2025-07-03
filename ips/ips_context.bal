import ballerinax/health.clients.fhir;

public isolated class IPSContext {
    // Map of FHIR service URLs to their initialized FHIR clients
    private map<fhir:FHIRConnector> fhirClients = {};

    // Map of IPS section to section config (configurable, with default per IPS IG)
    private final SectionConfig[] sectionConfigs;

    # Initializes the `IPSContext` instance with FHIR service-resource mapping, section-resource configuration, and section codes.
    #
    # + serviceResourceMap - Map of FHIR resource types to their corresponding service URLs.
    # + sectionConfigs - (optional) Array of section configuration objects for IPS sections. If not provided, defaults are used.
    # + return - An `error` if initialization fails, otherwise nil.
    public isolated function init(
            map<string> serviceResourceMap,
            SectionConfig[]? sectionConfigs = ()
    ) returns error? {
        self.sectionConfigs = sectionConfigs is SectionConfig[] ? sectionConfigs.clone() : DEFAULT_SECTION_RESOURCE_CONFIG;

        // Initialize FHIR clients for each service URL
        map<string> serviceMap = serviceResourceMap;
        foreach string resourceType in serviceMap.keys() {
            string? serviceUrl = serviceMap[resourceType];
            if serviceUrl is string {
                lock {
                    fhir:FHIRConnector fhirConnector = check new ({baseURL: serviceUrl});
                    self.fhirClients[resourceType] = fhirConnector;
                }
            }
        }
    }

    # Get the section-resource config (section to section configs)
    # + return - Map of section names to section config
    public isolated function getSectionConfigs() returns SectionConfig[] {
        lock {
            return self.sectionConfigs.cloneReadOnly();
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
}
