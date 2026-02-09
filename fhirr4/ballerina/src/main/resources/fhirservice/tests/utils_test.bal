// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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

import ballerina/test;
import ballerina/http;
import ballerina/jwt;
import ballerina/time;
import ballerina/file;

// Test data for JWT operations
const string VALID_JWT = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJpc3VydXV5IiwiaHR0cDovL3dzbzIub3JnL2NsYWltcy9hcGluYW1lIjoiUGF0aWVudCIsImh0dHA6Ly93c28yLm9yZy9jbGFpbXMvYXBwbGljYXRpb250aWVyIjoiMTBQZXJNaW4iLCJodHRwOi8vd3NvMi5vcmcvY2xhaW1zL3ZlcnNpb24iOiIxLjAuMCIsImh0dHA6Ly93c28yLm9yZy9jbGFpbXMva2V5dHlwZSI6IlBST0RVQ1RJT04iLCJpc3MiOiJ3c28yLm9yZy9wcm9kdWN0cy9hbSIsImh0dHA6Ly93c28yLm9yZy9jbGFpbXMvYXBwbGljYXRpb25BdHRyaWJ1dGVzIjp7IlRlcm1zIGFuZCBDb25kaXRpb25zIFNlY3VyZSBVUkwiOiJnb29nbGUuY29tIn0sImh0dHA6Ly93c28yLm9yZy9jbGFpbXMvYXBwbGljYXRpb25uYW1lIjoibmV3YXBwMSIsImh0dHA6Ly93c28yLm9yZy9jbGFpbXMvZW5kdXNlciI6ImlzdXJ1dXlAY2FyYm9uLnN1cGVyIiwiaHR0cDovL3dzbzIub3JnL2NsYWltcy9lbmR1c2VyVGVuYW50SWQiOiItMTIzNCIsImh0dHA6Ly93c28yLm9yZy9jbGFpbXMvcGF0aWVudElkIjoiMDAwMDAwODIwMyIsImh0dHA6Ly93c28yLm9yZy9jbGFpbXMvYXBwbGljYXRpb25VVUlkIjoiZGQ1YWRlZjUtYTczNS00YTJlLTkxODEtOTY4NDc0ZDZiMzg0IiwiY2xpZW50X2lkIjoiRkFsd21BTG0xVkFtSFNCU2Y2OGsyWGl6TUFrYSIsImh0dHA6Ly93c28yLm9yZy9jbGFpbXMvc3Vic2NyaWJlciI6ImlzdXJ1dXkiLCJhenAiOiJGQWx3bUFMbTFWQW1IU0JTZjY4azJYaXpNQWthIiwiaHR0cDovL3dzbzIub3JnL2NsYWltcy90aWVyIjoiQnJvbnplIiwic2NvcGUiOiJkZWZhdWx0IiwiZXhwIjoxNzU2MjkwMDI3LCJodHRwOi8vd3NvMi5vcmcvY2xhaW1zL2FwcGxpY2F0aW9uaWQiOiIxOTEiLCJodHRwOi8vd3NvMi5vcmcvY2xhaW1zL3VzZXJ0eXBlIjoiQXBwbGljYXRpb25fVXNlciIsImlhdCI6MTc1NjI4OTEyNywianRpIjoiNTkxZGEzODMtNjdmOS00NzcyLWI3ZDItZWNiZjcyNTI5NDQ0IiwiaHR0cDovL3dzbzIub3JnL2NsYWltcy9hcGljb250ZXh0IjoiL3I0L1BhdGllbnQvMS4wLjAiLCJmaGlyVXNlciI6InBhdGllbnQvMTAzIn0.WcYq7DclQ7kO6Pym5VrOxo8VFgXyPyXLXzirlTGjWqCuUOKz1LLh0LDoSPC9X7Qzs2ZB_3fWMVJOAuGjzF2IV879FGjk_vqfmzqEMs0tO21LjLDW0SzrBq9-imorjwK-7jjxGSwndO8igdmNhpojFwVMjX3MRZn2HBv-KD5Vs8Q2WvrIjlIl2UUDZ3Z3fj3QLcMJGnRx7IPRe9UIlsFnHKk6C-q2KmnoqKsba1Ll3GTj0gbMIrYU18GiJKmrL3fkTfwJOWhmqMuZixkVGzzauxGcAvAfKqk8T7rwnIdKir7JMnvk13zAihJOWHVtSfdyTk2DDe8OHRYqkueb2O2Q9A";

