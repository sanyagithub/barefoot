//
//  Activities+CoreDataProperties.swift
//  
//
//  Created by Sanya Khurana on 29/09/19.
//
//

import Foundation
import CoreData


extension Activities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activities> {
        return NSFetchRequest<Activities>(entityName: "Activities")
    }

    @NSManaged public var activityid: UUID?
    @NSManaged public var attendanceid: UUID?
    @NSManaged public var classid: UUID?
    @NSManaged public var desc: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var attendance: AttendanceTable?

}
