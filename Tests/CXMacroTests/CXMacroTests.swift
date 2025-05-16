import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CXMacroMacros)
import CXMacroMacros

let testMacros: [String: Macro.Type] = [
    "CaseCheck": EnumCasesMacro.self,
    "UserDefault": UserDefaultMacro.self
]
#endif

final class CXMacroTests: XCTestCase {
    func testEnumCases() throws {
        #if canImport(CXMacroMacros)
        assertMacroExpansion(
            """
            @CaseCheck
            enum Kind {
                case one
                case two
            }
            """,
            expandedSource: """
            enum Kind {
                case one
                case two

                var isOne: Bool {
                    if case .one = self {
                        return true
                    }
                    return false
                }

                var isTwo: Bool {
                    if case .two = self {
                        return true
                    }
                    return false
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testEnumCasesError() throws {
        #if canImport(CXMacroMacros)
        assertMacroExpansion(
            """
            @CaseCheck
            struct Kind {
            }
            """,
            expandedSource: """
            struct Kind {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "@CaseCheck can only be applied to an enum", line: 1, column: 1),
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
 
    func testUserDefault() throws {
        #if canImport(CXMacroMacros)
        assertMacroExpansion(
            """
            @UserDefault(key: "testKey", defaultValue: "cxgg")
            var testValue: String
            """,
            expandedSource: """
            var testValue: String {
                get {
                    if let value = UserDefaults.standard.object(forKey: "testKey") as? String {
                        return value
                    }
                    return "cxgg"
                }
                set {
                    UserDefaults.standard.set(newValue, forKey: "testKey")
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
