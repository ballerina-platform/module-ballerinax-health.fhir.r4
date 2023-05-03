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

import io.ballerina.compiler.api.symbols.ArrayTypeSymbol;
import io.ballerina.compiler.api.symbols.IntersectionTypeSymbol;
import io.ballerina.compiler.api.symbols.MapTypeSymbol;
import io.ballerina.compiler.api.symbols.TableTypeSymbol;
import io.ballerina.compiler.api.symbols.TypeDescKind;
import io.ballerina.compiler.api.symbols.TypeReferenceTypeSymbol;
import io.ballerina.compiler.api.symbols.TypeSymbol;
import io.ballerina.compiler.api.symbols.UnionTypeSymbol;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.ReturnTypeDescriptorNode;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.tools.diagnostics.DiagnosticFactory;
import io.ballerina.tools.diagnostics.DiagnosticInfo;
import io.ballerina.tools.diagnostics.DiagnosticProperty;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;
import io.ballerina.tools.diagnostics.Location;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

/**
 * Utility class providing fhir compiler plugin utility methods.
 */
public class FHIRCompilerPluginUtil {

    private static final List<TypeDescKind> ALLOWED_PAYLOAD_TYPES = Arrays.asList(
            TypeDescKind.BOOLEAN, TypeDescKind.INT, TypeDescKind.FLOAT, TypeDescKind.DECIMAL,
            TypeDescKind.STRING, TypeDescKind.XML, TypeDescKind.JSON,
            TypeDescKind.ANYDATA, TypeDescKind.NIL, TypeDescKind.BYTE, TypeDescKind.STRING_CHAR,
            TypeDescKind.XML_ELEMENT, TypeDescKind.XML_COMMENT, TypeDescKind.XML_PROCESSING_INSTRUCTION,
            TypeDescKind.XML_TEXT, TypeDescKind.INT_SIGNED8, TypeDescKind.INT_UNSIGNED8,
            TypeDescKind.INT_SIGNED16, TypeDescKind.INT_UNSIGNED16, TypeDescKind.INT_SIGNED32,
            TypeDescKind.INT_UNSIGNED32);
    private static final List<TypeDescKind> ALLOWED_RETURN_TYPES = Arrays.asList(
            TypeDescKind.BOOLEAN, TypeDescKind.INT, TypeDescKind.FLOAT, TypeDescKind.DECIMAL,
            TypeDescKind.STRING, TypeDescKind.XML, TypeDescKind.JSON,
            TypeDescKind.ANYDATA, TypeDescKind.RECORD, TypeDescKind.NIL, TypeDescKind.BYTE, TypeDescKind.STRING_CHAR,
            TypeDescKind.XML_ELEMENT, TypeDescKind.XML_COMMENT, TypeDescKind.XML_PROCESSING_INSTRUCTION,
            TypeDescKind.XML_TEXT, TypeDescKind.INT_SIGNED8, TypeDescKind.INT_UNSIGNED8,
            TypeDescKind.INT_SIGNED16, TypeDescKind.INT_UNSIGNED16, TypeDescKind.INT_SIGNED32,
            TypeDescKind.INT_UNSIGNED32);

    public static void updateDiagnostic(SyntaxNodeAnalysisContext ctx, Location location,
                                        FHIRDiagnosticCodes fhirDiagnosticCodes) {
        DiagnosticInfo diagnosticInfo = getDiagnosticInfo(fhirDiagnosticCodes);
        ctx.reportDiagnostic(DiagnosticFactory.createDiagnostic(diagnosticInfo, location));
    }

    public static void updateDiagnostic(SyntaxNodeAnalysisContext ctx, Location location,
                                        FHIRDiagnosticCodes fhirDiagnosticCodes, Object... argName) {
        DiagnosticInfo diagnosticInfo = getDiagnosticInfo(fhirDiagnosticCodes, argName);
        ctx.reportDiagnostic(DiagnosticFactory.createDiagnostic(diagnosticInfo, location));
    }

    public static void updateDiagnostic(SyntaxNodeAnalysisContext ctx, Location location,
                                        FHIRDiagnosticCodes fhirDiagnosticCodes,
                                        List<DiagnosticProperty<?>> diagnosticProperties, String argName) {
        DiagnosticInfo diagnosticInfo = getDiagnosticInfo(fhirDiagnosticCodes, argName);
        ctx.reportDiagnostic(DiagnosticFactory.createDiagnostic(diagnosticInfo, location, diagnosticProperties));
    }

    public static DiagnosticInfo getDiagnosticInfo(FHIRDiagnosticCodes diagnostic, Object... args) {
        return new DiagnosticInfo(diagnostic.getCode(), String.format(diagnostic.getMessage(), args),
                diagnostic.getSeverity());
    }

    public static String getReturnTypeDescription(ReturnTypeDescriptorNode returnTypeDescriptorNode) {
        return returnTypeDescriptorNode.type().toString().trim();
    }

