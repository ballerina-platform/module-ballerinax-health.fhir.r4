/*
 * Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org).
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerinax.fhirr4.compiler;

import io.ballerina.tools.diagnostics.DiagnosticSeverity;

import static io.ballerina.tools.diagnostics.DiagnosticSeverity.ERROR;

/**
 * {@code DiagnosticCodes} is used to hold diagnostic codes.
 */
public enum FHIRDiagnosticCodes {
    FHIR_101("FHIR_101", "remote methods are not allowed in fhir:Service", ERROR),
    FHIR_102("FHIR_102", "invalid resource method return type: expected '" + Constants.ALLOWED_RETURN_UNION +
            "', but found '%s'", ERROR),
    FHIR_103("FHIR_103", "invalid resource parameter '%s'", ERROR),
    FHIR_104("FHIR_104", "invalid number of parameters", ERROR);

    private final String code;
    private final String message;
    private final DiagnosticSeverity severity;

    FHIRDiagnosticCodes(String code, String message, DiagnosticSeverity severity) {
        this.code = code;
        this.message = message;
        this.severity = severity;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    public DiagnosticSeverity getSeverity() {
        return severity;
    }
}
