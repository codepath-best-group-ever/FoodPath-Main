//
//  savedRecipesViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu on 12/9/21.
//

import UIKit
import Parse

class savedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var foodsTableView: UITableView!
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var savedFoods = [PFObject]()
    var savedRecipes = [PFObject]()
    var selectedFoodForNext = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodsTableView.delegate = self
        foodsTableView.dataSource = self
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            
        let foods = PFQuery(className: "getFoodFromAPI")
        foods.findObjectsInBackground(block: { (foods, error) in
            if foods != nil{
                self.savedFoods = foods!
                self.foodsTableView.reloadData()
            }
            
        })
        
        
        let recipes = PFQuery(className: "getRecipesFromAPI")
        recipes.findObjectsInBackground(block: { (recipes, error) in
            if recipes != nil{
                self.savedRecipes = recipes!
                self.recipesTableView.reloadData()
            }
            
        })
        
        }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
            
            case foodsTableView:
                return savedFoods.count
                
                
            case recipesTableView:
                return savedRecipes.count
                
            default:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView{
            
            case foodsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "savedFoodsTableViewCell") as! savedFoodsTableViewCell
            let savedFood = savedFoods[indexPath.row]
            cell.savedFoodLabel.text = savedFood["foodName"] as! String
            return cell

                
            case recipesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipesTableViewCell") as! savedRecipesTableViewCell
            let savedRecipe = savedRecipes[indexPath.row]
            cell.savedRecipeLabel.text = savedRecipe["websiteTitle"] as! String
            return cell

                
            default:
                print("error")
                return cell
                
        }
        
    }
    
    // checkmark functionality
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView{
            
            case foodsTableView:
            foodsTableView.deselectRow(at: indexPath, animated: false)
            // make checkmark appear
            let cell = foodsTableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            for row in 0..<foodsTableView.numberOfRows(inSection: indexPath.section) {
                if let cell = foodsTableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                    cell.accessoryType = row == indexPath.row ? .checkmark : .none
                }
            }
            // save the selected row's food name
            let selectedFood = savedFoods[indexPath.row]
            selectedFoodForNext = selectedFood["foodName"] as! String

                

            case recipesTableView:
            recipesTableView.deselectRow(at: indexPath, animated: false)
            // make checkmark appear
            let cell = recipesTableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            for row in 0..<recipesTableView.numberOfRows(inSection: indexPath.section) {
                if let cell = recipesTableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                    cell.accessoryType = row == indexPath.row ? .checkmark : .none
                }
            }
            
            // direct to URL when clicked on source
            let selectedSource = savedRecipes[indexPath.row]
            if let url = URL(string: selectedSource["websiteURL"] as! String){
            UIApplication.shared.open(url)
        }


            default:
                print("error")
        }
    }
    
    // prepare segue to go to recipe picker
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecipesScreen" {
            let nextDestination = segue.destination as! recipesScreenViewController

            nextDestination.food = self.selectedFoodForNext
            nextDestination.screenName = "ingredients"

        }
    }
    
    
    
    @IBAction func goToRecipeScreen(_ sender: Any) {
        performSegue(withIdentifier: "goToRecipesScreen", sender: nil)
    }
    
    
    

    
    // !!!!!!!!!!!!! ELAINE FIX THIS !!!!!!!!!!!!!!!!!!!!!!!!!!!
    // clear data from both database tables
    @IBAction func clearHistory(_ sender: Any) {
        Task.init{
            do{
                await self.clearHistory()
                self.viewDidAppear(true)
                
            }
        }
//        self.recipesTableView.reloadData()
//        self.foodsTableView.reloadData()
    }
    
    func clearHistory() async{
        let allSavedRecipes = PFQuery(className: "getRecipesFromAPI")
        allSavedRecipes.findObjectsInBackground { (objects, error) -> Void  in
            if error == nil{
                if let everyRecipe = objects{
                    for eaRecipe in everyRecipe{
                        eaRecipe.deleteInBackground()
                    }
                }
            }
        }
        
        
        let allSavedFoods = PFQuery(className: "getFoodFromAPI")
        allSavedFoods.findObjectsInBackground { (objects, error) -> Void  in
            if error == nil{
                if let everyFood = objects{
                    for eaFood in everyFood{
                        eaFood.deleteInBackground()
                    }
                }
            }
        
        }
        
    }
  
    
}
    

