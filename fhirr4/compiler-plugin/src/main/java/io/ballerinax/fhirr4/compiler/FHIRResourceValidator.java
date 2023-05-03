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

import io.ballerina.compiler.api.symbols.FunctionSymbol;
import io.ballerina.compiler.api.symbols.FunctionTypeSymbol;
import io.ballerina.compiler.api.symbols.ParameterSymbol;
import io.ballerina.compiler.api.symbols.ResourceMethodSymbol;
import io.ballerina.compiler.api.symbols.Symbol;
import io.ballerina.compiler.api.symbols.TypeSymbol;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.ReturnTypeDescriptorNode;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.tools.diagnostics.Location;

import java.util.List;
import java.util.Optional;

import static io.ballerinax.fhirr4.compiler.FHIRCompilerPluginUtil.updateDiagnostic;

/**
 * Validates a ballerina FHIR resource.
 */
class FHIRResourceValidator {

    static void validateResource(SyntaxNodeAnalysisContext ctx, FunctionDefinitionNode member) {
        extractInputParamTypeAndValidate(ctx, member);
        extractReturnTypeAndValidate(ctx, member);
    }

    public static void extractInputParamTypeAndValidate(SyntaxNodeAnalysisContext ctx, FunctionDefinitionNode member) {

        Optional<Symbol> resourceMethodSymbolOptional = ctx.semanticModel().symbol(member);
        Location paramLocation = member.location();
        if (resourceMethodSymbolOptional.isEmpty()) {
            return;
        }
        Optional<List<ParameterSymbol>> parametersOptional =
                ((ResourceMethodSymbol) resourceMethodSymbolOptional.get()).typeDescriptor().params();
        if (parametersOptional.get().size() == 0 || parametersOptional.get().size() > 2) {
            updateDiagnostic(ctx, paramLocation, FHIRDiagnosticCodes.FHIR_104);
            return;
        }
        TypeSymbol firstParamType = parametersOptional.get().get(0).typeDescriptor();
        if (!(firstParamType.getName().get().equals(Constants.FHIR_CONTEXT)
                && firstParamType.getModule().get().getName().get().equals(Constants.HEALTHCARE_PKG))) {
            updateDiagnostic(ctx, paramLocation, FHIRDiagnosticCodes.FHIR_103,
                             firstParamType.getName().get());
            return;
        }
        if (parametersOptional.get().size() > 1) {
            TypeSymbol secondParamType = parametersOptional.get().get(1).typeDescriptor();
            if (!(secondParamType.getModule().isPresent() && secondParamType.getModule().get().getName().get().equals(
                    Constants.HEALTHCARE_PKG))) {
                updateDiagnostic(ctx, paramLocation, FHIRDiagnosticCodes.FHIR_103,
                                 secondParamType.getName().isPresent() ? secondParamType.getName().get() :
                                         "of type " + secondParamType.typeKind().getName());
                return;
            }
        }
    }

    private static void extractReturnTypeAndValidate(SyntaxNodeAnalysisContext ctx, FunctionDefinitionNode member) {
        Optional<ReturnTypeDescriptorNode> returnTypeDescriptorNode = member.functionSignature().returnTypeDesc();
        if (returnTypeDescriptorNode.isEmpty()) {
            return;
        }
        Node returnTypeNode = returnTypeDescriptorNode.get().type();
        String returnTypeStringValue = FHIRCompilerPluginUtil.getReturnTypeDescription(returnTypeDescriptorNode.get());
        Optional<Symbol> functionSymbol = ctx.semanticModel().symbol(member);
        if (functionSymbol.isEmpty()) {
            return;
        }
        FunctionTypeSymbol functionTypeSymbol = ((FunctionSymbol) functionSymbol.get()).typeDescriptor();
        Optional<TypeSymbol> returnTypeSymbol = functionTypeSymbol.returnTypeDescriptor();
        if (returnTypeSymbol.isEmpty()) {
            return;
        }
        FHIRCompilerPluginUtil.validateReturnType(ctx, returnTypeNode, returnTypeStringValue, returnTypeSymbol.get(),
                                                  FHIRDiagnosticCodes.FHIR_102, false);
    }
}
