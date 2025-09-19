# FHIR Terminology Package

A package containing utilities to perform search, read interactions on FHIR terminologies, including code systems and value sets.

## Package Overview

FHIR Terminology Package is a collection of standardized terminologies, including code systems, value sets, concept maps and other related artifacts. These packages provide a comprehensive set of codes and concepts that allow for accurate representation and exchange of healthcare data within the FHIR ecosystem.

This package provides the following functionalities required for FHIR terminology related requirements.

1. Get by Id
2. Search CodeSystems and ValueSets
3. CodeSystem-lookup - Given a code/system, or a Coding, get additional details about the concept, including definition, status, designations, and properties. One of the products of this operation is a complete decomposition of a code from a structured terminology
4. ValueSet-expand - Get the definition of a value set.
5. ValueSet-validate-code - Validate that a coded value is in the set of codes allowed by a value set.
6. CodeSystem-subsumes - Test the subsumption(The meaning of the hierarchy of concepts as represented in this resource) relationship between code/Coding A and code/Coding B given the semantics of subsumption in the underlying code system.
7. ConceptMap-translate - Translate a code from one value set to another, based on the existing value set and concept maps resources.
