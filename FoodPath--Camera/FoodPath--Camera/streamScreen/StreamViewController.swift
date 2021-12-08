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
    
    var selectedIngredientCount = 0
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // back button
    @IBAction func unwindToStream(_ unwindSegue: UIStoryboardSegue) {}
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
        return ingredidents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell") as! IngredientsCell
        
        let ingredient = ingredidents[indexPath.row]
        cell.ingredientNameLabel.text = ingredient["ingredientName"] as! String
        
        return cell
        
    }
    
    

    // store checked ingredients in database when checked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)

        // make checkmark appear
        let cell = tableView.cellForRow(at: indexPath) as! IngredientsCell
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                    if cell.accessoryType == .checkmark {
                        cell.accessoryType = .none
                    } else {
                        cell.accessoryType = .checkmark
                    }
                }
    
        // ingredient is checked, change value to true
        if cell.accessoryType == .checkmark{
            self.selectedIngredientCount += 1
            let ingredientCheck = PFQuery(className: "chooseIngredients")
            ingredientCheck.whereKey("ingredientName", equalTo: cell.ingredientNameLabel.text)
            ingredientCheck.getFirstObjectInBackground { object, error in
                if error == nil {
                        if let ingredent = object {
                            ingredent["isChecked"] = true
                            ingredent.saveInBackground()
                            print("Ingredient saved!")
                        }
                    }
                }
        }
        // ingredient unchecked, make false
        else if cell.accessoryType == .none{
            self.selectedIngredientCount -= 1
            let ingredientCheck = PFQuery(className: "chooseIngredients")
            ingredientCheck.whereKey("ingredientName", equalTo: cell.ingredientNameLabel.text)
            ingredientCheck.getFirstObjectInBackground { object, error in
                if error == nil {
                        if let ingredent = object {
                            ingredent["isChecked"] = false
                            ingredent.saveInBackground()
                            print("Ingredient unsaved!")
                        }
                    }
                }
        }
    }


    
    @IBAction func goToFoodPickerButton(_ sender: Any) {
        if selectedIngredientCount > 0{
            performSegue(withIdentifier: "goToFoodPicker", sender: nil)
        }
    }
    
    
    // use camera / gallery instead
    @IBAction func didPressButton(_ sender: Any) {
        performSegue(withIdentifier: "goToImageRecogScreen", sender: nil)
    }
}



