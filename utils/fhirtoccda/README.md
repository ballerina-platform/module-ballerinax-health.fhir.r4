# FHIR to C-CDA Mappings

This module provides functionality to transform FHIR resources to C-CDA (Consolidated Clinical Document Architecture) format using the Continuity of Care Document (CCD) template.

## Overview

The FHIR to C-CDA transformation follows the reverse mapping of the existing C-CDA to FHIR mappings, creating a bidirectional conversion system. The implementation uses the `ContinuityofCareDocumentCCD` record type as the target C-CDA document structure.

## Architecture

### Main Components

1. **`fhir_to_ccda.bal`** - Main transformation function that orchestrates the conversion
2. **`mapping_defs.bal`** - Function type definitions and mapper interface
3. **`mappings_patient.bal`** - Patient resource mapping implementation
4. **`mappings_allergy.bal`** - Allergy Intolerance resource mapping implementation
5. **`mappings_stubs.bal`** - Stub implementations for other resource mappings
6. **`datatypes.bal`** - C-CDA data type definitions
7. **`sections.bal`** - C-CDA document section definitions

### Mapping Function Types

The module defines function types for each FHIR resource to C-CDA mapping:

- `FhirToPatient` - Maps USCore Patient to C-CDA PatientRole
- `FhirToPractitioner` - Maps USCore Practitioner to C-CDA Author
- `FhirToAllergyIntolerance` - Maps USCore AllergyIntolerance to C-CDA Allergy Activity
- `FhirToCondition` - Maps USCore Condition to C-CDA Problem Concern Activity
- `FhirToImmunization` - Maps USCore Immunization to C-CDA Immunization Activity
- `FhirToMedication` - Maps USCore MedicationRequest to C-CDA Medication Activity
- `FhirToProcedure` - Maps USCore Procedure to C-CDA Procedure Activity
- `FhirToDiagnosticReport` - Maps USCore DiagnosticReport to C-CDA Diagnostic Imaging Report
- `FhirToEncounter` - Maps USCore Encounter to C-CDA Encounter Activity
- `FhirToDocumentReference` - Maps USCore DocumentReference to C-CDA Document Reference Activity

## Resource Mapping Implementations

### Patient Mapping

The patient mapping follows the specifications provided for FHIR to C-CDA transformation:

#### FHIR Patient to C-CDA PatientRole Mappings

| FHIR Field | C-CDA Element | Transform Steps |
|------------|---------------|-----------------|
| `.extension.extension (race)`<br/>`url=http://hl7.org/fhir/us/core/STU4/StructureDefinition/us-core-race` | `/patientRole/patient/raceCode`<br/>`/patientRole/patient/sdtc:raceCode` | Only one ombCategory extension goes in raceCode; other values go in sdtc:raceCode |
| `.extension.extension (ethnicity)`<br/>`url=http://hl7.org/fhir/us/core/STU4/StructureDefinition/us-core-ethnicity` | `/patientRole/patient/ethnicGroupCode`<br/>`/patientRole/patient/sdtc:ethnicGroupCode` | Only one ombCategory extension goes in ethnicGroupCode; other values go in sdtc:ethnicGroupCode |
| `.extension.extension (birth sex)`<br/>`url=http://hl7.org/fhir/us/core/STU4/StructureDefinition/us-core-birthsex` | Birth Sex | This is not in the header recordTarget in CDA |
| `.identifier` | `/patientRole/id` | CDA id ↔ FHIR identifier |
| `.name` | `/patientRole/patient/name` | CDA name ↔ FHIR name |
| `.telecom` | `/patientRole/telecom` | CDA telecom ↔ FHIR telecom |
| `.gender` | `/patientRole/patient/administrativeGenderCode` | FHIR gender → CDA administrativeGender |
| `.birthdate` | `/patientRole/patient/birthTime` | CDA ↔ FHIR Time/Dates |
| `.deceasedBoolean` | `/patientRole/patient/sdtc:deceasedInd` | If true, C-CDA also requires sdtc:deceasedTime to be present. Set its @nullFlavor="UNK" |
| `.deceasedDateTime` | `/patientRole/patient/sdtc:deceasedTime` | CDA ↔ FHIR Time/Dates<br/>When setting deceasedTime to a value, also set sdtc:deceasedInd to true. |
| `.address` | `/patientRole/addr` | CDA addr ↔ FHIR address |
| `.maritalStatus` | `/patientRole/patient/maritalStatus` | CDA coding ↔ FHIR CodeableConcept |
| `.communication.language` | `/patientRole/patient/languageCommunication/languageCode` | |
| `.communication.preferred` | `/patientRole/patient/languageCommunication/preferenceInd` | |
| `.managingOrganization` | `/patientRole/providerOrganization` | |

### Key Implementation Details

1. **Race and Ethnicity Extensions**: The implementation handles the complex mapping of race and ethnicity extensions, where only one OMB category goes to the main element and other values go to the sdtc namespace elements.

2. **Deceased Information**: When `deceasedBoolean` is true, the implementation ensures that `sdtc:deceasedTime` is present. If no `deceasedDateTime` is provided, it sets `nullFlavor="UNK"`.

3. **Date/Time Conversions**: FHIR dateTime values are converted to HL7 format (YYYYMMDDHHMMSS) for C-CDA compatibility.

4. **Gender Mapping**: FHIR gender values are mapped to C-CDA administrative gender codes using the appropriate code system.

