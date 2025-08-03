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
import ballerina/data.xmldata;

public function parse(string ccdaDoc) returns ClincialDocument|error {
    xmlns "urn:hl7-org:v3" as v3;
    xml ccdXml = check xml:fromString(ccdaDoc);
    xml templateIdElements = ccdXml/<v3:templateId|templateId>;
    if templateIdElements.length() > 0 {
        foreach xml templateIdElement in templateIdElements {
            string|error root = templateIdElement.root;
            if root is string {
                if root == "2.16.840.1.113883.10.20.22.1.9" {
                    ProgressNote|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                } else if root == "2.16.840.1.113883.10.20.22.1.15" {
                    CarePlan|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                } else if root == "2.16.840.1.113883.10.20.22.1.2" {
                    ContinuityofCareDocumentCCD|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                } else if root == "2.16.840.1.113883.10.20.22.1.8" {
                    DischargeSummary|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                } else if root == "2.16.840.1.113883.10.20.22.1.3" {
                    HistoryandPhysical|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                } else if root == "2.16.840.1.113883.10.20.22.1.7" {
                    OperativeNote|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                } else if root == "2.16.840.1.113883.10.20.22.1.6" {
                    ProcedureNote|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                } else if root == "2.16.840.1.113883.10.20.22.1.14" {
                    ReferralNote|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                } else if root == "2.16.840.1.113883.10.20.22.1.13" {
                    TransferSummary|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                } else if root == "2.16.840.1.113883.10.20.22.1.10" {
                    UnstructuredDocument|error ccdDoc =  xmldata:parseAsType(ccdXml, {textFieldName: "xmlText"});
                    return ccdDoc;
                }
            }
        }
    }
    return error("Unsupported templateId");
}
