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

import ballerina/io;
import ballerina/test;
import ballerinax/health.fhir.r4.international401 as i4;

function returnCodeSystemData(string fileName) returns i4:CodeSystem {
    string filePath = string `tests/resources/terminology/code_systems/${fileName}.json`;
    json|error data = io:fileReadJson(filePath);

    if data is json {
        i4:CodeSystem|error temp = data.cloneWithType(i4:CodeSystem);
        if temp is i4:CodeSystem {
            return temp;
        } else {
            test:assertFail("Can not parse the CodeSystem record");
        }
    } else {
        test:assertFail(string `Can not load data from: ${filePath}`);
    }
}

function returnValueSetData(string fileName) returns i4:ValueSet {
    string filePath = string `tests/resources/terminology/value_sets/${fileName}.json`;
    json|error data = io:fileReadJson(filePath);

    if data is json {
        i4:ValueSet|error temp = data.cloneWithType(i4:ValueSet);
        if temp is i4:ValueSet {
            return temp;
        } else {
            test:assertFail("Can not parse the ValueSet record");
        }
    } else {
        test:assertFail(string `Can not load data from: ${filePath}`);
    }
}

function readJsonData(string fileName) returns json {
    string filePath = string `tests/resources/terminology/${fileName}.json`;
    json|error data = io:fileReadJson(filePath);

    if data is json {
        return data;
    } else {
        test:assertFail(string `Can not load data from: ${filePath}`);
    }
}
    
