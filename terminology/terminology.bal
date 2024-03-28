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

import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401 as i4;

# Function type which will be used to extend and retrieve CodeSystem or ValueSet by external source
public type TerminologyRetriever isolated function (r4:uri system, r4:code code)
                                                        returns r4:CodeSystem|r4:ValueSet|r4:FHIRError;

# Find a Code System based on the provided Id and version.
#
# + id - Id of the CodeSystem to be retrieved
# + version - Version of the CodeSystem to be retrieved and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + return - Return CodeSystem data if the request is successful, return FHIR error if no data found for the provided Id
public isolated function readCodeSystemById(string id, string? version = ()) returns r4:CodeSystem|r4:FHIRError {
    return terminologyProcessor.readCodeSystemById(id, version);
}

# Find a ValueSet for a provided Id and version.
#
# + id - Id of the Value Set to be retrieved
# + version - Version of the ValueSet to be retrieved and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + return - Return ValueSet data if the request is successful, return FHIR error if no data found for the provided Id
public isolated function readValueSetById(string id, string? version = ()) returns r4:ValueSet|r4:FHIRError {
    return terminologyProcessor.readValueSetById(id, version);
}

# Find a CodeSystem based on the provided URL and version.
#
# + url - URL of the CodeSystem to be retrieved
# + version - Version of the CodeSystem to be retrieved and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + return - Return CodeSystem data if the request is successful, return FHIR error if no data found for the provided URL
public isolated function readCodeSystemByUrl(r4:uri url, string? version = ()) returns r4:CodeSystem|r4:FHIRError {
    return terminologyProcessor.readCodeSystemByUrl(url, version);
}

# Find a ValueSet for a provided URL and version.
#
# + url - URL of the Value Set to be retrieved
# + version - Version of the ValueSet to be retrieved and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + return - Return ValueSet data if the request is successful, return FHIR error if no data found for the provided URL
public isolated function readValueSetByUrl(r4:uri url, string? version = ()) returns r4:ValueSet|r4:FHIRError {
    return terminologyProcessor.readValueSetByUrl(url, version);
}

# Search for Code systems based on the provided search parameters.
# Allowed search parameters are name, title, url, version, status and so on.
#
# + searchParameters - List of search parameters, should be passed as map of string arrays
# + return - Return array of CodeSystem data if success, return FHIR error if the request contains unsupported search parameters 
# and for any other processing errors
public isolated function searchCodeSystems(map<r4:RequestSearchParameter[]> searchParameters) returns r4:CodeSystem[]|r4:FHIRError {
    return terminologyProcessor.searchCodeSystems(searchParameters);
}

# Search for Value Sets for the provided search parameters.
# Allowed search parameters: are name, title, url, version, status and son on.
#
# + searchParameters - List of search parameters, should be passed as map of string arrays  
# + return - Return array of ValueSet data if success, return FHIR error if the request contains unsupported search parameters
# and for any other processing errors
public isolated function searchValueSets(map<r4:RequestSearchParameter[]> searchParameters) returns r4:FHIRError|r4:ValueSet[] {
    return terminologyProcessor.searchValueSets(searchParameters);
}

# Extract the respective concepts from a given CodeSystem based on the give code or Coding or CodeableConcept data.
# This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#lookup.
#
# + codeValue - Code or Coding or CodeableConcept data type value to process with the CodeSystem  
# + cs - CodeSystem record to be processed. If system parameter is not supplied, this value shoud be mandatory,  
# else this is an optional field  
# + system - System URL of the CodeSystem to be processed, if system CodeSystem(cs) is not supplied,  
# this value shoud be mandatory  
# + version - Version of the CodeSystem and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + return - Return list of Concepts if processing is successful, return FHIRError if fails
public isolated function codeSystemLookUp(r4:code|r4:Coding|r4:CodeableConcept codeValue, r4:CodeSystem? cs = (),
        r4:uri? system = (), string? version = ()) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
    return terminologyProcessor.codeSystemLookUp(codeValue, cs, system, version);
}

# Extract the respective concepts from a given ValueSet based on the give code or Coding or CodeableConcept data.
# This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#validation.
#
# + codeValue - Code or Coding or CodeableConcept data type value to process with the ValueSet  
# + vs - vs - ValueSet record to be processed. If system parameter is not supplied, this value shoud be mandatory,  
# else this is an optional field  
# + system - System URL of the ValueSet to be processed, if system ValueSet(vs) is not supplied then  
# this value shoud be mandatory  
# + version - Version of the ValueSet and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up. 
# + return - Return list of Concepts if processing is successful, return FHIRError if fails
public isolated function valueSetLookUp(r4:code|r4:Coding|r4:CodeableConcept codeValue, r4:ValueSet? vs = (),
        r4:uri? system = (), string? version = ()) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
    return terminologyProcessor.valueSetLookUp(codeValue, vs, system, version);
}

