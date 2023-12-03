#if canImport(SwiftCompilerPlugin)
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DataWrapperPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    DataModelMacro.self,
  ]
}
#endif
