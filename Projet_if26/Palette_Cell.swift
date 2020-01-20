//
//  Palette_Cell.swift
//  Projet_if26
//
//  Created by if26-grp1 on 12/12/2019.
//  Copyright © 2019 if26-grp1. All rights reserved.
//

import UIKit
import CoreData

protocol PaletteCellDelegate {
    func didTapEdit(paletteName: String)
    func didTapDelete(paletteName : String)
    func viewPalette(paletteName : String)
}

class Palette_Cell: UITableViewCell, NSFetchedResultsControllerDelegate {
    
    var delegate : PaletteCellDelegate?

    static let reuseIdentifier = "Palette_cell"
    private let persistentContainer = NSPersistentContainer(name: "Projet_if26")
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var heartCount: UILabel!
    @IBOutlet weak var isPrivate: UISwitch!
    @IBOutlet weak var vcolor1: UIView!
    @IBOutlet weak var vcolor2: UIView!
    @IBOutlet weak var vcolor3: UIView!
    @IBOutlet weak var vcolor4: UIView!
    @IBOutlet weak var vcolor5: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    @IBAction func deletePalette(_ sender: Any) {
        delegate?.didTapDelete(paletteName: nom.text!)
    }
    
    @IBAction func editButton(_ sender: Any) {
        delegate?.didTapEdit(paletteName: nom.text!)
    }
    
    @IBAction func viewPalette(_ sender: Any) {
        delegate?.viewPalette(paletteName: nom.text!)
    }
    
    
    
}
