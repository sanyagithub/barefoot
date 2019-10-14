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
    var ClassId: String = ""
    var studentList: [String] = [String]()
    var studentIdList: [String] = [String]()
    var selectedStudentIdList: [String] = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
  
    @IBAction func captureAttendance(_ sender: Any) {
        
        let id = UUID()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //We need to create a context from this container
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
         
        for studentid in studentIdList{
            
            var present:Bool = false
            
            for selectedStudent in selectedStudentIdList{
                if selectedStudent == studentid {
                    present = true
                }
            }
        
            let entity = NSEntityDescription.entity(forEntityName: "StudentPresence", in:  context)
            let attendanceItem = NSManagedObject(entity: entity!, insertInto: context)
            attendanceItem.setValue(studentid, forKey: "studentId")
            attendanceItem.setValue(present, forKey: "studentPresence")
            attendanceItem.setValue(id.uuidString, forKey: "attendaceid")
    
              
            do{
                try context.save()
            }catch _ as NSError{
                print("Could Not Save School Context")
            }
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "TakePhoto") as! TakePhoto
        loggedInViewController.attendanceId = id.uuidString
        loggedInViewController.studentsPresent = selectedStudentIdList.count
        loggedInViewController.classid = ClassId
        self.present(loggedInViewController, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect data:
  
        self.tableView.delegate = self
        self.tableView.dataSource = self
         
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        let classId = getClassId(appDelegate: appDelegate!)
        ClassId = classId
              //We need to create a context from this container
        let managedContext = appDelegate?.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
        request.returnsObjectsAsFaults = false
              
        do {
            let result = try managedContext?.fetch(request)
            for data in result as! [NSManagedObject] {
                let classid = data.value(forKey: "classid") as! String
                if(classId == "\(classid)"){
                    let studentsid = data.value(forKey: "studentid") as! String
                    self.studentIdList.append(studentsid)
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
    
//    private func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
//            cell.accessoryType = .none
//        }
//    }
//    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
//            cell.accessoryType = .checkmark
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                selectedStudentIdList.remove(at: indexPath.row)
            }
            else{
                cell.accessoryType = .checkmark
                selectedStudentIdList.append(studentIdList[indexPath.row])
            }
        }
        
    }
    
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //numer of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }


}

