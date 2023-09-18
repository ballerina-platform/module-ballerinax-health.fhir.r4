# FHIR Validator Package

A FHIR validator is a package designed to check the adherence of FHIR resources to the FHIR specification. Validator ensures that FHIR resources follow the defined rules, constraints, and guidelines specified in the FHIR standard.

## Package Overview

This package provides the following functionalities required for validating FHIR resource payloads against corresponding FHIR resource models.

1. Resource Parsing: The FHIR validator parses the serialized FHIR resources, which are usually in JSON format. 
2. Schema/Strucuture Validation: The validator checks whether the resource adheres to the syntactic rules and structure defined by the FHIR specification. It verifies that the resource is well-formed and properly organized.
3. Profile Validation: FHIR resources can have associated profiles that define specific rules and constraints. The validator ensures that the resource conforms to these profiles.
4. Value Domain Validation: The validator examines the values within the resource to ensure they are within acceptable ranges, formats, and constraints. For example, it might validate that a patient's gender is a valid code value.
5. Constraint Validation: The validator checks whether the resource adhere to its element cardinalities and constraints such as regex patterns, etc.
6. Error Reporting: If any validation errors are found, the validator generates detailed error reports that highlight the issues in the resource. These reports assist developers in identifying and resolving problems.

Refer [API Documentation](https://lib.ballerina.io/ballerinax/health.fhir.r4.validator) for sample usage.
