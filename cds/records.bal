import ballerina/constraint;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;

# The response to the discovery endpoint SHALL be an object containing a list of CDS Services.
# https://cds-hooks.hl7.org/2.0/#response
#
# + services - Array of CDS hooks.
public type Services record {|
    CdsService[] services;
|};

# Defines a CDS service according to the spec - https://cds-hooks.hl7.org/2.0/#response.
#
# + hook - The hook this service should be invoked on.  
# + title - The human-friendly name of this service.  
# + description - The description of this service.
# + id - The {id} portion of the URL to this service which is available at {baseUrl }/cds -services/{id}.
# + prefetch - An object containing key/value pairs of FHIR queries that this service is requesting the CDS Client to perform and provide on each service call. The key is a string that describes the type of data being requested and the value is a string representing the FHIR query.
# + usageRequirements - Human-friendly description of any preconditions for the use of this CDS Service.
public type CdsService record {|
    Hook hook;
    string title?;
    string description;
    string id;
    map<string> prefetch?;
    string usageRequirements?;
|};

# As a specification, CDS Hooks does not prescribe a default or required set of hooks for implementers. 
# Rather, the set of hooks defined here are merely a set of common use cases that were used to aid in the creation of CDS Hooks.
#
# PATIENT_VIEW  - https://cds-hooks.hl7.org/hooks/patient-view/STU1/patient-view/
# ORDER_SIGN - https://cds-hooks.hl7.org/hooks/order-sign/STU1/order-sign/
# ORDER_SELECT - https://cds-hooks.hl7.org/hooks/order-select/STU1/order-select/
# ORDER_DISPATCH - https://cds-hooks.hl7.org/hooks/order-dispatch/STU1/order-dispatch/
# ENCOUNTER_START - https://cds-hooks.hl7.org/hooks/encounter-start/STU1/encounter-start/
# ENCOUNTER_DISCHARGE - https://cds-hooks.hl7.org/hooks/encounter-discharge/STU1/encounter-discharge/
# APPOINTMENT_BOOK - https://cds-hooks.hl7.org/hooks/appointment-book/STU1/appointment-book/
public enum Hook {
    PATIENT_VIEW = "patient-view",
    ORDER_SIGN = "order-sign",
    ORDER_SELECT = "order-select",
    ORDER_DISPATCH = "order-dispatch",
    ENCOUNTER_START = "encounter-start",
    ENCOUNTER_DISCHARGE = "encounter-discharge",
    APPOINTMENT_BOOK = "appointment-book"
};

# A CDS Client SHALL call a CDS Service by POSTing a JSON document to the service as described below.
#
# + hook - The hook this service should be invoked on.
# + hookInstance - A universally unique identifier (UUID).
# + fhirServer - The base URL of the CDS Client's FHIR server.
# + fhirAuthorization - A structure holding an OAuth 2.0 bearer access token granting the CDS Service access to FHIR resources, along with supplemental information relating to the token.
# + context - Hook-specific contextual data that the CDS service will need.
# + prefetch - The FHIR data that was prefetched by the CDS Client.
public type CdsRequest record {|
    Hook hook;
    string hookInstance;
    string fhirServer?;
    FhirAuthorization fhirAuthorization?;
    Context context;
    map<r4:DomainResource> prefetch?;
|};

# The access token is specified in the CDS Service request via the fhirAuthorization request parameter. 
# This parameter is an object that contains both the access token as well as other related information as specified below.
#
# + access_token - This is the OAuth 2.0 access token that provides access to the FHIR server.
# + token_type - Fixed value: Bearer
# + expires_in - The lifetime in seconds of the access token.
# + scope - The scopes the access token grants the CDS Service.
# + subject - The OAuth 2.0 client identifier of the CDS Service, as registered with the CDS Client's authorization server.
# + patient - If the granted SMART scopes include patient scopes (i.e. "patient/"), the access token is restricted to a specific patient. This field SHOULD be populated to identify the FHIR id of that patient.
public type FhirAuthorization record {|
    string access_token;
    string token_type = "Bearer";
    int expires_in;
    string scope;
    string subject;
    string patient?;
|};

