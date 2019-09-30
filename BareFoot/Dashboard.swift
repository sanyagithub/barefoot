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
    @IBOutlet weak var SyncNow: UIButton!
    
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Day: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TeacherName?.text = getTeacherName(TeacherId: TeacherId)
        let date = NSDate()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date as Date)
        Date.text = result
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTeacherName(TeacherId: String) -> String {
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
                    return data.value(forKey: "teachername") as! String
                } else {
                    return "No Teacher of with ID"
                }
            }
            
        } catch {
            
            return "No Teacher of with ID"
        }
        
        return ""
    }
    
    @IBOutlet weak var PrepareLessons: UIView!
    
    @IBOutlet weak var Attendace: UIView!
    
    @IBOutlet weak var Activity: UIView!
    @IBOutlet weak var Records: UIView!
    
    func loadPrepareLessons(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "Dashboard") as! Dashboard
        loggedInViewController.TeacherId = TeacherId.text!
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    
    func loadAttendance(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "Dashboard") as! Dashboard
        loggedInViewController.TeacherId = TeacherId.text!
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    
    func loadActivity(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "Dashboard") as! Dashboard
        loggedInViewController.TeacherId = TeacherId.text!
        self.present(loggedInViewController, animated: true, completion: nil)
    }
}