    public static void validateReturnType(SyntaxNodeAnalysisContext ctx, Node node, String returnTypeStringValue,
                                           TypeSymbol returnTypeSymbol, FHIRDiagnosticCodes diagnosticCode,
                                           boolean isInterceptorType) {
        if (isInterceptorType && isServiceType(returnTypeSymbol)) {
            return;
        }
        TypeDescKind kind = returnTypeSymbol.typeKind();
        if (isAllowedReturnType(kind) || kind == TypeDescKind.ERROR || kind == TypeDescKind.NIL ||
                kind == TypeDescKind.ANYDATA || kind == TypeDescKind.SINGLETON) {
            return;
        }
        if (kind == TypeDescKind.INTERSECTION) {
            TypeSymbol typeSymbol = ((IntersectionTypeSymbol) returnTypeSymbol).effectiveTypeDescriptor();
            validateReturnType(ctx, node, returnTypeStringValue, typeSymbol, diagnosticCode, isInterceptorType);
        } else if (kind == TypeDescKind.UNION) {
            List<TypeSymbol> typeSymbols = ((UnionTypeSymbol) returnTypeSymbol).memberTypeDescriptors();
            for (TypeSymbol typeSymbol : typeSymbols) {
                validateReturnType(ctx, node, returnTypeStringValue, typeSymbol, diagnosticCode, isInterceptorType);
            }
        } else if (kind == TypeDescKind.ARRAY) {
            TypeSymbol memberTypeDescriptor = ((ArrayTypeSymbol) returnTypeSymbol).memberTypeDescriptor();
            validateArrayElementTypeInReturnType(
                    ctx, node, returnTypeStringValue, memberTypeDescriptor, diagnosticCode);
        } else if (kind == TypeDescKind.TYPE_REFERENCE) {
            TypeSymbol typeDescriptor = ((TypeReferenceTypeSymbol) returnTypeSymbol).typeDescriptor();
            validateReturnType(ctx, node, returnTypeStringValue, typeDescriptor, diagnosticCode, isInterceptorType);
        } else if (kind == TypeDescKind.MAP) {
            TypeSymbol typeSymbol = ((MapTypeSymbol) returnTypeSymbol).typeParam();
            validateReturnType(ctx, node, returnTypeStringValue, typeSymbol, diagnosticCode, isInterceptorType);
        } else if (kind == TypeDescKind.TABLE) {
            TypeSymbol typeSymbol = ((TableTypeSymbol) returnTypeSymbol).rowTypeParameter();
            if (typeSymbol == null) {
                reportInvalidReturnType(ctx, node, returnTypeStringValue, diagnosticCode);
            } else {
                validateReturnType(ctx, node, returnTypeStringValue, typeSymbol, diagnosticCode, isInterceptorType);
            }
        } else {
            reportInvalidReturnType(ctx, node, returnTypeStringValue, diagnosticCode);
        }
    }

    private static boolean isServiceType(TypeSymbol returnTypeSymbol) {
        Optional<String> optionalTypeName = returnTypeSymbol.getName();
        return optionalTypeName.filter(typeName -> typeName.equals(Constants.SERVICE)).isPresent();
    }

    private static void validateArrayElementTypeInReturnType(SyntaxNodeAnalysisContext ctx, Node node,
                                                             String typeStringValue, TypeSymbol memberTypeDescriptor,
                                                             FHIRDiagnosticCodes diagnosticCode) {
        TypeDescKind kind = memberTypeDescriptor.typeKind();
        if (isAllowedReturnType(kind) || kind == TypeDescKind.RECORD || kind == TypeDescKind.MAP ||
                kind == TypeDescKind.TABLE) {
            return;
        }
        if (kind == TypeDescKind.INTERSECTION) {
            TypeSymbol typeSymbol = ((IntersectionTypeSymbol) memberTypeDescriptor).effectiveTypeDescriptor();
            validateArrayElementTypeInReturnType(ctx, node, typeStringValue, typeSymbol, diagnosticCode);
        } else if (kind == TypeDescKind.TYPE_REFERENCE) {
            TypeSymbol typeDescriptor = ((TypeReferenceTypeSymbol) memberTypeDescriptor).typeDescriptor();
            TypeDescKind typeDescKind = retrieveEffectiveTypeDesc(typeDescriptor);
            if (typeDescKind != TypeDescKind.RECORD && typeDescKind != TypeDescKind.MAP &&
                    typeDescKind != TypeDescKind.TABLE) {
                reportInvalidReturnType(ctx, node, typeStringValue, diagnosticCode);
            }
        } else if (kind == TypeDescKind.ARRAY) {
            memberTypeDescriptor = ((ArrayTypeSymbol) memberTypeDescriptor).memberTypeDescriptor();
            validateArrayElementTypeInReturnType(ctx, node, typeStringValue, memberTypeDescriptor, diagnosticCode);
        } else {
            reportInvalidReturnType(ctx, node, typeStringValue, diagnosticCode);
        }
    }

    public static TypeDescKind retrieveEffectiveTypeDesc(TypeSymbol descriptor) {
        TypeDescKind typeDescKind = descriptor.typeKind();
        if (typeDescKind == TypeDescKind.INTERSECTION) {
            return ((IntersectionTypeSymbol) descriptor).effectiveTypeDescriptor().typeKind();
        }
        return typeDescKind;
    }

    public static boolean isAllowedReturnType(TypeDescKind kind) {
        return ALLOWED_RETURN_TYPES.stream().anyMatch(allowedKind -> kind == allowedKind);
    }

    private static void reportInvalidReturnType(SyntaxNodeAnalysisContext ctx, Node node,
                                                String returnType, FHIRDiagnosticCodes diagnosticCode) {
        FHIRCompilerPluginUtil.updateDiagnostic(ctx, node.location(), diagnosticCode, returnType);
    }
}