# Describe the set of contextual data used by this hook. 
# Only data logically and necessarily associated with the purpose of this hook should be represented in context.
public type Context OrderSignContext|OrderDispatchContext|OrderSelectContext|AppointmentBookContext|EncounterStartContext|EncounterDischargeContext|PatientViewContext;

# Describe the set of contextual data used by order-sign hook.
#
# + patientId - The FHIR Patient.id of the current patient in context.
# + userId - The id of the current user. For this hook, the user is expected to be of type Practitioner or PractitionerRole. For example, PractitionerRole/123 or Practitioner/abc.
# + encounterId - The FHIR Encounter.id of the current encounter in context.
# + draftOrders - FHIR Bundle of DeviceRequest, MedicationRequest, NutritionOrder, ServiceRequest, VisionPrescription (typically with draft status).

public type OrderSignContext record {|
    string userId;
    string patientId;
    string encounterId?;
    r4:Bundle draftOrders;
|};

# Describe the set of contextual data used by order-select hook.
#
# + patientId - The FHIR Patient.id of the current patient in context.
# + userId - The id of the current user. For this hook, the user is expected to be of type Practitioner or PractitionerRole. For example, PractitionerRole/123 or Practitioner/abc.
# + encounterId - The FHIR Encounter.id of the current encounter in context.
# + draftOrders - FHIR Bundle of DeviceRequest, MedicationRequest, NutritionOrder, ServiceRequest, VisionPrescription (typically with draft status).
# + selections - field description
public type OrderSelectContext record {|
    string userId;
    string patientId;
    string encounterId?;
    string[] selections;
    r4:Bundle draftOrders;
|};

# Describe the set of contextual data used by order-dispatch hook.
#
# + patientId - The FHIR Patient.id of the current patient in context.
# + dispatchedOrders - Collection of the FHIR local references for the Request resource(s) for which fulfillment is sought E.g. ServiceRequest/123
# + performer - The FHIR local reference for the Practitioner, PractitionerRole, Organization, CareTeam, etc. who is being asked to execute the order. E.g. Practitioner/456  
# + fulfillmentTasks - DSTU2/STU3/R4/R5 - Collection of the Task instances (as objects) that provides a full description of the fulfillment request - including the timing and any constraints on fulfillment. If Tasks are provided, each will be for a separate order and SHALL reference one of the dispatched-orders.
public type OrderDispatchContext record {|
    string patientId;
    string[] dispatchedOrders;
    string performer;
    international401:Task[] fulfillmentTasks?;
|};

# Describe the set of contextual data used by appoinment-book hook.
#
# + patientId - The FHIR Patient.id of the current patient in context.
# + userId - The id of the current user. For this hook, the user is expected to be of type Practitioner or PractitionerRole. For example, PractitionerRole/123 or Practitioner/abc.
# + encounterId - The FHIR Encounter.id of the current encounter in context.
# + appointments - FHIR Bundle of Appointments in 'proposed' state.
public type AppointmentBookContext record {|
    string userId;
    string patientId;
    string encounterId?;
    international401:Appointment[] appointments;
|};

# Describe the set of contextual data used by patient-view hook.
#
# + userId - The id of the current user. For this hook, the user is expected to be of type Practitioner or PractitionerRole. For example, PractitionerRole/123 or Practitioner/abc.
# + patientId - The FHIR Patient.id of the current patient in context.
# + encounterId - The FHIR Encounter.id of the current encounter in context.
public type PatientViewContext record {|
    string userId;
    string patientId;
    string encounterId?;
|};

# Describe the set of contextual data used by encounter-start hook.
#
# + userId - The id of the current user. For this hook, the user is expected to be of type Practitioner or PractitionerRole. For example, PractitionerRole/123 or Practitioner/abc.
# + patientId - The FHIR Patient.id of the current patient in context.
# + encounterId - The FHIR Encounter.id of the current encounter in context.
public type EncounterStartContext record {|
    string userId;
    string patientId;
    string encounterId;
|};

# Describe the set of contextual data used by encounter-discharge hook.
#
# + userId - The id of the current user. For this hook, the user is expected to be of type Practitioner or PractitionerRole. For example, PractitionerRole/123 or Practitioner/abc.
# + patientId - The FHIR Patient.id of the current patient in context.
# + encounterId - The FHIR Encounter.id of the current encounter in context.
public type EncounterDischargeContext record {|
    string userId;
    string patientId;
    string encounterId;
|};

