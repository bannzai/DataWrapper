import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct DataModelMacro: MemberMacro {
  public static func expansion<Declaration, Context>(
    of node: AttributeSyntax,
    providingMembersOf declaration: Declaration,
    in context: Context
  ) throws -> [DeclSyntax] where Declaration : DeclGroupSyntax, Context : MacroExpansionContext {
    switch declaration.kind {
    case .classDecl:
      guard var declaration = declaration.as(ClassDeclSyntax.self) else {
        fatalError("Unexpected cast fail when kind == .classDecl")
      }

      let _access = declaration.modifiers.first(where: \.isNeededAccessLevelModifier)
      let access: String
      if let _access {
        access = "\(_access)"
      } else {
        access = ""
      }

      var attributes = declaration.attributes
      let contains = attributes.contains(where: { attr in
        guard case .attribute(let attribute) = attr else {
          return false
        }
        if attribute.attributeName.trimmedDescription == "@dynamicMemberLookup" {
          return true
        }
        return false
      })
      if !contains {
        attributes.append(.init(.init(stringLiteral: "@dynamicMemberLookup")))
      }
      declaration.attributes = attributes
      let member = MemberBlockItemListSyntax {
"""
      var json: String

      init(entity: Entity) {
        json = String(data: try! JSONEncoder().encode(entity), encoding: .utf8)!
      }

      @Transient var _entity: Entity?
      var entity: Entity {
      get {
        if _entity == nil {
          _entity = try! JSONDecoder().decode(Entity.self, from: json.data(using: .utf8)!)
        }
        return _entity!
      }
      set {
        _entity = newValue
          json = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
        }
      }

      \(raw: access)subscript<T>(dynamicMember keyPath: WritableKeyPath<Entity, T>) -> T {
        get { entity[keyPath: keyPath] }
        set { entity[keyPath: keyPath] = newValue }
      }

      \(raw: access)subscript<T>(dynamicMember keyPath: KeyPath<Entity, T>) -> T {
        entity[keyPath: keyPath]
      }
      """
      }
      declaration.memberBlock.members.append(contentsOf: member)

      return [declaration.cast(DeclSyntax.self)]
    case _:
      throw CustomError.message("@DataModel can only be applied to a struct or class declarations.")
    }
  }
}
