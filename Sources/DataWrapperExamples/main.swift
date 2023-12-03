import Foundation
import SwiftData
import CoreData
import DataWrapper

@DataModel
class Schedule  {
  struct Entity: Codable {
    let id: String
    let name: String
  }
}

let schedule = Schedule(entity: .init(id: "", name: ""))
let entity = Schedule.Entity(id: "", name: "")

schedule.name
