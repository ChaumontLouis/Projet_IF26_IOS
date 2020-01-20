//
//  Add_palette.swift
//  Projet_if26
//
//  Created by if26-grp1 on 10/12/2019.
//  Copyright © 2019 if26-grp1. All rights reserved.
//

import UIKit
import CoreData

class Add_palette: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tags: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var isPrivate: UISwitch!
    
    var color_cell_values = [String]() {
        didSet {
            updateView()
        }
    }
    var refresher: UIRefreshControl!
    
    func refresh(){
        print("refreshed")
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
        tableView.allowsSelection = false
        
        for _ in 0..<5{
            let str = generateColor()
            color_cell_values = color_cell_values + [str]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupView() {
        updateView()
    }

    

    @IBAction func btnColor(_ sender: Any) {
        for i in 0..<5{
            let str = generateColor()
            color_cell_values[i] = str
        }
        refresh()
    }
    
    @IBAction func valider(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPalette = NSEntityDescription.insertNewObject(forEntityName: "Palette",into: context)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateInFormat = dateFormatter.string(from: NSDate() as Date)
        
        newPalette.setValue(loggedUser, forKey: "user")
        newPalette.setValue(name.text, forKey:"nom")
        newPalette.setValue(tags.text, forKey:"tags")
        newPalette.setValue(color_cell_values[0], forKey:"color1")
        newPalette.setValue(color_cell_values[1], forKey:"color2")
        newPalette.setValue(color_cell_values[2], forKey:"color3")
        newPalette.setValue(color_cell_values[3], forKey:"color4")
        newPalette.setValue(color_cell_values[4], forKey:"color5")
        newPalette.setValue(isPrivate.isOn, forKey: "isPrivate")
        newPalette.setValue(dateInFormat, forKey: "date")
        newPalette.setValue(0, forKey: "heartCount")
        
        
        do {
            
            try context.save()
        } catch {
            print("Erreur : impossible de sauvegarder mon context")
        }
    }
    
}


extension Add_palette: UITableViewDataSource {
    
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
        cell.delegate = self
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = 150
    }
    
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

extension UIViewController {
    func hidesKeyboard() {
        let tap:UIGestureRecognizer = UITapGestureRecognizer(target:self,action:#selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    
    func rgb() -> String {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return " R : \(iRed), G : \(iGreen), B : \(iBlue), A : \(iAlpha)"
            //return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return ""
        }
    }
}

extension UIColor {
    
    func hsv() -> String {
        var fHue : CGFloat = 0
        var fSaturation : CGFloat = 0
        var fBrightness : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getHue(&fHue, saturation: &fSaturation, brightness: &fBrightness, alpha : &fAlpha) {
            let iHue = String(format: "%.0f", fHue*360)
            let iSaturation = String(format: "%.0f", fSaturation*100)
            let iBrightness = String(format: "%.0f", fBrightness*100)
            //var iAlpha =
            
            return " H : \(iHue), S : \(iSaturation), B : \(iBrightness), A : \(fAlpha)"
            //return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return ""
        }
    }
}


extension UIColor {
    func hex() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        let ret = String(format:"#%06x", rgb)+"FF"
        let retu = ret.uppercased()
        
        return retu
    }
}

extension Add_palette : AddPaletteCellDelegate {
    func colorChanged(newColor: String, index: Int) {
        color_cell_values[index] = newColor
    }
    
    
}
