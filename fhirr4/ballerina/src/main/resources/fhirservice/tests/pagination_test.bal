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

import ballerina/test;
import ballerina/http;
import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.parser;

Listener fhirPaginationListener = check new (9293, apiConfig);
http:Client fhirPaginationClient = check new ("http://localhost:9293");

@test:BeforeGroups { value:["Pagination"] }
function startPaginationService() returns error? {
    check fhirPaginationListener.attach(fhirServiceWithDefaultPagination);
    check fhirPaginationListener.'start();
    log:printInfo("FHIR pagination test service has started");
}

@test:Config {groups: ["Pagination"]}
function testDefaultPageParams() returns error? {
    [map<r4:RequestSearchParameter[]>, r4:PaginationContext] params = check fhirPaginationClient->/test1/Patient();
    test:assertTrue(params[1].paginationEnabled);
    test:assertEquals(params[1].page, 1);
    test:assertEquals(params[1].pageSize, 10);
}

@test:Config {groups: ["Pagination"]}
function testCustomPageParam() returns error? {
    [map<r4:RequestSearchParameter[]>, r4:PaginationContext] params = check fhirPaginationClient->/test1/Patient(page=2);
    test:assertEquals(params[1].page, 2);
    test:assertEquals(params[1].pageSize, 10);
}

@test:Config {groups: ["Pagination"]}
function testCustomCountParam() returns error? {
    [map<r4:RequestSearchParameter[]>, r4:PaginationContext] params = check fhirPaginationClient->/test1/Patient(_count=5);
    test:assertEquals(params[1].page, 1);
    test:assertEquals(params[1].pageSize, 5);
}

@test:Config {groups: ["Pagination"]}
function testPageWithOtherQparams() returns error? {
    [map<r4:RequestSearchParameter[]>, r4:PaginationContext] params = check fhirPaginationClient->/test1/Patient(page=2, given="Vijay");
    test:assertTrue(params[0].hasKey("given"));
    test:assertEquals(params[1].page, 2);
    test:assertEquals(params[1].pageSize, 10);
}

@test:Config {groups: ["Pagination"]}
function testAllLinks() returns error? {
    r4:Bundle patients = check fhirPaginationClient->/test2/Patient(page = 2, given = "Vijay");
    r4:BundleLink[]? allLinks = patients.link;
    string nextLink = "";
    string prevLink = "";
    string selfLink = "";
    if allLinks is r4:BundleLink[] {
        foreach r4:BundleLink link in allLinks {
            match link.relation {
                "next" => {
                    nextLink = link.url;
                }
                "prev" => {
                    prevLink = link.url;
                }
                "self" => {
                    selfLink = link.url;
                }
            }
        }
    }
    test:assertTrue(nextLink == "");
    test:assertTrue(prevLink.includes("page=1"));
    test:assertTrue(prevLink.includes("_count=10"));
    test:assertTrue(selfLink.includes("page=2"));
    test:assertTrue(selfLink.includes("_count=10"));

}

@test:Config {groups: ["Pagination"]}
function testAllLinksWithCount() returns error? {
    r4:Bundle patients = check fhirPaginationClient->/test2/Patient(page = 2, _count=5, given = "Vijay");
    r4:BundleLink[]? allLinks = patients.link;
    string nextLink = "";
    string prevLink = "";
    string selfLink = "";
    if allLinks is r4:BundleLink[] {
        foreach r4:BundleLink link in allLinks {
            match link.relation {
                "next" => {
                    nextLink = link.url;
                }
                "prev" => {
                    prevLink = link.url;
                }
                "self" => {
                    selfLink = link.url;
                }
            }
        }
    }
    test:assertTrue(nextLink == "");
    test:assertTrue(prevLink.includes("page=1"));
    test:assertTrue(prevLink.includes("_count=5"));
    test:assertTrue(selfLink.includes("page=2"));
    test:assertTrue(selfLink.includes("_count=5"));

}

