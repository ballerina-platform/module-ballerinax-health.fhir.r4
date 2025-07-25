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

import ballerina/constraint;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.parser;
import ballerina/http;
import ballerina/lang.regexp;
import ballerina/log;

# Record used to store user friendly error messages.
#
# + detailedErrors - User friendly error messages
public type FHIRValidationIssueDetail record {
    *r4:FHIRIssueDetail;
    string[]? detailedErrors = ();
};

# Utility function to create FHIRError for validator.
#
# + message - Message to be added to the error
# + errServerity - serverity of the error
# + code - error code
# + diagnostic - (optional) diagnostic message
# + expression - (optional) FHIR Path expression to the error location
# + cause - (optional) original error
# + errorType - (optional) type of the error
# + httpStatusCode - (optional) [default: 500] HTTP status code to return to the client
# + return - Return Value Description
# + parsedErrors - (optional) usefriendly error messages parsed from original error message
public isolated function createValidationError(string message, r4:Severity errServerity, r4:IssueType code,
        string? diagnostic = (), string[]? expression = (), error? cause = (),
        r4:FHIRErrorTypes? errorType = (), string[]? parsedErrors = (), int httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR)
        returns r4:FHIRError {
    string diagnosticMessage = diagnostic != () ? string `${message} due to ${diagnostic}` : message;
    string[] detailedErrors = parsedErrors != () ? parsedErrors : [diagnosticMessage];
    boolean internal = false;
    FHIRValidationIssueDetail issue = {
        severity: errServerity,
        code: code,
        diagnostic: diagnostic,
        expression: expression,
        details: {
            coding: [
                {
                    system: "http://hl7.org/fhir/issue-type",
                    code: httpStatusCode.toString()
                }
            ],
            text: message
        },
        detailedErrors: detailedErrors
    };
    match errorType {
        r4:VALIDATION_ERROR => {
            r4:FHIRValidationError fError = error(message, cause, issues = [issue], httpStatusCode = httpStatusCode,
                                                        internalError = internal);
            return fError;
        }
        r4:PARSE_ERROR => {
            r4:FHIRParseError fError = error(message, cause, issues = [issue], httpStatusCode = httpStatusCode,
                                                        internalError = internal);
            return fError;
        }
        _ => {
            r4:FHIRError fError = error(message, cause, issues = [issue], httpStatusCode = httpStatusCode,
                                                        internalError = internal);
            return fError;
        }
    }
}

