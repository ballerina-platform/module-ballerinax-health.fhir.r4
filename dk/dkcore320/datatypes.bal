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

// AUTO-GENERATED FILE.
// This file is auto-generated by Ballerina.

import ballerinax/health.fhir.r4;

@r4:DataTypeDefinition {
    name: "CVRIdentifier",
    baseType: (),
    elements: {

        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreCvrIdentifierUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Identifier.assigner"
        },
        "'type": {
            name: "'type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreCvrIdentifier record {|
    *r4:Identifier;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    r4:Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    r4:Period period?;
    r4:uri system;
    r4:IdentifierUse use?;
    r4:Reference assigner?;
    r4:CodeableConcept 'type?;
    string value;
|};

public enum DkCoreCvrIdentifierUse {
    CODE_DKCORECVRIDENTIFIERUSE_SECONDARY = "secondary",
    CODE_DKCORECVRIDENTIFIERUSE_TEMP = "temp",
    CODE_DKCORECVRIDENTIFIERUSE_USUAL = "usual",
    CODE_DKCORECVRIDENTIFIERUSE_OLD = "old",
    CODE_DKCORECVRIDENTIFIERUSE_OFFICIAL = "official"
};

@r4:DataTypeDefinition {
    name: "KombitOrgIdentifier",
    baseType: (),
    elements: {

        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreKombitOrgIdentifierUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Identifier.assigner"
        },
        "'type": {
            name: "'type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreKombitOrgIdentifier record {|
    *r4:Identifier;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    r4:Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    r4:Period period?;
    r4:uri system;
    r4:IdentifierUse use?;
    r4:Reference assigner?;
    r4:CodeableConcept 'type?;
    string value;
|};

public enum DkCoreKombitOrgIdentifierUse {
    CODE_DKCOREKOMBITORGIDENTIFIERUSE_SECONDARY = "secondary",
    CODE_DKCOREKOMBITORGIDENTIFIERUSE_TEMP = "temp",
    CODE_DKCOREKOMBITORGIDENTIFIERUSE_USUAL = "usual",
    CODE_DKCOREKOMBITORGIDENTIFIERUSE_OLD = "old",
    CODE_DKCOREKOMBITORGIDENTIFIERUSE_OFFICIAL = "official"
};

@r4:DataTypeDefinition {
    name: "DkCoreCprIdentifier",
    baseType: (),
    elements: {

        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreCprIdentifierUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Identifier.assigner"
        },
        "'type": {
            name: "'type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreCprIdentifier record {|
    *r4:Identifier;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    r4:Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    r4:Period period?;
    r4:uri system;
    r4:IdentifierUse use?;
    r4:Reference assigner?;
    r4:CodeableConcept 'type?;
    string value;
|};

public enum DkCoreCprIdentifierUse {
    CODE_DKCORECPRIDENTIFIERUSE_SECONDARY = "secondary",
    CODE_DKCORECPRIDENTIFIERUSE_TEMP = "temp",
    CODE_DKCORECPRIDENTIFIERUSE_USUAL = "usual",
    CODE_DKCORECPRIDENTIFIERUSE_OLD = "old",
    CODE_DKCORECPRIDENTIFIERUSE_OFFICIAL = "official"
};

@r4:DataTypeDefinition {
    name: "ProducentId",
    baseType: (),
    elements: {

        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreProducentIdUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Identifier.assigner"
        },
        "'type": {
            name: "'type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreProducentId record {|
    *r4:Identifier;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    r4:Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    r4:Period period?;
    r4:uri system;
    r4:IdentifierUse use?;
    r4:Reference assigner?;
    r4:CodeableConcept 'type?;
    string value;
|};

public enum DkCoreProducentIdUse {
    CODE_DKCOREPRODUCENTIDUSE_SECONDARY = "secondary",
    CODE_DKCOREPRODUCENTIDUSE_TEMP = "temp",
    CODE_DKCOREPRODUCENTIDUSE_USUAL = "usual",
    CODE_DKCOREPRODUCENTIDUSE_OLD = "old",
    CODE_DKCOREPRODUCENTIDUSE_OFFICIAL = "official"
};

@r4:DataTypeDefinition {
    name: "GLNIdentifier",
    baseType: (),
    elements: {

        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreGlnIdentifierUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Identifier.assigner"
        },
        "'type": {
            name: "'type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreGlnIdentifier record {|
    *r4:Identifier;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    r4:Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    r4:Period period?;
    r4:uri system;
    r4:IdentifierUse use?;
    r4:Reference assigner?;
    r4:CodeableConcept 'type?;
    string value;
|};

public enum DkCoreGlnIdentifierUse {
    CODE_DKCOREGLNIDENTIFIERUSE_SECONDARY = "secondary",
    CODE_DKCOREGLNIDENTIFIERUSE_TEMP = "temp",
    CODE_DKCOREGLNIDENTIFIERUSE_USUAL = "usual",
    CODE_DKCOREGLNIDENTIFIERUSE_OLD = "old",
    CODE_DKCOREGLNIDENTIFIERUSE_OFFICIAL = "official"
};

@r4:DataTypeDefinition {
    name: "AuthorizationIdentifier",
    baseType: (),
    elements: {

        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreAuthorizationIdentifierUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Identifier.assigner"
        },
        "'type": {
            name: "'type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreAuthorizationIdentifier record {|
    *r4:Identifier;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    r4:Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    r4:Period period?;
    r4:uri system;
    r4:IdentifierUse use?;
    r4:Reference assigner?;
    r4:CodeableConcept 'type?;
    string value;
|};

public enum DkCoreAuthorizationIdentifierUse {
    CODE_DKCOREAUTHORIZATIONIDENTIFIERUSE_SECONDARY = "secondary",
    CODE_DKCOREAUTHORIZATIONIDENTIFIERUSE_TEMP = "temp",
    CODE_DKCOREAUTHORIZATIONIDENTIFIERUSE_USUAL = "usual",
    CODE_DKCOREAUTHORIZATIONIDENTIFIERUSE_OLD = "old",
    CODE_DKCOREAUTHORIZATIONIDENTIFIERUSE_OFFICIAL = "official"
};

@r4:DataTypeDefinition {
    name: "DkCoreXeCprIdentifier",
    baseType: (),
    elements: {

        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreXEcprIdentifierUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Identifier.assigner"
        },
        "'type": {
            name: "'type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreXEcprIdentifier record {|
    *r4:Identifier;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    r4:Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    r4:Period period?;
    r4:uri system;
    r4:IdentifierUse use?;
    r4:Reference assigner?;
    r4:CodeableConcept 'type?;
    string value;
|};

public enum DkCoreXEcprIdentifierUse {
    CODE_DKCOREXECPRIDENTIFIERUSE_SECONDARY = "secondary",
    CODE_DKCOREXECPRIDENTIFIERUSE_TEMP = "temp",
    CODE_DKCOREXECPRIDENTIFIERUSE_USUAL = "usual",
    CODE_DKCOREXECPRIDENTIFIERUSE_OLD = "old",
    CODE_DKCOREXECPRIDENTIFIERUSE_OFFICIAL = "official"
};

@r4:DataTypeDefinition {
    name: "DkCoreDeCprIdentifier",
    baseType: (),
    elements: {

        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreDEcprIdentifierUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Identifier.assigner"
        },
        "'type": {
            name: "'type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreDEcprIdentifier record {|
    *r4:Identifier;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    r4:Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    r4:Period period?;
    r4:uri system;
    r4:IdentifierUse use?;
    r4:Reference assigner?;
    r4:CodeableConcept 'type?;
    string value;
|};

public enum DkCoreDEcprIdentifierUse {
    CODE_DKCOREDECPRIDENTIFIERUSE_SECONDARY = "secondary",
    CODE_DKCOREDECPRIDENTIFIERUSE_TEMP = "temp",
    CODE_DKCOREDECPRIDENTIFIERUSE_USUAL = "usual",
    CODE_DKCOREDECPRIDENTIFIERUSE_OLD = "old",
    CODE_DKCOREDECPRIDENTIFIERUSE_OFFICIAL = "official"
};

@r4:DataTypeDefinition {
    name: "SORIdentifier",
    baseType: (),
    elements: {

        "period": {
            name: "period",
            dataType: r4:Period,
            min: 0,
            max: 1,
            isArray: false,
            description: "Time period during which identifier is/was valid for use.",
            path: "Identifier.period"
        },
        "system": {
            name: "system",
            dataType: r4:uri,
            min: 1,
            max: 1,
            isArray: false,
            description: "Establishes the namespace for the value - that is, a URL that describes a set values that are unique.",
            path: "Identifier.system"
        },
        "use": {
            name: "use",
            dataType: DkCoreSorIdentifierUse,
            min: 0,
            max: 1,
            isArray: false,
            description: "The purpose of this identifier.",
            path: "Identifier.use"
        },
        "assigner": {
            name: "assigner",
            dataType: r4:Reference,
            min: 0,
            max: 1,
            isArray: false,
            description: "Organization that issued/manages the identifier.",
            path: "Identifier.assigner"
        },
        "'type": {
            name: "'type",
            dataType: r4:CodeableConcept,
            min: 0,
            max: 1,
            isArray: false,
            description: "A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.",
            path: "Identifier.type"
        },
        "value": {
            name: "value",
            dataType: string,
            min: 1,
            max: 1,
            isArray: false,
            description: "The portion of the identifier typically relevant to the user and which is unique within the context of the system.",
            path: "Identifier.value"
        }
    },
    serializers: {
        'xml: r4:complexDataTypeXMLSerializer,
        'json: r4:complexDataTypeJsonSerializer
    }
}
public type DkCoreSorIdentifier record {|
    *r4:Identifier;

    //Inherited child element from "Element" (Redefining to maintain order when serialize) (START)
    string id?;
    r4:Extension[] extension?;
    //Inherited child element from "Element" (Redefining to maintain order when serialize) (END)
    r4:Period period?;
    r4:uri system;
    r4:IdentifierUse use?;
    r4:Reference assigner?;
    r4:CodeableConcept 'type?;
    string value;
|};

public enum DkCoreSorIdentifierUse {
    CODE_DKCORESORIDENTIFIERUSE_SECONDARY = "secondary",
    CODE_DKCORESORIDENTIFIERUSE_TEMP = "temp",
    CODE_DKCORESORIDENTIFIERUSE_USUAL = "usual",
    CODE_DKCORESORIDENTIFIERUSE_OLD = "old",
    CODE_DKCORESORIDENTIFIERUSE_OFFICIAL = "official"
};

