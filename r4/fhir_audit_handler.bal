// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).
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

import ballerina/http;
import ballerina/io;
import ballerina/time;

# Audit service integration related configuration.
#
# + enabled - enable or disable integration with audit service
# + auditServiceUrl - url of the audit service
public type AuditConfig record {|
    boolean enabled = false;
    string auditServiceUrl;
|};

# Flattened version of the FHIR AuditEvent (http://hl7.org/fhir/R4/auditevent.html).
#
# + typeCode - FHIR AuditEvent.type.code (Value Set http://hl7.org/fhir/ValueSet/audit-event-type)
# + subTypeCode - FHIR AuditEvent.subtype.code (Value Set http://hl7.org/fhir/ValueSet/audit-event-sub-type)
# + actionCode - FHIR AuditEvent.action (Value Set http://hl7.org/fhir/ValueSet/audit-event-action)
# + outcomeCode - FHIR AuditEvent.outcome (Value Set http://hl7.org/fhir/ValueSet/audit-event-outcome)
# + recordedTime - FHIR AuditEvent.recorded
# + agentType - FHIR AuditEvent.agent.type.coding.code (Value Set http://hl7.org/fhir/ValueSet/participation-role-type)
# + agentName - FHIR AuditEvent.agent.who.display
# + agentIsRequestor - FHIR AuditEvent.agent.requestor
# + sourceObserverName - FHIR AuditEvent.source.observer.display
# + sourceObserverType - FHIR AuditEvent.source.observer.type (Value Set http://hl7.org/fhir/ValueSet/audit-source-type)
# + entityType - FHIR AuditEvent.entity.type.coding.code (Value Set http://hl7.org/fhir/ValueSet/audit-entity-type)
# + entityRole - FHIR AuditEvent.entity.role.coding.code (Value Set http://hl7.org/fhir/ValueSet/object-role)
# + entityWhatReference - FHIR AuditEvent.entity.what.reference (Requested relative path - eg.: "Patient/example/_history/1")
public type InternalAuditEvent record {|
    string typeCode;
    string subTypeCode;
    string actionCode;
    string outcomeCode;
    string recordedTime;
    string agentType;
    string agentName;
    boolean agentIsRequestor;
    string sourceObserverName;
    string sourceObserverType;
    string entityType;
    string entityRole;
    string entityWhatReference;
|};

# On an error sending an audit event, this record will be used.
#
# + fhirError - error occurred while sending audit event
# + auditEvent - audit event that failed to send
public type AuditEventSendingError record {|
    FHIRError fhirError?;
    InternalAuditEvent auditEvent;
|};

# Call audit service and handle response.
#
# + auditClient - @http:Client to call audit service
# + fhirContext - context of the request
# + return - FHIRError if audit service call fails
public isolated function handleAuditEvent(http:Client auditClient, FHIRContext fhirContext) returns AuditEventSendingError? {
    FHIRUser? user = fhirContext.getFHIRUser();
    InternalAuditEvent auditEvent = {
        typeCode: "rest",
        subTypeCode: fhirContext.getInteraction().interaction.toString(),
        actionCode: getAction(fhirContext.getInteraction().interaction),
        outcomeCode: fhirContext.isInErrorState() ? "8" : "0",
        recordedTime: time:utcToString(time:utcNow()),
        agentType: "",
        agentName: user == () ? "Unknown" : (<FHIRUser>user).userID,
        agentIsRequestor: true,
        sourceObserverName: "",
        sourceObserverType: "3",
        entityType: "2",
        entityRole: "1",
        entityWhatReference: fhirContext.getRawPath()
    };

    json|http:ClientError auditRes = auditClient->post("/audits", auditEvent);
    if auditRes is http:ClientError {
        // TODO temporary adding the println as errors are not logged by ballerina log module.
        io:println(auditRes);
        return {auditEvent: auditEvent, fhirError: clientErrorToFhirError(auditRes)};
    }
    return {auditEvent: auditEvent};
}

isolated function getAction(FHIRInteractionType interaction) returns string {
    match interaction {
        READ|VREAD => {
            return "R";
        }
        CREATE => {
            return "C";
        }
        UPDATE => {
            return "U";
        }
        DELETE => {
            return "D";
        }
        _ => {
            return "E";
        }
    }
}
