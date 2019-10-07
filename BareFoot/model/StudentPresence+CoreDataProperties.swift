//
//  StudentPresence+CoreDataProperties.swift
//  
//
//  Created by Sanya Khurana on 29/09/19.
//
//

import Foundation
import CoreData


extension StudentPresence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudentPresence> {
        return NSFetchRequest<StudentPresence>(entityName: "StudentPresence")
    }

    @NSManaged public var attendaceid: String?
    @NSManaged public var studentId: String?
    @NSManaged public var studentPresence: Bool

}
