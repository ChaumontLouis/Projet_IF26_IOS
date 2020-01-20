//
//  LoginControllerViewController.swift
//  Projet_if26
//
//  Created by CHAUMONT LOUIS on 13/12/2019.
//  Copyright © 2019 if26-grp1. All rights reserved.
//

import UIKit
import CoreData

var loggedUser = ""

class LoginControllerViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    private let persistentContainer = NSPersistentContainer(name: "Projet_if26")
    var users = [Users]()

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesKeyboard()
        navigationController?.navigationBar.isHidden = true
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                    self.users = (self.fetchedResultsController.fetchedObjects as! [Users]?)!
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Users> = {
        let fetchRequest = NSFetchRequest<Users> (entityName : "Users")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(_ sender: Any) {
        for user in users {
            if (password.text == user.password) && (userName.text==user.username) {
                loggedUser = user.username!
                navigationController?.navigationBar.isHidden = false
                performSegue(withIdentifier: "retourVP", sender: self)
            }
        }
    }
}
