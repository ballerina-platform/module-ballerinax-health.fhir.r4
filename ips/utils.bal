import ballerinax/health.fhir.r4;

# Construct the IPS Bundle from the given IPS Bundle data.
#
# + bundleData - Record to store the IPS Bundle data.
# + return - Constructed IPS Bundle.
public isolated function getIpsBundle(IpsBundleData bundleData) returns r4:Bundle {
    r4:Bundle bundle = {'type: "document"};
    r4:BundleEntry[] entries = [];
    entries.push(getBundleEntry(bundleData.composition));
    entries.push(getBundleEntry(bundleData.patient));
    if (bundleData.allergyIntolerance is AllergyIntoleranceUvIps[]) {
        foreach var allergyIntolerance in <AllergyIntoleranceUvIps[]>bundleData.allergyIntolerance {
            entries.push(getBundleEntry(allergyIntolerance));
        }
    }
    if (bundleData.condition is ConditionUvIps[]) {
        foreach var condition in <ConditionUvIps[]>bundleData.condition {
            entries.push(getBundleEntry(condition));
        }
    }
    if (bundleData.device is DeviceUvIps[]) {
        foreach var device in <DeviceUvIps[]>bundleData.device {
            entries.push(getBundleEntry(device));
        }
    }
    if (bundleData.deviceUseStatement is DeviceUseStatementUvIps[]) {
        foreach var deviceUseStatement in <DeviceUseStatementUvIps[]>bundleData.deviceUseStatement {
            entries.push(getBundleEntry(deviceUseStatement));
        }
    }
    if (bundleData.diagnosticReport is DiagnosticReportUvIps[]) {
        foreach var diagnosticReport in <DiagnosticReportUvIps[]>bundleData.diagnosticReport {
            entries.push(getBundleEntry(diagnosticReport));
        }
    }
    if (bundleData.imagingStudy is ImagingStudyUvIps[]) {
        foreach var imagingStudy in <ImagingStudyUvIps[]>bundleData.imagingStudy {
            entries.push(getBundleEntry(imagingStudy));
        }
    }
    if (bundleData.immunization is ImmunizationUvIps[]) {
        foreach var immunization in <ImmunizationUvIps[]>bundleData.immunization {
            entries.push(getBundleEntry(immunization));
        }
    }
    if (bundleData.mediaObservation is MediaObservationUvIps[]) {
        foreach var mediaObservation in <MediaObservationUvIps[]>bundleData.mediaObservation {
            entries.push(getBundleEntry(mediaObservation));
        }
    }
    if (bundleData.medication is MedicationIPS[]) {
        foreach var medication in <MedicationIPS[]>bundleData.medication {
            entries.push(getBundleEntry(medication));
        }
    }
    if (bundleData.medicationRequest is MedicationRequestIPS[]) {
        foreach var medicationRequest in <MedicationRequestIPS[]>bundleData.medicationRequest {
            entries.push(getBundleEntry(medicationRequest));
        }
    }
    if (bundleData.medicationStatement is MedicationStatementIPS[]) {
        foreach var medicationStatement in <MedicationStatementIPS[]>bundleData.medicationStatement {
            entries.push(getBundleEntry(medicationStatement));
        }
    }
    if (bundleData.practitioner is PractitionerUvIps[]) {
        foreach var practitioner in <PractitionerUvIps[]>bundleData.practitioner {
            entries.push(getBundleEntry(practitioner));
        }
    }
    if (bundleData.practitionerRole is PractitionerRoleUvIps[]) {
        foreach var practitionerRole in <PractitionerRoleUvIps[]>bundleData.practitionerRole {
            entries.push(getBundleEntry(practitionerRole));
        }
    }
    if (bundleData.procedure is ProcedureUvIps[]) {
        foreach var procedure in <ProcedureUvIps[]>bundleData.procedure {
            entries.push(getBundleEntry(procedure));
        }
    } 
    if (bundleData.organization is OrganizationUvIps[]) {
        foreach var organization in <OrganizationUvIps[]>bundleData.organization {
            entries.push(getBundleEntry(organization));
        }
    }
    if (bundleData.observationPregnancyEdd is ObservationPregnancyEddUvIps[]) {
        foreach var observationPregnancyEdd in <ObservationPregnancyEddUvIps[]>bundleData.observationPregnancyEdd {
            entries.push(getBundleEntry(observationPregnancyEdd));
        }
    }
    if (bundleData.observationPregnancyOutcome is ObservationPregnancyOutcomeUvIps[]) {
        foreach var observationPregnancyOutcome in <ObservationPregnancyOutcomeUvIps[]>bundleData.observationPregnancyOutcome {
            entries.push(getBundleEntry(observationPregnancyOutcome));
        }
    }
    if (bundleData.observationPregnancyStatus is ObservationPregnancyStatusUvIps[]) {
        foreach var observationPregnancyStatus in <ObservationPregnancyStatusUvIps[]>bundleData.observationPregnancyStatus {
            entries.push(getBundleEntry(observationPregnancyStatus));
        }
    }
    if (bundleData.observationAlcoholUse is ObservationAlcoholUseUvIps[]) {
        foreach var observationAlcoholUse in <ObservationAlcoholUseUvIps[]>bundleData.observationAlcoholUse {
            entries.push(getBundleEntry(observationAlcoholUse));
        }
    }
    if (bundleData.observationTobaccoUse is ObservationTobaccoUseUvIps[]) {
        foreach var observationTobaccoUse in <ObservationTobaccoUseUvIps[]>bundleData.observationTobaccoUse {
            entries.push(getBundleEntry(observationTobaccoUse));
        }
    }
    if (bundleData.observationResults is ObservationResultsUvIps[]) {
        foreach var observationResults in <ObservationResultsUvIps[]>bundleData.observationResults {
            entries.push(getBundleEntry(observationResults));
        }
    }
    if (bundleData.specimen is SpecimenUvIps[]) {
        foreach var specimen in <SpecimenUvIps[]>bundleData.specimen {
            entries.push(getBundleEntry(specimen));
        }
    }
    bundle.entry = entries;
    return bundle;
}

isolated function getBundleEntry(r4:Resource 'resource) returns r4:BundleEntry {
    r4:BundleEntry entry = {};
    entry.'resource = 'resource;
    return entry;
}