// Test: decodeJWT function with valid JWT
@test:Config {}
function testDecodeJWTValid() returns error? {

    [jwt:Header, jwt:Payload]|error result = decodeJWT(VALID_JWT);
    test:assertTrue(result is [jwt:Header, jwt:Payload], msg = "JWT decoding should succeed");
}

// Test: decodeJWT function with invalid JWT
@test:Config {}
function testDecodeJWTInvalid() {

    [jwt:Header, jwt:Payload]|error result = decodeJWT("invalid.jwt.token");
    test:assertTrue(result is error, msg = "Invalid JWT should return error");
}

// Test: extractAnalyaticsDataFromJWT function
@test:Config {}
function testExtractAnalyticsDataFromJWT() returns error? {

    [jwt:Header, jwt:Payload]|error decodedResult = decodeJWT(VALID_JWT);
    test:assertTrue(decodedResult is [jwt:Header, jwt:Payload], msg = "JWT should decode successfully");
    
    if decodedResult is [jwt:Header, jwt:Payload] {
        [jwt:Header, jwt:Payload] [_, payload] = decodedResult;
        string[] attributes = ["fhirUser", "client_id", "iss"];
        map<string> analyticsData = extractAnalyaticsDataFromJWT(attributes, payload);
        
        test:assertEquals(analyticsData.length(), 3, msg = "Should extract 3 attributes");
        test:assertEquals(analyticsData["fhirUser"], "patient/103", msg = "fhirUser should match");
        test:assertEquals(analyticsData["client_id"], "FAlwmALm1VAmHSBSf68k2XizMAka", msg = "client_id should match");
        test:assertEquals(analyticsData["iss"], "wso2.org/products/am", msg = "iss should match");
    }
}

// Test: extractAnalyaticsDataFromJWT with missing attributes
@test:Config {}
function testExtractAnalyticsDataFromJWTMissingAttributes() returns error? {

    [jwt:Header, jwt:Payload]|error decodedResult = decodeJWT(VALID_JWT);
    test:assertTrue(decodedResult is [jwt:Header, jwt:Payload], msg = "JWT should decode successfully");
    
    if decodedResult is [jwt:Header, jwt:Payload] {
        [jwt:Header, jwt:Payload] [_, payload] = decodedResult;
        string[] attributes = ["fhirUser", "nonExistentAttribute", "iss"];
        
        map<string> analyticsData = extractAnalyaticsDataFromJWT(attributes, payload);
        test:assertEquals(analyticsData.length(), 2, msg = "Should extract only existing attributes");
        test:assertTrue(analyticsData.hasKey("fhirUser"), msg = "Should have fhirUser");
        test:assertTrue(analyticsData.hasKey("iss"), msg = "Should have iss");
        test:assertFalse(analyticsData.hasKey("nonExistentAttribute"), msg = "Should not have nonExistentAttribute");
    }
}

// Test: convertMapToJson function
@test:Config {}
function testConvertMapToJson() {

    map<string> testMap = {
        "Content-Type": "application/json",
        "Authorization": "Bearer token123",
        "Accept": "application/fhir+json"
    };
    
    json result = convertMapToJson(testMap);    
    test:assertEquals(result.toJsonString().includes("application/json"), true, msg = "Content-Type should match");
    test:assertEquals(result.toJsonString().includes("Bearer token123"), true, msg = "Authorization should match");
    test:assertEquals(result.toJsonString().includes("application/fhir+json"), true, msg = "Accept should match");
}

// Test: convertMapToJson with empty map
@test:Config {}
function testConvertMapToJsonEmpty() {

    map<string> emptyMap = {};
    json result = convertMapToJson(emptyMap);
    test:assertEquals(result, {}, msg = "Empty map should produce empty JSON");
}