# For successful responses, CDS Services SHALL respond with a 200 HTTP response with an object containing a cards array and optionally a systemActions array as described below.
# Each card contains decision support guidance from the CDS Service. Cards are intended for display to an end user. 
# The data format of a card defines a very minimal set of required attributes with several more optional attributes to suit a variety of use cases, such as: narrative informational decision support, actionable suggestions to modify data, and links to SMART apps.
# https://cds-hooks.hl7.org/2.0/#cds-service-response
#
# + cards - Cards can provide a combination of information (for reading), suggested actions (to be applied if a user selects them), and links (to launch an app if the user selects them).
# + systemActions - An array of Actions that the CDS Service proposes to auto-apply.
public type CdsResponse record {|
    Card[] cards;
    Action[] systemActions?;
|};

# Cards can provide a combination of information (for reading), suggested actions (to be applied if a user selects them), and links (to launch an app if the user selects them).
# https://cds-hooks.hl7.org/2.0/#card-attributes
#
# + uuid - Unique identifier of the card.
# + summary - One-sentence, <140-character summary message for display to the user inside of this card.
# + detail - Optional detailed information to display; if provided MUST be represented in (GitHub Flavored) Markdown.
# + indicator - Urgency/importance of what this card conveys. Allowed values, in order of increasing urgency, are: info, warning, critical. 
# + 'source - Grouping structure for the Source of the information displayed on this card.
# + suggestions - Allows a service to suggest a set of changes in the context of the current activity.
# + selectionBehavior - Describes the intended selection behavior of the suggestions in the card. Allowed values are: at-most-one, any
# + overrideReason - Override reasons can be selected by the end user when overriding a card without taking the suggested recommendations.
# + links - Allows a service to suggest a link to an app that the user might want to run for additional information or to help guide a decision.
public type Card record {|
    string uuid?;
    @constraint:String {
        maxLength: 139
    }
    string summary;
    string detail?;
    string indicator;
    Source 'source;
    Suggestion[] suggestions?;
    string selectionBehavior?;
    r4:Coding[] overrideReason?;
    Link[] links?;
|};

# Grouping structure for the Source of the information displayed on this card. 
# The source should be the primary source of guidance for the decision support the card represents.
# https://cds-hooks.hl7.org/2.0/#source
#
# + label - A short, human-readable label to display for the source of the information displayed on this card. If a url is also specified, this MAY be the text for the hyperlink.
# + url - An optional absolute URL to load (via GET, in a browser context) when a user clicks on this link to learn more about the organization or data set that provided the information on this card.
# + icon - An absolute URL to an icon for the source of this card.
# + topic - A topic describes the content of the card by providing a high-level categorization that can be useful for filtering, searching or ordered display of related cards in the CDS client's UI.
public type Source record {|
    string label;
    r4:uri url?;
    string icon?;
    r4:Coding topic?;
|};

# Allows a service to suggest a set of changes in the context of the current activity 
# (e.g. changing the dose of a medication currently being prescribed, for the order-sign activity).
# https://cds-hooks.hl7.org/2.0/#suggestion
#
# + label - Human-readable label to display for this suggestion.
# + uuid - Unique identifier, used for auditing and logging suggestions. 
# + isRecommended - When there are multiple suggestions, allows a service to indicate that a specific suggestion is recommended from all the available suggestions on the card.
# + actions - Array of objects, each defining a suggested action. Within a suggestion, all actions are logically AND'd together, such that a user selecting a suggestion selects all of the actions within it.
public type Suggestion record {|
    string label;
    string uuid?;
    boolean isRecommended?;
    Action[] actions?;
|};

# Description.
# https://cds-hooks.hl7.org/2.0/#action
#
# + 'type - The type of action being performed. Allowed values are: create, update, delete.
# + description - Human-readable description of the suggested action MAY be presented to the end-user.
# + 'resource - A FHIR resource. 
# + resourceId - A relative reference to the relevant resource.
public type Action record {|
    ActionType 'type;
    string description;
    r4:DomainResource 'resource?;
    string resourceId?;
|};

