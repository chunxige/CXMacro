//
//  Untitled.swift
//  CXMacro
//
//  Created by chunxi on 2025/5/16.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
 
public struct UserDefaultMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        // Ensure the macro is applied to a variable with a type annotation
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              binding.pattern.is(IdentifierPatternSyntax.self),
              let typeAnnotation = binding.typeAnnotation?.type
        else {
            throw MacroError.message("Macro must be applied to a variable with a type annotation")
        }

        // Extract macro arguments: key and defaultValue
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
              arguments.count == 2,
              let keyExpr = arguments.first?.expression.as(StringLiteralExprSyntax.self),
              let key = keyExpr.representedLiteralValue
        else {
            throw MacroError.message("UserDefault macro requires a string 'key' and 'defaultValue'")
        }

        let defaultValueExpr = arguments.dropFirst().first!.expression
        let type = typeAnnotation

        let getter: AccessorDeclSyntax  =
                """
                get {
                    if let value = UserDefaults.standard.object(forKey: \(literal: key)) as? \(type) {
                        return value
                    }
                    return \(defaultValueExpr)
                }
                """
 
        let setter: AccessorDeclSyntax =
            """
            set {
                UserDefaults.standard.set(newValue, forKey: \(literal: key))
            }
            """

        return [getter, setter]
    }
}

enum MacroError: Error, CustomStringConvertible {
    case message(String)
    var description: String {
        switch self {
        case .message(let text):
            return text
        }
    }
}
