//
//  savedRecipesViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu on 12/9/21.
//

import UIKit
import Parse

class savedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    var savedRecipes = [PFObject]()
    
    // back button
    @IBAction func unwindFromRecipeScreen(_ unwindSegue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let recipes = PFQuery(className: "getRecipesFromAPI")
        recipes.findObjectsInBackground(block: { (recipes, error) in
            if recipes != nil{
                self.savedRecipes = recipes!
                self.recipesTableView.reloadData()
            }
            
        })
        
        }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return savedRecipes.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipesTableViewCell") as! savedRecipesTableViewCell
        let savedRecipe = savedRecipes[indexPath.row]
        cell.savedRecipeLabel.text = savedRecipe["websiteTitle"] as! String
        return cell
        
    }
    
    // checkmark functionality
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
    }


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

    }
  
    
}
    


