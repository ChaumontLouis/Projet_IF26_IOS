//
//  ViewPalette.swift
//  Projet_if26
//
//  Created by CHAUMONT LOUIS on 17/01/2020.
//  Copyright © 2020 if26-grp1. All rights reserved.
//

import UIKit

class ViewPalette: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tags: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var isPrivate: UISwitch!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var heartCount: UILabel!
    
    let cellSpacingHeight: CGFloat = 0
    
    var palette : Palette?
    
    var color_cell_values = [String]() {
        didSet {
            updateView()
        }
    }
    var refresher: UIRefreshControl!
    
    func refresh(){
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    private func generateColor()-> String{
        let baseInt = Int(arc4random() % 11390625)
        var str = String(format: "%06X", baseInt)
        str += "FF"
        str = "#" + str
        return str
    }
    
    private func updateView() {
        let hasColor = color_cell_values.count > 0
        
        tableView.isHidden = !hasColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesKeyboard()
        setupView()
        
        name.text = palette?.nom
        date.text = palette?.date
        heartCount.text = "\(palette?.heartCount ?? 0)"
        tags.text = palette?.tags
        isPrivate.isOn = (palette?.isPrivate)!
        color_cell_values.append((palette?.color1)!)
        color_cell_values.append((palette?.color2)!)
        color_cell_values.append((palette?.color3)!)
        color_cell_values.append((palette?.color4)!)
        color_cell_values.append((palette?.color5)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupView() {
        updateView()
    }
}

extension ViewPalette: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return color_cell_values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Add_palette_cell.reuseIdentifier, for: indexPath) as? Add_palette_cell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Quote
        let color = color_cell_values[indexPath.row]
        
        // Configure Cell
        cell.color_value.text = color
        let uiColor : UIColor = UIColor(hex : color)!
        cell.color.backgroundColor = uiColor
        cell.color_value_RGB.text = uiColor.rgb()
        cell.color_value_HSV.text = uiColor.hsv()
        cell.numCell = indexPath.row
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 125
        tableView.rowHeight = 125
    }
    
}
