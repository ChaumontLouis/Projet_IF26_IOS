//
//  ViewController.swift
//  Projet_if26
//
//  Created by if26-grp1 on 10/12/2019.
//  Copyright © 2019 if26-grp1. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    var menuIsHidden = true;
    @IBOutlet weak var menuView: UIView!
    var paletteToEdit : Palette?
    private let persistentContainer = NSPersistentContainer(name: "Projet_if26")
    @IBOutlet weak var tableView: UITableView!
    
    var palettes = [Palette](){
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        var hasPalette = palettes.count > 0
        
        if let palettes = fetchedResultsController.fetchedObjects {
            hasPalette = palettes.count > 0
        }
        
        tableView.isHidden = !hasPalette
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self.setupView()
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
            }
        }
        menuView.isHidden = true
    }
    
    private func setupView() {
        updateView()
    }

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Palette> = {
        let fetchRequest = NSFetchRequest<Palette> (entityName : "Palette")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "user == %@", loggedUser)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    @IBAction func toggleMenu(_ sender: UIBarButtonItem) {
        menuIsHidden = !menuIsHidden
        menuView.isHidden = menuIsHidden
    }
    
    @IBAction func MesPalettes(_ sender: Any) {
        menuIsHidden = !menuIsHidden
        menuView.isHidden = menuIsHidden
    }
    @IBAction func PublicPalettes(_ sender: Any) {
        menuIsHidden = !menuIsHidden
        menuView.isHidden = menuIsHidden
    }
    
    
    func loadSavedData(){
        
        let paletteRequest : NSFetchRequest<Palette> = Palette.fetchRequest()
        do{
            palettes = try self.persistentContainer.viewContext.fetch(paletteRequest)
            self.tableView.reloadData()
        }catch{
            print("Impossible de recharger les données")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if (segue.identifier == "EditSegue") {
        let receiver = segue.destination as! EditPalette
        receiver.palette = paletteToEdit
        }
        if (segue.identifier == "ViewPalette") {
            let receiver = segue.destination as! ViewPalette
            receiver.palette = paletteToEdit
        }
    }
    
    
}

extension ViewController : PaletteCellDelegate {
    func didTapEdit(paletteName : String){
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Palette")
        fetchRequest.predicate = NSPredicate(format: "nom == %@ AND user ==%@",argumentArray : [paletteName, loggedUser])
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [Palette]
        paletteToEdit = resultData[0]
        performSegue(withIdentifier: "EditSegue", sender: self)
    }

    func didTapDelete(paletteName : String) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Palette")
        fetchRequest.predicate = NSPredicate(format: "nom == %@ AND user ==%@",argumentArray : [paletteName, loggedUser])
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [Palette]
        for object in resultData {
            context.delete(object)
        }
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        loadSavedData()
    }
    
    func viewPalette(paletteName : String) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Palette")
        fetchRequest.predicate = NSPredicate(format: "nom == %@", paletteName)
        
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [Palette]
        paletteToEdit = resultData[0]
        performSegue(withIdentifier: "ViewPalette", sender: self)
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let palettes = fetchedResultsController.fetchedObjects else { return 0 }
        let result = palettes.filter{ $0.nom != nil }
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Palette_cell", for: indexPath) as? Palette_Cell else {
            fatalError("Unexpected Index Path")
        }
        let palettes = fetchedResultsController.fetchedObjects
        let result = palettes!.filter{ $0.nom != nil }
        
        let palette = result[indexPath.row]
        // Fetch Palette
        //let palette = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.nom.text = palette.nom
        cell.date.text = palette.date
        cell.tags.text = palette.tags
        cell.heartCount.text = String(palette.heartCount)
        cell.isPrivate.isOn = palette.isPrivate
        cell.vcolor1.backgroundColor = UIColor(hex: palette.color1!)
        cell.vcolor2.backgroundColor = UIColor(hex: palette.color2!)
        cell.vcolor3.backgroundColor = UIColor(hex: palette.color3!)
        cell.vcolor4.backgroundColor = UIColor(hex: palette.color4!)
        cell.vcolor5.backgroundColor = UIColor(hex: palette.color5!)
        cell.delegate = self
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = 250
    }
    
}




