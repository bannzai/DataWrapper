import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct DataModelMacro: PeerMacro {
  public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
    switch declaration.kind {
    case .structDecl:
      guard let declaration = declaration.as(StructDeclSyntax.self) else {
        fatalError("Unexpected cast fail when kind == .structDecl")
      }

      let _access = declaration.modifiers.first(where: \.isNeededAccessLevelModifier)
      let access: String
      if let _access {
        access = "\(_access)"
      } else {
        access = ""
      }

      // peer' macros are not allowed to introduce arbitrary names at global scope
      let name = declaration.name.text + "Data"

      let dataDecl = ClassDeclSyntax(
        attributes: .init(itemsBuilder: {
          "@Model"
          "@dynamicMemberLookup"
        }),
        classKeyword: " class ",
        identifier: "\(raw: name)") {
      """

      \(raw: access)typealias Entity = \(raw: declaration.name.text)
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

      return ["\(raw: dataDecl)"]
    case _:
      throw CustomError.message("@DataModel can only be applied to a struct or class declarations.")
    }
  }
}
