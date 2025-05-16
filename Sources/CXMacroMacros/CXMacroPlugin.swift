//
//  Untitled.swift
//  CXMacro
//
//  Created by chunxi on 2025/5/16.
//
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CXMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumCasesMacro.self,
        UserDefaultMacro.self
    ]
}