# Extract all the concepts from a given valueSet based on the given filter parameters.
# This method was implemented based on : http://hl7.org/fhir/R4/terminology-service.html#expand.
#
# + searchParameters - List of search parameters to filter concepts, should be passed as map of string arrays  
# + vs - ValueSet record to be processed. If system parameter is not supplied, this value shoud be mandatory, 
# else this is an optional field  
# + system - System URL of the ValueSet to be processed, if system ValueSet(vs) is not supplied then  
# this value shoud be mandatory
# + return - List of concepts is successful,  return FHIRError if fails
public isolated function valueSetExpansion(map<r4:RequestSearchParameter[]> searchParameters, r4:ValueSet? vs = (), r4:uri? system = ())
                                                                                        returns r4:ValueSet|r4:FHIRError {
    return terminologyProcessor.valueSetExpansion(searchParameters, vs, system);
}

# This method with compare concepts.
# This method was implemented based on: http://hl7.org/fhir/R4/terminology-service.html#subsumes.
#
# + conceptA - Concept 1  
# + conceptB - Concept 2  
# + cs - CodeSystem value  
# + system - System uri of the codeSystem  
# + version - Version of the CodeSystem and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + return - Return Values either equivalent or not-subsumed if processing is successful, FHIRError processing fails
public isolated function subsumes(r4:code|r4:Coding conceptA, r4:code|r4:Coding conceptB, r4:CodeSystem? cs = (),
        r4:uri? system = (), string? version = ()) returns i4:Parameters|r4:FHIRError {
    return terminologyProcessor.subsumes(conceptA, conceptB, cs, system, version);
}

# Create CodeableConcept data type for given code in a given system.
#
# + system - system uri of the code system or value set  
# + code - code interested  
# + version - Version of the CodeSystem and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + return - Created CodeableConcept record or FHIRError if not found
public isolated function createCodeableConcept(r4:uri system, r4:code code, string? version = ()
        ) returns r4:CodeableConcept|r4:FHIRError {
    return terminologyProcessor.createCodeableConcept(system, code, version);
}

# Create Coding data type for given code in a given system.
#
# + system - System uri of the CodeSystem or valueSet  
# + code - code interested 
# + version - Version of the CodeSystem and it should be provided with system parameter,
# if this version parameter is not supplied then the latest version of CodeSystem will picked up.
# + return - Created CodeableConcept record or FHIRError if not found
public isolated function createCoding(r4:uri system, r4:code code, string? version = ()
        ) returns r4:Coding|r4:FHIRError {
    return terminologyProcessor.createCoding(system, code, version);
}

# Add a list of new CodeSystems.
#
# + codeSystems - List CodeSystems
# + return - Return List of FHIRErrors if any
public isolated function addCodeSystems(r4:CodeSystem[] codeSystems) returns r4:FHIRError[]? {
    return terminologyProcessor.addCodeSystems(codeSystems);
}

# Add a list of new CodeSystems as a json or json array.
#
# + codeSystemJsonArray - CodeSystem data in the JSON format
# + return - Return List of FHIRErrors if any
public isolated function addCodeSystemsAsJson(json[] codeSystemJsonArray) returns r4:FHIRError[]? {
    return terminologyProcessor.addCodeSystemsAsJson(codeSystemJsonArray);
}

# Add a list of new ValueSets.
#
# + valueSets - List ValueSets in the Ballerina record format
# + return - Return List of FHIRErrors if any
public isolated function addValueSets(r4:ValueSet[] valueSets) returns r4:FHIRError[]? {
    return terminologyProcessor.addValueSets(valueSets);
}

# Add a list of new ValueSet as a json or json array.
#
# + valueSetJsonArray - Json ValueSet data in the JSON format
# + return - Return List of FHIRErrors if any
public isolated function addValueSetsAsJson(json[] valueSetJsonArray) returns r4:FHIRError[]? {
    return terminologyProcessor.addValueSetsAsJson(valueSetJsonArray);
}

# Add a new CodeSystem.
#
# + codeSystem - ValueSet to be added, data in the Ballerina record format
# + return - Return FHIRError
public isolated function addCodeSystem(r4:CodeSystem codeSystem) returns r4:FHIRError? {
    return terminologyProcessor.addCodeSystem(codeSystem);
}

# Add a new ValueSet.
#
# + valueSet - ValueSet to be added, data in the Ballerina record format
# + return - Return FHIRError
public isolated function addValueSet(r4:ValueSet valueSet) returns r4:FHIRError? {
    return terminologyProcessor.addValueSet(valueSet);
}

# Set the external terminology retriever function.
#
# + finder - Implementation of the external terminology retriever class
public isolated function setFinder(Finder finder) {
    terminologyProcessor.setFinder(finder);
}
