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

# A Signature - XML DigSig, JWS, Graphical image of signature, etc.
#
# + id - Unique id for inter-element referencing
# + extension - Additional content defined by implementations
# + 'type - Indication of the reason the entity signed the object(s)
# + when - When the signature was created
# + who - Who signed
# + onBehalfOf - The party represented
# + targetFormat - The technical format of the signed resources
# + sigFormat - The technical format of the signature
# + data - The actual signature content (XML DigSig. JWS, picture, etc.)
@DataTypeDefinition {
    name: "Signature",
    baseType: Element,
    elements: {
        "type": {
            name: "type",
            dataType: Coding,
            min: 1,
            max: int:MAX_VALUE,
            isArray: true,
            description: "documentation | justification | citation | predecessor | successor | derived-from | depends-on | composed-of",
            valueSet: "https://hl7.org/fhir/valueset-signature-type.html"
        },
        "when": {
            name: "when",
            dataType: instant,
            min: 1,
            max: 1,
            isArray: false,
            description: "When the signature was created"
        },
        "who": {
            name: "who",
            dataType: Reference,
            min: 1,
            max: 1,
            isArray: false,
            description: "Who signed"
        },
        "onBehalfOf": {
            name: "onBehalfOf",
            dataType: Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "The party represented"
        },
        "targetFormat": {
            name: "targetFormat",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "The technical format of the signed resources"
        },
        "sigFormat": {
            name: "sigFormat",
            dataType: code,
            min: 0,
            max: 1,
            isArray: false,
            description: "The technical format of the signature"
        },
        "data": {
            name: "data",
            dataType: base64Binary,
            min: 0,
            max: 1,
            isArray: false,
            description: "The actual signature content (XML DigSig. JWS, picture, etc.)"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type Signature record {|
    *Element;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)

    Coding[] 'type;
    instant when;
    Reference who;
    Reference onBehalfOf?;
    code targetFormat?;
    code sigFormat?;
    base64Binary data?;
|};
