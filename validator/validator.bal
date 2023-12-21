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

import ballerina/constraint;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.parser;
import ballerina/lang.regexp;

# This method will validate FHIR resource.
# Validation consist of Structure, cardinality, Value domain, Profile, json.
#
# + data - FHIR resource (can be in json or anydata)
# + targetFHIRModelType - (Optional) target model type to validate. Derived from payload if not given
# + return - If the validation fails, return validation error
public isolated function validate(json|anydata data, typedesc<anydata>? targetFHIRModelType = ()) returns r4:FHIRValidationError? {

    anydata finalData;

    if data is json {
        anydata|r4:FHIRParseError parsedResult = parser:parse(data, targetFHIRModelType);

        if parsedResult is r4:FHIRParseError {
            string[] errors = parseFHIRParserErrors(parsedResult.message());
            return <r4:FHIRValidationError>r4:createFHIRError("FHIR resource validation failed", r4:ERROR, r4:INVALID, parsedResult.message(),
                                                errorType = r4:VALIDATION_ERROR, cause = parsedResult, parsedErrors = errors);
        } else {
            finalData = parsedResult;
        }
    } else {
        finalData = data;
    }

    // Get the types of the FHIR resources, it can be international or any specific FHIR profiles like Uscore
    typedesc<anydata> typeDescOfData = typeof finalData;

    anydata|constraint:Error validationResult = constraint:validate(finalData, typeDescOfData);

    if validationResult is constraint:Error {
        string[] errors = parseConstraintErrors(validationResult.message());
        return <r4:FHIRValidationError>r4:createFHIRError("FHIR resource validation failed",r4:ERROR, r4:INVALID, validationResult.message(),
                                                errorType = r4:VALIDATION_ERROR, cause = validationResult, parsedErrors = errors);
    }

}

# This method will validate parsed FHIR resource.
# Validation consist of Structure, cardinality, Value domain, Profile.
# This is only for internal use.
#
# + data - parsed FHIR resource
# + return - If the validation fails, return validation error
isolated function validateFhirResource(anydata data) returns r4:FHIRValidationError? {
    return validate(data);
}


isolated function parseConstraintErrors(string message) returns string[] {

    string[] errors=[];

    string:RegExp regex = re `\n`;
    string[] data = regex.split(message);
  
    //Parsing for dateTime errors.
    foreach var i in 0...data.length()-1 {
        regexp:Groups[] invalidDates = re `\$\.(\w+):pattern`.findAllGroups(data[i]);
        foreach regexp:Groups result in invalidDates {
            if result is regexp:Groups {
                regexp:Span? value = result[1];
                if value !is () {
                errors.push("Invalid pattern (constraint) for field '"+ value.substring()+"'");
                }
            }
        }
    }

   return errors;
}

isolated function parseFHIRParserErrors(string message) returns string[]{

    string[] errors=[];

    //Removes related content if fhir multitype scenario is present so that it can be styled differently
    //The regex searches for a '{' enclosed within \n tags which signifies the start of multitype error.
    string:RegExp regex1 = re `\n\s*\{[\s\S]*`;
    string editedMessage =  regex1.replace(message, "");


   

    string:RegExp regex2 = re `\n`;
    string[] data = regex2.split(editedMessage);
  
    foreach var i in 0...data.length()-1 {
        

        //Parsing for resource Type
        regexp:Groups? resourceType = re `Failed to find FHIR profile for the resource type`.findGroups(data[i]);
        if resourceType is regexp:Groups {
            errors.push("Resource type is invalid");
        }

        //Parsing for missing fields
        regexp:Groups? missingFieldsData = re `missing required field '([^']+)'`.findGroups(data[i]);
        if missingFieldsData is regexp:Groups {
            regexp:Span? value = missingFieldsData[1];
            if value !is () {
                errors.push("Missing required field '" + value.substring() + "'");
    
            }
        }
        
        //Parsing for missing elements(if resourcetype is msiisng)
        regexp:Groups? missingElementsData = re `missing required element: "([^""]+)"`.findGroups(data[i]);
        if missingElementsData is regexp:Groups {
            regexp:Span? value = missingElementsData[1];
            if value !is () {
                errors.push("Missing required Element: '"+ value.substring()+ "'");
            }
        }

        //Parsing for Invalid fields
        regexp:Groups? invalidFieldData = re `value of field '([^']+)'`.findGroups(data[i]);
        if invalidFieldData is regexp:Groups {
            string fieldName="";
            string fieldData="";
            regexp:Span? value = invalidFieldData[1];
            if value !is () {
                fieldName = "Invalid field '"+ value.substring() + "'";
            }
            //To get the expected type from the error message
            regexp:Groups? expectedDataFormat = re `should be of type '([^']+)'`.findGroups(data[i]);
            if expectedDataFormat is regexp:Groups {
                regexp:Span? dataType  = expectedDataFormat[1];
                if dataType !is () {
                    fieldData = "Type of field should be '"+ dataType.substring()+"'";
                }
            }
            errors.push(fieldName + ". " + fieldData);  
        }

        //Parsing for invalid field values
        regexp:Groups? invalidValuesData = re `^\s*field '([^']+)'`.findGroups(data[i]);
        if invalidValuesData is regexp:Groups {
            string valueName="";
            string valueData="";
            regexp:Span? value = invalidValuesData[1];
            if value !is () {
                valueName = "Invalid value of field '"+ value.substring()+"'";
            }
            //To get the expected type from the error message
            regexp:Groups? expectedDataFormat = re `should be of type '([^']+)'`.findGroups(data[i]);
            if expectedDataFormat is regexp:Groups {
                regexp:Span? dataType  = expectedDataFormat[1];
                if dataType !is () {
                    valueData = "Type of value should be '"+ dataType.substring()+"'";
                }
            }
            errors.push(valueName + ". " + valueData);
        }


    }  

    //Parsing for fhir multitype scenario
    regexp:Groups? sss = re `\n\s*\{[\s\S]*`.findGroups(message);
    if sss is regexp:Groups {
        regexp:Span? value = sss[0];
        if value !is () {  
            string capturedString = value.substring();
            //Splits message into lines based on \n
            string[] capturedErrors = regex2.split(capturedString);

            string valueName="";
            foreach var i in 0...capturedErrors.length()-1 {
            regexp:Groups? capturedData = re `^\s*field '([^']+)'`.findGroups(capturedErrors[i]);
            if capturedData is regexp:Groups {
                    regexp:Span? fieldData = capturedData[1];
                    if fieldData !is () {
                      valueName = fieldData.substring();
                      errors.push("The field '"+ valueName +"' may be missing or invalid or it's value invalid" );
                      break;
                    }
            }
              }

     }
    }
    return errors;
}
