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

    @NSManaged public var activityid: String?
    @NSManaged public var attendanceid: String?
    @NSManaged public var classid: String?
    @NSManaged public var desc: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
  

}
