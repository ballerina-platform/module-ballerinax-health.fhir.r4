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


# The IPS Bundle record which is used to store the International Patient Summary (IPS) data.
#
# + composition - Summary of the patient's health information.
# + patient - Patient demographic and identifier details.  
# + allergyIntolerance - Recorded allergies and intolerances.  
# + condition - Diagnosed conditions and clinical problems.  
# + device - Medical devices used by the patient.  
# + deviceUseStatement - Patient's usage of medical devices.  
# + diagnosticReport - Diagnostic test results and reports.  
# + imagingStudy - Imaging procedures like X-ray, MRI, CT.  
# + immunization - Vaccination records.  
# + mediaObservation - Clinical media like images and videos.  
# + medication - Medication details, including formulation.  
# + medicationRequest - Prescribed medication orders.  
# + medicationStatement - Patient’s medication usage history.  
# + practitioner - Healthcare provider details.  
# + practitionerRole - Roles and responsibilities of practitioners.  
# + procedure - Medical or surgical procedures performed.  
# + organization - Healthcare organizations involved in care.  
# + observationPregnancyEdd - Estimated due date of pregnancy.  
# + observationPregnancyOutcome - Pregnancy outcome details.  
# + observationPregnancyStatus - Current pregnancy status.  
# + observationAlcoholUse - Patient’s alcohol consumption data.  
# + observationTobaccoUse - Tobacco usage history and status.  
# + observationResults - General clinical observations.  
# + specimen - Collected biological specimens.  
public type IpsBundleData record {|

    CompositionUvIps composition;
    PatientUvIps patient;
    AllergyIntoleranceUvIps[] allergyIntolerance?;
    ConditionUvIps[] condition?;
    DeviceUvIps[] device?;
    DeviceUseStatementUvIps[] deviceUseStatement?;
    DiagnosticReportUvIps[] diagnosticReport?;
    ImagingStudyUvIps[] imagingStudy?;
    ImmunizationUvIps[] immunization?;
    MediaObservationUvIps[] mediaObservation?;
    MedicationIPS[] medication?;
    MedicationRequestIPS[] medicationRequest?;
    MedicationStatementIPS[] medicationStatement?;
    PractitionerUvIps[] practitioner?;
    PractitionerRoleUvIps[] practitionerRole?;
    ProcedureUvIps[] procedure?;
    OrganizationUvIps[] organization?;
    ObservationPregnancyEddUvIps[] observationPregnancyEdd?;
    ObservationPregnancyOutcomeUvIps[] observationPregnancyOutcome?;
    ObservationPregnancyStatusUvIps[] observationPregnancyStatus?;
    ObservationAlcoholUseUvIps[] observationAlcoholUse?;
    ObservationTobaccoUseUvIps[] observationTobaccoUse?;
    ObservationResultsUvIps[] observationResults?;
    SpecimenUvIps[] specimen?;
|};
