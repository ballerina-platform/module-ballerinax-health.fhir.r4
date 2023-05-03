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

# The shelf-life and storage information for a medicinal product item or container can be described using this class.
#
# + id - Unique id for inter-element referencing  
# + extension - Additional content defined by implementations  
# + modifierExtension - Additional content defined by implementations   
# + identifier - Unique identifier for the packaged Medicinal Product  
# + 'type - This describes the shelf life, taking into account various scenarios such as shelf life of the packaged  
# + period - The shelf life time period can be specified using a numerical value for the period of time and its unit of  
# time measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology  
# The symbol and the symbol identifier shall be used  
# + specialPrecautionsForStorage - Special precautions for storage, if any, can be specified using an appropriate controlled  
# vocabulary The controlled term and the controlled term identifier shall be specified

@DataTypeDefinition {
    name: "ProductShelfLife",
    baseType: BackboneElement,
    elements: {
        "identifier": {
            name: "identifier",
            dataType: Identifier,
            min: 0,
            max: 1,
            isArray: false,
            description: "Unique identifier for the packaged Medicinal Product"
        },
        "type": {
            name: "type",
            dataType: CodeableConcept,
            min: 1,
            max: 1,
            isArray: false,
            description: "This describes the shelf life, taking into account various scenarios such as shelf life of " +
            "the packaged Medicinal Product itself, shelf life after transformation where necessary and shelf life after " +
            "the first opening of a bottle, etc. The shelf life type shall be specified using an appropriate controlled " +
            "vocabulary The controlled term and the controlled term identifier shall be specified"
        },
        "period": {
            name: "period",
            dataType: Quantity,
            min: 1,
            max: 1,
            isArray: false,
            description: "The shelf life time period can be specified using a numerical value for the period of time and " +
            "its unit of time measurement The unit of measurement shall be specified in accordance with ISO 11240 and the " +
            "resulting terminology The symbol and the symbol identifier shall be used"
        },
        "specialPrecautionsForStorage	": {
            name: "specialPrecautionsForStorage	",
            dataType: CodeableConcept,
            min: 0,
            max: int:MAX_VALUE,
            isArray: false,
            description: "Special precautions for storage, if any, can be specified using an appropriate controlled " +
            "vocabulary The controlled term and the controlled term identifier shall be specified"
        }
    },
    serializers: {
        'xml: complexDataTypeXMLSerializer,
        'json: complexDataTypeJsonSerializer
    }
}
public type ProductShelfLife record {|
    *BackboneElement;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    Extension[] modifierExtension?;
    //Inherited child element from "BackboneElement"

    Identifier identifier?;
    CodeableConcept 'type;
    Quantity period;
    CodeableConcept[] specialPrecautionsForStorage?;
|};