# The type of action being performed. Allowed values are: create, update, delete.
public enum ActionType {
    CREATE = "create",
    UPDATE = "update",
    DELETE = "delete"
};

# Allows a service to suggest a link to an app that the user might want to run for additional information or to help guide a decision.
# https://cds-hooks.hl7.org/2.0/#link
#
# + label - Human-readable label to display for this link. 
# + url - URL to load (via GET, in a browser context) when a user clicks on this link. Note that this MAY be a "deep link" with context embedded in path segments, query parameters, or a hash.
# + 'type - The type of the given URL. There are two possible values for this field. A type of absolute indicates that the URL is absolute and should be treated as-is. A type of smart indicates that the URL is a SMART app launch URL and the CDS Client should ensure the SMART app launch URL is populated with the appropriate SMART launch parameters.
# + appContext - An optional field that allows the CDS Service to share information from the CDS card with a subsequently launched SMART app. The appContext field should only be valued if the link type is smart and is not valid for absolute links. The appContext field and value will be sent to the SMART app as part of the OAuth 2.0 access token response, alongside the other SMART launch parameters when the SMART app is launched.
public type Link record {|
    string label;
    r4:uri url;
    LinkType 'type;
    string appContext?;
|};

# The type of the given URL. 
# There are two possible values for this field. 
# A type of absolute indicates that the URL is absolute and should be treated as-is. 
# A type of smart indicates that the URL is a SMART app launch URL and the CDS Client should ensure the SMART app launch URL is populated with the appropriate SMART launch parameters.
public enum LinkType {
    ABSOLUTE = "absolute",
    SMART = "smart"
}

# Array of Feedback.
#
# + feedback - field description
public type Feedbacks record {|
    Feedback[] feedback;
|};

# A CDS Client provides feedback by POSTing a JSON document. 
# The feedback endpoint can be constructed from the CDS Service endpoint and a path segment of "feedback" as {baseUrl}/cds-services/{service.id}/feedback. 
# The request to the feedback endpoint SHALL be an object containing an array.
# https://cds-hooks.hl7.org/2.0/#feedback
#
# + card - The card.uuid from the CDS Hooks response. Uniquely identifies the card.
# + outcome - A value of accepted or overridden. 
# + acceptedSuggestions - An array of json objects identifying one or more of the user's AcceptedSuggestions. Required for accepted outcomes.
# + overrideReason - A json object capturing the override reason as a Coding as well as any comments entered by the user.
# + outcomeTimestamp - ISO8601 representation of the date and time in Coordinated Universal Time (UTC) when action was taken on the card, as profiled in section 5.6 of RFC3339. e.g. 1985-04-12T23:20:50.52Z
public type Feedback record {|
    string card;
    string outcome;
    AcceptedSuggestion[] acceptedSuggestions?;
    OverrideReason overrideReason?;
    r4:dateTime outcomeTimestamp;
|};

# The CDS Client can inform the service when one or more suggestions were accepted by POSTing a simple JSON object.
# https://cds-hooks.hl7.org/2.0/#suggestion-accepted
#
# + id - The card.suggestion.uuid from the CDS Hooks response. Uniquely identifies the suggestion that was accepted.
public type AcceptedSuggestion record {|
    string id;
|};

# A CDS Client can inform the service when a card was rejected by POSTing an outcome of overridden along with an overrideReason to the service's feedback endpoint.
# https://cds-hooks.hl7.org/2.0/#overridereason
#
# + reason - The Coding object representing the override reason selected by the end user. Required if user selected an override reason from the list of reasons provided in the Card (instead of only leaving a userComment).
# + userComment - The CDS Client may enable the clinician to further explain why the card was rejected with free text. That user comment may be communicated to the CDS Service as a userComment
public type OverrideReason record {|
    r4:Coding reason?;
    string userComment?;
|};

# CDS error details record.
#
# + message - Message to be added to the error.  
# + code - Http status code/ error code.  
# + cause - (optional) original error.  
# + description - Description or insight about the error that can be used to reslove the issue.
public type CdsErrorDetails record {|
    string message;
    int code;
    error? cause;
    string? description;
|};

# CDS error type
public type CdsError error<CdsErrorDetails>;
