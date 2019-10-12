//
//  Dashboard.swift
//  BareFoot
//
//  Created by Sanya Khurana on 27/08/19.
//  Copyright © 2019 Sanya Khurana. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class Dashboard: UIViewController {
    

    var TeacherId:String = ""
    
    @IBOutlet weak var TeacherName: UILabel!
    
    @IBOutlet weak var Logout: UIButton!
    
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Day: UILabel!
    

    @IBAction func loadAttendance(_ sender: Any) {
        
        loadAttendance()
    }
    
    @IBAction func loadPrepareLessons(_ sender: Any) {
        
        loadPrepareLessons()
    }
    
    
    @IBAction func loadActivityCapture(_ sender: Any) {
        
        loadActivity()
    }
    
    @IBAction func syncNow(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "BluetoothViewController") as! BluetoothViewController
        self.present(loggedInViewController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TeacherName?.text = getTeacherName(TeacherId: TeacherId)
        let date = NSDate()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date as Date)
        Date.text = result
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "EEEE"
        let result2 = formatter2.string(from: date as Date)
        Day.text = result2
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTeacherName(TeacherId: String) -> String {
        var teachersname = ""
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Teachers")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let teacherid = data.value(forKey: "teachersid") as! String
                if(TeacherId == "\(teacherid)"){
                    teachersname = data.value(forKey: "teachername") as! String
                    break
                } else {
                    teachersname = "No Teacher of with ID"
                }
            }
            
        } catch {
            
            teachersname = "No Teacher of with ID"
        }
        
        return teachersname
        
    }
    

    
    func loadPrepareLessons(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "PrepareLesson") as! PrepareLesson
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    
    func loadAttendance(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "Attendance") as! Attendance
        loggedInViewController.teacherid = TeacherId
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    
    func loadActivity(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "Activity") as! Activity
        self.present(loggedInViewController, animated: true, completion: nil)
    }
}



