//
//  PublicPalette.swift
//  Projet_if26
//
//  Created by CHAUMONT LOUIS on 20/12/2019.
//  Copyright © 2019 if26-grp1. All rights reserved.
//

import UIKit
import CoreData

class PublicPalette: UIViewController, NSFetchedResultsControllerDelegate {

    private let persistentContainer = NSPersistentContainer(name: "Projet_if26")
    @IBOutlet weak var tableView: UITableView!
    var paletteToEdit : Palette?
    
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
    }
    
    private func setupView() {
        updateView()
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Palette> = {
        let fetchRequest = NSFetchRequest<Palette> (entityName : "Palette")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "isPrivate == %@", "false")
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if (segue.identifier == "ViewPalette") {
            let receiver = segue.destination as! ViewPalette
            receiver.palette = paletteToEdit
        }
    }
}

extension PublicPalette : PaletteCellDelegate {
    func didTapEdit(paletteName : String){
        
    }
    
    func didTapDelete(paletteName : String) {
        
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

extension PublicPalette: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let palettes = fetchedResultsController.fetchedObjects else { return 0 }
        return palettes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Palette_cell", for: indexPath) as? Palette_Cell else {
            fatalError("Unexpected Index Path")
        }
        
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let commit = palettes[indexPath.row]
                persistentContainer.viewContext.delete(commit)
                palettes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                do {
                    try persistentContainer.viewContext.save()
                } catch {
                    
                }
            }
        }
        
        // Fetch Quote
        let palette = fetchedResultsController.object(at: indexPath)
        
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
        cell.isPrivate.isEnabled = false
        cell.delegate = self
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = 250
    }
    
}
