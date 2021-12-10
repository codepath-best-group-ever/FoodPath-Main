//
//  savedFoodsViewController.swift
//  FoodPath--Camera
//
//  Created by Elaine Chan on 12/10/21.
//

import UIKit
import Parse

class savedFoodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var foodsTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var savedFoods = [PFObject]()
    var selectedFoodForNext = ""
    
    // back button
    @IBAction func unwindFromRecipeScreen(_ unwindSegue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodsTableView.delegate = self
        foodsTableView.dataSource = self

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
        
        }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedFoodsTableViewCell") as! savedFoodsTableViewCell
        let savedFood = savedFoods[indexPath.row]
        cell.savedFoodLabel.text = savedFood["foodName"] as! String
        return cell

    }
    
    // checkmark functionality
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
        if selectedFoodForNext != ""{
            performSegue(withIdentifier: "goToRecipesScreen", sender: nil)
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
    }
    
    func clearHistory() async{
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