// Test: getRequestHeaders function
@test:Config {}
function testGetRequestHeaders() {

    http:Request request = new;
    request.setHeader("Content-Type", "application/json");
    request.setHeader("Authorization", "Bearer token123");
    request.setHeader("X-Custom-Header", "custom-value");
    
    map<string> headers = getRequestHeaders(request);
    test:assertEquals(headers.length(), 3, msg = "Should extract 3 headers");
    test:assertEquals(headers["content-type"], "application/json", msg = "Content-Type should match");
    test:assertEquals(headers["authorization"], "Bearer token123", msg = "Authorization should match");
    test:assertEquals(headers["x-custom-header"], "custom-value", msg = "Custom header should match");
}

// Test: getRequestHeaders with no headers
@test:Config {}
function testGetRequestHeadersEmpty() {

    http:Request request = new;
    map<string> headers = getRequestHeaders(request);
    test:assertEquals(headers.length(), 0, msg = "Should return empty map for request with no headers");
}

// Test: getResponseHeaders function
@test:Config {}
function testGetResponseHeaders() {

    http:Response response = new;
    response.setHeader("Content-Type", "application/fhir+json");
    response.setHeader("Location", "/Patient/123");
    response.setHeader("X-Response-Time", "150ms");
    
    map<string> headers = getResponseHeaders(response);
    test:assertEquals(headers.length(), 3, msg = "Should extract 3 headers");
    test:assertEquals(headers["content-type"], "application/fhir+json", msg = "Content-Type should match");
    test:assertEquals(headers["location"], "/Patient/123", msg = "Location should match");
    test:assertEquals(headers["x-response-time"], "150ms", msg = "Response time should match");
}

// Test: getResponseHeaders with no headers
@test:Config {}
function testGetResponseHeadersEmpty() {

    http:Response response = new;
    map<string> headers = getResponseHeaders(response);
    test:assertEquals(headers.length(), 0, msg = "Should return empty map for response with no headers");
}

// Test: isExcludedApi function
@test:Config {}
function testIsExcludedApiMatching() {
    boolean result = isExcludedApi("/fhir/r4/bulk-export");
    test:assertTrue(result, msg = "Should return true for excluded API path");
}

// Test: isExcludedApi with non-matching path
@test:Config {}
function testIsExcludedApiNonMatching() {
    boolean result = isExcludedApi("/fhir/r4/Patient");
    test:assertFalse(result, msg = "Should return false for non-excluded API path");
}

// Test: isExcludedApi with case insensitive matching
@test:Config {}
function testIsExcludedApiCaseInsensitive() {
    boolean result = isExcludedApi("/fhir/r4/BULK-EXPORT");
    test:assertTrue(result, msg = "Should return true for excluded API path (case insensitive)");
}

// Test: calculateDelayUntilMidnight function
@test:Config {}
function testCalculateDelayUntilMidnight() {

    time:Utc|error endDayOfMonth = time:utcFromString("2024-12-31T00:00:00Z");

    time:Civil nextMidnight;
    if endDayOfMonth is time:Utc {
        nextMidnight = calculateDelayUntilMidnight(endDayOfMonth);
        test:assertEquals(nextMidnight.hour, 0, msg = "Hour should be 0 for midnight");
        test:assertEquals(nextMidnight.minute, 0, msg = "Minute should be 0 for midnight");
        test:assertEquals(nextMidnight.day, 1, msg = "Day should be 1 for midnight");
        test:assertEquals(nextMidnight.year, 2025, msg = "Year should be 2025 for midnight");
    }
    
    time:Utc|error leapYearTest = time:utcFromString("2024-02-29T00:00:00Z");

    time:Civil nextMidnight2;
    if leapYearTest is time:Utc {
        nextMidnight2 = calculateDelayUntilMidnight(leapYearTest);
        test:assertEquals(nextMidnight2.hour, 0, msg = "Hour should be 0 for midnight");
        test:assertEquals(nextMidnight2.minute, 0, msg = "Minute should be 0 for midnight");
        test:assertEquals(nextMidnight2.day, 1, msg = "Day should be 1 for midnight");
        test:assertEquals(nextMidnight2.month, 3, msg = "Month should be 3 for midnight");
        test:assertEquals(nextMidnight2.year, 2024, msg = "Year should be 2024 for midnight");
    }
}