5. **Identifier Mapping**: FHIR identifiers are mapped to C-CDA II elements with proper root and extension values.

### Allergy Intolerance Mapping

The allergy intolerance mapping implements the complete FHIR to C-CDA transformation following the provided specifications:

#### FHIR AllergyIntolerance to C-CDA Allergy Activity Mappings

| FHIR Field | C-CDA Element | Transform Steps |
|------------|---------------|-----------------|
| `.identifier` | `/id` | CDA id ↔ FHIR identifier |
| `.clinicalStatus` | `(act parent to observation) ../../statusCode`<br/>`&`<br/>`Allergy Status`<br/>`/entryRelationship/observation[code/@code="33999-4"]/value` | FHIR clinicalStatus → CDA Allergy Status Observation value |
| `.type`<br/>`&`<br/>`.category` | `/value` | FHIR type → CDA value<br/>FHIR category → CDA value |
| `.criticality` | `Criticality`<br/>`/entryRelationship/observation[code/@code="82606-5"]/value` | CDA coding ↔ FHIR CodeableConcept<br/>FHIR criticality → CDA Criticality value |
| `.code` | `/participant/participantRole/playingEntity/code` | Constraint: When FHIR concept is not a negated concept<br/>CDA coding ↔ FHIR CodeableConcept |
| `.code` | `/participant/participantRole/playingEntity/code or /value`<br/>`&`<br/>`set @negationInd="true"` | Constraint: When FHIR concept represents general negated concept (e.g. no known allergy)<br/>FHIR code → CDA No Known Allergy |
| `.encounter` | `/entryRelationship[@typeCode="REFR"]/act/id` | |
| `.onsetDateTime` | `/effectiveTime/low` | CDA ↔ FHIR Time/Dates |
| `.onsetPeriod.start` | `/effectiveTime/low` | effectiveTime/high should not be mapped from onsetPeriod |
| `.recordedDate` | `/assignedAuthor/time` | These are not necessarily the same author |
| `.recorder` | `/assignedAuthor` | CDA ↔ FHIR Provenance<br/>Time and author are not necessarily the same |
| `.note` | `Comment Activity`<br/>`/entryRelationship/act[code/@code="48767-8"]/text` | |
| `.reaction.manifestation` | `Reaction`<br/>`/entryRelationship[@typeCode="MFST"]/observation/value` | Both use SNOMED clinical findings with minor valueSet definition differences |
| `.reaction.onset` | `/effectiveTime/low` | Constraint: This should only be used in event that AlleryIntolerance.onset was not available |
| `.reaction.severity` | `Severity`<br/>`/entryRelationship[@typeCode="MFST"]/observation/entryRelationship/observation[code/@code="SEV"]/value` | FHIR severity → CDA severity value<br/>This should be nested in CDA within the respective allergic reaction observation |

#### Key Implementation Details

1. **Allergy Concern Act Structure**: The implementation creates a proper Allergy Concern Act with the correct classCode and moodCode.

2. **Clinical Status Mapping**: Maps FHIR clinicalStatus to a separate Allergy Status Observation with the appropriate LOINC code (33999-4).

3. **Criticality Observation**: Creates a separate observation for criticality using LOINC code (82606-5).

4. **Allergen Participant**: Maps the allergen code to a participant with playingEntity structure.

5. **Reaction Mapping**: Each reaction is mapped to a separate observation with proper manifestation, onset, and severity handling.

6. **Comment Activities**: Notes are mapped to comment activities with the appropriate LOINC code (48767-8).

7. **Encounter References**: Properly handles encounter references with REFR typeCode.

## Usage

### Basic Usage

```ballerina
import ballerinax/health.fhir.r4utils.fhirtoccda;

// Create FHIR resources
uscore501:USCorePatientProfile patient = {
    // ... patient data
};

r4:Resource[] fhirResources = [patient];

// Transform to C-CDA
ContinuityofCareDocumentCCD|r4:FHIRError result = fhirToCcda(fhirResources);
```

### Custom Mapper Usage

```ballerina
// Create custom mapper with specific implementations
FhirToCcdaMapper customMapper = {
    fhirToPatient: customPatientMapper,
    fhirToPractitioner: customPractitionerMapper,
    // ... other mappings
};

// Use custom mapper
ContinuityofCareDocumentCCD|r4:FHIRError result = fhirToCcda(fhirResources, customMapper);
```

## C-CDA Document Structure

The generated C-CDA document follows the Continuity of Care Document template with:

- **Header Information**: Document metadata, author, custodian, etc.
- **Record Target**: Patient information in PatientRole structure
- **Structured Body**: Clinical content organized in sections
- **Template IDs**: Proper C-CDA template identification

## Future Enhancements

1. **Complete Resource Mappings**: Implement full mappings for all FHIR resources
2. **Section Content**: Add support for mapping clinical content to C-CDA sections
3. **Validation**: Add validation for C-CDA document compliance
4. **Performance Optimization**: Optimize for large document transformations
5. **Error Handling**: Enhanced error handling and reporting

## Dependencies

- `ballerinax/health.fhir.r4` - FHIR R4 base types
- `ballerinax/health.fhir.r4.uscore501` - US Core FHIR profiles
- `ballerina/data.xmldata` - XML data handling
- `ballerina/uuid` - UUID generation

## License

Copyright (c) 2025, WSO2 LLC. Licensed under the Apache License, Version 2.0. 