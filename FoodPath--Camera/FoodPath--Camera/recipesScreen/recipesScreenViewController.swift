//
//  recipesScreenViewController.swift
//  FoodPath--Camera
//
//  Created by Elaine Chan on 12/5/21.
//


// BRAIN DUMP TO DO:
//  - change 'Look at recipes' to ' loading recipes ' when recipes not ready

import UIKit
import Parse

class recipesScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // to determine which screen the data was passed from
    var screenName: String = ""
    
    // back button
    
    @IBAction func unwindSegueBackButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromRecipeScreen", sender: self)
    }
    
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var food: String = ""
    var foodSuggestions = [[String:Any]]()
    var recipeSuggestion = [String: String]()
    var selectedRecipe: String = ""
    var selectedRecipeLink: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodLabel.text = food
        Task.init{
            do{
                await self.searchAPI()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func searchAPI() async{
        var searchTerm: String = "Recipes+for+"
        
        // add food dish to search term
        searchTerm.append(food)
        
        // set up URL Query to call search API
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "serpapi.com"
        urlComponents.path = "/search"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "api_key", value: "1e9bf17c61d9a8fb0143e0e681861b6249f8a07b2d8fe2a2d1ae04ce08b5e2be")
        ]
        guard let someString = urlComponents.url?.absoluteString else { return  }
        let url = URL(string: someString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 0)
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
                    for (_,foodItem) in returnedFoods.enumerated(){
                        let recipeSource = foodItem["source"] as! String
                        let recipeLink = foodItem["link"] as! String
                        self.recipeSuggestion[recipeSource] = recipeLink
                        
//                        let recipeDatabase = PFObject(className: "getRecipesFromAPI")
//                        recipeDatabase["recipeID"] = index + 1
//                        recipeDatabase["websiteTitle"] = recipeSource
//                        recipeDatabase["websiteURL"] = recipeLink
//                        recipeDatabase.saveInBackground { (success, error) in
//                            if success{
//                                print("Recipe Saved!")
//                            }
//
//                            else{
//                                print("Error: \(String(describing: error?.localizedDescription))")
//                            }
//                        }
                        
                    }
                    
                }
                else{
                    print("error")
                }
            }
            self.tableView.reloadData()
            
        }
        task.resume()
    }
    
    // TO FIX: use async functionality.
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSuggestion.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipesTableViewCell", for: indexPath) as! recipesTableViewCell
        let recipeTitles = Array(recipeSuggestion.keys)
        //print("\(recipeTitles[indexPath.row])")
        cell.recipeSourceLabel.text = recipeTitles[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)
        let recipeTitles = Array(recipeSuggestion.keys)
        selectedRecipe = recipeTitles[indexPath.row]
        selectedRecipeLink = recipeSuggestion[selectedRecipe]!
        if let url = URL(string: selectedRecipeLink){
            UIApplication.shared.open(url)
        }

        // make checkmark appear
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
