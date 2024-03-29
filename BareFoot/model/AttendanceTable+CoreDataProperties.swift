//
//  AttendanceTable+CoreDataProperties.swift
//  
//
//  Created by Sanya Khurana on 29/09/19.
//
//

import Foundation
import CoreData


extension AttendanceTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttendanceTable> {
        return NSFetchRequest<AttendanceTable>(entityName: "AttendanceTable")
    }

    @NSManaged public var attendanceid: String?
    @NSManaged public var classid: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var numberOfStudents: Int16

}
