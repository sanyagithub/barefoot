//
//  Students+CoreDataProperties.swift
//  
//
//  Created by Sanya Khurana on 29/09/19.
//
//

import Foundation
import CoreData


extension Students {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Students> {
        return NSFetchRequest<Students>(entityName: "Students")
    }

    @NSManaged public var classid: UUID?
    @NSManaged public var studentid: UUID?
    @NSManaged public var studentname: String?

}
