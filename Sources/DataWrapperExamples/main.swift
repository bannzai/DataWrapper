import Foundation
import SwiftData
import CoreData
import DataWrapper

@DataModel
struct Schedule  {
  let id: String
  let name: String
}


let schedule = ScheduleData.init(entity: .init(id: "", name: ""))
let entity = ScheduleData.Entity(id: "", name: "")

schedule.name
