//
//  AppDelegate.swift
//  BareFoot
//
//  Created by Sanya Khurana on 27/08/19.
//  Copyright © 2019 Sanya Khurana. All rights reserved.
//

import UIKit
import CoreData
import Firebase







@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //self.setLocalData(application);
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            preloadSchoolData(application)
            preloadStudentsData(application)
            preloadTeacherData(application)
            defaults.set(true, forKey: "isPreloaded")
        }
        FirebaseApp.configure()
        return true
    }
    
    func setLocalData(_ application: UIApplication){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "School", in: context)
        let newSchool = NSManagedObject(entity: entity!, insertInto: context)
        newSchool.setValue("ABCSchool", forKey: "schoolid")
        newSchool.setValue("1234", forKey: "password")
        let teacher = NSEntityDescription.entity(forEntityName: "Teachers", in: context)
        let newTeacher = NSManagedObject(entity: teacher!, insertInto: context)
        newTeacher.setValue("1234", forKey: "teachersid")
        newTeacher.setValue("Anand Kumar", forKey: "teachername")
        newTeacher.setValue("1B", forKey: "classid")
        do{
            try context.save()
        } catch _ as NSError{
            print("Could Not Save Context")
        }

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BareFoot")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func parseSchoolCSV (contentsOfURL: String, encoding: String.Encoding, error: NSErrorPointer) -> [(schoolid:String, password:String)]? {
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(schoolid:String, password:String)]?
        
        do{
            let content = try String(contentsOfFile: contentsOfURL, encoding: encoding)
            items = []
            let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of: "\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpTo("\"", into: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpTo(delimiter, into: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value! as String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.count {
                                textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.components(separatedBy: delimiter)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    let item = (schoolid: values[0], password: values[1])
                    items?.append(item)
                }
            }
        
        } catch _ as NSError {
                print("could not parse csv file")
            }
        
        return items
    }
    
    func parseTeachersCSV (contentsOfURL: String, encoding: String.Encoding, error: NSErrorPointer) -> [(classid:String, teachersid:String, teachername: String)]? {
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(classid:String, teachersid:String, teachername: String)]?
        
        do{
            let content = try String(contentsOfFile: contentsOfURL, encoding: encoding)
            items = []
            let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of: "\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpTo("\"", into: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpTo(delimiter, into: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value! as String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.count {
                                textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.components(separatedBy: delimiter)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    let item = (classid: values[0], teachersid: values[1], teachername: values[2])
                    items?.append(item)
                }
            }
            
        } catch _ as NSError {
            print("could not parse csv file")
        }
        
        return items
     
        
    }
    
    func parseStudentsCSV (contentsOfURL: String, encoding: String.Encoding, error: NSErrorPointer) -> [(classid:String, studentid:String, studentname: String)]? {
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(classid:String, studentid:String, studentname: String)]?
        
        do {
            let content = try String(contentsOfFile: contentsOfURL, encoding: encoding)
            items = []
            let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of:"\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpTo("\"", into: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpTo(delimiter, into: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value! as String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.count {
                                textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.components(separatedBy:delimiter)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    let item = (classid: values[0], studentid: values[1], studentname: values[2])
                    items?.append(item)
                }
            }
            
        } catch _ as NSError{
            print("could not parse csv")
        }
        
      return items
    }
    
    func removeSchoolData () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        // Remove the existing items
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "School")
       
        do{
            let result = try managedObjectContext.fetch(fetchRequest)
            let schoolItems = result as! [NSManagedObject]
            for schoolItem in schoolItems {
                    managedObjectContext.delete(schoolItem)
            }
                
            } catch {
                
                print("Could Not Get School Context")
                
            }
        
    }
    
    func preloadSchoolData (_ application: UIApplication) {
       // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = persistentContainer.viewContext
        // Retrieve data from the source file
        if let contentsOfURL = Bundle.main.path(forResource: "school", ofType: "csv") {
            
            // Remove all the menu items before preloading
            removeSchoolData()
            
            var error:NSError?
            if let items = parseSchoolCSV(contentsOfURL: contentsOfURL, encoding: String.Encoding.utf8, error: &error) {
                // Preload the menu items
                
                for item in items {
                    let entity = NSEntityDescription.entity(forEntityName: "School", in:  managedObjectContext)
                    let schoolItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                    schoolItem.setValue(item.schoolid, forKey: "schoolid")
                    schoolItem.setValue(item.password, forKey: "password")
                    
                    //menuItem.price = (item.price as NSString).doubleValue
                    do{
                        try managedObjectContext.save()
                    }catch _ as NSError{
                        print("Could Not Save School Context")
                    }
                }
                
            }
        }
    }
    
    
    func removeTeacherData () {
        // Remove the existing items
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Teachers")
        do{
            let result = try managedObjectContext.fetch(fetchRequest)
            let teacherItems = result as! [NSManagedObject]
            for teacherItem in teacherItems {
                    managedObjectContext.delete(teacherItem)
                }
            
        } catch {
            
            print("Could Not Get Student Context")
            
        }
        
    }
    
    func preloadTeacherData (_ application: UIApplication) {
      //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = persistentContainer.viewContext
        // Retrieve data from the source file
        if let contentsOfURL = Bundle.main.path(forResource: "teachers", ofType: "csv") {
            
            // Remove all the menu items before preloading
            removeTeacherData()
            
            var error:NSError?
            if let items = parseTeachersCSV(contentsOfURL: contentsOfURL, encoding: String.Encoding.utf8, error: &error) {
                // Preload the menu items
                for item in items {
                    let entity = NSEntityDescription.entity(forEntityName: "Teachers", in:  managedObjectContext)
                    let teacherItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                    teacherItem.setValue(item.classid, forKey: "classid")
                    teacherItem.setValue(item.teachersid, forKey: "teachersid")
                    teacherItem.setValue(item.teachername, forKey: "teachername")
                    
                    //menuItem.price = (item.price as NSString).doubleValue
                    do{
                        try managedObjectContext.save()
                    }catch _ as NSError{
                        print("Could Not Save Teachers Context")
                    }
                }
            }
        }
    }
    

    func removeStudentsData () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        // Remove the existing items
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
        do{
            let result = try managedObjectContext.fetch(fetchRequest)
            let studentsItems = result as! [NSManagedObject]
      
            for studentsItem in studentsItems {
                managedObjectContext.delete(studentsItem)
            }
            
        } catch {
            
             print("Could Not Get Student Context")
            
        }
   
    }
    
    func preloadStudentsData (_ application: UIApplication) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        // Retrieve data from the source file
        if let contentsOfURL = Bundle.main.path(forResource: "students", ofType: "csv") {
            
            // Remove all the menu items before preloading
            removeStudentsData()
            
            var error:NSError?
            if let items = parseStudentsCSV(contentsOfURL: contentsOfURL, encoding: String.Encoding.utf8, error: &error) {
                // Preload the menu items
                    for item in items {
                        let entity = NSEntityDescription.entity(forEntityName: "Students", in:  managedObjectContext)
                        let studentItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                        studentItem.setValue(item.classid, forKey: "classid")
                        studentItem.setValue(item.studentid, forKey: "studentid")
                        studentItem.setValue(item.studentname, forKey: "studentname")
                
                        //menuItem.price = (item.price as NSString).doubleValue
                        do{
                            try managedObjectContext.save()
                        }catch _ as NSError{
                            print("Could Not Save Student Context")
                        }
                    }
                
            }
        }
    }
    

}

