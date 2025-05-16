import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
 

enum EnumCaseError: CustomStringConvertible, Error {
    case onlyApplicableToEnum
    
    var description: String {
        switch self {
        case .onlyApplicableToEnum: return "@CaseCheck can only be applied to an enum"
        }
    }
}

public struct EnumCasesMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
          throw EnumCaseError.onlyApplicableToEnum
        }
        var members: [DeclSyntax] = []
        for member in enumDecl.memberBlock.members {
            guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }
            
            for caseElement in caseDecl.elements {
                let caseName = caseElement.name.text
                let computedPropName = "is" + caseName.prefix(1).capitalized + caseName.dropFirst()
                
                let decl: DeclSyntax = """
                        var \(raw: computedPropName): Bool {
                            if case .\(raw: caseName) = self {
                                return true
                            }
                            return false
                        }
                        """
                
                members.append(decl)
            }
        }
        
        return members
    }
}


