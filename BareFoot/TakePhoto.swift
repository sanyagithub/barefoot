//
//  TakePhoto.swift
//  BareFoot
//
//  Created by Sanya Khurana on 28/08/19.
//  Copyright © 2019 Sanya Khurana. All rights reserved.
//

import UIKit
import CoreData


class TakePhoto: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    var attendanceId: String! = ""
    var studentsPresent: Int! = 0
    var classid: String! = ""
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func captureAttendanceData(_ sender: Any) {
        
        guard let imageData = UIImageJPEGRepresentation(imageView.image!, 1) else {
                   // handle failed conversion
                   print("jpg error")
                   return
               }
        
        let date:NSDate! = NSDate()
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //We need to create a context from this container
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        
        let entity = NSEntityDescription.entity(forEntityName: "AttendanceTable", in:  context)
        let attendanceTableItem = NSManagedObject(entity: entity!, insertInto: context)
        attendanceTableItem.setValue(date, forKey: "date")
        attendanceTableItem.setValue(imageData, forKey: "image")
        
        attendanceTableItem.setValue(attendanceId, forKey: "attendanceid")
        attendanceTableItem.setValue(classid, forKey: "classid")
        attendanceTableItem.setValue(studentsPresent, forKey: "numberOfStudents")
        
        do{
            try context.save()
        }catch _ as NSError{
            print("Could Not Save School Context")
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "Dashboard") as! Dashboard
        self.present(loggedInViewController, animated: true, completion: nil)
    
        
        
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [String : Any]) {
    imagePicker.dismiss(animated: true, completion: nil)
    imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
}


