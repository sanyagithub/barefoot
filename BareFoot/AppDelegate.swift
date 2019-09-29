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
        self.setLocalData(application);
        let defaults = NSUserDefaults.standardUserDefaults()
        let isPreloaded = defaults.boolForKey("isPreloaded")
        if !isPreloaded {
            preloadSchoolData()
            defaults.setBool(true, forKey: "isPreloaded")
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
                fatalError("Unresolved error \(error), \(error.userInfo)")
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

    func parseSchoolCSV (contentsOfURL: NSURL, encoding: NSStringEncoding, error: NSErrorPointer) -> [(name:String, detail:String, price: String)]? {
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(name:String, detail:String, price: String)]?
        
        if let content = String(contentsOfURL: contentsOfURL, encoding: encoding, error: error) {
            items = []
            let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.rangeOfString("\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:NSScanner = NSScanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpToString("\"", intoString: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpToString(delimiter, intoString: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value as! String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < count(textScanner.string) {
                                textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = NSScanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.componentsSeparatedByString(delimiter)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    let item = (schoolid: values[0], password: values[1])
                    items?.append(item)
                }
            }
        }
        
        return items
    }
    
    func preloadSchoolData () {
        // Retrieve data from the source file
        if let contentsOfURL = NSBundle.mainBundle().URLForResource("school", withExtension: "csv") {
            
            // Remove all the menu items before preloading
            removeSchoolData()
            
            var error:NSError?
            if let items = parseSchoolCSV(contentsOfURL, encoding: NSUTF8StringEncoding, error: &error) {
                // Preload the menu items
                if let managedObjectContext = self.managedObjectContext {
                    for item in items {
                        let schoolItem = NSEntityDescription.insertNewObjectForEntityForName("School", inManagedObjectContext: managedObjectContext) as! School
                        schoolItem.schoolid = item.schoolid
                        schoolItem.password = item.password
                        //menuItem.price = (item.price as NSString).doubleValue
                        
                        if managedObjectContext.save(&error) != true {
                            println("insert error: \(error!.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func removeSchoolData () {
        // Remove the existing items
        if let managedObjectContext = self.managedObjectContext {
            let fetchRequest = NSFetchRequest(entityName: "School")
            var e: NSError?
            let schoolItems = managedObjectContext.executeFetchRequest(fetchRequest, error: &e) as! [School]
            
            if e != nil {
                println("Failed to retrieve record: \(e!.localizedDescription)")
                
            } else {
                
                for schoolItem in schoolItems {
                    managedObjectContext.deleteObject(schoolItem)
                }
            }
        }
    }
}

