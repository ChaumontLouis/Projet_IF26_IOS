import UIKit
import CoreData

class EditPalette: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tags: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var isPrivate: UISwitch!
    
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
        tableView.allowsSelection = false
        
        name.text = palette?.nom
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Palette")
        fetchRequest.predicate = NSPredicate(format: "nom == %@ AND user ==%@",argumentArray : [palette?.nom, loggedUser])
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [Palette]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateInFormat = dateFormatter.string(from: NSDate() as Date)
        
        resultData[0].setValue(name.text, forKey:"nom")
        resultData[0].setValue(tags.text, forKey:"tags")
        resultData[0].setValue(color_cell_values[0], forKey:"color1")
        resultData[0].setValue(color_cell_values[1], forKey:"color2")
        resultData[0].setValue(color_cell_values[2], forKey:"color3")
        resultData[0].setValue(color_cell_values[3], forKey:"color4")
        resultData[0].setValue(color_cell_values[4], forKey:"color5")
        resultData[0].setValue(isPrivate.isOn, forKey: "isPrivate")
        resultData[0].setValue(dateInFormat, forKey: "date")
        resultData[0].setValue(0, forKey: "heartCount")
        
        do {
            try context.save()
        } catch {
            print("Erreur : impossible de sauvegarder mon context")
        }
    }
    
}

extension EditPalette: UITableViewDataSource {
    
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


extension EditPalette : AddPaletteCellDelegate {
    func colorChanged(newColor: String, index: Int) {
        color_cell_values[index] = newColor
        
    }
}
