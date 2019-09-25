//
//  LoginScreen.swift
//  BareFoot
//
//  Created by Sanya Khurana on 27/08/19.
//  Copyright © 2019 Sanya Khurana. All rights reserved.
//

import UIKit
import Foundation
import CoreData



class LoginScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TeacherId.text = ""
        SchoolId.text = ""
        Password.text = ""
      
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var TeacherId: UITextField!
    @IBOutlet weak var SchoolId: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var ContinueButton: UIButton!
    
    @IBAction func signIn(_ sender: UIButton) {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "School")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let schoolid = data.value(forKey: "schoolid") as! String
                let password = data.value(forKey: "password") as! String
                if((SchoolId.text! == "\(schoolid)") && (Password.text! == "\(password)")){
                    self.loadDashboard()
                } else {
                    self.displayErrorMessage(message: "Invalid SchoolId/Password")
                }
            }
            
        } catch {
            
            print("Failed")
        }
      
    }
    
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func loadDashboard(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "Dashboard") as! Dashboard
        loggedInViewController.TeacherId = TeacherId.text!
        self.present(loggedInViewController, animated: true, completion: nil)
    }
}
