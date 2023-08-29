# FHIR Parser Package

FHIR Parser is a package facilitates to read, validate, and convert FHIR resources among their serialized formats and structured in-memory representations.

## Package Overview

This package provides the following functionalities required for parsing FHIR resource payloads to corresponding FHIR resource models.

1. Serialization: FHIR resources can be serialized to JSON.

2. Validation: The parser performs validation checks to ensure that the parsed resource adheres to the FHIR specification's rules and constraints.

3. In-Memory Representation: The parser creates an in-memory representation of the resource as a data model from Ballerina FHIR IG packages (i.e health.fhir.r4, health.fhir.r4.uscore501, etc.).

Refer [API Documentation](https://lib.ballerina.io/ballerinax/health.fhir.r4.parser) for sample usage.
