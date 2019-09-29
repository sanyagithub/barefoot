//
//  LessonPlan+CoreDataProperties.swift
//  
//
//  Created by Sanya Khurana on 29/09/19.
//
//

import Foundation
import CoreData


extension LessonPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LessonPlan> {
        return NSFetchRequest<LessonPlan>(entityName: "LessonPlan")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var lessonplanid: UUID?
    @NSManaged public var teacherid: UUID?
    @NSManaged public var teacher: Teachers?

}
