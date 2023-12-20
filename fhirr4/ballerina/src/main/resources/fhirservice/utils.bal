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

isolated function addPagination(r4:FHIRContext fhirContext, r4:Bundle bundle, int pageSize, string path) returns r4:Bundle {
    r4:Bundle bundleWithPagination = bundle;
    r4:BundleLink[] allLinks = [];

    // construct query string from processed search params
    string qString = "";
    map<r4:RequestSearchParameter[]> requestSearchParameters = fhirContext.getRequestSearchParameters();
    foreach r4:RequestSearchParameter[] params in requestSearchParameters {
        foreach r4:RequestSearchParameter param in params {
            if param.name == OFFSET || param.name == COUNT {
                continue;
            }
            qString = qString + string `${param.name}=${param.value}&`;
        }
    }
    if qString.endsWith("&") {
        qString = qString.substring(0, qString.length() - 1);
    }

    // get current page
    int currentpage = 1;
    r4:RequestSearchParameter[]? pageParam = fhirContext.getRequestSearchParameter(OFFSET);
    if pageParam is r4:RequestSearchParameter[] {
        r4:RequestSearchParameter offsetParam = pageParam[0];
        int|error offset = int:fromString(offsetParam.value);
        if offset is int {
            currentpage = (offset / pageSize) + 1;
        } else {
            // ignore error since we set the offset value to fhir context after validation
        }
    }

    // populate self link
    string selfUrl = qString.length() > 0 ? string `${path}?${qString}&${PAGE_QUERY_PARAM}=${currentpage}` : string `${path}?${PAGE_QUERY_PARAM}=${currentpage}`;
    r4:BundleLink selfLink = {
        relation: "self",
        url: string `${selfUrl}`
    };

    allLinks.push(selfLink);

    r4:BundleEntry[]? entries = bundle.entry;
    if entries is r4:BundleEntry[] && entries.length() < pageSize {
        // no next link
    } else {
        // populate next link
        int nextPage = currentpage + 1;
        string nextUrl = qString.length() > 0 ? string `${path}?${qString}&${PAGE_QUERY_PARAM}=${nextPage}` : string `${path}?${PAGE_QUERY_PARAM}=${nextPage}`;
        r4:BundleLink nextLink = {
            relation: "next",
            url: string `${nextUrl}`
        };
        allLinks.push(nextLink);
    }

    if currentpage > 1 {
        // previous link exists
        // populate previous link
        int prevPage = currentpage - 1;
        string prevUrl = qString.length() > 0 ? string `${path}?${qString}&${PAGE_QUERY_PARAM}=${prevPage}` : string `${path}?${PAGE_QUERY_PARAM}=${prevPage}`;
        r4:BundleLink prevLink = {
            relation: "prev",
            url: string `${prevUrl}`
        };
        allLinks.push(prevLink);
    }
    bundleWithPagination.link = allLinks;
    return bundleWithPagination;
}
