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

import ballerina/uuid;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

# Map CCDA DocumentReference to FHIR DocumentReference
#
# + actElement - CCDA activity element
# + parentDocument - CCDA document
# + return - FHIR DocumentReference
public isolated function ccdaToDocumentReference(xml actElement, xml parentDocument) returns uscore501:USCoreDocumentReferenceProfile? {
    if !isXMLElementNotNull(actElement) {
        return ();
    }

    uscore501:USCoreDocumentReferenceProfile documentReference = {
        resourceType: "DocumentReference",
        status: "current",
        category: [{coding: [{code: "clinical-note"}]}],
        content: [],
        subject: {},
        'type: {}
    };

    // Map identifier
    xml idElement = actElement/<v3:id|id>;
    if (idElement.length() > 0) {
        r4:Identifier[] identifiers = [];
        foreach xml id in idElement {
            r4:Identifier? identifier = mapCcdaIdToFhirIdentifier(id);
            if (identifier is r4:Identifier) {
                identifiers.push(identifier);
            }
        }
        if (identifiers.length() > 0) {
            documentReference.identifier = identifiers;
        }
    }

    // Map type
    xml codeElement = actElement/<v3:code|code>;
    if (codeElement.length() > 0) {
        r4:CodeableConcept? 'type = mapCcdaCodingToFhirCodeableConcept(codeElement, parentDocument);
        if ('type is r4:CodeableConcept) {
            documentReference.'type = 'type;
        }
    }

    // Map content
    xml textElement = actElement/<v3:text|text>;
    if (textElement.length() > 0) {
        string|error? mediaType = textElement.mediaType;
        string|error? textContent = textElement.data().trim();

        if (mediaType is string && textContent is string) {
            documentReference.content = [
                {
                    attachment: {
                        contentType: mediaType,
                        data: textContent
                    }
                }
            ];
        } else {
            xml|error? reference = textElement/<v3:reference|reference>;
            if (reference is xml) {
                string|error? value = reference.value;
                if (value is string) {
                    if value.startsWith("#") {
                        xml? referenceElement = getElementByID(parentDocument, value.substring(1));
                        if (referenceElement is xml) {
                            string content = referenceElement.data();
                            documentReference.content = [
                                {
                                    attachment: {
                                        contentType: "application/xhtml+xml",
                                        data: content
                                    }
                                }
                            ];
                        }
                    } else {
                        documentReference.content = [
                            {
                                attachment: {
                                    contentType: "application/xhtml+xml",
                                    data: value
                                }
                            }
                        ];
                    }
                }
            }
        }
    }

    // Map effectiveTime
    xml? effectiveTimeElement = actElement/<v3:effectiveTime|effectiveTime>;
    if (effectiveTimeElement is xml && effectiveTimeElement.length() > 0) {
        r4:Period? period = mapCcdaIntervalToFhirPeriod(effectiveTimeElement);
        if (period is r4:Period) {
            documentReference.context = {
                period: period
            };
        }
    }

    // Map author
    xml? authorElement = actElement/<v3:author|author>;
    if (authorElement is xml && authorElement.length() > 0) {
        r4:Reference[] authors = [];
        foreach xml author in authorElement {
            xml? assignedAuthorElement = author/<v3:assignedAuthor|assignedAuthor>;
            if (assignedAuthorElement is xml) {
                xml? assignedAuthorIdElement = assignedAuthorElement/<v3:id|id>;
                if (assignedAuthorIdElement is xml) {
                    string|error? id = assignedAuthorIdElement.extension;
                    if (id is string) {
                        authors.push({reference: string `Practitioner/${id}`});
                    }
                }
            }
        }
        if (authors.length() > 0) {
            documentReference.author = authors;
        }

        // Map author time
        xml authorTimeElement = authorElement/<v3:time|time>;
        if (authorTimeElement.length() > 0) {
            r4:dateTime? date = mapCcdaDateTimeToFhirDateTime(authorTimeElement);
            if (date is r4:dateTime) {
                documentReference.date = date;
            }
        }
    }

    // Map encounter
    xml entryRelationshipElement = actElement/<v3:entryRelationship|entryRelationship>;
    if (entryRelationshipElement.length() > 0) {
        foreach xml entryRel in entryRelationshipElement {
            string|error? typeCode = entryRel.typeCode;
            if (typeCode is string && typeCode == "COMP") {
                xml? encounterElement = entryRel/<v3:encounter|encounter>;
                if (encounterElement is xml) {
                    xml? encounterIdElement = encounterElement/<v3:id|id>;
                    if (encounterIdElement is xml) {
                        r4:Identifier? identifier = mapCcdaIdToFhirIdentifier(encounterIdElement);
                        if (identifier is r4:Identifier) {
                            if (identifier.value is string) {
                                documentReference.context = {
                                    // Base Element definition of context.encounter states that it is a list.
                                    // {
                                    //     "id": "DocumentReference.context.encounter",
                                    //     "path": "DocumentReference.context.encounter",
                                    //     "short": "Context of the document  content",
                                    //     "definition": "Describes the clinical encounter or type of care that the document content is associated with.",
                                    //     "min": 0,
                                    //     "max": "1",
                                    //     "base": {
                                    //          "path": "DocumentReference.context.encounter",
                                    //          "min": 0,
                                    //          "max": "*"
                                    //     },
                                    //     .....
                                    // }
                                    encounter: [{reference: string `Encounter/${<string>identifier.value}`}]
                                };
                            }
                        }
                    }
                }
            }
        }
    }

    // Map relatesTo
    xml referenceElement = actElement/<v3:reference|reference>;
    if (referenceElement.length() > 0) {
        xml? externalDocumentElement = referenceElement/<v3:externalDocument|externalDocument>;
        if (externalDocumentElement is xml) {
            xml? externalDocIdElement = externalDocumentElement/<v3:id|id>;
            if (externalDocIdElement is xml) {
                r4:Identifier? identifier = mapCcdaIdToFhirIdentifier(externalDocIdElement);
                if (identifier is r4:Identifier) {
                    documentReference.relatesTo = [
                        {
                            code: "replaces",
                            target: {
                                identifier: identifier
                            }
                        }
                    ];
                }
            }
        }
    }

    // Generate ID
    documentReference.id = uuid:createRandomUuid();

    return documentReference;
}
