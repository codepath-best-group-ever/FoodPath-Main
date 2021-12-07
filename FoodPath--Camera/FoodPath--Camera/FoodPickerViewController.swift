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
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var selectedIngredientsLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var possibleFoods = [PFObject]()
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
        
                self.callSearchAPI()
            }
         }
       }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "getFoodFromAPI")
        query.findObjectsInBackground(block: { (foods, error) in
            if foods != nil{
                self.possibleFoods = foods!
                self.tableView.reloadData()
            }
            
        })
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleFoods.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeOptionCell") as! RecipeOptionCell
         
         let ingredient = possibleFoods[indexPath.row]
         cell.recipeChoiceLabel.text = ingredient["foodName"] as! String
         
         return cell
     
     }
    
    
    
    // Set up URL Query and call search API
    func callSearchAPI(){
        let checkedIngredients = PFQuery(className: "chooseIngredients")
        var userChecked: [String] = []
        var searchTerm: String = "Recipes+for+"

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
                urlComponents.host = "serpapi.com"
                urlComponents.path = "/search"
                urlComponents.queryItems = [
                    URLQueryItem(name: "q", value: searchTerm),
                    URLQueryItem(name: "api_key", value: "8904e8f40f3070f69b5e5b20139add92b3d79e684d3b78a36b129d29a1f934eb")
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
            
                         self.foodSuggestions = dataDictionary["recipes_results"] as! [[String:Any]]
                         let returnedFoods = self.foodSuggestions
                         
                         
                         if(dataDictionary["recipes_results"] != nil){
                             // Add each result to database
                             for (index,foodItem) in returnedFoods.enumerated(){
                                 let foodFromAPI = PFObject(className: "getFoodFromAPI")
                                 let possibleRecipe = foodItem["title"] as! String
                                 
                                 foodFromAPI["foodName"] = possibleRecipe
                                 foodFromAPI["foodId"] = index + 1
                                 foodFromAPI.saveInBackground { (success, error) in
                                     if success{
                                         print("Recipe Saved!")
                                         self.statusLabel.text = "Here Are Some Suggested Recipes:"
                                         self.viewDidAppear(true)
                                     }
                                     
                                     else{
                                         print("Error: \(String(describing: error?.localizedDescription))")
                                     }
                                 }

                                }
                             
                         }
                         else{
                             print("No recipes found")
                         }
                    }
              
                }
                task.resume()
             
            }
            else{
                print("Error: Empty object")

            }
            
        }
    }

    
    
    // Back button pushed, go back to stream
    @IBAction func goBack(_ sender: Any) {
        clearData()
        performSegue(withIdentifier: "fromFoodPickerToStream" , sender: nil)
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
        
        let foodRecipes = PFQuery(className: "getFoodFromAPI")
        foodRecipes.findObjectsInBackground { (objects, error) -> Void  in
            if error == nil{
                if let everyRecipe = objects{
                    for eaRecipe in everyRecipe{
                        eaRecipe.deleteInBackground()
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    
    
    // enable user to check recipe
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)

        // make checkmark appear
        let cell = tableView.cellForRow(at: indexPath) as! RecipeOptionCell
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                    if cell.accessoryType == .checkmark {
                        cell.accessoryType = .none
                    } else {
                        cell.accessoryType = .checkmark
                    }
                }
        if cell.accessoryType == .checkmark{
            selectedRecipe = cell.recipeChoiceLabel.text as! String
        }
        else if cell.accessoryType == .none{
            selectedRecipe = ""
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecipeScreen" {
            let nextDestination = segue.destination as! TEMPViewController
            
            if selectedRecipe.isEmpty == false{
            nextDestination.selectedRecipe = selectedRecipe
            }
            else{
                nextDestination.selectedRecipe = "Plese go back and select a recipe"
            }
        }
    }
    
    
    @IBAction func goToRecipeScreen(_ sender: Any) {
        performSegue(withIdentifier: "goToRecipeScreen", sender: nil)
        
    }
    
    
}
