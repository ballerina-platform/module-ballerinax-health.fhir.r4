# FHIR R4 Utils PatientMatching Package

A package containing the patient matching related utility function to match new patients with the existing master patient index.

 ## Package Overview

This package provides the rule based patient matching algorithm function as the default algorithm with an extendable PatientMatcher abstract type. New Patient matching Implementations can be easily pluggable by including PatientMatcher abstract type and implementing the required methods in the new patient matching algorithm.


|                      |                      |
|----------------------|----------------------|
| FHIR version         | R4                   |
| Implementation Guide | http://hl7.org/fhir/patient-operation-match.html |

Refer [API Documentation](https://lib.ballerina.io/ballerinax/health.fhir.r4.utils/patientmatching) for sample usage.
