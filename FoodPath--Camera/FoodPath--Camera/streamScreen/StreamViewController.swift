//
//  StreamViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu on 11/20/21.
//

import UIKit
import Parse

class StreamViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var picture: UIImage!
    var ingredidents = [PFObject]()
    
    var selectedIngredients: [IndexPath] = []

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // back button
    @IBAction func unwindToStream(_ unwindSegue: UIStoryboardSegue) {
        selectedIngredients.removeAll()
    }
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "chooseIngredients")
        query.findObjectsInBackground(block: { (ingredidents, error) in
            if ingredidents != nil{
                self.ingredidents = ingredidents!
                self.tableView.reloadData()
                    
                }
        })
    }
    
    // tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(ingredidents.count)")
        return ingredidents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell") as! IngredientsCell
        
        let ingredient = ingredidents[indexPath.row]
        cell.ingredientNameLabel.text = ingredient["ingredientName"] as! String
        
        // to avoid repetitive checkmark cells
        if self.selectedIngredients.contains(indexPath){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    // handle duplicate checkmarks
    var indexNumber:NSInteger = -1
    // store checked ingredients in database when checked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)
        
        // check if ingredient has been selected
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        }
        
        if self.selectedIngredients.contains(indexPath){
            if let index = selectedIngredients.firstIndex(of: indexPath){
                selectedIngredients.remove(at: index)
            }
            let ingredientCheck = PFQuery(className: "chooseIngredients")
            ingredientCheck.whereKey("ingredientId", equalTo: indexPath.row+1)
            ingredientCheck.getFirstObjectInBackground { object, error in
                if error == nil {
                    if let ingredent = object {
                        ingredent["isChecked"] = false
                        ingredent.saveInBackground()
                        print("\(ingredent["ingredientName"]) unsaved!")
                    }
                }
            }
        }else{
            self.selectedIngredients.append(indexPath)
            let ingredientCheck = PFQuery(className: "chooseIngredients")
            ingredientCheck.whereKey("ingredientId", equalTo: indexPath.row+1)
            ingredientCheck.getFirstObjectInBackground { object, error in
                if error == nil {
                    if let ingredent = object {
                        ingredent["isChecked"] = true
                        ingredent.saveInBackground()
                        print("\(ingredent["ingredientName"]) saved!")
                    }
                }
            }
        }
    }

    
    @IBAction func goToFoodPickerButton(_ sender: Any) {
        if selectedIngredients.count > 0{
            performSegue(withIdentifier: "goToFoodPicker", sender: nil)
        }else{
            print("No ingredient was chosen!")
        }
    }
    
    
    // use camera / gallery instead
    @IBAction func didPressButton(_ sender: Any) {
        performSegue(withIdentifier: "goToImageRecogScreen", sender: nil)
    }
}



