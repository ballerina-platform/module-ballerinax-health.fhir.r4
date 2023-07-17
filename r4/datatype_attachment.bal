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

# Content in a format defined elsewhere.
# Rule: If the Attachment has data, it SHALL have a contentType.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + contentType - Mime type of the content, with charset etc. MimeType (Required) (http://hl7.org/fhir/valueset-mimetypes.html)
# + language - Human language of the content (BCP-47) Common Languages (Preferred but limited to AllLanguages) (http://hl7.org/fhir/valueset-languages.html)
# + data - Data inline, base64ed
# + url - Uri where the data can be found
# + size - Number of bytes of content (if url provided)
# + hash - Hash of the data (sha-1, base64ed)
# + title - Label to display in place of the data
# + creation - Date attachment was first created
@DataTypeDefinition {
    name: "Attachment",
    baseType: Element,
    elements: {
        "contentType": {
            name: "contentType",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "Mime type of the content, with charset etc. MimeType (Required) (http://hl7.org/fhir/valueset-mimetypes.html)",
            path: "Patient.contentType"
        },
        "language": {
            name: "language",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "Human language of the content (BCP-47) Common Languages (Preferred but limited to AllLanguages) (http://hl7.org/fhir/valueset-languages.html)",
            path: "Patient.language"
        },
        "data": {
            name: "data",
            dataType: base64Binary,
            min: 0,
            max: 1,
            isArray: false,
            description: "Data inline, base64ed",
            path: "Patient.data"
        },
        "url": {
            name: "url",
            dataType: urlType,
            min: 0,
            max: 1,
            isArray: false,
            description: "Uri where the data can be found",
            path: "Patient.url"
        },
        "size": {
            name: "size",
            dataType: unsignedInt,
            min: 0,
            max: 1,
            isArray: false,
            description: "Number of bytes of content (if url provided)",
            path: "Patient.size"
        },
        "hash": {
            name: "hash",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Hash of the data (sha-1, base64ed)",
            path: "Patient.hash"
        },
        "title": {
            name: "title",
            dataType: base64Binary,
            min: 0,
            max: 1,
            isArray: false,
            description: "Label to display in place of the data",
            path: "Patient.title"
        },
        "creation": {
            name: "creation",
            dataType: dateTime,
            min: 0,
            max: 1,
            isArray: false,
            description: "Date attachment was first created",
            path: "Patient.creation"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type Attachment record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    code contentType?;
    code language?;
    base64Binary data?;
    urlType url?;
    unsignedInt size?;
    base64Binary hash?;
    string title?;
    dateTime creation?;
|};
