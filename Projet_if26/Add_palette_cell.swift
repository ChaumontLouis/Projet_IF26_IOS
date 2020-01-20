//
//  Add_palette_cell.swift
//  Projet_if26
//
//  Created by if26-grp1 on 10/12/2019.
//  Copyright © 2019 if26-grp1. All rights reserved.
//

import UIKit

protocol AddPaletteCellDelegate {
    func colorChanged(newColor: String, index : Int)
}

class Add_palette_cell: UITableViewCell {
    
    static let reuseIdentifier = "Add_palette_cell"
    var delegate : AddPaletteCellDelegate?
    
    @IBOutlet weak var color: UIView!
    @IBOutlet weak var color_value: UITextField!
    @IBOutlet weak var color_mode: UILabel!
    @IBOutlet weak var color_value_RGB: UITextField!
    @IBOutlet weak var color_value_HSV: UITextField!
    
    var numCell:Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func hexChanged(_ sender: UITextField) {
        let color_hex = color_value.text
        let uiColor : UIColor = UIColor(hex : color_hex!)!
        color.backgroundColor = uiColor
        color_value_RGB.text = uiColor.rgb()
        color_value_HSV.text = uiColor.hsv()
        delegate?.colorChanged(newColor: color_value.text!, index: numCell)
    }
    
    @IBAction func rgbChanged(_ sender: UITextField) {
        let color_rgb = color_value_RGB.text
        let red_rgb = Float(String((color_rgb?.split(separator: " ")[2].characters.dropLast(1))!))!/255
        let gre_rgb = Float(String((color_rgb?.split(separator: " ")[5].characters.dropLast(1))!))!/255
        let blu_rgb = Float(String((color_rgb?.split(separator: " ")[8].characters.dropLast(1))!))!/255
        let alp_rgb = Float(String((color_rgb?.split(separator: " ")[11])!))!/255
        let uiColor : UIColor = UIColor(displayP3Red: CGFloat(red_rgb), green: CGFloat(gre_rgb), blue: CGFloat(blu_rgb), alpha: CGFloat(alp_rgb))
        color.backgroundColor = uiColor
        color_value_HSV.text = uiColor.hsv()
        color_value.text = uiColor.hex()
        //  color_value_HSV.text = uiColor.hsv()
        delegate?.colorChanged(newColor: color_value.text!, index: numCell)
    }
    
    @IBAction func hsvChanged(_ sender: UITextField) {
        let color_hsv = color_value_HSV.text
        let hue_hsv = Float(String((color_hsv?.split(separator: " ")[2].characters.dropLast(1))!))!/360
        let sat_hsv = Float(String((color_hsv?.split(separator: " ")[5].characters.dropLast(1))!))!/100
        let val_hsv = Float(String((color_hsv?.split(separator: " ")[8].characters.dropLast(1))!))!/100
        let alp_hsv = Float(String((color_hsv?.split(separator: " ")[11])!))!/100
        let uiColor : UIColor = UIColor(hue: CGFloat(hue_hsv), saturation: CGFloat(sat_hsv), brightness: CGFloat(val_hsv), alpha: CGFloat(alp_hsv))
        color.backgroundColor = uiColor
        color_value_RGB.text = uiColor.rgb()
        color_value.text = uiColor.hex()
        delegate?.colorChanged(newColor: color_value.text!, index: numCell)
    }
}
