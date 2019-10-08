//
//  PrepareLesson.swift
//  BareFoot
//
//  Created by Sanya Khurana on 28/08/19.
//  Copyright © 2019 Sanya Khurana. All rights reserved.
//

import UIKit
import CoreData

class PrepareLesson: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var imagePicker: UIImagePickerController!
    var selectedTeacher: String!
    var date :NSDate?
    var teacherid:String!

    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var createLesson: UIButton!
    
    @IBAction func createLessonAction(_ sender: Any) {
        date = datePicker.date as NSDate
        let id = UUID()
        guard let imageData = UIImageJPEGRepresentation(imageView.image!, 1) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //We need to create a context from this container
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        
        let entity = NSEntityDescription.entity(forEntityName: "LessonPlan", in:  context)
        let lessonPlanItem = NSManagedObject(entity: entity!, insertInto: context)
        lessonPlanItem.setValue(date, forKey: "date")
        lessonPlanItem.setValue(imageData, forKey: "image")
        
        lessonPlanItem.setValue(id.uuidString, forKey: "lessonplanid")
        lessonPlanItem.setValue(teacherid, forKey: "teacherid")
        
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
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var selectTeacher: UIPickerView!
    var pickerData: [String] = [String]()
    var pickerDataId: [String] = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Connect data:
        self.selectTeacher.delegate = self
        self.selectTeacher.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        //We need to create a context from this container
        let managedContext = appDelegate?.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Teachers")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext?.fetch(request)
            for data in result as! [NSManagedObject] {
                let teachersname = data.value(forKey: "teachername") as! String
                let teachersid = data.value(forKey: "teachersid") as! String
                self.pickerData.append(teachersname)
                self.pickerDataId.append(teachersid)
            }
            
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
      
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selectedTeacher = pickerData[pickerView.selectedRow(inComponent: component)]
        teacherid = pickerDataId[pickerView.selectedRow(inComponent: component)]
        
      
    }
    

}
