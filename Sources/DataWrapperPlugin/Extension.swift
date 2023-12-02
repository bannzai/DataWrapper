import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

extension DeclModifierSyntax {
  var isNeededAccessLevelModifier: Bool {
    switch self.name.tokenKind {
    case .keyword(.public): return true
    default: return false
    }
  }
}