# This method will validate FHIR resource.
# Validation consist of Structure, cardinality, Value domain, Profile, json.
#
# + data - FHIR resource (can be in json or anydata)
# + targetFHIRModelType - (Optional) target model type to validate. Derived from payload if not given
# + return - If the validation fails, return validation error
public isolated function validate(anydata data, typedesc<anydata>? targetFHIRModelType = ()) returns r4:FHIRValidationError? {

    anydata finalData;

    if data is json|xml|string {
        anydata|r4:FHIRParseError parsedResult = parser:parse(data, targetFHIRModelType);

        if parsedResult is r4:FHIRParseError {
            log:printDebug(string `FHIR parsing failed, ${parsedResult.message()}`);
            string[] errors = processFHIRParserErrors(parsedResult.message());
            return <r4:FHIRValidationError>createValidationError("FHIR resource validation failed", r4:ERROR, r4:INVALID, parsedResult.message(),
                                                errorType = r4:VALIDATION_ERROR, cause = parsedResult, parsedErrors = errors, httpStatusCode = parsedResult.detail().httpStatusCode);
        } else {
            finalData = parsedResult;
        }
    } else if data is r4:DomainResource{
        finalData = data;
    } else {
        return <r4:FHIRValidationError>r4:createFHIRError("FHIR resource validation failed", r4:ERROR, r4:INVALID, 
                        "Invalid FHIR resource type", errorType = r4:VALIDATION_ERROR, httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    // Get the types of the FHIR resources, it can be international or any specific FHIR profiles like Uscore
    typedesc<anydata> typeDescOfData = typeof finalData;

    anydata|constraint:Error validationResult = constraint:validate(finalData, typeDescOfData);

    if validationResult is constraint:Error {
        log:printDebug(string `Constraint validation failed, ${validationResult.message()}`);
        string[] errors = parseConstraintErrors(validationResult.message());
        return <r4:FHIRValidationError>createValidationError("FHIR resource validation failed", r4:ERROR, r4:INVALID, validationResult.message(),
                                                errorType = r4:VALIDATION_ERROR, cause = validationResult, parsedErrors = errors, httpStatusCode = http:STATUS_BAD_REQUEST);
    } 
    
    // terminology validation
    if terminologyValidationEnabled {
        string[]? validationErrors = validateTerminologyData(validationResult);

        if validationErrors is string[] {    
            return <r4:FHIRValidationError>createValidationError("FHIR resource validation failed, due to terminology validation failed", r4:ERROR, r4:INVALID, "Terminology validation failed", 
                errorType = r4:VALIDATION_ERROR, parsedErrors = validationErrors, httpStatusCode = http:STATUS_BAD_REQUEST);
        } else {
            log:printDebug("Successfully validated FHIR resource with terminology validation");
        }
    }
}

isolated function parseConstraintErrors(string message) returns string[] {

    string[] errors = [];

    string:RegExp regex = re `\n`;
    string[] data = regex.split(message);

    foreach var i in 0 ... data.length() - 1 {

        //Parsing for dateTime errors.
        regexp:Groups[] invalidDates = re `\$\.([\w\.\[\]]+):pattern`.findAllGroups(data[i]);
        foreach regexp:Groups result in invalidDates {
            if (result.length() > 1) {
                regexp:Span? value = result[1];
                if value !is () {
                    errors.push(string `Invalid pattern (constraint) for field '${value.substring()}'`);
                }
            }
        }

        //Add parsing logic here for other constraint errors
    }
    return errors;
}

isolated function processFHIRParserErrors(string message) returns string[] {

    string[] errors = [];

    //Removes related content if fhir multitype scenario is present so that it can be styled differently
    //The regex searches for a '{' enclosed within \n tags which signifies the start of multitype error.
    string:RegExp removeMultitypeRegex = re `\n\s*\{[\s\S]*`;
    string editedMessage = removeMultitypeRegex.replace(message, "");

    string:RegExp splitErrorRegex = re `\n`;
    string[] data = splitErrorRegex.split(editedMessage);

    foreach var i in 0 ... data.length() - 1 {

        //Parsing for resource Type
        regexp:Groups? resourceType = re `Failed to find FHIR profile for the resource type`.findGroups(data[i]);
        if resourceType is regexp:Groups {
            errors.push(string `Resource type is invalid`);
        }

        //Parsing for missing fields
        regexp:Groups? missingFieldsData = re `missing required field '([^']+)'`.findGroups(data[i]);
        if (missingFieldsData is regexp:Groups && missingFieldsData.length() > 1 ){
            regexp:Span? value = missingFieldsData[1];
            if value !is () {
                errors.push(string `Missing required field '${value.substring()}'`);
            }
        }

        //Parsing for missing elements(if resourcetype is msiisng)
        regexp:Groups? missingElementsData = re `missing required element: "([^""]+)"`.findGroups(data[i]);
        if (missingElementsData is regexp:Groups && missingElementsData.length() > 1 ){
            regexp:Span? value = missingElementsData[1];
            if value !is () {
                errors.push(string `Missing required Element: '${value.substring()}'`);
            }
        }

        //Parsing for Invalid fields
        regexp:Groups? invalidFieldData = re `value of field '([^']+)'`.findGroups(data[i]);
        if (invalidFieldData is regexp:Groups && invalidFieldData.length() > 1 ){
            string fieldName = "";
            string fieldData = "";
            regexp:Span? value = invalidFieldData[1];
            if value !is () {
                fieldName = string `Invalid field '${value.substring()}'`;
            }
            //To get the expected type from the error message
            regexp:Groups? expectedDataFormat = re `should be of type '([^']+)'`.findGroups(data[i]);
            if (expectedDataFormat is regexp:Groups && expectedDataFormat.length() > 1 ){
                regexp:Span? dataType = expectedDataFormat[1];
                if dataType !is () {
                    fieldData = string `Type of field should be '${dataType.substring()}'`;
                }
            }
            errors.push(string `${fieldName}. ${fieldData}`);
        }

        //Parsing for invalid field values
        regexp:Groups? invalidValuesData = re `^\s*field '([^']+)'`.findGroups(data[i]);
        if (invalidValuesData is regexp:Groups && invalidValuesData.length() > 1 ){
            string valueName = "";
            string valueData = "";
            regexp:Span? value = invalidValuesData[1];
            if value !is () {
                valueName = string `Invalid value of field '${value.substring()}'`;
            }
            //To get the expected type from the error message
            regexp:Groups? expectedDataFormat = re `should be of type '([^']+)'`.findGroups(data[i]);
            if (expectedDataFormat is regexp:Groups && expectedDataFormat.length() > 1 ){
                regexp:Span? dataType = expectedDataFormat[1];
                if dataType !is () {
                    valueData = string `Type of value should be '${dataType.substring()}'`;
                }
            }
            errors.push(string `${valueName}. ${valueData}`);
        }

        //Parsing for invalid array elements
        regexp:Groups? invalidArrayElementsData = re `^\s*array element '([^']+)'`.findGroups(data[i]);
        if (invalidArrayElementsData is regexp:Groups && invalidArrayElementsData.length() > 1 ) {
            string valueName = "";
            string valueData = "";
            regexp:Span? value = invalidArrayElementsData[1];
            if value !is () {
                valueName = string `Invalid array element '${value.substring()}'`;
            }
            //To get the expected type from the error message
            regexp:Groups? expectedDataFormat = re `should be of type '([^']+)'`.findGroups(data[i]);
            if (expectedDataFormat is regexp:Groups && expectedDataFormat.length() > 1 ){
                regexp:Span? dataType = expectedDataFormat[1];
                if dataType !is () {
                    valueData = string `Type of element should be '${dataType.substring()}'`;
                }
            }
            errors.push(string `${valueName}. ${valueData}`);
        }

        //Add parsing logic here for other parser errors

    }

    //Parsing for fhir multitype scenario (when there is a union type) 
    // Example of multitype error;
    // {
    //     missing required field 'x' of type 'health.fhir.r4:CodeableConcept' in record 'x'
    //     value of field 'x' adding to the record 'x' should be of type 'x', found 'x'
    // or
    //     missing required field 'x' of type 'string' in record 'x'
    //     value of field 'x' adding to the record 'x' should be of type 'x', found 'x'
    // or

    //The regex captures a '{' enclosed within \n tags which signifies the start of multitype error.
    regexp:Groups? multitypeMessage = re `\n\s*\{[\s\S]*`.findGroups(message);
    if multitypeMessage is regexp:Groups {
        regexp:Span? value = multitypeMessage[0];
        if value !is () {
            string capturedString = value.substring();
            //Splits message into lines based on \n
            string[] capturedErrors = splitErrorRegex.split(capturedString);

            string valueName = "";
            //To get the field name from the error message if error is with the VALUE
            foreach var i in 0 ... capturedErrors.length() - 1 {
                regexp:Groups? capturedData = re `^\s*field '([^']+)'`.findGroups(capturedErrors[i]);
                if (capturedData is regexp:Groups && capturedData.length() > 1 ){
                    regexp:Span? fieldData = capturedData[1];
                    if fieldData !is () {
                        valueName = fieldData.substring();
                        errors.push(string `The field '${valueName}' should be of type value[x] or url[x] where x is a valid fhir data type`);
                        break;
                    }
                }
            }
            if (valueName === "") {
                //To get the field name from the error message if error is with the FIELD itself
                foreach var i in 0 ... capturedErrors.length() - 1 {
                    regexp:Groups? capturedData = re `^\s* value of field '([^']+)'`.findGroups(capturedErrors[i]);
                    if (capturedData is regexp:Groups && capturedData.length() > 1 ){
                        regexp:Span? fieldData = capturedData[1];
                        if fieldData !is () {
                            valueName = fieldData.substring();
                            errors.push(string `The field '${valueName}' should be of type value[x] or url[x] where x is a valid fhir data type`);
                            break;
                        }
                    }
                }
            }
        }
    }
    return errors;
}
