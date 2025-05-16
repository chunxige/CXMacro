// The Swift Programming Language
// https://docs.swift.org/swift-book
  
@attached(member, names: arbitrary)
public macro CaseCheck() = #externalMacro(module: "CXMacroMacros", type: "EnumCasesMacro")

@attached(accessor, names: arbitrary)
public macro UserDefault(key: String, defaultValue: Any) = #externalMacro(module: "CXMacroMacros", type: "UserDefaultMacro")

