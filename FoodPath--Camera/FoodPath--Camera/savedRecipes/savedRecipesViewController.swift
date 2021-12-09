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
    var savedFoods = [PFObject]()
    var savedRecipes = [PFObject]()
    
    
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
    


}
