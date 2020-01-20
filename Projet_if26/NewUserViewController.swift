//
//  NewUserViewController.swift
//  Projet_if26
//
//  Created by CHAUMONT LOUIS on 13/12/2019.
//  Copyright © 2019 if26-grp1. All rights reserved.
//

import UIKit
import CoreData

class NewUserViewController: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func signUp(_ sender: Any) {
        if (password.text == repeatPassword.text) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
        
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users",into: context)
        
            newUser.setValue(username.text, forKey: "username")
            newUser.setValue(password.text, forKey: "password")
        
            do {
                try context.save()
            } catch {
                print("Erreur : impossible de sauvegarder mon context")
            }
        }
    }
    
}
