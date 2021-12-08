//
//  FoodPickerViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu on 11/28/21.
//

import UIKit
import Parse

class FoodPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    // back button
    @IBAction func unwindFromRecipeScreen(_ unwindSegue: UIStoryboardSegue) {}

    
    @IBOutlet weak var selectedIngredientsLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var possibleFoods: [String] = []
    var foodSuggestions = [[String:Any]]()
    var selectedRecipe: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Make sure something was checked
        let checked = PFQuery(className: "chooseIngredients")
        checked.whereKey("isChecked", equalTo: true)
        checked.getFirstObjectInBackground { object, error in
            if error != nil {
                self.statusLabel.text = "Please Select Ingredients or Take a Picture!"
                return
            }
            else{
                var text: String = ""
                let checked = PFQuery(className: "chooseIngredients")
                checked.whereKey("isChecked", equalTo: true)
                checked.findObjectsInBackground { objects, error in
                    if error == nil{
                        if let checkedIngredients = objects{
                            for everyTrue in checkedIngredients{
                                text.append(everyTrue["ingredientName"] as! String)
                                text.append("\n")
                            }
                        }
                        self.selectedIngredientsLabel.text = text
                    }
                    
                    
                }
            }
         }
       }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        super.viewDidAppear(animated)
        
        Task.init{
            do{
                await self.callSearchAPI()
            }
        }
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleFoods.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeOptionCell") as! RecipeOptionCell

         cell.recipeChoiceLabel.text = possibleFoods[indexPath.row]
         
         return cell
     
     }

    // Set up URL Query and call search API
    func callSearchAPI() async{
        let checkedIngredients = PFQuery(className: "chooseIngredients")
        var userChecked: [String] = []
        var searchTerm: String = ""

        // Retrieve checked ingredients from database
        checkedIngredients.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil{
                if let returnedObjects = objects{
                    for object in returnedObjects{
                        if (object["isChecked"] as! NSNumber).boolValue{
                            userChecked.append(object["ingredientName"] as! String)
                        }
                    }
                }
                for (index, checkedItem) in userChecked.enumerated(){
                    searchTerm.append(checkedItem)
                    if index < userChecked.count-1{
                        searchTerm.append("+")
                    }
                }
                
                
                //Set up URL Query to call search API
                var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "api.edamam.com"
                urlComponents.path = "/api/food-database/v2/parser"
                urlComponents.queryItems = [
                    URLQueryItem(name: "app_id", value: "ab02af7d"),
                    URLQueryItem(name: "app_key", value: "ba7d7b8364a7f7423abee89375a84d4a"),
                    URLQueryItem(name: "ingr", value: searchTerm)
                ]
                guard let someString = urlComponents.url?.absoluteString else { return  }
            
                let url = URL(string: someString)!
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                     if let error = error {
                            print(error.localizedDescription)
                     } else if let data = data {
                            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
                         let foodDictionary = dataDictionary["hints"] as! [[String:Any]]
                         for item in foodDictionary{
                             let returnedFoods = item["food"] as! [String:Any]
                             for (key, value) in returnedFoods{
                                 if key == "label"{
                                     let possibleRecipe = value as! String
                                     self.possibleFoods.append(possibleRecipe)
                                     self.statusLabel.text = "Here Are Some Suggested Food Dishes:"
                                 }
                             }

                         }
                    }
                         self.tableView.reloadData()
                }
                task.resume()
             
            }
            else{
                print("Error: Empty object")

            }
            
        }
    }

    
    // View was closed, delete table data
    override func viewDidDisappear(_ animated: Bool) {
        clearData()
    }
    
  
    // Resets checked ingredients and clear table
    func clearData(){
        let currentChecked = PFQuery(className: "chooseIngredients")
        currentChecked.whereKey("isChecked", equalTo: true )
        currentChecked.findObjectsInBackground { (objects, error) -> Void in
            if error == nil{
                if let checkedIngredients = objects{
                    for everyTrue in checkedIngredients{
                        everyTrue["isChecked"] = false
                        everyTrue.saveInBackground()
                    }
                }
            }
        }
        
//        let foodRecipes = PFQuery(className: "getFoodFromAPI")
//        foodRecipes.findObjectsInBackground { (objects, error) -> Void  in
//            if error == nil{
//                if let everyRecipe = objects{
//                    for eaRecipe in everyRecipe{
//                        eaRecipe.deleteInBackground()
//                    }
//                }
//            }
//        }
        self.tableView.reloadData()
    }
    
    
    
    // enable user to check recipe
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)
        
        selectedRecipe = possibleFoods[indexPath.row]
        print("Checkmark: \(selectedRecipe)")
        // make checkmark appear
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
    }
    
    // handle segueways
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecipeScreen" {
            let nextDestination = segue.destination as! recipesScreenViewController

            nextDestination.food = selectedRecipe
            nextDestination.screenName = "ingredients"
            
        } else if segue.identifier == "backToStream"{
            clearData()
        }
    }
    
    @IBAction func goToRecipeScreenButton(_ sender: Any) {
        if selectedRecipe.isEmpty == false{
            print("\(selectedRecipe)")
            performSegue(withIdentifier: "goToRecipeScreen", sender: nil)
        }
    }

    
}
