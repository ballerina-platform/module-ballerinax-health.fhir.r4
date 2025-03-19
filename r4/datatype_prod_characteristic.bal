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

# The marketing status describes the date when a medicinal product is actually put on the market or the date as of which it is no longer available.
#
# + id - Unique id for inter-element referencing  
# + extension - Additional content defined by implementations
# + modifierExtension - Extensions that cannot be ignored even if unrecognized
# + height - height can be specified using a numerical value and its unit of measurement  
# + width - width can be specified using a numerical value and its unit of measurement  
# + depth - depth can be specified using a numerical value and its unit of measurement  
# + weight - weight can be specified using a numerical value and its unit of measurement  
# + nominalValue - nominal volume can be specified using a numerical value and its unit of measurement  
# + externalDiameter - Number of sample points at each time point  
# + shape - shape can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used  
# + color - color can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used  
# + imprint - Where applicable, the imprint can be specified as text  
# + image - shape can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used  
# + scoring - the scoring can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used
@DataTypeDefinition {
    name: "ProdCharacteristic",
    baseType: BackboneElement,
    elements: {
        "height": {
            name: "height",
            dataType: Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Where applicable, the height can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used"
        },
        "width": {
            name: "width",
            dataType: Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Where applicable, the width can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used"
        },
        "depth": {
            name: "depth",
            dataType: Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Where applicable, the depth can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used"
        },
        "weight": {
            name: "weight",
            dataType: Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Where applicable, the weight can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used"
        },
        "nominalVolume": {
            name: "nominalVolume",
            dataType: Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Where applicable, the nominal volume can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used"
        },
        "externalDiameter": {
            name: "externalDiameter",
            dataType: Quantity,
            min: 0,
            max: 1,
            isArray: false,
            description: "Number of sample points at each time point"
        },
        "shape": {
            name: "shape",
            dataType: string,
            min: 0,
            max: 1,
            isArray: false,
            description: "Where applicable, the shape can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used"
        },
        "color": {
            name: "color",
            dataType: string,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Where applicable, the color can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used"
        },
        "imprint": {
            name: "imprint",
            dataType: string,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Where applicable, the imprint can be specified as text"
        },
        "image": {
            name: "image",
            dataType: Attachment,
            min: 0,
            max: int:MAX_VALUE,
            isArray: true,
            description: "Where applicable, the shape can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used"
        },
        "scoring": {
            name: "scoring",
            dataType: CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "Where applicable, the scoring can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}

public type ProdCharacteristic record {|
    *BackboneElement;
    //Inherited child element from "BackboneElement" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    Extension[] modifierExtension?;
    //Inherited child element from "BackboneElement" (Redefining to maintain order when serialize) (END)

    Quantity height?;
    Quantity width?;
    Quantity depth?;
    Quantity weight?;
    Quantity nominalValue?;
    Quantity externalDiameter?;
    string shape?;
    string color?;
    string imprint?;
    Attachment image?;
    CodeableConcept scoring?;
|};
