//
//  Teachers+CoreDataProperties.swift
//  
//
//  Created by Sanya Khurana on 29/09/19.
//
//

import Foundation
import CoreData


extension Teachers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teachers> {
        return NSFetchRequest<Teachers>(entityName: "Teachers")
    }

    @NSManaged public var classid: String?
    @NSManaged public var teachername: String?
    @NSManaged public var teachersid: String?
    @NSManaged public var students: Students?

}