@test:Config {groups: ["Pagination"]}
function testAllLinksWithPage() returns error? {
    r4:Bundle patients = check fhirPaginationClient->/test2/Patient(_count = 2, given = "Vijay");
    r4:BundleLink[]? allLinks = patients.link;
    string nextLink = "";
    string prevLink = "";
    string selfLink = "";
    if allLinks is r4:BundleLink[] {
        foreach r4:BundleLink link in allLinks {
            match link.relation {
                "next" => {
                    nextLink = link.url;
                }
                "prev" => {
                    prevLink = link.url;
                }
                "self" => {
                    selfLink = link.url;
                }
            }
        }
    }
    test:assertTrue(prevLink == "");
    test:assertTrue(nextLink.includes("page=2"));
    test:assertTrue(nextLink.includes("_count=2"));
    test:assertTrue(selfLink.includes("page=1"));
    test:assertTrue(selfLink.includes("_count=2"));

}

@test:Config {groups: ["Pagination"]}
function testNoPrev() returns error? {
    r4:Bundle patients = check fhirPaginationClient->/test2/Patient(page = 1, given = "Vijay");
    r4:BundleLink[]? allLinks = patients.link;
    string nextLink = "";
    string prevLink = "";
    string selfLink = "";
    if allLinks is r4:BundleLink[] {
        foreach r4:BundleLink link in allLinks {
            match link.relation {
                "next" => {
                    nextLink = link.url;
                }
                "prev" => {
                    prevLink = link.url;
                }
                "self" => {
                    selfLink = link.url;
                }
            }
        }
    }
    test:assertTrue(nextLink == "");
    test:assertTrue(prevLink == "");
    test:assertTrue(selfLink.includes("page=1"));

}

@test:Config {groups: ["Pagination"]}
function testNext() returns error? {
    r4:Bundle patients = check fhirPaginationClient->/test3/Patient;
    r4:BundleLink[]? allLinks = patients.link;
    string nextLink = "";
    string prevLink = "";
    string selfLink = "";
    if allLinks is r4:BundleLink[] {
        foreach r4:BundleLink link in allLinks {
            match link.relation {
                "next" => {
                    nextLink = link.url;
                }
                "prev" => {
                    prevLink = link.url;
                }
                "self" => {
                    selfLink = link.url;
                }
            }
        }
    }
    test:assertTrue(nextLink.includes("page=2"));
    test:assertTrue(prevLink == "");
    test:assertTrue(selfLink.includes("page=1"));
}

@test:AfterGroups { value:["Pagination"] }
function stopPaginationService() returns error? {
    check fhirPaginationListener.gracefulStop();
    log:printInfo("FHIR pagination test service has stopped");
}

// Testing no pagination

Listener fhirNoPaginationListener = check new (9294, apiConfigNoPagination);
http:Client fhirNoPaginationClient = check new ("http://localhost:9294");

@test:BeforeGroups { value:["NoPagination"] }
function startNoPaginationService() returns error? {
    check fhirNoPaginationListener.attach(fhirServiceNoPagination);
    check fhirNoPaginationListener.'start();
    log:printInfo("FHIR no pagination test service has started");
}

@test:Config {groups: ["NoPagination"]}
function testNoPagination() returns error? {
    http:Response response = check fhirNoPaginationClient->/test1/Patient(page = 1);
    test:assertEquals(response.statusCode, http:STATUS_BAD_REQUEST);
    
    anydata opOutcome = check parser:parse(check response.getJsonPayload());
    test:assertTrue(opOutcome is r4:OperationOutcome);
    if opOutcome is r4:OperationOutcome {
        r4:CodeableConcept? details = opOutcome.issue[0].details;
        if details is r4:CodeableConcept {
            test:assertTrue(details.text == "Pagination not supported");
        }
    }
}

@test:Config {groups: ["NoPagination"]}
function testTotal() returns error? {
    http:Response response = check fhirNoPaginationClient->/test1/Patient();
    anydata patients = check parser:parse(check response.getJsonPayload());
    if patients is r4:Bundle {
        test:assertTrue(patients.total == 2);
    } else {
        test:assertFail("Invalid response");
    }
}

@test:Config {groups: ["NoPagination"]}
function testNoPaginationWithCount() returns error? {
    http:Response response = check fhirNoPaginationClient->/test1/Patient(_count = 1);
    test:assertEquals(response.statusCode, http:STATUS_OK);
}

@test:AfterGroups { value:["NoPagination"] }
function stopNoPaginationService() returns error? {
    check fhirNoPaginationListener.gracefulStop();
    log:printInfo("FHIR no pagination test service has stopped");
}