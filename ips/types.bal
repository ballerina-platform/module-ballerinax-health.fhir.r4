import ballerinax/health.fhir.r4;

## SectionResourceConfig
# Configuration for a single resource type within an IPS section.
#
# + resourceType - Array of FHIR resource types (e.g., "Condition", "AllergyIntolerance").
# + patientParam - The parameter name used to filter resources by patient (e.g., "patient", "subject").
# + searchParams - Optional map of search parameters to use when querying for this resource type.
public type SectionResourceConfig record {
    string resourceType;
    string patientParam = "patient";
    map<string>? searchParams = ();
};

## SectionConfig
# Configuration for an IPS section, containing all resource configs for that section.
#
# + sectionName - The IPS section name (see `IpsSectionName`).
# + sectionTitle - Human-readable title for the section.
# + resources - Array of resource configurations for this section.
public type SectionConfig record {
    IpsSectionName sectionName;
    string sectionTitle;
    SectionResourceConfig[] resources;
};

## Coding
# Represents a FHIR Coding element specific to IPS (International Patient Summary).
#
# + system - The code system URI (default: LOINC system).
# + code - The code value from the code system.
# + display - The human-readable display for the code.
#
# This type extends the standard FHIR R4 Coding and is used to represent coded concepts in IPS resources.
public type Coding record {|
    *r4:Coding;

    r4:uri system = LOINC_SYSTEM;
    r4:code code;
    string display;
|};

