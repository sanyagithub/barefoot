//
//  Attendance.swift
//  BareFoot
//
//  Created by Sanya Khurana on 28/08/19.
//  Copyright © 2019 Sanya Khurana. All rights reserved.
//

import UIKit
import CoreData

class Attendance: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var teacherid: String = ""
    var studentList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect data:
            //  self.selectTeacher.delegate = self
             // self.selectTeacher.dataSource = self
              
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        let classId = getClassId(appDelegate: appDelegate!)
              //We need to create a context from this container
        let managedContext = appDelegate?.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
        request.returnsObjectsAsFaults = false
              
        do {
            let result = try managedContext?.fetch(request)
            for data in result as! [NSManagedObject] {
                let classid = data.value(forKey: "classId") as! String
                if(classId == "\(classid)"){
                    let studentsname = data.value(forKey: "studentname") as! String
                    self.studentList.append(studentsname)
                }
            }
                  
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getClassId(appDelegate: AppDelegate) -> String{
        var classid:String = ""
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Teachers")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let teacherid = data.value(forKey: "teachersid") as! String
                if(teacherid == "\(teacherid)"){
                    classid = data.value(forKey: "classid") as! String
                    break
                } else {
                    classid = "No Class ID"
                }
            }
            
        } catch {
            
            classid = "No Class Id"
        }
        
        return classid
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = studentList[indexPath.row]
        return cell
    }
    
    private func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .none
        }
    }
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .checkmark

        }
    }
    
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //numer of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}