// Test: isFileExist function with existing file
@test:Config {}
function testIsFileExistTrue() returns error? {
    string testFilePath = "test_file_exist.txt";
    
    // Create a test file
    check file:create(testFilePath);
    
    boolean|error? result = isFileExist(testFilePath);
    test:assertTrue(result is boolean, msg = "Should return boolean");
    
    if result is boolean {
        test:assertTrue(result, msg = "Should return true for existing file");
    }
    
    // Cleanup
    check file:remove(testFilePath);
}

// Test: isFileExist function with non-existing file
@test:Config {}
function testIsFileExistFalse() returns error? {
    string nonExistentPath = "non_existent_file_12345.txt";
    
    boolean|error? result = isFileExist(nonExistentPath);
    test:assertTrue(result is boolean, msg = "Should return boolean");
    
    if result is boolean {
        test:assertFalse(result, msg = "Should return false for non-existing file");
    }
}

// Test: writeDataToFile function
@test:Config {}
function testWriteDataToFile() returns error? {
    string testFilePath = "test_write_data.txt";
    string testData = "Test analytics data\n";
    
    // Create the file first
    check file:create(testFilePath);
    
    // Write data to file
    error? writeResult = writeDataToFile(testFilePath, testData);
    test:assertTrue(writeResult is (), msg = "Write operation should succeed");
    
    // Cleanup
    check file:remove(testFilePath);
}

// Test: writeDataToFile with append mode
@test:Config {}
function testWriteDataToFileAppend() returns error? {
    string testFilePath = "test_append_data.txt";
    string firstData = "First line\n";
    string secondData = "Second line\n";
    
    // Create the file
    check file:create(testFilePath);
    
    // Write first data
    check writeDataToFile(testFilePath, firstData);
    
    // Append second data
    check writeDataToFile(testFilePath, secondData);
    
    // Cleanup
    check file:remove(testFilePath);
}

// Test data for Request record
@test:Config {}
function testRequestRecordCreation() {

    Request testRequest = {
        time: time:utcToString(time:utcNow()),
        uri: "/fhir/r4/Patient",
        verb: "GET",
        headers: {"Content-Type": "application/json"}
    };
    
    test:assertTrue(testRequest.time.length() > 0, msg = "Time should be set");
    test:assertEquals(testRequest.uri, "/fhir/r4/Patient", msg = "URI should match");
    test:assertEquals(testRequest.verb, "GET", msg = "Verb should match");
}

// Test data for Response record
@test:Config {}
function testResponseRecordCreation() {

    Response testResponse = {
        time: time:utcToString(time:utcNow()),
        status: 200,
        headers: {"Content-Type": "application/fhir+json"}
    };
    
    test:assertTrue(testResponse.time.length() > 0, msg = "Time should be set");
    test:assertEquals(testResponse.status, 200, msg = "Status should be 200");
}

// Test data for AnalyticsData record
@test:Config {}
function testAnalyticsDataRecordCreation() {

    Request testRequest = {
        time: time:utcToString(time:utcNow()),
        uri: "/fhir/r4/Patient",
        verb: "POST",
        headers: {"Content-Type": "application/json"},
        body: {"resourceType": "Patient"}
    };
    
    Response testResponse = {
        time: time:utcToString(time:utcNow()),
        status: 201,
        headers: {"Location": "/Patient/123"},
        body: {"resourceType": "Patient", "id": "123"}
    };
    
    AnalyticsData analyticsData = {
        request: testRequest,
        response: testResponse,
        user_id: "user123",
        company_id: "company456",
        metadata: {"custom": "data"}
    };
    
    test:assertEquals(analyticsData.request.verb, "POST", msg = "Request verb should match");
    test:assertEquals(analyticsData.response?.status, 201, msg = "Response status should match");
    test:assertEquals(analyticsData.user_id, "user123", msg = "User ID should match");
    test:assertEquals(analyticsData.company_id, "company456", msg = "Company ID should match");
}

// Test: Multiple headers with same name
@test:Config {}
function testGetRequestHeadersMultipleValues() {
    
    http:Request request = new;
    request.addHeader("Accept", "application/fhir+json");
    request.addHeader("Accept", "application/xml");
    
    map<string> headers = getRequestHeaders(request);
    
    test:assertTrue(headers.hasKey("accept"), msg = "Should have Accept header");
    test:assertEquals(headers["accept"], "application/fhir+json, application/xml", msg = "Should return first value");
}
